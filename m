Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECEE8609853
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 04:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiJXCuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 22:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJXCt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 22:49:59 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080F62E682
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 19:49:57 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-333a4a5d495so74578847b3.10
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 19:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Vcw+B8Y6vRBD/HTa6c0Z+4olQLKtZKYs9adB6IapZ84=;
        b=Zr21sIgkdoonmo7kwIdyV4A7U8a+/iAPLs6p6xi5KIMNT6NJCuEO1vtxnRxIlBNCrh
         8nP7isuid/lKyo41jaXX74cTj/2JAJ9XEvuh2wjru80WuM6MUabqtfeWT+u1UugSrWg4
         vqh8Kt5wKexBcWyDi7eDOFuH+QBktnkaAOMLYMq8uYczymOV7olHPDAUa/SsVoHiIfIa
         ocHjjddXF3L5HMO3F9O76BuRh7bhcSpt6Fvi0FQ7rufzsfwX9J/7aKzPBFL9VMrfEkkw
         Vbb5dpWQBIWUpMV+Bg+Llo8i1OTpMVDPPx1DLPoDf35o+J16S/DvoNNLrG+0TNaglKoe
         XYow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vcw+B8Y6vRBD/HTa6c0Z+4olQLKtZKYs9adB6IapZ84=;
        b=sHWsstVYAYsNh7172esZIczeWMvoTpWqkmBrN38n6VuSI+7Va8Buiu0+xTV9XYZ9kS
         gg988sOD/7GZnW+5XKHEAGsFGLc5BH8wVaRXVcKScBbQHc3mgR7b+89ovUTDX/sPj0QY
         xrYpyp9L0MK2MhxIvkhbqDrhkwe4/rdUCiktLeQpio3MSI9XRnP6IDCTXO8EjGU9t45x
         s5NXEygBbgrPimsFDmExOEl+iwutOTe3nSdqxtZrWFbAR8GcLdonW5DdIKd+jhjv1Z1R
         qkeNOWVtb1klHRALbVb79/Ite5xwC+s5I/DG9XQPpWU8JiW6Xuj2kaVyR9HnyHWe9OmH
         XoEA==
X-Gm-Message-State: ACrzQf2PnTVuWOcNvOQHF4fq+afuSxTwOkIqudcQkmJG535EGaEdxGBf
        hcIfjvseNyH/86VW/WEpQzxL/gsXN9l6m5SDwTzA6Q==
X-Google-Smtp-Source: AMsMyM4Bub9mcptLtgEmYFmY8sMltV4NvKCcq/nl2VcBaDOgSVT2eu3J0ToTSE6q0dU4jGU8WarA4GofGPg7/NRN4iw=
X-Received: by 2002:a0d:cb8a:0:b0:36c:12ed:9423 with SMTP id
 n132-20020a0dcb8a000000b0036c12ed9423mr5568499ywd.489.1666579796029; Sun, 23
 Oct 2022 19:49:56 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000fd9a4005ebbeac67@google.com>
