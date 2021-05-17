Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9057A3838EA
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 18:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343495AbhEQQDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 12:03:44 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:51127 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244010AbhEQQBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 12:01:42 -0400
Received: by mail-il1-f200.google.com with SMTP id w3-20020a056e021a63b02901b3d9411975so6729134ilv.17
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 09:00:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=HO4zHcF8xb4JZ4yQh0Gr77M93NwiZbQGWT7Q4a8ctyY=;
        b=pXoKNxqnj/oaFbTg6rtsO4AfVmz371NrGHJxyWDVISFMxpfQawBESTJbVM5NHhdJfU
         V5bQ0M8a9MZ3FeaM0O+e574kDNauN+Tgl3bCLhWPr4FMxqH7sskdZSAg+O2Yb9UU2VKR
         5FQL8BLiHK7EOtTqaNCG0aXrIf4+0g7XIpk+3Z+jhUZLXc/5O2bs1KiPHx3Wzd9RzZJo
         vkIAB++kn9hYHZyQALgS+DjqqqkRUMNZxiDRz1lKL0wEI/TP8ZIeQgbvZkdOZ9uzDfns
         qdDG2h3Q4u+GsBrsu61o7b9J8KHgdDCfp5SD0zV91rZ+dOZs4k8s1xr/ek84drrg31ON
         uaTg==
X-Gm-Message-State: AOAM532unJy5dWihnXu1jzmGgxFxYVM6cBGLJIYCVbJtNo+vzL27FhqS
        nhV85ayYLhtEOgSV5tojq/ENBaRAmYWRlukoPp8uMzk9m4wx
X-Google-Smtp-Source: ABdhPJziJGbmMoZ0f0HVv7bXDP3P0weHXJGZ46CJy2meyEs+mo60n8I9Q/lbXqSiyc9rkhI1ljn4wWibOd2sgZYoBiVZRR1gH43x
MIME-Version: 1.0
X-Received: by 2002:a6b:c981:: with SMTP id z123mr582910iof.6.1621267225550;
 Mon, 17 May 2021 09:00:25 -0700 (PDT)
Date:   Mon, 17 May 2021 09:00:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000010a43c05c288b153@google.com>
Subject: [syzbot] KMSAN: uninit-value in sctp_inq_pop
From:   syzbot <syzbot+0beedf55972341845fa1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com,
        vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    bdefec9a minor fix
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=154a6123d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e6842a91012889c
dashboard link: https://syzkaller.appspot.com/bug?extid=0beedf55972341845fa1
compiler:       Debian clang version 11.0.1-2
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0beedf55972341845fa1@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in sctp_inq_pop+0x15cb/0x1970 net/sctp/inqueue.c:205
CPU: 0 PID: 4692 Comm: systemd-udevd Tainted: G        W         5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 sctp_inq_pop+0x15cb/0x1970 net/sctp/inqueue.c:205
 sctp_assoc_bh_rcv+0x207/0xe10 net/sctp/associola.c:994
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
 sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
 ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
 ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
 dst_input include/net/dst.h:458 [inline]
 ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
 process_backlog+0x517/0xbd0 net/core/dev.c:6365
 __napi_poll+0x13e/0xca0 net/core/dev.c:6912
 napi_poll net/core/dev.c:6979 [inline]
 net_rx_action+0x726/0x14a0 net/core/dev.c:7065
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345
 invoke_softirq kernel/softirq.c:221 [inline]
 __irq_exit_rcu+0x22f/0x280 kernel/softirq.c:422
 irq_exit_rcu+0xe/0x10 kernel/softirq.c:434
 sysvec_apic_timer_interrupt+0xc6/0xf0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:650
