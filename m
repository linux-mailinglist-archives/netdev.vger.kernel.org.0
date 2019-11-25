Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB01E109438
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 20:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbfKYT2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 14:28:09 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:36031 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbfKYT2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 14:28:09 -0500
Received: by mail-io1-f70.google.com with SMTP id z12so11622658iop.3
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 11:28:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=vepHw2FCtDai2doID+pQcicHSRg4AAVaV69lUY8SeNc=;
        b=af4DcZYZthhYLF6KYWobcVBP3vUTMRjfrRosYa8v2AAAsRQG/jb+ABCMmQj+E1eqJ2
         9pUv4J2yA+TcPL4Myl9uIXpDq9y0mIVA7him0incZc5DguoJAB32SXiA90EHgoe+fvAJ
         kXxQdt5rqtkXGOH2zb5wBv8yZQUA6YjEROf5Z1EyNGR22UQs9pk/RA9VI4MNXFKLXOwk
         nvM2evXZwyF3xXslAo6whF0pBc2WXnDyaP7MTkd6OjEYXoLiOXvWDD9k208RmlcfnmCC
         v2d9frvLpM4PXFoNYHI85ArgwPUX3qfhsStog6HjMZzndOryaGEvZ70gVo8dMZRCNkMS
         71Ow==
X-Gm-Message-State: APjAAAVFLAwWFy2KpO0Sx3SruOuLWP0vFWOTwhD9zcspLPkqwx8JxVTT
        Q5iGshT44k78UhP+s1phekg2ORS3qt+aTFPdjBwC4ClWzeqD
X-Google-Smtp-Source: APXvYqy9j/n9HPTJPkHiUlSCPsZh3oe7S2pyT8r5kW0yvcYxtwD0vMn4rZli+fUaFR17ZHhevavNreq77VK2Vn/4uWHbujIQHC/t
MIME-Version: 1.0
X-Received: by 2002:a92:9e0e:: with SMTP id q14mr20742629ili.151.1574710088077;
 Mon, 25 Nov 2019 11:28:08 -0800 (PST)
Date:   Mon, 25 Nov 2019 11:28:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006c9f4e059830c33c@google.com>
Subject: general protection fault in selinux_socket_sendmsg (2)
From:   syzbot <syzbot+314db21f0d5c1f53856c@syzkaller.appspotmail.com>
To:     andriin@fb.com, anton@enomsg.org, ast@kernel.org,
        bpf@vger.kernel.org, ccross@android.com, daniel@iogearbox.net,
        eparis@parisplace.org, kafai@fb.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        paul@paul-moore.com, sds@tycho.nsa.gov, selinux@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        tony.luck@intel.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6b8a7946 Merge tag 'for_linus' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1680ab8ce00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4737c15fc47048f2
dashboard link: https://syzkaller.appspot.com/bug?extid=314db21f0d5c1f53856c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+314db21f0d5c1f53856c@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 4616 Comm: kworker/1:0 Not tainted 5.4.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: krxrpcd rxrpc_peer_keepalive_worker
RIP: 0010:selinux_socket_sendmsg+0x22/0x40 security/selinux/hooks.c:4828
Code: c3 e8 c2 40 ac fe eb e8 55 48 89 e5 53 48 89 fb e8 43 d5 70 fe 48 8d  
7b 18 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75  
11 48 8b 7b 18 be 04 00 00 00 e8 fa fb ff ff 5b 5d
RSP: 0000:ffff888089fd79f0 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff83427eb5
RDX: 0000000000000003 RSI: ffffffff830281dd RDI: 0000000000000018
RBP: ffff888089fd79f8 R08: ffff888098698400 R09: fffffbfff14f0154
R10: fffffbfff14f0153 R11: ffffffff8a780a9f R12: dffffc0000000000
R13: ffff888089fd7b20 R14: ffff888089fd7b20 R15: 000000000000001d
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c000064008 CR3: 00000000a87b8000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  security_socket_sendmsg+0x77/0xc0 security/security.c:2013
  sock_sendmsg+0x45/0x130 net/socket.c:654
  kernel_sendmsg+0x44/0x50 net/socket.c:677
  rxrpc_send_keepalive+0x1ff/0x940 net/rxrpc/output.c:655
  rxrpc_peer_keepalive_dispatch net/rxrpc/peer_event.c:376 [inline]
  rxrpc_peer_keepalive_worker+0x7be/0xd02 net/rxrpc/peer_event.c:437
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace f42fd501ecc72d8d ]---
RIP: 0010:selinux_socket_sendmsg+0x22/0x40 security/selinux/hooks.c:4828
Code: c3 e8 c2 40 ac fe eb e8 55 48 89 e5 53 48 89 fb e8 43 d5 70 fe 48 8d  
7b 18 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75  
11 48 8b 7b 18 be 04 00 00 00 e8 fa fb ff ff 5b 5d
RSP: 0000:ffff888089fd79f0 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff83427eb5
RDX: 0000000000000003 RSI: ffffffff830281dd RDI: 0000000000000018
RBP: ffff888089fd79f8 R08: ffff888098698400 R09: fffffbfff14f0154
R10: fffffbfff14f0153 R11: ffffffff8a780a9f R12: dffffc0000000000
R13: ffff888089fd7b20 R14: ffff888089fd7b20 R15: 000000000000001d
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9c00057120 CR3: 00000000a3e31000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
