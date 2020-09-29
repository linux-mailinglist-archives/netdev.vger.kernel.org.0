Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF8E27D75E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 21:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbgI2T4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 15:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727700AbgI2T4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 15:56:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0ECC061755;
        Tue, 29 Sep 2020 12:56:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8F76B13B07A75;
        Tue, 29 Sep 2020 12:39:45 -0700 (PDT)
Date:   Tue, 29 Sep 2020 12:56:32 -0700 (PDT)
Message-Id: <20200929.125632.1592891495047804335.davem@davemloft.net>
To:     willy.liu@realtek.com
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        kuba@kernel.org, fancer.lancer@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevans@FreeBSD.org,
        ryankao@realtek.com
Subject: Re: [PATCH net v4] net: phy: realtek: fix rtl8211e rx/tx delay
 config
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1601345449-14676-1-git-send-email-willy.liu@realtek.com>
References: <1601345449-14676-1-git-send-email-willy.liu@realtek.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 29 Sep 2020 12:39:46 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willy Liu <willy.liu@realtek.com>
Date: Tue, 29 Sep 2020 10:10:49 +0800

> There are two chip pins named TXDLY and RXDLY which actually adds the 2ns
> delays to TXC and RXC for TXD/RXD latching. These two pins can config via
> 4.7k-ohm resistor to 3.3V hw setting, but also config via software setting
> (extension page 0xa4 register 0x1c bit13 12 and 11).
> 
> The configuration register definitions from table 13 official PHY datasheet:
> PHYAD[2:0] = PHY Address
> AN[1:0] = Auto-Negotiation
> Mode = Interface Mode Select
> RX Delay = RX Delay
> TX Delay = TX Delay
> SELRGV = RGMII/GMII Selection
> 
> This table describes how to config these hw pins via external pull-high or pull-
> low resistor.
> 
> It is a misunderstanding that mapping it as register bits below:
> 8:6 = PHY Address
> 5:4 = Auto-Negotiation
> 3 = Interface Mode Select
> 2 = RX Delay
> 1 = TX Delay
> 0 = SELRGV
> So I removed these descriptions above and add related settings as below:
> 14 = reserved
> 13 = force Tx RX Delay controlled by bit12 bit11
> 12 = Tx Delay
> 11 = Rx Delay
> 10:0 = Test && debug settings reserved by realtek
> 
> Test && debug settings are not recommend to modify by default.
> 
> Fixes: f81dadbcf7fd ("net: phy: realtek: Add rtl8211e rx/tx delays config")
> Signed-off-by: Willy Liu <willy.liu@realtek.com>

Applied and queued up for -stable, thank you.
