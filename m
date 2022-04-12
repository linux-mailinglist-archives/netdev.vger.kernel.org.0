Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 460034FCC9D
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 04:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244789AbiDLCuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 22:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbiDLCuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 22:50:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B77A21246
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 19:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649731676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hJ8D0MpKmhUU0VrC5/OdFFUt9V6ywO7AHposB393jHM=;
        b=i+XExlhK6QRR4fobSoDbapPFON7ATojJoTRgUK3ZuMrkxM7nrXxpWWI8eCZBIuQnNbD/hh
        1sZZG2Zna7ZjadNPkcplt/Q4afSDaoYtynhYcoykujcLWHkBFDYR+Nnfk/uGmbRmPmx6jp
        oZziu8/DruWzlUARYMSiBlrbctE1TG0=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-85ASzINdNluquMMdZmpifQ-1; Mon, 11 Apr 2022 22:47:53 -0400
X-MC-Unique: 85ASzINdNluquMMdZmpifQ-1
Received: by mail-pj1-f70.google.com with SMTP id q10-20020a17090a2dca00b001cb87691fbaso2735207pjm.5
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 19:47:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hJ8D0MpKmhUU0VrC5/OdFFUt9V6ywO7AHposB393jHM=;
        b=yAO4J+Xs2Awu2qdvQannLi/rwAx3Z+gQmAFZdQGspVPD8WfrynV6Anj8eVvVPKpMYg
         +buRsEnNyhaMShNvmKNOyJrrx779hnsxlux1i+hbrofJb4x8tMf61VEsWHG5Vd0GUXFW
         8pSWqkjSlNo18QI5VKPai6ezljXjDWlmxbIxPG6PXc8HFoIzbY6L0tG3T2o0su02VAhq
         +fgfohZEKtj9nXeT98iGQVI4TpEsVl2q6ysLHn4OT4wY1OLwIia543799ywPId7PMfod
         mB70JCiFMUjO6kRNwTXigyGWRkUh4ROgjocQRRfHb0Vurs5Wt8X737l7mHyaHScjrooc
         ujOA==
X-Gm-Message-State: AOAM5325O8VVZMW5XDtug854P1U/qTmM8o5y5RSupBkhXycoIOcxFet8
        LLGQlxQrxIr1dvCC45i+5gnEIecjtZmUdmAIefqa2DwRTnDhJ/SQdq46QheYdjywgYHLaOV+93B
        zG3EP+BHHJkiiDDTG
X-Received: by 2002:a17:902:aa88:b0:156:914b:dc79 with SMTP id d8-20020a170902aa8800b00156914bdc79mr35261836plr.138.1649731672245;
        Mon, 11 Apr 2022 19:47:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw0iNy2ww2vpQRiLgmCUeLissGsbocjPE44RHGsIyPREMT6U8PtkHOixn6nv9QmiJuaqKxs0Q==
X-Received: by 2002:a17:902:aa88:b0:156:914b:dc79 with SMTP id d8-20020a170902aa8800b00156914bdc79mr35261806plr.138.1649731671976;
        Mon, 11 Apr 2022 19:47:51 -0700 (PDT)
Received: from [10.72.14.5] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z16-20020a637e10000000b00382b21c6b0bsm975709pgc.51.2022.04.11.19.47.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 19:47:51 -0700 (PDT)
Message-ID: <9868de23-c171-2492-a43f-78f51df84640@redhat.com>
Date:   Tue, 12 Apr 2022 10:47:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v9 02/32] virtio: struct virtio_config_ops add callbacks
 for queue_reset
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org
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
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
 <20220406034346.74409-3-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220406034346.74409-3-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/4/6 上午11:43, Xuan Zhuo 写道:
> Performing reset on a queue is divided into four steps:
>
>   1. transport: notify the device to reset the queue
>   2. vring:     recycle the buffer submitted
>   3. vring:     reset/resize the vring (may re-alloc)
>   4. transport: mmap vring to device, and enable the queue


Nit: it looks to me we'd better say it's an example (since step 3 or 
even 2 is not a must).


>
> In order to support queue reset, add two callbacks(reset_vq,
> enable_reset_vq) in struct virtio_config_ops to implement steps 1 and 4.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   include/linux/virtio_config.h | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index 4d107ad31149..d4adcd0e1c57 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -74,6 +74,16 @@ struct virtio_shm_region {
>    * @set_vq_affinity: set the affinity for a virtqueue (optional).
>    * @get_vq_affinity: get the affinity for a virtqueue (optional).
>    * @get_shm_region: get a shared memory region based on the index.
> + * @reset_vq: reset a queue individually (optional).
> + *	vq: the virtqueue
> + *	Returns 0 on success or error status
> + *	reset_vq will guarantee that the callbacks are disabled and synchronized.
> + *	Except for the callback, the caller should guarantee that the vring is


I wonder what's the implications for virtio hardening[1]. In that 
series, we agree to have a synchronize_vqs() config ops to make sure 
callbacks are synchronized.

It uses a global flag and a device wise synchronization mechanism. It 
looks to me we need to switch to

1) per virtqueue flag
2) per virtqueue synchronization

Thanks


> + *	not accessed by any functions of virtqueue.
> + * @enable_reset_vq: enable a reset queue
> + *	vq: the virtqueue
> + *	Returns 0 on success or error status
> + *	If reset_vq is set, then enable_reset_vq must also be set.
>    */
>   typedef void vq_callback_t(struct virtqueue *);
>   struct virtio_config_ops {
> @@ -100,6 +110,8 @@ struct virtio_config_ops {
>   			int index);
>   	bool (*get_shm_region)(struct virtio_device *vdev,
>   			       struct virtio_shm_region *region, u8 id);
> +	int (*reset_vq)(struct virtqueue *vq);
> +	int (*enable_reset_vq)(struct virtqueue *vq);
>   };
>   
>   /* If driver didn't advertise the feature, it will never appear. */

