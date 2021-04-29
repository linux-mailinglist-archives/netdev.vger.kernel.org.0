Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49DC036EFC4
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 20:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241519AbhD2SwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 14:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241503AbhD2SwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 14:52:10 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F4BC06138E
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 11:51:22 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id i21-20020a05600c3555b029012eae2af5d4so319950wmq.4
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 11:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=G4T1feCRX4TLasSulNlD/YXTM3T/mKWHa/HALOMBqRE=;
        b=QgKZ8ydzf6oyIPPQVVElrlAAvUXvjeCV+LfNBolAT+qNEs5bCdKySk/51s6GcjTh7t
         ovdL6T/AM2Nkgg5ip/MPERs7HrwjK6whXjusJTKQBirU38Le3ua964zPqfnGVFInrfki
         dozXtZTFfbrP2a1OWFjGiIkaoGl5mZbzF29SDm7ScjoYHqoAtQ6i4E3sIAQ1FUNmcTao
         SN2rujJoPBg8W4pa95XN2MQQ3giTSA2MZQ+KlsaJxTh6JNvb+T3aj7OtYTo6Gd3rFOWZ
         L+LbZLzP7MjYMe1dsmUCxwzIQL6rtGAXICqqxWZY3TSPtLnmSoUAyqk4wM5CUMiPMf/H
         kDfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=G4T1feCRX4TLasSulNlD/YXTM3T/mKWHa/HALOMBqRE=;
        b=tVUcG72AWWcns1kH3aa7fmo93LI3BqomHd0TaciDROiLo1mcU0M4+iAlTXAir84jPX
         WSJDuF6WqAep9janendZkWxkw8bvyZCIhYMEDW8KUgJEQVpR7lYq+XQqBnUBpp9Guha9
         tvsy7VdTWyh16y6IL95zw5YrHbWRtmi71iKuyr6quRTcNpkDS29BQPQytvCyl1hinp/n
         h+IvlGUO0G+lv7bRZISet4TaHR8w+LH8njNzaFAxgp1EZ/VP6VHN2jqjlpNmi0ertPSb
         k0SQGqy5XoRr5WLz4vDEYmtNBvo9mglG5Hv0wLD5weXrVhTOPSGUUyUBJEFYHbVkgu42
         BlBA==
X-Gm-Message-State: AOAM533Y95o813d/kLekBkx8Ehb/CFBzdXXxWl+qCNbrsnOhSQvcV38m
        9Sre4N6fptjk4ABybG353MPyJ0vivKp4tIuF
X-Google-Smtp-Source: ABdhPJz4cwum8Vt8KBIxLHSQujxRWtkwfsaB3lSFdUguV+8XNNJCFG1SSDkBNsPkbHC0XADsdUSIEQ==
X-Received: by 2002:a1c:228a:: with SMTP id i132mr1768594wmi.10.1619722280823;
        Thu, 29 Apr 2021 11:51:20 -0700 (PDT)
Received: from apalos.home ([94.69.77.156])
        by smtp.gmail.com with ESMTPSA id m11sm5596997wri.44.2021.04.29.11.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 11:51:20 -0700 (PDT)
Date:   Thu, 29 Apr 2021 21:51:15 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Matteo Croce <mcroce@linux.microsoft.com>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 0/5] page_pool: recycle buffers
Message-ID: <YIsAIzecktXXBlxn@apalos.home>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
 <e873c16e-8f49-6e70-1f56-21a69e2e37ce@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e873c16e-8f49-6e70-1f56-21a69e2e37ce@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yunsheng,

On Thu, Apr 29, 2021 at 04:27:21PM +0800, Yunsheng Lin wrote:
> On 2021/4/10 6:37, Matteo Croce wrote:
> > From: Matteo Croce <mcroce@microsoft.com>
> > 
> > This is a respin of [1]
> > 
> > This  patchset shows the plans for allowing page_pool to handle and
> > maintain DMA map/unmap of the pages it serves to the driver.  For this
> > to work a return hook in the network core is introduced.
> > 
> > The overall purpose is to simplify drivers, by providing a page
> > allocation API that does recycling, such that each driver doesn't have
> > to reinvent its own recycling scheme.  Using page_pool in a driver
> > does not require implementing XDP support, but it makes it trivially
> > easy to do so.  Instead of allocating buffers specifically for SKBs
> > we now allocate a generic buffer and either wrap it on an SKB
> > (via build_skb) or create an XDP frame.
> > The recycling code leverages the XDP recycle APIs.
> > 
> > The Marvell mvpp2 and mvneta drivers are used in this patchset to
> > demonstrate how to use the API, and tested on a MacchiatoBIN
> > and EspressoBIN boards respectively.
> > 
> 
> Hi, Matteo
>      I added the skb frag page recycling in hns3 based on this patchset,
> and it has above 10%~20% performance improvement for one thread iperf
> TCP flow(IOMMU is off, there may be more performance improvement if
> considering the DMA map/unmap avoiding for IOMMU), thanks for the job.
> 
>     The skb frag page recycling support in hns3 driver is not so simple
> as the mvpp2 and mvneta driver, because:
> 
> 1. the hns3 driver do not have XDP support yet, so "struct xdp_rxq_info"
>    is added to assist relation binding between the "struct page" and
>    "struct page_pool".
> 
> 2. the hns3 driver has already a page reusing based on page spliting and
>    page reference count, but it may not work if the upper stack can not
>    handle skb and release the corresponding page fast enough.
> 
> 3. the hns3 driver support page reference count updating batching, see:
>    aeda9bf87a45 ("net: hns3: batch the page reference count updates")
> 
> So it would be better if：
> 
> 1. skb frag page recycling do not need "struct xdp_rxq_info" or
>    "struct xdp_mem_info" to bond the relation between "struct page" and
>    "struct page_pool", which seems uncessary at this point if bonding
>    a "struct page_pool" pointer directly in "struct page" does not cause
>    space increasing.

We can't do that. The reason we need those structs is that we rely on the
existing XDP code, which already recycles it's buffers, to enable
recycling.  Since we allocate a page per packet when using page_pool for a
driver , the same ideas apply to an SKB and XDP frame. We just recycle the
payload and we don't really care what's in that.  We could rename the functions
to something more generic in the future though ?

> 
> 2. it would be good to do the page reference count updating batching
>    in page pool instead of specific driver.
> 
> 
> page_pool_atomic_sub_if_positive() is added to decide who can call
> page_pool_put_full_page(), because the driver and stack may hold
> reference to the same page, only if last one which hold complete
> reference to a page can call page_pool_put_full_page() to decide if
> recycling is possible, if not, the page is released, so I am wondering
> if a similar page_pool_atomic_sub_if_positive() can added to specific
> user space address unmapping path to allow skb recycling for RX zerocopy
> too?
> 

I would prefer a different page pool type if we wanted to support the split
page model.  The changes as is are quite intrusive, since they change the 
entire skb return path.  So I would prefer introducing the changes one at a 
time. 

The fundamental difference between having the recycling in the driver vs
having it in a generic API is pretty straightforward.  When a driver holds
the extra page references he is free to decide what to reuse, when he is about
to refill his Rx descriptors.  So TCP zerocopy might work even if the
userspace applications hold the buffers for an X amount of time.
On this proposal though we *need* to decide what to do with the buffer when we
are about to free the skb.

[...]


Cheers
/Ilias
