Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26BE96B9A29
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbjCNPpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbjCNPpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:45:32 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464D53B67B;
        Tue, 14 Mar 2023 08:45:00 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id da10so63917383edb.3;
        Tue, 14 Mar 2023 08:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678808698;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eKXDqlgRlxDBpfBSUg+NALui/8xB4e6ou/BhNO7mLI4=;
        b=IAzLxnAp6XszDIaOhMc3QPxTqF85nNzGKqy1tkwbOUs9FdXHZECjQhBSHD/wu/SMCO
         XEGhPvZbIAK7G898j0na7C8AlqoqrOFXDjW7wbFe3aHu0+EecYHkrQuLeVQcoQz6JMos
         JD4cCmgQTg0nVK/iRrKwFJfUPMhXlM/TXjNk5A7tWpSobltqv2xDJxUg/5H7xhQTLqAH
         C3fBqWtfEHgUZvW5t3PJ0O48977uryrB1CN57tYG30Eg983bLlEZpZKUnMRePHn4i0qn
         riZDYiVaA64QTH4kuawKv1uGH53tMe2peloWMAwl9C2EpPu6WMsjjNm9pqtOm0NR8sot
         h/4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678808698;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eKXDqlgRlxDBpfBSUg+NALui/8xB4e6ou/BhNO7mLI4=;
        b=KMxIbI1MTe0ofO45/EdC+N1B4BPvC54qNhlpxVO7Fj+VQ/MBuZSlDlOR59YxKFn17E
         isAFOC/U7Pq3Tu96MXhnTBDjhsn7thuzvu859DkfZrnUrkspuAYNZ++AeQYeVVKzo1rN
         oKpwVC773hhkRaLIDBkPIcvz2ZgYVEovRRYRb6ADzqiVRGcJ1Y2WGzxzsctlciBJLTx8
         Y7v6XINtbehM73Xrr6c6IAxl9aIJivzrCJM1qzDRdUP1EMmG3Phd9jN62onzUo2Yx/3e
         OVbBya0OBBqiyO+A/0LYyAmruZz48sANzsC6/9qKJTvR59ZLcqAf8dh1cUkpodbpnxcv
         bKyQ==
X-Gm-Message-State: AO0yUKVpfhQ0FHXVkc1IGp4O3jzSMKs5xRn8czekn9Sq7+zcFVlrz7Mr
        98Lh2YWtkJE5OUSDk3+AOP1TOOXi2JDLRZZA5kY=
X-Google-Smtp-Source: AK7set9q7zAwL8U3or4cXTpOyuJtTD98rXetlwgFWoer8FKPE8NTLIcMS9zdJoPbs8aex72ekWe7OJDq0ibIvIyYO6Q=
X-Received: by 2002:a17:906:518:b0:8dd:70a:3a76 with SMTP id
 j24-20020a170906051800b008dd070a3a76mr1491582eja.11.1678808697803; Tue, 14
 Mar 2023 08:44:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230314030532.9238-1-kerneljasonxing@gmail.com>
 <20230314030532.9238-2-kerneljasonxing@gmail.com> <CANn89iKP7GVxZ0HYcPQq5ryC+rtwyymZuHuvza_SoCOJeADzGw@mail.gmail.com>
In-Reply-To: <CANn89iKP7GVxZ0HYcPQq5ryC+rtwyymZuHuvza_SoCOJeADzGw@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 14 Mar 2023 23:44:21 +0800
Message-ID: <CAL+tcoANe4FMSCvTH46ToPqMsEUSwwKMhdT+z_hR7hEE0FsL7g@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 1/2] net-sysfs: display two backlog queue len separately
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

On Tue, Mar 14, 2023 at 10:59=E2=80=AFPM Eric Dumazet <edumazet@google.com>=
 wrote:
>
> On Mon, Mar 13, 2023 at 8:06=E2=80=AFPM Jason Xing <kerneljasonxing@gmail=
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
> > v2: keep the total len of backlog queues untouched as Eric said
> > Link: https://lore.kernel.org/lkml/20230311151756.83302-1-kerneljasonxi=
ng@gmail.com/
> > ---
> >  net/core/net-procfs.c | 20 ++++++++++++++++----
> >  1 file changed, 16 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
> > index 1ec23bf8b05c..2809b663e78d 100644
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
>
[...]
> Reading these variables twice might lead to inconsistency that can
> easily be avoided.
>
> I would suggest you cache the values,
>
> u32 len1 =3D softnet_input_pkt_queue_len(sd);
> u32 len2 =3D softnet_process_queue_len(sd);

Agreed. Thank you, Eric. I should have realized that.

Also, the 2/2 patch which is all about the time_/budget_squeeze should
avoid such inconsistency, I think.

Jason
>
>
>
> >  }
> >
> >  static struct softnet_data *softnet_get_online(loff_t *pos)
> > @@ -169,12 +178,15 @@ static int softnet_seq_show(struct seq_file *seq,=
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
> > +                  softnet_backlog_len(sd),     /* keep it untouched */
>                     len1 + len2.
>
> > +                  (int)seq->index,
> > +                  softnet_input_pkt_queue_len(sd), softnet_process_que=
ue_len(sd));
>                len1,  len2);
>
> >         return 0;
> >  }
> >
> > --
> > 2.37.3
> >
