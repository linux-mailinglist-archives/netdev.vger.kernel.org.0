Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6716A9BD4
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 17:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjCCQes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 11:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbjCCQer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 11:34:47 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77151630D
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 08:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3HytLgINGNu3oNUPqpI3b6iGjGDjoL/18R46bwjDZ+g=; b=pY64JrmycwZI5Ow8hO82vMv6r6
        n+pTWQnLCwiqiU38slvdfxWgsanextD4Ba6zhwp08CoqXjF8odkKw6dwR/EvO83tcgXy8zC5sCTr9
        fXpFzyGWkD7t/TOYcA8PtZI2HtNR8oDz16MhaCV1wyK4IMiuVeIPBLnVX5CYuAKC1/fU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pY8Md-006OeU-6e; Fri, 03 Mar 2023 17:34:35 +0100
Date:   Fri, 3 Mar 2023 17:34:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Michael Walle <michael@walle.cc>, davem@davemloft.net,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        kory.maincent@bootlin.com, kuba@kernel.org,
        maxime.chevallier@bootlin.com, netdev@vger.kernel.org,
        richardcochran@gmail.com, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <0c0df176-1fbb-43d5-9fb0-358b3873f4e0@lunn.ch>
References: <ZADcSwvmwt8jYxWD@shell.armlinux.org.uk>
 <20230303102005.442331-1-michael@walle.cc>
 <ZAH0FIrZL9Wf4gvp@lunn.ch>
 <ZAH+F6GCCXfzeR+6@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAH+F6GCCXfzeR+6@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > 4) Some solution to the default choice if there is no DT property.
> 
> I thought (4) was what we have been discussing... but the problem
> seems to be that folk want to drill down into the fine detail about
> whether PHY or MAC timestamping is better than the other.
> 
> As I've already stated, I doubt DT maintainers will wear having a
> DT property for this, on the grounds that it's very much a software
> control rather than a hardware description.

We can argue it is describing the hardware. In that hardware blob X
has a better implementation of PTP than hardware blob Y. That could be
because of the basic features of the blob, like resolution, adjustable
clocks, or board specific features, like temperature compensated
crystals, etc.

There could also be a linkage to the default choice. If we go with the
idea of giving each PTP stamper a quality indicator, and the highest
quality wins, we can have the DT property change this quality property
because it knows of external things, like the lack of a temperature
compensated crystal.

	Andrew
