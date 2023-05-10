Return-Path: <netdev+bounces-1549-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3436E6FE44F
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 21:00:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BBF51C20DBC
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 19:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B775174EC;
	Wed, 10 May 2023 19:00:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F181F36F
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:00:15 +0000 (UTC)
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21CD128
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 12:00:14 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-3ef34c49cb9so532031cf.1
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 12:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683745214; x=1686337214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xKsdgPcqj7KmYQZqWilT9rwcetEcIXv94yhUAf7G1sA=;
        b=BvJIvdH3Wybsgy9FE4pyTQfaOjRyNKOOtwD8AxKBkOLwQnEb8UA1Ez5R0nRn2CFFBL
         BXgoH7pw0kursav4wE2lwTrsKDnbBpwm7XG4ro5lrOuMCnNM9OqssguSNAUo7HbNaWwC
         j40w6tVnkluvyUchlgU8rYyRRcEQwmE3Zpnbh6RscDtfNz10rYG0KfpUKVd8wmoNZj9I
         vTdcpjPoxtgDsptCivj+6K0OgYH6Bcgllqe2Y3mDvoTxA67v54GNd+C7Q5M4TB3/70n0
         h5NlSITmtP1wgtX8LZtx21dkK0mPYkk0oTPqWfrXi9seT6ecC66ADSSg2marBGDzT/7q
         kIZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683745214; x=1686337214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xKsdgPcqj7KmYQZqWilT9rwcetEcIXv94yhUAf7G1sA=;
        b=PZThso9nh1i+I3A8DuHaq3WQ57EbYexf53PYmzTwJ7IL4b56BK+I+GlJD1Jr1Ab2Sz
         74/ucWRsiWo3if0Z8RnTtORM006xRpj9jKe9tAZl3zWeMqwCm0ajhwU6YptyYXuA8FsT
         rgL3cK2gaZzkQeEPa7o4OzaUVp3uPqGr2LWP8XRTaItQR0prES3jUsaR7wsZNg59+0oc
         sE3xXFrgL2izDAoAczkVeMhmNKqDQZQfrgV9/shpZcuHeYiHU23NsW9rVr7rlNgnf+ZK
         D/XH2nRSA4pXfsHZp4ujxzRx4/25hZdalbRgS4X0Ly1UNhE6DItlbirjWquYXkYj/A81
         xX+w==
X-Gm-Message-State: AC+VfDyox5w2ecC093WwffRsHvBQxfQDj7L7KynBjD+LqeMoIg+yP0HV
	B33H8KstxehoAjyePYEtrG4Qh7zn7yihXEqLsOhwew==
X-Google-Smtp-Source: ACHHUZ6rnfauvJlvb1mwzzlT8g0GY54+NROCZwvEmL9WYPQejz5W4eVK9gMe7CWqWbMSgLrgOf+zP9SLEfzjAsntQys=
X-Received: by 2002:ac8:7d11:0:b0:3e6:81be:93b3 with SMTP id
 g17-20020ac87d11000000b003e681be93b3mr25392qtb.5.1683745213654; Wed, 10 May
 2023 12:00:13 -0700 (PDT)
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
 <CANn89iL6Ckuu9vOEvc7A9CBLGuh-EpbwFRxRAchV-6VFyhTUpg@mail.gmail.com>
 <CH3PR11MB73458BB403D537CFA96FD8DDFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iJvpgXTwGEiXAkFwY3j3RqVhNzJ_6_zmuRb4w7rUA_8Ug@mail.gmail.com>
 <CALvZod6JRuWHftDcH0uw00v=yi_6BKspGCkDA4AbmzLHaLi2Fg@mail.gmail.com>
 <CH3PR11MB7345ABB947E183AFB7C18322FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+9rQcGey+AJyhR02pTTBNhWN+P78e4a8knfC9F5sx0hQ@mail.gmail.com>
 <CH3PR11MB73455A98A232920B322C3976FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+J+ciJGPkWAFKDwhzJERFJr9_2Or=ehpwSTYO14qzHmA@mail.gmail.com> <CH3PR11MB734502756F495CB9C520494FFC779@CH3PR11MB7345.namprd11.prod.outlook.com>
In-Reply-To: <CH3PR11MB734502756F495CB9C520494FFC779@CH3PR11MB7345.namprd11.prod.outlook.com>
From: Shakeel Butt <shakeelb@google.com>
Date: Wed, 10 May 2023 12:00:02 -0700
Message-ID: <CALvZod4n+Kwa1sOV9jxiEMTUoO7MaCGWz=wT3MHOuj4t-+9S6Q@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
To: "Zhang, Cathy" <cathy.zhang@intel.com>
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

On Wed, May 10, 2023 at 9:09=E2=80=AFAM Zhang, Cathy <cathy.zhang@intel.com=
> wrote:
>
>
[...]
> > > >
> > > > Have you tried to increase batch sizes ?
> > >
> > > I jus picked up 256 and 1024 for a try, but no help, the overhead sti=
ll exists.
> >
> > This makes no sense at all.
>
> Eric,
>
> I added a pr_info in try_charge_memcg() to print nr_pages if
> nr_pages >=3D MEMCG_CHARGE_BATCH, except it prints 64 during the initiali=
zation
> of instances, there is no other output during the running. That means nr_=
pages is not
> over 64, I guess that might be the reason why to increase MEMCG_CHARGE_BA=
TCH
> doesn't affect this case.
>

I am assuming you increased MEMCG_CHARGE_BATCH to 256 and 1024 but
that did not help. To me that just means there is a different
bottleneck in the memcg charging codepath. Can you please share the
perf profile? Please note that memcg charging does a lot of other
things as well like updating memcg stats and checking (and enforcing)
memory.high even if you have not set memory.high.

