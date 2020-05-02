Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139C31C2901
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 01:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgEBXmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 19:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbgEBXmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 19:42:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB025C061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 16:42:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7228615166937;
        Sat,  2 May 2020 16:42:20 -0700 (PDT)
Date:   Sat, 02 May 2020 16:42:19 -0700 (PDT)
Message-Id: <20200502.164219.774099040080742203.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, fugang.duan@nxp.com, cphealy@gmail.com
Subject: Re: [PATCH net-next v5] net: ethernet: fec: Replace interrupt
 driven MDIO with polled IO
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200502152504.154401-1-andrew@lunn.ch>
References: <20200502152504.154401-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 02 May 2020 16:42:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sat,  2 May 2020 17:25:04 +0200

> Measurements of the MDIO bus have shown that driving the MDIO bus
> using interrupts is slow. Back to back MDIO transactions take about
> 90us, with 25us spent performing the transaction, and the remainder of
> the time the bus is idle.
> 
> Replacing the completion interrupt with polled IO results in back to
> back transactions of 40us. The polling loop waiting for the hardware
> to complete the transaction takes around 28us. Which suggests
> interrupt handling has an overhead of 50us, and polled IO nearly
> halves this overhead, and doubles the MDIO performance.
> 
> Care has to be taken when setting the MII_SPEED register, or it can
> trigger an MII event> That then upsets the polling, due to an
> unexpected pending event.
> 
> Suggested-by: Chris Heally <cphealy@gmail.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: David S. Miller <davem@davemloft.net>

Applied, thanks Andrew.
