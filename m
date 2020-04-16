Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3D31AD1AE
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 23:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgDPVEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 17:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726320AbgDPVEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 17:04:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C18C061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 14:04:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B44B71275AE17;
        Thu, 16 Apr 2020 14:04:03 -0700 (PDT)
Date:   Thu, 16 Apr 2020 14:04:02 -0700 (PDT)
Message-Id: <20200416.140402.1289729188604088162.davem@davemloft.net>
To:     bigeasy@linutronix.de
Cc:     netdev@vger.kernel.org, thomas.lendacky@amd.com,
        tglx@linutronix.de, eric.dumazet@gmail.com
Subject: Re: [PATCH net] amd-xgbe: Use __napi_schedule() in BH context
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200416155740.o3mzl7c73g4xkrmr@linutronix.de>
References: <20200416155740.o3mzl7c73g4xkrmr@linutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 Apr 2020 14:04:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Thu, 16 Apr 2020 17:57:40 +0200

> The driver uses __napi_schedule_irqoff() which is fine as long as it is
> invoked with disabled interrupts by everybody. Since the commit
> mentioned below the driver may invoke xgbe_isr_task() in tasklet/softirq
> context. This may lead to list corruption if another driver uses
> __napi_schedule_irqoff() in IRQ context.
> 
> Use __napi_schedule() which safe to use from IRQ and softirq context.
> 
> Fixes: 85b85c853401d ("amd-xgbe: Re-issue interrupt if interrupt status not cleared")
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

Applied and queued up for -stable, thanks.
