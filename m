Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 174F25B3F61
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 21:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiIITU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 15:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiIITUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 15:20:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA2938455
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 12:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VXeWLmQVnAQShTgX4GcdFO8ig1SGD3lpWXTWiBZ2vjk=; b=X+7WN0iA2EynAOYQzK42EVKzLh
        QNBYrXGTvPbDJiD0xTmDU8PkQM2Aw9dGBRZQVDgoPMHOfpjtVF0NI3Dtf+EtP2EAgfVxhqyL42kO7
        i9yTZVGcBuVdSjn7MEuC2A23IjymR8bMrORaZo7Utq8S4FY+/UfaIZlBw2UbXjre4ujXdvQKrNz0x
        44F0ycNSwUEQbMgg5WjtUpQDMPwjMh6vblpzsSzLQUQf0Z/XVkqxvkhdgbwVlyW84NgFVV7NapFet
        a+CtoN5QkcgfJS8eV2SYexH6yospWienAq89+3LkRnXNfCGniVVT1UWw/dCWB+92RWkOJt4MGBLNs
        /oSy8gkg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34222)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oWjXt-0007zM-K6; Fri, 09 Sep 2022 20:20:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oWjXo-0003HR-12; Fri, 09 Sep 2022 20:20:04 +0100
Date:   Fri, 9 Sep 2022 20:20:03 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC v8 net-next 15/16] net: dsa: felix: add phylink_get_caps
 capability
Message-ID: <YxuR41mjy7c9weXO@shell.armlinux.org.uk>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-16-colin.foster@in-advantage.com>
 <20220509103444.bg6g6wt6mxohi2vm@skbuf>
 <20220510002332.GF895@COLIN-DESKTOP1.localdomain>
 <20220509173029.xkwajrngvejkyjzs@skbuf>
 <20220510005537.GH895@COLIN-DESKTOP1.localdomain>
 <20220509175806.osytlqnrri6t3g6r@skbuf>
 <YxuHF4UrUEJBKmcu@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxuHF4UrUEJBKmcu@euler>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 09, 2022 at 11:33:59AM -0700, Colin Foster wrote:
> Seemingly because net/dsa/port.c checks for phylink_validate before it
> checks for mac_capabilties, it won't make a difference there, but this
> seems ... wrong? Or maybe it isn't wrong until I implement the QSGMII
> port that supports 2500FD (as in drivers/net/ethernet/mscc/ocelot_net.c
> ocelot_port_phylink_create())

No, the code in dsa_port_phylink_validate() is exactly what I intend.

If there's a phylink_validate() function, then that gets used to cater
for Ocelot's rate adaption in the PCS (where the link modes are not
limited by the interface mode.)

If there isn't a phylink_validate() function, then we require that
mac_capabilities() is filled in, and if it is, we use the generic
validator - essentially I want to see everyone filling in both the
supported interface masks and the MAC capabilities no matter what.

The Ocelot rate adaption is something that needs to be tidied up, but
until that has been done, Ocelot needs to have the phylink_validate()
hook. Ocelot is currently the sole user of this hook.

I have some experimental patches to address this, but nothing that I
felt happy to send out yet.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
