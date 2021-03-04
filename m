Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B691A32CD03
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 07:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235497AbhCDGmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 01:42:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50351 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235522AbhCDGle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 01:41:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614840009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mhc8+IYGUbK4OnkoVwRYTHNFwVq12BuILz0iHs1E/Uo=;
        b=YnTOt/rkccfkC5xhxe0ZuXQBgwN/dGozzo5t10dls3H2x/ZW3hh5uE2qygmzsmOsHUj2o7
        avMAhTkM65e8eab2SOBjCw0cdMgTl+2AXGKwRVNOWOReUK1Q6uBS35rw6R3tfx4R79bzE3
        gfuhW+wB2/rbfVqLVigR78T0pqMPrxY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-M0FYuybqNzCq9i68Eos2Cw-1; Thu, 04 Mar 2021 01:40:05 -0500
X-MC-Unique: M0FYuybqNzCq9i68Eos2Cw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81669100CC8B;
        Thu,  4 Mar 2021 06:40:02 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-113.pek2.redhat.com [10.72.12.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B93D65C1C2;
        Thu,  4 Mar 2021 06:39:50 +0000 (UTC)
Subject: Re: [RFC v4 09/11] Documentation: Add documentation for VDUSE
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        bob.liu@oracle.com, hch@infradead.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210223115048.435-1-xieyongji@bytedance.com>
 <20210223115048.435-10-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <366f2dcf-51ab-4d66-9c94-517349ef0bdd@redhat.com>
Date:   Thu, 4 Mar 2021 14:39:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210223115048.435-10-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/23 7:50 下午, Xie Yongji wrote:
> VDUSE (vDPA Device in Userspace) is a framework to support
> implementing software-emulated vDPA devices in userspace. This
> document is intended to clarify the VDUSE design and usage.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   Documentation/userspace-api/index.rst |   1 +
>   Documentation/userspace-api/vduse.rst | 112 ++++++++++++++++++++++++++++++++++
>   2 files changed, 113 insertions(+)
>   create mode 100644 Documentation/userspace-api/vduse.rst
>
> diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
> index acd2cc2a538d..f63119130898 100644
> --- a/Documentation/userspace-api/index.rst
> +++ b/Documentation/userspace-api/index.rst
> @@ -24,6 +24,7 @@ place where this information is gathered.
>      ioctl/index
>      iommu
>      media/index
> +   vduse
>   
>   .. only::  subproject and html
>   
> diff --git a/Documentation/userspace-api/vduse.rst b/Documentation/userspace-api/vduse.rst
> new file mode 100644
> index 000000000000..2a20e686bb59
> --- /dev/null
> +++ b/Documentation/userspace-api/vduse.rst
> @@ -0,0 +1,112 @@
> +==================================
> +VDUSE - "vDPA Device in Userspace"
> +==================================
> +
> +vDPA (virtio data path acceleration) device is a device that uses a
> +datapath which complies with the virtio specifications with vendor
> +specific control path. vDPA devices can be both physically located on
> +the hardware or emulated by software. VDUSE is a framework that makes it
> +possible to implement software-emulated vDPA devices in userspace.
> +
> +How VDUSE works
> +------------
> +Each userspace vDPA device is created by the VDUSE_CREATE_DEV ioctl on
> +the character device (/dev/vduse/control). Then a device file with the
> +specified name (/dev/vduse/$NAME) will appear, which can be used to
> +implement the userspace vDPA device's control path and data path.


It's better to mention that in order to le thte device to be registered 
on the bus, admin need to use the management API(netlink) to create the 
vDPA device.

Some codes to demnonstrate how to create the device will be better.


> +
> +To implement control path, a message-based communication protocol and some
> +types of control messages are introduced in the VDUSE framework:
> +
> +- VDUSE_SET_VQ_ADDR: Set the vring address of virtqueue.
> +
> +- VDUSE_SET_VQ_NUM: Set the size of virtqueue
> +
> +- VDUSE_SET_VQ_READY: Set ready status of virtqueue
> +
> +- VDUSE_GET_VQ_READY: Get ready status of virtqueue
> +
> +- VDUSE_SET_VQ_STATE: Set the state for virtqueue
> +
> +- VDUSE_GET_VQ_STATE: Get the state for virtqueue
> +
> +- VDUSE_SET_FEATURES: Set virtio features supported by the driver
> +
> +- VDUSE_GET_FEATURES: Get virtio features supported by the device
> +
> +- VDUSE_SET_STATUS: Set the device status
> +
> +- VDUSE_GET_STATUS: Get the device status
> +
> +- VDUSE_SET_CONFIG: Write to device specific configuration space
> +
> +- VDUSE_GET_CONFIG: Read from device specific configuration space
> +
> +- VDUSE_UPDATE_IOTLB: Notify userspace to update the memory mapping in device IOTLB
> +
> +Those control messages are mostly based on the vdpa_config_ops in
> +include/linux/vdpa.h which defines a unified interface to control
> +different types of vdpa device. Userspace needs to read()/write()
> +on the VDUSE device file to receive/reply those control messages
> +from/to VDUSE kernel module as follows:
> +
> +.. code-block:: c
> +
> +	static int vduse_message_handler(int dev_fd)
> +	{
> +		int len;
> +		struct vduse_dev_request req;
> +		struct vduse_dev_response resp;
> +
> +		len = read(dev_fd, &req, sizeof(req));
> +		if (len != sizeof(req))
> +			return -1;
> +
> +		resp.request_id = req.unique;
> +
> +		switch (req.type) {
> +
> +		/* handle different types of message */
> +
> +		}
> +
> +		len = write(dev_fd, &resp, sizeof(resp));
> +		if (len != sizeof(resp))
> +			return -1;
> +
> +		return 0;
> +	}
> +
> +In the deta path, vDPA device's iova regions will be mapped into userspace
> +with the help of VDUSE_IOTLB_GET_FD ioctl on the VDUSE device file:
> +
> +- VDUSE_IOTLB_GET_FD: get the file descriptor to iova region. Userspace can
> +  access this iova region by passing the fd to mmap().


It would be better to have codes to explain how it is expected to work here.


> +
> +Besides, the following ioctls on the VDUSE device file are provided to support
> +interrupt injection and setting up eventfd for virtqueue kicks:
> +
> +- VDUSE_VQ_SETUP_KICKFD: set the kickfd for virtqueue, this eventfd is used
> +  by VDUSE kernel module to notify userspace to consume the vring.
> +
> +- VDUSE_INJECT_VQ_IRQ: inject an interrupt for specific virtqueue
> +
> +- VDUSE_INJECT_CONFIG_IRQ: inject a config interrupt
> +
> +MMU-based IOMMU Driver
> +----------------------
> +In virtio-vdpa case, VDUSE framework implements an MMU-based on-chip IOMMU
> +driver to support mapping the kernel DMA buffer into the userspace iova
> +region dynamically.
> +
> +The basic idea behind this driver is treating MMU (VA->PA) as IOMMU (IOVA->PA).
> +The driver will set up MMU mapping instead of IOMMU mapping for the DMA transfer
> +so that the userspace process is able to use its virtual address to access
> +the DMA buffer in kernel.
> +
> +And to avoid security issue, a bounce-buffering mechanism is introduced to
> +prevent userspace accessing the original buffer directly which may contain other
> +kernel data.


It's worth to mention this is designed for virtio-vdpa (kernel virtio 
drivers).

Thanks


>   During the mapping, unmapping, the driver will copy the data from
> +the original buffer to the bounce buffer and back, depending on the direction of
> +the transfer. And the bounce-buffer addresses will be mapped into the user address
> +space instead of the original one.

