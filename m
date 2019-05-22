Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFCAB268DD
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 19:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbfEVRKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 13:10:45 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33514 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729155AbfEVRKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 13:10:45 -0400
Received: by mail-qk1-f196.google.com with SMTP id p18so1985076qkk.0
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 10:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=g4EyfT6p5FwfZYyG+l5P03rDlwoWAmrsZLFPciaeXRM=;
        b=W/KLuJZP0NRPc5fGkoEtpXBXGKQxRin1N6vGt/I4Uo0L9X3MosUo9RSM+/nPQdr0XP
         a+2sYthD8ZhxU3FL/Dh0itkBt5CigdV+H+f1SRUyfeH9p8GgEySLFkVOgM5D1NRuvtAZ
         n5HuznPgT8FYifzlt5LDriom1pQeeqNztiSO5s57CSMxYJAWeclSYfw1VvzNicaYGTVr
         gwRD3AWbB1zCEABTw2xnjNReabz7RO4KOXkGHOZFhGfRGjUIG31hKuuglUQ3z9kpthS5
         /h45xdg6DwBipg+9C+43WoCdQt9//cwyMEfBlUC3/C9QrfIckSkcqhUwLKqDAfOQ7qfe
         jEVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=g4EyfT6p5FwfZYyG+l5P03rDlwoWAmrsZLFPciaeXRM=;
        b=pgHFzkiUoM1A0f6ESBbusneIjNqwoVp1JUJQE2Hvx42A5cNFU16S+wkGdE9gjlGEnQ
         OOvARLe9t7TjRJb+p8QgNE0qvsvtH0nZcDG00EMsdN8RNHl5OiZPQM4IGIAPue6QnfRW
         hbB8VWCWhVYZzBIeGb0tosDSN5wUzzFXasSbsve7n9DYDS8qrBFWdqm/RYqNuD1WsKfL
         RSb5x+JDXs/6PlUQu5G1/4Hpr0lYDQm+wB0S0xTztFqdz/zPYfBLjgyAkkhPNsIYLVMW
         GKrAfBfXnPeNpLJFTw0KXtuAqN2yw9Bzq2JTbcFLakJRh518J3gkq6y0B1k6vhd2Bscl
         jZ5w==
X-Gm-Message-State: APjAAAUoMU5PuD8O2PcNAfSC4YR2GoCvirHVLZpw5y2frbeSd4y/VR39
        +CdoBSHuMPS6vnE2oSCUJsx22w==
X-Google-Smtp-Source: APXvYqytVKZZ4ui0xZ1VusHhA/020Xjj6SKTQ3TKIyS2BAkiv/Y4ZZgqGSp/TfCmOmdL5og0Sykvag==
X-Received: by 2002:a05:620a:146d:: with SMTP id j13mr3848060qkl.222.1558545043992;
        Wed, 22 May 2019 10:10:43 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-49-251.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.49.251])
        by smtp.gmail.com with ESMTPSA id l40sm15886693qtc.32.2019.05.22.10.10.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 10:10:43 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hTUlH-0003wv-0E; Wed, 22 May 2019 14:10:43 -0300
Date:   Wed, 22 May 2019 14:10:42 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 13/17] RDMA/core: Get sum value of all
 counters when perform a sysfs stat read
Message-ID: <20190522171042.GA15023@ziepe.ca>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-14-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429083453.16654-14-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 11:34:49AM +0300, Leon Romanovsky wrote:
> From: Mark Zhang <markz@mellanox.com>
> 
> Since a QP can only be bound to one counter, then if it is bound to a
> separate counter, for backward compatibility purpose, the statistic
> value must be:
> * stat of default counter
> + stat of all running allocated counters
> + stat of all deallocated counters (history stats)
> 
> Signed-off-by: Mark Zhang <markz@mellanox.com>
> Reviewed-by: Majd Dibbiny <majd@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/core/counters.c | 99 +++++++++++++++++++++++++++++-
>  drivers/infiniband/core/device.c   |  8 ++-
>  drivers/infiniband/core/sysfs.c    | 10 ++-
>  include/rdma/rdma_counter.h        |  5 +-
>  4 files changed, 113 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
> index 36cd9eca1e46..f598b1cdb241 100644
> +++ b/drivers/infiniband/core/counters.c
> @@ -146,6 +146,20 @@ static int __rdma_counter_bind_qp(struct rdma_counter *counter,
>  	return ret;
>  }
>  
> +static void counter_history_stat_update(const struct rdma_counter *counter)
> +{
> +	struct ib_device *dev = counter->device;
> +	struct rdma_port_counter *port_counter;
> +	int i;
> +
> +	port_counter = &dev->port_data[counter->port].port_counter;
> +	if (!port_counter->hstats)
> +		return;
> +
> +	for (i = 0; i < counter->stats->num_counters; i++)
> +		port_counter->hstats->value[i] += counter->stats->value[i];
> +}
> +
>  static int __rdma_counter_unbind_qp(struct ib_qp *qp, bool force)
>  {
>  	struct rdma_counter *counter = qp->counter;
> @@ -285,8 +299,10 @@ int rdma_counter_unbind_qp(struct ib_qp *qp, bool force)
>  		return ret;
>  
>  	rdma_restrack_put(&counter->res);
> -	if (atomic_dec_and_test(&counter->usecnt))
> +	if (atomic_dec_and_test(&counter->usecnt)) {
> +		counter_history_stat_update(counter);
>  		rdma_counter_dealloc(counter);
> +	}
>  
>  	return 0;
>  }
> @@ -307,21 +323,98 @@ int rdma_counter_query_stats(struct rdma_counter *counter)
>  	return ret;
>  }
>  
> -void rdma_counter_init(struct ib_device *dev)
> +static u64 get_running_counters_hwstat_sum(struct ib_device *dev,
> +					   u8 port, u32 index)
> +{
> +	struct rdma_restrack_entry *res;
> +	struct rdma_restrack_root *rt;
> +	struct rdma_counter *counter;
> +	unsigned long id = 0;
> +	u64 sum = 0;
> +
> +	rt = &dev->res[RDMA_RESTRACK_COUNTER];
> +	xa_lock(&rt->xa);
> +	xa_for_each(&rt->xa, id, res) {
> +		if (!rdma_restrack_get(res))
> +			continue;

Why do we need to get refcounts if we are holding the xa_lock?

> +
> +		counter = container_of(res, struct rdma_counter, res);
> +		if ((counter->device != dev) || (counter->port != port))
> +			goto next;
> +
> +		if (rdma_counter_query_stats(counter))
> +			goto next;

And rdma_counter_query_stats does

+	mutex_lock(&counter->lock);

So this was never tested as it will insta-crash with lockdep.

Presumably this is why it is using xa_for_each and restrack_get - but
it needs to drop the lock after successful get.

This sort of comment applies to nearly evey place in this series that
uses xa_for_each. 

This needs to be tested with lockdep.

Jason
