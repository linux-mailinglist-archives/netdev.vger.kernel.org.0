Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCDF3BC5D2
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 06:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhGFE5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 00:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhGFE5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 00:57:40 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3BFC061760
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 21:55:01 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id q17so4033563wrv.2
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 21:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1hc5y9q+TR2gB81GfeKnlJ2OJ7hAe1yiB6F6WVE1b04=;
        b=Vo0NvDOtXpZqpu8HwooztgFhqnXwtxxCN/pfxoWQhRpoFnaXyd8bBD4VhDN1wpPgUR
         hDqOXAW5qJI1qgQIG7ShqKgUkrn34D7naCbNl2V5M32IXqSxkiYmSSFbhQdb9ighGiw8
         dofPpqPJakmJqkk9skT+jCXel1SgfIXK8WIa3DnsR/6fK0Xk7JiZq9eDO6zDfb/gK7Mv
         IGNGQYXysjvbRMzP0BKnJXFMmxO5Kc0rsh00/m+YUQkZclCW4jNtvjEl2hv5M8kf4zap
         6bJBVExOR/7dUP+YgKPXAgymJVECIjpVgEMwLJkHx3uUFfXRsHh1WgwxTuSzPb7+MTsj
         y5fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1hc5y9q+TR2gB81GfeKnlJ2OJ7hAe1yiB6F6WVE1b04=;
        b=DdXZ8gSI32UlU0iiOZDbIuIxw6GW+kSNefj9ycDYTIyOOGe8Be1y/yT8qrgvZ6boFb
         4mJhrdSCSQRPq0fdGqLoNPb2g9eTcYNCsIUgJkHD7CN7fEIY8R/1LgxB6JE1QoPAsLop
         QOK6/ns5OSAXoIX3Ck++sp9bLLdftMt68BHnYn2y+Anamzc11DfNn+DVh4a0JkprR/0j
         6lQbKk4Klf1vBFQbztzJGyPrMzJdJZItCgHgKETD+xsFIy9JYDJ5RFXu35zpnEOKM0xw
         kc9tFjccnNQkZ1AgGct2cYhf1hEb+5xq/DXgDeZh/IXi+jA+yKx3wXDzw2A5JxvqQ9hj
         2kxA==
X-Gm-Message-State: AOAM531sz//4MuZLZhUyG9Di9Xra7w3Dhb2+2jvDBsIdYcmTL36oN363
        GVEJbmwAuuLhFNVrW7y0M2TDug==
X-Google-Smtp-Source: ABdhPJw+P21r6CvwrBZSNQgijgok+s56/uFzstudBtkwxQf8+GJWobkbF+8fRoQ/Wy1n/zJPpx10YA==
X-Received: by 2002:adf:a41e:: with SMTP id d30mr1078685wra.10.1625547300130;
        Mon, 05 Jul 2021 21:55:00 -0700 (PDT)
Received: from enceladus (ppp-94-66-242-227.home.otenet.gr. [94.66.242.227])
        by smtp.gmail.com with ESMTPSA id s17sm14919717wrt.58.2021.07.05.21.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 21:54:59 -0700 (PDT)
Date:   Tue, 6 Jul 2021 07:54:55 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, linuxarm@openeuler.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, thomas.petazzoni@bootlin.com,
        mw@semihalf.com, linux@armlinux.org.uk, hawk@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        akpm@linux-foundation.org, peterz@infradead.org, will@kernel.org,
        willy@infradead.org, vbabka@suse.cz, fenghua.yu@intel.com,
        guro@fb.com, peterx@redhat.com, feng.tang@intel.com, jgg@ziepe.ca,
        mcroce@microsoft.com, hughd@google.com, jonathan.lemon@gmail.com,
        alobakin@pm.me, willemb@google.com, wenxu@ucloud.cn,
        cong.wang@bytedance.com, haokexin@gmail.com, nogikh@google.com,
        elver@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net-next RFC 1/2] page_pool: add page recycling support
 based on elevated refcnt
Message-ID: <YOPiHzVkKhdHmxLB@enceladus>
References: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
 <1625044676-12441-2-git-send-email-linyunsheng@huawei.com>
 <6c2d76e2-30ce-5c0f-9d71-f6b71f9ad34f@redhat.com>
 <ec994486-b385-0597-39f7-128092cba0ce@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec994486-b385-0597-39f7-128092cba0ce@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yunsheng,

Thanks for having a look!

On Fri, Jul 02, 2021 at 06:15:13PM +0800, Yunsheng Lin wrote:
> On 2021/7/2 17:42, Jesper Dangaard Brouer wrote:
> > 
> > On 30/06/2021 11.17, Yunsheng Lin wrote:
> >> Currently page pool only support page recycling only when
> >> refcnt of page is one, which means it can not support the
> >> split page recycling implemented in the most ethernet driver.
> > 
> > Cc. Alex Duyck as I consider him an expert in this area.
> 
> Thanks.
> 
> > 
> > 
> >> So add elevated refcnt support in page pool, and support
> >> allocating page frag to enable multi-frames-per-page based
> >> on the elevated refcnt support.
> >>
> >> As the elevated refcnt is per page, and there is no space
> >> for that in "struct page" now, so add a dynamically allocated
> >> "struct page_pool_info" to record page pool ptr and refcnt
> >> corrsponding to a page for now. Later, we can recycle the
> >> "struct page_pool_info" too, or use part of page memory to
> >> record pp_info.
> > 
> > I'm not happy with allocating a memory (slab) object "struct page_pool_info" per page.
> > 
> > This also gives us an extra level of indirection.
> 
> I'm not happy with that either, if there is better way to
> avoid that, I will be happy to change it:)

I think what we have to answer here is, do we want and does it make sense
for page_pool to do the housekeeping of the buffer splitting or are we
better of having each driver do that.  IIRC your previous patch on top of
the original recycling patchset was just 'atomic' refcnts on top of page pool.

I think I'd prefer each driver having it's own meta-data of how he splits
the page, mostly due to hardware diversity, but tbh I don't have any
strong preference atm.

> 
> > 
> > 
> > You are also adding a page "frag" API inside page pool, which I'm not 100% convinced belongs inside page_pool APIs.
> > 
> > Please notice the APIs that Alex Duyck added in mm/page_alloc.c:
> 
> Actually, that is where the idea of using "page frag" come from.
> 
> Aside from the performance improvement, there is memory usage
> decrease for 64K page size kernel, which means a 64K page can
> be used by 32 description with 2k buffer size, and that is a
> lot of memory saving for 64 page size kernel comparing to the
> current split page reusing implemented in the driver.
> 

Whether the driver or page_pool itself keeps the meta-data, the outcome
here won't change.  We'll still be able to use page frags.


Cheers
/Ilias
> 
> > 
> >  __page_frag_cache_refill() + __page_frag_cache_drain() + page_frag_alloc_align()
> > 
> > 
> 
> [...]
