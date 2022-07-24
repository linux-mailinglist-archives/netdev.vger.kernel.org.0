Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 853AD57F4B5
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 12:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbiGXKl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 06:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiGXKl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 06:41:28 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C08013F1E
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 03:41:27 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id c14-20020a056e020bce00b002dd1cb7ce4dso4054510ilu.22
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 03:41:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=gkvQ37tFI06glUdd4oh7VQpcud1L0XJ8uToS1d1FP2Q=;
        b=IoOyAwIdv+N8pYhATbSpvvQ4ZGTSORPvSvbA9AFv+6jEITFac7qrWMLJFL0NriiD6H
         N6py1RKWJkBaaFBZ4RuG4SFXWTDt3JWuAjitAe8sKDpBtJcNYVV+sKxRBXum3bAUAhjt
         svo6uKxJYvIjL1K1f+Z/vLgIz87a6DOeFWVrgcVvZvw6snFluCd6XtG0VyyYSZU6jUQq
         C5l7n84pyAT9KRscUX18TPBLI6oKcEehnk0Dm1DuiEEA9BVHY9qANleH43R0Kks3J9JA
         ROjBKWjrmRUQTGYtOSIwBxka6MNZvQHFuWMZuvSb6MFpzl8YJW+TVpEVr1eRSqFIb+Uy
         IR8Q==
X-Gm-Message-State: AJIora+I4UapBIc0yn5I6VGUOojhzqtNN2TDYfDdEDfqc7vbPUrOR0SX
        R3/dG4cC2hsET5WqVjy/k37RCc2dl5VjIU+eLxcVmeKOWMbW
X-Google-Smtp-Source: AGRyM1sfHZzIglP/EV115Y3kwYJS/9VcS8QLbIHZ/8DyOKaduZEmpZywwTF1uIHt4p+3BrLJ/MHJF2ZTNcH9PNzylXPqGvrt4v+O
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c45:b0:2dc:dc24:c103 with SMTP id
 d5-20020a056e021c4500b002dcdc24c103mr3031769ilg.132.1658659286662; Sun, 24
 Jul 2022 03:41:26 -0700 (PDT)
Date:   Sun, 24 Jul 2022 03:41:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000095c6a005e48ab50f@google.com>
Subject: [syzbot] WARNING in nsim_map_alloc_elem
From:   syzbot <syzbot+ad24705d3fd6463b18c6@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b77ffb30cfc5 libbpf: fix an snprintf() overflow check
git tree:       bpf-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=16a7f652080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=386b986585586629
dashboard link: https://syzkaller.appspot.com/bug?extid=ad24705d3fd6463b18c6
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=102ad7c6080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d71a9c080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ad24705d3fd6463b18c6@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 3609 at mm/page_alloc.c:5402 __alloc_pages+0x39e/0x510 mm/page_alloc.c:5402
Modules linked in:
CPU: 0 PID: 3609 Comm: syz-executor427 Not tainted 5.19.0-rc5-syzkaller-01146-gb77ffb30cfc5 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
RIP: 0010:__alloc_pages+0x39e/0x510 mm/page_alloc.c:5402
Code: ff ff 00 0f 84 33 fe ff ff 80 ce 01 e9 2b fe ff ff 83 fe 0a 0f 86 3e fd ff ff 80 3d d2 70 e9 0b 00 75 09 c6 05 c9 70 e9 0b 01 <0f> 0b 45 31 f6 e9 8d fe ff ff 65 ff 05 21 55 45 7e 48 c7 c0 a0 16
RSP: 0018:ffffc900030cf9c0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 1ffff92000619f39 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 000000000000000b RDI: 0000000000000000
RBP: 0000000000140cc0 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 000000000000000b
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000400002
FS:  0000555556dfc300(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000001b8ef000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2272
 kmalloc_order+0x34/0xf0 mm/slab_common.c:945
 kmalloc_order_trace+0x14/0x120 mm/slab_common.c:961
 kmalloc include/linux/slab.h:605 [inline]
 nsim_map_alloc_elem+0x119/0x2e0 drivers/net/netdevsim/bpf.c:357
 nsim_bpf_map_alloc drivers/net/netdevsim/bpf.c:512 [inline]
 nsim_bpf+0x8b3/0x1050 drivers/net/netdevsim/bpf.c:573
 bpf_map_offload_ndo+0x132/0x1e0 kernel/bpf/offload.c:359
 bpf_map_offload_map_alloc+0x243/0x450 kernel/bpf/offload.c:394
 find_and_alloc_map kernel/bpf/syscall.c:131 [inline]
 map_create kernel/bpf/syscall.c:1102 [inline]
 __sys_bpf+0x8b8/0x5750 kernel/bpf/syscall.c:4936
 __do_sys_bpf kernel/bpf/syscall.c:5058 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5056 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:5056
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f1f9a4a1ba9
Code: 28 c3 e8 4a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffebe3a1e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007fffebe3a1f8 RCX: 00007f1f9a4a1ba9
RDX: 0000000000000048 RSI: 0000000020000100 RDI: 0000000000000000
RBP: 0000000000000003 R08: bb1414ac00000000 R09: bb1414ac00000000
R10: bb1414ac00000000 R11: 0000000000000246 R12: 00007fffebe3a200
R13: 00007fffebe3a1f4 R14: 0000000000000003 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
