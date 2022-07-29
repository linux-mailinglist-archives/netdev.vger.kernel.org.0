Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3BE585457
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 19:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238315AbiG2RUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 13:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbiG2RUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 13:20:01 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24EB83225;
        Fri, 29 Jul 2022 10:20:00 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so5872185pjf.2;
        Fri, 29 Jul 2022 10:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=hxBFRTN1LZRoFnahsiKcdK0tbZNGdjelWAHFypZYkFw=;
        b=eiq04DaxAgViGZ9EjXJAweUo+d5rfzN0ZcDsnWBuTVAbrBldprM1+hXUHba9T/4yJa
         Dfflm8wSp8C681mf5fMlGS0yPjfW38NmFqJbW+39mcFA9u+YjxX+zpB3rnKuGPvmoaCG
         VMIHDm2ztN7RI+qdvlrDfD86Fngq/U1Tj6Yb1umPyx3nVj1K75u47/ryQMhjVU1tKa2v
         qHSyD6s/gTlxlRcWAnErIpS1Xa7O1qogS2n4GfwNgYYRSUM/OsLO3H1tLUUo4n5zQivs
         F7vpYEAWdZ89AvkwKQ4cJGpmLP15VViBvgiBmI1ideW0NrYN/p0WGJvmnm3iSqwoFuLJ
         5owg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=hxBFRTN1LZRoFnahsiKcdK0tbZNGdjelWAHFypZYkFw=;
        b=CscgOhR9kFcinc8BeOW+gU8EDiOtdqX25CwXkV0lcmIkVBnvjPiIOnjwXOgyYV9hOb
         6wt1H4pfdcJWQ39gwj0rMh/sMAohwGcs4xIfHPQnbNGM/aQ7Icu9JXDHxWtMEP0NevHy
         zsa/9vfqmk3DIp4RGrjZREhNAU/fUPPoT7TAtxDJky+vB3frxu81cco5KObjd/7ZxCHT
         euFlKcYMHdmZjF9sMJtlAK6I+mJf4n69z4DZO9V+PIPGP4S4TWSOEVbgTi9ALRuRZSP0
         3435IUutWDFypPuoq4y5F5lni0FpGGvcXERsQuTH81IxNJ7bZCQjs5ZKHbcS84ro7zqR
         ElhQ==
X-Gm-Message-State: ACgBeo0SimLQjVPHsfNAbxY/OTzNDbALl5GMLVh/oCGO4nAG7SSO0ncV
        QxTrV7AZtNSCT5JcyjAw+FI=
X-Google-Smtp-Source: AA6agR41uGgoEk7+NXJL+sFLmDGhuy+Mni8pojmb/mVvHl4PEVuWbXu8RbyWs4i0T2dCXz60Kcq39w==
X-Received: by 2002:a17:90b:1d91:b0:1f0:7824:1297 with SMTP id pf17-20020a17090b1d9100b001f078241297mr5773562pjb.126.1659115200308;
        Fri, 29 Jul 2022 10:20:00 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m14-20020a63710e000000b0041b667a1b69sm2818592pgc.36.2022.07.29.10.19.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 10:19:59 -0700 (PDT)
Message-ID: <056164ec-3525-479b-3b71-834af48d323c@gmail.com>
Date:   Fri, 29 Jul 2022 10:19:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v3 3/4] net: phy: Add helper to derive the number
 of ports from a phy mode
Content-Language: en-US
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Richard Cochran <richardcochran@gmail.com>,
        Horatiu.Vultur@microchip.com, Allan.Nielsen@microchip.com,
        UNGLinuxDriver@microchip.com
References: <20220729153356.581444-1-maxime.chevallier@bootlin.com>
 <20220729153356.581444-4-maxime.chevallier@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220729153356.581444-4-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/22 08:33, Maxime Chevallier wrote:
> Some phy modes such as QSGMII multiplex several MAC<->PHY links on one
> single physical interface. QSGMII used to be the only one supported, but
> other modes such as QUSGMII also carry multiple links.
> 
> This helper allows getting the number of links that are multiplexed
> on a given interface.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> V1->V2 : New patch
> V2->V3 : Made PHY_INTERFACE_MODE_INTERNAL 1 port, and added the MAX
> case.
> 
>  drivers/net/phy/phy-core.c | 52 ++++++++++++++++++++++++++++++++++++++
>  include/linux/phy.h        |  2 ++
>  2 files changed, 54 insertions(+)
> 
> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
> index 1f2531a1a876..f8ec12d3d6ae 100644
> --- a/drivers/net/phy/phy-core.c
> +++ b/drivers/net/phy/phy-core.c
> @@ -74,6 +74,58 @@ const char *phy_duplex_to_str(unsigned int duplex)
>  }
>  EXPORT_SYMBOL_GPL(phy_duplex_to_str);
>  
> +/**
> + * phy_interface_num_ports - Return the number of links that can be carried by
> + *			     a given MAC-PHY physical link. Returns 0 if this is
> + *			     unknown, the number of links else.
> + *
> + * @interface: The interface mode we want to get the number of ports
> + */
> +int phy_interface_num_ports(phy_interface_t interface)
> +{
> +	switch (interface) {
> +	case PHY_INTERFACE_MODE_NA:
> +		return 0;
> +	case PHY_INTERFACE_MODE_INTERNAL:

Maybe this was covered in the previous iteration, but cannot the default case return 1, and all of the cases that need an explicit non-1 return value are handled? Enumeration all of those that do need to return 1 does not really scale.
-- 
Florian
