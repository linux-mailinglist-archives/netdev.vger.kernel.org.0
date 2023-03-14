Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4B76B93DD
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 13:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjCNMeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 08:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjCNMeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 08:34:12 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC135A90A;
        Tue, 14 Mar 2023 05:33:46 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id x3so61296080edb.10;
        Tue, 14 Mar 2023 05:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678797142;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zrMC9KwaSjXs9wLyBZxtxGqFGtsGSBGVUQRPCzl8eEM=;
        b=ErxBV6U52wuVRLabo6aedVoGLUP4Zuqq3dTUJYVarscscv0SfZt3Qs2d1+ICVmaZoU
         hMuT8pqlSzWngK5RlX4V+4/KecTjzDXow8BOgOpDdR/X7DUPg+FYLFlkeakXi9KFdxz1
         seIYsn8lNm+skgbk4YjRDVR96zyn3vjI6ImJHlaL3GyJpNPYlf783L+O8PeCy14ck3Uy
         RZrVkkw+BbLSRYaU1uE9O+diLwB+BnZ2RbmtwD3GoLgOsBUnkYpVrLc/KwrSOyLqrb9A
         LQ6ArBkuIdBT4EheCiPP7TpxyykMdAAAYIM0+3PVjrbb13Bf9qAn6ve7gJ75kuBZzBAj
         Vvnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678797142;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zrMC9KwaSjXs9wLyBZxtxGqFGtsGSBGVUQRPCzl8eEM=;
        b=KBK3VhfyTwjNGtY18aB6iQxwlfJcxwUJ2oRyXwL2o+GA7YKHwou2vHigx8pUMpIauC
         J6a+BCynstMDc9v8f00xMjz9/anjf7zNI/3MftgbeRvcByf/7Q2+dnWSay4bhlCnsm9W
         rMPbM5gfJY/KJufMl2B45aj8X2dZj6yd4EtuuHQgoQjQY1Qn5ugcelEv/lyyyYgchhdL
         nXkyAwdtYwp6Gt5plwnwkbYQVmK1MK3qiLB0ZEDA2B54uTBQ1y3p1k0tMrPbLYhIJ3WO
         k5TlbDnLvM7nn1/TsQGq+vExeJFAJBMMbrpqCaxDfxJRFlHkojwjT54vwSfTpG+TmB33
         U5Yg==
X-Gm-Message-State: AO0yUKXSZ1fjdD0ZZW2smoqPQQ2uIfP7lcW8oJBuMzwZO286E0qL43uU
        xLixx0deN7VKrYpl9AfoRG2Bei4EWYuRjrVezhE=
X-Google-Smtp-Source: AK7set96ntz0wwf9F3ExaDsu5J8vo4QfmtKqdpA+G+2YJmIcf2a3AuQl2nM1cmB8ZqQyRF/jOE/l8Wh2VKTV5WDVluM=
X-Received: by 2002:a17:906:518:b0:8dd:70a:3a76 with SMTP id
 j24-20020a170906051800b008dd070a3a76mr1139314eja.11.1678797142335; Tue, 14
 Mar 2023 05:32:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230314030532.9238-1-kerneljasonxing@gmail.com>
 <20230314030532.9238-3-kerneljasonxing@gmail.com> <ZBBir/hjHRJz6Laf@corigine.com>
In-Reply-To: <ZBBir/hjHRJz6Laf@corigine.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 14 Mar 2023 20:31:46 +0800
Message-ID: <CAL+tcoAhRKEengF_st9Owu9=LTj9+_UH2ToU8osgd4LcFD=bvg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 2/2] net: introduce budget_squeeze to help us
 tune rx behavior
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, sinquersw@gmail.com,
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

On Tue, Mar 14, 2023 at 8:04=E2=80=AFPM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Tue, Mar 14, 2023 at 11:05:32AM +0800, Jason Xing wrote:
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > When we encounter some performance issue and then get lost on how
> > to tune the budget limit and time limit in net_rx_action() function,
> > we can separately counting both of them to avoid the confusion.
> >
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
>
> As per my comment on patch 1/2, I'd drop the "/* keep it untouched */"
> comment.

