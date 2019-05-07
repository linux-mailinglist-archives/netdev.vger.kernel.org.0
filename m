Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD1916B56
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 21:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfEGT2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 15:28:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33308 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfEGT2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 15:28:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9A69014B79718;
        Tue,  7 May 2019 12:28:50 -0700 (PDT)
Date:   Tue, 07 May 2019 12:28:49 -0700 (PDT)
Message-Id: <20190507.122849.1270099594432351727.davem@davemloft.net>
To:     harini.katakam@xilinx.com
Cc:     nicolas.ferre@microchip.com, rafalo@cadence.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com
Subject: Re: [PATCH] net: macb: Change interrupt and napi enable order in
 open
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1557239350-4760-1-git-send-email-harini.katakam@xilinx.com>
References: <1557239350-4760-1-git-send-email-harini.katakam@xilinx.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 May 2019 12:28:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>
Date: Tue, 7 May 2019 19:59:10 +0530

> Current order in open:
> -> Enable interrupts (macb_init_hw)
> -> Enable NAPI
> -> Start PHY
> 
> Sequence of RX handling:
> -> RX interrupt occurs
> -> Interrupt is cleared and interrupt bits disabled in handler
> -> NAPI is scheduled
> -> In NAPI, RX budget is processed and RX interrupts are re-enabled
> 
> With the above, on QEMU or fixed link setups (where PHY state doesn't
> matter), there's a chance macb RX interrupt occurs before NAPI is
> enabled. This will result in NAPI being scheduled before it is enabled.
> Fix this macb open by changing the order.
> 
> Fixes: ae1f2a56d273 ("net: macb: Added support for many RX queues")
> Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>

Applied and queued up for -stable.
