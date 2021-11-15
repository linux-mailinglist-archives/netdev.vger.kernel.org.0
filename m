Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343F2451DA7
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352488AbhKPAcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345549AbhKOT2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:28:42 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DD2C046448
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 10:55:16 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id b15so75974256edd.7
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 10:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PjdtqDE5IZoZWPVh5zBT28O2ZBw9XMZ1me5HF7IikXw=;
        b=hWdvF2YQu9ybJLd9M03F8VNvxfoMcRKL6t4J12XuU6cgl8HqPNBL379NwnT5U+873o
         gedgYwNzuwygg92/zcYP6q8WhzKquvc0Jux/+NwHmEx4vWmgVH1FJ9jHZQeh6KjsYoVN
         HRCkRRqtTmhIL05ZT9e/4WLebCM6ErBh+oiy4p1H2/7xSTTL3C2RRfdjv7lZxpdl2L8F
         3pbA6KuQfIUBFrgzhqU3He7ehlE+MVS1svKaXTNRdgg/c9BH5YwznD93H9VnhE4n6ZMd
         6b9HF5W3RQTKAp+7xqJcZwWNfG364yLgrBMXZstDHdirffLS79LCqyuGP1/hR+y1RqVe
         KZLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PjdtqDE5IZoZWPVh5zBT28O2ZBw9XMZ1me5HF7IikXw=;
        b=jpEE0ZQOofYdfSpF0eZq/6ldggTmNiB9Z3OcpQA1wBjS8BsrNqBcKzgGI1rzHflkL1
         E9EiBffNZVITkbK/djchpSSZw63rpP/so+MP4+qa4taOUYlRvVRi2jjEI/yN4k/UGjau
         /1FpEHlw2wnuY5nAxbJgwW60lRAURR7EnA2rpsq5FqgBZixkXyFojvJvLwtZqjE1Lae5
         s/PIm4GsWb2v2yrKjElXFYPTbBk9RsgOH0h6tpXakyO4FU885VFMP9+ka7VCKNRikKg5
         XkpPXyWc2bsXDuObbDkbWOMXRyBYhSBzgbTD12WxDVe+Ni4xcHZHZnxkyidlUArWzojw
         8Chg==
X-Gm-Message-State: AOAM531ACfACjmsJJEmwWXC17OerqBS4ZbnEzJI1GnxsJ89WYBksawH3
        /ms5g41frplO1b5PfLtuJRIVHQ==
X-Google-Smtp-Source: ABdhPJxBVSrjJOsg8J1xcxx2ymJmN5TWIA4YMGLAznHmtdIBIdm+x7PJqWHRA4eACTTNm81r92jqHQ==
X-Received: by 2002:a05:6402:40c3:: with SMTP id z3mr1270008edb.203.1637002515170;
        Mon, 15 Nov 2021 10:55:15 -0800 (PST)
Received: from apalos.home (ppp-94-66-220-79.home.otenet.gr. [94.66.220.79])
        by smtp.gmail.com with ESMTPSA id s4sm7248523ejn.25.2021.11.15.10.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 10:55:14 -0800 (PST)
Date:   Mon, 15 Nov 2021 20:55:11 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>, brouer@redhat.com,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        hawk@kernel.org, akpm@linux-foundation.org, peterz@infradead.org,
        will@kernel.org, jhubbard@nvidia.com, yuzhao@google.com,
        mcroce@microsoft.com, fenghua.yu@intel.com, feng.tang@intel.com,
        jgg@ziepe.ca, aarcange@redhat.com, guro@fb.com,
        "kernelci@groups.io" <kernelci@groups.io>
Subject: Re: [PATCH net-next v6] page_pool: disable dma mapping support for
 32-bit arch with 64-bit DMA
Message-ID: <YZKtD4+13gQBXEX6@apalos.home>
References: <20211013091920.1106-1-linyunsheng@huawei.com>
 <b9c0e7ef-a7a2-66ad-3a19-94cc545bd557@collabora.com>
 <1090744a-3de6-1dc2-5efe-b7caae45223a@huawei.com>
 <644e10ca-87b8-b553-db96-984c0b2c6da1@collabora.com>
 <93173400-1d37-09ed-57ef-931550b5a582@huawei.com>
 <YZJKNLEm6YTkygHM@apalos.home>
 <CAC_iWjKFLr932sMt9G2T+MFYUAQZNWPqp6YsnmSd3rMia7OpoA@mail.gmail.com>
 <d0223831-44ff-3e1a-1be9-27d751dc39f2@huawei.com>
 <8c688448-e8a9-5a6b-7b17-ccd294a416d3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c688448-e8a9-5a6b-7b17-ccd294a416d3@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


