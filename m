Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA8B3F5A67
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 11:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbhHXJGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 05:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbhHXJGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 05:06:01 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A49C061760
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 02:05:17 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id r4so39602658ybp.4
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 02:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pi0qo+xXuS6kSGyNH78LnLRPJynXHSFWOYYRHFd34qo=;
        b=PxhEdmeB/PXelisPbyIKQvxHmi3BUgZIxo5wWrWayhicredLhmyj3CWbAz7HkZGhdl
         Z8BKInt415hq3gB2qIfuz0ogwMzaTdJRQaS6n4BpfuYZC39NSiBe6WZEWJXMSeep89fw
         JueJs6jUnu+SAiFmbpWqmAv/lgsb7kNin7NHPLoswZ13uOgoyn4HKm7JCoRbc9ORSDDh
         XbpVJql/C2jYY9hFTipQ6NEJ8RD7uKlTndGQvTmb0oId31BTyf0MqGhpmBkkJfJ3Ofdg
         UiuV6y3QpLYHocdUw7VlfAVF45Ee5QVWvvAdvr1Z3Slctf4+lT6bb69weW+QnG2c/7K9
         8lHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pi0qo+xXuS6kSGyNH78LnLRPJynXHSFWOYYRHFd34qo=;
        b=mqzUbRNR3C1wOR1I2gtAsTg5PlLE15pq8qxEagMgYkFBeridtVbu5ViBuDluuShQMP
         KT+jNguTmrh7F2tyYFP0cRZVDt2YftvnDh29ZlsR74RshoJndkZyLeExgGTHDYDDqn+z
         na07abBK72ZNop1jCgvZZLa02wYxcbUbmm/RPYwt/r1BgyaKIkret/2R2vNPfF1y1Q2F
         ycu1axXVbTXyOt/8LhfOM5GMvmyFZlmV+p5nGJkoS3X0Y7zh1pqtXz6CoxzG4Cj/8yeb
         D01NhZnxI4yeFetRxJvtWrynw6fvDBLR7pRZam7MKdUKMiLlP37Eo24VAeK24Gdms2YC
         r2Qg==
X-Gm-Message-State: AOAM530uI7o36inMqI2dVWErzpgvgsAn5oNWSCyWGOOOH+GVOHMQi3U8
        adljDllwAIOw7uoSY9/M7rqzoYHBluS2sap904lmhA==
X-Google-Smtp-Source: ABdhPJznUmLZTKao/oVi1ucNxWn1wWlDzcxsU890EijJqsIQjaLFUMysOXFz8jgVuxMaDWp1Df/UYSasSd6y8D7N9xk=
X-Received: by 2002:a25:57:: with SMTP id 84mr13065154yba.201.1629795916090;
 Tue, 24 Aug 2021 02:05:16 -0700 (PDT)
MIME-Version: 1.0
References: <1629442611-61547-1-git-send-email-linyunsheng@huawei.com>
 <1629442611-61547-3-git-send-email-linyunsheng@huawei.com>
 <YR94YYRv2qpQtdSZ@Iliass-MBP> <16468e57-49d8-0a23-0058-c920af99d74a@huawei.com>
 <YSOXwdLgeY1ti8ZO@enceladus> <710fcc40-64d0-cafc-5dde-8762cc0ae457@huawei.com>
In-Reply-To: <710fcc40-64d0-cafc-5dde-8762cc0ae457@huawei.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Tue, 24 Aug 2021 12:04:38 +0300
Message-ID: <CAC_iWj+KiPWjztQsQ-1Qi1rLDCojnzFsK18KYfyLLhsxz0k5FA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/2] page_pool: optimize the cpu sync
 operation when DMA mapping
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yunsheng,

+cc Lorenzo, which has done some tests on non-coherent platforms

On Tue, 24 Aug 2021 at 10:00, Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/8/23 20:42, Ilias Apalodimas wrote:
> > On Mon, Aug 23, 2021 at 11:56:48AM +0800, Yunsheng Lin wrote:
> >> On 2021/8/20 17:39, Ilias Apalodimas wrote:
> >>> On Fri, Aug 20, 2021 at 02:56:51PM +0800, Yunsheng Lin wrote:
>
> [..]
> >>
> >> https://elixir.bootlin.com/linux/latest/source/kernel/dma/direct.h#L104
> >>
> >> The one thing I am not sure about is that the pool->p.offset
> >> and pool->p.max_len are used to decide the sync range before this
> >> patch, while the sync range is the same as the map range when doing
> >> the sync in dma_map_page_attrs().
> >
> > I am not sure I am following here. We always sync the entire range as well
> > in the current code as the mapping function is called with max_len.
> >
> >>
> >> I assumed the above is not a issue? only sync more than we need?
> >> and it won't hurt the performance?
> >
> > We can sync more than we need, but if it's a non-coherent architecture,
> > there's a performance penalty.
>
> Since I do not have any performance data to prove if there is a
> performance penalty for non-coherent architecture, I will drop it:)

I am pretty sure it does affect it.  Unless I am missing something the
patch simply re-arranges calls to avoid calling dma_map_page_attrs()
right?
However since dma_map_page_attrs() won't do anything sync-related
since it's called with DMA_ATTR_SKIP_CPU_SYNC, I doubt calling it will
have any measurable difference.  If there is, we should pick it up.


Regards
/Ilias
>
> >
> > Regards
> > /Ilias
> >>
