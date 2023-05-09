Return-Path: <netdev+bounces-1234-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F6FA6FCC89
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 19:19:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 631B71C20C21
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 17:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F26A13AE4;
	Tue,  9 May 2023 17:19:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D6B17FE0
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 17:19:15 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041792697
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:19:14 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba6388fb324so40311276.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 10:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683652753; x=1686244753;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IBTSBftt1PJZ947KTT5HuLmK9Q4JRp1ckp/xOLvbM2Y=;
        b=uKEfNpdw9WWrPRRTrj9h9foiBlNLT3WJq9pqOpE0YJHCEjNNaI4D5e5x8ELW8Q/bMI
         Pj0vnF9eTPxfw/ebSZ11JjYWE6hK6804ytp1NBPJ/uTC1i/wNay4e6osrUIIo2Jb3Gfa
         eMCArBpj9e7crAws57r8k4yEyjUKPMs9qC6D2/WBe6/cxlSlJhHjNmlhiPFyioeGPwDu
         vSaJRd+eDJr87t1zT9uXO6tSHdm2cp/o5kVEohG9qH650W9DB23S11Tmw34ykZHcR1Se
         8Mymhg2d5yjvkXuVPohyN752Sz1nP5nRx8keUCCYOe+WhCANlSO6+5t/svXtH2MdvlGE
         a3wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683652753; x=1686244753;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IBTSBftt1PJZ947KTT5HuLmK9Q4JRp1ckp/xOLvbM2Y=;
        b=T1IbXLDwqWQ3rCy5OPhbGzW48pVik5GgweKFpW5yIw8FgZemg6xI64bi8345KPHWlr
         HjX5QazUhgof5ao0FXbUHVHiXnU86vxFq9RICzUxDprC+6661/qbcVGUeSUn3obkQ28S
         oKDcGZiKT2d3tRtt65JL/bwftNsLpqqswqdcQbmKZv2byhs6/ebQpLN7PeJVpBtLsyYf
         B77nF3L858TwESHGOd2nruv+8AGfZ1qLyJnCfP6kG5X8Ob1p3uqUHPJcu3ok6bB5Qvd9
         XWuFEX+NRiAMQg8g0hycb4Xc9qsGVlyjYdNA2M3J4V+Sc5mIh/z3zcoj9QcNBRCSNuU8
         YGvw==
X-Gm-Message-State: AC+VfDwskNY0BiwcFOh3Figu6jaKiJSZ+iQiS8+qkNWjYXrDnX6xZt++
	J1z8rbk8XMGlYKdEemdMRmxIgTgi9918Iw==
X-Google-Smtp-Source: ACHHUZ4qq+O4yGw2rL/VJ5eM47IH1JbWFnhn4TU5LOG2QI4Lwps+bE/wvyYGRSdzui38NPnxXQIfxPUPBQGkdA==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:262e])
 (user=shakeelb job=sendgmr) by 2002:a25:8010:0:b0:b9e:7d81:4b91 with SMTP id
 m16-20020a258010000000b00b9e7d814b91mr6606417ybk.9.1683652753298; Tue, 09 May
 2023 10:19:13 -0700 (PDT)
Date: Tue, 9 May 2023 17:19:10 +0000
In-Reply-To: <20230508020801.10702-2-cathy.zhang@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230508020801.10702-1-cathy.zhang@intel.com> <20230508020801.10702-2-cathy.zhang@intel.com>
Message-ID: <20230509171910.yka3hucbwfnnq5fq@google.com>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
From: Shakeel Butt <shakeelb@google.com>
To: Cathy Zhang <cathy.zhang@intel.com>
Cc: edumazet@google.com, davem@davemloft.net, kuba@kernel.org, 
	pabeni@redhat.com, jesse.brandeburg@intel.com, suresh.srinivas@intel.com, 
	tim.c.chen@intel.com, lizhen.you@intel.com, eric.dumazet@gmail.com, 
	netdev@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 07, 2023 at 07:08:00PM -0700, Cathy Zhang wrote:
> Before commit 4890b686f408 ("net: keep sk->sk_forward_alloc as small as
> possible"), each TCP can forward allocate up to 2 MB of memory and
> tcp_memory_allocated might hit tcp memory limitation quite soon.

Not just the system level tcp memory limit but we have actually seen in
production unneeded and unexpected memcg OOMs and the commit 4890b686f408
fixes those OOMs as well.

> To
> reduce the memory pressure, that commit keeps sk->sk_forward_alloc as
> small as possible, which will be less than 1 page size if SO_RESERVE_MEM
> is not specified.
> 
> However, with commit 4890b686f408 ("net: keep sk->sk_forward_alloc as
> small as possible"), memcg charge hot paths are observed while system is
> stressed with a large amount of connections. That is because
> sk->sk_forward_alloc is too small and it's always less than
> sk->truesize, network handlers like tcp_rcv_established() should jump to
> slow path more frequently to increase sk->sk_forward_alloc. Each memory
> allocation will trigger memcg charge, then perf top shows the following
> contention paths on the busy system.
> 
>     16.77%  [kernel]            [k] page_counter_try_charge
>     16.56%  [kernel]            [k] page_counter_cancel
>     15.65%  [kernel]            [k] try_charge_memcg
> 
> In order to avoid the memcg overhead and performance penalty,

IMO this is not the right place to fix memcg performance overhead,
specifically because it will re-introduce the memcg OOMs issue. Please
fix the memcg overhead in the memcg code.

Please share the detail profile of the memcg code. I can help in
brainstorming and reviewing the fix.

> sk->sk_forward_alloc should be kept with a proper size instead of as
> small as possible. Keep memory up to 64KB from reclaims when uncharging
> sk_buff memory, which is closer to the maximum size of sk_buff. It will
> help reduce the frequency of allocating memory during TCP connection.
> The original reclaim threshold for reserved memory per-socket is 2MB, so
> the extraneous memory reserved now is about 32 times less than before
> commit 4890b686f408 ("net: keep sk->sk_forward_alloc as small as
> possible").
> 
> Run memcached with memtier_benchamrk to verify the optimization fix. 8
> server-client pairs are created with bridge network on localhost, server
> and client of the same pair share 28 logical CPUs.
> 
> Results (Average for 5 run)
> RPS (with/without patch)	+2.07x
> 

Do you have regression data from any production workload? Please keep in
mind that many times we (MM subsystem) accepts the regressions of
microbenchmarks over complicated optimizations. So, if there is a real
production regression, please be very explicit about it.

