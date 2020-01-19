Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC026141FA8
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 19:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbgASSum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 13:50:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46122 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbgASSum (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jan 2020 13:50:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+dklvkM+nB0DNACPMHU2f0gGUtyaBW/KLRfkJCSPJIE=; b=efQwYnVJXs7Y+UqbMGlOMDQ26K
        VMc7Za6REtseAR341ySVgWHhT/fpr7kME2cuItotJjGrEFA/F4gjHHHICGti1GrUfeylCYETPxYiz
        KzvWJEY35LgZEiX4BLseyEYUXokuISIei7wMbh7L4gk4KW3eMMjPnKen9v73DzPilfrE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1itFed-00053I-3V; Sun, 19 Jan 2020 19:50:35 +0100
Date:   Sun, 19 Jan 2020 19:50:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] net: phy: add generic ndo_do_ioctl handler
 phy_do_ioctl
Message-ID: <20200119185035.GC17720@lunn.ch>
References: <520c07a1-dd26-1414-0a2f-7f0d491589d1@gmail.com>
 <20200119161240.GA17720@lunn.ch>
 <97389eb0-fc7f-793b-6f84-730e583c00e9@googlemail.com>
 <20200119175109.GB17720@lunn.ch>
 <c1f7d8ce-2bc2-5141-9f28-a659d2af4e10@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1f7d8ce-2bc2-5141-9f28-a659d2af4e10@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Also it seems we don't consider situations like runtime PM yet.
> Then the MDIO bus may not be accessible, but ndev is running
> and PHY is attached.

I don't think this can happen. If the device is running, the MDIO bus
has to work, or phylib is broken.

I have had issue with the FEC, runtime PM and MDIO, but that was when
the interface was not running, but an Ethernet switch was using the
MDIO bus. MDIO transactions would time out, until i made the MDIO
operations PM aware.

But in general, we should keep the running test, just to avoid
breakage of assumptions we don't know about.

	 Andrew
