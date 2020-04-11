Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C89A91A53F7
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 00:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgDKWoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 18:44:00 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:39340 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726108AbgDKWoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 18:44:00 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jNOqf-0001Xx-8g; Sun, 12 Apr 2020 00:43:37 +0200
Date:   Sun, 12 Apr 2020 00:43:37 +0200
From:   Florian Westphal <fw@strlen.de>
To:     syzbot <syzbot+6ebb6d4830e8f8815623@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.01.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [MPTCP] WARNING: bad unlock balance in mptcp_shutdown
Message-ID: <20200411224337.GA5795@breakpoint.cc>
References: <000000000000adb83a05a30aaa04@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000adb83a05a30aaa04@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> console output: https://syzkaller.appspot.com/x/log.txt?x=17a5dbfbe00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ca75979eeebf06c2
> dashboard link: https://syzkaller.appspot.com/bug?extid=6ebb6d4830e8f8815623
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+6ebb6d4830e8f8815623@syzkaller.appspotmail.com
> 
> =====================================
> WARNING: bad unlock balance detected!
> 5.6.0-syzkaller #0 Not tainted
> -------------------------------------
> syz-executor.5/2215 is trying to release lock (sk_lock-AF_INET6) at:
> [<ffffffff87c5203b>] mptcp_shutdown+0x38b/0x550 net/mptcp/protocol.c:1889
> but there are no more locks to release!
> 
> other info that might help us debug this:
> 1 lock held by syz-executor.5/2215:
>  #0: ffff88804a22eda0 (slock-AF_INET6){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:358 [inline]
>  #0: ffff88804a22eda0 (slock-AF_INET6){+.-.}-{2:2}, at: release_sock+0x1b/0x1b0 net/core/sock.c:2974

I think this is same issue as the other report, so:

#syz dup: WARNING: bad unlock balance in mptcp_poll
