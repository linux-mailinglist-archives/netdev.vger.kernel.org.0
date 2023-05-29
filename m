Return-Path: <netdev+bounces-6074-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00920714B33
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:57:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5280280E78
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D085579CB;
	Mon, 29 May 2023 13:57:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30B77489
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 13:57:09 +0000 (UTC)
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B101A8
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:56:49 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id 3f1490d57ef6-b9a7e639656so6462245276.0
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685368562; x=1687960562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E5ZbOTNIGsyMBPrAGlum0uVhbCXq1Fr/43Mrcd4J4TI=;
        b=48Ctxr1/ag8+dCHgnLgD8YIpipfZQcA1TCxj3+6gKZrmXhCswKf4C59OXdAz0IC7bF
         bG44mkRiqFPq3DsHtz9h3qliHTP3fb8J6hZO7DjiXcFJ1+Ev5XZXPmkYDL3H0yThKZIr
         KOwYGAK/6cQQBdRYCNbxrO0Jm8f1YC6HvNGvNE641EkROqZUCVUX78W6z5RJ1RunekcU
         e59y29Ft8jIbRX8YkIKsPMPCtsFIUBLk2bEUCAmxgWK7tpUliDNkWyMci5om8tOUThcl
         Dk9FNmt6f8o5DpMiKXHIrftmlASk80YqRIWjKhxNTxKvg7dIp+VbzewirFqq/eiNsAhQ
         sQvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685368562; x=1687960562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E5ZbOTNIGsyMBPrAGlum0uVhbCXq1Fr/43Mrcd4J4TI=;
        b=YwRhvQCzA/UEy6p+ptPHUMZ6UScvvskTBRfzQOsFMuF9yxe5wg4AQlvWgGaIoghvhF
         13d5S0cTgW1MrghyOhwTgV6GUL91J6QclG6x9/92644TLGVfHTAvNuShvi3vGfkRibHm
         kDzpTuwff/0ftAJXSrbjmhjXGkHqnH18ObnM+wUHG1APGEPwjAvZLHltFTrVguF819P6
         zx8oBfiwG8a4lyNd9qniB73ficJdm9qe+beIZ5RtB7m3qPwpQRHfF2EPTgERYg3qPGN3
         p9ogP6/ejRJkDfo21hagUbNFmaVr6P5Ay10qoXE/M0p8ZMsb1lCV+dQyaB/zXs2jGaZM
         YXyg==
X-Gm-Message-State: AC+VfDyKeh178A9LxsA8EaTIIajIyKVj4cmSgtQ0bkjvPYT7FqhJNa77
	Et5Mi+ByMQWboEzIVuh6eI69EB+8q/G09maTzej0Lg==
X-Google-Smtp-Source: ACHHUZ4nJ8K4bXKZc5FqraNai4oH3/N9lj+KYIRKMArOKtBGraC4zDL79G1uBMriT6QFR7x8fNPoSOxHZd66GTHzmRw=
X-Received: by 2002:a05:6902:1507:b0:ba7:4356:e0fa with SMTP id
 q7-20020a056902150700b00ba74356e0famr13335669ybu.3.1685368562572; Mon, 29 May
 2023 06:56:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1684887977.git.peilin.ye@bytedance.com> <429357af094297abbc45f47b8e606f11206df049.1684887977.git.peilin.ye@bytedance.com>
 <faaeb0b0-8538-9dfa-4c1e-8a225e3534f4@mojatatu.com> <CAM0EoM=3iYmmLjnifx_FDcJfRbN31tRnCE0ZvqQs5xSBPzaqXQ@mail.gmail.com>
 <CAM0EoM=FS2arxv0__aQXF1a7ViJnM0hST=TL9dcnJpkf-ipjvA@mail.gmail.com>
 <7879f218-c712-e9cc-57ba-665990f5f4c9@mojatatu.com> <ZHE8P9Bi6FlKz4US@C02FL77VMD6R.googleapis.com>
 <20230526193324.41dfafc8@kernel.org> <ZHG+AR8qgpJ6/Zhx@C02FL77VMD6R.googleapis.com>
 <CAM0EoM=xLkAr5EF7bty+ETmZ3GXnmB9De3fYSCrQjKPb8qDy7Q@mail.gmail.com> <87jzwrxrz8.fsf@nvidia.com>
