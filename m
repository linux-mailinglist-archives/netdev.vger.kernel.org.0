Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1886C941B
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 14:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbjCZMMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 08:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjCZMMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 08:12:15 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB81355B8;
        Sun, 26 Mar 2023 05:12:13 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so9255476pjt.2;
        Sun, 26 Mar 2023 05:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679832733;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cynBup3iIGDVF38yrwNGDEaLmfwmPVzuM59W25sx92c=;
        b=LPuwikY8txL/FwUQjFIt6q33J3IZd+SNIw2PaEnwYrtIbLhxf100xBohZBp4Um9ufo
         1jwq4vkE03dt0/XzTKCgoMgU3RtKRYSiPqDWUGLMY94U2pHogHm4eQzfFawX995jPahT
         TUOz0i/wytT4HeZrFnB7DBx57gvvnep7idpQ46SHdVvlrmz8KW3o4E9kRz3x22P9rhsz
         opRUbFKJwiJZqVaLTm0Wwt1dQOq6MAs2WSuwBH04DYXqSFW/WUD5GLHDeAz4Gl1QAdeD
         s+Tvkdy6+sjAOlAiyO0EirwC2HFaqUxh8KNNsZc0Xspt0LIIAggsrtWioy4E4pE9yrJe
         3hiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679832733;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cynBup3iIGDVF38yrwNGDEaLmfwmPVzuM59W25sx92c=;
        b=f9FiYKMv47DiMHHZKE0zM3aLr0e5RAzMNDxXeKOmBlX3DYDv0W75bJhCOAccu8+B1j
         OPVNB6sRpKcK8nMJ9En6KBMcQw4nCUiQKIv1WK0s8Zunlh+jpYh4SMOphgZ4FvqGkM1E
         XcVcfnK0MoJ1rbkiBIpBYtAGXPy5DvGBvXl6i6i92aw04X832VB4MIbv9Ppi5W0+kdql
         UJyDAAiPTzGrCwzkcG1l94qwoteNAopmmry6lCeV0/V/GIq1rleYVGmGjkPtKwjbh9gZ
         6Ramh0qM7lCA2C+5AhTc+GQ7GKZaBztndV3o/REOnw99rEkWA2KM+JwTqbObQksBVExR
         gBCw==
X-Gm-Message-State: AAQBX9f4WX8jsRlEIW+GMLWebAOb9HnbCGuMo8BIoFvBVbYGnlmgzYDN
        j/CXV+I46wtZDoVs90ZDzVE=
X-Google-Smtp-Source: AKy350as+pb46ZysylNF94P15s0jP3qRdGH3jiI2Rf0qAZbXBCrtWMBi/ZUDXGZmJaGlKhXM4T3tlg==
X-Received: by 2002:a17:90b:4d8b:b0:234:bf0:86b9 with SMTP id oj11-20020a17090b4d8b00b002340bf086b9mr8669957pjb.25.1679832733051;
        Sun, 26 Mar 2023 05:12:13 -0700 (PDT)
Received: from dragonet (dragonet.kaist.ac.kr. [143.248.133.220])
        by smtp.gmail.com with ESMTPSA id o10-20020a17090ab88a00b0023cfa3f7c9fsm5749400pjr.10.2023.03.26.05.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 05:12:12 -0700 (PDT)
Date:   Sun, 26 Mar 2023 21:12:08 +0900
From:   "Dae R. Jeong" <threeearcat@gmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: general protection fault in raw_seq_start
Message-ID: <ZCA2mGV_cmq7lIfV@dragonet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We observed an issue "general protection fault in raw_seq_start"
during fuzzing.

Unfortunately, we have not found a reproducer for the crash yet. We
will inform you if we have any update on this crash.
Detailed crash information is attached below.

Best regards,
Dae R. Jeong

-----

- Kernel version
  6.2

- Last executed input
  unshare(0x40060200)
  r0 = syz_open_procfs(0x0, &(0x7f0000002080)='net/raw\x00')
  socket$inet_icmp_raw(0x2, 0x3, 0x1)
  ppoll(0x0, 0x0, 0x0, 0x0, 0x0)
  socket$inet_icmp_raw(0x2, 0x3, 0x1)
  pread64(r0, &(0x7f0000000000)=""/10, 0xa, 0x10000000007f)

