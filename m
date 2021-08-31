Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AFE3FC551
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 12:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240785AbhHaJzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 05:55:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38737 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240676AbhHaJzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 05:55:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630403685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sSiG1T10K5QaNICdBn+fQ2XcRsLKJ5lbf7eHXoqa2lw=;
        b=Q5NAl3Jit4fuTCkeYSYapFIJ2Tx8wk8ja9kdv7YxeeUetDsHRN8wFXPbP6UIxS2oiTANJQ
        CRrLy9clAYuPPJEJYLhj1eqRmk6iVqaVC1nLAFm9jLO1GEyUSUDMQL3CT3lV+Z1dv1uZ3i
        wMDr/om8mndFaXRs+SZWQRe7nXZNGlM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-TuPfFEqgNa2QMv1y1KF2jg-1; Tue, 31 Aug 2021 05:54:44 -0400
X-MC-Unique: TuPfFEqgNa2QMv1y1KF2jg-1
Received: by mail-ej1-f72.google.com with SMTP id x21-20020a170906135500b005d8d4900c5eso350969ejb.4
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 02:54:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sSiG1T10K5QaNICdBn+fQ2XcRsLKJ5lbf7eHXoqa2lw=;
        b=lN/8ZK3A6v6xYFPBv2EaSCp046yWmYcDTOiDLNZOOZIzBqPloQgyiFm7CHxpYBp2Jh
         XIdf2XRsLDz6GpbLOCWIoSceTwZTw5FfoZ8ldlNvBha4VBnd48Tr7sY9Vuh256Ynx0wD
         tvg+qmnAwGLzWz6s5qmC+J3pq+KFA8FgDRtpFr0/BAyx0pe5KNOQuh4+5EpmZCTdDjfF
         seORnzQTZStIViJ+1wVVEBtsJKkEmDzsAr3CL9ZvdTmtLFTatWKwzyuBq4pWMyQ3ricq
         XNa1499dqCoalosmxuETnDDCCZbUO78FRpVBNGMW7yriw4eS/sJe4RHQBsEBPpum3sqX
         w+tw==
X-Gm-Message-State: AOAM532UH6TFsXYCIuC6aGSWpWQV7PyKbj/wFyzDg5I1cM9linLYha9T
        5iJ/fcP0WYLkHiUEfc2o1gaS3BrKgmfJfwW4/hvN8ehbnE0TCLBv52zaxhPD4ds7K9aK5AhMDjt
        uBdl16PGqM+U668/6vjQVvSl7oOsLId5PwbyYRYDORcsPb2qbdG3Y1yi1IK/Bu4B1Y9iG
X-Received: by 2002:a17:907:1de1:: with SMTP id og33mr29950360ejc.278.1630403682716;
        Tue, 31 Aug 2021 02:54:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYeLEmgIbCsy3e7GZK2RW70u9rFHLj8LQGTbstaU/7lj9JeND1/RrXQFn8ICZwviZXdC1Fdg==
X-Received: by 2002:a17:907:1de1:: with SMTP id og33mr29950333ejc.278.1630403682325;
        Tue, 31 Aug 2021 02:54:42 -0700 (PDT)
Received: from localhost (net-188-218-11-235.cust.vodafonedsl.it. [188.218.11.235])
        by smtp.gmail.com with ESMTPSA id j22sm8141860ejt.11.2021.08.31.02.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 02:54:41 -0700 (PDT)
Date:   Tue, 31 Aug 2021 11:54:40 +0200
From:   Davide Caratti <dcaratti@redhat.com>
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     xiyou.wangcong@gmail.com, davem@davemloft.net, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, liuhangbin@gmail.com,
        petrm@mellanox.com
Subject: Re: [PATH net] net/sched: ets: fix crash when flipping from 'strict'
 to 'quantum'
Message-ID: <YS38YB9JTSHeYgJG@dcaratti.users.ipa.redhat.com>
References: <2fdc7b4e11c3283cd65c7cf77c81bd6687a32c20.1629844159.git.dcaratti@redhat.com>
 <CAM_iQpUryQ8Q9cd9Oiv=hxAgpqfCz=j4E=c=hskbPE2+VB-ZvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUryQ8Q9cd9Oiv=hxAgpqfCz=j4E=c=hskbPE2+VB-ZvQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello Cong, thanks a lot for looking at this!

On Mon, Aug 30, 2021 at 05:43:09PM -0700, Cong Wang wrote:
> On Tue, Aug 24, 2021 at 3:34 PM Davide Caratti <dcaratti@redhat.com> wrote:
> > When the change() function decreases the value of 'nstrict', we must take
> > into account that packets might be already enqueued on a class that flips
> > from 'strict' to 'quantum': otherwise that class will not be added to the
> > bandwidth-sharing list. Then, a call to ets_qdisc_reset() will attempt to
> > do list_del(&alist) with 'alist' filled with zero, hence the NULL pointer
> > dereference.
> 
> I am confused about how we end up having NULL in list head.
> 
> From your changelog, you imply it happens when we change an existing
> Qdisc, but I don't see any place that could set this list head to NULL.
> list_del() clearly doesn't set NULL.

