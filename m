Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E128A6B6D3B
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 02:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjCMB4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 21:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCMB4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 21:56:16 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8DC29403;
        Sun, 12 Mar 2023 18:56:15 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id j11so42745216edq.4;
        Sun, 12 Mar 2023 18:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678672573;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kWK9l6oO63fsuYbhxw+2itoc1uIny5FLOrsGgX9Wzz0=;
        b=oXnTMU9xWdaJ54cug1P2DyGEqBGgaJj1loGiv526Boo7pTw4RCdpTimgwutbr/6ZIr
         bRDcCwt0BFMDnXexx5BlG/McxTEvoQJk5R4LWVY16y69l1yZV5sr+Cp1rrD51dRYp62v
         4wFM6h0/NEpP6FJAQnPTBUgAVaH+bBH5YbC4wj2KIw+BRdoYw4OexVLiLwZtrSzEpUvq
         4qLWRVj8TPdID8k3DS07ca5ijUgq0eBKA9tZFI3MmUf3dEbRYdkAqknyTfyVF/s7GV8I
         Fqh3rVNZSFmQh4tHErt0i5vDEsz6YrFZjG9mn9DeuAm4ZbpED/vVI+fc71bFrctKc7Yd
         E/cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678672573;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kWK9l6oO63fsuYbhxw+2itoc1uIny5FLOrsGgX9Wzz0=;
        b=iv75QxaVtS6lNU5TGiSaX+JhChanapbdgBEUvvassMyMXOmag8DfD+UpWkJvIU/mSJ
         VQPqlmKXZArmDEib4luz3gvNQ0hV+zLpsQuTeozzZ5aQvgg9xdql6pD01iPOr+wVUNMx
         UwYZTwSSj6KrzGFBXbpB30lj1g6HzWMGIGjFoGdeT3kinNGOnDRmzpvM0XLrMnNSw+42
         3bX6MHPuTBIwN1sm4ePnrJuG56OcpPI3E/0m67K13N2rnT7wq8D4OhMZk3lA/sITcDf8
         zplNkLPWhSsLt/D50kRmTU5R0pEIKdG+ptuOZCsyQKCQRQvyQiHGldlYjBDAgFz3XKFM
         wkxQ==
X-Gm-Message-State: AO0yUKUAFr3/f32Q4MenuCitSDB4XgfLIjd19H1wQeFz8SumoYvpJfaG
        IuNrPifSOitjF+oc4RWZ4HdQQIthSfiJjiOXThM=
X-Google-Smtp-Source: AK7set/MTjxsChf+B5WhVnnNN8MlSbOTlXD6uA5tgzkdHL4q+18DOSUu+HV1VZLKY1E9llgUoKg6aNs6AmuOdMcIX40=
X-Received: by 2002:a17:906:b256:b0:924:32b2:e3d1 with SMTP id
 ce22-20020a170906b25600b0092432b2e3d1mr1968310ejb.3.1678672573448; Sun, 12
 Mar 2023 18:56:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230311151756.83302-1-kerneljasonxing@gmail.com> <ZA4huzYKK/tdT3Ep@corigine.com>
In-Reply-To: <ZA4huzYKK/tdT3Ep@corigine.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Mon, 13 Mar 2023 09:55:37 +0800
Message-ID: <CAL+tcoDi5fVWjyTX6wjJGKrszqL6JWkEgDBajhZchYSW7kyhGQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net-sysfs: display two backlog queue len separately
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
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

On Mon, Mar 13, 2023 at 3:02=E2=80=AFAM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Sat, Mar 11, 2023 at 11:17:56PM +0800, Jason Xing wrote:
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
> >       return 0;
> >  }
> >
> > -static u32 softnet_backlog_len(struct softnet_data *sd)
> > +static u32 softnet_input_pkt_queue_len(struct softnet_data *sd)
> >  {
> > -     return skb_queue_len_lockless(&sd->input_pkt_queue) +
> > -            skb_queue_len_lockless(&sd->process_queue);
> > +     return skb_queue_len_lockless(&sd->input_pkt_queue);
> > +}
> > +
> > +static u32 softnet_process_queue_len(struct softnet_data *sd)
> > +{
> > +     return skb_queue_len_lockless(&sd->process_queue);
> >  }
> >
> >  static struct softnet_data *softnet_get_online(loff_t *pos)
> > @@ -169,12 +173,15 @@ static int softnet_seq_show(struct seq_file *seq,=
 void *v)
> >        * mapping the data a specific CPU
> >        */
> >       seq_printf(seq,
> > -                "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08=
x %08x %08x\n",
> > +                "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08=
x %08x %08x "
> > +                "%08x %08x\n",
> >                  sd->processed, sd->dropped, sd->time_squeeze, 0,
> >                  0, 0, 0, 0, /* was fastroute */
> >                  0,   /* was cpu_collision */
> >                  sd->received_rps, flow_limit_count,
> > -                softnet_backlog_len(sd), (int)seq->index);
> > +                0,   /* was len of two backlog queues */
> > +                (int)seq->index,
>
> nit: I think you could avoid this cast by using %llx as the format specif=
ier.

I'm not sure if I should change this format since the above line is
introduced in commit 7d58e6555870d ('net-sysfs: add backlog len and
CPU id to softnet data').
The seq->index here manifests which cpu it uses, so it can be
displayed in 'int' format. Meanwhile, using %8x to output is much
cleaner if the user executes 'cat /proc/net/softnet_stat'.

What do you think about this?

Thanks,
Jason

>
> > +                softnet_input_pkt_queue_len(sd), softnet_process_queue=
_len(sd));
> >       return 0;
> >  }
> >
> > --
> > 2.37.3
> >
