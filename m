Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9CD157363
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 12:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbgBJLXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 06:23:48 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47798 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727029AbgBJLXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 06:23:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581333825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IgizTYDV3S5Jm+sWU2R/tJjVdQt8N8M47y+p6iWSyZE=;
        b=gjNmEfFrXVnGfCJum8yaG/Ay01+x2K/Xqo9WxIRS8HOXOm5p/Y7qwZqxFMjy/akhYeiOal
        8+3pV8D3VrqSQFSPT1Po5PQ+6hkC858NaawxlXuypw3/75RIQn7M7qC3KJaLFsindFHNMg
        R8Vh0ha9J49SOCXaJbVmyfG+gEyxEKg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-kuhbSXknOZ-Tzhl_v3YY0w-1; Mon, 10 Feb 2020 06:23:43 -0500
X-MC-Unique: kuhbSXknOZ-Tzhl_v3YY0w-1
Received: by mail-qk1-f197.google.com with SMTP id t186so4541718qkf.9
        for <netdev@vger.kernel.org>; Mon, 10 Feb 2020 03:23:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IgizTYDV3S5Jm+sWU2R/tJjVdQt8N8M47y+p6iWSyZE=;
        b=F+cmcewIE3/ksXklp5HIwstbW9vbHafOBYLlaTMg4V73UE71sDgsZ/aHZ0nXpIORyO
         9GVz3sR1Xm1ZtVxoivBVGxyu5hrd7pEh5CRCiuYieJFlyLtVnffXuCeVIQyhXCb1yVor
         EvvT+swu4JZo91yGpMVG6RTjBqkjtVn+w3+tZiUdsuAfrTNwHCY5mLr4GT/rf4hqTzlW
         BfImGVdmpix3HQxU2Wu0Ker+birFBvpLYI+NvB2GvRf7aPjXquC4l/kIHoW6t1FfeCUc
         x4LZqXpRLs1v0CzEoLb95Pti5Fi1HgHwhK7VFcshK/2lmyJpY/7bazm0Mr+y6pSB8yXt
         WRVQ==
X-Gm-Message-State: APjAAAWOjIgk8mJaaExKH9hRcMZco1yp6hxVYs8zxKzXWPhFKVhI/+lG
        3sVDXV35b8m3xzTMLNMyBGfadTSB9ChtvAckfRsI87zBrDitwnmXGPGFIdz8mM81eXV+V2WFYkd
        IObeijOEl0W1wat+N
X-Received: by 2002:aed:3384:: with SMTP id v4mr9297890qtd.58.1581333822613;
        Mon, 10 Feb 2020 03:23:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqyV16Edfph5i++DCFEv3epE7gagiGJ8v2kdKXXlRlQpYn8U+m1L6wNVWQPf9cM78fqerHab2A==
X-Received: by 2002:aed:3384:: with SMTP id v4mr9297866qtd.58.1581333822118;
        Mon, 10 Feb 2020 03:23:42 -0800 (PST)
Received: from redhat.com (bzq-79-176-41-183.red.bezeqint.net. [79.176.41.183])
        by smtp.gmail.com with ESMTPSA id j196sm3579785qke.102.2020.02.10.03.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 03:23:41 -0800 (PST)
Date:   Mon, 10 Feb 2020 06:23:33 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        tiwei.bie@intel.com, jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, rdunlap@infradead.org,
        hch@infradead.org, aadam@redhat.com, jiri@mellanox.com,
        shahafs@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com
Subject: Re: [PATCH V2 5/5] vdpasim: vDPA device simulator
Message-ID: <20200210062219-mutt-send-email-mst@kernel.org>
References: <20200210035608.10002-1-jasowang@redhat.com>
 <20200210035608.10002-6-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210035608.10002-6-jasowang@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 10, 2020 at 11:56:08AM +0800, Jason Wang wrote:
