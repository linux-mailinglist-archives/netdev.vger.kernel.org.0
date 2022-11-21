Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB9C632827
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 16:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbiKUP3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 10:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbiKUP2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 10:28:49 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463E9C8469;
        Mon, 21 Nov 2022 07:28:34 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id me22so12777160ejb.8;
        Mon, 21 Nov 2022 07:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hoTrouIZVhvpH4CAuc3k03YnFRSR2oWgJtrCBTl9X2g=;
        b=CDKi+Dl1HzFWlab7aKVtda7kjXD7qAL+UCeSxI/ftCqNNj2tGrzw4LtH4CWUXk4kLo
         kP5Gd4z+WlHi9wkhy+kxAFSSbjMaSqHjNKdtDM/qjyGbJNgNJaU9xTB9X/QTci/bE9fZ
         7r4aoxcIcFNj/x4ixfW/tVP/hpmwJqL2nEO3MuOdoF15g2T3S5DX06Orq7Bb5qbPfYRW
         f2XD3Esvj00Jplrkd1JbQgNPN5H7x8AVmnpK5VdQR4UK0Ys5t5Vx2o9I3WBbNYCKXQqx
         bL6aoVij/vdwj7UlAGJyKTGPmjnKecJMKDJ56S/DyIoj3Iv4QVjNxuEDJMFMtu0fiqoF
         XPlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hoTrouIZVhvpH4CAuc3k03YnFRSR2oWgJtrCBTl9X2g=;
        b=7nWneiRC5DqlbwrrE/2ALFC/utUqXP55mFH0uT8w8DURO2RiS4iSz/bj+1xmklQ7j1
         MBzvEZOw+tT3zxT8KsPuSvCOPvD9s8FN6i5lkyIlpnh0E3fL7OZLNAJMB6w0JMc+3USH
         QS9ximxjZJrK9jn1OVwPqR6GIJQl8oWOkkDGUF2R0JtvA7HtJlTNhW+UztIsOK3s2aEp
         awKO0SFvUFbsldKXNNpoa8RXvB3uOLnFCVPE1kZ86cOgPSVQosemaKYbsQp8G+Lx+oM3
         zond/ptFW+d49B6mii0RjBPeYBmrj2LIi7ILtZAyIQ0KqfGrVHtwpEZXo8MZ4R5gJWWd
         +SDA==
X-Gm-Message-State: ANoB5pm1G9OO9IpXKL7LetjVte0th95C82cGZYeTw0Q+R4Y0iBHMaY8e
        /2avQ036dlMZQ2GXesDxqv8UOZY1LIWBlbH0I0A=
X-Google-Smtp-Source: AA0mqf4FBTx1VFIh/xj6nggsJGq6o0Qnk+AkUjTnEGI4HjruJVFEJ/Zkmex1zK2eNtpedoJPoMWD9bcMA8gQmEVtxbQ=
X-Received: by 2002:a17:907:3ac5:b0:78d:5d4a:c12f with SMTP id
 fi5-20020a1709073ac500b0078d5d4ac12fmr16439252ejc.421.1669044512722; Mon, 21
 Nov 2022 07:28:32 -0800 (PST)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Mon, 21 Nov 2022 23:27:56 +0800
Message-ID: <CAO4mrfc+5zmJ_skpczu5aWW3jNWWPwq15LHJ2fzsZ1mzJ3CSGw@mail.gmail.com>
Subject: BUG: unable to handle kernel NULL pointer dereference in xfrm_policy_lookup_bytype
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, bpf@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux Developer,

Recently when using our tool to fuzz kernel, the following crash was triggered.

HEAD commit: 147307c69ba
git tree: upstream
compiler: clang 12.0.0
console output:
https://drive.google.com/file/d/1DW61s3gHmgG-1aa8JP-KfsQzVW_1zm_P/view?usp=share_link
kernel config: https://drive.google.com/file/d/1NAf4S43d9VOKD52xbrqw-PUP1Mbj8z-S/view?usp=share_link
Syz reproducer:
https://drive.google.com/file/d/1LfCJ4C3H2QKanNGIfVwEAewaN53G9CSE/view?usp=share_link

Unfortunately, if we transform the syz reproducer to C reproducer with
syz-prog2c, the crash would not happen. Please consider using
syz-execprog and syz-executor to reproduce the crash.

