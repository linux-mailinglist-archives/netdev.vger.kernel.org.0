Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7CDD6F0A40
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 18:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243361AbjD0QvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 12:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243673AbjD0QvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 12:51:00 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A134AE53
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 09:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iGwLgUMRiyzYPWnS+fbXMRCIB5fkIOpgRljc3493flg=; b=cytzrua7dNDKrWfkEX7BqUkQLe
        DPL5x8W6QaECnOGMYDY7zMZRRSp7Loi/cZyEhKZw7ps3K6ktHBTgjw3iGoUour7Go1oq9aKqO95gb
        bVi0vwLV2qqxVAvaLl+gbunlTgqwSHAUkgbeiNtV/i6tH/iGa4ZI9wB2Vq9RCcHjFIcM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ps4pT-00BMjB-Cg; Thu, 27 Apr 2023 18:50:47 +0200
Date:   Thu, 27 Apr 2023 18:50:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org, richardcochran@gmail.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <8ad8c6ce-1a3e-4f80-84c8-d6921613cbb9@lunn.ch>
References: <20200730124730.GY1605@shell.armlinux.org.uk>
 <20230227154037.7c775d4c@kmaincent-XPS-13-7390>
 <Y/zKJUHUhEgXjKFG@shell.armlinux.org.uk>
 <20230427171306.2bfd824a@kmaincent-XPS-13-7390>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427171306.2bfd824a@kmaincent-XPS-13-7390>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> As we are currently moving forward on PTP core to resolve this issue, I would
> like to investigate your PHY PTP patch in parallel. Indeed it does not work very
> well on my side.
> 
> The PTP UDP v4 and v6 work only if I add "--tx_timestamp_timeout 20" and the
> PTP IEEE 802.3 (802.1AS) does not work at all.
> On PTP IEEE 802.3 network transport ("ptp4l -2") I get continuously rx timestamp
> overrun:
> Marvell 88E1510 ff0d0000.ethernet-ffffffff:01: rx timestamp overrun (5)
> Marvell 88E1510 ff0d0000.ethernet-ffffffff:01: rx timestamp overrun (5)
> 
> I know it's been a long time but does it ring a bell on your memory?

How are you talking to the PHY? I had issues with slow MDIO busses,
especially those embedded within an Ethernet switch. You end up with
MDIO over MDIO which has a lot of latency. I _think_ i added some
patches to ptp4l to deal with this, but i forget exactly what landed.

	Andrew
