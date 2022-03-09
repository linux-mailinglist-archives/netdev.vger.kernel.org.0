Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51E84D2AE0
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 09:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbiCIItp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 03:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbiCIIto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 03:49:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36CC7127565
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 00:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646815724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TO8OA67xOJIVUQ+IzXv9BnLhNmwQiU+fyDz+FkJQweU=;
        b=g5J+PGEoU/CPiFQ80HiaO3LHPUvF/NcUe/FU+FPmJYM6JMXfekzHECII3e4ktuc9CgYvGt
        WgYjxFAaDpKiTFdY4joYX8Hu/wqPGAQOVHE9nBnapdtO2cIMd10dS79CcY8kuIb5jpOBmF
        DoqERkWb7oUJqrBcT8ZmO6i1gnrVIyI=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-QnVqj62HOVi1EOvBsabbVQ-1; Wed, 09 Mar 2022 03:48:43 -0500
X-MC-Unique: QnVqj62HOVi1EOvBsabbVQ-1
Received: by mail-pg1-f199.google.com with SMTP id v32-20020a634660000000b0037c3f654c50so948476pgk.6
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 00:48:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TO8OA67xOJIVUQ+IzXv9BnLhNmwQiU+fyDz+FkJQweU=;
        b=6V5PsMJC7HJuwHN1vHD8OWrnMP28AnhJQDnQwg3RAHBGj0e7lslRd6zSRluR0+lx4r
         AMgjdz82+sS+Y3XQAXmrNDBqy1HEnK9F8DZ0yKyo4YHf5XsL+hg4B/mdA/IgMY/OCE6Y
         1UrWM+edER+Dz1dVGxPzgSowgVQLqUv044GrEFNTJJhUOTCoPtw0dy69nnNhyyBoIgcf
         XQMILo1l8KLOfOzNjRjTUNtQelf2SJO8x/wPpCu+LRmnLMY0GIXSY68wuPtAOC1pqdBb
         Fntk7XEw+pfZl4I8iPQdmmBkAEK5MMHRke6ROaYTBHT/wA+9L36CZejcIFZLx9QNE3Ci
         sCkQ==
X-Gm-Message-State: AOAM533OoJGll/uZVgZmwuAcIPAjDpVbNE6Flhp67TXcKDn03577YC9Z
        fuFGDzcDMRHKNapM1mmzFQlzzePoaJ3a7EXuKWHnSouR5KOTAirlvMWg3mpg7+lhsPYgmCYEeof
        jhUx0/vh3xWQPZuo3
X-Received: by 2002:aa7:8882:0:b0:4df:7b9e:1ccb with SMTP id z2-20020aa78882000000b004df7b9e1ccbmr22312156pfe.41.1646815722238;
        Wed, 09 Mar 2022 00:48:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy7/YbZyXIgHV6hqpeiO7757QCskmbcneG6gJIkE8+QzhmuMcmfZenCb/AE2A7PcyT+4y4qLw==
X-Received: by 2002:aa7:8882:0:b0:4df:7b9e:1ccb with SMTP id z2-20020aa78882000000b004df7b9e1ccbmr22312131pfe.41.1646815721958;
        Wed, 09 Mar 2022 00:48:41 -0800 (PST)
Received: from [10.72.12.183] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 142-20020a621894000000b004dfc714b076sm2024468pfy.11.2022.03.09.00.48.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 00:48:41 -0800 (PST)
Message-ID: <fda406d7-3ed9-7c62-0f26-4058a63e73a9@redhat.com>
Date:   Wed, 9 Mar 2022 16:48:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v7 14/26] virtio: add helper for queue reset
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
References: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
 <20220308123518.33800-15-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220308123518.33800-15-xuanzhuo@linux.alibaba.com>
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


在 2022/3/8 下午8:35, Xuan Zhuo 写道:
> Add helper for virtio queue reset.
>
> * virtio_reset_vq(): reset a queue individually
> * virtio_enable_resetq(): enable a reset queue
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   include/linux/virtio_config.h | 40 +++++++++++++++++++++++++++++++++++
>   1 file changed, 40 insertions(+)
>
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index d51906b1389f..0b81fbe17c85 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -230,6 +230,46 @@ int virtio_find_vqs_ctx(struct virtio_device *vdev, unsigned nvqs,
>   				      desc);
>   }
>   
> +/**
> + * virtio_reset_vq - reset a queue individually
> + * @vq: the virtqueue
> + *
> + * returns 0 on success or error status
> + *
> + * The api process of reset under normal circumstances:
> + *	1. virtio_reset_vq()              - notify the device to reset the queue
> + *	2. virtqueue_detach_unused_buf()  - recycle the buffer submitted
> + *	3. virtqueue_reset_vring()        - reset the vring (may re-alloc)
> + *	4. virtio_enable_resetq()         - mmap vring to device, and enable the queue
> + *
> + * Caller should guarantee that the vring is not accessed by any functions
> + * of virtqueue.
> + */
> +static inline
> +int virtio_reset_vq(struct virtqueue *vq)
> +{


It looks to me the prefix "virtio" is used for the device specific 
operations.

I wonder if it's better to rename this as virtqueue_reste() and move it 
to virtio_ring.c?

Thanks


> +	if (!vq->vdev->config->reset_vq)
> +		return -ENOENT;
> +
> +	return vq->vdev->config->reset_vq(vq);
> +}
> +
> +/**
> + * virtio_enable_resetq - enable a reset queue
> + * @vq: the virtqueue
> + *
> + * returns 0 on success or error status
> + *
> + */
> +static inline
> +int virtio_enable_resetq(struct virtqueue *vq)
> +{
> +	if (!vq->vdev->config->enable_reset_vq)
> +		return -ENOENT;
> +
> +	return vq->vdev->config->enable_reset_vq(vq);
> +}
> +
>   /**
>    * virtio_device_ready - enable vq use in probe function
>    * @vdev: the device

