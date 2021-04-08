Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAC4357D22
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 09:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhDHHSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 03:18:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27935 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229517AbhDHHSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 03:18:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617866313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WLo5y26tyNpXazJT3ZncllY/pNeQOYtG29MP51ipiH8=;
        b=OMG6chr4W2fRA+3sCWdVc/RUcTE76dpZT6+UXk8vv6gi9sIC8EFpcNJ8zvbSWo/+Tqtw4k
        pQAfmQfrokaKkSdJCP9Nq2FShgMh1AUx4IdILB/H5UI6VYq5bw5smCyV95sMxlLYSsZIjW
        2ZGPzPN0h9EpoKymr25U38Cz7KXU4B4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-nJ3WjYThN7OR_z1Zo7TU_Q-1; Thu, 08 Apr 2021 03:18:30 -0400
X-MC-Unique: nJ3WjYThN7OR_z1Zo7TU_Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C85A10053E8;
        Thu,  8 Apr 2021 07:18:27 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-78.pek2.redhat.com [10.72.12.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A22F760C5D;
        Thu,  8 Apr 2021 07:18:12 +0000 (UTC)
Subject: Re: [PATCH v6 10/10] Documentation: Add documentation for VDUSE
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20210331080519.172-1-xieyongji@bytedance.com>
 <20210331080519.172-11-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b3d97ee2-5c8c-2568-20ab-7e9ce51c4e72@redhat.com>
Date:   Thu, 8 Apr 2021 15:18:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210331080519.172-11-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/31 ÏÂÎç4:05, Xie Yongji Ð´µÀ:
> VDUSE (vDPA Device in Userspace) is a framework to support
> implementing software-emulated vDPA devices in userspace. This
> document is intended to clarify the VDUSE design and usage.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   Documentation/userspace-api/index.rst |   1 +
>   Documentation/userspace-api/vduse.rst | 212 ++++++++++++++++++++++++++++++++++
>   2 files changed, 213 insertions(+)
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
> index 000000000000..8c4e2b2df8bb
> --- /dev/null
> +++ b/Documentation/userspace-api/vduse.rst
> @@ -0,0 +1,212 @@
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
> +		resp.request_id = req.request_id;
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
> +In the data path, vDPA device's iova regions will be mapped into userspace
> +with the help of VDUSE_IOTLB_GET_FD ioctl on the VDUSE device file:
> +
> +- VDUSE_IOTLB_GET_FD: get the file descriptor to the first overlapped iova region.
> +  Userspace can access this iova region by passing fd and corresponding size, offset,
> +  perm to mmap(). For example:
> +
> +.. code-block:: c
> +
> +	static int perm_to_prot(uint8_t perm)
> +	{
> +		int prot = 0;
> +
> +		switch (perm) {
> +		case VDUSE_ACCESS_WO:
> +			prot |= PROT_WRITE;
> +			break;
> +		case VDUSE_ACCESS_RO:
> +			prot |= PROT_READ;
> +			break;
> +		case VDUSE_ACCESS_RW:
> +			prot |= PROT_READ | PROT_WRITE;
> +			break;
> +		}
> +
> +		return prot;
> +	}
> +
> +	static void *iova_to_va(int dev_fd, uint64_t iova, uint64_t *len)
> +	{
> +		int fd;
> +		void *addr;
> +		size_t size;
> +		struct vduse_iotlb_entry entry;
> +
> +		entry.start = iova;
> +		entry.last = iova + 1;
> +		fd = ioctl(dev_fd, VDUSE_IOTLB_GET_FD, &entry);
> +		if (fd < 0)
> +			return NULL;
> +
> +		size = entry.last - entry.start + 1;
> +		*len = entry.last - iova + 1;
> +		addr = mmap(0, size, perm_to_prot(entry.perm), MAP_SHARED,
> +			    fd, entry.offset);
> +		close(fd);
> +		if (addr == MAP_FAILED)
> +			return NULL;
> +
> +		/* do something to cache this iova region */
> +
> +		return addr + iova - entry.start;
> +	}
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
> +Register VDUSE device on vDPA bus
> +---------------------------------
> +In order to make the VDUSE device work, administrator needs to use the management
> +API (netlink) to register it on vDPA bus. Some sample codes are show below:
> +
> +.. code-block:: c
> +
> +	static int netlink_add_vduse(const char *name, int device_id)
> +	{
> +		struct nl_sock *nlsock;
> +		struct nl_msg *msg;
> +		int famid;
> +
> +		nlsock = nl_socket_alloc();
> +		if (!nlsock)
> +			return -ENOMEM;
> +
> +		if (genl_connect(nlsock))
> +			goto free_sock;
> +
> +		famid = genl_ctrl_resolve(nlsock, VDPA_GENL_NAME);
> +		if (famid < 0)
> +			goto close_sock;
> +
> +		msg = nlmsg_alloc();
> +		if (!msg)
> +			goto close_sock;
> +
> +		if (!genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, famid, 0, 0,
> +		    VDPA_CMD_DEV_NEW, 0))
> +			goto nla_put_failure;
> +
> +		NLA_PUT_STRING(msg, VDPA_ATTR_DEV_NAME, name);
> +		NLA_PUT_STRING(msg, VDPA_ATTR_MGMTDEV_DEV_NAME, "vduse");
> +		NLA_PUT_U32(msg, VDPA_ATTR_DEV_ID, device_id);
> +
> +		if (nl_send_sync(nlsock, msg))
> +			goto close_sock;
> +
> +		nl_close(nlsock);
> +		nl_socket_free(nlsock);
> +
> +		return 0;
> +	nla_put_failure:
> +		nlmsg_free(msg);
> +	close_sock:
> +		nl_close(nlsock);
> +	free_sock:
> +		nl_socket_free(nlsock);
> +		return -1;
> +	}


Let's also explain this can be done via vdpa tool in iproute2 as well.

Otherwise

Acked-by: Jason Wang <jasowang@redhat.com>


> +
> +MMU-based IOMMU Driver
> +----------------------
> +VDUSE framework implements an MMU-based on-chip IOMMU driver to support
> +mapping the kernel DMA buffer into the userspace iova region dynamically.
> +This is mainly designed for virtio-vdpa case (kernel virtio drivers).
> +
> +The basic idea behind this driver is treating MMU (VA->PA) as IOMMU (IOVA->PA).
> +The driver will set up MMU mapping instead of IOMMU mapping for the DMA transfer
> +so that the userspace process is able to use its virtual address to access
> +the DMA buffer in kernel.
> +
> +And to avoid security issue, a bounce-buffering mechanism is introduced to
> +prevent userspace accessing the original buffer directly which may contain other
> +kernel data. During the mapping, unmapping, the driver will copy the data from
> +the original buffer to the bounce buffer and back, depending on the direction of
> +the transfer. And the bounce-buffer addresses will be mapped into the user address
> +space instead of the original one.

