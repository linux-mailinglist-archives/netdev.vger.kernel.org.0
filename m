Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEAE2CD8F6
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 15:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730797AbgLCOWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 09:22:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36516 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725967AbgLCOWq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 09:22:46 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkpUf-00A31F-07; Thu, 03 Dec 2020 15:22:01 +0100
Date:   Thu, 3 Dec 2020 15:22:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20201203142200.GF2333853@lunn.ch>
References: <20201202140904.24748-1-o.rempel@pengutronix.de>
 <20201202140904.24748-3-o.rempel@pengutronix.de>
 <20201202104207.697cfdbb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201203085011.GA3606@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203085011.GA3606@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @Andrew
> 
> > You could update the stats here, after the interface is down. You then
> > know the stats are actually up to date and correct!
> 
> stats are automatically read on __dev_notify_flags(), for example here:
> 
> [   11.049289] [<80069ce0>] show_stack+0x9c/0x140
> [   11.053651] [<804eea2c>] ar9331_get_stats64+0x38/0x394
> [   11.058820] [<80526584>] dev_get_stats+0x58/0xfc
> [   11.063385] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
> [   11.068293] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
> [   11.073274] [<8054a4d4>] rtmsg_ifinfo_build_skb+0xbc/0x134
> [   11.078799] [<8054a5d4>] rtmsg_ifinfo_event+0x4c/0x84
> [   11.083782] [<8054a6c8>] rtmsg_ifinfo+0x2c/0x38
> [   11.088378] [<80534380>] __dev_notify_flags+0x50/0xd8
> [   11.093365] [<80534ca0>] dev_change_flags+0x60/0x80
> [   11.098273] [<80c13fa4>] ic_close_devs+0xcc/0xdc
> [   11.102810] [<80c15200>] ip_auto_config+0x1144/0x11e4
> [   11.107847] [<80060f14>] do_one_initcall+0x110/0x2b4
> [   11.112871] [<80bf31bc>] kernel_init_freeable+0x220/0x258
> [   11.118248] [<80739a2c>] kernel_init+0x24/0x11c
> [   11.122707] [<8006306c>] ret_from_kernel_thread+0x14/0x1c
> 
> Do we really need an extra read within the ar9331 driver?

Ah, did not know that. Nice, Somebody solved this for all drivers at
once.

   Andrew
