defmodule Soap.Request do
  @moduledoc """
  Documentation for Soap.Request.
  """
  alias Soap.Request.Params

  require Logger

  @doc """
  Executing with parsed wsdl and headers with body map.
  Calling HTTPoison request by Map with method, url, body, headers, options keys.
  """
  @spec call(wsdl :: map(), operation :: String.t(), params :: any(), body_headers :: Params.body_header(), headers :: any()) :: any()
  def call(wsdl, operation, params, body_headers, headers \\ []) do
    url = Params.get_url(wsdl)
    headers = Params.build_headers(wsdl, operation, headers)
    body = Params.build_body(wsdl, operation, params, body_headers)

    Logger.debug fn ->
      "Calling url: #{url}\nwith headers: #{inspect headers}\nand body: #{inspect body}"
    end

    HTTPoison.post(url, body, headers, http_opts())
  end

  defp http_opts, do: Application.get_env(:soap, :http_opts) || []
end
