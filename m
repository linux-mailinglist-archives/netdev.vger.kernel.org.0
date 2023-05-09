Return-Path: <netdev+bounces-1210-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B6686FCA6C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 17:43:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92A9B280E09
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0CC618017;
	Tue,  9 May 2023 15:43:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C64017FEF
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 15:43:37 +0000 (UTC)
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2E544B9
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 08:43:35 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id d75a77b69052e-3ef34c49cb9so182621cf.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 08:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683647015; x=1686239015;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RC10H+upWtMjNGVIZqTpAxUfNcLAVHKwaMmhHcZ3sPY=;
        b=Y7LsPKwjFSxN+pOrzzGlwH/M+2V0wTZpL3YArHsDbtRGH9Tf+LJNXqcS9i6Z5ozJRQ
         MeJwjnU7fmRsaQfsvBX0iwGpQ+NaTmo6PzT3tuA4I/rmhrlZsB7LyVzJ9gnGGbfY2jkb
         YSVW+B2v7ph+U+gCf2N5ndcXvZAKuRxe3Od7qI8XnHWji+RhGoH5yUIUWdQGlopDZU/0
         ZhlMWysxq/ae28tjQ/sqjb26eKyfxjWzdf15f+QBUKoUgQpxuIANDg9pazrqisWXPqnQ
         nBf/aiR1tax+tOXmTJrwBf8BBhcMtXfJQR57a4GmS3ZL9L7+eZljPB6+Hi8ELj6FXdri
         5Vfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683647015; x=1686239015;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RC10H+upWtMjNGVIZqTpAxUfNcLAVHKwaMmhHcZ3sPY=;
        b=UPDfl3tyG+1DRMTr6EP0Nojntmj3RJ2k+p63uRX7vkuDE2HaI5bdynnnzA5eR650QT
         asOYaA4TjwwbB+9m+Sbm2ta9CPFaVnsufk4a1nup4clDZuWlhYJUkgJhvdV9ldyjtBqr
         mTt9FkdtFx4CTe83HseYhaHiQpdLNZkhKN5n12Y+y1WaQvpKuRYEeEhftm1oo2aqOQrX
         i1fAOiU2DzIGzendYPXd3photqMX8tRwNtO/cYRm78rJVT2i6dgZQo4wb7D0IGTiXDab
         u+WsO2x0qjJFrKH0w7vucT8hUra5+7pC1jF9HfRf27eoEPLSDSO7E5uHge7JUWzdkpkv
         XlNw==
X-Gm-Message-State: AC+VfDwQTSImdOeg+ylTai/49akrAeggbYzDRafy49lmKGePv+Iy8x1M
	vxoseLNsx2EwmENqmfjvYA6CBTr6wZhL8uUFMj7qKQ==
X-Google-Smtp-Source: ACHHUZ57W1nOa0X4ewHSLcN8W7SiiUfEroHroqth8SD+GGr+ntwQzNNnVdB5Q+DuYqH+zWOvLBs1u6pRQGJCDv4G0Zc=
X-Received: by 2002:a05:622a:1890:b0:3ef:330c:8f9e with SMTP id
 v16-20020a05622a189000b003ef330c8f9emr429089qtc.10.1683647014659; Tue, 09 May
 2023 08:43:34 -0700 (PDT)
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
 <CANn89iL6Ckuu9vOEvc7A9CBLGuh-EpbwFRxRAchV-6VFyhTUpg@mail.gmail.com> <CH3PR11MB73458BB403D537CFA96FD8DDFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
In-Reply-To: <CH3PR11MB73458BB403D537CFA96FD8DDFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 9 May 2023 17:43:21 +0200
Message-ID: <CANn89iJvpgXTwGEiXAkFwY3j3RqVhNzJ_6_zmuRb4w7rUA_8Ug@mail.gmail.com>
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

On Tue, May 9, 2023 at 5:07=E2=80=AFPM Zhang, Cathy <cathy.zhang@intel.com>=
 wrote:
