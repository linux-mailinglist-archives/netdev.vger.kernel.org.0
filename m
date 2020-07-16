Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F9422222E
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 14:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgGPMHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 08:07:20 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:47758 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgGPMHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 08:07:19 -0400
Received: by mail-io1-f70.google.com with SMTP id d22so3449525iom.14
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 05:07:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=t9ueKYwuAsIH4rYDj3ZAOiWwulEOYI3pILFlxCZZO1M=;
        b=cv8l/WoeFuSOUDkUOgDRV2TMAhB+Y1VFMQeLdw1ZnTbrCbICSLNBXDJrmFv5MC0djJ
         Gb0EAlvj+fatWjMakx5/X9CI5OWKmKIZc4NxgKnL2bWL7PlbJM1jYlIdPoAuEigSKy81
         zQuEYjfpXQAiGwJMjOp56WEpQx1z9OJphwS4NTzJfztIolkq2NrNNR4soYHkcvL49ksA
         Wvf87FdDRYbssdUCrOeFJKr+NCpyMCBARWL8as/2i1HtGwd5U3Y46MxYDxzFXNqveUWU
         gxnwRmqmJDeUDv8omg97q9zk+g0TBcfdvQGscCp3pDbU5D51qkyu4hXRIiST2vn/AcuI
         h17w==
X-Gm-Message-State: AOAM530ZVSKe1px30yMJDDloRmc+nxbeM23HgmDuxd3vTXXaoLTxxePL
        y8pdgjW8DpaS2/ZlZLbANd9nvSOl5NCrWIw8uMnAfFLHx5ag
X-Google-Smtp-Source: ABdhPJyBXJd+D/Vcvpx21xayAwbWoK3JT2IJ6ASU6HmVW17IPdSHEdHUNHbKm3neXWfLOm8OZfhHLefuefkNcAB54+0WWaCuGRm+
MIME-Version: 1.0
X-Received: by 2002:a6b:3ac6:: with SMTP id h189mr4102202ioa.78.1594901238306;
 Thu, 16 Jul 2020 05:07:18 -0700 (PDT)
Date:   Thu, 16 Jul 2020 05:07:18 -0700
In-Reply-To: <000000000000ba65ba05a2fd48d9@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c2de7705aa8de1eb@google.com>
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

HEAD commit:    ca0e494a Add linux-next specific files for 20200715
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11daec20900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2c76d72659687242
dashboard link: https://syzkaller.appspot.com/bug?extid=af23e7f3e0a7e10c8b67
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12dd73bf100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17a466b3100000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+af23e7f3e0a7e10c8b67@syzkaller.appspotmail.com

bond0 (unregistering): (slave wireguard2): Releasing backup interface
bond0 (unregistering): (slave wireguard1): Releasing backup interface
bond0 (unregistering): (slave wireguard0): Releasing backup interface
device wireguard0 left promiscuous mode
bond0 (unregistering): Destroying bond
------------[ cut here ]------------
kernel BUG at net/core/dev.c:8948!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 21 Comm: kworker/u4:1 Not tainted 5.8.0-rc5-next-20200715-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:rollback_registered_many+0x2be/0xf60 net/core/dev.c:8948
Code: 4c 89 e8 48 c1 e8 03 42 80 3c 20 00 0f 85 91 0c 00 00 48 b8 22 01 00 00 00 00 ad de 48 89 43 70 e9 b9 fe ff ff e8 f2 77 39 fb <0f> 0b 4c 8d 7b 68 4c 8d 6b 70 eb a5 e8 e1 77 39 fb 48 8b 74 24 10
RSP: 0018:ffffc90000dd76b0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888097a94000 RCX: ffffffff863ab928
RDX: ffff8880a97a8580 RSI: ffffffff863aba7e RDI: 0000000000000001
RBP: ffffc90000dd7770 R08: 0000000000000000 R09: ffffffff8a854947
R10: 0000000000000001 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff888097a94068 R14: ffffc90000dd7718 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa85f1dee78 CR3: 000000009e4d2000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 rollback_registered net/core/dev.c:9022 [inline]
 unregister_netdevice_queue+0x2dd/0x570 net/core/dev.c:10103
 unregister_netdevice include/linux/netdevice.h:2764 [inline]
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
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Modules linked in:
---[ end trace d02cbf494c57b1f4 ]---
RIP: 0010:rollback_registered_many+0x2be/0xf60 net/core/dev.c:8948
Code: 4c 89 e8 48 c1 e8 03 42 80 3c 20 00 0f 85 91 0c 00 00 48 b8 22 01 00 00 00 00 ad de 48 89 43 70 e9 b9 fe ff ff e8 f2 77 39 fb <0f> 0b 4c 8d 7b 68 4c 8d 6b 70 eb a5 e8 e1 77 39 fb 48 8b 74 24 10
RSP: 0018:ffffc90000dd76b0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888097a94000 RCX: ffffffff863ab928
RDX: ffff8880a97a8580 RSI: ffffffff863aba7e RDI: 0000000000000001
RBP: ffffc90000dd7770 R08: 0000000000000000 R09: ffffffff8a854947
R10: 0000000000000001 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff888097a94068 R14: ffffc90000dd7718 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5f78695000 CR3: 000000008e0d9000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

