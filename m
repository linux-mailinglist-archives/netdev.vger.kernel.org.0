Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A82E72BC3
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 11:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfGXJxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 05:53:17 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:41784 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfGXJxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 05:53:16 -0400
Received: by mail-wr1-f53.google.com with SMTP id c2so43031115wrm.8
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 02:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lR8Ju9su/CBU1j0HeTY4zNhljAae1dIFpfV6iNZG33M=;
        b=rt/AaXnhKheL0xFkzKLunvj8+9MwYEXt7S1oWeRDReGARnsopOBP3yinZcK7tsLHqv
         qFxSb0f+FgWqC2SiOJ+Y4Q+N2wnCIxG//pk1XmsRAU8Ks4FKHEcjiDkdRA/Vqy8Tpg+3
         IrCkPu96jz7A5YWxYU96ngNunz6QAhNjF4guFqYYXuxMy4oeAms2bw1+kIMcTn0QoPLr
         1JWbKZ0PhszWxXesACC+DBTOOgO2HEByQt11XNPWWviacFtZESCOJUwMHq+yX7lh5fV+
         icCJzRZV90ddlGcEZzwNZpikwm2MDlWl0espu3AlxlUJeG/9K338Yp4WXLlVGzQSyXSH
         MT1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lR8Ju9su/CBU1j0HeTY4zNhljAae1dIFpfV6iNZG33M=;
        b=djIP9j9wk3Z1hoJxHuTbgKRxvuWZhWIO8L+DQjedZ/Wq+qNJOkScg3DdOm414HHaTY
         PpM3BDkrTE3kahWdERCm2GvLKBD0BwUZBFRzHwzy603J8tPIpZ6GYj1ejWKalB7PFjtK
         R2HtHIA4Eat59PGVdNk4uJ3yAiZbQ/7RLwcs1ttI1vq0SFxlqS/rhHQ77vO4/KdPS0Pg
         HpNb0cwof2l4pVaVfn3GCJ5xspLa0MrGu33+3b8dcEAf2p+jHW/71uv8vTwFAwNICknz
         cSzCFdZ51Pnnk5NrsMe/+3I3f9TlzjFUTkkM66YMZuvYEQXhWrNSf+aLi/Kdi5Sp/3xi
         x2GQ==
X-Gm-Message-State: APjAAAUPImXSFOiFn2a5g3VlSSqhVBNugr9C4GzJ58685vap5z3DGlJP
        oIRcpfYzrvulnhjNjv+2fVzj+w==
X-Google-Smtp-Source: APXvYqxWislcFVF3Du4KHOxbpYbgSDdLfG5qWcm0W5OuQz1uGH40+V+7q9mAco6CKAQ68bL6fhPIRg==
X-Received: by 2002:a5d:6190:: with SMTP id j16mr76465400wru.49.1563961994279;
        Wed, 24 Jul 2019 02:53:14 -0700 (PDT)
Received: from apalos (athedsl-373703.home.otenet.gr. [79.131.11.197])
        by smtp.gmail.com with ESMTPSA id p18sm45611466wrm.16.2019.07.24.02.53.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 02:53:13 -0700 (PDT)
Date:   Wed, 24 Jul 2019 12:53:10 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     David Miller <davem@davemloft.net>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "lists@bofh.nu" <lists@bofh.nu>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "maxime.ripard@bootlin.com" <maxime.ripard@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "wens@csie.org" <wens@csie.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Message-ID: <20190724095310.GA12991@apalos>
References: <BYAPR12MB32692AF2BA127C5DA5B74804D3C70@BYAPR12MB3269.namprd12.prod.outlook.com>
 <6c769226-bdd9-6fe0-b96b-5a0d800fed24@arm.com>
 <8756d681-e167-fe4a-c6f0-47ae2dcbb100@nvidia.com>
 <20190723.115112.1824255524103179323.davem@davemloft.net>
 <20190724085427.GA10736@apalos>
 <BYAPR12MB3269AA9955844E317B62A239D3C60@BYAPR12MB3269.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR12MB3269AA9955844E317B62A239D3C60@BYAPR12MB3269.namprd12.prod.outlook.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jose, 
> From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Date: Jul/24/2019, 09:54:27 (UTC+00:00)
> 
> > Hi David, 
> > 
> > > From: Jon Hunter <jonathanh@nvidia.com>
> > > Date: Tue, 23 Jul 2019 13:09:00 +0100
> > > 
> > > > Setting "iommu.passthrough=1" works for me. However, I am not sure where
> > > > to go from here, so any ideas you have would be great.
> > > 
> > > Then definitely we are accessing outside of a valid IOMMU mapping due
> > > to the page pool support changes.
> > 
> > Yes. On the netsec driver i did test with and without SMMU to make sure i am not
> > breaking anything.
> > Since we map the whole page on the API i think some offset on the driver causes
> > that. In any case i'll have another look on page_pool to make sure we are not
> > missing anything. 
> 
> Ilias, can it be due to this:
> 
> stmmac_main.c:
> 	pp_params.order = DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE);
> 
> page_pool.c:
> 	dma = dma_map_page_attrs(pool->p.dev, page, 0,
> 				 (PAGE_SIZE << pool->p.order),
> 				 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
> 
> "order", will be at least 1 and then mapping the page can cause overlap 
> ?

well the API is calling the map with the correct page, page offset (0) and size
right? I don't see any overlapping here. Aren't we mapping what we allocate?

Why do you need higher order pages? Jumbo frames? Can we do a quick test with
the order being 0?

Thanks,
/Ilias
