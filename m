Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DDA54D0AA
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 20:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357817AbiFOSIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 14:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346928AbiFOSH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 14:07:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA4517E01
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 11:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GYUACeooAo5O3nT8nJvw8QyjL+BrQ+jo2wWpKiZ3T0M=; b=zo7w8Vv/IL35Z8MEhe8QPPk1cI
        eA0sXupl+URK+V3OfSLB+rgzW5lFbydmDhJ+66JOmeZBkcQzVGg7ot1bC8GuVt/vprL0SXaWfzahv
        yqRqQY1InPtK9wyb1mKCoiUnMbvLxpBh8dQku7qUo8P/OwmFmyKt4ZB1Qqa0I4x5cRHF4TChRXitk
        mniUdkx11Mkms9lee2jTjeUD225KwjEO8i1IoarjXYUziAFjo2b081weutnU7E8WvOyP8I5ge8YjF
        mcg9glvqm80vBvC9syq9nYi3hhlAQZQSOFSFoXoAm5oI/8QcMLv7gw+P1U7yvZM8hScyr937hxds3
        JSHLCe1A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32882)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o1XQZ-0004qh-NK; Wed, 15 Jun 2022 19:07:39 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o1XQS-0000AQ-SW; Wed, 15 Jun 2022 19:07:32 +0100
Date:   Wed, 15 Jun 2022 19:07:32 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 02/15] net: phylink: add phylink_pcs_inband()
Message-ID: <Yqof5IHYlI9NDWKK@shell.armlinux.org.uk>
References: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
 <E1o0jgF-000JYC-49@rmk-PC.armlinux.org.uk>
 <20220614224652.09d4c287@kernel.org>
 <YqmVdj4X5101PC1u@shell.armlinux.org.uk>
 <20220615104652.591f5e98@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615104652.591f5e98@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 10:46:52AM -0700, Jakub Kicinski wrote:
> On Wed, 15 Jun 2022 09:16:54 +0100 Russell King (Oracle) wrote:
> > > Patch 1 does not need to be backported so I presume it can lose the
> > > fixes tag?  
> > 
> > As the commit talks about fixing something, in my experience the commit
> > will get automatically selected for backporting to stable trees whether
> > or not it has a fixes tag on it. The only way to stop that happening is
> > not through avoiding a fixes tag, but to keep on top of the stable tree
> > emails to stop patches being backported that don't need to be.
> > 
> > If you still want me to remove it, I will, but I predict it will still
> > be backported.
> 
> Fair, but the argument is not very... "clean", if you will. I read the
> argument as "the unwelcome thing is likely to happen anyway, so doesn't
> matter". But Fixes serves no purpose here, since we don't expect the
> backport. So we are defaulting to adding something useless on the basis
> of it not making things worse?

I think it's a point of view; I do absolutely expect the backport to
happen irrespective of whether there's a Fixes there or not - which
I base on all the patches that have been automatically selected
seemingly just because the commit message talks about fixing something.

I am up for trying an experiment - I'll get rid of the Fixes: tag, and
we'll see whether -stable picks the patch up anyway!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
