Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AE335F2FB
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 13:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbhDNL4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 07:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233472AbhDNL4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 07:56:30 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D309AC06175F
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 04:56:06 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id w18so23418633edc.0
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 04:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hx2ElfME/z8t2NqHuq0is1lt5Hwbga3+EmXPk/bu8jE=;
        b=DWo11BYUP8M2RRCHuP8NVoIUVaZdHxvf5gQUYMCSsF+3FuNm57QzXEZcai5Rz0tOOo
         SbjF++30ZWPKeE5ll0FuVJdbnC6en6luhn4Srsw0nzGczA/5kOLisn07OBSuyU4dZxRn
         VA64IxWARI5+cNZO1Gpuzf/roH+cBpRBVTJdejQt5W9JrR4IlCALwHfffinSr2UyHkil
         qxsEo35IATHxRBKkw2RZFaVCbU++Ou4BlBSalUywvyrmHI7vFrB5bXCM1E5ca49UqJsq
         uPEylfZj+pQ5RnNAzRX75L24L3VACUzpB9eOBEiA/pU28RYTNcsgrRrzCb+ZaVdCccSG
         HZEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hx2ElfME/z8t2NqHuq0is1lt5Hwbga3+EmXPk/bu8jE=;
        b=QYuCs0QERqQenV+oyNk/lVL2bMW0B+Lu1LnkjRSU+OM9TnL0XistIjQu0chNhhr/Uc
         rP8xS//XsvbePKOFj1lSEOp2HHhN1rC5FdwAMGBiThtls7UZs8vw8Ud2x0eWiBmDu2pQ
         LdHbybglEnD4Zi24TJSoFPKZRSyJVTNuyBbwppy6BBO+ZIaanK0JLoeb59r+pb7SRPiR
         dvJ2NhaWdpNtFjB7KkTQFd/DaGokad40G8R6brTTG/ajuoZbRUy8BgaAAhpPYRvcUtsA
         6MNHZGuifXoIO+MuST0bhGmdNty9xgfIgpIv6ATb+8z+iLEJ7fczvkeLuQ9lfEfUeovQ
         zZFA==
X-Gm-Message-State: AOAM5324VqY/iA72dAxfe9JvcEwaZs4JKgrbpmGtifFb7xGCIvAvStSz
        uk1xShZ2o9/kiSqoEivnUkNQjA==
X-Google-Smtp-Source: ABdhPJw6QJVw35RGBrDVlA3MmikqiMsQbKDlIXm2vu0RmVXh/7v7wkWwJa8DqtuBoq9uM+i77OTQzQ==
X-Received: by 2002:a05:6402:1051:: with SMTP id e17mr40827551edu.42.1618401365504;
        Wed, 14 Apr 2021 04:56:05 -0700 (PDT)
Received: from apalos.home (ppp-94-65-92-88.home.otenet.gr. [94.65.92.88])
        by smtp.gmail.com with ESMTPSA id z4sm11158884edb.97.2021.04.14.04.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 04:56:05 -0700 (PDT)
Date:   Wed, 14 Apr 2021 14:56:02 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/1] mm: Fix struct page layout on 32-bit systems
Message-ID: <YHbYUvOYedojZAoB@apalos.home>
References: <20210410205246.507048-1-willy@infradead.org>
 <20210410205246.507048-2-willy@infradead.org>
 <20210411114307.5087f958@carbon>
 <20210411103318.GC2531743@casper.infradead.org>
 <20210412011532.GG2531743@casper.infradead.org>
 <20210414101044.19da09df@carbon>
 <20210414115052.GS2531743@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414115052.GS2531743@casper.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 12:50:52PM +0100, Matthew Wilcox wrote:
> On Wed, Apr 14, 2021 at 10:10:44AM +0200, Jesper Dangaard Brouer wrote:
> > Yes, indeed! - And very frustrating.  It's keeping me up at night.
> > I'm dreaming about 32 vs 64 bit data structures. My fitbit stats tell
> > me that I don't sleep well with these kind of dreams ;-)
> 
> Then you're going to love this ... even with the latest patch, there's
> still a problem.  Because dma_addr_t is still 64-bit aligned _as a type_,
> that forces the union to be 64-bit aligned (as we already knew and worked
> around), but what I'd forgotten is that forces the entirety of struct
> page to be 64-bit aligned.  Which means ...
> 
>         /* size: 40, cachelines: 1, members: 4 */
>         /* padding: 4 */
>         /* forced alignments: 1 */
>         /* last cacheline: 40 bytes */
> } __attribute__((__aligned__(8)));
> 
> .. that we still have a hole!  It's just moved from being at offset 4
> to being at offset 36.
> 
> > That said, I think we need to have a quicker fix for the immediate
> > issue with 64-bit bit dma_addr on 32-bit arch and the misalignment hole
> > it leaves[3] in struct page.  In[3] you mention ppc32, does it only
> > happens on certain 32-bit archs?
> 
> AFAICT it happens on mips32, ppc32, arm32 and arc.  It doesn't happen
> on x86-32 because dma_addr_t is 32-bit aligned.
> 
> Doing this fixes it:
> 
> +++ b/include/linux/types.h
> @@ -140,7 +140,7 @@ typedef u64 blkcnt_t;
>   * so they don't care about the size of the actual bus addresses.
>   */
>  #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> -typedef u64 dma_addr_t;
> +typedef u64 __attribute__((aligned(sizeof(void *)))) dma_addr_t;
>  #else
>  typedef u32 dma_addr_t;
>  #endif
> 
> > I'm seriously considering removing page_pool's support for doing/keeping
> > DMA-mappings on 32-bit arch's.  AFAIK only a single driver use this.
> 
> ... if you're going to do that, then we don't need to do this.

FWIW I already proposed that to Matthew in private a few days ago...
II am not even sure the AM572x has that support.  I'd much prefer getting rid
of it as well, instead of overcomplicating the struct for a device noone is
going to need.

Cheers
/Ilias
