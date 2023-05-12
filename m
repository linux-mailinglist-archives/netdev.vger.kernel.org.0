Return-Path: <netdev+bounces-2237-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 78286700DBF
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 19:17:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37636281B9F
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 408A2200CB;
	Fri, 12 May 2023 17:17:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355DC200A5
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 17:17:07 +0000 (UTC)
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502F17DBF
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:17:05 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-645538f6101so34825083b3a.1
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683911825; x=1686503825;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=g/vEoaxxlidjk6ZRnVQ6vBnM5rJLiZ0SFsw4oljX9Bo=;
        b=6TzRO4dhn5IQ9F9oBlZSna42ZOqtLV1QcfYJqq0S5da4w8udY31eLcwr/E03q3nFoB
         ODjOKKPktW+57iOsHRQ94HWijxeHVRQsNCKzBtLgwx52ZLMDichW/UVkpYTYMo5c+c0W
         C37q+PaEllbmgwGvnyQiCScSGXH2VUjfY+x9RPgqiCjw/Q824wEI2tVYxRUTa5OHSyKh
         EqLwh6+KXRPctS0apgFG1m5k2fJn1Mxh+A9hEQ/vmsThZr9DgY1FQaCJ0OwDCjLGIHFI
         dzA74UjBQoyNUMFHq06ENAe24xaZNGPz8dMoD+WWJaA7alhFLNTbdqDlZ4lWEuoihrbQ
         7G+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683911825; x=1686503825;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g/vEoaxxlidjk6ZRnVQ6vBnM5rJLiZ0SFsw4oljX9Bo=;
        b=PJ7WS+PlLO654IFQBfACFphBJpblZXv9ljFj3mKen2GRwh/BARNx0K/VOOGHSrCoKJ
         hJoRzSygGztyayFJ+nzKLiTNNZvnJtGG3nWCS23F4iNpe/u6OEgc3ikeKp6he/+4H7UE
         EGiyCrNrYfakWhIfn7/WH+bZQ5XQqAKuWdjNKmxS3rIBWLeLzBH7SQ2jNg66TofO1ri+
         RU+eud0yXDHFZ0VMtSEvr10HfJhEUqXk0JhKyJZpwL6ei7hULYtyFOC7AoOH6ENJ/BOd
         n+VdVdXbJS3OdZLq+Te6fHYOtDNB9EEGCaorEaPSUqBNr1Jz1urPNX/g+IvsdOgStVrS
         CKrw==
X-Gm-Message-State: AC+VfDy0vki08jqWCf742rmSrgUuDzn2qor+8y4TAVg93U5S4kRuW2Bj
	hpXqn6wqS6Tnbjp7WmzuD6bj5kbzCIHYVA==
X-Google-Smtp-Source: ACHHUZ4Io4WMVWZF2N7SrfbUUa6wZY00VH6g2t/BdY1sGdWVyMUKJbLOj2L1LQb+1nfCVSe+9B5xLmBKbM7rcA==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:262e])
 (user=shakeelb job=sendgmr) by 2002:a17:90a:6f81:b0:24b:6d01:584a with SMTP
 id e1-20020a17090a6f8100b0024b6d01584amr8353401pjk.0.1683911824771; Fri, 12
 May 2023 10:17:04 -0700 (PDT)
Date: Fri, 12 May 2023 17:17:01 +0000
In-Reply-To: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230512171702.923725-1-shakeelb@google.com>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
From: Shakeel Butt <shakeelb@google.com>
To: Cathy Zhang <cathy.zhang@intel.com>
Cc: Shakeel Butt <shakeelb@google.com>, Eric Dumazet <edumazet@google.com>, 
	Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>, 
	"kuba@kernel.org" <kuba@kernel.org>, "Brandeburg@google.com" <Brandeburg@google.com>, 
	Jesse Brandeburg <jesse.brandeburg@intel.com>, Suresh Srinivas <suresh.srinivas@intel.com>, 
	Tim C Chen <tim.c.chen@intel.com>, Lizhen You <lizhen.you@intel.com>, 
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 05:51:40AM +0000, Zhang, Cathy wrote:
> 
> 
[...]
> > 
> > Thanks a lot. This tells us that one or both of following scenarios are
> > happening:
> > 
> > 1. In the softirq recv path, the kernel is processing packets from multiple
> > memcgs.
> > 
> > 2. The process running on the CPU belongs to memcg which is different from
> > the memcgs whose packets are being received on that CPU.
> 
> Thanks for sharing the points, Shakeel! Is there any trace records you want to
> collect?
> 

Can you please try the following patch and see if there is any
improvement?


From 48eb23c8cbb5d6c6086299c8a5ae4b3485c79a8c Mon Sep 17 00:00:00 2001
From: Shakeel Butt <shakeelb@google.com>
Date: Fri, 12 May 2023 17:04:35 +0000
Subject: [PATCH] No batch charge in irq context

---
 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d31fb1e2cb33..f1453a140fc8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2652,7 +2652,8 @@ void mem_cgroup_handle_over_high(void)
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			unsigned int nr_pages)
 {
-	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
+	unsigned int batch = in_task() ?
+		max(MEMCG_CHARGE_BATCH, nr_pages) : nr_pages;
 	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
-- 
2.40.1.606.ga4b1b128d6-goog


