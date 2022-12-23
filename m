Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10E19654D7A
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 09:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236077AbiLWI3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 03:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiLWI3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 03:29:35 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4FB33CFE
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 00:29:34 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id h26-20020a5e841a000000b006e408c1d2a1so1682207ioj.1
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 00:29:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yq9FN37EjnzFvzk0X4kPUox4xYL4nnb5F7GXVPf/ZN4=;
        b=OGguL+1V3cgpIcDvqi4FPcB7+y6G27gQccBObAfvQUPEEnaOswnNewJjKuvy9L+gpg
         NL2hvNxgXkHdJGr/yGO889AN6ZtV9e26FwyLZFb03yUKaxEQhfdmRt3RuszwS7d327zo
         uKDVGROBtSOcjVsKPmfT6WHzyEea6cBBctoz8NmGJRGmN9qF0MWdbWVhbh5NM4OaR8b6
         6z6ypekgcn4joS0RD5t/wqcJzRbPGUamEGZZb5NXTvm1s1g5mKqHJulDURuyhh68Q1Fv
         926p+YJ0MQIcwiKvNxJPcd6bTYVlvzS+6UPC0w/arnNhPfrYr0NnNKNU2cfALAqjkBC4
         b3DQ==
X-Gm-Message-State: AFqh2kq9R8z99MeT6x2qWOYx/nVyoNqYoFLF7ln+3kCcKr/zE5m2JkX0
        3tJeg0P/d0/t9B7vuqkcicKXaN96Z6bbWFPZoAUXkRXLIuS4
X-Google-Smtp-Source: AMrXdXvcNDEnFCMzndQipkM5q65XtBP5dMUearBBfqtC/kvI8F9d93JReEEzrFy9V217dd7oTQklAbCsaJOP+u09PaM6C2il6FNJ
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1048:b0:30b:b94e:522 with SMTP id
 p8-20020a056e02104800b0030bb94e0522mr890795ilj.195.1671784174287; Fri, 23 Dec
 2022 00:29:34 -0800 (PST)
Date:   Fri, 23 Dec 2022 00:29:34 -0800
In-Reply-To: <0000000000002b4a9f05ef2b616f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d9826e05f07a95b3@google.com>
Subject: Re: [syzbot] kernel BUG in rxrpc_put_peer
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    8395ae05cb5a Merge tag 'scsi-misc' of git://git.kernel.org..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1458e1cf880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b0e81c4eb13a67cd
dashboard link: https://syzkaller.appspot.com/bug?extid=c22650d2844392afdcfd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14386450480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17223f80480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/185a22278a16/disk-8395ae05.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/852ad4c6710f/vmlinux-8395ae05.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d0b9daae6d3a/bzImage-8395ae05.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c22650d2844392afdcfd@syzkaller.appspotmail.com

rxrpc: Assertion failed
------------[ cut here ]------------
kernel BUG at net/rxrpc/peer_object.c:413!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 27502 Comm: krxrpcio/0 Not tainted 6.1.0-syzkaller-14446-g8395ae05cb5a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:__rxrpc_put_peer net/rxrpc/peer_object.c:413 [inline]
RIP: 0010:rxrpc_put_peer.cold+0x11/0x13 net/rxrpc/peer_object.c:437
Code: ff e9 21 62 f9 fe e8 74 30 7e f7 48 c7 c7 a0 16 76 8b e8 04 ef bc ff 0f 0b e8 61 30 7e f7 48 c7 c7 a0 1b 76 8b e8 f1 ee bc ff <0f> 0b e8 4e 30 7e f7 4c 8b 4c 24 30 48 89 ea 48 89 ee 48 c7 c1 a0
RSP: 0018:ffffc9000607fbe8 EFLAGS: 00010282
RAX: 0000000000000017 RBX: ffff88801eeb7800 RCX: 0000000000000000
RDX: ffff88802b638280 RSI: ffffffff8165927c RDI: fffff52000c0ff6f
RBP: ffff888028d23c00 R08: 0000000000000017 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: ffff888028550000
R13: ffff888028d23d28 R14: ffff888028d23c10 R15: ffff888028d23c30
FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000140 CR3: 0000000077fb2000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 rxrpc_clean_up_connection+0x37d/0x4b0 net/rxrpc/conn_object.c:317
 rxrpc_put_connection.part.0+0x1e8/0x210 net/rxrpc/conn_object.c:356
 rxrpc_put_connection+0x25/0x30 net/rxrpc/conn_object.c:339
 rxrpc_clean_up_local_conns+0x3ad/0x530 net/rxrpc/conn_client.c:1129
 rxrpc_destroy_local+0x170/0x2f0 net/rxrpc/local_object.c:395
 rxrpc_io_thread+0xce8/0xfb0 net/rxrpc/io_thread.c:496
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__rxrpc_put_peer net/rxrpc/peer_object.c:413 [inline]
RIP: 0010:rxrpc_put_peer.cold+0x11/0x13 net/rxrpc/peer_object.c:437
Code: ff e9 21 62 f9 fe e8 74 30 7e f7 48 c7 c7 a0 16 76 8b e8 04 ef bc ff 0f 0b e8 61 30 7e f7 48 c7 c7 a0 1b 76 8b e8 f1 ee bc ff <0f> 0b e8 4e 30 7e f7 4c 8b 4c 24 30 48 89 ea 48 89 ee 48 c7 c1 a0
RSP: 0018:ffffc9000607fbe8 EFLAGS: 00010282
RAX: 0000000000000017 RBX: ffff88801eeb7800 RCX: 0000000000000000
RDX: ffff88802b638280 RSI: ffffffff8165927c RDI: fffff52000c0ff6f
RBP: ffff888028d23c00 R08: 0000000000000017 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: ffff888028550000
R13: ffff888028d23d28 R14: ffff888028d23c10 R15: ffff888028d23c30
FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000140 CR3: 000000000c48e000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

