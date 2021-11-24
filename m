Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32BBD45D11D
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245419AbhKXXZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 18:25:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244955AbhKXXZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 18:25:01 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCE3C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 15:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=L47GZxuR/UZFWeY9giJejKUfPAJXc59R+oHK6bquUw4=; b=dBvLiJfcK5SyQk/nynbyM2CiTA
        oTMuDWBVZ4/6boI6Pf8JgPuBkPG2MtkOMVfj43JXBEp0QN4bMV6tWV9K7KKMV0GuEG0lTKlnMPATj
        w2Qrg72uA4E3MBUDgW3+pNsCFdMNsgt1XEH8ZeR6GVE11mBgLbj6istiqxJ8hlPKNHDH73eTKvLXR
        yYrFq36m+5RnUYn0q/p4/79a14j2zyqnv0osckS2JZE4JEHB9VFnwBL3aXXXuuuCPEMgEMAHFvBfI
        fJuAoWZvU251tlfd5Hkhuq1Zwhar/kecbxbkiiK8p/XDBWp98cnrjdhSbtGCt7wDU302WXUe+NiWv
        5x2aEvSw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55878)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mq1a7-0001JV-4R; Wed, 24 Nov 2021 23:21:39 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mq1a3-0001bd-Ap; Wed, 24 Nov 2021 23:21:35 +0000
Date:   Wed, 24 Nov 2021 23:21:35 +0000
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
Message-ID: <YZ7I/6i42LMtr2hS@shell.armlinux.org.uk>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwSN-00D8Lz-GB@rmk-PC.armlinux.org.uk>
 <20211124195339.oa7u4zyintrwr4tx@skbuf>
 <YZ6p0V0ZOEJLhgEH@shell.armlinux.org.uk>
 <20211124223432.w3flpx55hyjxmkwn@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124223432.w3flpx55hyjxmkwn@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 10:34:33PM +0000, Vladimir Oltean wrote:
> On Wed, Nov 24, 2021 at 09:08:33PM +0000, Russell King (Oracle) wrote:
> > On Wed, Nov 24, 2021 at 07:53:40PM +0000, Vladimir Oltean wrote:
> > > On Wed, Nov 24, 2021 at 05:53:19PM +0000, Russell King (Oracle) wrote:
> > > > Populate the supported interfaces and MAC capabilities for the SJA1105
> > > > DSA switch and remove the old validate implementation to allow DSA to
> > > > use phylink_generic_validate() for this switch driver.
> > > > 
> > > > This switch only supports a static model of configuration, so we
> > > > restrict the interface modes to the configured setting, and pass the
> > > > MAC capabilities. As it is unclear which interface modes support 1G
> > > > speeds, we keep the setting of MAC_1000FD conditional on the configured
> > > > interface mode.
> > > > 
> > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > > ---
> > > 
> > > Please use this patch for sja1105. Thanks.
> > 
> > Your patch is combining two changes into one patch. Specifically, the
> > there are two logical changes in your patch:
> > 
> > 1) changing the existing behaviour of the validate() function by
> > allowing switching between PHY_INTERFACE_MODE_SGMII and
> > PHY_INTERFACE_MODE_2500BASEX, which was not permitted before with the
> > sja1105_phy_mode_mismatch() check.
> > 
> > 2) converting to supported_interfaces / mac_capabilities way of defining
> > what is supported.
> > 
> > Combining the two changes makes the patch harder to review, and it
> > becomes less obvious that it is actually correct. I would recommend
> > changing the existing behaviour prior to the conversion, but ultimately
> > that is your decision.
> > 
> > For more information please see the "Separate your changes" section in
> > Documentation/process/submitting-patches.rst
> > 
> > Thanks.
> 
> -- >8 --
> From febedc56cf0e269556e7483a70a3e6cb8d0d5cc3 Mon Sep 17 00:00:00 2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Wed, 24 Nov 2021 21:02:43 +0200
> Subject: [PATCH] net: dsa: sja1105: convert to phylink_generic_validate()
> 
> Provide a ->phylink_get_caps() implementation in order to tell phylink
> what are the PHY modes between which each port can change (none for
> now), and the MAC capabilities so it can limit the advertisement and
> supported masks of the PHY.
> 
> Now that we populate phylink_config->supported_interfaces, it is
> phylink's responsibility to not attempt a PHY mode change towards
> something which we do not support, so we can delete the logic from
> sja1105_phy_mode_mismatch() and move the essence of it into
> sja1105_phylink_get_caps(), which happens much earlier.
> 
> This patch also fixes an inconsequential bug, which was that for ports
> which support 2500base-X, we used to keep advertising the gigabit and
> lower speeds. We should not have done this, because 2500base-X operates
> only at 2500Mbps (and we do not support PAUSE frames in order for the
> lower media speeds to work via rate adaptation). Nonetheless, the only
> SJA1110 boards which use 2500base-X use it in a SERDES-to-SERDES fixed
> link, so there isn't any PHY whose advertisement matters there.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Clearly, you have stopped listening to me. This can no longer be
productive.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
