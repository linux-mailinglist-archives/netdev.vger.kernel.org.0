Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B2F6775EC
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 08:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbjAWH7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 02:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbjAWH66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 02:58:58 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E935511E89
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 23:58:51 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id i14-20020a056e020d8e00b003034b93bd07so7843117ilj.14
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 23:58:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I5Up1rMGfcNvyDnvVl+nuzPiYvmCyR5tUMOQkGTcDP8=;
        b=PIU3tIHJtWkANYO2UOVPRZCy5Yb2LfKhcIIkg8RVBRiiE76CFTwSOgZSUJBBG3UMl+
         4S/mZ2ADxM5+Qf05dkHtrQk4ibn1E06WJ3MTnborw3ZLjC3hLOMzJsGojBibZXKgvsgf
         jWbGnipmXTFK6O81uGEBIykShVbSWabJz1XYz5tryXkne+l52wc7bD0YxLpSNSFRH2E+
         jOq0r2xrt+jTn4kT8UpjQRZ0QZwJt+pW7Xmr/zqoQCNtTrKKGkdeh9amJE17xzLj0hKP
         bkGmq+hBu5mDEh1x310l4qL2Z7FIA7IuyOAYxrRO/oZNl5ehRGoRIDnFNtjs40WFNPYT
         Q0lA==
X-Gm-Message-State: AFqh2kofl4AO5al2unrihZdTBgFE2bRjmDldfkgeya85Xz2fPHdCsRaU
        KuCiS2nFw1gTyCi26ENxs97Q5rQZv6DgoJovn8ofiqiH2uht
X-Google-Smtp-Source: AMrXdXsWQAbLU3P6XZkfVyzuUWTTdQiRIx3df0oWJ6qeqlWH4+HXo3sv+PYCwWrvwaM85v5uWcGHfLyv0vjN2cepd88wggadUdQr
MIME-Version: 1.0
X-Received: by 2002:a05:6638:4916:b0:375:c16b:7776 with SMTP id
 cx22-20020a056638491600b00375c16b7776mr2329370jab.54.1674460731151; Sun, 22
 Jan 2023 23:58:51 -0800 (PST)
Date:   Sun, 22 Jan 2023 23:58:51 -0800
In-Reply-To: <000000000000f5b4ab05f0522438@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000012245205f2e9c5a1@google.com>
Subject: Re: [syzbot] BUG: corrupted list in nfc_llcp_register_device
From:   syzbot <syzbot+c1d0a03d305972dbbe14@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dvyukov@google.com, edumazet@google.com,
        hdanton@sina.com, krzysztof.kozlowski@linaro.org, kuba@kernel.org,
        linma@zju.edu.cn, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    2475bf0250de Merge tag 'sched_urgent_for_v6.2_rc6' of git:..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=116dd0ac480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=23330449ad10b66f
dashboard link: https://syzkaller.appspot.com/bug?extid=c1d0a03d305972dbbe14
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e4a789480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=100108fa480000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c1d0a03d305972dbbe14@syzkaller.appspotmail.com

