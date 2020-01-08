Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 903D813472B
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729349AbgAHQGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:06:09 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36640 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728985AbgAHQGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:06:06 -0500
Received: by mail-qk1-f196.google.com with SMTP id a203so3106173qkc.3
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 08:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dHVy/bdGgZG0dgo/A6xJ4fb+c5SsUeYQ5V/nRwaXsR8=;
        b=gIzYSGyFOm/9vezNwEfG3UhvQcxnfPpDvcyH9PS3eCoL5GgNPJwBj0B5jViIbSD1wx
         20Ad85YOsFF/oVehT82Fwe67ffRzl80vtLUgib1Zv/SrUWo4O0T0tqyDoBYoBdymi2tn
         4h/mocvUgJ6oNKsBi2FQFD726DicXF5efWUuDb7VQp6ULa+GFISmIr/YFy70VdM+tguo
         kPoxjJm4ZkFp6irwJ4gh7PNgxT79s5m143V55hPQMoRzyWTpVpJVi0+pqAGbgJGXjOGh
         3zrxkmAg2MsWDKqTzcm35s7hSz32g8DeF3n07UJkbSwby+l+g0a377eiWJMTeahXkTyw
         lsCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dHVy/bdGgZG0dgo/A6xJ4fb+c5SsUeYQ5V/nRwaXsR8=;
        b=MHVaSLoTWcUSSRbYV+g7wTA2oWsh7u33Bd7bRVuEyUwGXYOkjjaZFeTMXkv7nR0qcX
         8ejHf3hrtYWWztpnPpClUY3vj2SlX0dKrEZkY0QKab9h0JrN5Nfrdj22lGeIx+tkivz4
         4F9WLJs8I9KlkqrU4t/p1M6heOZ/uPFde8oQRUwX86RNDrkyGvELMno+N1rHdGyiOD7Y
         nitM5STtCyIY9eN7Ur+pOz1iVpjcnT7dUPTOI5FxNS/3YZxEZWRmJIZQ5/eMiWb7LGL4
         1AZC8UpKDp/Bb8B6xUAn6chxXsfgXzeXX0o3gVwpTz6JAUrSKP6HDVluQfXZjKr5fHv+
         N/EA==
X-Gm-Message-State: APjAAAVklsT3MNpXt1s0QG0Gqbc9THmKNpQDFcn6az6EtQ2OAo4U+xIg
        Oz4MOxjiT6pyvxoP4PofANRysbLdrDzdHqUAzym82Q==
X-Google-Smtp-Source: APXvYqwu8vcwV28qqkCiKOxLYe7TONUIvZEDdzkJ4P+jYRYuHgTF/4k0P0SBjS4B+/GNrAPa4IWS6FSlZR6dvPujKME=
X-Received: by 2002:ae9:eb48:: with SMTP id b69mr4903928qkg.43.1578499564696;
 Wed, 08 Jan 2020 08:06:04 -0800 (PST)
MIME-Version: 1.0
References: <00000000000002902c059ba30b4b@google.com>
In-Reply-To: <00000000000002902c059ba30b4b@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 8 Jan 2020 17:05:53 +0100
Message-ID: <CACT4Y+aHL0fCnREJwk7JKWo14tFM5dKh1N9UzG6=mdxkFvUL+w@mail.gmail.com>
Subject: Re: general protection fault in hash_ipportip6_uadt
To:     syzbot <syzbot+19df0457b3f8383e02bd@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        "Enrico Weigelt, metux IT consult" <info@metux.net>,
        jeremy@azazel.net, kadlec@netfilter.org,
        Kate Stewart <kstewart@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 8, 2020 at 5:04 PM syzbot
<syzbot+19df0457b3f8383e02bd@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    ae608821 Merge tag 'trace-v5.5-rc5' of git://git.kernel.or..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17a8e885e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=18698c0c240ba616
> dashboard link: https://syzkaller.appspot.com/bug?extid=19df0457b3f8383e02bd
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11ccdf51e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=123dd5fee00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+19df0457b3f8383e02bd@syzkaller.appspotmail.com

#syz dup: general protection fault in hash_ipportnet4_uadt

> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 9515 Comm: syz-executor397 Not tainted 5.5.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:hash_ipportip6_uadt+0x226/0xa00
> net/netfilter/ipset/ip_set_hash_ipportip.c:285
> Code: 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 14 07 00 00 4c 89
> ea 45 8b 76 04 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 4c
> 89 e8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 d9
> RSP: 0018:ffffc90001d07170 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: ffffc90001d07320 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff867d0153 RDI: ffff888094d55430
> RBP: ffffc90001d072b8 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: ffff8880a6f34c00
> R13: 0000000000000000 R14: 0000000004000000 R15: 0000000000000002
> FS:  0000000001348880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000180 CR3: 00000000a2c54000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   ip_set_utest+0x55b/0x890 net/netfilter/ipset/ip_set_core.c:1867
>   nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
>   netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
>   nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
>   netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
>   netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
>   netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
>   sock_sendmsg_nosec net/socket.c:639 [inline]
>   sock_sendmsg+0xd7/0x130 net/socket.c:659
>   ____sys_sendmsg+0x753/0x880 net/socket.c:2330
>   ___sys_sendmsg+0x100/0x170 net/socket.c:2384
>   __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
>   __do_sys_sendmsg net/socket.c:2426 [inline]
>   __se_sys_sendmsg net/socket.c:2424 [inline]
>   __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
>   do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x441469
> Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 0f 83 9b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffe390fa778 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441469
> RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000003
> RBP: 00000000000166ea R08: 00000000004002c8 R09: 00000000004002c8
> R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000402290
> R13: 0000000000402320 R14: 0000000000000000 R15: 0000000000000000
> Modules linked in:
> ---[ end trace 12a892406cf2adb8 ]---
> RIP: 0010:hash_ipportip6_uadt+0x226/0xa00
> net/netfilter/ipset/ip_set_hash_ipportip.c:285
> Code: 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 14 07 00 00 4c 89
> ea 45 8b 76 04 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 4c
> 89 e8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 d9
> RSP: 0018:ffffc90001d07170 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: ffffc90001d07320 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff867d0153 RDI: ffff888094d55430
> RBP: ffffc90001d072b8 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: ffff8880a6f34c00
> R13: 0000000000000000 R14: 0000000004000000 R15: 0000000000000002
> FS:  0000000001348880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000180 CR3: 00000000a2c54000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/00000000000002902c059ba30b4b%40google.com.
