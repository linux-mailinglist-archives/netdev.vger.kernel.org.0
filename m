Return-Path: <netdev+bounces-2477-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E2A37022B5
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 06:13:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F10942810B0
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 04:13:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 251CB1FB6;
	Mon, 15 May 2023 04:13:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1335E1C26
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 04:13:35 +0000 (UTC)
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7343F1BE3
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 21:13:32 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-3f38a9918d1so1313781cf.1
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 21:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684124011; x=1686716011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YStTJgpJxghtuoBZk87RzSQY/v+lqurPQ0sgyIhp1Ps=;
        b=7SCyQfiTw4tckZw3oxtRgm3S34UkIVRMsMkishGxaYF42kqIOh9pOrwcNY8jsGk2+X
         ViLkd+/8VsMrSaCScA6bvCPgpEshi1LK7YjW8cvAueeSF9E194mlh9pFfiPVe68yO34P
         BXiEtC4ThZO5lrRoIy4NpWgOET9HuSbGTUwXM5hGC82mJxfcdWoorRGZ9oy9+XjtnH+A
         uQrmk5y1LopWW9xCt17bquSWitNv9qWhbLYwLzFJAnYh4LH1n3RyKQUWnzfO8/Ev1Is0
         JoUlKgdNqD1Wk2xHBUs/wKI3btKgUzNhwAuS5oFVszmlzYoHGwa8nU/79RCx/EgnhX3E
         sBNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684124011; x=1686716011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YStTJgpJxghtuoBZk87RzSQY/v+lqurPQ0sgyIhp1Ps=;
        b=blM61a3bEVXsoa2nKfhJm9bMCua3Vy22pXVIcGCdv9dbtaQlTzfkzTQsCxyKd9j0R8
         ZxNCIocUlmdZ6rcl1HZBvOopSbu0UuS9OzjjjJUCio97k7M7j68ppGjG4N1MOxPVsbWq
         rdUkCwPP8hedtyLMWYjaLyO12ctbXEmCf+sw2nERC9BHnRJwrke3e8Qdi/IUtP3dCWyS
         DatJx6lW4KOQLandVO0ydlMOrlfbmwzoPagZnYC+nwzDrOhNiDNnKP71peo0ey39NETZ
         x3vryPBbbSipVYuF5w9Jki2UtL1LKlTEIG0DDU1d7lDzqk2TIjTAfsM9iFr5PGXL9L0H
         276g==
X-Gm-Message-State: AC+VfDxr9de/ckk2O/jx5etxJRU7RbtvEnrpeNqhsUA9+N9gFu9TMHkW
	cdCpMgaMajVmPtD6WdgiJiKG6bWEoTzdt8UQfIqgeQ==
X-Google-Smtp-Source: ACHHUZ5ykYW2V6yWJQUZ51vyxTbY8cpo7eQrQ6U4bKjnsJLqpza5H8K01Tv4A9QRgZPm4hJ2ctiEFpsU4DiUiSzF1jo=
X-Received: by 2002:a05:622a:14cf:b0:3e0:c2dd:fd29 with SMTP id
 u15-20020a05622a14cf00b003e0c2ddfd29mr1061107qtx.4.1684124011324; Sun, 14 May
 2023 21:13:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <20230512171702.923725-1-shakeelb@google.com> <CH3PR11MB7345035086C1661BF5352E6EFC789@CH3PR11MB7345.namprd11.prod.outlook.com>
In-Reply-To: <CH3PR11MB7345035086C1661BF5352E6EFC789@CH3PR11MB7345.namprd11.prod.outlook.com>
From: Shakeel Butt <shakeelb@google.com>
Date: Sun, 14 May 2023 21:13:20 -0700
Message-ID: <CALvZod7n2yHU8PMn5b39w6E+NhLtBynDKfo1GEfXaa64_tqMWQ@mail.gmail.com>
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

On Sun, May 14, 2023 at 8:46=E2=80=AFPM Zhang, Cathy <cathy.zhang@intel.com=
> wrote:
>
>
>
> > -----Original Message-----
> > From: Shakeel Butt <shakeelb@google.com>
> > Sent: Saturday, May 13, 2023 1:17 AM
> > To: Zhang, Cathy <cathy.zhang@intel.com>
> > Cc: Shakeel Butt <shakeelb@google.com>; Eric Dumazet
> > <edumazet@google.com>; Linux MM <linux-mm@kvack.org>; Cgroups
> > <cgroups@vger.kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> > davem@davemloft.net; kuba@kernel.org; Brandeburg@google.com;
> > Brandeburg, Jesse <jesse.brandeburg@intel.com>; Srinivas, Suresh
> > <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>; You,
> > Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> > netdev@vger.kernel.org
> > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a p=
roper
> > size
> >
> > On Fri, May 12, 2023 at 05:51:40AM +0000, Zhang, Cathy wrote:
> > >
> > >
> > [...]
> > > >
> > > > Thanks a lot. This tells us that one or both of following scenarios
> > > > are
> > > > happening:
> > > >
> > > > 1. In the softirq recv path, the kernel is processing packets from
> > > > multiple memcgs.
> > > >
> > > > 2. The process running on the CPU belongs to memcg which is
> > > > different from the memcgs whose packets are being received on that =
CPU.
> > >
> > > Thanks for sharing the points, Shakeel! Is there any trace records yo=
u
> > > want to collect?
> > >
> >
> > Can you please try the following patch and see if there is any improvem=
ent?
>
> Hi Shakeel,
>
> Try the following patch, the data of 'perf top' from system wide indicate=
s that
> the overhead of page_counter_cancel is dropped from 15.52% to 4.82%.
>
> Without patch:
>     15.52%  [kernel]            [k] page_counter_cancel
>     12.30%  [kernel]            [k] page_counter_try_charge
>     11.97%  [kernel]            [k] try_charge_memcg
>
> With patch:
>     10.63%  [kernel]            [k] page_counter_try_charge
>      9.49%  [kernel]            [k] try_charge_memcg
>      4.82%  [kernel]            [k] page_counter_cancel
>
> The patch is applied on the latest net-next/main:
> befcc1fce564 ("sfc: fix use-after-free in efx_tc_flower_record_encap_matc=
h()")
>

Thanks a lot Cathy for testing. Do you see any performance improvement
for the memcached benchmark with the patch?

