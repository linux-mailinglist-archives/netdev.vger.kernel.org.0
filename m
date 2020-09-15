Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6537E26A088
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 10:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgIOITp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 04:19:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53694 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726361AbgIOITK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 04:19:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600157947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3bhDFHrLKx2Ugr++K3UZXsMiyEdJCQXQW25owbTuEPc=;
        b=EcDpTG1arSWhyuAHQuyBdv0+Q+G1IMK5Z9AboLCn8j8AvfH5MaYqnwnnMurdsejbSCnQ/6
        /wsZAo5+CfMSvEU+a/7RBKuQvAYDS0KMi+0gDUjWZa4soXd1IFIi6TIY76br98cPMruJ33
        gkDNNv812WTxRAcnkDSq3fSNCwOmP9o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-zNagHMNCPB-SgFEqX8TqPw-1; Tue, 15 Sep 2020 04:19:03 -0400
X-MC-Unique: zNagHMNCPB-SgFEqX8TqPw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53E0480F040;
        Tue, 15 Sep 2020 08:19:01 +0000 (UTC)
Received: from [10.72.13.94] (ovpn-13-94.pek2.redhat.com [10.72.13.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A9D55DDB8;
        Tue, 15 Sep 2020 08:18:47 +0000 (UTC)
Subject: Re: [RFC PATCH 00/22] Enhance VHOST to enable SoC-to-SoC
 communication
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-ntb@googlegroups.com,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20200702082143.25259-1-kishon@ti.com>
 <20200702055026-mutt-send-email-mst@kernel.org>
 <603970f5-3289-cd53-82a9-aa62b292c552@redhat.com>
 <14c6cad7-9361-7fa4-e1c6-715ccc7e5f6b@ti.com>
 <59fd6a0b-8566-44b7-3dae-bb52b468219b@redhat.com>
 <ce9eb6a5-cd3a-a390-5684-525827b30f64@ti.com>
 <da2b671c-b05d-a57f-7bdf-8b1043a41240@redhat.com>
 <fee8a0fb-f862-03bd-5ede-8f105b6af529@ti.com>
 <b2178e1d-2f5c-e8a3-72fb-70f2f8d6aa45@redhat.com>
 <45a8a97c-2061-13ee-5da8-9877a4a3b8aa@ti.com>
 <c8739d7f-e12e-f6a2-7018-9eeaf6feb054@redhat.com>
 <20200828123409.4cd2a812.cohuck@redhat.com>
 <ac8f7e4f-9f46-919a-f5c2-89b07794f0ab@ti.com>
 <9cd58cd1-0041-3d98-baf7-6e5bc2e7e317@redhat.com>
 <edf25301-93c0-4ba6-aa85-5f04137d0906@ti.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5733dbfc-76c1-45dc-6dce-ef5449eacc73@redhat.com>
Date:   Tue, 15 Sep 2020 16:18:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <edf25301-93c0-4ba6-aa85-5f04137d0906@ti.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kishon:

On 2020/9/14 下午3:23, Kishon Vijay Abraham I wrote:
>> Then you need something that is functional equivalent to virtio PCI
>> which is actually the concept of vDPA (e.g vDPA provides alternatives if
>> the queue_sel is hard in the EP implementation).
> Okay, I just tried to compare the 'struct vdpa_config_ops' and 'struct
> vhost_config_ops' ( introduced in [RFC PATCH 03/22] vhost: Add ops for
> the VHOST driver to configure VHOST device).
>
> struct vdpa_config_ops {
> 	/* Virtqueue ops */
> 	int (*set_vq_address)(struct vdpa_device *vdev,
> 			      u16 idx, u64 desc_area, u64 driver_area,
> 			      u64 device_area);
> 	void (*set_vq_num)(struct vdpa_device *vdev, u16 idx, u32 num);
> 	void (*kick_vq)(struct vdpa_device *vdev, u16 idx);
> 	void (*set_vq_cb)(struct vdpa_device *vdev, u16 idx,
> 			  struct vdpa_callback *cb);
> 	void (*set_vq_ready)(struct vdpa_device *vdev, u16 idx, bool ready);
> 	bool (*get_vq_ready)(struct vdpa_device *vdev, u16 idx);
> 	int (*set_vq_state)(struct vdpa_device *vdev, u16 idx,
> 			    const struct vdpa_vq_state *state);
> 	int (*get_vq_state)(struct vdpa_device *vdev, u16 idx,
> 			    struct vdpa_vq_state *state);
> 	struct vdpa_notification_area
> 	(*get_vq_notification)(struct vdpa_device *vdev, u16 idx);
> 	/* vq irq is not expected to be changed once DRIVER_OK is set */
> 	int (*get_vq_irq)(struct vdpa_device *vdv, u16 idx);
>
> 	/* Device ops */
> 	u32 (*get_vq_align)(struct vdpa_device *vdev);
> 	u64 (*get_features)(struct vdpa_device *vdev);
> 	int (*set_features)(struct vdpa_device *vdev, u64 features);
> 	void (*set_config_cb)(struct vdpa_device *vdev,
> 			      struct vdpa_callback *cb);
> 	u16 (*get_vq_num_max)(struct vdpa_device *vdev);
> 	u32 (*get_device_id)(struct vdpa_device *vdev);
> 	u32 (*get_vendor_id)(struct vdpa_device *vdev);
> 	u8 (*get_status)(struct vdpa_device *vdev);
> 	void (*set_status)(struct vdpa_device *vdev, u8 status);
> 	void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
> 			   void *buf, unsigned int len);
> 	void (*set_config)(struct vdpa_device *vdev, unsigned int offset,
> 			   const void *buf, unsigned int len);
> 	u32 (*get_generation)(struct vdpa_device *vdev);
>
> 	/* DMA ops */
> 	int (*set_map)(struct vdpa_device *vdev, struct vhost_iotlb *iotlb);
> 	int (*dma_map)(struct vdpa_device *vdev, u64 iova, u64 size,
> 		       u64 pa, u32 perm);
> 	int (*dma_unmap)(struct vdpa_device *vdev, u64 iova, u64 size);
>
> 	/* Free device resources */
> 	void (*free)(struct vdpa_device *vdev);
> };
>
> +struct vhost_config_ops {
> +	int (*create_vqs)(struct vhost_dev *vdev, unsigned int nvqs,
> +			  unsigned int num_bufs, struct vhost_virtqueue *vqs[],
> +			  vhost_vq_callback_t *callbacks[],
> +			  const char * const names[]);
> +	void (*del_vqs)(struct vhost_dev *vdev);
> +	int (*write)(struct vhost_dev *vdev, u64 vhost_dst, void *src, int len);
> +	int (*read)(struct vhost_dev *vdev, void *dst, u64 vhost_src, int len);
> +	int (*set_features)(struct vhost_dev *vdev, u64 device_features);
> +	int (*set_status)(struct vhost_dev *vdev, u8 status);
> +	u8 (*get_status)(struct vhost_dev *vdev);
> +};
> +
> struct virtio_config_ops
> I think there's some overlap here and some of the ops tries to do the
> same thing.
>
> I think it differs in (*set_vq_address)() and (*create_vqs)().
> [create_vqs() introduced in struct vhost_config_ops provides
> complimentary functionality to (*find_vqs)() in struct
> virtio_config_ops. It seemingly encapsulates the functionality of
> (*set_vq_address)(), (*set_vq_num)(), (*set_vq_cb)(),..].
>
> Back to the difference between (*set_vq_address)() and (*create_vqs)(),
> set_vq_address() directly provides the virtqueue address to the vdpa
> device but create_vqs() only provides the parameters of the virtqueue
> (like the number of virtqueues, number of buffers) but does not directly
> provide the address. IMO the backend client drivers (like net or vhost)
> shouldn't/cannot by itself know how to access the vring created on
> virtio front-end. The vdpa device/vhost device should have logic for
> that. That will help the client drivers to work with different types of
> vdpa device/vhost device and can access the vring created by virtio
> irrespective of whether the vring can be accessed via mmio or kernel
> space or user space.
>
> I think vdpa always works with client drivers in userspace and providing
> userspace address for vring.


