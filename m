Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667613D0066
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 19:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhGTQ7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 12:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbhGTQ7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 12:59:05 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B0BC061767
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 10:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=glvbjE+OZ04203JSFuFumaFA1GmsdXekzju+Ko0NqaA=; b=TO08lEsgcz2PBOSPLNORa7CaY
        iPo5GEYPZdYHbyi52o8Q087Ga9zg8R9CFEPSdiQLFrEvyFeZDR5kMvblsJt7o/BI+/uR5phSnLVd9
        C9yk3TtbDBzLnr1ISSHlyGza+eycSf9oFqNXydJKYigyPUeAjxB8iriBcbFbBKe0s4IyykO5Z8uRi
        QQfPwNJqaiCH+K3gpvlE6AAEZYhFKLX5SigWeY5gT4KwZQlKJEcMXx/6PZY0LmktU5Tr5QyMDbTVw
        2ZxNtF3SO4yIdAOWHQQec0oUBMjlGCJM2emt4kS5d7E2hTFKyEdd70QJ4dGvxSyZcwNfp4hkOXI3e
        LpG6gNntA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46380)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m5tiX-0006hz-Td; Tue, 20 Jul 2021 18:39:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m5tiX-00076X-MO; Tue, 20 Jul 2021 18:39:41 +0100
Date:   Tue, 20 Jul 2021 18:39:41 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH RFC net-next] net: phy: marvell10g: add downshift tunable
 support
Message-ID: <20210720173941.GX22278@shell.armlinux.org.uk>
References: <E1m5pwy-0003uX-Pf@rmk-PC.armlinux.org.uk>
 <20210720170424.07cba755@dellmb>
 <20210720171401.GV22278@shell.armlinux.org.uk>
 <20210720193223.194cb79e@dellmb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210720193223.194cb79e@dellmb>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 07:32:23PM +0200, Marek Behún wrote:
> On Tue, 20 Jul 2021 18:14:01 +0100
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> 
> > On Tue, Jul 20, 2021 at 05:04:24PM +0200, Marek Behún wrote:
> > > Hi Russell,
> > > 
> > > On Tue, 20 Jul 2021 14:38:20 +0100
> > > Russell King <rmk+kernel@armlinux.org.uk> wrote:
> > >   
> > > > Add support for the downshift tunable for the Marvell 88x3310 PHY.
> > > > Downshift is only usable with firmware 0.3.5.0 and later.  
> > > 
> > > mv3310_{g,s}et_features are also used for 88E211x, but there is no
> > > such register in the documentation for these PHYs. (Also firmware
> > > versions on those are different, the newest is 8.3.0.0, but thats
> > > not important.) My solution would be to rename the current methods
> > > prefix to mv211x_ and and add new mv3310_{g,s}et_tunable methods.  
> > 
> > There's more than just the tunables themselves - there's also
> > config_init().
> > 
> > We already need to reject downshift when old firmware is running,
> > as that fails to work correctly. So, we can just do that for
> > 88E211x as well, adding a flag to struct mv3310_chip to indicate
> > whether downshift is present. Sound sensible?
> 
> Hmm, maybe add the flag to struct mv3310_priv, instead of struct
> mv3310_chip, since the latter is static. And fill in the flag in
> mv3310_probe() function, depending on firmware version?

I was intending to leave the firmware version check where it was and
just add a flag to say "this has downshift". The older firmwares on
3310 are basically buggy - they do downshift but only from 1G to 100M,
they fail to go to 10M.

> BTW would you agree with a patch renaming the mv3310_ prefixes to
> mv10g_ for all functions that are generic to both mv3310_ and mv2110_?
> I was thinking about such a thing because it has become rather
> confusing.

I've been thinking the same thing actually.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
