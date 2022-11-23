Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA626366E2
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 18:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236717AbiKWRV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 12:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236038AbiKWRVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 12:21:25 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5B8742E7;
        Wed, 23 Nov 2022 09:21:24 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id t19-20020a9d7753000000b0066d77a3d474so11610217otl.10;
        Wed, 23 Nov 2022 09:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fDEMS5yeehB25qFHdTGxrrgDnBxGLxhe75Cpq64CCpI=;
        b=X7Gd7zgCawPhlCOdJNevGyE2PGQrjm8Mq7mrmiJATmi6Oi0ZCby+/rjFxgcsPdAYEL
         3pT78nLz0gMbw5K5Ry9U5zyQ2MsMKxPifhdEedZAUpzd2byr4ipmGI6S1A334tZ/A57D
         Fk9uq57BYG6Y+DRaJsKi55m4PeVq/GID12Ie8SKuENTsW6nkpCXEr1JTr0+YsOk6SVMN
         sCFwJk/jgSmGn/lwtFBEN3+B+onRIKZhLTgeCzTmjXMRqVvN1xCB8OQqeA4BIOlcqGJK
         GbMn/Gr+2kAdcKilRoJYTHtj47JHNclMkuEoWmxvrOLlZMeS4CsPXNfQzXNNjFcgJh5w
         5+8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fDEMS5yeehB25qFHdTGxrrgDnBxGLxhe75Cpq64CCpI=;
        b=6qJx0s9NNgJcXuy1wo6cxpIA0Q+5TfVKKgBlpvhtMP8HODx/TVoQv+0y5pUaCxxDId
         0uDYD1IM1H1+yZqOU5e579MyIMHPd3zn2qKtniGSyjUcX0Y6+CyN3J1GarnsBSkV8l1X
         pim2VsVZCOCx6hmLFR2lRqpcTNc27GY92BhsYih+YQ/adFETAuQc18Hu7a4/3DHfeguF
         zZvqgvk6RXbFk4OwmGozlEylYLhPCW3lWqjlKoW6zq3tffEKT/JcYgS9FO6GYnh2YQTR
         or0Ko2lvq0fGRagdCuG+ggey4byEkKmhiCaxae6QckNsUBtH8DXH0ZCulUSu+5SsTxwd
         Rrww==
X-Gm-Message-State: ANoB5pkwYlD36rI4t7qHLlwRx6fnyrXamSwyjkq5jSJJNPJ0sp5wJz12
        pcpMutPsHW9mQH1Fs+RKMY/AnfLB49OZfKpMzS8=
X-Google-Smtp-Source: AA0mqf6aJgsq+AjIEX6trEV8qyD+3o6n78fJCJWtHba1TO5MEIGuMweHL/hAFzKgOB6Bo3SHrH4OZbyzrWv/+C+bPaU=
X-Received: by 2002:a05:6830:4b:b0:66c:50ce:2a2f with SMTP id
 d11-20020a056830004b00b0066c50ce2a2fmr15909329otp.46.1669224083983; Wed, 23
 Nov 2022 09:21:23 -0800 (PST)
MIME-Version: 1.0
References: <20221118085030.121297-1-shaozhengchao@huawei.com>
 <CADvbK_frWVFTSLMwC_xYvE+jDuk917K7SqZHUON3srLz8TxotQ@mail.gmail.com> <Y31ct/lSXNTm9ev9@t14s.localdomain>
In-Reply-To: <Y31ct/lSXNTm9ev9@t14s.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 23 Nov 2022 12:20:44 -0500
Message-ID: <CADvbK_cVBVL1KKPsONv3A3m_mPA2-41uNwxz+9eM-EuQeCSygw@mail.gmail.com>
Subject: Re: [PATCH net] sctp: fix memory leak in sctp_stream_outq_migrate()
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Zhengchao Shao <shaozhengchao@huawei.com>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
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

