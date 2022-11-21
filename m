Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB0463242E
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbiKUNry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbiKUNrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:47:49 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08DDB1
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:47:39 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id t2-20020a6b6402000000b006dea34ad528so3059656iog.1
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:47:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LD9H/9Knv1l6U5mL6/frwAOufqA8ut3NkTvM/u6y6Hs=;
        b=CuVpw6S2TbacPUPAR9QKG9R9KtbEeM00z0nstTQXJt+jmLkaY2NROvkGQZlWbp2Dy/
         MRbW57Un8R42LxwB0/dpQYYFpJdX/3wf9+iSZBoGkiA+MLCiAHzBtkg2TYUSoz9dPlbc
         rn9ohg9F+YsO195VTJL6F/XIVErH9Nq4s5TtAwZPAfEqBH9DiwVq1CGVhGKV1+o2lIPg
         8QhGEmll0/PeAWjpDDVADHf6Z8Ixu5jhJxyETwbePow16MORWGs79A7NdaIQUTIbv9js
         n26gp0h4G6h4ETQh2uDAQN62Y7PKESW+0SUyhFyNnQ2N8Xsx3MwSDMT+LPho4IAjo+I1
         wCPw==
X-Gm-Message-State: ANoB5pnbfvioRQB2l3YR5pTq7qwkul7huNrC5Ph6Jmo8fadkehpL91Ld
        5mrWY4l2+EeKaN444TIr9A8Ds9i+cxE+aJ/GhKwykHZtToOW
X-Google-Smtp-Source: AA0mqf7CqdJ9ZLw9fqsA1wdYgqAnghyW6l/wNxAJF1fgCH4+oAGA1871vA9M61B2lGnyoiVDFi+ma+/h+2bnRfIw5rxmkGowZSS5
MIME-Version: 1.0
X-Received: by 2002:a02:93e5:0:b0:375:8bcb:a4e9 with SMTP id
 z92-20020a0293e5000000b003758bcba4e9mr1930252jah.228.1669038458562; Mon, 21
 Nov 2022 05:47:38 -0800 (PST)
