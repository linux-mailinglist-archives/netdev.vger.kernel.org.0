Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCCC528337
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 13:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237146AbiEPL3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 07:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbiEPL3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 07:29:51 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37BFDE8E;
        Mon, 16 May 2022 04:29:49 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id p26so1649024eds.5;
        Mon, 16 May 2022 04:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=60Jgax5rtmHXd0F8D+8VKZQsMiEQwIXeF0CHSq4UiDE=;
        b=BCr2OuCSVdHkm0JVRNOcu+/R7xDpH9/+ysUv4RYdcGm2QZp2OpcJjpFQZX82dnK53B
         /GH/cPOhQzXCNmkGAvBjWJ+MmxVrP04zybYLfItRs0H7ic1L2Tt8uttum5PLC9Ba2k5O
         DQUJDUlNQTEAtMu7G0f3lsZbY9kxtBtSN70gjB6VP45jPREgFV/alLT51g8T8GlOsDbr
         mvYiUtXYPyNmY0Id96KejARw2R+cmBu5KuRzREjvGb8cuwdWfSbTYIq51n7JbhAlAMdJ
         gOhrlRlC+FhRfx0DZEgabc3tvmTHqkT/pWKSGUGLsC0++Dol5ke4cfMKqjzP/TRn6oAA
         wC/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=60Jgax5rtmHXd0F8D+8VKZQsMiEQwIXeF0CHSq4UiDE=;
        b=CU1SWihfg+cPMZ3QBA1Qtilycd8yvXRJ8Vkd6iokWnheed9f3PXxFH6XV0H4z0YZQT
         9tDWSRgByT7Du+LGMhZ4gl3JCTuCy9emqcgUCfsB8XYCTMW4B2+L5NKGgF6LoRmQpmJt
         4rmJ3g9JcxgGvK9//qtrm8bCojPFHgQw61deruQgAPYgqkxY4hM1uYfNAp+PAArpXu24
         uvAknncSR6e7iYFnGUfclKlUun9DjNf1biIyKnZnuvbwykJwnaVf5Rvh1gIDThJwPsU5
         IrOON5vMhiXfO2tnkZnHxUBYvTVEKTwGLp67RMM9AgiFRVN9tYMk6W7G3mgZ4qD0om6/
         O1qA==
X-Gm-Message-State: AOAM531H8kY2xMH2/UTFePOoVCsbgRSRaoruxvEZBCrRSBW5J/xBnLaQ
        igxaEE14mLtH0ftHL8kx0K0=
X-Google-Smtp-Source: ABdhPJxPnfSiDTaGhFi3/CPyBIpP9vgHJABxpSq4vi0q7Xr5EAT74pu1v9B+e04Qq8CEetnwd8vg8g==
X-Received: by 2002:a05:6402:c17:b0:42a:b3e0:cbd0 with SMTP id co23-20020a0564020c1700b0042ab3e0cbd0mr3721234edb.213.1652700588454;
        Mon, 16 May 2022 04:29:48 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id gz21-20020a170907a05500b006f4512e7bc8sm3622055ejc.60.2022.05.16.04.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 04:29:47 -0700 (PDT)
Date:   Mon, 16 May 2022 14:29:46 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [RFC Patch net-next v2 8/9] net: dsa: microchip: add the phylink
 get_caps
Message-ID: <20220516112946.txal6try5x6uou75@skbuf>
References: <20220513102219.30399-1-arun.ramadoss@microchip.com>
 <20220513102219.30399-9-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513102219.30399-9-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 03:52:18PM +0530, Arun Ramadoss wrote:
> This patch add the support for phylink_get_caps for ksz8795 and ksz9477
> series switch. It updates the struct ksz_switch_chip with the details of
> the internal phys and xmii interface. Then during the get_caps based on
> the bits set in the structure, corresponding phy mode is set.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Looks good, although I haven't verified the exact compatibility matrix
for all switches. Just one comment below.

> @@ -179,6 +183,10 @@ const struct ksz_chip_data ksz_switch_chips[] = {
>  		.mib_names = ksz9477_mib_names,
>  		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
>  		.reg_mib_cnt = MIB_COUNTER_NUM,
> +		.supports_mii = {false, false, false, false, true},
> +		.supports_rmii = {false, false, false, false, true},
> +		.supports_rgmii = {false, false, false, false, true},
> +		.internal_phy = {true, true, true, false, false},
>  	},
>  
>  	[KSZ8765] = {
> @@ -193,6 +201,10 @@ const struct ksz_chip_data ksz_switch_chips[] = {
>  		.mib_names = ksz9477_mib_names,
>  		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
>  		.reg_mib_cnt = MIB_COUNTER_NUM,
> +		.supports_mii = {false, false, false, false, true},
> +		.supports_rmii = {false, false, false, false, true},
> +		.supports_rgmii = {false, false, false, false, true},
> +		.internal_phy = {true, true, true, true, false},
>  	},
>  
>  	[KSZ8830] = {
> @@ -206,6 +218,9 @@ const struct ksz_chip_data ksz_switch_chips[] = {
>  		.mib_names = ksz88xx_mib_names,
>  		.mib_cnt = ARRAY_SIZE(ksz88xx_mib_names),
>  		.reg_mib_cnt = MIB_COUNTER_NUM,
> +		.supports_mii = {false, false, true},
> +		.supports_rmii = {false, false, true},
> +		.internal_phy = {true, true, false},
>  	},
>  
>  	[KSZ9477] = {
> @@ -220,6 +235,14 @@ const struct ksz_chip_data ksz_switch_chips[] = {
>  		.mib_names = ksz9477_mib_names,
>  		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
>  		.reg_mib_cnt = MIB_COUNTER_NUM,
> +		.supports_mii = {false, false, false, false,
> +				 false, true, false},
> +		.supports_rmii = {false, false, false, false,
> +			false, true, false},
> +		.supports_rgmii = {false, false, false, false,
> +			false, true, false},

Please fix indentation here and for KSZ9897 and KSZ9567.

> +		.internal_phy = {true, true, true, true,
> +				true, false, false},
>  	},
