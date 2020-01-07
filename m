Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52981131FB1
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 07:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbgAGGEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 01:04:09 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:34477 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgAGGEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 01:04:09 -0500
Received: by mail-io1-f69.google.com with SMTP id n26so32612673ioj.1
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 22:04:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=MpBXCcCu6Jkfd1WtSRJVeNF1LvLtwS/lptU4QXrTk+E=;
        b=Dv7HMMQ5lr0kPcaGBFIPwAFeT9lsnFXH+XdyYa9P9ufXYli3SSxvl062K3ZUWnTpTO
         +7KaActxd+KJ3+ErK5JlmFnj81aee1xJJMFWLVd20wG5xjFS2SL6wK1lZWC0gX6gCrom
         u/uJx99RaFEcUiecfhCN445GbmGd7RsL17Utsi7PX7cnksAfBKODp8oajK35eA8/n9pQ
         ARKuAWmL93BhBxMIh8i+uHMv6mSk/bQ57ssivcfRmvWvEjEK8dcKfep7Y91B6ROvJxC+
         pGbehm9MyUsOLQsb5fB08Ai6tLp+MCZWfz+TxcWl7EBk58USescEdetYLE0NUpNjyGOb
         uJNg==
X-Gm-Message-State: APjAAAXiiWFakWUX8JwX0rIr8CThqwmDI9Z/9XMrZ1sZeLrQ3KtlynOY
        V/hWa0/iQ4CcOBXiTuPO8tB387+6HjShcPlKKFQVU9bodtib
X-Google-Smtp-Source: APXvYqzJzNdE6kTaG7j29Oo9KVQ0AI3berNT+GPIjNiZvx/RP1u/97tGFBy8QcVLOu4JD1yhUOrzwEg0JigHTiFug58N7pRtHGSw
MIME-Version: 1.0
X-Received: by 2002:a6b:731a:: with SMTP id e26mr69528220ioh.254.1578377048547;
 Mon, 06 Jan 2020 22:04:08 -0800 (PST)
Date:   Mon, 06 Jan 2020 22:04:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004ceb27059b868b57@google.com>
Subject: BUG: unable to handle kernel NULL pointer dereference in cfg80211_wext_siwfrag
From:   syzbot <syzbot+e8a797964a4180eb57d5@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    d89091a4 macb: Don't unregister clks unconditionally
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=130a0915e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f2f3ef188b7e16cf
dashboard link: https://syzkaller.appspot.com/bug?extid=e8a797964a4180eb57d5
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15c85915e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11c02bc1e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e8a797964a4180eb57d5@syzkaller.appspotmail.com

device veth1_vlan entered promiscuous mode
BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD a066f067 P4D a066f067 PUD 958e3067 PMD 0
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9308 Comm: syz-executor762 Not tainted 5.5.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:0x0
Code: Bad RIP value.
RSP: 0018:ffffc90001d37a78 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffff8882186a6540 RCX: ffffffff876a3fd1
RDX: 1ffffffff1148afc RSI: 0000000000000004 RDI: ffff8882186a6540
RBP: ffffc90001d37ab8 R08: ffff88809f9ba580 R09: ffffed1015d0703d
R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: ffffffff88a45660
R13: ffff8880a7aed000 R14: ffffc90001d37bb0 R15: 0000000000000000
FS:  0000000001a01880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 00000000a5220000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  rdev_set_wiphy_params net/wireless/rdev-ops.h:542 [inline]
  cfg80211_wext_siwfrag+0x279/0x910 net/wireless/wext-compat.c:307
  ioctl_standard_call+0xca/0x1d0 net/wireless/wext-core.c:1015
  wireless_process_ioctl.constprop.0+0x236/0x2b0 net/wireless/wext-core.c:953
  wext_ioctl_dispatch net/wireless/wext-core.c:986 [inline]
  wext_ioctl_dispatch net/wireless/wext-core.c:974 [inline]
  wext_handle_ioctl+0x106/0x1c0 net/wireless/wext-core.c:1047
  sock_ioctl+0x47d/0x790 net/socket.c:1112
  vfs_ioctl fs/ioctl.c:47 [inline]
  file_ioctl fs/ioctl.c:545 [inline]
  do_vfs_ioctl+0x977/0x14e0 fs/ioctl.c:732
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:749
  __do_sys_ioctl fs/ioctl.c:756 [inline]
  __se_sys_ioctl fs/ioctl.c:754 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:754
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4423f9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 5b 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd5699e578 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004423f9
RDX: 0000000020000040 RSI: 0800000000008b24 RDI: 0000000000000003
RBP: 0000000000000004 R08: 0000000000000025 R09: 0000000000000025
R10: 0000000000000025 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000403970 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
CR2: 0000000000000000
---[ end trace d5d5f75393c2f62d ]---
RIP: 0010:0x0
Code: Bad RIP value.
RSP: 0018:ffffc90001d37a78 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffff8882186a6540 RCX: ffffffff876a3fd1
RDX: 1ffffffff1148afc RSI: 0000000000000004 RDI: ffff8882186a6540
RBP: ffffc90001d37ab8 R08: ffff88809f9ba580 R09: ffffed1015d0703d
R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: ffffffff88a45660
R13: ffff8880a7aed000 R14: ffffc90001d37bb0 R15: 0000000000000000
FS:  0000000001a01880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 00000000a5220000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
