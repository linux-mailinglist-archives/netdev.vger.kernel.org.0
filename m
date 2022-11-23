Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFB6F6368DF
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 19:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239672AbiKWSbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 13:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239221AbiKWSaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 13:30:52 -0500
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344B6627E;
        Wed, 23 Nov 2022 10:30:51 -0800 (PST)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-142faa7a207so8981372fac.13;
        Wed, 23 Nov 2022 10:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yby3XAcpsjPZi0VSkOYnNY2Kmmja1GFipzDWM2IqziE=;
        b=jZKFhSLS9GuPYdF9MXCnxBZftCycuW53+l/t8llBoFJLAZCmgLQbFJxiQxEew778zk
         kOQytgRE+AziafxCJInbKfC2gof4HTASy9giKBi1bT/ge0tenEbiQYdl1dtXqI8bfNGJ
         OiTgGzuTNa49lp50o7HZsmfewBC+c5WqMSZY3Ts0sb0+qD85+CnpF2ItjYAHXcklTm+/
         GO9lQmkxWiGHW4LXpb7Yfxf98qG8zDPEx+Kj8RA6O+AhQ4gUQHlFaCXbKmJJQ7f4yw+U
         R+DfYsFj1SgqPozNFfdKBFdNukA35JYngPN52xlce8NsrE5cFkkM6Rt2w5JrYPvOrk15
         j+7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yby3XAcpsjPZi0VSkOYnNY2Kmmja1GFipzDWM2IqziE=;
        b=IomWHgAt6eXQM9EcYCqzZxKu6xnZRHJpEc3FFkK5X6Te8+I3HxwTgsILNHGno82aN9
         l4UCc3PwYUbu62c8grRu9n73NyWpPUxhaAv7yQKuKGzDw/ACY0rc6SqAvJNHmxhaR1of
         nhnLmsK1Uayhal7GLFOJfzQ9EnD45pYMLwkJDf2+8xp+lqV0NSdtDr6lOcy+zA69oG/j
         /8Es2XNRbeiMf33RQzlkzsHLG10uolsSIUnpqVlCJzdTOS1qnwk0iMETrg4IoThanVQ/
         sFCz96lFkxtiizUza2hmH0EIHni5G8dg3U2roHIEo+lioWLQbh5XaYXBW+bqLakcygJ9
         DM1g==
X-Gm-Message-State: ANoB5pm9c30zmsArcqpsjcPOKi61jnaJQ8WutzhlIu12xoo/YBwnNBEH
        Ozbymg4pyL6COXcLcvRuHRpv/ZamRAOEf3NFel8=
X-Google-Smtp-Source: AA0mqf6pJyn7b2lFfRT7ugKtQxflgB/tJ1ehlGj0vaR1T39lzH8atG3MQ2cNDo2LSbDU8X2Ul+oh5vibw0ggwKmx/Bk=
X-Received: by 2002:a05:6871:4494:b0:142:6cb4:8b3a with SMTP id
 ne20-20020a056871449400b001426cb48b3amr6754896oab.190.1669228250528; Wed, 23
 Nov 2022 10:30:50 -0800 (PST)
MIME-Version: 1.0
References: <20221118085030.121297-1-shaozhengchao@huawei.com>
 <CADvbK_frWVFTSLMwC_xYvE+jDuk917K7SqZHUON3srLz8TxotQ@mail.gmail.com>
 <Y31ct/lSXNTm9ev9@t14s.localdomain> <CADvbK_cVBVL1KKPsONv3A3m_mPA2-41uNwxz+9eM-EuQeCSygw@mail.gmail.com>
 <Y35iJUx/Q/X01dNI@t14s.localdomain>
In-Reply-To: <Y35iJUx/Q/X01dNI@t14s.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 23 Nov 2022 13:30:11 -0500
Message-ID: <CADvbK_dDJpyY2xUmEyv+z2B77=N8fcUQsVyqZUORoE6UO7DAdw@mail.gmail.com>
Subject: Re: [PATCH net] sctp: fix memory leak in sctp_stream_outq_migrate()
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Zhengchao Shao <shaozhengchao@huawei.com>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
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

