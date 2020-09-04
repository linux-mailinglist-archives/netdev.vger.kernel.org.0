Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADFD325D24C
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 09:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgIDH1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 03:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgIDH1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 03:27:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767DDC061244
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 00:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RNEt0e4IGwPn4geaSEumBxWc0p+qIMsXjIOZfG2zeOg=; b=Pj4Xp8tW/K5qYN4UeFoweSTI2
        VTd8LfqWFSZzx2FaQh7lvvhDc70V9Eh3Qm3Ekg45/koYxilHBZwCZ8J9ahULePsAF3csMAM5v0VEU
        +EmgDHxiSQgU0SfK6Jl6IcFeljTkTQLTzGW7BU1nIukJgPWGdG4iK9L/6K4VtxDp8TNGu3jgjTjw4
        9jgJqChaK7odueH+Xzh2IVVIPE8gjR2ehIXrZI8jocWYI+o+uZrn4Xe2MFBf75Y8jzax8VnnCX9pk
        z5wNysr0jKQlGk8yXThvvfNXMRW7HEtFAjcxNxl8VN1qv0Gyfaz8zZO/5AJKAtH4vuqxho/bGgMpV
        uFYfL9n7w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60940)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kE67W-0007Nm-QG; Fri, 04 Sep 2020 08:26:50 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kE67T-0001bz-6U; Fri, 04 Sep 2020 08:26:47 +0100
Date:   Fri, 4 Sep 2020 08:26:47 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/7] net: mvpp2: check first level interrupt
 status registers
Message-ID: <20200904072646.GP1551@shell.armlinux.org.uk>
References: <20200902161007.GN1551@shell.armlinux.org.uk>
 <E1kDVMQ-0000jX-D8@rmk-PC.armlinux.org.uk>
 <20200903012414.GH3071395@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903012414.GH3071395@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 03, 2020 at 03:24:14AM +0200, Andrew Lunn wrote:
> On Wed, Sep 02, 2020 at 05:11:46PM +0100, Russell King wrote:
> > Check the first level interrupt status registers to determine how to
> > further process the port interrupt. We will need this to know whether
> > to invoke the link status processing and/or the PTP processing for
> > both XLG and GMAC.
> 
> As i said, i don't know this driver. Does the hardware actually have
> two MAC hardware blocks? One for 10Mbs->1G, and a second for > 1G?

Yes.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