RIP: 0010:kmsan_get_shadow_origin_ptr+0x6/0xb0 mm/kmsan/kmsan_shadow.c:133
Code: 0f 00 75 10 48 8b 45 b8 c6 80 3c 1a 00 00 01 e9 63 fe ff ff 48 c7 c7 7f 3a 7a 90 31 c0 e8 eb e5 25 ff cc cc 55 48 89 e5 41 57 <41> 56 53 41 89 d7 48 89 f3 49 89 fe 48 81 fe 01 10 00 00 73 6e 80
RSP: 0018:ffff8881174eb498 EFLAGS: 00000246
RAX: ffff88811777c628 RBX: 0000000000000000 RCX: 00000001170eb740
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88811777c618
RBP: ffff8881174eb4a0 R08: ffffea000000000f R09: ffff88813fffa000
R10: 0000000000000002 R11: ffff8881117eddc0 R12: ffff88811777c618
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881174eb740
 __msan_metadata_ptr_for_load_8+0x10/0x20 mm/kmsan/kmsan_instr.c:55
 tomoyo_path_matches_pattern+0x88/0x4d0 security/tomoyo/util.c:941
 tomoyo_compare_name_union security/tomoyo/file.c:87 [inline]
 tomoyo_check_path_acl+0x272/0x360 security/tomoyo/file.c:260
 tomoyo_check_acl+0x249/0x5d0 security/tomoyo/domain.c:175
 tomoyo_path_permission security/tomoyo/file.c:586 [inline]
 tomoyo_check_open_permission+0x61f/0xdf0 security/tomoyo/file.c:777
 tomoyo_file_open+0x24c/0x2d0 security/tomoyo/tomoyo.c:313
 security_file_open+0xb1/0x1f0 security/security.c:1589
 do_dentry_open+0x4d5/0x1b50 fs/open.c:813
 vfs_open+0xaf/0xe0 fs/open.c:940
 do_open fs/namei.c:3365 [inline]
 path_openat+0x5731/0x6be0 fs/namei.c:3498
 do_filp_open+0x2b8/0x710 fs/namei.c:3525
 do_sys_openat2+0x25f/0x830 fs/open.c:1187
 do_sys_open fs/open.c:1203 [inline]
 __do_sys_open fs/open.c:1211 [inline]
 __se_sys_open+0x271/0x2d0 fs/open.c:1207
 __x64_sys_open+0x4a/0x70 fs/open.c:1207
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbf5e7ec9b1
Code: f7 d8 bf ff ff ff ff 64 89 02 eb cb 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 80 3f 00 74 1b be 00 08 09 00 b8 02 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1f 89 c7 e9 00 ff ff ff 48 8b 05 b1 54 2e 00
RSP: 002b:00007ffeaa699a98 EFLAGS: 00000202 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 0000563f833af280 RCX: 00007fbf5e7ec9b1
RDX: 00000000000000fe RSI: 0000000000090800 RDI: 0000563f83376370
RBP: 00007fbf5f9a2710 R08: 0000563f83392900 R09: 0000000000001010
R10: 0000000000000030 R11: 0000000000000202 R12: 0000000000000000
R13: 0000563f83376370 R14: 00000000000000fe R15: 0000563f83376370

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
 __msan_chain_origin+0x54/0xa0 mm/kmsan/kmsan_instr.c:147
 sctp_inq_pop+0x155b/0x1970 net/sctp/inqueue.c:201
 sctp_assoc_bh_rcv+0x207/0xe10 net/sctp/associola.c:994
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
 sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
 ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
 ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
 dst_input include/net/dst.h:458 [inline]
 ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
 process_backlog+0x517/0xbd0 net/core/dev.c:6365
 __napi_poll+0x13e/0xca0 net/core/dev.c:6912
 napi_poll net/core/dev.c:6979 [inline]
 net_rx_action+0x726/0x14a0 net/core/dev.c:7065
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2922 [inline]
 __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
 kmalloc_reserve net/core/skbuff.c:353 [inline]
 __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
 alloc_skb include/linux/skbuff.h:1103 [inline]
 sctp_packet_pack net/sctp/output.c:442 [inline]
 sctp_packet_transmit+0x17ac/0x44c0 net/sctp/output.c:588
 sctp_outq_flush_transports net/sctp/outqueue.c:1154 [inline]
 sctp_outq_flush+0x1e56/0x6510 net/sctp/outqueue.c:1202
 sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
 sctp_do_sm+0x9a18/0xa160 net/sctp/sm_sideeffect.c:1156
 sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
 sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
 ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
 ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
 dst_input include/net/dst.h:458 [inline]
 ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
 process_backlog+0x517/0xbd0 net/core/dev.c:6365
 __napi_poll+0x13e/0xca0 net/core/dev.c:6912
 napi_poll net/core/dev.c:6979 [inline]
 net_rx_action+0x726/0x14a0 net/core/dev.c:7065
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345
=====================================================
=====================================================
BUG: KMSAN: uninit-value in sctp_inq_pop+0x1622/0x1970 net/sctp/inqueue.c:208
CPU: 0 PID: 4692 Comm: systemd-udevd Tainted: G    B   W         5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 sctp_inq_pop+0x1622/0x1970 net/sctp/inqueue.c:208
 sctp_assoc_bh_rcv+0x207/0xe10 net/sctp/associola.c:994
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
 sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
 ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
 ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
 dst_input include/net/dst.h:458 [inline]
 ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
 process_backlog+0x517/0xbd0 net/core/dev.c:6365
 __napi_poll+0x13e/0xca0 net/core/dev.c:6912
 napi_poll net/core/dev.c:6979 [inline]
 net_rx_action+0x726/0x14a0 net/core/dev.c:7065
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345
 invoke_softirq kernel/softirq.c:221 [inline]
 __irq_exit_rcu+0x22f/0x280 kernel/softirq.c:422
 irq_exit_rcu+0xe/0x10 kernel/softirq.c:434
 sysvec_apic_timer_interrupt+0xc6/0xf0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:650
RIP: 0010:kmsan_get_shadow_origin_ptr+0x6/0xb0 mm/kmsan/kmsan_shadow.c:133
Code: 0f 00 75 10 48 8b 45 b8 c6 80 3c 1a 00 00 01 e9 63 fe ff ff 48 c7 c7 7f 3a 7a 90 31 c0 e8 eb e5 25 ff cc cc 55 48 89 e5 41 57 <41> 56 53 41 89 d7 48 89 f3 49 89 fe 48 81 fe 01 10 00 00 73 6e 80
RSP: 0018:ffff8881174eb498 EFLAGS: 00000246
RAX: ffff88811777c628 RBX: 0000000000000000 RCX: 00000001170eb740
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88811777c618
RBP: ffff8881174eb4a0 R08: ffffea000000000f R09: ffff88813fffa000
R10: 0000000000000002 R11: ffff8881117eddc0 R12: ffff88811777c618
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881174eb740
 __msan_metadata_ptr_for_load_8+0x10/0x20 mm/kmsan/kmsan_instr.c:55
 tomoyo_path_matches_pattern+0x88/0x4d0 security/tomoyo/util.c:941
 tomoyo_compare_name_union security/tomoyo/file.c:87 [inline]
 tomoyo_check_path_acl+0x272/0x360 security/tomoyo/file.c:260
 tomoyo_check_acl+0x249/0x5d0 security/tomoyo/domain.c:175
 tomoyo_path_permission security/tomoyo/file.c:586 [inline]
 tomoyo_check_open_permission+0x61f/0xdf0 security/tomoyo/file.c:777
 tomoyo_file_open+0x24c/0x2d0 security/tomoyo/tomoyo.c:313
 security_file_open+0xb1/0x1f0 security/security.c:1589
 do_dentry_open+0x4d5/0x1b50 fs/open.c:813
 vfs_open+0xaf/0xe0 fs/open.c:940
 do_open fs/namei.c:3365 [inline]
 path_openat+0x5731/0x6be0 fs/namei.c:3498
 do_filp_open+0x2b8/0x710 fs/namei.c:3525
 do_sys_openat2+0x25f/0x830 fs/open.c:1187
 do_sys_open fs/open.c:1203 [inline]
 __do_sys_open fs/open.c:1211 [inline]
 __se_sys_open+0x271/0x2d0 fs/open.c:1207
 __x64_sys_open+0x4a/0x70 fs/open.c:1207
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbf5e7ec9b1
Code: f7 d8 bf ff ff ff ff 64 89 02 eb cb 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 80 3f 00 74 1b be 00 08 09 00 b8 02 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1f 89 c7 e9 00 ff ff ff 48 8b 05 b1 54 2e 00
RSP: 002b:00007ffeaa699a98 EFLAGS: 00000202 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 0000563f833af280 RCX: 00007fbf5e7ec9b1
RDX: 00000000000000fe RSI: 0000000000090800 RDI: 0000563f83376370
RBP: 00007fbf5f9a2710 R08: 0000563f83392900 R09: 0000000000001010
R10: 0000000000000030 R11: 0000000000000202 R12: 0000000000000000
R13: 0000563f83376370 R14: 00000000000000fe R15: 0000563f83376370

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
 __msan_chain_origin+0x54/0xa0 mm/kmsan/kmsan_instr.c:147
 sctp_inq_pop+0x155b/0x1970 net/sctp/inqueue.c:201
 sctp_assoc_bh_rcv+0x207/0xe10 net/sctp/associola.c:994
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
 sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
 ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
 ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
 dst_input include/net/dst.h:458 [inline]
 ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
 process_backlog+0x517/0xbd0 net/core/dev.c:6365
 __napi_poll+0x13e/0xca0 net/core/dev.c:6912
 napi_poll net/core/dev.c:6979 [inline]
 net_rx_action+0x726/0x14a0 net/core/dev.c:7065
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2922 [inline]
 __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
 kmalloc_reserve net/core/skbuff.c:353 [inline]
 __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
 alloc_skb include/linux/skbuff.h:1103 [inline]
 sctp_packet_pack net/sctp/output.c:442 [inline]
 sctp_packet_transmit+0x17ac/0x44c0 net/sctp/output.c:588
 sctp_outq_flush_transports net/sctp/outqueue.c:1154 [inline]
 sctp_outq_flush+0x1e56/0x6510 net/sctp/outqueue.c:1202
 sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
 sctp_do_sm+0x9a18/0xa160 net/sctp/sm_sideeffect.c:1156
 sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
 sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
 ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
 ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
 dst_input include/net/dst.h:458 [inline]
 ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
 process_backlog+0x517/0xbd0 net/core/dev.c:6365
 __napi_poll+0x13e/0xca0 net/core/dev.c:6912
 napi_poll net/core/dev.c:6979 [inline]
 net_rx_action+0x726/0x14a0 net/core/dev.c:7065
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345
=====================================================
=====================================================
BUG: KMSAN: uninit-value in sctp_assoc_bh_rcv+0x425/0xe10 net/sctp/associola.c:1001
CPU: 0 PID: 4692 Comm: systemd-udevd Tainted: G    B   W         5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 sctp_assoc_bh_rcv+0x425/0xe10 net/sctp/associola.c:1001
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
 sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
 ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
 ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
 dst_input include/net/dst.h:458 [inline]
 ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
 process_backlog+0x517/0xbd0 net/core/dev.c:6365
 __napi_poll+0x13e/0xca0 net/core/dev.c:6912
 napi_poll net/core/dev.c:6979 [inline]
 net_rx_action+0x726/0x14a0 net/core/dev.c:7065
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345
 invoke_softirq kernel/softirq.c:221 [inline]
 __irq_exit_rcu+0x22f/0x280 kernel/softirq.c:422
 irq_exit_rcu+0xe/0x10 kernel/softirq.c:434
 sysvec_apic_timer_interrupt+0xc6/0xf0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:650
