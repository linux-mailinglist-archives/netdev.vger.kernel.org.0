Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96CC22E15B
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 17:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfE2PmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 11:42:01 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38101 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfE2PmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 11:42:01 -0400
Received: by mail-qt1-f193.google.com with SMTP id l3so3152200qtj.5
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 08:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=U9+ZXoZmSq1N9Z9JFxGsh6NHJYNjjT0qSWD/xvSYMYM=;
        b=MlbCEbrlgMsZji00+NHhpB0p05UhjOwVQqXaDjFsG+n5A5L/xc11CEmAvvAjxKmun8
         ALKIlXWhqIa1HCCMoK9i9DXClAFmkJ0bKBGHKGg5MyWuotehEkijBFBtfiRurjHHCDXI
         2RZ2Puxk2ReVKADm9GZdIRxWbZeVKgEE1VaaZFeRgdxEqKE/d1EF7edGOFn/fWJPOkoL
         xYouJp5Ur4tuqD5K7gZKNIOWPF56DsWNxyU89v5jTq+sRUPYZSmyF3FaUZm8HxzO/w68
         wTXY9yZyStfZYyr0tFKPwR45WaH3ujbBfDrUGcNol8I1IncnG9QiDGoYqJywrEVjtMkG
         FT2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=U9+ZXoZmSq1N9Z9JFxGsh6NHJYNjjT0qSWD/xvSYMYM=;
        b=NuDY66qgcwCWG4RtXX/Abl8Ca2wnGxaHUQlAXWN/j3Z1kmm7Otsrv/TndtGfmMH7MN
         bDXLEuz+4eClCcSrY9YE4MbP4xVCSlmiQsfWAPAkcbfdfxyuudebxtAvA3deN4C61duC
         UpS6ODp3Pa8BhkfTthlhBzbgSqGQFydbnC2uE5TVQL1CqMbRFb3issSWVu46XZih6fWq
         cyZlLWyM10rgr6aMNZz4d1c6UVLoEYLxPiUmqIguQYQYSDQQf1UN3jpp6OYTXU5UExY+
         lVaoFK6fPAXNMb05zhkdwzpKOjT6KY1aI+ryCbMEVo7SAx87DanObac1IjIm80krhQ3Z
         gFzA==
X-Gm-Message-State: APjAAAVq9v7Ih+ZQnQfY7vE9wbSRWupOjXWBRX3GYbbjpQky3krY7Q7W
        rydp9yEi3LYyNjlULI3iQDY2CQ==
X-Google-Smtp-Source: APXvYqxDNBw67ZtKJwdmuuaw0gjBiHUiz2Io7tBmqZ4SC9WJQ2YL7y7+wZOYhUfC5ctc4gS4ZCGrbw==
X-Received: by 2002:a0c:8d0d:: with SMTP id r13mr21831740qvb.203.1559144520165;
        Wed, 29 May 2019 08:42:00 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id z12sm4990740qkl.66.2019.05.29.08.41.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 May 2019 08:41:59 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hW0iE-0004yU-SX; Wed, 29 May 2019 12:41:58 -0300
Date:   Wed, 29 May 2019 12:41:58 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 13/17] RDMA/core: Get sum value of all
 counters when perform a sysfs stat read
Message-ID: <20190529154158.GA8567@ziepe.ca>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-14-leon@kernel.org>
 <20190522171042.GA15023@ziepe.ca>
 <20190529111544.GV4633@mtr-leonro.mtl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529111544.GV4633@mtr-leonro.mtl.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 02:15:44PM +0300, Leon Romanovsky wrote:
> On Wed, May 22, 2019 at 02:10:42PM -0300, Jason Gunthorpe wrote:
> > On Mon, Apr 29, 2019 at 11:34:49AM +0300, Leon Romanovsky wrote:
> > > From: Mark Zhang <markz@mellanox.com>
> > >
> > > Since a QP can only be bound to one counter, then if it is bound to a
> > > separate counter, for backward compatibility purpose, the statistic
> > > value must be:
> > > * stat of default counter
> > > + stat of all running allocated counters
> > > + stat of all deallocated counters (history stats)
> > >
> > > Signed-off-by: Mark Zhang <markz@mellanox.com>
> > > Reviewed-by: Majd Dibbiny <majd@mellanox.com>
> > > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > >  drivers/infiniband/core/counters.c | 99 +++++++++++++++++++++++++++++-
> > >  drivers/infiniband/core/device.c   |  8 ++-
> > >  drivers/infiniband/core/sysfs.c    | 10 ++-
> > >  include/rdma/rdma_counter.h        |  5 +-
> > >  4 files changed, 113 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
> > > index 36cd9eca1e46..f598b1cdb241 100644
> > > +++ b/drivers/infiniband/core/counters.c
> > > @@ -146,6 +146,20 @@ static int __rdma_counter_bind_qp(struct rdma_counter *counter,
> > >  	return ret;
> > >  }
> > >
> > > +static void counter_history_stat_update(const struct rdma_counter *counter)
> > > +{
> > > +	struct ib_device *dev = counter->device;
> > > +	struct rdma_port_counter *port_counter;
> > > +	int i;
> > > +
> > > +	port_counter = &dev->port_data[counter->port].port_counter;
> > > +	if (!port_counter->hstats)
> > > +		return;
> > > +
> > > +	for (i = 0; i < counter->stats->num_counters; i++)
> > > +		port_counter->hstats->value[i] += counter->stats->value[i];
> > > +}
> > > +
> > >  static int __rdma_counter_unbind_qp(struct ib_qp *qp, bool force)
> > >  {
> > >  	struct rdma_counter *counter = qp->counter;
> > > @@ -285,8 +299,10 @@ int rdma_counter_unbind_qp(struct ib_qp *qp, bool force)
> > >  		return ret;
> > >
> > >  	rdma_restrack_put(&counter->res);
> > > -	if (atomic_dec_and_test(&counter->usecnt))
> > > +	if (atomic_dec_and_test(&counter->usecnt)) {
> > > +		counter_history_stat_update(counter);
> > >  		rdma_counter_dealloc(counter);
> > > +	}
> > >
> > >  	return 0;
> > >  }
> > > @@ -307,21 +323,98 @@ int rdma_counter_query_stats(struct rdma_counter *counter)
> > >  	return ret;
> > >  }
> > >
> > > -void rdma_counter_init(struct ib_device *dev)
> > > +static u64 get_running_counters_hwstat_sum(struct ib_device *dev,
> > > +					   u8 port, u32 index)
> > > +{
> > > +	struct rdma_restrack_entry *res;
> > > +	struct rdma_restrack_root *rt;
> > > +	struct rdma_counter *counter;
> > > +	unsigned long id = 0;
> > > +	u64 sum = 0;
> > > +
> > > +	rt = &dev->res[RDMA_RESTRACK_COUNTER];
> > > +	xa_lock(&rt->xa);
> > > +	xa_for_each(&rt->xa, id, res) {
> > > +		if (!rdma_restrack_get(res))
> > > +			continue;
> >
> > Why do we need to get refcounts if we are holding the xa_lock?
> 
> Don't we need to protect an entry itself from disappearing?

xa_lock prevents xa_erase and xa_erase should be done before any
parallel kfree.

Jason
