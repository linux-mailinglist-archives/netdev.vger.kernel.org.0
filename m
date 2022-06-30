Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F13E561FFD
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 18:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235871AbiF3QLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 12:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235499AbiF3QLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 12:11:04 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BAB20F7C;
        Thu, 30 Jun 2022 09:11:03 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id lw20so39989934ejb.4;
        Thu, 30 Jun 2022 09:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DI8QFpbUpV04tpjpn3J1wpOKvBnlP701ikBsHY36P6Y=;
        b=AEzI3XWnd+jvATdCwuZRilR//wkEjJsgxHnw5qDM/5vuoXEdkEVvEmZrB4IJTIoiuZ
         iMqtpruklD/neBsoXQwR+WRzb8vDdq7+cMQiqJB4CHcx06l85xhcI/BekqymA9nbQc2o
         auTuFs4l0G6S3xdr/zK+5N/MlBTiorJfOW5o5YXZqMG8H52sqbcKg+Ywqx+LSIyQRZVd
         6m8Ee0sTPFCGcjR6+wxodiCFusVTw1hPYI6gDWqEMH2s4c5QyzLV2qyJxObGmW6s5x4U
         COBGtl5CKm74SKB4U6IsETVDPGG2Ay8D4LUdggfD2nHqHseekLutcH/RHFVjpCdOvess
         7qbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DI8QFpbUpV04tpjpn3J1wpOKvBnlP701ikBsHY36P6Y=;
        b=zL6bEQfwN8fHG2K4MYQE0wGbFicto0n9ymx4c0+XoGJOlrBWJsidwdNMxwVu3Gv27v
         9EUxUCERYaJzkVtmtKzUpCA/gwbFeaKQ8hgtD3oCxIpaz8SgtXYqpy514Um93PlXXvcs
         KqTHy+ThWPvzlfOjfVA1UeO5uMXNjXVgnfx6lmpc4Efu46YK/A6vLRjkApPBr9hlGyex
         sXuc89hMQAwvttuXMlnPv3bQrgU06e/sdHZsz6G1/yX6x8A2+FxMkQ4iRtwaDCEibcEu
         0AFSXInDxKRsqmk+WN95+R6Y+Q1S1Vb50qbSfonnDwUP6lGroKyqw+1yGVOtpA5JS59Z
         Arhw==
X-Gm-Message-State: AJIora90EmueM02jJ6RRVrbue0BBzPe2uyLfZ6bpm+NZ/3ianFSiHL1a
        Gtl4rnjyRPs/w4Ja4X5sqAE=
X-Google-Smtp-Source: AGRyM1thY3tgD+ppr1JwQ/p3aEi07bYkmItANYp6TGwnbhPGUvGIrao6rHB56Z5h72bVebDwBShrQg==
X-Received: by 2002:a17:907:3e0e:b0:726:602b:c19b with SMTP id hp14-20020a1709073e0e00b00726602bc19bmr9891199ejc.117.1656605462223;
        Thu, 30 Jun 2022 09:11:02 -0700 (PDT)
Received: from skbuf ([188.25.231.226])
        by smtp.gmail.com with ESMTPSA id a21-20020a056402169500b004357063bf60sm13417588edv.41.2022.06.30.09.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 09:11:01 -0700 (PDT)
Date:   Thu, 30 Jun 2022 19:10:59 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: dsa: sja1105: silent spi_device_id
 warnings
Message-ID: <20220630161059.jnmladythszbh7py@skbuf>
References: <20220630071013.1710594-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630071013.1710594-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 09:10:13AM +0200, Oleksij Rempel wrote:
> Add spi_device_id entries to silent following warnings:
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105e
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105t
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105p
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105q
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105r
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105s
>  SPI driver sja1105 has no spi_device_id for nxp,sja1110a
>  SPI driver sja1105 has no spi_device_id for nxp,sja1110b
>  SPI driver sja1105 has no spi_device_id for nxp,sja1110c
>  SPI driver sja1105 has no spi_device_id for nxp,sja1110d
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/sja1105/sja1105_main.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> index b253e27bcfb4..b03d0d0c3dbf 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -3382,12 +3382,28 @@ static const struct of_device_id sja1105_dt_ids[] = {
>  };
>  MODULE_DEVICE_TABLE(of, sja1105_dt_ids);
>  
> +static const struct spi_device_id sja1105_spi_ids[] = {
> +	{ "sja1105e" },
> +	{ "sja1105t" },
> +	{ "sja1105p" },
> +	{ "sja1105q" },
> +	{ "sja1105r" },
> +	{ "sja1105s" },
> +	{ "sja1110a" },
> +	{ "sja1110b" },
> +	{ "sja1110c" },
> +	{ "sja1110d" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(spi, sja1105_spi_ids);
> +
>  static struct spi_driver sja1105_driver = {
>  	.driver = {
>  		.name  = "sja1105",
>  		.owner = THIS_MODULE,
>  		.of_match_table = of_match_ptr(sja1105_dt_ids),
>  	},
> +	.id_table = sja1105_spi_ids,
>  	.probe  = sja1105_probe,
>  	.remove = sja1105_remove,
>  	.shutdown = sja1105_shutdown,
> -- 
> 2.30.2
> 

Do we also need these?

MODULE_ALIAS("spi:sja1105e");
MODULE_ALIAS("spi:sja1105t");
MODULE_ALIAS("spi:sja1105p");
MODULE_ALIAS("spi:sja1105q");
MODULE_ALIAS("spi:sja1105r");
MODULE_ALIAS("spi:sja1105s");
MODULE_ALIAS("spi:sja1110a");
MODULE_ALIAS("spi:sja1110b");
MODULE_ALIAS("spi:sja1110c");
MODULE_ALIAS("spi:sja1110d");

To be honest I don't do much testing with modules at all, so I'm not
sure if udev-based module loading is broken or not. I remember becoming
vaguely curious after commit 5fa6863ba692 ("spi: Check we have a
spi_device_id for each DT compatible"), and I did some basic testing
without the spi_device_id table and MODULE_ALIASes, and it appeared that
udev could still autoload the sja1105 kernel module just fine.
So I'm not really sure what's broken.
