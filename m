Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564CC6A3FB7
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 11:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjB0KxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 05:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjB0KxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 05:53:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4301972A8
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 02:53:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCB1A60C4F
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81E3C433D2;
        Mon, 27 Feb 2023 10:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677495179;
        bh=6JFT6ur4jX4S4xLulruMUMzwn9Veq3hAer5G9iC1/JE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RDdB/ecGyD3G+5YEfZHiWfOuN2ylSBr2TPE2HK+a7XNVtjk4TnpKILh/5JFOV2nzR
         cyf26KOADfbbBDPbcgGBpfb9ZAU5FU1VvZJvq8H3F5oxLLQaOkVbL7en7XdzihknD2
         y+cHG/oaTA9QnY6YCQsMWW2uRLURiC+511e8dOuhtZqTF+KoPVIwrcJZQThQq/MVP1
         haxTR1sVxUJDnkIT4AriUY6Wz5t00ADSdKyEjUAF+hijRopDcZIyVPl3Jo5NAzMRiY
         FIdYUyMyubw0g8Y7uDUvfcbPXabYTG72pamJFMFNldERMJKCr3R4d+BRzEFykQVs5Y
         3mC9UwLK5MGpg==
Date:   Mon, 27 Feb 2023 10:52:52 +0000
From:   Lee Jones <lee@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Maksim Kiselev <bigunclemax@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net 3/3] net: mscc: ocelot: fix duplicate driver name
 error
Message-ID: <Y/yLhHIjtdBzSpLu@google.com>
References: <20230224155235.512695-1-vladimir.oltean@nxp.com>
 <20230224155235.512695-4-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230224155235.512695-4-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Feb 2023, Vladimir Oltean wrote:

> When compiling a kernel which has both CONFIG_NET_DSA_MSCC_OCELOT_EXT
> and CONFIG_MSCC_OCELOT_SWITCH enabled, the following error message will
> be printed:
> 
> [    5.266588] Error: Driver 'ocelot-switch' is already registered, aborting...
> 
> Rename the ocelot_ext.c driver to "ocelot-ext-switch" to avoid the name
> duplication, and update the mfd_cell entry for its resources.
> 
> Fixes: 3d7316ac81ac ("net: dsa: ocelot: add external ocelot switch control")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/mfd/ocelot-core.c           | 2 +-

Acked-by: Lee Jones <lee@kernel.org>

>  drivers/net/dsa/ocelot/ocelot_ext.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> index b0ff05c1759f..e1772ff00cad 100644
> --- a/drivers/mfd/ocelot-core.c
> +++ b/drivers/mfd/ocelot-core.c
> @@ -177,7 +177,7 @@ static const struct mfd_cell vsc7512_devs[] = {
>  		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
>  		.resources = vsc7512_miim1_resources,
>  	}, {
> -		.name = "ocelot-switch",
> +		.name = "ocelot-ext-switch",
>  		.of_compatible = "mscc,vsc7512-switch",
>  		.num_resources = ARRAY_SIZE(vsc7512_switch_resources),
>  		.resources = vsc7512_switch_resources,
> diff --git a/drivers/net/dsa/ocelot/ocelot_ext.c b/drivers/net/dsa/ocelot/ocelot_ext.c
> index 14efa6387bd7..52b41db63a28 100644
> --- a/drivers/net/dsa/ocelot/ocelot_ext.c
> +++ b/drivers/net/dsa/ocelot/ocelot_ext.c
> @@ -149,7 +149,7 @@ MODULE_DEVICE_TABLE(of, ocelot_ext_switch_of_match);
>  
>  static struct platform_driver ocelot_ext_switch_driver = {
>  	.driver = {
> -		.name = "ocelot-switch",
> +		.name = "ocelot-ext-switch",
>  		.of_match_table = of_match_ptr(ocelot_ext_switch_of_match),
>  	},
>  	.probe = ocelot_ext_probe,
> -- 
> 2.34.1
> 

-- 
Lee Jones [李琼斯]
