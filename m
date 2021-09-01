Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A533FE07F
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 18:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345479AbhIAQ7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 12:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbhIAQ7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 12:59:37 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494EBC061575;
        Wed,  1 Sep 2021 09:58:40 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id bt14so539171ejb.3;
        Wed, 01 Sep 2021 09:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GE91exg5ngcKEMLz0SmXbShNV+SlH9FtlYg8YonG5Jg=;
        b=ZAk5I46BPJSs4FeAwCEeba2oi/olISmVhlZRWgRYaLwts/GDyQHoaLT+UbmUCBaltZ
         hLwP7nnj+8Fl2YKJhZz/L1ZLfOVrZQpr0zEVWsmodLFJzC5qFXgwisys3QUve1eSxp0q
         eCZgorEz2QWiyAZG6O0XylD2wvDTHWK1vNCtz7HKJ0W4rhnKY0Nk9XYf72BHCKyoqxST
         +a6CHPCGFNXykcmtcaaMi8VYg+w0YvmKo9zlGyzz2IC4WG3OPHFpI2LhCTgx+MPnjRJl
         GOxdj+uRVpEQtV6PcPbuB13EfOLMc8IGXpblM+kpcIogzIQfD8duGjetUdZETum9NcYt
         V0jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GE91exg5ngcKEMLz0SmXbShNV+SlH9FtlYg8YonG5Jg=;
        b=JAJBYSl7PJbn8nGoyKNR6bQQsZ0zxkqZtxAP4hH1eDvBgM2wuSD7fK/XUDnTQc0/Db
         zAmAPCrdWOtqWGuF6LQF2wriDElaOyeuV5kZKWGVtvTmhE9tagkpbpMrsMEeduJ64GBs
         7emad34dupIsbaeAywrNToCi7+2EkYndIICj0GiXRt9qlhWvgUjZNORF5IPWigThBKUy
         FmBDGL9dy1DeeOJfEddJb3ft1ovVvRL3picNplSn0fAroTcTmMwtacyZ4HObik4+rWCP
         6co8nLOVHV14+yqND36YoEG6TS2gSY8f3wZFhUuVaPt790B5Kr6XgtgWTMxL1IQjybG5
         /3ig==
X-Gm-Message-State: AOAM531gAbGhnNiFCnarpcF2swGA3N3z9ex6qEUHhEXoEc89ph/VDWA8
        IldbvlazH/qmDSBNFIser5mYPU3N5Ut2GOyTVrg=
X-Google-Smtp-Source: ABdhPJyus+p6A891MknmYtXIEiM9wo5gTavtB9DhITGV9xMQyai3diCpZ8e7LaJpja9TW+RjWLY9cBGIjnP9TRMzNFA=
X-Received: by 2002:a17:906:249a:: with SMTP id e26mr430140ejb.221.1630515518596;
 Wed, 01 Sep 2021 09:58:38 -0700 (PDT)
MIME-Version: 1.0
References: <b653692b-1550-e17a-6c51-894832c56065@virtuozzo.com> <ee5b763a-c39d-80fd-3dd4-bca159b5f5ac@virtuozzo.com>
In-Reply-To: <ee5b763a-c39d-80fd-3dd4-bca159b5f5ac@virtuozzo.com>
From:   Christoph Paasch <christoph.paasch@gmail.com>
Date:   Wed, 1 Sep 2021 09:58:27 -0700
Message-ID: <CALMXkpYB6bJQ4c7CNx4mdjfNtYxnLDCN5DXgh0A4RUUUkD69Jw@mail.gmail.com>
Subject: Re: [PATCH net-next v4] skb_expand_head() adjust skb->truesize incorrectly
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel@openvz.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Julian Wiedmann <jwi@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, Sep 1, 2021 at 1:12 AM Vasily Averin <vvs@virtuozzo.com> wrote:
>
> Christoph Paasch reports [1] about incorrect skb->truesize
> after skb_expand_head() call in ip6_xmit.
> This may happen because of two reasons:
> - skb_set_owner_w() for newly cloned skb is called too early,
> before pskb_expand_head() where truesize is adjusted for (!skb-sk) case.
> - pskb_expand_head() does not adjust truesize in (skb->sk) case.
> In this case sk->sk_wmem_alloc should be adjusted too.
>
> [1] https://lkml.org/lkml/2021/8/20/1082
>
> Fixes: f1260ff15a71 ("skbuff: introduce skb_expand_head()")
> Reported-by: Christoph Paasch <christoph.paasch@gmail.com>
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
> v4: decided to use is_skb_wmem() after pskb_expand_head() call
>     fixed 'return (EXPRESSION);' in os_skb_wmem according to Eric Dumazet
> v3: removed __pskb_expand_head(),
>     added is_skb_wmem() helper for skb with wmem-compatible destructors
>     there are 2 ways to use it:
>      - before pskb_expand_head(), to create skb clones
>      - after successfull pskb_expand_head() to change owner on extended skb.
> v2: based on patch version from Eric Dumazet,
>     added __pskb_expand_head() function, which can be forced
>     to adjust skb->truesize and sk->sk_wmem_alloc.
> ---
>  include/net/sock.h |  1 +
>  net/core/skbuff.c  | 35 ++++++++++++++++++++++++++---------
>  net/core/sock.c    |  8 ++++++++
>  3 files changed, 35 insertions(+), 9 deletions(-)

