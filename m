Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE0D8186747
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 10:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbgCPJBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 05:01:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41186 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730369AbgCPJBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 05:01:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5118814648F08;
        Mon, 16 Mar 2020 02:01:01 -0700 (PDT)
Date:   Mon, 16 Mar 2020 02:01:00 -0700 (PDT)
Message-Id: <20200316.020100.467958998097459111.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+f9b32aaacd60305d9687@syzkaller.appspotmail.com,
        syzbot+2f8c233f131943d6056d@syzkaller.appspotmail.com,
        syzbot+9c2df9fd5e9445b74e01@syzkaller.appspotmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, john.fastabend@gmail.com
Subject: Re: [Patch net] net_sched: cls_route: remove the right filter from
 hashtable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200314052954.26885-1-xiyou.wangcong@gmail.com>
References: <20200314052954.26885-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Mar 2020 02:01:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Fri, 13 Mar 2020 22:29:54 -0700

> route4_change() allocates a new filter and copies values from
> the old one. After the new filter is inserted into the hash
> table, the old filter should be removed and freed, as the final
> step of the update.
> 
> However, the current code mistakenly removes the new one. This
> looks apparently wrong to me, and it causes double "free" and
> use-after-free too, as reported by syzbot.
> 
> Reported-and-tested-by: syzbot+f9b32aaacd60305d9687@syzkaller.appspotmail.com
> Reported-and-tested-by: syzbot+2f8c233f131943d6056d@syzkaller.appspotmail.com
> Reported-and-tested-by: syzbot+9c2df9fd5e9445b74e01@syzkaller.appspotmail.com
> Fixes: 1109c00547fc ("net: sched: RCU cls_route")
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thanks Cong.