> This patch implements a software vDPA networking device. The datapath
> is implemented through vringh and workqueue. The device has an on-chip
> IOMMU which translates IOVA to PA. For kernel virtio drivers, vDPA
> simulator driver provides dma_ops. For vhost driers, set_map() methods
> of vdpa_config_ops is implemented to accept mappings from vhost.
> 
> Currently, vDPA device simulator will loopback TX traffic to RX. So
> the main use case for the device is vDPA feature testing, prototyping
> and development.
> 
> Note, there's no management API implemented, a vDPA device will be
> registered once the module is probed. We need to handle this in the
> future development.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/virtio/vdpa/Kconfig    |  17 +
>  drivers/virtio/vdpa/Makefile   |   1 +
>  drivers/virtio/vdpa/vdpa_sim.c | 678 +++++++++++++++++++++++++++++++++
>  3 files changed, 696 insertions(+)
>  create mode 100644 drivers/virtio/vdpa/vdpa_sim.c
> 
> diff --git a/drivers/virtio/vdpa/Kconfig b/drivers/virtio/vdpa/Kconfig
> index 7a99170e6c30..a7888974dda8 100644
> --- a/drivers/virtio/vdpa/Kconfig
> +++ b/drivers/virtio/vdpa/Kconfig
> @@ -7,3 +7,20 @@ config VDPA
>            datapath which complies with virtio specifications with
>            vendor specific control path.
>  
> +menuconfig VDPA_MENU
> +	bool "VDPA drivers"
> +	default n
> +
> +if VDPA_MENU
> +
> +config VDPA_SIM
> +	tristate "vDPA device simulator"
> +        select VDPA
> +        default n
> +        help
> +          vDPA networking device simulator which loop TX traffic back
> +          to RX. This device is used for testing, prototyping and
> +          development of vDPA.

So how about we make this depend on RUNTIME_TESTING_MENU?