this introduces more issues with the syzkaller reproducer that I
shared earlier (see below for the output).

I don't have time at the moment to dig into these though - so just
sharing this as an FYI for now.

syzkaller login: [   12.768064] cgroup: Unknown subsys name 'perf_event'
[   12.769831] cgroup: Unknown subsys name 'net_cls'
[   13.587819] ------------[ cut here ]------------
[   13.588943] refcount_t: saturated; leaking memory.
[   13.590166] WARNING: CPU: 1 PID: 1658 at lib/refcount.c:22
refcount_warn_saturate+0xce/0x1f0
[   13.591909] Modules linked in:
[   13.592595] CPU: 1 PID: 1658 Comm: syz-executor Not tainted
5.14.0ea78abdd8ff18baaea3211eabdd6a2a88169cfd6 #134
[   13.594455] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[   13.596640] RIP: 0010:refcount_warn_saturate+0xce/0x1f0
[   13.597651] Code: 1d 32 63 11 02 31 ff 89 de e8 1e 26 79 ff 84 db
75 d8 e8 b5 1e 79 ff 48 c7 c7 80 48 32 83 c6 05 12 63 11 02 01 e8 2f
39
[   13.601049] RSP: 0018:ffffc9000091f2a8 EFLAGS: 00010286
[   13.602077] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[   13.603477] RDX: ffff888100fa2880 RSI: ffffffff8121e533 RDI: fffff52000123e47
[   13.604758] RBP: ffff88810b88013c R08: 0000000000000001 R09: 0000000000000000
[   13.606110] R10: ffffffff814135db R11: 0000000000000000 R12: ffff88810b880000
[   13.607421] R13: 00000000fffffe03 R14: ffff8881094c97c0 R15: ffff88810b88013c
[   13.608874] FS:  00007f8ad457d700(0000) GS:ffff88811b480000(0000)
knlGS:0000000000000000
[   13.610515] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   13.611671] CR2: 0000000000000000 CR3: 00000001045d8000 CR4: 00000000000006e0
[   13.613017] Call Trace:
[   13.613521]  skb_expand_head+0x35a/0x470
[   13.614331]  ip6_xmit+0x105f/0x1560
[   13.615038]  ? ip6_forward+0x22b0/0x22b0
[   13.616011]  ? ip6_dst_check+0x227/0x540
[   13.616773]  ? rt6_check_expired+0x250/0x250
[   13.617657]  ? __sk_dst_check+0xfb/0x200
[   13.618424]  ? inet6_csk_route_socket+0x59e/0x980
[   13.619377]  ? inet6_csk_addr2sockaddr+0x2a0/0x2a0
[   13.620399]  ? stack_trace_consume_entry+0x160/0x160
[   13.621530]  inet6_csk_xmit+0x2b3/0x430
[   13.622290]  ? kasan_save_stack+0x32/0x40
[   13.623133]  ? kasan_save_stack+0x1b/0x40
[   13.623939]  ? inet6_csk_route_socket+0x980/0x980
[   13.624802]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
[   13.625786]  ? csum_ipv6_magic+0x26/0x70
[   13.626653]  ? inet6_csk_route_socket+0x980/0x980
[   13.627480]  __tcp_transmit_skb+0x186e/0x35d0
[   13.628358]  ? __tcp_select_window+0xa50/0xa50
[   13.629153]  ? __sanitizer_cov_trace_cmp4+0x1c/0x70
[   13.630130]  ? kasan_unpoison+0x23/0x50
[   13.630872]  ? __build_skb_around+0x241/0x300
[   13.631667]  ? __sanitizer_cov_trace_const_cmp4+0x1c/0x70
[   13.632785]  ? __alloc_skb+0x180/0x360
[   13.633545]  __tcp_send_ack.part.0+0x3da/0x650
[   13.634333]  tcp_send_ack+0x7d/0xa0
[   13.635031]  __tcp_ack_snd_check+0x156/0x8c0
[   13.635957]  tcp_rcv_established+0x1733/0x1d30
[   13.636889]  ? tcp_data_queue+0x4af0/0x4af0
[   13.637753]  tcp_v6_do_rcv+0x438/0x1380
[   13.638523]  __release_sock+0x1ad/0x310
[   13.639306]  release_sock+0x54/0x1a0
[   13.640029]  ? tcp_sendmsg_locked+0x2ee0/0x2ee0
[   13.640953]  tcp_sendmsg+0x36/0x40
[   13.641710]  inet6_sendmsg+0xb5/0x140
[   13.642359]  ? inet6_ioctl+0x2a0/0x2a0
[   13.643092]  ____sys_sendmsg+0x3b5/0x970
[   13.643834]  ? sock_release+0x1b0/0x1b0
[   13.644593]  ? __ia32_sys_recvmmsg+0x290/0x290
[   13.645505]  ? futex_wait_setup+0x2e0/0x2e0
[   13.646350]  ___sys_sendmsg+0xff/0x170
[   13.647084]  ? hash_futex+0x12/0x1f0
[   13.647870]  ? sendmsg_copy_msghdr+0x160/0x160
[   13.648691]  ? asm_exc_page_fault+0x1e/0x30
[   13.649475]  ? __sanitizer_cov_trace_const_cmp1+0x22/0x80
[   13.650523]  ? __fget_files+0x1c2/0x2a0
[   13.651245]  ? __fget_light+0xea/0x270
[   13.652027]  ? sockfd_lookup_light+0xc3/0x170
[   13.652845]  __sys_sendmmsg+0x192/0x440
[   13.653622]  ? __ia32_sys_sendmsg+0xb0/0xb0
[   13.654365]  ? vfs_fileattr_set+0xb80/0xb80
[   13.655085]  ? __sanitizer_cov_trace_const_cmp4+0x1c/0x70
[   13.656175]  ? alloc_file_pseudo+0x1/0x250
[   13.657026]  ? sock_ioctl+0x1bb/0x670
[   13.657861]  ? __do_sys_futex+0xe7/0x3d0
[   13.658697]  ? __do_sys_futex+0xe7/0x3d0
[   13.659379]  ? __do_sys_futex+0xf0/0x3d0
[   13.660090]  ? __restore_fpregs_from_fpstate+0xa9/0xf0
[   13.661212]  ? fpregs_mark_activate+0x130/0x130
[   13.662078]  ? do_futex+0x1be0/0x1be0
[   13.662846]  __x64_sys_sendmmsg+0x98/0x100
[   13.663706]  ? syscall_exit_to_user_mode+0x1d/0x40
[   13.664698]  do_syscall_64+0x3b/0x90
[   13.665450]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   13.666564] RIP: 0033:0x7f8ad3e8c469
[   13.667204] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40
00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24
08
[   13.670776] RSP: 002b:00007f8ad457cda8 EFLAGS: 00000246 ORIG_RAX:
0000000000000133
[   13.672208] RAX: ffffffffffffffda RBX: 0000000000000133 RCX: 00007f8ad3e8c469
[   13.673598] RDX: 0000000000000003 RSI: 00000000200008c0 RDI: 0000000000000003
[   13.674946] RBP: 0000000000000133 R08: 0000000000000000 R09: 0000000000000000
[   13.676397] R10: 0000000040044040 R11: 0000000000000246 R12: 000000000069bf8c
[   13.677876] R13: 00007ffe38506fef R14: 00007f8ad455d000 R15: 0000000000000003
[   13.679129] ---[ end trace 55e20198e13af26c ]---
[   13.680043] ------------[ cut here ]------------
[   13.681049] refcount_t: underflow; use-after-free.
[   13.682005] WARNING: CPU: 1 PID: 1658 at lib/refcount.c:28
refcount_warn_saturate+0x103/0x1f0
[   13.683658] Modules linked in:
[   13.684246] CPU: 1 PID: 1658 Comm: syz-executor Tainted: G        W
        5.14.0ea78abdd8ff18baaea3211eabdd6a2a88169cfd6 #134
