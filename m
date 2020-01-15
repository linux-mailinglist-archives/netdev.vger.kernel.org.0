Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C578113D0D1
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 00:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731249AbgAOXyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 18:54:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40228 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729016AbgAOXyD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 18:54:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vZVudi2gBuyHBZjmOkQ+epG4bVJAbZTvIrxTIDCHEJc=; b=g7IWQlXltCA0UdQn0qVVxvlIE1
        SKL7IPC5l1obdNuFHrw0x61WK7HrHXVqVZ2YDKFP3vxUq7j67oJsR2r0G26xh2zqTM2qqHfgL342Y
        FF9o5dRTDOmBcfgGx60WuiDJPeSdRydnKCfQGLFa7MOLQbQMJR8QC70t5uSY3bj85IcE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1irsU1-0002WZ-4N; Thu, 16 Jan 2020 00:53:57 +0100
Date:   Thu, 16 Jan 2020 00:53:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, cphealy@gmail.com,
        rmk+kernel@armlinux.org.uk, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: phy: Maintain MDIO device and bus
 statistics
Message-ID: <20200115235357.GG2475@lunn.ch>
References: <20200115204228.26094-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115204228.26094-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#define MDIO_BUS_STATS_ADDR_ATTR(field, addr, file)			\
> +static ssize_t mdio_bus_##field##_##addr##_show(struct device *dev,	\
> +						struct device_attribute *attr, \
> +						char *buf)		\
> +{									\
> +	struct mii_bus *bus = to_mii_bus(dev);				\
> +	return mdio_bus_stats_##field##_show(&bus->stats[addr], buf);	\
> +}									\

Hi Florian

Lots of Macro magic here. But it is reasonably understandable.
However, the compiler is maybe not doing the best of jobs:

00000064 l     F .text	00000030 mdio_bus_reads_31_show
00000094 l     F .text	00000030 mdio_bus_reads_30_show
000000c4 l     F .text	00000030 mdio_bus_reads_29_show
000000f4 l     F .text	00000030 mdio_bus_reads_28_show
00000124 l     F .text	00000030 mdio_bus_reads_27_show
00000154 l     F .text	00000030 mdio_bus_reads_26_show
00000184 l     F .text	00000030 mdio_bus_reads_25_show
000001b4 l     F .text	00000034 mdio_bus_reads_24_show
000001e8 l     F .text	00000034 mdio_bus_reads_23_show
0000021c l     F .text	00000034 mdio_bus_reads_22_show
00000250 l     F .text	00000034 mdio_bus_reads_21_show
00000284 l     F .text	00000034 mdio_bus_reads_20_show
000002b8 l     F .text	00000034 mdio_bus_reads_19_show
000002ec l     F .text	00000034 mdio_bus_reads_18_show
00000320 l     F .text	00000034 mdio_bus_reads_17_show
00000354 l     F .text	00000034 mdio_bus_reads_16_show
00000388 l     F .text	00000034 mdio_bus_reads_15_show
000003bc l     F .text	00000034 mdio_bus_reads_14_show
000003f0 l     F .text	00000034 mdio_bus_reads_13_show
00000424 l     F .text	00000034 mdio_bus_reads_12_show
00000458 l     F .text	00000034 mdio_bus_reads_11_show
0000048c l     F .text	00000034 mdio_bus_reads_10_show
000004c0 l     F .text	00000034 mdio_bus_reads_9_show
000004f4 l     F .text	00000034 mdio_bus_reads_8_show
00000528 l     F .text	00000034 mdio_bus_reads_7_show
0000055c l     F .text	00000034 mdio_bus_reads_6_show
00000590 l     F .text	00000034 mdio_bus_reads_5_show
000005c4 l     F .text	00000034 mdio_bus_reads_4_show
000005f8 l     F .text	00000034 mdio_bus_reads_3_show
0000062c l     F .text	00000034 mdio_bus_reads_2_show
00000660 l     F .text	00000034 mdio_bus_reads_1_show
00000694 l     F .text	00000034 mdio_bus_reads_0_show

It appears to be inlining everything, so end up with lots of
functions, and they are not tiny.

I'm wondering if we can get ride of this per address
reads/write/transfer function. Could you stuff the addr into var of
struct dev_ext_attribute?

https://elixir.bootlin.com/linux/latest/source/include/linux/device.h#L813

	Andrew