>
>
>
> > -----Original Message-----
> > From: Eric Dumazet <edumazet@google.com>
> > Sent: Tuesday, May 9, 2023 7:59 PM
> > To: Zhang, Cathy <cathy.zhang@intel.com>
> > Cc: Paolo Abeni <pabeni@redhat.com>; davem@davemloft.net;
> > kuba@kernel.org; Brandeburg, Jesse <jesse.brandeburg@intel.com>;
> > Srinivas, Suresh <suresh.srinivas@intel.com>; Chen, Tim C
> > <tim.c.chen@intel.com>; You, Lizhen <lizhen.you@intel.com>;
> > eric.dumazet@gmail.com; netdev@vger.kernel.org; Shakeel Butt
> > <shakeelb@google.com>
> > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a p=
roper
> > size
> >
> > On Tue, May 9, 2023 at 1:01=E2=80=AFPM Zhang, Cathy <cathy.zhang@intel.=
com>
> > wrote:
> > >
> > >
> > >
> > > > -----Original Message-----
> > > > From: Zhang, Cathy
> > > > Sent: Tuesday, May 9, 2023 6:40 PM
> > > > To: Paolo Abeni <pabeni@redhat.com>; edumazet@google.com;
> > > > davem@davemloft.net; kuba@kernel.org
> > > > Cc: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Srinivas, Sures=
h
> > > > <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>;
> > > > You, Lizhen <Lizhen.You@intel.com>; eric.dumazet@gmail.com;
> > > > netdev@vger.kernel.org
> > > > Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as
> > > > a proper size
> > > >
> > > >
> > > >
> > > > > -----Original Message-----
> > > > > From: Paolo Abeni <pabeni@redhat.com>
> > > > > Sent: Tuesday, May 9, 2023 5:51 PM
> > > > > To: Zhang, Cathy <cathy.zhang@intel.com>; edumazet@google.com;
> > > > > davem@davemloft.net; kuba@kernel.org
> > > > > Cc: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Srinivas,
> > > > > Suresh <suresh.srinivas@intel.com>; Chen, Tim C
> > > > > <tim.c.chen@intel.com>; You, Lizhen <lizhen.you@intel.com>;
> > > > > eric.dumazet@gmail.com; netdev@vger.kernel.org
> > > > > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc
> > > > > as a proper size
> > > > >
> > > > > On Sun, 2023-05-07 at 19:08 -0700, Cathy Zhang wrote:
> > > > > > Before commit 4890b686f408 ("net: keep sk->sk_forward_alloc as
> > > > > > small as possible"), each TCP can forward allocate up to 2 MB o=
f
> > > > > > memory and tcp_memory_allocated might hit tcp memory limitation
> > quite soon.
> > > > > > To reduce the memory pressure, that commit keeps
> > > > > > sk->sk_forward_alloc as small as possible, which will be less
> > > > > > sk->than 1
> > > > > > page size if SO_RESERVE_MEM is not specified.
> > > > > >
> > > > > > However, with commit 4890b686f408 ("net: keep
> > > > > > sk->sk_forward_alloc as small as possible"), memcg charge hot
> > > > > > paths are observed while system is stressed with a large amount
> > > > > > of connections. That is because
> > > > > > sk->sk_forward_alloc is too small and it's always less than
> > > > > > sk->truesize, network handlers like tcp_rcv_established() shoul=
d
> > > > > > sk->jump to
> > > > > > slow path more frequently to increase sk->sk_forward_alloc. Eac=
h
> > > > > > memory allocation will trigger memcg charge, then perf top show=
s
> > > > > > the following contention paths on the busy system.
> > > > > >
> > > > > >     16.77%  [kernel]            [k] page_counter_try_charge
> > > > > >     16.56%  [kernel]            [k] page_counter_cancel
> > > > > >     15.65%  [kernel]            [k] try_charge_memcg
> > > > >
> > > > > I'm guessing you hit memcg limits frequently. I'm wondering if
> > > > > it's just a matter of tuning/reducing tcp limits in
> > /proc/sys/net/ipv4/tcp_mem.
> > > >
> > > > Hi Paolo,
> > > >
> > > > Do you mean hitting the limit of "--memory" which set when start
> > container?
> > > > If the memory option is not specified when init a container, cgroup=
2
> > > > will create a memcg without memory limitation on the system, right?
> > > > We've run test without this setting, and the memcg charge hot paths=
 also
> > exist.
> > > >
> > > > It seems that /proc/sys/net/ipv4/tcp_[wr]mem is not allowed to be
> > > > changed by a simple echo writing, but requires a change to
> > > > /etc/sys.conf, I'm not sure if it could be changed without stopping
> > > > the running application.  Additionally, will this type of change
> > > > bring more deeper and complex impact of network stack, compared to
> > > > reclaim_threshold which is assumed to mostly affect of the memory
> > > > allocation paths? Considering about this, it's decided to add the
> > reclaim_threshold directly.
> > > >
> > >
> > > BTW, there is a SK_RECLAIM_THRESHOLD in sk_mem_uncharge previously,
> > we
> > > add it back with a smaller but sensible setting.
> >
> > The only sensible setting is as close as possible from 0 really.
> >
> > Per-socket caches do not scale.
> > Sure, they make some benchmarks really look nice.
>
> Benchmark aims to help get better performance in reality I think :-)

Sure, but system stability comes first.

>
> >
> > Something must be wrong in your setup, because the only small issue tha=
t
> > was noticed was the memcg one that Shakeel solved last year.
>
> As mentioned in commit log, the test is to create 8 memcached-memtier pai=
rs
> on the same host, when server and client of the same pair connect to the =
same
> CPU socket and share the same CPU set (28 CPUs), the memcg overhead is
> obviously high as shown in commit log. If they are set with different CPU=
 set from
> separate CPU socket, the overhead is not so high but still observed.  Her=
e is the
> server/client command in our test:
> server:
> memcached -p ${port_i} -t ${threads_i} -c 10240
> client:
> memtier_benchmark --server=3D${memcached_id} --port=3D${port_i} \
> --protocol=3Dmemcache_text --test-time=3D20 --threads=3D${threads_i} \
> -c 1 --pipeline=3D16 --ratio=3D1:100 --run-count=3D5
>
> So, is there anything wrong you see?

Please post /proc/sys/net/ipv4/tcp_[rw]mem setting, and "cat
/proc/net/sockstat" while the test is running.

Some mm experts should chime in, this is not a networking issue.

I suspect some kind of accidental false sharing.

Can you post this from your .config

grep RANDSTRUCT .config

