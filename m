Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4D9647645
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 20:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiLHTia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 14:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiLHTi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 14:38:28 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559C777233
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 11:38:27 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id b16so2967229yba.0
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 11:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+uP+XpFfkKZXzZgEzXmIxGEZ3g7OKDET45/mYYRaIrE=;
        b=QZGMYcHuPS3gWnEBHmoupMR1nNRjm1qzDkVuF1ZHAmxS9pMTo5rQCSGhOtU3NVOgN6
         GpAj8wGqOWlBOEzDC6TIplSaIhEKGIJskShSsqzN3CAT2jOaJFqXwv0a65LaXOCE0zY3
         AelMN30B4HiNzoiIgmxgkW46mv1amJvelxAU+8JrKMdO4PMQlYeHbAtVv8lTHp1qnKIl
         LWWiGeWC0HtgoTymoVypFgYgZ+EulxLNC0A+TN7O/evf31p0Rw6Us2VPgiARwLJYawgX
         1r9vHMXxlvWXRUoJpvFCNX6XYLsjhlXd5OvnDcT+CqGz/bbG+Ek6GCsofz98ftz+Uy4u
         9eGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+uP+XpFfkKZXzZgEzXmIxGEZ3g7OKDET45/mYYRaIrE=;
        b=bNAqd1pLZKTDaMhxuxDTm6cx9y3vdNvCYJ68fP+YY6pOtWnJf6hJRdMchq7vEi+CwQ
         To48YuWNld1BEuviY4C+tfZMSDQA6qrEctUUtZYr7s+C1/MkSML6k9uUEFkVd0WNdPy5
         m72+L4Jl9Tx1xq6zDZL/IRFSlZyKSimpWXJMlwzhQUyNu88nR1NZ2ozm9NT7YKgCf4zI
         6wZpNSgSB5ob9/AIv7F91u8XeEtQmYVHNJcwQgEcqseq0adArQsMcHkQLDgYIi9L8Mzn
         E599rMUmEjefvO1Oz/QryXVbnLV4epIrH8rFFmGQOULMCp4CDB/73DsnNAtX2Pb6rF+2
         TYrA==
X-Gm-Message-State: ANoB5pk32Wi0Bmdos2u6bsSrfNo4LQ+yimGrGRCtYyVTIRs0+vE4HMti
        4C6PnOV4yOZK4g32DtND54UgRLegCR7ToBT8tJEYpg==
X-Google-Smtp-Source: AA0mqf7DEUxZS8aCZsoaElkt6UJ0vsOnUAi8ol/THM9V1TX6HFYHsKfzuzeEPzlSSXeAPxTqgju1lv+I4Bk80/VbRz8=
X-Received: by 2002:a25:941:0:b0:706:bafd:6f95 with SMTP id
 u1-20020a250941000000b00706bafd6f95mr8792231ybm.55.1670528306221; Thu, 08 Dec
 2022 11:38:26 -0800 (PST)
MIME-Version: 1.0
References: <000000000000bc5b5a05ef56276d@google.com>
In-Reply-To: <000000000000bc5b5a05ef56276d@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 8 Dec 2022 20:38:14 +0100
Message-ID: <CANn89i+ov7yr_aKNnXdGekZaCT8RW1ijRhPj4BXkKK2hJ0OH3A@mail.gmail.com>
Subject: Re: [syzbot] WARNING in _copy_from_iter
To:     syzbot <syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     davem@davemloft.net, jmaloy@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 8, 2022 at 8:36 PM syzbot
<syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    591cd61541b9 Add linux-next specific files for 20221207
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=15d12929880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8b2d3e63e054c24f
> dashboard link: https://syzkaller.appspot.com/bug?extid=d43608d061e8847ec9f3
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=172536fb880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12d00a7d880000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/bc862c01ec56/disk-591cd615.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/8f9b93f8ed2f/vmlinux-591cd615.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/9d5cb636d548/bzImage-591cd615.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 5086 at lib/iov_iter.c:629 _copy_from_iter+0x2ed/0xf70 lib/iov_iter.c:629
> Modules linked in:
> CPU: 0 PID: 5086 Comm: syz-executor371 Not tainted 6.1.0-rc8-next-20221207-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> RIP: 0010:_copy_from_iter+0x2ed/0xf70 lib/iov_iter.c:629
> Code: 77 fd 44 89 fb e9 33 ff ff ff e8 be 34 77 fd be 79 02 00 00 48 c7 c7 e0 59 a6 8a e8 fd 6f b0 fd e9 17 fe ff ff e8 a3 34 77 fd <0f> 0b 45 31 ff e9 7b ff ff ff e8 94 34 77 fd 31 ff 89 ee e8 fb 30
> RSP: 0018:ffffc90003e1f828 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff888026548000 RSI: ffffffff840a6e5d RDI: 0000000000000001
> RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90003e1fd00
> R13: ffff888079c498f8 R14: ffffc90003e1fd00 R15: 0000000000000000
> FS:  0000555557073300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000045b630 CR3: 000000007d92a000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  copy_from_iter include/linux/uio.h:187 [inline]
>  copy_from_iter_full include/linux/uio.h:194 [inline]
>  tipc_msg_build+0x2d4/0x10a0 net/tipc/msg.c:404
>  __tipc_sendmsg+0xada/0x1870 net/tipc/socket.c:1505
>  tipc_connect+0x57b/0x6b0 net/tipc/socket.c:2624
>  __sys_connect_file+0x153/0x1a0 net/socket.c:1976
>  __sys_connect+0x165/0x1a0 net/socket.c:1993
>  __do_sys_connect net/socket.c:2003 [inline]
>  __se_sys_connect net/socket.c:2000 [inline]
>  __x64_sys_connect+0x73/0xb0 net/socket.c:2000
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fac68eeeb19
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe4214d778 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fac68eeeb19
> RDX: 0000000000000010 RSI: 0000000020000000 RDI: 0000000000000003
> RBP: 00007fac68eb2cc0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fac68eb2d50
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

Exposes an old bug in tipc ?

Seems a new check added by Al in :

Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Sep 15 20:11:15 2022 -0400

    iov_iter: saner checks for attempt to copy to/from iterator

    instead of "don't do it to ITER_PIPE" check for ->data_source being
    false on copying from iterator.  Check for !->data_source for
    copying to iterator, while we are at it.

    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