[   13.686321] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[   13.688388] RIP: 0010:refcount_warn_saturate+0x103/0x1f0
[   13.689502] Code: 1d fb 62 11 02 31 ff 89 de e8 e9 25 79 ff 84 db
75 a3 e8 80 1e 79 ff 48 c7 c7 80 49 32 83 c6 05 db 62 11 02 01 e8 fa
34
[   13.692805] RSP: 0018:ffffc9000091eff8 EFLAGS: 00010286
[   13.693756] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[   13.695193] RDX: ffff888100fa2880 RSI: ffffffff8121e533 RDI: fffff52000123df1
[   13.696696] RBP: ffff88810b88013c R08: 0000000000000001 R09: 0000000000000000
[   13.697982] R10: ffffffff814135db R11: 0000000000000000 R12: ffff88810b88013c
[   13.699291] R13: 00000000fffffe02 R14: ffff8881011a4c00 R15: ffff8881094c97c0
[   13.700576] FS:  00007f8ad457d700(0000) GS:ffff88811b480000(0000)
knlGS:0000000000000000
[   13.702031] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   13.703134] CR2: 0000000000000000 CR3: 00000001045d8000 CR4: 00000000000006e0
[   13.704525] Call Trace:
[   13.704973]  __sock_wfree+0xec/0x110
[   13.705737]  ? sock_wfree+0x240/0x240
[   13.706406]  loopback_xmit+0x126/0x4b0
[   13.707278]  ? refcount_warn_saturate+0xce/0x1f0
[   13.708208]  dev_hard_start_xmit+0x16c/0x5c0
[   13.709116]  __dev_queue_xmit+0x1679/0x2970
[   13.709912]  ? netdev_core_pick_tx+0x2d0/0x2d0
[   13.710758]  ? __sanitizer_cov_trace_const_cmp8+0x1d/0x70
[   13.711846]  ? report_bug+0x38/0x210
[   13.712656]  ? handle_bug+0x3c/0x60
[   13.713395]  ? exc_invalid_op+0x14/0x40
[   13.714119]  ip6_finish_output2+0xb52/0x14c0
[   13.715029]  ip6_output+0x572/0x9e0
[   13.715761]  ? ip6_fragment+0x1f40/0x1f40
[   13.716478]  ip6_xmit+0xc6f/0x1560
[   13.717083]  ? ip6_forward+0x22b0/0x22b0
[   13.717895]  ? ip6_dst_check+0x227/0x540
[   13.718689]  ? rt6_check_expired+0x250/0x250
[   13.719620]  ? __sk_dst_check+0xfb/0x200
[   13.720427]  ? inet6_csk_route_socket+0x59e/0x980
[   13.721408]  ? inet6_csk_addr2sockaddr+0x2a0/0x2a0
[   13.722286]  ? stack_trace_consume_entry+0x160/0x160
[   13.723186]  inet6_csk_xmit+0x2b3/0x430
[   13.723873]  ? kasan_save_stack+0x32/0x40
[   13.724682]  ? kasan_save_stack+0x1b/0x40
[   13.725422]  ? inet6_csk_route_socket+0x980/0x980
[   13.726398]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
[   13.727478]  ? csum_ipv6_magic+0x26/0x70
[   13.728288]  ? inet6_csk_route_socket+0x980/0x980
[   13.729267]  __tcp_transmit_skb+0x186e/0x35d0
[   13.730048]  ? __tcp_select_window+0xa50/0xa50
[   13.730952]  ? __sanitizer_cov_trace_cmp4+0x1c/0x70
[   13.732007]  ? kasan_unpoison+0x23/0x50
[   13.732740]  ? __build_skb_around+0x241/0x300
[   13.733605]  ? __sanitizer_cov_trace_const_cmp4+0x1c/0x70
[   13.734749]  ? __alloc_skb+0x180/0x360
[   13.735506]  __tcp_send_ack.part.0+0x3da/0x650
[   13.736377]  tcp_send_ack+0x7d/0xa0
[   13.737015]  __tcp_ack_snd_check+0x156/0x8c0
[   13.737758]  tcp_rcv_established+0x1733/0x1d30
[   13.738679]  ? tcp_data_queue+0x4af0/0x4af0
[   13.739417]  tcp_v6_do_rcv+0x438/0x1380
[   13.740166]  __release_sock+0x1ad/0x310
[   13.740874]  release_sock+0x54/0x1a0
[   13.741527]  ? tcp_sendmsg_locked+0x2ee0/0x2ee0
[   13.742394]  tcp_sendmsg+0x36/0x40
[   13.743037]  inet6_sendmsg+0xb5/0x140
[   13.743752]  ? inet6_ioctl+0x2a0/0x2a0
[   13.744511]  ____sys_sendmsg+0x3b5/0x970
[   13.745325]  ? sock_release+0x1b0/0x1b0
[   13.746031]  ? __ia32_sys_recvmmsg+0x290/0x290
[   13.746914]  ? futex_wait_setup+0x2e0/0x2e0
[   13.747749]  ___sys_sendmsg+0xff/0x170
[   13.748393]  ? hash_futex+0x12/0x1f0
[   13.749036]  ? sendmsg_copy_msghdr+0x160/0x160
[   13.749972]  ? asm_exc_page_fault+0x1e/0x30
[   13.750870]  ? __sanitizer_cov_trace_const_cmp1+0x22/0x80
[   13.751974]  ? __fget_files+0x1c2/0x2a0
[   13.752659]  ? __fget_light+0xea/0x270
[   13.753514]  ? sockfd_lookup_light+0xc3/0x170
[   13.754296]  __sys_sendmmsg+0x192/0x440
[   13.755102]  ? __ia32_sys_sendmsg+0xb0/0xb0
[   13.755917]  ? vfs_fileattr_set+0xb80/0xb80
[   13.756692]  ? __sanitizer_cov_trace_const_cmp4+0x1c/0x70
[   13.757790]  ? alloc_file_pseudo+0x1/0x250
[   13.758675]  ? sock_ioctl+0x1bb/0x670
[   13.759341]  ? __do_sys_futex+0xe7/0x3d0
[   13.760040]  ? __do_sys_futex+0xe7/0x3d0
[   13.760762]  ? __do_sys_futex+0xf0/0x3d0
[   13.761585]  ? __restore_fpregs_from_fpstate+0xa9/0xf0
[   13.762511]  ? fpregs_mark_activate+0x130/0x130
[   13.763382]  ? do_futex+0x1be0/0x1be0
[   13.764044]  __x64_sys_sendmmsg+0x98/0x100
[   13.764831]  ? syscall_exit_to_user_mode+0x1d/0x40
[   13.765814]  do_syscall_64+0x3b/0x90
[   13.766607]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   13.767467] RIP: 0033:0x7f8ad3e8c469
[   13.768206] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40
00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24
08
[   13.771618] RSP: 002b:00007f8ad457cda8 EFLAGS: 00000246 ORIG_RAX:
0000000000000133
[   13.773054] RAX: ffffffffffffffda RBX: 0000000000000133 RCX: 00007f8ad3e8c469
[   13.774260] RDX: 0000000000000003 RSI: 00000000200008c0 RDI: 0000000000000003
[   13.775586] RBP: 0000000000000133 R08: 0000000000000000 R09: 0000000000000000
[   13.776909] R10: 0000000040044040 R11: 0000000000000246 R12: 000000000069bf8c
[   13.778390] R13: 00007ffe38506fef R14: 00007f8ad455d000 R15: 0000000000000003
[   13.779752] ---[ end trace 55e20198e13af26d ]---
[   13.780935] ------------[ cut here ]------------
[   13.781986] WARNING: CPU: 0 PID: 1658 at net/core/skbuff.c:5429
skb_try_coalesce+0x1019/0x12c0
[   13.783740] Modules linked in:
[   13.784398] CPU: 0 PID: 1658 Comm: syz-executor Tainted: G        W
        5.14.0ea78abdd8ff18baaea3211eabdd6a2a88169cfd6 #134
