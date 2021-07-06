Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D806C3BC7BB
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 10:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhGFIU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 04:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbhGFIU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 04:20:58 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB26C061760
        for <netdev@vger.kernel.org>; Tue,  6 Jul 2021 01:18:20 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id l1so12928449wme.4
        for <netdev@vger.kernel.org>; Tue, 06 Jul 2021 01:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3mgnx8fEegD/aQ9zqBoBzzOqjAcJdnecr5X8UBCh88A=;
        b=jCtVYDlvBHH3GlSQUuqptLNQoADj8E6pFWpmgL1Or65pa8VgkFEwlKQz+Zy50buntc
         1nXamWlS/PQVS/aK7+Q/p0wsC7O54/u3cjI7mRNz9oaiT5YjVbK8dhHZMxPRxotu43oF
         shzv1ow2Fda7OXIQZ9qxe40tW1SS7DWp4D0t0P1LBT9ZCQ+VOMwI/d35WdrCZ8II0DP5
         anwOy0CkQp+4q4RGCYoxoUe2gppifBs8Ic/KLbTXuyrK0cx5zAPtIXE46eNnPJgHUxFq
         9+BEil0tPu6G0o3NnhY5Ioc49EO7vFdHqxmuWtvxc1NnlHrnGEGTam4NFPi1EfcpVZEb
         bLdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3mgnx8fEegD/aQ9zqBoBzzOqjAcJdnecr5X8UBCh88A=;
        b=fwYhampB73GsiOLhEWQUj3F6McFjx6QneLdrcQfpdf2uVMgfMmMJQB1GggTDMjgA8u
         jj9V3kecDywzz/H2xZS6lC6wtdzaAI2cNk5m9BVFfbxLLf6TJW1Yb2y+PZXJs5Zw/Liz
         n6WGVPt7KHHBLsgw9L5FKzmhAy/iQRiCqVeXgrOBOYjXv9RLI+44XcdCJJsmK0vAt7k2
         vCLnhNjMFRuFVsB/cLIn95o+CwC38NeSrrngrICHqhJBftQlGSC2k6Oll+TjrsQ+UiG+
         3sQiaB1sGrbimNbl6tLfGKhlAKNCZ2cgQ+vr3IR26vlNQwRtsKqBWE9afmUpEPsrTfgp
         eUjg==
X-Gm-Message-State: AOAM532Q4Hyow6Mw63rL8kXUtFsGNUAALg1md1WfgO/7Mm3KyLD8hhBs
        wYqhUVHtajK6rlgBhNkB37OkVA==
X-Google-Smtp-Source: ABdhPJzCkfz/lF+lODYpP9glLgYUjtgw7C2saATpfh0DjO+CQKgR8u8ve5k+pbfxMTn5z4kxfFlMXg==
X-Received: by 2002:a05:600c:4843:: with SMTP id j3mr19554366wmo.73.1625559498313;
        Tue, 06 Jul 2021 01:18:18 -0700 (PDT)
Received: from enceladus (ppp-94-66-242-227.home.otenet.gr. [94.66.242.227])
        by smtp.gmail.com with ESMTPSA id a22sm13783534wrc.66.2021.07.06.01.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 01:18:17 -0700 (PDT)
Date:   Tue, 6 Jul 2021 11:18:13 +0300
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
Message-ID: <YOQRxS+MUFIRubsf@enceladus>
References: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
 <1625044676-12441-2-git-send-email-linyunsheng@huawei.com>
 <6c2d76e2-30ce-5c0f-9d71-f6b71f9ad34f@redhat.com>
 <ec994486-b385-0597-39f7-128092cba0ce@huawei.com>
 <YOPiHzVkKhdHmxLB@enceladus>
 <33aee58e-b1d5-ce7b-1576-556d0da28560@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33aee58e-b1d5-ce7b-1576-556d0da28560@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >>

[...]

> >>>
> >>>
> >>>> So add elevated refcnt support in page pool, and support
> >>>> allocating page frag to enable multi-frames-per-page based
> >>>> on the elevated refcnt support.
> >>>>
> >>>> As the elevated refcnt is per page, and there is no space
> >>>> for that in "struct page" now, so add a dynamically allocated
> >>>> "struct page_pool_info" to record page pool ptr and refcnt
> >>>> corrsponding to a page for now. Later, we can recycle the
> >>>> "struct page_pool_info" too, or use part of page memory to
> >>>> record pp_info.
> >>>
> >>> I'm not happy with allocating a memory (slab) object "struct page_pool_info" per page.
> >>>
> >>> This also gives us an extra level of indirection.
> >>
> >> I'm not happy with that either, if there is better way to
> >> avoid that, I will be happy to change it:)
> > 
> > I think what we have to answer here is, do we want and does it make sense
> > for page_pool to do the housekeeping of the buffer splitting or are we
> > better of having each driver do that.  IIRC your previous patch on top of
> > the original recycling patchset was just 'atomic' refcnts on top of page pool.
> 
> You are right that driver was doing the the buffer splitting in previous
> patch.
> 
> The reason why I abandoned that is:
> 1. Currently the meta-data of page in the driver is per desc, which means
>    it might not be able to use first half of a page for a desc, and the
>    second half of the same page for another desc, this ping-pong way of
>    reusing the whole page for only one desc in the driver seems unnecessary
>    and waste a lot of memory when there is already reusing in the page pool.
> 
> 2. Easy use of API for the driver too, which means the driver uses
>    page_pool_dev_alloc_frag() and page_pool_put_full_page() for elevated
>    refcnt case, corresponding to page_pool_dev_alloc_pages() and
>    page_pool_put_full_page() for non-elevated refcnt case, the driver does
>    not need to worry about the meta-data of a page.
> 

Ok that makes sense.  We'll need the complexity anyway and I said I don't
have any strong opinions yet, we might as well make page_pool responsible
for it.
What we need to keep in mind is that page_pool was primarily used for XDP
packets.  We need to make sure we have no performance regressions there.
However I don't have access to > 10gbit NICs with XDP support. Can anyone
apply the patchset and check the performance?

> > 
> >>

[...]

> >> Aside from the performance improvement, there is memory usage
> >> decrease for 64K page size kernel, which means a 64K page can
> >> be used by 32 description with 2k buffer size, and that is a
> >> lot of memory saving for 64 page size kernel comparing to the
> >> current split page reusing implemented in the driver.
> >>
> > 
> > Whether the driver or page_pool itself keeps the meta-data, the outcome
> > here won't change.  We'll still be able to use page frags.
> 
> As above, it is the ping-pong way of reusing when the driver keeps the
> meta-data, and it is page-frag way of reusing when the page pool keeps
> the meta-data.
> 
> I am not sure if the page-frag way of reusing is possible when we still
> keep the meta-data in the driver, which seems very complex at the initial
> thinking.
> 

Fair enough. It's complex in both scenarios so if people think it's useful
I am not against adding it in the API.


Thanks
/Ilias
> > 
> > 
> > Cheers
> > /Ilias
> >>
> >>>
> >>>  __page_frag_cache_refill() + __page_frag_cache_drain() + page_frag_alloc_align()
> >>>
> >>>
> >>
> >> [...]
> > .
> > 
