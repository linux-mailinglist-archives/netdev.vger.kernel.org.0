Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783A757F095
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 19:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237468AbiGWR1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 13:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiGWR1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 13:27:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D8318E08;
        Sat, 23 Jul 2022 10:27:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 358D960DF1;
        Sat, 23 Jul 2022 17:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46EAC341C0;
        Sat, 23 Jul 2022 17:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658597226;
        bh=JtBO3HEfqLTQtzCzKW/NxyX2wNsOWUNYTzoUck7xXUg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ol8Q+QJNjYLHFhh7Zd5YnD3B56Am/wMVZhZXBQlXQPz5SJSxXfgah+RpIuL6onO6g
         1PD+1kdTuEsOmaRqVfHmqdlcSjYn/3lSCqojrr07uvrWXV1zRkFaQoE4f4Xr8H+GJJ
         F89q5D3fcYU1N4PBilj1GP3EPCRYuGUa5IXtO8yd06kzCoRYEwBd0wwcT33yCmT+Nm
         WLsq69QANKcmIoDxRCU9KgccbmiBw1pJEDNbkzWBliUktplyEwwsLKaH30p0sap4+i
         JNRZIg6UuILNjKLJHhlTrBKIxMPAOenTVET6Nm/vEVIZ8TOuNr2OO29ZC6m3xSMCFF
         NJtdLHfAm7EtA==
Date:   Sat, 23 Jul 2022 19:26:55 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 3/6] net: dsa: add support for retrieving the
 interface mode
Message-ID: <20220723192655.46de7cae@thinkpad>
In-Reply-To: <20220722223932.poxim3sxz62lhcuf@skbuf>
References: <YtnBmFm8Jhokgp7Q@shell.armlinux.org.uk>
        <20220721213645.57ne2jf7f6try4ec@skbuf>
        <YtpfmF37FmfY6BV5@shell.armlinux.org.uk>
        <20220722105238.qhfq5myqa4ixkvy4@skbuf>
        <YtqNkSDLRDtuooy/@shell.armlinux.org.uk>
        <20220722124629.7y3p7nt6jmm5hecq@skbuf>
        <YtqjFKUTsH4CK0L+@shell.armlinux.org.uk>
        <20220722165600.lldukpdflv7cjp4j@skbuf>
        <YtsUhdg3a2rT3NJC@shell.armlinux.org.uk>
        <YtsUhdg3a2rT3NJC@shell.armlinux.org.uk>
        <20220722223932.poxim3sxz62lhcuf@skbuf>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Jul 2022 01:39:32 +0300
Vladimir Oltean <olteanv@gmail.com> wrote:

> You mean in general, or with the firmware description you posted above?
> Because the Lynx PCS does the best it can (considering it does this from
> a function that returns void) to complain that you shouldn't put
> MLO_AN_INBAND for 2500base-x.
> 
> static void lynx_pcs_link_up_2500basex(struct mdio_device *pcs,
> 				       unsigned int mode,
> 				       int speed, int duplex)
> {
> 	u16 if_mode = 0;
> 
> 	if (mode == MLO_AN_INBAND) {
> 		dev_err(&pcs->dev, "AN not supported for 2500BaseX\n");
> 		return;
> 	}
> 
> I noticed just earlier today that I made a blunder while upstreaming some
> riser cards for some LS1028A-QDS development boards, and I did just that
> (left 2500base-x with in-band-status). But the system just errors out.
> I need to boot a board and fix that up. They're just NXP development
> systems so not a big issue. Otherwise I'm not aware of what you're
> talking about.
> 
> > However, both will request link status from the PCS side and use that
> > to determine whether the link is up, and use the parameters that the
> > PCS code returns for the link. Since 2500base-X can only operate at
> > 2.5G, PCS code always reports SPEED_2500, and as half duplex is
> > virtually never supported above 1G, DUPLEX_FULL.  
> 
> If you're saying this just because Lynx implements pcs_get_state for
> 2500base-x, it's extremely likely that this simply originates from
> vsc9959_pcs_link_state_2500basex(), which was deleted in ocelot in
> commit 588d05504d2d ("net: dsa: ocelot: use the Lynx PCS helpers in
> Felix and Seville"), and it was always dead code. It wasn't the only
> dead code, remember commit b4c2354537b4 ("net: dsa: felix: delete
> .phylink_mac_an_restart code").
> 
> Since the Lynx PCS prints error messages in inband/2500base-x mode,
> and so did Felix/Ocelot before the code became common, I'm pretty sure
> no one relies on this mode.

Does Lynx PCS support 1000base-x with AN? Because if so, it may be
possible to somehow hack working AN for 2500base-x, as I managed it for
88E6393X in the commit I mentioned (by configuring 1000base-x and then
hacking the PHY speed to 2.5x).

Anyway, I am now looking at the standards, and it seems that all the X
and R have K variant: 1000base-kx, 2500base-kx, 5gbase-kr and
10gbase-kr. These modes have mandatory clause 73 autonegotiation.

So either we need to add these as different modes of the
phy_interface_t type, or we need to differentiate whether clause 37 or
clause 73 AN should be used by another property.

But since 1000base-x supports clause 37 and 1000base-kx clause 73, the
one property that we have, managed="in-band-status" is not enough, if
we keep calling both modes '1000base-x'.

So maybe we really need to add K variants as separate
PHY_INTERFACE_MODED_ constants. That way we can keep assuming clause 37
for 2500base-x, and try to implement it for as much drivers as
possible, by hacking it up...

And I still don't understand this clause 73 AN at all. For example, if
one PHY supports only up to 2.5g speeds, will it complete AN with
another PHY that supports up to 10g speeds, if the second PHY will
(maybe?) try at higher frequency?

Marek

