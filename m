Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A084519182
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 00:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243726AbiECWld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 18:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiECWlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 18:41:32 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15B1427E3
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 15:37:58 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2f7d7e3b5bfso195521677b3.5
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 15:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uVPEP/t88TxWVB3RQ2Uu4An4m5Q6tjXE/WhomcsasrA=;
        b=b+/CC8nxKLwVHo3CTrwYj+krxeR/eQQj1BZa8FgeQR3TTfW9+c6xy8k4Ar9PZd8V1i
         7eosH3CCvJbov6ipCbin3A+tZc2U2NqW2Gb3ywTOWo0if8iYJhJNhZysUET+sNB5bMa4
         cx5Bcz7aBAVPKE6QAVQFxmnil/QWUQv0fjObWIkfXDlgfNhTVpSMEDRliJQX66USX76V
         EP5ljeJ+4ewYmhQdd6otGavyFBUcNBfJ2qrn9UM52Oec6GiYuOiQhPdvsmg7uaLDbWD6
         aAVur1Ql+dSZw5qrCAMawTifBzxklKG6j/1od4B2TcRzbvD2enxdaxFuNJmb4n6KCy+E
         neOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uVPEP/t88TxWVB3RQ2Uu4An4m5Q6tjXE/WhomcsasrA=;
        b=y8lIDwuc9OTlIPXqdfkRadvMIEU+t4IbCom9R4NoFcATkMs2isDmtujRkWOPAtlOjc
         ZRqSiB3FTAjBewooqOeGBWX2vWaZC+M84x/gZnyfrKjjQKqt7xcLyHAbW3SU862PDCaI
         nD6m89l0ppB7oAixM8l+yeBHc8EcTW/WN74aU76MYtxc99BCkw/ae0Y5vnZRXdADQcVt
         6VsGGrpeRuZKvSHHXeAh6hemFeF+rGsVicHHNTQVzJCmO64E+pkU8V4HJM1c/exMrfHj
         8idD6oWjeY3vfFAb21qnr5gGGPsjuyOmrzILqfYH5QeFUrMbhT4P5/Uzneu8O0cHtKnq
         LNkw==
X-Gm-Message-State: AOAM530v5HnQSRUvy8aqYMwSjg6SEeS17LotNENSVwGqJ9AmgLYsEmKt
        +Q1JoLw/4qwnoaGyz7uA0Fc+tjL29mKCngqUceH6kw==
X-Google-Smtp-Source: ABdhPJxL93pzrQz6LuoJVcZVgln8HDHp7rsyGBa12s31huRvF7C1MBRlu+oT46jt9XoqcK2Uni9uH/sWeVT2TefQnkc=
X-Received: by 2002:a0d:e8c7:0:b0:2f4:cd95:76d8 with SMTP id
 r190-20020a0de8c7000000b002f4cd9576d8mr16717641ywe.55.1651617477586; Tue, 03
 May 2022 15:37:57 -0700 (PDT)
MIME-Version: 1.0
References: <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
 <165157801106.17866.6764782659491020080.git-patchwork-notify@kernel.org> <CANn89iLHihonbBUQWkd0mjJPUuYBLMVoLCsRswtXmGjU3NKL5w@mail.gmail.com>
In-Reply-To: <CANn89iLHihonbBUQWkd0mjJPUuYBLMVoLCsRswtXmGjU3NKL5w@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 3 May 2022 15:37:46 -0700
Message-ID: <CANn89iJ=LF0KhRXDiFcky7mqpVaiHdbc6RDacAdzseS=iwjr4Q@mail.gmail.com>
Subject: Re: [PATCH v2] net: rds: acquire refcount on TCP sockets
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-rdma <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 3, 2022 at 2:17 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, May 3, 2022 at 4:40 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
> >
> > Hello:
> >
> > This patch was applied to netdev/net.git (master)
> > by Paolo Abeni <pabeni@redhat.com>:
> >
> > On Mon, 2 May 2022 10:40:18 +0900 you wrote:
> > > syzbot is reporting use-after-free read in tcp_retransmit_timer() [1],
> > > for TCP socket used by RDS is accessing sock_net() without acquiring a
> > > refcount on net namespace. Since TCP's retransmission can happen after
> > > a process which created net namespace terminated, we need to explicitly
> > > acquire a refcount.
> > >
> > > Link: https://syzkaller.appspot.com/bug?extid=694120e1002c117747ed [1]
> > > Reported-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
> > > Fixes: 26abe14379f8e2fa ("net: Modify sk_alloc to not reference count the netns of kernel sockets.")
> > > Fixes: 8a68173691f03661 ("net: sk_clone_lock() should only do get_net() if the parent is not a kernel socket")
> > > Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > > Tested-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
> > >
> > > [...]
> >
> > Here is the summary with links:
> >   - [v2] net: rds: acquire refcount on TCP sockets
> >     https://git.kernel.org/netdev/net/c/3a58f13a881e
> >
> > You are awesome, thank you!
> > --
> > Deet-doot-dot, I am a bot.
> > https://korg.docs.kernel.org/patchwork/pwbot.html
> >
> >
>
> I think we merged this patch too soon.
>
> My question is : What prevents rds_tcp_conn_path_connect(), and thus
> rds_tcp_tune() to be called
> after the netns refcount already reached 0 ?
>
> I guess we can wait for next syzbot report, but I think that get_net()
> should be replaced
> by maybe_get_net()

Yes, syzbot was fast to trigger this exact issue:

HEAD commit:    3a58f13a net: rds: acquire refcount on TCP sockets
git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master
------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 1 PID: 6934 at lib/refcount.c:25
refcount_warn_saturate+0x169/0x1e0 lib/refcount.c:25
Modules linked in:
CPU: 1 PID: 6934 Comm: kworker/u4:17 Not tainted
5.18.0-rc4-syzkaller-00209-g3a58f13a881e #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 01/01/2011
Workqueue: krdsd rds_connect_worker
RIP: 0010:refcount_warn_saturate+0x169/0x1e0 lib/refcount.c:25
Code: 09 31 ff 89 de e8 f7 b9 81 fd 84 db 0f 85 36 ff ff ff e8 0a b6
81 fd 48 c7 c7 40 eb 26 8a c6 05 75 1f ac 09 01 e8 56 75 2d 05 <0f> 0b
e9 17 ff ff ff e8 eb b5 81 fd 0f b6 1d 5a 1f ac 09 31 ff 89
RSP: 0018:ffffc9000b5e7b80 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88807a948000 RSI: ffffffff81600c08 RDI: fffff520016bcf62
RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815fb5de R11: 0000000000000000 R12: ffff888021e69b80
R13: ffff88805bc82a00 R14: ffff888021e69ccc R15: ffff8880741a2900
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2cb5c000 CR3: 000000005688f000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __refcount_add include/linux/refcount.h:199 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 get_net include/net/net_namespace.h:248 [inline]
 get_net_track include/net/net_namespace.h:334 [inline]
 rds_tcp_tune+0x5a0/0x5f0 net/rds/tcp.c:503
 rds_tcp_conn_path_connect+0x489/0x880 net/rds/tcp_connect.c:127
 rds_connect_worker+0x1a5/0x2c0 net/rds/threads.c:176
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>
