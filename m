Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA01641E36
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 18:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbiLDRZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 12:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiLDRZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 12:25:11 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB6110FC4;
        Sun,  4 Dec 2022 09:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MvoNu+9faBq3vPebtwFdjPGYYsL9BPsqHiP4qhDEpPg=; b=Pvudnvh58fnczY7xhx77dxo/Gd
        3oBgHycnCZWP3Q7HKDXZciTkj5dMSyxlIyJ4iLLJveHNMlv6tOf+WODyp7uwfFd5QTlAmTzQVlOX5
        yqSumFZUZPDgaFPQiekCSQ8BMm9QS4A/bxUbJqcdfOWaicFg3f0hnCKpZoZEzekgonXI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p1siT-004KeJ-Te; Sun, 04 Dec 2022 18:23:49 +0100
Date:   Sun, 4 Dec 2022 18:23:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 3/4] drivers/net/phy: Add driver for the onsemi
 NCN26000 10BASE-T1S PHY
Message-ID: <Y4zXpWEo5rJdNecG@lunn.ch>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
 <834be48779804c338f00f03002f31658d942546b.1670119328.git.piergiorgio.beruto@gmail.com>
 <Y4zQNHEkWQG+C/Oj@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4zQNHEkWQG+C/Oj@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +
> > +	// bring up the link (link_ctrl is mapped to BMCR_ANENABLE)
> > +	// clear also ISOLATE mode and Collision Test
> > +	return phy_write(phydev, MII_BMCR, BMCR_ANENABLE);
> 
> You always use AN even when ethtool turns off AN? If AN is mandatory,
> it seems there should be some way that phylib can force that to be
> the case.

Hi Russell

The comment is trying to explain that the bit BMCR_ANENABLE does not
actually mean Enable Autoneg. Since AN is not supported by T1S PHYs,
and the standard, some vendors have repurposed this bit.

Maybe we need BMCR_T1S_LINK_CTRL, local to this driver.

      Andrew
