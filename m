Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B5257C766
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 11:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiGUJSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 05:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbiGUJSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 05:18:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1BAA67172C
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 02:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658395092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M+vIwXeYsCEkEUsTKw8QtL45orx1Kk3xmbASgcq3Ur4=;
        b=AVTIO/F3l5dJx+BFvWKNGbWFFf9vPdlRh9s1gPyUyWysqdcXuKioreWn3y6+A3ra6Y8jR1
        15CsGi9Vu2Xoo3EICptWeWnsFrFxR6JmHYnAofC9smw+2xFkXmVXBxLpZyOvgT5LvXCpNX
        CGgu0mNvuhnl1g3q2YPMwGtAbTDsjsA=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-x9YtmgoQNXeSJQaWkmKKbQ-1; Thu, 21 Jul 2022 05:18:10 -0400
X-MC-Unique: x9YtmgoQNXeSJQaWkmKKbQ-1
Received: by mail-pg1-f197.google.com with SMTP id 81-20020a630054000000b0041978b2aa9eso662588pga.9
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 02:18:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=M+vIwXeYsCEkEUsTKw8QtL45orx1Kk3xmbASgcq3Ur4=;
        b=7Jag8BTUf8Iv6WgTX4L8oawcHYNiJiF7QMk3wPgVZ2h1gkUZ3yLz/64Oen0GZuABck
         xwX3VXIQooeFrdoTqg3Lnjlhw/z49uRoj6Ri6XTbz2aunh3SrwUWn16ri4WfO26oMghx
         +hPrZviZHsTQ6hA7QzssXqoDayXNLo6e83WpWCFFBw/NXHlF0nF7Mi7kNQGCKsOkUUUE
         lyNOHUsfJjPwU8ZVmn/0cPec9gMy24qTn1aij+7mr5e1C5FuHzL0FXIDSXldH80HnzNs
         k5ob6aEdy2rJzCi1fIvW3kG0NTO87RS5G5rRqFn0giBs75jRqKmBAdSAvRU2JjXDc0dN
         pvOw==
X-Gm-Message-State: AJIora/OOuhANBmL1gPBNbJpsXawPYRPpy7r1ok0WWMKRLn/Kb39m60J
        10Lber8he8+ktK5fK91TTI4YG5JLUMfVBoFpiCxtreF+M9unIdmV96mr05YT6ZqELVYY7AS3J/Z
        E6IHCnydFmGLGHWEB
X-Received: by 2002:a63:4a06:0:b0:419:f141:888b with SMTP id x6-20020a634a06000000b00419f141888bmr26735161pga.55.1658395089662;
        Thu, 21 Jul 2022 02:18:09 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s9nzu3jAsk5dUxtx54RQoVz+wHADLvAyZMB2NBOxUjVrQ03oeZ7/DH43ZkbxWeca1+gmgJrw==
X-Received: by 2002:a63:4a06:0:b0:419:f141:888b with SMTP id x6-20020a634a06000000b00419f141888bmr26735127pga.55.1658395089370;
        Thu, 21 Jul 2022 02:18:09 -0700 (PDT)
Received: from [10.72.12.47] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e17-20020a056a0000d100b00528bbf8245dsm1203607pfj.79.2022.07.21.02.17.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 02:18:08 -0700 (PDT)
Message-ID: <d79d26ce-c149-283a-8fd7-825b029aa51d@redhat.com>
Date:   Thu, 21 Jul 2022 17:17:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v12 31/40] virtio: find_vqs() add arg sizes
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        kangjie.xu@linux.alibaba.com
References: <20220720030436.79520-1-xuanzhuo@linux.alibaba.com>
 <20220720030436.79520-32-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220720030436.79520-32-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/7/20 11:04, Xuan Zhuo 写道:
