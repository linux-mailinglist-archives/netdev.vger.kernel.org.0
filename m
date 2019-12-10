Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF28118B8C
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 15:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfLJOww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 09:52:52 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:36932 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbfLJOww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 09:52:52 -0500
Received: by mail-wr1-f42.google.com with SMTP id w15so20513904wru.4
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 06:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dlZD+zg4mU2MBCRgZVmmXzdjMehsCbs6hw8KLL1aGLg=;
        b=OutHUdjZDyPWaf6WfJg+zUgNcgzUCPbkVeTDnlj9gNHlyWbarIdlgsOskyYIV/Uzkz
         rFS0cpTNEbWCyhgKwvAnLz5BaY4azHX8aPfNOIYmedQ7X9gZf6oZs2zCrfL45ndWj7Y5
         zVDvZTJIMBbXlNDU1kXDaT55RWl8EuERCG0gJk+wPxsg/bwXdUegeot6UD4MHiGJN2ng
         JcqwP31s4PtvT5I6jqRuXxd275lQXjM00TOgC2GYn+S3UQtOPn6k9CGRWr/fmcDzlmQ5
         c7qmQ76a1QUWRv0cPgwfTGSZKpo57HDroGJrCj0C8Vhbp5ppxv+ydr/hs2Rf6iPdqn3j
         FHHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dlZD+zg4mU2MBCRgZVmmXzdjMehsCbs6hw8KLL1aGLg=;
        b=O77Ayv5qU7CkAGRYKnwj2nxDjTaACD4xPboYbeQGtzz7E+kpjY262NojKC1EKCRTdX
         jcdNTTcBUYVTTZS03PhHHXXBjsyXWH6iLa8+uSC/myBP7UBBxtCQbwr5fQHfPMzwtRpl
         15D0tpwCBV47a83H4hFXrP93fjrDFhrShpM6mG8roH0C9rmr8plkEky2V0lcwcOF4OhD
         N+zZhbKDDvjD68n2uHRA4zaxihOu7VO6FhLKroadux+D7K1yRA87e3jPL1Ovn6pIiqq3
         p2oYFiMNIQHBy0MP2hsuu/ziBWWbxfAjZdofnSmZ0pjykzEIY/ZuQVgFWAxDhmQIlfdK
         D90w==
X-Gm-Message-State: APjAAAV2+3vNJfjiojtpn9qt6EZu0OhprpzYwnwLz8YS46SSt9J156FT
        gSVzz3jlIky03xs6NEne6LZ0sg==
X-Google-Smtp-Source: APXvYqwYtPXlodB8vedshCxzhz/XBsOt4YRlHWVukh0b1OlisoHEJjkru2P/Bkwnzd1k31h0BIPyDg==
X-Received: by 2002:adf:dc06:: with SMTP id t6mr3810680wri.378.1575989569619;
        Tue, 10 Dec 2019 06:52:49 -0800 (PST)
Received: from apalos.home (athedsl-4476713.home.otenet.gr. [94.71.27.49])
        by smtp.gmail.com with ESMTPSA id i127sm3423270wma.35.2019.12.10.06.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 06:52:49 -0800 (PST)
Date:   Tue, 10 Dec 2019 16:52:46 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     "Li,Rongqing" <lirongqing@baidu.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3Yy?= =?utf-8?Q?=5D?= page_pool:
 handle page recycle for NUMA_NO_NODE condition
Message-ID: <20191210145246.GA12702@apalos.home>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
 <20191209131416.238d4ae4@carbon>
 <816bc34a7d25881f35e0c3e21dc2283ffeffb093.camel@mellanox.com>
 <e9855bd9-dddd-e12c-c889-b872702f80d1@huawei.com>
 <bb3c3846334744d7bbe83b1a29eaa762@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb3c3846334744d7bbe83b1a29eaa762@baidu.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, 

On Tue, Dec 10, 2019 at 09:39:14AM +0000, Li,Rongqing wrote:
> > 
> > static int mvneta_create_page_pool(struct mvneta_port *pp,
> > 				   struct mvneta_rx_queue *rxq, int size) {
> > 	struct bpf_prog *xdp_prog = READ_ONCE(pp->xdp_prog);
> > 	struct page_pool_params pp_params = {
> > 		.order = 0,
> > 		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
> > 		.pool_size = size,
> > 		.nid = cpu_to_node(0),
> 
> This kind of device should only be installed to vendor's platform which did not support numa
> 
> But as you say , Saeed advice maybe cause that recycle always fail, if nid is configured like upper, and different from running NAPI node id
> 
> And maybe we can catch this case by the below
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 3c8b51ccd1c1..973235c09487 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -328,6 +328,11 @@ static bool pool_page_reusable(struct page_pool *pool, struct page *page)
>  void __page_pool_put_page(struct page_pool *pool, struct page *page,
>                           unsigned int dma_sync_size, bool allow_direct)
>  {
> +       allow_direct = allow_direct && in_serving_softirq();
> +
> +       if (allow_direct)
> +               WARN_ON_ONCE((pool->p.nid != NUMA_NO_NODE) &&
> +                                    (pool->p.nid != numa_mem_id()));

Isn't this a duplicate of what Saeed proposed?
Instead of marking the page as recyclable we just throw a warning here.

>         /* This allocator is optimized for the XDP mode that uses
>          * one-frame-per-page, but have fallbacks that act like the
>          * regular page allocator APIs.
> @@ -342,7 +347,7 @@ void __page_pool_put_page(struct page_pool *pool, struct page *page,
>                         page_pool_dma_sync_for_device(pool, page,
>                                                       dma_sync_size);
>  

Thanks
/Ilias
