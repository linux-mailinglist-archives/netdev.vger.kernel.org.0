Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0AC4ACF4C
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 03:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240078AbiBHC64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 21:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbiBHC6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:58:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 22018C061355
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 18:58:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644289134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1iPL/OY2vKtxnnn4ofse5g3sqVcV7OwRhLLviSAEN2s=;
        b=fMhzR+yVHt4gd4D1q0IWiMTBk13qtyNdcjiiJQw+YlvHc4o6P1dH+drKz146yFEKCmwhu6
        8Z0sIdTJkG70x3TqEf7cJFyLHxxDrhDIPDluOADKbM6ayRYfXS/IPihd2yPzv/T7MoT5NT
        5KeCSRAJzq0jeKc2l3OvKJJQpUqxfP8=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-166-2CyEG7_gNUaDfdu87WBaQw-1; Mon, 07 Feb 2022 21:58:53 -0500
X-MC-Unique: 2CyEG7_gNUaDfdu87WBaQw-1
Received: by mail-pl1-f199.google.com with SMTP id v20-20020a1709028d9400b0014ca63d0f10so6550571plo.5
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 18:58:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1iPL/OY2vKtxnnn4ofse5g3sqVcV7OwRhLLviSAEN2s=;
        b=NxPgyIlyQBUd6MNEOkl9zwPqmLVVBLgTVYcNGb7p7SwtVrwr0lNXNtbXuRjLxgfVAg
         nSn2DUaxQhn2UuE5oH5DLkszFTN+iQlA8tdr09HYMly/uAcIItOpT7lYhQ0mpx9pT1WW
         bYy+FbKZDeiJmtB4e/5NGB5mo9QCnh9JC7t3a6BOoPkIEXMWiRWMNHF5/s1rISSrtoAJ
         1M74Ys0W9Rdh/EWL0wPrjslHAfKOAJ7Uj+zyGwoeFfA6TuMd6UtzoxhFaOwUREeBtqR0
         p/HhRBDriqP8Yj6BRAwJ25jhsZ/2yWlb5sX1i89sQ+kdZTkW3sq47tUvSZhpckCyOqIL
         CbDA==
X-Gm-Message-State: AOAM5306UZW506HIaRNQdkqHB1erCKu4EriszQjuK37ITjXlT2+ek3Nb
        2FQbOQltbn3PLCh3hu893GNQxMoj1Gjg72Lov2Kl0ggc0xHZhUxdZm3lYz5sFO42+fayuN0Smc7
        L7xwF2vpNUZmlNerp
X-Received: by 2002:a17:902:b583:: with SMTP id a3mr2677357pls.77.1644289131929;
        Mon, 07 Feb 2022 18:58:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwDaqEp6ylw0Kb/+6cBe2Mf1Qn8HvvlERmvET9tFW4bEroVdMmJC/V5b59ayI5l0Rjw7B7isA==
X-Received: by 2002:a17:902:b583:: with SMTP id a3mr2677336pls.77.1644289131628;
        Mon, 07 Feb 2022 18:58:51 -0800 (PST)
Received: from [10.72.13.233] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r12sm9576072pgn.6.2022.02.07.18.58.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 18:58:51 -0800 (PST)
Message-ID: <b0debb2b-7548-c354-2128-2ddf56bf5c18@redhat.com>
Date:   Tue, 8 Feb 2022 10:58:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v3 03/17] virtio: queue_reset: struct virtio_config_ops
 add callbacks for queue_reset
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1644218386.0457659-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <1644218386.0457659-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/2/7 下午3:19, Xuan Zhuo 写道:
> On Mon, 7 Feb 2022 14:45:02 +0800, Jason Wang <jasowang@redhat.com> wrote:
>> 在 2022/1/26 下午3:35, Xuan Zhuo 写道:
>>> Performing reset on a queue is divided into two steps:
>>>
>>> 1. reset_vq: reset one vq
>>> 2. enable_reset_vq: re-enable the reset queue
>>>
>>> In the first step, these tasks will be completed:
>>>       1. notify the hardware queue to reset
>>>       2. recycle the buffer from vq
>>>       3. release the ring of the vq
>>>
>>> The second step is similar to find vqs,
>>
>> Not sure, since find_vqs will usually try to allocate interrupts.
>>
>>
> Yes.
>
>
>>>    passing parameters callback and
>>> name, etc. Based on the original vq, the ring is re-allocated and
>>> configured to the backend.
>>
>> I wonder whether we really have such requirement.
>>
>> For example, do we really have a use case that may change:
>>
>> vq callback, ctx, ring_num or even re-create the virtqueue?
> 1. virtqueue is not recreated
> 2. ring_num can be used to modify ring num by ethtool -G