[   13.786692] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[   13.788958] RIP: 0010:skb_try_coalesce+0x1019/0x12c0
[   13.789930] Code: 24 20 bf 01 00 00 00 8b 40 20 44 0f b7 f0 44 89
f6 e8 0b 2b cf fe 41 83 ee 01 0f 85 01 f3 ff ff e9 42 f6 ff ff e8 67
2c
[   13.793371] RSP: 0018:ffffc9000091f530 EFLAGS: 00010293
[   13.794316] RAX: 0000000000000000 RBX: 0000000000000c00 RCX: 0000000000000000
[   13.795688] RDX: ffff888100fa2880 RSI: ffffffff826767a9 RDI: 0000000000000003
[   13.797093] RBP: ffff888109496de0 R08: 0000000000000c00 R09: 0000000000000000
[   13.798381] R10: ffffffff82676122 R11: 0000000000000000 R12: ffff888100efc0e0
[   13.799766] R13: ffff8881046baac0 R14: 0000000000001000 R15: ffff888100efc156
[   13.801052] FS:  00007f8ad457d700(0000) GS:ffff88811b400000(0000)
knlGS:0000000000000000
[   13.802463] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   13.803603] CR2: 00007f83d8028000 CR3: 00000001045d8000 CR4: 00000000000006f0
[   13.805079] Call Trace:
[   13.805622]  tcp_try_coalesce+0x312/0x870
[   13.806488]  ? tcp_ack_update_rtt+0xfc0/0xfc0
[   13.807406]  ? __sanitizer_cov_trace_const_cmp4+0x1c/0x70
[   13.808483]  ? tcp_try_rmem_schedule+0x99b/0x16e0
[   13.809296]  tcp_queue_rcv+0x73/0x670
[   13.810013]  tcp_data_queue+0x11e5/0x4af0
[   13.810844]  ? __sanitizer_cov_trace_const_cmp2+0x22/0x80
[   13.811890]  ? tcp_urg+0x108/0xb60
[   13.812536]  ? tcp_data_ready+0x550/0x550
[   13.813362]  ? tcp_enter_cwr+0x3f0/0x4d0
[   13.814148]  ? __sanitizer_cov_trace_cmp4+0x1c/0x70
[   13.815014]  ? ktime_get+0xf4/0x150
[   13.815637]  ? __sanitizer_cov_trace_const_cmp8+0x1d/0x70
[   13.816721]  tcp_rcv_established+0x83a/0x1d30
[   13.817541]  ? tcp_data_queue+0x4af0/0x4af0
[   13.818375]  tcp_v6_do_rcv+0x438/0x1380
[   13.819160]  __release_sock+0x1ad/0x310
[   13.819975]  release_sock+0x54/0x1a0
[   13.820745]  ? tcp_sendmsg_locked+0x2ee0/0x2ee0
[   13.821662]  tcp_sendmsg+0x36/0x40
[   13.822351]  inet6_sendmsg+0xb5/0x140
[   13.823115]  ? inet6_ioctl+0x2a0/0x2a0
[   13.823909]  ____sys_sendmsg+0x3b5/0x970
[   13.824720]  ? sock_release+0x1b0/0x1b0
[   13.825521]  ? __ia32_sys_recvmmsg+0x290/0x290
[   13.826441]  ? futex_wait_setup+0x2e0/0x2e0
[   13.827308]  ___sys_sendmsg+0xff/0x170
[   13.828112]  ? hash_futex+0x12/0x1f0
[   13.828853]  ? sendmsg_copy_msghdr+0x160/0x160
[   13.829804]  ? asm_exc_page_fault+0x1e/0x30
[   13.830660]  ? __sanitizer_cov_trace_const_cmp1+0x22/0x80
[   13.831760]  ? __fget_files+0x1c2/0x2a0
[   13.832576]  ? __fget_light+0xea/0x270
[   13.833349]  ? sockfd_lookup_light+0xc3/0x170
[   13.834289]  __sys_sendmmsg+0x192/0x440
[   13.835065]  ? __ia32_sys_sendmsg+0xb0/0xb0
[   13.835918]  ? vfs_fileattr_set+0xb80/0xb80
[   13.836823]  ? __sanitizer_cov_trace_const_cmp4+0x1c/0x70
[   13.837941]  ? alloc_file_pseudo+0x1/0x250
[   13.838810]  ? sock_ioctl+0x1bb/0x670
[   13.839550]  ? __do_sys_futex+0xe7/0x3d0
[   13.840369]  ? __do_sys_futex+0xe7/0x3d0
[   13.841205]  ? __do_sys_futex+0xf0/0x3d0
[   13.842022]  ? __restore_fpregs_from_fpstate+0xa9/0xf0
[   13.843115]  ? fpregs_mark_activate+0x130/0x130
[   13.844074]  ? do_futex+0x1be0/0x1be0
[   13.844868]  __x64_sys_sendmmsg+0x98/0x100
[   13.845725]  ? syscall_exit_to_user_mode+0x1d/0x40
[   13.846754]  do_syscall_64+0x3b/0x90
[   13.847472]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   13.848550] RIP: 0033:0x7f8ad3e8c469
[   13.849289] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40
00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24
08
[   13.852935] RSP: 002b:00007f8ad457cda8 EFLAGS: 00000246 ORIG_RAX:
0000000000000133
[   13.854476] RAX: ffffffffffffffda RBX: 0000000000000133 RCX: 00007f8ad3e8c469
[   13.855896] RDX: 0000000000000003 RSI: 00000000200008c0 RDI: 0000000000000003
[   13.857304] RBP: 0000000000000133 R08: 0000000000000000 R09: 0000000000000000
[   13.858756] R10: 0000000040044040 R11: 0000000000000246 R12: 000000000069bf8c
[   13.860168] R13: 00007ffe38506fef R14: 00007f8ad455d000 R15: 0000000000000003
[   13.861597] ---[ end trace 55e20198e13af26e ]---


