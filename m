Return-Path: <netdev+bounces-2760-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E281B703DD5
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 21:50:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D16F11C20B9D
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 19:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83A4119528;
	Mon, 15 May 2023 19:50:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E0ED2E4
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 19:50:45 +0000 (UTC)
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F085AD2C
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:50:43 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id d75a77b69052e-3f38a9918d1so1541171cf.1
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684180242; x=1686772242;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R9rBJ3Z6bMHq4Ea+F9E390Qio2yO4hD5BQLQUaMJTwA=;
        b=zuGmhQqWoc00Zv+gSniT0ih5yLMGbWSeEIuQWzHekcnhvcSP3KRGL9187CcmxOPax+
         MtLWl4dMw6+fJkaOFeH/pb6g8aCL788Q5ZZGDWgqcMRScbxYfgV/MyGdvNzRfE8+31f1
         nD2iSIsiwu4VYaNTTBv35fZqIEC2HvSxslyNnPR+trOvrP/gt6qnD8VQaqzf8VrVJmwg
         y0ds0jsLE2nvp5xBk9c9AGFPD1mhBoCLZEtzLWpFD8Q5hCJvGHjz1E9xXVphXw1eCiQQ
         rVpBywpzQX9RwqIMhWYO9rCR4/kJ///SolL7aMR4r8Xqev9LMV6pO/WIocrN3XFUtjjU
         aOWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684180242; x=1686772242;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R9rBJ3Z6bMHq4Ea+F9E390Qio2yO4hD5BQLQUaMJTwA=;
        b=NKwLA8t3jjprHnHHAWCAHD1q+TqC/XZD/UmQlH8YjYA6OGlOrPCcWRF0aqmwmj0EVc
         kpgApNYiZ1P9PAQcgxev3IVqs3lkbZhiWzT+nhBf0LNZTeGqpD7EJfEolMYibI2D12nX
         XariZTo4RuiMn+QrV9XRw5vD8akRQycTGi4GztIIAFdumdk2VscnzGy9n/JNP/uxFG+M
         rMztJ7ll8ZSAkc0MDHo2gdBJBCohQygioxe3RCmo21DphTxP5fCYLee6zQ1m4Fgr1M8j
         v71wpGWKzDtut0VD6uYAZO8U5b7ZmY/k7QQLt2cXB9IRStQbVJhptf6jfCBuNlo3OXd+
         RtrQ==
X-Gm-Message-State: AC+VfDyZTMEW9jT16gHFzhihifFXjKYKSY5cLWWSFKL1NBRKog9Bha+l
	5kY4vxXYTcx3yvkVu0UDuVr2RYrJTCqHAchsA2Do9A==
X-Google-Smtp-Source: ACHHUZ7XVTjje4a4teCP0LdhFit4xaugXUIJ68JcFbfxEOfJ5reZF2OVJCCDEM9N2UqtbUc4EJnvx4PSN18tj2biYFo=
X-Received: by 2002:a05:622a:178a:b0:3ef:31a5:13c with SMTP id
 s10-20020a05622a178a00b003ef31a5013cmr29129qtk.3.1684180242180; Mon, 15 May
 2023 12:50:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <20230512171702.923725-1-shakeelb@google.com> <CH3PR11MB7345035086C1661BF5352E6EFC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod7n2yHU8PMn5b39w6E+NhLtBynDKfo1GEfXaa64_tqMWQ@mail.gmail.com> <CH3PR11MB7345E9EAC5917338F1C357C0FC789@CH3PR11MB7345.namprd11.prod.outlook.com>
In-Reply-To: <CH3PR11MB7345E9EAC5917338F1C357C0FC789@CH3PR11MB7345.namprd11.prod.outlook.com>
From: Shakeel Butt <shakeelb@google.com>
Date: Mon, 15 May 2023 12:50:31 -0700
Message-ID: <CALvZod6txDQ9kOHrNFL64XiKxmbVHqMtWNiptUdGt9UuhQVLOQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
To: "Zhang, Cathy" <cathy.zhang@intel.com>, Yin Fengwei <fengwei.yin@intel.com>, 
	kernel test robot <oliver.sang@intel.com>, Feng Tang <feng.tang@intel.com>
