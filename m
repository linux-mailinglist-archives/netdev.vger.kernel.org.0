Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336B051A3F5
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352381AbiEDP2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352359AbiEDP2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:28:30 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3B644A07;
        Wed,  4 May 2022 08:24:53 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id a21so2115149edb.1;
        Wed, 04 May 2022 08:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wOYVxYLL6+BG3TePrLsXdWjDVPS5GIUfbLWvSKSl8h4=;
        b=E7T0aF/BXgKfjiVEfL+S2vuOTV2X2yNSlckCr6+J5M7W+t5VoAN+Og/Yv5P36CGu74
         VvkDxRjgzUKvk2WA0JTA5u6U/m+zPkvpUSM+bFtCUQNpjrhvSusOBZAipF95jlUXSeid
         oZ1vPEHG/g/L1B4fu1ZmNQjZlqqUv13WaosS+SE2TWD24vArT8f8QwQ1uFAliabkCjSQ
         S7HStKY/EqJRikDQe1JuWbZdS0JxTZrL5Iu4AFJTkhE3CQDiB8JRyoIr2f6YTzBwQUGM
         nVE4bRY+sKyuRdsof4VCxH9EtrcwyOcKFWC5vdaDWVbtygWvvchlxdy60RA6dKapoO6Z
         2aaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wOYVxYLL6+BG3TePrLsXdWjDVPS5GIUfbLWvSKSl8h4=;
        b=sowuu9VbqstQa2SS5fXdy25X4vTTzpwXd9j4eYHylbA5RlwkYSCjHKSIX155RGNKhf
         i3s1/j9b9cQgKVYIPMYTeLGPmoc2lhEaOqjMZN22CjtR4q8WXzJAh7M1z85DsvuaBhoG
         LFgQTK9pOOLisbumT1UCzxbFDwQR0ZLn34DZXTMGZVHMxZ+ueu9gjJ8rqM3nsijKs0/J
         Rm4XAY3YhRQN4J+DdfLfDX0AtEXNdVoc7HuKS36DEjxgsfxqcfGiWJCLT5DWa+Cq9MB5
         fRXKn3I6lvgu9h6copcMg9/6DFd9/OsQu4PkJ7F6sb+QUxwtzCUsppMikQiYRgzj2BoU
         bh0g==
X-Gm-Message-State: AOAM530ZM/2dmYXkG2GvgsF+15KN5e7NMnAvoT96EFwK6HPFqXGPLyiM
        I2B49Wbc2EvO7nZc2HjhX/mlthBgVAE=
X-Google-Smtp-Source: ABdhPJxEFFzGhqnPOG0Za6rPtdUf8ua0dRw2gu36H+cAyAv37Oe0WTmKKVlESwvCZomBMQkRM2P7XA==
X-Received: by 2002:aa7:dcc1:0:b0:427:e1ae:d822 with SMTP id w1-20020aa7dcc1000000b00427e1aed822mr9129036edu.353.1651677892502;
        Wed, 04 May 2022 08:24:52 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id k6-20020aa7d8c6000000b0042617ba63d0sm9311741eds.90.2022.05.04.08.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 08:24:51 -0700 (PDT)
Date:   Wed, 4 May 2022 18:24:50 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC v2 4/4] arm64: dts: rockchip: Add mt7531 dsa node to
 BPI-R2-Pro board
Message-ID: <20220504152450.cs2afa4hwkqp5b5m@skbuf>
References: <20220430130347.15190-1-linux@fw-web.de>
 <20220430130347.15190-5-linux@fw-web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220430130347.15190-5-linux@fw-web.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 30, 2022 at 03:03:47PM +0200, Frank Wunderlich wrote:
> From: Frank Wunderlich <frank-w@public-files.de>
> 
> Add Device Tree node for mt7531 switch connected to gmac0.
> 
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> ---
> v2:
> - drop status=disabled
> ---
>  .../boot/dts/rockchip/rk3568-bpi-r2-pro.dts   | 48 +++++++++++++++++++
>  1 file changed, 48 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts b/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
> index ed2f2bd9a016..f0ffbe818170 100644
> --- a/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
> +++ b/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
> @@ -437,6 +437,54 @@ &i2c5 {
>  	status = "disabled";
>  };
>  
> +&mdio0 {
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +
> +	switch@0 {

I think the preferable names are the newer "ethernet-switch@0",
"ethernet-ports", "ethernet-port@0".

Otherwise

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

> +		compatible = "mediatek,mt7531";
> +		reg = <0>;
> +
> +		ports {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			port@1 {
> +				reg = <1>;
> +				label = "lan0";
> +			};
> +
> +			port@2 {
> +				reg = <2>;
> +				label = "lan1";
> +			};
> +
> +			port@3 {
> +				reg = <3>;
> +				label = "lan2";
> +			};
> +
> +			port@4 {
> +				reg = <4>;
> +				label = "lan3";
> +			};
> +
> +			port@5 {
> +				reg = <5>;
> +				label = "cpu";
> +				ethernet = <&gmac0>;
> +				phy-mode = "rgmii";
> +
> +				fixed-link {
> +					speed = <1000>;
> +					full-duplex;
> +					pause;
> +				};
> +			};
> +		};
> +	};
> +};
> +
>  &mdio1 {
>  	rgmii_phy1: ethernet-phy@0 {
>  		compatible = "ethernet-phy-ieee802.3-c22";
> -- 
> 2.25.1
> 