Sorry for being unclear. What I meant is not replacing vDPA with the 
vhost(bus) you proposed but the possibility of replacing virtio-pci-epf 
with vDPA in:

My question is basically for the part of virtio_pci_epf_send_command(), 
so it looks to me you have a vendor specific API to replace the 
virtio-pci layout of the BAR:


+static int virtio_pci_epf_send_command(struct virtio_pci_device *vp_dev,
+                       u32 command)
+{
+    struct virtio_pci_epf *pci_epf;
+    void __iomem *ioaddr;
+    ktime_t timeout;
+    bool timedout;
+    int ret = 0;
+    u8 status;
+
+    pci_epf = to_virtio_pci_epf(vp_dev);
+    ioaddr = vp_dev->ioaddr;
+
+    mutex_lock(&pci_epf->lock);
+    writeb(command, ioaddr + HOST_CMD);
+    timeout = ktime_add_ms(ktime_get(), COMMAND_TIMEOUT);
+    while (1) {
+        timedout = ktime_after(ktime_get(), timeout);
+        status = readb(ioaddr + HOST_CMD_STATUS);
+

Several questions:

- It's not clear to me how the synchronization is done between the RC 
and EP. E.g how and when the value of HOST_CMD_STATUS can be changed.  
If you still want to introduce a new transport, a virtio spec patch 
would be helpful for us to understand the device API.
- You have you vendor specific layout (according to 
virtio_pci_epb_table()), so I guess you it's better to have a vendor 
specific vDPA driver instead
- The advantage of vendor specific vDPA driver is that it can 1) have 
less codes 2) support userspace drivers through vhost-vDPA (instead of 
inventing new APIs since we can't use vfio-pci here).


>>> "Virtio Over NTB" should anyways be a new transport.
>>>> Does that make any sense?
>>> yeah, in the approach I used the initial features are hard-coded in
>>> vhost-rpmsg (inherent to the rpmsg) but when we have to use adapter
>>> layer (vhost only for accessing virtio ring and use virtio drivers on
>>> both front end and backend), based on the functionality (e.g, rpmsg),
>>> the vhost should be configured with features (to be presented to the
>>> virtio) and that's why additional layer or APIs will be required.
>> A question here, if we go with vhost bus approach, does it mean the
>> virtio device can only be implemented in EP's userspace?
> The vhost bus approach doesn't provide any restriction in where the
> virto backend device should be created. This series creates two types of
> virtio backend device (one for PCIe endpoint and the other for NTB) and
> both these devices are created in kernel.


Ok.

Thanks


>
> Thanks
> Kishon
>

