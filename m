Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90EC46B6D95
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 03:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjCMCnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 22:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCMCnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 22:43:16 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1874EB75;
        Sun, 12 Mar 2023 19:43:13 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id k10so42882766edk.13;
        Sun, 12 Mar 2023 19:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678675392;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OQeH1kRHssYB3DRN8tlVnh86NMNc0TbgdGvV4cLCRdE=;
        b=PtUm5+t+NdnQbcTBolh4rORpfrOX+cvv0JCwxg1IyvNTg0XChoXYqB+uApRfuLy6C4
         AaEZVfezBv6iN5aHvdpqmRqTDYofOO7L3oaFsFr1W5H5Rra6AGKorMgcjuJDRsg9U0e7
         ZjKqZPZncvuxyvo7vikziUTPGGPbflCWG3eEHZa+pBqprOBo09ybLssNT5Xq4GfZiqr6
         j7WlghShMBMFylKCdZlm5rT+/y2wFoyK9HwHjhJL+xqHjJIE/Py0w3kpAUz8CuchgUTY
         kblN0nN2kryHEXT6KJFmxphqn1ovTJ8YP2vHL9U4EZkmipIWoFmF5yOU99UdI1sFrpFU
         vubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678675392;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OQeH1kRHssYB3DRN8tlVnh86NMNc0TbgdGvV4cLCRdE=;
        b=DdmgxlD8rHksu1bBnnFjFM6tu7qCltLheMccshdDSOb0YVck5ExA5rRxIAihzFSirR
         3gAyQPw3wZIaKLDrjXO+VAjYsSuy2a4HUlxyLfn3NVJZbcXmyHj5rRBBZpc4S3b9ruam
         GUHUGQLA5MhvJcMX0Bf6a9t2xFPnAB8xiROk+9NqZ2jfuP61dbmeAN1OmglZTENSuyd0
         1Imp0uyjY0z7QB5SjT3q5eaA5AWsZCrCGTJ/DWociSfe6TFPKnNZB9BcD2V6ah7//JT+
         w909nhK4VJQTRcL5p44SF2EtRO6GdVe/y3gPGfwuJtjUM61kysITkno0Y5PrwbHMQokU
         J6kg==
X-Gm-Message-State: AO0yUKUxQ3Rq0gYqbv6eh6BJG9qy8OE3uXKKQPOUTtumNBYXp3xTHVmx
        4Q/QowogElltkA0ZRZZKg8nQeqD9YufNLunUEl3hKPQj1G0=
X-Google-Smtp-Source: AK7set9+aIHXC2lhAt3vRuR0yE28amhuNuWqzhfKwpJJDFagXEi2WjZlpPfK1LCUG4X2Tox51bVZB47TMqkfbkRyr6s=
X-Received: by 2002:a17:907:7d8c:b0:8f5:2e0e:6def with SMTP id
 oz12-20020a1709077d8c00b008f52e0e6defmr5992455ejc.0.1678675392198; Sun, 12
 Mar 2023 19:43:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230311151756.83302-1-kerneljasonxing@gmail.com>
 <ZA4huzYKK/tdT3Ep@corigine.com> <CAL+tcoDi5fVWjyTX6wjJGKrszqL6JWkEgDBajhZchYSW7kyhGQ@mail.gmail.com>
 <20230312192847.0d58155e@hermes.local>
In-Reply-To: <20230312192847.0d58155e@hermes.local>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Mon, 13 Mar 2023 10:42:35 +0800
Message-ID: <CAL+tcoDEfwZHMNPgzodu101Z6HBQe7fHi0yAcKwFrtx28J_MmQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net-sysfs: display two backlog queue len separately
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Simon Horman <simon.horman@corigine.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
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

On Mon, Mar 13, 2023 at 10:28=E2=80=AFAM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 13 Mar 2023 09:55:37 +0800
> Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> > On Mon, Mar 13, 2023 at 3:02=E2=80=AFAM Simon Horman <simon.horman@cori=
gine.com> wrote:
> > >
> > > On Sat, Mar 11, 2023 at 11:17:56PM +0800, Jason Xing wrote:
> > > > From: Jason Xing <kernelxing@tencent.com>
> > > >
> > > > Sometimes we need to know which one of backlog queue can be exactly
> > > > long enough to cause some latency when debugging this part is neede=
d.
> > > > Thus, we can then separate the display of both.
> > > >
> > > > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > > > ---
> > > >  net/core/net-procfs.c | 17 ++++++++++++-----
> > > >  1 file changed, 12 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
> > > > index 1ec23bf8b05c..97a304e1957a 100644
> > > > --- a/net/core/net-procfs.c
> > > > +++ b/net/core/net-procfs.c
> > > > @@ -115,10 +115,14 @@ static int dev_seq_show(struct seq_file *seq,=
 void *v)
> > > >       return 0;
> > > >  }
> > > >
> > > > -static u32 softnet_backlog_len(struct softnet_data *sd)
> > > > +static u32 softnet_input_pkt_queue_len(struct softnet_data *sd)
> > > >  {
> > > > -     return skb_queue_len_lockless(&sd->input_pkt_queue) +
> > > > -            skb_queue_len_lockless(&sd->process_queue);
> > > > +     return skb_queue_len_lockless(&sd->input_pkt_queue);
> > > > +}
> > > > +
> > > > +static u32 softnet_process_queue_len(struct softnet_data *sd)
> > > > +{
> > > > +     return skb_queue_len_lockless(&sd->process_queue);
> > > >  }
> > > >
> > > >  static struct softnet_data *softnet_get_online(loff_t *pos)
> > > > @@ -169,12 +173,15 @@ static int softnet_seq_show(struct seq_file *=
seq, void *v)
> > > >        * mapping the data a specific CPU
> > > >        */
> > > >       seq_printf(seq,
> > > > -                "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x=
 %08x %08x %08x\n",
> > > > +                "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x=
 %08x %08x %08x "
> > > > +                "%08x %08x\n",
> > > >                  sd->processed, sd->dropped, sd->time_squeeze, 0,
> > > >                  0, 0, 0, 0, /* was fastroute */
> > > >                  0,   /* was cpu_collision */
> > > >                  sd->received_rps, flow_limit_count,
> > > > -                softnet_backlog_len(sd), (int)seq->index);
> > > > +                0,   /* was len of two backlog queues */
> > > > +                (int)seq->index,
> > >
> > > nit: I think you could avoid this cast by using %llx as the format sp=
ecifier.
> >
> > I'm not sure if I should change this format since the above line is
> > introduced in commit 7d58e6555870d ('net-sysfs: add backlog len and
> > CPU id to softnet data').
> > The seq->index here manifests which cpu it uses, so it can be
> > displayed in 'int' format. Meanwhile, using %8x to output is much
> > cleaner if the user executes 'cat /proc/net/softnet_stat'.
> >
> > What do you think about this?
> >
> > Thanks,
> > Jason
>
> I consider sofnet_data a legacy API (ie don't change).

Yeah, people seldomly touch this file in these years.

> Why not add to real sysfs for network device with the one value per file?

Thanks for your advice. It's worth thinking about what kind of output
can replace the softnet_stat file because this file includes almost
everything which makes it more user-friendly. I'm a little bit
confused if we can use a fully new way to completely replace the
legacy file.

Do other maintainers have some precious opinion on this?

Thanks,
Jason
