Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553D8229D1F
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgGVQbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728670AbgGVQbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 12:31:23 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB5AC0619E1
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 09:31:22 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id o11so2516542wrv.9
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 09:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5cFIfC+OivX43Sjf9f32csmhS5DY7aIU9Z07O3VWtcw=;
        b=AZPMChI05cqAi6MJH6FVsLhvicI1WK5HMQXitvcHrozb28mVXKt4mHBw6hzbJPUYLA
         v7sMwj9K/z22GFtHh1UrRmWzFq/JXOnUOT8zDfi0uGYCLcqfv8+dZK6H6q/W6PxdxnCv
         +icjOafsjpwgElCSVU3kO0+CjlonJHB85haRUlOsJGyu8Odgw2ojecbyVBKcghVWQddz
         EBxpq7dQDvAXRIlAWpGXWezcIDVrQ+yUMh48LqJ/RKoKy8ckwdlgWPcf/ajcnRaNaeWv
         tzeMEyLA+l64z3PI4LBns2eunEX2DWYSGHqSoctyEPwdwtYTuyiJzzU2/jDS2608Mpxf
         dy2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5cFIfC+OivX43Sjf9f32csmhS5DY7aIU9Z07O3VWtcw=;
        b=ZPL7jup7IW6+UK4n7qjZ1Aoph2O25DEWTCXbBeaXW+h69zE+3wZszE9G3NL6HLYJ9p
         GZ/hjnN5FxRU8tiIYHqwsBclwg2RMsdIgqkr/BBFRvdNwelZLXKKb3JHOeRKEg+Nky6D
         zDzN2VvdPdEr/tGzNR312RRNOkL0WFnjcsm7XREXSySLmaDBvdrh2TPRqrr9A7AW9teb
         O5GA6AImmjvr4PIqtyHQxidOPEH24iWZIz04RfupbMU7TMF06rXTvpE4pPJDrlER2ldH
         q1LClJk7rjO5Yih7Jan30gQcjdrqj+boccNfrlXX4mLTc6hdyI7YcKCMj25G+HwnDZtN
         N5jQ==
X-Gm-Message-State: AOAM530FziAfq2PZRCNjGP+e65LMUueZlCReG7Oe3dQtqO0NZDASNt2d
        AuNqWfnbGVmiYOzSCOMxn6B1T7EPmSwgwoq4qDpZYw==
X-Google-Smtp-Source: ABdhPJxnhPXbDtp9CA6zjIv2f43C+u9uDm6Tg7C1qadvZWr0iaGfPx3K9UBHkwQyt8cpTtsIC08MagZzuwT8voXNtUo=
X-Received: by 2002:adf:e68f:: with SMTP id r15mr358501wrm.196.1595435481117;
 Wed, 22 Jul 2020 09:31:21 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000009a764805ab04b5e1@google.com>
In-Reply-To: <0000000000009a764805ab04b5e1@google.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Wed, 22 Jul 2020 18:31:09 +0200
Message-ID: <CAG_fn=XwF9gHLsWYEvrS65gcvSR1T=cabByizGh6B=tFhLsp8w@mail.gmail.com>
Subject: Re: KMSAN: uninit-value in __skb_flow_dissect (3)
To:     syzbot <syzbot+051a531e8f1f59cf6dc9@syzkaller.appspotmail.com>
Cc:     andriin@fb.com, Alexei Starovoitov <ast@kernel.org>,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, jakub@cloudflare.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        mcroce@redhat.com, Networking <netdev@vger.kernel.org>,
        ppenkov@google.com, sdf@google.com, songliubraving@fb.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 11:53 AM syzbot
<syzbot+051a531e8f1f59cf6dc9@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:

Sorry for the noise. This is a false report caused by incorrect
copy_to_user() instrumentation after KMSAN rebase.
Should be fixed now.

#syz invalid


