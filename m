Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106644AB585
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 08:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiBGHEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 02:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbiBGGpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 01:45:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A9D3C043181
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 22:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644216317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JEUURs9DbKRojqtjER3XfuZTqVH5n0Bbt2yoRWooa6A=;
        b=YOx7Aild7cTu7/JAsa0ZcFNMKU5uANIsCqKp9HezOBfdzP87Au48J34/VzL2vMycAgAj7C
        N4TiM+vCVMKtxOOuEtDXx7u9uzO/MJ8JAubHbyUGhs5w87xcbt+l5HH1xGMm8fJ/GdGNjz
        MOHSF4nnBa05AlO2DG/0TWu1ofvb7K0=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-iR5tF7UPNf6a9eEIOD03Sg-1; Mon, 07 Feb 2022 01:45:12 -0500
X-MC-Unique: iR5tF7UPNf6a9eEIOD03Sg-1
Received: by mail-pl1-f197.google.com with SMTP id p7-20020a1709026b8700b0014a8d8fbf6fso4847659plk.23
        for <netdev@vger.kernel.org>; Sun, 06 Feb 2022 22:45:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JEUURs9DbKRojqtjER3XfuZTqVH5n0Bbt2yoRWooa6A=;
        b=dC/s4pCG5KE8EJcdrdOz6ob1OcRYMYJ8FQ7dqr6WE+oJIHL8QdytL1E62esmXSSUyy
         KT+VqKzpT67eg6LCHd0TM4OkuFS7v1XrimhAw4YiMQCEiLUARdWLljV/vWlkwO1q4k2j
         HZGUwVbLfTFu9OcazWmev9BsbGS0w+5wJizigm55pHd12P02QzZvqeqBhPVN7WrLGLn0
         XTesuj5FMiVUk1A6fIeJUIR51KWjqKXSUSpFvrl7LeP6NZlnFv8lB1YzbGQbQlVnRkze
         FZt3wDdGgRpAh/5Od2gY3rGRzwZHPB/mrtQQFveFQdsaFSFdCRhHVyqfgHckkOUNs75i
         gmSQ==
X-Gm-Message-State: AOAM532PO4mBaQu7Ske5Tpu138Vkk9onYe29PE5YNNTXR6Xz8dWrCXP2
        nQnBnQdwzstRQULurDwiYGEfDMWbpOiJ68FSYXAsE4evz2J1KsDrup9OXNNk+tWOzewTyVe+Ukf
        23Up63Pub+iaXeW8/
X-Received: by 2002:a63:6b42:: with SMTP id g63mr8303758pgc.602.1644216311796;
        Sun, 06 Feb 2022 22:45:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxtYZ8GxxwFMH2BvLkRE/V/ozYLXcbkTgERq0ID8ESIJ580AADyl/hLYYCiSuS83tm2veY2YQ==
X-Received: by 2002:a63:6b42:: with SMTP id g63mr8303744pgc.602.1644216311494;
        Sun, 06 Feb 2022 22:45:11 -0800 (PST)
Received: from [10.72.13.253] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 17sm11002163pfl.175.2022.02.06.22.45.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Feb 2022 22:45:10 -0800 (PST)
Message-ID: <6e3efe44-3ca8-acfa-58a6-c0fc150846e7@redhat.com>
Date:   Mon, 7 Feb 2022 14:45:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v3 03/17] virtio: queue_reset: struct virtio_config_ops
 add callbacks for queue_reset
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
References: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
 <20220126073533.44994-4-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220126073533.44994-4-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/1/26 下午3:35, Xuan Zhuo 写道:
> Performing reset on a queue is divided into two steps:
>
> 1. reset_vq: reset one vq
> 2. enable_reset_vq: re-enable the reset queue
>
> In the first step, these tasks will be completed:
>      1. notify the hardware queue to reset
>      2. recycle the buffer from vq
>      3. release the ring of the vq
>
> The second step is similar to find vqs,


Not sure, since find_vqs will usually try to allocate interrupts.


>   passing parameters callback and
> name, etc. Based on the original vq, the ring is re-allocated and
> configured to the backend.


I wonder whether we really have such requirement.

For example, do we really have a use case that may change:

vq callback, ctx, ring_num or even re-create the virtqueue?

Thanks


>
> So add two callbacks reset_vq, enable_reset_vq to struct
> virtio_config_ops.
>
> Add a structure for passing parameters. This will facilitate subsequent
> expansion of the parameters of enable reset vq.
> There is currently only one default extended parameter ring_num.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   include/linux/virtio_config.h | 43 ++++++++++++++++++++++++++++++++++-
>   1 file changed, 42 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index 4d107ad31149..51dd8461d1b6 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -16,6 +16,44 @@ struct virtio_shm_region {
>   	u64 len;
>   };
>   
> +typedef void vq_callback_t(struct virtqueue *);
> +
> +/* virtio_reset_vq: specify parameters for queue_reset
> + *
> + *	vdev: the device
> + *	queue_index: the queue index
> + *
> + *	free_unused_cb: callback to free unused bufs
> + *	data: used by free_unused_cb
> + *
> + *	callback: callback for the virtqueue, NULL for vq that do not need a
> + *	          callback
> + *	name: virtqueue names (mainly for debugging), NULL for vq unused by
> + *	      driver
> + *	ctx: ctx
> + *
> + *	ring_num: specify ring num for the vq to be re-enabled. 0 means use the
> + *	          default value. MUST be a power of 2.
> + */
> +struct virtio_reset_vq;
> +typedef void vq_reset_callback_t(struct virtio_reset_vq *param, void *buf);
> +struct virtio_reset_vq {
> +	struct virtio_device *vdev;
> +	u16 queue_index;
> +
> +	/* reset vq param */
> +	vq_reset_callback_t *free_unused_cb;
> +	void *data;
> +
> +	/* enable reset vq param */
> +	vq_callback_t *callback;
> +	const char *name;
> +	const bool *ctx;
> +
> +	/* ext enable reset vq param */
> +	u16 ring_num;
> +};
> +
>   /**
>    * virtio_config_ops - operations for configuring a virtio device
>    * Note: Do not assume that a transport implements all of the operations
> @@ -74,8 +112,9 @@ struct virtio_shm_region {
>    * @set_vq_affinity: set the affinity for a virtqueue (optional).
>    * @get_vq_affinity: get the affinity for a virtqueue (optional).
>    * @get_shm_region: get a shared memory region based on the index.
> + * @reset_vq: reset a queue individually
> + * @enable_reset_vq: enable a reset queue
>    */
> -typedef void vq_callback_t(struct virtqueue *);
>   struct virtio_config_ops {
>   	void (*enable_cbs)(struct virtio_device *vdev);
>   	void (*get)(struct virtio_device *vdev, unsigned offset,
> @@ -100,6 +139,8 @@ struct virtio_config_ops {
>   			int index);
>   	bool (*get_shm_region)(struct virtio_device *vdev,
>   			       struct virtio_shm_region *region, u8 id);
> +	int (*reset_vq)(struct virtio_reset_vq *param);
> +	struct virtqueue *(*enable_reset_vq)(struct virtio_reset_vq *param);
>   };
>   
>   /* If driver didn't advertise the feature, it will never appear. */

