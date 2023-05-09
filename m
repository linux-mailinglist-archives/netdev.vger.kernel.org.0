Return-Path: <netdev+bounces-1237-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E262E6FCD14
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 19:58:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C5562812DE
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 17:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59D3E182D5;
	Tue,  9 May 2023 17:58:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE4DF9C5
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 17:58:16 +0000 (UTC)
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577194480
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:58:14 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id d75a77b69052e-3f38a9918d1so220721cf.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 10:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683655093; x=1686247093;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vhZkJ8mwG4mA4GCg1/8ebcBN7nEL6s99qLu8EGL+6aM=;
        b=KgfWhPK3zHiclIOgn2Kt/8GHAUxSexMKKgnsWOlc7aVOEV4EKytoa+H0EqUWWLumnT
         1dRSubDaBeFdDFq5mk6LysSPbERN+lyQPD6IuvnSJnePeVD1mQLJ88Za+dm8IVENdkjb
         WQRDUXrSe8O8ohUX6luTRGj+g5E9a9OHHVag8TjgszPmoF94rDtT+dNxqBrAns28z89w
         V5qmy+0WHT/mBZruiHDgKsBO1vYTxuKtWFMvj3ulbgcdd/+mfQsRI7sweMdZHiLG7Cab
         FDLGqCHgc/hpMLWaXSeZ00gzyUNtkn9ZNZnNo5zXiUsxk7Epss7emB+77WZKRnXVFIUf
         UZ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683655093; x=1686247093;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vhZkJ8mwG4mA4GCg1/8ebcBN7nEL6s99qLu8EGL+6aM=;
        b=Hds3nk+SJ0r0xytrioglIIooQT3TJFLrHn+b3fpBdR/srWA0BpBZBernwHAaSwDkmh
         oyH8sDd98tz/4pz3p5RZr0msa/tffFvyl9eZA+9A8iMx1WSLQSad1GhDQ4O2WLTAd8dq
         sL7KEwLtu0rc/MOIrMfZWwjEqnqN0btBbaA5M2SkIEwzz49/vSCwnGPMIziz2KxMY4Dz
         QLC8Bq7ZaSiUY+eOcBou6XTxWgDuAsS6kKe2K4qCcOpvWMF+hmV/SHS1p9wSGDB569ol
         7/qvpAL3MfV47z5QAvKfcIqckAoyvVXfVmUe0KSiC55AGn8JEBOk1CcyidUZRrofd6QA
         7HQA==
X-Gm-Message-State: AC+VfDzZcBm5AK5o9MTUIU+iP3sZ9XqZ3L1qwV7QRmrHnOhlHE4lPETr
	083YXDelht7iwYyM3u4mSGvWftbjbrrg6szyyLtMWg==
X-Google-Smtp-Source: ACHHUZ49rJPjHxjqOEHg2XTDvvYXxlAomMZ/J8dwcm1ggGpbs6cJE4E4fgmh/Nng3T5GtklLnTYVfidXTQDFZNjsIF8=
X-Received: by 2002:a05:622a:1a0a:b0:3ef:302c:319e with SMTP id
 f10-20020a05622a1a0a00b003ef302c319emr15535qtb.8.1683655093002; Tue, 09 May
 2023 10:58:13 -0700 (PDT)
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
From: Shakeel Butt <shakeelb@google.com>
Date: Tue, 9 May 2023 10:58:01 -0700
Message-ID: <CALvZod6JK1Ts90uGYSDRWXX3-D=gyN3q+Bpy-oW+dqJsjjBm2w@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
To: "Zhang, Cathy" <cathy.zhang@intel.com>, Linux MM <linux-mm@kvack.org>, 
	Cgroups <cgroups@vger.kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
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
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 9, 2023 at 8:07=E2=80=AFAM Zhang, Cathy <cathy.zhang@intel.com>=
 wrote:
>
[...]
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
>

What is the memcg hierarchy of this workload? Is each server and
client processes running in their own memcg? How many levels of
memcgs? Are you setting memory.max and memory.high to some value? Also
how are you limiting the processes to CPUs? cpusets?