RIP: 0010:kmsan_get_shadow_origin_ptr+0x6/0xb0 mm/kmsan/kmsan_shadow.c:133
Code: 0f 00 75 10 48 8b 45 b8 c6 80 3c 1a 00 00 01 e9 63 fe ff ff 48 c7 c7 7f 3a 7a 90 31 c0 e8 eb e5 25 ff cc cc 55 48 89 e5 41 57 <41> 56 53 41 89 d7 48 89 f3 49 89 fe 48 81 fe 01 10 00 00 73 6e 80
RSP: 0018:ffff8881174eb498 EFLAGS: 00000246
RAX: ffff88811777c628 RBX: 0000000000000000 RCX: 00000001170eb740
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88811777c618
RBP: ffff8881174eb4a0 R08: ffffea000000000f R09: ffff88813fffa000
R10: 0000000000000002 R11: ffff8881117eddc0 R12: ffff88811777c618
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881174eb740
 __msan_metadata_ptr_for_load_8+0x10/0x20 mm/kmsan/kmsan_instr.c:55
 tomoyo_path_matches_pattern+0x88/0x4d0 security/tomoyo/util.c:941
 tomoyo_compare_name_union security/tomoyo/file.c:87 [inline]
 tomoyo_check_path_acl+0x272/0x360 security/tomoyo/file.c:260
 tomoyo_check_acl+0x249/0x5d0 security/tomoyo/domain.c:175
 tomoyo_path_permission security/tomoyo/file.c:586 [inline]
 tomoyo_check_open_permission+0x61f/0xdf0 security/tomoyo/file.c:777
 tomoyo_file_open+0x24c/0x2d0 security/tomoyo/tomoyo.c:313
 security_file_open+0xb1/0x1f0 security/security.c:1589
 do_dentry_open+0x4d5/0x1b50 fs/open.c:813
 vfs_open+0xaf/0xe0 fs/open.c:940
 do_open fs/namei.c:3365 [inline]
 path_openat+0x5731/0x6be0 fs/namei.c:3498
 do_filp_open+0x2b8/0x710 fs/namei.c:3525
 do_sys_openat2+0x25f/0x830 fs/open.c:1187
 do_sys_open fs/open.c:1203 [inline]
 __do_sys_open fs/open.c:1211 [inline]
 __se_sys_open+0x271/0x2d0 fs/open.c:1207
 __x64_sys_open+0x4a/0x70 fs/open.c:1207
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbf5e7ec9b1
Code: f7 d8 bf ff ff ff ff 64 89 02 eb cb 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 80 3f 00 74 1b be 00 08 09 00 b8 02 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1f 89 c7 e9 00 ff ff ff 48 8b 05 b1 54 2e 00
RSP: 002b:00007ffeaa699a98 EFLAGS: 00000202 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 0000563f833af280 RCX: 00007fbf5e7ec9b1
RDX: 00000000000000fe RSI: 0000000000090800 RDI: 0000563f83376370
RBP: 00007fbf5f9a2710 R08: 0000563f83392900 R09: 0000000000001010
R10: 0000000000000030 R11: 0000000000000202 R12: 0000000000000000
R13: 0000563f83376370 R14: 00000000000000fe R15: 0000563f83376370

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2922 [inline]
 __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
 kmalloc_reserve net/core/skbuff.c:353 [inline]
 __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
 alloc_skb include/linux/skbuff.h:1103 [inline]
 sctp_packet_pack net/sctp/output.c:442 [inline]
 sctp_packet_transmit+0x17ac/0x44c0 net/sctp/output.c:588
 sctp_outq_flush_transports net/sctp/outqueue.c:1154 [inline]
 sctp_outq_flush+0x1e56/0x6510 net/sctp/outqueue.c:1202
 sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
 sctp_do_sm+0x9a18/0xa160 net/sctp/sm_sideeffect.c:1156
 sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
 sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
 ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
 ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
 dst_input include/net/dst.h:458 [inline]
 ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
 process_backlog+0x517/0xbd0 net/core/dev.c:6365
 __napi_poll+0x13e/0xca0 net/core/dev.c:6912
 napi_poll net/core/dev.c:6979 [inline]
 net_rx_action+0x726/0x14a0 net/core/dev.c:7065
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345
=====================================================
=====================================================
BUG: KMSAN: uninit-value in sctp_assoc_bh_rcv+0x94d/0xe10 net/sctp/associola.c:1035
CPU: 0 PID: 4692 Comm: systemd-udevd Tainted: G    B   W         5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 sctp_assoc_bh_rcv+0x94d/0xe10 net/sctp/associola.c:1035
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
 sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
 ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
 ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
 dst_input include/net/dst.h:458 [inline]
 ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
 process_backlog+0x517/0xbd0 net/core/dev.c:6365
 __napi_poll+0x13e/0xca0 net/core/dev.c:6912
 napi_poll net/core/dev.c:6979 [inline]
 net_rx_action+0x726/0x14a0 net/core/dev.c:7065
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345
 invoke_softirq kernel/softirq.c:221 [inline]
 __irq_exit_rcu+0x22f/0x280 kernel/softirq.c:422
 irq_exit_rcu+0xe/0x10 kernel/softirq.c:434
 sysvec_apic_timer_interrupt+0xc6/0xf0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:650
