Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0FC6B99F2
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjCNPkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCNPjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:39:43 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84168B1A56;
        Tue, 14 Mar 2023 08:38:56 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id cy23so63600435edb.12;
        Tue, 14 Mar 2023 08:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678808288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w3ZuYTnI2XHY7qD63HYvqwpI7hWCTPg4374W3++0NbA=;
        b=L0jFXnD6fY2x71EQ6w5SQvZLc7ZP5CiMlLl4xc0rdvsqGB5tEvmmxbPeKgrGvU9/uH
         Nkr8DxsNI+KjwtM8AoP4ciM3N+C1/kbI9m6KYG7YnpPwKZUm7gJKqSXhRtrLSlzfEVeu
         33J5hjtg2BBUTdLptztUqdfOyNJJbUmsV6F4+Et6z1GDzCIXkwzv/hK5j0DY+8xwvOV9
         KHM9aGLsq232L01gSCxnGG+sYkkNy58kZNbdF1qJVond/CQ4T+gHOOpYpzSHt+yXQIUb
         7NfzEYCOLqPM5QvsgcszumEN93G/0WC1EguFNpjoJyQUFRHlew+g0jMj/bhvFpjN82Jc
         XOCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678808288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w3ZuYTnI2XHY7qD63HYvqwpI7hWCTPg4374W3++0NbA=;
        b=m4Gh0JPNwp0duQnv8ImKxkBcZMURksCtdfvMrbRtkn3O+R2mYJqMASrD5JRsxL2ks+
         B24yQyD62d+agv+WZGYijCe6o6icls6OILI8Qj6b1lhuZsJc4QDPl0pOpXUN3Pq83Bop
         J2Uxeu3H6T/O6YCNgQlc86s9nhekXQxeMlvfoOzX0L2c6/8NB6O/XFX41fjlYbzEeZLy
         oRqA+bBEJ5Tu5kvr9gWB32i3t/X0R+25ktfd9US4fualbW4zL59g/KurXGIeJTyfRMC3
         ficiX3XYxskgHuoQnZQlgRLlYFXr3Cz3ee8Wj6JIJOQ5FFPUUQUf3mJXENkLiAWH/vhA
         5+UA==
X-Gm-Message-State: AO0yUKVr5rpX63ays4C6r4pCv6ToAW/r3w8OEr84iuadm/w9HTrxtw/m
        qLnYjlAXUedOztsyMjC7u/YwTxNSLk1iUileWc0=
X-Google-Smtp-Source: AK7set/dZz+S30ElspvS+EcKXPdVdzDcBSO9QhvK39lm23VCHLr/Hpbu8dtl8+OAdMgr3AlVyBzh8Mhibzq+cHa5/VA=
X-Received: by 2002:a17:906:8443:b0:922:26ae:c68c with SMTP id
 e3-20020a170906844300b0092226aec68cmr1630233ejy.5.1678808287719; Tue, 14 Mar
 2023 08:38:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230314131427.85135-1-kerneljasonxing@gmail.com>
 <20230314131427.85135-2-kerneljasonxing@gmail.com> <CANn89iJzVjht5L1zxwCMTPXXoXdRMtRmzbL5UzHodhBJziCxYg@mail.gmail.com>
In-Reply-To: <CANn89iJzVjht5L1zxwCMTPXXoXdRMtRmzbL5UzHodhBJziCxYg@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 14 Mar 2023 23:37:31 +0800
Message-ID: <CAL+tcoCitx8045qWr1E-yudvEkCndDMBJT+OtqqjbdEPv7EXhQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 1/2] net-sysfs: display two backlog queue len separately
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, stephen@networkplumber.org,
        simon.horman@corigine.com, sinquersw@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
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

On Tue, Mar 14, 2023 at 11:15=E2=80=AFPM Eric Dumazet <edumazet@google.com>=
 wrote:
>
> On Tue, Mar 14, 2023 at 6:14=E2=80=AFAM Jason Xing <kerneljasonxing@gmail=
.com> wrote:
> >
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > Sometimes we need to know which one of backlog queue can be exactly
> > long enough to cause some latency when debugging this part is needed.
> > Thus, we can then separate the display of both.
> >
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> > ---
> > v3: drop the comment suggested by Simon
> > Link: https://lore.kernel.org/lkml/20230314030532.9238-2-kerneljasonxin=
g@gmail.com/
> >
> > v2: keep the total len of backlog queues untouched as Eric said
> > Link: https://lore.kernel.org/lkml/20230311151756.83302-1-kerneljasonxi=
ng@gmail.com/
> > ---
> >  net/core/net-procfs.c | 19 +++++++++++++++----
> >  1 file changed, 15 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
> > index 1ec23bf8b05c..8056f39da8a1 100644
> > --- a/net/core/net-procfs.c
> > +++ b/net/core/net-procfs.c
> > @@ -115,10 +115,19 @@ static int dev_seq_show(struct seq_file *seq, voi=
d *v)
> >         return 0;
> >  }
> >
> > +static u32 softnet_input_pkt_queue_len(struct softnet_data *sd)
> > +{
> > +       return skb_queue_len_lockless(&sd->input_pkt_queue);
> > +}
> > +
> > +static u32 softnet_process_queue_len(struct softnet_data *sd)
> > +{
> > +       return skb_queue_len_lockless(&sd->process_queue);
> > +}
> > +
> >  static u32 softnet_backlog_len(struct softnet_data *sd)
> >  {
> > -       return skb_queue_len_lockless(&sd->input_pkt_queue) +
> > -              skb_queue_len_lockless(&sd->process_queue);
> > +       return softnet_input_pkt_queue_len(sd) + softnet_process_queue_=
len(sd);
> >  }
> >
> >  static struct softnet_data *softnet_get_online(loff_t *pos)
> > @@ -169,12 +178,14 @@ static int softnet_seq_show(struct seq_file *seq,=
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
> > +                  softnet_backlog_len(sd), (int)seq->index,
> > +                  softnet_input_pkt_queue_len(sd), softnet_process_que=
ue_len(sd));
> >         return 0;
>
>
[...]
> It is customary to wait ~24 hours between each version, so that
> everybody gets a chance to comment,
> and to avoid polluting mailing lists with too many messages/day.

Thanks for your reminder.

>
> (I see you are including lkml@, which seems unnecessary for this kind of =
patch)

Yes, I alway do the get_maintainers.pl to check before I submit. So
I'll remove the lkml@.

>
> Please address the feedback I gave for v2.

Sure :)

Thanks,
Jason

>
> Thanks.
