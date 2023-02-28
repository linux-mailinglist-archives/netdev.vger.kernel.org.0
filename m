Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95BEF6A5A0D
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 14:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjB1Ngn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 08:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjB1Ngm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 08:36:42 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767CD279A7
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 05:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DxHpbPEvvEtASvMuak0wsJyk5U7PMQosqG3xB4FMaLw=; b=tT1I0a/INTa5dWmeIbKu4LMbOj
        k/LvSSmv2ex9dl+Kt4t4Am0q6ribw8DfRQO1R6N6u7UIBQdElbYMZTIJcQXggQ2fcbEBkCFO7sJPz
        SzeTor6TJc33wD4TSthnr6JkXBeurWtcnck77H8+euep1oFd9zuNjXKNnODoJDDi4LLmWXOhv5857
        fByyGoOpoLsvD3vE9tvZI//vmnFiIHRnH/yS1/754mv+UYCHsvhxHCFvS6nf7LLATD1Qtq3v9HbH2
        0TZDj50yyb2FsOHyXh/o7SjFx9RGcp6s3uiwFCxWx605jwpwtYtdzcL9EWceoETMmO784dD9RRsie
        aMufSzwA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55350)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pX09l-0004l9-Ry; Tue, 28 Feb 2023 13:36:37 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pX09k-0002lP-3S; Tue, 28 Feb 2023 13:36:36 +0000
Date:   Tue, 28 Feb 2023 13:36:36 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>
Cc:     Richard Cochran <richardcochran@gmail.com>, andrew@lunn.ch,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <Y/4DZIDm1d74MuFJ@shell.armlinux.org.uk>
References: <20200730124730.GY1605@shell.armlinux.org.uk>
 <20230227154037.7c775d4c@kmaincent-XPS-13-7390>
 <Y/zKJUHUhEgXjKFG@shell.armlinux.org.uk>
 <Y/0Idkhy27TObawi@hoboy.vegasvil.org>
 <Y/0N4ZcUl8pG7awc@shell.armlinux.org.uk>
 <Y/0QSphmMGXP5gYy@hoboy.vegasvil.org>
 <Y/3ubSj5+2C5xbZu@shell.armlinux.org.uk>
 <20230228141630.64d5ef63@kmaincent-XPS-13-7390>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230228141630.64d5ef63@kmaincent-XPS-13-7390>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 02:16:30PM +0100, Köry Maincent wrote:
> On Tue, 28 Feb 2023 12:07:09 +0000
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> > So yes, it's a nice idea to support multiple hardware timestamps, but
> > I think that's an entirely separate problem to solving the current
> > issue, which is a blocking issue to adding support for PTP on some
> > platforms.
> 
> Alright, Richard can I continue your work on it and send new revisions of your
> patch series or do you prefer to continue on your own?
> Also your series rise the question of which timestamping should be the default,
> MAC or PHY, without breaking any past or future compatibilities.
> There is question of using Kconfig or devicetree but each of them seems to have
> drawbacks:
> https://lore.kernel.org/netdev/ad4a8d3efbeaacf241a19bfbca5976f9@walle.cc/ 
> 
> Do you or Russell have any new thought about it?

The only thought I have is that maybe a MAC driver should be able to
override the default, then at least we have a way to deal with this
on a case by case basis. However, that's just pulling an idea out of
the air.

I think what might be useful as a first step is to go through the
various networking devices to work out which support PTP today, and
tabulate the result. There shouldn't be any cases where we have both
the MAC and PHY having PTP support (for the API reasons I've already
stated) but if there are, that needs to be highlighted.

Then we can see what the default should be, and then which MAC
drivers would need to override the default.

It would probably be a good idea to document that in the kernel's
Documentation subdirectory so when e.g. a PHY driver gains PTP
support, we have some idea which MAC drivers may be impacted.

Does that sound sensible?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
