Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD60268FC
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 19:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbfEVRWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 13:22:18 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46307 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727365AbfEVRWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 13:22:17 -0400
Received: by mail-qk1-f194.google.com with SMTP id a132so1956779qkb.13
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 10:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/9cmKSxWeIgR5fJLUWZ+U+J12wM/zBl4mLbAQy2Q+0U=;
        b=OXc4Qq6XsKuEn+iypCDBVs75WVhDLp6T5X+qzYhP/MVwQeup8ggDsNQARGaBqT3LBe
         0doHu3ggDRqEiFkFt6ri6sAgdGDS9WpZPg9b2x/uk1fqrJx4nNW3NZ0Yxd/dms+/SXGf
         YZwnFYcc2vPNt8uRrdfbEEdmd9Y8nmK2hypd8Zl8OFW7BpukxHGjkqHdlekzp7XaBQCl
         tSRJoiPW635VtdrmayEBUAx7ctpNuD8KIEaVeDvYTpjchlv/i4voZIvnG7c8i/6vg1hk
         cPAyVcZCW6QfZEDy0+BWIE1Rux7/UIL0h/Vqfytsp+oNcLNMQEygx5kx3cEgzXKxmE4S
         nZ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/9cmKSxWeIgR5fJLUWZ+U+J12wM/zBl4mLbAQy2Q+0U=;
        b=fs0pf3WVKjIh+ddE5+0lDG3Jo4V5jWOSOuMtrMY5a18b5cw70qNlqEDmFBUlenwloH
         NwZOdIZRrxRBwF7EHS8LBpvAP7MB+56BI0ofN8uHETK+8udbQxYaBR0MmOWfriZbA7e0
         /9yNQ9xCDY3ourjzkUlf2unURGIn6ZkkvU+YUdWNynOqWr/Lt63lfcjncCeK2PKFN2D+
         JsCzPCyiSHdUb0RqCn1xUGcPH0SDV2JDD+Ew8Z9NrDOwlr1i8qd32udvxW/izbfkBpyq
         2RiFJjfr0NB/sz91qVCct3I64vn1CeW4U/U+CRdubB6FKJv9zb2HywW3tMrKjrqUBuEf
         cIqA==
X-Gm-Message-State: APjAAAWzDbEu1CYaB7B12VOm1hMq1ChtH+ejHo/5fZcpA5gXYbls+QZI
        w/mUbp/sMmMfUthBc4p5oOu88Q==
X-Google-Smtp-Source: APXvYqxdJtsK/VJCVK99qUdU9F8acU67rhJdbOlv09gZQumQ7TxyoXG4Qz9OnqhrVV2mgy/PI02aUg==
X-Received: by 2002:a05:620a:158d:: with SMTP id d13mr12030473qkk.271.1558545736847;
        Wed, 22 May 2019 10:22:16 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-49-251.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.49.251])
        by smtp.gmail.com with ESMTPSA id j9sm1340700qkg.30.2019.05.22.10.22.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 10:22:16 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hTUwS-00042U-37; Wed, 22 May 2019 14:22:16 -0300
Date:   Wed, 22 May 2019 14:22:16 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 11/17] RDMA/netlink: Implement counter
 dumpit calback
Message-ID: <20190522172216.GE15023@ziepe.ca>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-12-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429083453.16654-12-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 11:34:47AM +0300, Leon Romanovsky wrote:
> From: Mark Zhang <markz@mellanox.com>
> 
> This patch adds the ability to return all available counters
> together with their properties and hwstats.
> 
> Signed-off-by: Mark Zhang <markz@mellanox.com>
> Reviewed-by: Majd Dibbiny <majd@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/core/counters.c |  28 +++++
>  drivers/infiniband/core/device.c   |   2 +
>  drivers/infiniband/core/nldev.c    | 173 +++++++++++++++++++++++++++++
>  include/rdma/ib_verbs.h            |  10 ++
>  include/rdma/rdma_counter.h        |   3 +
>  include/uapi/rdma/rdma_netlink.h   |  10 +-
>  6 files changed, 225 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
> index 665e0d43c21b..36cd9eca1e46 100644
> +++ b/drivers/infiniband/core/counters.c
> @@ -62,6 +62,9 @@ static struct rdma_counter *rdma_counter_alloc(struct ib_device *dev, u8 port,
>  {
>  	struct rdma_counter *counter;
>  
> +	if (!dev->ops.counter_alloc_stats)
> +		return NULL;
> +
>  	counter = kzalloc(sizeof(*counter), GFP_KERNEL);
>  	if (!counter)
>  		return NULL;
> @@ -69,16 +72,25 @@ static struct rdma_counter *rdma_counter_alloc(struct ib_device *dev, u8 port,
>  	counter->device    = dev;
>  	counter->port      = port;
>  	counter->res.type  = RDMA_RESTRACK_COUNTER;
> +	counter->stats     = dev->ops.counter_alloc_stats(counter);
> +	if (!counter->stats)
> +		goto err_stats;
> +
>  	counter->mode.mode = mode;
>  	atomic_set(&counter->usecnt, 0);
>  	mutex_init(&counter->lock);
>  
>  	return counter;
> +
> +err_stats:
> +	kfree(counter);
> +	return NULL;
>  }
>  
>  static void rdma_counter_dealloc(struct rdma_counter *counter)
>  {
>  	rdma_restrack_del(&counter->res);
> +	kfree(counter->stats);
>  	kfree(counter);
>  }
>  
> @@ -279,6 +291,22 @@ int rdma_counter_unbind_qp(struct ib_qp *qp, bool force)
>  	return 0;
>  }
>  
> +int rdma_counter_query_stats(struct rdma_counter *counter)
> +{
> +	int ret;
> +
> +	struct ib_device *dev = counter->device;
> +

Extra blank line
Something about festive trees

Jason