> HEAD commit:    14525656 compiler.h: reinstate missing KMSAN_INIT
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D154bb20f10000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dc534a9fad6323=
722
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D051a531e8f1f59c=
f6dc9
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-projec=
t/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> userspace arch: i386
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D13946658900=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D17adcb6f10000=
0
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+051a531e8f1f59cf6dc9@syzkaller.appspotmail.com
>
> batman_adv: batadv0: Interface activated: batadv_slave_1
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> BUG: KMSAN: uninit-value in __skb_flow_dissect+0x30f0/0x8440 net/core/flo=
w_dissector.c:1163
> CPU: 0 PID: 8524 Comm: syz-executor152 Not tainted 5.8.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1df/0x240 lib/dump_stack.c:118
>  kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
>  __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
>  __skb_flow_dissect+0x30f0/0x8440 net/core/flow_dissector.c:1163
>  skb_flow_dissect_flow_keys include/linux/skbuff.h:1310 [inline]
>  ___skb_get_hash net/core/flow_dissector.c:1520 [inline]
>  __skb_get_hash+0x131/0x480 net/core/flow_dissector.c:1586
>  skb_get_hash include/linux/skbuff.h:1348 [inline]
>  udp_flow_src_port+0xa5/0x690 include/net/udp.h:220
>  geneve_xmit_skb drivers/net/geneve.c:895 [inline]
>  geneve_xmit+0xdf1/0x2bf0 drivers/net/geneve.c:1005
>  __netdev_start_xmit include/linux/netdevice.h:4611 [inline]
>  netdev_start_xmit include/linux/netdevice.h:4625 [inline]
>  xmit_one net/core/dev.c:3556 [inline]
>  dev_hard_start_xmit+0x50e/0xa70 net/core/dev.c:3572
>  __dev_queue_xmit+0x2f8d/0x3b20 net/core/dev.c:4131
>  dev_queue_xmit+0x4b/0x60 net/core/dev.c:4164
>  pppoe_sendmsg+0xb43/0xb90 drivers/net/ppp/pppoe.c:900
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg net/socket.c:672 [inline]
>  kernel_sendmsg+0x433/0x440 net/socket.c:692
>  sock_no_sendpage+0x235/0x300 net/core/sock.c:2853
>  kernel_sendpage net/socket.c:3644 [inline]
>  sock_sendpage+0x25b/0x2c0 net/socket.c:945
>  pipe_to_sendpage+0x38c/0x4c0 fs/splice.c:448
>  splice_from_pipe_feed fs/splice.c:502 [inline]
>  __splice_from_pipe+0x565/0xf00 fs/splice.c:626
>  splice_from_pipe fs/splice.c:661 [inline]
>  generic_splice_sendpage+0x1d5/0x2d0 fs/splice.c:834
>  do_splice_from fs/splice.c:846 [inline]
>  direct_splice_actor+0x1fd/0x580 fs/splice.c:1016
>  splice_direct_to_actor+0x6b2/0xf50 fs/splice.c:971
>  do_splice_direct+0x342/0x580 fs/splice.c:1059
>  do_sendfile+0x101b/0x1d40 fs/read_write.c:1540
>  __do_compat_sys_sendfile fs/read_write.c:1622 [inline]
>  __se_compat_sys_sendfile+0x301/0x3c0 fs/read_write.c:1605
>  __ia32_compat_sys_sendfile+0x56/0x70 fs/read_write.c:1605
>  do_syscall_32_irqs_on arch/x86/entry/common.c:430 [inline]
>  __do_fast_syscall_32+0x2aa/0x400 arch/x86/entry/common.c:477
>  do_fast_syscall_32+0x6b/0xd0 arch/x86/entry/common.c:505
>  do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:554
>  entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
> RIP: 0023:0xf7f13549
> Code: Bad RIP value.
> RSP: 002b:00000000ffd520cc EFLAGS: 00000217 ORIG_RAX: 00000000000000bb
> RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 0000000000000005
> RDX: 0000000000000000 RSI: 000000007fffffff RDI: 0000000000000006
> RBP: 0000000020000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>
> Uninit was stored to memory at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
>  kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
>  kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
>  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
>  __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
>  pppoe_sendmsg+0xaed/0xb90 drivers/net/ppp/pppoe.c:896
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg net/socket.c:672 [inline]
>  kernel_sendmsg+0x433/0x440 net/socket.c:692
>  sock_no_sendpage+0x235/0x300 net/core/sock.c:2853
>  kernel_sendpage net/socket.c:3644 [inline]
>  sock_sendpage+0x25b/0x2c0 net/socket.c:945
>  pipe_to_sendpage+0x38c/0x4c0 fs/splice.c:448
>  splice_from_pipe_feed fs/splice.c:502 [inline]
>  __splice_from_pipe+0x565/0xf00 fs/splice.c:626
>  splice_from_pipe fs/splice.c:661 [inline]
>  generic_splice_sendpage+0x1d5/0x2d0 fs/splice.c:834
>  do_splice_from fs/splice.c:846 [inline]
>  direct_splice_actor+0x1fd/0x580 fs/splice.c:1016
>  splice_direct_to_actor+0x6b2/0xf50 fs/splice.c:971
>  do_splice_direct+0x342/0x580 fs/splice.c:1059
>  do_sendfile+0x101b/0x1d40 fs/read_write.c:1540
>  __do_compat_sys_sendfile fs/read_write.c:1622 [inline]
>  __se_compat_sys_sendfile+0x301/0x3c0 fs/read_write.c:1605
>  __ia32_compat_sys_sendfile+0x56/0x70 fs/read_write.c:1605
>  do_syscall_32_irqs_on arch/x86/entry/common.c:430 [inline]
>  __do_fast_syscall_32+0x2aa/0x400 arch/x86/entry/common.c:477
>  do_fast_syscall_32+0x6b/0xd0 arch/x86/entry/common.c:505
>  do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:554
>  entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
>
> Local variable ----hdr@pppoe_sendmsg created at:
>  pppoe_sendmsg+0xa6/0xb90 drivers/net/ppp/pppoe.c:843
>  pppoe_sendmsg+0xa6/0xb90 drivers/net/ppp/pppoe.c:843
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
