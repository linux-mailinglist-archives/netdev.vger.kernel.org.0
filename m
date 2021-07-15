Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757C63C9768
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 06:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbhGOEbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 00:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbhGOEbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 00:31:14 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26962C06175F
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 21:28:21 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y4so3916586pfi.9
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 21:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f0pjWiua39O5r8qC5j0tpvn+ZTQO/DefPsrjyZWcdVA=;
        b=pMwPjZLdGxgKmDRjVuvem+GESeHswUC6PsaVR1nqRalLPfnC3Uvyynzxq3sVJk6X4Z
         8wvaLu5t4l7oNkLPtbMxOc0PKDBpcFTETcYv3H9vJz4ylelnmPsXbeF56IsrZgFw7EIb
         DeqowznMFGCCy7od3bIN2L4UzXqLlRpJ/TCAbr/htk+ee0qoBEL43WRIt2mTsJ3xhZoZ
         gZxK72n3zAkQ3NQzS3BEoZk7MsQP+bcA1gMKbYOeoIKSVmh3YyVHkCGwgce/Q1KD1jXh
         a1YUIlmGeBpjZE/telXmpJ4pw2cLxvhage0vPMYqFB/CleX1O+23dwPYTxn5APqSeQGA
         AC2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f0pjWiua39O5r8qC5j0tpvn+ZTQO/DefPsrjyZWcdVA=;
        b=lNzWUyo+akd22+RgG6E4fLC1JLA1fp5094MFOx+zdOoo2tid/JCgGdGi0zflQKsqjE
         SM7o3lFyrXulBkw+5Zx7czuRLO11YuKnja32UGPg2C0FvtCzCuuDj2sKqMG26bjJIVTV
         L0Er3oX7E3aH2H9cm3lD64i3GCCZbmnqz00B32IxQTnTaX7X+fkf4upfKmf2XXGO+OSN
         QbLG4C0rXmiCahBh1PaN8YLhZDvS+K3SeIowXFZh26MKouTYwWVXcQikRfaBumrGgJyl
         3r9FBauLhsMfictHwAapZF2TRAksUBStkzbkJXPhOLCmqh9MWTQ490bSWQN7fGtumK6m
         JpAQ==
X-Gm-Message-State: AOAM5339+r2+MgIT/YNyK1xT+hlwY9rXbmMAtKO/tMdQGVul3pbIXhtV
        FjnSRiSayVDXr+DJ80WrnojTjo66GmPFHUgNocM=
X-Google-Smtp-Source: ABdhPJyz73rlMPQfqjcx5VSXoQi0R58NzsmLN/Okk+vykhClS5ZkPYjFK2rG9ZNcOLC/t4Faa5vAih5O0zdclCqD2P8=
X-Received: by 2002:a63:4302:: with SMTP id q2mr2175919pga.428.1626323300710;
 Wed, 14 Jul 2021 21:28:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210711190308.8476-1-xiyou.wangcong@gmail.com>
 <CAMDZJNWWq2TGb6-nZRbBNfLevOyD2oSn941Nw_+7q0QzVep_GA@mail.gmail.com>
 <CAM_iQpUmO8S-7cgG=yy2TsNoc9nHpW__-WCfhcfV-_eAf46K7A@mail.gmail.com>
 <CAMDZJNXbwzXrHX1UT+DLsJvbKPh70-OPyrkTV=D05a5Mwcko3w@mail.gmail.com>
 <CAM_iQpUG28PBhXmqQeEzcWq8cNLFH1BzXaZ1FWGu1jqObGfdwg@mail.gmail.com>
 <CAMDZJNV9tbGE0Y1nZgMcp2Z5LU5Cb7YfJ+mS9rVogrin8SGxjQ@mail.gmail.com>
 <CAM_iQpVAuF0Pq1qmKRWoOvBPPMSaf1seKykEwYvVhm0tRkNo4A@mail.gmail.com>
 <CAMDZJNW5F3MDPYaRhx1o1ifPXQPnW_fdML=ap+Gis2PG9FB9Pg@mail.gmail.com>
 <CAM_iQpWHvY1h-xdUxWk+PhQcMRqSmnDpzxvBLXKh1mARYzQfmg@mail.gmail.com>
 <CAMDZJNUMXFYJ9_UdWnv8j74fJZ4T6psdxMvbmRBzTAJuZBeQAA@mail.gmail.com>
 <CAM_iQpXhC6Jj+KE-L8UTyasTgVDyLDPS4rbXau2MVzwH41N-7g@mail.gmail.com>
 <CAMDZJNXzPum_1_GkW+w28QgVhcMvq3rz=OOEE5XbdDfTYvCTAw@mail.gmail.com>
 <CAM_iQpUJcL23=iZQqMwiiFNnDP12oWk+CVHUe5BYZ812z31DCQ@mail.gmail.com> <CAMDZJNXKvyXUZy53=CDyQ8RNfNK2_0-arxRWn40LoLOZY5F1UQ@mail.gmail.com>
