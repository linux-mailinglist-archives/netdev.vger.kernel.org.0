Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B297B57A733
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 21:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238511AbiGSTZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 15:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238260AbiGSTZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 15:25:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F4EC1116E
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 12:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658258719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=01nIMAqu9kXKBUZerezX8Ft5zuAeFvv5UsalBlZ7zoI=;
        b=hL0mNNVoGhCVo3Th32A1du12WRgDIdXahL14IbDdY1PkSfjPkCfISfOJuoIEvEtEBU3Ako
        rMXZJy1EaXJPnde2vb5gHFOB1tULPpdW5uDX26IhymU3nZcJk9L6fLy6DcyM5FAYau/2RI
        lwQjSihicoJAYWQL4IaeCjwpdE4KQ8o=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-_b872QoaML6tZM9fZpn2fQ-1; Tue, 19 Jul 2022 15:25:17 -0400
X-MC-Unique: _b872QoaML6tZM9fZpn2fQ-1
Received: by mail-il1-f199.google.com with SMTP id i8-20020a056e020d8800b002d931252904so10015519ilj.23
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 12:25:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=01nIMAqu9kXKBUZerezX8Ft5zuAeFvv5UsalBlZ7zoI=;
        b=IQ5Vc1n40/am4WkrKuP1MPnNjJdQBY9B9PVrsnDRfdbiQXh2J1uC27Bs+JfCURzx+U
         yRfFZ6zjOtkNXE6bztsVbIibCvfTQb39SaWqX/ZVJe1ymEYLio+jp5I2tBRQKlj4lLnN
         6jbbYZUGr5tS3DLDq77illwEihrsh44K01lZEz/OV4++AXVNJykwZDJEnho7U7nPbhGV
         awHP+Nxsi3XLkRer+BOg4nECa0nPNNQokLNb0L2UzO+XXSNoYb3onBZfMUVw9o5Pd8AK
         Ee5TqiGGo2yOv0H4Sj+yK6byaqgdl7HvSCYoxeitRXa7VrOIFkWmDZnIzSodMlRPddKT
         vKlQ==
X-Gm-Message-State: AJIora+ifTNBI2y+Ga7z14xUOQmriK8ixIC1s0UKzczJgNDahvc1l8Yn
        duIbDDHGi6PsNRYVz9yGhd+tYj4eDywfoBDFnU+6B4Mv4MaDAHkK00jF1llyFbfTIb0KxxyiAY3
        zgq/z8X35pBEjcgaR
X-Received: by 2002:a05:6e02:1c88:b0:2dc:d092:9721 with SMTP id w8-20020a056e021c8800b002dcd0929721mr9150725ill.118.1658258716777;
        Tue, 19 Jul 2022 12:25:16 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tZOG+3tB+aCvTVCSR7lYMcpDeYWLonIVl6Pt4opkh9VdDb7o0N1f6aAdQJVuSsAqXhIfjkZw==
X-Received: by 2002:a05:6e02:1c88:b0:2dc:d092:9721 with SMTP id w8-20020a056e021c8800b002dcd0929721mr9150708ill.118.1658258716470;
        Tue, 19 Jul 2022 12:25:16 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id k21-20020a02a715000000b00333fa7a642asm6997536jam.63.2022.07.19.12.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 12:25:16 -0700 (PDT)
Date:   Tue, 19 Jul 2022 13:25:14 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>
Subject: Re: [PATCH V2 vfio 06/11] vfio: Introduce the DMA logging feature
 support
Message-ID: <20220719132514.7d21dfaf.alex.williamson@redhat.com>
In-Reply-To: <8242cd07-0b65-e2b8-3797-3fe5623ec65d@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
        <20220714081251.240584-7-yishaih@nvidia.com>
        <20220718163024.143ec05a.alex.williamson@redhat.com>
        <8242cd07-0b65-e2b8-3797-3fe5623ec65d@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jul 2022 12:19:25 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 19/07/2022 1:30, Alex Williamson wrote:
