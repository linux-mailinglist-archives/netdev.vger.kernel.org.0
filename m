Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8079546A108
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 17:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355674AbhLFQT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 11:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386979AbhLFQTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 11:19:34 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8E0C08E9B9
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 08:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=chmcx33+jCp9x+f1PcnLooIvECM117i66kL0WxG3LbY=; b=RuuLswMrIEwCTwg9oZ404W0qzE
        uc1+oXNvYa9BPaC3QPCkN3h364hMsaX+fkPojisfcdbJkBZ7056h/27/5r7Vx2azBVp25j/GMS0hB
        Rp8suxQ3r3XwL5TAvxw4QkKIgvIeR9J0ANtAKvuuM4Duh78CPVN4IODDzdNY3Jp1CIDG9fe7EcdfH
        1PeF2jXKcB1UJGvCf4URYDck+P9I8RUy09lecns5XO2r/nApuPROfPS2nIgvrftAZn+XPDoNSfeRX
        HRplbhWY2instN3dsfOJR3IUcFfzKzc3L5ZNIzHOC6VW7iWyVBhi8PJRAhY4ldeYIiW/UnDJ5I6nC
        J1/CwcbQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56102)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1muGcV-0004xp-Pc; Mon, 06 Dec 2021 16:13:39 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1muGcS-0004Tk-Cn; Mon, 06 Dec 2021 16:13:36 +0000
Date:   Mon, 6 Dec 2021 16:13:36 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH RFC net-next 05/12] net: dsa: bcm_sf2: convert to
 phylink_generic_validate()
Message-ID: <Ya42sBObkK60mhUo@shell.armlinux.org.uk>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwRs-00D8LK-N3@rmk-PC.armlinux.org.uk>
 <6ef4f764-cd91-91bd-e921-407e9d198179@gmail.com>
 <3b3fed98-0c82-99e9-dc72-09fe01c2bcf3@gmail.com>
 <Yast4PrQGGLxDrCy@shell.armlinux.org.uk>
 <YauArR7bd6Xh4ISt@shell.armlinux.org.uk>
 <24f210a9-54c9-eb0b-af88-a7ad75ce26aa@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24f210a9-54c9-eb0b-af88-a7ad75ce26aa@amd.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 09:59:46AM -0600, Tom Lendacky wrote:
> On 12/4/21 8:52 AM, Russell King (Oracle) wrote:
> > On Sat, Dec 04, 2021 at 08:59:12AM +0000, Russell King (Oracle) wrote:
> > > On Fri, Dec 03, 2021 at 08:18:22PM -0800, Florian Fainelli wrote:
> 
> > 
> > Here's a patch for one of my suggestions above. Tom, I'd appreciate
> > if you could look at this please. Thanks.
> 
> I think it's fine to move the setting down. The driver that I was working on
> at the time only advertised 1000baseKX_Full for 1gpbs (which wasn't in the
> array and why I added it), so I don't see an issue with moving it down.
> 
> A quick build and test showed that I was able to successfully connect at 1
> gbps. I didn't dive any deeper than that.

Thanks Tom! Can I use that to add your tested-by to this change please?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
