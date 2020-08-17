Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2213245B47
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 06:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgHQEEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 00:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgHQEEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 00:04:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBD7C061388
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 21:04:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6104D125007E8;
        Sun, 16 Aug 2020 20:47:19 -0700 (PDT)
Date:   Sun, 16 Aug 2020 21:04:04 -0700 (PDT)
Message-Id: <20200816.210404.1864176276185744630.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+0e7181deafa7e0b79923@syzkaller.appspotmail.com,
        jmaloy@redhat.com, ying.xue@windriver.com,
        richard.alpe@ericsson.com
Subject: Re: [Patch net] tipc: fix uninit skb->data in
 tipc_nl_compat_dumpit()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200815232915.17625-1-xiyou.wangcong@gmail.com>
References: <20200815232915.17625-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Aug 2020 20:47:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Sat, 15 Aug 2020 16:29:15 -0700

> __tipc_nl_compat_dumpit() has two callers, and it expects them to
> pass a valid nlmsghdr via arg->data. This header is artificial and
> crafted just for __tipc_nl_compat_dumpit().
> 
> tipc_nl_compat_publ_dump() does so by putting a genlmsghdr as well
> as some nested attribute, TIPC_NLA_SOCK. But the other caller
> tipc_nl_compat_dumpit() does not, this leaves arg->data uninitialized
> on this call path.
> 
> Fix this by just adding a similar nlmsghdr without any payload in
> tipc_nl_compat_dumpit().
> 
> This bug exists since day 1, but the recent commit 6ea67769ff33
> ("net: tipc: prepare attrs in __tipc_nl_compat_dumpit()") makes it
> easier to appear.
> 
> Reported-and-tested-by: syzbot+0e7181deafa7e0b79923@syzkaller.appspotmail.com
> Fixes: d0796d1ef63d ("tipc: convert legacy nl bearer dump to nl compat")
> Cc: Jon Maloy <jmaloy@redhat.com>
> Cc: Ying Xue <ying.xue@windriver.com>
> Cc: Richard Alpe <richard.alpe@ericsson.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thanks.
