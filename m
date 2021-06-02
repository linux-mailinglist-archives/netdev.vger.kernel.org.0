Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44CD73995C6
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 00:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhFBWRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 18:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbhFBWRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 18:17:42 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEA0C06174A;
        Wed,  2 Jun 2021 15:15:43 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id c5so3751626wrq.9;
        Wed, 02 Jun 2021 15:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q1dm+ob0R3Bxo8HHjTfn84wHEk2temw9DcWpxfATVK0=;
        b=aim5K4LSh5yiX3LvuClikkmwPU7vtKaXF80jvsaejEmqTkpfvTpG/XjuBCyBjQpXWQ
         QCmtz7j4kLJVQ2FX/XDqpyYTnCxvy23eypCmegJybMix1K5kYm4h0w9s8jZWG0STIPFM
         Y/JKaL+29TsN7Agq5o6FxJInaL1gL8voQvXFM7fPZPmluYwdrhcvNxj0HnrFw7njRwMA
         IdbRYnPYFxxNAAFNw54wr3btogi0SkTq9JUh7xM4d6X5pycwwOUnv6FWVn8UNsTIVG0L
         RtNYP3h+hdMEQ7x2RgoPKiajRIoQPEHwNirjMJnZ4FQ/r6AYYq9FT4ZE4VILrptLCrcS
         1wIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q1dm+ob0R3Bxo8HHjTfn84wHEk2temw9DcWpxfATVK0=;
        b=pBxjr/iDcNIiIqtT/BUslZJfIJhQ643pkNmurlE5/S0PBpB5VecdwLC37v3+nv/mZS
         YUZcrbzy1x5DVs5PTI4nqLBamTgw6FmazdaZyJ4w8InkzMVEsPQR7V52MDR1y4K1yLTJ
         s+mMBEQAmnNgbtr10lrSaGqC1LvgLFt/WxjWJUOvrdiv1SlBkf4aT7+z1Lb5wU4AFRiJ
         pMmI3l1Ut5wS6m4TuYFLNYFM0eeWi9k8iPiIuQ1iYO2H9a6hVW4dlv/fU3Gz8iI+uYl0
         YBMqct+VVMo9Pzm2wsjfV2UumIBQqHNCQ8rU65ru/geURGiUuo9T2pzQlr0WYZ2Wb6ux
         lNug==
X-Gm-Message-State: AOAM533h7SOg9k+7+sXNt/bBHDMumrShvjwQrnFpbYmmeDkdBSJQelxm
        9W2YntRl8x3OixLHi1JQ2pcZBDw2yGOUY/kKU98=
X-Google-Smtp-Source: ABdhPJxh/CvefAL4EPduqQwTbLfxkQ7atkPZmpLZeBFUaQjE4oaeV6luTEDndqrGxzImWhICJKm0rYK1bER5j099U9c=
X-Received: by 2002:a05:6000:2cf:: with SMTP id o15mr36021300wry.243.1622672142359;
 Wed, 02 Jun 2021 15:15:42 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000010a43c05c288b153@google.com>
In-Reply-To: <00000000000010a43c05c288b153@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 2 Jun 2021 18:15:31 -0400
Message-ID: <CADvbK_en5UzzXbM_=fBAXnvasMmdkSgzNEdxezEgLMKaFjnZsA@mail.gmail.com>
Subject: Re: [syzbot] KMSAN: uninit-value in sctp_inq_pop
To:     syzbot <syzbot+0beedf55972341845fa1@syzkaller.appspotmail.com>
Cc:     davem <davem@davemloft.net>,
        Alexander Potapenko <glider@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vlad Yasevich <vyasevich@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 12:05 PM syzbot
