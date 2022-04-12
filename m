Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 841014FCD1A
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 05:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344541AbiDLDdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 23:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242870AbiDLDdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 23:33:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2448526544
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 20:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649734281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5eb+Gzab3jr62PJIS60DbGOqSCN3+xOrWtJx9HNjsDg=;
        b=GrkO3HTXlBfv31E1hy6Jz2jIRBtCIMrbECa6kWo8jumygO73OHh5bY+UCp9+10VKWHvStz
        MRnRWHx898TEQ60BG47RLOhDZBVY0//rho66+MiZw5h567u+Kyl1DWBr84zBT61AvCk7mr
        mExszei55N1Y0ZxduUnXV0jIRIzUHmQ=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-fDG-fL1hOkOPq6AjHFUz6w-1; Mon, 11 Apr 2022 23:31:20 -0400
X-MC-Unique: fDG-fL1hOkOPq6AjHFUz6w-1
Received: by mail-pf1-f200.google.com with SMTP id j17-20020a62b611000000b004fa6338bd77so10698059pff.10
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 20:31:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5eb+Gzab3jr62PJIS60DbGOqSCN3+xOrWtJx9HNjsDg=;
        b=nw+/Plwcleys7DwVC45No4Rze/hNQxWufhxWJNIlJGWQ7+Fky/CSgPSuLh63azfWYm
         J0NuRwDKxgjD9sOml6/6bP4AA/WguXl+344GCqiVAe9WY8GqoA3gTXghZsnlwsoFIM9b
         ZwEU48Q1l5MP7/gTYrTwHjePk0+2aFTYsjY24QS/8+CiXSHi1WmP9bz580JyWlzmoKTr
         kgd+ZIHGte0ORQtQarEXAiN+rDgnfHTo08+3WhJlAqJGSP8Me3B6A5j/U4Rx5kg6k6PV
         jlrJtASKcncOeG33DTqIhGyg+K/2cr94/VEhEykNpouOKTXqY4Unynhq0CzY9zlUBgV7
         izpQ==
X-Gm-Message-State: AOAM533CFTqoWhFxS2Gz2ppGwPhNXur0IpkGWpfgBR+bTDKXZQuGE8Py
        +2zm0TB/KG/qTY+P6HOwNE+q9jgkJ1tQrxuOub+Dn3se0K7+oUjMSAM3icinuvSWpccmdAWuw3e
        OnpmZ1PhDlpXeocau
X-Received: by 2002:a63:3fc7:0:b0:398:aad3:3ce1 with SMTP id m190-20020a633fc7000000b00398aad33ce1mr28475484pga.461.1649734279081;
        Mon, 11 Apr 2022 20:31:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz47KljxbHDCRWoq3Z8n63z/qIZIEy7qpHO2PYfQHRukhkqpY0pZKdUv2yQALElEze5aAFBww==
X-Received: by 2002:a63:3fc7:0:b0:398:aad3:3ce1 with SMTP id m190-20020a633fc7000000b00398aad33ce1mr28475463pga.461.1649734278851;
        Mon, 11 Apr 2022 20:31:18 -0700 (PDT)
Received: from [10.72.14.5] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n4-20020a637204000000b00398522203a2sm1029161pgc.80.2022.04.11.20.31.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 20:31:18 -0700 (PDT)
Message-ID: <28237db0-cf04-aa36-b7b8-de55b11d18db@redhat.com>
Date:   Tue, 12 Apr 2022 11:31:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v9 08/32] virtio_ring: split: extract the logic of attach
 vring
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
 <20220406034346.74409-9-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220406034346.74409-9-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/4/6 上午11:43, Xuan Zhuo 写道:
> Separate the logic of attach vring, subsequent patches will call it
> separately.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/virtio/virtio_ring.c | 20 ++++++++++++++------
>   1 file changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 6de67439cb57..083f2992ba0d 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -916,6 +916,19 @@ static void *virtqueue_detach_unused_buf_split(struct virtqueue *_vq)
>   	return NULL;
>   }
>   
> +static void vring_virtqueue_attach_split(struct vring_virtqueue *vq,
> +					 struct vring vring,
> +					 struct vring_desc_state_split *desc_state,
> +					 struct vring_desc_extra *desc_extra)
> +{
> +	vq->split.vring = vring;
> +	vq->split.queue_dma_addr = 0;
> +	vq->split.queue_size_in_bytes = 0;


Any reason to add the above two assignment in attach? It seems belong to 
free or reset.

Thanks


> +
> +	vq->split.desc_state = desc_state;
> +	vq->split.desc_extra = desc_extra;
> +}
> +
>   static int vring_alloc_state_extra_split(u32 num,
>   					 struct vring_desc_state_split **desc_state,
>   					 struct vring_desc_extra **desc_extra)
> @@ -2262,10 +2275,6 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>   	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
>   		vq->weak_barriers = false;
>   
> -	vq->split.queue_dma_addr = 0;
> -	vq->split.queue_size_in_bytes = 0;
> -
> -	vq->split.vring = vring;
>   	vq->split.avail_flags_shadow = 0;
>   	vq->split.avail_idx_shadow = 0;
>   
> @@ -2283,8 +2292,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>   		return NULL;
>   	}
>   
> -	vq->split.desc_state = state;
> -	vq->split.desc_extra = extra;
> +	vring_virtqueue_attach_split(vq, vring, state, extra);
>   
>   	/* Put everything in free lists. */
>   	vq->free_head = 0;

