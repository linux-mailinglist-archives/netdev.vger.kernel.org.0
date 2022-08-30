Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44AF45A60D1
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 12:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiH3Kds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 06:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiH3Kdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 06:33:47 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1361EA99D4;
        Tue, 30 Aug 2022 03:33:46 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id p16so18072166ejb.9;
        Tue, 30 Aug 2022 03:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=Ys+8Z6N0JfNmceYLYZuuH+Ph0GEReWrDYc+IFrZJZ9g=;
        b=LZ95PwPgsdj1N4bPPn9buX0wXjjtt8FUMSHPYkmjckRYeMzfKwpRyce9O0TNChyn7f
         XBBEVysmFGKpofkQPY4EZCsU0MM4sB1h63mTRxj6Cp4kPJ3Iu1/byqNIaNHrTPHaxZBT
         S3qO5VPZDyoKUCaBJRHFNeJUPPX//kgip2P0EnJCteVv3QLY2x4wBHtmdpmJaC0GfUDC
         A0e4yeofBlv5yItDpV1maqSoP4hQhEeZOzjg6YwLNH55Wc+J3UNt8Ckx3uN/C/gc33eO
         h7yI8UfGHX8gWcfYDjkQTgtUKWRJFwfTyLmJnv7hbohQTaf7m+df9E35TeKlBOMvJHkk
         LBnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Ys+8Z6N0JfNmceYLYZuuH+Ph0GEReWrDYc+IFrZJZ9g=;
        b=3BgCC9ix0JctO6uReQIJFtIfzVwKtNGOtgZPIRnKCGByZytSavJl1aN2xIJMj75Z/h
         RIIaLeuVu24R4VZSdkywJXsifaWMZSSftPtbbCIwCNTlD/+27JS5gvsBl1o4iSEPrTWI
         PjLNbLDj/Mj+DIovdhO+pbjdbE/V9HFeWGE9oEDJcWXV/OgBVc4qLGu5ZpT1gZBnhUAL
         Wk5ta7Pryyjc13S6iKMKIxlNSYBXvIOaUjio7q9QjT9rVawBZjffEM2FW9A3TxlKS4t5
         cHq6pnPOdM6+5e+6cZDvuAWEuCQBWCvDv4Glqpk2+zggHHrCWqQeI/m79TsTYaYY+EEO
         /nIg==
X-Gm-Message-State: ACgBeo3UEiAGLVEAJWx4JyiLNF2f/ydY+roUDp/quJzcGEosgj8/9CTM
        ITGxBxk8f6fJ/ega+fvNH2s=
X-Google-Smtp-Source: AA6agR5llQh730VpcSYBbVc5ywWPY4z5/DSb0T/203JQCSaYPRWFMUzcQNRhGrOGSh0Ebh2/UQU0VQ==
X-Received: by 2002:a17:906:cc14:b0:73d:d230:2aa8 with SMTP id ml20-20020a170906cc1400b0073dd2302aa8mr15518970ejb.218.1661855624532;
        Tue, 30 Aug 2022 03:33:44 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id 6-20020a170906328600b0073d6d1990e2sm5668047ejw.140.2022.08.30.03.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 03:33:43 -0700 (PDT)
Date:   Tue, 30 Aug 2022 13:33:40 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH 1/2] net: dsa: LAN9303: Add basic support for LAN9354
Message-ID: <20220830103340.bqgzmcztb57m7jgd@skbuf>
References: <20220829180037.31078-1-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829180037.31078-1-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 01:00:36PM -0500, Jerry Ray wrote:
> Add initial BYTE_ORDER read to sync to improve driver robustness

Please don't post 2 different patches with the same commit message.
I think here, the first paragraph is what the commit message should
actually be.

> 
> The lan9303 expects two mdio read transactions back-to-back to read a 32-bit
> register. The first read transaction causes the other half of the 32-bit
> register to get latched.  The subsequent read returns the latched second half
> of the 32-bit read. The BYTE_ORDER register is an exception to this rule. As
> it is a constant value, there is no need to latch the second half. We read
> this register first in case there were reads during the boot loader process
> that might have occurred prior to this driver taking over ownership of
> accessing this device.
> 
> This patch has been tested on the SAMA5D3-EDS with a LAN9303 RMII daughter
> card.

Is this patch fixing a problem for any existing platforms supported by
this driver?

> 
> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
> ---
>  drivers/net/dsa/lan9303-core.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
> index e03ff1f267bb..17ae02a56bfe 100644
> --- a/drivers/net/dsa/lan9303-core.c
> +++ b/drivers/net/dsa/lan9303-core.c
> @@ -32,6 +32,7 @@
>  #define LAN9303_INT_EN 0x17
>  # define LAN9303_INT_EN_PHY_INT2_EN BIT(27)
>  # define LAN9303_INT_EN_PHY_INT1_EN BIT(26)
> +#define LAN9303_BYTE_ORDER 0x19
>  #define LAN9303_HW_CFG 0x1D
>  # define LAN9303_HW_CFG_READY BIT(27)
>  # define LAN9303_HW_CFG_AMDX_EN_PORT2 BIT(26)
> @@ -847,9 +848,10 @@ static int lan9303_check_device(struct lan9303 *chip)
>  	int ret;
>  	u32 reg;
>  
> -	ret = lan9303_read(chip->regmap, LAN9303_CHIP_REV, &reg);
> +	// Dummy read to ensure MDIO access is in 32-bit sync.

C-style comments /* */ are more typical in the Linux kernel coding style.

> +	ret = lan9303_read(chip->regmap, LAN9303_BYTE_ORDER, &reg);

Pretty strange to see the dummy read in lan9303_check_device().
Bootloader leaving things in a messy state is only a problem if we don't
have a reset GPIO, right?

How about introducing the logic here, right in lan9303_probe():

	lan9303_handle_reset(chip);

	if (!chip->reset_gpio) {
		/* Dummy read to ensure MDIO access is in 32-bit sync. */
		ret = lan9303_read(chip->regmap, LAN9303_BYTE_ORDER, &reg);
		if (ret) {
			dev_err(chip->dev, "failed to access the device: %pe\n",
				ERR_PTR(ret));
			return ret;
		}
	}

	ret = lan9303_check_device(chip);

>  	if (ret) {
> -		dev_err(chip->dev, "failed to read chip revision register: %d\n",
> +		dev_err(chip->dev, "failed to access the device: %d\n",
>  			ret);
>  		if (!chip->reset_gpio) {
>  			dev_dbg(chip->dev,

The context here reads:
		if (!chip->reset_gpio) {
			dev_dbg(chip->dev,
				"hint: maybe failed due to missing reset GPIO\n");
		}

Is the comment still accurate after the change, or do you feel that it
can be removed? Looks like you are fixing a known issue.

> @@ -858,6 +860,13 @@ static int lan9303_check_device(struct lan9303 *chip)
>  		return ret;
>  	}
>  
> +	ret = lan9303_read(chip->regmap, LAN9303_CHIP_REV, &reg);
> +	if (ret) {
> +		dev_err(chip->dev, "failed to read chip revision register: %d\n",
> +			ret);
> +		return ret;
> +	}
> +
>  	if ((reg >> 16) != LAN9303_CHIP_ID) {
>  		dev_err(chip->dev, "expecting LAN9303 chip, but found: %X\n",
>  			reg >> 16);
> -- 
> 2.17.1
> 
