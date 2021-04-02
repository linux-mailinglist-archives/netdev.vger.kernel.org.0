Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF538352AE2
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 14:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbhDBM7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 08:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbhDBM7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 08:59:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F904C0613E6;
        Fri,  2 Apr 2021 05:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=h1VWSN8soVzunp3HrMrLO5PRz7NfktsWIKRpk3RjL/A=; b=rxxE80V9/KzUwgw5QpAHo7UTX
        Bdo4Sv8nEVDZE9D1Y6T5axFZ3CDneMiN0MeuS3J3cJO4koSusLjr/rTlCf+rt2UZ8idsX3AOQKrw6
        9VhNCouxO5kqJnSkUT8U3ogiF9VL8qwnzcRmgrSlE9j9aE02X7zTw/ZqLv9GO1T75txX5ScjW+dyp
        AXjq12bGDeUmY3X1RhLSgNrJ2iK+AOZPNz6RxVZ8n8FAUwbfS9KovffgB26pHA2CtMoFqt9SM7TsH
        mAA+rJk3sm33JC4oyerDqFwajCygqCsRhSrMn2DVh6774RkHzWKbis9k8+yuuqYkD6ooPDldEDuZZ
        IpFTcpWXQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52044)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lSJO8-0004jy-Lw; Fri, 02 Apr 2021 13:59:00 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lSJO6-0005rC-Tg; Fri, 02 Apr 2021 13:58:58 +0100
Date:   Fri, 2 Apr 2021 13:58:58 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Danilo Krummrich <danilokrummrich@dk-develop.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeremy.linton@arm.com
Subject: Re: [PATCH 2/2] net: mdio: support c45 peripherals on c22 busses
Message-ID: <20210402125858.GB1463@shell.armlinux.org.uk>
References: <20210331141755.126178-1-danilokrummrich@dk-develop.de>
 <20210331141755.126178-3-danilokrummrich@dk-develop.de>
 <YGSi+b/r4zlq9rm8@lunn.ch>
 <6f1dfc28368d098ace9564e53ed92041@dk-develop.de>
 <20210331183524.GV1463@shell.armlinux.org.uk>
 <2f0ea3c3076466e197ca2977753b07f3@dk-develop.de>
 <20210401084857.GW1463@shell.armlinux.org.uk>
 <YGZvGfNSBBq/92D+@arch-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGZvGfNSBBq/92D+@arch-linux>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 02, 2021 at 03:10:49AM +0200, Danilo Krummrich wrote:
> On Thu, Apr 01, 2021 at 09:48:58AM +0100, Russell King - ARM Linux admin wrote:
> > Do you actually have a requirement for this?
> >
> Yes, the Marvell 88Q2112 1000Base-T1 PHY. But actually, I just recognize that it
> should be possible to just register it with the compatible string
> "ethernet-phy-ieee802.3-c22" instead of "ethernet-phy-ieee802.3-c45", this
> should result in probing it as c22 PHY and doing indirect accesses through
> phy_*_mmd().

Unfortunately, I let my Marvell Extranet access expire last year, so
I can't grab the datasheet for the 88Q2112 to see what Marvell claim
it supports.

> > One could also argue this is a feature, and it allows userspace to
> > know whether C45 cycles are supported or not.
> >
> No, if the userspace requests such a transfer although the MDIO controller
> does not support real c45 framing the kernel will call mdiobus_c45_addr() to
> join the devaddr and  and regaddr in one parameter and pass it to
> mdiobus_read() or mdiobus_write(). A bus driver not supporting c45 framing
> will not care and just mask/shift the joined value and write it to the
> particular register. Obviously, this will result into complete garbage being
> read or (even worse) written.


We have established that MDIO drivers need to reject accesses for
reads/writes that they do not support - this isn't something that
they have historically checked for because it is only recent that
phylib has really started to support clause 45 PHYs.

More modern MDIO drivers check the requested access type and error
out - we need the older MDIO drivers to do the same.

> > In summary, I think you need to show us that you have a real world
> > use case for these changes - in other words, a real world PHY setup
> > that doesn't work today.
> >
> My concrete setup would have been the PHY I mentioned above, but if I'm right
> with my assumption that I can just use "ethernet-phy-ieee802.3-c22" for it,
> I don't have a concreate setup anymore.
> 
> However, the kernel provides the option to register arbitrary MDIO drivers with
> mdio_driver_register() where a device could support c45 and live on a c22 only
> bus. For such devices the fallback to indirect accesses would be useful as well,
> since they can't use the existing indirect access functions, because they're
> specific to PHYs. However, currently there aren't such drivers in the kernel.
> I just want to mention this for completeness.

Right, and in such a scenario, I think using the PHY compatible
property that allows you to specify the IDs will do exactly what you
need. Yes, is_c45 will be false, which is exactly what you want in this
case.

The PHY specific C45 driver will still recognise the PHY ID, and bind
to the PHY device. It will then issue the MMD accesses, which will go
through the indirect registers.

So, I don't immediately see any need to change the kernel code for
this. However, you say you don't have this setup anymore, so there's
no way to test this.

I suggest we wait until we do have such a setup where it can be tested
and proven to work, rather than changing the kernel code to try adding
something that we've no way to test - but at the same time where making
those changes has its own risk of causing regressions. Without it being
tested, the cost/benefit ratio is weighed to the change being costly.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
