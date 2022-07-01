Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29115639C6
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 21:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbiGAT0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 15:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiGAT0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 15:26:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059044D4DA
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 12:26:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F8C461F1E
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 19:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7CBC3411E;
        Fri,  1 Jul 2022 19:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656703564;
        bh=SBjh679OIL2Ez+k5zUA2ND4cI1RAcl0Sh4hM5d7eK80=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TaFuZ1lBBJSXyy3Uk3a6JkA8MW8A0Si5QvCXzT8/FCSkJBZLS8v9Dnu5/svbolCbw
         0bVfC3DBY11hYio6WJutV0MQFWUbrl70auSBlWtsxA7lGYrZH6tFpT3gjFy/DZKik0
         gNlbRInAXyH6N8hgw6vosjbpZOXBNCwHN6PVayKaW76cHkhpQq5qoePwGgj8nm4ar/
         It43L48cb/7CAJGs1Z4l2IAba4ulqMaQZdSpbZJllzcIiFlRHkC4pfk4/zWThlTI6Y
         dBvxPUQ08UrgQgT/Z9v1k3bIvlVFI9Yu2Wbvan8p/R+9b4Dg5oY3AGyF6PnEn/F30P
         qI8fN1ugR7JKQ==
Date:   Fri, 1 Jul 2022 21:25:56 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Alvin __ipraga" <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH RFC net-next 2/6] net: dsa: mv88e6xxx: report the
 default interface mode for the port
Message-ID: <20220701212556.0b396dea@thinkpad>
In-Reply-To: <E1o6XAF-004pVi-Ue@rmk-PC.armlinux.org.uk>
References: <YrxKdVmBzeMsVjsH@shell.armlinux.org.uk>
        <E1o6XAF-004pVi-Ue@rmk-PC.armlinux.org.uk>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jun 2022 13:51:27 +0100
"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk> wrote:

> Report the maximum speed interface mode for the port, or if we don't
> have that information, the hardware configured interface mode for
> the port.
> 
> This allows phylink to know which interface mode CPU and DSA ports
> are operating, which will be necessary when we want to select the
> maximum speed for the port (required for such ports without a PHY or
> fixed-link specified in firmware.)
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index f98be98551ef..1c6b4b00d58d 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -823,6 +823,7 @@ static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
>  			       phy_interface_t *default_interface)
>  {
>  	struct mv88e6xxx_chip *chip = ds->priv;
> +	u8 cmode = chip->ports[port].cmode;
>  
>  	chip->info->ops->phylink_get_caps(chip, port, config);
>  
> @@ -830,6 +831,14 @@ static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
>  	if (mv88e6xxx_phy_is_internal(ds, port))
>  		__set_bit(PHY_INTERFACE_MODE_GMII,
>  			  config->supported_interfaces);
> +
> +	if (chip->info->ops->port_max_speed_mode)
> +		*default_interface = chip->info->ops->port_max_speed_mode(port);
> +	else if (cmode < ARRAY_SIZE(mv88e6xxx_phy_interface_modes) &&
> +		 mv88e6xxx_phy_interface_modes[cmode])
> +		*default_interface = mv88e6xxx_phy_interface_modes[cmode];
> +	else if (cmode == MV88E6XXX_PORT_STS_CMODE_RGMII)
> +		*default_interface = PHY_INTERFACE_MODE_RGMII;

Will this work correctly for 6185? That one has different array,
mv88e6185_phy_interface_modes.

Maybe instead we need to send the default_interface parameter to
chip->info->ops->phylink_get_caps() ?

Marek
