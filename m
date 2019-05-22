Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 749BD268A9
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 18:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730201AbfEVQ4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 12:56:11 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34938 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729712AbfEVQ4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 12:56:11 -0400
Received: by mail-qk1-f193.google.com with SMTP id c15so1946437qkl.2
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 09:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7eTACDealanDtys4NrqS8slnFKSEZuAn8MP1Ic7TMFQ=;
        b=WJK9nMpvr5oajdKkw+5A/Rx0+CJDXA0aLvr9fObhHo3vyb/MWky6wGwpCq0M6wPsmf
         /q8EHG7HwnQErYtopdcEyCTfaaYgpLO8ZrzfmOmOmmAIjQ75sghztd7+oj1rnVEx+hwU
         a+EHYksPuC8a9Cagd5rC3c8vC82qLpMZgMlG2IGQY0kNlQnAOOULB5zu+wgLiveXK9Gt
         HOqyKfLZFGq7LDqpMjw6D8jc24V+nsTPJrbJKdVh6saGkyVo8b/ZtktIxB186adkuaNs
         Y+RQIOr7gPZ+7melcuBZxNpql6wiIqrMJ6bYM/9uRPhyPRL9ArRipjiSgU4/1huAffnL
         J7Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7eTACDealanDtys4NrqS8slnFKSEZuAn8MP1Ic7TMFQ=;
        b=Nr+0IzNb9L9IOOKnWMMr9UvHX2qhZsZk4gFSEeTNCWxNZ+LuwMm1hk1CidtNDX2u+R
         gw9zkVNPThxPUqiC+vMP0Smk4tD9Ijz8lkWEE8lGpBP2ga30dzDsoUj71lyngIIwFjS7
         mEhAIePsarj36EbpZwfAnjqdvPGry0wh/6sQcc5E+GtCRyq1HBo/dU+dqiGvo1yXJP5d
         hXy4YBgYFE6J14OKlP6Qx2/J/yaG9EhD2/Sk98MGxqiUIN/QHQge9yWdJmiZaIXQOPQS
         s7mxJqi/UNAY7Yz45lOi5xffEUSWpRKgGqeywYH2RxZrEo8Plc9aDJOFSrDa6ZG5WvyT
         Z3UQ==
X-Gm-Message-State: APjAAAV2DdxhzOFxeaf0fVagrdNtx6EhQ8+v7h7HUWHw0034Jx8N+KjT
        xuHoLmkpxq813pFTrFDvtAy4LQ==
X-Google-Smtp-Source: APXvYqxKnpPCeTZFUPoBPRzJKGQw4/Rxer7lX4oDV1uMgPxrCCo9/npYEB4usUmVc/lYRLUgGhxUCQ==
X-Received: by 2002:a37:dc03:: with SMTP id v3mr71496235qki.151.1558544169534;
        Wed, 22 May 2019 09:56:09 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-49-251.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.49.251])
        by smtp.gmail.com with ESMTPSA id q24sm6894008qtq.58.2019.05.22.09.56.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 09:56:08 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hTUXA-0003oA-9v; Wed, 22 May 2019 13:56:08 -0300
Date:   Wed, 22 May 2019 13:56:08 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 05/17] RDMA/counter: Add set/clear per-port
 auto mode support