BUG: kernel NULL pointer dereference, address: 000000000000006c
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 106d3d067 P4D 106d3d067 PUD 107d32067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
CPU: 0 PID: 2783 Comm: kworker/0:3 Not tainted 6.1.0-rc5-next-20221118 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
Workqueue: wg-crypt-wg0 wg_packet_tx_worker
RIP: 0010:xfrm_policy_lookup_bytype+0x1764/0x1790 net/xfrm/xfrm_policy.c:2139
Code: 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 03 4b 1f fd eb 0c
e8 fc 4a 1f fd e8 17 a3 12 fd 31 ed 48 8d 7d 6c e8 ec b3 32 fd <8b> 75
6c 48 c7 c7 89 21 7e 85 44 89 e2 31 c0 e8 38 5f a1 00 eb a6
RSP: 0000:ffffc90000003740 EFLAGS: 00010246
RAX: ffff88813bc274d8 RBX: 0000000000000000 RCX: ffffffff840866f4
RDX: 00000000000004d4 RSI: 0000000000000000 RDI: 000000000000006c
RBP: 0000000000000000 R08: 000000000000006f R09: 0000000000000000
R10: 0001ffffffffffff R11: ffff8881032a4000 R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000000006c CR3: 0000000104bd7000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 xfrm_policy_lookup net/xfrm/xfrm_policy.c:2151 [inline]
 __xfrm_policy_check+0x5c1/0x19e0 net/xfrm/xfrm_policy.c:3571
 __xfrm_policy_check2 include/net/xfrm.h:1132 [inline]
 xfrm_policy_check include/net/xfrm.h:1137 [inline]
 xfrm6_policy_check include/net/xfrm.h:1147 [inline]
 udpv6_queue_rcv_one_skb+0x184/0xb90 net/ipv6/udp.c:703
 udpv6_queue_rcv_skb+0x53d/0x5c0 net/ipv6/udp.c:792
 udp6_unicast_rcv_skb net/ipv6/udp.c:935 [inline]
 __udp6_lib_rcv+0xceb/0x1770 net/ipv6/udp.c:1020
 udpv6_rcv+0x4b/0x50 net/ipv6/udp.c:1133
 ip6_protocol_deliver_rcu+0x85f/0xd80 net/ipv6/ip6_input.c:439
 ip6_input_finish net/ipv6/ip6_input.c:484 [inline]
 NF_HOOK include/linux/netfilter.h:302 [inline]
 ip6_input+0x9f/0x180 net/ipv6/ip6_input.c:493
 dst_input include/net/dst.h:454 [inline]
 ip6_rcv_finish+0x1e9/0x2d0 net/ipv6/ip6_input.c:79
 NF_HOOK include/linux/netfilter.h:302 [inline]
 ipv6_rcv+0x85/0x140 net/ipv6/ip6_input.c:309
 __netif_receive_skb_one_core net/core/dev.c:5482 [inline]
 __netif_receive_skb+0x8b/0x1b0 net/core/dev.c:5596
 process_backlog+0x23f/0x3b0 net/core/dev.c:5924
 __napi_poll+0x65/0x420 net/core/dev.c:6485
 napi_poll net/core/dev.c:6552 [inline]
 net_rx_action+0x37e/0x730 net/core/dev.c:6663
 __do_softirq+0xf2/0x2c9 kernel/softirq.c:571
 do_softirq+0xb1/0xf0 kernel/softirq.c:472
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x6f/0x80 kernel/softirq.c:396
 __raw_read_unlock_bh include/linux/rwlock_api_smp.h:257 [inline]
 _raw_read_unlock_bh+0x17/0x20 kernel/locking/spinlock.c:284
 wg_socket_send_skb_to_peer+0x107/0x120 drivers/net/wireguard/socket.c:184
 wg_packet_create_data_done drivers/net/wireguard/send.c:251 [inline]
 wg_packet_tx_worker+0x142/0x360 drivers/net/wireguard/send.c:276
 process_one_work+0x3e3/0x950 kernel/workqueue.c:2289
 worker_thread+0x628/0xa70 kernel/workqueue.c:2436
 kthread+0x1a9/0x1e0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
Modules linked in:
CR2: 000000000000006c
---[ end trace 0000000000000000 ]---
RIP: 0010:xfrm_policy_lookup_bytype+0x1764/0x1790 net/xfrm/xfrm_policy.c:2139
Code: 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 03 4b 1f fd eb 0c
e8 fc 4a 1f fd e8 17 a3 12 fd 31 ed 48 8d 7d 6c e8 ec b3 32 fd <8b> 75
6c 48 c7 c7 89 21 7e 85 44 89 e2 31 c0 e8 38 5f a1 00 eb a6
RSP: 0000:ffffc90000003740 EFLAGS: 00010246
RAX: ffff88813bc274d8 RBX: 0000000000000000 RCX: ffffffff840866f4
RDX: 00000000000004d4 RSI: 0000000000000000 RDI: 000000000000006c
RBP: 0000000000000000 R08: 000000000000006f R09: 0000000000000000
R10: 0001ffffffffffff R11: ffff8881032a4000 R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000000006c CR3: 0000000104bd7000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0: 00 00                add    %al,(%rax)
   2: 00 5b 41              add    %bl,0x41(%rbx)
   5: 5c                    pop    %rsp
   6: 41 5d                pop    %r13
   8: 41 5e                pop    %r14
   a: 41 5f                pop    %r15
   c: 5d                    pop    %rbp
   d: c3                    retq
   e: e8 03 4b 1f fd        callq  0xfd1f4b16
  13: eb 0c                jmp    0x21
  15: e8 fc 4a 1f fd        callq  0xfd1f4b16
  1a: e8 17 a3 12 fd        callq  0xfd12a336
  1f: 31 ed                xor    %ebp,%ebp
  21: 48 8d 7d 6c          lea    0x6c(%rbp),%rdi
  25: e8 ec b3 32 fd        callq  0xfd32b416
* 2a: 8b 75 6c              mov    0x6c(%rbp),%esi <-- trapping instruction
  2d: 48 c7 c7 89 21 7e 85 mov    $0xffffffff857e2189,%rdi
  34: 44 89 e2              mov    %r12d,%edx
  37: 31 c0                xor    %eax,%eax
  39: e8 38 5f a1 00        callq  0xa15f76
  3e: eb a6                jmp    0xffffffe6

Best,
Wei
