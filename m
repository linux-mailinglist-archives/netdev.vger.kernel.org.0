Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD324D10FF
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 08:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244345AbiCHH36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 02:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243190AbiCHH34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 02:29:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 964DC33E37
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 23:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646724537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ztihaAlc182OY1fZeHkkwRaEj5VUIs+DTdjcjAgLSk=;
        b=CpT16pYx7sVf0aUVyQsn3i4AzCqlnsYCmuVej5v9y0OFXsz8Uy1GK1v8j1o9nScgk76HUe
        SnafWKXE1PsQnrrm7j+ej3HGdTNybK2D6zbq5XEHx61m2ffa0w6HL/it0jeMp1VfpiTY9x
        uWeuu5sySTGNdfkSMjuW+P+bsVxZsQc=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-eC8hXw--PMSry9GnRL4WXg-1; Tue, 08 Mar 2022 02:28:54 -0500
X-MC-Unique: eC8hXw--PMSry9GnRL4WXg-1
Received: by mail-pj1-f69.google.com with SMTP id y1-20020a17090a644100b001bc901aba0dso7615153pjm.8
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 23:28:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6ztihaAlc182OY1fZeHkkwRaEj5VUIs+DTdjcjAgLSk=;
        b=QZ6sZB9bT057TpC+Iyk1M1m5JqJjPfwYxTu2EkdOO+fm1YQCa8KPZorSq7/22OugWQ
         zUORIZmnh59Ji4sgIove6ifdq/JOyv5Ua/vMGGMaaA0QaeAeq55+x+0unu5nRo23UBPl
         Ud1Z8LzF7xNk/4cwUFRmoxo44yQhms5Bl2dwrtQBcXnupFXBH1mB7sUgiDxL7ZmYQdbd
         HgSh/MpPm4zYJmPG+KUrqRiV0puFL5v5d2ek9N5fjnmRth4rlrEGl3lx26UBO7PEaALK
         4JwoKoOSo33yw0clrJ/SM9ZG0LSAw4NdkP6DK1jFLaRPXH2dkJ6RPZxUtMSAOyNVXedB
         XrmQ==
X-Gm-Message-State: AOAM532a4eKqwCQr5O5zRTqxGWxT9HrdS+ziK9i25looOOxBG3hFCAEa
        zoZbwPjKKL0n/yum3UPFT2oVdvzoV4Uaf67DewHoaTpyeixuzVE5WBsMQGP12lhs79ArBacq2zl
        X1KZwbdzohl5IW17v
X-Received: by 2002:a63:5a5c:0:b0:378:73b1:e1d8 with SMTP id k28-20020a635a5c000000b0037873b1e1d8mr13018907pgm.364.1646724533793;
        Mon, 07 Mar 2022 23:28:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwCUyzra0ttoBcB8VkDz4+CWP5e4H7VU1NxfWT6AIZG0k832QCn774gcMfF9dm/7wb5trfu5Q==
X-Received: by 2002:a63:5a5c:0:b0:378:73b1:e1d8 with SMTP id k28-20020a635a5c000000b0037873b1e1d8mr13018893pgm.364.1646724533473;
        Mon, 07 Mar 2022 23:28:53 -0800 (PST)
Received: from [10.72.13.77] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y16-20020a056a00191000b004e155b2623bsm19224048pfi.178.2022.03.07.23.28.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 23:28:52 -0800 (PST)
Message-ID: <91910574-d3f7-6a75-57cf-06a5fcb29be8@redhat.com>
Date:   Tue, 8 Mar 2022 15:28:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v6 06/26] virtio_ring: packed: extrace the logic of
 creating vring
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
References: <20220224081102.80224-1-xuanzhuo@linux.alibaba.com>
 <20220224081102.80224-7-xuanzhuo@linux.alibaba.com>
 <20220307171629-mutt-send-email-mst@kernel.org>
 <1646722885.3801584-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <1646722885.3801584-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/3/8 下午3:01, Xuan Zhuo 写道:
