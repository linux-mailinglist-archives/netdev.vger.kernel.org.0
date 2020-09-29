Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DDC27BD35
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 08:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgI2Gej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 02:34:39 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7556 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgI2Gej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 02:34:39 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f72d51a0003>; Mon, 28 Sep 2020 23:32:58 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 29 Sep
 2020 06:34:37 +0000
Date:   Tue, 29 Sep 2020 09:34:33 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <jasowang@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <elic@nvidia.com>
Subject: Re: [PATCH V1 vhost-next] vdpa/mlx5: Make vdpa core driver a
 distinct module
Message-ID: <20200929063433.GC120395@mtl-vdi-166.wap.labs.mlnx>
References: <20200924143231.GA186492@mtl-vdi-166.wap.labs.mlnx>
 <20200928155448-mutt-send-email-mst@kernel.org>
 <20200929062026.GB120395@mtl-vdi-166.wap.labs.mlnx>
 <20200929022430-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200929022430-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601361178; bh=l9qG9LBFjw4viaVywOFIG85jlSGRc2/E0zyTKuySSrQ=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=QaGzBY9ZSHz+QT5YRFkA1VOOtjiu9Bosuefda6vwKgM79rnBGbYmvaJ1q57zyyCXZ
         ET/0hc1taTEXUWt6MzwS1BZW5LCzt1nRYDlpB5B8B7QvNgszI0sVwi52JNGgSomrMC
         G9FSL3e66zLAYRngGNdh801B+NqJ9Aan45Kq52DFVAihc51JgUNkF56IYmLRNBERD2
         DDJ9NKJZd/A2Tsha5SlyrMynAk0W5FH1wV6Z/JllzsDEaVAysbM4wiOGtmBMfn5evw
         Rvj0LUqPlWfXeDqWFgSz+cGskcq5iqIAXYCPWppnBOBY1IDd3fWIXi6rTjyYErxQ9K
         6icMeFSk0u/FQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 02:26:44AM -0400, Michael S. Tsirkin wrote:
> On Tue, Sep 29, 2020 at 09:20:26AM +0300, Eli Cohen wrote:
> > On Mon, Sep 28, 2020 at 03:55:09PM -0400, Michael S. Tsirkin wrote:
> > > On Thu, Sep 24, 2020 at 05:32:31PM +0300, Eli Cohen wrote:
> > > > Change core vdpa functionality into a loadbale module such that upcoming
> > > > block implementation will be able to use it.
> > > > 
> > > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > 
> > > Why don't we merge this patch together with the block module?
> > > 
> > 
> > Since there are still not too many users of this driver, I would prefer
> > to merge this as early as possible so pepole get used to the involved
> > modules.
> > 
> > Anyways, I will send another version of the patch which makes use of
> > 'select' instead of 'depends'.
> > 
> > Hope you agree to merge this.
> 
> Are you quite sure there will be a block driver though?
> I'd like to avoid a situation in which we have infrastructure
> in place but no users.
>

I know it's in our plans but I see your point. Let me know if you
prefer me to send the patch that fixes the 'depends' thing or defer it
to a later time.