<syzbot+0beedf55972341845fa1@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    bdefec9a minor fix
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=154a6123d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4e6842a91012889c
> dashboard link: https://syzkaller.appspot.com/bug?extid=0beedf55972341845fa1
> compiler:       Debian clang version 11.0.1-2
> userspace arch: i386
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+0beedf55972341845fa1@syzkaller.appspotmail.com
>
> =====================================================
> BUG: KMSAN: uninit-value in sctp_inq_pop+0x15cb/0x1970 net/sctp/inqueue.c:205
        if (chunk->chunk_end + sizeof(*ch) <= skb_tail_pointer(chunk->skb)) {
                /* This is not a singleton */
                chunk->singleton = 0;

I'm thinking to change this to:
        if (chunk->chunk_end <= skb_tail_pointer(chunk->skb) - sizeof(*ch)) {
                /* This is not a singleton */
                chunk->singleton = 0;

> CPU: 0 PID: 4692 Comm: systemd-udevd Tainted: G        W         5.12.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
>  kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
>  __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
>  sctp_inq_pop+0x15cb/0x1970 net/sctp/inqueue.c:205
>  sctp_assoc_bh_rcv+0x207/0xe10 net/sctp/associola.c:994
>  sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
>  sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
>  sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
>  ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
>  __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
>  process_backlog+0x517/0xbd0 net/core/dev.c:6365
>  __napi_poll+0x13e/0xca0 net/core/dev.c:6912
>  napi_poll net/core/dev.c:6979 [inline]
>  net_rx_action+0x726/0x14a0 net/core/dev.c:7065
>  __do_softirq+0x1b9/0x715 kernel/softirq.c:345
>  invoke_softirq kernel/softirq.c:221 [inline]
>  __irq_exit_rcu+0x22f/0x280 kernel/softirq.c:422
>  irq_exit_rcu+0xe/0x10 kernel/softirq.c:434
>  sysvec_apic_timer_interrupt+0xc6/0xf0 arch/x86/kernel/apic/apic.c:1100
>  </IRQ>
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:650
> RIP: 0010:kmsan_get_shadow_origin_ptr+0x6/0xb0 mm/kmsan/kmsan_shadow.c:133
> Code: 0f 00 75 10 48 8b 45 b8 c6 80 3c 1a 00 00 01 e9 63 fe ff ff 48 c7 c7 7f 3a 7a 90 31 c0 e8 eb e5 25 ff cc cc 55 48 89 e5 41 57 <41> 56 53 41 89 d7 48 89 f3 49 89 fe 48 81 fe 01 10 00 00 73 6e 80
> RSP: 0018:ffff8881174eb498 EFLAGS: 00000246
> RAX: ffff88811777c628 RBX: 0000000000000000 RCX: 00000001170eb740
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88811777c618
> RBP: ffff8881174eb4a0 R08: ffffea000000000f R09: ffff88813fffa000
> R10: 0000000000000002 R11: ffff8881117eddc0 R12: ffff88811777c618
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881174eb740
>  __msan_metadata_ptr_for_load_8+0x10/0x20 mm/kmsan/kmsan_instr.c:55
>  tomoyo_path_matches_pattern+0x88/0x4d0 security/tomoyo/util.c:941
>  tomoyo_compare_name_union security/tomoyo/file.c:87 [inline]
>  tomoyo_check_path_acl+0x272/0x360 security/tomoyo/file.c:260
>  tomoyo_check_acl+0x249/0x5d0 security/tomoyo/domain.c:175
>  tomoyo_path_permission security/tomoyo/file.c:586 [inline]
>  tomoyo_check_open_permission+0x61f/0xdf0 security/tomoyo/file.c:777
>  tomoyo_file_open+0x24c/0x2d0 security/tomoyo/tomoyo.c:313
>  security_file_open+0xb1/0x1f0 security/security.c:1589
>  do_dentry_open+0x4d5/0x1b50 fs/open.c:813
>  vfs_open+0xaf/0xe0 fs/open.c:940
>  do_open fs/namei.c:3365 [inline]
>  path_openat+0x5731/0x6be0 fs/namei.c:3498
>  do_filp_open+0x2b8/0x710 fs/namei.c:3525
>  do_sys_openat2+0x25f/0x830 fs/open.c:1187
>  do_sys_open fs/open.c:1203 [inline]
>  __do_sys_open fs/open.c:1211 [inline]
>  __se_sys_open+0x271/0x2d0 fs/open.c:1207
>  __x64_sys_open+0x4a/0x70 fs/open.c:1207
>  do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fbf5e7ec9b1
> Code: f7 d8 bf ff ff ff ff 64 89 02 eb cb 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 80 3f 00 74 1b be 00 08 09 00 b8 02 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1f 89 c7 e9 00 ff ff ff 48 8b 05 b1 54 2e 00
> RSP: 002b:00007ffeaa699a98 EFLAGS: 00000202 ORIG_RAX: 0000000000000002
> RAX: ffffffffffffffda RBX: 0000563f833af280 RCX: 00007fbf5e7ec9b1
> RDX: 00000000000000fe RSI: 0000000000090800 RDI: 0000563f83376370
> RBP: 00007fbf5f9a2710 R08: 0000563f83392900 R09: 0000000000001010
> R10: 0000000000000030 R11: 0000000000000202 R12: 0000000000000000
> R13: 0000563f83376370 R14: 00000000000000fe R15: 0000563f83376370
>
> Uninit was stored to memory at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
>  kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
>  __msan_chain_origin+0x54/0xa0 mm/kmsan/kmsan_instr.c:147
>  sctp_inq_pop+0x155b/0x1970 net/sctp/inqueue.c:201
>  sctp_assoc_bh_rcv+0x207/0xe10 net/sctp/associola.c:994
>  sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
>  sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
>  sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
>  ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
>  __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
>  process_backlog+0x517/0xbd0 net/core/dev.c:6365
>  __napi_poll+0x13e/0xca0 net/core/dev.c:6912
>  napi_poll net/core/dev.c:6979 [inline]
>  net_rx_action+0x726/0x14a0 net/core/dev.c:7065
>  __do_softirq+0x1b9/0x715 kernel/softirq.c:345
>
> Uninit was created at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
>  kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
>  kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
>  slab_alloc_node mm/slub.c:2922 [inline]
>  __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
>  kmalloc_reserve net/core/skbuff.c:353 [inline]
>  __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
>  alloc_skb include/linux/skbuff.h:1103 [inline]
>  sctp_packet_pack net/sctp/output.c:442 [inline]
>  sctp_packet_transmit+0x17ac/0x44c0 net/sctp/output.c:588
>  sctp_outq_flush_transports net/sctp/outqueue.c:1154 [inline]
>  sctp_outq_flush+0x1e56/0x6510 net/sctp/outqueue.c:1202
>  sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
>  sctp_do_sm+0x9a18/0xa160 net/sctp/sm_sideeffect.c:1156
>  sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
>  sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
>  sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
>  sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
>  ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
>  __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
>  process_backlog+0x517/0xbd0 net/core/dev.c:6365
>  __napi_poll+0x13e/0xca0 net/core/dev.c:6912
>  napi_poll net/core/dev.c:6979 [inline]
>  net_rx_action+0x726/0x14a0 net/core/dev.c:7065
>  __do_softirq+0x1b9/0x715 kernel/softirq.c:345
> =====================================================
> =====================================================
> BUG: KMSAN: uninit-value in sctp_inq_pop+0x1622/0x1970 net/sctp/inqueue.c:208
> CPU: 0 PID: 4692 Comm: systemd-udevd Tainted: G    B   W         5.12.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
>  kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
>  __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
>  sctp_inq_pop+0x1622/0x1970 net/sctp/inqueue.c:208
>  sctp_assoc_bh_rcv+0x207/0xe10 net/sctp/associola.c:994
>  sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
>  sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
>  sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
>  ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
>  __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
>  process_backlog+0x517/0xbd0 net/core/dev.c:6365
>  __napi_poll+0x13e/0xca0 net/core/dev.c:6912
>  napi_poll net/core/dev.c:6979 [inline]
>  net_rx_action+0x726/0x14a0 net/core/dev.c:7065
>  __do_softirq+0x1b9/0x715 kernel/softirq.c:345
>  invoke_softirq kernel/softirq.c:221 [inline]
>  __irq_exit_rcu+0x22f/0x280 kernel/softirq.c:422
>  irq_exit_rcu+0xe/0x10 kernel/softirq.c:434
>  sysvec_apic_timer_interrupt+0xc6/0xf0 arch/x86/kernel/apic/apic.c:1100
>  </IRQ>
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:650
> RIP: 0010:kmsan_get_shadow_origin_ptr+0x6/0xb0 mm/kmsan/kmsan_shadow.c:133
> Code: 0f 00 75 10 48 8b 45 b8 c6 80 3c 1a 00 00 01 e9 63 fe ff ff 48 c7 c7 7f 3a 7a 90 31 c0 e8 eb e5 25 ff cc cc 55 48 89 e5 41 57 <41> 56 53 41 89 d7 48 89 f3 49 89 fe 48 81 fe 01 10 00 00 73 6e 80
> RSP: 0018:ffff8881174eb498 EFLAGS: 00000246
> RAX: ffff88811777c628 RBX: 0000000000000000 RCX: 00000001170eb740
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88811777c618
> RBP: ffff8881174eb4a0 R08: ffffea000000000f R09: ffff88813fffa000
> R10: 0000000000000002 R11: ffff8881117eddc0 R12: ffff88811777c618
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881174eb740
>  __msan_metadata_ptr_for_load_8+0x10/0x20 mm/kmsan/kmsan_instr.c:55
>  tomoyo_path_matches_pattern+0x88/0x4d0 security/tomoyo/util.c:941
>  tomoyo_compare_name_union security/tomoyo/file.c:87 [inline]
>  tomoyo_check_path_acl+0x272/0x360 security/tomoyo/file.c:260
>  tomoyo_check_acl+0x249/0x5d0 security/tomoyo/domain.c:175
>  tomoyo_path_permission security/tomoyo/file.c:586 [inline]
>  tomoyo_check_open_permission+0x61f/0xdf0 security/tomoyo/file.c:777
>  tomoyo_file_open+0x24c/0x2d0 security/tomoyo/tomoyo.c:313
>  security_file_open+0xb1/0x1f0 security/security.c:1589
>  do_dentry_open+0x4d5/0x1b50 fs/open.c:813
>  vfs_open+0xaf/0xe0 fs/open.c:940
>  do_open fs/namei.c:3365 [inline]
>  path_openat+0x5731/0x6be0 fs/namei.c:3498
>  do_filp_open+0x2b8/0x710 fs/namei.c:3525
>  do_sys_openat2+0x25f/0x830 fs/open.c:1187
>  do_sys_open fs/open.c:1203 [inline]
>  __do_sys_open fs/open.c:1211 [inline]
>  __se_sys_open+0x271/0x2d0 fs/open.c:1207
>  __x64_sys_open+0x4a/0x70 fs/open.c:1207
>  do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fbf5e7ec9b1
> Code: f7 d8 bf ff ff ff ff 64 89 02 eb cb 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 80 3f 00 74 1b be 00 08 09 00 b8 02 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1f 89 c7 e9 00 ff ff ff 48 8b 05 b1 54 2e 00
> RSP: 002b:00007ffeaa699a98 EFLAGS: 00000202 ORIG_RAX: 0000000000000002
> RAX: ffffffffffffffda RBX: 0000563f833af280 RCX: 00007fbf5e7ec9b1
> RDX: 00000000000000fe RSI: 0000000000090800 RDI: 0000563f83376370
> RBP: 00007fbf5f9a2710 R08: 0000563f83392900 R09: 0000000000001010
> R10: 0000000000000030 R11: 0000000000000202 R12: 0000000000000000
> R13: 0000563f83376370 R14: 00000000000000fe R15: 0000563f83376370
>
> Uninit was stored to memory at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
>  kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
>  __msan_chain_origin+0x54/0xa0 mm/kmsan/kmsan_instr.c:147
>  sctp_inq_pop+0x155b/0x1970 net/sctp/inqueue.c:201
>  sctp_assoc_bh_rcv+0x207/0xe10 net/sctp/associola.c:994
>  sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
>  sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
>  sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
>  ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
>  __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
>  process_backlog+0x517/0xbd0 net/core/dev.c:6365
>  __napi_poll+0x13e/0xca0 net/core/dev.c:6912
>  napi_poll net/core/dev.c:6979 [inline]
>  net_rx_action+0x726/0x14a0 net/core/dev.c:7065
>  __do_softirq+0x1b9/0x715 kernel/softirq.c:345
>
> Uninit was created at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
>  kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
>  kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
>  slab_alloc_node mm/slub.c:2922 [inline]
>  __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
>  kmalloc_reserve net/core/skbuff.c:353 [inline]
>  __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
>  alloc_skb include/linux/skbuff.h:1103 [inline]
>  sctp_packet_pack net/sctp/output.c:442 [inline]
>  sctp_packet_transmit+0x17ac/0x44c0 net/sctp/output.c:588
>  sctp_outq_flush_transports net/sctp/outqueue.c:1154 [inline]
>  sctp_outq_flush+0x1e56/0x6510 net/sctp/outqueue.c:1202
>  sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
>  sctp_do_sm+0x9a18/0xa160 net/sctp/sm_sideeffect.c:1156
>  sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
>  sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
>  sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
>  sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
>  ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
>  __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
>  process_backlog+0x517/0xbd0 net/core/dev.c:6365
>  __napi_poll+0x13e/0xca0 net/core/dev.c:6912
>  napi_poll net/core/dev.c:6979 [inline]
>  net_rx_action+0x726/0x14a0 net/core/dev.c:7065
>  __do_softirq+0x1b9/0x715 kernel/softirq.c:345
> =====================================================
> =====================================================
> BUG: KMSAN: uninit-value in sctp_assoc_bh_rcv+0x425/0xe10 net/sctp/associola.c:1001
> CPU: 0 PID: 4692 Comm: systemd-udevd Tainted: G    B   W         5.12.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
>  kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
>  __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
>  sctp_assoc_bh_rcv+0x425/0xe10 net/sctp/associola.c:1001
>  sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
>  sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
>  sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
>  ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
>  __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
>  process_backlog+0x517/0xbd0 net/core/dev.c:6365
>  __napi_poll+0x13e/0xca0 net/core/dev.c:6912
>  napi_poll net/core/dev.c:6979 [inline]
>  net_rx_action+0x726/0x14a0 net/core/dev.c:7065
>  __do_softirq+0x1b9/0x715 kernel/softirq.c:345
>  invoke_softirq kernel/softirq.c:221 [inline]
>  __irq_exit_rcu+0x22f/0x280 kernel/softirq.c:422
>  irq_exit_rcu+0xe/0x10 kernel/softirq.c:434
>  sysvec_apic_timer_interrupt+0xc6/0xf0 arch/x86/kernel/apic/apic.c:1100
>  </IRQ>
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:650
> RIP: 0010:kmsan_get_shadow_origin_ptr+0x6/0xb0 mm/kmsan/kmsan_shadow.c:133
> Code: 0f 00 75 10 48 8b 45 b8 c6 80 3c 1a 00 00 01 e9 63 fe ff ff 48 c7 c7 7f 3a 7a 90 31 c0 e8 eb e5 25 ff cc cc 55 48 89 e5 41 57 <41> 56 53 41 89 d7 48 89 f3 49 89 fe 48 81 fe 01 10 00 00 73 6e 80
> RSP: 0018:ffff8881174eb498 EFLAGS: 00000246
> RAX: ffff88811777c628 RBX: 0000000000000000 RCX: 00000001170eb740
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88811777c618
> RBP: ffff8881174eb4a0 R08: ffffea000000000f R09: ffff88813fffa000
> R10: 0000000000000002 R11: ffff8881117eddc0 R12: ffff88811777c618
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881174eb740
>  __msan_metadata_ptr_for_load_8+0x10/0x20 mm/kmsan/kmsan_instr.c:55
>  tomoyo_path_matches_pattern+0x88/0x4d0 security/tomoyo/util.c:941
>  tomoyo_compare_name_union security/tomoyo/file.c:87 [inline]
>  tomoyo_check_path_acl+0x272/0x360 security/tomoyo/file.c:260
>  tomoyo_check_acl+0x249/0x5d0 security/tomoyo/domain.c:175
>  tomoyo_path_permission security/tomoyo/file.c:586 [inline]
>  tomoyo_check_open_permission+0x61f/0xdf0 security/tomoyo/file.c:777
>  tomoyo_file_open+0x24c/0x2d0 security/tomoyo/tomoyo.c:313
>  security_file_open+0xb1/0x1f0 security/security.c:1589
>  do_dentry_open+0x4d5/0x1b50 fs/open.c:813
>  vfs_open+0xaf/0xe0 fs/open.c:940
>  do_open fs/namei.c:3365 [inline]
>  path_openat+0x5731/0x6be0 fs/namei.c:3498
>  do_filp_open+0x2b8/0x710 fs/namei.c:3525
>  do_sys_openat2+0x25f/0x830 fs/open.c:1187
>  do_sys_open fs/open.c:1203 [inline]
>  __do_sys_open fs/open.c:1211 [inline]
>  __se_sys_open+0x271/0x2d0 fs/open.c:1207
>  __x64_sys_open+0x4a/0x70 fs/open.c:1207
>  do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fbf5e7ec9b1
> Code: f7 d8 bf ff ff ff ff 64 89 02 eb cb 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 80 3f 00 74 1b be 00 08 09 00 b8 02 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1f 89 c7 e9 00 ff ff ff 48 8b 05 b1 54 2e 00
> RSP: 002b:00007ffeaa699a98 EFLAGS: 00000202 ORIG_RAX: 0000000000000002
> RAX: ffffffffffffffda RBX: 0000563f833af280 RCX: 00007fbf5e7ec9b1
> RDX: 00000000000000fe RSI: 0000000000090800 RDI: 0000563f83376370
> RBP: 00007fbf5f9a2710 R08: 0000563f83392900 R09: 0000000000001010
> R10: 0000000000000030 R11: 0000000000000202 R12: 0000000000000000
> R13: 0000563f83376370 R14: 00000000000000fe R15: 0000563f83376370
>
> Uninit was created at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
>  kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
>  kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
>  slab_alloc_node mm/slub.c:2922 [inline]
>  __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
>  kmalloc_reserve net/core/skbuff.c:353 [inline]
>  __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
>  alloc_skb include/linux/skbuff.h:1103 [inline]
>  sctp_packet_pack net/sctp/output.c:442 [inline]
>  sctp_packet_transmit+0x17ac/0x44c0 net/sctp/output.c:588
>  sctp_outq_flush_transports net/sctp/outqueue.c:1154 [inline]
>  sctp_outq_flush+0x1e56/0x6510 net/sctp/outqueue.c:1202
>  sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
>  sctp_do_sm+0x9a18/0xa160 net/sctp/sm_sideeffect.c:1156
>  sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
>  sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
>  sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
>  sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
>  ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
>  __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
>  process_backlog+0x517/0xbd0 net/core/dev.c:6365
>  __napi_poll+0x13e/0xca0 net/core/dev.c:6912
>  napi_poll net/core/dev.c:6979 [inline]
>  net_rx_action+0x726/0x14a0 net/core/dev.c:7065
>  __do_softirq+0x1b9/0x715 kernel/softirq.c:345
> =====================================================
> =====================================================
> BUG: KMSAN: uninit-value in sctp_assoc_bh_rcv+0x94d/0xe10 net/sctp/associola.c:1035
> CPU: 0 PID: 4692 Comm: systemd-udevd Tainted: G    B   W         5.12.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
>  kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
>  __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
>  sctp_assoc_bh_rcv+0x94d/0xe10 net/sctp/associola.c:1035
>  sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
>  sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
>  sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
>  ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
>  __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
>  process_backlog+0x517/0xbd0 net/core/dev.c:6365
>  __napi_poll+0x13e/0xca0 net/core/dev.c:6912
>  napi_poll net/core/dev.c:6979 [inline]
>  net_rx_action+0x726/0x14a0 net/core/dev.c:7065
>  __do_softirq+0x1b9/0x715 kernel/softirq.c:345
>  invoke_softirq kernel/softirq.c:221 [inline]
>  __irq_exit_rcu+0x22f/0x280 kernel/softirq.c:422
>  irq_exit_rcu+0xe/0x10 kernel/softirq.c:434
>  sysvec_apic_timer_interrupt+0xc6/0xf0 arch/x86/kernel/apic/apic.c:1100
>  </IRQ>
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:650
> RIP: 0010:kmsan_get_shadow_origin_ptr+0x6/0xb0 mm/kmsan/kmsan_shadow.c:133
> Code: 0f 00 75 10 48 8b 45 b8 c6 80 3c 1a 00 00 01 e9 63 fe ff ff 48 c7 c7 7f 3a 7a 90 31 c0 e8 eb e5 25 ff cc cc 55 48 89 e5 41 57 <41> 56 53 41 89 d7 48 89 f3 49 89 fe 48 81 fe 01 10 00 00 73 6e 80
> RSP: 0018:ffff8881174eb498 EFLAGS: 00000246
> RAX: ffff88811777c628 RBX: 0000000000000000 RCX: 00000001170eb740
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88811777c618
> RBP: ffff8881174eb4a0 R08: ffffea000000000f R09: ffff88813fffa000
> R10: 0000000000000002 R11: ffff8881117eddc0 R12: ffff88811777c618
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881174eb740
>  __msan_metadata_ptr_for_load_8+0x10/0x20 mm/kmsan/kmsan_instr.c:55
>  tomoyo_path_matches_pattern+0x88/0x4d0 security/tomoyo/util.c:941
>  tomoyo_compare_name_union security/tomoyo/file.c:87 [inline]
>  tomoyo_check_path_acl+0x272/0x360 security/tomoyo/file.c:260
>  tomoyo_check_acl+0x249/0x5d0 security/tomoyo/domain.c:175
>  tomoyo_path_permission security/tomoyo/file.c:586 [inline]
>  tomoyo_check_open_permission+0x61f/0xdf0 security/tomoyo/file.c:777
>  tomoyo_file_open+0x24c/0x2d0 security/tomoyo/tomoyo.c:313
>  security_file_open+0xb1/0x1f0 security/security.c:1589
>  do_dentry_open+0x4d5/0x1b50 fs/open.c:813
>  vfs_open+0xaf/0xe0 fs/open.c:940
>  do_open fs/namei.c:3365 [inline]
>  path_openat+0x5731/0x6be0 fs/namei.c:3498
>  do_filp_open+0x2b8/0x710 fs/namei.c:3525
>  do_sys_openat2+0x25f/0x830 fs/open.c:1187
>  do_sys_open fs/open.c:1203 [inline]
>  __do_sys_open fs/open.c:1211 [inline]
>  __se_sys_open+0x271/0x2d0 fs/open.c:1207
>  __x64_sys_open+0x4a/0x70 fs/open.c:1207
>  do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fbf5e7ec9b1
> Code: f7 d8 bf ff ff ff ff 64 89 02 eb cb 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 80 3f 00 74 1b be 00 08 09 00 b8 02 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1f 89 c7 e9 00 ff ff ff 48 8b 05 b1 54 2e 00
> RSP: 002b:00007ffeaa699a98 EFLAGS: 00000202 ORIG_RAX: 0000000000000002
> RAX: ffffffffffffffda RBX: 0000563f833af280 RCX: 00007fbf5e7ec9b1
> RDX: 00000000000000fe RSI: 0000000000090800 RDI: 0000563f83376370
> RBP: 00007fbf5f9a2710 R08: 0000563f83392900 R09: 0000000000001010
> R10: 0000000000000030 R11: 0000000000000202 R12: 0000000000000000
> R13: 0000563f83376370 R14: 00000000000000fe R15: 0000563f83376370
>
> Uninit was created at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
>  kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
>  kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
>  slab_alloc_node mm/slub.c:2922 [inline]
>  __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
>  kmalloc_reserve net/core/skbuff.c:353 [inline]
>  __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
>  alloc_skb include/linux/skbuff.h:1103 [inline]
>  sctp_packet_pack net/sctp/output.c:442 [inline]
>  sctp_packet_transmit+0x17ac/0x44c0 net/sctp/output.c:588
>  sctp_outq_flush_transports net/sctp/outqueue.c:1154 [inline]
>  sctp_outq_flush+0x1e56/0x6510 net/sctp/outqueue.c:1202
>  sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
>  sctp_do_sm+0x9a18/0xa160 net/sctp/sm_sideeffect.c:1156
>  sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
>  sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
>  sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
>  sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
>  ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
>  __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
>  process_backlog+0x517/0xbd0 net/core/dev.c:6365
>  __napi_poll+0x13e/0xca0 net/core/dev.c:6912
>  napi_poll net/core/dev.c:6979 [inline]
>  net_rx_action+0x726/0x14a0 net/core/dev.c:7065
>  __do_softirq+0x1b9/0x715 kernel/softirq.c:345
> =====================================================
> =====================================================
> BUG: KMSAN: uninit-value in sctp_chunk_event_lookup net/sctp/sm_statetable.c:976 [inline]
> BUG: KMSAN: uninit-value in sctp_sm_lookup_event+0x5b0/0x740 net/sctp/sm_statetable.c:73
> CPU: 0 PID: 4692 Comm: systemd-udevd Tainted: G    B   W         5.12.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
>  kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
>  __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
>  sctp_chunk_event_lookup net/sctp/sm_statetable.c:976 [inline]
>  sctp_sm_lookup_event+0x5b0/0x740 net/sctp/sm_statetable.c:73
>  sctp_do_sm+0x191/0xa160 net/sctp/sm_sideeffect.c:1148
>  sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
>  sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
>  sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
>  sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
>  ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
>  __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
>  process_backlog+0x517/0xbd0 net/core/dev.c:6365
>  __napi_poll+0x13e/0xca0 net/core/dev.c:6912
>  napi_poll net/core/dev.c:6979 [inline]
>  net_rx_action+0x726/0x14a0 net/core/dev.c:7065
>  __do_softirq+0x1b9/0x715 kernel/softirq.c:345
>  invoke_softirq kernel/softirq.c:221 [inline]
>  __irq_exit_rcu+0x22f/0x280 kernel/softirq.c:422
>  irq_exit_rcu+0xe/0x10 kernel/softirq.c:434
>  sysvec_apic_timer_interrupt+0xc6/0xf0 arch/x86/kernel/apic/apic.c:1100
>  </IRQ>
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:650
> RIP: 0010:kmsan_get_shadow_origin_ptr+0x6/0xb0 mm/kmsan/kmsan_shadow.c:133
> Code: 0f 00 75 10 48 8b 45 b8 c6 80 3c 1a 00 00 01 e9 63 fe ff ff 48 c7 c7 7f 3a 7a 90 31 c0 e8 eb e5 25 ff cc cc 55 48 89 e5 41 57 <41> 56 53 41 89 d7 48 89 f3 49 89 fe 48 81 fe 01 10 00 00 73 6e 80
> RSP: 0018:ffff8881174eb498 EFLAGS: 00000246
> RAX: ffff88811777c628 RBX: 0000000000000000 RCX: 00000001170eb740
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88811777c618
> RBP: ffff8881174eb4a0 R08: ffffea000000000f R09: ffff88813fffa000
> R10: 0000000000000002 R11: ffff8881117eddc0 R12: ffff88811777c618
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881174eb740
>  __msan_metadata_ptr_for_load_8+0x10/0x20 mm/kmsan/kmsan_instr.c:55
>  tomoyo_path_matches_pattern+0x88/0x4d0 security/tomoyo/util.c:941
>  tomoyo_compare_name_union security/tomoyo/file.c:87 [inline]
>  tomoyo_check_path_acl+0x272/0x360 security/tomoyo/file.c:260
>  tomoyo_check_acl+0x249/0x5d0 security/tomoyo/domain.c:175
>  tomoyo_path_permission security/tomoyo/file.c:586 [inline]
>  tomoyo_check_open_permission+0x61f/0xdf0 security/tomoyo/file.c:777
>  tomoyo_file_open+0x24c/0x2d0 security/tomoyo/tomoyo.c:313
>  security_file_open+0xb1/0x1f0 security/security.c:1589
>  do_dentry_open+0x4d5/0x1b50 fs/open.c:813
>  vfs_open+0xaf/0xe0 fs/open.c:940
>  do_open fs/namei.c:3365 [inline]
>  path_openat+0x5731/0x6be0 fs/namei.c:3498
>  do_filp_open+0x2b8/0x710 fs/namei.c:3525
>  do_sys_openat2+0x25f/0x830 fs/open.c:1187
>  do_sys_open fs/open.c:1203 [inline]
>  __do_sys_open fs/open.c:1211 [inline]
>  __se_sys_open+0x271/0x2d0 fs/open.c:1207
>  __x64_sys_open+0x4a/0x70 fs/open.c:1207
>  do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fbf5e7ec9b1
> Code: f7 d8 bf ff ff ff ff 64 89 02 eb cb 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 80 3f 00 74 1b be 00 08 09 00 b8 02 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1f 89 c7 e9 00 ff ff ff 48 8b 05 b1 54 2e 00
> RSP: 002b:00007ffeaa699a98 EFLAGS: 00000202 ORIG_RAX: 0000000000000002
> RAX: ffffffffffffffda RBX: 0000563f833af280 RCX: 00007fbf5e7ec9b1
> RDX: 00000000000000fe RSI: 0000000000090800 RDI: 0000563f83376370
> RBP: 00007fbf5f9a2710 R08: 0000563f83392900 R09: 0000000000001010
> R10: 0000000000000030 R11: 0000000000000202 R12: 0000000000000000
> R13: 0000563f83376370 R14: 00000000000000fe R15: 0000563f83376370
>
> Uninit was created at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
>  kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
>  kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
>  slab_alloc_node mm/slub.c:2922 [inline]
>  __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
>  kmalloc_reserve net/core/skbuff.c:353 [inline]
>  __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
>  alloc_skb include/linux/skbuff.h:1103 [inline]
>  sctp_packet_pack net/sctp/output.c:442 [inline]
>  sctp_packet_transmit+0x17ac/0x44c0 net/sctp/output.c:588
>  sctp_outq_flush_transports net/sctp/outqueue.c:1154 [inline]
>  sctp_outq_flush+0x1e56/0x6510 net/sctp/outqueue.c:1202
>  sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
>  sctp_do_sm+0x9a18/0xa160 net/sctp/sm_sideeffect.c:1156
>  sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
>  sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
>  sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
>  sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
>  ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
>  __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
>  process_backlog+0x517/0xbd0 net/core/dev.c:6365
>  __napi_poll+0x13e/0xca0 net/core/dev.c:6912
>  napi_poll net/core/dev.c:6979 [inline]
>  net_rx_action+0x726/0x14a0 net/core/dev.c:7065
>  __do_softirq+0x1b9/0x715 kernel/softirq.c:345
> =====================================================
> =====================================================
> BUG: KMSAN: uninit-value in sctp_do_sm+0x9808/0xa160 net/sctp/sm_sideeffect.c:1153
> CPU: 0 PID: 4692 Comm: systemd-udevd Tainted: G    B   W         5.12.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
>  kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
>  __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
>  sctp_do_sm+0x9808/0xa160 net/sctp/sm_sideeffect.c:1153
>  sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
>  sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
>  sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
>  sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
>  ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
>  __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
>  process_backlog+0x517/0xbd0 net/core/dev.c:6365
>  __napi_poll+0x13e/0xca0 net/core/dev.c:6912
>  napi_poll net/core/dev.c:6979 [inline]
>  net_rx_action+0x726/0x14a0 net/core/dev.c:7065
>  __do_softirq+0x1b9/0x715 kernel/softirq.c:345
>  invoke_softirq kernel/softirq.c:221 [inline]
>  __irq_exit_rcu+0x22f/0x280 kernel/softirq.c:422
>  irq_exit_rcu+0xe/0x10 kernel/softirq.c:434
>  sysvec_apic_timer_interrupt+0xc6/0xf0 arch/x86/kernel/apic/apic.c:1100
>  </IRQ>
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:650
> RIP: 0010:kmsan_get_shadow_origin_ptr+0x6/0xb0 mm/kmsan/kmsan_shadow.c:133
> Code: 0f 00 75 10 48 8b 45 b8 c6 80 3c 1a 00 00 01 e9 63 fe ff ff 48 c7 c7 7f 3a 7a 90 31 c0 e8 eb e5 25 ff cc cc 55 48 89 e5 41 57 <41> 56 53 41 89 d7 48 89 f3 49 89 fe 48 81 fe 01 10 00 00 73 6e 80
> RSP: 0018:ffff8881174eb498 EFLAGS: 00000246
> RAX: ffff88811777c628 RBX: 0000000000000000 RCX: 00000001170eb740
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88811777c618
> RBP: ffff8881174eb4a0 R08: ffffea000000000f R09: ffff88813fffa000
> R10: 0000000000000002 R11: ffff8881117eddc0 R12: ffff88811777c618
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881174eb740
>  __msan_metadata_ptr_for_load_8+0x10/0x20 mm/kmsan/kmsan_instr.c:55
>  tomoyo_path_matches_pattern+0x88/0x4d0 security/tomoyo/util.c:941
>  tomoyo_compare_name_union security/tomoyo/file.c:87 [inline]
>  tomoyo_check_path_acl+0x272/0x360 security/tomoyo/file.c:260
>  tomoyo_check_acl+0x249/0x5d0 security/tomoyo/domain.c:175
>  tomoyo_path_permission security/tomoyo/file.c:586 [inline]
>  tomoyo_check_open_permission+0x61f/0xdf0 security/tomoyo/file.c:777
>  tomoyo_file_open+0x24c/0x2d0 security/tomoyo/tomoyo.c:313
>  security_file_open+0xb1/0x1f0 security/security.c:1589
>  do_dentry_open+0x4d5/0x1b50 fs/open.c:813
>  vfs_open+0xaf/0xe0 fs/open.c:940
>  do_open fs/namei.c:3365 [inline]
>  path_openat+0x5731/0x6be0 fs/namei.c:3498
>  do_filp_open+0x2b8/0x710 fs/namei.c:3525
>  do_sys_openat2+0x25f/0x830 fs/open.c:1187
>  do_sys_open fs/open.c:1203 [inline]
>  __do_sys_open fs/open.c:1211 [inline]
>  __se_sys_open+0x271/0x2d0 fs/open.c:1207
>  __x64_sys_open+0x4a/0x70 fs/open.c:1207
>  do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fbf5e7ec9b1
> Code: f7 d8 bf ff ff ff ff 64 89 02 eb cb 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 80 3f 00 74 1b be 00 08 09 00 b8 02 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1f 89 c7 e9 00 ff ff ff 48 8b 05 b1 54 2e 00
> RSP: 002b:00007ffeaa699a98 EFLAGS: 00000202 ORIG_RAX: 0000000000000002
> RAX: ffffffffffffffda RBX: 0000563f833af280 RCX: 00007fbf5e7ec9b1
> RDX: 00000000000000fe RSI: 0000000000090800 RDI: 0000563f83376370
> RBP: 00007fbf5f9a2710 R08: 0000563f83392900 R09: 0000000000001010
> R10: 0000000000000030 R11: 0000000000000202 R12: 0000000000000000
> R13: 0000563f83376370 R14: 00000000000000fe R15: 0000563f83376370
>
> Uninit was created at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
>  kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
>  kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
>  slab_alloc_node mm/slub.c:2922 [inline]
>  __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
>  kmalloc_reserve net/core/skbuff.c:353 [inline]
>  __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
>  alloc_skb include/linux/skbuff.h:1103 [inline]
>  sctp_packet_pack net/sctp/output.c:442 [inline]
>  sctp_packet_transmit+0x17ac/0x44c0 net/sctp/output.c:588
>  sctp_outq_flush_transports net/sctp/outqueue.c:1154 [inline]
>  sctp_outq_flush+0x1e56/0x6510 net/sctp/outqueue.c:1202
>  sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
>  sctp_do_sm+0x9a18/0xa160 net/sctp/sm_sideeffect.c:1156
>  sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
>  sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
>  sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
>  sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
>  ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
>  __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
>  process_backlog+0x517/0xbd0 net/core/dev.c:6365
>  __napi_poll+0x13e/0xca0 net/core/dev.c:6912
>  napi_poll net/core/dev.c:6979 [inline]
>  net_rx_action+0x726/0x14a0 net/core/dev.c:7065
>  __do_softirq+0x1b9/0x715 kernel/softirq.c:345
> =====================================================
> =====================================================
> BUG: KMSAN: uninit-value in sctp_sf_eat_data_6_2+0x80a/0x12e0 net/sctp/sm_statefuns.c:3101
> CPU: 0 PID: 4692 Comm: systemd-udevd Tainted: G    B   W         5.12.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
>  kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
>  __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
>  sctp_sf_eat_data_6_2+0x80a/0x12e0 net/sctp/sm_statefuns.c:3101
>  sctp_do_sm+0x29a/0xa160 net/sctp/sm_sideeffect.c:1153
>  sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
>  sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
>  sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
>  sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
>  ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
>  __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
>  process_backlog+0x517/0xbd0 net/core/dev.c:6365
>  __napi_poll+0x13e/0xca0 net/core/dev.c:6912
>  napi_poll net/core/dev.c:6979 [inline]
>  net_rx_action+0x726/0x14a0 net/core/dev.c:7065
>  __do_softirq+0x1b9/0x715 kernel/softirq.c:345
>  invoke_softirq kernel/softirq.c:221 [inline]
>  __irq_exit_rcu+0x22f/0x280 kernel/softirq.c:422
>  irq_exit_rcu+0xe/0x10 kernel/softirq.c:434
>  sysvec_apic_timer_interrupt+0xc6/0xf0 arch/x86/kernel/apic/apic.c:1100
>  </IRQ>
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:650
> RIP: 0010:kmsan_get_shadow_origin_ptr+0x6/0xb0 mm/kmsan/kmsan_shadow.c:133
> Code: 0f 00 75 10 48 8b 45 b8 c6 80 3c 1a 00 00 01 e9 63 fe ff ff 48 c7 c7 7f 3a 7a 90 31 c0 e8 eb e5 25 ff cc cc 55 48 89 e5 41 57 <41> 56 53 41 89 d7 48 89 f3 49 89 fe 48 81 fe 01 10 00 00 73 6e 80
> RSP: 0018:ffff8881174eb498 EFLAGS: 00000246
> RAX: ffff88811777c628 RBX: 0000000000000000 RCX: 00000001170eb740
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88811777c618
> RBP: ffff8881174eb4a0 R08: ffffea000000000f R09: ffff88813fffa000
> R10: 0000000000000002 R11: ffff8881117eddc0 R12: ffff88811777c618
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881174eb740
>  __msan_metadata_ptr_for_load_8+0x10/0x20 mm/kmsan/kmsan_instr.c:55
>  tomoyo_path_matches_pattern+0x88/0x4d0 security/tomoyo/util.c:941
>  tomoyo_compare_name_union security/tomoyo/file.c:87 [inline]
>  tomoyo_check_path_acl+0x272/0x360 security/tomoyo/file.c:260
>  tomoyo_check_acl+0x249/0x5d0 security/tomoyo/domain.c:175
>  tomoyo_path_permission security/tomoyo/file.c:586 [inline]
>  tomoyo_check_open_permission+0x61f/0xdf0 security/tomoyo/file.c:777
>  tomoyo_file_open+0x24c/0x2d0 security/tomoyo/tomoyo.c:313
>  security_file_open+0xb1/0x1f0 security/security.c:1589
>  do_dentry_open+0x4d5/0x1b50 fs/open.c:813
>  vfs_open+0xaf/0xe0 fs/open.c:940
>  do_open fs/namei.c:3365 [inline]
>  path_openat+0x5731/0x6be0 fs/namei.c:3498
>  do_filp_open+0x2b8/0x710 fs/namei.c:3525
>  do_sys_openat2+0x25f/0x830 fs/open.c:1187
>  do_sys_open fs/open.c:1203 [inline]
>  __do_sys_open fs/open.c:1211 [inline]
>  __se_sys_open+0x271/0x2d0 fs/open.c:1207
>  __x64_sys_open+0x4a/0x70 fs/open.c:1207
>  do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fbf5e7ec9b1
> Code: f7 d8 bf ff ff ff ff 64 89 02 eb cb 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 80 3f 00 74 1b be 00 08 09 00 b8 02 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1f 89 c7 e9 00 ff ff ff 48 8b 05 b1 54 2e 00
> RSP: 002b:00007ffeaa699a98 EFLAGS: 00000202 ORIG_RAX: 0000000000000002
> RAX: ffffffffffffffda RBX: 0000563f833af280 RCX: 00007fbf5e7ec9b1
> RDX: 00000000000000fe RSI: 0000000000090800 RDI: 0000563f83376370
> RBP: 00007fbf5f9a2710 R08: 0000563f83392900 R09: 0000000000001010
> R10: 0000000000000030 R11: 0000000000000202 R12: 0000000000000000
> R13: 0000563f83376370 R14: 00000000000000fe R15: 0000563f83376370
>
> Uninit was created at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
>  kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
>  kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
>  slab_alloc_node mm/slub.c:2922 [inline]
>  __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
>  kmalloc_reserve net/core/skbuff.c:353 [inline]
>  __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
>  alloc_skb include/linux/skbuff.h:1103 [inline]
>  sctp_packet_pack net/sctp/output.c:442 [inline]
>  sctp_packet_transmit+0x17ac/0x44c0 net/sctp/output.c:588
>  sctp_outq_flush_transports net/sctp/outqueue.c:1154 [inline]
>  sctp_outq_flush+0x1e56/0x6510 net/sctp/outqueue.c:1202
>  sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
>  sctp_do_sm+0x9a18/0xa160 net/sctp/sm_sideeffect.c:1156
>  sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
>  sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
>  sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
>  sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
>  ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
>  __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
>  process_backlog+0x517/0xbd0 net/core/dev.c:6365
>  __napi_poll+0x13e/0xca0 net/core/dev.c:6912
>  napi_poll net/core/dev.c:6979 [inline]
>  net_rx_action+0x726/0x14a0 net/core/dev.c:7065
>  __do_softirq+0x1b9/0x715 kernel/softirq.c:345
> =====================================================
> =====================================================
> BUG: KMSAN: uninit-value in sctp_sf_abort_violation+0x484/0x16a0 net/sctp/sm_statefuns.c:4624
> CPU: 0 PID: 4692 Comm: systemd-udevd Tainted: G    B   W         5.12.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
>  kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
>  __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
>  sctp_sf_abort_violation+0x484/0x16a0 net/sctp/sm_statefuns.c:4624
>  sctp_sf_eat_data_6_2+0x36c/0x12e0 net/sctp/sm_statefuns.c:4717
>  sctp_do_sm+0x29a/0xa160 net/sctp/sm_sideeffect.c:1153
>  sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
>  sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
>  sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
>  sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
>  ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
>  __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
>  process_backlog+0x517/0xbd0 net/core/dev.c:6365
>  __napi_poll+0x13e/0xca0 net/core/dev.c:6912
>  napi_poll net/core/dev.c:6979 [inline]
>  net_rx_action+0x726/0x14a0 net/core/dev.c:7065
>  __do_softirq+0x1b9/0x715 kernel/softirq.c:345
>  invoke_softirq kernel/softirq.c:221 [inline]
>  __irq_exit_rcu+0x22f/0x280 kernel/softirq.c:422
>  irq_exit_rcu+0xe/0x10 kernel/softirq.c:434
>  sysvec_apic_timer_interrupt+0xc6/0xf0 arch/x86/kernel/apic/apic.c:1100
>  </IRQ>
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:650
> RIP: 0010:kmsan_get_shadow_origin_ptr+0x6/0xb0 mm/kmsan/kmsan_shadow.c:133
> Code: 0f 00 75 10 48 8b 45 b8 c6 80 3c 1a 00 00 01 e9 63 fe ff ff 48 c7 c7 7f 3a 7a 90 31 c0 e8 eb e5 25 ff cc cc 55 48 89 e5 41 57 <41> 56 53 41 89 d7 48 89 f3 49 89 fe 48 81 fe 01 10 00 00 73 6e 80
> RSP: 0018:ffff8881174eb498 EFLAGS: 00000246
> RAX: ffff88811777c628 RBX: 0000000000000000 RCX: 00000001170eb740
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88811777c618
> RBP: ffff8881174eb4a0 R08: ffffea000000000f R09: ffff88813fffa000
> R10: 0000000000000002 R11: ffff8881117eddc0 R12: ffff88811777c618
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881174eb740
>  __msan_metadata_ptr_for_load_8+0x10/0x20 mm/kmsan/kmsan_instr.c:55
>  tomoyo_path_matches_pattern+0x88/0x4d0 security/tomoyo/util.c:941
>  tomoyo_compare_name_union security/tomoyo/file.c:87 [inline]
>  tomoyo_check_path_acl+0x272/0x360 security/tomoyo/file.c:260
>  tomoyo_check_acl+0x249/0x5d0 security/tomoyo/domain.c:175
>  tomoyo_path_permission security/tomoyo/file.c:586 [inline]
>  tomoyo_check_open_permission+0x61f/0xdf0 security/tomoyo/file.c:777
>  tomoyo_file_open+0x24c/0x2d0 security/tomoyo/tomoyo.c:313
>  security_file_open+0xb1/0x1f0 security/security.c:1589
>  do_dentry_open+0x4d5/0x1b50 fs/open.c:813
>  vfs_open+0xaf/0xe0 fs/open.c:940
>  do_open fs/namei.c:3365 [inline]
>  path_openat+0x5731/0x6be0 fs/namei.c:3498
>  do_filp_open+0x2b8/0x710 fs/namei.c:3525
>  do_sys_openat2+0x25f/0x830 fs/open.c:1187
>  do_sys_open fs/open.c:1203 [inline]
>  __do_sys_open fs/open.c:1211 [inline]
>  __se_sys_open+0x271/0x2d0 fs/open.c:1207
>  __x64_sys_open+0x4a/0x70 fs/open.c:1207
>  do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fbf5e7ec9b1
> Code: f7 d8 bf ff ff ff ff 64 89 02 eb cb 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 80 3f 00 74 1b be 00 08 09 00 b8 02 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1f 89 c7 e9 00 ff ff ff 48 8b 05 b1 54 2e 00
> RSP: 002b:00007ffeaa699a98 EFLAGS: 00000202 ORIG_RAX: 0000000000000002
> RAX: ffffffffffffffda RBX: 0000563f833af280 RCX: 00007fbf5e7ec9b1
> RDX: 00000000000000fe RSI: 0000000000090800 RDI: 0000563f83376370
> RBP: 00007fbf5f9a2710 R08: 0000563f83392900 R09: 0000000000001010
> R10: 0000000000000030 R11: 0000000000000202 R12: 0000000000000000
> R13: 0000563f83376370 R14: 00000000000000fe R15: 0000563f83376370
>
> Uninit was created at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
>  kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
>  kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
>  slab_alloc_node mm/slub.c:2922 [inline]
>  __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
>  kmalloc_reserve net/core/skbuff.c:353 [inline]
>  __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
>  alloc_skb include/linux/skbuff.h:1103 [inline]
>  sctp_packet_pack net/sctp/output.c:442 [inline]
>  sctp_packet_transmit+0x17ac/0x44c0 net/sctp/output.c:588
>  sctp_outq_flush_transports net/sctp/outqueue.c:1154 [inline]
>  sctp_outq_flush+0x1e56/0x6510 net/sctp/outqueue.c:1202
>  sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
>  sctp_do_sm+0x9a18/0xa160 net/sctp/sm_sideeffect.c:1156
>  sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
>  sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
>  sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
>  sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
>  ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
>  __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
>  process_backlog+0x517/0xbd0 net/core/dev.c:6365
>  __napi_poll+0x13e/0xca0 net/core/dev.c:6912
>  napi_poll net/core/dev.c:6979 [inline]
>  net_rx_action+0x726/0x14a0 net/core/dev.c:7065
>  __do_softirq+0x1b9/0x715 kernel/softirq.c:345
> =====================================================
> =====================================================
> BUG: KMSAN: uninit-value in sctp_ulpevent_make_assoc_change+0x96a/0xff0 net/sctp/ulpevent.c:126
> CPU: 0 PID: 4692 Comm: systemd-udevd Tainted: G    B   W         5.12.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
>  kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
>  __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
>  sctp_ulpevent_make_assoc_change+0x96a/0xff0 net/sctp/ulpevent.c:126
>  sctp_cmd_assoc_failed net/sctp/sm_sideeffect.c:625 [inline]
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1608 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
>  sctp_do_sm+0x374f/0xa160 net/sctp/sm_sideeffect.c:1156
>  sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
>  sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
>  sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
>  sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
>  ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
>  __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
>  process_backlog+0x517/0xbd0 net/core/dev.c:6365
>  __napi_poll+0x13e/0xca0 net/core/dev.c:6912
>  napi_poll net/core/dev.c:6979 [inline]
>  net_rx_action+0x726/0x14a0 net/core/dev.c:7065
>  __do_softirq+0x1b9/0x715 kernel/softirq.c:345
>  invoke_softirq kernel/softirq.c:221 [inline]
>  __irq_exit_rcu+0x22f/0x280 kernel/softirq.c:422
>  irq_exit_rcu+0xe/0x10 kernel/softirq.c:434
>  sysvec_apic_timer_interrupt+0xc6/0xf0 arch/x86/kernel/apic/apic.c:1100
>  </IRQ>
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:650
> RIP: 0010:kmsan_get_shadow_origin_ptr+0x6/0xb0 mm/kmsan/kmsan_shadow.c:133
> Code: 0f 00 75 10 48 8b 45 b8 c6 80 3c 1a 00 00 01 e9 63 fe ff ff 48 c7 c7 7f 3a 7a 90 31 c0 e8 eb e5 25 ff cc cc 55 48 89 e5 41 57 <41> 56 53 41 89 d7 48 89 f3 49 89 fe 48 81 fe 01 10 00 00 73 6e 80
> RSP: 0018:ffff8881174eb498 EFLAGS: 00000246
> RAX: ffff88811777c628 RBX: 0000000000000000 RCX: 00000001170eb740
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88811777c618
> RBP: ffff8881174eb4a0 R08: ffffea000000000f R09: ffff88813fffa000
> R10: 0000000000000002 R11: ffff8881117eddc0 R12: ffff88811777c618
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881174eb740
>  __msan_metadata_ptr_for_load_8+0x10/0x20 mm/kmsan/kmsan_instr.c:55
>  tomoyo_path_matches_pattern+0x88/0x4d0 security/tomoyo/util.c:941
>  tomoyo_compare_name_union security/tomoyo/file.c:87 [inline]
>  tomoyo_check_path_acl+0x272/0x360 security/tomoyo/file.c:260
>  tomoyo_check_acl+0x249/0x5d0 security/tomoyo/domain.c:175
>  tomoyo_path_permission security/tomoyo/file.c:586 [inline]
>  tomoyo_check_open_permission+0x61f/0xdf0 security/tomoyo/file.c:777
>  tomoyo_file_open+0x24c/0x2d0 security/tomoyo/tomoyo.c:313
>  security_file_open+0xb1/0x1f0 security/security.c:1589
>  do_dentry_open+0x4d5/0x1b50 fs/open.c:813
>  vfs_open+0xaf/0xe0 fs/open.c:940
>  do_open fs/namei.c:3365 [inline]
>  path_openat+0x5731/0x6be0 fs/namei.c:3498
>  do_filp_open+0x2b8/0x710 fs/namei.c:3525
>  do_sys_openat2+0x25f/0x830 fs/open.c:1187
>  do_sys_open fs/open.c:1203 [inline]
>  __do_sys_open fs/open.c:1211 [inline]
>  __se_sys_open+0x271/0x2d0 fs/open.c:1207
>  __x64_sys_open+0x4a/0x70 fs/open.c:1207
>  do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fbf5e7ec9b1
> Code: f7 d8 bf ff ff ff ff 64 89 02 eb cb 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 80 3f 00 74 1b be 00 08 09 00 b8 02 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1f 89 c7 e9 00 ff ff ff 48 8b 05 b1 54 2e 00
> RSP: 002b:00007ffeaa699a98 EFLAGS: 00000202 ORIG_RAX: 0000000000000002
> RAX: ffffffffffffffda RBX: 0000563f833af280 RCX: 00007fbf5e7ec9b1
> RDX: 00000000000000fe RSI: 0000000000090800 RDI: 0000563f83376370
> RBP: 00007fbf5f9a2710 R08: 0000563f83392900 R09: 0000000000001010
> R10: 0000000000000030 R11: 0000000000000202 R12: 0000000000000000
> R13: 0000563f83376370 R14: 00000000000000fe R15: 0000563f83376370
>
> Uninit was created at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
>  kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
>  kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
>  slab_alloc_node mm/slub.c:2922 [inline]
>  __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
>  kmalloc_reserve net/core/skbuff.c:353 [inline]
>  __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
>  alloc_skb include/linux/skbuff.h:1103 [inline]
>  sctp_packet_pack net/sctp/output.c:442 [inline]
>  sctp_packet_transmit+0x17ac/0x44c0 net/sctp/output.c:588
>  sctp_outq_flush_transports net/sctp/outqueue.c:1154 [inline]
>  sctp_outq_flush+0x1e56/0x6510 net/sctp/outqueue.c:1202
>  sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
>  sctp_do_sm+0x9a18/0xa160 net/sctp/sm_sideeffect.c:1156
>  sctp_assoc_bh_rcv+0xa3f/0xe10 net/sctp/associola.c:1048
>  sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
>  sctp_rcv+0x562f/0x60d0 net/sctp/input.c:256
>  sctp6_rcv+0x64/0xd0 net/sctp/ipv6.c:1078
>  ip6_protocol_deliver_rcu+0x1402/0x25f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish net/ipv6/ip6_input.c:463 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_input+0x12b/0x390 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish+0x5fc/0x7f0 net/ipv6/ip6_input.c:76
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ipv6_rcv+0x1d1/0x460 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core net/core/dev.c:5384 [inline]
>  __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5498
>  process_backlog+0x517/0xbd0 net/core/dev.c:6365
>  __napi_poll+0x13e/0xca0 net/core/dev.c:6912
>  napi_poll net/core/dev.c:6979 [inline]
>  net_rx_action+0x726/0x14a0 net/core/dev.c:7065
>  __do_softirq+0x1b9/0x715 kernel/softirq.c:345
> =====================================================
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
