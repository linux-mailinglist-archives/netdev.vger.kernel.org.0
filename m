Return-Path: <netdev+bounces-11276-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B05F173259F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 05:07:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E29491C20F29
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 03:07:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12ED8653;
	Fri, 16 Jun 2023 03:07:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BBD648
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 03:07:38 +0000 (UTC)
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDD92D67;
	Thu, 15 Jun 2023 20:07:27 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2b1acd41ad2so1830801fa.3;
        Thu, 15 Jun 2023 20:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686884845; x=1689476845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eT9UpcbwWO2JnIYIfjcX5Jd0IBCHYSti9NZENcHY/tk=;
        b=dmoE23iSIi92vpqibKIWHcNdfWvs3eBID/BVsDizNXrKkgufw5qcI/CpLFD68JvlM+
         JUiakZpOdGoRQmOYBS8/BzSXbkfXonHtwbYbwcqHGXNkldt3t1lxeQ2PfyfLLEKejsa4
         zYIqkOdLpHNd5dJas0KacV/V+S9kuyJOtL3sX9HsM3I/+sq75D0IFe3dWaxTReCyvCvQ
         IEk4mtt04oaHDnzIm7bBLpHqBaWp+OMczYLtJj8s839oEgnrlAGYMEaB8Mz0UpOL57+L
         1wkhmbsjG4RlFmQQFw9w6AVls8hIdcTWCPjltntl5JsFeDYw24KGtpjQVlB3QTRlRBEO
         KbOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686884845; x=1689476845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eT9UpcbwWO2JnIYIfjcX5Jd0IBCHYSti9NZENcHY/tk=;
        b=O7kRnOF0HVLEOD+uxSgBRuWfzNkIPh6G1lsgJYw4A+xVubk8nOAp/e1WyLqNSMzQTv
         0lfPvWgDUTXdLM7Fi7Zzt+gmGC9f97sP2E7b1xzIj/3yRw/B0Wmr82kyw4A5A5wjWaHU
         h6jiY6Lztet2epMDib8lwdNZRdSko/lFpUZPuDn/h6Rf1CMpiQDYaFFUEJJ++qBb8WJf
         nZQLwDt2z5CbmBpzLT/I0jdM5mC8TGDHoZJnneu+v3ImFUaNRLTElLHM0SpFfHEe1cSV
         l9/ZRTqNixhmUDBvvCoYRwkPusZKOIqt3zlARObTt2s7RqgXXJvho6Ho4PpGL8KiRdSv
         YKyA==
X-Gm-Message-State: AC+VfDxNgkJP10fo0FQG46MyX1g1yGh8yzLtcqgX7IUhvpQ1Y69PNWdg
	b+hwDxOgVQuAFgMaVaqVb1ePnyQREyzOL8i4A5IoTFUMPH0=
X-Google-Smtp-Source: ACHHUZ6T/TCtii78HO+6RKGkS0+MK104OEkjrz1nJ/B9+r3DADBkcNhGs6OSnP9uxhMH3q5nzELnP0bbGwUHyaRzEzA=
X-Received: by 2002:a2e:914a:0:b0:2b1:eb93:ecb1 with SMTP id
 q10-20020a2e914a000000b002b1eb93ecb1mr773236ljg.26.1686884845321; Thu, 15 Jun
 2023 20:07:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230615013645.7297-1-liangchen.linux@gmail.com>
 <20230614212031.7e1b6893@kernel.org> <b28b0e3e-87e4-5a02-c172-2d1424405a5a@redhat.com>
In-Reply-To: <b28b0e3e-87e4-5a02-c172-2d1424405a5a@redhat.com>
From: Liang Chen <liangchen.linux@gmail.com>
Date: Fri, 16 Jun 2023 11:07:12 +0800
Message-ID: <CAKhg4t+Xehzuy2Y-M7DBY3HU4y_rFpz_7P-kuX2kjxpKP20qFw@mail.gmail.com>
Subject: Re: [PATCH net-next] page pool: not return page to alloc cache during
 pool destruction
