Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E37514430
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 06:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725851AbfEFEzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 00:55:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59840 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfEFEzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 00:55:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 37D8912DAF003;
        Sun,  5 May 2019 21:55:43 -0700 (PDT)
Date:   Sun, 05 May 2019 21:55:42 -0700 (PDT)
Message-Id: <20190505.215542.197859649563578060.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, edumazet@google.com
Subject: Re: [Patch net-next v2] sch_htb: redefine htb qdisc overlimits
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190504184342.1094-1-xiyou.wangcong@gmail.com>
References: <20190504184342.1094-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 21:55:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Sat,  4 May 2019 11:43:42 -0700

> In commit 3c75f6ee139d ("net_sched: sch_htb: add per class overlimits counter")
> we added an overlimits counter for each HTB class which could
> properly reflect how many times we use up all the bandwidth
> on each class. However, the overlimits counter in HTB qdisc
> does not, it is way bigger than the sum of each HTB class.
> In fact, this qdisc overlimits counter increases when we have
> no skb to dequeue, which happens more often than we run out of
> bandwidth.
> 
> It makes more sense to make this qdisc overlimits counter just
> be a sum of each HTB class, in case people still get confused.
> 
> I have verified this patch with one single HTB class, where HTB
> qdisc counters now always match HTB class counters as expected.
> 
> Eric suggested we could fold this field into 'direct_pkts' as
> we only use its 32bit on 64bit CPU, this saves one cache line.
> 
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied.
