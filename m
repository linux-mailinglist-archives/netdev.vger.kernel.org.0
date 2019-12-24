Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03117129FD9
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 10:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfLXJwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 04:52:34 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43483 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfLXJwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 04:52:34 -0500
Received: by mail-wr1-f67.google.com with SMTP id d16so19327587wre.10
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 01:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N3HBmWELJ09NCKU7N1TUdxqAH5rNCluFgs2bN3EZVaM=;
        b=a5SwwLJ7wdPE0l7OEStq9kLfrybjTtNM9B2ahwATRWhdqk04fohhlIqkQG74hqA6Fz
         +Aj3921DFogeuC7csDkXVEnZLXIELKVyi2PCE6kUhBRPU1MiHjAUkssRhn3TS+AD2OtF
         yUC7UPi9dtY344RFgjAcsU1QApLLOGY88dg+5N4uAR7UVqv73CakDc+k23Mu6MHOerXd
         nB4fUsX7i7c7BRFdJrolF1lFVqq1cTeoOCVtCFfw4L5KAXodgx7iT0vMznczToxy8fk6
         cKbCZCKI13lqNKQJj4CbsWEdfWTyhIw/ddiJsj3sRRwU8VGE2TKbaJ56MNhVXJe2KhGG
         RGug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N3HBmWELJ09NCKU7N1TUdxqAH5rNCluFgs2bN3EZVaM=;
        b=s/2HUtXpjn6YsodksBFi+hwj7g+G6E8tSqpL5PiavbtmA33DSTSXEbICKTnH8oZd1S
         c0xSGeAQ4zimG5z/rJJErrLl6t8BHBticvs3Zw8FfH0j/5H0jbAr7OXapTwovI6cY+pA
         qN93eNtiia4JdN03zte5BU7DSK9idPX7fUEh4dI3rdA/Lb+/VH0yBtey5bJh6fue0L/r
         +bAq8kk11Uze6f/SMEJS4WgsA527hDtdiOBniRTL1NQzKbQmvxgD2VX+xx0QjDindfh1
         qrqSVdWvRqhmLtd9XOUERZpLOahhP3HQPIk74wSHlvI6P/BN7rxyM6mG/FoxAjFndZQh
         xA1A==
X-Gm-Message-State: APjAAAWRZiVAgfU7vCDL5LztoVp5oeMdVNfdz5jTtODe/1kesfco+QeH
        u1TpfLRwT13rLW6NdFtN+xDWrg==
X-Google-Smtp-Source: APXvYqx8OEXpOqgIwYiNou/aJcyi8NyZ0Zz3lhggLDmM2qFtxsFeWbTTbrXCsfnE1VKXx1IcnvMZoQ==
X-Received: by 2002:adf:ee92:: with SMTP id b18mr36084857wro.281.1577181152190;
        Tue, 24 Dec 2019 01:52:32 -0800 (PST)
Received: from apalos.home (ppp-94-64-118-170.home.otenet.gr. [94.64.118.170])
        by smtp.gmail.com with ESMTPSA id v14sm23394678wrm.28.2019.12.24.01.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2019 01:52:31 -0800 (PST)
Date:   Tue, 24 Dec 2019 11:52:29 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Tomislav Tomasic <tomislav.tomasic@sartura.hr>,
        Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Nadav Haklai <nadavh@marvell.com>
Subject: Re: [RFC net-next 0/2] mvpp2: page_pool support
Message-ID: <20191224095229.GA24310@apalos.home>
References: <20191224010103.56407-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224010103.56407-1-mcroce@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 24, 2019 at 02:01:01AM +0100, Matteo Croce wrote:
> This patches change the memory allocator of mvpp2 from the frag allocator to
> the page_pool API. This change is needed to add later XDP support to mvpp2.
> 
> The reason I send it as RFC is that with this changeset, mvpp2 performs much
> more slower. This is the tc drop rate measured with a single flow:
> 
> stock net-next with frag allocator:
> rx: 900.7 Mbps 1877 Kpps
> 
> this patchset with page_pool:
> rx: 423.5 Mbps 882.3 Kpps
> 
> This is the perf top when receiving traffic:
> 
>   27.68%  [kernel]            [k] __page_pool_clean_page

This seems extremly high on the list. 

>    9.79%  [kernel]            [k] get_page_from_freelist
>    7.18%  [kernel]            [k] free_unref_page
>    4.64%  [kernel]            [k] build_skb
>    4.63%  [kernel]            [k] __netif_receive_skb_core
>    3.83%  [mvpp2]             [k] mvpp2_poll
>    3.64%  [kernel]            [k] eth_type_trans
>    3.61%  [kernel]            [k] kmem_cache_free
>    3.03%  [kernel]            [k] kmem_cache_alloc
>    2.76%  [kernel]            [k] dev_gro_receive
>    2.69%  [mvpp2]             [k] mvpp2_bm_pool_put
>    2.68%  [kernel]            [k] page_frag_free
>    1.83%  [kernel]            [k] inet_gro_receive
>    1.74%  [kernel]            [k] page_pool_alloc_pages
>    1.70%  [kernel]            [k] __build_skb
>    1.47%  [kernel]            [k] __alloc_pages_nodemask
>    1.36%  [mvpp2]             [k] mvpp2_buf_alloc.isra.0
>    1.29%  [kernel]            [k] tcf_action_exec
> 
> I tried Ilias patches for page_pool recycling, I get an improvement
> to ~1100, but I'm still far than the original allocator.

Can you post the recycling perf for comparison?

> 
> Any idea on why I get such bad numbers?

Nop but it's indeed strange

> 
> Another reason to send it as RFC is that I'm not fully convinced on how to
> use the page_pool given the HW limitation of the BM.

I'll have a look right after holidays

> 
> The driver currently uses, for every CPU, a page_pool for short packets and
> another for long ones. The driver also has 4 rx queue per port, so every
> RXQ #1 will share the short and long page pools of CPU #1.
> 

I am not sure i am following the hardware config here

> This means that for every RX queue I call xdp_rxq_info_reg_mem_model() twice,
> on two different page_pool, can this be a problem?
> 
> As usual, ideas are welcome.
> 
> Matteo Croce (2):
>   mvpp2: use page_pool allocator
>   mvpp2: memory accounting
> 
>  drivers/net/ethernet/marvell/Kconfig          |   1 +
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |   7 +
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 142 +++++++++++++++---
>  3 files changed, 125 insertions(+), 25 deletions(-)
> 
> -- 
> 2.24.1
> 
Cheers
/Ilias
