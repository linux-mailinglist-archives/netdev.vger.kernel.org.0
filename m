Return-Path: <netdev+bounces-7577-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A1A9720A94
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 22:53:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA5141C21082
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 20:53:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 519A6848A;
	Fri,  2 Jun 2023 20:53:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468D92F33
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 20:53:27 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CA4E49
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 13:53:25 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-babb76a9831so3257451276.2
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 13:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685739204; x=1688331204;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+fG+5ZSAkptAZFJidv7/9+oyabWoMFk8mfKUsXGlGg0=;
        b=wK1p09WOIIRnkXa564ureFQ57MRy9iMKrPOln0YwwE/Rw8OZR3fzlJZiq5HBxRLpkH
         3ZcKf8jeGec78koGS+8A3fzef2GGzvuzmiXEkdpPRekeof/+cw6itBzIXeP7oBplDYXu
         RENyUJUpLE4LR2JQJKLwMtUUm7+E4iikGt4Sa6bxosnO3BgwDDOIAsBpL4kHgB50kBVu
         jGC0TjJFLJqBV/tIiCMA1TyH0A1nt94H+9HtXZ3Hep/sBNd17pXa7SPMg3qYJ1Mx2YN+
         DXOflqNAt8Jq1N6cDVlWptPE+gccL71iYSJLkLd/wHhKkhEewij5gwtzW4oGkN0siEub
         SP9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685739204; x=1688331204;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+fG+5ZSAkptAZFJidv7/9+oyabWoMFk8mfKUsXGlGg0=;
        b=VCdgyyPOcmN55Xdpq7O+kkFXKFTfLK+GEFXFDYUvbQJ3wzM+9GuGxwqNQ9y4v9Rjvo
         hhfht6Qq6ZpFr0riT95btyfsfgXFtxaRbG2PUXY+B3ASCQZUehWxTPnx5ctNU/qrFVph
         gug10fs9Jf0/H+1SltrWoVflGT9YzKAo4R1B2dVn3RyOcyiDo4FuvyyobDI7ES8iwdtS
         3eHxLt/lvzmJoDbOU12jLxTEof6oxsNKutS7pWI/0i2eDkACjxk4uxsvZESYGHObOOjV
         fXiFCgwLZzprq8rAHYeBahO37PDz5Mg7HBow06uQwvE5fi6a9gN55RWTSflbzHl5Svkv
         rifg==
X-Gm-Message-State: AC+VfDweNCjUpyOAhY3b11N8MRrkSyttOgtdZZ1FCXp/No1UUrK4KgUZ
	un3ziV2MooVZOT6qqpzSprYEVeTfKqQEuw==
X-Google-Smtp-Source: ACHHUZ6/VyNEBjEoo9wnWjEXa9PEbJyPsJUJw7sZiQ+swj5n+8uAxQ+8ijts5la1Uf9FkJtC5uEVjrYkgty+zg==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:262e])
 (user=shakeelb job=sendgmr) by 2002:a81:ad66:0:b0:55d:955b:360 with SMTP id
 l38-20020a81ad66000000b0055d955b0360mr530382ywk.5.1685739204454; Fri, 02 Jun
 2023 13:53:24 -0700 (PDT)
Date: Fri, 2 Jun 2023 20:53:22 +0000
In-Reply-To: <20230602081135.75424-4-wuyun.abel@bytedance.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230602081135.75424-1-wuyun.abel@bytedance.com> <20230602081135.75424-4-wuyun.abel@bytedance.com>
Message-ID: <20230602205322.ehxm2q2mbg5laa5s@google.com>
Subject: Re: [PATCH net-next v5 3/3] sock: Fix misuse of sk_under_memory_pressure()
From: Shakeel Butt <shakeelb@google.com>
To: Abel Wu <wuyun.abel@bytedance.com>
Cc: "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Vladimir Davydov <vdavydov.dev@gmail.com>, Muchun Song <muchun.song@linux.dev>, 
	Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 04:11:35PM +0800, Abel Wu wrote:
> The status of global socket memory pressure is updated when:
> 
>   a) __sk_mem_raise_allocated():
> 
> 	enter: sk_memory_allocated(sk) >  sysctl_mem[1]
> 	leave: sk_memory_allocated(sk) <= sysctl_mem[0]
> 
>   b) __sk_mem_reduce_allocated():
> 
> 	leave: sk_under_memory_pressure(sk) &&
> 		sk_memory_allocated(sk) < sysctl_mem[0]

There is also sk_page_frag_refill() where we can enter the global
protocol memory pressure on actual global memory pressure i.e. page
allocation failed. However this might be irrelevant from this patch's
perspective as the focus is on the leaving part.

> 
> So the conditions of leaving global pressure are inconstant, which

*inconsistent

> may lead to the situation that one pressured net-memcg prevents the
> global pressure from being cleared when there is indeed no global
> pressure, thus the global constrains are still in effect unexpectedly
> on the other sockets.
> 
> This patch fixes this by ignoring the net-memcg's pressure when
> deciding whether should leave global memory pressure.
> 
> Fixes: e1aab161e013 ("socket: initial cgroup code.")
> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>

This patch looks good.

