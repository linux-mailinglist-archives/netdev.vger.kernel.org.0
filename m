Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0EC5E7010
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 01:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiIVXHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 19:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiIVXHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 19:07:40 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4B610E5C7
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 16:07:39 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id f11-20020a5d858b000000b006a17b75af65so5658776ioj.13
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 16:07:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=i3llcBJ6K4cihMKh8naEQ7Ev7uVu+YaW9EbAKCxKzwY=;
        b=VMtZ9ibAHOPi++pp1JFfI2y7vQwZV06bHGiBGnQ/s1jrreNw+Da7zTmyvOMU6/HvOJ
         k59wF9WErqFrhFGSp3pKszte5ryLHyjrJObJeiNEgQ02sGvepfY16j0G+BBpVEn8EFax
         quiqiRPgMkPCcDTm4TDhOggLOcojOmX0WsVi0q+36eFcMvMnYHl/8W7I8HMq1iR+YyNz
         zPZ4rcp76LBtidFTM74vEY7efXy7d8cCWQ1Bt7zmrblYd/6qOv8ftoF0vOD+VsCU3geD
         lJ8vrzjqJGHqStBIlPbredQyWXssEyrZCPWG9rhvPklWdBl+ki2lWYl82cRCa1DmuFnp
         +Q5g==
X-Gm-Message-State: ACrzQf0n3a77sGoqCE2iy++QXmrcM3g4Tko2llqV+SUT2T2+LOdyPjwN
        42rmMtuyUPLu9v+2nY2t+sPKOEIOgaM7hVkGjODj+arj/uM/
X-Google-Smtp-Source: AMsMyM6esA4lG0MKhkpyb0l0JdZ72aaIF776hi27heOS8NpFlPJjY/gZckACg80nEUIibec4VvmjKWc8iuvLHzj4qfj41Om++kEb
MIME-Version: 1.0
X-Received: by 2002:a05:6638:300e:b0:35a:ab7a:4509 with SMTP id
 r14-20020a056638300e00b0035aab7a4509mr3341925jak.82.1663888058688; Thu, 22
 Sep 2022 16:07:38 -0700 (PDT)
Date:   Thu, 22 Sep 2022 16:07:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000af2e0605e94c2009@google.com>
Subject: [syzbot] BUG: stored value of X_recv is zero at net/dccp/ccids/ccid3.c:LINE/ccid3_first_li()
 (3)
From:   syzbot <syzbot+2ad8ef335371014d4dc7@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dccp@vger.kernel.org, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5aa266bb455b Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=13d881cf080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=769607722d601d0a
dashboard link: https://syzkaller.appspot.com/bug?extid=2ad8ef335371014d4dc7
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1743f1cf080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11b28dd5080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2ad8ef335371014d4dc7@syzkaller.appspotmail.com

BUG: stored value of X_recv is zero at net/dccp/ccids/ccid3.c:691/ccid3_first_li()
CPU: 0 PID: 3117 Comm: syz-executor214 Not tainted 6.0.0-rc6-syzkaller-17715-g5aa266bb455b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
Call trace:
 dump_backtrace+0x1c4/0x1f0 arch/arm64/kernel/stacktrace.c:156
 show_stack+0x2c/0x54 arch/arm64/kernel/stacktrace.c:163
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x104/0x16c lib/dump_stack.c:106
 dump_stack+0x1c/0x58 lib/dump_stack.c:113
 ccid3_first_li+0x274/0x280 net/dccp/ccids/ccid3.c:691
 tfrc_lh_interval_add+0x280/0x444 net/dccp/ccids/lib/loss_interval.c:157
 tfrc_rx_handle_loss+0x23c/0x920 net/dccp/ccids/lib/packet_history.c:328
 ccid3_hc_rx_packet_recv+0x17c/0x4b8 net/dccp/ccids/ccid3.c:744
 ccid_hc_rx_packet_recv net/dccp/ccid.h:182 [inline]
 dccp_deliver_input_to_ccids net/dccp/input.c:176 [inline]
 dccp_rcv_established+0x120/0x1a4 net/dccp/input.c:374
 dccp_v4_do_rcv+0x58/0xd0 net/dccp/ipv4.c:666
 sk_backlog_rcv include/net/sock.h:1100 [inline]
 __sk_receive_skb+0x2a4/0x494 net/core/sock.c:565
 dccp_v4_rcv+0x964/0xc5c net/dccp/ipv4.c:889
 ip_protocol_deliver_rcu+0x224/0x414 net/ipv4/ip_input.c:205
 ip_local_deliver_finish+0x124/0x1d8 net/ipv4/ip_input.c:233
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ip_local_deliver+0xd0/0xf4 net/ipv4/ip_input.c:254
 dst_input include/net/dst.h:461 [inline]
 ip_rcv_finish+0x16c/0x190 net/ipv4/ip_input.c:444
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ip_rcv+0x80/0xb0 net/ipv4/ip_input.c:564
 __netif_receive_skb_one_core net/core/dev.c:5485 [inline]
 __netif_receive_skb+0x70/0x14c net/core/dev.c:5599
 process_backlog+0x23c/0x384 net/core/dev.c:5927
 __napi_poll+0x5c/0x24c net/core/dev.c:6511
 napi_poll+0x110/0x484 net/core/dev.c:6578
 net_rx_action+0x18c/0x40c net/core/dev.c:6689
 _stext+0x168/0x37c
 ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:79
 call_on_irq_stack+0x2c/0x54
 do_softirq_own_stack+0x20/0x2c arch/arm64/kernel/irq.c:84
 invoke_softirq+0x70/0xbc kernel/softirq.c:452
 __irq_exit_rcu+0xf0/0x140 kernel/softirq.c:650
 irq_exit_rcu+0x10/0x40 kernel/softirq.c:662
 __el1_irq arch/arm64/kernel/entry-common.c:471 [inline]
 el1_interrupt+0x38/0x68 arch/arm64/kernel/entry-common.c:485
 el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:490
 el1h_64_irq+0x64/0x68
 arch_local_irq_restore arch/arm64/include/asm/irqflags.h:122 [inline]
 seqcount_lockdep_reader_access include/linux/seqlock.h:104 [inline]
 ktime_get_with_offset+0x14c/0x218 kernel/time/timekeeping.c:889
 ktime_get_real include/linux/timekeeping.h:79 [inline]
 ccid3_hc_tx_send_packet+0x38/0x3b8 net/dccp/ccids/ccid3.c:276
 ccid_hc_tx_send_packet net/dccp/ccid.h:167 [inline]
 dccp_write_xmit+0x50/0x148 net/dccp/output.c:356
 dccp_sendmsg+0x2d0/0x300 net/dccp/proto.c:783
 inet_sendmsg+0xb0/0x118 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0x308/0x450 net/socket.c:2482
 ___sys_sendmsg net/socket.c:2536 [inline]
 __sys_sendmmsg+0x228/0x594 net/socket.c:2622
 __do_sys_sendmmsg net/socket.c:2651 [inline]
 __se_sys_sendmmsg net/socket.c:2648 [inline]
 __arm64_sys_sendmmsg+0x30/0x44 net/socket.c:2648
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:636
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:654
 el0t_64_sync+0x18c/0x190
Negotiation of local Allow Short Seqnos failed in state CHANGING at net/dccp/feat.c:1537/dccp_feat_activate_values()
Negotiation of local Allow Short Seqnos failed in state CHANGING at net/dccp/feat.c:1537/dccp_feat_activate_values()


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