list_add corruption. prev->next should be next (ffff88802620c000), but was ffff88801d633000. (prev=ffffffff8e546e60).
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:30!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 12187 Comm: syz-executor209 Not tainted 6.2.0-rc5-syzkaller-00013-g2475bf0250de #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:__list_add_valid.cold+0x56/0x58 lib/list_debug.c:30
Code: 0b 48 89 f2 4c 89 e1 48 89 ee 48 c7 c7 c0 bc a6 8a e8 df 2c f0 ff 0f 0b 48 89 f1 48 c7 c7 40 bc a6 8a 4c 89 e6 e8 cb 2c f0 ff <0f> 0b 4c 89 e1 48 89 ee 48 c7 c7 a0 be a6 8a e8 b7 2c f0 ff 0f 0b
RSP: 0018:ffffc90026c577f0 EFLAGS: 00010282
RAX: 0000000000000075 RBX: ffff888026209000 RCX: 0000000000000000
RDX: ffff888012c20000 RSI: ffffffff816680ec RDI: fffff52004d8aef0
RBP: ffff888026209000 R08: 0000000000000075 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: ffff88802620c000
R13: ffff88802620c000 R14: 0000000000000000 R15: ffff88802620a140
FS:  0000000000000000(0000) GS:ffff88802c600000(0063) knlGS:0000000057a07380
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000200003c0 CR3: 000000002433d000 CR4: 0000000000150ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __list_add include/linux/list.h:69 [inline]
 list_add include/linux/list.h:88 [inline]
 nfc_llcp_register_device+0x7a8/0x9e0 net/nfc/llcp_core.c:1604
 nfc_register_device+0x70/0x3b0 net/nfc/core.c:1124
 nci_register_device+0x7cb/0xb50 net/nfc/nci/core.c:1257
 virtual_ncidev_open+0x14f/0x230 drivers/nfc/virtual_ncidev.c:148
 misc_open+0x37a/0x4a0 drivers/char/misc.c:165
 chrdev_open+0x26a/0x770 fs/char_dev.c:414
 do_dentry_open+0x6cc/0x13f0 fs/open.c:882
 do_open fs/namei.c:3557 [inline]
 path_openat+0x1bbc/0x2a50 fs/namei.c:3714
 do_filp_open+0x1ba/0x410 fs/namei.c:3741
 do_sys_openat2+0x16d/0x4c0 fs/open.c:1310
 do_sys_open fs/open.c:1326 [inline]
 __do_compat_sys_openat fs/open.c:1386 [inline]
 __se_compat_sys_openat fs/open.c:1384 [inline]
 __ia32_compat_sys_openat+0x143/0x1f0 fs/open.c:1384
 do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
 __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
 do_fast_syscall_32+0x33/0x70 arch/x86/entry/common.c:203
 entry_SYSENTER_compat_after_hwframe+0x70/0x82
RIP: 0023:0xf7e6f549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000ff98601c EFLAGS: 00000292 ORIG_RAX: 0000000000000127
RAX: ffffffffffffffda RBX: 00000000ffffff9c RCX: 0000000020000080
RDX: 0000000000000002 RSI: 0000000000000000 RDI: 00000000ffffffff
RBP: 0000000000008933 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_add_valid.cold+0x56/0x58 lib/list_debug.c:30
Code: 0b 48 89 f2 4c 89 e1 48 89 ee 48 c7 c7 c0 bc a6 8a e8 df 2c f0 ff 0f 0b 48 89 f1 48 c7 c7 40 bc a6 8a 4c 89 e6 e8 cb 2c f0 ff <0f> 0b 4c 89 e1 48 89 ee 48 c7 c7 a0 be a6 8a e8 b7 2c f0 ff 0f 0b
RSP: 0018:ffffc90026c577f0 EFLAGS: 00010282
RAX: 0000000000000075 RBX: ffff888026209000 RCX: 0000000000000000
RDX: ffff888012c20000 RSI: ffffffff816680ec RDI: fffff52004d8aef0
RBP: ffff888026209000 R08: 0000000000000075 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: ffff88802620c000
R13: ffff88802620c000 R14: 0000000000000000 R15: ffff88802620a140
FS:  0000000000000000(0000) GS:ffff88802c600000(0063) knlGS:0000000057a07380
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000200003c0 CR3: 000000002433d000 CR4: 0000000000150ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	03 74 c0 01          	add    0x1(%rax,%rax,8),%esi
   4:	10 05 03 74 b8 01    	adc    %al,0x1b87403(%rip)        # 0x1b8740d
   a:	10 06                	adc    %al,(%rsi)
   c:	03 74 b4 01          	add    0x1(%rsp,%rsi,4),%esi
  10:	10 07                	adc    %al,(%rdi)
  12:	03 74 b0 01          	add    0x1(%rax,%rsi,4),%esi
  16:	10 08                	adc    %cl,(%rax)
  18:	03 74 d8 01          	add    0x1(%rax,%rbx,8),%esi
  1c:	00 00                	add    %al,(%rax)
  1e:	00 00                	add    %al,(%rax)
  20:	00 51 52             	add    %dl,0x52(%rcx)
  23:	55                   	push   %rbp
  24:	89 e5                	mov    %esp,%ebp
  26:	0f 34                	sysenter
  28:	cd 80                	int    $0x80
* 2a:	5d                   	pop    %rbp <-- trapping instruction
  2b:	5a                   	pop    %rdx
  2c:	59                   	pop    %rcx
  2d:	c3                   	retq
  2e:	90                   	nop
  2f:	90                   	nop
  30:	90                   	nop
  31:	90                   	nop
  32:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi
  39:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi

