Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C062F67C1
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbhANRb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbhANRbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 12:31:55 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A80C061574
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 09:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Dn6L65rN0t+cXuNLr/L+aB9a14vAbZIuUTES9/alShY=; b=rL5yp7U0I+oBKxVJoQBXZtozO
        jLZ6JGXNgtoYMWERDwrFqaS53+1vxf55sS54c0yDX0LjE5DMlIUZAXXaT3MXxA6GSwSp3wzSz/KKk
        PPD+jtLyb90EI0uQOXTjltREHBH3nJdjRzEb9IeVoTBsbR8miJFSeCEmesvsixPdzfHJXUm0z2oXF
        vyZuk0TxQMiS9qP59g7sPEHRsyQ/R7BH+KxJyaRJRKpQnnyAvO0G+WGZogtRDnlnZOuhzmiJIGmkK
        owdQmSzxM1qb/V/VyJ4kpSEPQ6KFUYBk46ntmecz6XKHflXQJnrBNPQgX58pjqkwrpKG7RZ6Kxjhi
        BMwOJCLrw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47968)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l06Sm-0002kQ-6N; Thu, 14 Jan 2021 17:31:12 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l06Sl-00005a-Vy; Thu, 14 Jan 2021 17:31:12 +0000
Date:   Thu, 14 Jan 2021 17:31:11 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethtool: allow MAC drivers to override
 ethtool get_ts_info
Message-ID: <20210114173111.GX1551@shell.armlinux.org.uk>
References: <E1kyYfI-0004wl-Tf@rmk-PC.armlinux.org.uk>
 <20210114125506.GC3154@hoboy.vegasvil.org>
 <20210114132217.GR1551@shell.armlinux.org.uk>
 <20210114133235.GP1605@shell.armlinux.org.uk>
 <20210114172712.GA13644@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114172712.GA13644@hoboy.vegasvil.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 09:27:12AM -0800, Richard Cochran wrote:
> On Thu, Jan 14, 2021 at 01:32:35PM +0000, Russell King - ARM Linux admin wrote:
> > > We had already discussed this patch last year, and you agreed with it
> > > then. What has changed?
> > 
> > See the discussion in this sub-thread:
> > 
> > https://lore.kernel.org/netdev/20200729105807.GZ1551@shell.armlinux.org.uk/
> 
> Thanks for the reminder.  We ended up with having to review the MAC
> drivers that support phydev.
> 
>    https://lore.kernel.org/netdev/20200730194427.GE1551@shell.armlinux.org.uk/
> 
> There is at least the FEC that supports phydev.  I have a board that
> combines the FEC with the dp83640 PHYTER, and your patch would break
> this setup.  (In the case of this HW combination, the PHYTER is
> superior in every way.)
> 
> Another combination that I have seen twice is the TI am335x with its
> cpsw MAC and the PHYTER.  Unfortunately I don't have one of these
> boards, but people made them because the cpsw MAC supports time
> stamping in a way that is inadequate.
> 
> I *think* the cpsw/phyter combination would work with your patch, but
> only if the users disable CONFIG_TI_CPTS at compile time.

I think then the only solution is to move the decision how to handle
get_ts_info into each MAC driver and get rid of:

	if (phy_has_tsinfo(phydev))
	        return phy_ts_info(phydev, info);

in __ethtool_get_ts_info().

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