Date:   Mon, 21 Nov 2022 05:47:38 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000706e6f05edfb4ce0@google.com>
Subject: [syzbot] linux-next test error: general protection fault in xfrm_policy_lookup_bytype
From:   syzbot <syzbot+bfb2bee01b9c01fff864@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, sfr@canb.auug.org.au,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e4cd8d3ff7f9 Add linux-next specific files for 20221121
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1472370d880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a0ebedc6917bacc1
dashboard link: https://syzkaller.appspot.com/bug?extid=bfb2bee01b9c01fff864
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b59eb967701d/disk-e4cd8d3f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/37a7b43e6e84/vmlinux-e4cd8d3f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ebfb0438e6a2/bzImage-e4cd8d3f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bfb2bee01b9c01fff864@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000019: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000000c8-0x00000000000000cf]
CPU: 0 PID: 5295 Comm: kworker/0:3 Not tainted 6.1.0-rc5-next-20221121-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: ipv6_addrconf addrconf_dad_work
RIP: 0010:xfrm_policy_lookup_bytype.cold+0x1c/0x54 net/xfrm/xfrm_policy.c:2139
Code: 80 44 28 8e e8 9a 88 37 fa e9 28 e7 7b fe e8 c0 25 7a f7 49 8d bf cc 00 00 00 b8 ff ff 37 00 48 89 fa 48 c1 e0 2a 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 1c 41
RSP: 0018:ffffc90003cdf1e0 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000019 RSI: ffffffff8a068150 RDI: 00000000000000cc
RBP: 0000000000000000 R08: 0000000000000007 R09: fffffffffffff000
R10: 0000000000000000 R11: 0000000000000005 R12: 0000000000000000
R13: ffff88802ae78000 R14: ffffed10055cf2ff R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb5cb893300 CR3: 00000000714fb000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 xfrm_policy_lookup net/xfrm/xfrm_policy.c:2151 [inline]
 xfrm_bundle_lookup net/xfrm/xfrm_policy.c:2958 [inline]
 xfrm_lookup_with_ifid+0x39b/0x20f0 net/xfrm/xfrm_policy.c:3099
 xfrmi_xmit2 net/xfrm/xfrm_interface.c:404 [inline]
 xfrmi_xmit+0x3c7/0x1b90 net/xfrm/xfrm_interface.c:521
 __netdev_start_xmit include/linux/netdevice.h:4859 [inline]
 netdev_start_xmit include/linux/netdevice.h:4873 [inline]
 xmit_one net/core/dev.c:3583 [inline]
 dev_hard_start_xmit+0x1c2/0x990 net/core/dev.c:3599
 __dev_queue_xmit+0x2cdf/0x3ba0 net/core/dev.c:4249
 dev_queue_xmit include/linux/netdevice.h:3029 [inline]
 neigh_connected_output+0x3c4/0x520 net/core/neighbour.c:1600
 neigh_output include/net/neighbour.h:546 [inline]
 ip6_finish_output2+0x56c/0x1530 net/ipv6/ip6_output.c:134
 __ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
 ip6_finish_output+0x694/0x1170 net/ipv6/ip6_output.c:206
 NF_HOOK_COND include/linux/netfilter.h:291 [inline]
 ip6_output+0x1f1/0x540 net/ipv6/ip6_output.c:227
 dst_output include/net/dst.h:444 [inline]
 NF_HOOK include/linux/netfilter.h:302 [inline]
 ndisc_send_skb+0xa63/0x1740 net/ipv6/ndisc.c:508
 ndisc_send_rs+0x132/0x6f0 net/ipv6/ndisc.c:718
 addrconf_dad_completed+0x37a/0xda0 net/ipv6/addrconf.c:4248
 addrconf_dad_begin net/ipv6/addrconf.c:4014 [inline]
 addrconf_dad_work+0x820/0x12d0 net/ipv6/addrconf.c:4116
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:xfrm_policy_lookup_bytype.cold+0x1c/0x54 net/xfrm/xfrm_policy.c:2139
Code: 80 44 28 8e e8 9a 88 37 fa e9 28 e7 7b fe e8 c0 25 7a f7 49 8d bf cc 00 00 00 b8 ff ff 37 00 48 89 fa 48 c1 e0 2a 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 1c 41
RSP: 0018:ffffc90003cdf1e0 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000019 RSI: ffffffff8a068150 RDI: 00000000000000cc
RBP: 0000000000000000 R08: 0000000000000007 R09: fffffffffffff000
R10: 0000000000000000 R11: 0000000000000005 R12: 0000000000000000
R13: ffff88802ae78000 R14: ffffed10055cf2ff R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb5cb893300 CR3: 00000000714fb000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	44 28 8e e8 9a 88 37 	sub    %r9b,0x37889ae8(%rsi)
   7:	fa                   	cli
   8:	e9 28 e7 7b fe       	jmpq   0xfe7be735
   d:	e8 c0 25 7a f7       	callq  0xf77a25d2
  12:	49 8d bf cc 00 00 00 	lea    0xcc(%r15),%rdi
  19:	b8 ff ff 37 00       	mov    $0x37ffff,%eax
  1e:	48 89 fa             	mov    %rdi,%rdx
  21:	48 c1 e0 2a          	shl    $0x2a,%rax
  25:	48 c1 ea 03          	shr    $0x3,%rdx
* 29:	0f b6 14 02          	movzbl (%rdx,%rax,1),%edx <-- trapping instruction
  2d:	48 89 f8             	mov    %rdi,%rax
  30:	83 e0 07             	and    $0x7,%eax
  33:	83 c0 03             	add    $0x3,%eax
  36:	38 d0                	cmp    %dl,%al
  38:	7c 04                	jl     0x3e
  3a:	84 d2                	test   %dl,%dl
  3c:	75 1c                	jne    0x5a
  3e:	41                   	rex.B


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
