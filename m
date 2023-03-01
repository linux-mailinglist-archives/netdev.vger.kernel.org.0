Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2B96A7070
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 17:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjCAQEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 11:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjCAQEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 11:04:14 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDA02A6C2
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 08:04:12 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id EC5B91C001A;
        Wed,  1 Mar 2023 16:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1677686650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=umyygrqr9kaSn7MPST+N4UxWo9CNyqYjg3Kwsw7SZe8=;
        b=WR8bW3PMLnRIiwYZ4JYoljwMTCSr2FeQxpB3iVSeI/yzLe0TRtF2BbQijTvPI5V4HhV8s8
        vTUOp8hUZYFWfnJypLldFvR5FMg+/DAe0w+fkDdVg7/cBLVz9Zd3EznQ048ds0B9V4t4ci
        cvs3rMfIhh7/IN3nP4lR9z6glEQa5Wyr5zy3Sdh+uROQ4roRq0HRxasPktyJ8C9b8Htw2p
        zMLaUS9ZfirlH6V+H3QywcRA2X0oO/6/3XE4eeEFcK6gqGywkOoWxlhdORrlSjk/EiJIcV
        50UAdkJkvfsWA8WpR/XEHMuLimT9z1Wy1ecmWAiLuzZEdePUiB+keoIo2/MjPw==
Date:   Wed, 1 Mar 2023 17:04:08 +0100
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>, andrew@lunn.ch,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <20230301170408.0cc0519d@kmaincent-XPS-13-7390>
In-Reply-To: <20230228145911.2df60a9f@kernel.org>
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
        <Y/6Cxf6EAAg22GOL@shell.armlinux.org.uk>
        <20230228145911.2df60a9f@kernel.org>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Feb 2023 14:59:11 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Tue, 28 Feb 2023 22:40:05 +0000 Russell King (Oracle) wrote:
> > IMHO, it's better if the kernel automatically selects a sensible
> > default _and_ gives the user the ability to override it e.g. via
> > ethtool.  
> 
> Oh, I see, makes sense.

I suppose the idea of Russell to rate each PTP clocks may be the best one, as
all others solutions have drawbacks. Does using the PTP clock period value (in
picoseconds) is enough to decide which PTP is the best one? It is hardware
specific therefore it is legitimate to be set by the MAC and PHY drivers.

Regards,
