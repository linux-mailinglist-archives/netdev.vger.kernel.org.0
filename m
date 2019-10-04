Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F53ECBC59
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 15:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388794AbfJDNz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 09:55:59 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:32790 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388491AbfJDNz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 09:55:59 -0400
Received: by mail-ed1-f68.google.com with SMTP id c4so5964181edl.0;
        Fri, 04 Oct 2019 06:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1csabjhWVNY3kOmJm1w8vuqsbkwQCoftT+YyWdw/wF8=;
        b=JPGkyZ1C0hfdUrp9qoqlHLQlkrEWaEBcK5nHm9C3iBhXl8f87HwcYJMnJpBEzQOdSO
         T2478ascOBGZkafOmfqmJY4feY1t065/trwiw8pQsO/Epi6Esdh4vWrEdOFOQXkNL00p
         9vvXs/Uj6wl2cf1s2EIXAKLx7smSv7/RBgZHaH1aL8aJqQSD6lZgxmvgxolcaxgzhDmc
         ctnPsuOLeB4iBiH87r6c0we5duiLkCCnaPislwiAjN8QSmHMKDwsW0cn/UP0tedzlrvL
         HB+P1TcEAKyE6Xv458Kr87p5W5CBu0ZypFc/CoZK4Vm/mV1A0kR8ec40FtVrxwyg2VjG
         i80Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1csabjhWVNY3kOmJm1w8vuqsbkwQCoftT+YyWdw/wF8=;
        b=CcKOY+Kr7IELNp7D6VnhvU0YmlQOfaxL6Ya/CFIEzLQZt4iOV8ymEdJuPjNMW27v8V
         l/uS85XkjDwTwa59HwjhIUTKFLuuoagaSwBrIGFJfIzZnNTJPuFFHfVG0opo2RIrary9
         v/Le1vL6SShEc8OSshbD7tksbPAeQI+V3sI/J1k5u49kL4NZzW4O5JiycWt5e0NDP88P
         86kMMvc3dUgxTSLCy1L7EKEK7MdY860jxxvQTzvb0pPUEnMCzQIEx9qoKWF66y4VwW+j
         0W/xZVtTziq942o8wHgC6xx+pQVpGSkZk/97v4b0ncOY+GFHiGWkTnXT4RGCZkIbuLQj
         UV/Q==
X-Gm-Message-State: APjAAAXl5qN2TuwEmtwY6HhuuKenPysRV7S4y7KSCi0z2AdJv8oxROO7
        3lb4/wowbxvr4Ls/Czw8oWayYfI/A+fQa3pM1U8=
X-Google-Smtp-Source: APXvYqzzKOfL4IXEV8NTYa6HFtfKh2JmOq/jPD1SkT4mywatbIhJKh84XSwTj/v19amYnQntfnu2mbh5/1tZy5+/UtM=
X-Received: by 2002:aa7:d789:: with SMTP id s9mr15371233edq.62.1570197354887;
 Fri, 04 Oct 2019 06:55:54 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000051e9280593f2dc9f@google.com>
In-Reply-To: <00000000000051e9280593f2dc9f@google.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 4 Oct 2019 09:55:18 -0400
Message-ID: <CAF=yD-J-qZv+K5AJc_W8zbyfV2FrtN1kV2pwL65CXzVo8cmH1w@mail.gmail.com>
Subject: Re: general protection fault in veth_get_stats64
To:     syzbot <syzbot+3f3e5e77d793c7a6fe6c@syzkaller.appspotmail.com>
Cc:     airlied@linux.ie, andriy.shevchenko@linux.intel.com,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        bskeggs@redhat.com, Daniel Vetter <daniel@ffwll.ch>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        dri-devel@lists.freedesktop.org, David Ahern <dsahern@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, guoren@kernel.org,
        hawk@kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>, jwi@linux.ibm.com,
        Martin KaFai Lau <kafai@fb.com>, kimbrownkd@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        nouveau@lists.freedesktop.org, petrm@mellanox.com,
        songliubraving@fb.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        toshiaki.makita1@gmail.com, wanghai26@huawei.com,
        Yonghong Song <yhs@fb.com>, yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 2, 2019 at 5:45 PM syzbot