>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 95b2577..173d58c 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1695,6 +1695,7 @@ struct sk_buff *sock_wmalloc(struct sock *sk, unsigned long size, int force,
>                              gfp_t priority);
>  void __sock_wfree(struct sk_buff *skb);
>  void sock_wfree(struct sk_buff *skb);
> +bool is_skb_wmem(const struct sk_buff *skb);
>  struct sk_buff *sock_omalloc(struct sock *sk, unsigned long size,
>                              gfp_t priority);
>  void skb_orphan_partial(struct sk_buff *skb);
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index f931176..09991cb 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -1804,28 +1804,45 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
>  struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>  {
>         int delta = headroom - skb_headroom(skb);
> +       int osize = skb_end_offset(skb);
> +       struct sk_buff *oskb = NULL;
> +       struct sock *sk = skb->sk;
>
>         if (WARN_ONCE(delta <= 0,
>                       "%s is expecting an increase in the headroom", __func__))
>                 return skb;
>
> -       /* pskb_expand_head() might crash, if skb is shared */
> +       delta = SKB_DATA_ALIGN(delta);
> +       /* pskb_expand_head() might crash, if skb is shared.
> +        * Also we should clone skb if its destructor does
> +        * not adjust skb->truesize and sk->sk_wmem_alloc
> +        */
>         if (skb_shared(skb)) {
>                 struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
>
> -               if (likely(nskb)) {
> -                       if (skb->sk)
> -                               skb_set_owner_w(nskb, skb->sk);
> -                       consume_skb(skb);
> -               } else {
> +               if (unlikely(!nskb)) {
>                         kfree_skb(skb);
> +                       return NULL;
>                 }
> +               oskb = skb;
>                 skb = nskb;
>         }
> -       if (skb &&
> -           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
> +       if (pskb_expand_head(skb, delta, 0, GFP_ATOMIC)) {
>                 kfree_skb(skb);
> -               skb = NULL;
> +               kfree_skb(oskb);
> +               return NULL;
> +       }
> +       if (oskb) {
> +               if (sk)
> +                       skb_set_owner_w(skb, sk);
> +               consume_skb(oskb);
> +       } else if (sk) {
> +               delta = osize - skb_end_offset(skb);
> +               if (!is_skb_wmem(skb))
> +                       skb_set_owner_w(skb, sk);
> +               skb->truesize += delta;
> +               if (sk_fullsock(sk))
> +                       refcount_add(delta, &sk->sk_wmem_alloc);
>         }
>         return skb;
>  }
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 950f1e7..6cbda43 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2227,6 +2227,14 @@ void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
>  }
>  EXPORT_SYMBOL(skb_set_owner_w);
>
> +bool is_skb_wmem(const struct sk_buff *skb)
> +{
> +       return skb->destructor == sock_wfree ||
> +              skb->destructor == __sock_wfree ||
> +              (IS_ENABLED(CONFIG_INET) && skb->destructor == tcp_wfree);
> +}
> +EXPORT_SYMBOL(is_skb_wmem);
> +
>  static bool can_skb_orphan_partial(const struct sk_buff *skb)
>  {
>  #ifdef CONFIG_TLS_DEVICE
> --
> 1.8.3.1
>
