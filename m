Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A9E2254F2
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 02:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgGTAZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 20:25:21 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:45997 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbgGTAZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 20:25:21 -0400
Received: by mail-il1-f198.google.com with SMTP id c1so9866313ilk.12
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 17:25:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=M6bxXO3+4E6BmggilTQQvfwUuaZfGJ3KU4BesjSYsAE=;
        b=k+BgCbA3L4RCgvgkSa+mCzCEVsjoWRV8u+pKgO+rQkh/gere5/l19NwnneScicVwdj
         i6chwuRL/4NzhoHyIJ7jp55c5G1qRYQw7As2ofHOXDoMbDs/2JFqxiCrwwXMt3hTnAlk
         9Uz+RiQy6NP61z6WtcGgv/sSWAztf6J/AieuXqXk4Cr8aYs1oEXF0yO0uXJunqgIxaEp
         2kcBugDZ6AnfqGI/Iz69CT8v+EEoIC8EZJ413+HMuAmieB1YzF5Zzg56fntnqVWgOjT3
         2z54ZNOQmRFMSrg358yqEwQdsLSeJygNAHTKudBUHHg7f4G9jmX5pnojwGpSYQZ8oERP
         l0sw==
X-Gm-Message-State: AOAM532T4IrKivz1Y1mXsPuT75UFo4/e1EhzeTfndEcWWEc+up+MqNrX
        pYh3ni3tb/Pvg5fcTYayseBMF6dwRmAXKViI15dduUlRWytm
X-Google-Smtp-Source: ABdhPJwfX+SSTJLDpAt/PmIPzGikUKwsrrLb2iZ6rsZqy0l/UvE4SFC9yg518qb6VwFEpC19Cyi0/hxVM3U13QK3WJ1uRC3v8+g2
MIME-Version: 1.0
X-Received: by 2002:a05:6602:449:: with SMTP id e9mr20273877iov.71.1595204719851;
 Sun, 19 Jul 2020 17:25:19 -0700 (PDT)