In-Reply-To: <87jzwrxrz8.fsf@nvidia.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Mon, 29 May 2023 09:55:51 -0400
Message-ID: <CAM0EoMkS+F5DRN=NOuuA0M1CCCmMYdjDpB1Wz2wjW=eJzHvC0w@mail.gmail.com>
Subject: Re: [PATCH v5 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
To: Vlad Buslov <vladbu@nvidia.com>
Cc: Peilin Ye <yepeilin.cs@gmail.com>, Jakub Kicinski <kuba@kernel.org>, 
	Pedro Tammela <pctammela@mojatatu.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, 
	Peilin Ye <peilin.ye@bytedance.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org, 
	Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 8:06=E2=80=AFAM Vlad Buslov <vladbu@nvidia.com> wro=
te:
>
> On Sun 28 May 2023 at 14:54, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> > On Sat, May 27, 2023 at 4:23=E2=80=AFAM Peilin Ye <yepeilin.cs@gmail.co=
m> wrote:
> >>
> >> Hi Jakub and all,
> >>
> >> On Fri, May 26, 2023 at 07:33:24PM -0700, Jakub Kicinski wrote:
> >> > On Fri, 26 May 2023 16:09:51 -0700 Peilin Ye wrote:
> >> > > Thanks a lot, I'll get right on it.
> >> >
> >> > Any insights? Is it just a live-lock inherent to the retry scheme
> >> > or we actually forget to release the lock/refcnt?
> >>
> >> I think it's just a thread holding the RTNL mutex for too long (replay=
ing
> >> too many times).  We could replay for arbitrary times in
> >> tc_{modify,get}_qdisc() if the user keeps sending RTNL-unlocked filter
> >> requests for the old Qdisc.
>
> After looking very carefully at the code I think I know what the issue
> might be:
>
>    Task 1 graft Qdisc   Task 2 new filter
>            +                    +
>            |                    |
>            v                    v
>         rtnl_lock()       take  q->refcnt
>            +                    +
>            |                    |
>            v                    v
> Spin while q->refcnt!=3D1   Block on rtnl_lock() indefinitely due to -EAG=
AIN
>
> This will cause a real deadlock with the proposed patch. I'll try to
> come up with a better approach. Sorry for not seeing it earlier.
>
> >>
> >> I tested the new reproducer Pedro posted, on:
> >>
> >> 1. All 6 v5 patches, FWIW, which caused a similar hang as Pedro report=
ed
> >>
> >> 2. First 5 v5 patches, plus patch 6 in v1 (no replaying), did not trig=
ger
> >>    any issues (in about 30 minutes).
> >>
> >> 3. All 6 v5 patches, plus this diff:
> >>
> >> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> >> index 286b7c58f5b9..988718ba5abe 100644
> >> --- a/net/sched/sch_api.c
> >> +++ b/net/sched/sch_api.c
> >> @@ -1090,8 +1090,11 @@ static int qdisc_graft(struct net_device *dev, =
struct Qdisc *parent,
> >>                          * RTNL-unlocked filter request(s).  This is t=
he counterpart of that
> >>                          * qdisc_refcount_inc_nz() call in __tcf_qdisc=
_find().
> >>                          */
> >> -                       if (!qdisc_refcount_dec_if_one(dev_queue->qdis=
c_sleeping))
> >> +                       if (!qdisc_refcount_dec_if_one(dev_queue->qdis=
c_sleeping)) {
> >> +                               rtnl_unlock();
> >> +                               rtnl_lock();
> >>                                 return -EAGAIN;
> >> +                       }
> >>                 }
> >>
> >>                 if (dev->flags & IFF_UP)
> >>
> >>    Did not trigger any issues (in about 30 mintues) either.
> >>
> >> What would you suggest?
> >
> >
> > I am more worried it is a wackamole situation. We fixed the first
> > reproducer with essentially patches 1-4 but we opened a new one which
> > the second reproducer catches. One thing the current reproducer does
> > is create a lot rtnl contention in the beggining by creating all those
> > devices and then after it is just creating/deleting qdisc and doing
> > update with flower where such contention is reduced. i.e it may just
> > take longer for the mole to pop up.
> >
> > Why dont we push the V1 patch in and then worry about getting clever
> > with EAGAIN after? Can you test the V1 version with the repro Pedro
> > posted? It shouldnt have these issues. Also it would be interesting to
> > see how performance of the parallel updates to flower is affected.
>
> This or at least push first 4 patches of this series. They target other
> older commits and fix straightforward issues with the API.


Yes, lets get patch 1-4 in first ...

cheers,
jamal

