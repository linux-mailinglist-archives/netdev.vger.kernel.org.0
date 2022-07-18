Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE2E578D8F
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 00:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235151AbiGRWae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 18:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235145AbiGRWad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 18:30:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0FD02C665
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 15:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658183428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p8Vxu+b5s/s3tU4vedn2DVYFIE/kRvk2G8tl0G6Dmow=;
        b=ecaeXY2JK87CGOifT5aZfWH9ULAZksVYS6rCGt2cj1OurxSkgZF9+WkCN1sK3pCZ8BDk+J
        J/jYd49g2lwBCXAmkfsBkfIAQZNv2bpCTlcj9qQttITFbxahqmJc4X4Edn+r4NsdMsq0iC
        RP3NTRGWTb6KmR4NixLAIeYBHsanjao=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-319-DPwwXdYuPnGB-0KuqXfPzw-1; Mon, 18 Jul 2022 18:30:27 -0400
X-MC-Unique: DPwwXdYuPnGB-0KuqXfPzw-1
Received: by mail-il1-f200.google.com with SMTP id g8-20020a92cda8000000b002dcbd57f808so6894018ild.4
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 15:30:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=p8Vxu+b5s/s3tU4vedn2DVYFIE/kRvk2G8tl0G6Dmow=;
        b=aYo2j0BAoxPN9HG091MyN3p8JgCe1xGCQfdRltwVADZlv+2KzH05CIB0phbBRvLtkR
         htk73hTFpnuGe7K9XHOazrqAbrHY5deXvZ88/RSzb+zSg9b2qAZtkQHgndjBvNHP9O9J
         17K1naT1t6iG/lX5OKhuByi5H8Fba2jx1MgKo74x71LnTNDASwS8HIB9YZ9FeKHI9JjD
         GdsBpqMCp8aGzXZvOro0D4wVt/dob3x/6BlA87zXMhUV5tqJK+m0j1LKlBWVXgiels0m
         nFr/8GB8ksgxjS+fRqGtrAXUNQ6rRkxuMvQZCVdvAZtYa5E7gbcBKS4tzrYK9B4PnEpp
         OL4A==
X-Gm-Message-State: AJIora9FnZVzM9f+8CMGC3XaqQ0xQpYh6+fJzkkPdypiXrkuujj/KWH4
        11zC4oNZaGdiqps8LQHRKH9/+ndXiffoyBwLwwPIBDDgrdFE9a3+TOJ3+Fnb7xneh6GVybbBj9v
        HIjv6yxpguDtu3YP3
X-Received: by 2002:a02:8504:0:b0:33f:1342:719d with SMTP id g4-20020a028504000000b0033f1342719dmr15459655jai.64.1658183427057;
        Mon, 18 Jul 2022 15:30:27 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vtGH01kAdeHTIJRzYxRZU9aOii0gxerLom+B+Z4RlZ1NtODkxPk1VPw7L2jDHskLuCOb+itw==
X-Received: by 2002:a02:8504:0:b0:33f:1342:719d with SMTP id g4-20020a028504000000b0033f1342719dmr15459644jai.64.1658183426789;
        Mon, 18 Jul 2022 15:30:26 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e44-20020a02212c000000b0033f25da5228sm5999880jaa.93.2022.07.18.15.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 15:30:26 -0700 (PDT)
Date:   Mon, 18 Jul 2022 16:30:24 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>
Subject: Re: [PATCH V2 vfio 06/11] vfio: Introduce the DMA logging feature
 support
Message-ID: <20220718163024.143ec05a.alex.williamson@redhat.com>
In-Reply-To: <20220714081251.240584-7-yishaih@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
        <20220714081251.240584-7-yishaih@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jul 2022 11:12:46 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> Introduce the DMA logging feature support in the vfio core layer.