Date:   Sun, 19 Jul 2020 17:25:19 -0700
In-Reply-To: <0000000000000924780598075f4b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000abc0e505aad48a7d@google.com>
Subject: Re: KMSAN: uninit-value in __skb_checksum_complete (4)
From:   syzbot <syzbot+721b564cd88ebb710182@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        glider@google.com, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    14525656 compiler.h: reinstate missing KMSAN_INIT
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=16a7c827100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c534a9fad6323722
dashboard link: https://syzkaller.appspot.com/bug?extid=721b564cd88ebb710182
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=115be9d7100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b9425f100000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+721b564cd88ebb710182@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in __skb_checksum_complete+0x37f/0x540 net/core/skbuff.c:2850
CPU: 1 PID: 8457 Comm: syz-executor769 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1df/0x240 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 __skb_checksum_complete+0x37f/0x540 net/core/skbuff.c:2850
 nf_ip_checksum+0x53b/0x740 net/netfilter/utils.c:36
 nf_nat_icmp_reply_translation+0x2ba/0x980 net/netfilter/nf_nat_proto.c:578
 nf_nat_ipv4_fn net/netfilter/nf_nat_proto.c:637 [inline]
 nf_nat_ipv4_local_fn+0x215/0x830 net/netfilter/nf_nat_proto.c:708
 nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
 nf_hook_slow+0x16e/0x400 net/netfilter/core.c:512
 nf_hook include/linux/netfilter.h:262 [inline]
 __ip_local_out+0x69b/0x800 net/ipv4/ip_output.c:114
 ip_local_out net/ipv4/ip_output.c:123 [inline]
 ip_send_skb net/ipv4/ip_output.c:1560 [inline]
 ip_push_pending_frames+0x16f/0x460 net/ipv4/ip_output.c:1580
 icmp_push_reply+0x660/0x710 net/ipv4/icmp.c:390
 __icmp_send+0x23ca/0x3150 net/ipv4/icmp.c:740
 icmp_send include/net/icmp.h:43 [inline]
 ip_fragment+0x39f/0x400 net/ipv4/ip_output.c:579
 __ip_finish_output+0xd34/0xd80 net/ipv4/ip_output.c:304
 ip_finish_output+0x166/0x410 net/ipv4/ip_output.c:316
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0x593/0x680 net/ipv4/ip_output.c:430
 dst_output include/net/dst.h:443 [inline]
 ip_local_out net/ipv4/ip_output.c:125 [inline]
 __ip_queue_xmit+0x1b5c/0x21a0 net/ipv4/ip_output.c:530
 ip_queue_xmit include/net/ip.h:237 [inline]
 l2tp_ip_sendmsg+0x1477/0x1870 net/l2tp/l2tp_ip.c:508
 inet_sendmsg+0x2d8/0x2e0 net/ipv4/af_inet.c:814
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 kernel_sendmsg+0x384/0x440 net/socket.c:692
 sock_no_sendpage+0x235/0x300 net/core/sock.c:2853
 kernel_sendpage net/socket.c:3642 [inline]
 sock_sendpage+0x1e1/0x2c0 net/socket.c:945
 pipe_to_sendpage+0x38c/0x4c0 fs/splice.c:448
 splice_from_pipe_feed fs/splice.c:502 [inline]
 __splice_from_pipe+0x565/0xf00 fs/splice.c:626
 splice_from_pipe fs/splice.c:661 [inline]
 generic_splice_sendpage+0x1d5/0x2d0 fs/splice.c:834
 do_splice_from fs/splice.c:846 [inline]
 direct_splice_actor+0x1fd/0x580 fs/splice.c:1016
 splice_direct_to_actor+0x6b2/0xf50 fs/splice.c:971
 do_splice_direct+0x342/0x580 fs/splice.c:1059
 do_sendfile+0x101b/0x1d40 fs/read_write.c:1540
 __do_sys_sendfile64 fs/read_write.c:1601 [inline]
 __se_sys_sendfile64+0x2bb/0x360 fs/read_write.c:1587
 __x64_sys_sendfile64+0x56/0x70 fs/read_write.c:1587
 do_syscall_64+0xb0/0x150 arch/x86/entry/common.c:386
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440409
Code: Bad RIP value.
RSP: 002b:00007ffe9c5d76d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440409
RDX: 0000000000000000 RSI: 0000000000000005 RDI: 0000000000000003
RBP: 00000000006cb018 R08: 0000000000000014 R09: 65732f636f72702f
R10: 0800000080004103 R11: 0000000000000246 R12: 0000000000401c70
R13: 0000000000401d00 R14: 0000000000000000 R15: 0000000000000000

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
 csum_partial_copy+0xae/0x100 lib/checksum.c:154
 skb_copy_and_csum_bits+0x227/0x1130 net/core/skbuff.c:2737
 icmp_glue_bits+0x166/0x380 net/ipv4/icmp.c:353
 __ip_append_data+0x47c4/0x5630 net/ipv4/ip_output.c:1131
 ip_append_data+0x328/0x480 net/ipv4/ip_output.c:1315
 icmp_push_reply+0x206/0x710 net/ipv4/icmp.c:371
 __icmp_send+0x23ca/0x3150 net/ipv4/icmp.c:740
 icmp_send include/net/icmp.h:43 [inline]
 ip_fragment+0x39f/0x400 net/ipv4/ip_output.c:579
 __ip_finish_output+0xd34/0xd80 net/ipv4/ip_output.c:304
 ip_finish_output+0x166/0x410 net/ipv4/ip_output.c:316
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0x593/0x680 net/ipv4/ip_output.c:430
 dst_output include/net/dst.h:443 [inline]
 ip_local_out net/ipv4/ip_output.c:125 [inline]
 __ip_queue_xmit+0x1b5c/0x21a0 net/ipv4/ip_output.c:530
 ip_queue_xmit include/net/ip.h:237 [inline]
 l2tp_ip_sendmsg+0x1477/0x1870 net/l2tp/l2tp_ip.c:508
 inet_sendmsg+0x2d8/0x2e0 net/ipv4/af_inet.c:814
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 kernel_sendmsg+0x384/0x440 net/socket.c:692
 sock_no_sendpage+0x235/0x300 net/core/sock.c:2853
 kernel_sendpage net/socket.c:3642 [inline]
 sock_sendpage+0x1e1/0x2c0 net/socket.c:945
 pipe_to_sendpage+0x38c/0x4c0 fs/splice.c:448
 splice_from_pipe_feed fs/splice.c:502 [inline]
 __splice_from_pipe+0x565/0xf00 fs/splice.c:626
 splice_from_pipe fs/splice.c:661 [inline]
 generic_splice_sendpage+0x1d5/0x2d0 fs/splice.c:834
 do_splice_from fs/splice.c:846 [inline]
 direct_splice_actor+0x1fd/0x580 fs/splice.c:1016
 splice_direct_to_actor+0x6b2/0xf50 fs/splice.c:971
 do_splice_direct+0x342/0x580 fs/splice.c:1059
 do_sendfile+0x101b/0x1d40 fs/read_write.c:1540
 __do_sys_sendfile64 fs/read_write.c:1601 [inline]
 __se_sys_sendfile64+0x2bb/0x360 fs/read_write.c:1587
 __x64_sys_sendfile64+0x56/0x70 fs/read_write.c:1587
 do_syscall_64+0xb0/0x150 arch/x86/entry/common.c:386
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
 _copy_from_iter_full+0xbfe/0x13b0 lib/iov_iter.c:793
 copy_from_iter_full include/linux/uio.h:156 [inline]
 memcpy_from_msg include/linux/skbuff.h:3566 [inline]
 l2tp_ip_sendmsg+0x6a5/0x1870 net/l2tp/l2tp_ip.c:462
 inet_sendmsg+0x2d8/0x2e0 net/ipv4/af_inet.c:814
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 kernel_sendmsg+0x384/0x440 net/socket.c:692
 sock_no_sendpage+0x235/0x300 net/core/sock.c:2853
 kernel_sendpage net/socket.c:3642 [inline]
 sock_sendpage+0x1e1/0x2c0 net/socket.c:945
 pipe_to_sendpage+0x38c/0x4c0 fs/splice.c:448
 splice_from_pipe_feed fs/splice.c:502 [inline]
 __splice_from_pipe+0x565/0xf00 fs/splice.c:626
 splice_from_pipe fs/splice.c:661 [inline]
 generic_splice_sendpage+0x1d5/0x2d0 fs/splice.c:834
 do_splice_from fs/splice.c:846 [inline]
 direct_splice_actor+0x1fd/0x580 fs/splice.c:1016
 splice_direct_to_actor+0x6b2/0xf50 fs/splice.c:971
 do_splice_direct+0x342/0x580 fs/splice.c:1059
 do_sendfile+0x101b/0x1d40 fs/read_write.c:1540
 __do_sys_sendfile64 fs/read_write.c:1601 [inline]
 __se_sys_sendfile64+0x2bb/0x360 fs/read_write.c:1587
 __x64_sys_sendfile64+0x56/0x70 fs/read_write.c:1587
 do_syscall_64+0xb0/0x150 arch/x86/entry/common.c:386
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Uninit was created at:
 kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:144
 kmsan_internal_alloc_meta_for_pages mm/kmsan/kmsan_shadow.c:269 [inline]
 kmsan_alloc_page+0xb9/0x180 mm/kmsan/kmsan_shadow.c:293
 __alloc_pages_nodemask+0x56a2/0x5dc0 mm/page_alloc.c:4889
 alloc_pages_current+0x672/0x990 mm/mempolicy.c:2292
 alloc_pages include/linux/gfp.h:545 [inline]
 push_pipe+0x605/0xb70 lib/iov_iter.c:537
 __pipe_get_pages lib/iov_iter.c:1278 [inline]
 pipe_get_pages_alloc lib/iov_iter.c:1385 [inline]
 iov_iter_get_pages_alloc+0x18a9/0x21c0 lib/iov_iter.c:1403
 default_file_splice_read fs/splice.c:385 [inline]
 do_splice_to+0x4fc/0x14f0 fs/splice.c:871
 splice_direct_to_actor+0x45c/0xf50 fs/splice.c:950
 do_splice_direct+0x342/0x580 fs/splice.c:1059
 do_sendfile+0x101b/0x1d40 fs/read_write.c:1540
 __do_sys_sendfile64 fs/read_write.c:1601 [inline]
 __se_sys_sendfile64+0x2bb/0x360 fs/read_write.c:1587
 __x64_sys_sendfile64+0x56/0x70 fs/read_write.c:1587
 do_syscall_64+0xb0/0x150 arch/x86/entry/common.c:386
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================