Cc: Eric Dumazet <edumazet@google.com>, Linux MM <linux-mm@kvack.org>, 
	Cgroups <cgroups@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>, 
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>, "Srinivas, Suresh" <suresh.srinivas@intel.com>, 
	"Chen, Tim C" <tim.c.chen@intel.com>, "You, Lizhen" <lizhen.you@intel.com>, 
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

+Feng, Yin and Oliver

On Sun, May 14, 2023 at 11:27=E2=80=AFPM Zhang, Cathy <cathy.zhang@intel.co=
m> wrote:
>
>
>
> > -----Original Message-----
> > From: Shakeel Butt <shakeelb@google.com>
> > Sent: Monday, May 15, 2023 12:13 PM
> > To: Zhang, Cathy <cathy.zhang@intel.com>
> > Cc: Eric Dumazet <edumazet@google.com>; Linux MM <linux-
> > mm@kvack.org>; Cgroups <cgroups@vger.kernel.org>; Paolo Abeni
> > <pabeni@redhat.com>; davem@davemloft.net; kuba@kernel.org;
> > Brandeburg, Jesse <jesse.brandeburg@intel.com>; Srinivas, Suresh
> > <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>; You,
> > Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> > netdev@vger.kernel.org
> > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a p=
roper
> > size
> >
> > On Sun, May 14, 2023 at 8:46=E2=80=AFPM Zhang, Cathy <cathy.zhang@intel=
.com>
> > wrote:
> > >
> > >
> > >
> > > > -----Original Message-----
> > > > From: Shakeel Butt <shakeelb@google.com>
> > > > Sent: Saturday, May 13, 2023 1:17 AM
> > > > To: Zhang, Cathy <cathy.zhang@intel.com>
> > > > Cc: Shakeel Butt <shakeelb@google.com>; Eric Dumazet
> > > > <edumazet@google.com>; Linux MM <linux-mm@kvack.org>; Cgroups
> > > > <cgroups@vger.kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> > > > davem@davemloft.net; kuba@kernel.org; Brandeburg@google.com;
> > > > Brandeburg, Jesse <jesse.brandeburg@intel.com>; Srinivas, Suresh
> > > > <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>;
> > > > You, Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> > > > netdev@vger.kernel.org
> > > > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as
> > > > a proper size
> > > >
> > > > On Fri, May 12, 2023 at 05:51:40AM +0000, Zhang, Cathy wrote:
> > > > >
> > > > >
> > > > [...]
> > > > > >
> > > > > > Thanks a lot. This tells us that one or both of following
> > > > > > scenarios are
> > > > > > happening:
> > > > > >
> > > > > > 1. In the softirq recv path, the kernel is processing packets
> > > > > > from multiple memcgs.
> > > > > >
> > > > > > 2. The process running on the CPU belongs to memcg which is
> > > > > > different from the memcgs whose packets are being received on t=
hat
> > CPU.
> > > > >
> > > > > Thanks for sharing the points, Shakeel! Is there any trace record=
s
> > > > > you want to collect?
> > > > >
> > > >
> > > > Can you please try the following patch and see if there is any
> > improvement?
> > >
> > > Hi Shakeel,
> > >
> > > Try the following patch, the data of 'perf top' from system wide
> > > indicates that the overhead of page_counter_cancel is dropped from 15=
.52%
> > to 4.82%.
> > >
> > > Without patch:
> > >     15.52%  [kernel]            [k] page_counter_cancel
> > >     12.30%  [kernel]            [k] page_counter_try_charge
> > >     11.97%  [kernel]            [k] try_charge_memcg
> > >
> > > With patch:
> > >     10.63%  [kernel]            [k] page_counter_try_charge
> > >      9.49%  [kernel]            [k] try_charge_memcg
> > >      4.82%  [kernel]            [k] page_counter_cancel
> > >
> > > The patch is applied on the latest net-next/main:
> > > befcc1fce564 ("sfc: fix use-after-free in
> > > efx_tc_flower_record_encap_match()")
> > >
> >
> > Thanks a lot Cathy for testing. Do you see any performance improvement =
for
> > the memcached benchmark with the patch?
>
> Yep, absolutely :- ) RPS (with/without patch) =3D +1.74

Thanks a lot Cathy.

Feng/Yin/Oliver, can you please test the patch at [1] with other
workloads used by the test robot? Basically I wanted to know if it has
any positive or negative impact on other perf benchmarks.

[1] https://lore.kernel.org/all/20230512171702.923725-1-shakeelb@google.com=
/

Thanks in advance.

