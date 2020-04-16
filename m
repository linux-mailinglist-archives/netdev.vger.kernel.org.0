Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7C51ACFFF
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 20:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgDPS5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 14:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbgDPS5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 14:57:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA18AC061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 11:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=aC9p43kblM+ukNSnO6nV0AFKOaM5VD/z8aphvnIQ3IY=; b=z1yu/cqkBOtLXyVUEbMXj4edo
        1m0kAkflxFswRRXozh4JmMVpIL5lbyYfgzKz981AVWaU87cPd4djkTXbXoPmwVe6KwFVuaFUxM6/O
        QdlmZfjNY5gWF05yRJHjHBFgW0e3ietK+dhRNmoBurDb2pbN7bxvSHxxkk6ckFDvwIG5rJgPrk2a4
        EJ1mjNJHhXHRU+PJiUDVYtkeHGX4At+jEEfUHzItA59UjDQCaSMw2AFKs5Ah8/FIAF6lAt6IqLwhn
        KArD5zvIk/3qmJ4BUT+FV1VYIPlVBw8PcfIbalGRrEZhMVYMn03BOlBUreY67MrdXoIjCPSFGCRMb
        2g3U2NJMw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50964)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jP9hc-0005uS-GO; Thu, 16 Apr 2020 19:57:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jP9hZ-00027K-NP; Thu, 16 Apr 2020 19:57:29 +0100
Date:   Thu, 16 Apr 2020 19:57:29 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH] net: phy: marvell10g: disable temperature sensor on 2110
Message-ID: <20200416185729.GN25745@shell.armlinux.org.uk>
References: <1eca8c654679764a64252072509ddc1bf59938a0.1587047556.git.baruch@tkos.co.il>
 <20200416143858.GO657811@lunn.ch>
 <87v9lzcwqz.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v9lzcwqz.fsf@tarshish>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 05:48:20PM +0300, Baruch Siach wrote:
> Hi Andrew,
> 
> On Thu, Apr 16 2020, Andrew Lunn wrote:
> > On Thu, Apr 16, 2020 at 05:32:36PM +0300, Baruch Siach wrote:
> >> The 88E2110 temperature sensor is in a different location than 88X3310,
> >> and it has no enable/disable option.
> >
> > Hi Buruch
> >
> > How easy would it be to support the new location? These things can get
> > warm, specially if there is no heat sink attached. So it would be nice
> > to support it, if possible.
> 
> Adding support should not be too hard. I might find some time to work on
> this in the next few days.
> 
> I think this patch should go to -stable, so it is useful on its
> own. Support for 2110 hwmon sensor is net-next material.

Irrespective of that, we really need some way to test changes to this
driver on the 88E2110 PHYs.  Right now, there's a high chance of
breakage because afaik no one tests the patches I send to netdev on
this, so the only time we find out that something breaks is after the
fact, and your patch shows that it takes many kernel revisions before
breakage is spotted.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
