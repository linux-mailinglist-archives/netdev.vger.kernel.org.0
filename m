Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71120744FE
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 07:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403761AbfGYFcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 01:32:09 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:36708 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403746AbfGYFcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 01:32:08 -0400
Received: by mail-io1-f69.google.com with SMTP id k21so53667650ioj.3
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 22:32:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yWsDlW6MgpAkPWsLf6FB7GE416qtqNMSo5lG6bK7/0I=;
        b=eliV6TRGyVTEPQOyaFSrwG7UfIlIPmSlJsud5clj9+NDkZIw1/jUOiTVtwFVrU98dh
         KWO200Ztl14RBU4r0qVmoAzyfcsLFBwo9lvqDFb6d2ZiIMAu0EBkGlNPLY5oWkGOcRpd
         JH0lWntx4vt13FS5HH4uQcZQ30O4cU2wjF0gM2Zc6mpoDGKIzcPkJ7ov3yG2YsdP72n4
         0VCeXUCFKOnO5TstGziQ2twSFzu4P6yqwyZ10VzgBu/O1be7RsXRNpHwLxX+xGSS1lNR
         DvUcT+RqsMWnFECyQnLHoY5p2mAfGuANhH6rGIvdYLQu9XdZvj0XQmlKtZSCrt2eEk/X
         m0Aw==
X-Gm-Message-State: APjAAAViyI0A+Ajcnefb/tx0h6GI0l4vtCR1/KX+8cr44f1hePF6OPaV
        72xYVv/KRSKJOj8oqpIo4HqRcXNVoRWOMqvzhunz8oqUHrw9
X-Google-Smtp-Source: APXvYqwHfXVL2mZFXb4Hxi0p3FIlEjAcdjnCe3x9neugDtNVtXtEYN/FKK/D/JN9iP8+kKP3o8DhYVj2oZIfpY6+lG7uA911ygAL
MIME-Version: 1.0
X-Received: by 2002:a5e:c24b:: with SMTP id w11mr70459260iop.111.1564032727990;
 Wed, 24 Jul 2019 22:32:07 -0700 (PDT)
Date:   Wed, 24 Jul 2019 22:32:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002b4896058e7abf78@google.com>
Subject: general protection fault in tls_trim_both_msgs
From:   syzbot <syzbot+0e0fedcad708d12d3032@syzkaller.appspotmail.com>
To:     ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9e6dfe80 Add linux-next specific files for 20190724
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1046971fa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6cbb8fc2cf2842d7
dashboard link: https://syzkaller.appspot.com/bug?extid=0e0fedcad708d12d3032
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0e0fedcad708d12d3032@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 15517 Comm: syz-executor.4 Not tainted 5.3.0-rc1-next-20190724  
#50
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:tls_trim_both_msgs+0x54/0x130 net/tls/tls_sw.c:268
Code: 48 c1 ea 03 80 3c 02 00 0f 85 e3 00 00 00 4d 8b b5 b0 06 00 00 48 b8  
00 00 00 00 00 fc ff df 49 8d 7e 28 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 b3 00 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b
RSP: 0018:ffff8880612cfac0 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffff8880a8794340 RCX: ffffc9000e7b9000
RDX: 0000000000000005 RSI: ffffffff86298656 RDI: 0000000000000028
RBP: ffff8880612cfae0 R08: ffff88805ae4c580 R09: fffffbfff14a8155
R10: fffffbfff14a8154 R11: ffffffff8a540aa7 R12: 0000000000000000
R13: ffff888061d82e00 R14: 0000000000000000 R15: 00000000ffffffe0
FS:  00007f7d33516700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2fa2f000 CR3: 000000009fcf1000 CR4: 00000000001406e0
Call Trace:
  tls_sw_sendmsg+0xe38/0x17b0 net/tls/tls_sw.c:1057
  inet6_sendmsg+0x9e/0xe0 net/ipv6/af_inet6.c:576
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  __sys_sendto+0x262/0x380 net/socket.c:1952
  __do_sys_sendto net/socket.c:1964 [inline]
  __se_sys_sendto net/socket.c:1960 [inline]
  __x64_sys_sendto+0xe1/0x1a0 net/socket.c:1960
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459829
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f7d33515c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 0000000000459829
RDX: ffffffffffffffc1 RSI: 00000000200005c0 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 1201000000003618
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f7d335166d4
R13: 00000000004c7669 R14: 00000000004dcc70 R15: 00000000ffffffff
Modules linked in:
---[ end trace 2dd728cceb39a185 ]---
RIP: 0010:tls_trim_both_msgs+0x54/0x130 net/tls/tls_sw.c:268
Code: 48 c1 ea 03 80 3c 02 00 0f 85 e3 00 00 00 4d 8b b5 b0 06 00 00 48 b8  
00 00 00 00 00 fc ff df 49 8d 7e 28 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 b3 00 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b
RSP: 0018:ffff8880612cfac0 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffff8880a8794340 RCX: ffffc9000e7b9000
RDX: 0000000000000005 RSI: ffffffff86298656 RDI: 0000000000000028
RBP: ffff8880612cfae0 R08: ffff88805ae4c580 R09: fffffbfff14a8155
R10: fffffbfff14a8154 R11: ffffffff8a540aa7 R12: 0000000000000000
R13: ffff888061d82e00 R14: 0000000000000000 R15: 00000000ffffffe0
FS:  00007f7d33516700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000019dbe80 CR3: 000000009fcf1000 CR4: 00000000001406e0


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
