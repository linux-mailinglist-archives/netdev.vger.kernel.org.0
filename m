Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E7230F576
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 15:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236954AbhBDOye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 09:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236877AbhBDOwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 09:52:30 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E42C061573
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 06:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kC/7q5KJ4gPnnxs6D6VMDzQjvJoPTIlGyfYjLHi3Keg=; b=Kzs49MgMCIfs2t1mFkIeIhIw0
        4MITam8ihvHpOSNWIrVe5x7DO8mQiJsKgIuDuddb1klj/E6n6yIgif8NmLb+r2OEPlZx04a01mK1m
        OCTk6S8LTv8eejy9zQlTAYaVy+q5vu2xGOtygFcS/io2gVy7/DQJFb4eviTrqyGGxLpkzW1+5txJz
        U8nTP+9HYWXyFb05ZSHIbp31vUvY7hjLy6JsXvDnrjSXe6IuCosMmqcve+KaXIV5F72mZzn3NsE86
        xQBzj6v4vLPp0ckD0mZO4dy8JjJ/sYr0CfTXSz5RrCZCMXRNriq9c2YJjvFmFp14ZNK2pn61O2d7r
        4Gp1v/48g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39128)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l7fyh-0006fQ-6l; Thu, 04 Feb 2021 14:51:27 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l7fye-0005Fq-ET; Thu, 04 Feb 2021 14:51:24 +0000
Date:   Thu, 4 Feb 2021 14:51:24 +0000
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
Message-ID: <20210204145124.GZ1463@shell.armlinux.org.uk>
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
> 
> All in all, this patch is not needed for this particular usecase, where
> the switch between 1000Base-X and SGMII is done by just a minor
> reconfiguration in the PCS, without the need for SerDes changes.
> 
> Also, with just the changes from this patch, a interface connected to a
> DPMAC in TYPE_BACKPLANE is not even creating a phylink instance. It's
> mainly because of this check from dpaa2-eth:
> 
> 	if (dpaa2_eth_is_type_phy(priv)) {
> 		err = dpaa2_mac_connect(mac);
> 
> 
> I would suggest just dropping this patch.

Hi Ioana,

So what is happening with this series given our discussions off-list?

Do I resend it as-is?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
