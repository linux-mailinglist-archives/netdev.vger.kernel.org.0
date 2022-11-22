Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3957634B24
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 00:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbiKVXfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 18:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233625AbiKVXfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 18:35:24 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE4E748D0;
        Tue, 22 Nov 2022 15:35:23 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id r10-20020a4aa2ca000000b0049dd7ad4128so2477609ool.13;
        Tue, 22 Nov 2022 15:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nmqO32R0xh7ZwtHhKj+PuIQgHP1cIE3l41h8BA/283E=;
        b=MovYM6yqLsuCHsYDqEWpT0WYOSFrtK0W99CqSlrOfI0G/NuLEmyFKyp+YQ/gZPPYu6
         7tcJ9t2KrBu0imDHTLqPWoLmLnWEq5r3C2kTttUSHsrCLZ+6z1USnqDXFVrUB8Y78he8
         gcGdfQYusJC0A7ppRP9YXYiqgoSMbcKiDx5IGnJ11cPjB/VlsQlu1O9kBvQGOn6WxZxc
         sSH3R0e+0KDgOadKRnq+hUlQyBfY7aYJXLri0Qd1Q4f1bUIiGgMqs7LjDU5lQ6DEO2VE
         Kj9tJQbxDeTIbrHA/k20NbaK+aSb/N+BbWUu3CuPtijMM9i5WsBAcPoA7n4QhKwOKpRy
         Rw4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nmqO32R0xh7ZwtHhKj+PuIQgHP1cIE3l41h8BA/283E=;
        b=qhF0KlbR3s44SNviPUd7R/b+WV6JTuOnrYU2vno+U7q5g9X1kt2piN5c9msN72PWdp
         z6RA03D4OktQmHZWy08vyqFiyNG4Z5oNqoCiRwIVKBN+HFlpKsdU9ZpFNrXRQ6KBWOUw
         TXvhFhEFaJNtddXfHbzCT5bgNjU5u9Kvi0wj8LQCuh/RjV8Zmahpjh1vva/y1hG9DBLI
         k5u8L0mzQLydLCTmSN1+sdm3ZBfALfUrmF7hxKOYxjAP9O0Pa65gPL2Azt9aUwpJ83SO
         wo1h96RtWxD1xMFNV/eOLMZJjB6GKK1WG6FqvJd/1VJRKhLvl7OMNJZm46mVNilfigf0
         UbEA==
X-Gm-Message-State: ANoB5plGMe/grTw2af8Gew75odG6t6XoTZEv5CBKkrmXxZPTA+6AJWgL
        BJGmNvrVDT3rN5u8VldF+RM=
X-Google-Smtp-Source: AA0mqf5TcQlIlH/YLkZZHxScJOAd259RNQYxCxwpMO7+XwHDSao/s0XMef9TTr40FypJydb3qxFWUQ==
X-Received: by 2002:a4a:94a9:0:b0:480:8f4a:7062 with SMTP id k38-20020a4a94a9000000b004808f4a7062mr2778208ooi.57.1669160122267;
        Tue, 22 Nov 2022 15:35:22 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f016:5412:fa8e:2d33:bd7c:54c7])
        by smtp.gmail.com with ESMTPSA id n20-20020a9d6f14000000b00661a3f4113bsm6638845otq.64.2022.11.22.15.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 15:35:21 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 9920C459A37; Tue, 22 Nov 2022 20:35:19 -0300 (-03)
Date:   Tue, 22 Nov 2022 20:35:19 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Zhengchao Shao <shaozhengchao@huawei.com>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH net] sctp: fix memory leak in sctp_stream_outq_migrate()
Message-ID: <Y31ct/lSXNTm9ev9@t14s.localdomain>
References: <20221118085030.121297-1-shaozhengchao@huawei.com>
 <CADvbK_frWVFTSLMwC_xYvE+jDuk917K7SqZHUON3srLz8TxotQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_frWVFTSLMwC_xYvE+jDuk917K7SqZHUON3srLz8TxotQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 10:15:50PM -0500, Xin Long wrote:
