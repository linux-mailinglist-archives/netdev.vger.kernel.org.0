Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB0CE416CC9
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 09:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244392AbhIXH1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 03:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244371AbhIXH1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 03:27:38 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF3CC061574
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 00:26:05 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id s16so3804121ybe.0
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 00:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iXmaLP0QITpXmUm0I4qZk9+8cjo3bJJq44r9iD2yvFA=;
        b=djWo2A2huCziuE3vkw6Kcd//eh6jk9/htSdh4LjU1JGjEtSHvS8QRtXEW2KkpnKL2+
         DwEROspQZQ12JY53NJq8OwDShZTVt1MVxwUEL965Q/6TRpYiz73CJd4/e25+WxrVN+Az
         Bhy2MgjEoJV3aYMdbFmdQCcEBtBl3Xiy6vza1/BMk40/rhl/S16nepKly03vmAVwGWqb
         7R5Dc587Z0zyZ+vDDWfesGBUHj6uZuXywqVPzuTyU2Rkt06rx5G4XEV+0tKxtwwHW8Og
         5jCjir894lkBHcCNlzahg8gvGek+mfCiPHWnCf61zgaemcNuPIHcvCnwuJOFJHsxDPxL
         vtEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iXmaLP0QITpXmUm0I4qZk9+8cjo3bJJq44r9iD2yvFA=;
        b=AhrcGZLGi5s0IwXti/gtE8kYkOHU7pSxY6ySWYGe7TWfdzwnXJW3ognKWNgJXCaPW8
         LjfCD4KJZHoJ3/8rtWcfeG6usIR8aCeZnjppgjbJAD+yfL9/abbaQsWOGeAFmJjX2gKg
         8UPgLPAd2svVRCdC3Xf6cSMK/qa82UiY1oeM5VYUSilrz5Z3b6Oq7MTiU4an3xNkslal
         9eed8pCcjlzDWDQp+e1Y15XL+MCSUQkKkGKgcgZZIeFL65jqS6jfSB3acPS25MZT0K6L
         pABbWzD71K1pznRvnARYP/GmWh4pVt/xeqxxjE2i4wlAhIqLioruw44u/mgaq09vsOYp
         XIBg==
X-Gm-Message-State: AOAM531/Df6zlfkBJtNTR0hFcC6kX5ZDdA7bj8YQV8FaJGfR0Nq9bGci
        BItk+kSEo42/B6F2YRo4x0/LbEFqr5jSNDkb2NiarA==
X-Google-Smtp-Source: ABdhPJx5lIljPuPkjF8AMt4OtZuAOPUJkxe0u7+wY9bLo39zNtO4ofyyMv+1yoKSHxceJs+i9Nc6DbrxH1Vdwc6rP9g=
X-Received: by 2002:a25:2f48:: with SMTP id v69mr10584955ybv.339.1632468364546;
 Fri, 24 Sep 2021 00:26:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210922094131.15625-1-linyunsheng@huawei.com>
 <20210922094131.15625-2-linyunsheng@huawei.com> <0ffa15a1-742d-a05d-3ea6-04ff25be6a29@redhat.com>
 <CAC_iWjJLCQNHxgbQ-mzLC3OC-m2s7qj3YAtw7vPAKGG6WxywpA@mail.gmail.com>
 <adb2687f-b501-9324-52b2-33ede1169007@huawei.com> <YUx8KZS5NPdTRkPS@apalos.home>
 <27bc803a-1687-a583-fa6b-3691fef7552e@huawei.com>
In-Reply-To: <27bc803a-1687-a583-fa6b-3691fef7552e@huawei.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Fri, 24 Sep 2021 10:25:28 +0300
Message-ID: <CAC_iWj+dandMsja0qh4CYG1Wwhgg=MriL2O74T7=1hXeEKcfXA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/7] page_pool: disable dma mapping support for
 32-bit arch with 64-bit DMA
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linuxarm@openeuler.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Marco Elver <elver@google.com>, memxor@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Sept 2021 at 10:04, Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/9/23 21:07, Ilias Apalodimas wrote:
> > On Thu, Sep 23, 2021 at 07:13:11PM +0800, Yunsheng Lin wrote:
> >> On 2021/9/23 18:02, Ilias Apalodimas wrote:
> >>> Hi Jesper,
> >>>
> >>> On Thu, 23 Sept 2021 at 12:33, Jesper Dangaard Brouer
> >>> <jbrouer@redhat.com> wrote:
> >>>>
> >>>>
> >>>> On 22/09/2021 11.41, Yunsheng Lin wrote:
> >>>>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> >>>>> index 1a6978427d6c..a65bd7972e37 100644
> >>>>> --- a/net/core/page_pool.c
> >>>>> +++ b/net/core/page_pool.c
> >>>>> @@ -49,6 +49,12 @@ static int page_pool_init(struct page_pool *pool,
> >>>>>        * which is the XDP_TX use-case.
> >>>>>        */
> >>>>>       if (pool->p.flags & PP_FLAG_DMA_MAP) {
> >>>>> +             /* DMA-mapping is not supported on 32-bit systems with
> >>>>> +              * 64-bit DMA mapping.
> >>>>> +              */
> >>>>> +             if (sizeof(dma_addr_t) > sizeof(unsigned long))
> >>>>> +                     return -EINVAL;
> >>>>
> >>>> As I said before, can we please use another error than EINVAL.
> >>>> We should give drivers a chance/ability to detect this error, and e.g.
> >>>> fallback to doing DMA mappings inside driver instead.
> >>>>
> >>>> I suggest using EOPNOTSUPP 95 (Operation not supported).
> >>
> >> Will change it to EOPNOTSUPP, thanks.
> >
> > Mind sending this one separately (and you can keep my reviewed-by).  It
> > fits nicely on it's own and since I am not sure about the rest of the
> > changes yet, it would be nice to get this one in.
>
> I am not sure sending this one separately really makes sense, as it is
> mainly used to make supporting the "keep track of pp page when __skb_frag_ref()
> is called" in patch 5 easier.

It rips out support for devices that are 32bit and have 64bit dma and
make the whole code easier to follow.  I thought we agreed on removing
the support for those devices regardless didn't we?

Regards
/Ilias
