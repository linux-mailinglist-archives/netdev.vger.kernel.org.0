Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEFE37F55
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbfFFVQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:16:34 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50624 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727915AbfFFVQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:16:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8Q7UkQv5cPKh6HDG9WYfTYlxwyr5DBDbv2lp0A19+OY=; b=Fp/u4hodTI1c+n/KV9e5wFp/5
        WvMBH+bEDpTB4j5sdY7d9pucBKvWKZA0F5IV4eYnrT2tzQQqimcGy5cHZ0EDdLGvjZo5GDsDUR4xZ
        KQ3fkbBPkubQiijd65C3fFaqTU7mbLkl6NuG4WPAr/hOguZrLMZ2zeDiUW6VvnOhTdfqtmj7SOom5
        RA9v57FDyN8rQXOHE1YAo65gB1IeF4747mcKcf24gL0WAGBXFbL3Ot6l2G53LW8XTG6RPe7c/u7PN
        wkDXhvuFyfzLOOdZHBcdr4AmRlvKMfFcQqFOSoVqha9UhuN7TPhNN7xuByGNKh3VoLuSZxNrwQ1jN
        mEsFV2d/Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52888)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hYzkK-0008Ra-Ke; Thu, 06 Jun 2019 22:16:28 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hYzkH-0003aT-Mn; Thu, 06 Jun 2019 22:16:25 +0100
Date:   Thu, 6 Jun 2019 22:16:25 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell10g: allow PHY to probe without firmware
Message-ID: <20190606211625.jsde7eebomhkt2dg@shell.armlinux.org.uk>
References: <E1hYTO0-0000MZ-2d@rmk-PC.armlinux.org.uk>
 <20190605.184827.1552392791102735448.davem@davemloft.net>
 <20190606075919.ysofpcpnu2rp3bh4@shell.armlinux.org.uk>
 <20190606124218.GD20899@lunn.ch>
 <16971900-e6b9-e4b7-fbf6-9ea2cdb4dc8b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <16971900-e6b9-e4b7-fbf6-9ea2cdb4dc8b@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 08:24:23PM +0200, Heiner Kallweit wrote:
> On 06.06.2019 14:42, Andrew Lunn wrote:
> > On Thu, Jun 06, 2019 at 08:59:19AM +0100, Russell King - ARM Linux admin wrote:
> >> On Wed, Jun 05, 2019 at 06:48:27PM -0700, David Miller wrote:
> >>> From: Russell King <rmk+kernel@armlinux.org.uk>
> >>> Date: Wed, 05 Jun 2019 11:43:16 +0100
> >>>
> >>>> +	    (state == PHY_UP || state == PHY_RESUMING)) {
> >>>
> >>> drivers/net/phy/marvell10g.c: In function ‘mv3310_link_change_notify’:
> >>> drivers/net/phy/marvell10g.c:268:35: error: ‘PHY_RESUMING’ undeclared (first use in this function); did you mean ‘RPM_RESUMING’?
> >>>       (state == PHY_UP || state == PHY_RESUMING)) {
> >>>                                    ^~~~~~~~~~~~
> >>>                                    RPM_RESUMING
> >>> drivers/net/phy/marvell10g.c:268:35: note: each undeclared identifier is reported only once for each function it appears in
> >>> At top level:
> >>> drivers/net/phy/marvell10g.c:262:13: warning: ‘mv3310_link_change_notify’ defined but not used [-Wunused-function]
> >>>  static void mv3310_link_change_notify(struct phy_device *phydev)
> >>>              ^~~~~~~~~~~~~~~~~~~~~~~~~
> >>
> >> Hmm. Looks like Heiner's changes in net-next _totally_ screw this
> >> approach - it's not just about PHY_RESUMING being removed, it's
> >> also about the link change notifier being moved. :(
> > 
> > Hi Russell
> > 
> > The link change notifier still seems to be called, and it is still
> > part of the phy_driver structure.
> > 
> Before my change the link change notifier didn't do what the name states.
> It was an "I'm going to run the state machine now, and something may
> have changed or not" callback.

Sure, but you've made an unexpected semantic change to the callback,
which means patches can be applied (even back-ported) that may depend
on one behaviour or the other, which will end up introducing bugs.

> Still we have state changes happening outside the state machine and
> therefore not calling the link change notifier. This brings me to the
> second point:
> 
> I don't like too much state changes outside control of the state machine,
> like in phy_start / phy_stop / phy_error. I think it would be better
> if a state change request is sent to the state machine, and the state
> machine decides whether the requested transition is allowed.

I do like to waste my time creating patches _after_ a discussion about
how this should be handled, writing code, getting people to test, and
then submitting the patches.  It makes me feel like a valued individual
when I end up wasting both my time and others time like that.

However, there is now a bigger issue - the person who reported the
issue has now programmed firmware into their PHYs, so can no longer
test.  So, whatever we now come up with has to be just submitted
without testing that it actually works.

> Coming to the use case of keeping the link down if the firmware isn't
> loaded. I'm not sure whether the firmware is needed for all modes, or
> whether e.g. basic modes like 100BaseT work also w/o firmware.
> Instead of manually changing the state it may be better to remove all
> modes needing the firmware from supported and advertising bitmap in
> the config_init callback.
> Then modes not needing the firmware can still be used, and if no mode
> remains then nothing is advertised and the link stays down anyway.

We've lost the ability to determine that now.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
