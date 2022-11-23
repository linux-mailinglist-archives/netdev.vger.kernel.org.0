Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEE4636869
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 19:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239674AbiKWSOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 13:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238849AbiKWSNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 13:13:54 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E828A11A0F;
        Wed, 23 Nov 2022 10:10:48 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id a13-20020a9d6e8d000000b00668d65fc44fso11706585otr.9;
        Wed, 23 Nov 2022 10:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j6r0CC9TisfV7wm8BdBdWohmuoxOFNGRQTl2jwbJACo=;
        b=CgPoGiIG3pBrp7eujX56xc48VPf1EZn44oEbSpWQyQSdv6uFHhdJWy4d+cfIsMU9dU
         +y3T0Pg6+qapLPHu9jFJ9nROcc3eZrxISUrnnPwjkUYWQxJFwbmmghk3FwLikwLzRnKL
         pQYu4e7kBKSTt4JTTfd9iErXaDWaUCP6iiosBRzimlXDgsWO0pfTvOuM4rI7MFEv8w86
         nJQdeL7tfcOiPTJxMCTlMrJgpg0/f4T2OY+LO7rPuu4fiptcf/7VmR/OFUT8yS55XZ2l
         PJpDI0PwXC5+2u4eNtY62MG+cfRG+hP1RJKwacLydlFgrRfwyRiEb8rjZe0q7y6c7pQE
         CS+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j6r0CC9TisfV7wm8BdBdWohmuoxOFNGRQTl2jwbJACo=;
        b=nZ8G4FmeYFPH4XxI9VL1g5w0ugEoQqgwDBWpn5gycyRT3zB6IaAk7/CCtHT9r1h3/x
         TnndBhbrw5LMHtGFjSox2ORF+znD/F0AcZ/xNuqObwzx/XL7s1Dujfg4wv3Ujy2Yzmet
         sPTYn5aQzHYe8no8d9R0H8kB4YdradyGlAb34ZvgWFOzZdYfny5XDTapaQFsbwdEPK3h
         mJ//Ney/1OoUrVnwOlos4pgXrDrOShLUr0ShNU5isCfIEQJqf3eT4t1UyWm5vwV8G8TG
         jcK4NZOSW8qpAwiWZ6sfKdlo/uUinnYcZrEl/Cy3YdEZxqVsN5w0SwrimQdHEOddhYHI
         Uvyg==
X-Gm-Message-State: ANoB5pmDJaB2B2rysBJpp3AragMPCTm5dZN4kyDXxLPJnuVC+H+b59ek
        PPnifwTe51nFKgUdZ3FUjzQ=
X-Google-Smtp-Source: AA0mqf6/xIwU3vxvBKYK1+Ir4kN0laorPiDEZZHCpbZxLCoUhRYxgSVWtrEKrNn/KFz2Jdkbdg5cog==
X-Received: by 2002:a05:6830:13c9:b0:66c:a3a8:3870 with SMTP id e9-20020a05683013c900b0066ca3a83870mr5537218otq.54.1669227048082;
        Wed, 23 Nov 2022 10:10:48 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f016:5412:fa8e:2d33:bd7c:54c7])
        by smtp.gmail.com with ESMTPSA id q8-20020aca4308000000b0035b7002af8csm1665966oia.56.2022.11.23.10.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 10:10:47 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 633ED459D27; Wed, 23 Nov 2022 15:10:45 -0300 (-03)
Date:   Wed, 23 Nov 2022 15:10:45 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Zhengchao Shao <shaozhengchao@huawei.com>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH net] sctp: fix memory leak in sctp_stream_outq_migrate()
Message-ID: <Y35iJUx/Q/X01dNI@t14s.localdomain>
References: <20221118085030.121297-1-shaozhengchao@huawei.com>
 <CADvbK_frWVFTSLMwC_xYvE+jDuk917K7SqZHUON3srLz8TxotQ@mail.gmail.com>
 <Y31ct/lSXNTm9ev9@t14s.localdomain>
 <CADvbK_cVBVL1KKPsONv3A3m_mPA2-41uNwxz+9eM-EuQeCSygw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_cVBVL1KKPsONv3A3m_mPA2-41uNwxz+9eM-EuQeCSygw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 12:20:44PM -0500, Xin Long wrote:
