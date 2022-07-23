Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C9257F1D9
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 00:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236636AbiGWWHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 18:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGWWHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 18:07:23 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D13140C5;
        Sat, 23 Jul 2022 15:07:22 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id c12so2272371ede.3;
        Sat, 23 Jul 2022 15:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=1ud5s3lr2DV5lJPs9Tb+JHqzax7xR2iHCfmMlhijD0Q=;
        b=g4IMw2gWQDQwxUtc2W0jdPz63rrAgJ/pVLQX18cNUzmZbkmoeqjtEqX5d0JAANOsjS
         T1xXi3chhzfIYXTr3cm6gsOACQRmW6memdhK9MzyJ2gRcGdEl51+nmz+VHW0ddjESg4O
         4uTIdbHI8fC5HoyM5VgbHGIBCAoy5R3lLmFkRJZYAs+GAbTORQ+3Kye6WIwifyUv0qRS
         2ORHENPrHjnB5046CECTCDVHqqtTJIaspUgHYIpIAR9zFsUpVyFzaDD9VQgMf7z8u+e1
         WAsksYXiJbZOPKPCgbwGWAObdDH0eBSkZcs9ElZOMQSYTIxVT+eUxC9CfKsptbSiReC3
         YxyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=1ud5s3lr2DV5lJPs9Tb+JHqzax7xR2iHCfmMlhijD0Q=;
        b=DsLVO+sdoUu6ZrXMhxv0C9X+7SGNr1nfZhzawsks9XQWGJ99wIxHodroDoYa1OyQSN
         hZ1b4yqIHBO7mBbpKJea+2nu4Q4z1rvF8XYAAI7k85UQkhmsT2OFX4rIHGuqN5tsdjRB
         sxaSNmGJrzSQ+llg68cArkYqlzX+lzqYJ5So55upJfhUcPR6nMJUx0xCSknwPrUCBPFj
         +j7J6pzeMnExI7QOqgw1KEGawR2YO5QAvGLhvQRdPzXYFchoqKfDNOrVnBSyn5WwuxsD
         iqmVIsffVfKaA3vUB3BITkOPInRvN44Wz4vu56koeKUZi7LsxtYw/hdgvrIqfabTOM4V
         xapA==
X-Gm-Message-State: AJIora/sAq72bAW5cq7TgaEBsxnBRl/MzaHldBopnQhAem2Aq0Dn5pD9
        ManRerfXpvp3WqoMUpEQcbD6VBXqrhHT5fwPsNY=
X-Google-Smtp-Source: AGRyM1uuDrMDBoiptsY8ACLbUpqed0qOT5qs7CacC6KucPKzUiqDHiV3nbCFVLfMsm66WrCpi6rt7lXe4dINxW0MFFw=
X-Received: by 2002:a05:6402:5299:b0:435:61da:9bb9 with SMTP id
 en25-20020a056402529900b0043561da9bb9mr6079472edb.21.1658614040701; Sat, 23
 Jul 2022 15:07:20 -0700 (PDT)
MIME-Version: 1.0
From:   Dipanjan Das <mail.dipanjan.das@gmail.com>
Date:   Sat, 23 Jul 2022 15:07:09 -0700
Message-ID: <CANX2M5Yphi3JcCsMf3HgPPkk9XCfOKO85gyMdxQf3_O74yc1Hg@mail.gmail.com>
Subject: general protection fault in sock_def_error_report
To:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        sashal@kernel.org, edumazet@google.com, gregkh@linuxfoundation.org,
        steffen.klassert@secunet.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Cc:     syzkaller@googlegroups.com, fleischermarius@googlemail.com,
        its.priyanka.bose@gmail.com
Content-Type: multipart/mixed; boundary="000000000000b76c5b05e4802c16"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000b76c5b05e4802c16
Content-Type: text/plain; charset="UTF-8"

Hi,

We would like to report the following bug which has been found by our
modified version of syzkaller.

