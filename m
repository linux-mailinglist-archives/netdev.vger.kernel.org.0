Return-Path: <netdev+bounces-7571-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 326F9720A3D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 22:25:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68057281A73
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 20:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BD361F18D;
	Fri,  2 Jun 2023 20:25:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D20B1E537
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 20:25:53 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB6EE45
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 13:25:51 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba81b37d9d2so3244356276.3
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 13:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685737551; x=1688329551;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E/w9dpHTMqgkLEKvl14+NZFKAOeWHv5+6Cm9LcEp2Pk=;
        b=yLQeX37dgxp9PBBi8VizndbTFQ0QUx+l8iC6lB7aHf3WHqlzVM0sr3Knbm3N2EWBhw
         eZqpYVjs3t3t1cmAGoCNORvLZ8+FHUiHEBRNL7D6U6HSt7vWq9CRTVbjf660HFdOYef1
         R97noyMAORChP/anS1o79GwHXO2AK1/h+l1kpywQpPrYYYroDrmPZE/yWMiufDsascoF
         OLfw0QrP0qttpoClFMjgNKc8UoPuf2u3EbtL+JKqUsVnx0s+fHYPrwPOiysst7WXYUE4
         FUzN8Gk9kCSOktftMRWy2E51SlIaTtlyrVESbO6KanMkf4BVwX+YmFT1EMvmNOATbh9/
         kw+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685737551; x=1688329551;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E/w9dpHTMqgkLEKvl14+NZFKAOeWHv5+6Cm9LcEp2Pk=;
        b=Ao3JKxo0/rgkwPFh9BiWYNGU1iZEXzZSxGsTQEac3afDNp0RcSO2S3CrghmPZ/gcdh
         LjM1fz7i9l0/sFZd0aSGt1n4T4+ZbAo2xEm38Yj2bz6jSHrpqlIqUap3Ps2R3jlvLlsV
         t+kBY+l4vwEDj6P7roMh/T69BetnJLRjFuvuS0DNP5RzC4QOn7B55ZPRwwQtR2jb+e2b
         JRredNwG/ZE6n6EpW02eQuPLD0rvSq26ISu5PeKALYzu5ZZT2XUlAe3v/YS4vc7S5pW6
         adidU/Sftm/OzzAEDInNZAm+ayzXfoECwm8Q6mnHHS+osw3GZv7Ld7LAITelan7f0Pu8
         /T8w==
X-Gm-Message-State: AC+VfDzKg2J6JnWD5hmllBjD8aoqJMlhw39ozozZPDZAVhI7szfVFABe
	qcl7fD/V9vtpKdzdLIjqEccnWfkEnQOUEw==
X-Google-Smtp-Source: ACHHUZ5aXiSla8WVuXVKHCpO0levd8tv2DJvY5OiqwlaBcJWCvDt6MnMLYk9lsZATIzAwGIMvUjHj9o6HW8CBg==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:262e])
 (user=shakeelb job=sendgmr) by 2002:a5b:804:0:b0:bac:a7d5:f895 with SMTP id
 x4-20020a5b0804000000b00baca7d5f895mr1398068ybp.10.1685737551177; Fri, 02 Jun
 2023 13:25:51 -0700 (PDT)
Date: Fri, 2 Jun 2023 20:25:49 +0000
In-Reply-To: <20230602081135.75424-2-wuyun.abel@bytedance.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230602081135.75424-1-wuyun.abel@bytedance.com> <20230602081135.75424-2-wuyun.abel@bytedance.com>
Message-ID: <20230602202549.7nvrv4bx4cu7qxdn@google.com>
Subject: Re: [PATCH net-next v5 1/3] net-memcg: Fold dependency into memcg
 pressure cond
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

On Fri, Jun 02, 2023 at 04:11:33PM +0800, Abel Wu wrote:
> The callers of mem_cgroup_under_socket_pressure() should always make
> sure that (mem_cgroup_sockets_enabled && sk->sk_memcg) is true. So
> instead of coding around all the callsites, put the dependencies into
> mem_cgroup_under_socket_pressure() to avoid redundancy and possibly
> bugs.
> 
> This change might also introduce slight function call overhead *iff*
> the function gets expanded in the future. But for now this change
> doesn't make binaries different (checked by vimdiff) except the one
> net/ipv4/tcp_input.o (by scripts/bloat-o-meter), which is probably
> negligible to performance:
> 
> add/remove: 0/0 grow/shrink: 1/2 up/down: 5/-5 (0)
> Function                                     old     new   delta
> tcp_grow_window                              573     578      +5
> tcp_try_rmem_schedule                       1083    1081      -2
> tcp_check_space                              324     321      -3
> Total: Before=44647, After=44647, chg +0.00%
> 
> So folding the dependencies into mem_cgroup_under_socket_pressure()
> is generally a good thing and provides better readablility.
> 

I don't see how it is improving readability. If you have removed the use
of mem_cgroup_sockets_enabled completely from the networking then I can
understand but this change IMHO will actually decrease the readability
because the later readers will have to reason why we are doing this
check at some places but not other.