Message-ID: <20190522165608.GA14554@ziepe.ca>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-6-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429083453.16654-6-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 11:34:41AM +0300, Leon Romanovsky wrote:
> From: Mark Zhang <markz@mellanox.com>
> 
> Add an API to support set/clear per-port auto mode.
> 
> Signed-off-by: Mark Zhang <markz@mellanox.com>
> Reviewed-by: Majd Dibbiny <majd@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/core/Makefile   |  2 +-
>  drivers/infiniband/core/counters.c | 77 ++++++++++++++++++++++++++++++
>  drivers/infiniband/core/device.c   |  4 ++
>  include/rdma/ib_verbs.h            |  2 +
>  include/rdma/rdma_counter.h        | 24 ++++++++++
>  include/uapi/rdma/rdma_netlink.h   | 26 ++++++++++
>  6 files changed, 134 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/infiniband/core/counters.c
> 
> diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
> index 313f2349b518..cddf748c15c9 100644
> +++ b/drivers/infiniband/core/Makefile
> @@ -12,7 +12,7 @@ ib_core-y :=			packer.o ud_header.o verbs.o cq.o rw.o sysfs.o \
>  				device.o fmr_pool.o cache.o netlink.o \
>  				roce_gid_mgmt.o mr_pool.o addr.o sa_query.o \
>  				multicast.o mad.o smi.o agent.o mad_rmpp.o \
> -				nldev.o restrack.o
> +				nldev.o restrack.o counters.o
>  
>  ib_core-$(CONFIG_SECURITY_INFINIBAND) += security.o
>  ib_core-$(CONFIG_CGROUP_RDMA) += cgroup.o
> diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
> new file mode 100644
> index 000000000000..bda8d945a758
> +++ b/drivers/infiniband/core/counters.c
> @@ -0,0 +1,77 @@
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +/*
> + * Copyright (c) 2019 Mellanox Technologies. All rights reserved.
> + */
> +#include <rdma/ib_verbs.h>
> +#include <rdma/rdma_counter.h>
> +
> +#include "core_priv.h"
> +#include "restrack.h"
> +
> +#define ALL_AUTO_MODE_MASKS (RDMA_COUNTER_MASK_QP_TYPE)
> +
> +static int __counter_set_mode(struct rdma_counter_mode *curr,
> +			      enum rdma_nl_counter_mode new_mode,
> +			      enum rdma_nl_counter_mask new_mask)
> +{
> +	if ((new_mode == RDMA_COUNTER_MODE_AUTO) &&
> +	    ((new_mask & (~ALL_AUTO_MODE_MASKS)) ||
> +	     (curr->mode != RDMA_COUNTER_MODE_NONE)))
> +		return -EINVAL;
> +
> +	curr->mode = new_mode;
> +	curr->mask = new_mask;
> +	return 0;
> +}
> +
> +/**
> + * rdma_counter_set_auto_mode() - Turn on/off per-port auto mode
> + *
> + * When @on is true, the @mask must be set
> + */
> +int rdma_counter_set_auto_mode(struct ib_device *dev, u8 port,
> +			       bool on, enum rdma_nl_counter_mask mask)
> +{
> +	struct rdma_port_counter *port_counter;
> +	int ret;
> +
> +	if (!rdma_is_port_valid(dev, port))
> +		return -EINVAL;
> +
> +	port_counter = &dev->port_data[port].port_counter;
> +	mutex_lock(&port_counter->lock);
> +	if (on) {
> +		ret = __counter_set_mode(&port_counter->mode,
> +					 RDMA_COUNTER_MODE_AUTO, mask);
> +	} else {
> +		if (port_counter->mode.mode != RDMA_COUNTER_MODE_AUTO) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +		ret = __counter_set_mode(&port_counter->mode,
> +					 RDMA_COUNTER_MODE_NONE, 0);
> +	}
> +
> +out:
> +	mutex_unlock(&port_counter->lock);
> +	return ret;
> +}
> +
> +void rdma_counter_init(struct ib_device *dev)
> +{
> +	struct rdma_port_counter *port_counter;
> +	u32 port;
> +
> +	if (!dev->ops.alloc_hw_stats)
> +		return;
> +
> +	rdma_for_each_port(dev, port) {
> +		port_counter = &dev->port_data[port].port_counter;
> +		port_counter->mode.mode = RDMA_COUNTER_MODE_NONE;
> +		mutex_init(&port_counter->lock);
> +	}
> +}
> +
> +void rdma_counter_cleanup(struct ib_device *dev)
> +{
> +}

Please don't add empty functions

> @@ -1304,6 +1307,7 @@ static void __ib_unregister_device(struct ib_device *ib_dev)
>  		goto out;
>  
>  	disable_device(ib_dev);
> +	rdma_counter_cleanup(ib_dev);

This is the wrong place to call this, the patch that actually adds a
body is just doing kfree's so it is properly called
'rdma_counter_release' and it belongs in ib_device_release()

And it shouldn't test hw_stats, and it shouldn't have a 'fail' stanza
for allocation either.

Jason
