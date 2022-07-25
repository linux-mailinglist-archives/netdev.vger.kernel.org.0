Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D3E580500
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236764AbiGYUGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236247AbiGYUGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:06:22 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68427CE3B
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:06:21 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id d12-20020a056e02214c00b002dd143bee38so7895562ilv.7
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:06:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=jALjLym/x8uogNDMDeD9EXR+XfiHKoWS+XNpUQ2FdbU=;
        b=dT4IGu7V1aFPiAipxf7OQ3V3vqyvsbVGzFqime8ay/ynYA9drgjS5q9Mku8/4hmaUN
         E6WaXMhR4PzAJSmRAwnAp84qTns9YCx03Cq59k1+XAYDU7VkVdoTs/GF7GkER91gOXrn
         Ml/N/JqRK83oGpVvV0qK6ow8gPQozeRNbRtviW2mqaiMAr+nLiRFDhL7YXdv+2N/3fGh
         Pjt3PZYp3LYJgd8uw5xzNHplnO4S4uh+lFEFfUqpAKi/07VyzGw6LN/52qarphJWioBT
         7HVFLlumCfLkO0rS9fiTMiguR0GOf3R+UwOPrjsq3FtAEEZPBVI+84SCL9A/a8Ezma6/
         HTMA==
X-Gm-Message-State: AJIora88/Dx3XkGVHYenJN3dnzBUDV7qW7ZPwEDV2nLOeaT4JbZ1z3oT
        4sylc7Wx5bY1/sK2ONuXnP/dKTfi1Ja4nTHln7zK17rnGLmU
X-Google-Smtp-Source: AGRyM1uryIB9VDMQcroA8VUz1B/u6VlGSrLflRKjzYDpZ/w9+QWutuaN9aEg65GjW2FxG79UYr5OF/B+xp8M0MID4nSsIT9V2et9
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b44:b0:2dd:89bf:6b99 with SMTP id
 f4-20020a056e020b4400b002dd89bf6b99mr334353ilu.114.1658779580772; Mon, 25 Jul
 2022 13:06:20 -0700 (PDT)
Date:   Mon, 25 Jul 2022 13:06:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ac3b8305e4a6b766@google.com>
Subject: [syzbot] WARNING in __dev_queue_xmit
From:   syzbot <syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        liuhangbin@gmail.com, netdev@vger.kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, sdf@google.com, shaozhengchao@huawei.com,
        syzkaller-bugs@googlegroups.com, willemb@google.com,
        yajun.deng@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b77ffb30cfc5 libbpf: fix an snprintf() overflow check
git tree:       bpf-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=11ef3226080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=386b986585586629
dashboard link: https://syzkaller.appspot.com/bug?extid=5ea725c25d06fb9114c4
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11004e64080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1009bfd0080000

The issue was bisected to:

commit fd1894224407c484f652ad456e1ce423e89bb3eb
Author: Zhengchao Shao <shaozhengchao@huawei.com>
Date:   Fri Jul 15 11:55:59 2022 +0000

    bpf: Don't redirect packets with invalid pkt_len

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1749bfd0080000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14c9bfd0080000
console output: https://syzkaller.appspot.com/x/log.txt?x=10c9bfd0080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com
Fixes: fd1894224407 ("bpf: Don't redirect packets with invalid pkt_len")

------------[ cut here ]------------
skb_assert_len
WARNING: CPU: 0 PID: 3608 at include/linux/skbuff.h:2465 skb_assert_len include/linux/skbuff.h:2465 [inline]
WARNING: CPU: 0 PID: 3608 at include/linux/skbuff.h:2465 __dev_queue_xmit+0x313c/0x3ad0 net/core/dev.c:4171
Modules linked in:
CPU: 0 PID: 3608 Comm: syz-executor357 Not tainted 5.19.0-rc5-syzkaller-01146-gb77ffb30cfc5 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
RIP: 0010:skb_assert_len include/linux/skbuff.h:2465 [inline]
RIP: 0010:__dev_queue_xmit+0x313c/0x3ad0 net/core/dev.c:4171
Code: 10 e8 18 6c 73 fa e9 b4 f2 ff ff e8 4e 18 26 fa 48 c7 c6 a0 81 d3 8a 48 c7 c7 a0 55 d3 8a c6 05 89 33 52 06 01 e8 45 75 de 01 <0f> 0b e9 4f f2 ff ff e8 28 18 26 fa e8 a3 17 10 fa 31 ff 89 c3 89
RSP: 0018:ffffc900031af748 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801b9bbb00 RSI: ffffffff8160d618 RDI: fffff52000635edb
RBP: ffff888020059aba R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000001 R12: ffff888020059a00
R13: 0000000000000000 R14: ffff888020059a10 R15: ffff888020059a00
FS:  0000555556f80300(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000561be8192048 CR3: 0000000020721000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 packet_snd net/packet/af_packet.c:3073 [inline]
 packet_sendmsg+0x21f4/0x55d0 net/packet/af_packet.c:3104
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x6eb/0x810 net/socket.c:2485
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2539
 __sys_sendmsg net/socket.c:2568 [inline]
 __do_sys_sendmsg net/socket.c:2577 [inline]
 __se_sys_sendmsg net/socket.c:2575 [inline]
 __x64_sys_sendmsg+0x132/0x220 net/socket.c:2575
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f4882617369
Code: 28 c3 e8 4a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff94d23dd8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f4882617369
RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff94d23df0
R13: 00007fff94d23e10 R14: 0000000000000000 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
