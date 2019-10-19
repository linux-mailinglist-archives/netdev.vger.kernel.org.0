Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6B07DDA90
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 20:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfJSS7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 14:59:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42474 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfJSS7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 14:59:20 -0400
Received: from localhost (unknown [64.79.112.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 115A2148FDE8B;
        Sat, 19 Oct 2019 11:59:20 -0700 (PDT)
Date:   Sat, 19 Oct 2019 11:59:19 -0700 (PDT)
Message-Id: <20191019.115919.1355675870258176623.davem@davemloft.net>
To:     m.tretter@pengutronix.de
Cc:     nicolas.ferre@microchip.com, netdev@vger.kernel.org
Subject: Re: [PATCH] macb: propagate errors when getting optional clocks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191018141143.24148-1-m.tretter@pengutronix.de>
References: <20191018141143.24148-1-m.tretter@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 19 Oct 2019 11:59:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Tretter <m.tretter@pengutronix.de>
Date: Fri, 18 Oct 2019 16:11:43 +0200

> The tx_clk, rx_clk, and tsu_clk are optional. Currently the macb driver
> marks clock as not available if it receives an error when trying to get
> a clock. This is wrong, because a clock controller might return
> -EPROBE_DEFER if a clock is not available, but will eventually become
> available.
> 
> In these cases, the driver would probe successfully but will never be
> able to adjust the clocks, because the clocks were not available during
> probe, but became available later.
> 
> For example, the clock controller for the ZynqMP is implemented in the
> PMU firmware and the clocks are only available after the firmware driver
> has been probed.
> 
> Use devm_clk_get_optional() in instead of devm_clk_get() to get the
> optional clock and propagate all errors to the calling function.
> 
> Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>

Applied, thanks.
