Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D93228C1D
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 00:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731304AbgGUWnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 18:43:22 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:42146 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731210AbgGUWnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 18:43:21 -0400
Received: by mail-io1-f70.google.com with SMTP id l18so61640ion.9
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 15:43:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=HpXEP7+7WDpHa02yNTkxAcACkue1pdIoYYR+xtw8X5c=;
        b=OMn0zCWv95l8VyRvL4De1LbfjKScsW/QXHp8wbm4A3a/xwBkWmlNmiYPnQz4xRod4/
         PxeDTl54Qo3/QDoRCvOvZ9uNkkMU+xKsq9TTV5r06wLjyKEQihpImZyhfI/ks3ekyMw/
         oysAKO/iuUcTUY2daQSSVOWiGowltV12mdb3qZmUYo6nwnBwOwMgOOJMPq/nYkFrNx1c
         1ueK/UTc0nw3ykgubFdg4xl9pNGPTUtfvg61VTz9m1p9X68O4QB9mhPMXYncK1z+wXxJ
         xYKI3z1bdBDxvDVJnq7K/zS9SH9HBKK/CpqGQVshCNQGHIKdEhxPgvM01bITrslgndS4
         h+wQ==
X-Gm-Message-State: AOAM531vTdEo9GakfU6POtLwLKBCowKk6vWAKp4B4nBmKJETfKhSmkph
        UcXYyyN3p455agbtBX4jkxWw7Cp0CdjzSWZr8SyNmoT4Pi52
X-Google-Smtp-Source: ABdhPJwmT3uMd7hY5PNYc+pNKWfBkGcT013rGVEZEdNidSosH2flq9+qBOjMxvgO4rMFNDl1nT6dWYrBHyerO0/7AGHoy9i9o7IQ
MIME-Version: 1.0
X-Received: by 2002:a6b:6211:: with SMTP id f17mr30923765iog.34.1595371400264;
 Tue, 21 Jul 2020 15:43:20 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:43:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000099052605aafb5923@google.com>
Subject: general protection fault in vsock_poll
From:   syzbot <syzbot+a61bac2fcc1a7c6623fe@syzkaller.appspotmail.com>
To:     davem@davemloft.net, decui@microsoft.com, jhansen@vmware.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, sgarzare@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6a70f89c Merge tag 'nfs-for-5.8-3' of git://git.linux-nfs...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=172ed85f100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a160d1053fc89af5
dashboard link: https://syzkaller.appspot.com/bug?extid=a61bac2fcc1a7c6623fe
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1539bcf0900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a61bac2fcc1a7c6623fe@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000012: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000090-0x0000000000000097]
CPU: 1 PID: 9090 Comm: syz-executor.3 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:vsock_poll+0x75a/0x8e0 net/vmw_vsock/af_vsock.c:1038
Code: 84 ed 0f 85 c4 00 00 00 e8 b3 33 99 f9 48 8d bb 90 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa c6 44 24 30 00 48 c1 ea 03 <80> 3c 02 00 0f 85 3f 01 00 00 48 8d 54 24 30 be 01 00 00 00 48 89
RSP: 0018:ffffc90007bcf650 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff87da863f
RDX: 0000000000000012 RSI: ffffffff87da864d RDI: 0000000000000090
RBP: ffff8880a4fbc800 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff8880a4fbcc2a R15: 0000000000000001
FS:  00007f97883c0700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555e4c1776b0 CR3: 00000000a8182000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 sock_poll+0x159/0x460 net/socket.c:1266
 vfs_poll include/linux/poll.h:90 [inline]
 do_select+0x8dc/0x1630 fs/select.c:534
 core_sys_select+0x3ba/0x8e0 fs/select.c:677
 do_pselect.constprop.0+0x17b/0x1c0 fs/select.c:759
 __do_sys_pselect6 fs/select.c:800 [inline]
 __se_sys_pselect6 fs/select.c:791 [inline]
 __x64_sys_pselect6+0x1ea/0x2e0 fs/select.c:791
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c1d9
Code: Bad RIP value.
RSP: 002b:00007f97883bfc78 EFLAGS: 00000246 ORIG_RAX: 000000000000010e
RAX: ffffffffffffffda RBX: 0000000000023b80 RCX: 000000000045c1d9
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000040
RBP: 000000000078c098 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000020000140 R11: 0000000000000246 R12: 000000000078c04c
R13: 00007ffed20a578f R14: 00007f97883c09c0 R15: 000000000078c04c
Modules linked in:
---[ end trace 086e7155f301615d ]---
RIP: 0010:vsock_poll+0x75a/0x8e0 net/vmw_vsock/af_vsock.c:1038
Code: 84 ed 0f 85 c4 00 00 00 e8 b3 33 99 f9 48 8d bb 90 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa c6 44 24 30 00 48 c1 ea 03 <80> 3c 02 00 0f 85 3f 01 00 00 48 8d 54 24 30 be 01 00 00 00 48 89
RSP: 0018:ffffc90007bcf650 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff87da863f
RDX: 0000000000000012 RSI: ffffffff87da864d RDI: 0000000000000090
RBP: ffff8880a4fbc800 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff8880a4fbcc2a R15: 0000000000000001
FS:  00007f97883c0700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004d9ad0 CR3: 00000000a8182000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
