Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61FE1472A2
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 21:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgAWUfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 15:35:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33864 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgAWUfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 15:35:32 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BE3B214EADFA6;
        Thu, 23 Jan 2020 12:35:30 -0800 (PST)
Date:   Thu, 23 Jan 2020 21:35:29 +0100 (CET)
Message-Id: <20200123.213529.793076422651134151.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+5af9a90dad568aa9f611@syzkaller.appspotmail.com,
        syzbot+2f07903a5b05e7f36410@syzkaller.appspotmail.com,
        eric.dumazet@gmail.com
Subject: Re: [Patch net] net_sched: fix datalen for ematch
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200122234203.15441-1-xiyou.wangcong@gmail.com>
References: <20200122234203.15441-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jan 2020 12:35:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Wed, 22 Jan 2020 15:42:02 -0800

> syzbot reported an out-of-bound access in em_nbyte. As initially
> analyzed by Eric, this is because em_nbyte sets its own em->datalen
> in em_nbyte_change() other than the one specified by user, but this
> value gets overwritten later by its caller tcf_em_validate().
> We should leave em->datalen untouched to respect their choices.
> 
> I audit all the in-tree ematch users, all of those implement
> ->change() set em->datalen, so we can just avoid setting it twice
> in this case.
> 
> Reported-and-tested-by: syzbot+5af9a90dad568aa9f611@syzkaller.appspotmail.com
> Reported-by: syzbot+2f07903a5b05e7f36410@syzkaller.appspotmail.com
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thanks.
