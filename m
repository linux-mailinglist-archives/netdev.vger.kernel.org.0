Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 759586D35B1
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 08:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbjDBGDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 02:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDBGDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 02:03:34 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C7220C3A
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 23:03:33 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id by14so7958732ljb.12
        for <netdev@vger.kernel.org>; Sat, 01 Apr 2023 23:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680415411;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BqYyW7EZa3aXT88mEfZolIz7f7/7ZPGYTCIRNY9RI9M=;
        b=fOJ7wDTwlrYOS/GNDSUHHsjAeYSg/GayPBpWqc7kP1CMcsDu5hkiXs97zj42/mMANK
         r6vI3PKt5XTxkdg4nCtE86MvsbKwSZ8rb8ZMWwOR8kFDdRnV5YbPcrryQD3MjxLilQzE
         9M0pzZTi5blpa27VqhOTwydOjx5KOOLB7b0YY3jRUpXe4An7TSeV44GqzgIwA6gN3KLC
         0tQK7NpnDuKVvTXeNreN3AaizueRCDzCk8mJ7jknYebfdzytPwT+pkVX1logRPv2p8KH
         kt/CAGqmMuvGoN5dxGBCfrvmFsunkcLLjZA+iJTAt/h8c73S0on8zjhToVO7Od38NC7P
         BUPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680415411;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BqYyW7EZa3aXT88mEfZolIz7f7/7ZPGYTCIRNY9RI9M=;
        b=2yF3MD9dKvdGNlEai8g2IMjAy8gw1e7yLJ+FrGJhyE3xL4R8YTgEjzj5Qf3xYDn5Tt
         ILCej+H9+S1XmRJAPvmzXPxiWUHzWasRytYtFoXPyMGBFX1vlA5iCmfHj5LCVsS2UoQR
         4/BM5LiAVkfSC5yiPMCi+epGhJ6LsTmg6w8+tSVmWm48R8fpP7I4/M3XdipGKZi6xU99
         bKh5FR3iqSh2HojLP45zERIaIgXT8Bf9xRA3MSUjrnpZ/+7RIVCtBNsWs3perWciNMvd
         fuhn4YcWk1lEiAjZ9i78Vydom+9UmoZMUSuPESDrksNqKyPOcY3pWtM9XajfbSn/uetP
         iZag==
X-Gm-Message-State: AAQBX9ctg7hQSTjEbkmJQDCGGUsPZ05UJvvJnWoLSzVyh/GM3c0esrtB
        zlbjpOdoJB534TaSIobkhdPVnqZiqbZbtizN596EIQ==
X-Google-Smtp-Source: AKy350YerB16ilv8TX3k75szf4T1Q9DIFKnnm0bV4ZFURKhZGAo86Bao2uKywHc9CvQMcAwZEUnhYzIq725L1Z/r/lc=
X-Received: by 2002:a2e:9949:0:b0:2a0:f395:cc44 with SMTP id
 r9-20020a2e9949000000b002a0f395cc44mr9591129ljj.8.1680415411058; Sat, 01 Apr
 2023 23:03:31 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000000cda0605c8bf219e@google.com> <00000000000073d78505cee3f389@google.com>
In-Reply-To: <00000000000073d78505cee3f389@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sun, 2 Apr 2023 08:03:18 +0200
Message-ID: <CACT4Y+Z_9WOw7x+xLzDqdjFUJ7Xy+PN9m9eBpFkYW22_=FjPHg@mail.gmail.com>
Subject: Re: [syzbot] WARNING: proc registration bug in clusterip_tg_check (3)
To:     syzbot <syzbot+08e6343a8cbd89b0c9d8@syzkaller.appspotmail.com>
Cc:     ap420073@gmail.com, coreteam@netfilter.org, davem@davemloft.net,
        dsahern@kernel.org, fw@strlen.de, kadlec@blackhole.kfki.hu,
        kadlec@netfilter.org, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-13.2 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Oct 2021 at 23:55, syzbot