> > > > ---
> > > > V0 --> V1:
> > > > Removed "default n" for configu options as 'n' is the default
> > > > 
> > > >  drivers/vdpa/Kconfig               |  8 +++-----
> > > >  drivers/vdpa/Makefile              |  2 +-
> > > >  drivers/vdpa/mlx5/Makefile         |  7 +++++--
> > > >  drivers/vdpa/mlx5/core/core_main.c | 20 ++++++++++++++++++++
> > > >  drivers/vdpa/mlx5/core/mr.c        |  3 +++
> > > >  drivers/vdpa/mlx5/core/resources.c | 10 ++++++++++
> > > >  6 files changed, 42 insertions(+), 8 deletions(-)
> > > >  create mode 100644 drivers/vdpa/mlx5/core/core_main.c
> > > > 
> > > > diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
> > > > index 4271c408103e..57ff6a7f7401 100644
> > > > --- a/drivers/vdpa/Kconfig
> > > > +++ b/drivers/vdpa/Kconfig
> > > > @@ -29,10 +29,9 @@ config IFCVF
> > > >  	  To compile this driver as a module, choose M here: the module will
> > > >  	  be called ifcvf.
> > > >  
> > > > -config MLX5_VDPA
> > > > -	bool "MLX5 VDPA support library for ConnectX devices"
> > > > +config MLX5_VDPA_CORE
> > > > +	tristate "MLX5 VDPA support library for ConnectX devices"
> > > >  	depends on MLX5_CORE
> > > > -	default n
> > > >  	help
> > > >  	  Support library for Mellanox VDPA drivers. Provides code that is
> > > >  	  common for all types of VDPA drivers. The following drivers are planned:
> > > > @@ -40,8 +39,7 @@ config MLX5_VDPA
> > > >  
> > > >  config MLX5_VDPA_NET
> > > >  	tristate "vDPA driver for ConnectX devices"
> > > > -	depends on MLX5_VDPA
> > > > -	default n
> > > > +	depends on MLX5_VDPA_CORE
> > > >  	help
> > > >  	  VDPA network driver for ConnectX6 and newer. Provides offloading
> > > >  	  of virtio net datapath such that descriptors put on the ring will
> > > > diff --git a/drivers/vdpa/Makefile b/drivers/vdpa/Makefile
> > > > index d160e9b63a66..07353bbb9f8b 100644
> > > > --- a/drivers/vdpa/Makefile
> > > > +++ b/drivers/vdpa/Makefile
> > > > @@ -2,4 +2,4 @@
> > > >  obj-$(CONFIG_VDPA) += vdpa.o
> > > >  obj-$(CONFIG_VDPA_SIM) += vdpa_sim/
> > > >  obj-$(CONFIG_IFCVF)    += ifcvf/
> > > > -obj-$(CONFIG_MLX5_VDPA) += mlx5/
> > > > +obj-$(CONFIG_MLX5_VDPA_CORE) += mlx5/
> > > > diff --git a/drivers/vdpa/mlx5/Makefile b/drivers/vdpa/mlx5/Makefile
> > > > index 89a5bededc9f..9f50f7e8d889 100644
> > > > --- a/drivers/vdpa/mlx5/Makefile
> > > > +++ b/drivers/vdpa/mlx5/Makefile
> > > > @@ -1,4 +1,7 @@
> > > >  subdir-ccflags-y += -I$(srctree)/drivers/vdpa/mlx5/core
> > > >  
> > > > -obj-$(CONFIG_MLX5_VDPA_NET) += mlx5_vdpa.o
> > > > -mlx5_vdpa-$(CONFIG_MLX5_VDPA_NET) += net/main.o net/mlx5_vnet.o core/resources.o core/mr.o
> > > > +obj-$(CONFIG_MLX5_VDPA_CORE) += mlx5_vdpa_core.o
> > > > +mlx5_vdpa_core-$(CONFIG_MLX5_VDPA_CORE) += core/resources.o core/mr.o core/core_main.o
> > > > +
> > > > +obj-$(CONFIG_MLX5_VDPA_NET) += mlx5_vdpa_net.o
> > > > +mlx5_vdpa_net-$(CONFIG_MLX5_VDPA_NET) += net/main.o net/mlx5_vnet.o
> > > > diff --git a/drivers/vdpa/mlx5/core/core_main.c b/drivers/vdpa/mlx5/core/core_main.c
> > > > new file mode 100644
> > > > index 000000000000..4b39b55f57ab
> > > > --- /dev/null
> > > > +++ b/drivers/vdpa/mlx5/core/core_main.c
> > > > @@ -0,0 +1,20 @@
> > > > +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> > > > +/* Copyright (c) 2020 Mellanox Technologies Ltd. */
> > > > +
> > > > +#include <linux/module.h>
> > > > +
> > > > +MODULE_AUTHOR("Eli Cohen <elic@nvidia.com>");
> > > > +MODULE_DESCRIPTION("Mellanox VDPA core driver");
> > > > +MODULE_LICENSE("Dual BSD/GPL");
> > > > +
> > > > +static int __init mlx5_vdpa_core_init(void)
> > > > +{
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static void __exit mlx5_vdpa_core_exit(void)
> > > > +{
> > > > +}
> > > > +
> > > > +module_init(mlx5_vdpa_core_init);
> > > > +module_exit(mlx5_vdpa_core_exit);
> > > > diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
> > > > index ef1c550f8266..c093eab6c714 100644
> > > > --- a/drivers/vdpa/mlx5/core/mr.c
> > > > +++ b/drivers/vdpa/mlx5/core/mr.c
> > > > @@ -434,6 +434,7 @@ int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb)
> > > >  	mutex_unlock(&mr->mkey_mtx);
> > > >  	return err;
> > > >  }
> > > > +EXPORT_SYMBOL(mlx5_vdpa_create_mr);
> > > >  
> > > >  void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev)
> > > >  {
> > > > @@ -456,6 +457,7 @@ void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev)
> > > >  out:
> > > >  	mutex_unlock(&mr->mkey_mtx);
> > > >  }
> > > > +EXPORT_SYMBOL(mlx5_vdpa_destroy_mr);
> > > >  
> > > >  static bool map_empty(struct vhost_iotlb *iotlb)
> > > >  {
> > > > @@ -484,3 +486,4 @@ int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *io
> > > >  
> > > >  	return err;
> > > >  }
> > > > +EXPORT_SYMBOL(mlx5_vdpa_handle_set_map);
> > > > diff --git a/drivers/vdpa/mlx5/core/resources.c b/drivers/vdpa/mlx5/core/resources.c
> > > > index 96e6421c5d1c..89606a18e286 100644
> > > > --- a/drivers/vdpa/mlx5/core/resources.c
> > > > +++ b/drivers/vdpa/mlx5/core/resources.c
> > > > @@ -98,6 +98,7 @@ int mlx5_vdpa_create_tis(struct mlx5_vdpa_dev *mvdev, void *in, u32 *tisn)
> > > >  
> > > >  	return err;
> > > >  }
> > > > +EXPORT_SYMBOL(mlx5_vdpa_create_tis);
> > > >  
> > > >  void mlx5_vdpa_destroy_tis(struct mlx5_vdpa_dev *mvdev, u32 tisn)
> > > >  {
> > > > @@ -108,6 +109,7 @@ void mlx5_vdpa_destroy_tis(struct mlx5_vdpa_dev *mvdev, u32 tisn)
> > > >  	MLX5_SET(destroy_tis_in, in, tisn, tisn);
> > > >  	mlx5_cmd_exec_in(mvdev->mdev, destroy_tis, in);
> > > >  }
> > > > +EXPORT_SYMBOL(mlx5_vdpa_destroy_tis);
> > > >  
> > > >  int mlx5_vdpa_create_rqt(struct mlx5_vdpa_dev *mvdev, void *in, int inlen, u32 *rqtn)
> > > >  {
> > > > @@ -121,6 +123,7 @@ int mlx5_vdpa_create_rqt(struct mlx5_vdpa_dev *mvdev, void *in, int inlen, u32 *
> > > >  
> > > >  	return err;
> > > >  }
> > > > +EXPORT_SYMBOL(mlx5_vdpa_create_rqt);
> > > >  
> > > >  void mlx5_vdpa_destroy_rqt(struct mlx5_vdpa_dev *mvdev, u32 rqtn)
> > > >  {
> > > > @@ -131,6 +134,7 @@ void mlx5_vdpa_destroy_rqt(struct mlx5_vdpa_dev *mvdev, u32 rqtn)
> > > >  	MLX5_SET(destroy_rqt_in, in, rqtn, rqtn);
> > > >  	mlx5_cmd_exec_in(mvdev->mdev, destroy_rqt, in);
> > > >  }
> > > > +EXPORT_SYMBOL(mlx5_vdpa_destroy_rqt);
> > > >  
> > > >  int mlx5_vdpa_create_tir(struct mlx5_vdpa_dev *mvdev, void *in, u32 *tirn)
> > > >  {
> > > > @@ -144,6 +148,7 @@ int mlx5_vdpa_create_tir(struct mlx5_vdpa_dev *mvdev, void *in, u32 *tirn)
> > > >  
> > > >  	return err;
> > > >  }
> > > > +EXPORT_SYMBOL(mlx5_vdpa_create_tir);
> > > >  
> > > >  void mlx5_vdpa_destroy_tir(struct mlx5_vdpa_dev *mvdev, u32 tirn)
> > > >  {
> > > > @@ -154,6 +159,7 @@ void mlx5_vdpa_destroy_tir(struct mlx5_vdpa_dev *mvdev, u32 tirn)
> > > >  	MLX5_SET(destroy_tir_in, in, tirn, tirn);
> > > >  	mlx5_cmd_exec_in(mvdev->mdev, destroy_tir, in);
> > > >  }
> > > > +EXPORT_SYMBOL(mlx5_vdpa_destroy_tir);
> > > >  
> > > >  int mlx5_vdpa_alloc_transport_domain(struct mlx5_vdpa_dev *mvdev, u32 *tdn)
> > > >  {
> > > > @@ -170,6 +176,7 @@ int mlx5_vdpa_alloc_transport_domain(struct mlx5_vdpa_dev *mvdev, u32 *tdn)
> > > >  
> > > >  	return err;
> > > >  }
> > > > +EXPORT_SYMBOL(mlx5_vdpa_alloc_transport_domain);
> > > >  
> > > >  void mlx5_vdpa_dealloc_transport_domain(struct mlx5_vdpa_dev *mvdev, u32 tdn)
> > > >  {
> > > > @@ -180,6 +187,7 @@ void mlx5_vdpa_dealloc_transport_domain(struct mlx5_vdpa_dev *mvdev, u32 tdn)
> > > >  	MLX5_SET(dealloc_transport_domain_in, in, transport_domain, tdn);
> > > >  	mlx5_cmd_exec_in(mvdev->mdev, dealloc_transport_domain, in);
> > > >  }
> > > > +EXPORT_SYMBOL(mlx5_vdpa_dealloc_transport_domain);
> > > >  
> > > >  int mlx5_vdpa_create_mkey(struct mlx5_vdpa_dev *mvdev, struct mlx5_core_mkey *mkey, u32 *in,
> > > >  			  int inlen)
> > > > @@ -266,6 +274,7 @@ int mlx5_vdpa_alloc_resources(struct mlx5_vdpa_dev *mvdev)
> > > >  	mutex_destroy(&mvdev->mr.mkey_mtx);
> > > >  	return err;
> > > >  }
> > > > +EXPORT_SYMBOL(mlx5_vdpa_alloc_resources);
> > > >  
> > > >  void mlx5_vdpa_free_resources(struct mlx5_vdpa_dev *mvdev)
> > > >  {
> > > > @@ -282,3 +291,4 @@ void mlx5_vdpa_free_resources(struct mlx5_vdpa_dev *mvdev)
> > > >  	mutex_destroy(&mvdev->mr.mkey_mtx);
> > > >  	res->valid = false;
> > > >  }
> > > > +EXPORT_SYMBOL(mlx5_vdpa_free_resources);
> > > > -- 
> > > > 2.27.0
> > > 
> 
