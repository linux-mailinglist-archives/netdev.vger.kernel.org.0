Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F46C2D69F6
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 22:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404908AbgLJVeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 16:34:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46428 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405038AbgLJVdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 16:33:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id D12494D2ED6E5;
        Thu, 10 Dec 2020 13:33:01 -0800 (PST)
Date:   Thu, 10 Dec 2020 13:33:01 -0800 (PST)
Message-Id: <20201210.133301.321052044098459280.davem@davemloft.net>
To:     w@1wt.eu
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        daniel@0x0f.com, alexandre.belloni@bootlin.com
Subject: Re: [PATCH] Revert "macb: support the two tx descriptors on
 at91rm9200"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201209184740.16473-1-w@1wt.eu>
References: <20201209184740.16473-1-w@1wt.eu>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 10 Dec 2020 13:33:02 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>
Date: Wed,  9 Dec 2020 19:47:40 +0100

> This reverts commit 0a4e9ce17ba77847e5a9f87eed3c0ba46e3f82eb.
> 
> The code was developed and tested on an MSC313E SoC, which seems to be
> half-way between the AT91RM9200 and the AT91SAM9260 in that it supports
> both the 2-descriptors mode and a Tx ring.
> 
> It turns out that after the code was merged I could notice that the
> controller would sometimes lock up, and only when dealing with sustained
> bidirectional transfers, in which case it would report a Tx overrun
> condition right after having reported being ready, and will stop sending
> even after the status is cleared (a down/up cycle fixes it though).
> 
> After adding lots of traces I couldn't spot a sequence pattern allowing
> to predict that this situation would happen. The chip comes with no
> documentation and other bits are often reported with no conclusive
> pattern either.
> 
> It is possible that my change is wrong just like it is possible that
> the controller on the chip is bogus or at least unpredictable based on
> existing docs from other chips. I do not have an RM9200 at hand to test
> at the moment and a few tests run on a more recent 9G20 indicate that
> this code path cannot be used there to test the code on a 3rd platform.
> 
> Since the MSC313E works fine in the single-descriptor mode, and that
> people using the old RM9200 very likely favor stability over performance,
> better revert this patch until we can test it on the original platform
> this part of the driver was written for. Note that the reverted patch
> was actually tested on MSC313E.
> 
> Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
> Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
> Cc: Daniel Palmer <daniel@0x0f.com>
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Link: https://lore.kernel.org/netdev/20201206092041.GA10646@1wt.eu/
> Signed-off-by: Willy Tarreau <w@1wt.eu>

Applied, thanks.
