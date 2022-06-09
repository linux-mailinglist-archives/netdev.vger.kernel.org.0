Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B7754424A
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 06:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237350AbiFIEB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 00:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiFIEB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 00:01:26 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D230B7B9F9
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 21:01:24 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id s189-20020a6b2cc6000000b00669add3c306so396174ios.21
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 21:01:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=RSLiPAtENbTkSowwv2uPq1Qvn2KqDjp9roHFS/8AUSY=;
        b=uj/agxUXmQx0DHsEASyazIwmA/Qy0I5pL0ArJMdLnEotV8vaCr7P9re9cznuIyu0x1
         aEamna8io7aovolXMoU3tSQ+ezL+j6xsZYnwqja7TJOwX4e8xlLWFAER72GwzDi8bv6r
         4SRbPNgA5SeoFDBkirlQCiCAs/7hCoEkz50aIlLSOS12IAm5Ja4f8Y3++O5KBqTSWe9J
         WUZPrl8XjtM6sP8FC0j5KNzNqDBKtsspAk41gLi8prQ5NmehL95iGMRqX3NNaWb0B0Ak
         R7R21ZyXWH9IswHcQjPatiqmozviYREBexPkCkwSwIM5rmzwGhuuX355EsBzcZcMD5ks
         l2sA==
X-Gm-Message-State: AOAM530+PVe6AzA5WHUp5+iJEX4fNUlz1pJ12dJKceRug9slj8UQ6eeD
        taKCxuUaOd1ayNzv0ZkA3lEkKSG+iSIdzXroT0hn/Xd1G5kS
X-Google-Smtp-Source: ABdhPJzyyKP5vrE2Hdhnme0jjwLAT91coYM95JWyNU9CSxjGxkjNdnqp5wWX5vLENY+BTkGhKSApw8vnAMk8Hjrua/U/wupKTUa0
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1645:b0:2d6:5dd3:e627 with SMTP id
 v5-20020a056e02164500b002d65dd3e627mr3465147ilu.268.1654747284259; Wed, 08
 Jun 2022 21:01:24 -0700 (PDT)
Date:   Wed, 08 Jun 2022 21:01:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000124e9105e0fbe047@google.com>
Subject: [syzbot] BUG: sleeping function called from invalid context in
 corrupted (2)
From:   syzbot <syzbot+efe1afd49d981d281ae4@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        jakub@cloudflare.com, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, wangyufen@huawei.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    03c312cc5f47 Add linux-next specific files for 20220608
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=155a4b73f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a0a0f5184fb46b
dashboard link: https://syzkaller.appspot.com/bug?extid=efe1afd49d981d281ae4
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168d9ebff00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=125c6e5ff00000

The issue was bisected to:

commit d8616ee2affcff37c5d315310da557a694a3303d
Author: Wang Yufen <wangyufen@huawei.com>
Date:   Tue May 24 07:53:11 2022 +0000

    bpf, sockmap: Fix sk->sk_forward_alloc warn_on in sk_stream_kill_queues

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=138a4b57f00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=104a4b57f00000
console output: https://syzkaller.appspot.com/x/log.txt?x=178a4b57f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+efe1afd49d981d281ae4@syzkaller.appspotmail.com
Fixes: d8616ee2affc ("bpf, sockmap: Fix sk->sk_forward_alloc warn_on in sk_stream_kill_queues")

BUG: sleeping function called from invalid context at kernel/workqueue.c:3010
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 3611, name: syz-executor124
preempt_count: 201, expected: 0
RCU nest depth: 0, expected: 0
3 locks held by syz-executor124/3611:
 #0: ffff888073295c10 (&sb->s_type->i_mutex_key#10){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:742 [inline]
 #0: ffff888073295c10 (&sb->s_type->i_mutex_key#10){+.+.}-{3:3}, at: __sock_release+0x86/0x280 net/socket.c:649
 #1: ffff888073ff1ab0 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1691 [inline]
 #1: ffff888073ff1ab0 (sk_lock-AF_INET6){+.+.}-{0:0}, at: tcp_close+0x1e/0xc0 net/ipv4/tcp.c:2908


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
