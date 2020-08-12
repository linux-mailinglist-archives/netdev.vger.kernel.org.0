Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39DD0242B66
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 16:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgHLOdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 10:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbgHLOdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 10:33:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051CDC061383
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 07:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=H+EiYUFsn0f/MMkkfRu+W0Mxg6BWj5oggKCfFgDkvWA=; b=MjZ2sfA+BEVEEXMIiK6p4ev8Z
        16GenDWWxBCusQj1/BNytjlHzM7vC+xMoTKAZAE0cqNnDNkvj+FFjubExWaEnqQ2sl95cM8lVj9cO
        rEh5k1skg9JngP9ywJmvMcJV3SrybbSe6g4MC2+Xmmtu8ar2ko1yo1hClOnqAYJL6snsbmSIl5dfw
        +Dn6CB17rwyTugYHBuZj1l5+G4s8XEKkWqia+gyQen1CufMuw9DfZrPoSC5oUAYP/PstknSO4saV0
        9Y6QSHP3td6K2vVKlBo6/BESQ1T1eg5LAPMUViVP+w9JafgtXjIzqFfZBVgxepGB3tA6gCIjHeXcn
        vEtebijqg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51590)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k5roP-0002ib-E8; Wed, 12 Aug 2020 15:33:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k5roO-0003sS-1J; Wed, 12 Aug 2020 15:33:04 +0100
Date:   Wed, 12 Aug 2020 15:33:04 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 2/4] net: phy: sfp: add support for
 multigig RollBall modules
Message-ID: <20200812143303.GO1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
 <20200810220645.19326-3-marek.behun@nic.cz>
 <20200811151552.GM1551@shell.armlinux.org.uk>
 <20200812153326.71b84e45@dellmb.labs.office.nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200812153326.71b84e45@dellmb.labs.office.nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 12, 2020 at 03:33:26PM +0200, Marek Behún wrote:
> On Tue, 11 Aug 2020 16:15:53 +0100
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> 
> > > +	if (rollball) {
> > > +		/* TODO: try to write this to EEPROM */
> > > +		id.base.extended_cc = SFF8024_ECC_10GBASE_T_SFI;  
> > 
> > Should we really be "fixing" vendors EEPROMs for them?
> > 
> 
> Are you reffering to the TODO comment or the id.base.extended_cc
> assignment?
> If the comment, well, your code does it for cotsworks modules, but I am
> actually indifferent.

No, that's Chris' code, and there's quite a bit of history there:
It appears Cotsworks programmed things like the serial number into
the EEPROM and did not update the checksums.  After quite some time,
it seems Cotsworks have seen sense, and have fixed their production
line to properly program the EEPROM, but that leaves a whole bunch
of modules with bad checksums.

I'm more than happy that we should continue issuing the warning, but
Chris has decided to fix them up.  I'm not particularly happy with
that idea, but I didn't get the chance to express it before David
picked up the patch.  So, it's now in mainline.

Fixing the checksum for a module that is known to suffer bad checksums
is one thing - it's a single byte write, and as the checksum is wrong,
it's likely other systems that know about the issue will ignore it.

However, changing the module description to be "correct" is a completely
different level - there are many modules that do not report "correct"
data, and, if we start fixing these up, it's likely that fixups that
other SFP cage implementations have could stop working since they may
not recognise the module.

Remember, things like the extended CC codes are dependent on the SFF
spec revisions, so if we start changing the extended CC code in byte
36, should we also change the SFF8472 compliance code as well (to
be > rev 11.9)?  Since SFF8472 rev 11.9 changed the definition of this
byte.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
