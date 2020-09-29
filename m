Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77C227BD5F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 08:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbgI2GvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 02:51:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48482 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725786AbgI2GvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 02:51:23 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601362280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P2el4z4T/pzkwfe+NnTyTuHBT85wHNdc3OI7ierNM/Y=;
        b=NFkBgNxUY5gqCYXZTH56uM4gREuvum5z6VuUykZ7bsNy4iIXic4xSMF3uUgBx2dpNjGU9W
        Q0pxEFiU+s4CmVUHUYJ/0QV7/NE7yFRIa+MGlIZdMs/ukaDzJUgnNClwzHqTHEL7IX+ab2
        Bg321FZRbhTRPmQA8Tmph56pjztm6q0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-73TlCFEUPE2voKpqXMRgpw-1; Tue, 29 Sep 2020 02:51:18 -0400
X-MC-Unique: 73TlCFEUPE2voKpqXMRgpw-1
Received: by mail-wr1-f72.google.com with SMTP id l9so1311949wrq.20
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 23:51:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P2el4z4T/pzkwfe+NnTyTuHBT85wHNdc3OI7ierNM/Y=;
        b=J4ldclm3LHyK9LVJd/QDyIU5C9wy6xYUPY+b468VBZj2Qm8VKPnTTl0pqUqlpISj63
         PxtJ1XKv8PDM7t4v/jyQHs1LItwYU8GFQj7S9T/nW4T3G2L6REv/RpQ+WxaaQDrLXbP/
         PcZXI0R3w735lZZiRBpMq4X4OyeZbRzq0znzu+2VxqLTVrxIK63N2jPLjWvXH7fOKP8L
         WxqZFkbpj37LmDgBXal/jVR5N/QRlRI+eNWRZDvGPHFVdjlZufYcqAidM+d8Z43uZwWh
         ri0S2sHe2EhPKFqETQFXN/BEdGoEhdkS6x/IWjs2ZMC82xyr34Rcc6RbHA4qFe7jK0lo
         4lVw==
X-Gm-Message-State: AOAM532vJ4912cpMEGMpL7O/A50nFBxYu1RprF0NdL4BasNWQ4z1Romi
        7m7SJSI0ouRRhmsJW5a7bZEILakYBCirSItRx3jgRWpEuoWLjdDt/oPE8BFu36exTSd43pAwBm2
        EXkhhxuP8x+Cc3Rc6
X-Received: by 2002:a5d:55c8:: with SMTP id i8mr2395208wrw.331.1601362276982;
        Mon, 28 Sep 2020 23:51:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFyBifzvckpLQD7r8EHKOtkcUo+iba3+gpfBH8ykb9hU5ZqL4RKVRr01XS3RiySG+bnJSoxA==
X-Received: by 2002:a5d:55c8:: with SMTP id i8mr2395182wrw.331.1601362276658;
        Mon, 28 Sep 2020 23:51:16 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id u13sm4356273wrm.77.2020.09.28.23.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 23:51:15 -0700 (PDT)
Date:   Tue, 29 Sep 2020 02:51:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH V1 vhost-next] vdpa/mlx5: Make vdpa core driver a
 distinct module
Message-ID: <20200929025038-mutt-send-email-mst@kernel.org>
References: <20200924143231.GA186492@mtl-vdi-166.wap.labs.mlnx>
 <20200928155448-mutt-send-email-mst@kernel.org>
 <20200929062026.GB120395@mtl-vdi-166.wap.labs.mlnx>
 <20200929022430-mutt-send-email-mst@kernel.org>
 <20200929063433.GC120395@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929063433.GC120395@mtl-vdi-166.wap.labs.mlnx>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 09:34:33AM +0300, Eli Cohen wrote:
> On Tue, Sep 29, 2020 at 02:26:44AM -0400, Michael S. Tsirkin wrote:
> > On Tue, Sep 29, 2020 at 09:20:26AM +0300, Eli Cohen wrote:
> > > On Mon, Sep 28, 2020 at 03:55:09PM -0400, Michael S. Tsirkin wrote:
> > > > On Thu, Sep 24, 2020 at 05:32:31PM +0300, Eli Cohen wrote:
> > > > > Change core vdpa functionality into a loadbale module such that upcoming
> > > > > block implementation will be able to use it.
> > > > > 
> > > > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > > 
> > > > Why don't we merge this patch together with the block module?
> > > > 
> > > 
> > > Since there are still not too many users of this driver, I would prefer
> > > to merge this as early as possible so pepole get used to the involved
> > > modules.
> > > 
> > > Anyways, I will send another version of the patch which makes use of
> > > 'select' instead of 'depends'.
> > > 
> > > Hope you agree to merge this.
> > 
> > Are you quite sure there will be a block driver though?
> > I'd like to avoid a situation in which we have infrastructure
> > in place but no users.
> >
> 
> I know it's in our plans but I see your point. Let me know if you
> prefer me to send the patch that fixes the 'depends' thing or defer it
> to a later time.

