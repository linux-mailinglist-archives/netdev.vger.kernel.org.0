Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24DFD5256F2
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 23:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358669AbiELVSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 17:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353619AbiELVS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 17:18:29 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335277A45B
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 14:18:29 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id c25-20020a5d9399000000b00652e2b23358so3775498iol.6
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 14:18:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OD+DJjg0IVnWKUjf9SiJctf3WNuUFGLwQrxYAzpgXbY=;
        b=ijjE3nCQlnhYmsthuEko5/NLNvik+22u3riwQ3Q1LBRa+eBhFMU6fyhY/zrjy3wFC3
         ZLLlSuezEtpmvRZSO+PFzkA/N7EPjJok9+VdWPetk17P+bB5/nmMmjWimMJ0+SPd6Lr+
         h/tT9Y2eF5ykPLm1bZo+zgWYpcETISdAPQwo0ayrOWLuPmJm1nMOdVEJKXGDtOxBi7ab
         oulSorWBykPNU409eFnS/nD7ZDU9Q1YA9Y1QmwSNL64rCAhGcAGUk+vZnyOAyirWDCgi
         mV9lqHmv+q7Z3U1+DFfwY4cxFbTCA8xka5ig7EE56hHWu214aB866pHIoIF5LysxzYqy
         IXIg==
X-Gm-Message-State: AOAM5330vXhWu6yZatRXlnlQMFcpcfQDyozqd7y27a5eWMoSuW5nrGAE
        iW3bFj1hAXrSEFavZnecjX1n28aUdjw6CsU60luH1dTVd/0l
X-Google-Smtp-Source: ABdhPJwC5eM42fGDTmMX5/gu/JoS0zMGHmicuAdhYE4t7bPkyifrzJ9L1lPr6G41pEJ+uFmJHyhw810wOPpQo+RcWbagA4M0NSVd
MIME-Version: 1.0
X-Received: by 2002:a05:6602:27c6:b0:657:7e7a:11f3 with SMTP id
 l6-20020a05660227c600b006577e7a11f3mr937389ios.40.1652390308547; Thu, 12 May
 2022 14:18:28 -0700 (PDT)
Date:   Thu, 12 May 2022 14:18:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005f1a8805ded719cc@google.com>
Subject: [syzbot] UBSAN: shift-out-of-bounds in tcf_pedit_init
From:   syzbot <syzbot+8ed8fc4c57e9dcf23ca6@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    810c2f0a3f86 mlxsw: Avoid warning during ip6gre device rem..
git tree:       net
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1448a599f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=331feb185f8828e0
dashboard link: https://syzkaller.appspot.com/bug?extid=8ed8fc4c57e9dcf23ca6
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=104e9749f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15f913b9f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8ed8fc4c57e9dcf23ca6@syzkaller.appspotmail.com

netlink: 28 bytes leftover after parsing attributes in process `syz-executor151'.
netlink: 28 bytes leftover after parsing attributes in process `syz-executor151'.
================================================================================
UBSAN: shift-out-of-bounds in net/sched/act_pedit.c:238:43
shift exponent 1400735974 is too large for 32-bit type 'unsigned int'
CPU: 0 PID: 3606 Comm: syz-executor151 Not tainted 5.18.0-rc5-syzkaller-00165-g810c2f0a3f86 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 ubsan_epilogue+0xb/0x50 lib/ubsan.c:151
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x187 lib/ubsan.c:322
 tcf_pedit_init.cold+0x1a/0x1f net/sched/act_pedit.c:238
 tcf_action_init_1+0x414/0x690 net/sched/act_api.c:1367
 tcf_action_init+0x530/0x8d0 net/sched/act_api.c:1432
 tcf_action_add+0xf9/0x480 net/sched/act_api.c:1956
 tc_ctl_action+0x346/0x470 net/sched/act_api.c:2015
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5993
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:725
 ____sys_sendmsg+0x6e2/0x800 net/socket.c:2413
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2496
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fe36e9e1b59
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffef796fe88 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fe36e9e1b59
RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000000000003
RBP: 00007fe36e9a5d00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fe36e9a5d90
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
