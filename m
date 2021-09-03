Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317213FFB5F
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 09:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348120AbhICHzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 03:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348107AbhICHzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 03:55:15 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E01C061575;
        Fri,  3 Sep 2021 00:54:15 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id s29so3688427pfw.5;
        Fri, 03 Sep 2021 00:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=CMZ1yyi16oqxGNmWrTRmixFhuOGqIwUUrsc3+oEvQLQ=;
        b=AeyDQY9c3UDEIOHYavQLmYnA94d4zpvooNUNsPC6+jzPddrZ/pS3k7b+8BRCFd6sEt
         VZKFplcMfjmfbKoCt+rW/tQ27LEkQ+q+AGRPyRYbFPB7LB94D15KgYM3Ajov0MCONCg+
         UpOXU7peWZsCcu9VzLgCseL9vXyUTd33VTXy1jS2Ty3YHr1/+pM1QZc7vK1nbYKur7HR
         a9L/LMxtoUU76mw/YQaz5vLaV6edQ9Gh1O43T7fpWBVyAGImNH+X3oP+ahbln9IG7YoV
         TbLdxqBUcPBCWqx/frvu5HEiLJzqC1DTY5ofwPFY5iK+NEJHwJQ9AzEz0QgHMA4qcwJi
         ufeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=CMZ1yyi16oqxGNmWrTRmixFhuOGqIwUUrsc3+oEvQLQ=;
        b=D0S1etV3IU/NMZpC+UL+y+K//wyVocvwqhGRtyGTkj5Vai0T8b9fvps3jcHt7gOwai
         dxdOozb7Q+LMBhUUQX/n+K5KklGHSbIeO32FRG2dW58MS4NubV3+Rw0pCNfGz2ZTV/eZ
         LvQSghTNM+Bm+GjEq9AzM72t3UsD8XhJZLaQH0KCeDXFJcCYl6VwibaNMGlKv/DZ0fWr
         wrR7KGQIWQbaEaOsSl9ifcdgchLujCHdo6ipPnOAHmX3k+SYJ2Zu+sfVVWmHcvCrvO9P
         KrUPSUPzL5qydofS/36q+YmE609VIiRDOGKrzxwUna+rT+wVVCKuetG+1ZKmJhyhxQhX
         LaVA==
X-Gm-Message-State: AOAM530qkU5SflJGJhKGWVatqOSw13at7mZuEUFoBficfqYsVe9C9Jy2
        636YOgXBp6MNrNfwx9D1eh8Yely2VRZtLahQBQ==
X-Google-Smtp-Source: ABdhPJyAqvm3zibS819NJDXGX6KUDZ6JLuFBr2kOplBsGryaQFcudKuOunst68KqG25+1XWL9bBBQeUuXt9MeD3u+jo=
X-Received: by 2002:a05:6a00:c81:b029:30e:21bf:4c15 with SMTP id
 a1-20020a056a000c81b029030e21bf4c15mr2080205pfv.70.1630655655266; Fri, 03 Sep
 2021 00:54:15 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Fri, 3 Sep 2021 15:54:04 +0800
Message-ID: <CACkBjsYG3O_irFOZqjq5dJVDwW8pSUR_p6oO4BUaabWcx-hQCQ@mail.gmail.com>
Subject: WARNING in sk_stream_kill_queues
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: 9e9fb7655ed58 Merge tag 'net-next-5.15'
git tree: upstream
console output:
https://drive.google.com/file/d/1AXEQDnn7SPgFAMjqbL03_24-X_8YHoAq/view?usp=sharing
kernel config: https://drive.google.com/file/d/1zgxbwaYkrM26KEmJ-5sUZX57gfXtRrwA/view?usp=sharing
C reproducer: https://drive.google.com/file/d/1qa4FVNoO-EsJGuDMtGlTxtHW0li-vMSP/view?usp=sharing
Syzlang reproducer:
https://drive.google.com/file/d/1pL6atNID5ZGzH4GceqyBCOC5IjFfiaVN/view?usp=sharing

If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

 ------------[ cut here ]------------
WARNING: CPU: 1 PID: 10229 at net/core/stream.c:207
sk_stream_kill_queues+0x162/0x190 net/core/stream.c:207
Modules linked in:
CPU: 1 PID: 10229 Comm: syz-executor Not tainted 5.14.0+ #12
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
RIP: 0010:sk_stream_kill_queues+0x162/0x190 net/core/stream.c:207
Code: 41 5c e9 21 3b ce fd e8 1c 3b ce fd 89 de 48 89 ef e8 62 68 fe
ff e8 0d 3b ce fd 8b 95 68 02 00 00 85 d2 74 ca e8 fe 3a ce fd <0f> 0b
e8 f7 3a ce fd 8b 85 20 02 00 00 85 c0 74 c3 e8 e8 3a ce fd
RSP: 0018:ffffc900080b7c98 EFLAGS: 00010202
RAX: 000000000002a750 RBX: 0000000000000180 RCX: ffffc90002c0d000
RDX: 0000000000040000 RSI: ffffffff836939f2 RDI: ffff8881031f0b40
RBP: ffff8881031f0b40 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000000d R11: 000000000004f380 R12: ffff8881031f0c90
R13: ffff8881031f0bc0 R14: ffff8881031f0cf0 R15: 0000000000000000
FS:  00007f311adcb700(0000) GS:ffff88813dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000732190 CR3: 000000010ab01000 CR4: 0000000000752ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 inet_csk_destroy_sock+0x6f/0x1a0 net/ipv4/inet_connection_sock.c:1012
 __tcp_close+0x512/0x610 net/ipv4/tcp.c:2869
 tcp_close+0x29/0xa0 net/ipv4/tcp.c:2881
 inet_release+0x58/0xb0 net/ipv4/af_inet.c:431
 __sock_release+0x47/0xf0 net/socket.c:649
 sock_close+0x18/0x20 net/socket.c:1314
 __fput+0xdf/0x380 fs/file_table.c:280
 task_work_run+0x86/0xd0 kernel/task_work.c:164
 get_signal+0xde6/0x10b0 kernel/signal.c:2596
 arch_do_signal_or_restart+0xa9/0x860 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0xf2/0x280 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x40/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x46a9a9
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f311adcac58 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: 0000000000069340 RBX: 000000000078c0a0 RCX: 000000000046a9a9
RDX: 0000000000088012 RSI: 0000000020000380 RDI: 0000000000000004
RBP: 00000000004e4042 R08: 0000000000000000 R09: 0000000000000027
R10: 000000000020c49a R11: 0000000000000246 R12: 000000000078c0a0
R13: 0000000000000000 R14: 000000000078c0a0 R15: 00007ffe75b47830
