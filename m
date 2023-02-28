Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B9B6A58D7
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 13:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbjB1MHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 07:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbjB1MHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 07:07:18 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C5D2ED72
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 04:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0BCP96rUdXQKWmQ4SqWfqwRjuo8z9pcHgIezhPCFYSg=; b=nLB846dq28ZWV/pTUedMQAXwkv
        Akz9/e5/0BjMngiFRmxiR/qJmzznG77ig1MztKe7WOjaOxv+9H5P53lAX2SKNNpTOedmouCNtgkAk
        pQ2TjluCGC/GCCm6s1fPwqeJkoBFmG/q8K3+AcK+l6Mgo9342SlPH1f+q+fKfNXjTxcqu9eL+q4rM
        nCwU+BUOlUnL06yDZyvZsJz52HEtSKLllK1XsrzLnU7zQTasLu88u320NWsKn2iaqXNY4AtaFIFZt
        yjFb9SGPMzz0iF4ETQ459U0oTpQlZWcPHJ2+/zslsLFeeouMuklNnflQ8NLToiNyZAuTYVWN0vmw/
        WhjxNnZw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43392)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pWylE-0004eC-4O; Tue, 28 Feb 2023 12:07:12 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pWylB-0002hR-2R; Tue, 28 Feb 2023 12:07:09 +0000
Date:   Tue, 28 Feb 2023 12:07:09 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <Y/3ubSj5+2C5xbZu@shell.armlinux.org.uk>
References: <20200730124730.GY1605@shell.armlinux.org.uk>
 <20230227154037.7c775d4c@kmaincent-XPS-13-7390>
 <Y/zKJUHUhEgXjKFG@shell.armlinux.org.uk>
 <Y/0Idkhy27TObawi@hoboy.vegasvil.org>
 <Y/0N4ZcUl8pG7awc@shell.armlinux.org.uk>
 <Y/0QSphmMGXP5gYy@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/0QSphmMGXP5gYy@hoboy.vegasvil.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 12:19:22PM -0800, Richard Cochran wrote:
> On Mon, Feb 27, 2023 at 08:09:05PM +0000, Russell King (Oracle) wrote:
> 
> > Looking at that link, I'm only seeing that message, with none of
> > the patches nor the discussion. Digging back in my mailbox, I
> > find that the patches weren't threaded to the cover message, which
> > makes it quite difficult to go back and review the discussion.
> 
> Sorry about that.  By accident I omitted --thread=shallow that time.
> 
> > Looking back briefly at the discussion on patch 3, was the reason
> > this approach died due to the request to have something more flexible,
> > supporting multiple hardware timestamps per packet?
> 
> I still think the approach will work, but I guess I got distracted
> with other stuff and forgot about it.
> 
> The "multiple hardware timestamps per packet" is a nice idea, but it
> would require a new user API, and so selectable MAC/PHY on the
> existing API is still needed.

I agree - even when we have support for multiple hardware timestamps,
we still need the existing API to work in a sensible way, and we need
a way to choose which hardware timestamp we want the existing API to
report.

So yes, it's a nice idea to support multiple hardware timestamps, but
I think that's an entirely separate problem to solving the current
issue, which is a blocking issue to adding support for PTP on some
platforms.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