I think you're right. I'll drop this.

Thanks,
Jason

>
> That notwithstanding:
>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>
> > ---
> > v2:
> > 1) change the coding style suggested by Stephen and Simon
> > 2) Keep the display of the old data (time_squeeze) untouched suggested
> > by Kui-Feng
> > Link: https://lore.kernel.org/lkml/20230311163614.92296-1-kerneljasonxi=
ng@gmail.com/
> > ---
> >  include/linux/netdevice.h |  1 +
> >  net/core/dev.c            | 12 ++++++++----
> >  net/core/net-procfs.c     |  9 ++++++---
> >  3 files changed, 15 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 6a14b7b11766..5736311a2133 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -3157,6 +3157,7 @@ struct softnet_data {
> >       /* stats */
> >       unsigned int            processed;
> >       unsigned int            time_squeeze;
> > +     unsigned int            budget_squeeze;
> >  #ifdef CONFIG_RPS
> >       struct softnet_data     *rps_ipi_list;
> >  #endif
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 253584777101..1518a366783b 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6637,6 +6637,7 @@ static __latent_entropy void net_rx_action(struct=
 softirq_action *h)
> >       unsigned long time_limit =3D jiffies +
> >               usecs_to_jiffies(READ_ONCE(netdev_budget_usecs));
> >       int budget =3D READ_ONCE(netdev_budget);
> > +     bool done =3D false;
> >       LIST_HEAD(list);
> >       LIST_HEAD(repoll);
> >
> > @@ -6644,7 +6645,7 @@ static __latent_entropy void net_rx_action(struct=
 softirq_action *h)
> >       list_splice_init(&sd->poll_list, &list);
> >       local_irq_enable();
> >
> > -     for (;;) {
> > +     while (!done) {
> >               struct napi_struct *n;
> >
> >               skb_defer_free_flush(sd);
> > @@ -6662,10 +6663,13 @@ static __latent_entropy void net_rx_action(stru=
ct softirq_action *h)
> >                * Allow this to run for 2 jiffies since which will allow
> >                * an average latency of 1.5/HZ.
> >                */
> > -             if (unlikely(budget <=3D 0 ||
> > -                          time_after_eq(jiffies, time_limit))) {
> > +             if (unlikely(budget <=3D 0)) {
> > +                     sd->budget_squeeze++;
> > +                     done =3D true;
> > +             }
> > +             if (unlikely(time_after_eq(jiffies, time_limit))) {
> >                       sd->time_squeeze++;
> > -                     break;
> > +                     done =3D true;
> >               }
> >       }
> >
> > diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
> > index 2809b663e78d..25810ee46a04 100644
> > --- a/net/core/net-procfs.c
> > +++ b/net/core/net-procfs.c
> > @@ -179,14 +179,17 @@ static int softnet_seq_show(struct seq_file *seq,=
 void *v)
> >        */
> >       seq_printf(seq,
> >                  "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08=
x %08x %08x "
> > -                "%08x %08x\n",
> > -                sd->processed, sd->dropped, sd->time_squeeze, 0,
> > +                "%08x %08x %08x %08x\n",
> > +                sd->processed, sd->dropped,
> > +                sd->time_squeeze + sd->budget_squeeze, /* keep it unto=
uched */
> > +                0,
> >                  0, 0, 0, 0, /* was fastroute */
> >                  0,   /* was cpu_collision */
> >                  sd->received_rps, flow_limit_count,
> >                  softnet_backlog_len(sd),     /* keep it untouched */
> >                  (int)seq->index,
> > -                softnet_input_pkt_queue_len(sd), softnet_process_queue=
_len(sd));
> > +                softnet_input_pkt_queue_len(sd), softnet_process_queue=
_len(sd),
> > +                sd->time_squeeze, sd->budget_squeeze);
> >       return 0;
> >  }
> >
> > --
> > 2.37.3
> >
