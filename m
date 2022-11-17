Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51CA262D78F
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239257AbiKQJ5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239155AbiKQJ4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:56:52 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098DC6F368
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:55:38 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id a14-20020a921a0e000000b003016bfa7e50so906300ila.16
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:55:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gnQLM+uf6EzDh8opNU8l71HS9owOO9Qy4dij00CPUug=;
        b=1glo1pcbGRhshDXsl+NTyOirwqWy3dMAsGTYNH3PaC+tPnHPcgmMMcGchjjovA7WWi
         jCQsxtXx7Q1tQB2+ozcWUO0ZtRRy3UIgEkDILvmQlRLewOh3sLE2bXBfzPJ+1CJSjild
         8zOMywiQLHcH+XxVHjsgpVvAsDVGqHbaYE0sYssAKzO8hrRBM35ChMP0xpyX8ZVP4pve
         uWX5FzN11Hl9uwCHpzrtwwAKOMAjHgP+v5hxXUlQBrJxzv8xR72uZDOn7AwvUkZ/w6IH
         9BnUE4h/MK0YGpQm/n6oVdLI0EMvQkpU8QBL3et/LtqDcBkWHcH0htL9EhsJln8gVSiF
         n8fg==
X-Gm-Message-State: ANoB5plliDtdVlalz9tCCb01cjw1BX0MulfuiwLBIcxT3Zn5D9KciAq8
        Ac7JG8Gt4OgHLI5mEVM6a1QVMKjQaRwwiUYewI3yyv+204J2
X-Google-Smtp-Source: AA0mqf4OGqMmsF/lZaJKYoWoFuYKpYEVeb2ySk4w3mbbI1CfZLnx84ngDXwl4SlEUWqSx6tp+sbTKyMztxwOoDFiGzIxyQy/5DYm
MIME-Version: 1.0
X-Received: by 2002:a6b:c8cf:0:b0:688:2d29:95f0 with SMTP id
 y198-20020a6bc8cf000000b006882d2995f0mr940094iof.173.1668678937374; Thu, 17
 Nov 2022 01:55:37 -0800 (PST)
Date:   Thu, 17 Nov 2022 01:55:37 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004e78ec05eda79749@google.com>
Subject: [syzbot] BUG: sleeping function called from invalid context in static_key_slow_inc
From:   syzbot <syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com>
To:     Jason@zx2c4.com, frederic@kernel.org, juri.lelli@redhat.com,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org, peterz@infradead.org,
        sathyanarayanan.kuppuswamy@linux.intel.com, steven.price@arm.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
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

HEAD commit:    064bc7312bd0 netdevsim: Fix memory leak of nsim_dev->fa_co..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=13d3204e880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a33ac7bbc22a8c35
dashboard link: https://syzkaller.appspot.com/bug?extid=703d9e154b3b58277261
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0634e1c0e4cb/disk-064bc731.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fe1039d2de22/vmlinux-064bc731.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5a0d673875fa/bzImage-064bc731.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at include/linux/percpu-rwsem.h:49
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 9420, name: syz-executor.5
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 PID: 9420 Comm: syz-executor.5 Not tainted 6.1.0-rc4-syzkaller-00212-g064bc7312bd0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 __might_resched.cold+0x222/0x26b kernel/sched/core.c:9890
 percpu_down_read include/linux/percpu-rwsem.h:49 [inline]
 cpus_read_lock+0x1b/0x140 kernel/cpu.c:310
 static_key_slow_inc+0x12/0x20 kernel/jump_label.c:158
 udp_tunnel_encap_enable include/net/udp_tunnel.h:187 [inline]
 setup_udp_tunnel_sock+0x43d/0x550 net/ipv4/udp_tunnel_core.c:81
 l2tp_tunnel_register+0xc51/0x1210 net/l2tp/l2tp_core.c:1509
 pppol2tp_connect+0xcdc/0x1a10 net/l2tp/l2tp_ppp.c:723
 __sys_connect_file+0x153/0x1a0 net/socket.c:1976
 __sys_connect+0x165/0x1a0 net/socket.c:1993
 __do_sys_connect net/socket.c:2003 [inline]
 __se_sys_connect net/socket.c:2000 [inline]
 __x64_sys_connect+0x73/0xb0 net/socket.c:2000
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fd94d28b639
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd94e038168 EFLAGS: 00000246
 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 00007fd94d3abf80 RCX: 00007fd94d28b639
RDX: 000000000000002e RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00007fd94d2e6ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffde93128bf R14: 00007fd94e038300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
