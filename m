Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7265185CD
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 15:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236397AbiECNrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 09:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236391AbiECNrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 09:47:12 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47F91D32E
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 06:43:39 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2f7c424c66cso180418987b3.1
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 06:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GDW9NFvTVUZU0OXiK1V5vkvO7rLAmfjO6t3+PGR4Adg=;
        b=QgaEpgJAAyem65Q6TAKxwJJ3o1V+C7zObAPPgKlJM62+lc8DygEVsd+kYoEYkM16Fl
         vitMPIHaEUJ9hGhopT4e1uv51ALgp9qB8NpKutqi8oD5KNfOlzeymJCPL9wLQMqMfZfa
         gHgkLdEl3lrVRqMvjZeiosAb85yvrAbxdBDLHeGAfJlWEnxgVNoruJpbryO6HtlGHFdE
         TGDReQmhU8Jwcqp5xdkxTOvk91Uwna7rkKD1Yu7G38UuLHX1HtUBPP1n7v452Aujr25B
         FUUU62RlnvfoIgHhxDE7Wqxk4Cdl89PBphh7FMcF0ee2SDrJCdEsHQ1NN4+nCl89tghK
         g2dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GDW9NFvTVUZU0OXiK1V5vkvO7rLAmfjO6t3+PGR4Adg=;
        b=79ZblL/wboeOKkEazctwRDCTRGdHz98B/r7QD4MYYTQz+7sqgmmoJD22yP6pBgmmpS
         p7EQaiUJRyrQxD7NzmwiFQnPnZszFxVhB3e+V3T+Ant0D9ZZN05pkjZHyykuWedbn3ue
         uxcc9VVMJ+b7dU8UxOTi/yD8AY/F9I4c0jaeA3wPA5D6E7l6FVP7qO/HTnBccxMZkyMr
         naGMFUmjkrxLAi6Rfth7LBDtUcbiUBUzd1FWrPo8atkDaHDuNkfTJ4cqlEAeOJRHma5o
         2FnYHc+xdNHlt6Bdb8p5IRYq8EEiNXFsK9nZ3HQxehs69wCDDMD2cEf82beo99TIrouS
         Nyng==
X-Gm-Message-State: AOAM533O+71gPBP+pD8Ek8slfqrTyg7jS5tpXnKd62WZgFoR+VjD2vRC
        DAmwVBK/ipd3EDNvLHAWqvS2RPKPp2xeKxO2QjpC3w==
X-Google-Smtp-Source: ABdhPJyNRiMmKn7C6XCkZGQqbYy63g4zeoEzquu1MeADlJuMPOJ3hIrnxuDlqew8AFLimody0G+bq16PwL2zsWwlQHM=
X-Received: by 2002:a81:1d4e:0:b0:2f7:be8b:502e with SMTP id
 d75-20020a811d4e000000b002f7be8b502emr15496205ywd.278.1651585418486; Tue, 03
 May 2022 06:43:38 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000045dc96059f4d7b02@google.com> <000000000000f75af905d3ba0716@google.com>
 <c389e47f-8f82-fd62-8c1d-d9481d2f71ff@I-love.SAKURA.ne.jp>
 <b0f99499-fb6a-b9ec-7bd3-f535f11a885d@I-love.SAKURA.ne.jp>
 <5f90c2b8-283e-6ca5-65f9-3ea96df00984@I-love.SAKURA.ne.jp>
 <f8ae5dcd-a5ed-2d8b-dd7a-08385e9c3675@I-love.SAKURA.ne.jp>
 <CANn89iJukWcN9-fwk4HEH-StAjnTVJ34UiMsrN=mdRbwVpo8AA@mail.gmail.com>
 <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
 <3b6bc24c8cd3f896dcd480ff75715a2bf9b2db06.camel@redhat.com> <8783dad64b0d41af9624f923cb4e4f03@AcuMS.aculab.com>
