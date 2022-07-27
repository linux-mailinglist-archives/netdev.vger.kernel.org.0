Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8702B581EEE
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 06:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240157AbiG0EeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 00:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240226AbiG0EeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 00:34:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0929D3D59A
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 21:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658896447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zmsJFhYx/U7wRWY1QXPRuk0DZiGyI1mt4/EGEseZMos=;
        b=O1b5tU95vioAajCzMK050gjhpfd5PViij6ZqmquqBultmZUvTBZHxZq+Knb8egJGo4YdhC
        3A3l5qpUZ6LnBAbgd9XqwpmasJRrZPVMyJreMNhFOBji2okn3dlpec/Vmmk5o+OaA7Yl44
        Adm1DTbE2aqGUBu+2i6Kteh8U5SBJiQ=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-sBBsar03MGiucAkhB0v-KA-1; Wed, 27 Jul 2022 00:34:06 -0400
X-MC-Unique: sBBsar03MGiucAkhB0v-KA-1
Received: by mail-pj1-f71.google.com with SMTP id v18-20020a17090abb9200b001f2fb9c5ff8so567255pjr.0
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 21:34:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zmsJFhYx/U7wRWY1QXPRuk0DZiGyI1mt4/EGEseZMos=;
        b=2VA28dm7arYfXZvjsWhEuIrwc4gjUi7vJdJChJL2/c5PSwDFbHDATkfVLRl3FfL+8R
         AfeH4rIvp8ocMKDnwH2tlpEp//9IQ5MvE0Xca8/hRcH8vMpBgIK2scxdL37KwjhQquql
         5yEMD5xfhL40ttOIuvoTSXcwuN/KTq18GYZEzkYkjf3RUc+8IJfuycs/5U9cm93EdF5N
         zXAwCc/xRlKW/z7iAwQ4L5Slponf+rtp9lZFoTKs84upSZMQnptR6iVFcyHcVT2xYcTc
         PBYD8eyF1NsbVbvBmvFhSF0WHidHPrueyHVgrppjo/GSzG/JVWGzyF96yYxBjYhBNV1f
         WHqw==
X-Gm-Message-State: AJIora/G/Hg/F8u8iBj4w0OsYDyjjV5QcZbKzX1xB6dWCqNyOQCZmuWQ
        Gc1rUl8fONJ9QFUiCRfE+KyvCK4AqUBsCrXjXzNmlQcUe+hdG7IphXLpiC2mXaZQRhShpsbYtiX
        XGrbZNIsl1PfRsqDc
X-Received: by 2002:a65:6907:0:b0:415:c9c1:eb4f with SMTP id s7-20020a656907000000b00415c9c1eb4fmr17446490pgq.193.1658896444740;
        Tue, 26 Jul 2022 21:34:04 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tLOTTMSwZn23J72vfWRP8aVjMiYXEHs6Q/e6N32SFoFq1t32q5shVi3/mZ0Ya8jurhHaEXXg==
X-Received: by 2002:a65:6907:0:b0:415:c9c1:eb4f with SMTP id s7-20020a656907000000b00415c9c1eb4fmr17446476pgq.193.1658896444474;
        Tue, 26 Jul 2022 21:34:04 -0700 (PDT)
Received: from [10.72.12.96] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y12-20020a17090322cc00b0016c9e5f291bsm9114120plg.111.2022.07.26.21.33.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 21:34:00 -0700 (PDT)
Message-ID: <11a17272-7318-0217-7e45-83a3b237ed7f@redhat.com>
Date:   Wed, 27 Jul 2022 12:33:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v13 20/42] virtio_ring: packed: extract the logic of vring
 init
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
References: <20220726072225.19884-1-xuanzhuo@linux.alibaba.com>
 <20220726072225.19884-21-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220726072225.19884-21-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/7/26 15:22, Xuan Zhuo 写道:
> Separate the logic of initializing vring, and subsequent patches will
> call it separately.
>
> This function completes the variable initialization of packed vring. It
> together with the logic of atatch constitutes the initialization of
> vring.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/virtio/virtio_ring.c | 28 +++++++++++++++++-----------
>   1 file changed, 17 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 32590d763c3b..fc4e3db9f93b 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -1935,6 +1935,22 @@ static int vring_alloc_state_extra_packed(struct vring_virtqueue_packed *vring_p
>   	return -ENOMEM;
>   }
>   
> +static void virtqueue_vring_init_packed(struct vring_virtqueue_packed *vring_packed,
> +					bool callback)
> +{
> +	vring_packed->next_avail_idx = 0;
> +	vring_packed->avail_wrap_counter = 1;
> +	vring_packed->event_flags_shadow = 0;
> +	vring_packed->avail_used_flags = 1 << VRING_PACKED_DESC_F_AVAIL;
> +
> +	/* No callback?  Tell other side not to bother us. */
> +	if (!callback) {
> +		vring_packed->event_flags_shadow = VRING_PACKED_EVENT_FLAG_DISABLE;
> +		vring_packed->vring.driver->flags =
> +			cpu_to_le16(vring_packed->event_flags_shadow);
> +	}
> +}
> +
>   static struct virtqueue *vring_create_virtqueue_packed(
>   	unsigned int index,
>   	unsigned int num,
> @@ -1984,11 +2000,6 @@ static struct virtqueue *vring_create_virtqueue_packed(
>   
>   	vq->packed.vring = vring_packed.vring;
>   
> -	vq->packed.next_avail_idx = 0;
> -	vq->packed.avail_wrap_counter = 1;
> -	vq->packed.event_flags_shadow = 0;
> -	vq->packed.avail_used_flags = 1 << VRING_PACKED_DESC_F_AVAIL;
> -
>   	err = vring_alloc_state_extra_packed(&vring_packed);
>   	if (err)
>   		goto err_state_extra;
> @@ -1996,12 +2007,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
>   	vq->packed.desc_state = vring_packed.desc_state;
>   	vq->packed.desc_extra = vring_packed.desc_extra;
>   
> -	/* No callback?  Tell other side not to bother us. */
> -	if (!callback) {
> -		vq->packed.event_flags_shadow = VRING_PACKED_EVENT_FLAG_DISABLE;
> -		vq->packed.vring.driver->flags =
> -			cpu_to_le16(vq->packed.event_flags_shadow);
> -	}
> +	virtqueue_vring_init_packed(&vring_packed, !!callback);
>   
>   	virtqueue_init(vq, num);
>   