> +
> +endif # VDPA_MENU
> +
> diff --git a/drivers/virtio/vdpa/Makefile b/drivers/virtio/vdpa/Makefile
> index ee6a35e8a4fb..5ec0e6ae3c57 100644
> --- a/drivers/virtio/vdpa/Makefile
> +++ b/drivers/virtio/vdpa/Makefile
> @@ -1,2 +1,3 @@
>  # SPDX-License-Identifier: GPL-2.0
>  obj-$(CONFIG_VDPA) += vdpa.o
> +obj-$(CONFIG_VDPA_SIM) += vdpa_sim.o
> diff --git a/drivers/virtio/vdpa/vdpa_sim.c b/drivers/virtio/vdpa/vdpa_sim.c
> new file mode 100644
> index 000000000000..89783a2b9773
> --- /dev/null
> +++ b/drivers/virtio/vdpa/vdpa_sim.c
> @@ -0,0 +1,678 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * VDPA networking device simulator.
> + *
> + * Copyright (c) 2020, Red Hat Inc. All rights reserved.
> + *     Author: Jason Wang <jasowang@redhat.com>
> + *
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/fs.h>
> +#include <linux/poll.h>
> +#include <linux/slab.h>
> +#include <linux/sched.h>
> +#include <linux/wait.h>
> +#include <linux/uuid.h>
> +#include <linux/iommu.h>
> +#include <linux/sysfs.h>
> +#include <linux/file.h>
> +#include <linux/etherdevice.h>
> +#include <linux/vringh.h>
> +#include <linux/vdpa.h>
> +#include <linux/vhost_iotlb.h>
> +#include <uapi/linux/virtio_config.h>
> +#include <uapi/linux/virtio_net.h>
> +
> +#define DRV_VERSION  "0.1"
> +#define DRV_AUTHOR   "Jason Wang <jasowang@redhat.com>"
> +#define DRV_DESC     "vDPA Device Simulator"
> +#define DRV_LICENSE  "GPL v2"
> +
> +struct vdpasim_dev {
> +	struct device	dev;
> +};
> +
> +struct vdpasim_dev *vdpasim_dev;
> +
> +struct vdpasim_virtqueue {
> +	struct vringh vring;
> +	struct vringh_kiov iov;
> +	unsigned short head;
> +	bool ready;
> +	u64 desc_addr;
> +	u64 device_addr;
> +	u64 driver_addr;
> +	u32 num;
> +	void *private;
> +	irqreturn_t (*cb)(void *data);
> +};
> +
> +#define VDPASIM_QUEUE_ALIGN PAGE_SIZE
> +#define VDPASIM_QUEUE_MAX 256
> +#define VDPASIM_DEVICE_ID 0x1
> +#define VDPASIM_VENDOR_ID 0
> +#define VDPASIM_VQ_NUM 0x2
> +#define VDPASIM_NAME "vdpasim-netdev"
> +
> +static u64 vdpasim_features = (1ULL << VIRTIO_F_ANY_LAYOUT) |
> +			      (1ULL << VIRTIO_F_VERSION_1)  |
> +			      (1ULL << VIRTIO_F_IOMMU_PLATFORM);
> +
> +/* State of each vdpasim device */
> +struct vdpasim {
> +	struct vdpasim_virtqueue vqs[2];
> +	struct work_struct work;
> +	/* spinlock to synchronize virtqueue state */
> +	spinlock_t lock;
> +	struct vdpa_device vdpa;
> +	struct virtio_net_config config;
> +	struct vhost_iotlb *iommu;
> +	void *buffer;
> +	u32 status;
> +	u32 generation;
> +	u64 features;
> +};
> +
> +struct vdpasim *vdpa_sim;
> +
> +static struct vdpasim *vdpa_to_sim(struct vdpa_device *vdpa)
> +{
> +	return container_of(vdpa, struct vdpasim, vdpa);
> +}
> +
> +static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
> +{
> +	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
> +	int ret;
> +
> +	ret = vringh_init_iotlb(&vq->vring, vdpasim_features,
> +				VDPASIM_QUEUE_MAX, false,
> +				(struct vring_desc *)(uintptr_t)vq->desc_addr,
> +				(struct vring_avail *)
> +				(uintptr_t)vq->driver_addr,
> +				(struct vring_used *)
> +				(uintptr_t)vq->device_addr);
> +}
> +
> +static void vdpasim_vq_reset(struct vdpasim_virtqueue *vq)
> +{
> +	vq->ready = 0;
> +	vq->desc_addr = 0;
> +	vq->driver_addr = 0;
> +	vq->device_addr = 0;
> +	vq->cb = NULL;
> +	vq->private = NULL;
> +	vringh_init_iotlb(&vq->vring, vdpasim_features, VDPASIM_QUEUE_MAX,
> +			  false, 0, 0, 0);
> +}
> +
> +static void vdpasim_reset(struct vdpasim *vdpasim)
> +{
> +	int i;
> +
> +	for (i = 0; i < VDPASIM_VQ_NUM; i++)
> +		vdpasim_vq_reset(&vdpasim->vqs[i]);
> +
> +	vhost_iotlb_reset(vdpasim->iommu);
> +
> +	vdpasim->features = 0;
> +	vdpasim->status = 0;
> +	++vdpasim->generation;
> +}
> +
> +static void vdpasim_work(struct work_struct *work)
> +{
> +	struct vdpasim *vdpasim = container_of(work, struct
> +						 vdpasim, work);
> +	struct vdpasim_virtqueue *txq = &vdpasim->vqs[1];
> +	struct vdpasim_virtqueue *rxq = &vdpasim->vqs[0];
> +	size_t read, write, total_write;
> +	int err;
> +	int pkts = 0;
> +
> +	spin_lock(&vdpasim->lock);
> +
> +	if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
> +		goto out;
> +
> +	if (!txq->ready || !rxq->ready)
> +		goto out;
> +
> +	while (true) {
> +		total_write = 0;
> +		err = vringh_getdesc_iotlb(&txq->vring, &txq->iov, NULL,
> +					   &txq->head, GFP_ATOMIC);
> +		if (err <= 0)
> +			break;
> +
> +		err = vringh_getdesc_iotlb(&rxq->vring, NULL, &rxq->iov,
> +					   &rxq->head, GFP_ATOMIC);
> +		if (err <= 0) {
> +			vringh_complete_iotlb(&txq->vring, txq->head, 0);
> +			break;
> +		}
> +
> +		while (true) {
> +			read = vringh_iov_pull_iotlb(&txq->vring, &txq->iov,
> +						     vdpasim->buffer,
> +						     PAGE_SIZE);
> +			if (read <= 0)
> +				break;
> +
> +			write = vringh_iov_push_iotlb(&rxq->vring, &rxq->iov,
> +						      vdpasim->buffer, read);
> +			if (write <= 0)
> +				break;
> +
> +			total_write += write;
> +		}
> +
> +		/* Make sure data is wrote before advancing index */
> +		smp_wmb();
> +
> +		vringh_complete_iotlb(&txq->vring, txq->head, 0);
> +		vringh_complete_iotlb(&rxq->vring, rxq->head, total_write);
> +
> +		/* Make sure used is visible before rasing the interrupt. */
> +		smp_wmb();
> +
> +		local_bh_disable();
> +		if (txq->cb)
> +			txq->cb(txq->private);
> +		if (rxq->cb)
> +			rxq->cb(rxq->private);
> +		local_bh_enable();
> +
> +		if (++pkts > 4) {
> +			schedule_work(&vdpasim->work);
> +			goto out;
> +		}
> +	}
> +
> +out:
> +	spin_unlock(&vdpasim->lock);
> +}
> +
> +static int dir_to_perm(enum dma_data_direction dir)
> +{
> +	int perm = -EFAULT;
> +
> +	switch (dir) {
> +	case DMA_FROM_DEVICE:
> +		perm = VHOST_MAP_WO;
> +		break;
> +	case DMA_TO_DEVICE:
> +		perm = VHOST_MAP_RO;
> +		break;
> +	case DMA_BIDIRECTIONAL:
> +		perm = VHOST_MAP_RW;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return perm;
> +}
> +
> +static dma_addr_t vdpasim_map_page(struct device *dev, struct page *page,
> +				   unsigned long offset, size_t size,
> +				   enum dma_data_direction dir,
> +				   unsigned long attrs)
> +{
> +	struct vdpa_device *vdpa = dev_to_vdpa(dev);
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +	struct vhost_iotlb *iommu = vdpasim->iommu;
> +	u64 pa = (page_to_pfn(page) << PAGE_SHIFT) + offset;
> +	int ret, perm = dir_to_perm(dir);
> +
> +	if (perm < 0)
> +		return DMA_MAPPING_ERROR;
> +
> +	/* For simplicity, use identical mapping to avoid e.g iova
> +	 * allocator.
> +	 */
> +	ret = vhost_iotlb_add_range(iommu, pa, pa + size - 1,
> +				    pa, dir_to_perm(dir));
> +	if (ret)
> +		return DMA_MAPPING_ERROR;
> +
> +	return (dma_addr_t)(pa);
> +}
> +
> +static void vdpasim_unmap_page(struct device *dev, dma_addr_t dma_addr,
> +			       size_t size, enum dma_data_direction dir,
> +			       unsigned long attrs)
> +{
> +	struct vdpa_device *vdpa = dev_to_vdpa(dev);
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +	struct vhost_iotlb *iommu = vdpasim->iommu;
> +
> +	vhost_iotlb_del_range(iommu, (u64)dma_addr,
> +			      (u64)dma_addr + size - 1);
> +}
> +
> +static void *vdpasim_alloc_coherent(struct device *dev, size_t size,
> +				    dma_addr_t *dma_addr, gfp_t flag,
> +				    unsigned long attrs)
> +{
> +	struct vdpa_device *vdpa = dev_to_vdpa(dev);
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +	struct vhost_iotlb *iommu = vdpasim->iommu;
> +	void *addr = kmalloc(size, flag);
> +	int ret;
> +
> +	if (!addr)
> +		*dma_addr = DMA_MAPPING_ERROR;
> +	else {
> +		u64 pa = virt_to_phys(addr);
> +
> +		ret = vhost_iotlb_add_range(iommu, (u64)pa,
> +					    (u64)pa + size - 1,
> +					    pa, VHOST_MAP_RW);
> +		if (ret) {
> +			*dma_addr = DMA_MAPPING_ERROR;
> +			kfree(addr);
> +			addr = NULL;
> +		} else
> +			*dma_addr = (dma_addr_t)pa;
> +	}
> +
> +	return addr;
> +}
> +
> +static void vdpasim_free_coherent(struct device *dev, size_t size,
> +				void *vaddr, dma_addr_t dma_addr,
> +				unsigned long attrs)
> +{
> +	struct vdpa_device *vdpa = dev_to_vdpa(dev);
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +	struct vhost_iotlb *iommu = vdpasim->iommu;
> +
> +	vhost_iotlb_del_range(iommu, (u64)dma_addr,
> +			      (u64)dma_addr + size - 1);
> +	kfree(phys_to_virt((uintptr_t)dma_addr));
> +}
> +
> +static const struct dma_map_ops vdpasim_dma_ops = {
> +	.map_page = vdpasim_map_page,
> +	.unmap_page = vdpasim_unmap_page,
> +	.alloc = vdpasim_alloc_coherent,
> +	.free = vdpasim_free_coherent,
> +};
> +
> +static void vdpasim_release_dev(struct device *_d)
> +{
> +	struct vdpa_device *vdpa = dev_to_vdpa(_d);
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +
> +	kfree(vdpasim->buffer);
> +	kfree(vdpasim);
> +}
> +
> +static const struct vdpa_config_ops vdpasim_net_config_ops;
> +
> +static struct vdpasim *vdpasim_create(void)
> +{
> +	struct vdpasim *vdpasim;
> +	struct virtio_net_config *config;
> +	struct vdpa_device *vdpa;
> +	struct device *dev;
> +	int ret = -ENOMEM;
> +
> +	vdpasim = kzalloc(sizeof(*vdpasim), GFP_KERNEL);
> +	if (!vdpasim)
> +		goto err_vdpa_alloc;
> +
> +	vdpasim->buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (!vdpasim->buffer)
> +		goto err_buffer_alloc;
> +
> +	vdpasim->iommu = vhost_iotlb_alloc(2048, 0);
> +	if (!vdpasim->iommu)
> +		goto err_iotlb;
> +
> +	config = &vdpasim->config;
> +	config->mtu = 1500;
> +	config->status = VIRTIO_NET_S_LINK_UP;
> +	eth_random_addr(config->mac);
> +
> +	INIT_WORK(&vdpasim->work, vdpasim_work);
> +	spin_lock_init(&vdpasim->lock);
> +
> +	vdpa = &vdpasim->vdpa;
> +	vdpa->dev.release = vdpasim_release_dev;
> +
> +	vringh_set_iotlb(&vdpasim->vqs[0].vring, vdpasim->iommu);
> +	vringh_set_iotlb(&vdpasim->vqs[1].vring, vdpasim->iommu);
> +
> +	dev = &vdpa->dev;
> +	dev->coherent_dma_mask = DMA_BIT_MASK(64);
> +	set_dma_ops(dev, &vdpasim_dma_ops);
> +
> +	ret = vdpa_init_device(vdpa, &vdpasim_dev->dev, dev,
> +			       &vdpasim_net_config_ops);
> +	if (ret)
> +		goto err_init;
> +
> +	ret = vdpa_register_device(vdpa);
> +	if (ret)
> +		goto err_register;
> +
> +	return vdpasim;
> +
> +err_register:
> +	put_device(&vdpa->dev);
> +err_init:
> +	vhost_iotlb_free(vdpasim->iommu);
> +err_iotlb:
> +	kfree(vdpasim->buffer);
> +err_buffer_alloc:
> +	kfree(vdpasim);
> +err_vdpa_alloc:
> +	return ERR_PTR(ret);
> +}
> +
> +static int vdpasim_set_vq_address(struct vdpa_device *vdpa, u16 idx,
> +				  u64 desc_area, u64 driver_area,
> +				  u64 device_area)
> +{
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
> +
> +	vq->desc_addr = desc_area;
> +	vq->driver_addr = driver_area;
> +	vq->device_addr = device_area;
> +
> +	return 0;
> +}
> +
> +static void vdpasim_set_vq_num(struct vdpa_device *vdpa, u16 idx, u32 num)
> +{
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
> +
> +	vq->num = num;
> +}
> +
> +static void vdpasim_kick_vq(struct vdpa_device *vdpa, u16 idx)
> +{
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
> +
> +	if (vq->ready)
> +		schedule_work(&vdpasim->work);
> +}
> +
> +static void vdpasim_set_vq_cb(struct vdpa_device *vdpa, u16 idx,
> +			      struct vdpa_callback *cb)
> +{
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
> +
> +	vq->cb = cb->callback;
> +	vq->private = cb->private;
> +}
> +
> +static void vdpasim_set_vq_ready(struct vdpa_device *vdpa, u16 idx, bool ready)
> +{
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
> +
> +	spin_lock(&vdpasim->lock);
> +	vq->ready = ready;
> +	if (vq->ready)
> +		vdpasim_queue_ready(vdpasim, idx);
> +	spin_unlock(&vdpasim->lock);
> +}
> +
> +static bool vdpasim_get_vq_ready(struct vdpa_device *vdpa, u16 idx)
> +{
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
> +
> +	return vq->ready;
> +}
> +
> +static int vdpasim_set_vq_state(struct vdpa_device *vdpa, u16 idx, u64 state)
> +{
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
> +	struct vringh *vrh = &vq->vring;
> +
> +	spin_lock(&vdpasim->lock);
> +	vrh->last_avail_idx = state;
> +	spin_unlock(&vdpasim->lock);
> +
> +	return 0;
> +}
> +
> +static u64 vdpasim_get_vq_state(struct vdpa_device *vdpa, u16 idx)
> +{
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
> +	struct vringh *vrh = &vq->vring;
> +
> +	return vrh->last_avail_idx;
> +}
> +
> +static u16 vdpasim_get_vq_align(struct vdpa_device *vdpa)
> +{
> +	return VDPASIM_QUEUE_ALIGN;
> +}
> +
> +static u64 vdpasim_get_features(struct vdpa_device *vdpa)
> +{
> +	return vdpasim_features;
> +}
> +
> +static int vdpasim_set_features(struct vdpa_device *vdpa, u64 features)
> +{
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +
> +	/* DMA mapping must be done by driver */
> +	if (!(features & (1ULL << VIRTIO_F_IOMMU_PLATFORM)))
> +		return -EINVAL;
> +
> +	vdpasim->features = features & vdpasim_features;
> +
> +	return 0;
> +}
> +
> +static void vdpasim_set_config_cb(struct vdpa_device *vdpa,
> +				  struct vdpa_callback *cb)
> +{
> +	/* We don't support config interrupt */
> +}
> +
> +static u16 vdpasim_get_vq_num_max(struct vdpa_device *vdpa)
> +{
> +	return VDPASIM_QUEUE_MAX;
> +}
> +
> +static u32 vdpasim_get_device_id(struct vdpa_device *vdpa)
> +{
> +	return VDPASIM_DEVICE_ID;
> +}
> +
> +static u32 vdpasim_get_vendor_id(struct vdpa_device *vdpa)
> +{
> +	return VDPASIM_VENDOR_ID;
> +}
> +
> +static u8 vdpasim_get_status(struct vdpa_device *vdpa)
> +{
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +	u8 status;
> +
> +	spin_lock(&vdpasim->lock);
> +	status = vdpasim->status;
> +	spin_unlock(&vdpasim->lock);
> +
> +	return vdpasim->status;
> +}
> +
> +static void vdpasim_set_status(struct vdpa_device *vdpa, u8 status)
> +{
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +
> +	spin_lock(&vdpasim->lock);
> +	vdpasim->status = status;
> +	if (status == 0)
> +		vdpasim_reset(vdpasim);
> +	spin_unlock(&vdpasim->lock);
> +}
> +
> +static void vdpasim_get_config(struct vdpa_device *vdpa, unsigned int offset,
> +			     void *buf, unsigned int len)
> +{
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +
> +	if (offset + len < sizeof(struct virtio_net_config))
> +		memcpy(buf, &vdpasim->config + offset, len);
> +}
> +
> +static void vdpasim_set_config(struct vdpa_device *vdpa, unsigned int offset,
> +			     const void *buf, unsigned int len)
> +{
> +	/* No writable config supportted by vdpasim */
> +}
> +
> +static u32 vdpasim_get_generation(struct vdpa_device *vdpa)
> +{
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +
> +	return vdpasim->generation;
> +}
> +
> +static int vdpasim_set_map(struct vdpa_device *vdpa,
> +			   struct vhost_iotlb *iotlb)
> +{
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +	struct vhost_iotlb_map *map;
> +	u64 start = 0ULL, last = 0ULL - 1;
> +	int ret;
> +
> +	vhost_iotlb_reset(vdpasim->iommu);
> +
> +	for (map = vhost_iotlb_itree_first(iotlb, start, last); map;
> +	     map = vhost_iotlb_itree_next(map, start, last)) {
> +		ret = vhost_iotlb_add_range(vdpasim->iommu, map->start,
> +					    map->last, map->addr, map->perm);
> +		if (ret)
> +			goto err;
> +	}
> +	return 0;
> +
> +err:
> +	vhost_iotlb_reset(vdpasim->iommu);
> +	return ret;
> +}
> +
> +static int vdpasim_dma_map(struct vdpa_device *vdpa, u64 iova, u64 size,
> +			   u64 pa, u32 perm)
> +{
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +
> +	return vhost_iotlb_add_range(vdpasim->iommu, iova,
> +				     iova + size - 1, pa, perm);
> +}
> +
> +static int vdpasim_dma_unmap(struct vdpa_device *vdpa, u64 iova, u64 size)
> +{
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +
> +	vhost_iotlb_del_range(vdpasim->iommu, iova, iova + size - 1);
> +
> +	return 0;
> +}
> +
> +static const struct vdpa_config_ops vdpasim_net_config_ops = {
> +	.set_vq_address         = vdpasim_set_vq_address,
> +	.set_vq_num             = vdpasim_set_vq_num,
> +	.kick_vq                = vdpasim_kick_vq,
> +	.set_vq_cb              = vdpasim_set_vq_cb,
> +	.set_vq_ready           = vdpasim_set_vq_ready,
> +	.get_vq_ready           = vdpasim_get_vq_ready,
> +	.set_vq_state           = vdpasim_set_vq_state,
> +	.get_vq_state           = vdpasim_get_vq_state,
> +	.get_vq_align           = vdpasim_get_vq_align,
> +	.get_features           = vdpasim_get_features,
> +	.set_features           = vdpasim_set_features,
> +	.set_config_cb          = vdpasim_set_config_cb,
> +	.get_vq_num_max         = vdpasim_get_vq_num_max,
> +	.get_device_id          = vdpasim_get_device_id,
> +	.get_vendor_id          = vdpasim_get_vendor_id,
> +	.get_status             = vdpasim_get_status,
> +	.set_status             = vdpasim_set_status,
> +	.get_config             = vdpasim_get_config,
> +	.set_config             = vdpasim_set_config,
> +	.get_generation         = vdpasim_get_generation,
> +	.set_map                = vdpasim_set_map,
> +	.dma_map                = vdpasim_dma_map,
> +	.dma_unmap              = vdpasim_dma_unmap,
> +};
> +
> +static void vdpasim_device_release(struct device *dev)
> +{
> +	struct vdpasim_dev *vdpasim_dev =
> +	       container_of(dev, struct vdpasim_dev, dev);
> +
> +	vdpasim_dev->dev.bus = NULL;
> +	kfree(vdpasim_dev);
> +}
> +
> +static int __init vdpasim_dev_init(void)
> +{
> +	struct device *dev;
> +	int ret = 0;
> +
> +	vdpasim_dev = kzalloc(sizeof(*vdpasim_dev), GFP_KERNEL);
> +	if (!vdpasim_dev)
> +		return -ENOMEM;
> +
> +	dev = &vdpasim_dev->dev;
> +	dev->release = vdpasim_device_release;
> +	dev_set_name(dev, "%s", VDPASIM_NAME);
> +
> +	ret = device_register(&vdpasim_dev->dev);
> +	if (ret)
> +		goto err_register;
> +
> +	if (!vdpasim_create())
> +		goto err_register;
> +
> +	return 0;
> +
> +err_register:
> +	kfree(vdpasim_dev);
> +	vdpasim_dev = NULL;
> +	return ret;
> +}
> +
> +static int vdpasim_device_remove_cb(struct device *dev, void *data)
> +{
> +	struct vdpa_device *vdpa = dev_to_vdpa(dev);
> +
> +	vdpa_unregister_device(vdpa);
> +
> +	return 0;
> +}
> +
> +static void __exit vdpasim_dev_exit(void)
> +{
> +	device_for_each_child(&vdpasim_dev->dev, NULL,
> +			      vdpasim_device_remove_cb);
> +	device_unregister(&vdpasim_dev->dev);
> +}
> +
> +module_init(vdpasim_dev_init)
> +module_exit(vdpasim_dev_exit)
> +
> +MODULE_VERSION(DRV_VERSION);
> +MODULE_LICENSE(DRV_LICENSE);
> +MODULE_AUTHOR(DRV_AUTHOR);
> +MODULE_DESCRIPTION(DRV_DESC);
> -- 
> 2.19.1