In-Reply-To: <000000000000fd9a4005ebbeac67@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 23 Oct 2022 19:49:44 -0700
Message-ID: <CANn89iJdYrAsp8X61ojw=ZVPEZeYu2vWaTcyDQL8NQ5aZW+8cA@mail.gmail.com>
Subject: Re: [syzbot] kernel BUG in warn_crc32c_csum_combine
To:     syzbot <syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 23, 2022 at 7:37 PM syzbot
<syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    4d48f589d294 Add linux-next specific files for 20221021
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=1224e236880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2c4b7d600a5739a6
> dashboard link: https://syzkaller.appspot.com/bug?extid=1e9af9185d8850e2c2fa
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16f390f2880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=171f9c8c880000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/0c86bd0b39a0/disk-4d48f589.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/074059d37f1f/vmlinux-4d48f589.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/4a30bce99f60/mount_1.gz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> kernel BUG at net/core/skbuff.c:120!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 3637 Comm: syz-executor164 Not tainted 6.1.0-rc1-next-20221021-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022
> RIP: 0010:skb_push.cold-0x2/0x24
> Code: f8 4c 8b 4c 24 10 8b 4b 70 41 56 45 89 e8 4c 89 e2 41 57 48 89 ee 48 c7 c7 80 69 d4 8a ff 74 24 10 ff 74 24 20 e8 b2 77 c1 ff <0f> 0b e8 d4 d0 f1 f7 4c 8b 64 24 18 e8 ba 52 3e f8 48 c7 c1 e0 76
> RSP: 0018:ffffc90003e7ee70 EFLAGS: 00010286
> RAX: 0000000000000086 RBX: ffff888079c00280 RCX: 0000000000000000
> RDX: ffff888020a3ba80 RSI: ffffffff81621a58 RDI: fffff520007cfdc0
> RBP: ffffffff8ad47720 R08: 0000000000000086 R09: 0000000000000000
> R10: 0000000080000000 R11: 0000000075626b73 R12: ffffffff883cc6c6
> R13: 0000000000000048 R14: ffffffff8ad46940 R15: 00000000000000c0
> FS:  00007f2b0a939700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f9f0b184060 CR3: 00000000755db000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  skb_over_panic net/core/skbuff.c:125 [inline]
>  warn_crc32c_csum_combine.cold+0x0/0x1d net/core/skbuff.c:2152
>  dump_esp_combs net/key/af_key.c:3009 [inline]
>  pfkey_send_acquire+0x1856/0x2520 net/key/af_key.c:3230
>  km_query+0xac/0x220 net/xfrm/xfrm_state.c:2248
>  xfrm_state_find+0x2bfe/0x4f10 net/xfrm/xfrm_state.c:1165
>  xfrm_tmpl_resolve_one net/xfrm/xfrm_policy.c:2392 [inline]
>  xfrm_tmpl_resolve+0x2f3/0xd40 net/xfrm/xfrm_policy.c:2437
>  xfrm_resolve_and_create_bundle+0x123/0x2580 net/xfrm/xfrm_policy.c:2730
>  xfrm_lookup_with_ifid+0x229/0x20f0 net/xfrm/xfrm_policy.c:3064
>  xfrm_lookup net/xfrm/xfrm_policy.c:3193 [inline]
>  xfrm_lookup_route+0x36/0x1e0 net/xfrm/xfrm_policy.c:3204
>  ip_route_output_flow+0x114/0x150 net/ipv4/route.c:2880
>  udp_sendmsg+0x1963/0x2740 net/ipv4/udp.c:1224
>  inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:825
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:734
>  ____sys_sendmsg+0x334/0x8c0 net/socket.c:2482
>  ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
>  __sys_sendmmsg+0x18b/0x460 net/socket.c:2622
>  __do_sys_sendmmsg net/socket.c:2651 [inline]
>  __se_sys_sendmmsg net/socket.c:2648 [inline]
>  __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2648
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f2b0a9adf89
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f2b0a9392f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> RAX: ffffffffffffffda RBX: 00007f2b0aa334d0 RCX: 00007f2b0a9adf89
> RDX: 000000000800001d RSI: 0000000020007fc0 RDI: 0000000000000003
> RBP: 00007f2b0aa002b8 R08: 0000000000000000 R09: 0000000000000000
> R10: 000000a742250118 R11: 0000000000000246 R12: 00007f2b0aa000b8
> R13: 00007f2b0aa001b8 R14: 0100000000000000 R15: 00007f2b0aa334d8
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:skb_push.cold-0x2/0x24
> Code: f8 4c 8b 4c 24 10 8b 4b 70 41 56 45 89 e8 4c 89 e2 41 57 48 89 ee 48 c7 c7 80 69 d4 8a ff 74 24 10 ff 74 24 20 e8 b2 77 c1 ff <0f> 0b e8 d4 d0 f1 f7 4c 8b 64 24 18 e8 ba 52 3e f8 48 c7 c1 e0 76
> RSP: 0018:ffffc90003e7ee70 EFLAGS: 00010286
> RAX: 0000000000000086 RBX: ffff888079c00280 RCX: 0000000000000000
> RDX: ffff888020a3ba80 RSI: ffffffff81621a58 RDI: fffff520007cfdc0
> RBP: ffffffff8ad47720 R08: 0000000000000086 R09: 0000000000000000
> R10: 0000000080000000 R11: 0000000075626b73 R12: ffffffff883cc6c6
> R13: 0000000000000048 R14: ffffffff8ad46940 R15: 00000000000000c0
> FS:  00007f2b0a939700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fcc1415d300 CR3: 00000000755db000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
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

pfkey_send_acquire() allocates and skb, and then later this skb seems
to be too small to fit all dump info.

Maybe ->available status flips during the duration of the call ?

(So count_esp_combs() might return a value, but later dump_esp_combs()
needs more space)


Relevant patch suggests this could happen

commit ba953a9d89a00c078b85f4b190bc1dde66fe16b5
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu Aug 4 18:03:46 2022 +0800

    af_key: Do not call xfrm_probe_algs in parallel