> find_vqs() adds a new parameter sizes to specify the size of each vq
> vring.
>
> NULL as sizes means that all queues in find_vqs() use the maximum size.
> A value in the array is 0, which means that the corresponding queue uses
> the maximum size.
>
> In the split scenario, the meaning of size is the largest size, because
> it may be limited by memory, the virtio core will try a smaller size.
> And the size is power of 2.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Hans de Goede <hdegoede@redhat.com>
> Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   arch/um/drivers/virtio_uml.c             |  2 +-
>   drivers/platform/mellanox/mlxbf-tmfifo.c |  1 +
>   drivers/remoteproc/remoteproc_virtio.c   |  1 +
>   drivers/s390/virtio/virtio_ccw.c         |  1 +
>   drivers/virtio/virtio_mmio.c             |  1 +
>   drivers/virtio/virtio_pci_common.c       |  2 +-
>   drivers/virtio/virtio_pci_common.h       |  2 +-
>   drivers/virtio/virtio_pci_modern.c       |  7 +++++--
>   drivers/virtio/virtio_vdpa.c             |  1 +
>   include/linux/virtio_config.h            | 14 +++++++++-----
>   10 files changed, 22 insertions(+), 10 deletions(-)
>
> diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
> index e719af8bdf56..79e38afd4b91 100644
> --- a/arch/um/drivers/virtio_uml.c
> +++ b/arch/um/drivers/virtio_uml.c
> @@ -1011,7 +1011,7 @@ static struct virtqueue *vu_setup_vq(struct virtio_device *vdev,
>   
>   static int vu_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>   		       struct virtqueue *vqs[], vq_callback_t *callbacks[],
> -		       const char * const names[], const bool *ctx,
> +		       const char * const names[], u32 sizes[], const bool *ctx,
>   		       struct irq_affinity *desc)
>   {
>   	struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
> diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/mellanox/mlxbf-tmfifo.c
> index 1ae3c56b66b0..8be13d416f48 100644
> --- a/drivers/platform/mellanox/mlxbf-tmfifo.c
> +++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
> @@ -928,6 +928,7 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct virtio_device *vdev,
>   					struct virtqueue *vqs[],
>   					vq_callback_t *callbacks[],
>   					const char * const names[],
> +					u32 sizes[],
>   					const bool *ctx,
>   					struct irq_affinity *desc)
>   {
> diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
> index 0f7706e23eb9..81c4f5776109 100644
> --- a/drivers/remoteproc/remoteproc_virtio.c
> +++ b/drivers/remoteproc/remoteproc_virtio.c
> @@ -158,6 +158,7 @@ static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>   				 struct virtqueue *vqs[],
>   				 vq_callback_t *callbacks[],
>   				 const char * const names[],
> +				 u32 sizes[],
>   				 const bool * ctx,
>   				 struct irq_affinity *desc)
>   {
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 6b86d0280d6b..72500cd2dbf5 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -635,6 +635,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>   			       struct virtqueue *vqs[],
>   			       vq_callback_t *callbacks[],
>   			       const char * const names[],
> +			       u32 sizes[],
>   			       const bool *ctx,
>   			       struct irq_affinity *desc)
>   {
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index a20d5a6b5819..5e3ba3cc7fd0 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -474,6 +474,7 @@ static int vm_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>   		       struct virtqueue *vqs[],
>   		       vq_callback_t *callbacks[],
>   		       const char * const names[],
> +		       u32 sizes[],
>   		       const bool *ctx,
>   		       struct irq_affinity *desc)
>   {
> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> index ad258a9d3b9f..7ad734584823 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -396,7 +396,7 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
>   /* the config->find_vqs() implementation */
>   int vp_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>   		struct virtqueue *vqs[], vq_callback_t *callbacks[],
> -		const char * const names[], const bool *ctx,
> +		const char * const names[], u32 sizes[], const bool *ctx,
>   		struct irq_affinity *desc)
>   {
>   	int err;
> diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
> index 23112d84218f..a5ff838b85a5 100644
> --- a/drivers/virtio/virtio_pci_common.h
> +++ b/drivers/virtio/virtio_pci_common.h
> @@ -110,7 +110,7 @@ void vp_del_vqs(struct virtio_device *vdev);
>   /* the config->find_vqs() implementation */
>   int vp_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>   		struct virtqueue *vqs[], vq_callback_t *callbacks[],
> -		const char * const names[], const bool *ctx,
> +		const char * const names[], u32 sizes[], const bool *ctx,
>   		struct irq_affinity *desc);
>   const char *vp_bus_name(struct virtio_device *vdev);
>   
> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> index 4d28b6918c80..19ec491d515a 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -355,12 +355,15 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>   static int vp_modern_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>   			      struct virtqueue *vqs[],
>   			      vq_callback_t *callbacks[],
> -			      const char * const names[], const bool *ctx,
> +			      const char * const names[],
> +			      u32 sizes[],
> +			      const bool *ctx,
>   			      struct irq_affinity *desc)
>   {
>   	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>   	struct virtqueue *vq;
> -	int rc = vp_find_vqs(vdev, nvqs, vqs, callbacks, names, ctx, desc);
> +	int rc = vp_find_vqs(vdev, nvqs, vqs, callbacks, names, sizes, ctx,
> +			     desc);
>   
>   	if (rc)
>   		return rc;
> diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
> index 9670cc79371d..832d2c5b1b19 100644
> --- a/drivers/virtio/virtio_vdpa.c
> +++ b/drivers/virtio/virtio_vdpa.c
> @@ -269,6 +269,7 @@ static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>   				struct virtqueue *vqs[],
>   				vq_callback_t *callbacks[],
>   				const char * const names[],
> +				u32 sizes[],
>   				const bool *ctx,
>   				struct irq_affinity *desc)
>   {
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index 36ec7be1f480..888f7e96f0c7 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -55,6 +55,7 @@ struct virtio_shm_region {
>    *		include a NULL entry for vqs that do not need a callback
>    *	names: array of virtqueue names (mainly for debugging)
>    *		include a NULL entry for vqs unused by driver
> + *	sizes: array of virtqueue sizes
>    *	Returns 0 on success or error status
>    * @del_vqs: free virtqueues found by find_vqs().
>    * @synchronize_cbs: synchronize with the virtqueue callbacks (optional)
> @@ -103,7 +104,9 @@ struct virtio_config_ops {
>   	void (*reset)(struct virtio_device *vdev);
>   	int (*find_vqs)(struct virtio_device *, unsigned nvqs,
>   			struct virtqueue *vqs[], vq_callback_t *callbacks[],
> -			const char * const names[], const bool *ctx,
> +			const char * const names[],
> +			u32 sizes[],
> +			const bool *ctx,
>   			struct irq_affinity *desc);
>   	void (*del_vqs)(struct virtio_device *);
>   	void (*synchronize_cbs)(struct virtio_device *);
> @@ -212,7 +215,7 @@ struct virtqueue *virtio_find_single_vq(struct virtio_device *vdev,
>   	const char *names[] = { n };
>   	struct virtqueue *vq;
>   	int err = vdev->config->find_vqs(vdev, 1, &vq, callbacks, names, NULL,
> -					 NULL);
> +					 NULL, NULL);
>   	if (err < 0)
>   		return ERR_PTR(err);
>   	return vq;
> @@ -224,7 +227,8 @@ int virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>   			const char * const names[],
>   			struct irq_affinity *desc)
>   {
> -	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, NULL, desc);
> +	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, NULL,
> +				      NULL, desc);
>   }
>   
>   static inline
> @@ -233,8 +237,8 @@ int virtio_find_vqs_ctx(struct virtio_device *vdev, unsigned nvqs,
>   			const char * const names[], const bool *ctx,
>   			struct irq_affinity *desc)
>   {
> -	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, ctx,
> -				      desc);
> +	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, NULL,
> +				      ctx, desc);
>   }
>   
>   /**

