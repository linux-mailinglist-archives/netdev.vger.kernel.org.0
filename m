Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3561CE8D55
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 17:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390481AbfJ2QyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 12:54:09 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:35915 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727279AbfJ2QyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 12:54:09 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 949CA5805;
        Tue, 29 Oct 2019 12:54:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 29 Oct 2019 12:54:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=e8zlGTKgif5MoJT93rDm8cGTOU34R4PgtEM32L99v
        Vo=; b=oob0NMfWdZRQbpdE/NeToouSagLInmqlAvKkKJj/URI594U+vcXJOptt4
        iI01lrK6UH0k6D5PALQR/DW6v5+BmffGdOe15ET+IwWrzk75elt2bG/tnju/03ON
        4RGb0NRyn6/LJ26DdmM3yYQsRqcDFZMtjoQmQ6iDL6dQpabjOqsI0sqfzI3Xkoe/
        gYgQOQ0878nL5SzpR6KazOZc/nF5LWvJ73+gyzRzkJdqO+BcLQ4VvRSKa8JVL7YL
        G0w/76Z+2PAEXo5xe4EKB0Z4xNtFpRbWz+FNCYZbHOipQEKTwz8oLXnf1Z0ShzQg
        rWGQPEX4IEwWUFcb1O1eWCQYt/Jww==
X-ME-Sender: <xms:rm64XZAzGiQ_SWdPxOTO1FsYsmmF9vuoSZQKgiZ01SmKcP57UK3HoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtuddgledvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhushhpvggtthffohhmrghinhculdegledmnecujfgurhepfffhvffukfhfgggtugfg
    jggfsehtkeertddtreejnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughosh
    gthhesihguohhstghhrdhorhhgqeenucffohhmrghinhepghhoohhglhgvrdgtohhmpdhg
    ohhordhglhdprghpphhsphhothdrtghomhenucfkphepudelfedrgeejrdduieehrddvhe
    dunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:r264XV9lrKQXXgjtvwTDgs0ZQm9vpptZEAU8bN99ujUPmF5UPzPm8A>
    <xmx:r264XbsKe9VHRLOtPhC7qENIMKtBvPhJFq4J6vrTK9IW8PrUn_wEYQ>
    <xmx:r264XXVIpjGgom-dI3KK5ejQvnuPUIRUfC2ritb1XBbeL_I-xlIxrQ>
    <xmx:r264XfQJmcXfKLprIs3jhi4SMEVukjUdSRX9AHNGwMlNnsQ6sOOunw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 95BAED60066;
        Tue, 29 Oct 2019 12:54:06 -0400 (EDT)
Date:   Tue, 29 Oct 2019 18:54:04 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+9ed8f68ab30761f3678e@syzkaller.appspotmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Subject: Re: general protection fault in process_one_work
Message-ID: <20191029165404.GA10996@splinter>
References: <0000000000001c46d5059608892f@google.com>
 <CACT4Y+b7nkRO_Q6X3sTWbGU5Y6bGuZPmKzoPL2uoFpA4KCP2hw@mail.gmail.com>
 <20191029084517.GA24289@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191029084517.GA24289@splinter>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 10:45:19AM +0200, Ido Schimmel wrote:
> On Tue, Oct 29, 2019 at 09:43:27AM +0100, Dmitry Vyukov wrote:
> > On Tue, Oct 29, 2019 at 9:38 AM syzbot
> > <syzbot+9ed8f68ab30761f3678e@syzkaller.appspotmail.com> wrote:
> > >
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    38207291 bpf: Prepare btf_ctx_access for non raw_tp use case
> > > git tree:       bpf-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=14173c0f600000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=41648156aa09be10
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=9ed8f68ab30761f3678e
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > >
> > > Unfortunately, I don't have any reproducer for this crash yet.
> > >
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+9ed8f68ab30761f3678e@syzkaller.appspotmail.com
> > 
> > +Jiří Pírko, this seems to be related to netdevsim.
> 
> Will check it.

Didn't have a lot of time today, but I think the issue is a race
condition (note that syzbot only triggered it twice so far).

