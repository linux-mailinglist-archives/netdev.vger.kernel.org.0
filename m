Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1569D10DEA7
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 19:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfK3Soy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 13:44:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44022 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbfK3Sox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 13:44:53 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3:a597:786a:2aef:1599])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E9B2713CB3364;
        Sat, 30 Nov 2019 10:44:52 -0800 (PST)
Date:   Sat, 30 Nov 2019 10:44:52 -0800 (PST)
Message-Id: <20191130.104452.290995378176134973.davem@davemloft.net>
To:     dust.li@linux.alibaba.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        john.fastabend@gmail.com, tonylu@linux.alibaba.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: sched: fix `tc -s class show` no bstats on class
 with nolock subqueues
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191128062909.84666-1-dust.li@linux.alibaba.com>
References: <20191128062909.84666-1-dust.li@linux.alibaba.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 Nov 2019 10:44:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dust Li <dust.li@linux.alibaba.com>
Date: Thu, 28 Nov 2019 14:29:09 +0800

> When a classful qdisc's child qdisc has set the flag
> TCQ_F_CPUSTATS (pfifo_fast for example), the child qdisc's
> cpu_bstats should be passed to gnet_stats_copy_basic(),
> but many classful qdisc didn't do that. As a result,
> `tc -s class show dev DEV` always return 0 for bytes and
> packets in this case.
> 
> Pass the child qdisc's cpu_bstats to gnet_stats_copy_basic()
> to fix this issue.
> 
> The qstats also has this problem, but it has been fixed
> in 5dd431b6b9 ("net: sched: introduce and use qstats read...")
> and bstats still remains buggy.
> 
> Fixes: 22e0f8b9322c ("net: sched: make bstats per cpu and estimator RCU safe")
> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>

Applied and queued up for -stable.
