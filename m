Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29EA768E769
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 06:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjBHFT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 00:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjBHFT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 00:19:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D69829E24;
        Tue,  7 Feb 2023 21:19:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB8DD614B9;
        Wed,  8 Feb 2023 05:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA15CC433EF;
        Wed,  8 Feb 2023 05:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675833592;
        bh=ppQX0phum8j/ZtlYSmQzrNm0nrrmlila/Ki/EiEn2ts=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XJ81Zr/f58c2/CUfED5JykJHvyvkjghGbRESxgOzC3aLdtpUX8NwAe7nyROcMFvSL
         z1KD92LORGPR/hI4W8CSfmyP3sp3f6Utx2Dc2iF3NqtVCxp8+H2R4+zbEAypoodCq1
         yyNtJuw//KLn8EoXrdXHMsh4c/K2cKCmXUGvRsJM49jEbojyzt4pqH2Yc2zxEG+fR2
         8ZRIotOgfSKZctiKHnIASlA/KXH0ch3T4fewGvzSOPUMAfdVGZiCDTyIFfQYhQiR4d
         4KTyT/sPJPP32AQXYqZP0IiRfFsL37N1KMWEljIijqPQouzmYZOGkEUF7O3uYZmCrj
         WqLTWseAEv9/g==
Date:   Tue, 7 Feb 2023 21:19:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v5 02/23] net: phy: add
 genphy_c45_read_eee_abilities() function
Message-ID: <20230207211950.58352ede@kernel.org>
In-Reply-To: <20230206135050.3237952-3-o.rempel@pengutronix.de>
References: <20230206135050.3237952-1-o.rempel@pengutronix.de>
        <20230206135050.3237952-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  6 Feb 2023 14:50:29 +0100 Oleksij Rempel wrote:
> +/**
> + * mii_eee_cap1_mod_linkmode_t

A bit odd formatting - for a function it should have () at the end?

> + * @adv: target the linkmode advertisement settings
> + * @val: register value
> + *
> + * A function that translates value of following registers to the linkmode:
> + * IEEE 802.3-2018 45.2.3.10 "EEE control and capability 1" register (3.20)
> + * IEEE 802.3-2018 45.2.7.13 "EEE advertisement 1" register (7.60)
> + * IEEE 802.3-2018 45.2.7.14 "EEE "link partner ability 1 register (7.61)
> + */
> +static inline void mii_eee_cap1_mod_linkmode_t(unsigned long *adv, u32 val)
> +{

> @@ -676,6 +678,8 @@ struct phy_device {
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising);
>  	/* used with phy_speed_down */
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_old);
> +	/* used for eee validation */
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported_eee);

missing kdoc for the new field
