Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D50B51FED9
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 07:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfEPFqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 01:46:06 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:54647 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726324AbfEPFqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 01:46:06 -0400
Received: by mail-io1-f72.google.com with SMTP id t7so1821851iof.21
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 22:46:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ltOragm0SCqo4uoAEQQAlYmgIkzdvYfcpSv92gE1T/g=;
        b=fED+xbNq2iCOX9wPIAIWGrfUX7ff4DOt4wM9+eECnN+SYAOOySnFzURbDbVERwxA9/
         D6IStXClM6l6HuycGL83Q5Mb17lVEVUbRJLmodc2Jv6h2GIYzgIT359WjDsMIlpmOTg+
         ukc3W/MnMffKqIdCRzndnc6gBKiE9gPZ20/tQ9kqad/ufaiuBsIA248QqVyLMSBMdp/m
         Qjlu8Tk9mzMri2zN2+o9pM+oRU8iNYM8A2kaQxLdxhkLXd3fSbMJt8FJWpI0JEQnkAV5
         l5A5iQbWp/ASBzT4VO1hmKcq6FhvmlWgz13E3T6SsB98NSkh/3e1IcdMRZKlAgeivFjm
         YDUQ==
X-Gm-Message-State: APjAAAWN2VNOHJrKPW6amHRsfmrBxCcDR2su4p6w0bSM1hQkqo2GrBJM
        alZE+HH17J3Bv6BhkNpd1RaHAt/nvNuXAqbme3+6tDoFr6dV
X-Google-Smtp-Source: APXvYqzwKn9sE6VTf7DFye3cDrVijXOpZDs3MSil5qUtRVtlHQRwdifCAK2mN67WThT25zT+9EoQ4V1ve+lq7vw/p+h74CYtN/wj
MIME-Version: 1.0
X-Received: by 2002:a6b:ea02:: with SMTP id m2mr24613082ioc.270.1557985565350;
 Wed, 15 May 2019 22:46:05 -0700 (PDT)
Date:   Wed, 15 May 2019 22:46:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003028060588fac869@google.com>
Subject: WARNING: locking bug in udpv6_pre_connect
From:   syzbot <syzbot+65f10c5aadc049eb5ef5@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, kafai@fb.com, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    8f779443 net: phy: realtek: fix double page ops in generic..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=13f16ee8a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4005028a9d5ddac8
dashboard link: https://syzkaller.appspot.com/bug?extid=65f10c5aadc049eb5ef5
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+65f10c5aadc049eb5ef5@syzkaller.appspotmail.com

WARNING: CPU: 0 PID: 2749 at kernel/locking/lockdep.c:734  
arch_local_save_flags arch/x86/include/asm/paravirt.h:762 [inline]
WARNING: CPU: 0 PID: 2749 at kernel/locking/lockdep.c:734  
arch_local_save_flags arch/x86/include/asm/paravirt.h:760 [inline]
WARNING: CPU: 0 PID: 2749 at kernel/locking/lockdep.c:734  
look_up_lock_class kernel/locking/lockdep.c:725 [inline]
WARNING: CPU: 0 PID: 2749 at kernel/locking/lockdep.c:734  
register_lock_class+0xe10/0x1860 kernel/locking/lockdep.c:1078
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 2749 Comm: syz-executor.2 Not tainted 5.1.0+ #8
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2cb/0x65c kernel/panic.c:214
  __warn.cold+0x20/0x45 kernel/panic.c:566
  report_bug+0x263/0x2b0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:972
RIP: 0010:look_up_lock_class kernel/locking/lockdep.c:734 [inline]
RIP: 0010:register_lock_class+0xe10/0x1860 kernel/locking/lockdep.c:1078
Code: 00 48 89 da 4d 8b 76 c0 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 80  
3c 02 00 0f 85 23 07 00 00 4c 89 33 e9 e3 f4 ff ff 0f 0b <0f> 0b e9 ea f3  
ff ff 44 89 e0 4c 8b 95 50 ff ff ff 83 c0 01 4c 8b
RSP: 0018:ffff8880475b79e8 EFLAGS: 00010083
RAX: dffffc0000000000 RBX: ffff888045e2f0a0 RCX: 0000000000000000
RDX: 1ffff11008bc5e17 RSI: 0000000000000000 RDI: ffff888045e2f0b8
RBP: ffff8880475b7ab0 R08: 1ffff11008eb6f45 R09: ffffffff8a455c80
R10: ffffffff8a0e2318 R11: 0000000000000000 R12: ffffffff8a11ed60
R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff87fe3860
  __lock_acquire+0x116/0x5490 kernel/locking/lockdep.c:3673
  lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4302
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
  _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  lock_sock_nested+0x41/0x120 net/core/sock.c:2917
  lock_sock include/net/sock.h:1525 [inline]
  udpv6_pre_connect net/ipv6/udp.c:1064 [inline]
  udpv6_pre_connect+0xc4/0x170 net/ipv6/udp.c:1046
  inet_dgram_connect+0x1cd/0x2e0 net/ipv4/af_inet.c:568
  __sys_connect+0x266/0x330 net/socket.c:1840
  __do_sys_connect net/socket.c:1851 [inline]
  __se_sys_connect net/socket.c:1848 [inline]
  __x64_sys_connect+0x73/0xb0 net/socket.c:1848
  do_syscall_64+0x103/0x670 arch/x86/entry/common.c:298
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x458da9
Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f9ad544cc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000458da9
RDX: 000000000000001c RSI: 0000000020000000 RDI: 0000000000000003
RBP: 000000000073bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f9ad544d6d4
R13: 00000000004bf1fe R14: 00000000004d04b8 R15: 00000000ffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
