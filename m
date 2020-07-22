Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2AA229D4E
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730962AbgGVQmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgGVQmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 12:42:05 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C13C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 09:42:05 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id w3so2610797wmi.4
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 09:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LkxJ/wwAxK7dNBV4JJHJ6LwkNtx/8CG6PgQnexCLiK4=;
        b=PbEnkDzpBaYmL6gqXaz2TM+srdRqQT/VCBZyO77WsOIPca2jdk5CJGsk0s32orVFNa
         5Nt8yn4o1hBDCaX7m7ANzoBU9DAJhH8y8GiH9rbOiYilM3bjQ68E9hRY1oAGs5IQs7+U
         pz70l1FjPXpD6S/gSWVYlCjas4lADLEN+hY958cto/Xg/niK/YT8lIPF/wp2/JSYgv63
         Q+Zu5PaLW2LCo8Vr5P4fZR8Kic5WzuJKBJszi+juSZW5HYBeJkOHmm/CRPyudJQpXVlb
         594qZagPngWhCFFKX+7AOUUfEsiQ1+Je7TU9N3jLnwpGDEU6uD/4zx2Oqtj5MC51P8zg
         UmQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LkxJ/wwAxK7dNBV4JJHJ6LwkNtx/8CG6PgQnexCLiK4=;
        b=ClmL+LPkSD/xHVmL7ppLfZSNOIW3oSV3crbqZuF13ojFlzyHOWhpTfJ+5dYNM7UWMG
         EvHoIO3k862sw/lp78dTQGa7vAxhNptgjYMDvDHazn3KgEnnuoq/fExRefUNxmhkdwe4
         lyqzBBgX4LdRmd4hAGhQZH8XQkNbqBRHVdpXmb2JqQd5XuttvB5zEdgm4s3gVDAAU1Ch
         fR3Y0+kamjAfEEjikxl6kQFehZdAHExok9KIV8ZfhRqIOA5Jqnv5JCcH/C0h97/Vm+Na
         U6q1qhVIflmysWN0+ULllnV+ZLe44eItao5WWOS2udtLYWqNo0JLvx05uVwT/1+kp9ZE
         JTpA==
X-Gm-Message-State: AOAM5313Ue50G88i7Vct4/QJax3YL/pEdW8LtdoHDenu59UyET0F7ucs
        knwHBIZHwvIQ9xAOHmGsfSygR7GyOzuxVgEkTo6hmA==
X-Google-Smtp-Source: ABdhPJyvIYj/euI8KxW4s/HGdAbouF0Cv3ZJqoidap6PtDPmqIZyZE0G07F7lgTnhHzUwogbG2pQGBgahvjK7lfjApE=
X-Received: by 2002:a1c:7f0e:: with SMTP id a14mr476282wmd.21.1595436123518;
 Wed, 22 Jul 2020 09:42:03 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000000924780598075f4b@google.com> <000000000000abc0e505aad48a7d@google.com>
In-Reply-To: <000000000000abc0e505aad48a7d@google.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Wed, 22 Jul 2020 18:41:52 +0200
Message-ID: <CAG_fn=XDg4FjGfFHe8nQpxXvtMTBkKHGbrXSdKT+KepRCAVVxg@mail.gmail.com>
Subject: Re: KMSAN: uninit-value in __skb_checksum_complete (4)
To:     syzbot <syzbot+721b564cd88ebb710182@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 2:25 AM syzbot
<syzbot+721b564cd88ebb710182@syzkaller.appspotmail.com> wrote:
>
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    14525656 compiler.h: reinstate missing KMSAN_INIT
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D16a7c82710000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dc534a9fad6323=
722
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D721b564cd88ebb7=
10182
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-projec=
t/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D115be9d7100=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D15b9425f10000=
0
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+721b564cd88ebb710182@syzkaller.appspotmail.com

Sorry for the noise. This is a false report caused by incorrect
copy_to_user() instrumentation after KMSAN rebase.
Should be fixed now.

#syz invalid

> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> BUG: KMSAN: uninit-value in __skb_checksum_complete+0x37f/0x540 net/core/=
skbuff.c:2850
> CPU: 1 PID: 8457 Comm: syz-executor769 Not tainted 5.8.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1df/0x240 lib/dump_stack.c:118
>  kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
>  __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
>  __skb_checksum_complete+0x37f/0x540 net/core/skbuff.c:2850
>  nf_ip_checksum+0x53b/0x740 net/netfilter/utils.c:36
>  nf_nat_icmp_reply_translation+0x2ba/0x980 net/netfilter/nf_nat_proto.c:5=
78
>  nf_nat_ipv4_fn net/netfilter/nf_nat_proto.c:637 [inline]
>  nf_nat_ipv4_local_fn+0x215/0x830 net/netfilter/nf_nat_proto.c:708
>  nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
>  nf_hook_slow+0x16e/0x400 net/netfilter/core.c:512
>  nf_hook include/linux/netfilter.h:262 [inline]
>  __ip_local_out+0x69b/0x800 net/ipv4/ip_output.c:114
>  ip_local_out net/ipv4/ip_output.c:123 [inline]
>  ip_send_skb net/ipv4/ip_output.c:1560 [inline]
>  ip_push_pending_frames+0x16f/0x460 net/ipv4/ip_output.c:1580
>  icmp_push_reply+0x660/0x710 net/ipv4/icmp.c:390
>  __icmp_send+0x23ca/0x3150 net/ipv4/icmp.c:740
>  icmp_send include/net/icmp.h:43 [inline]
>  ip_fragment+0x39f/0x400 net/ipv4/ip_output.c:579
>  __ip_finish_output+0xd34/0xd80 net/ipv4/ip_output.c:304
>  ip_finish_output+0x166/0x410 net/ipv4/ip_output.c:316
>  NF_HOOK_COND include/linux/netfilter.h:296 [inline]
>  ip_output+0x593/0x680 net/ipv4/ip_output.c:430
>  dst_output include/net/dst.h:443 [inline]
>  ip_local_out net/ipv4/ip_output.c:125 [inline]
>  __ip_queue_xmit+0x1b5c/0x21a0 net/ipv4/ip_output.c:530
>  ip_queue_xmit include/net/ip.h:237 [inline]
>  l2tp_ip_sendmsg+0x1477/0x1870 net/l2tp/l2tp_ip.c:508
>  inet_sendmsg+0x2d8/0x2e0 net/ipv4/af_inet.c:814
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg net/socket.c:672 [inline]
>  kernel_sendmsg+0x384/0x440 net/socket.c:692
>  sock_no_sendpage+0x235/0x300 net/core/sock.c:2853
>  kernel_sendpage net/socket.c:3642 [inline]
>  sock_sendpage+0x1e1/0x2c0 net/socket.c:945
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
>  __do_sys_sendfile64 fs/read_write.c:1601 [inline]
>  __se_sys_sendfile64+0x2bb/0x360 fs/read_write.c:1587
>  __x64_sys_sendfile64+0x56/0x70 fs/read_write.c:1587
>  do_syscall_64+0xb0/0x150 arch/x86/entry/common.c:386
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x440409
> Code: Bad RIP value.
> RSP: 002b:00007ffe9c5d76d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440409
> RDX: 0000000000000000 RSI: 0000000000000005 RDI: 0000000000000003
> RBP: 00000000006cb018 R08: 0000000000000014 R09: 65732f636f72702f
> R10: 0800000080004103 R11: 0000000000000246 R12: 0000000000401c70
> R13: 0000000000401d00 R14: 0000000000000000 R15: 0000000000000000
>
> Uninit was stored to memory at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
>  kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
>  kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
>  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
>  __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
>  csum_partial_copy+0xae/0x100 lib/checksum.c:154
>  skb_copy_and_csum_bits+0x227/0x1130 net/core/skbuff.c:2737
>  icmp_glue_bits+0x166/0x380 net/ipv4/icmp.c:353
>  __ip_append_data+0x47c4/0x5630 net/ipv4/ip_output.c:1131
>  ip_append_data+0x328/0x480 net/ipv4/ip_output.c:1315
>  icmp_push_reply+0x206/0x710 net/ipv4/icmp.c:371
>  __icmp_send+0x23ca/0x3150 net/ipv4/icmp.c:740
>  icmp_send include/net/icmp.h:43 [inline]
>  ip_fragment+0x39f/0x400 net/ipv4/ip_output.c:579
>  __ip_finish_output+0xd34/0xd80 net/ipv4/ip_output.c:304
>  ip_finish_output+0x166/0x410 net/ipv4/ip_output.c:316
>  NF_HOOK_COND include/linux/netfilter.h:296 [inline]
>  ip_output+0x593/0x680 net/ipv4/ip_output.c:430
>  dst_output include/net/dst.h:443 [inline]
>  ip_local_out net/ipv4/ip_output.c:125 [inline]
>  __ip_queue_xmit+0x1b5c/0x21a0 net/ipv4/ip_output.c:530
>  ip_queue_xmit include/net/ip.h:237 [inline]
>  l2tp_ip_sendmsg+0x1477/0x1870 net/l2tp/l2tp_ip.c:508
>  inet_sendmsg+0x2d8/0x2e0 net/ipv4/af_inet.c:814
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg net/socket.c:672 [inline]
>  kernel_sendmsg+0x384/0x440 net/socket.c:692
>  sock_no_sendpage+0x235/0x300 net/core/sock.c:2853
>  kernel_sendpage net/socket.c:3642 [inline]
>  sock_sendpage+0x1e1/0x2c0 net/socket.c:945
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
>  __do_sys_sendfile64 fs/read_write.c:1601 [inline]
>  __se_sys_sendfile64+0x2bb/0x360 fs/read_write.c:1587
>  __x64_sys_sendfile64+0x56/0x70 fs/read_write.c:1587
>  do_syscall_64+0xb0/0x150 arch/x86/entry/common.c:386
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> Uninit was stored to memory at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
>  kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
>  kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
>  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
>  __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
>  _copy_from_iter_full+0xbfe/0x13b0 lib/iov_iter.c:793
>  copy_from_iter_full include/linux/uio.h:156 [inline]
>  memcpy_from_msg include/linux/skbuff.h:3566 [inline]
>  l2tp_ip_sendmsg+0x6a5/0x1870 net/l2tp/l2tp_ip.c:462
>  inet_sendmsg+0x2d8/0x2e0 net/ipv4/af_inet.c:814
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg net/socket.c:672 [inline]
>  kernel_sendmsg+0x384/0x440 net/socket.c:692
>  sock_no_sendpage+0x235/0x300 net/core/sock.c:2853
>  kernel_sendpage net/socket.c:3642 [inline]
>  sock_sendpage+0x1e1/0x2c0 net/socket.c:945
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
>  __do_sys_sendfile64 fs/read_write.c:1601 [inline]
>  __se_sys_sendfile64+0x2bb/0x360 fs/read_write.c:1587
>  __x64_sys_sendfile64+0x56/0x70 fs/read_write.c:1587
>  do_syscall_64+0xb0/0x150 arch/x86/entry/common.c:386
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> Uninit was created at:
>  kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:144
>  kmsan_internal_alloc_meta_for_pages mm/kmsan/kmsan_shadow.c:269 [inline]
>  kmsan_alloc_page+0xb9/0x180 mm/kmsan/kmsan_shadow.c:293
>  __alloc_pages_nodemask+0x56a2/0x5dc0 mm/page_alloc.c:4889
>  alloc_pages_current+0x672/0x990 mm/mempolicy.c:2292
>  alloc_pages include/linux/gfp.h:545 [inline]
>  push_pipe+0x605/0xb70 lib/iov_iter.c:537
>  __pipe_get_pages lib/iov_iter.c:1278 [inline]
>  pipe_get_pages_alloc lib/iov_iter.c:1385 [inline]
>  iov_iter_get_pages_alloc+0x18a9/0x21c0 lib/iov_iter.c:1403
>  default_file_splice_read fs/splice.c:385 [inline]
>  do_splice_to+0x4fc/0x14f0 fs/splice.c:871
>  splice_direct_to_actor+0x45c/0xf50 fs/splice.c:950
>  do_splice_direct+0x342/0x580 fs/splice.c:1059
>  do_sendfile+0x101b/0x1d40 fs/read_write.c:1540
>  __do_sys_sendfile64 fs/read_write.c:1601 [inline]
>  __se_sys_sendfile64+0x2bb/0x360 fs/read_write.c:1587
>  __x64_sys_sendfile64+0x56/0x70 fs/read_write.c:1587
>  do_syscall_64+0xb0/0x150 arch/x86/entry/common.c:386
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>


--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