- Crash report
general protection fault, probably for non-canonical address 0xdffffc0000000005: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
CPU: 2 PID: 20952 Comm: syz-executor.0 Not tainted 6.2.0-g048ec869bafd-dirty #7
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
RIP: 0010:read_pnet include/net/net_namespace.h:383 [inline]
RIP: 0010:sock_net include/net/sock.h:649 [inline]
RIP: 0010:raw_get_next net/ipv4/raw.c:974 [inline]
RIP: 0010:raw_get_idx net/ipv4/raw.c:986 [inline]
RIP: 0010:raw_seq_start+0x431/0x800 net/ipv4/raw.c:995
Code: ef e8 33 3d 94 f7 49 8b 6d 00 4c 89 ef e8 b7 65 5f f7 49 89 ed 49 83 c5 98 0f 84 9a 00 00 00 48 83 c5 c8 48 89 e8 48 c1 e8 03 <42> 80 3c 30 00 74 08 48 89 ef e8 00 3d 94 f7 4c 8b 7d 00 48 89 ef
RSP: 0018:ffffc9001154f9b0 EFLAGS: 00010206
RAX: 0000000000000005 RBX: 1ffff1100302c8fd RCX: 0000000000000000
RDX: 0000000000000028 RSI: ffffc9001154f988 RDI: ffffc9000f77a338
RBP: 0000000000000029 R08: ffffffff8a50ffb4 R09: fffffbfff24b6bd9
R10: fffffbfff24b6bd9 R11: 0000000000000000 R12: ffff88801db73b78
R13: fffffffffffffff9 R14: dffffc0000000000 R15: 0000000000000030
FS:  00007f843ae8e700(0000) GS:ffff888063700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055bb9614b35f CR3: 000000003c672000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 seq_read_iter+0x4c6/0x10f0 fs/seq_file.c:225
 seq_read+0x224/0x320 fs/seq_file.c:162
 pde_read fs/proc/inode.c:316 [inline]
 proc_reg_read+0x23f/0x330 fs/proc/inode.c:328
 vfs_read+0x31e/0xd30 fs/read_write.c:468
 ksys_pread64 fs/read_write.c:665 [inline]
 __do_sys_pread64 fs/read_write.c:675 [inline]
 __se_sys_pread64 fs/read_write.c:672 [inline]
 __x64_sys_pread64+0x1e9/0x280 fs/read_write.c:672
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x4e/0xa0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x478d29
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f843ae8dbe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000011
RAX: ffffffffffffffda RBX: 0000000000791408 RCX: 0000000000478d29
RDX: 000000000000000a RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00000000f477909a R08: 0000000000000000 R09: 0000000000000000
R10: 000010000000007f R11: 0000000000000246 R12: 0000000000791740
R13: 0000000000791414 R14: 0000000000791408 R15: 00007ffc2eb48a50
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:read_pnet include/net/net_namespace.h:383 [inline]
RIP: 0010:sock_net include/net/sock.h:649 [inline]
RIP: 0010:raw_get_next net/ipv4/raw.c:974 [inline]
RIP: 0010:raw_get_idx net/ipv4/raw.c:986 [inline]
RIP: 0010:raw_seq_start+0x431/0x800 net/ipv4/raw.c:995
Code: ef e8 33 3d 94 f7 49 8b 6d 00 4c 89 ef e8 b7 65 5f f7 49 89 ed 49 83 c5 98 0f 84 9a 00 00 00 48 83 c5 c8 48 89 e8 48 c1 e8 03 <42> 80 3c 30 00 74 08 48 89 ef e8 00 3d 94 f7 4c 8b 7d 00 48 89 ef
RSP: 0018:ffffc9001154f9b0 EFLAGS: 00010206
RAX: 0000000000000005 RBX: 1ffff1100302c8fd RCX: 0000000000000000
RDX: 0000000000000028 RSI: ffffc9001154f988 RDI: ffffc9000f77a338
RBP: 0000000000000029 R08: ffffffff8a50ffb4 R09: fffffbfff24b6bd9
R10: fffffbfff24b6bd9 R11: 0000000000000000 R12: ffff88801db73b78
R13: fffffffffffffff9 R14: dffffc0000000000 R15: 0000000000000030
FS:  00007f843ae8e700(0000) GS:ffff888063700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f92ff166000 CR3: 000000003c672000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