right, the problem happens when we try to *decrease* the value of 'nstrict'
while traffic is being loaded.

ETS classes from 0 to nstrict - 1 don't initialize this list at all, nor they
use it. The initialization happens when the first packet is enqueued to one of
the bandwidth-sharing classes (from nstrict to nbands - 1), see [1]).

However, if we modify the value of 'nstrict' while q->classes[i].qdisc->q.len is
greater than zero, the list initialization is probably not going to happen, so
the struct

q->classes[i].alist

remains filled with zero even since the first allocation, like you mentioned below:

> But if it is a new Qdisc, Qdisc is allocated with zero's hence having NULL
> as list head. However, in this case, q->nstrict should be 0 before the loop,

^^ this. But you are wrong, q->nstrict can be any value from 0 to 16 (inclusive)
before the loop. As the value of 'nstrict' is reduced (e.g. from 4 to 0), the code
can reach the loop in ets_qdisc_change() with the following 4 conditions
simultaneously true:

1) nstrict = 0
2) q->nstrict = 4
3) q->classes[2].qdisc->q.qlen  greater than zero
4) q->classes[2].alist filled with 0

then, the value of q->nstrict is updated to 0. After that, ets_qdisc_reset() can be
called on unpatched Linux with the following 3 conditions simultaneously true:

a) q->nstrict = 0
b) q->classes[2].qdisc->q.qlen greater than zero
c) q->classes[2].alist filled with 0

that leads to the reported crash.

> so I don't think your code helps at all as the for loop can't even be entered?

The first code I tried was just doing INIT_LIST_HEAD(&q->classes[i].alist), with 
i ranging from nstrict to q->nstrict - 1: it fixed the crash in ets_qdisc_reset().

But then I observed that classes changing from strict to quantum were not sharing
any bandwidth at all, and they had a non-empty backlog even after I stopped all
the traffic: so, I added the 

	if (q->classes[i].qdisc->q.qlen) {
		list_add_tail(&q->classes[i].alist, &q->active);
		q->classes[i].deficit = quanta[i];
	}

part, that updates the DRR list with non-empty classes that are changing from
strict to DRR. After that, I verified that all classes were depleted correctly.

On a second thought, this INIT_LIST_HEAD(&q->classes[i].alist) line is no more
useful. If q->classes[i].qdisc->q.qlen is 0, either it remains 0 until the call
to ets_qdisc_reset(), or some packet is enqueued after q->nstrict is updated,
and the enqueueing of a 'first' packet [1] will fix the value of
q->classes[i].alist.
Finally, if q->classes[i].qdisc->q.qlen is bigger than zero, the list_add_tail()
part of my patch covers the missing update of the DRR list. In all these cases,
the NULL dereference in ets_qdisc_reset() is prevented.

So, I can probably send a patch (for net-next, when it reopens) that removes
this INIT_LIST_HEAD() line; anyway, its presence is harmless IMO. WDYT?

> 
> Thanks.

BTW, please find below a reproducer that's more efficient than kselftests in
seeing the problem:

    1   #!/bin/bash
    2   ip link del dev ddd0 >/dev/null 2>&1
    3   ip link add dev ddd0 type dummy
    4   ip link set dev ddd0 up
    5   tc qdisc add dev ddd0 handle 1: root tbf rate 100kbit latency 1000ms burst 1Mbit
    6   tc qdisc add dev ddd0 handle 10: parent 1: ets bands 4 strict 4 priomap  2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
    7   tc qdisc show dev ddd0
    8   mausezahn ddd0 -A 10.10.10.1 -B 10.10.10.2 -c 0 -a own -b 00:c1:a0:c1:a0:00 -t udp &
    9   mpid=$!
   10   sleep 5
   11   tc qdisc change dev ddd0 handle 10: ets bands 8 quanta 2500 2500 2500 2500 2500 2500 2500 2500  priomap 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
   12   tc qdisc del dev ddd0 root
   13   sleep 1
   14   tc qdisc show dev ddd0
   15   kill $mpid
   16   rmmod sch_ets

Line 11 changes the ets qdisc from 4 prio to 8 DRR, so the value of q->nstrict
changes from 4 to 0. The crash in ets_qdisc_reset() happens with band number #2
(that's the only class being loaded with traffic during the test).

thanks!

-- 
davide

[1] https://elixir.bootlin.com/linux/v5.14/source/net/sched/sch_ets.c#L445

