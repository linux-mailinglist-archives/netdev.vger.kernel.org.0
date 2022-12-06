Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBCF64495D
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235571AbiLFQfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235125AbiLFQfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:35:24 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1D06170
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:34:37 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id o15-20020a6bf80f000000b006de313e5cfeso11914422ioh.6
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 08:34:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GaYaKvm7527pWnE+UJ237BHtMl+FJafTPBwru3zauxQ=;
        b=djiC+AMOuFaV/WJ4x/YFFoHhK6PT6leeLwypkW5EK08IG49Pp198rxv64T88Nz69F8
         O9Tzlq/lRO5NseKvOqzSW4gzi8LYW902SjF4Q58Wr/xI6y10Ap35kh9NWDTxIcv0zn1w
         ojRMR4+723kgi0oDpfurctHn/CXQ7EoZFh71cA7ig/8+zpA2tteZGyMATlyGI4XRmU2T
         qlRXUcI4gF22I8QCbW3zl6l4LzI576ttWS9E5phalUv7A/CH0tV9BUQFhPwb3uLa+0Wq
         otQFnd4dPD83XmVQfMLmVCpBs4BuOkULaMLFd2WoUoNYGsTnp0vhCYugMabcYgAIGAyX
         Xlvw==
X-Gm-Message-State: ANoB5pkGtSNp7f2QuRioEMZKLA/Il78KjjCqn260wjElzyiEkLJPm2XA
        7t0zuEoEjJPbW8pZ+sJkIpMZMmLaKkYQ8gJ1+fLBkMT7SIl+
X-Google-Smtp-Source: AA0mqf4UGCKW2zPPjx2TZaa/TTH+S96lVpW9fuVFk0/W2a3B0lqTV6lsBxRa8GEox6hrcJsBtgM79KBq5n8PbmoqoH8Co/vW3ClK
MIME-Version: 1.0
X-Received: by 2002:a5d:9f0a:0:b0:6df:c6b6:df00 with SMTP id
 q10-20020a5d9f0a000000b006dfc6b6df00mr11606438iot.173.1670344476410; Tue, 06
 Dec 2022 08:34:36 -0800 (PST)
Date:   Tue, 06 Dec 2022 08:34:36 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002b4a9f05ef2b616f@google.com>
Subject: [syzbot] kernel BUG in rxrpc_put_peer
From:   syzbot <syzbot+c22650d2844392afdcfd@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
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

HEAD commit:    c9f8d73645b6 net: mtk_eth_soc: enable flow offload support..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11fedb97880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c608c21151db14f2
dashboard link: https://syzkaller.appspot.com/bug?extid=c22650d2844392afdcfd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=103f84db880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/bf270f71d81b/disk-c9f8d736.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9df5873e74c3/vmlinux-c9f8d736.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4db90f01e6d3/bzImage-c9f8d736.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c22650d2844392afdcfd@syzkaller.appspotmail.com

rxrpc: Assertion failed
------------[ cut here ]------------
kernel BUG at net/rxrpc/peer_object.c:413!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 15173 Comm: krxrpcio/0 Not tainted 6.1.0-rc7-syzkaller-01810-gc9f8d73645b6 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:__rxrpc_put_peer net/rxrpc/peer_object.c:413 [inline]
RIP: 0010:rxrpc_put_peer.cold+0x11/0x13 net/rxrpc/peer_object.c:437
Code: ff e9 2d f2 f9 fe e8 60 39 92 f7 48 c7 c7 20 ce 74 8b e8 f8 72 bd ff 0f 0b e8 4d 39 92 f7 48 c7 c7 20 d3 74 8b e8 e5 72 bd ff <0f> 0b e8 3a 39 92 f7 4c 8b 4c 24 30 48 89 ea 48 89 ee 48 c7 c1 20
RSP: 0018:ffffc9000b017be8 EFLAGS: 00010282
RAX: 0000000000000017 RBX: ffff88807c44a800 RCX: 0000000000000000
RDX: ffff88807b57ba80 RSI: ffffffff816576cc RDI: fffff52001602f6f
RBP: ffff88807b531c00 R08: 0000000000000017 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: ffff888023d7c000
R13: ffff88807b531d28 R14: ffff88807b531c10 R15: ffff88807b531c30
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9bbe7821b8 CR3: 0000000076947000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 rxrpc_clean_up_connection+0x37d/0x4b0 net/rxrpc/conn_object.c:317
 rxrpc_put_connection.part.0+0x1e8/0x210 net/rxrpc/conn_object.c:356
 rxrpc_put_connection+0x25/0x30 net/rxrpc/conn_object.c:339
 rxrpc_clean_up_local_conns+0x3ad/0x530 net/rxrpc/conn_client.c:1131
 rxrpc_destroy_local+0x170/0x2f0 net/rxrpc/local_object.c:392
 rxrpc_io_thread+0xcde/0xfa0 net/rxrpc/io_thread.c:492
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__rxrpc_put_peer net/rxrpc/peer_object.c:413 [inline]
RIP: 0010:rxrpc_put_peer.cold+0x11/0x13 net/rxrpc/peer_object.c:437
Code: ff e9 2d f2 f9 fe e8 60 39 92 f7 48 c7 c7 20 ce 74 8b e8 f8 72 bd ff 0f 0b e8 4d 39 92 f7 48 c7 c7 20 d3 74 8b e8 e5 72 bd ff <0f> 0b e8 3a 39 92 f7 4c 8b 4c 24 30 48 89 ea 48 89 ee 48 c7 c1 20
RSP: 0018:ffffc9000b017be8 EFLAGS: 00010282
RAX: 0000000000000017 RBX: ffff88807c44a800 RCX: 0000000000000000
RDX: ffff88807b57ba80 RSI: ffffffff816576cc RDI: fffff52001602f6f
RBP: ffff88807b531c00 R08: 0000000000000017 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: ffff888023d7c000
R13: ffff88807b531d28 R14: ffff88807b531c10 R15: ffff88807b531c30
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9bbe7821b8 CR3: 000000002698e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
