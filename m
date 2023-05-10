Return-Path: <netdev+bounces-1556-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B89C6FE49D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 21:50:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CE7E1C20E18
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 19:50:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D03D17FEF;
	Wed, 10 May 2023 19:50:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AFD174FF
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:50:41 +0000 (UTC)
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A4C40C1
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 12:50:39 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-24e1d272b09so5693870a91.1
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 12:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1683748239; x=1686340239;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RzJXq5M126VXCpiLaXhWPXp33e8DOHU0imjBBTS6ocY=;
        b=UYPeCm9xk2F+UqFzo7t2g252TthUcu3MmFve6bnrGKluC0KPQdbx+R96WtCPlOzvP/
         GuwquTTUWnmNSWWBlWU7CiHXyhNZ3FvMvvbZiaUU6GddxjxTW4Hp7rQKk0S1eLZq5tyl
         3NSD3wRK/T9jfmIbLeJkVJQhKWt+8t/pPHfQ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683748239; x=1686340239;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RzJXq5M126VXCpiLaXhWPXp33e8DOHU0imjBBTS6ocY=;
        b=THBNxLH9WGEZ8u+QgCEzc3lDZZ90n0zcFymZEoaiwTNaeBgD6OSyec9CRXwcMGVIsf
         MGToxjTm59VgWSe4luOv/g8RL3HuBBtH2tOKCVCf0bMNX+5673BmLxzNZ4wBIaRW30g7
         lIMx2TrnFenmtZRsDuP0bqniYmjVJqnDpAz1GlORnIc7NLvP6TW1nF0iaEAbD57Vth3L
         fc0S2rN4xL8/0dvOjcPNYhSAs+K6rxiYhT5RCwN1GfCsMm40Q2NB2C+HJFYmsvGppew9
         YgFMQ6fMmKq0pD2dFqZLu4P9vYPOA7li1ly03MB+3uyMNvPR01QliNMPJnfyVoDWJDKS
         elGQ==
X-Gm-Message-State: AC+VfDylriFM0nEglnHbK6xSxkzj/2wZbnFoQBvyg+D2WYz3X/3DXGp/
	gRut7+jObEmJIKJzgf8/D0vFlQ==
X-Google-Smtp-Source: ACHHUZ4hSLTRdAWmIJbXpDVFtmGq/SMTG5NAr/KdpxYfUUkv2hBQi11Hb8rjTqCQj4EVVAL1KHNGtQ==
X-Received: by 2002:a17:90a:4618:b0:250:6bd9:cf6 with SMTP id w24-20020a17090a461800b002506bd90cf6mr13900854pjg.15.1683748239244;
        Wed, 10 May 2023 12:50:39 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:17a2:4d38:332d:67a0])
        by smtp.gmail.com with ESMTPSA id 3-20020a630a03000000b0051b930b2b49sm3579202pgk.72.2023.05.10.12.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 12:50:38 -0700 (PDT)
Date: Wed, 10 May 2023 12:50:36 -0700
From: Brian Norris <briannorris@chromium.org>
To: Tejun Heo <tj@kernel.org>
Cc: jiangshanlai@gmail.com, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, Amitkumar Karwar <amitkarwar@gmail.com>,
	Ganapathi Bhat <ganapathi017@gmail.com>,
	Sharvari Harisangam <sharvari.harisangam@nxp.com>,
	Xinming Hu <huxinming820@gmail.com>, Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Pin-yen Lin <treapking@chromium.org>
Subject: Re: [PATCH 02/13] wifi: mwifiex: Use default @max_active for
 workqueues
Message-ID: <ZFv1jM2PErlNUNsm@google.com>
References: <20230509015032.3768622-1-tj@kernel.org>
 <20230509015032.3768622-3-tj@kernel.org>
 <ZFvd8zcPq4ijSszM@google.com>
 <ZFvfYK-u8suHjPFw@slm.duckdns.org>
 <ZFvpJb9Dh0FCkLQA@google.com>
 <ZFvuOK_dpGTE4UVS@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFvuOK_dpGTE4UVS@slm.duckdns.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 09:19:20AM -1000, Tejun Heo wrote:
> On Wed, May 10, 2023 at 11:57:41AM -0700, Brian Norris wrote:
> > (1) much better (nearly the same as 4.19) if we add WQ_SYSFS and pin the
> > work queue to one CPU (doesn't really matter which CPU, as long as it's
> > not the one loaded with IRQ(?) work)
> > 
> > (2) moderately better if we pin the CPU frequency (e.g., "performance"
> > cpufreq governor instead of "schedutil")
> > 
> > (3) moderately better (not quite as good as (2)) if we switch a
> > kthread_worker and don't pin anything.
> 
> Hmm... so it's not just workqueue.

Right. And not just cpufreq either.

> > We tried (2) because we saw a lot more CPU migration on kernel 5.15
> > (work moves across all 4 CPUs throughout the run; on kernel 4.19 it
> > mostly switched between 2 CPUs).
> 
> Workqueue can contribute to this but it seems more likely that scheduling
> changes are also part of the story.

Yeah, that's one theory. And in that vein, that's one reason we might
consider switching to a kthread_worker anyway, even if that doesn't
solve all the regression -- because schedutil relies on per-entity load
calculations to make decisions, and workqueues don't help the scheduler
understand that load when spread across N CPUs (workers). A dedicated
kthread would better represent our workload to the scheduler.

(Threaded NAPI -- mwifiex doesn't support NAPI -- takes a similar
approach, as it has its own thread per NAPI context.)

> > We tried (3) suspecting some kind of EAS issue (instead of distributing
> > our workload onto 4 different kworkers, our work (and therefore our load
> > calculation) is mostly confined to a single kernel thread). But it still
> > seems like our issues are more than "just" EAS / cpufreq issues, since
> > (2) and (3) aren't as good as (1).
> > 
> > NB: there weren't many relevant mwifiex or MTK-SDIO changes in this
> > range.
> > 
> > So we're still investigating a few other areas, but it does seem like
> > "locality" (in some sense of the word) is relevant. We'd probably be
> > open to testing any patches you have, although it's likely we'd have the
> > easiest time if we can port those to 5.15. We're constantly working on
> > getting good upstream support for Chromebook chips, but ARM SoC reality
> > is that it still varies a lot as to how much works upstream on any given
> > system.
> 
> I should be able to post the patchset later today or tomorrow. It comes with
> sysfs knobs to control affinity scopes and strictness, so hopefully you
> should be able to find the configuration that works without too much
> difficulty.

Great!

Brian

