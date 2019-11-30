Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0914B10DF32
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 21:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfK3UWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 15:22:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44820 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfK3UWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 15:22:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3:a597:786a:2aef:1599])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C9DD144B304A;
        Sat, 30 Nov 2019 12:22:42 -0800 (PST)
Date:   Sat, 30 Nov 2019 12:22:39 -0800 (PST)
Message-Id: <20191130.122239.1812288224681402502.davem@davemloft.net>
To:     dust.li@linux.alibaba.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        john.fastabend@gmail.com, tonylu@linux.alibaba.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: sched: keep __gnet_stats_copy_xxx() same
 semantics for percpu stats
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191128063048.90282-1-dust.li@linux.alibaba.com>
References: <20191128063048.90282-1-dust.li@linux.alibaba.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 Nov 2019 12:22:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dust Li <dust.li@linux.alibaba.com>
Date: Thu, 28 Nov 2019 14:30:48 +0800

> __gnet_stats_copy_basic/queue() support both percpu stat and
> non-percpu stat, but they are handle in a different manner:
> 1. For percpu stat, percpu stats are added to the return value;
> 2. For non-percpu stat, non-percpu stats will overwrite the
>    return value;
> We should keep the same semantics for both type.
> 
> This patch makes percpu stats follow non-percpu's manner by
> reset the return bstats before add the percpu bstats to it.
> Also changes the caller in sch_mq.c/sch_mqprio.c to make sure
> they dump the right statistics for percpu qdisc.
> 
> One more thing, the sch->q.qlen is not set with nonlock child
> qdisc in mq_dump()/mqprio_dump(), add that.
> 
> Fixes: 22e0f8b9322c ("net: sched: make bstats per cpu and estimator RCU safe")
> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>

You are changing way too many things at one time here.

Fix one bug in one patch, for example just fix the missed
initialization of the per-cpu stats.

The qlen fix is another patch.

And so on and so forth.

Thank you.
