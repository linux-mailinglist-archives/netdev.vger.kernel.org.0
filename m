Return-Path: <netdev+bounces-6179-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 742107150DD
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 23:12:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A01A9280FA0
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 21:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A663E1095F;
	Mon, 29 May 2023 21:12:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9AC1094D
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 21:12:10 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF03CF
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 14:12:08 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-568960f4596so19994767b3.1
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 14:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685394727; x=1687986727;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SNIbMRRuukreAZUC2GpTXXJapIJH6ZTqRY6eETcu5do=;
        b=a58aF0yeP61zDhlUOfNZLdoceiGGu26FxV3w360cVEX5mXHSCikCT9QZERrFOn+Wgg
         PQV3rmSuBZyWY7RJpxGCaweRtPtOGXNtJcQhRUc2Iiihmavwag/sytmxBLigXGwWZ5lk
         MLQoJyIYLb64f3BZPnDxbbiLlxkUMoohc9b/lJFrsKSBEmQDa4uuUXrKl0lWOYjJlass
         Vm9R7gNJl0aoBHuFj+eLnN5KovJ8X9KpPljEMIAznmET2jGKoJR2W7ks9R7Zl7Kw+ity
         mkmUkdCwuo7zJwvR5vpEgDRs5datWM1md9+4+SU5d4GrZlIohZop23cGF+rwOMxEyoPR
         NYUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685394727; x=1687986727;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SNIbMRRuukreAZUC2GpTXXJapIJH6ZTqRY6eETcu5do=;
        b=HccMd6aaabnZ0RryCChk2g8uWD5+7NknQSSe/8f6XM+pCEOEdFeYm+IZzJK7bLXMj0
         pJFL7qCwYLGjDE+ZXVTp3OH63ODKtA3Wic2Qgf+8FkneSdskGVPyCXH+GpYnvEXCkVLm
         hkbJz84SAYbCCdq5jYIRoF5XEE8PjGACuOhJ+A1fyAmsEk4XXFvHrNHMHww3+qVzRBdi
         nACe0ZBDavrv+yhNBaALuZmFL+Wh6K9H2OVO/9GFjeI59Aq+aqnaRwnRvxysHQ0UBSj5
         fim17Y0THNRyR1FXFC2ZoYqE039RnUfMmHnhnAJdE75vL2OGHezGD3CQJDEpxn+eSAdy
         pvZw==
X-Gm-Message-State: AC+VfDwnre9nbMDNLKna1Gguy1mSkadvCWqLkBf7/C6gtqEdgGFf8z+T
	j2O4onWMbMX6HDqM6m4ZswG7E+YQMqPHFQ==
X-Google-Smtp-Source: ACHHUZ4EK9Ki5lqBKfhxeJ5UQrbZDNyq0mE3Vi/VAJElmaNP79ShHBWggELHy87FMqUFasJeW9t+ieHOM3yayw==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:262e])
 (user=shakeelb job=sendgmr) by 2002:a81:b619:0:b0:561:bf07:ee28 with SMTP id
 u25-20020a81b619000000b00561bf07ee28mr54893ywh.5.1685394727672; Mon, 29 May
 2023 14:12:07 -0700 (PDT)
Date: Mon, 29 May 2023 21:12:05 +0000
In-Reply-To: <73b1381e-6a59-26fe-c0b6-51ea3ebf60f8@bytedance.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230522070122.6727-1-wuyun.abel@bytedance.com>
 <20230522070122.6727-4-wuyun.abel@bytedance.com> <20230525012259.qd6i6rtqvvae3or7@google.com>
 <73b1381e-6a59-26fe-c0b6-51ea3ebf60f8@bytedance.com>
Message-ID: <20230529211205.6clthjyt37c4opju@google.com>
Subject: Re: [PATCH v2 3/4] sock: Consider memcg pressure when raising sockmem
From: Shakeel Butt <shakeelb@google.com>
To: Abel Wu <wuyun.abel@bytedance.com>
Cc: "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


+linux-mm and cgroups

On Mon, May 29, 2023 at 07:58:45PM +0800, Abel Wu wrote:
> Hi Shakeel, thanks for reviewing! And sorry for replying so late,
> I was on a vocation :)
> 
> On 5/25/23 9:22 AM, Shakeel Butt wrote:
> > On Mon, May 22, 2023 at 03:01:21PM +0800, Abel Wu wrote:
> > > For now __sk_mem_raise_allocated() mainly considers global socket
> > > memory pressure and allows to raise if no global pressure observed,
> > > including the sockets whose memcgs are in pressure, which might
> > > result in longer memcg memstall.
> > > 
> > > So take net-memcg's pressure into consideration when allocating
> > > socket memory to alleviate long tail latencies.
> > > 
> > > Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
> > 
> > Hi Abel,
> > 
> > Have you seen any real world production issue which is fixed by this
> > patch or is it more of a fix after reading code?
> 
> The latter. But we do observe one common case in the production env
> that p2p service, which mainly downloads container images, running
> inside a container with tight memory limit can easily be throttled and
> keep memstalled for a long period of time and sometimes even be OOM-
> killed. This service shows burst usage of TCP memory and I think it
> indeed needs suppressing sockmem allocation if memcg is already under
> pressure. The memcg pressure is usually caused by too many page caches
> and the dirty ones starting to be wrote back to slow backends. So it
> is insane to continuously receive net data to consume more memory.
> 

We actually made an intentional decision to not throttle the incoming
traffic under memory pressure. See 720ca52bcef22 ("net-memcg: avoid
stalls when under memory pressure"). If you think the throttling
behavior is preferred for your application, please propose the patch
separately and we can work on how to enable flexible policy here.

> > 
> > This code is quite subtle and small changes can cause unintended
> > behavior changes. At the moment the tcp memory accounting and memcg
> > accounting is intermingled and I think we should decouple them.
> 
> My original intention to post this patchset is to clarify that:
> 
>   - proto pressure only considers sysctl_mem[] (patch 2)
>   - memcg pressure only indicates the pressure inside itself
>   - consider both whenever needs allocation or reclaim (patch 1,3)
> 
> In this way, the two kinds of pressure maintain purer semantics, and
> socket core can react on both of them properly and consistently.

Can you please resend you patch series (without patch 3) and Cc to
linux-mm, cgroups list and memcg maintainers as well?