> On Tue, Nov 22, 2022 at 6:35 PM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Fri, Nov 18, 2022 at 10:15:50PM -0500, Xin Long wrote:
> > > On Fri, Nov 18, 2022 at 3:48 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
> > > >
> > > > When sctp_stream_outq_migrate() is called to release stream out resources,
> > > > the memory pointed to by prio_head in stream out is not released.
> > > >
> > > > The memory leak information is as follows:
> > > > unreferenced object 0xffff88801fe79f80 (size 64):
> > > >   comm "sctp_repo", pid 7957, jiffies 4294951704 (age 36.480s)
> > > >   hex dump (first 32 bytes):
> > > >     80 9f e7 1f 80 88 ff ff 80 9f e7 1f 80 88 ff ff  ................
> > > >     90 9f e7 1f 80 88 ff ff 90 9f e7 1f 80 88 ff ff  ................
> > > >   backtrace:
> > > >     [<ffffffff81b215c6>] kmalloc_trace+0x26/0x60
> > > >     [<ffffffff88ae517c>] sctp_sched_prio_set+0x4cc/0x770
> > > >     [<ffffffff88ad64f2>] sctp_stream_init_ext+0xd2/0x1b0
> > > >     [<ffffffff88aa2604>] sctp_sendmsg_to_asoc+0x1614/0x1a30
> > > >     [<ffffffff88ab7ff1>] sctp_sendmsg+0xda1/0x1ef0
> > > >     [<ffffffff87f765ed>] inet_sendmsg+0x9d/0xe0
> > > >     [<ffffffff8754b5b3>] sock_sendmsg+0xd3/0x120
> > > >     [<ffffffff8755446a>] __sys_sendto+0x23a/0x340
> > > >     [<ffffffff87554651>] __x64_sys_sendto+0xe1/0x1b0
> > > >     [<ffffffff89978b49>] do_syscall_64+0x39/0xb0
> > > >     [<ffffffff89a0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > >
> > > > Fixes: 637784ade221 ("sctp: introduce priority based stream scheduler")
> > > > Reported-by: syzbot+29c402e56c4760763cc0@syzkaller.appspotmail.com
> > > > Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> > > > ---
> > > >  net/sctp/stream.c | 6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > >
> > > > diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> > > > index ef9fceadef8d..a17dc368876f 100644
> > > > --- a/net/sctp/stream.c
> > > > +++ b/net/sctp/stream.c
> > > > @@ -70,6 +70,9 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
> > > >                  * sctp_stream_update will swap ->out pointers.
> > > >                  */
> > > >                 for (i = 0; i < outcnt; i++) {
> > > > +                       if (SCTP_SO(new, i)->ext)
> > > > +                               kfree(SCTP_SO(new, i)->ext->prio_head);
> > > > +
> > > >                         kfree(SCTP_SO(new, i)->ext);
> > > >                         SCTP_SO(new, i)->ext = SCTP_SO(stream, i)->ext;
> > > >                         SCTP_SO(stream, i)->ext = NULL;
> > > > @@ -77,6 +80,9 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
> > > >         }
> > > >
> > > >         for (i = outcnt; i < stream->outcnt; i++) {
> > > > +               if (SCTP_SO(stream, i)->ext)
> > > > +                       kfree(SCTP_SO(stream, i)->ext->prio_head);
> > > > +
> > > >                 kfree(SCTP_SO(stream, i)->ext);
> > > >                 SCTP_SO(stream, i)->ext = NULL;
> > > >         }
> > > > --
> > > > 2.17.1
> > > >
> > > This is not a proper fix:
> > > 1. you shouldn't access "prio_head" outside stream_sched_prio.c.
> > > 2. the prio_head you freed might be used by other out streams, freeing
> > > it unconditionally would cause either a double free or use after free.
> > >
> > > I'm afraid we have to add a ".free_sid" in sctp_sched_ops, and
> > > implement it for sctp_sched_prio, like:
> > >
> > > +static void sctp_sched_prio_free_sid(struct sctp_stream *stream, __u16 sid)
> > > +{
> > > +       struct sctp_stream_priorities *prio = SCTP_SO(stream,
> > > sid)->ext->prio_head;
> > > +       int i;
> > > +
> > > +       if (!prio)
> > > +               return;
> > > +
> > > +       SCTP_SO(stream, sid)->ext->prio_head = NULL;
> > > +       for (i = 0; i < stream->outcnt; i++) {
> >
> > Instead of checking all streams, the for() can/should be replaced by
> > (from sctp_sched_prio_free):
> >         if (!list_empty(&prio->prio_sched))
> >                 return;
> sctp_stream_outq_migrate() is called after unsched_all() for "stream",
> list_empty(prio_sched) is expected to be true.

Good point. Am I missing something or the 'prio_head == prio' below
would always be false then as well?

Anyhow, as this is moving to something that can potentially be called
from other places afterwards, keeping the check doesn't hurt.

> 
> Note that kfree(SCTP_SO(new, i)->ext) shouldn't have the reported
> problem, as at that moment, the "new" stream hasn't been set
> stream_sched yet. It means there's only one place that needs to
> call free_sid in sctp_stream_outq_migrate().
> (Maybe Zhengchao can help us confirm this?)

That's the case in Tetsuo's patch (earlier today) as well. Yet, if we
have an official way to free a stream, if it's not error handling
during initialization, it should use it.

> 
> >
> > > +               if (SCTP_SO(stream, i)->ext &&
> > > +                   SCTP_SO(stream, i)->ext->prio_head == prio)
> > > +                       return;
> > > +       }
> > > +       kfree(prio);
> > > +}
> > > +
> > >  static void sctp_sched_prio_free(struct sctp_stream *stream)
> > >  {
> > >         struct sctp_stream_priorities *prio, *n;
> > > @@ -323,6 +340,7 @@ static struct sctp_sched_ops sctp_sched_prio = {
> > >         .get = sctp_sched_prio_get,
> > >         .init = sctp_sched_prio_init,
> > >         .init_sid = sctp_sched_prio_init_sid,
> > > +       .free_sid = sctp_sched_prio_free_sid,
> > >         .free = sctp_sched_prio_free,
> > >         .enqueue = sctp_sched_prio_enqueue,
> > >         .dequeue = sctp_sched_prio_dequeue,
> > >
> > > then call it in sctp_stream_outq_migrate(), like:
> > >
> > > +static void sctp_stream_free_ext(struct sctp_stream *stream, __u16 sid)
> > > +{
> > > +       struct sctp_sched_ops *sched = sctp_sched_ops_from_stream(stream);
> > > +
> > > +       sched->free_sid(stream, sid);
> > > +       kfree(SCTP_SO(stream, sid)->ext);
> > > +       SCTP_SO(stream, sid)->ext = NULL;
> > > +}
> > > +
> > >  /* Migrates chunks from stream queues to new stream queues if needed,
> > >   * but not across associations. Also, removes those chunks to streams
> > >   * higher than the new max.
> > > @@ -70,16 +79,14 @@ static void sctp_stream_outq_migrate(struct
> > > sctp_stream *stream,
> > >                  * sctp_stream_update will swap ->out pointers.
> > >                  */
> > >                 for (i = 0; i < outcnt; i++) {
> > > -                       kfree(SCTP_SO(new, i)->ext);
> > > +                       sctp_stream_free_ext(new, i);
> > >                         SCTP_SO(new, i)->ext = SCTP_SO(stream, i)->ext;
> > >                         SCTP_SO(stream, i)->ext = NULL;
> > >                 }
> > >         }
> > >
> > > -       for (i = outcnt; i < stream->outcnt; i++) {
> > > -               kfree(SCTP_SO(stream, i)->ext);
> > > -               SCTP_SO(stream, i)->ext = NULL;
> > > -       }
> > > +       for (i = outcnt; i < stream->outcnt; i++)
> > > +               sctp_stream_free_ext(new, i);
> > >  }
> > >
> > > Marcelo, do you see a better solution?
> >
> > No. Your suggestion is the best I could think of too.
> >
> > Another approach would be to expose sched->free and do all the freeing
> > at once, like sctp_stream_free() does. But the above is looks cleaner
> > and makes it evident that freeing 'ext' is not trivial.
> >
> > With the proposal above, sctp_sched_prio_free() becomes an
> > optimization, if we can call it that. With the for/if replacement
> > above, not even that, and should be removed. Including sctp_sched_ops
> > 'free' pointer.
> Or we extract the common code to another function, like
> sctp_sched_prio_free_head(stream, prio), and pass prio as
> NULL in sctp_sched_prio_free() for freeing all.
> 
> >
> > sctp_stream_free() then should be updated to use the new
> > sctp_stream_free_ext() instead, instead of mangling it directly.
> I thought about this, but there is ".free", which is more efficient
> to free all prio than calling ".free_sid" outcnt times.

How much more efficient, just by avoiding retpoline stuff on the
indirect functional call or something else?

> 
> I may move free_sid() out of sctp_stream_free_ext(), then in
> sctp_stream_free() we can call sctp_stream_free_ext() without
> calling free_sid(), or just remove sctp_stream_free_ext().

It's easier to maintain it if we have symmetric paths for initializing
and for freeing it and less special cases. We already have
sctp_stream_init_ext(), so having sctp_stream_free_ext() is not off.

I'm happy to review any patch that also updates sctp_stream_free(),
one way or another.

> 
> Thanks.
> 
> >
> > Makes sense?
> >
> > Thanks,
> > Marcelo
