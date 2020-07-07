Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B72217891
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 22:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgGGUG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 16:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgGGUG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 16:06:27 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF313C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 13:06:26 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id v8so44466535iox.2
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 13:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nJxuKhd26G24t6VOwjxeUrPuCMtMADWQWWoaE+1UDvk=;
        b=Uk4Y5c5ueZwAQOTaXSPCDIVy3XVcRFTKF7MONRQw4amj2W13JJmuff0DWbAL4mSVfI
         m3FRLoke2PkfbZNQCCrd9sBaUmpLFSFsRhP2yCCMvmPRLBGl4mGIDpqvSoMoH+ENK+ys
         3YfeGf+EPsqyglPIAME7EwFYXS+hTcQqh9N046TV+TDZPHhycmJdGlsOS6PPpkNx2v4i
         4Pwq9gYnryX/3TMxvszwXe5EeEJmUrPLdIGcv6JbAFeF4+zkjmt9dSAR5h7oEQ5hL0gV
         TqbiEAVQu1DWG9Yc9ZWIHRwISFoEomF9nLMtACvrOUX7rY9AgfD9v6B8SAVNTl+NgTa0
         nRdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nJxuKhd26G24t6VOwjxeUrPuCMtMADWQWWoaE+1UDvk=;
        b=haI6DJOTAKR5rJrK5DR5rXLewN3oVLJ29tUzOJ4YqZD7UfituBvCrO5BzoXjc7/wpp
         ojGVuRCKjQcbVSG4eQoVOF3i+gukyagS3dq4E9PZcVYD0y8oLz3gRZL+ZpYOWRUOqD8W
         1sgla8A2AFWdNCV6MWOZLdXcWSzzZCTixe5PVYam/tzARgBhU4nofx6QiQZbGqGE9Eer
         a/WFfmVKP3X04JPn2kINbQIClZcxwwdJS8knkKXYJU5pndV8VW722g4b2F7G5KZlvmNg
         oLVFmUIYenEFvK+pyaxmDzTxwfqR2USrg6PoUTcOkSFeTWvoUtPbfw+x/sPEuuOV7X+t
         gkfg==
X-Gm-Message-State: AOAM531OMYJHEvwoODnh2sXQPpcPr34lgpQB1sCbec+VgdqES1D6OqDF
        xa7TIOS9FgaDLDfuvMfGQmXlnndi8sHK5/3zxCtz6O9CkuM=
X-Google-Smtp-Source: ABdhPJwpCMy2unF0DAksuuhH7EsgAqRZte0J6s7ULewYvM3zvxFDCR5uWjD7hClDE6u+ke2RjyKqlXfgiKNmoxCQlWY=
X-Received: by 2002:a5e:c311:: with SMTP id a17mr3549242iok.12.1594152386277;
 Tue, 07 Jul 2020 13:06:26 -0700 (PDT)
MIME-Version: 1.0
References: <28bff9d7-fa2d-5284-f6d5-e08cd792c9c6@alibaba-inc.com>
 <CAM_iQpVux85OXH-oYeH15sYTb=kEj0o7uu9ug9PeTesHzXk_gQ@mail.gmail.com> <5c963736-2a83-b658-2a9d-485d0876c03f@alibaba-inc.com>
In-Reply-To: <5c963736-2a83-b658-2a9d-485d0876c03f@alibaba-inc.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 7 Jul 2020 13:06:15 -0700
Message-ID: <CAM_iQpV5LRU-JxfLETsdNqh75wv3vWyCsxiTTgC392HvTxa9CQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: sched: Lockless Token Bucket (LTB) Qdisc
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 6, 2020 at 1:34 PM YU, Xiangning
<xiangning.yu@alibaba-inc.com> wrote:
>
>
>
> On 7/6/20 1:10 PM, Cong Wang wrote:
> > On Mon, Jul 6, 2020 at 11:11 AM YU, Xiangning
> > <xiangning.yu@alibaba-inc.com> wrote:
> >> +static int ltb_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlo=
ck_t *root_lock,
> >> +                      struct sk_buff **to_free)
> >> +{
> >> +       struct ltb_sched *ltb =3D qdisc_priv(sch);
> >> +       struct ltb_pcpu_sched *pcpu_q;
> >> +       struct ltb_class *cl;
> >> +       struct ltb_pcpu_data *pcpu =3D this_cpu_ptr(ltb->pcpu_data);
> >> +       int cpu;
> >> +
> >> +       cpu =3D smp_processor_id();
> >> +       pcpu_q =3D qdisc_priv(pcpu->qdisc);
> >> +       ltb_skb_cb(skb)->cpu =3D cpu;
> >> +
> >> +       cl =3D ltb_classify(sch, ltb, skb);
> >> +       if (unlikely(!cl)) {
> >> +               kfree_skb(skb);
> >> +               return NET_XMIT_DROP;
> >> +       }
> >> +
> >> +       pcpu->active =3D true;
> >> +       if (unlikely(kfifo_put(&cl->aggr_queues[cpu], skb) =3D=3D 0)) =
{
> >> +               kfree_skb(skb);
> >> +               atomic64_inc(&cl->stat_drops);
> >> +               return NET_XMIT_DROP;
> >> +       }
> >
> >
> > How do you prevent out-of-order packets?
> >
>
> Hi Cong,
>
> That's a good question. In theory there will be out of order packets duri=
ng aggregation. While keep in mind this is per-class aggregation, and it ru=
ns at a high frequency, that the chance to have any left over skbs from the=
 same TCP flow on many CPUs is low.
>
> Also, based on real deployment experience, we haven't observed an increas=
ed out of order events even under heavy work load.
>

Yeah, but unless you always classify packets into proper flows, there
is always a chance to generate out-of-order packets here, which
means the default configuration is flawed.


> >
> >> +static int ltb_init(struct Qdisc *sch, struct nlattr *opt,
> > ...
> >> +       ltb->default_cls =3D ltb->shadow_cls; /* Default hasn't been c=
reated */
> >> +       tasklet_init(&ltb->fanout_tasklet, ltb_fanout_tasklet,
> >> +                    (unsigned long)ltb);
> >> +
> >> +       /* Bandwidth balancer, this logic can be implemented in user-l=
and. */
> >> +       init_waitqueue_head(&ltb->bwbalancer_wq);
> >> +       ltb->bwbalancer_task =3D
> >> +           kthread_create(ltb_bw_balancer_kthread, ltb, "ltb-balancer=
");
> >> +       wake_up_process(ltb->bwbalancer_task);
> >
> > Creating a kthread for each qdisc doesn't look good. Why do you
> > need a per-qdisc kthread or even a kernel thread at all?
> >
>
> We moved the bandwidth sharing out of the critical data path, that's why =
we use a kernel thread to balance the current maximum bandwidth used by eac=
h class periodically.
>
> This part could be implemented at as timer. What's your suggestion?

I doubt you can use a timer, as you call rtnl_trylock() there.
Why not use a delayed work?

Thanks.
