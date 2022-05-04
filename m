Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32CF51A0E2
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 15:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347065AbiEDN3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 09:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344173AbiEDN3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 09:29:43 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6644A23BE3
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 06:26:02 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id y76so2370601ybe.1
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 06:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HrYMTeFGo9vv6CKXzizg7NkClqf4L09RghpNP8UrcKs=;
        b=gMcuDBZiJC9XVzC3n0YH66HtjurBfHh9/PMn4aWd97i19KpMA6GLOinhB/NrchmZH7
         UVaqK8p6QOwMxC5k2gidFLzSIyOPKtwjZXpU15v73eOPe9YbzWjJPBNYzgQdo2d4+tVQ
         9VX218pK5y+5Ra2/hdErORbiys9t3VHLj4+f1ayC2q9ob0dUtcwrW+H8iskxbY9k2LCO
         rCRR9A4rRAYRRLNf/cxL3m4Kj69l7qb/OXnlDJknnc60Na1XB85lEXZVWOax+IBnSIPP
         KWdUwEi0gMPAnTBjQASSMXAl1FJR9WCHoC392rb8Pofp8V0iqltRtaasQ4eUETkOjise
         g+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HrYMTeFGo9vv6CKXzizg7NkClqf4L09RghpNP8UrcKs=;
        b=1J8NikjQPjV7c7fuq3HXECTSOKiCBq/2K1w92umT97xJVb1E2DjAjlSzfWcjosewpv
         K+hiqkdMfhFWbOYsRGzPP8EPwGUsKd+olBE6rUKyMYUn9gYDONAlbnt3cTGERwDHpwvF
         R9Cm6jwystgtxsPXyaMPfkZO5lKaQsVK0CGNl/O1X/xJj3BOmX/acRg4H4vwt8fm4PeU
         /hCzVvqfWoTblt3tJXJ17rMeevg0FSgSRL0Bzo6Brx88Rd0nZaXgWK9RedbNqLSc2BFx
         WSk7HkRxAIbdvcPhmlwU2QajtJ0RGj6wD5KPE4X4c1z84sD3qwnHedczxQzRDB6g00/s
         bDwA==
X-Gm-Message-State: AOAM532RaXlP7JX9dqO/Ng2AJpXJnHTBkv4TisMXrh1Gyt+yvhz+dz9r
        hD28MIlLfyI/sxbhjkFs+xFPxf5Aj6X5wt4EJChirw==
X-Google-Smtp-Source: ABdhPJzZO0k04SWiCPzvEWue+yEqCZJeE4lPhq25YMS11jefYio+fzRyjZzkukLm52cgXUWdeg/CKblpgLuPSy5HoM0=
X-Received: by 2002:a25:ba50:0:b0:649:b5b2:6fca with SMTP id
 z16-20020a25ba50000000b00649b5b26fcamr8221474ybj.55.1651670760992; Wed, 04
 May 2022 06:26:00 -0700 (PDT)
MIME-Version: 1.0
References: <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
 <165157801106.17866.6764782659491020080.git-patchwork-notify@kernel.org>
 <CANn89iLHihonbBUQWkd0mjJPUuYBLMVoLCsRswtXmGjU3NKL5w@mail.gmail.com> <d3d068eda5ef2d1ab818f01d7d07fab901363446.camel@redhat.com>
In-Reply-To: <d3d068eda5ef2d1ab818f01d7d07fab901363446.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 4 May 2022 06:25:49 -0700
Message-ID: <CANn89i+W-b8CPxzdTzGXJsHLV4yyKagQK6OJP6CUjM8f+qpB5Q@mail.gmail.com>
Subject: Re: [PATCH v2] net: rds: acquire refcount on TCP sockets
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-rdma <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 4, 2022 at 6:09 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2022-05-03 at 14:17 -0700, Eric Dumazet wrote:
> > On Tue, May 3, 2022 at 4:40 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
> > >
> > > Hello:
> > >
> > > This patch was applied to netdev/net.git (master)
> > > by Paolo Abeni <pabeni@redhat.com>:
> > >
> > > On Mon, 2 May 2022 10:40:18 +0900 you wrote:
> > > > syzbot is reporting use-after-free read in tcp_retransmit_timer() [1],
> > > > for TCP socket used by RDS is accessing sock_net() without acquiring a
> > > > refcount on net namespace. Since TCP's retransmission can happen after
> > > > a process which created net namespace terminated, we need to explicitly
> > > > acquire a refcount.
> > > >
> > > > Link: https://syzkaller.appspot.com/bug?extid=694120e1002c117747ed [1]
> > > > Reported-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
> > > > Fixes: 26abe14379f8e2fa ("net: Modify sk_alloc to not reference count the netns of kernel sockets.")
> > > > Fixes: 8a68173691f03661 ("net: sk_clone_lock() should only do get_net() if the parent is not a kernel socket")
> > > > Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > > > Tested-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
> > > >
> > > > [...]
> > >
> > > Here is the summary with links:
> > >   - [v2] net: rds: acquire refcount on TCP sockets
> > >     https://git.kernel.org/netdev/net/c/3a58f13a881e
> > >
> > > You are awesome, thank you!
> > > --
> > > Deet-doot-dot, I am a bot.
> > > https://korg.docs.kernel.org/patchwork/pwbot.html
> > >
> > >
> >
> > I think we merged this patch too soon.
>
> My fault.
>
>
> > My question is : What prevents rds_tcp_conn_path_connect(), and thus
> > rds_tcp_tune() to be called
> > after the netns refcount already reached 0 ?
> >
> > I guess we can wait for next syzbot report, but I think that get_net()
> > should be replaced
> > by maybe_get_net()
> >
> Should we revert this patch before the next pull request, if a suitable
> incremental fix is not available by then?
>
> It looks like the window of opportunity for the race is roughly the
> same?
>

No need to revert the patch, we certainly are in a better situation,
as refcount_t helps here.

We can refine the logic in a followup.

Thanks.
