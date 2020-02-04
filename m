Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB461518FB
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 11:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgBDKoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 05:44:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41744 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgBDKoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 05:44:01 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E737812142F5D;
        Tue,  4 Feb 2020 02:43:59 -0800 (PST)
Date:   Tue, 04 Feb 2020 11:43:50 +0100 (CET)
Message-Id: <20200204.114350.708501156293848185.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+35d4dea36c387813ed31@syzkaller.appspotmail.com,
        eric.dumazet@gmail.com, john.fastabend@gmail.com, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org
Subject: Re: [Patch net v2] net_sched: fix an OOB access in cls_tcindex
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200203051435.11272-1-xiyou.wangcong@gmail.com>
References: <20200203051435.11272-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Feb 2020 02:44:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Sun,  2 Feb 2020 21:14:35 -0800

> As Eric noticed, tcindex_alloc_perfect_hash() uses cp->hash
> to compute the size of memory allocation, but cp->hash is
> set again after the allocation, this caused an out-of-bound
> access.
> 
> So we have to move all cp->hash initialization and computation
> before the memory allocation. Move cp->mask and cp->shift together
> as cp->hash may need them for computation too.
> 
> Reported-and-tested-by: syzbot+35d4dea36c387813ed31@syzkaller.appspotmail.com
> Fixes: 331b72922c5f ("net: sched: RCU cls_tcindex")
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thanks Cong.
