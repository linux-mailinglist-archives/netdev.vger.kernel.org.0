Return-Path: <netdev+bounces-1466-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C15F6FDD60
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:02:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAA141C20CF4
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 423B312B79;
	Wed, 10 May 2023 12:02:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DAA12B78
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 12:02:27 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266D36A6E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 05:02:25 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f4234f67feso115825e9.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 05:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683720143; x=1686312143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tOnK3QEUSO2Pa0Hql2jnLCw3y/zQzMgskPzUsbEDJx8=;
        b=VIbvYLCB/JsVydTyeT8FTEQc7waKgvxDWlaBZBeFzG2aR6rRkFoOWGjGwXj4SpESIY
         6gfmpjqmYgpPsLW09OjBPoUISZm0ZMoerAKQq4dJzaAVpYvu1dAgV7htYYZMoqIMM0c+
         YZr60hSYciyfIA0KSj9PHeURmp+gkXkRzxjlTn9O9XQ3otOZRcHKAovYDi1EPG1cDEx6
         liKqoIzs8Qs57FDWjbEJdnu2pQorbGqTm02uFxt5lSii0EYFSLJoWFsXkfigFovQDv5B
         jioFchHWiBBrjgTFs6331Q1/97JGob27j2ayZHLQhiHbXjiyLqz3rDb8JQxohZPep215
         qOEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683720143; x=1686312143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tOnK3QEUSO2Pa0Hql2jnLCw3y/zQzMgskPzUsbEDJx8=;
        b=ca/32tUM/BjKSak8oAPaZUR/WdWsTJM6+pSQqe2WKseLhpy58LwLa6i5yT/82/xQXA
         sDN9dMwyUh2BVIqvzyzhSRUkupKbdxn4IFA7KDGOxGfgNhJapx+kJmcSpu0ilBZnSUdk
         rE2ZjbDtbNXVMKJVQYQ/0k6b5c1RpkSknPDkunbs6obfocflcAgW7czZs/mOuJsCrGGq
         Cac90DGkTDMYBUvUPC9G9Bxe7iY9pBnqlZzpnaVGEo0TxIG1y4+mw4+bnDA7QycRax9J
         TSTXa2dANsspvGRq3ib9W786AhCOT5+w9C3C6T/7IdZdruWONllZmIqovBKStGcs/Iqd
         Iscw==
X-Gm-Message-State: AC+VfDzZmtCFZJCBYaVtNzpwihxbWdYw/FHOZ66wCnhRZH6COfmixRCE
	3H7EuGaCnXOfhgj/prwkDxMq5akNLiLnGsH0xH5kiA==
X-Google-Smtp-Source: ACHHUZ7qRVvWWpIvBI7U2RmnQhbLVYwcJTZvpQEwc5BrQe8sgh6OTTh+4FxYH2VT9sPKEWkd0vpZlr080/pl6sYOdss=
X-Received: by 2002:a05:600c:46cc:b0:3f1:6fe9:4a95 with SMTP id
 q12-20020a05600c46cc00b003f16fe94a95mr189908wmo.4.1683720143441; Wed, 10 May
 2023 05:02:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000a02fbd05fb558a79@google.com>
In-Reply-To: <000000000000a02fbd05fb558a79@google.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 10 May 2023 14:02:11 +0200
Message-ID: <CANn89iKSG01+XfjDDQQLqyrW3yU0MjzdwxKbj27p7+hSCvHT3A@mail.gmail.com>
Subject: Re: [syzbot] [net?] kernel BUG in nsh_gso_segment
To: syzbot <syzbot+632b5d9964208bfef8c0@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzkaller-bugs@googlegroups.com, 
	Dong Chenchen <dongchenchen2@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
	USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

CC Dong who is working on a fix.

