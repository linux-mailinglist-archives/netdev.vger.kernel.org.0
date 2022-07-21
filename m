Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4AA657C737
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 11:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbiGUJOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 05:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbiGUJOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 05:14:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD1303C16D
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 02:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658394884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qsc4liwturFJYHAITq0jfAcGv5JnVY7R1RVgysjsWkI=;
        b=ht9iHBb7wDvinRuLOPw2KXXXxh1SIXRRqM2B7PFqaXNzr1c5fRrm04TN4CcHZYWBlIpXTe
        DTEykRgzTAXN6AIo0oQZ/tnH6hzvEE4veg0ATXLoqeEJ3OSTx32xskeYa6V95Fd3H0Cw51
        d0qm8zB5x24eUFXubt0PkMvF/of06a8=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-6vHVcYAcNBGoeVq6aXPjBg-1; Thu, 21 Jul 2022 05:14:42 -0400
X-MC-Unique: 6vHVcYAcNBGoeVq6aXPjBg-1
Received: by mail-pj1-f70.google.com with SMTP id o21-20020a17090a9f9500b001f0574225faso2549865pjp.6
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 02:14:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Qsc4liwturFJYHAITq0jfAcGv5JnVY7R1RVgysjsWkI=;
        b=SD2gxW2O+gIA7km8oMwAyiKS2fNZ8Nb2MFI8iM8eaiz2DGV9Q1n/QDcnDRwNVvpHQI
         54Sbii+Ghae/8yNB5MyMxn9dpMT8MJ0AGwfwnAiHwq8267WABDiDjS479F0WmFixqM+u
         /XhzYcKod2kCg2pNTS/5N+4nT3nItjU4hCpG63IhPDN2GQgfRI2ja6uOeADStTI+lODl
         zbj5Sv1a1iWheOXnWMjPer5ZoFPQ7SoSYrFKEbDPU23u7Sd0fLFl13COcB0f7Aofff7a
         stKQ+lKHxEvKc0xf0QnnD91par5Nce0ac60MaIlLtXcX7Ewsin//4xMu182YCJlUH2MG
         MwbA==
X-Gm-Message-State: AJIora+2ihYz5ndiUV8e0OXqe3UVkBGILMNIxH+MCjkFrMsPpoYx7Kpb
        DcdYDL9+Qr09OPtckPDPfMW6qR/ovR9VRssbT2Va867bOJz8B971BtmrgLsDNga3jX2LBJ5R3lm
        wVz5Exd0dONAdQ1Zs
X-Received: by 2002:a17:902:f54e:b0:16c:5119:d4a8 with SMTP id h14-20020a170902f54e00b0016c5119d4a8mr41391775plf.22.1658394881754;
        Thu, 21 Jul 2022 02:14:41 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vZasibIAHQ47D1+cg3lbZlHNL9q45E+5hv7aYoBqQJppes7C+ekD1lr5quAazlbWW4qs7GdA==
X-Received: by 2002:a17:902:f54e:b0:16c:5119:d4a8 with SMTP id h14-20020a170902f54e00b0016c5119d4a8mr41391753plf.22.1658394881472;
        Thu, 21 Jul 2022 02:14:41 -0700 (PDT)
Received: from [10.72.12.47] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x8-20020a170902a38800b0016bebb0cb96sm1114154pla.266.2022.07.21.02.14.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 02:14:40 -0700 (PDT)
Message-ID: <e760bce5-2ead-8be4-6a86-0f453b30dcc3@redhat.com>
Date:   Thu, 21 Jul 2022 17:14:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v12 26/40] virtio_ring: struct virtqueue introduce reset
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
 <20220720030436.79520-27-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220720030436.79520-27-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/7/20 11:04, Xuan Zhuo 写道:
> Introduce a new member reset to the structure virtqueue to determine
> whether the current vq is in the reset state. Subsequent patches will
> use it.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/virtio/virtio_ring.c | 2 ++
>   include/linux/virtio.h       | 2 ++
>   2 files changed, 4 insertions(+)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index bf666dad9904..8278b917ad64 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -2011,6 +2011,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
>   	vq->vq.vdev = vdev;
>   	vq->vq.name = name;
>   	vq->vq.index = index;
> +	vq->vq.reset = false;
>   	vq->we_own_ring = true;
>   	vq->notify = notify;
>   	vq->weak_barriers = weak_barriers;
> @@ -2490,6 +2491,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>   	vq->vq.vdev = vdev;
>   	vq->vq.name = name;
>   	vq->vq.index = index;
> +	vq->vq.reset = false;
>   	vq->we_own_ring = false;
>   	vq->notify = notify;
>   	vq->weak_barriers = weak_barriers;
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index d45ee82a4470..a3f73bb6733e 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -20,6 +20,7 @@
>    * @index: the zero-based ordinal number for this queue.
>    * @num_free: number of elements we expect to be able to fit.
>    * @num_max: the maximum number of elements supported by the device.
> + * @reset: vq is in reset state or not.
>    *
>    * A note on @num_free: with indirect buffers, each buffer needs one
>    * element in the queue, otherwise a buffer will need one element per
> @@ -34,6 +35,7 @@ struct virtqueue {
>   	unsigned int num_free;
>   	unsigned int num_max;
>   	void *priv;
> +	bool reset;
>   };
>   
>   int virtqueue_add_outbuf(struct virtqueue *vq,

