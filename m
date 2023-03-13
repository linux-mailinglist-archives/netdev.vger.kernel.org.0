Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D196B78A3
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 14:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjCMNQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 09:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjCMNQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 09:16:07 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465952A172;
        Mon, 13 Mar 2023 06:16:05 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id j11so48569748edq.4;
        Mon, 13 Mar 2023 06:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678713364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qy+YS68/6ftY+Izh4xyJcJqKqdESz2LS/MZ0geP5yPA=;
        b=YnuuOHAYq1T+ZvSgf2QAedSw5b5Xr0j6v9e8XSa18yrLb2jlA/cwfLTDYEv74eo3/J
         +o+5gif4mY1RZvvlvX2pgC/wRkatMEaFhhrMxhgFqE8ab3zYi9vyn7MIwHLzHjOFy1dr
         QbrXp6vun4ehCQNGRAyp1VhxjG0KTW0ymgVxpkNpwGsGR6PimFd3ZKZu+QcQBNNoqGk6
         0Vb+0BOjXbgJSk6J+4rRsTCZmxqZpOHG37WL0YKIUiL/xFYJRPBasw3x+0s6qhm3Qern
         kzBD5BXqZgNsuTl8qxJwJfB/JBqiiH0SGgp7C7Umm+AtTiACVVz81KIEhu9avIe6JasJ
         nkYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678713364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qy+YS68/6ftY+Izh4xyJcJqKqdESz2LS/MZ0geP5yPA=;
        b=JQAzxiDTFXUA3Sw8YXcgETq6W4rwN9Ohf2wwz1W+pWZNXrz44RPNdbw5FoeCu9PchY
         H4w7YgLK1syocC/eOe8RfZSHX6bxvI8dZykk7IM2gXLbHJO+Z8FWYbnOb0nca4nQlaW5
         aZbiFxfvDy+MqUHBDLbBFB0JCX/M8hgyUyzTd6P0hkJ/vepdncmriUrMIjAvTeHpoPFp
         fY26rbXg9N8C4rWsszNdJx9i/UIefqr9wwZ4Ih2Z2EfiE64ZFigQyiQZ0w8sjkDb3cV1
         8jZX5SDgNP/JgoUAmUN+JsKCQkRMDKUlzgsvYba7T64z+AlcUs8e6wx8L1KSUmFPpgGp
         0bpQ==
X-Gm-Message-State: AO0yUKW9/2k1e/II2GguXWuMuXlE9SsSJyzkXTVL/HVNSaNyXkjuvtsJ
        WiBZJX72Djt1hr8wYw/iFoqUiVDJZKCuF6w1UqQ=
X-Google-Smtp-Source: AK7set/ijfRMDLlYd+8w9hfgR1/DCZnCowu3rqEJL5mX6JUz8GNk2PObZFFeIxC0FLdRrEvqkxYMWv+3xKGMCu6ZwLM=
X-Received: by 2002:a17:906:60f:b0:8dd:70a:3a76 with SMTP id
 s15-20020a170906060f00b008dd070a3a76mr17904962ejb.11.1678713363722; Mon, 13
 Mar 2023 06:16:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230311151756.83302-1-kerneljasonxing@gmail.com> <CANn89iKWewG7JZXQ=bmab9rSXUs_P5fX-BQ792QjYuH151DV-g@mail.gmail.com>
In-Reply-To: <CANn89iKWewG7JZXQ=bmab9rSXUs_P5fX-BQ792QjYuH151DV-g@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Mon, 13 Mar 2023 21:15:27 +0800
Message-ID: <CAL+tcoAchbTk9ibrAVH-bZ-0KHJ8g3XnsQHFWiBosyNgYJtymA@mail.gmail.com>
Subject: Re: [PATCH net-next] net-sysfs: display two backlog queue len separately
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 8:34=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Sat, Mar 11, 2023 at 7:18=E2=80=AFAM Jason Xing <kerneljasonxing@gmail=
.com> wrote:
> >
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > Sometimes we need to know which one of backlog queue can be exactly
> > long enough to cause some latency when debugging this part is needed.
> > Thus, we can then separate the display of both.
> >
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > ---
> >  net/core/net-procfs.c | 17 ++++++++++++-----
> >  1 file changed, 12 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
> > index 1ec23bf8b05c..97a304e1957a 100644
> > --- a/net/core/net-procfs.c
> > +++ b/net/core/net-procfs.c
> > @@ -115,10 +115,14 @@ static int dev_seq_show(struct seq_file *seq, voi=
d *v)
> >         return 0;
> >  }
> >
> > -static u32 softnet_backlog_len(struct softnet_data *sd)
> > +static u32 softnet_input_pkt_queue_len(struct softnet_data *sd)
> >  {
> > -       return skb_queue_len_lockless(&sd->input_pkt_queue) +
> > -              skb_queue_len_lockless(&sd->process_queue);
> > +       return skb_queue_len_lockless(&sd->input_pkt_queue);
> > +}
> > +
> > +static u32 softnet_process_queue_len(struct softnet_data *sd)
> > +{
> > +       return skb_queue_len_lockless(&sd->process_queue);
> >  }
> >
> >  static struct softnet_data *softnet_get_online(loff_t *pos)
> > @@ -169,12 +173,15 @@ static int softnet_seq_show(struct seq_file *seq,=
 void *v)
> >          * mapping the data a specific CPU
> >          */
> >         seq_printf(seq,
> > -                  "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %=
08x %08x %08x\n",
> > +                  "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %=
08x %08x %08x "
> > +                  "%08x %08x\n",
> >                    sd->processed, sd->dropped, sd->time_squeeze, 0,
> >                    0, 0, 0, 0, /* was fastroute */
> >                    0,   /* was cpu_collision */
> >                    sd->received_rps, flow_limit_count,
> > -                  softnet_backlog_len(sd), (int)seq->index);
> > +                  0,   /* was len of two backlog queues */
>
> You can not pretend the sum is zero, some user space tools out there
> would be fooled.
>
> > +                  (int)seq->index,
> > +                  softnet_input_pkt_queue_len(sd), softnet_process_que=
ue_len(sd));
> >         return 0;
> >  }
> >
> > --
> > 2.37.3
> >
>
> In general I would prefer we no longer change this file.

Fine. Since now, let this legacy file be one part of history.

>
> Perhaps add a tracepoint instead ?

Thanks, Eric. It's one good idea. It seems acceptable if we only need
to trace two separate backlog queues where it can probably hit the
limit, say, in the enqueue_to_backlog().

Similarly I decide to write another two tracepoints of time_squeeze
and budget_squeeze which I introduced to distinguish from time_squeeze
as the below link shows:
https://lore.kernel.org/lkml/CAL+tcoAwodpnE2NjMLPhBbmHUvmKMgSykqx0EQ4YZaQHj=
rx0Hw@mail.gmail.com/.
For that change, any suggestions are deeply welcome :)

Thanks,
Jason