To: Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>, brouer@redhat.com, hawk@kernel.org, 
	ilias.apalodimas@linaro.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, davem@davemloft.net, edumazet@google.com, 
	pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 10:00=E2=80=AFPM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
>
> On 15/06/2023 06.20, Jakub Kicinski wrote:
> > On Thu, 15 Jun 2023 09:36:45 +0800 Liang Chen wrote:
> >> When destroying a page pool, the alloc cache and recycle ring are empt=
ied.
> >> If there are inflight pages, the retry process will periodically check=
 the
> >> recycle ring for recently returned pages, but not the alloc cache (all=
oc
> >> cache is only emptied once). As a result, any pages returned to the al=
loc
> >> cache after the page pool destruction will be stuck there and cause th=
e
> >> retry process to continuously look for inflight pages and report warni=
ngs.
> >>
> >> To safeguard against this situation, any pages returning to the alloc =
cache
> >> after pool destruction should be prevented.
> >
> > Let's hear from the page pool maintainers but I think the driver
> > is supposed to prevent allocations while pool is getting destroyed.
>
> Yes, this is a driver API violation. Direct returns (allow_direct) can
> only happen from drivers RX path, e.g while driver is active processing
> packets (in NAPI).  When driver is shutting down a page_pool, it MUST
> have stopped RX path and NAPI (napi_disable()) before calling
> page_pool_destroy()  Thus, this situation cannot happen and if it does
> it is a driver bug.
>
> > Perhaps we can add DEBUG_NET_WARN_ON_ONCE() for this condition to
> > prevent wasting cycles in production builds?
> >
>
> For this page_pool code path ("allow_direct") it is extremely important
> we avoid wasting cycles in production.  As this is used for XDP_DROP
> use-cases for 100Gbit/s NICs.
>
> At 100Gbit/s with 64 bytes Ethernet frames (84 on wire), the wirespeed
> is 148.8Mpps which gives CPU 6.72 nanosec to process each packet.
> The microbench[1] shows (below signature) that page_pool_alloc_pages() +
> page_pool_recycle_direct() cost 4.041 ns (or 14 cycles(tsc)).
> Thus, for this code fast-path every cycle counts.
>
> In practice PCIe transactions/sec seems limit total system to 108Mpps
> (with multiple RX-queues + descriptor compression) thus 9.26 nanosec to
> process each packet. Individual hardware RX queues seems be limited to
> around 36Mpps thus 27.77 nanosec to process each packet.
>
> Adding a DEBUG_NET_WARN_ON_ONCE will be annoying as I like to run my
> testlab kernels with CONFIG_DEBUG_NET, which will change this extreme
> fash-path slightly (adding some unlikely's affecting code layout to the
> mix).
>
> Question to Liang Chen: Did you hit this bug in practice?
>
> --Jesper
>

Yeah, we hit this problem while implementing page pool support for
virtio_net driver, where we only enable page pool for xdp path, i.e.
turning on/off page pool when xdp is enabled/disabled. The problem
turns up when the xdp program is uninstalled, and there are still
inflight page pool page buffers. Then napi is enabled again, the
driver starts to process those inflight page pool buffers. So we will
need to be aware of the state of the page pool (if it is being
destructed) while returning the pages back. That's what motivated us
to add this check to __page_pool_put_page.

Thanks,
Liang



> CPU E5-1650 v4 @ 3.60GHz
>   tasklet_page_pool01_fast_path Per elem:  14 cycles(tsc)  4.041 ns
>   tasklet_page_pool02_ptr_ring  Per elem:  49 cycles(tsc) 13.622 ns
>   tasklet_page_pool03_slow      Per elem: 162 cycles(tsc) 45.198 ns
>
> [1]
> https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/b=
ench_page_pool_simple.c
>