On Tue, Nov 22, 2022 at 6:35 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Fri, Nov 18, 2022 at 10:15:50PM -0500, Xin Long wrote:
> > On Fri, Nov 18, 2022 at 3:48 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
> > >
> > > When sctp_stream_outq_migrate() is called to release stream out resources,
> > > the memory pointed to by prio_head in stream out is not released.
> > >
> > > The memory leak information is as follows:
> > > unreferenced object 0xffff88801fe79f80 (size 64):
> > >   comm "sctp_repo", pid 7957, jiffies 4294951704 (age 36.480s)
> > >   hex dump (first 32 bytes):
> > >     80 9f e7 1f 80 88 ff ff 80 9f e7 1f 80 88 ff ff  ................
> > >     90 9f e7 1f 80 88 ff ff 90 9f e7 1f 80 88 ff ff  ................
> > >   backtrace:
> > >     [<ffffffff81b215c6>] kmalloc_trace+0x26/0x60
> > >     [<ffffffff88ae517c>] sctp_sched_prio_set+0x4cc/0x770
> > >     [<ffffffff88ad64f2>] sctp_stream_init_ext+0xd2/0x1b0
> > >     [<ffffffff88aa2604>] sctp_sendmsg_to_asoc+0x1614/0x1a30
> > >     [<ffffffff88ab7ff1>] sctp_sendmsg+0xda1/0x1ef0
> > >     [<ffffffff87f765ed>] inet_sendmsg+0x9d/0xe0
> > >     [<ffffffff8754b5b3>] sock_sendmsg+0xd3/0x120
> > >     [<ffffffff8755446a>] __sys_sendto+0x23a/0x340
> > >     [<ffffffff87554651>] __x64_sys_sendto+0xe1/0x1b0
> > >     [<ffffffff89978b49>] do_syscall_64+0x39/0xb0
> > >     [<ffffffff89a0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > >
> > > Fixes: 637784ade221 ("sctp: introduce priority based stream scheduler")
> > > Reported-by: syzbot+29c402e56c4760763cc0@syzkaller.appspotmail.com
> > > Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> > > ---
> > >  net/sctp/stream.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >
> > > diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> > > index ef9fceadef8d..a17dc368876f 100644
> > > --- a/net/sctp/stream.c
> > > +++ b/net/sctp/stream.c
> > > @@ -70,6 +70,9 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
> > >                  * sctp_stream_update will swap ->out pointers.
> > >                  */
> > >                 for (i = 0; i < outcnt; i++) {
> > > +                       if (SCTP_SO(new, i)->ext)
> > > +                               kfree(SCTP_SO(new, i)->ext->prio_head);
> > > +
> > >                         kfree(SCTP_SO(new, i)->ext);
> > >                         SCTP_SO(new, i)->ext = SCTP_SO(stream, i)->ext;
> > >                         SCTP_SO(stream, i)->ext = NULL;
> > > @@ -77,6 +80,9 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
> > >         }
> > >
> > >         for (i = outcnt; i < stream->outcnt; i++) {
> > > +               if (SCTP_SO(stream, i)->ext)
> > > +                       kfree(SCTP_SO(stream, i)->ext->prio_head);
> > > +
> > >                 kfree(SCTP_SO(stream, i)->ext);
> > >                 SCTP_SO(stream, i)->ext = NULL;
> > >         }
> > > --
> > > 2.17.1
> > >
> > This is not a proper fix:
> > 1. you shouldn't access "prio_head" outside stream_sched_prio.c.
> > 2. the prio_head you freed might be used by other out streams, freeing
> > it unconditionally would cause either a double free or use after free.
> >
> > I'm afraid we have to add a ".free_sid" in sctp_sched_ops, and
> > implement it for sctp_sched_prio, like:
> >
> > +static void sctp_sched_prio_free_sid(struct sctp_stream *stream, __u16 sid)
> > +{
> > +       struct sctp_stream_priorities *prio = SCTP_SO(stream,
> > sid)->ext->prio_head;
> > +       int i;
> > +
> > +       if (!prio)
> > +               return;
> > +
> > +       SCTP_SO(stream, sid)->ext->prio_head = NULL;
> > +       for (i = 0; i < stream->outcnt; i++) {
>
> Instead of checking all streams, the for() can/should be replaced by
> (from sctp_sched_prio_free):
>         if (!list_empty(&prio->prio_sched))
>                 return;
sctp_stream_outq_migrate() is called after unsched_all() for "stream",
list_empty(prio_sched) is expected to be true.

Note that kfree(SCTP_SO(new, i)->ext) shouldn't have the reported
problem, as at that moment, the "new" stream hasn't been set
stream_sched yet. It means there's only one place that needs to
call free_sid in sctp_stream_outq_migrate().
(Maybe Zhengchao can help us confirm this?)

>
> > +               if (SCTP_SO(stream, i)->ext &&
> > +                   SCTP_SO(stream, i)->ext->prio_head == prio)
> > +                       return;
> > +       }
> > +       kfree(prio);
> > +}
> > +
> >  static void sctp_sched_prio_free(struct sctp_stream *stream)
> >  {
> >         struct sctp_stream_priorities *prio, *n;
> > @@ -323,6 +340,7 @@ static struct sctp_sched_ops sctp_sched_prio = {
> >         .get = sctp_sched_prio_get,
> >         .init = sctp_sched_prio_init,
> >         .init_sid = sctp_sched_prio_init_sid,
> > +       .free_sid = sctp_sched_prio_free_sid,
> >         .free = sctp_sched_prio_free,
> >         .enqueue = sctp_sched_prio_enqueue,
> >         .dequeue = sctp_sched_prio_dequeue,
> >
> > then call it in sctp_stream_outq_migrate(), like:
> >
> > +static void sctp_stream_free_ext(struct sctp_stream *stream, __u16 sid)
> > +{
> > +       struct sctp_sched_ops *sched = sctp_sched_ops_from_stream(stream);
> > +
> > +       sched->free_sid(stream, sid);
> > +       kfree(SCTP_SO(stream, sid)->ext);
> > +       SCTP_SO(stream, sid)->ext = NULL;
> > +}
> > +
> >  /* Migrates chunks from stream queues to new stream queues if needed,
> >   * but not across associations. Also, removes those chunks to streams
> >   * higher than the new max.
> > @@ -70,16 +79,14 @@ static void sctp_stream_outq_migrate(struct
> > sctp_stream *stream,
> >                  * sctp_stream_update will swap ->out pointers.
> >                  */
> >                 for (i = 0; i < outcnt; i++) {
> > -                       kfree(SCTP_SO(new, i)->ext);
> > +                       sctp_stream_free_ext(new, i);
> >                         SCTP_SO(new, i)->ext = SCTP_SO(stream, i)->ext;
> >                         SCTP_SO(stream, i)->ext = NULL;
> >                 }
> >         }
> >
> > -       for (i = outcnt; i < stream->outcnt; i++) {
> > -               kfree(SCTP_SO(stream, i)->ext);
> > -               SCTP_SO(stream, i)->ext = NULL;
> > -       }
> > +       for (i = outcnt; i < stream->outcnt; i++)
> > +               sctp_stream_free_ext(new, i);
> >  }
> >
> > Marcelo, do you see a better solution?
>
> No. Your suggestion is the best I could think of too.
>
> Another approach would be to expose sched->free and do all the freeing
> at once, like sctp_stream_free() does. But the above is looks cleaner
> and makes it evident that freeing 'ext' is not trivial.
>
> With the proposal above, sctp_sched_prio_free() becomes an
> optimization, if we can call it that. With the for/if replacement
> above, not even that, and should be removed. Including sctp_sched_ops
> 'free' pointer.
Or we extract the common code to another function, like
sctp_sched_prio_free_head(stream, prio), and pass prio as
NULL in sctp_sched_prio_free() for freeing all.

>
> sctp_stream_free() then should be updated to use the new
> sctp_stream_free_ext() instead, instead of mangling it directly.
I thought about this, but there is ".free", which is more efficient
to free all prio than calling ".free_sid" outcnt times.

I may move free_sid() out of sctp_stream_free_ext(), then in
sctp_stream_free() we can call sctp_stream_free_ext() without
calling free_sid(), or just remove sctp_stream_free_ext().

Thanks.

>
> Makes sense?
>
> Thanks,
> Marcelo
