Return-Path: <netdev+bounces-1550-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81BAE6FE470
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 21:19:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 623DB1C20DE1
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 19:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33086174F3;
	Wed, 10 May 2023 19:19:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E3E8C0F
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:19:24 +0000 (UTC)
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB78F5255;
	Wed, 10 May 2023 12:19:22 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-6439e6f5a33so4431114b3a.2;
        Wed, 10 May 2023 12:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683746362; x=1686338362;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vdKoW9P2jhBRnfmfNK6oFRBXOmfqdpLVW/L7FZNRlBQ=;
        b=RPF5HXOjB1S+X34THeUgO74GhOevm4XKHWyln3kcxR64HMWwEYRMAiv1yihOGbxoOY
         V68pDwIC6StEtl85K2ZEvsrtryxcSaTDq5fB5gSK849T/Y7nrVESXimWoInf04t8SqQD
         ugZEhVj6IAhE+5df0H8ElTx8vUhoxXLjstdOUdEU7cauKmrKgeTbrivxOxCsPsEfBubs
         x+FOeiipp2XiYXuLQYlRkHnh4BBDzK6Vu/WgbUE7LcLq3l+nGqvR9k51fhCDko5r2jXB
         eismONkkFymXXp6+VZy7E5uNPwWetYXO+8CJH1GRfWeAjDlA2QpJqHAFcJKfMR3E+tPf
         4NGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683746362; x=1686338362;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vdKoW9P2jhBRnfmfNK6oFRBXOmfqdpLVW/L7FZNRlBQ=;
        b=EXUAkhoqi4SJ62AAhcKaKGnhCJn2dwP/sl8mxIkiaPAvCxc8xMaFLJQqMC912l9V5I
         Xsx7XOdYzDdLFZu2NWJMmDtMjaOq2OanC20IhznRy4SUN+89O5vuvz411qp5dSWpfrrP
         IqaD0B4SbjjSFiE+SP3Jp9sB5253VkNHfhhTNygXP+mkDvEtqC90uJ87BfvsKnC3HBUq
         kJ9QGZuM47H0lWTXtRJBl9v9beOPfll9v05rjSltnCOmPJEnQ46C/MtEaGK2UD+H/cMP
         o11pqTuhCR/WN50H054ehBKGNOOeIJitYlVuizlvgjqAqQaTkvJQyLFpFKv45Fu6UiSX
         h80A==
X-Gm-Message-State: AC+VfDy5WZo2gr1VLfwDWNyY3GrhRu4p6LGV6dpWDFcyzE5K4UC8EP4r
	vNhUu5Kn1AuQe26d7x5SU5o=
X-Google-Smtp-Source: ACHHUZ4dbVM57Fb+/Mp2jiw4JmUznHlGsRzKlTeN0YuWMzJY71pwMBbkE3WhK4cDOE37L/6/O0B3Iw==
X-Received: by 2002:a05:6a00:248d:b0:63a:8f4c:8be1 with SMTP id c13-20020a056a00248d00b0063a8f4c8be1mr27949390pfv.10.1683746362066;
        Wed, 10 May 2023 12:19:22 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id n22-20020aa79056000000b0063d24fcc2b7sm3918870pfo.1.2023.05.10.12.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 12:19:21 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Wed, 10 May 2023 09:19:20 -1000
From: Tejun Heo <tj@kernel.org>
To: Brian Norris <briannorris@chromium.org>
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
Message-ID: <ZFvuOK_dpGTE4UVS@slm.duckdns.org>
References: <20230509015032.3768622-1-tj@kernel.org>
 <20230509015032.3768622-3-tj@kernel.org>
 <ZFvd8zcPq4ijSszM@google.com>
 <ZFvfYK-u8suHjPFw@slm.duckdns.org>
 <ZFvpJb9Dh0FCkLQA@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFvpJb9Dh0FCkLQA@google.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

On Wed, May 10, 2023 at 11:57:41AM -0700, Brian Norris wrote:
> Test case: iperf TCP RX (i.e., hits "MWIFIEX_RX_WORK_QUEUE" a lot) at
> some of the higher (VHT 80 MHz) data rates.
> 
> Hardware: Mediatek MT8173 2xA53 (little) + 2xA72 (big) CPU
> (I'm not familiar with its cache details)
> +
> Marvell SD8897 SDIO WiFi (mwifiex_sdio)

Yeah, we had multiple of similar cases on, what I think are, similar
configurations, which is why I'm working on improving workqueue locality.

> We're looking at a major regression from our 4.19 kernel to a 5.15
> kernel (yeah, that's downstream reality). So far, we've found that
> performance is:

That's curious. 4.19 is old but I scanned the history and there's nothing
which can cause that kind of perf regression for unbound workqueues between
4.19 and 5.15.

> (1) much better (nearly the same as 4.19) if we add WQ_SYSFS and pin the
> work queue to one CPU (doesn't really matter which CPU, as long as it's
> not the one loaded with IRQ(?) work)
> 
> (2) moderately better if we pin the CPU frequency (e.g., "performance"
> cpufreq governor instead of "schedutil")
> 
> (3) moderately better (not quite as good as (2)) if we switch a
> kthread_worker and don't pin anything.

Hmm... so it's not just workqueue.

> We tried (2) because we saw a lot more CPU migration on kernel 5.15
> (work moves across all 4 CPUs throughout the run; on kernel 4.19 it
> mostly switched between 2 CPUs).

Workqueue can contribute to this but it seems more likely that scheduling
changes are also part of the story.

> We tried (3) suspecting some kind of EAS issue (instead of distributing
> our workload onto 4 different kworkers, our work (and therefore our load
> calculation) is mostly confined to a single kernel thread). But it still
> seems like our issues are more than "just" EAS / cpufreq issues, since
> (2) and (3) aren't as good as (1).
> 
> NB: there weren't many relevant mwifiex or MTK-SDIO changes in this
> range.
> 
> So we're still investigating a few other areas, but it does seem like
> "locality" (in some sense of the word) is relevant. We'd probably be
> open to testing any patches you have, although it's likely we'd have the
> easiest time if we can port those to 5.15. We're constantly working on
> getting good upstream support for Chromebook chips, but ARM SoC reality
> is that it still varies a lot as to how much works upstream on any given
> system.

I should be able to post the patchset later today or tomorrow. It comes with
sysfs knobs to control affinity scopes and strictness, so hopefully you
should be able to find the configuration that works without too much
difficulty.

Thanks.

-- 
tejun