> 
> It includes the processing of the device start/stop/report DMA logging
> UAPIs and calling the relevant driver 'op' to do the work.
> 
> Specifically,
> Upon start, the core translates the given input ranges into an interval
> tree, checks for unexpected overlapping, non aligned ranges and then
> pass the translated input to the driver for start tracking the given
> ranges.
> 
> Upon report, the core translates the given input user space bitmap and
> page size into an IOVA kernel bitmap iterator. Then it iterates it and
> call the driver to set the corresponding bits for the dirtied pages in a
> specific IOVA range.
> 
> Upon stop, the driver is called to stop the previous started tracking.
> 
> The next patches from the series will introduce the mlx5 driver
> implementation for the logging ops.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/Kconfig             |   1 +
>  drivers/vfio/pci/vfio_pci_core.c |   5 +
>  drivers/vfio/vfio_main.c         | 161 +++++++++++++++++++++++++++++++
>  include/linux/vfio.h             |  21 +++-
>  4 files changed, 186 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 6130d00252ed..86c381ceb9a1 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -3,6 +3,7 @@ menuconfig VFIO
>  	tristate "VFIO Non-Privileged userspace driver framework"
>  	select IOMMU_API
>  	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
> +	select INTERVAL_TREE
>  	help
>  	  VFIO provides a framework for secure userspace device drivers.
>  	  See Documentation/driver-api/vfio.rst for more details.
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 2efa06b1fafa..b6dabf398251 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1862,6 +1862,11 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>  			return -EINVAL;
>  	}
>  
> +	if (vdev->vdev.log_ops && !(vdev->vdev.log_ops->log_start &&
> +	    vdev->vdev.log_ops->log_stop &&
> +	    vdev->vdev.log_ops->log_read_and_clear))
> +		return -EINVAL;
> +
>  	/*
>  	 * Prevent binding to PFs with VFs enabled, the VFs might be in use
>  	 * by the host or other users.  We cannot capture the VFs if they
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index bd84ca7c5e35..2414d827e3c8 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -32,6 +32,8 @@
>  #include <linux/vfio.h>
>  #include <linux/wait.h>
>  #include <linux/sched/signal.h>
> +#include <linux/interval_tree.h>
> +#include <linux/iova_bitmap.h>
>  #include "vfio.h"
>  
>  #define DRIVER_VERSION	"0.3"
> @@ -1603,6 +1605,153 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
>  	return 0;
>  }
>  
> +#define LOG_MAX_RANGES 1024
> +
> +static int
> +vfio_ioctl_device_feature_logging_start(struct vfio_device *device,
> +					u32 flags, void __user *arg,
> +					size_t argsz)
> +{
> +	size_t minsz =
> +		offsetofend(struct vfio_device_feature_dma_logging_control,
> +			    ranges);
> +	struct vfio_device_feature_dma_logging_range __user *ranges;
> +	struct vfio_device_feature_dma_logging_control control;
> +	struct vfio_device_feature_dma_logging_range range;
> +	struct rb_root_cached root = RB_ROOT_CACHED;
> +	struct interval_tree_node *nodes;
> +	u32 nnodes;
> +	int i, ret;
> +
> +	if (!device->log_ops)
> +		return -ENOTTY;
> +
> +	ret = vfio_check_feature(flags, argsz,
> +				 VFIO_DEVICE_FEATURE_SET,
> +				 sizeof(control));
> +	if (ret != 1)
> +		return ret;
> +
> +	if (copy_from_user(&control, arg, minsz))
> +		return -EFAULT;
> +
> +	nnodes = control.num_ranges;
> +	if (!nnodes || nnodes > LOG_MAX_RANGES)
> +		return -EINVAL;

The latter looks more like an -E2BIG errno.  This is a hard coded
limit, but what are the heuristics?  Can a user introspect the limit?
Thanks,

Alex

> +
> +	ranges = u64_to_user_ptr(control.ranges);
> +	nodes = kmalloc_array(nnodes, sizeof(struct interval_tree_node),
> +			      GFP_KERNEL);
> +	if (!nodes)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < nnodes; i++) {
> +		if (copy_from_user(&range, &ranges[i], sizeof(range))) {
> +			ret = -EFAULT;
> +			goto end;
> +		}
> +		if (!IS_ALIGNED(range.iova, control.page_size) ||
> +		    !IS_ALIGNED(range.length, control.page_size)) {
> +			ret = -EINVAL;
> +			goto end;
> +		}
> +		nodes[i].start = range.iova;
> +		nodes[i].last = range.iova + range.length - 1;
> +		if (interval_tree_iter_first(&root, nodes[i].start,
> +					     nodes[i].last)) {
> +			/* Range overlapping */
> +			ret = -EINVAL;
> +			goto end;
> +		}
> +		interval_tree_insert(nodes + i, &root);
> +	}
> +
> +	ret = device->log_ops->log_start(device, &root, nnodes,
> +					 &control.page_size);
> +	if (ret)
> +		goto end;
> +
> +	if (copy_to_user(arg, &control, sizeof(control))) {
> +		ret = -EFAULT;
> +		device->log_ops->log_stop(device);
> +	}
> +
> +end:
> +	kfree(nodes);
> +	return ret;
> +}
> +
> +static int
> +vfio_ioctl_device_feature_logging_stop(struct vfio_device *device,
> +				       u32 flags, void __user *arg,
> +				       size_t argsz)
> +{
> +	int ret;
> +
> +	if (!device->log_ops)
> +		return -ENOTTY;
> +
> +	ret = vfio_check_feature(flags, argsz,
> +				 VFIO_DEVICE_FEATURE_SET, 0);
> +	if (ret != 1)
> +		return ret;
> +
> +	return device->log_ops->log_stop(device);
> +}
> +
> +static int
> +vfio_ioctl_device_feature_logging_report(struct vfio_device *device,
> +					 u32 flags, void __user *arg,
> +					 size_t argsz)
> +{
> +	size_t minsz =
> +		offsetofend(struct vfio_device_feature_dma_logging_report,
> +			    bitmap);
> +	struct vfio_device_feature_dma_logging_report report;
> +	struct iova_bitmap_iter iter;
> +	int ret;
> +
> +	if (!device->log_ops)
> +		return -ENOTTY;
> +
> +	ret = vfio_check_feature(flags, argsz,
> +				 VFIO_DEVICE_FEATURE_GET,
> +				 sizeof(report));
> +	if (ret != 1)
> +		return ret;
> +
> +	if (copy_from_user(&report, arg, minsz))
> +		return -EFAULT;
> +
> +	if (report.page_size < PAGE_SIZE)
> +		return -EINVAL;
> +
> +	iova_bitmap_init(&iter.dirty, report.iova, ilog2(report.page_size));
> +	ret = iova_bitmap_iter_init(&iter, report.iova, report.length,
> +				    u64_to_user_ptr(report.bitmap));
> +	if (ret)
> +		return ret;
> +
> +	for (; !iova_bitmap_iter_done(&iter);
> +	     iova_bitmap_iter_advance(&iter)) {
> +		ret = iova_bitmap_iter_get(&iter);
> +		if (ret)
> +			break;
> +
> +		ret = device->log_ops->log_read_and_clear(device,
> +			iova_bitmap_iova(&iter),
> +			iova_bitmap_length(&iter), &iter.dirty);
> +
> +		iova_bitmap_iter_put(&iter);
> +
> +		if (ret)
> +			break;
> +	}
> +
> +	iova_bitmap_iter_free(&iter);
> +	return ret;
> +}
> +
>  static int vfio_ioctl_device_feature(struct vfio_device *device,
>  				     struct vfio_device_feature __user *arg)
>  {
> @@ -1636,6 +1785,18 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
>  		return vfio_ioctl_device_feature_mig_device_state(
>  			device, feature.flags, arg->data,
>  			feature.argsz - minsz);
> +	case VFIO_DEVICE_FEATURE_DMA_LOGGING_START:
> +		return vfio_ioctl_device_feature_logging_start(
> +			device, feature.flags, arg->data,
> +			feature.argsz - minsz);
> +	case VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP:
> +		return vfio_ioctl_device_feature_logging_stop(
> +			device, feature.flags, arg->data,
> +			feature.argsz - minsz);
> +	case VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT:
> +		return vfio_ioctl_device_feature_logging_report(
> +			device, feature.flags, arg->data,
> +			feature.argsz - minsz);
>  	default:
>  		if (unlikely(!device->ops->device_feature))
>  			return -EINVAL;
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 4d26e149db81..feed84d686ec 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -14,6 +14,7 @@
>  #include <linux/workqueue.h>
>  #include <linux/poll.h>
>  #include <uapi/linux/vfio.h>
> +#include <linux/iova_bitmap.h>
>  
>  struct kvm;
>  
> @@ -33,10 +34,11 @@ struct vfio_device {
>  	struct device *dev;
>  	const struct vfio_device_ops *ops;
>  	/*
> -	 * mig_ops is a static property of the vfio_device which must be set
> -	 * prior to registering the vfio_device.
> +	 * mig_ops/log_ops is a static property of the vfio_device which must
> +	 * be set prior to registering the vfio_device.
>  	 */
>  	const struct vfio_migration_ops *mig_ops;
> +	const struct vfio_log_ops *log_ops;
>  	struct vfio_group *group;
>  	struct vfio_device_set *dev_set;
>  	struct list_head dev_set_list;
> @@ -104,6 +106,21 @@ struct vfio_migration_ops {
>  				   enum vfio_device_mig_state *curr_state);
>  };
>  
> +/**
> + * @log_start: Optional callback to ask the device start DMA logging.
> + * @log_stop: Optional callback to ask the device stop DMA logging.
> + * @log_read_and_clear: Optional callback to ask the device read
> + *         and clear the dirty DMAs in some given range.
> + */
> +struct vfio_log_ops {
> +	int (*log_start)(struct vfio_device *device,
> +		struct rb_root_cached *ranges, u32 nnodes, u64 *page_size);
> +	int (*log_stop)(struct vfio_device *device);
> +	int (*log_read_and_clear)(struct vfio_device *device,
> +		unsigned long iova, unsigned long length,
> +		struct iova_bitmap *dirty);
> +};
> +
>  /**
>   * vfio_check_feature - Validate user input for the VFIO_DEVICE_FEATURE ioctl
>   * @flags: Arg from the device_feature op