In-Reply-To: <CAMDZJNXKvyXUZy53=CDyQ8RNfNK2_0-arxRWn40LoLOZY5F1UQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 14 Jul 2021 21:28:09 -0700
Message-ID: <CAM_iQpUv+Vw4WsRaPyQxOecDsDQNtDOg6iraXv27uGLPZd01FQ@mail.gmail.com>
Subject: Re: [Patch net-next v2] net_sched: introduce tracepoint trace_qdisc_enqueue()
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 6:57 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Mon, Jul 12, 2021 at 12:45 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Sun, Jul 11, 2021 at 9:41 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > On Mon, Jul 12, 2021 at 12:20 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > On Sun, Jul 11, 2021 at 9:12 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > > >
> > > > > On Mon, Jul 12, 2021 at 12:02 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > > >
> > > > > > On Sun, Jul 11, 2021 at 8:49 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > > > > >
> > > > > > > On Mon, Jul 12, 2021 at 11:39 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > > > > >
> > > > > > > > On Sun, Jul 11, 2021 at 8:36 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > > > > > > >
> > > > > > > > > On Mon, Jul 12, 2021 at 11:23 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > > > > > > > Sure, in that case a different packet is dropped, once again you
> > > > > > > > > > can trace it with kfree_skb() if you want. What's the problem?
> > > > > > > > > It's ok, but we can make it better. Yunsheng Lin may have explained why?
> > > > > > > >
> > > > > > > > Why it is better to trace dropped packets both in enqueue and in kfree_skb()?
> > > > > > > I mean we can use one tracepoint to know what happened in the queue,
> > > > > > > not necessary to trace enqueue and  kfree_skb()
> > > > > >
> > > > > > This is wrong, packets can be dropped for other reasons too, tracing
> > > > > no matter where the packet is dropped, we should allow user to know
> > > > > whether dropped in the enqueue.  and the
> > > > > what the return value.
> > > >
> > > > Again you can know it by kfree_skb(). And you can not avoid
> > > > kfree_skb() no matter how you change enqueue. So, I don't see your
> > > No, If I know what value returned for specified qdisc , I can know
> > > what happened, not necessarily kfree_skb()
> >
> > This is wrong. You have to trace dropped packets because you
> > need to know when to delete the key (skb address) from the hashtable
> > you use to calculate the latency. You save the key on enqueue and
> > remove it on both dequeue and kfree_skb, the only difference is you
> No, we can set the timestamp or cb in  skb in enqueue and check them in dequeue.
> we may not use the hashtable.

Are you sure this is safe?? How do you ensure we have enough space
in skb->cb[]? More importantly, why do we even modify skb in tracepoint?

> If we use hashtable, we still can check the return value, save them to
> hashtable or not.

How many times do I have to repeat the return value of enqueue is not
sufficient even if you trace it? Can't you just look at codel_dequeue()
and tell me how a drop at dequeue can be reflected to enqueue?

Thanks.
