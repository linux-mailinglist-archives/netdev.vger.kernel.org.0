Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653D22729A7
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 17:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgIUPMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 11:12:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47774 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbgIUPMt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 11:12:49 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kKNUY-00Fbpb-9v; Mon, 21 Sep 2020 17:12:34 +0200
Date:   Mon, 21 Sep 2020 17:12:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?5YqJ5YGJ5qyK?= <willy.liu@realtek.com>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Kyle Evans <kevans@FreeBSD.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ryan Kao <ryankao@realtek.com>,
        Joe Hershberger <joe.hershberger@ni.com>,
        Peter Robinson <pbrobinson@gmail.com>
Subject: Re: [PATCH] net: phy: realtek: fix rtl8211e rx/tx delay config
Message-ID: <20200921151234.GC3717417@lunn.ch>
References: <1600307253-3538-1-git-send-email-willy.liu@realtek.com>
 <20200917101035.uwajg4m524g4lz5o@mobilestation>
 <87c4ebf4b1fe48a7a10b27d0ba0b333c@realtek.com>
 <20200918135403.GC3631014@lunn.ch>
 <20200918153301.chwlvzh6a2bctbjw@mobilestation>
 <e14a0e96ddf8480591f98677cdca5e77@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e14a0e96ddf8480591f98677cdca5e77@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 07:00:00AM +0000, 劉偉權 wrote:
> Hi Andrew,

> I removed below register layout descriptions because these
> descriptions did not match register definitions for rtl8211e
> extension page 164 reg 0x1c at all.
> 8:6 = PHY Address
> 5:4 = Auto-Negotiation
> 3 = Mode
> 2 = RXD
> 1 = TXD
> 0 = SELRGV1

> I think it is a misunderstanding. These definitions are mapped from
> datasheet rtl8211e table13" Configuration Register
> Definition". However this table should be HW pin configurations not
> register descriptions.

So these are just how the device is strapped. So lets add that to the
description, rather than remove it.

> Users can config RXD/TXD via register setting(extension page 164 reg
> 0x1c). But bit map for these two settings should be below:
> 13 = Force Tx RX Delay controlled by bit12 bit11,
> 12 = RX Delay, 11 = TX Delay

> Hi Sergey,

> I saw the summary from https://reviews.freebsd.org/D13591. This
> patch is to reconfigure the RTL8211E used to force off TXD/RXD (RXD
> is defaulting to on, in my checks) and turn on some bits in the
> configuration register for this PHY that are undocumented.

> The default value for "extension pg 0xa4 reg 0x1c" is 0x8148, and
> bit1-2 should be 0. In my opinion, this patch should be worked based
> on the magic number (0xb400).

Magic numbers are always bad. Please document what these bits mean.

      Andrew