RIP: 0010:kmsan_get_shadow_origin_ptr+0x6/0xb0 mm/kmsan/kmsan_shadow.c:133
Code: 0f 00 75 10 48 8b 45 b8 c6 80 3c 1a 00 00 01 e9 63 fe ff ff 48 c7 c7 7f 3a 7a 90 31 c0 e8 eb e5 25 ff cc cc 55 48 89 e5 41 57 <41> 56 53 41 89 d7 48 89 f3 49 89 fe 48 81 fe 01 10 00 00 73 6e 80
RSP: 0018:ffff8881174eb498 EFLAGS: 00000246
RAX: ffff88811777c628 RBX: 0000000000000000 RCX: 00000001170eb740
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88811777c618
RBP: ffff8881174eb4a0 R08: ffffea000000000f R09: ffff88813fffa000
R10: 0000000000000002 R11: ffff8881117eddc0 R12: ffff88811777c618
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881174eb740
 __msan_metadata_ptr_for_load_8+0x10/0x20 mm/kmsan/kmsan_instr.c:55
 tomoyo_path_matches_pattern+0x88/0x4d0 security/tomoyo/util.c:941
 tomoyo_compare_name_union security/tomoyo/file.c:87 [inline]
 tomoyo_check_path_acl+0x272/0x360 security/tomoyo/file.c:260
 tomoyo_check_acl+0x249/0x5d0 security/tomoyo/domain.c:175
 tomoyo_path_permission security/tomoyo/file.c:586 [inline]
 tomoyo_check_open_permission+0x61f/0xdf0 security/tomoyo/file.c:777
 tomoyo_file_open+0x24c/0x2d0 security/tomoyo/tomoyo.c:313
 security_file_open+0xb1/0x1f0 security/security.c:1589
 do_dentry_open+0x4d5/0x1b50 fs/open.c:813
 vfs_open+0xaf/0xe0 fs/open.c:940
 do_open fs/namei.c:3365 [inline]
 path_openat+0x5731/0x6be0 fs/namei.c:3498
 do_filp_open+0x2b8/0x710 fs/namei.c:3525
 do_sys_openat2+0x25f/0x830 fs/open.c:1187
 do_sys_open fs/open.c:1203 [inline]
 __do_sys_open fs/open.c:1211 [inline]
 __se_sys_open+0x271/0x2d0 fs/open.c:1207
 __x64_sys_open+0x4a/0x70 fs/open.c:1207
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbf5e7ec9b1
Code: f7 d8 bf ff ff ff ff 64 89 02 eb cb 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 80 3f 00 74 1b be 00 08 09 00 b8 02 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1f 89 c7 e9 00 ff ff ff 48 8b 05 b1 54 2e 00
RSP: 002b:00007ffeaa699a98 EFLAGS: 00000202 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 0000563f833af280 RCX: 00007fbf5e7ec9b1
RDX: 00000000000000fe RSI: 0000000000090800 RDI: 0000563f83376370
RBP: 00007fbf5f9a2710 R08: 0000563f83392900 R09: 0000000000001010
R10: 0000000000000030 R11: 0000000000000202 R12: 0000000000000000
R13: 0000563f83376370 R14: 00000000000000fe R15: 0000563f83376370

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2922 [inline]
 __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
 kmalloc_reserve net/core/skbuff.c:353 [inline]
 __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
 alloc_skb include/linux/skbuff.h:1103 [inline]
 sctp_packet_pack net/sctp/output.c:442 [inline]
 sctp_packet_transmit+0x17ac/0x44c0 net/sctp/output.c:588
 sctp_outq_flush_transports net/sctp/outqueue.c:1154 [inline]
 sctp_outq_flush+0x1e56/0x6510 net/sctp/outqueue.c:1202
 sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
 sctp_do_sm+0x9a18/0xa160 net/sctp/sm_sideeffect.c:1156
 sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
 sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
 ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
 ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
 dst_input include/net/dst.h:458 [inline]
 ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
 process_backlog+0x517/0xbd0 net/core/dev.c:6365
 __napi_poll+0x13e/0xca0 net/core/dev.c:6912
 napi_poll net/core/dev.c:6979 [inline]
 net_rx_action+0x726/0x14a0 net/core/dev.c:7065
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345
=====================================================
=====================================================
BUG: KMSAN: uninit-value in sctp_chunk_event_lookup net/sctp/sm_statetable.c:976 [inline]
BUG: KMSAN: uninit-value in sctp_sm_lookup_event+0x5b0/0x740 net/sctp/sm_statetable.c:73
CPU: 0 PID: 4692 Comm: systemd-udevd Tainted: G    B   W         5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 sctp_chunk_event_lookup net/sctp/sm_statetable.c:976 [inline]
 sctp_sm_lookup_event+0x5b0/0x740 net/sctp/sm_statetable.c:73
 sctp_do_sm+0x191/0xa160 net/sctp/sm_sideeffect.c:1148
 sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
 sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
 ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
 ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
 dst_input include/net/dst.h:458 [inline]
 ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
 process_backlog+0x517/0xbd0 net/core/dev.c:6365
 __napi_poll+0x13e/0xca0 net/core/dev.c:6912
 napi_poll net/core/dev.c:6979 [inline]
 net_rx_action+0x726/0x14a0 net/core/dev.c:7065
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345
 invoke_softirq kernel/softirq.c:221 [inline]
 __irq_exit_rcu+0x22f/0x280 kernel/softirq.c:422
 irq_exit_rcu+0xe/0x10 kernel/softirq.c:434
 sysvec_apic_timer_interrupt+0xc6/0xf0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:650