<syzbot+08e6343a8cbd89b0c9d8@syzkaller.appspotmail.com> wrote:
>
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    2f111a6fd5b5 Merge tag 'ceph-for-5.15-rc7' of git://github..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13e33db4b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1f7f46d98a0da80e
> dashboard link: https://syzkaller.appspot.com/bug?extid=08e6343a8cbd89b0c9d8
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f70630b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1033ffecb00000
>
> The issue was bisected to:
>
> commit 2a61d8b883bbad26b06d2e6cc3777a697e78830d
> Author: Taehee Yoo <ap420073@gmail.com>
> Date:   Mon Nov 5 09:23:13 2018 +0000
>
>     netfilter: ipt_CLUSTERIP: fix sleep-in-atomic bug in clusterip_config_entry_put()
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16ce2121300000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=15ce2121300000
> console output: https://syzkaller.appspot.com/x/log.txt?x=11ce2121300000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+08e6343a8cbd89b0c9d8@syzkaller.appspotmail.com
> Fixes: 2a61d8b883bb ("netfilter: ipt_CLUSTERIP: fix sleep-in-atomic bug in clusterip_config_entry_put()")

#syz fix: netfilter: ip_tables: remove clusterip target

> ------------[ cut here ]------------
> proc_dir_entry 'ipt_CLUSTERIP/224.0.0.1' already registered
> WARNING: CPU: 1 PID: 24819 at fs/proc/generic.c:376 proc_register+0x34c/0x700 fs/proc/generic.c:376
> Modules linked in:
> CPU: 1 PID: 24819 Comm: syz-executor269 Not tainted 5.15.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:proc_register+0x34c/0x700 fs/proc/generic.c:376
> Code: df 48 89 f9 48 c1 e9 03 80 3c 01 00 0f 85 5d 03 00 00 48 8b 44 24 28 48 c7 c7 e0 b1 9c 89 48 8b b0 d8 00 00 00 e8 a0 2c 01 07 <0f> 0b 48 c7 c7 40 ac b4 8b e8 26 c0 46 07 48 8b 4c 24 38 48 b8 00
> RSP: 0018:ffffc900041df268 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff88806ca35580 RSI: ffffffff815e88a8 RDI: fffff5200083be3f
> RBP: ffff88801af3c838 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff815e264e R11: 0000000000000000 R12: ffff88801ee5b498
> R13: ffff88801ee5bd40 R14: dffffc0000000000 R15: 0000000000000009
> FS:  00007f976a6aa700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f976a6aa718 CR3: 00000000697b9000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  proc_create_data+0x130/0x190 fs/proc/generic.c:575
>  clusterip_config_init net/ipv4/netfilter/ipt_CLUSTERIP.c:292 [inline]
>  clusterip_tg_check+0x1b83/0x2300 net/ipv4/netfilter/ipt_CLUSTERIP.c:517
>  xt_check_target+0x26c/0x9e0 net/netfilter/x_tables.c:1038
>  check_target net/ipv4/netfilter/ip_tables.c:511 [inline]
>  find_check_entry.constprop.0+0x7a9/0x9a0 net/ipv4/netfilter/ip_tables.c:553
>  translate_table+0xc26/0x16a0 net/ipv4/netfilter/ip_tables.c:717
>  do_replace net/ipv4/netfilter/ip_tables.c:1135 [inline]
>  do_ipt_set_ctl+0x56e/0xb80 net/ipv4/netfilter/ip_tables.c:1629
>  nf_setsockopt+0x83/0xe0 net/netfilter/nf_sockopt.c:101
>  ip_setsockopt+0x3c3/0x3a60 net/ipv4/ip_sockglue.c:1435
>  tcp_setsockopt+0x136/0x2530 net/ipv4/tcp.c:3658
>  __sys_setsockopt+0x2db/0x610 net/socket.c:2176
>  __do_sys_setsockopt net/socket.c:2187 [inline]
>  __se_sys_setsockopt net/socket.c:2184 [inline]
>  __x64_sys_setsockopt+0xba/0x150 net/socket.c:2184
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f976af2bd19
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 31 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f976a6aa208 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
> RAX: ffffffffffffffda RBX: 00007f976afb4278 RCX: 00007f976af2bd19
> RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 00007f976afb4270 R08: 0000000000000298 R09: 0000000000000000
> R10: 00000000200002c0 R11: 0000000000000246 R12: 00007f976afb427c
> R13: 00007fff7aa240bf R14: 00007f976a6aa300 R15: 0000000000022000
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/00000000000073d78505cee3f389%40google.com.
