Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADC69127995
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 11:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfLTKtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 05:49:42 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39345 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfLTKtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 05:49:42 -0500
Received: by mail-wr1-f67.google.com with SMTP id y11so8960464wrt.6
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 02:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yrfph1/GfS10pnQ52qoQl7bLv2L4obyhx4T8y7yOMZM=;
        b=ymavTb38A76LwyPLUuMyrDSAg2m7QzQbPORR5ZPH2NkaFQG+SoOTdll8WBIR1m9LFw
         ITTFftJpv0huxyoEWX84c9qgYu4HbNRiDjrb9QohABFomV77z1zDuQl/xG7W3FZt4sy+
         cyD5/Jt+GqIURA0HvYLNT8qrsi9keEib+QZkaUfgaYEvvaPAroYRbBzOhHsO82uJbgzp
         tGCInwJQsonK3ajJ4TwX+ZQQtPjk44YqJOFgiRKPgtnXu2dh1T2C7vsZ1v7ZldR8YCJK
         BoX7Fu0hOu4ogHv8Da903OVwqH+QMqj0cCS9zG96TReYwU/URWn6o4LNdl+XZXde8XBx
         87lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yrfph1/GfS10pnQ52qoQl7bLv2L4obyhx4T8y7yOMZM=;
        b=sLFRE9VtD91gkCiqoBxeXJ4wdvxQJNsS+M4Zh0HXcWzd4R/hHY0U0bqUb/HYhtAlfF
         wElEnW1MJ/GT5RHhGiaqOwwfuS/52MFUVgNTUE1w2L9AbHjRop6BN1uCv0YZI58UDsWk
         t6JKPMU1Tky1QVuAxHVAKCvKX5vTGkQ355hObZp955OEFjw/I9jQITDDsqdkGtDQUWKK
         mBO1ADps/iN2Lq1W0S+Uw6b373vZyx/EKABRN41o0g28DijHZuzHCmQL4WDairHddu3o
         IGhyqA4ZvL8Ua0qUvuH7Ew+UsKMnLoA8ZWC0rvPmAkyqiO/X2PLDtB+UR2tKOEkKgNV1
         4SDQ==
X-Gm-Message-State: APjAAAU6urXZtKnMSoWukOEQrJnskQaiS4VskVwe+SzmqJxmCnRn+fIk
        1LLLBizIpct0A7ckjZltE3sN6w==
X-Google-Smtp-Source: APXvYqzZVlLF/dmhxcIff1ZqwYclRHe8LhN0IapHUGsw0pW2MVvDeN20Q5Eah+SrS19icSAsn7/FMQ==
X-Received: by 2002:a5d:6886:: with SMTP id h6mr2376655wru.154.1576838980176;
        Fri, 20 Dec 2019 02:49:40 -0800 (PST)
Received: from apalos.home (ppp-94-64-118-170.home.otenet.gr. [94.64.118.170])
        by smtp.gmail.com with ESMTPSA id c4sm9328559wml.7.2019.12.20.02.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 02:49:39 -0800 (PST)
Date:   Fri, 20 Dec 2019 12:49:37 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, lirongqing@baidu.com,
        linyunsheng@huawei.com, Saeed Mahameed <saeedm@mellanox.com>,
        mhocko@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next v5 PATCH] page_pool: handle page recycle for
 NUMA_NO_NODE condition
Message-ID: <20191220104937.GA15487@apalos.home>
References: <20191218084437.6db92d32@carbon>
 <157676523108.200893.4571988797174399927.stgit@firesoul>
 <20191220102314.GB14269@apalos.home>
 <20191220114116.59d86ff6@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220114116.59d86ff6@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 11:41:16AM +0100, Jesper Dangaard Brouer wrote:
> On Fri, 20 Dec 2019 12:23:14 +0200
> Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> 
> > Hi Jesper, 
> > 
> > I like the overall approach since this moves the check out of  the hotpath. 
> > @Saeed, since i got no hardware to test this on, would it be possible to check
> > that it still works fine for mlx5?
> > 
> > [...]
> > > +	struct ptr_ring *r = &pool->ring;
> > > +	struct page *page;
> > > +	int pref_nid; /* preferred NUMA node */
> > > +
> > > +	/* Quicker fallback, avoid locks when ring is empty */
> > > +	if (__ptr_ring_empty(r))
> > > +		return NULL;
> > > +
> > > +	/* Softirq guarantee CPU and thus NUMA node is stable. This,
> > > +	 * assumes CPU refilling driver RX-ring will also run RX-NAPI.
> > > +	 */
> > > +	pref_nid = (pool->p.nid == NUMA_NO_NODE) ? numa_mem_id() : pool->p.nid;  
> > 
> > One of the use cases for this is that during the allocation we are not
> > guaranteed to pick up the correct NUMA node. 
> > This will get automatically fixed once the driver starts recycling packets. 
> > 
> > I don't feel strongly about this, since i don't usually like hiding value
> > changes from the user but, would it make sense to move this into 
> > __page_pool_alloc_pages_slow() and change the pool->p.nid?
> > 
> > Since alloc_pages_node() will replace NUMA_NO_NODE with numa_mem_id()
> > regardless, why not store the actual node in our page pool information?
> > You can then skip this and check pool->p.nid == numa_mem_id(), regardless of
> > what's configured. 
> 
> This single code line helps support that drivers can control the nid
> themselves.  This is a feature that is only used my mlx5 AFAIK.
> 
> I do think that is useful to allow the driver to "control" the nid, as
> pinning/preferring the pages to come from the NUMA node that matches
> the PCI-e controller hardware is installed in does have benefits.

Sure you can keep the if statement as-is, it won't break anything. 
Would we want to store the actual numa id in pool->p.nid if the user selects 
'NUMA_NO_NODE'?


Thanks
/Ilias
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> 
