Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 419C27DE43
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 16:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732304AbfHAOvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 10:51:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730544AbfHAOvm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 10:51:42 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E04A204EC;
        Thu,  1 Aug 2019 14:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564671102;
        bh=es+GJSm4DfXZzEUDZuCILXeu9fjr9WYBSsuRwDDUQ4s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=elyRvGjMMPEP3w9wloU7BSM7xLgVstdgaPIJ/vQhIecLIU7VQsmBM7XxjZOhF9/yC
         V754KQV/KLdve5oKgtJReJdyOVfjPMbvELPSjUSwvjAc7HoVee9YNrv4CIKGwd7g7G
         juJTyMBQL6WrO8VAR83QpmKX/IBp37Cu1aN+kIqY=
Date:   Thu, 1 Aug 2019 17:51:34 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 1/3] IB/mlx5: Query ODP capabilities for DC
Message-ID: <20190801145134.GO4832@mtr-leonro.mtl.com>
References: <20190801122139.25224-1-leon@kernel.org>
 <20190801122139.25224-2-leon@kernel.org>
 <20190801142511.GE23885@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801142511.GE23885@mellanox.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 01, 2019 at 02:25:16PM +0000, Jason Gunthorpe wrote:
> On Thu, Aug 01, 2019 at 03:21:37PM +0300, Leon Romanovsky wrote:
>
> > diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
> > index ec571fd7fcf8..5eae8d734435 100644
> > +++ b/include/linux/mlx5/mlx5_ifc.h
> > @@ -944,7 +944,9 @@ struct mlx5_ifc_odp_cap_bits {
> >
> >  	struct mlx5_ifc_odp_per_transport_service_cap_bits xrc_odp_caps;
> >
> > -	u8         reserved_at_100[0x700];
> > +	struct mlx5_ifc_odp_per_transport_service_cap_bits dc_odp_caps;
> > +
> > +	u8         reserved_at_100[0x6E0];
> >  };
>
> Not splitting this to mlx5-next?

This whole patch goes to mlx5-next, because it touches
drivers/net/ethernet/mellanox/mlx5/core/main.c too and splitting
to ifc specific patch won't change anything.

Thanks

>
> Jason