(

On Wed, Nov 23, 2022 at 1:10 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Wed, Nov 23, 2022 at 12:20:44PM -0500, Xin Long wrote:
> > On Tue, Nov 22, 2022 at 6:35 PM Marcelo Ricardo Leitner
> > <marcelo.leitner@gmail.com> wrote:
> > >
> > > On Fri, Nov 18, 2022 at 10:15:50PM -0500, Xin Long wrote:
> > > > On Fri, Nov 18, 2022 at 3:48 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
> > > > >
> > > > > When sctp_stream_outq_migrate() is called to release stream out resources,
> > > > > the memory pointed to by prio_head in stream out is not released.
> > > > >
> > > > > The memory leak information is as follows:
> > > > > unreferenced object 0xffff88801fe79f80 (size 64):
> > > > >   comm "sctp_repo", pid 7957, jiffies 4294951704 (age 36.480s)
> > > > >   hex dump (first 32 bytes):
> > > > >     80 9f e7 1f 80 88 ff ff 80 9f e7 1f 80 88 ff ff  ................
> > > > >     90 9f e7 1f 80 88 ff ff 90 9f e7 1f 80 88 ff ff  ................
> > > > >   backtrace:
> > > > >     [<ffffffff81b215c6>] kmalloc_trace+0x26/0x60
> > > > >     [<ffffffff88ae517c>] sctp_sched_prio_set+0x4cc/0x770
> > > > >     [<ffffffff88ad64f2>] sctp_stream_init_ext+0xd2/0x1b0
> > > > >     [<ffffffff88aa2604>] sctp_sendmsg_to_asoc+0x1614/0x1a30
> > > > >     [<ffffffff88ab7ff1>] sctp_sendmsg+0xda1/0x1ef0
> > > > >     [<ffffffff87f765ed>] inet_sendmsg+0x9d/0xe0
> > > > >     [<ffffffff8754b5b3>] sock_sendmsg+0xd3/0x120
> > > > >     [<ffffffff8755446a>] __sys_sendto+0x23a/0x340
> > > > >     [<ffffffff87554651>] __x64_sys_sendto+0xe1/0x1b0
> > > > >     [<ffffffff89978b49>] do_syscall_64+0x39/0xb0
> > > > >     [<ffffffff89a0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > > >
> > > > > Fixes: 637784ade221 ("sctp: introduce priority based stream scheduler")
> > > > > Reported-by: syzbot+29c402e56c4760763cc0@syzkaller.appspotmail.com
> > > > > Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> > > > > ---
> > > > >  net/sctp/stream.c | 6 ++++++
> > > > >  1 file changed, 6 insertions(+)
> > > > >
> > > > > diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> > > > > index ef9fceadef8d..a17dc368876f 100644
> > > > > --- a/net/sctp/stream.c
> > > > > +++ b/net/sctp/stream.c
> > > > > @@ -70,6 +70,9 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
> > > > >                  * sctp_stream_update will swap ->out pointers.
> > > > >                  */
> > > > >                 for (i = 0; i < outcnt; i++) {
> > > > > +                       if (SCTP_SO(new, i)->ext)
> > > > > +                               kfree(SCTP_SO(new, i)->ext->prio_head);
> > > > > +
> > > > >                         kfree(SCTP_SO(new, i)->ext);
> > > > >                         SCTP_SO(new, i)->ext = SCTP_SO(stream, i)->ext;
> > > > >                         SCTP_SO(stream, i)->ext = NULL;
> > > > > @@ -77,6 +80,9 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
> > > > >         }
> > > > >
> > > > >         for (i = outcnt; i < stream->outcnt; i++) {
> > > > > +               if (SCTP_SO(stream, i)->ext)
> > > > > +                       kfree(SCTP_SO(stream, i)->ext->prio_head);
> > > > > +
> > > > >                 kfree(SCTP_SO(stream, i)->ext);
> > > > >                 SCTP_SO(stream, i)->ext = NULL;
> > > > >         }
> > > > > --
> > > > > 2.17.1
> > > > >
> > > > This is not a proper fix:
> > > > 1. you shouldn't access "prio_head" outside stream_sched_prio.c.
> > > > 2. the prio_head you freed might be used by other out streams, freeing
> > > > it unconditionally would cause either a double free or use after free.
> > > >
> > > > I'm afraid we have to add a ".free_sid" in sctp_sched_ops, and
> > > > implement it for sctp_sched_prio, like:
> > > >
> > > > +static void sctp_sched_prio_free_sid(struct sctp_stream *stream, __u16 sid)
> > > > +{
> > > > +       struct sctp_stream_priorities *prio = SCTP_SO(stream,
> > > > sid)->ext->prio_head;
> > > > +       int i;
> > > > +
> > > > +       if (!prio)
> > > > +               return;
> > > > +
> > > > +       SCTP_SO(stream, sid)->ext->prio_head = NULL;
> > > > +       for (i = 0; i < stream->outcnt; i++) {
> > >
> > > Instead of checking all streams, the for() can/should be replaced by
> > > (from sctp_sched_prio_free):
> > >         if (!list_empty(&prio->prio_sched))
> > >                 return;
> > sctp_stream_outq_migrate() is called after unsched_all() for "stream",
> > list_empty(prio_sched) is expected to be true.
>
> Good point. Am I missing something or the 'prio_head == prio' below
> would always be false then as well?
>
> Anyhow, as this is moving to something that can potentially be called
> from other places afterwards, keeping the check doesn't hurt.
>
> >
> > Note that kfree(SCTP_SO(new, i)->ext) shouldn't have the reported
> > problem, as at that moment, the "new" stream hasn't been set
> > stream_sched yet. It means there's only one place that needs to
> > call free_sid in sctp_stream_outq_migrate().
> > (Maybe Zhengchao can help us confirm this?)
>
> That's the case in Tetsuo's patch (earlier today) as well. Yet, if we
> have an official way to free a stream, if it's not error handling
> during initialization, it should use it.
right.

>
> >
> > >
> > > > +               if (SCTP_SO(stream, i)->ext &&
> > > > +                   SCTP_SO(stream, i)->ext->prio_head == prio)
> > > > +                       return;
> > > > +       }
> > > > +       kfree(prio);
> > > > +}
> > > > +
> > > >  static void sctp_sched_prio_free(struct sctp_stream *stream)
> > > >  {
> > > >         struct sctp_stream_priorities *prio, *n;
> > > > @@ -323,6 +340,7 @@ static struct sctp_sched_ops sctp_sched_prio = {
> > > >         .get = sctp_sched_prio_get,
> > > >         .init = sctp_sched_prio_init,
> > > >         .init_sid = sctp_sched_prio_init_sid,
> > > > +       .free_sid = sctp_sched_prio_free_sid,
> > > >         .free = sctp_sched_prio_free,
> > > >         .enqueue = sctp_sched_prio_enqueue,
> > > >         .dequeue = sctp_sched_prio_dequeue,
> > > >
> > > > then call it in sctp_stream_outq_migrate(), like:
> > > >
> > > > +static void sctp_stream_free_ext(struct sctp_stream *stream, __u16 sid)
> > > > +{
> > > > +       struct sctp_sched_ops *sched = sctp_sched_ops_from_stream(stream);
> > > > +
> > > > +       sched->free_sid(stream, sid);
> > > > +       kfree(SCTP_SO(stream, sid)->ext);
> > > > +       SCTP_SO(stream, sid)->ext = NULL;
> > > > +}
> > > > +
> > > >  /* Migrates chunks from stream queues to new stream queues if needed,
> > > >   * but not across associations. Also, removes those chunks to streams
> > > >   * higher than the new max.
> > > > @@ -70,16 +79,14 @@ static void sctp_stream_outq_migrate(struct
> > > > sctp_stream *stream,
> > > >                  * sctp_stream_update will swap ->out pointers.
> > > >                  */
> > > >                 for (i = 0; i < outcnt; i++) {
> > > > -                       kfree(SCTP_SO(new, i)->ext);
> > > > +                       sctp_stream_free_ext(new, i);
> > > >                         SCTP_SO(new, i)->ext = SCTP_SO(stream, i)->ext;
> > > >                         SCTP_SO(stream, i)->ext = NULL;
> > > >                 }
> > > >         }
> > > >
> > > > -       for (i = outcnt; i < stream->outcnt; i++) {
> > > > -               kfree(SCTP_SO(stream, i)->ext);
> > > > -               SCTP_SO(stream, i)->ext = NULL;
> > > > -       }
> > > > +       for (i = outcnt; i < stream->outcnt; i++)
> > > > +               sctp_stream_free_ext(new, i);
> > > >  }
> > > >
> > > > Marcelo, do you see a better solution?
> > >
> > > No. Your suggestion is the best I could think of too.
> > >
> > > Another approach would be to expose sched->free and do all the freeing
> > > at once, like sctp_stream_free() does. But the above is looks cleaner
> > > and makes it evident that freeing 'ext' is not trivial.
> > >
> > > With the proposal above, sctp_sched_prio_free() becomes an
> > > optimization, if we can call it that. With the for/if replacement
> > > above, not even that, and should be removed. Including sctp_sched_ops
> > > 'free' pointer.
> > Or we extract the common code to another function, like
> > sctp_sched_prio_free_head(stream, prio), and pass prio as
> > NULL in sctp_sched_prio_free() for freeing all.
> >
> > >
> > > sctp_stream_free() then should be updated to use the new
> > > sctp_stream_free_ext() instead, instead of mangling it directly.
> > I thought about this, but there is ".free", which is more efficient
> > to free all prio than calling ".free_sid" outcnt times.
>
> How much more efficient, just by avoiding retpoline stuff on the
> indirect functional call or something else?

in sctp_stream_free():
.free() will be called one time to free all prios
while .free_sid will be called in a loop to  free all prios:
        for (i = 0; i < stream->outcnt; i++)
               .free_sid(stream, i);

inside either() .free or . free_sid() there is another loop:
for (i = 0; i < stream->outcnt; i++)
    ...

That's why I said using .free() in sctp_stream_free() will be more efficient.

>
> >
> > I may move free_sid() out of sctp_stream_free_ext(), then in
> > sctp_stream_free() we can call sctp_stream_free_ext() without
> > calling free_sid(), or just remove sctp_stream_free_ext().
>
> It's easier to maintain it if we have symmetric paths for initializing
> and for freeing it and less special cases. We already have
> sctp_stream_init_ext(), so having sctp_stream_free_ext() is not off.
didn't notice init_sid in sctp_stream_init_ext(), it makes sense to
have free_sid in sctp_stream_free_ext().

Thanks.

>
> I'm happy to review any patch that also updates sctp_stream_free(),
> one way or another.
>
> >
> > Thanks.
> >
> > >
> > > Makes sense?
> > >
> > > Thanks,
> > > Marcelo