======================================================
description: general protection fault in sock_def_error_report
affected file: net/core/sock.c
kernel version: 5.4.206
kernel commit: 6584107915561f860b7b05dcca5c903dd62a308d
git tree: upstream
kernel config: https://syzkaller.appspot.com/text?tag=KernelConfig&x=1aab6d4187ddf667
crash reproducer: We could only generate the syz-repro for this bug.
The corresponding C-repro does not trigger the bug. The syz-repo can
be run as: `syz-execprog -executor=./syz-executor -repeat=0 -procs=16
-cover=0 repro.syz`
======================================================
Crash log:
======================================================
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 5480 Comm: syz-executor.2 Tainted: G           OE     5.4.206+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:__wake_up_common+0x198/0x650 kernel/sched/wait.c:86
Code: 18 48 39 1c 24 0f 85 eb 01 00 00 8b 44 24 10 48 83 c4 28 5b 5d
41 5c 41 5d 41 5e 41 5f c3 49 8d 54 24 18 48 89 d0 48 c1 e8 03 <80> 3c
28 00 0f 85 c1 02 00 00 49 8b 44 24 18 4d 89 e0 48 83 e8 18
RSP: 0018:ffff8880b25ff4b0 EFLAGS: 00010802
RAX: 1bd5a00000000020 RBX: 0000000000000002 RCX: ffffc900080f5000
RDX: dead000000000100 RSI: ffffffff81c30ef8 RDI: 0000000000000001
RBP: dffffc0000000000 R08: ffff88809f932380 R09: ffffed101637d55d
R10: 00000000000000a0 R11: ffff88809f932380 R12: dead0000000000e8
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000008
FS:  00007f53462e4700(0000) GS:ffff88811a000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f75554d1098 CR3: 00000000b1a27004 CR4: 0000000000160ef0
Call Trace:
 __wake_up_common_lock+0xd0/0x130 kernel/sched/wait.c:123
 sock_def_error_report+0x16a/0x590 net/core/sock.c:2817
 tcp_disconnect+0x14b9/0x1dc0 net/ipv4/tcp.c:2701
 __inet_stream_connect+0xb44/0xe60 net/ipv4/af_inet.c:707
 tcp_sendmsg_fastopen net/ipv4/tcp.c:1176 [inline]
 tcp_sendmsg_locked+0x22b9/0x3220 net/ipv4/tcp.c:1218
 tcp_sendmsg+0x2b/0x40 net/ipv4/tcp.c:1445
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:807
 smc_sendmsg+0x31f/0x3f0 net/smc/af_smc.c:1566
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0xd3/0x130 net/socket.c:657
 ____sys_sendmsg+0x304/0x7e0 net/socket.c:2286
 ___sys_sendmsg+0x11d/0x1b0 net/socket.c:2340
 __sys_sendmmsg+0x195/0x480 net/socket.c:2443
 __do_sys_sendmmsg net/socket.c:2472 [inline]
 __se_sys_sendmmsg net/socket.c:2469 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2469
 do_syscall_64+0xf6/0x7b0 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f53483544ed
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f53462e3be8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f5348473040 RCX: 00007f53483544ed
RDX: 0000000000000001 RSI: 0000000020001a80 RDI: 0000000000000003
RBP: 00007f53483c02e1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000020000084 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffcd7ac395f R14: 00007f5348473040 R15: 00007f53462e3d80
Modules linked in: uio_ivshmem(OE) uio(E)
---[ end trace d3594c146e1822a7 ]---
RIP: 0010:__wake_up_common+0x198/0x650 kernel/sched/wait.c:86
Code: 18 48 39 1c 24 0f 85 eb 01 00 00 8b 44 24 10 48 83 c4 28 5b 5d
41 5c 41 5d 41 5e 41 5f c3 49 8d 54 24 18 48 89 d0 48 c1 e8 03 <80> 3c
28 00 0f 85 c1 02 00 00 49 8b 44 24 18 4d 89 e0 48 83 e8 18
RSP: 0018:ffff8880b25ff4b0 EFLAGS: 00010802
RAX: 1bd5a00000000020 RBX: 0000000000000002 RCX: ffffc900080f5000
RDX: dead000000000100 RSI: ffffffff81c30ef8 RDI: 0000000000000001
RBP: dffffc0000000000 R08: ffff88809f932380 R09: ffffed101637d55d
R10: 00000000000000a0 R11: ffff88809f932380 R12: dead0000000000e8
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000008
FS:  00007f53462e4700(0000) GS:ffff88811a000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f75554d1098 CR3: 00000000b1a27004 CR4: 0000000000160ef0
----------------
Code disassembly (best guess):
   0: 18 48 39              sbb    %cl,0x39(%rax)
   3: 1c 24                sbb    $0x24,%al
   5: 0f 85 eb 01 00 00    jne    0x1f6
   b: 8b 44 24 10          mov    0x10(%rsp),%eax
   f: 48 83 c4 28          add    $0x28,%rsp
  13: 5b                    pop    %rbx
  14: 5d                    pop    %rbp
  15: 41 5c                pop    %r12
  17: 41 5d                pop    %r13
  19: 41 5e                pop    %r14
  1b: 41 5f                pop    %r15
  1d: c3                    retq
  1e: 49 8d 54 24 18        lea    0x18(%r12),%rdx
  23: 48 89 d0              mov    %rdx,%rax
  26: 48 c1 e8 03          shr    $0x3,%rax
* 2a: 80 3c 28 00          cmpb   $0x0,(%rax,%rbp,1) <-- trapping instruction
  2e: 0f 85 c1 02 00 00    jne    0x2f5
  34: 49 8b 44 24 18        mov    0x18(%r12),%rax
  39: 4d 89 e0              mov    %r12,%r8
  3c: 48 83 e8 18          sub    $0x18,%rax

-- 
Thanks and Regards,

Dipanjan

--000000000000b76c5b05e4802c16
Content-Type: application/octet-stream; name="repro.syz"
Content-Disposition: attachment; filename="repro.syz"
Content-Transfer-Encoding: base64
Content-ID: <f_l5yfvfd70>
X-Attachment-Id: f_l5yfvfd70

cjAgPSBzb2NrZXQkaW5ldF9zbWMoMHgyYiwgMHgxLCAweDApCnBvbGwoJigweDdmMDAwMDAwMDE0
MCk9W3tyMCwgMHgxMDA4fSwge3IwLCAweDIwfSwge3IwLCAweDIwMDB9LCB7MHhmZmZmZmZmZmZm
ZmZmZmZmLCAweDEwMDB9LCB7cjAsIDB4MjIwfSwgezB4ZmZmZmZmZmZmZmZmZmZmZiwgMHgxMDAw
MX0sIHsweGZmZmZmZmZmZmZmZmZmZmYsIDB4MjE0MX0sIHtyMCwgMHgyMDAwfSwge31dLCAweDks
IDB4N2ZmZmZmZmYpCnNlbmRtbXNnJGluZXQocjAsICYoMHg3ZjAwMDAwMDFhODApPVt7eyYoMHg3
ZjAwMDAwMDAzODApPXsweDIsIDB4MCwgQGxvY2FsfSwgMHgxMCwgMHgwfX1dLCAweDEsIDB4MjAw
MDAwODQpCg==
--000000000000b76c5b05e4802c16--