On Wed, May 10, 2023 at 1:55=E2=80=AFPM syzbot
<syzbot+632b5d9964208bfef8c0@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    28b17f6270f1 net: phy: marvell-88x2222: remove unnecessar=
y..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D116a6a7828000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dd2214265c0654=
dae
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D632b5d9964208bf=
ef8c0
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binuti=
ls for Debian) 2.35.2
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/5f3e3e49ec73/dis=
k-28b17f62.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/cb64fed0222b/vmlinu=
x-28b17f62.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/e383b1704f8e/b=
zImage-28b17f62.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+632b5d9964208bfef8c0@syzkaller.appspotmail.com
>
> skbuff: skb_under_panic: text:ffffffff89e68b03 len:59147 put:212 head:fff=
f88801e2da000 data:ffff887f1e2da1a0 tail:0x288 end:0x2c0 dev:erspan0
> ------------[ cut here ]------------
> kernel BUG at net/core/skbuff.c:200!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 17167 Comm: syz-executor.5 Not tainted 6.3.0-rc7-syzkaller-02=
376-g28b17f6270f1 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 04/14/2023
> RIP: 0010:skb_panic+0x152/0x1d0 net/core/skbuff.c:200
> Code: 0f b6 04 01 84 c0 74 04 3c 03 7e 20 8b 4b 70 41 56 45 89 e8 48 c7 c=
7 40 4b 5c 8b 41 57 56 48 89 ee 52 4c 89 e2 e8 be f4 66 f9 <0f> 0b 4c 89 4c=
 24 10 48 89 54 24 08 48 89 34 24 e8 d9 c3 d4 f9 4c
> RSP: 0018:ffffc90007857340 EFLAGS: 00010282
> RAX: 000000000000008d RBX: ffff88804d3d9500 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff81677f6c RDI: 0000000000000005
> RBP: ffffffff8b5c5960 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000201 R11: 0000000000000000 R12: ffffffff89e68b03
> R13: 00000000000000d4 R14: ffff88802adae000 R15: 00000000000002c0
> FS:  00007f36759a9700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007faba606bbc6 CR3: 000000007c523000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  skb_under_panic net/core/skbuff.c:210 [inline]
>  skb_push+0xc8/0xe0 net/core/skbuff.c:2401
>  skb_gso_error_unwind include/linux/netdevice.h:5041 [inline]
>  nsh_gso_segment+0x7e3/0xa70 net/nsh/nsh.c:110
>  skb_mac_gso_segment+0x273/0x5e0 net/core/gro.c:141
>  __skb_gso_segment+0x32b/0x6e0 net/core/dev.c:3401
>  skb_gso_segment include/linux/netdevice.h:4859 [inline]
>  validate_xmit_skb+0x69c/0xef0 net/core/dev.c:3659
>  validate_xmit_skb_list+0xc0/0x130 net/core/dev.c:3709
>  sch_direct_xmit+0x3d5/0xc30 net/sched/sch_generic.c:327
>  __dev_xmit_skb net/core/dev.c:3805 [inline]
>  __dev_queue_xmit+0x14d6/0x3b10 net/core/dev.c:4210
>  dev_queue_xmit include/linux/netdevice.h:3085 [inline]
>  packet_xmit+0x260/0x390 net/packet/af_packet.c:276
>  packet_snd net/packet/af_packet.c:3083 [inline]
>  packet_sendmsg+0x347f/0x5030 net/packet/af_packet.c:3115
>  sock_sendmsg_nosec net/socket.c:724 [inline]
>  sock_sendmsg+0xde/0x190 net/socket.c:747
>  ____sys_sendmsg+0x71c/0x900 net/socket.c:2503
>  ___sys_sendmsg+0x110/0x1b0 net/socket.c:2557
>  __sys_sendmsg+0xf7/0x1c0 net/socket.c:2586
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f3674c8c169
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f36759a9168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f3674dac120 RCX: 00007f3674c8c169
> RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
> RBP: 00007f3674ce7ca1 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffcb2710e7f R14: 00007f36759a9300 R15: 0000000000022000
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:skb_panic+0x152/0x1d0 net/core/skbuff.c:200
> Code: 0f b6 04 01 84 c0 74 04 3c 03 7e 20 8b 4b 70 41 56 45 89 e8 48 c7 c=
7 40 4b 5c 8b 41 57 56 48 89 ee 52 4c 89 e2 e8 be f4 66 f9 <0f> 0b 4c 89 4c=
 24 10 48 89 54 24 08 48 89 34 24 e8 d9 c3 d4 f9 4c
> RSP: 0018:ffffc90007857340 EFLAGS: 00010282
> RAX: 000000000000008d RBX: ffff88804d3d9500 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff81677f6c RDI: 0000000000000005
> RBP: ffffffff8b5c5960 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000201 R11: 0000000000000000 R12: ffffffff89e68b03
> R13: 00000000000000d4 R14: ffff88802adae000 R15: 00000000000002c0
> FS:  00007f36759a9700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007faba606bbc6 CR3: 000000007c523000 CR4: 00000000003506f0
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
>
> If the bug is already fixed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want to change bug's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the bug is a duplicate of another bug, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup

