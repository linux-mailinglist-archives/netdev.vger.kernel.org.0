Return-Path: <netdev+bounces-1150-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD6E76FC5B2
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:59:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0920281239
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF467182A1;
	Tue,  9 May 2023 11:59:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3427DDCD
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 11:59:17 +0000 (UTC)
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94149137
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 04:59:13 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id d75a77b69052e-3f38a9918d1so120991cf.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 04:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683633552; x=1686225552;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fPmzeSv3+LQ35Fc8WXTsAP0H9FArbidk3WRpK97uUVc=;
        b=sJK31UO3zIHsGf28McXiGIpCNL45IvpI9etciMcSGtBz6ajPoLjPY9oS6Rujweng65
         Iju0fmPaCl0HI+Y7FQXs/cPz+oGU3zkkzfAklkzFrHL76U4IsIVF6MuYPM1omG2431yB
         cPNKkAogWsBV6tYIBZrC+MvWFv4I0KaTtVZBR6j/AAH33HcEHgG8UAi/9g37cKDr0bS6
         DtbiIpkefCfp1vJN3sPpnAIYA2tUeKEJI8SUPeBxARqCD0D54EN12c82bNPhF36Ux7Up
         1lWJ/EreZO/GT08PY1bSBTXTeAyrlTywN1+Rplo+ceZRmYnwQZhBOCh2XeuqLxAvRVyV
         FQbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683633552; x=1686225552;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fPmzeSv3+LQ35Fc8WXTsAP0H9FArbidk3WRpK97uUVc=;
        b=UGKyna+t4N6sMveYilQK3OIFH6EkOQF+cC/uo+pxG13wDnhrU0zxL1LpW/CteEs6SE
         50pHDd3CTM++bQ0Wa9uas1PED/bmErbQ1PhhYGszSHd+vd1qhyX0MsAbNX1nl6lS/UuO
         9DXpuyCDuBTaMYCS0lNQiPpURZxmfc6UZPXnecZUI2MhnzYz5rl/o7cbTUTZyf08cElj
         n5JcqUQVK6janydihW1ptc0RwcY+43rW9cwpxP+r9FdQCdm8xLy/YtGQM1nK44vf4him
         mGm4C44Q1bQ2gf75Jglfr0zzCvUrP9Cl7jpwTeNzG4fMlNVOTM6TEBg0qGyX/MB3rV/Z
         i8ZQ==
X-Gm-Message-State: AC+VfDx8dgrEgZp9B8HGwK104cEN6EJFxshrFfYv6h2D33XQVS3V8BTH
	UswlqVLGc0CFSs4ZyU2Dtn2VKBV3LgGkXfxswF8i7g==
X-Google-Smtp-Source: ACHHUZ6wcW8W5dOJ70M/yLaCWWp12WepbVw4SqKUU07VQAsttY+pCj5M834XwvGP//8Bd6Bx/C9/jHEGWQvAsbIao0I=
X-Received: by 2002:a05:622a:5ca:b0:3ef:1c85:5b5e with SMTP id
 d10-20020a05622a05ca00b003ef1c855b5emr196808qtb.19.1683633552342; Tue, 09 May
 2023 04:59:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230508020801.10702-1-cathy.zhang@intel.com> <20230508020801.10702-2-cathy.zhang@intel.com>
 <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
 <CH3PR11MB73459006FCE3887E1EA3B82FFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CH3PR11MB73456D792EC6E7614E2EF14DFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
In-Reply-To: <CH3PR11MB73456D792EC6E7614E2EF14DFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 9 May 2023 13:58:59 +0200
Message-ID: <CANn89iL6Ckuu9vOEvc7A9CBLGuh-EpbwFRxRAchV-6VFyhTUpg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
To: "Zhang, Cathy" <cathy.zhang@intel.com>
Cc: Paolo Abeni <pabeni@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>, 
	"kuba@kernel.org" <kuba@kernel.org>, "Brandeburg, Jesse" <jesse.brandeburg@intel.com>, 
	"Srinivas, Suresh" <suresh.srinivas@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>, 
	"You, Lizhen" <lizhen.you@intel.com>, "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 9, 2023 at 1:01=E2=80=AFPM Zhang, Cathy <cathy.zhang@intel.com>=
 wrote:
>
>
>
> > -----Original Message-----
> > From: Zhang, Cathy
> > Sent: Tuesday, May 9, 2023 6:40 PM
> > To: Paolo Abeni <pabeni@redhat.com>; edumazet@google.com;
> > davem@davemloft.net; kuba@kernel.org
> > Cc: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Srinivas, Suresh
> > <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>; You,
> > Lizhen <Lizhen.You@intel.com>; eric.dumazet@gmail.com;
> > netdev@vger.kernel.org
> > Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a p=
roper
> > size
> >
> >
> >
> > > -----Original Message-----
> > > From: Paolo Abeni <pabeni@redhat.com>
> > > Sent: Tuesday, May 9, 2023 5:51 PM
> > > To: Zhang, Cathy <cathy.zhang@intel.com>; edumazet@google.com;
> > > davem@davemloft.net; kuba@kernel.org
> > > Cc: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Srinivas, Suresh
> > > <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>; You,
> > > Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> > > netdev@vger.kernel.org
> > > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a
> > > proper size
> > >
> > > On Sun, 2023-05-07 at 19:08 -0700, Cathy Zhang wrote:
> > > > Before commit 4890b686f408 ("net: keep sk->sk_forward_alloc as smal=
l
> > > > as possible"), each TCP can forward allocate up to 2 MB of memory
> > > > and tcp_memory_allocated might hit tcp memory limitation quite soon=
.
> > > > To reduce the memory pressure, that commit keeps
> > > > sk->sk_forward_alloc as small as possible, which will be less than =
1
> > > > page size if SO_RESERVE_MEM is not specified.
> > > >
> > > > However, with commit 4890b686f408 ("net: keep sk->sk_forward_alloc
> > > > as small as possible"), memcg charge hot paths are observed while
> > > > system is stressed with a large amount of connections. That is
> > > > because
> > > > sk->sk_forward_alloc is too small and it's always less than
> > > > sk->truesize, network handlers like tcp_rcv_established() should
> > > > sk->jump to
> > > > slow path more frequently to increase sk->sk_forward_alloc. Each
> > > > memory allocation will trigger memcg charge, then perf top shows th=
e
> > > > following contention paths on the busy system.
> > > >
> > > >     16.77%  [kernel]            [k] page_counter_try_charge
> > > >     16.56%  [kernel]            [k] page_counter_cancel
> > > >     15.65%  [kernel]            [k] try_charge_memcg
> > >
> > > I'm guessing you hit memcg limits frequently. I'm wondering if it's
> > > just a matter of tuning/reducing tcp limits in /proc/sys/net/ipv4/tcp=
_mem.
> >
> > Hi Paolo,
> >
> > Do you mean hitting the limit of "--memory" which set when start contai=
ner?
> > If the memory option is not specified when init a container, cgroup2 wi=
ll
> > create a memcg without memory limitation on the system, right? We've ru=
n
> > test without this setting, and the memcg charge hot paths also exist.
> >
> > It seems that /proc/sys/net/ipv4/tcp_[wr]mem is not allowed to be chang=
ed
> > by a simple echo writing, but requires a change to /etc/sys.conf, I'm n=
ot sure
> > if it could be changed without stopping the running application.  Addit=
ionally,
> > will this type of change bring more deeper and complex impact of networ=
k
> > stack, compared to reclaim_threshold which is assumed to mostly affect =
of
> > the memory allocation paths? Considering about this, it's decided to ad=
d the
> > reclaim_threshold directly.
> >
>
> BTW, there is a SK_RECLAIM_THRESHOLD in sk_mem_uncharge previously, we
> add it back with a smaller but sensible setting.

The only sensible setting is as close as possible from 0 really.

Per-socket caches do not scale.
Sure, they make some benchmarks really look nice.

Something must be wrong in your setup, because the only small issue
that was noticed was the memcg
one that Shakeel solved last year.

If under pressure, then memory allocations are going to be slow.
Having per-socket caches is going to be unfair to sockets with empty caches=
.

