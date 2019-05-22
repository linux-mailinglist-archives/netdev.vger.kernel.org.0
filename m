Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B30D268FA
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 19:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729475AbfEVRVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 13:21:39 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43420 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729511AbfEVRVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 13:21:39 -0400
Received: by mail-qk1-f194.google.com with SMTP id z6so1961880qkl.10
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 10:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5QZytqMZiYOF2wTS5jUhUQ+GQL4+6ObxqUvVrYeJeHk=;
        b=VtVWSjKkMs0dDBl+SEXlsg3zJ9jhjj05lFs1YFad3bzm27lQRKzgyXLqNcYynEdnt6
         t3aJZTEUdP/sjkxxFgWHMgYIn8A5lq9vB5O5bRBWOoqM2JEBbXf9z4m8rjb7gaY2UGFp
         33NhAzzEl8/LhuFHbuwYTlH3WoAH2J+xygA/E+7c6pbLLzCar8pdGD8SKPEfgSD1UQyA
         iMQfI45NjOh+OcLLDcU1rfOXcGIkx9XP1aoOiFYiQUenDeDF9w19847zOfd6PfWQdN2T
         r0OfD8Yx5BUCxzZEKvxla2o54LOyxgUF4nQUMGwE7OlYucXazT1tqRf/vcmnbpzcEJn/
         NNWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5QZytqMZiYOF2wTS5jUhUQ+GQL4+6ObxqUvVrYeJeHk=;
        b=Abtz2CUMMXqpiMdV2w8oXnzqfcwSDEeHc8H69L+4YW/lgqWMj8bdAtqnbeIz69uMuC
         juskLgHbeu8n8XYUj2cOkrQYjO/w23MkiLyf3KRcrZdd4y39HLlgX4PTzjtRsJ6XBHaw
         TDrj5lTyfl6GhUQ8wrrlFoEnN25w6DbgVHrA7icqzKDSJjT+57muwb6augwYN1P0jxSj
         H5S85k0bHwC4b4jbnytVSUDjofDtROWNHTeLDJCibtwWEW/rge/c5noPFYI/pdAM32vd
         9TURagNvky7ueFpk0/JJPmR8N+Q7wok1y/ixbiMQTArN4MGbu1HpcuB7NvTH/zwWtgZX
         0r5w==
X-Gm-Message-State: APjAAAV7i2x01Kb+g6sUJqm4GLluSYjeC7NhuZJaPCILJxGh2/+sLe0O
        u0zPNpfchvwkOLq/WhCzdAKqxQ==
X-Google-Smtp-Source: APXvYqypy3Kq4QQ2X0j/W5fNZo8gvyxSTpyOWA/z6R5djSaK8p7YAAEtG1Lmt9ruDgycBRyaC2w1nw==
X-Received: by 2002:a37:4781:: with SMTP id u123mr70425969qka.284.1558545698541;
        Wed, 22 May 2019 10:21:38 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-49-251.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.49.251])
        by smtp.gmail.com with ESMTPSA id s28sm15816210qtc.81.2019.05.22.10.21.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 10:21:38 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hTUvp-000429-KE; Wed, 22 May 2019 14:21:37 -0300
Date:   Wed, 22 May 2019 14:21:37 -0300
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
Message-ID: <20190522172137.GD15023@ziepe.ca>
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

Seems weird to add this now, why was it Ok to have counters prior to
this patch?

Jason
