Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC09B127938
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 11:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfLTKXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 05:23:20 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38720 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727191AbfLTKXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 05:23:19 -0500
Received: by mail-wm1-f66.google.com with SMTP id u2so8632863wmc.3
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 02:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uQdPlsn4yWeKR+P38HI2aR4JDYgkGH7cKD0IIfa/6Fc=;
        b=jirLvM+45Mm+kCnkPb1PBEZ3dBor6q81/EXh8ttVUS/A0vTzgIYSZDzjfmGjFuXFIe
         gsD5C1kowEtYt3aXLevBGa4Q2IHwZhgA64ewav4/isbWiLjWs5FDXszXMK9IQV2qT0CO
         7Vg/i8/dB05ZMmnhB+9ob27DTES72p3VhKK7J4bVtMGlTRQ8uSoLGZ1N3LlBpdZ1tncP
         Pm340rTErQZ0m5Sjljtl5FnB7pj1tLBsJ6oVKYptRgcIiSdh147tGidGZRmkwQu6hC8n
         MWY6QBuj26wnMhKQxpgeZUS9RnrwwQ44LBx2BVZREVzL+U1B1vgCDINbMRHv7JDWhZkD
         QNJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uQdPlsn4yWeKR+P38HI2aR4JDYgkGH7cKD0IIfa/6Fc=;
        b=iox2CCaPXF+ZNektNPh92X6+vjcWd/d161HZzsDPHK0/gTJFKaPH3AA92NSq9ETC//
         2PhMvtaxGbDvgV3aoiTvhm8zvNQlo0FQ5Tu80kOcEkOOXMetlos62tvoivrwv1rNdwNK
         al2rfvk/mekx6gZ18tz0C3BYJXFZ+KbJZTxnpsm4AENIV17yvkdtTZ/1RHpDG+H3JFTZ
         JgHWp0wTsV1/8iyXiJ7SQ+1uRcYpJ6Yxxz6ri6P/NmMBmEpR7KFv4nIZ6dWa4wK6l+K7
         3gRLN6D4A6srzU4guYO7wiELdCUI8UQ0uCxkfdITp1H/xAG/eBdPB/a4eZPRqAxJjore
         uOLg==
X-Gm-Message-State: APjAAAU8sfo+cD4q67ARtEYj1oN69IdXXG4VMhVfZDTrGu0Miu8ccCz2
        OtVgRZaz+wrRrl36GNBU51Jaww==
X-Google-Smtp-Source: APXvYqxj5tK9m0x1h+AojOEUs+hkHY7x0TGAJPxJY/PS/z7eZ+XWW6Dp1nUpWbfNd9XwnsII9Tlhcg==
X-Received: by 2002:a7b:cf2d:: with SMTP id m13mr15511250wmg.163.1576837397900;
        Fri, 20 Dec 2019 02:23:17 -0800 (PST)
Received: from apalos.home (ppp-94-64-118-170.home.otenet.gr. [94.64.118.170])
        by smtp.gmail.com with ESMTPSA id q11sm9523141wrp.24.2019.12.20.02.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 02:23:17 -0800 (PST)
Date:   Fri, 20 Dec 2019 12:23:14 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, lirongqing@baidu.com,
        linyunsheng@huawei.com, Saeed Mahameed <saeedm@mellanox.com>,
        mhocko@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next v5 PATCH] page_pool: handle page recycle for
 NUMA_NO_NODE condition
Message-ID: <20191220102314.GB14269@apalos.home>
References: <20191218084437.6db92d32@carbon>
 <157676523108.200893.4571988797174399927.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157676523108.200893.4571988797174399927.stgit@firesoul>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesper, 

I like the overall approach since this moves the check out of  the hotpath. 
@Saeed, since i got no hardware to test this on, would it be possible to check
that it still works fine for mlx5?

[...]
> +	struct ptr_ring *r = &pool->ring;
> +	struct page *page;
> +	int pref_nid; /* preferred NUMA node */
> +
> +	/* Quicker fallback, avoid locks when ring is empty */
> +	if (__ptr_ring_empty(r))
> +		return NULL;
> +
> +	/* Softirq guarantee CPU and thus NUMA node is stable. This,
> +	 * assumes CPU refilling driver RX-ring will also run RX-NAPI.
> +	 */
> +	pref_nid = (pool->p.nid == NUMA_NO_NODE) ? numa_mem_id() : pool->p.nid;

One of the use cases for this is that during the allocation we are not
guaranteed to pick up the correct NUMA node. 
This will get automatically fixed once the driver starts recycling packets. 

I don't feel strongly about this, since i don't usually like hiding value
changes from the user but, would it make sense to move this into 
__page_pool_alloc_pages_slow() and change the pool->p.nid?

Since alloc_pages_node() will replace NUMA_NO_NODE with numa_mem_id()
regardless, why not store the actual node in our page pool information?
You can then skip this and check pool->p.nid == numa_mem_id(), regardless of
what's configured. 

Thanks
/Ilias
