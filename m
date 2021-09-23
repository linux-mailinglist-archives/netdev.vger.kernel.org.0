Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A630C415F34
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 15:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbhIWNJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 09:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbhIWNJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 09:09:30 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AA4C061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 06:07:58 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id d6so16910692wrc.11
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 06:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rE6nnZCkTUCQWXqTRzlILH190eg8HrCKfBnNZwDr1Zo=;
        b=VV2tCq3SN8ulJhpc0E6jDm+p8kHvTGIWq0mPVdpqBKCELiHsCgpY8t7yIKoUsss3oA
         9+FzKPqeQbvPha1ggffEuMX0eobcioNr0u/yhCbaX2f9zWv+bDZjx9dBH++SKlo/GxLc
         r/TV9g24RrZRebJvy82+h3DzTxGoYH5F7+Sn5Zw4bRLh0zYEREy6tCiAdaVQQBLsMFqD
         TEqeDIe/Uvm+ez7Bh9nbptOPACNTxy+kM8IRI6WEi9xScYcX+4S6ir5be7cL9yVqIsGg
         RSh+2wA+u9a9HWrQj/GvFVZYhD2+kbSEJ2j9ibvs7yvNvEjIyMB+XR0cFnxNRP0LjALK
         AhpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rE6nnZCkTUCQWXqTRzlILH190eg8HrCKfBnNZwDr1Zo=;
        b=7+OKftYJ6qc0WlEGTqU3UicCQMKqAf8tYhaikG6g6oNzUXDS7Qu5evoMzQ8txH1nim
         T7bju5izu1d60HOOhkjxXheYfRWiGwqeENBME0fjfHd3bZqLt2Es/ux1xoNR/PaDj939
         k6yeIYOPY0cM7w6jSvJjjUmEA8NBHsHI/wPu7a9iZ6Bj4dWe+4/gwi0C0Fz4tiNMY1p0
         O0NiEiHQdW4UwtqwzhsdUc3O6HqkaTOfuZe3O7WHg0hEK5RuT4SnIObqysQnQl/55ITq
         0jmDBlZd4D9j42FRcwGb+rrL3dEQ252QAaVtf9Hi1YZ1zR8qHIbVTZmMA/v0wSjjVoIG
         yYEQ==
X-Gm-Message-State: AOAM532cOQQhtmmw01MeZ2rbmSbn0G5SLB2Zs6ItExkJyLcdQEEejNQF
        AVr+3dLeqOOgj7y9XrAqeLLmhg==
X-Google-Smtp-Source: ABdhPJwuMnzsQggZhsSErxfF8pu9yl1541ldsvSrqOM8VzsHHyZLEe0lBR+TR8HxTw8LgR4Pqc47UQ==
X-Received: by 2002:a1c:403:: with SMTP id 3mr4417280wme.161.1632402476975;
        Thu, 23 Sep 2021 06:07:56 -0700 (PDT)
Received: from apalos.home (ppp-94-66-220-137.home.otenet.gr. [94.66.220.137])
        by smtp.gmail.com with ESMTPSA id b16sm5406560wrp.82.2021.09.23.06.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 06:07:56 -0700 (PDT)
Date:   Thu, 23 Sep 2021 16:07:53 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
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
Subject: Re: [PATCH net-next 1/7] page_pool: disable dma mapping support for
 32-bit arch with 64-bit DMA
Message-ID: <YUx8KZS5NPdTRkPS@apalos.home>
References: <20210922094131.15625-1-linyunsheng@huawei.com>
 <20210922094131.15625-2-linyunsheng@huawei.com>
 <0ffa15a1-742d-a05d-3ea6-04ff25be6a29@redhat.com>
 <CAC_iWjJLCQNHxgbQ-mzLC3OC-m2s7qj3YAtw7vPAKGG6WxywpA@mail.gmail.com>
 <adb2687f-b501-9324-52b2-33ede1169007@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adb2687f-b501-9324-52b2-33ede1169007@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 07:13:11PM +0800, Yunsheng Lin wrote:
> On 2021/9/23 18:02, Ilias Apalodimas wrote:
> > Hi Jesper,
> > 
> > On Thu, 23 Sept 2021 at 12:33, Jesper Dangaard Brouer
> > <jbrouer@redhat.com> wrote:
> >>
> >>
> >> On 22/09/2021 11.41, Yunsheng Lin wrote:
> >>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> >>> index 1a6978427d6c..a65bd7972e37 100644
> >>> --- a/net/core/page_pool.c
> >>> +++ b/net/core/page_pool.c
> >>> @@ -49,6 +49,12 @@ static int page_pool_init(struct page_pool *pool,
> >>>        * which is the XDP_TX use-case.
> >>>        */
> >>>       if (pool->p.flags & PP_FLAG_DMA_MAP) {
> >>> +             /* DMA-mapping is not supported on 32-bit systems with
> >>> +              * 64-bit DMA mapping.
> >>> +              */
> >>> +             if (sizeof(dma_addr_t) > sizeof(unsigned long))
> >>> +                     return -EINVAL;
> >>
> >> As I said before, can we please use another error than EINVAL.
> >> We should give drivers a chance/ability to detect this error, and e.g.
> >> fallback to doing DMA mappings inside driver instead.
> >>
> >> I suggest using EOPNOTSUPP 95 (Operation not supported).
> 
> Will change it to EOPNOTSUPP, thanks.

Mind sending this one separately (and you can keep my reviewed-by).  It
fits nicely on it's own and since I am not sure about the rest of the
changes yet, it would be nice to get this one in.

Cheers
/Ilias
> 
> > 
> > I am fine with both.  In any case though the aforementioned driver can
> > just remove PP_FLAG_DMA_MAP and do it's own mappings.
> > 
> > Regards
> > /Ilias
> >>
> >> -Jesper
> >>
> > .
> > 
