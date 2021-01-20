Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB1D2FDF32
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 03:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404575AbhATXz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 18:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403926AbhATXVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 18:21:38 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D73C061798
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 14:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LK344BKhFxBCjto3A67yC1MJSrqRz9QtKcLEHfAkUSU=; b=h1IXcRLG4XDL+sEWWF4LWpkaF
        jOVCLO3EPWzcsZ6sthFkfJ6QDS1KPd2oyFW20t1JSYYMOGhPeaQrKWm6IjLlNmP9qUIGC6PBSigHI
        kTrOkAW701pnbIcKd6KK4p6ysWtkSuLpbEsRnUaRwgVh9Q3hdvQAtjl+GzHWHiBZl9oIfLxsinUFK
        FYzjDzC1N49Vy8Ve3yk+uXtXD+YTEO+QLw7cUY95UEWObhFsPFe/MDDqdBrfhekkp796rSnvtu7wQ
        yQLf7u3krI1/n2LISnOm35skNKkJGWrAOYvABGShk94YExP+h41gowu7PzrCbDlzSOjvQuTC/sn+7
        EQZch3gZQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50570)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l2M52-0000gv-Cm; Wed, 20 Jan 2021 22:36:01 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l2M50-0006Pg-RK; Wed, 20 Jan 2021 22:35:58 +0000
Date:   Wed, 20 Jan 2021 22:35:58 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: dpaa2-mac: add backplane link mode
 support
Message-ID: <20210120223558.GM1551@shell.armlinux.org.uk>
References: <20210119153545.GK1551@shell.armlinux.org.uk>
 <E1l1t3B-0005Vn-2N@rmk-PC.armlinux.org.uk>
 <20210120221900.i6esmk6uadgqpdtu@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120221900.i6esmk6uadgqpdtu@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 10:19:01PM +0000, Ioana Ciornei wrote:
> On Tue, Jan 19, 2021 at 03:36:09PM +0000, Russell King wrote:
> > Add support for backplane link mode, which is, according to discussions
> > with NXP earlier in the year, is a mode where the OS (Linux) is able to
> > manage the PCS and Serdes itself.
> 
> Indeed, DPMACs in TYPE_BACKPLANE can have both their PCS and SerDes managed
> by Linux (since the firmware is not touching these).
> That being said, DPMACs in TYPE_PHY (the type that is already supported
> in dpaa2-mac) can also have their PCS managed by Linux (no interraction
> from the firmware's part with the PCS, just the SerDes).

This is not what was discussed last year. It clearly shows in the
slides that Bogdan sent in April 2020 "PCS Representation in Linux.pptx"
page 4 that the firmware manages the PCS in TYPE_PHY and TYPE_FIXED
mode.

It was explained during the call that Linux must not access the internal
MDIO nor touch the PCS _except_ when using TYPE_BACKPLANE mode. Touching
the internal MDIO was stated as unsupported in other modes as the MC
firmware will be performing MDIO accesses.

> Also, with just the changes from this patch, a interface connected to a
> DPMAC in TYPE_BACKPLANE is not even creating a phylink instance. It's
> mainly because of this check from dpaa2-eth:
> 
> 	if (dpaa2_eth_is_type_phy(priv)) {
> 		err = dpaa2_mac_connect(mac);
> 
> 
> I would suggest just dropping this patch.

That is a recent change in net-next, but is not in my tree...

In any case, if NXP have changed it such that, when in TYPE_PHY, the
MC firmware no longer accesses the PCS and it is now safe to perform
MDIO accesses, then we _still_ need this patch for older firmwares.

In short, what you've put in your email does not tie up with the
position that was discussed last year, and seems to me to be a total
U-turn over what was being said.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