RIP: 0010:kmsan_get_shadow_origin_ptr+0x6/0xb0 mm/kmsan/kmsan_shadow.c:133
Code: 0f 00 75 10 48 8b 45 b8 c6 80 3c 1a 00 00 01 e9 63 fe ff ff 48 c7 c7 7f 3a 7a 90 31 c0 e8 eb e5 25 ff cc cc 55 48 89 e5 41 57 <41> 56 53 41 89 d7 48 89 f3 49 89 fe 48 81 fe 01 10 00 00 73 6e 80
RSP: 0018:ffff8881174eb498 EFLAGS: 00000246
RAX: ffff88811777c628 RBX: 0000000000000000 RCX: 00000001170eb740
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88811777c618
RBP: ffff8881174eb4a0 R08: ffffea000000000f R09: ffff88813fffa000
R10: 0000000000000002 R11: ffff8881117eddc0 R12: ffff88811777c618
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881174eb740
 __msan_metadata_ptr_for_load_8+0x10/0x20 mm/kmsan/kmsan_instr.c:55
 tomoyo_path_matches_pattern+0x88/0x4d0 security/tomoyo/util.c:941
 tomoyo_compare_name_union security/tomoyo/file.c:87 [inline]
 tomoyo_check_path_acl+0x272/0x360 security/tomoyo/file.c:260
 tomoyo_check_acl+0x249/0x5d0 security/tomoyo/domain.c:175
 tomoyo_path_permission security/tomoyo/file.c:586 [inline]
 tomoyo_check_open_permission+0x61f/0xdf0 security/tomoyo/file.c:777
 tomoyo_file_open+0x24c/0x2d0 security/tomoyo/tomoyo.c:313
 security_file_open+0xb1/0x1f0 security/security.c:1589
 do_dentry_open+0x4d5/0x1b50 fs/open.c:813
 vfs_open+0xaf/0xe0 fs/open.c:940
 do_open fs/namei.c:3365 [inline]
 path_openat+0x5731/0x6be0 fs/namei.c:3498
 do_filp_open+0x2b8/0x710 fs/namei.c:3525
 do_sys_openat2+0x25f/0x830 fs/open.c:1187
 do_sys_open fs/open.c:1203 [inline]
 __do_sys_open fs/open.c:1211 [inline]
 __se_sys_open+0x271/0x2d0 fs/open.c:1207
 __x64_sys_open+0x4a/0x70 fs/open.c:1207
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbf5e7ec9b1
Code: f7 d8 bf ff ff ff ff 64 89 02 eb cb 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 80 3f 00 74 1b be 00 08 09 00 b8 02 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1f 89 c7 e9 00 ff ff ff 48 8b 05 b1 54 2e 00
RSP: 002b:00007ffeaa699a98 EFLAGS: 00000202 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 0000563f833af280 RCX: 00007fbf5e7ec9b1
RDX: 00000000000000fe RSI: 0000000000090800 RDI: 0000563f83376370
RBP: 00007fbf5f9a2710 R08: 0000563f83392900 R09: 0000000000001010
R10: 0000000000000030 R11: 0000000000000202 R12: 0000000000000000
R13: 0000563f83376370 R14: 00000000000000fe R15: 0000563f83376370

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2922 [inline]
 __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
 kmalloc_reserve net/core/skbuff.c:353 [inline]
 __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
 alloc_skb include/linux/skbuff.h:1103 [inline]
 sctp_packet_pack net/sctp/output.c:442 [inline]
 sctp_packet_transmit+0x17ac/0x44c0 net/sctp/output.c:588
 sctp_outq_flush_transports net/sctp/outqueue.c:1154 [inline]
 sctp_outq_flush+0x1e56/0x6510 net/sctp/outqueue.c:1202
 sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
 sctp_do_sm+0x9a18/0xa160 net/sctp/sm_sideeffect.c:1156
 sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
 sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
 ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
 ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
 dst_input include/net/dst.h:458 [inline]
 ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
 process_backlog+0x517/0xbd0 net/core/dev.c:6365
 __napi_poll+0x13e/0xca0 net/core/dev.c:6912
 napi_poll net/core/dev.c:6979 [inline]
 net_rx_action+0x726/0x14a0 net/core/dev.c:7065
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345
=====================================================
=====================================================
BUG: KMSAN: uninit-value in sctp_do_sm+0x9808/0xa160 net/sctp/sm_sideeffect.c:1153
CPU: 0 PID: 4692 Comm: systemd-udevd Tainted: G    B   W         5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 sctp_do_sm+0x9808/0xa160 net/sctp/sm_sideeffect.c:1153
 sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
 sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
 ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
 ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
 dst_input include/net/dst.h:458 [inline]
 ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
 process_backlog+0x517/0xbd0 net/core/dev.c:6365
 __napi_poll+0x13e/0xca0 net/core/dev.c:6912
 napi_poll net/core/dev.c:6979 [inline]
 net_rx_action+0x726/0x14a0 net/core/dev.c:7065
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345
 invoke_softirq kernel/softirq.c:221 [inline]
 __irq_exit_rcu+0x22f/0x280 kernel/softirq.c:422
 irq_exit_rcu+0xe/0x10 kernel/softirq.c:434
 sysvec_apic_timer_interrupt+0xc6/0xf0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:650
