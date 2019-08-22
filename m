Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 144CF989B6
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 05:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730698AbfHVDF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 23:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727910AbfHVDF6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 23:05:58 -0400
Received: from zzz.localdomain (unknown [67.218.105.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DF9E22CE3;
        Thu, 22 Aug 2019 03:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566443151;
        bh=DnEAnCFHnSweMrjsSTiXNXx2bG4JKH5yAYytDjuqSGM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SJYyBLjB2+v5oYe2xDq3qTmDppaRuZ94AQGtKmQhDNAnEo4cgkqXT5Mn9JDQT/v2Y
         umnBkgZOp28tW1l23HsS1Bc/YM9Bt3Ef0L/lU90dpN5ItwFl7o5xkjPXqGqgvXnH3g
         IiRcg8Op0MmfMtr064B6veLJXBEzDVED91c/Z93U=
Date:   Wed, 21 Aug 2019 20:05:49 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     syzbot <syzbot+5f97459a05652f579f6c@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, jon.maloy@ericsson.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Subject: Re: BUG: MAX_STACK_TRACE_ENTRIES too low in tipc_topsrv_exit_net
Message-ID: <20190822030549.GA6111@zzz.localdomain>
Mail-Followup-To: syzbot <syzbot+5f97459a05652f579f6c@syzkaller.appspotmail.com>,
        davem@davemloft.net, jon.maloy@ericsson.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
References: <00000000000071c72c0590776357@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000071c72c0590776357@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 05:22:07AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    5181b473 net: phy: realtek: add NBase-T PHY auto-detection
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=156b731c600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d4cf1ffb87d590d7
> dashboard link: https://syzkaller.appspot.com/bug?extid=5f97459a05652f579f6c
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+5f97459a05652f579f6c@syzkaller.appspotmail.com
> 
> BUG: MAX_STACK_TRACE_ENTRIES too low!
> turning off the locking correctness validator.
> CPU: 0 PID: 2581 Comm: kworker/u4:4 Not tainted 5.3.0-rc3+ #132
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: netns cleanup_net
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
>  save_trace kernel/locking/lockdep.c:473 [inline]
>  save_trace.isra.0.cold+0x14/0x19 kernel/locking/lockdep.c:458
>  mark_lock+0x3db/0x11e0 kernel/locking/lockdep.c:3583
>  mark_usage kernel/locking/lockdep.c:3517 [inline]
>  __lock_acquire+0x538/0x4c30 kernel/locking/lockdep.c:3834
>  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4412
>  flush_workqueue+0x126/0x14b0 kernel/workqueue.c:2774
>  drain_workqueue+0x1b4/0x470 kernel/workqueue.c:2939
>  destroy_workqueue+0x21/0x6c0 kernel/workqueue.c:4320
>  tipc_topsrv_work_stop net/tipc/topsrv.c:636 [inline]
>  tipc_topsrv_stop net/tipc/topsrv.c:694 [inline]
>  tipc_topsrv_exit_net+0x3fe/0x5d8 net/tipc/topsrv.c:706
>  ops_exit_list.isra.0+0xaa/0x150 net/core/net_namespace.c:172
>  cleanup_net+0x4e2/0xa70 net/core/net_namespace.c:594
>  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
>  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
>  kthread+0x361/0x430 kernel/kthread.c:255
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> kobject: 'rx-0' (000000000e2c91cd): kobject_cleanup, parent 000000002003fefb
> kobject: 'rx-0' (000000000e2c91cd): auto cleanup 'remove' event
> kobject: 'rx-0' (000000000e2c91cd): kobject_uevent_env
> kobject: 'rx-0' (000000000e2c91cd): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000000e2c91cd): auto cleanup kobject_del
> kobject: 'rx-0' (000000000e2c91cd): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (0000000058b6f726): kobject_cleanup, parent 000000002003fefb
> kobject: 'tx-0' (0000000058b6f726): auto cleanup 'remove' event
> kobject: 'tx-0' (0000000058b6f726): kobject_uevent_env
> kobject: 'tx-0' (0000000058b6f726): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (0000000058b6f726): auto cleanup kobject_del
> kobject: 'tx-0' (0000000058b6f726): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000002003fefb): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (000000002003fefb): calling ktype release
> kobject: 'queues' (000000002003fefb): kset_release
> kobject: 'queues': free name
> kobject: 'ip6gre0' (0000000018a24d65): kobject_uevent_env
> kobject: 'ip6gre0' (0000000018a24d65): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000940b22b0): kobject_cleanup, parent 0000000005a1fc3a
> kobject: 'rx-0' (00000000940b22b0): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000940b22b0): kobject_uevent_env
> kobject: 'rx-0' (00000000940b22b0): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000940b22b0): auto cleanup kobject_del
> kobject: 'rx-0' (00000000940b22b0): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000278e85e2): kobject_cleanup, parent 0000000005a1fc3a
> kobject: 'tx-0' (00000000278e85e2): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000278e85e2): kobject_uevent_env
> kobject: 'tx-0' (00000000278e85e2): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000278e85e2): auto cleanup kobject_del
> kobject: 'tx-0' (00000000278e85e2): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (0000000005a1fc3a): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (0000000005a1fc3a): calling ktype release
> kobject: 'queues' (0000000005a1fc3a): kset_release
> kobject: 'queues': free name
> kobject: 'ip6gre0' (00000000c78b955b): kobject_uevent_env
> kobject: 'ip6gre0' (00000000c78b955b): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000000fa7c1d1): kobject_cleanup, parent 00000000d264d5b4
> kobject: 'rx-0' (000000000fa7c1d1): auto cleanup 'remove' event
> kobject: 'rx-0' (000000000fa7c1d1): kobject_uevent_env
> kobject: 'rx-0' (000000000fa7c1d1): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000000fa7c1d1): auto cleanup kobject_del
> kobject: 'rx-0' (000000000fa7c1d1): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (000000000f66c80c): kobject_cleanup, parent 00000000d264d5b4
> kobject: 'tx-0' (000000000f66c80c): auto cleanup 'remove' event
> kobject: 'tx-0' (000000000f66c80c): kobject_uevent_env
> kobject: 'tx-0' (000000000f66c80c): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (000000000f66c80c): auto cleanup kobject_del
> kobject: 'tx-0' (000000000f66c80c): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (00000000d264d5b4): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (00000000d264d5b4): calling ktype release
> kobject: 'queues' (00000000d264d5b4): kset_release
> kobject: 'queues': free name
> kobject: 'ip6gre0' (00000000ef80dc29): kobject_uevent_env
> kobject: 'ip6gre0' (00000000ef80dc29): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000f928d911): kobject_cleanup, parent 000000003c7c9951
> kobject: 'rx-0' (00000000f928d911): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000f928d911): kobject_uevent_env
> kobject: 'rx-0' (00000000f928d911): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000f928d911): auto cleanup kobject_del
> kobject: 'rx-0' (00000000f928d911): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (000000009bf7cc90): kobject_cleanup, parent 000000003c7c9951
> kobject: 'tx-0' (000000009bf7cc90): auto cleanup 'remove' event
> kobject: 'tx-0' (000000009bf7cc90): kobject_uevent_env
> kobject: 'tx-0' (000000009bf7cc90): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (000000009bf7cc90): auto cleanup kobject_del
> kobject: 'tx-0' (000000009bf7cc90): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000003c7c9951): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (000000003c7c9951): calling ktype release
> kobject: 'queues' (000000003c7c9951): kset_release
> kobject: 'queues': free name
> kobject: 'ip6gre0' (00000000acb4e121): kobject_uevent_env
> kobject: 'ip6gre0' (00000000acb4e121): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (0000000045fca4e1): kobject_cleanup, parent 000000001c9d9e42
> kobject: 'rx-0' (0000000045fca4e1): auto cleanup 'remove' event
> kobject: 'rx-0' (0000000045fca4e1): kobject_uevent_env
> kobject: 'rx-0' (0000000045fca4e1): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (0000000045fca4e1): auto cleanup kobject_del
> kobject: 'rx-0' (0000000045fca4e1): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000a309e805): kobject_cleanup, parent 000000001c9d9e42
> kobject: 'tx-0' (00000000a309e805): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000a309e805): kobject_uevent_env
> kobject: 'tx-0' (00000000a309e805): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000a309e805): auto cleanup kobject_del
> kobject: 'tx-0' (00000000a309e805): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000001c9d9e42): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (000000001c9d9e42): calling ktype release
> kobject: 'queues' (000000001c9d9e42): kset_release
> kobject: 'queues': free name
> kobject: 'ip6gre0' (0000000094fbf7bb): kobject_uevent_env
> kobject: 'ip6gre0' (0000000094fbf7bb): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000443242e0): kobject_cleanup, parent 000000009f9df3e8
> kobject: 'rx-0' (00000000443242e0): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000443242e0): kobject_uevent_env
> kobject: 'rx-0' (00000000443242e0): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000443242e0): auto cleanup kobject_del
> kobject: 'rx-0' (00000000443242e0): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (000000005588ef99): kobject_cleanup, parent 000000009f9df3e8
> kobject: 'tx-0' (000000005588ef99): auto cleanup 'remove' event
> kobject: 'tx-0' (000000005588ef99): kobject_uevent_env
> kobject: 'tx-0' (000000005588ef99): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (000000005588ef99): auto cleanup kobject_del
> kobject: 'tx-0' (000000005588ef99): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000009f9df3e8): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (000000009f9df3e8): calling ktype release
> kobject: 'queues' (000000009f9df3e8): kset_release
> kobject: 'queues': free name
> kobject: 'ip6gre0' (0000000060028093): kobject_uevent_env
> kobject: 'ip6gre0' (0000000060028093): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (0000000002c2db56): kobject_cleanup, parent 000000000ee23264
> kobject: 'rx-0' (0000000002c2db56): auto cleanup 'remove' event
> kobject: 'rx-0' (0000000002c2db56): kobject_uevent_env
> kobject: 'rx-0' (0000000002c2db56): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (0000000002c2db56): auto cleanup kobject_del
> kobject: 'rx-0' (0000000002c2db56): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000831daf90): kobject_cleanup, parent 000000000ee23264
> kobject: 'tx-0' (00000000831daf90): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000831daf90): kobject_uevent_env
> kobject: 'tx-0' (00000000831daf90): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000831daf90): auto cleanup kobject_del
> kobject: 'tx-0' (00000000831daf90): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000000ee23264): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (000000000ee23264): calling ktype release
> kobject: 'queues' (000000000ee23264): kset_release
> kobject: 'queues': free name
> kobject: 'ip6gre0' (00000000e217374d): kobject_uevent_env
> kobject: 'ip6gre0' (00000000e217374d): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000f8e7f44b): kobject_cleanup, parent 000000003daaa7c9
> kobject: 'rx-0' (00000000f8e7f44b): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000f8e7f44b): kobject_uevent_env
> kobject: 'rx-0' (00000000f8e7f44b): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000f8e7f44b): auto cleanup kobject_del
> kobject: 'rx-0' (00000000f8e7f44b): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (000000001277c9de): kobject_cleanup, parent 000000003daaa7c9
> kobject: 'tx-0' (000000001277c9de): auto cleanup 'remove' event
> kobject: 'tx-0' (000000001277c9de): kobject_uevent_env
> kobject: 'tx-0' (000000001277c9de): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (000000001277c9de): auto cleanup kobject_del
> kobject: 'tx-0' (000000001277c9de): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000003daaa7c9): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (000000003daaa7c9): calling ktype release
> kobject: 'queues' (000000003daaa7c9): kset_release
> kobject: 'queues': free name
> kobject: 'ip6gre0' (00000000597e3c0a): kobject_uevent_env
> kobject: 'ip6gre0' (00000000597e3c0a): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000eb376580): kobject_cleanup, parent 0000000054d719cb
> kobject: 'rx-0' (00000000eb376580): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000eb376580): kobject_uevent_env
> kobject: 'rx-0' (00000000eb376580): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000eb376580): auto cleanup kobject_del
> kobject: 'rx-0' (00000000eb376580): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (0000000040024191): kobject_cleanup, parent 0000000054d719cb
> kobject: 'tx-0' (0000000040024191): auto cleanup 'remove' event
> kobject: 'tx-0' (0000000040024191): kobject_uevent_env
> kobject: 'tx-0' (0000000040024191): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (0000000040024191): auto cleanup kobject_del
> kobject: 'tx-0' (0000000040024191): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (0000000054d719cb): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (0000000054d719cb): calling ktype release
> kobject: 'queues' (0000000054d719cb): kset_release
> kobject: 'queues': free name
> kobject: 'ip6gre0' (00000000995a4c19): kobject_uevent_env
> kobject: 'ip6gre0' (00000000995a4c19): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'ip6gre0' (0000000018a24d65): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6gre0' (0000000018a24d65): calling ktype release
> kobject: 'ip6gre0': free name
> kobject: 'ip6gre0' (00000000c78b955b): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6gre0' (00000000c78b955b): calling ktype release
> kobject: 'ip6gre0': free name
> kobject: 'ip6gre0' (00000000ef80dc29): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6gre0' (00000000ef80dc29): calling ktype release
> kobject: 'ip6gre0': free name
> kobject: 'ip6gre0' (00000000acb4e121): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6gre0' (00000000acb4e121): calling ktype release
> kobject: 'ip6gre0': free name
> kobject: 'ip6gre0' (0000000094fbf7bb): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6gre0' (0000000094fbf7bb): calling ktype release
> kobject: 'ip6gre0': free name
> kobject: 'ip6gre0' (0000000060028093): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6gre0' (0000000060028093): calling ktype release
> kobject: 'ip6gre0': free name
> kobject: 'ip6gre0' (00000000e217374d): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6gre0' (00000000e217374d): calling ktype release
> kobject: 'ip6gre0': free name
> kobject: 'ip6gre0' (00000000597e3c0a): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6gre0' (00000000597e3c0a): calling ktype release
> kobject: 'ip6gre0': free name
> kobject: 'ip6gre0' (00000000995a4c19): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6gre0' (00000000995a4c19): calling ktype release
> kobject: 'ip6gre0': free name
> kobject: 'rx-0' (00000000a530319b): kobject_cleanup, parent 0000000044c197cb
> kobject: 'rx-0' (00000000a530319b): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000a530319b): kobject_uevent_env
> kobject: 'rx-0' (00000000a530319b): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000a530319b): auto cleanup kobject_del
> kobject: 'rx-0' (00000000a530319b): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (0000000036817586): kobject_cleanup, parent 0000000044c197cb
> kobject: 'tx-0' (0000000036817586): auto cleanup 'remove' event
> kobject: 'tx-0' (0000000036817586): kobject_uevent_env
> kobject: 'tx-0' (0000000036817586): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (0000000036817586): auto cleanup kobject_del
> kobject: 'tx-0' (0000000036817586): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (0000000044c197cb): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (0000000044c197cb): calling ktype release
> kobject: 'queues' (0000000044c197cb): kset_release
> kobject: 'queues': free name
> kobject: 'ip6tnl0' (000000004d7cdca9): kobject_uevent_env
> kobject: 'ip6tnl0' (000000004d7cdca9): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000009ad0ffcd): kobject_cleanup, parent 000000006632a50a
> kobject: 'rx-0' (000000009ad0ffcd): auto cleanup 'remove' event
> kobject: 'rx-0' (000000009ad0ffcd): kobject_uevent_env
> kobject: 'rx-0' (000000009ad0ffcd): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000009ad0ffcd): auto cleanup kobject_del
> kobject: 'rx-0' (000000009ad0ffcd): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000cc8f7d89): kobject_cleanup, parent 000000006632a50a
> kobject: 'tx-0' (00000000cc8f7d89): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000cc8f7d89): kobject_uevent_env
> kobject: 'tx-0' (00000000cc8f7d89): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000cc8f7d89): auto cleanup kobject_del
> kobject: 'tx-0' (00000000cc8f7d89): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000006632a50a): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (000000006632a50a): calling ktype release
> kobject: 'queues' (000000006632a50a): kset_release
> kobject: 'queues': free name
> kobject: 'ip6tnl0' (00000000af12a50a): kobject_uevent_env
> kobject: 'ip6tnl0' (00000000af12a50a): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000000f3a002b): kobject_cleanup, parent 000000008e667009
> kobject: 'rx-0' (000000000f3a002b): auto cleanup 'remove' event
> kobject: 'rx-0' (000000000f3a002b): kobject_uevent_env
> kobject: 'rx-0' (000000000f3a002b): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000000f3a002b): auto cleanup kobject_del
> kobject: 'rx-0' (000000000f3a002b): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (000000003dd814d2): kobject_cleanup, parent 000000008e667009
> kobject: 'tx-0' (000000003dd814d2): auto cleanup 'remove' event
> kobject: 'tx-0' (000000003dd814d2): kobject_uevent_env
> kobject: 'tx-0' (000000003dd814d2): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (000000003dd814d2): auto cleanup kobject_del
> kobject: 'tx-0' (000000003dd814d2): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000008e667009): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (000000008e667009): calling ktype release
> kobject: 'queues' (000000008e667009): kset_release
> kobject: 'queues': free name
> kobject: 'ip6tnl0' (00000000ad24f481): kobject_uevent_env
> kobject: 'ip6tnl0' (00000000ad24f481): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000b57b4b94): kobject_cleanup, parent 00000000c8f88c97
> kobject: 'rx-0' (00000000b57b4b94): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000b57b4b94): kobject_uevent_env
> kobject: 'rx-0' (00000000b57b4b94): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000b57b4b94): auto cleanup kobject_del
> kobject: 'rx-0' (00000000b57b4b94): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000035a9b1c): kobject_cleanup, parent 00000000c8f88c97
> kobject: 'tx-0' (00000000035a9b1c): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000035a9b1c): kobject_uevent_env
> kobject: 'tx-0' (00000000035a9b1c): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000035a9b1c): auto cleanup kobject_del
> kobject: 'tx-0' (00000000035a9b1c): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (00000000c8f88c97): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (00000000c8f88c97): calling ktype release
> kobject: 'queues' (00000000c8f88c97): kset_release
> kobject: 'queues': free name
> kobject: 'ip6tnl0' (00000000e4871037): kobject_uevent_env
> kobject: 'ip6tnl0' (00000000e4871037): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000009e5eabee): kobject_cleanup, parent 000000000bef0c44
> kobject: 'rx-0' (000000009e5eabee): auto cleanup 'remove' event
> kobject: 'rx-0' (000000009e5eabee): kobject_uevent_env
> kobject: 'rx-0' (000000009e5eabee): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000009e5eabee): auto cleanup kobject_del
> kobject: 'rx-0' (000000009e5eabee): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000917837d7): kobject_cleanup, parent 000000000bef0c44
> kobject: 'tx-0' (00000000917837d7): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000917837d7): kobject_uevent_env
> kobject: 'tx-0' (00000000917837d7): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000917837d7): auto cleanup kobject_del
> kobject: 'tx-0' (00000000917837d7): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000000bef0c44): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (000000000bef0c44): calling ktype release
> kobject: 'queues' (000000000bef0c44): kset_release
> kobject: 'queues': free name
> kobject: 'ip6tnl0' (00000000a48d6ad0): kobject_uevent_env
> kobject: 'ip6tnl0' (00000000a48d6ad0): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (0000000099277526): kobject_cleanup, parent 0000000085f382c3
> kobject: 'rx-0' (0000000099277526): auto cleanup 'remove' event
> kobject: 'rx-0' (0000000099277526): kobject_uevent_env
> kobject: 'rx-0' (0000000099277526): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (0000000099277526): auto cleanup kobject_del
> kobject: 'rx-0' (0000000099277526): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000e28e65a5): kobject_cleanup, parent 0000000085f382c3
> kobject: 'tx-0' (00000000e28e65a5): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000e28e65a5): kobject_uevent_env
> kobject: 'tx-0' (00000000e28e65a5): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000e28e65a5): auto cleanup kobject_del
> kobject: 'tx-0' (00000000e28e65a5): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (0000000085f382c3): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (0000000085f382c3): calling ktype release
> kobject: 'queues' (0000000085f382c3): kset_release
> kobject: 'queues': free name
> kobject: 'ip6tnl0' (000000002480b06a): kobject_uevent_env
> kobject: 'ip6tnl0' (000000002480b06a): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000ad1f374e): kobject_cleanup, parent 000000004552107a
> kobject: 'rx-0' (00000000ad1f374e): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000ad1f374e): kobject_uevent_env
> kobject: 'rx-0' (00000000ad1f374e): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000ad1f374e): auto cleanup kobject_del
> kobject: 'rx-0' (00000000ad1f374e): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000a52c4930): kobject_cleanup, parent 000000004552107a
> kobject: 'tx-0' (00000000a52c4930): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000a52c4930): kobject_uevent_env
> kobject: 'tx-0' (00000000a52c4930): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000a52c4930): auto cleanup kobject_del
> kobject: 'tx-0' (00000000a52c4930): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000004552107a): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (000000004552107a): calling ktype release
> kobject: 'queues' (000000004552107a): kset_release
> kobject: 'queues': free name
> kobject: 'ip6tnl0' (00000000b5c75a98): kobject_uevent_env
> kobject: 'ip6tnl0' (00000000b5c75a98): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (0000000069cf2cec): kobject_cleanup, parent 000000000effb6b7
> kobject: 'rx-0' (0000000069cf2cec): auto cleanup 'remove' event
> kobject: 'rx-0' (0000000069cf2cec): kobject_uevent_env
> kobject: 'rx-0' (0000000069cf2cec): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (0000000069cf2cec): auto cleanup kobject_del
> kobject: 'rx-0' (0000000069cf2cec): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000f6dd67a1): kobject_cleanup, parent 000000000effb6b7
> kobject: 'tx-0' (00000000f6dd67a1): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000f6dd67a1): kobject_uevent_env
> kobject: 'tx-0' (00000000f6dd67a1): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000f6dd67a1): auto cleanup kobject_del
> kobject: 'tx-0' (00000000f6dd67a1): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000000effb6b7): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (000000000effb6b7): calling ktype release
> kobject: 'queues' (000000000effb6b7): kset_release
> kobject: 'queues': free name
> kobject: 'ip6tnl0' (0000000017bab338): kobject_uevent_env
> kobject: 'ip6tnl0' (0000000017bab338): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000005bed9a62): kobject_cleanup, parent 000000002a90c11d
> kobject: 'rx-0' (000000005bed9a62): auto cleanup 'remove' event
> kobject: 'rx-0' (000000005bed9a62): kobject_uevent_env
> kobject: 'rx-0' (000000005bed9a62): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000005bed9a62): auto cleanup kobject_del
> kobject: 'rx-0' (000000005bed9a62): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000148a89bb): kobject_cleanup, parent 000000002a90c11d
> kobject: 'tx-0' (00000000148a89bb): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000148a89bb): kobject_uevent_env
> kobject: 'tx-0' (00000000148a89bb): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000148a89bb): auto cleanup kobject_del
> kobject: 'tx-0' (00000000148a89bb): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000002a90c11d): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (000000002a90c11d): calling ktype release
> kobject: 'queues' (000000002a90c11d): kset_release
> kobject: 'queues': free name
> kobject: 'ip6tnl0' (000000007855542e): kobject_uevent_env
> kobject: 'ip6tnl0' (000000007855542e): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'ip6tnl0' (000000004d7cdca9): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6tnl0' (000000004d7cdca9): calling ktype release
> kobject: 'ip6tnl0': free name
> kobject: 'ip6tnl0' (00000000af12a50a): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6tnl0' (00000000af12a50a): calling ktype release
> kobject: 'ip6tnl0': free name
> kobject: 'ip6tnl0' (00000000ad24f481): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6tnl0' (00000000ad24f481): calling ktype release
> kobject: 'ip6tnl0': free name
> kobject: 'ip6tnl0' (00000000e4871037): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6tnl0' (00000000e4871037): calling ktype release
> kobject: 'ip6tnl0': free name
> kobject: 'ip6tnl0' (00000000a48d6ad0): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6tnl0' (00000000a48d6ad0): calling ktype release
> kobject: 'ip6tnl0': free name
> kobject: 'ip6tnl0' (000000002480b06a): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6tnl0' (000000002480b06a): calling ktype release
> kobject: 'ip6tnl0': free name
> kobject: 'ip6tnl0' (00000000b5c75a98): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6tnl0' (00000000b5c75a98): calling ktype release
> kobject: 'ip6tnl0': free name
> kobject: 'ip6tnl0' (0000000017bab338): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6tnl0' (0000000017bab338): calling ktype release
> kobject: 'ip6tnl0': free name
> kobject: 'ip6tnl0' (000000007855542e): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6tnl0' (000000007855542e): calling ktype release
> kobject: 'ip6tnl0': free name
> kobject: 'rx-0' (00000000faff8a75): kobject_cleanup, parent 000000003555e997
> kobject: 'rx-0' (00000000faff8a75): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000faff8a75): kobject_uevent_env
> kobject: 'rx-0' (00000000faff8a75): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000faff8a75): auto cleanup kobject_del
> kobject: 'rx-0' (00000000faff8a75): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (000000003377944b): kobject_cleanup, parent 000000003555e997
> kobject: 'tx-0' (000000003377944b): auto cleanup 'remove' event
> kobject: 'tx-0' (000000003377944b): kobject_uevent_env
> kobject: 'tx-0' (000000003377944b): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (000000003377944b): auto cleanup kobject_del
> kobject: 'tx-0' (000000003377944b): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000003555e997): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (000000003555e997): calling ktype release
> kobject: 'queues' (000000003555e997): kset_release
> kobject: 'queues': free name
> kobject: 'sit0' (00000000ba6470e9): kobject_uevent_env
> kobject: 'sit0' (00000000ba6470e9): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000003577adaa): kobject_cleanup, parent 00000000c5fbab92
> kobject: 'rx-0' (000000003577adaa): auto cleanup 'remove' event
> kobject: 'rx-0' (000000003577adaa): kobject_uevent_env
> kobject: 'rx-0' (000000003577adaa): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000003577adaa): auto cleanup kobject_del
> kobject: 'rx-0' (000000003577adaa): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000f519527f): kobject_cleanup, parent 00000000c5fbab92
> kobject: 'tx-0' (00000000f519527f): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000f519527f): kobject_uevent_env
> kobject: 'tx-0' (00000000f519527f): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000f519527f): auto cleanup kobject_del
> kobject: 'tx-0' (00000000f519527f): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (00000000c5fbab92): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (00000000c5fbab92): calling ktype release
> kobject: 'queues' (00000000c5fbab92): kset_release
> kobject: 'queues': free name
> kobject: 'sit0' (000000009f74c826): kobject_uevent_env
> kobject: 'sit0' (000000009f74c826): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000137dfc9e): kobject_cleanup, parent 00000000e8ee822b
> kobject: 'rx-0' (00000000137dfc9e): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000137dfc9e): kobject_uevent_env
> kobject: 'rx-0' (00000000137dfc9e): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000137dfc9e): auto cleanup kobject_del
> kobject: 'rx-0' (00000000137dfc9e): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000cf51e058): kobject_cleanup, parent 00000000e8ee822b
> kobject: 'tx-0' (00000000cf51e058): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000cf51e058): kobject_uevent_env
> kobject: 'tx-0' (00000000cf51e058): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000cf51e058): auto cleanup kobject_del
> kobject: 'tx-0' (00000000cf51e058): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (00000000e8ee822b): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (00000000e8ee822b): calling ktype release
> kobject: 'queues' (00000000e8ee822b): kset_release
> kobject: 'queues': free name
> kobject: 'sit0' (0000000065e536c8): kobject_uevent_env
> kobject: 'sit0' (0000000065e536c8): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000265aa8c8): kobject_cleanup, parent 000000001c613bad
> kobject: 'rx-0' (00000000265aa8c8): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000265aa8c8): kobject_uevent_env
> kobject: 'rx-0' (00000000265aa8c8): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000265aa8c8): auto cleanup kobject_del
> kobject: 'rx-0' (00000000265aa8c8): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000669b1a88): kobject_cleanup, parent 000000001c613bad
> kobject: 'tx-0' (00000000669b1a88): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000669b1a88): kobject_uevent_env
> kobject: 'tx-0' (00000000669b1a88): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000669b1a88): auto cleanup kobject_del
> kobject: 'tx-0' (00000000669b1a88): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000001c613bad): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (000000001c613bad): calling ktype release
> kobject: 'queues' (000000001c613bad): kset_release
> kobject: 'queues': free name
> kobject: 'sit0' (00000000b0b0bf77): kobject_uevent_env
> kobject: 'sit0' (00000000b0b0bf77): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000c08b3e35): kobject_cleanup, parent 000000004d964cab
> kobject: 'rx-0' (00000000c08b3e35): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000c08b3e35): kobject_uevent_env
> kobject: 'rx-0' (00000000c08b3e35): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000c08b3e35): auto cleanup kobject_del
> kobject: 'rx-0' (00000000c08b3e35): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (000000006bb20443): kobject_cleanup, parent 000000004d964cab
> kobject: 'tx-0' (000000006bb20443): auto cleanup 'remove' event
> kobject: 'tx-0' (000000006bb20443): kobject_uevent_env
> kobject: 'tx-0' (000000006bb20443): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (000000006bb20443): auto cleanup kobject_del
> kobject: 'tx-0' (000000006bb20443): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000004d964cab): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (000000004d964cab): calling ktype release
> kobject: 'queues' (000000004d964cab): kset_release
> kobject: 'queues': free name
> kobject: 'sit0' (00000000e3a2a337): kobject_uevent_env
> kobject: 'sit0' (00000000e3a2a337): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000fcf6c2df): kobject_cleanup, parent 000000001f378765
> kobject: 'rx-0' (00000000fcf6c2df): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000fcf6c2df): kobject_uevent_env
> kobject: 'rx-0' (00000000fcf6c2df): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000fcf6c2df): auto cleanup kobject_del
> kobject: 'rx-0' (00000000fcf6c2df): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000306e361a): kobject_cleanup, parent 000000001f378765
> kobject: 'tx-0' (00000000306e361a): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000306e361a): kobject_uevent_env
> kobject: 'tx-0' (00000000306e361a): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000306e361a): auto cleanup kobject_del
> kobject: 'tx-0' (00000000306e361a): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000001f378765): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (000000001f378765): calling ktype release
> kobject: 'queues' (000000001f378765): kset_release
> kobject: 'queues': free name
> kobject: 'sit0' (0000000058d12d0d): kobject_uevent_env
> kobject: 'sit0' (0000000058d12d0d): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000078d95bd): kobject_cleanup, parent 000000003596feb5
> kobject: 'rx-0' (00000000078d95bd): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000078d95bd): kobject_uevent_env
> kobject: 'rx-0' (00000000078d95bd): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000078d95bd): auto cleanup kobject_del
> kobject: 'rx-0' (00000000078d95bd): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (0000000037709752): kobject_cleanup, parent 000000003596feb5
> kobject: 'tx-0' (0000000037709752): auto cleanup 'remove' event
> kobject: 'tx-0' (0000000037709752): kobject_uevent_env
> kobject: 'tx-0' (0000000037709752): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (0000000037709752): auto cleanup kobject_del
> kobject: 'tx-0' (0000000037709752): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000003596feb5): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (000000003596feb5): calling ktype release
> kobject: 'queues' (000000003596feb5): kset_release
> kobject: 'queues': free name
> kobject: 'sit0' (000000008276eda5): kobject_uevent_env
> kobject: 'sit0' (000000008276eda5): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000004d3b044b): kobject_cleanup, parent 000000006b53a9a0
> kobject: 'rx-0' (000000004d3b044b): auto cleanup 'remove' event
> kobject: 'rx-0' (000000004d3b044b): kobject_uevent_env
> kobject: 'rx-0' (000000004d3b044b): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000004d3b044b): auto cleanup kobject_del
> kobject: 'rx-0' (000000004d3b044b): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000273da9ae): kobject_cleanup, parent 000000006b53a9a0
> kobject: 'tx-0' (00000000273da9ae): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000273da9ae): kobject_uevent_env
> kobject: 'tx-0' (00000000273da9ae): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000273da9ae): auto cleanup kobject_del
> kobject: 'tx-0' (00000000273da9ae): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000006b53a9a0): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (000000006b53a9a0): calling ktype release
> kobject: 'queues' (000000006b53a9a0): kset_release
> kobject: 'queues': free name
> kobject: 'sit0' (000000005ed040cc): kobject_uevent_env
> kobject: 'sit0' (000000005ed040cc): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000f150476e): kobject_cleanup, parent 00000000a0cff6dd
> kobject: 'rx-0' (00000000f150476e): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000f150476e): kobject_uevent_env
> kobject: 'rx-0' (00000000f150476e): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000f150476e): auto cleanup kobject_del
> kobject: 'rx-0' (00000000f150476e): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000c81ff56b): kobject_cleanup, parent 00000000a0cff6dd
> kobject: 'tx-0' (00000000c81ff56b): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000c81ff56b): kobject_uevent_env
> kobject: 'tx-0' (00000000c81ff56b): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000c81ff56b): auto cleanup kobject_del
> kobject: 'tx-0' (00000000c81ff56b): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (00000000a0cff6dd): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (00000000a0cff6dd): calling ktype release
> kobject: 'queues' (00000000a0cff6dd): kset_release
> kobject: 'queues': free name
> kobject: 'sit0' (000000009ebda3df): kobject_uevent_env
> kobject: 'sit0' (000000009ebda3df): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'sit0' (00000000ba6470e9): kobject_cleanup, parent 000000009c061a32
> kobject: 'sit0' (00000000ba6470e9): calling ktype release
> kobject: 'sit0': free name
> kobject: 'sit0' (000000009f74c826): kobject_cleanup, parent 000000009c061a32
> kobject: 'sit0' (000000009f74c826): calling ktype release
> kobject: 'sit0': free name
> kobject: 'sit0' (0000000065e536c8): kobject_cleanup, parent 000000009c061a32
> kobject: 'sit0' (0000000065e536c8): calling ktype release
> kobject: 'sit0': free name
> kobject: 'sit0' (00000000b0b0bf77): kobject_cleanup, parent 000000009c061a32
> kobject: 'sit0' (00000000b0b0bf77): calling ktype release
> kobject: 'sit0': free name
> kobject: 'sit0' (00000000e3a2a337): kobject_cleanup, parent 000000009c061a32
> kobject: 'sit0' (00000000e3a2a337): calling ktype release
> kobject: 'sit0': free name
> kobject: 'sit0' (0000000058d12d0d): kobject_cleanup, parent 000000009c061a32
> kobject: 'sit0' (0000000058d12d0d): calling ktype release
> kobject: 'sit0': free name
> kobject: 'sit0' (000000008276eda5): kobject_cleanup, parent 000000009c061a32
> kobject: 'sit0' (000000008276eda5): calling ktype release
> kobject: 'sit0': free name
> kobject: 'sit0' (000000005ed040cc): kobject_cleanup, parent 000000009c061a32
> kobject: 'sit0' (000000005ed040cc): calling ktype release
> kobject: 'sit0': free name
> kobject: 'sit0' (000000009ebda3df): kobject_cleanup, parent 000000009c061a32
> kobject: 'sit0' (000000009ebda3df): calling ktype release
> kobject: 'sit0': free name
> kobject: 'rx-0' (00000000011781b4): kobject_cleanup, parent 0000000037662b61
> kobject: 'rx-0' (00000000011781b4): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000011781b4): kobject_uevent_env
> kobject: 'rx-0' (00000000011781b4): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000011781b4): auto cleanup kobject_del
> kobject: 'rx-0' (00000000011781b4): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (000000002bafd647): kobject_cleanup, parent 0000000037662b61
> kobject: 'tx-0' (000000002bafd647): auto cleanup 'remove' event
> kobject: 'tx-0' (000000002bafd647): kobject_uevent_env
> kobject: 'tx-0' (000000002bafd647): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (000000002bafd647): auto cleanup kobject_del
> kobject: 'tx-0' (000000002bafd647): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (0000000037662b61): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (0000000037662b61): calling ktype release
> kobject: 'queues' (0000000037662b61): kset_release
> kobject: 'queues': free name
> kobject: 'ip6_vti0' (000000000e5b1a5c): kobject_uevent_env
> kobject: 'ip6_vti0' (000000000e5b1a5c): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (0000000068311350): kobject_cleanup, parent 00000000facffc2f
> kobject: 'rx-0' (0000000068311350): auto cleanup 'remove' event
> kobject: 'rx-0' (0000000068311350): kobject_uevent_env
> kobject: 'rx-0' (0000000068311350): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (0000000068311350): auto cleanup kobject_del
> kobject: 'rx-0' (0000000068311350): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000d6e81326): kobject_cleanup, parent 00000000facffc2f
> kobject: 'tx-0' (00000000d6e81326): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000d6e81326): kobject_uevent_env
> kobject: 'tx-0' (00000000d6e81326): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000d6e81326): auto cleanup kobject_del
> kobject: 'tx-0' (00000000d6e81326): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (00000000facffc2f): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (00000000facffc2f): calling ktype release
> kobject: 'queues' (00000000facffc2f): kset_release
> kobject: 'queues': free name
> kobject: 'ip6_vti0' (0000000084bcfa3e): kobject_uevent_env
> kobject: 'ip6_vti0' (0000000084bcfa3e): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000ce1fbf9a): kobject_cleanup, parent 00000000faad76b9
> kobject: 'rx-0' (00000000ce1fbf9a): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000ce1fbf9a): kobject_uevent_env
> kobject: 'rx-0' (00000000ce1fbf9a): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000ce1fbf9a): auto cleanup kobject_del
> kobject: 'rx-0' (00000000ce1fbf9a): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (0000000054a9318d): kobject_cleanup, parent 00000000faad76b9
> kobject: 'tx-0' (0000000054a9318d): auto cleanup 'remove' event
> kobject: 'tx-0' (0000000054a9318d): kobject_uevent_env
> kobject: 'tx-0' (0000000054a9318d): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (0000000054a9318d): auto cleanup kobject_del
> kobject: 'tx-0' (0000000054a9318d): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (00000000faad76b9): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (00000000faad76b9): calling ktype release
> kobject: 'queues' (00000000faad76b9): kset_release
> kobject: 'queues': free name
> kobject: 'ip6_vti0' (00000000a17dcb7a): kobject_uevent_env
> kobject: 'ip6_vti0' (00000000a17dcb7a): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000e1ec0489): kobject_cleanup, parent 0000000032133323
> kobject: 'rx-0' (00000000e1ec0489): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000e1ec0489): kobject_uevent_env
> kobject: 'rx-0' (00000000e1ec0489): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000e1ec0489): auto cleanup kobject_del
> kobject: 'rx-0' (00000000e1ec0489): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000c69707b0): kobject_cleanup, parent 0000000032133323
> kobject: 'tx-0' (00000000c69707b0): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000c69707b0): kobject_uevent_env
> kobject: 'tx-0' (00000000c69707b0): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000c69707b0): auto cleanup kobject_del
> kobject: 'tx-0' (00000000c69707b0): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (0000000032133323): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (0000000032133323): calling ktype release
> kobject: 'queues' (0000000032133323): kset_release
> kobject: 'queues': free name
> kobject: 'ip6_vti0' (00000000f1a1ebea): kobject_uevent_env
> kobject: 'ip6_vti0' (00000000f1a1ebea): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000310059d9): kobject_cleanup, parent 000000002f7c701e
> kobject: 'rx-0' (00000000310059d9): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000310059d9): kobject_uevent_env
> kobject: 'rx-0' (00000000310059d9): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000310059d9): auto cleanup kobject_del
> kobject: 'rx-0' (00000000310059d9): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000463fbeb0): kobject_cleanup, parent 000000002f7c701e
> kobject: 'tx-0' (00000000463fbeb0): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000463fbeb0): kobject_uevent_env
> kobject: 'tx-0' (00000000463fbeb0): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000463fbeb0): auto cleanup kobject_del
> kobject: 'tx-0' (00000000463fbeb0): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000002f7c701e): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (000000002f7c701e): calling ktype release
> kobject: 'queues' (000000002f7c701e): kset_release
> kobject: 'queues': free name
> kobject: 'ip6_vti0' (00000000e99a1c16): kobject_uevent_env
> kobject: 'ip6_vti0' (00000000e99a1c16): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000fc3878f1): kobject_cleanup, parent 0000000039005ce6
> kobject: 'rx-0' (00000000fc3878f1): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000fc3878f1): kobject_uevent_env
> kobject: 'rx-0' (00000000fc3878f1): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000fc3878f1): auto cleanup kobject_del
> kobject: 'rx-0' (00000000fc3878f1): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (000000003da8a217): kobject_cleanup, parent 0000000039005ce6
> kobject: 'tx-0' (000000003da8a217): auto cleanup 'remove' event
> kobject: 'tx-0' (000000003da8a217): kobject_uevent_env
> kobject: 'tx-0' (000000003da8a217): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (000000003da8a217): auto cleanup kobject_del
> kobject: 'tx-0' (000000003da8a217): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (0000000039005ce6): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (0000000039005ce6): calling ktype release
> kobject: 'queues' (0000000039005ce6): kset_release
> kobject: 'queues': free name
> kobject: 'ip6_vti0' (000000003f213163): kobject_uevent_env
> kobject: 'ip6_vti0' (000000003f213163): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (0000000066dc1b5f): kobject_cleanup, parent 00000000e169d802
> kobject: 'rx-0' (0000000066dc1b5f): auto cleanup 'remove' event
> kobject: 'rx-0' (0000000066dc1b5f): kobject_uevent_env
> kobject: 'rx-0' (0000000066dc1b5f): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (0000000066dc1b5f): auto cleanup kobject_del
> kobject: 'rx-0' (0000000066dc1b5f): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000b99448c7): kobject_cleanup, parent 00000000e169d802
> kobject: 'tx-0' (00000000b99448c7): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000b99448c7): kobject_uevent_env
> kobject: 'tx-0' (00000000b99448c7): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000b99448c7): auto cleanup kobject_del
> kobject: 'tx-0' (00000000b99448c7): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (00000000e169d802): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (00000000e169d802): calling ktype release
> kobject: 'queues' (00000000e169d802): kset_release
> kobject: 'queues': free name
> kobject: 'ip6_vti0' (000000003422603c): kobject_uevent_env
> kobject: 'ip6_vti0' (000000003422603c): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000b6464399): kobject_cleanup, parent 00000000785ed365
> kobject: 'rx-0' (00000000b6464399): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000b6464399): kobject_uevent_env
> kobject: 'rx-0' (00000000b6464399): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000b6464399): auto cleanup kobject_del
> kobject: 'rx-0' (00000000b6464399): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000c2beb7d2): kobject_cleanup, parent 00000000785ed365
> kobject: 'tx-0' (00000000c2beb7d2): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000c2beb7d2): kobject_uevent_env
> kobject: 'tx-0' (00000000c2beb7d2): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000c2beb7d2): auto cleanup kobject_del
> kobject: 'tx-0' (00000000c2beb7d2): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (00000000785ed365): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (00000000785ed365): calling ktype release
> kobject: 'queues' (00000000785ed365): kset_release
> kobject: 'queues': free name
> kobject: 'ip6_vti0' (0000000031ab464d): kobject_uevent_env
> kobject: 'ip6_vti0' (0000000031ab464d): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000a7d5a6f7): kobject_cleanup, parent 00000000ed628333
> kobject: 'rx-0' (00000000a7d5a6f7): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000a7d5a6f7): kobject_uevent_env
> kobject: 'rx-0' (00000000a7d5a6f7): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000a7d5a6f7): auto cleanup kobject_del
> kobject: 'rx-0' (00000000a7d5a6f7): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000564c497f): kobject_cleanup, parent 00000000ed628333
> kobject: 'tx-0' (00000000564c497f): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000564c497f): kobject_uevent_env
> kobject: 'tx-0' (00000000564c497f): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000564c497f): auto cleanup kobject_del
> kobject: 'tx-0' (00000000564c497f): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (00000000ed628333): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (00000000ed628333): calling ktype release
> kobject: 'queues' (00000000ed628333): kset_release
> kobject: 'queues': free name
> kobject: 'ip6_vti0' (00000000fb053a2a): kobject_uevent_env
> kobject: 'ip6_vti0' (00000000fb053a2a): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'ip6_vti0' (000000000e5b1a5c): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6_vti0' (000000000e5b1a5c): calling ktype release
> kobject: 'ip6_vti0': free name
> kobject: 'ip6_vti0' (0000000084bcfa3e): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6_vti0' (0000000084bcfa3e): calling ktype release
> kobject: 'ip6_vti0': free name
> kobject: 'ip6_vti0' (00000000a17dcb7a): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6_vti0' (00000000a17dcb7a): calling ktype release
> kobject: 'ip6_vti0': free name
> kobject: 'ip6_vti0' (00000000f1a1ebea): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6_vti0' (00000000f1a1ebea): calling ktype release
> kobject: 'ip6_vti0': free name
> kobject: 'ip6_vti0' (00000000e99a1c16): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6_vti0' (00000000e99a1c16): calling ktype release
> kobject: 'ip6_vti0': free name
> kobject: 'ip6_vti0' (000000003f213163): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6_vti0' (000000003f213163): calling ktype release
> kobject: 'ip6_vti0': free name
> kobject: 'ip6_vti0' (000000003422603c): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6_vti0' (000000003422603c): calling ktype release
> kobject: 'ip6_vti0': free name
> kobject: 'ip6_vti0' (0000000031ab464d): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6_vti0' (0000000031ab464d): calling ktype release
> kobject: 'ip6_vti0': free name
> kobject: 'ip6_vti0' (00000000fb053a2a): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'ip6_vti0' (00000000fb053a2a): calling ktype release
> kobject: 'ip6_vti0': free name
> kobject: 'rx-0' (00000000c827514b): kobject_cleanup, parent 000000004e70d3ea
> kobject: 'rx-0' (00000000c827514b): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000c827514b): kobject_uevent_env
> kobject: 'rx-0' (00000000c827514b): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000c827514b): auto cleanup kobject_del
> kobject: 'rx-0' (00000000c827514b): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000e9330ec4): kobject_cleanup, parent 000000004e70d3ea
> kobject: 'tx-0' (00000000e9330ec4): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000e9330ec4): kobject_uevent_env
> kobject: 'tx-0' (00000000e9330ec4): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000e9330ec4): auto cleanup kobject_del
> kobject: 'tx-0' (00000000e9330ec4): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000004e70d3ea): kobject_cleanup, parent
> 000000009c061a32
> kobject: 'queues' (000000004e70d3ea): calling ktype release
> kobject: 'queues' (000000004e70d3ea): kset_release
> kobject: 'queues': free name
> kobject: 'ip_vti0' (000000004ee7ad23): kobject_uevent_env
> kobject: 'ip_vti0' (000000004ee7ad23): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000004dda38d8): kobject_cleanup, parent 00000000025cb3fe
> kobject: 'rx-0' (000000004dda38d8): auto cleanup 'remove' event
> kobject: 'rx-0' (000000004dda38d8): kobject_uevent_env
> kobject: 'rx-0' (000000004dda38d8): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000004dda38d8): auto cleanup kobject_del
> kobject: 'rx-0' (000000004dda38d8): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (0000000097fba38d): kobject_cleanup, parent 00000000025cb3fe
> kobject: 'tx-0' (0000000097fba38d): auto cleanup 'remove' event
> kobject: 'tx-0' (0000000097fba38d): kobject_uevent_env
> kobject: 'tx-0' (0000000097fba38d): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (0000000097fba38d): auto cleanup kobject_del
> kobject: 'tx-0' (0000000097fba38d): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (00000000025cb3fe): kobject_cleanup, parent
> 000000009c061a32
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/00000000000071c72c0590776357%40google.com.

Looks to be:

#syz dup: BUG: MAX_STACK_TRACE_ENTRIES too low! (2)

Original thread: https://lkml.kernel.org/lkml/0000000000005ff8b20585395280@google.com/T/#u

The caller isn't really meaningful for "MAX_STACK_TRACE_ENTRIES too low" bugs,
so I think
https://github.com/google/syzkaller/pull/1332/commits/ccbd11f30158d198e84953b1bb5eaa33464d9311
should be reverted...

- Eric
