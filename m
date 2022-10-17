Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03221601B83
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 23:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiJQVvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 17:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiJQVvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 17:51:02 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8584480528;
        Mon, 17 Oct 2022 14:51:01 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-132fb4fd495so14790757fac.12;
        Mon, 17 Oct 2022 14:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jNxK7gQU0fVn+WFkTZndlvUy+KYzOVRKDyhK+Bqlq/I=;
        b=poqUORzS4XvE9lntYRGHUyQkTLhZ5KTUvoXfTCqFoj2K3EbK0UNKyXB9SQcw6RfIV+
         ZF5N6GgBs1Op8g2UwzXtrnmRgREo4cnT5UUPy1PzRWC1P7p2u81iGIEp/LK+4gX09jKO
         GyNGWisqB88CrL1nXQED3gMjsJFyeHtgy7fEfohjSMlHZq97A0lR/21K3VmxNu+hGz9j
         C3pwv5BezeH+4+GrY1jjOltqwJi4xfQs40RN120aLmgBJd1E05JYXJhz2jbLIGxQstKn
         XjNVfuFSiXKa76r1YxO309gTqQ16O4nedSxzWPkTYjyNWPYrHfmOQvqkypSaE5NsGFui
         FyQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jNxK7gQU0fVn+WFkTZndlvUy+KYzOVRKDyhK+Bqlq/I=;
        b=Gl6Pw2Lh4M+BaUnXWowUWqbrev6ZRO1x+DgHWR3Q6e/No/OWxR65kEKr+AVtcvUN4m
         uAY/FItx0wmOMXLipZhxTe0zRfUwTpZyrYQGRjivzcK/um8hhpJwOtnUpZCP8oZLySzN
         uNRhPS+YEHqh8EzWf/0BqY89fB2xfe273JmgR2f4hhBwBxeZlQelYR5ACn0WsilDDALa
         nffIJqo5ISDEJEGdH9G9j0J9aCSBEgT4E+M8d0pq49EK4RODwxFgDYz13HBa/MOswTAv
         nYI/wyqITizx3RyQFNwI31l7MVZ7+VKGBPcLK+kBbQSypm35LxebPCwLFOMo4q9EHGHT
         7wQw==
X-Gm-Message-State: ACrzQf0oLqN/xhHE5ZfGYUaFwW1Z9NIoo3E4bSbGlpAIcHPLMR/213TX
        mRgTDAAvK+6OfK6HCWCx+Pl7ncJk8JrPHlD8mGE=
X-Google-Smtp-Source: AMsMyM4RiNJ6IwwoQYulQsvwxrPapOScQuc+SAeZuiM+0pJG9wjaMvI0fEt8Blh/XGSOO/xfsBA7mqGHZdUstLPg3a0=
X-Received: by 2002:a05:6870:9614:b0:11d:3906:18fc with SMTP id
 d20-20020a056870961400b0011d390618fcmr16778298oaq.190.1666043460198; Mon, 17
 Oct 2022 14:51:00 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000006d989105e9a4b916@google.com> <20220927071449.67a2b0a0@kernel.org>
