Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1C03ECF2B
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 09:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhHPHPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 03:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233868AbhHPHPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 03:15:00 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B62C061764;
        Mon, 16 Aug 2021 00:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QAAz08g+VKyMUMfo2084bahucGKmb0pkuRCADWnqZww=; b=pdrq58BPxM+lkuxd5a1KjloHc
        8rh+fbKwFghCHQt0uX1Xzw++wTfy4xxn2sjhupdkEif1sPusC9mShX7qMpyYf0q6sL4NfscXo7rlG
        ss3niMXhJYlHicc4FPKbd4EO7DU+adpBcKDuuDlMBKGFdZN5m3fjH+AV+OhIcJX3/zYtua1J1KuLg
        uzyrsaqu9XqHWPQpFaC3j1Wff+GGJEJNZaavXcv7VZy6Z6IPnaeRtb2YxniSWmY+aHASVN9xjIGX2
        +AXEA3BtjI80IsqmyPFVCqVdC1u0XqwUh2ikg7XgoKagpDoxMXJnjrEu2wlbLgfQ4zLHsas1t8YJN
        bJv92tuhQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47354)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mFWpB-0007Qb-Qe; Mon, 16 Aug 2021 08:14:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mFWp9-0007n5-Fk; Mon, 16 Aug 2021 08:14:19 +0100
Date:   Mon, 16 Aug 2021 08:14:19 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "Song, Yoong Siang" <yoong.siang.song@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Message-ID: <20210816071419.GF22278@shell.armlinux.org.uk>
References: <20210813084536.182381-1-yoong.siang.song@intel.com>
 <20210814172656.GA22278@shell.armlinux.org.uk>
 <YRgFxzIB3v8wS4tF@lunn.ch>
 <20210814194916.GB22278@shell.armlinux.org.uk>
 <PH0PR11MB4950652B4D07C189508767F1D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
 <YRnmRp92j7Qpir7N@lunn.ch>
 <PH0PR11MB4950F854C789F610ECD88E6ED8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB4950F854C789F610ECD88E6ED8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 05:40:18AM +0000, Song, Yoong Siang wrote:
> > On Mon, Aug 16, 2021 at 03:52:06AM +0000, Song, Yoong Siang wrote:
> > > > > Agreed. If the interrupt register is being used, i think we need
> > > > > this patchset to add proper interrupt support. Can you recommend a
> > > > > board they can buy off the shelf with the interrupt wired up? Or
> > > > > maybe Intel can find a hardware engineer to add a patch wire to
> > > > > link the interrupt output to a SoC pin that can do interrupts.
> > > >
> > > > The only board I'm aware of with the 88x3310 interrupt wired is the
> > > > Macchiatobin double-shot. :)
> > > >
> > > > I forget why I didn't implement interrupt support though - I
> > > > probably need to revisit that. Sure enough, looking at the code I
> > > > was tinkering with, adding interrupt support would certainly conflict with
> > this patch.
> > >
> > > Hi Russell,
> > >
> > > For EHL board, both WoL interrupt and link change interrupt are the same
> > pin.
> > > Based on your knowledge, is this common across other platforms?
> > 
> > Other PHYs? Yes. WoL is just another interrupt, and any interrupt can wake
> > the system, so longer as the interrupt controller can actually wake the
> > system.
> > 
> > > Can we take set wol function as one of the ways to control the
> > > interrupts?
> > 
> > WOl does not control the interrupt, it is an interrupt source. And you need to
> > service it as an interrupt. So long as your PMC is also an interrupt controller,
> > it should all work.
> > 
> > 	  Andrew
> 
> Sorry, I should not use the word "control". Actually what I am trying to said was
> "can we take set_wol() as one of the ways to enable/disable link change interrupt?".
> PMC is not an interrupt controller. I guess the confusion here is due to I am
> using polling mode. Let me ask the question differently.
> 
> What is the conflict that will happen when interrupt support is added? 
> I can help to add config_intr() and handle_interrupt() callback support
> If they will help to solve the conflict.

The conflict is - when interrupt support is added, the link change
interrupt will be enabled all the time the PHY is in use. This will
have the effect with your patch of making the PHY appear to have WoL
enabled, even when it hasn't been configured through a set_wol call.

Essentially, your proposal for WoL on link-change fundamentally
conflicts with proper interrupt support.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