Upon reload nsim_dev_port_del_all() is called and starts deleting ports
from the ports list without holding the ports list mutex. It is possible
that during this time nsim_dev_trap_report_work() is executing from a
workqueue and accessing freed memory despite holding the ports list
mutex.

I'll try to reproduce and send a fix later this week.

> 
> > 
> > > kasan: CONFIG_KASAN_INLINE enabled
> > > kasan: GPF could be caused by NULL-ptr deref or user memory access
> > > general protection fault: 0000 [#1] PREEMPT SMP KASAN
> > > CPU: 1 PID: 9149 Comm: kworker/1:3 Not tainted 5.4.0-rc1+ #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > > Google 01/01/2011
> > > Workqueue: events nsim_dev_trap_report_work
> > > RIP: 0010:nsim_dev_trap_report_work+0xc4/0xaf0
> > > drivers/net/netdevsim/dev.c:409
> > > Code: 89 45 d0 0f 84 8b 07 00 00 49 bc 00 00 00 00 00 fc ff df e8 3e ae ef
> > > fc 48 8b 45 d0 48 05 68 01 00 00 48 89 45 90 48 c1 e8 03 <42> 80 3c 20 00
> > > 0f 85 b1 09 00 00 48 8b 45 d0 48 8b 98 68 01 00 00
> > > RSP: 0018:ffff88806c98fc90 EFLAGS: 00010a06
> > > RAX: 1bd5a0000000004d RBX: 0000000000000000 RCX: ffffffff84836e22
> > > RDX: 0000000000000000 RSI: ffffffff84836db2 RDI: 0000000000000001
> > > RBP: ffff88806c98fd30 R08: ffff88806c9863c0 R09: ffffed100d75f3d9
> > > R10: ffffed100d75f3d8 R11: ffff88806baf9ec7 R12: dffffc0000000000
> > > R13: ffff88806baf9ec0 R14: ffff8880a9a13900 R15: ffff8880ae934500
> > > FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 00007efdd0c9e000 CR3: 000000009cc1b000 CR4: 00000000001406e0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > Call Trace:
> > >   process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
> > >   worker_thread+0x98/0xe40 kernel/workqueue.c:2415
> > >   kthread+0x361/0x430 kernel/kthread.c:255
> > >   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> > > Modules linked in:
> > > ---[ end trace ba29cd1c27f63d86 ]---
> > > RIP: 0010:nsim_dev_trap_report_work+0xc4/0xaf0
> > > drivers/net/netdevsim/dev.c:409
> > > Code: 89 45 d0 0f 84 8b 07 00 00 49 bc 00 00 00 00 00 fc ff df e8 3e ae ef
> > > fc 48 8b 45 d0 48 05 68 01 00 00 48 89 45 90 48 c1 e8 03 <42> 80 3c 20 00
> > > 0f 85 b1 09 00 00 48 8b 45 d0 48 8b 98 68 01 00 00
> > > RSP: 0018:ffff88806c98fc90 EFLAGS: 00010a06
> > > RAX: 1bd5a0000000004d RBX: 0000000000000000 RCX: ffffffff84836e22
> > > RDX: 0000000000000000 RSI: ffffffff84836db2 RDI: 0000000000000001
> > > RBP: ffff88806c98fd30 R08: ffff88806c9863c0 R09: ffffed100d75f3d9
> > > R10: ffffed100d75f3d8 R11: ffff88806baf9ec7 R12: dffffc0000000000
> > > R13: ffff88806baf9ec0 R14: ffff8880a9a13900 R15: ffff8880ae934500
> > > FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 00007efdd0c9e000 CR3: 000000009cc1b000 CR4: 00000000001406e0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > >
> > >
> > > ---
> > > This bug is generated by a bot. It may contain errors.
> > > See https://goo.gl/tpsmEJ for more information about syzbot.
> > > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > >
> > > syzbot will keep track of this bug report. See:
> > > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > >
> > > --
> > > You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> > > To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> > > To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/0000000000001c46d5059608892f%40google.com.
