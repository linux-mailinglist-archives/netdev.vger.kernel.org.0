Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3A16A62AA
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 23:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjB1Wkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 17:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjB1Wkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 17:40:40 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21EF1B33B
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 14:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Dm/5O3gi7zNk1dTTBGhwJmfSoAwkksoFFz71QxRf3xg=; b=vfw3HFU7ajDyQxmNlTMZ1NwLYb
        YHyNbghvpM3sEKUOV5QWG+Bbok8zqOv8Y4kzYxKnZ1a8NbMg3Y84cfilKQ3TH1GzYF6jCf/U0WFM5
        j5neYAUby3kVCwfZWblPZsL35BZ4GEsfxlj43pYnWMynaVbrjjbqp+0Y0t6uMs9ThezCUtOBE0C/C
        +rdfe0YkMCIsUPPP9i23t+Ggv4JeMpzI6h6qNOATsKulsOuDJdEdjIgNiI36j66Tc3/B59Z0Ia4i5
        h3RbF82hd949pNK3bxNXF1g/BxgpgYni8C53tQFyxSEUBRdRgpE3rIssuYjMy0ZkKHrm0AiusD1Xj
        hQRmfI0A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41768)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pX8dk-0005Pc-7R; Tue, 28 Feb 2023 22:40:08 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pX8dh-00037i-9p; Tue, 28 Feb 2023 22:40:05 +0000
Date:   Tue, 28 Feb 2023 22:40:05 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <Y/6Cxf6EAAg22GOL@shell.armlinux.org.uk>
References: <20230227154037.7c775d4c@kmaincent-XPS-13-7390>
 <Y/zKJUHUhEgXjKFG@shell.armlinux.org.uk>
 <Y/0Idkhy27TObawi@hoboy.vegasvil.org>
 <Y/0N4ZcUl8pG7awc@shell.armlinux.org.uk>
 <Y/0QSphmMGXP5gYy@hoboy.vegasvil.org>
 <Y/3ubSj5+2C5xbZu@shell.armlinux.org.uk>
 <20230228141630.64d5ef63@kmaincent-XPS-13-7390>
 <Y/4ayPsZuYh+13eI@hoboy.vegasvil.org>
 <Y/4rXpPBbCbLqJLY@shell.armlinux.org.uk>
 <20230228142648.408f26c4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228142648.408f26c4@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 02:26:48PM -0800, Jakub Kicinski wrote:
> On Tue, 28 Feb 2023 16:27:10 +0000 Russell King (Oracle) wrote:
> > > 5. other?  
> > 
> > Another possible solution to this would be to introduce a rating for
> > each PTP clock in a similar way that we do for the kernel's
> > clocksources, and the one with the highest rating becomes the default. 
> 
> Why not ethtool? Sorry if I'm missing something obvious..

If we make the "default" fixed, such as "we always default to PHY"
then merge Marvell PHY PTP support, then on Macchiatobin, we will
end up switching from the current mvpp2-based PTP support to using
the inferior PHY PTP support, resulting in a loss of precision
and accuracy. That's a regression.

So, while we generally want PHY PTP support to be the default,
there are legitimate reasons for wanting in some circumstances
for the MAC to be the default.

The problem with an ethtool control is it's an extra step that
the user has to do to restore the accuracy that they had under
today's kernels, and I don't think that's something that they
should be involved in doing.

Providing controls to userspace is all very well _if_ there is
a way for users to make sensible decisions - which means giving
them information such as "on this hardware, MAC PTP is preferable
because it has better accuracy and precision, but on some other
hardware, PHY PTP is preferable" and such a document would get
very very long.

IMHO, it's better if the kernel automatically selects a sensible
default _and_ gives the user the ability to override it e.g. via
ethtool.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