> On Mon, 7 Mar 2022 17:17:51 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
>> On Thu, Feb 24, 2022 at 04:10:42PM +0800, Xuan Zhuo wrote:
>>> Separate the logic of packed to create vring queue.
>>>
>>> For the convenience of passing parameters, add a structure
>>> vring_packed.
>>>
>>> This feature is required for subsequent virtuqueue reset vring.
>>>
>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>> Subject has a typo.
> I will fix it.
>
>> Besides:
>>
>>> ---
>>>   drivers/virtio/virtio_ring.c | 121 ++++++++++++++++++++++++++---------
>>>   1 file changed, 92 insertions(+), 29 deletions(-)
>>>
>>> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
>>> index dc6313b79305..41864c5e665f 100644
>>> --- a/drivers/virtio/virtio_ring.c
>>> +++ b/drivers/virtio/virtio_ring.c
>>> @@ -92,6 +92,18 @@ struct vring_split {
>>>   	struct vring vring;
>>>   };
>>>
>>> +struct vring_packed {
>>> +	u32 num;
>>> +	struct vring_packed_desc *ring;
>>> +	struct vring_packed_desc_event *driver;
>>> +	struct vring_packed_desc_event *device;
>>> +	dma_addr_t ring_dma_addr;
>>> +	dma_addr_t driver_event_dma_addr;
>>> +	dma_addr_t device_event_dma_addr;
>>> +	size_t ring_size_in_bytes;
>>> +	size_t event_size_in_bytes;
>>> +};
>>> +
>>>   struct vring_virtqueue {
>>>   	struct virtqueue vq;
>>>
>>> @@ -1683,45 +1695,101 @@ static struct vring_desc_extra *vring_alloc_desc_extra(struct vring_virtqueue *v
>>>   	return desc_extra;
>>>   }
>>>
>>> -static struct virtqueue *vring_create_virtqueue_packed(
>>> -	unsigned int index,
>>> -	unsigned int num,
>>> -	unsigned int vring_align,
>>> -	struct virtio_device *vdev,
>>> -	bool weak_barriers,
>>> -	bool may_reduce_num,
>>> -	bool context,
>>> -	bool (*notify)(struct virtqueue *),
>>> -	void (*callback)(struct virtqueue *),
>>> -	const char *name)
>>> +static void vring_free_vring_packed(struct vring_packed *vring,
>>> +				    struct virtio_device *vdev)
>>> +{
>>> +	dma_addr_t ring_dma_addr, driver_event_dma_addr, device_event_dma_addr;
>>> +	struct vring_packed_desc_event *driver, *device;
>>> +	size_t ring_size_in_bytes, event_size_in_bytes;
>>> +	struct vring_packed_desc *ring;
>>> +
>>> +	ring                  = vring->ring;
>>> +	driver                = vring->driver;
>>> +	device                = vring->device;
>>> +	ring_dma_addr         = vring->ring_size_in_bytes;
>>> +	event_size_in_bytes   = vring->event_size_in_bytes;
>>> +	ring_dma_addr         = vring->ring_dma_addr;
>>> +	driver_event_dma_addr = vring->driver_event_dma_addr;
>>> +	device_event_dma_addr = vring->device_event_dma_addr;
>>> +
>>> +	if (device)
>>> +		vring_free_queue(vdev, event_size_in_bytes, device, device_event_dma_addr);
>>> +
>>> +	if (driver)
>>> +		vring_free_queue(vdev, event_size_in_bytes, driver, driver_event_dma_addr);
>>> +
>>> +	if (ring)
>>> +		vring_free_queue(vdev, ring_size_in_bytes, ring, ring_dma_addr);
>> ring_size_in_bytes is uninitialized here.
>>
>> Which begs the question how was this tested patchset generally and
>> this patch in particular.
>> Please add note on tested configurations and tests run to the patchset.
> Sorry, my environment is running in split mode. I did not retest the packed mode
> before sending patches. Because my dpdk vhost-user is not easy to use, I
> need to change the kernel of the host.
>
> I would like to ask if there are other lightweight environments that can be used
> to test packed mode.


You can use Qemu's dataplane. It has support for packed virtqueue.

Thanks


>
>
> Thanks.
>
>
>>> +}
>>> +
>>> +static int vring_create_vring_packed(struct vring_packed *vring,
>>> +				    struct virtio_device *vdev,
>>> +				    u32 num)
>>>   {
>>> -	struct vring_virtqueue *vq;
>>>   	struct vring_packed_desc *ring;
>>>   	struct vring_packed_desc_event *driver, *device;
>>>   	dma_addr_t ring_dma_addr, driver_event_dma_addr, device_event_dma_addr;
>>>   	size_t ring_size_in_bytes, event_size_in_bytes;
>>>
>>> +	memset(vring, 0, sizeof(*vring));
>>> +
>>>   	ring_size_in_bytes = num * sizeof(struct vring_packed_desc);
>>>
>>>   	ring = vring_alloc_queue(vdev, ring_size_in_bytes,
>>>   				 &ring_dma_addr,
>>>   				 GFP_KERNEL|__GFP_NOWARN|__GFP_ZERO);
>>>   	if (!ring)
>>> -		goto err_ring;
>>> +		goto err;
>>> +
>>> +	vring->num = num;
>>> +	vring->ring = ring;
>>> +	vring->ring_size_in_bytes = ring_size_in_bytes;
>>> +	vring->ring_dma_addr = ring_dma_addr;
>>>
>>>   	event_size_in_bytes = sizeof(struct vring_packed_desc_event);
>>> +	vring->event_size_in_bytes = event_size_in_bytes;
>>>
>>>   	driver = vring_alloc_queue(vdev, event_size_in_bytes,
>>>   				   &driver_event_dma_addr,
>>>   				   GFP_KERNEL|__GFP_NOWARN|__GFP_ZERO);
>>>   	if (!driver)
>>> -		goto err_driver;
>>> +		goto err;
>>> +
>>> +	vring->driver = driver;
>>> +	vring->driver_event_dma_addr = driver_event_dma_addr;
>>>
>>>   	device = vring_alloc_queue(vdev, event_size_in_bytes,
>>>   				   &device_event_dma_addr,
>>>   				   GFP_KERNEL|__GFP_NOWARN|__GFP_ZERO);
>>>   	if (!device)
>>> -		goto err_device;
>>> +		goto err;
>>> +
>>> +	vring->device = device;
>>> +	vring->device_event_dma_addr = device_event_dma_addr;
>>> +	return 0;
>>> +
>>> +err:
>>> +	vring_free_vring_packed(vring, vdev);
>>> +	return -ENOMEM;
>>> +}
>>> +
>>> +static struct virtqueue *vring_create_virtqueue_packed(
>>> +	unsigned int index,
>>> +	unsigned int num,
>>> +	unsigned int vring_align,
>>> +	struct virtio_device *vdev,
>>> +	bool weak_barriers,
>>> +	bool may_reduce_num,
>>> +	bool context,
>>> +	bool (*notify)(struct virtqueue *),
>>> +	void (*callback)(struct virtqueue *),
>>> +	const char *name)
>>> +{
>>> +	struct vring_virtqueue *vq;
>>> +	struct vring_packed vring;
>>> +
>>> +	if (vring_create_vring_packed(&vring, vdev, num))
>>> +		goto err_vq;
>>>
>>>   	vq = kmalloc(sizeof(*vq), GFP_KERNEL);
>>>   	if (!vq)
>>> @@ -1753,17 +1821,17 @@ static struct virtqueue *vring_create_virtqueue_packed(
>>>   	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
>>>   		vq->weak_barriers = false;
>>>
>>> -	vq->packed.ring_dma_addr = ring_dma_addr;
>>> -	vq->packed.driver_event_dma_addr = driver_event_dma_addr;
>>> -	vq->packed.device_event_dma_addr = device_event_dma_addr;
>>> +	vq->packed.ring_dma_addr = vring.ring_dma_addr;
>>> +	vq->packed.driver_event_dma_addr = vring.driver_event_dma_addr;
>>> +	vq->packed.device_event_dma_addr = vring.device_event_dma_addr;
>>>
>>> -	vq->packed.ring_size_in_bytes = ring_size_in_bytes;
>>> -	vq->packed.event_size_in_bytes = event_size_in_bytes;
>>> +	vq->packed.ring_size_in_bytes = vring.ring_size_in_bytes;
>>> +	vq->packed.event_size_in_bytes = vring.event_size_in_bytes;
>>>
>>>   	vq->packed.vring.num = num;
>>> -	vq->packed.vring.desc = ring;
>>> -	vq->packed.vring.driver = driver;
>>> -	vq->packed.vring.device = device;
>>> +	vq->packed.vring.desc = vring.ring;
>>> +	vq->packed.vring.driver = vring.driver;
>>> +	vq->packed.vring.device = vring.device;
>>>
>>>   	vq->packed.next_avail_idx = 0;
>>>   	vq->packed.avail_wrap_counter = 1;
>>> @@ -1804,12 +1872,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
>>>   err_desc_state:
>>>   	kfree(vq);
>>>   err_vq:
>>> -	vring_free_queue(vdev, event_size_in_bytes, device, device_event_dma_addr);
>>> -err_device:
>>> -	vring_free_queue(vdev, event_size_in_bytes, driver, driver_event_dma_addr);
>>> -err_driver:
>>> -	vring_free_queue(vdev, ring_size_in_bytes, ring, ring_dma_addr);
>>> -err_ring:
>>> +	vring_free_vring_packed(&vring, vdev);
>>>   	return NULL;
>>>   }
>>>
>>> --
>>> 2.31.0

