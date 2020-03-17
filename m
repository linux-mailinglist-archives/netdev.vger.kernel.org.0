Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC62188923
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 16:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgCQP0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 11:26:47 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:41416 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgCQP0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 11:26:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=c4VMEeyDub9gXNam5tpCczR26KhxHVaAyLJoni/S3RY=; b=oSzL0s7RhZ3kfnfVk9InOw2RV
        /rZnV1en5VrEMPjBF0my7Xl6yRoJwkknuLQ26Ng3LqLWfT2TKpgM0sYIgFkxWdBfyH91Uijg03j7v
        2Kvgmgk8aGUMeXBrakZBP0mNOGyhMwu5RPl7gyCJr5DL9JM+FtHaYDriEkRg1RlUp2LNLj5MkKzUo
        vWsT6ptKZI3pDbd8KCR96BLJ2lbDxwnJ4RyKpeLxTsZHfNYuBEQA/A/Us8kYwYSOW1a+jQ8eP6R7/
        2/Drsn82mbndGb6lDSX30Jw4wijbZX6Y3eEHCSQIrKj3nQMOka0bdeDIF+Lmbh1idkGATUxpUyD6Y
        l2UByn9KQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:54286)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jEE77-0007sM-OA; Tue, 17 Mar 2020 15:26:41 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jEE76-0002ud-S8; Tue, 17 Mar 2020 15:26:40 +0000
Date:   Tue, 17 Mar 2020 15:26:40 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH REPOST3 net-next 0/3] net: add phylink support for PCS
Message-ID: <20200317152640.GR25745@shell.armlinux.org.uk>
References: <20200314103102.GJ25745@shell.armlinux.org.uk>
 <20200314220018.GH8622@lunn.ch>
 <20200314224459.GL25745@shell.armlinux.org.uk>
 <20200317141839.GT24270@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317141839.GT24270@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 03:18:39PM +0100, Andrew Lunn wrote:
> On Sat, Mar 14, 2020 at 10:44:59PM +0000, Russell King - ARM Linux admin wrote:
> > On Sat, Mar 14, 2020 at 11:00:18PM +0100, Andrew Lunn wrote:
> > > On Sat, Mar 14, 2020 at 10:31:02AM +0000, Russell King - ARM Linux admin wrote:
> > > > Depends on "net: mii clause 37 helpers".
> > > > 
> > > > This series adds support for IEEE 802.3 register set compliant PCS
> > > > for phylink.  In order to do this, we:
> > > > 
> > > > 1. add accessors for modifying a MDIO device register, and use them in
> > > >    phylib, rather than duplicating the code from phylib.
> > > > 2. add support for decoding the advertisement from clause 22 compatible
> > > >    register sets for clause 37 advertisements and SGMII advertisements.
> > > > 3. add support for clause 45 register sets for 10GBASE-R PCS.
> > > 
> > > Hi Russell
> > > 
> > > How big is the patchset which actually makes use of this code? It is
> > > normal to add helpers and at least one user in the same patchset. But
> > > if that would make the patchset too big, there could be some leeway.
> > 
> > The minimum is three patches:
> > 
> > arm64: dts: lx2160a: add PCS MDIO nodes
> > dpaa2-mac: add 1000BASE-X/SGMII PCS support
> > dpaa2-mac: add 10GBASE-R PCS support
> 
> Hi Russell
> 
> Are the two dpaa2-mac changes safe without the DT changes? I guess
> so. So it seems sensible to post a set of 5 patches.

That would need to be tested; it hasn't yet been tested to prove
that nothing breaks as a result.

> > and, at the moment, depending on whether you want 1G or 10G speeds,
> > changes to the board firmware to select the serdes group mode.
> 
> And this is where we start speculating.

It is not speculation, what I've said is factual.  "At the moment"
describes the present situation.  If it was any different, then the
discussions that are going on between SolidRun and NXP would have
been over very quickly.  This was raised back in December, and
conference calls are still on-going on this issue, so that's about
four months so far.

There is also some evidence that if we attempt to reprogram the
Serdes PLLs at runtime, that will raise an exception and completely
reset the chip. There is also some evidence that experimenting with
changing the setup somehow bricked one of the Honeycomb boards.

So no, what I've said is not speculation.

The fact is that today, I need two different firmware images, one for
1G speeds and another for 10G speeds on _all_ the SFP+/QSFP+ cages -
it's either all at 1G or all at 10G.  This is due to the "reset
configuration word" block that is loaded from boot media at reset time
to configure the hardware.

Even different RAM speeds need different RCW contents and therefore
different firmware.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