> On Fri, Nov 18, 2022 at 3:48 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
> >
> > When sctp_stream_outq_migrate() is called to release stream out resources,
> > the memory pointed to by prio_head in stream out is not released.
> >
> > The memory leak information is as follows:
> > unreferenced object 0xffff88801fe79f80 (size 64):
> >   comm "sctp_repo", pid 7957, jiffies 4294951704 (age 36.480s)
> >   hex dump (first 32 bytes):
> >     80 9f e7 1f 80 88 ff ff 80 9f e7 1f 80 88 ff ff  ................
> >     90 9f e7 1f 80 88 ff ff 90 9f e7 1f 80 88 ff ff  ................
> >   backtrace:
> >     [<ffffffff81b215c6>] kmalloc_trace+0x26/0x60
> >     [<ffffffff88ae517c>] sctp_sched_prio_set+0x4cc/0x770
> >     [<ffffffff88ad64f2>] sctp_stream_init_ext+0xd2/0x1b0
> >     [<ffffffff88aa2604>] sctp_sendmsg_to_asoc+0x1614/0x1a30
> >     [<ffffffff88ab7ff1>] sctp_sendmsg+0xda1/0x1ef0
> >     [<ffffffff87f765ed>] inet_sendmsg+0x9d/0xe0
> >     [<ffffffff8754b5b3>] sock_sendmsg+0xd3/0x120
> >     [<ffffffff8755446a>] __sys_sendto+0x23a/0x340
> >     [<ffffffff87554651>] __x64_sys_sendto+0xe1/0x1b0
> >     [<ffffffff89978b49>] do_syscall_64+0x39/0xb0
> >     [<ffffffff89a0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > Fixes: 637784ade221 ("sctp: introduce priority based stream scheduler")
> > Reported-by: syzbot+29c402e56c4760763cc0@syzkaller.appspotmail.com
> > Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> > ---
> >  net/sctp/stream.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> > index ef9fceadef8d..a17dc368876f 100644
> > --- a/net/sctp/stream.c
> > +++ b/net/sctp/stream.c
> > @@ -70,6 +70,9 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
> >                  * sctp_stream_update will swap ->out pointers.
> >                  */
> >                 for (i = 0; i < outcnt; i++) {
> > +                       if (SCTP_SO(new, i)->ext)
> > +                               kfree(SCTP_SO(new, i)->ext->prio_head);
> > +
> >                         kfree(SCTP_SO(new, i)->ext);
> >                         SCTP_SO(new, i)->ext = SCTP_SO(stream, i)->ext;
> >                         SCTP_SO(stream, i)->ext = NULL;
> > @@ -77,6 +80,9 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
> >         }
> >
> >         for (i = outcnt; i < stream->outcnt; i++) {
> > +               if (SCTP_SO(stream, i)->ext)
> > +                       kfree(SCTP_SO(stream, i)->ext->prio_head);
> > +
> >                 kfree(SCTP_SO(stream, i)->ext);
> >                 SCTP_SO(stream, i)->ext = NULL;
> >         }
> > --
> > 2.17.1
> >
> This is not a proper fix:
> 1. you shouldn't access "prio_head" outside stream_sched_prio.c.
> 2. the prio_head you freed might be used by other out streams, freeing
> it unconditionally would cause either a double free or use after free.
> 
> I'm afraid we have to add a ".free_sid" in sctp_sched_ops, and
> implement it for sctp_sched_prio, like:
> 
> +static void sctp_sched_prio_free_sid(struct sctp_stream *stream, __u16 sid)
> +{
> +       struct sctp_stream_priorities *prio = SCTP_SO(stream,
> sid)->ext->prio_head;
> +       int i;
> +
> +       if (!prio)
> +               return;
> +
> +       SCTP_SO(stream, sid)->ext->prio_head = NULL;
> +       for (i = 0; i < stream->outcnt; i++) {

Instead of checking all streams, the for() can/should be replaced by
(from sctp_sched_prio_free):
	if (!list_empty(&prio->prio_sched))
		return;

> +               if (SCTP_SO(stream, i)->ext &&
> +                   SCTP_SO(stream, i)->ext->prio_head == prio)
> +                       return;
> +       }
> +       kfree(prio);
> +}
> +
>  static void sctp_sched_prio_free(struct sctp_stream *stream)
>  {
>         struct sctp_stream_priorities *prio, *n;
> @@ -323,6 +340,7 @@ static struct sctp_sched_ops sctp_sched_prio = {
>         .get = sctp_sched_prio_get,
>         .init = sctp_sched_prio_init,
>         .init_sid = sctp_sched_prio_init_sid,
> +       .free_sid = sctp_sched_prio_free_sid,
>         .free = sctp_sched_prio_free,
>         .enqueue = sctp_sched_prio_enqueue,
>         .dequeue = sctp_sched_prio_dequeue,
> 
> then call it in sctp_stream_outq_migrate(), like:
> 
> +static void sctp_stream_free_ext(struct sctp_stream *stream, __u16 sid)
> +{
> +       struct sctp_sched_ops *sched = sctp_sched_ops_from_stream(stream);
> +
> +       sched->free_sid(stream, sid);
> +       kfree(SCTP_SO(stream, sid)->ext);
> +       SCTP_SO(stream, sid)->ext = NULL;
> +}
> +
>  /* Migrates chunks from stream queues to new stream queues if needed,
>   * but not across associations. Also, removes those chunks to streams
>   * higher than the new max.
> @@ -70,16 +79,14 @@ static void sctp_stream_outq_migrate(struct
> sctp_stream *stream,
>                  * sctp_stream_update will swap ->out pointers.
>                  */
>                 for (i = 0; i < outcnt; i++) {
> -                       kfree(SCTP_SO(new, i)->ext);
> +                       sctp_stream_free_ext(new, i);
>                         SCTP_SO(new, i)->ext = SCTP_SO(stream, i)->ext;
>                         SCTP_SO(stream, i)->ext = NULL;
>                 }
>         }
> 
> -       for (i = outcnt; i < stream->outcnt; i++) {
> -               kfree(SCTP_SO(stream, i)->ext);
> -               SCTP_SO(stream, i)->ext = NULL;
> -       }
> +       for (i = outcnt; i < stream->outcnt; i++)
> +               sctp_stream_free_ext(new, i);
>  }
> 
> Marcelo, do you see a better solution?

No. Your suggestion is the best I could think of too.

Another approach would be to expose sched->free and do all the freeing
at once, like sctp_stream_free() does. But the above is looks cleaner
and makes it evident that freeing 'ext' is not trivial.

With the proposal above, sctp_sched_prio_free() becomes an
optimization, if we can call it that. With the for/if replacement
above, not even that, and should be removed. Including sctp_sched_ops
'free' pointer.

sctp_stream_free() then should be updated to use the new
sctp_stream_free_ext() instead, instead of mangling it directly.

Makes sense?

Thanks,
Marcelo
