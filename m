Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D64A45DAB4
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 14:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354932AbhKYNHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 08:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354927AbhKYNFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 08:05:51 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49A6C0613FC
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 04:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QwJZUGrFmKR3VojXTURAuhSVzp0N+iOdZfF7G7fp94Y=; b=QbfR46rU8JHWawW1gEn+Yb7DwJ
        fV+3/kDplVR79t7ZkCYUtwB+jJJx1PdmrLuL9+N08ypyCluKu/FPE7lzCrUDyxf9yzVNNUlkYRHHi
        b+saUAE6ryNn7Dlnxe96m+nuR9lyCN4zjqmNPpLa3RIFYFEAbkAqIbrzs/wXpV216/Qfu5VffPGnk
        fZp46R8nS4cXe9H7ESKPJxmR/7AyLqA607sDU/UjE8/d7tsKT9VowoCx6+gwH62gmimJj66MIQ2LX
        tVwx4zTuta5gW07coZi3JES7m0uYvprXmkAeJ2a4mKLVxDnKjYAbOlDWr88qAqgDGmDdOIE+uz4na
        WrVfaS/w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55890)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mqEIc-0001tz-Nt; Thu, 25 Nov 2021 12:56:26 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mqEIZ-0002Iv-EY; Thu, 25 Nov 2021 12:56:23 +0000
Date:   Thu, 25 Nov 2021 12:56:23 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH RFC net-next 11/12] net: dsa: sja1105: convert to
 phylink_generic_validate()
Message-ID: <YZ+H95E9iI85mfax@shell.armlinux.org.uk>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwSN-00D8Lz-GB@rmk-PC.armlinux.org.uk>
 <20211124195339.oa7u4zyintrwr4tx@skbuf>
 <YZ6p0V0ZOEJLhgEH@shell.armlinux.org.uk>
 <20211124223432.w3flpx55hyjxmkwn@skbuf>
 <YZ7I/6i42LMtr2hS@shell.armlinux.org.uk>
 <20211124233200.s77wp6r7cx4okqh4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124233200.s77wp6r7cx4okqh4@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 11:32:00PM +0000, Vladimir Oltean wrote:
> On Wed, Nov 24, 2021 at 11:21:35PM +0000, Russell King (Oracle) wrote:
> > Clearly, you have stopped listening to me. This can no longer be
> > productive.
> 
> What is wrong with the second patch? You said I should split the change
> that allows the SERDES protocol to be changed, and I did. You also said
> I should make the change in behavior be the first patch, but that it's
> up to me, and I decided not to make that change now at all.
> 
> As for why I prefer to send you a patch that I am testing, it is to make
> the conversion process easier to you. For example you removed a comment
> that said this MAC doesn't support flow control, and you declared flow
> control in mac_capabilities anyway.
> 
> So no, I have not stopped listening to you, can you please tell me what
> is not right?

Let's be clear: I find dealing with you extremely difficult and
stressful. I don't find that with other people, such as Marek or
Andrew. I don't know why this is, but every time we interact, it
quickly becomes confrontational. I don't want this, and the only
way I can see to stop this is to stop interacting with you, which
is obviously also detrimental. I don't have a solution to this.

Now, as for your second patch, it didn't contain a changelog to
indicate what had changed, and it looked like it was merely a re-post
of the previously posted patch. Given how noisy the patch is due to
the size of the changes being made, this is hardly surprising. There
is a reason why we ask for changelogs when patches are modified, and
this is *exactly* why.

Having saved out and diffed the two patches, I can now see the
changes you've made. Now:

-       if (priv->info->supports_2500basex[port]) {
-               phylink_set(mask, 2500baseT_Full);
-               phylink_set(mask, 2500baseX_Full);
+       if (phy_mode == PHY_INTERFACE_MODE_2500BASEX) {
+               config->mac_capabilities = MAC_2500FD;
+       } else if (phy_interface_mode_is_rgmii(phy_mode) ||
+                  phy_mode == PHY_INTERFACE_MODE_SGMII) {
+               config->mac_capabilities = MAC_10FD | MAC_100FD | MAC_1000FD;
+       } else {
+               config->mac_capabilities = MAC_10FD | MAC_100FD;
        }

This limitation according to the interface mode is done by the generic
validation, so is unnecessary unless there really is a restriction on
the capabilities of the MAC.

Given that the generic validation will only permit the 2.5G ethtool
link modes, RGMII and SGMII will permit the 10, 100 and 1G ethtool link
modes, and MII/RevMII/RMII/RevRMII will only permit the 10 and 100
ethtool link modes, recoding this in the get_caps is rather pointless.

This also becomes less obvious that it is a correct conversion - one
can't look at the old validate() code and the new get_caps() code and
check that it's making the same decisions. The old validate code
did:

- allow 10 and 100 FD
- if mii->xmii_mode[port] is XMII_MODE_RGMII or XMII_MODE_SGMII
  - allow 1000 FD
- if priv->info->supports_2500basex[port]
  - allow 2500 FD

The new code bases it off the PHY interface mode, and now one has to
refer to the code in sja1105_init_mii_settings() to see what that is
doing to work out whether it is making equivalent decisions.

In other words, it's changing how the decisions are made concerning
which speeds (whether they are the MAC capabilities or ethtool link
modes) _and_ converting to the new way of specifying those speeds.

I've made the decision to drop the sja1105 patch from this series as
well as ocelot. Do whatever you want there, I no longer care, unless
what you do causes me problems for phylink.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
