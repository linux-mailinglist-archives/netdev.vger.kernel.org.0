Return-Path: <netdev+bounces-1543-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1F076FE3B6
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:16:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CF24281568
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 18:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43F3C174E0;
	Wed, 10 May 2023 18:16:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3127014A81
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 18:16:09 +0000 (UTC)
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1562B61B0;
	Wed, 10 May 2023 11:16:03 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1aad5245632so54648195ad.3;
        Wed, 10 May 2023 11:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683742562; x=1686334562;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MV9KKbnlL+o+b9x6xmrTpuZGcH+89cbdDhrFO47jPDI=;
        b=o5Y7xv20o5mb5unhzSkkqEMFLfZemZ3Fq7tIeDgj5NY1msy0Go/2xY/wrMzxSfT9D9
         JwJMcse7ELe/2fUUuGgymqY0hXejB61olNuRHmUKr0Z8boiMUjl7njBt3h9xf/bNKwFd
         xVkjozoLCJQOL0/KCaHABwNZ0vbBae2mjSS+/jhRJl3/V91GXz7iWNNn4AVYNHoZSaYZ
         dmQvMPiRSQbmR9YgMom1IYy94DESmAzhyBARwsmm9FsMMHhdiJyPZwdij2iXvsuYkf93
         miMGoKNSWCwprwfIgGEMuVLBCAWWkFDY5uJmxg4nDETy0lz5FHKo1Okb+ouDQemKHr15
         o9Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683742562; x=1686334562;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MV9KKbnlL+o+b9x6xmrTpuZGcH+89cbdDhrFO47jPDI=;
        b=kzFRYuA0zfGGYB8TmhLvGuge5JkqplhH/PW8feAIumZXCORS1I/AQkRJwFCM3X2jzJ
         rl45HrjyXUQxNcMeyaZNJWwcKKirub4uSo8hVaMUjTworBVK2s0P1qDRrufEuKW/Qg4J
         U78vYdRYGn+Ntc2rSFcircIUAsPVYBLI2S2FP9WQotC0sdg0qSxh9DJcjtEJoA6ypLrn
         AbYbSB9eBRS4zX9pMjsCipf/nXROSuxtHTyRsPquj4RaconI2Y3H1ardRFUqHSVRH8d1
         RPUqQPz1lNxLNUEN+iPVP1bemrc/7l8Jo9fKMuvo4BvNTS/NiepDBiWAHewnW+5fK2Qt
         5ivQ==
X-Gm-Message-State: AC+VfDxU4lXZEhmZ0yRzvjD+iBh78RzOgxOvlbDDA6tIZXldqq8GtH+A
	URUe24yybYPBTxGyuYEE5CY=
X-Google-Smtp-Source: ACHHUZ5zdzxE/nxzHwipE7aLMexdW6UuNkId05cX7KuDNO37PTIHoYGXQ2ZzwwAuGUkqY/Bm0hpOJg==
X-Received: by 2002:a17:902:eb4b:b0:1a6:7632:2b20 with SMTP id i11-20020a170902eb4b00b001a676322b20mr19942490pli.40.1683742562313;
        Wed, 10 May 2023 11:16:02 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id j12-20020a170902690c00b001a04d27ee92sm4082703plk.241.2023.05.10.11.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 11:16:01 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Wed, 10 May 2023 08:16:00 -1000
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
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 02/13] wifi: mwifiex: Use default @max_active for
 workqueues
Message-ID: <ZFvfYK-u8suHjPFw@slm.duckdns.org>
References: <20230509015032.3768622-1-tj@kernel.org>
 <20230509015032.3768622-3-tj@kernel.org>
 <ZFvd8zcPq4ijSszM@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFvd8zcPq4ijSszM@google.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

On Wed, May 10, 2023 at 11:09:55AM -0700, Brian Norris wrote:
> I'll admit, the workqueue documentation sounds a bit like "max_active ==
> 1 + WQ_UNBOUND" is what we want ("one work item [...] active at any
> given time"), but that's more of my misunderstanding than anything --
> each work item can only be active in a single context at any given time,
> so that note is talking about distinct (i.e., more than 1) work items.

Yeah, a future patch is gonna change the semantics a bit and I'll update the
doc to be clearer.

> While I'm here: we're still debugging what's affecting WiFi performance
> on some of our WiFi systems, but it's possible I'll be turning some of
> these into struct kthread_worker instead. We can cross that bridge
> (including potential conflicts) if/when we come to it though.

Can you elaborate the performance problem you're seeing? I'm working on a
major update for workqueue to improve its locality behavior, so if you're
experiencing issues on CPUs w/ multiple L3 caches, it'd be a good test case.

Thanks.

-- 
tejun

