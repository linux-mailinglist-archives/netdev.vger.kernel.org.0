Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A7C241EC2
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 18:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgHKQ7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 12:59:37 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:34739 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729214AbgHKQ7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 12:59:19 -0400
Received: by mail-io1-f72.google.com with SMTP id 127so10253390iou.1
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 09:59:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=N2GsfEY2o2ubTFLb0+uCQ2NHYhOo26KcY/ro/Y8xVwA=;
        b=dsy2jIszYTS4EMa/8xK8ZIWeQ0qZs14JrouhT0kaqveJl5qS4fMfAd7v/AEuYDOMB/
         sH6HWxi9rac1wjMqpbxfwtOVYXqD0A6gTteEqzh8vGoNMJpmxjK4+THN1jAl3fIJOQN5
         G0ixBEtg4HGDAH7CP6NYhJr8WbS1rd/BoobDPNTJowxKWwqY+Ep0qL4wzgVlQTZljo7u
         9ppz4AwWlPP2Vw4avqQ1F04qq3y63uIuJ2PJNSuhu2jS9cHvVbS4T/K7OXEJlOYQgkfA
         jlj4kml53oUEAYAVDFqHm2y4IVe3sPbgYBduuPC6z826gNKhalHC/jv5LxYeW3w0UQ2J
         u3JQ==
X-Gm-Message-State: AOAM531Dh/KjHydREtkByJEnVO7AaMCfCRENcUO2Ii9J6+eHfnCOjXJe
        maye2y/AWaXGXFfxB9xDtBDHgi9Qq3YWo5YrTxMokDRMYmC3
X-Google-Smtp-Source: ABdhPJzGaY6E5SnEB3SD3BP4V12XiLq/lSuT7UfHasB614QLGq/e/7r6IrVgWgaS+eEsOr36HKI/5rrDaxfHwsBWWAl/yT38KBHG
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:14c2:: with SMTP id o2mr23786319ilk.54.1597165158224;
 Tue, 11 Aug 2020 09:59:18 -0700 (PDT)
Date:   Tue, 11 Aug 2020 09:59:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e7619e05ac9cfd5a@google.com>
Subject: general protection fault in ip6t_do_table (2)
From:   syzbot <syzbot+dcaf7e1befbc40105535@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    00e4db51 Merge tag 'perf-tools-2020-08-10' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1224746e900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=64a3282e09356140
dashboard link: https://syzkaller.appspot.com/bug?extid=dcaf7e1befbc40105535
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dcaf7e1befbc40105535@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 PID: 21 Comm: kworker/u4:1 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: wg-kex-wg0 wg_packet_handshake_send_worker
RIP: 0010:ip6t_do_table+0x289/0x1920 net/ipv6/netfilter/ip6_tables.c:286
Code: 80 3c 11 00 0f 85 f4 15 00 00 48 8b 4c 24 48 89 c0 48 8b 51 38 48 8d 1c c2 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 bd 15 00 00 48 8b 03 48 89 44 24 70 0f 1f 44 00
RSP: 0018:ffffc90000dd7650 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000008 RCX: ffff888000112800
RDX: 0000000000000001 RSI: ffff888000112840 RDI: ffff888000112838
RBP: 0000000000000001 R08: 0000000000000001 R09: ffffffff8c5eca27
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88808a0b8010
R13: ffff8880499a6400 R14: ffffc90000dd78a8 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004ed650 CR3: 00000000656af000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
 nf_hook_entry_hookfn include/linux/netfilter.h:136 [inline]
 nf_hook_slow+0xc5/0x1e0 net/netfilter/core.c:512
 nf_hook include/linux/netfilter.h:256 [inline]
 __ip6_local_out+0x419/0x890 net/ipv6/output_core.c:167
 ip6_local_out+0x26/0x1a0 net/ipv6/output_core.c:177
 ip6tunnel_xmit include/net/ip6_tunnel.h:160 [inline]
 udp_tunnel6_xmit_skb+0x6a6/0xb90 net/ipv6/ip6_udp_tunnel.c:109
 send6+0x4cd/0xbc0 drivers/net/wireguard/socket.c:152
 wg_socket_send_skb_to_peer drivers/net/wireguard/socket.c:177 [inline]
 wg_socket_send_buffer_to_peer+0x1f9/0x340 drivers/net/wireguard/socket.c:199
 wg_packet_send_handshake_initiation+0x1fc/0x240 drivers/net/wireguard/send.c:40
 wg_packet_handshake_send_worker+0x18/0x30 drivers/net/wireguard/send.c:51
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Modules linked in:
---[ end trace c813eadb1f32ebc3 ]---
RIP: 0010:ip6t_do_table+0x289/0x1920 net/ipv6/netfilter/ip6_tables.c:286
Code: 80 3c 11 00 0f 85 f4 15 00 00 48 8b 4c 24 48 89 c0 48 8b 51 38 48 8d 1c c2 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 bd 15 00 00 48 8b 03 48 89 44 24 70 0f 1f 44 00
RSP: 0018:ffffc90000dd7650 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000008 RCX: ffff888000112800
RDX: 0000000000000001 RSI: ffff888000112840 RDI: ffff888000112838
RBP: 0000000000000001 R08: 0000000000000001 R09: ffffffff8c5eca27
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88808a0b8010
R13: ffff8880499a6400 R14: ffffc90000dd78a8 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004ed650 CR3: 00000000656af000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