In-Reply-To: <8783dad64b0d41af9624f923cb4e4f03@AcuMS.aculab.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 3 May 2022 06:43:27 -0700
Message-ID: <CANn89iJE5anTbyLJ0TdGAqGsE+GichY3YzQECjNUVMz=G3bcQg@mail.gmail.com>
Subject: Re: [PATCH v2] net: rds: acquire refcount on TCP sockets
To:     David Laight <David.Laight@aculab.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>
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

On Tue, May 3, 2022 at 6:27 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Paolo Abeni
> > Sent: 03 May 2022 10:03
> >
> > Hello,
> >
> > On Mon, 2022-05-02 at 10:40 +0900, Tetsuo Handa wrote:
> > > syzbot is reporting use-after-free read in tcp_retransmit_timer() [1],
> > > for TCP socket used by RDS is accessing sock_net() without acquiring a
> > > refcount on net namespace. Since TCP's retransmission can happen after
> > > a process which created net namespace terminated, we need to explicitly
> > > acquire a refcount.
> > >
> > > Link: https://syzkaller.appspot.com/bug?extid=694120e1002c117747ed [1]
> > > Reported-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
> > > Fixes: 26abe14379f8e2fa ("net: Modify sk_alloc to not reference count the netns of kernel sockets.")
> > > Fixes: 8a68173691f03661 ("net: sk_clone_lock() should only do get_net() if the parent is not a
> > kernel socket")
> > > Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > > Tested-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
> > > ---
> > > Changes in v2:
> > >   Add Fixes: tag.
> > >   Move to inside lock_sock() section.
> > >
> > > I chose 26abe14379f8e2fa and 8a68173691f03661 which went to 4.2 for Fixes: tag,
> > > for refcount was implicitly taken when 70041088e3b97662 ("RDS: Add TCP transport
> > > to RDS") was added to 2.6.32.
> > >
> > >  net/rds/tcp.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > >
> > > diff --git a/net/rds/tcp.c b/net/rds/tcp.c
> > > index 5327d130c4b5..2f638f8b7b1e 100644
> > > --- a/net/rds/tcp.c
> > > +++ b/net/rds/tcp.c
> > > @@ -495,6 +495,14 @@ void rds_tcp_tune(struct socket *sock)
> > >
> > >     tcp_sock_set_nodelay(sock->sk);
> > >     lock_sock(sk);
> > > +   /* TCP timer functions might access net namespace even after
> > > +    * a process which created this net namespace terminated.
> > > +    */
> > > +   if (!sk->sk_net_refcnt) {
> > > +           sk->sk_net_refcnt = 1;
> > > +           get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
> > > +           sock_inuse_add(net, 1);
> > > +   }
> > >     if (rtn->sndbuf_size > 0) {
> > >             sk->sk_sndbuf = rtn->sndbuf_size;
> > >             sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
> >
> > This looks equivalent to the fix presented here:
> >
> > https://lore.kernel.org/all/CANn89i+484ffqb93aQm1N-tjxxvb3WDKX0EbD7318RwRgsatjw@mail.gmail.com/
> >
> > but the latter looks a more generic solution. @Tetsuo could you please
> > test the above in your setup?
>
> Wouldn't a more generic solution be to add a flag to sock_create_kern()
> so that it acquires a reference to the namespace?
> This could be a bit on one of the existing parameters - like SOCK_NONBLOCK.
>
> I've a driver that uses __sock_create() in order to get that reference.
> I'm pretty sure the extra 'security' check will never fail.
>

This would be silly really.

Definition of a 'kernel socket' is that it does not hold a reference
to the namespace.
(otherwise a netns could not be destroyed by user space)

A kernel layer using kernel sockets needs to properly dismantle them
when a namespace is destroyed.

In the RDS case, the socket was a user socket, or RDS lacked proper
tracking of all the sockets
so that they can be dismantled properly.