In-Reply-To: <20220927071449.67a2b0a0@kernel.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 17 Oct 2022 17:50:47 -0400
Message-ID: <CADvbK_eFcPUw0Bn_xM6JY_JgcxO7MQRQ25W3LGkbty2WGsn8PQ@mail.gmail.com>
Subject: Re: [syzbot] general protection fault in kernel_accept (5)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     syzbot <syzbot+c5ce866a8d30f4be0651@syzkaller.appspotmail.com>,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 10:26 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Adding TIPC
>
> On Tue, 27 Sep 2022 01:49:38 -0700 syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    bf682942cd26 Merge tag 'scsi-fixes' of git://git.kernel.or..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=117fc3ac880000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=7db7ad17eb14cb7
> > dashboard link: https://syzkaller.appspot.com/bug?extid=c5ce866a8d30f4be0651
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+c5ce866a8d30f4be0651@syzkaller.appspotmail.com
> >
> > general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
> > KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> > CPU: 3 PID: 12841 Comm: kworker/u16:2 Not tainted 6.0.0-rc6-syzkaller-00210-gbf682942cd26 #0
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
> > Workqueue: tipc_rcv tipc_topsrv_accept
> > RIP: 0010:kernel_accept+0x22d/0x350 net/socket.c:3487
> > Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 e3 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 5b 20 48 8d 7b 08 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 ee 00 00 00 48 8b 7b 08 e8 a0 36 1c fa e8 8b ff
> > RSP: 0018:ffffc9000494fc28 EFLAGS: 00010202
> > RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > RDX: 0000000000000001 RSI: ffffffff874c37b2 RDI: 0000000000000008
> > RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000449 R12: 0000000000000000
> > R13: ffff888027a7b980 R14: ffff888028bc08e0 R15: 1ffff92000929f90
> > FS:  0000000000000000(0000) GS:ffff88802cb00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007fa6e1a8c920 CR3: 000000004bba0000 CR4: 0000000000150ee0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <TASK>
> >  tipc_topsrv_accept+0x197/0x280 net/tipc/topsrv.c:460
It seems that we should free the lsock after the worker is done:

@@ -699,8 +699,8 @@ static void tipc_topsrv_stop(struct net *net)
        __module_get(lsock->sk->sk_prot_creator->owner);
        srv->listener = NULL;
        spin_unlock_bh(&srv->idr_lock);
-       sock_release(lsock);
        tipc_topsrv_work_stop(srv);
+       sock_release(lsock);
        idr_destroy(&srv->conn_idr);
        kfree(srv);
 }

> >  process_one_work+0x991/0x1610 kernel/workqueue.c:2289
> >  worker_thread+0x665/0x1080 kernel/workqueue.c:2436
> >  kthread+0x2e4/0x3a0 kernel/kthread.c:376
> >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
> >  </TASK>
> > Modules linked in:
> > ---[ end trace 0000000000000000 ]---
> > RIP: 0010:kernel_accept+0x22d/0x350 net/socket.c:3487
> > Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 e3 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 5b 20 48 8d 7b 08 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 ee 00 00 00 48 8b 7b 08 e8 a0 36 1c fa e8 8b ff
> > RSP: 0018:ffffc9000494fc28 EFLAGS: 00010202
> > RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > RDX: 0000000000000001 RSI: ffffffff874c37b2 RDI: 0000000000000008
> > RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000449 R12: 0000000000000000
> > R13: ffff888027a7b980 R14: ffff888028bc08e0 R15: 1ffff92000929f90
> > FS:  0000000000000000(0000) GS:ffff88802ca00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000000c0154d8000 CR3: 000000006fb4b000 CR4: 0000000000150ee0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > ----------------
> > Code disassembly (best guess):
> >    0: 48 89 fa                mov    %rdi,%rdx
> >    3: 48 c1 ea 03             shr    $0x3,%rdx
> >    7: 80 3c 02 00             cmpb   $0x0,(%rdx,%rax,1)
> >    b: 0f 85 e3 00 00 00       jne    0xf4
> >   11: 48 b8 00 00 00 00 00    movabs $0xdffffc0000000000,%rax
> >   18: fc ff df
> >   1b: 48 8b 5b 20             mov    0x20(%rbx),%rbx
> >   1f: 48 8d 7b 08             lea    0x8(%rbx),%rdi
> >   23: 48 89 fa                mov    %rdi,%rdx
> >   26: 48 c1 ea 03             shr    $0x3,%rdx
> > * 2a: 80 3c 02 00             cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
> >   2e: 0f 85 ee 00 00 00       jne    0x122
> >   34: 48 8b 7b 08             mov    0x8(%rbx),%rdi
> >   38: e8 a0 36 1c fa          callq  0xfa1c36dd
> >   3d: e8                      .byte 0xe8
> >   3e: 8b ff                   mov    %edi,%edi
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