RIP: 0010:kmsan_get_shadow_origin_ptr+0x6/0xb0 mm/kmsan/kmsan_shadow.c:133
Code: 0f 00 75 10 48 8b 45 b8 c6 80 3c 1a 00 00 01 e9 63 fe ff ff 48 c7 c7 7f 3a 7a 90 31 c0 e8 eb e5 25 ff cc cc 55 48 89 e5 41 57 <41> 56 53 41 89 d7 48 89 f3 49 89 fe 48 81 fe 01 10 00 00 73 6e 80
RSP: 0018:ffff8881174eb498 EFLAGS: 00000246
RAX: ffff88811777c628 RBX: 0000000000000000 RCX: 00000001170eb740
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88811777c618
RBP: ffff8881174eb4a0 R08: ffffea000000000f R09: ffff88813fffa000
R10: 0000000000000002 R11: ffff8881117eddc0 R12: ffff88811777c618
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881174eb740
 __msan_metadata_ptr_for_load_8+0x10/0x20 mm/kmsan/kmsan_instr.c:55
 tomoyo_path_matches_pattern+0x88/0x4d0 security/tomoyo/util.c:941
 tomoyo_compare_name_union security/tomoyo/file.c:87 [inline]
 tomoyo_check_path_acl+0x272/0x360 security/tomoyo/file.c:260
 tomoyo_check_acl+0x249/0x5d0 security/tomoyo/domain.c:175
 tomoyo_path_permission security/tomoyo/file.c:586 [inline]
 tomoyo_check_open_permission+0x61f/0xdf0 security/tomoyo/file.c:777
 tomoyo_file_open+0x24c/0x2d0 security/tomoyo/tomoyo.c:313
 security_file_open+0xb1/0x1f0 security/security.c:1589
 do_dentry_open+0x4d5/0x1b50 fs/open.c:813
 vfs_open+0xaf/0xe0 fs/open.c:940
 do_open fs/namei.c:3365 [inline]
 path_openat+0x5731/0x6be0 fs/namei.c:3498
 do_filp_open+0x2b8/0x710 fs/namei.c:3525
 do_sys_openat2+0x25f/0x830 fs/open.c:1187
 do_sys_open fs/open.c:1203 [inline]
 __do_sys_open fs/open.c:1211 [inline]
 __se_sys_open+0x271/0x2d0 fs/open.c:1207
 __x64_sys_open+0x4a/0x70 fs/open.c:1207
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbf5e7ec9b1
Code: f7 d8 bf ff ff ff ff 64 89 02 eb cb 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 80 3f 00 74 1b be 00 08 09 00 b8 02 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1f 89 c7 e9 00 ff ff ff 48 8b 05 b1 54 2e 00
RSP: 002b:00007ffeaa699a98 EFLAGS: 00000202 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 0000563f833af280 RCX: 00007fbf5e7ec9b1
RDX: 00000000000000fe RSI: 0000000000090800 RDI: 0000563f83376370
RBP: 00007fbf5f9a2710 R08: 0000563f83392900 R09: 0000000000001010
R10: 0000000000000030 R11: 0000000000000202 R12: 0000000000000000
R13: 0000563f83376370 R14: 00000000000000fe R15: 0000563f83376370

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2922 [inline]
 __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
 kmalloc_reserve net/core/skbuff.c:353 [inline]
 __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
 alloc_skb include/linux/skbuff.h:1103 [inline]
 sctp_packet_pack net/sctp/output.c:442 [inline]
 sctp_packet_transmit+0x17ac/0x44c0 net/sctp/output.c:588
 sctp_outq_flush_transports net/sctp/outqueue.c:1154 [inline]
 sctp_outq_flush+0x1e56/0x6510 net/sctp/outqueue.c:1202
 sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
 sctp_do_sm+0x9a18/0xa160 net/sctp/sm_sideeffect.c:1156
 sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
 sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
 ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
 ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
 dst_input include/net/dst.h:458 [inline]
 ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
 process_backlog+0x517/0xbd0 net/core/dev.c:6365
 __napi_poll+0x13e/0xca0 net/core/dev.c:6912
 napi_poll net/core/dev.c:6979 [inline]
 net_rx_action+0x726/0x14a0 net/core/dev.c:7065
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345
=====================================================
=====================================================
BUG: KMSAN: uninit-value in sctp_sf_eat_data_6_2+0x80a/0x12e0 net/sctp/sm_statefuns.c:3101
CPU: 0 PID: 4692 Comm: systemd-udevd Tainted: G    B   W         5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 sctp_sf_eat_data_6_2+0x80a/0x12e0 net/sctp/sm_statefuns.c:3101
 sctp_do_sm+0x29a/0xa160 net/sctp/sm_sideeffect.c:1153
 sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
 sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
 ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
 ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
 dst_input include/net/dst.h:458 [inline]
 ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
 process_backlog+0x517/0xbd0 net/core/dev.c:6365
 __napi_poll+0x13e/0xca0 net/core/dev.c:6912
 napi_poll net/core/dev.c:6979 [inline]
 net_rx_action+0x726/0x14a0 net/core/dev.c:7065
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345
 invoke_softirq kernel/softirq.c:221 [inline]
 __irq_exit_rcu+0x22f/0x280 kernel/softirq.c:422
 irq_exit_rcu+0xe/0x10 kernel/softirq.c:434
 sysvec_apic_timer_interrupt+0xc6/0xf0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:650