<syzbot+3f3e5e77d793c7a6fe6c@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    a32db7e1 Add linux-next specific files for 20191002
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=175ab7cd600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=599cf05035799eef
> dashboard link: https://syzkaller.appspot.com/bug?extid=3f3e5e77d793c7a6fe6c
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f8b943600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16981a25600000
>
> The bug was bisected to:
>
> commit 84da111de0b4be15bd500deff773f5116f39f7be
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sat Sep 21 17:07:42 2019 +0000
>
>      Merge tag 'for-linus-hmm' of
> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17c55847600000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=14255847600000
> console output: https://syzkaller.appspot.com/x/log.txt?x=10255847600000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+3f3e5e77d793c7a6fe6c@syzkaller.appspotmail.com
> Fixes: 84da111de0b4 ("Merge tag 'for-linus-hmm' of
> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma")
>
> RSP: 002b:00007fff0ba6c998 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004424a9
> RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000000000002 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
> R13: 0000000000000004 R14: 0000000000000000 R15: 0000000000000000
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 8605 Comm: syz-executor330 Not tainted 5.4.0-rc1-next-20191002
> #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:veth_stats_rx drivers/net/veth.c:322 [inline]
> RIP: 0010:veth_get_stats64+0x523/0x900 drivers/net/veth.c:356
> Code: 89 85 60 ff ff ff e8 6c 74 31 fd 49 63 c7 48 69 c0 c0 02 00 00 48 03
> 85 60 ff ff ff 48 8d b8 a0 01 00 00 48 89 fa 48 c1 ea 03 <42> 80 3c 32 00
> 0f 85 c9 02 00 00 48 8d b8 a8 01 00 00 48 8b 90 a0
> RSP: 0018:ffff88809996ed00 EFLAGS: 00010202
> RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff84418daf
> RDX: 0000000000000034 RSI: ffffffff84418e04 RDI: 00000000000001a0
> RBP: ffff88809996ede0 R08: ffff888093182180 R09: ffffed1013202d6a
> R10: ffffed1013202d69 R11: ffff888099016b4f R12: 0000000000000000
> R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
> FS:  0000000001f4a880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000140 CR3: 000000009a80b000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   dev_get_stats+0x8e/0x280 net/core/dev.c:9220
>   rtnl_fill_stats+0x4d/0xac0 net/core/rtnetlink.c:1191
>   rtnl_fill_ifinfo+0x10ad/0x3af0 net/core/rtnetlink.c:1717
>   rtmsg_ifinfo_build_skb+0xc9/0x1a0 net/core/rtnetlink.c:3635
>   rtmsg_ifinfo_event.part.0+0x43/0xe0 net/core/rtnetlink.c:3667
>   rtmsg_ifinfo_event net/core/rtnetlink.c:3678 [inline]
>   rtmsg_ifinfo+0x8d/0xa0 net/core/rtnetlink.c:3676
>   __dev_notify_flags+0x235/0x2c0 net/core/dev.c:7757
>   rtnl_configure_link+0x175/0x250 net/core/rtnetlink.c:2968
>   __rtnl_newlink+0x10c4/0x16d0 net/core/rtnetlink.c:3285
>   rtnl_newlink+0x69/0xa0 net/core/rtnetlink.c:3325
>   rtnetlink_rcv_msg+0x463/0xb00 net/core/rtnetlink.c:5386
>   netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
>   rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5404
>   netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
>   netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
>   netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
>   sock_sendmsg_nosec net/socket.c:638 [inline]
>   sock_sendmsg+0xd7/0x130 net/socket.c:658
>   ___sys_sendmsg+0x803/0x920 net/socket.c:2312
>   __sys_sendmsg+0x105/0x1d0 net/socket.c:2357
>   __do_sys_sendmsg net/socket.c:2366 [inline]
>   __se_sys_sendmsg net/socket.c:2364 [inline]
>   __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2364
>   do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x4424a9
> Code: e8 9c 07 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 0f 83 3b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007fff0ba6c998 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004424a9
> RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000000000002 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
> R13: 0000000000000004 R14: 0000000000000000 R15: 0000000000000000
> Modules linked in:
> ---[ end trace cc6dec8a4962bfff ]---
> RIP: 0010:veth_stats_rx drivers/net/veth.c:322 [inline]
> RIP: 0010:veth_get_stats64+0x523/0x900 drivers/net/veth.c:356
> Code: 89 85 60 ff ff ff e8 6c 74 31 fd 49 63 c7 48 69 c0 c0 02 00 00 48 03
> 85 60 ff ff ff 48 8d b8 a0 01 00 00 48 89 fa 48 c1 ea 03 <42> 80 3c 32 00
> 0f 85 c9 02 00 00 48 8d b8 a8 01 00 00 48 8b 90 a0
> RSP: 0018:ffff88809996ed00 EFLAGS: 00010202
> RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff84418daf
> RDX: 0000000000000034 RSI: ffffffff84418e04 RDI: 00000000000001a0
> RBP: ffff88809996ede0 R08: ffff888093182180 R09: ffffed1013202d6a
> R10: ffffed1013202d69 R11: ffff888099016b4f R12: 0000000000000000
> R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
> FS:  0000000001f4a880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000140 CR3: 000000009a80b000 CR4: 00000000001406e0
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
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches

#syz fix: net: propagate errors correctly in register_netdevice()
