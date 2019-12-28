Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4E0412BD4D
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 11:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfL1Kca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 05:32:30 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:39106 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725957AbfL1Kc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Dec 2019 05:32:29 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1il9OR-0006pv-5Q; Sat, 28 Dec 2019 11:32:23 +0100
Date:   Sat, 28 Dec 2019 11:32:23 +0100
From:   Florian Westphal <fw@strlen.de>
To:     syzbot <syzbot+19616eedf6fd8e241e50@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Subject: Re: general protection fault in nf_ct_netns_do_get
Message-ID: <20191228103223.GH795@breakpoint.cc>
References: <0000000000004718ff059abd88ef@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000004718ff059abd88ef@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+19616eedf6fd8e241e50@syzkaller.appspotmail.com> wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    46cf053e Linux 5.5-rc3
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14188971e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ed9d672709340e35
> dashboard link: https://syzkaller.appspot.com/bug?extid=19616eedf6fd8e241e50
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a47ab9e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=170f2485e00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+19616eedf6fd8e241e50@syzkaller.appspotmail.com
> 
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 9171 Comm: syz-executor797 Not tainted 5.5.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:__read_once_size include/linux/compiler.h:199 [inline]
> RIP: 0010:net_generic include/net/netns/generic.h:45 [inline]
> RIP: 0010:nf_ct_netns_do_get+0xd2/0x7e0
> net/netfilter/nf_conntrack_proto.c:449
> Code: 22 22 fb 45 84 f6 0f 84 5c 03 00 00 e8 07 21 22 fb 49 8d bc 24 68 13
> 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85
> 9f 06 00 00 4d 8b b4 24 68 13 00 00 e8 47 59 0e
> RSP: 0018:ffffc90001f177a8 EFLAGS: 00010202
> RAX: dffffc0000000000 RBX: 0000000000000003 RCX: ffffffff86531056
> RDX: 000000000000026d RSI: ffffffff86530ce9 RDI: 0000000000001368
> RBP: ffffc90001f177e8 R08: ffff88808fd96200 R09: ffffed1015d0703d
> R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: 0000000000000000
> R13: 000000000000002a R14: 0000000000000001 R15: 0000000000000003
> FS:  00000000009fd880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000200008a0 CR3: 0000000093cc3000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  nf_ct_netns_get+0x41/0x150 net/netfilter/nf_conntrack_proto.c:601

#syz-dup: general protection fault in xt_rateest_tg_checkentry