RIP: 0010:kmsan_get_shadow_origin_ptr+0x6/0xb0 mm/kmsan/kmsan_shadow.c:133
Code: 0f 00 75 10 48 8b 45 b8 c6 80 3c 1a 00 00 01 e9 63 fe ff ff 48 c7 c7 7f 3a 7a 90 31 c0 e8 eb e5 25 ff cc cc 55 48 89 e5 41 57 <41> 56 53 41 89 d7 48 89 f3 49 89 fe 48 81 fe 01 10 00 00 73 6e 80
RSP: 0018:ffff8881174eb498 EFLAGS: 00000246
RAX: ffff88811777c628 RBX: 0000000000000000 RCX: 00000001170eb740
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88811777c618
RBP: ffff8881174eb4a0 R08: ffffea000000000f R09: ffff88813fffa000
R10: 0000000000000002 R11: ffff8881117eddc0 R12: ffff88811777c618
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881174eb740
 __msan_metadata_ptr_for_load_8+0x10/0x20 mm/kmsan/kmsan_instr.c:55
 tomoyo_path_matches_pattern+0x88/0x4d0 security/tomoyo/util.c:941
 tomoyo_compare_name_union security/tomoyo/file.c:87 [inline]
 tomoyo_check_path_acl+0x272/0x360 security/tomoyo/file.c:260
 tomoyo_check_acl+0x249/0x5d0 security/tomoyo/domain.c:175
 tomoyo_path_permission security/tomoyo/file.c:586 [inline]
 tomoyo_check_open_permission+0x61f/0xdf0 security/tomoyo/file.c:777
 tomoyo_file_open+0x24c/0x2d0 security/tomoyo/tomoyo.c:313
 security_file_open+0xb1/0x1f0 security/security.c:1589
 do_dentry_open+0x4d5/0x1b50 fs/open.c:813
 vfs_open+0xaf/0xe0 fs/open.c:940
 do_open fs/namei.c:3365 [inline]
 path_openat+0x5731/0x6be0 fs/namei.c:3498
 do_filp_open+0x2b8/0x710 fs/namei.c:3525
 do_sys_openat2+0x25f/0x830 fs/open.c:1187
 do_sys_open fs/open.c:1203 [inline]
 __do_sys_open fs/open.c:1211 [inline]
 __se_sys_open+0x271/0x2d0 fs/open.c:1207
 __x64_sys_open+0x4a/0x70 fs/open.c:1207
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbf5e7ec9b1
Code: f7 d8 bf ff ff ff ff 64 89 02 eb cb 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 80 3f 00 74 1b be 00 08 09 00 b8 02 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1f 89 c7 e9 00 ff ff ff 48 8b 05 b1 54 2e 00
RSP: 002b:00007ffeaa699a98 EFLAGS: 00000202 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 0000563f833af280 RCX: 00007fbf5e7ec9b1
RDX: 00000000000000fe RSI: 0000000000090800 RDI: 0000563f83376370
RBP: 00007fbf5f9a2710 R08: 0000563f83392900 R09: 0000000000001010
R10: 0000000000000030 R11: 0000000000000202 R12: 0000000000000000
R13: 0000563f83376370 R14: 00000000000000fe R15: 0000563f83376370

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2922 [inline]
 __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
 kmalloc_reserve net/core/skbuff.c:353 [inline]
 __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
 alloc_skb include/linux/skbuff.h:1103 [inline]
 sctp_packet_pack net/sctp/output.c:442 [inline]
 sctp_packet_transmit+0x17ac/0x44c0 net/sctp/output.c:588
 sctp_outq_flush_transports net/sctp/outqueue.c:1154 [inline]
 sctp_outq_flush+0x1e56/0x6510 net/sctp/outqueue.c:1202
 sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
 sctp_do_sm+0x9a18/0xa160 net/sctp/sm_sideeffect.c:1156
 sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
 sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
 ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
 ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
 dst_input include/net/dst.h:458 [inline]
 ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
 process_backlog+0x517/0xbd0 net/core/dev.c:6365
 __napi_poll+0x13e/0xca0 net/core/dev.c:6912
 napi_poll net/core/dev.c:6979 [inline]
 net_rx_action+0x726/0x14a0 net/core/dev.c:7065
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345
=====================================================
=====================================================
BUG: KMSAN: uninit-value in sctp_sf_abort_violation+0x484/0x16a0 net/sctp/sm_statefuns.c:4624
CPU: 0 PID: 4692 Comm: systemd-udevd Tainted: G    B   W         5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 sctp_sf_abort_violation+0x484/0x16a0 net/sctp/sm_statefuns.c:4624
 sctp_sf_eat_data_6_2+0x36c/0x12e0 net/sctp/sm_statefuns.c:4717
 sctp_do_sm+0x29a/0xa160 net/sctp/sm_sideeffect.c:1153
 sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
 sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
 ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
 ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
 dst_input include/net/dst.h:458 [inline]
 ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
 process_backlog+0x517/0xbd0 net/core/dev.c:6365
 __napi_poll+0x13e/0xca0 net/core/dev.c:6912
 napi_poll net/core/dev.c:6979 [inline]
 net_rx_action+0x726/0x14a0 net/core/dev.c:7065
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345
 invoke_softirq kernel/softirq.c:221 [inline]
 __irq_exit_rcu+0x22f/0x280 kernel/softirq.c:422
 irq_exit_rcu+0xe/0x10 kernel/softirq.c:434
 sysvec_apic_timer_interrupt+0xc6/0xf0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:650
RIP: 0010:kmsan_get_shadow_origin_ptr+0x6/0xb0 mm/kmsan/kmsan_shadow.c:133
Code: 0f 00 75 10 48 8b 45 b8 c6 80 3c 1a 00 00 01 e9 63 fe ff ff 48 c7 c7 7f 3a 7a 90 31 c0 e8 eb e5 25 ff cc cc 55 48 89 e5 41 57 <41> 56 53 41 89 d7 48 89 f3 49 89 fe 48 81 fe 01 10 00 00 73 6e 80
RSP: 0018:ffff8881174eb498 EFLAGS: 00000246
RAX: ffff88811777c628 RBX: 0000000000000000 RCX: 00000001170eb740
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88811777c618
RBP: ffff8881174eb4a0 R08: ffffea000000000f R09: ffff88813fffa000
R10: 0000000000000002 R11: ffff8881117eddc0 R12: ffff88811777c618
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881174eb740
 __msan_metadata_ptr_for_load_8+0x10/0x20 mm/kmsan/kmsan_instr.c:55
 tomoyo_path_matches_pattern+0x88/0x4d0 security/tomoyo/util.c:941
 tomoyo_compare_name_union security/tomoyo/file.c:87 [inline]
 tomoyo_check_path_acl+0x272/0x360 security/tomoyo/file.c:260
 tomoyo_check_acl+0x249/0x5d0 security/tomoyo/domain.c:175
 tomoyo_path_permission security/tomoyo/file.c:586 [inline]
 tomoyo_check_open_permission+0x61f/0xdf0 security/tomoyo/file.c:777
 tomoyo_file_open+0x24c/0x2d0 security/tomoyo/tomoyo.c:313
 security_file_open+0xb1/0x1f0 security/security.c:1589
 do_dentry_open+0x4d5/0x1b50 fs/open.c:813
 vfs_open+0xaf/0xe0 fs/open.c:940
 do_open fs/namei.c:3365 [inline]
 path_openat+0x5731/0x6be0 fs/namei.c:3498
 do_filp_open+0x2b8/0x710 fs/namei.c:3525
 do_sys_openat2+0x25f/0x830 fs/open.c:1187
 do_sys_open fs/open.c:1203 [inline]
 __do_sys_open fs/open.c:1211 [inline]
 __se_sys_open+0x271/0x2d0 fs/open.c:1207
 __x64_sys_open+0x4a/0x70 fs/open.c:1207
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbf5e7ec9b1
Code: f7 d8 bf ff ff ff ff 64 89 02 eb cb 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 80 3f 00 74 1b be 00 08 09 00 b8 02 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1f 89 c7 e9 00 ff ff ff 48 8b 05 b1 54 2e 00
RSP: 002b:00007ffeaa699a98 EFLAGS: 00000202 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 0000563f833af280 RCX: 00007fbf5e7ec9b1
RDX: 00000000000000fe RSI: 0000000000090800 RDI: 0000563f83376370
RBP: 00007fbf5f9a2710 R08: 0000563f83392900 R09: 0000000000001010
R10: 0000000000000030 R11: 0000000000000202 R12: 0000000000000000
R13: 0000563f83376370 R14: 00000000000000fe R15: 0000563f83376370

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2922 [inline]
 __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
 kmalloc_reserve net/core/skbuff.c:353 [inline]
 __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
 alloc_skb include/linux/skbuff.h:1103 [inline]
 sctp_packet_pack net/sctp/output.c:442 [inline]
 sctp_packet_transmit+0x17ac/0x44c0 net/sctp/output.c:588
 sctp_outq_flush_transports net/sctp/outqueue.c:1154 [inline]
 sctp_outq_flush+0x1e56/0x6510 net/sctp/outqueue.c:1202
 sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
 sctp_do_sm+0x9a18/0xa160 net/sctp/sm_sideeffect.c:1156
 sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
 sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
 ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
 ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
 dst_input include/net/dst.h:458 [inline]
 ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
 process_backlog+0x517/0xbd0 net/core/dev.c:6365
 __napi_poll+0x13e/0xca0 net/core/dev.c:6912
 napi_poll net/core/dev.c:6979 [inline]
 net_rx_action+0x726/0x14a0 net/core/dev.c:7065
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345
=====================================================
=====================================================
BUG: KMSAN: uninit-value in sctp_ulpevent_make_assoc_change+0x96a/0xff0 net/sctp/ulpevent.c:126
CPU: 0 PID: 4692 Comm: systemd-udevd Tainted: G    B   W         5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 sctp_ulpevent_make_assoc_change+0x96a/0xff0 net/sctp/ulpevent.c:126
 sctp_cmd_assoc_failed net/sctp/sm_sideeffect.c:625 [inline]
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1608 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
 sctp_do_sm+0x374f/0xa160 net/sctp/sm_sideeffect.c:1156
 sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
 sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
 ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
 ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
 dst_input include/net/dst.h:458 [inline]
 ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
 process_backlog+0x517/0xbd0 net/core/dev.c:6365
 __napi_poll+0x13e/0xca0 net/core/dev.c:6912
 napi_poll net/core/dev.c:6979 [inline]
 net_rx_action+0x726/0x14a0 net/core/dev.c:7065
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345
 invoke_softirq kernel/softirq.c:221 [inline]
 __irq_exit_rcu+0x22f/0x280 kernel/softirq.c:422
 irq_exit_rcu+0xe/0x10 kernel/softirq.c:434
 sysvec_apic_timer_interrupt+0xc6/0xf0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:650