[...] 

> > > > > > > > Some more details can be found here:
> > > > > > > > 
> > > > > > > >    https://linux.kernelci.org/test/case/id/6189968c3ec0a3c06e3358fe/
> > > > > > > > 
> > > > > > > > Here's the same revision on the same platform booting fine with a
> > > > > > > > plain multi_v7_defconfig build:
> > > > > > > > 
> > > > > > > >    https://linux.kernelci.org/test/plan/id/61899d322c0e9fee7e3358ec/
> > > > > > > > 
> > > > > > > > Please let us know if you need any help debugging this issue or
> > > > > > > > if you have a fix to try.
> > > > > > > 
> > > > > > > The patch below is removing the dma mapping support in page pool
> > > > > > > for 32 bit systems with 64 bit dma address, so it seems there
> > > > > > > is indeed a a drvier using the the page pool with PP_FLAG_DMA_MAP
> > > > > > > flags set in a 32 bit systems with 64 bit dma address.
> > > > > > > 
> > > > > > > It seems we might need to revert the below patch or implement the
> > > > > > > DMA-mapping tracking support in the driver as mentioned in the below
> > > > > > > commit log.
> > > > > > > 
> > > > > > > which ethernet driver do you use in your system?
> > > > > > 
> > > > > > Thanks for taking a look and sorry for the slow reply.  Here's a
> > > > > > booting test job with LPAE disabled:
> > > > > > 
> > > > > >      https://linux.kernelci.org/test/plan/id/618dbb81c60c4d94503358f1/
> > > > > >      https://storage.kernelci.org/mainline/master/v5.15-12452-g5833291ab6de/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-nfs-rk3288-rock2-square.html#L812
> > > > > > 
> > > > > > [    8.314523] rk_gmac-dwmac ff290000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
> > > > > > 
> > > > > > So the driver is drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> > > > > 
> > > > > Thanks for the report, this patch seems to cause problem for 32-bit
> > > > > system with LPAE enabled.
> > > > > 
> > > > > As LPAE seems like a common feature for 32 bits system, this patch
> > > > > might need to be reverted.
> > > > > 
> > > > > @Jesper, @Ilias, what do you think?
> > > > 
> > > > 
> > > > So enabling LPAE also enables CONFIG_ARCH_DMA_ADDR_T_64BIT on that board?
> > > > Doing a quick grep only selects that for XEN.  I am ok reverting that,  but
> > > > I think we need to understand how the dma address ended up being 64bit.
> > > 
> > > So looking a bit closer, indeed enabling LPAE always enables this.  So
> > > we need to revert the patch.
> > > Yunsheng will you send that?
> > 
> > Sure.
> 
> Why don't we change that driver[1] to not use page_pool_get_dma_addr() ?
> 
>  [1] drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> 
> I took a closer look and it seems the driver have struct stmmac_rx_buffer in
> which is stored the dma_addr it gets from page_pool_get_dma_addr().
> 
> See func: stmmac_init_rx_buffers
> 
>  static int stmmac_init_rx_buffers(struct stmmac_priv *priv,
> 				struct dma_desc *p,
> 				int i, gfp_t flags, u32 queue)
>  {
> 
> 	if (!buf->page) {
> 		buf->page = page_pool_dev_alloc_pages(rx_q->page_pool);
> 		if (!buf->page)
> 			return -ENOMEM;
> 		buf->page_offset = stmmac_rx_offset(priv);
> 	}
> 	[...]
> 
> 	buf->addr = page_pool_get_dma_addr(buf->page) + buf->page_offset;
> 
> 	stmmac_set_desc_addr(priv, p, buf->addr);
> 	[...]
>  }
> 
> I question if this driver really to use page_pool for storing the dma_addr
> as it just extract it and store it outside page_pool?
> 
> @Ilias it looks like you added part of the page_pool support in this driver,
> so I hope you can give a qualified guess on:
> How much work will it be to let driver do the DMA-map itself?
> (and not depend on the DMA-map feature provided by page_pool)

It shouldn't be that hard.   However when we removed that we were hoping we
had no active consumers.  So we'll have to fix this and check for other
32-bit boards with LPAE and page_pool handling the DMA mappings.
But the point now is that this is far from a 'hardware configuration' of
32-bit CPU + 64-bit DMA.  Every armv7 and x86 board can get that.  So I was
thinking it's better to revert this and live with the 'weird' handling in the
code.

Cheers
/Ilias
