Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F63A7787B
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 13:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbfG0LkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 07:40:07 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:55488 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfG0LkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 07:40:06 -0400
Received: by mail-io1-f70.google.com with SMTP id f22so61768524ioh.22
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 04:40:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=4hE5MFlcvCrluUJqG4iGcm5nKHlJDnOlC6mpPTKYzN8=;
        b=J2UPp4aok2RwCfBulxVygyxoPEPnX3+/AkPFg2G+7IFsI3QHEUA7AwIIwxN8aKe7c7
         gKgqgtVOIl8RXcCKmxBFgqHvRfVDxeCmGBCXDq9eEGW84eG6Xgy2y2TPBWkZqg6a00ou
         iTzmZZlHmEdkRY6rS5tgMwN7o3/X0qVq9PoZhHe9kvpK53AVxNpNhMaAs21aIJsfAH8y
         D/DEGcE4Kv+Q1vKMi3fcIMH56yTq3r+0UzmFy5GDyKBxaER0k7hnQNKKJlBqvxk+Ea2H
         YfBoqUVX+4HDkGKWIc/jyXzShsWpA1jV7bi5Cwji4tzt/0+ksfH78Jbicp+Y9VVDZsIT
         +dMw==
X-Gm-Message-State: APjAAAVMvqxXrE6LnWshEmKP8lvgY+KOWjRdl0x1mEaqLIIujyUG31QH
        Hf5vAlTMpnWVaEkCcCqj9cqkzWCc4l5H+X8CjIfHCsV8Yn/E
X-Google-Smtp-Source: APXvYqzROQXiyDS5c/uLW2dsKoaCgTkYKi/WKjtywPIJN4f1/0PgmEZsC292WWXMeFNK8gSs9jBIlV1Cv7tMp2g6pnNdNGvmyGVm
MIME-Version: 1.0
X-Received: by 2002:a05:6638:691:: with SMTP id i17mr102984038jab.70.1564227605925;
 Sat, 27 Jul 2019 04:40:05 -0700 (PDT)
Date:   Sat, 27 Jul 2019 04:40:05 -0700
In-Reply-To: <0000000000002b4896058e7abf78@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cc977f058ea81e82@google.com>
Subject: Re: general protection fault in tls_trim_both_msgs
From:   syzbot <syzbot+0e0fedcad708d12d3032@syzkaller.appspotmail.com>
To:     ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    fde50b96 Add linux-next specific files for 20190726
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=142826cc600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4b58274564b354c1
dashboard link: https://syzkaller.appspot.com/bug?extid=0e0fedcad708d12d3032
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14779d64600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1587c842600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0e0fedcad708d12d3032@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 10205 Comm: syz-executor265 Not tainted 5.3.0-rc1-next-20190726  
#53
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:tls_trim_both_msgs+0x54/0x130 net/tls/tls_sw.c:268
Code: 48 c1 ea 03 80 3c 02 00 0f 85 e3 00 00 00 4d 8b b5 b0 06 00 00 48 b8  
00 00 00 00 00 fc ff df 49 8d 7e 28 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 b3 00 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b
RSP: 0018:ffff88809037fac0 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffff8880a8c0eec0 RCX: ffffffff862f4eef
RDX: 0000000000000005 RSI: ffffffff862e9016 RDI: 0000000000000028
RBP: ffff88809037fae0 R08: ffff8880944a8040 R09: ffffed10125e7d51
R10: ffffed10125e7d50 R11: ffff888092f3ea83 R12: 0000000000000000
R13: ffff8880a9560c80 R14: 0000000000000000 R15: 00000000ffffffe0
FS:  000055555717a880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc5f44109c0 CR3: 000000008b1cc000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
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
RIP: 0033:0x441339
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 9b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffef90e4908 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441339
RDX: ffffffffffffffc1 RSI: 00000000200005c0 RDI: 0000000000000003
RBP: 00000000006cb018 R08: 0000000000000000 R09: 1201000000003618
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402160
R13: 00000000004021f0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 94e33101f438b014 ]---
RIP: 0010:tls_trim_both_msgs+0x54/0x130 net/tls/tls_sw.c:268
Code: 48 c1 ea 03 80 3c 02 00 0f 85 e3 00 00 00 4d 8b b5 b0 06 00 00 48 b8  
00 00 00 00 00 fc ff df 49 8d 7e 28 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 b3 00 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b
RSP: 0018:ffff88809037fac0 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffff8880a8c0eec0 RCX: ffffffff862f4eef
RDX: 0000000000000005 RSI: ffffffff862e9016 RDI: 0000000000000028
RBP: ffff88809037fae0 R08: ffff8880944a8040 R09: ffffed10125e7d51
R10: ffffed10125e7d50 R11: ffff888092f3ea83 R12: 0000000000000000
R13: ffff8880a9560c80 R14: 0000000000000000 R15: 00000000ffffffe0
FS:  000055555717a880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc5f44109c0 CR3: 000000008b1cc000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

