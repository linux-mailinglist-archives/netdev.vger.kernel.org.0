Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162366299FC
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 14:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbiKONWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 08:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiKONWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 08:22:51 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87A1DF65;
        Tue, 15 Nov 2022 05:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Uj14LxRdZq+uBK+ju+dmVEZiLu1x+H1PhPrIAZjtMXg=; b=aq1WPFvqCEhY6zptBuQtTxRoHu
        wHAQp40fjk5hJaBGFCqKT2lpsa44Up74ljupeKind7DCoEwpzNMvpKVoUOg3ibb/0Tfdp4CnFqryy
        86EUEYRYFke7MUS77ehCjYyDjaH0XG/1inVnabbr710bl35avNBJVnlQimaykcHC7FJQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ouvsr-002Sbt-P6; Tue, 15 Nov 2022 14:21:49 +0100
Date:   Tue, 15 Nov 2022 14:21:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev@kapio-technology.com
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 0/2] mv88e6xxx: Add MAB offload support
Message-ID: <Y3OSbZs6Ho07D6Yx@lunn.ch>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <Y3NcOYvCkmcRufIn@shredder>
 <5559fa646aaad7551af9243831b48408@kapio-technology.com>
 <20221115102833.ahwnahrqstcs2eug@skbuf>
 <7c02d4f14e59a6e26431c086a9bb9643@kapio-technology.com>
 <20221115111034.z5bggxqhdf7kbw64@skbuf>
 <0cd30d4517d548f35042a535fd994831@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cd30d4517d548f35042a535fd994831@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:00] driver [Generic
> PHY] (irq=POLL)

It is interesting it is using the generic PHY driver, not the Marvell
PHY driver. 

> mv88e6085 1002b000.ethernet-1:04 eth6 (uninitialized): PHY
> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:01] driver [Generic
> PHY] (irq=POLL)
> mv88e6085 1002b000.ethernet-1:04 eth9 (uninitialized): PHY
> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:02] driver [Generic
> PHY] (irq=POLL)
> mv88e6085 1002b000.ethernet-1:04 eth5 (uninitialized): PHY
> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:03] driver [Generic
> PHY] (irq=POLL)
> mv88e6085 1002b000.ethernet-1:04 eth8 (uninitialized): PHY
> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:04] driver [Generic
> PHY] (irq=POLL)
> mv88e6085 1002b000.ethernet-1:04 eth4 (uninitialized): PHY
> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:05] driver [Generic
> PHY] (irq=POLL)
> mv88e6085 1002b000.ethernet-1:04 eth7 (uninitialized): PHY
> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:06] driver [Generic
> PHY] (irq=POLL)
> mv88e6085 1002b000.ethernet-1:04 eth3 (uninitialized): PHY
> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:07] driver [Generic
> PHY] (irq=POLL)
> mv88e6085 1002b000.ethernet-1:04 eth2 (uninitialized): PHY
> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdioe:08] driver
> [Marvell 88E1112] (irq=174)
> mv88e6085 1002b000.ethernet-1:04 eth1 (uninitialized): PHY
> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdioe:09] driver
> [Marvell 88E1112] (irq=175)

And here it does use the Marvell PHY driver. Are ports 8 and 9
external, where as the others are internal?

    Andrew
