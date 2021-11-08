Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26C1449ECC
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 23:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240237AbhKHW6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 17:58:09 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:55231 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237677AbhKHW6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 17:58:08 -0500
Received: by mail-il1-f198.google.com with SMTP id i18-20020a056e021d1200b002704079022dso11643889ila.21
        for <netdev@vger.kernel.org>; Mon, 08 Nov 2021 14:55:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=z5scoa6MdgDTM/v1KInMqbp8/KCcBhmgZOy4sVbZyCY=;
        b=WAbZ/c2JQCaCg/5i4dXyPtR7m8BnUMi6s116pfMVdf477DFDcr239Kmx0lBYsIgEMc
         uXVSz4UZ0qP/fCvAICFkbjxJkNdLHDbA2vKUGolgR+MN5cMwTnLd46zWy40ArrG7D12w
         jlCpoAVdqpinFlpE8yfXM/7tdqJGW98u8GpULIGxMOLVt7uK5BnYx8VkV7fhtiUqW2Hx
         xF9jMIfdx78gCuBMAFc7GP6Kgx/VIBUOEO9kuOeEWm75OnolWbFCqVisz2ZVxVZeorhP
         Gs+95ck5sl2R6eXylxJj+7iiYjNPPcOiZ5ue9+aSsbSiESd72HxhSveuItlCxLMsb2bS
         aDBg==
X-Gm-Message-State: AOAM533SB5IMjcsSdWN36QFyC+On0jhA9piF8GIxleVwb5akH6m97d84
        UeA6mOE5v5QNUMRAYyrwX4yfcX3k7QiZlcDxsYP15jmqBlBu
X-Google-Smtp-Source: ABdhPJxkX8wQ0QA2DeaLGIQSJPOxngvajESK7Vfl07z6xa8mUqFCT4tRjIr/6/JXFI3P5v6YNF5HWZZdWeSW7Ud1P9dqCLHRKuzs
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:ea5:: with SMTP id u5mr1743510ilj.285.1636412122868;
 Mon, 08 Nov 2021 14:55:22 -0800 (PST)
Date:   Mon, 08 Nov 2021 14:55:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004a302505d04ee33c@google.com>
Subject: [syzbot] bpf-next boot error: KASAN: global-out-of-bounds Read in task_iter_init
From:   syzbot <syzbot+e0d81ec552a21d9071aa@syzkaller.appspotmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c23551c9c36a selftests/bpf: Add exception handling selftes..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=107d637ab00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a5d447cdc3ae81d9
dashboard link: https://syzkaller.appspot.com/bug?extid=e0d81ec552a21d9071aa
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e0d81ec552a21d9071aa@syzkaller.appspotmail.com

Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: BNEP socket layer initialized
Bluetooth: CMTP (CAPI Emulation) ver 1.0
Bluetooth: CMTP socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Bluetooth: HIDP socket layer initialized
NET: Registered PF_RXRPC protocol family
Key type rxrpc registered
Key type rxrpc_s registered
NET: Registered PF_KCM protocol family
lec:lane_module_init: lec.c: initialized
mpoa:atm_mpoa_init: mpc.c: initialized
l2tp_core: L2TP core driver, V2.0
l2tp_ppp: PPPoL2TP kernel driver, V2.0
l2tp_ip: L2TP IP encapsulation support (L2TPv3)
l2tp_netlink: L2TP netlink interface
l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
NET: Registered PF_PHONET protocol family
8021q: 802.1Q VLAN Support v1.8
DCCP: Activated CCID 2 (TCP-like)
DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
sctp: Hash tables configured (bind 32/56)
NET: Registered PF_RDS protocol family
Registered RDS/infiniband transport
Registered RDS/tcp transport
tipc: Activated (version 2.0.0)
NET: Registered PF_TIPC protocol family
tipc: Started in single node mode
NET: Registered PF_SMC protocol family
9pnet: Installing 9P2000 support
NET: Registered PF_CAIF protocol family
NET: Registered PF_IEEE802154 protocol family
Key type dns_resolver registered
Key type ceph registered
libceph: loaded (mon/osd proto 15/24)
batman_adv: B.A.T.M.A.N. advanced 2021.3 (compatibility version 15) loaded
openvswitch: Open vSwitch switching datapath
NET: Registered PF_VSOCK protocol family
mpls_gso: MPLS GSO support
IPI shorthand broadcast: enabled
AVX2 version of gcm_enc/dec engaged.
AES CTR mode by8 optimization enabled
sched_clock: Marking stable (11873113821, 15126850)->(11899219612, -10978941)
registered taskstats version 1
==================================================================
BUG: KASAN: global-out-of-bounds in task_iter_init+0x212/0x2e7 kernel/bpf/task_iter.c:661
Read of size 4 at addr ffffffff90297404 by task swapper/0/1

CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xf/0x309 mm/kasan/report.c:256
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 task_iter_init+0x212/0x2e7 kernel/bpf/task_iter.c:661
 do_one_initcall+0x103/0x650 init/main.c:1295
 do_initcall_level init/main.c:1368 [inline]
 do_initcalls init/main.c:1384 [inline]
 do_basic_setup init/main.c:1403 [inline]
 kernel_init_freeable+0x6b1/0x73a init/main.c:1606
 kernel_init+0x1a/0x1d0 init/main.c:1497
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

The buggy address belongs to the variable:
 btf_task_struct_ids+0x4/0x40

Memory state around the buggy address:
 ffffffff90297300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffffffff90297380: 00 00 00 00 00 00 00 00 00 00 00 00 f9 f9 f9 f9
>ffffffff90297400: 04 f9 f9 f9 f9 f9 f9 f9 00 f9 f9 f9 f9 f9 f9 f9
                   ^
 ffffffff90297480: 00 04 f9 f9 f9 f9 f9 f9 00 00 f9 f9 f9 f9 f9 f9
 ffffffff90297500: 04 f9 f9 f9 f9 f9 f9 f9 04 f9 f9 f9 f9 f9 f9 f9
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
