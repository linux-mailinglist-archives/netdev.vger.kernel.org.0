Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEB3599320
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 04:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244271AbiHSCo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 22:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbiHSCo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 22:44:27 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4FED54652
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 19:44:25 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id k22-20020a6bf716000000b0068898c0b395so1936903iog.3
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 19:44:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=OWj7n2QWAJaSzd48INs7TkxSAJ8MfTiVRRNOpTq3BK0=;
        b=PFXTTnUJHedyxH9PtqeKjh63/t+x3D+YbPJnNzey8Qox8PzLgty3Y+soswc+ck1sX9
         bEa9/zKnrLIsiAGFPaCEQ0flPypFr7PGRFgA0d00f9t4/rHaHNBCHVZujbTpy6ZnTHco
         BUguN1+xtfsA4J2Q9YZ25zvChzOUjgHrJSV3+fAUiuwjYj+jdaBP3K1ReI/rc+mOWe+j
         FaoLO/LjqG3ynt0Mxmw14UofJ5cMsfrWjczP+x72vgTcSeCDEC5OIZzKsOVx5lCHf8ZQ
         kSPJez0KhOo1uSbfBW23pkcEbD+Hz6cMsPS/WhRqOFOjXHyHUhgNr+VoBA07d+nO3lGQ
         UTgA==
X-Gm-Message-State: ACgBeo3QPlqO2hsLbCwaq4I2vCuiiqAXPIOCv3PBVGJPfrez3UqGE6H6
        MWepNi/BR6iXyfjG6F1oZBVynrD80Hs9xvXhI/fKz4HGIbPU
X-Google-Smtp-Source: AA6agR6Hf8+BW+gFiAzr1Trd5069lUZpfjDMP9HrUQrtnHoABNQyqDI1+E2syvPYkxF5CH38gg6VNd4bVyNFsGaUntY4UyP0H3T3
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1683:b0:345:9e65:cd07 with SMTP id
 f3-20020a056638168300b003459e65cd07mr2603311jat.128.1660877065034; Thu, 18
 Aug 2022 19:44:25 -0700 (PDT)
Date:   Thu, 18 Aug 2022 19:44:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007a222005e68f139f@google.com>
Subject: [syzbot] WARNING: ODEBUG bug in __cancel_work
From:   syzbot <syzbot+83672956c7aa6af698b3@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6c8f479764eb Add linux-next specific files for 20220809
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1193703d080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a5ae8cfa8d7075d1
dashboard link: https://syzkaller.appspot.com/bug?extid=83672956c7aa6af698b3
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12b620f3080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=127b1a0d080000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12371a0d080000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11371a0d080000
console output: https://syzkaller.appspot.com/x/log.txt?x=16371a0d080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+83672956c7aa6af698b3@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
WARNING: CPU: 0 PID: 3607 at lib/debugobjects.c:509 debug_print_object+0x16e/0x250 lib/debugobjects.c:509
Modules linked in:
CPU: 0 PID: 3607 Comm: syz-executor235 Not tainted 5.19.0-next-20220809-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:509
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd 60 09 49 8a 4c 89 ee 48 c7 c7 00 fd 48 8a e8 73 ac 38 05 <0f> 0b 83 05 35 41 dd 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc900039ef8a0 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
RDX: ffff88807f355880 RSI: ffffffff8161f1f8 RDI: fffff5200073df06
RBP: 0000000000000001 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff89eeff60
R13: ffffffff8a4903c0 R14: ffffffff816b23c0 R15: 1ffff9200073df1f
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff196b876a8 CR3: 00000000261c8000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 debug_object_assert_init lib/debugobjects.c:899 [inline]
 debug_object_assert_init+0x1f4/0x2e0 lib/debugobjects.c:870
 debug_timer_assert_init kernel/time/timer.c:792 [inline]
 debug_assert_init kernel/time/timer.c:837 [inline]
 del_timer+0x6d/0x110 kernel/time/timer.c:1257
 try_to_grab_pending+0x6d/0xd0 kernel/workqueue.c:1275
 __cancel_work+0x7c/0x340 kernel/workqueue.c:3250
 l2cap_clear_timer include/net/bluetooth/l2cap.h:884 [inline]
 l2cap_chan_del+0x565/0xa60 net/bluetooth/l2cap_core.c:688
 l2cap_conn_del+0x3c0/0x7b0 net/bluetooth/l2cap_core.c:1922
 l2cap_disconn_cfm net/bluetooth/l2cap_core.c:8213 [inline]
 l2cap_disconn_cfm+0x8c/0xc0 net/bluetooth/l2cap_core.c:8206
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1779 [inline]
 hci_conn_hash_flush+0x122/0x260 net/bluetooth/hci_conn.c:2366
 hci_dev_close_sync+0x55d/0x1130 net/bluetooth/hci_sync.c:4476
 hci_dev_do_close+0x2d/0x70 net/bluetooth/hci_core.c:554
 hci_unregister_dev+0x17f/0x4e0 net/bluetooth/hci_core.c:2682
 vhci_release+0x7c/0xf0 drivers/bluetooth/hci_vhci.c:568
 __fput+0x277/0x9d0 fs/file_table.c:320
 task_work_run+0xdd/0x1a0 kernel/task_work.c:177
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xc39/0x2b60 kernel/exit.c:813
 do_group_exit+0xd0/0x2a0 kernel/exit.c:943
 __do_sys_exit_group kernel/exit.c:954 [inline]
 __se_sys_exit_group kernel/exit.c:952 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:952
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fbef442f629
Code: Unable to access opcode bytes at RIP 0x7fbef442f5ff.
RSP: 002b:00007ffc6284d478 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007fbef44ba390 RCX: 00007fbef442f629
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000001
RBP: 0000000000000001 R08: ffffffffffffffb8 R09: 000000fff44b4e00
R10: 0000000000000004 R11: 0000000000000246 R12: 00007fbef44ba390
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
