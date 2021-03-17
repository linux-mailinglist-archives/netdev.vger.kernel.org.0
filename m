Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C6B33F83B
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 19:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbhCQSiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 14:38:54 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:15735 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbhCQSiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 14:38:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616006329; x=1647542329;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=/asCof1+5nk8cUHgwkHBeAt1DWQUxlwGjbaaSGPT2zE=;
  b=P1NXCViKCTwIwIzNA7Te+4OiFIGMI9yXstgjLTQwjJWK4tuH5us8YaWd
   g8TE7oR/XD/C0V+B40UlDLJl4lCqHy3t+w+wfACcg91zebgBiZVhs/yVZ
   Di2OHw3uFjf/KjsONFexLdSEKf2uA5MknzanCwHXjc1tKqYoJnRtt2I8J
   WffRHPjakD2NHX0RvYVyAeTg100vmuCp0ezC2j9Yr3cBd2KXNIxjfb/iW
   fyjtKy02rWQtjPFoI56Haq+7hOiJy+VLyxx6juh/MzwJU1//+TVS4s4zc
   jaxeVLVHEova0+/DLygWopS38Dfl4DBCrnSYVNnYlde7SHm3Vb/WlKl6U
   w==;
IronPort-SDR: B/BhEyKz6cOsFY0ZtxQd7fBzE6DFI+ClHCDKQciMcjGXLOVsc5V3/4m7nYFun9/z/Jn6FB8ibA
 TFbXfO75SUnQgZv9BGgir4VQFz0V0PGBWhdQQYa2L5W9feoLcKOcn03uVIqvQOJFFN5MSUUpZI
 Lp6Nq0ke6Rw6Y2bazGvXc/B0MPJ3o1gzmvS92Q57HxZX+obiiudyZuqvW9CC99epjF32SSK5VH
 +6+JO/Gl+3Xfo2KEJ8UI2MbIBth+lQGxumzBkuUqgo3uqQ8ueTQ1D38IQ6STCGj0TFZuElxpK9
 6Is=
X-IronPort-AV: E=Sophos;i="5.81,257,1610434800"; 
   d="scan'208";a="47914226"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2021 11:38:47 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 17 Mar 2021 11:38:46 -0700
Received: from [10.12.89.254] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 17 Mar 2021 11:38:45 -0700
Subject: Re: [PATCH] net: macb: simplify clk_init with dev_err_probe
To:     Michael Tretter <m.tretter@pengutronix.de>,
        <netdev@vger.kernel.org>
CC:     <claudiu.beznea@microchip.com>, <davem@davemloft.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
References: <20210317161609.2104738-1-m.tretter@pengutronix.de>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <f8f4494f-3d6c-f9b3-68fe-9ae3a5f345c6@microchip.com>
Date:   Wed, 17 Mar 2021 19:38:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210317161609.2104738-1-m.tretter@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/03/2021 at 17:16, Michael Tretter wrote:
> On some platforms, e.g., the ZynqMP, devm_clk_get can return
> -EPROBE_DEFER if the clock controller, which is implemented in firmware,
> has not been probed yet.
> 
> As clk_init is only called during probe, use dev_err_probe to simplify
> the error message and hide it for -EPROBE_DEFER.
> 
> Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>

Looks good to me:
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Thanks Michael, regards,
   Nicolas

> ---
>   drivers/net/ethernet/cadence/macb_main.c | 20 +++++++++-----------
>   1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index e7c123aadf56..f56f3dbbc015 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -3758,17 +3758,15 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
>                  *hclk = devm_clk_get(&pdev->dev, "hclk");
>          }
> 
> -       if (IS_ERR_OR_NULL(*pclk)) {
> -               err = IS_ERR(*pclk) ? PTR_ERR(*pclk) : -ENODEV;
> -               dev_err(&pdev->dev, "failed to get macb_clk (%d)\n", err);
> -               return err;
> -       }
> -
> -       if (IS_ERR_OR_NULL(*hclk)) {
> -               err = IS_ERR(*hclk) ? PTR_ERR(*hclk) : -ENODEV;
> -               dev_err(&pdev->dev, "failed to get hclk (%d)\n", err);
> -               return err;
> -       }
> +       if (IS_ERR_OR_NULL(*pclk))
> +               return dev_err_probe(&pdev->dev,
> +                                    IS_ERR(*pclk) ? PTR_ERR(*pclk) : -ENODEV,
> +                                    "failed to get pclk\n");
> +
> +       if (IS_ERR_OR_NULL(*hclk))
> +               return dev_err_probe(&pdev->dev,
> +                                    IS_ERR(*hclk) ? PTR_ERR(*hclk) : -ENODEV,
> +                                    "failed to get hclk\n");
> 
>          *tx_clk = devm_clk_get_optional(&pdev->dev, "tx_clk");
>          if (IS_ERR(*tx_clk))
> --
> 2.29.2
> 


-- 
Nicolas Ferre
