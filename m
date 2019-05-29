Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8842E16C
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 17:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfE2Poq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 11:44:46 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41201 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfE2Pop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 11:44:45 -0400
Received: by mail-qt1-f193.google.com with SMTP id s57so3149894qte.8
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 08:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1ugujwbWgw1/+lNpmVHIPPx1F2E+BasHxCTHWAskdck=;
        b=o1aCXY6QwgPqVPWNxW/mR+NePkCQhV48n8Mt6GSlseE37otqM4mgfdz2cxkumutL3a
         JUd1w2TGRD7MVByGJJr4jnqlqEF8p2oicfXvs0wnUiYm8R2bRU+S00voiY8C2Vpfxg3q
         di4E518nNeyuC/8LBnCjDpzykolf5RuBIhVfSlKH10cdCPxfJpLz2QfsSUh1ES05GWL+
         fjDlSXsmPG/8xkFfxVKjJnCdHU4NbIJGoFOVT4WK5ihoDMQflYxw5PYvuScSmXMyaT3k
         iX4e58p2REWT+N7j9YHZ9EiWPw10xOuVXPWH8ILwW7WRQdCePQAu/pyezERUIp7ZRWb3
         v1dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1ugujwbWgw1/+lNpmVHIPPx1F2E+BasHxCTHWAskdck=;
        b=RV6BWvtJTHnkNOxUbiUUiKZrrvzI4ME0VkxooeM2UsmBhgqkvnsFX5nA2LXHzkP5uL
         4qo5HwhWNuq67NHQFenmjw/AMYVOMnJt37oMoQbji2zu5ET2xMIYH8JWSi4QltlHkXtc
         k10DJT0DgUP+FBteQrigmncekr50AXLKMpwVa3V0yxu7YEcAgXz8Uw0Glgi3ZkrpNkme
         7C6/uyI+OLWHQPVVTpC0w07NnVomKw05RgVO88K161yTlW5CEu/i67N/pJ7MzalC1Ghe
         x+YyfO8V2SagM6xqQd90PlwlktpwldJN8c7tCctG+EMiBVW972HmjCgmS5nHWCDznD+L
         yjBw==
X-Gm-Message-State: APjAAAUayFWVKjHYf02LiObnkq9pUrEfv2p0rXPjN9qgQOTgHrG98+dj
        46TJdJVayx5Ko5pcxng3qVxm4A==
X-Google-Smtp-Source: APXvYqxqnCKs4vhZYrzxvQ9szeXZkCd06oIOiF7pZ4AcglMdx6oo5ZlX5NJY/2HaYtoiPUau/KE6Mg==
X-Received: by 2002:ac8:2744:: with SMTP id h4mr22163820qth.180.1559144679558;
        Wed, 29 May 2019 08:44:39 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id h20sm8438354qtc.16.2019.05.29.08.44.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 May 2019 08:44:38 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hW0ko-00050C-AD; Wed, 29 May 2019 12:44:38 -0300
Date:   Wed, 29 May 2019 12:44:38 -0300
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
Message-ID: <20190529154438.GB8567@ziepe.ca>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-14-leon@kernel.org>
 <20190522172636.GF15023@ziepe.ca>
 <20190529110524.GU4633@mtr-leonro.mtl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529110524.GU4633@mtr-leonro.mtl.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 02:05:24PM +0300, Leon Romanovsky wrote:
> On Wed, May 22, 2019 at 02:26:36PM -0300, Jason Gunthorpe wrote:
> > On Mon, Apr 29, 2019 at 11:34:49AM +0300, Leon Romanovsky wrote:
> > > diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> > > index c56ffc61ab1e..8ae4906a60e7 100644
> > > +++ b/drivers/infiniband/core/device.c
> > > @@ -1255,7 +1255,11 @@ int ib_register_device(struct ib_device *device, const char *name)
> > >  		goto dev_cleanup;
> > >  	}
> > >
> > > -	rdma_counter_init(device);
> > > +	ret = rdma_counter_init(device);
> > > +	if (ret) {
> > > +		dev_warn(&device->dev, "Couldn't initialize counter\n");
> > > +		goto sysfs_cleanup;
> > > +	}
> >
> > Don't put this things randomly, if there is some reason it should be
> > after sysfs it needs a comment, otherwise if it is just allocating
> > memory it belongs earlier, and the unwind should be done in release.
> >
> > I also think it is very strange/wrong that both sysfs and counters are
> > allocating the same alloc_hw_stats object
> >
> > Why can't they share?
> 
> They can, but we wanted to separate "legacy" counters which were exposed
> through sysfs and "new" counters which can be enabled/disable automatically.

Is there any cross contamination through the hw_stats? If no they
should just share.

Jason