It looks to me we don't support this right now.


>
> There is really no scene to modify vq callback, ctx, name.
>
> Do you mean we still use the old one instead of adding these parameters?


Yes, I think for driver we need to implement the function that is needed 
for the first user (e.g AF_XDP). If there's no use case, we can leave 
those extension for the future.

Thanks


>
> Thanks.
>
>> Thanks
>>
>>
>>> So add two callbacks reset_vq, enable_reset_vq to struct
>>> virtio_config_ops.
>>>
>>> Add a structure for passing parameters. This will facilitate subsequent
>>> expansion of the parameters of enable reset vq.
>>> There is currently only one default extended parameter ring_num.
>>>
>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>> ---
>>>    include/linux/virtio_config.h | 43 ++++++++++++++++++++++++++++++++++-
>>>    1 file changed, 42 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
>>> index 4d107ad31149..51dd8461d1b6 100644
>>> --- a/include/linux/virtio_config.h
>>> +++ b/include/linux/virtio_config.h
>>> @@ -16,6 +16,44 @@ struct virtio_shm_region {
>>>    	u64 len;
>>>    };
>>>
>>> +typedef void vq_callback_t(struct virtqueue *);
>>> +
>>> +/* virtio_reset_vq: specify parameters for queue_reset
>>> + *
>>> + *	vdev: the device
>>> + *	queue_index: the queue index
>>> + *
>>> + *	free_unused_cb: callback to free unused bufs
>>> + *	data: used by free_unused_cb
>>> + *
>>> + *	callback: callback for the virtqueue, NULL for vq that do not need a
>>> + *	          callback
>>> + *	name: virtqueue names (mainly for debugging), NULL for vq unused by
>>> + *	      driver
>>> + *	ctx: ctx
>>> + *
>>> + *	ring_num: specify ring num for the vq to be re-enabled. 0 means use the
>>> + *	          default value. MUST be a power of 2.
>>> + */
>>> +struct virtio_reset_vq;
>>> +typedef void vq_reset_callback_t(struct virtio_reset_vq *param, void *buf);
>>> +struct virtio_reset_vq {
>>> +	struct virtio_device *vdev;
>>> +	u16 queue_index;
>>> +
>>> +	/* reset vq param */
>>> +	vq_reset_callback_t *free_unused_cb;
>>> +	void *data;
>>> +
>>> +	/* enable reset vq param */
>>> +	vq_callback_t *callback;
>>> +	const char *name;
>>> +	const bool *ctx;
>>> +
>>> +	/* ext enable reset vq param */
>>> +	u16 ring_num;
>>> +};
>>> +
>>>    /**
>>>     * virtio_config_ops - operations for configuring a virtio device
>>>     * Note: Do not assume that a transport implements all of the operations
>>> @@ -74,8 +112,9 @@ struct virtio_shm_region {
>>>     * @set_vq_affinity: set the affinity for a virtqueue (optional).
>>>     * @get_vq_affinity: get the affinity for a virtqueue (optional).
>>>     * @get_shm_region: get a shared memory region based on the index.
>>> + * @reset_vq: reset a queue individually
>>> + * @enable_reset_vq: enable a reset queue
>>>     */
>>> -typedef void vq_callback_t(struct virtqueue *);
>>>    struct virtio_config_ops {
>>>    	void (*enable_cbs)(struct virtio_device *vdev);
>>>    	void (*get)(struct virtio_device *vdev, unsigned offset,
>>> @@ -100,6 +139,8 @@ struct virtio_config_ops {
>>>    			int index);
>>>    	bool (*get_shm_region)(struct virtio_device *vdev,
>>>    			       struct virtio_shm_region *region, u8 id);
>>> +	int (*reset_vq)(struct virtio_reset_vq *param);
>>> +	struct virtqueue *(*enable_reset_vq)(struct virtio_reset_vq *param);
>>>    };
>>>
>>>    /* If driver didn't advertise the feature, it will never appear. */