RIP: 0010:kmsan_get_shadow_origin_ptr+0x6/0xb0 mm/kmsan/kmsan_shadow.c:133
Code: 0f 00 75 10 48 8b 45 b8 c6 80 3c 1a 00 00 01 e9 63 fe ff ff 48 c7 c7 7f 3a 7a 90 31 c0 e8 eb e5 25 ff cc cc 55 48 89 e5 41 57 <41> 56 53 41 89 d7 48 89 f3 49 89 fe 48 81 fe 01 10 00 00 73 6e 80
RSP: 0018:ffff8881174eb498 EFLAGS: 00000246
RAX: ffff88811777c628 RBX: 0000000000000000 RCX: 00000001170eb740
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88811777c618
RBP: ffff8881174eb4a0 R08: ffffea000000000f R09: ffff88813fffa000
R10: 0000000000000002 R11: ffff8881117eddc0 R12: ffff88811777c618
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881174eb740
 __msan_metadata_ptr_for_load_8+0x10/0x20 mm/kmsan/kmsan_instr.c:55
 tomoyo_path_matches_pattern+0x88/0x4d0 security/tomoyo/util.c:941
 tomoyo_compare_name_union security/tomoyo/file.c:87 [inline]
 tomoyo_check_path_acl+0x272/0x360 security/tomoyo/file.c:260
 tomoyo_check_acl+0x249/0x5d0 security/tomoyo/domain.c:175
 tomoyo_path_permission security/tomoyo/file.c:586 [inline]
 tomoyo_check_open_permission+0x61f/0xdf0 security/tomoyo/file.c:777
 tomoyo_file_open+0x24c/0x2d0 security/tomoyo/tomoyo.c:313
 security_file_open+0xb1/0x1f0 security/security.c:1589
 do_dentry_open+0x4d5/0x1b50 fs/open.c:813
 vfs_open+0xaf/0xe0 fs/open.c:940
 do_open fs/namei.c:3365 [inline]
 path_openat+0x5731/0x6be0 fs/namei.c:3498
 do_filp_open+0x2b8/0x710 fs/namei.c:3525
 do_sys_openat2+0x25f/0x830 fs/open.c:1187
 do_sys_open fs/open.c:1203 [inline]
 __do_sys_open fs/open.c:1211 [inline]
 __se_sys_open+0x271/0x2d0 fs/open.c:1207
 __x64_sys_open+0x4a/0x70 fs/open.c:1207
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbf5e7ec9b1
Code: f7 d8 bf ff ff ff ff 64 89 02 eb cb 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 80 3f 00 74 1b be 00 08 09 00 b8 02 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1f 89 c7 e9 00 ff ff ff 48 8b 05 b1 54 2e 00
RSP: 002b:00007ffeaa699a98 EFLAGS: 00000202 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 0000563f833af280 RCX: 00007fbf5e7ec9b1
RDX: 00000000000000fe RSI: 0000000000090800 RDI: 0000563f83376370
RBP: 00007fbf5f9a2710 R08: 0000563f83392900 R09: 0000000000001010
R10: 0000000000000030 R11: 0000000000000202 R12: 0000000000000000
R13: 0000563f83376370 R14: 00000000000000fe R15: 0000563f83376370

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2922 [inline]
 __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
 kmalloc_reserve net/core/skbuff.c:353 [inline]
 __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
 alloc_skb include/linux/skbuff.h:1103 [inline]
 sctp_packet_pack net/sctp/output.c:442 [inline]
 sctp_packet_transmit+0x17ac/0x44c0 net/sctp/output.c:588
 sctp_outq_flush_transports net/sctp/outqueue.c:1154 [inline]
 sctp_outq_flush+0x1e56/0x6510 net/sctp/outqueue.c:1202
 sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
 sctp_do_sm+0x9a18/0xa160 net/sctp/sm_sideeffect.c:1156
 sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
 sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
 ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
 ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
 dst_input include/net/dst.h:458 [inline]
 ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
 process_backlog+0x517/0xbd0 net/core/dev.c:6365
 __napi_poll+0x13e/0xca0 net/core/dev.c:6912
 napi_poll net/core/dev.c:6979 [inline]
 net_rx_action+0x726/0x14a0 net/core/dev.c:7065
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
