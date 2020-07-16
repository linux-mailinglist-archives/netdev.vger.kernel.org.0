Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10842221B2D
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 06:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgGPESZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 00:18:25 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:48682 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbgGPESZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 00:18:25 -0400
Received: by mail-il1-f199.google.com with SMTP id q9so2841753ilt.15
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 21:18:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=BbQzChrVeBZgzn4hjDJtb4vWH12f22fdbm4mXnkKsBE=;
        b=D5RFmhn1cATFG2XnAdqtt2WLFrc0nctLvR9DYNI34kPOLzGO0+GGwXtlDO0hQEbQqr
         8I2Urig0719GLVq3Sh7LGKEamqjZ/sTC0DLBbZ6Z3ARKamTztH9cEFuH4pdmlTBI/9m8
         0+qWLlsEjgRfWsjz9V3Y+ImRG3ue/bfb3fdBBu+vJ9cGJp8qyvFrXUiaOOSwRiknNDIN
         DEEWIvbzniiO/fGWUTIoQUl0hID34ls43b6DGNNH72hCEX1o65RIZAbmZkz8e1ghA3WE
         3vm83gNj25lMh+1USB+41Ut8JM3Gqne0PW1gJ4sN76y6nFDq+MJoL8tXR51QjjWTUFlT
         vedw==
X-Gm-Message-State: AOAM530Sv7gMNQDEaRUx3MVojU5ec/TwtD3U8PzRW/biYmmGqsrciEJX
        qSAbtHJdxgRzeatB+8mu7o2iYWEhpq0MR8vZ/TeyLJEkyx5T
X-Google-Smtp-Source: ABdhPJxn0t3XXp4BZ55iG/cnCjrWk9nsOKB0kw7qFhf+ESr8a4I1vwuxvpddNeTvzOHXlhGlXC8yAHV5kwh1yIR2Lweq5O1Nq86G
MIME-Version: 1.0
X-Received: by 2002:a6b:d31a:: with SMTP id s26mr2732835iob.48.1594873103983;
 Wed, 15 Jul 2020 21:18:23 -0700 (PDT)
Date:   Wed, 15 Jul 2020 21:18:23 -0700
In-Reply-To: <000000000000ba65ba05a2fd48d9@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d3284805aa87548a@google.com>
Subject: Re: kernel BUG at net/core/dev.c:LINE! (3)
From:   syzbot <syzbot+af23e7f3e0a7e10c8b67@syzkaller.appspotmail.com>
To:     andy@greyhouse.net, davem@davemloft.net, j.vosburgh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vfalico@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    4ff91fa0 Merge branch 'udp_tunnel-NIC-RX-port-offload-infr..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1777b9bf100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8a8f9de6c9d911de
dashboard link: https://syzkaller.appspot.com/bug?extid=af23e7f3e0a7e10c8b67
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13a7c4f7100000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+af23e7f3e0a7e10c8b67@syzkaller.appspotmail.com

bond1 (unregistering): (slave wireguard2): Releasing backup interface
bond1 (unregistering): (slave wireguard1): Releasing backup interface
bond1 (unregistering): (slave wireguard0): Releasing backup interface
device wireguard0 left promiscuous mode
bond1 (unregistering): Destroying bond
------------[ cut here ]------------
kernel BUG at net/core/dev.c:8948!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 129 Comm: kworker/u4:3 Not tainted 5.8.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:rollback_registered_many+0x2be/0xf60 net/core/dev.c:8948
Code: 4c 89 e8 48 c1 e8 03 42 80 3c 20 00 0f 85 91 0c 00 00 48 b8 22 01 00 00 00 00 ad de 48 89 43 70 e9 b9 fe ff ff e8 82 19 3d fb <0f> 0b 4c 8d 7b 68 4c 8d 6b 70 eb a5 e8 71 19 3d fb 48 8b 74 24 10
RSP: 0018:ffffc90000e976b0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff8880a2bb0000 RCX: ffffffff86369018
RDX: ffff8880a8dcc2c0 RSI: ffffffff8636916e RDI: 0000000000000001
RBP: ffffc90000e97770 R08: 0000000000000000 R09: ffffffff8a7b9707
R10: 0000000000000001 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff8880a2bb0068 R14: ffffc90000e97718 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000e07978 CR3: 0000000093d17000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 rollback_registered net/core/dev.c:9022 [inline]
 unregister_netdevice_queue+0x2dd/0x570 net/core/dev.c:10103
 unregister_netdevice include/linux/netdevice.h:2762 [inline]
 bond_release_and_destroy drivers/net/bonding/bond_main.c:2212 [inline]
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3285 [inline]
 bond_netdev_event.cold+0xc1/0x10e drivers/net/bonding/bond_main.c:3398
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2033
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 rollback_registered_many+0x665/0xf60 net/core/dev.c:8977
 unregister_netdevice_many.part.0+0x1a/0x2f0 net/core/dev.c:10122
 unregister_netdevice_many net/core/dev.c:10121 [inline]
 default_device_exit_batch+0x30c/0x3d0 net/core/dev.c:10605
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:189
 cleanup_net+0x4ea/0xa00 net/core/net_namespace.c:603
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
Modules linked in:
---[ end trace c01e039c1ee3796a ]---
RIP: 0010:rollback_registered_many+0x2be/0xf60 net/core/dev.c:8948
Code: 4c 89 e8 48 c1 e8 03 42 80 3c 20 00 0f 85 91 0c 00 00 48 b8 22 01 00 00 00 00 ad de 48 89 43 70 e9 b9 fe ff ff e8 82 19 3d fb <0f> 0b 4c 8d 7b 68 4c 8d 6b 70 eb a5 e8 71 19 3d fb 48 8b 74 24 10
RSP: 0018:ffffc90000e976b0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff8880a2bb0000 RCX: ffffffff86369018
RDX: ffff8880a8dcc2c0 RSI: ffffffff8636916e RDI: 0000000000000001
RBP: ffffc90000e97770 R08: 0000000000000000 R09: ffffffff8a7b9707
R10: 0000000000000001 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff8880a2bb0068 R14: ffffc90000e97718 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f091b46f018 CR3: 0000000097f54000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

