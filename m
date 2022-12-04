Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C97D4641F03
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 19:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiLDS6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 13:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiLDS6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 13:58:16 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DDE13F04;
        Sun,  4 Dec 2022 10:58:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HMU5AHH9KKS1/AVVoeU+/FowDlxlFXjYr1vMNPrjg/E=; b=c/DZmo20g5S+4IX5mvuoBij6nG
        HDlYKukVVzQXUD/WhHzfLl/nBICffukblmqAF7Q8HG3zKFTpmJHOunLPI9wYJdDuGQ423U/pKtg1W
        fEqw9E81yT5UgQnPAlGeBmn/1BduNcKxAdGdYuj59NQG8+4/JgVAK3s1j11+fguaRXFU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p1uBj-004KzD-47; Sun, 04 Dec 2022 19:58:07 +0100
Date:   Sun, 4 Dec 2022 19:58:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 3/4] drivers/net/phy: Add driver for the onsemi
 NCN26000 10BASE-T1S PHY
Message-ID: <Y4ztv0mvMFEuLccG@lunn.ch>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
 <834be48779804c338f00f03002f31658d942546b.1670119328.git.piergiorgio.beruto@gmail.com>
 <Y4zQNHEkWQG+C/Oj@shell.armlinux.org.uk>
 <Y4zplu5hdrh8CvZ5@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4zplu5hdrh8CvZ5@gvm01>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +static int ncn26000_enable(struct phy_device *phydev)
> > > +{
> > 
> > This is actually the config_aneg() implementation, it should be named
> > as such.
> I can certainly rename it, however I did this for a reason. The NCN26000
> only supports P2MP mode. Therefore, it does not support AN (this is
> clearly indicated in the IEEE specifications as well).
> 
> However, it is my understanding that the config_aneg() callback is
> invoked also for PHYs that do not support AN, and this is actually the
> only way to set a link_control bit to have the PHY enable the PMA/PCS
> functions. So I thought to call this function "enable" to make it clear
> we're not really implementing autoneg, but link_control.

Anybody familiar with PHY drivers knows the name is not ideal, but
when they see config_aneg() they have a good idea what it does without
having to look at the code. All PHY drivers should have the same basic
structure, naming etc, just to make knowledge transfer between drivers
easy, maintenance easy, etc.

	Andrew