> > On Thu, 14 Jul 2022 11:12:46 +0300
> > Yishai Hadas <yishaih@nvidia.com> wrote:
> >  
> >> Introduce the DMA logging feature support in the vfio core layer.
> >>
> >> It includes the processing of the device start/stop/report DMA logging
> >> UAPIs and calling the relevant driver 'op' to do the work.
> >>
> >> Specifically,
> >> Upon start, the core translates the given input ranges into an interval
> >> tree, checks for unexpected overlapping, non aligned ranges and then
> >> pass the translated input to the driver for start tracking the given
> >> ranges.
> >>
> >> Upon report, the core translates the given input user space bitmap and
> >> page size into an IOVA kernel bitmap iterator. Then it iterates it and
> >> call the driver to set the corresponding bits for the dirtied pages in a
> >> specific IOVA range.
> >>
> >> Upon stop, the driver is called to stop the previous started tracking.
> >>
> >> The next patches from the series will introduce the mlx5 driver
> >> implementation for the logging ops.
> >>
> >> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> >> ---
> >>   drivers/vfio/Kconfig             |   1 +
> >>   drivers/vfio/pci/vfio_pci_core.c |   5 +
> >>   drivers/vfio/vfio_main.c         | 161 +++++++++++++++++++++++++++++++
> >>   include/linux/vfio.h             |  21 +++-
> >>   4 files changed, 186 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> >> index 6130d00252ed..86c381ceb9a1 100644
> >> --- a/drivers/vfio/Kconfig
> >> +++ b/drivers/vfio/Kconfig
> >> @@ -3,6 +3,7 @@ menuconfig VFIO
> >>   	tristate "VFIO Non-Privileged userspace driver framework"
> >>   	select IOMMU_API
> >>   	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
> >> +	select INTERVAL_TREE
> >>   	help
> >>   	  VFIO provides a framework for secure userspace device drivers.
> >>   	  See Documentation/driver-api/vfio.rst for more details.
> >> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> >> index 2efa06b1fafa..b6dabf398251 100644
> >> --- a/drivers/vfio/pci/vfio_pci_core.c
> >> +++ b/drivers/vfio/pci/vfio_pci_core.c
> >> @@ -1862,6 +1862,11 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
> >>   			return -EINVAL;
> >>   	}
> >>   
> >> +	if (vdev->vdev.log_ops && !(vdev->vdev.log_ops->log_start &&
> >> +	    vdev->vdev.log_ops->log_stop &&
> >> +	    vdev->vdev.log_ops->log_read_and_clear))
> >> +		return -EINVAL;
> >> +
> >>   	/*
> >>   	 * Prevent binding to PFs with VFs enabled, the VFs might be in use
> >>   	 * by the host or other users.  We cannot capture the VFs if they
> >> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> >> index bd84ca7c5e35..2414d827e3c8 100644
> >> --- a/drivers/vfio/vfio_main.c
> >> +++ b/drivers/vfio/vfio_main.c
> >> @@ -32,6 +32,8 @@
> >>   #include <linux/vfio.h>
> >>   #include <linux/wait.h>
> >>   #include <linux/sched/signal.h>
> >> +#include <linux/interval_tree.h>
> >> +#include <linux/iova_bitmap.h>
> >>   #include "vfio.h"
> >>   
> >>   #define DRIVER_VERSION	"0.3"
> >> @@ -1603,6 +1605,153 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
> >>   	return 0;
> >>   }
> >>   
> >> +#define LOG_MAX_RANGES 1024
> >> +
> >> +static int
> >> +vfio_ioctl_device_feature_logging_start(struct vfio_device *device,
> >> +					u32 flags, void __user *arg,
> >> +					size_t argsz)
> >> +{
> >> +	size_t minsz =
> >> +		offsetofend(struct vfio_device_feature_dma_logging_control,
> >> +			    ranges);
> >> +	struct vfio_device_feature_dma_logging_range __user *ranges;
> >> +	struct vfio_device_feature_dma_logging_control control;
> >> +	struct vfio_device_feature_dma_logging_range range;
> >> +	struct rb_root_cached root = RB_ROOT_CACHED;
> >> +	struct interval_tree_node *nodes;
> >> +	u32 nnodes;
> >> +	int i, ret;
> >> +
> >> +	if (!device->log_ops)
> >> +		return -ENOTTY;
> >> +
> >> +	ret = vfio_check_feature(flags, argsz,
> >> +				 VFIO_DEVICE_FEATURE_SET,
> >> +				 sizeof(control));
> >> +	if (ret != 1)
> >> +		return ret;
> >> +
> >> +	if (copy_from_user(&control, arg, minsz))
> >> +		return -EFAULT;
> >> +
> >> +	nnodes = control.num_ranges;
> >> +	if (!nnodes || nnodes > LOG_MAX_RANGES)
> >> +		return -EINVAL;  
> > The latter looks more like an -E2BIG errno.  
> 
> OK
> 
> > This is a hard coded
> > limit, but what are the heuristics?  Can a user introspect the limit?
> > Thanks,
> >
> > Alex  
> 
> This hard coded value just comes to prevent user space from exploding 
> kernel memory allocation.

Of course.

> We don't really expect user space to hit this limit, the RAM in QEMU is 
> divided today to around ~12 ranges as we saw so far in our evaluation.

There can be far more for vIOMMU use cases or non-QEMU drivers.

> We may also expect user space to combine contiguous ranges to a single 
> range or in the worst case even to combine non contiguous ranges to a 
> single range.

Why do we expect that from users?
 
> We can consider moving this hard-coded value to be part of the UAPI 
> header, although, not sure that this is really a must.
> 
> What do you think ?

We're looking at a very narrow use case with implicit assumptions about
the behavior of the user driver.  Some of those assumptions need to be
exposed via the uAPI so that userspace can make reasonable choices.
Thanks,

Alex

> >> +
> >> +	ranges = u64_to_user_ptr(control.ranges);
> >> +	nodes = kmalloc_array(nnodes, sizeof(struct interval_tree_node),
> >> +			      GFP_KERNEL);
> >> +	if (!nodes)
> >> +		return -ENOMEM;
> >> +
> >> +	for (i = 0; i < nnodes; i++) {
> >> +		if (copy_from_user(&range, &ranges[i], sizeof(range))) {
> >> +			ret = -EFAULT;
> >> +			goto end;
> >> +		}
> >> +		if (!IS_ALIGNED(range.iova, control.page_size) ||
> >> +		    !IS_ALIGNED(range.length, control.page_size)) {
> >> +			ret = -EINVAL;
> >> +			goto end;
> >> +		}
> >> +		nodes[i].start = range.iova;
> >> +		nodes[i].last = range.iova + range.length - 1;
> >> +		if (interval_tree_iter_first(&root, nodes[i].start,
> >> +					     nodes[i].last)) {
> >> +			/* Range overlapping */
> >> +			ret = -EINVAL;
> >> +			goto end;
> >> +		}
> >> +		interval_tree_insert(nodes + i, &root);
> >> +	}
> >> +
> >> +	ret = device->log_ops->log_start(device, &root, nnodes,
> >> +					 &control.page_size);
> >> +	if (ret)
> >> +		goto end;
> >> +
> >> +	if (copy_to_user(arg, &control, sizeof(control))) {
> >> +		ret = -EFAULT;
> >> +		device->log_ops->log_stop(device);
> >> +	}
> >> +
> >> +end:
> >> +	kfree(nodes);
> >> +	return ret;
> >> +}
> >> +
> >> +static int
> >> +vfio_ioctl_device_feature_logging_stop(struct vfio_device *device,
> >> +				       u32 flags, void __user *arg,
> >> +				       size_t argsz)
> >> +{
> >> +	int ret;
> >> +
> >> +	if (!device->log_ops)
> >> +		return -ENOTTY;
> >> +
> >> +	ret = vfio_check_feature(flags, argsz,
> >> +				 VFIO_DEVICE_FEATURE_SET, 0);
> >> +	if (ret != 1)
> >> +		return ret;
> >> +
> >> +	return device->log_ops->log_stop(device);
> >> +}
> >> +
> >> +static int
> >> +vfio_ioctl_device_feature_logging_report(struct vfio_device *device,
> >> +					 u32 flags, void __user *arg,
> >> +					 size_t argsz)
> >> +{
> >> +	size_t minsz =
> >> +		offsetofend(struct vfio_device_feature_dma_logging_report,
> >> +			    bitmap);
> >> +	struct vfio_device_feature_dma_logging_report report;
> >> +	struct iova_bitmap_iter iter;
> >> +	int ret;
> >> +
> >> +	if (!device->log_ops)
> >> +		return -ENOTTY;
> >> +
> >> +	ret = vfio_check_feature(flags, argsz,
> >> +				 VFIO_DEVICE_FEATURE_GET,
> >> +				 sizeof(report));
> >> +	if (ret != 1)
> >> +		return ret;
> >> +
> >> +	if (copy_from_user(&report, arg, minsz))
> >> +		return -EFAULT;
> >> +
> >> +	if (report.page_size < PAGE_SIZE)
> >> +		return -EINVAL;
> >> +
> >> +	iova_bitmap_init(&iter.dirty, report.iova, ilog2(report.page_size));
> >> +	ret = iova_bitmap_iter_init(&iter, report.iova, report.length,
> >> +				    u64_to_user_ptr(report.bitmap));
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	for (; !iova_bitmap_iter_done(&iter);
> >> +	     iova_bitmap_iter_advance(&iter)) {
> >> +		ret = iova_bitmap_iter_get(&iter);
> >> +		if (ret)
> >> +			break;
> >> +
> >> +		ret = device->log_ops->log_read_and_clear(device,
> >> +			iova_bitmap_iova(&iter),
> >> +			iova_bitmap_length(&iter), &iter.dirty);
> >> +
> >> +		iova_bitmap_iter_put(&iter);
> >> +
> >> +		if (ret)
> >> +			break;
> >> +	}
> >> +
> >> +	iova_bitmap_iter_free(&iter);
> >> +	return ret;
> >> +}
> >> +
> >>   static int vfio_ioctl_device_feature(struct vfio_device *device,
> >>   				     struct vfio_device_feature __user *arg)
> >>   {
> >> @@ -1636,6 +1785,18 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
> >>   		return vfio_ioctl_device_feature_mig_device_state(
> >>   			device, feature.flags, arg->data,
> >>   			feature.argsz - minsz);
> >> +	case VFIO_DEVICE_FEATURE_DMA_LOGGING_START:
> >> +		return vfio_ioctl_device_feature_logging_start(
> >> +			device, feature.flags, arg->data,
> >> +			feature.argsz - minsz);
> >> +	case VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP:
> >> +		return vfio_ioctl_device_feature_logging_stop(
> >> +			device, feature.flags, arg->data,
> >> +			feature.argsz - minsz);
> >> +	case VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT:
> >> +		return vfio_ioctl_device_feature_logging_report(
> >> +			device, feature.flags, arg->data,
> >> +			feature.argsz - minsz);
> >>   	default:
> >>   		if (unlikely(!device->ops->device_feature))
> >>   			return -EINVAL;
> >> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> >> index 4d26e149db81..feed84d686ec 100644
> >> --- a/include/linux/vfio.h
> >> +++ b/include/linux/vfio.h
> >> @@ -14,6 +14,7 @@
> >>   #include <linux/workqueue.h>
> >>   #include <linux/poll.h>
> >>   #include <uapi/linux/vfio.h>
> >> +#include <linux/iova_bitmap.h>
> >>   
> >>   struct kvm;
> >>   
> >> @@ -33,10 +34,11 @@ struct vfio_device {
> >>   	struct device *dev;
> >>   	const struct vfio_device_ops *ops;
> >>   	/*
> >> -	 * mig_ops is a static property of the vfio_device which must be set
> >> -	 * prior to registering the vfio_device.
> >> +	 * mig_ops/log_ops is a static property of the vfio_device which must
> >> +	 * be set prior to registering the vfio_device.
> >>   	 */
> >>   	const struct vfio_migration_ops *mig_ops;
> >> +	const struct vfio_log_ops *log_ops;
> >>   	struct vfio_group *group;
> >>   	struct vfio_device_set *dev_set;
> >>   	struct list_head dev_set_list;
> >> @@ -104,6 +106,21 @@ struct vfio_migration_ops {
> >>   				   enum vfio_device_mig_state *curr_state);
> >>   };
> >>   
> >> +/**
> >> + * @log_start: Optional callback to ask the device start DMA logging.
> >> + * @log_stop: Optional callback to ask the device stop DMA logging.
> >> + * @log_read_and_clear: Optional callback to ask the device read
> >> + *         and clear the dirty DMAs in some given range.
> >> + */
> >> +struct vfio_log_ops {
> >> +	int (*log_start)(struct vfio_device *device,
> >> +		struct rb_root_cached *ranges, u32 nnodes, u64 *page_size);
> >> +	int (*log_stop)(struct vfio_device *device);
> >> +	int (*log_read_and_clear)(struct vfio_device *device,
> >> +		unsigned long iova, unsigned long length,
> >> +		struct iova_bitmap *dirty);
> >> +};
> >> +
> >>   /**
> >>    * vfio_check_feature - Validate user input for the VFIO_DEVICE_FEATURE ioctl
> >>    * @flags: Arg from the device_feature op  
> 
> 

