Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A49D6B7758
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 13:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjCMMUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 08:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjCMMUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 08:20:33 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E4B52F72;
        Mon, 13 Mar 2023 05:20:31 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id j11so47901447edq.4;
        Mon, 13 Mar 2023 05:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678710030;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U9QeXAHeMugQluXQmQ0vDaleIoBtKB5Ww7MDNzTXkTs=;
        b=aNQgexFo/zLOjD/VvwQqH0QucmBFS3mLE36uRYn2rNfW6ikWMyBB9lxb/MEQ7E/rEX
         Lv2urpDe5MELhQqne/Pnvo9lj911dX+owC8PbleYhKMTCvSbDTy6zV2u35ywbeEr84zT
         LL7lXVekdfbCGe1ssZTGOkkuqJjfZhsI1m/DUxaFxc5kNfqMBD7bfI66DAjueQ3gVvpi
         bvknJbkHGMvtNCNtQ/RuZinjXgVa98B/xhLVUd8FWkKtpcbfDF+JjOWBQtCYKDn7qF4H
         8VXKzJdbBW5eLwRNFxiNJFwwP6w6xwoTtZ/PFms0E20vM7VqEgDrIfZdX/07rs+Z8FlA
         XrgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678710030;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U9QeXAHeMugQluXQmQ0vDaleIoBtKB5Ww7MDNzTXkTs=;
        b=GW8kfuMGRxGeEiK6YhoUGcdjCsOk5vLz08NrP65rxIvZduPPHHn5DcVVHeMrkxU6cm
         QlmXU09Vy1QcCHpP6Ma6g4XNrTxNiCtY9eSHKCL7dPMfWT6+MbzZB5JmzOxie/NHAfdm
         59ik0JsuS8PNS8w68p/r5egM+K3E9V6rs+aUF+4fY+gKuxrSX79srYmcmIza9NtO9hne
         DZCsVZj6nT71d5iEx0afgqP/5Pa1MjRegOhYrnVUi45fTvsvxV8UNAmdsPJzHpBTFiCk
         5zXXa2gViHOoafUCX2nD9L1HS4ZpFC2k/DY1m+0vzgjKABn5PYJ60kOopLSQte5KMBXV
         9R9w==
X-Gm-Message-State: AO0yUKV+jYba/fcvjKwXZEcCFP1C/EJmVL1tLI3tq6lG/BXIU3gd5R7n
        lhmGCg4NxUw0a0GNo+jjMS7TZQrmC+RFPnpRljg=
X-Google-Smtp-Source: AK7set8o+aFFFn6E49sD+TH2pPUAA1oNe7C77j1nrEz47+vNPIxudd7nb7GNX3PO/mlB2+SlIqLS5Fmck2j5jvCYhe4=
X-Received: by 2002:a17:906:6d5a:b0:922:26ae:c68c with SMTP id
 a26-20020a1709066d5a00b0092226aec68cmr3781992ejt.5.1678710030117; Mon, 13 Mar
 2023 05:20:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230311151756.83302-1-kerneljasonxing@gmail.com>
 <ZA4huzYKK/tdT3Ep@corigine.com> <CAL+tcoDi5fVWjyTX6wjJGKrszqL6JWkEgDBajhZchYSW7kyhGQ@mail.gmail.com>
 <ZA8S14QtdBduQEVq@corigine.com>
In-Reply-To: <ZA8S14QtdBduQEVq@corigine.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Mon, 13 Mar 2023 20:19:53 +0800
Message-ID: <CAL+tcoAmWU0w5dJ6_fL9yp1sMOF3px-n=H=kqaWwosHuzvijqA@mail.gmail.com>
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

On Mon, Mar 13, 2023 at 8:11=E2=80=AFPM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Mon, Mar 13, 2023 at 09:55:37AM +0800, Jason Xing wrote:
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
>
> I think %08llx might be a good way to go.
> But perhaps I'm missing something wrt to changing user-facing output.
>
> In any case, this is more a suggestion than a request for a change.

Ah, now I see. Thanks again for your review and suggestion :)

Thanks,
Jason