Not sure what's the depends thing.

> > > > > ---
> > > > > V0 --> V1:
> > > > > Removed "default n" for configu options as 'n' is the default
> > > > > 
> > > > >  drivers/vdpa/Kconfig               |  8 +++-----
> > > > >  drivers/vdpa/Makefile              |  2 +-
> > > > >  drivers/vdpa/mlx5/Makefile         |  7 +++++--
> > > > >  drivers/vdpa/mlx5/core/core_main.c | 20 ++++++++++++++++++++
> > > > >  drivers/vdpa/mlx5/core/mr.c        |  3 +++
> > > > >  drivers/vdpa/mlx5/core/resources.c | 10 ++++++++++
> > > > >  6 files changed, 42 insertions(+), 8 deletions(-)
> > > > >  create mode 100644 drivers/vdpa/mlx5/core/core_main.c
> > > > > 
> > > > > diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
> > > > > index 4271c408103e..57ff6a7f7401 100644
> > > > > --- a/drivers/vdpa/Kconfig
> > > > > +++ b/drivers/vdpa/Kconfig
> > > > > @@ -29,10 +29,9 @@ config IFCVF
> > > > >  	  To compile this driver as a module, choose M here: the module will
> > > > >  	  be called ifcvf.
> > > > >  
> > > > > -config MLX5_VDPA
> > > > > -	bool "MLX5 VDPA support library for ConnectX devices"
> > > > > +config MLX5_VDPA_CORE
> > > > > +	tristate "MLX5 VDPA support library for ConnectX devices"
> > > > >  	depends on MLX5_CORE
> > > > > -	default n
> > > > >  	help
> > > > >  	  Support library for Mellanox VDPA drivers. Provides code that is
> > > > >  	  common for all types of VDPA drivers. The following drivers are planned:
> > > > > @@ -40,8 +39,7 @@ config MLX5_VDPA
> > > > >  
> > > > >  config MLX5_VDPA_NET
> > > > >  	tristate "vDPA driver for ConnectX devices"
> > > > > -	depends on MLX5_VDPA
> > > > > -	default n
> > > > > +	depends on MLX5_VDPA_CORE
> > > > >  	help
> > > > >  	  VDPA network driver for ConnectX6 and newer. Provides offloading
> > > > >  	  of virtio net datapath such that descriptors put on the ring will
> > > > > diff --git a/drivers/vdpa/Makefile b/drivers/vdpa/Makefile
> > > > > index d160e9b63a66..07353bbb9f8b 100644
> > > > > --- a/drivers/vdpa/Makefile
> > > > > +++ b/drivers/vdpa/Makefile
> > > > > @@ -2,4 +2,4 @@
> > > > >  obj-$(CONFIG_VDPA) += vdpa.o
> > > > >  obj-$(CONFIG_VDPA_SIM) += vdpa_sim/
> > > > >  obj-$(CONFIG_IFCVF)    += ifcvf/
> > > > > -obj-$(CONFIG_MLX5_VDPA) += mlx5/
> > > > > +obj-$(CONFIG_MLX5_VDPA_CORE) += mlx5/
> > > > > diff --git a/drivers/vdpa/mlx5/Makefile b/drivers/vdpa/mlx5/Makefile
> > > > > index 89a5bededc9f..9f50f7e8d889 100644
> > > > > --- a/drivers/vdpa/mlx5/Makefile
> > > > > +++ b/drivers/vdpa/mlx5/Makefile
> > > > > @@ -1,4 +1,7 @@
> > > > >  subdir-ccflags-y += -I$(srctree)/drivers/vdpa/mlx5/core
> > > > >  
> > > > > -obj-$(CONFIG_MLX5_VDPA_NET) += mlx5_vdpa.o
> > > > > -mlx5_vdpa-$(CONFIG_MLX5_VDPA_NET) += net/main.o net/mlx5_vnet.o core/resources.o core/mr.o
> > > > > +obj-$(CONFIG_MLX5_VDPA_CORE) += mlx5_vdpa_core.o
> > > > > +mlx5_vdpa_core-$(CONFIG_MLX5_VDPA_CORE) += core/resources.o core/mr.o core/core_main.o
> > > > > +
> > > > > +obj-$(CONFIG_MLX5_VDPA_NET) += mlx5_vdpa_net.o
> > > > > +mlx5_vdpa_net-$(CONFIG_MLX5_VDPA_NET) += net/main.o net/mlx5_vnet.o
> > > > > diff --git a/drivers/vdpa/mlx5/core/core_main.c b/drivers/vdpa/mlx5/core/core_main.c
> > > > > new file mode 100644
> > > > > index 000000000000..4b39b55f57ab
> > > > > --- /dev/null
> > > > > +++ b/drivers/vdpa/mlx5/core/core_main.c
> > > > > @@ -0,0 +1,20 @@
> > > > > +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> > > > > +/* Copyright (c) 2020 Mellanox Technologies Ltd. */
> > > > > +
> > > > > +#include <linux/module.h>
> > > > > +
> > > > > +MODULE_AUTHOR("Eli Cohen <elic@nvidia.com>");
> > > > > +MODULE_DESCRIPTION("Mellanox VDPA core driver");
> > > > > +MODULE_LICENSE("Dual BSD/GPL");
> > > > > +
> > > > > +static int __init mlx5_vdpa_core_init(void)
> > > > > +{
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > > +static void __exit mlx5_vdpa_core_exit(void)
> > > > > +{
> > > > > +}
> > > > > +
> > > > > +module_init(mlx5_vdpa_core_init);
> > > > > +module_exit(mlx5_vdpa_core_exit);
> > > > > diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
> > > > > index ef1c550f8266..c093eab6c714 100644
> > > > > --- a/drivers/vdpa/mlx5/core/mr.c
> > > > > +++ b/drivers/vdpa/mlx5/core/mr.c
> > > > > @@ -434,6 +434,7 @@ int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb)
> > > > >  	mutex_unlock(&mr->mkey_mtx);
> > > > >  	return err;
> > > > >  }
> > > > > +EXPORT_SYMBOL(mlx5_vdpa_create_mr);
> > > > >  
> > > > >  void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev)
> > > > >  {
> > > > > @@ -456,6 +457,7 @@ void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev)
> > > > >  out:
> > > > >  	mutex_unlock(&mr->mkey_mtx);
> > > > >  }
> > > > > +EXPORT_SYMBOL(mlx5_vdpa_destroy_mr);
> > > > >  
> > > > >  static bool map_empty(struct vhost_iotlb *iotlb)
> > > > >  {
> > > > > @@ -484,3 +486,4 @@ int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *io
> > > > >  
> > > > >  	return err;
> > > > >  }
> > > > > +EXPORT_SYMBOL(mlx5_vdpa_handle_set_map);
> > > > > diff --git a/drivers/vdpa/mlx5/core/resources.c b/drivers/vdpa/mlx5/core/resources.c
> > > > > index 96e6421c5d1c..89606a18e286 100644
> > > > > --- a/drivers/vdpa/mlx5/core/resources.c
> > > > > +++ b/drivers/vdpa/mlx5/core/resources.c
> > > > > @@ -98,6 +98,7 @@ int mlx5_vdpa_create_tis(struct mlx5_vdpa_dev *mvdev, void *in, u32 *tisn)
> > > > >  
> > > > >  	return err;
> > > > >  }
> > > > > +EXPORT_SYMBOL(mlx5_vdpa_create_tis);
> > > > >  
> > > > >  void mlx5_vdpa_destroy_tis(struct mlx5_vdpa_dev *mvdev, u32 tisn)
> > > > >  {
> > > > > @@ -108,6 +109,7 @@ void mlx5_vdpa_destroy_tis(struct mlx5_vdpa_dev *mvdev, u32 tisn)
> > > > >  	MLX5_SET(destroy_tis_in, in, tisn, tisn);
> > > > >  	mlx5_cmd_exec_in(mvdev->mdev, destroy_tis, in);
> > > > >  }
> > > > > +EXPORT_SYMBOL(mlx5_vdpa_destroy_tis);
> > > > >  
> > > > >  int mlx5_vdpa_create_rqt(struct mlx5_vdpa_dev *mvdev, void *in, int inlen, u32 *rqtn)
> > > > >  {
> > > > > @@ -121,6 +123,7 @@ int mlx5_vdpa_create_rqt(struct mlx5_vdpa_dev *mvdev, void *in, int inlen, u32 *
> > > > >  
> > > > >  	return err;
> > > > >  }
> > > > > +EXPORT_SYMBOL(mlx5_vdpa_create_rqt);
> > > > >  
> > > > >  void mlx5_vdpa_destroy_rqt(struct mlx5_vdpa_dev *mvdev, u32 rqtn)
> > > > >  {
> > > > > @@ -131,6 +134,7 @@ void mlx5_vdpa_destroy_rqt(struct mlx5_vdpa_dev *mvdev, u32 rqtn)
> > > > >  	MLX5_SET(destroy_rqt_in, in, rqtn, rqtn);
> > > > >  	mlx5_cmd_exec_in(mvdev->mdev, destroy_rqt, in);
> > > > >  }
> > > > > +EXPORT_SYMBOL(mlx5_vdpa_destroy_rqt);
> > > > >  
> > > > >  int mlx5_vdpa_create_tir(struct mlx5_vdpa_dev *mvdev, void *in, u32 *tirn)
> > > > >  {
> > > > > @@ -144,6 +148,7 @@ int mlx5_vdpa_create_tir(struct mlx5_vdpa_dev *mvdev, void *in, u32 *tirn)
> > > > >  
> > > > >  	return err;
> > > > >  }
> > > > > +EXPORT_SYMBOL(mlx5_vdpa_create_tir);
> > > > >  
> > > > >  void mlx5_vdpa_destroy_tir(struct mlx5_vdpa_dev *mvdev, u32 tirn)
> > > > >  {
> > > > > @@ -154,6 +159,7 @@ void mlx5_vdpa_destroy_tir(struct mlx5_vdpa_dev *mvdev, u32 tirn)
> > > > >  	MLX5_SET(destroy_tir_in, in, tirn, tirn);
> > > > >  	mlx5_cmd_exec_in(mvdev->mdev, destroy_tir, in);
> > > > >  }
> > > > > +EXPORT_SYMBOL(mlx5_vdpa_destroy_tir);
> > > > >  
> > > > >  int mlx5_vdpa_alloc_transport_domain(struct mlx5_vdpa_dev *mvdev, u32 *tdn)
> > > > >  {
> > > > > @@ -170,6 +176,7 @@ int mlx5_vdpa_alloc_transport_domain(struct mlx5_vdpa_dev *mvdev, u32 *tdn)
> > > > >  
> > > > >  	return err;
> > > > >  }
> > > > > +EXPORT_SYMBOL(mlx5_vdpa_alloc_transport_domain);
> > > > >  
> > > > >  void mlx5_vdpa_dealloc_transport_domain(struct mlx5_vdpa_dev *mvdev, u32 tdn)
> > > > >  {
> > > > > @@ -180,6 +187,7 @@ void mlx5_vdpa_dealloc_transport_domain(struct mlx5_vdpa_dev *mvdev, u32 tdn)
> > > > >  	MLX5_SET(dealloc_transport_domain_in, in, transport_domain, tdn);
> > > > >  	mlx5_cmd_exec_in(mvdev->mdev, dealloc_transport_domain, in);
> > > > >  }
> > > > > +EXPORT_SYMBOL(mlx5_vdpa_dealloc_transport_domain);
> > > > >  
> > > > >  int mlx5_vdpa_create_mkey(struct mlx5_vdpa_dev *mvdev, struct mlx5_core_mkey *mkey, u32 *in,
> > > > >  			  int inlen)
> > > > > @@ -266,6 +274,7 @@ int mlx5_vdpa_alloc_resources(struct mlx5_vdpa_dev *mvdev)
> > > > >  	mutex_destroy(&mvdev->mr.mkey_mtx);
> > > > >  	return err;
> > > > >  }
> > > > > +EXPORT_SYMBOL(mlx5_vdpa_alloc_resources);
> > > > >  
> > > > >  void mlx5_vdpa_free_resources(struct mlx5_vdpa_dev *mvdev)
> > > > >  {
> > > > > @@ -282,3 +291,4 @@ void mlx5_vdpa_free_resources(struct mlx5_vdpa_dev *mvdev)
> > > > >  	mutex_destroy(&mvdev->mr.mkey_mtx);
> > > > >  	res->valid = false;
> > > > >  }
> > > > > +EXPORT_SYMBOL(mlx5_vdpa_free_resources);
> > > > > -- 
> > > > > 2.27.0
> > > > 
> > 

