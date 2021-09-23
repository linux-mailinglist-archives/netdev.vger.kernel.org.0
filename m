Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4DC54158D2
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 09:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239667AbhIWHIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 03:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239668AbhIWHIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 03:08:50 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890DEC061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 00:07:19 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id t18so14289694wrb.0
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 00:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=al6aRxBJTHCHmw5L/7ubtKaJ9PdDCptUmmdfzhB20/g=;
        b=pjlgvB9gpczXyVGy4KGKCkrvML2s1dAaukSFuRttdgOCPKZAanD/dd1hmQIuyb3gbM
         qkwMmuWRnw0DeczT3AqGL0LvEHNvSNwnj2Shw/BxvO/CYCuVt0qC2FWS96Fn8gDebpdM
         7up7/y1GKkC0DqEJFl5QX2uqvpIBAJHnlO6K3l3DvZBNCAGBslRSe6arFQqLDbG1GaQ8
         SuIh2zHWiJ8viXZWhRszlcIcJGWwbSeiLEMloumBnxKEQBf04aSYYp3zZtqiQvdFW/7+
         ZiQsxB+Ue2vQ43PfiYN3GFtAfgF2jwAuacHLKzXHTXKOGjYpKKmMyz3mof/eYL3E+xNd
         5T3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=al6aRxBJTHCHmw5L/7ubtKaJ9PdDCptUmmdfzhB20/g=;
        b=Cg55J5AngiPbV7QmZ9Lt/NH2R9tGX2EiuEMBAGHxWCSFdRE6sbSXcR78BvBpyDeSpt
         4KDLLfz7YtiBL9HKcfw4OctMV9Q5OUE/6Q+drDfodHLBK94BF5hUfDVHnQvHlTpgOEjf
         +HyYEw7h4Vr8OJLLfVOVMqO2sVlcFEuoZ42d8/4BVmEkfcynECVVF4KzCLx98LPxSQPX
         JA5cQ6YpHW1p4Awx5TmFj5xdiota3dEOiLPqewm9rErF+oZogsWO7C0XPLD+mDaEvM7x
         uVl182Sws09j7C65U8WWVLgdAezN2qFdeH8rNz1zCiY9rMJB+yCYe9aWm1k6YM/cYso9
         rFmg==
X-Gm-Message-State: AOAM530zQP8hStXt7/w1j1PB/wJttDTZXG9nj5nnU32bnPBeY8GjHi9p
        QlX9qwcICltWIuOHbYfI5V3njw==
X-Google-Smtp-Source: ABdhPJwDGSL4J+Y/s/bRsaf1H94n9NXNCXney7KIFYAavTTYcO1DvpjUj20lxmeyvG1IwQ6gCVsLJw==
X-Received: by 2002:a1c:2313:: with SMTP id j19mr14177832wmj.189.1632380838114;
        Thu, 23 Sep 2021 00:07:18 -0700 (PDT)
Received: from apalos.home (ppp-94-66-220-137.home.otenet.gr. [94.66.220.137])
        by smtp.gmail.com with ESMTPSA id c8sm4522911wru.30.2021.09.23.00.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 00:07:17 -0700 (PDT)
Date:   Thu, 23 Sep 2021 10:07:14 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        hawk@kernel.org, jonathan.lemon@gmail.com, alobakin@pm.me,
        willemb@google.com, cong.wang@bytedance.com, pabeni@redhat.com,
        haokexin@gmail.com, nogikh@google.com, elver@google.com,
        memxor@gmail.com, edumazet@google.com, alexander.duyck@gmail.com,
        dsahern@gmail.com
Subject: Re: [PATCH net-next 0/7] some optimization for page pool
Message-ID: <YUwnogBl/qbNbQ7X@apalos.home>
References: <20210922094131.15625-1-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922094131.15625-1-linyunsheng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yunsheng, 

On Wed, Sep 22, 2021 at 05:41:24PM +0800, Yunsheng Lin wrote:
> Patch 1: disable dma mapping support for 32-bit arch with 64-bit
>          DMA.
> Patch 2: support non-split page when PP_FLAG_PAGE_FRAG is set.
> patch 3: avoid calling compound_head() for skb frag page
> Patch 4-7: use pp_magic to identify pp page uniquely.

There's some subtle changes in this patchset that might affect XDP.

What I forgot when I proposed removing the recycling bit,  is that it also
serves as an 'opt-in' mechanism for drivers that want to use page_pool but 
do the recycling internally.  With that removed we need to make sure
nothing bad happens to them.  In theory the page refcnt for mlx5
specifically will be elevated, so we'll just end up unmapping the buffer.
Arguably we could add a similar mechanism internally into page pool,  
which would allow us to enable and disable recycling,  but that's
an extra if per packet allocation and I don't know if we want that on the XDP 
case.
A few numbers pre/post patch for XDP would help, but iirc hns3 doesn't have
XDP support yet?

It's plumbers week so I'll do some testing starting Monday.

Thanks
/Ilias

> 
> V3:
>     1. add patch 1/4/6/7.
>     2. use pp_magic to identify pp page uniquely too.
>     3. avoid unnecessary compound_head() calling.
> 
> V2: add patch 2, adjust the commit log accroding to the discussion
>     in V1, and fix a compiler error reported by kernel test robot.
> 
> Yunsheng Lin (7):
>   page_pool: disable dma mapping support for 32-bit arch with 64-bit DMA
>   page_pool: support non-split page with PP_FLAG_PAGE_FRAG
>   pool_pool: avoid calling compound_head() for skb frag page
>   page_pool: change BIAS_MAX to support incrementing
>   skbuff: keep track of pp page when __skb_frag_ref() is called
>   skbuff: only use pp_magic identifier for a skb' head page
>   skbuff: remove unused skb->pp_recycle
> 
>  .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  6 ---
>  drivers/net/ethernet/marvell/mvneta.c         |  2 -
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  4 +-
>  drivers/net/ethernet/marvell/sky2.c           |  2 +-
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  2 +-
>  drivers/net/ethernet/ti/cpsw.c                |  2 -
>  drivers/net/ethernet/ti/cpsw_new.c            |  2 -
>  include/linux/mm_types.h                      | 13 +-----
>  include/linux/skbuff.h                        | 39 ++++++++----------
>  include/net/page_pool.h                       | 31 ++++++++------
>  net/core/page_pool.c                          | 40 +++++++------------
>  net/core/skbuff.c                             | 36 ++++++-----------
>  net/tls/tls_device.c                          |  2 +-
>  13 files changed, 67 insertions(+), 114 deletions(-)
> 
> -- 
> 2.33.0
> 
