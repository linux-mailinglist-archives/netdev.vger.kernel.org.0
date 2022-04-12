Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE29D4FCCC9
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 04:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235736AbiDLDAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 23:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235747AbiDLDAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 23:00:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 375032A24A
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 19:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649732308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kb270zTcKFgdb0H5CrhMTvFSHJ9sEAjIYD+VUSYpTQc=;
        b=f7BdlZXwErmRvTqlJ7SYTZvoSQHac1CQkCdPb4izLJy3DC598P7i1MMKX4r8C0gXqJPjPW
        yya+bFlC8jZxSu0g+rcNDukYXDzF9CiI7wCWZ3jBbHfT4yzTaVkrLns/MUNguL45Rn7gTJ
        B/cg4qrF6Suau5RsN72WcGoQKmcxgLM=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-IDCgZxAdOn200f3JveTxng-1; Mon, 11 Apr 2022 22:58:26 -0400
X-MC-Unique: IDCgZxAdOn200f3JveTxng-1
Received: by mail-pj1-f70.google.com with SMTP id u1-20020a17090a2b8100b001cba1905e25so721301pjd.7
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 19:58:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kb270zTcKFgdb0H5CrhMTvFSHJ9sEAjIYD+VUSYpTQc=;
        b=vg7jwnEe5JYmtyjhgw9c1XhphQ3MOHtRPm+IYN65xNa+qKYnSYcp61Jsp76+lbonh1
         7t8+1TpJ5O8AN0FLKVefvYF8xTp/He2OaRI96RmFqzoF/PfiOaFSFmFLMp7/kwsJKMaR
         WZeFeMjeXvqYrk+P8a+PU/5bVwr+hffpCZf3Tl3tRTVd43BFsTPnLif4DTt1i0Kz2zwy
         ZYT9gbnuOP/HSSYS6rkWcN3wa8NBcLjiFXBjatVHXu+AH4EI22+rSJ2E16XJiKtx/J5R
         Z05eaQPrCn1giHqQ+8UXwWjhREji4SRAwHXNA2dYzoAtt3inoMz44xbdfLQCR1B+czAL
         ffkg==
X-Gm-Message-State: AOAM5321QnZ+pA1pzaucs8vtBa0Km9+8tda6eJFI42fgiyVnRvg91ILn
        SSo/RCzaZuid0Vq9bNaG71akKUJ+Oh7kBO9k4jgD4h/qZT97AZlGSOvQDoIComDt1yWiCfN5OvV
        nemsxvsHUHRrB4N6j
X-Received: by 2002:a17:902:7c01:b0:158:3dd6:d1ba with SMTP id x1-20020a1709027c0100b001583dd6d1bamr13393373pll.120.1649732305612;
        Mon, 11 Apr 2022 19:58:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0eBbGj1OUtWYDo7mmUONDwOeZaEnnKcRCtxgJd2sVmvnSsbaW8//LNh4m+6WALJ5MiKzuew==
X-Received: by 2002:a17:902:7c01:b0:158:3dd6:d1ba with SMTP id x1-20020a1709027c0100b001583dd6d1bamr13393363pll.120.1649732305374;
        Mon, 11 Apr 2022 19:58:25 -0700 (PDT)
Received: from [10.72.14.5] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 21-20020a630115000000b00382a0895661sm999882pgb.11.2022.04.11.19.58.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 19:58:24 -0700 (PDT)
Message-ID: <14b0c4ea-038a-8688-7ca0-4ea0ef407aba@redhat.com>
Date:   Tue, 12 Apr 2022 10:58:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v9 05/32] virtio_ring: extract the logic of freeing vring
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
 <20220406034346.74409-6-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220406034346.74409-6-xuanzhuo@linux.alibaba.com>
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
> Introduce vring_free() to free the vring of vq.
>
> Subsequent patches will use vring_free() alone.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/virtio/virtio_ring.c | 18 +++++++++++++-----
>   1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index cb6010750a94..33fddfb907a6 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -2301,14 +2301,10 @@ struct virtqueue *vring_new_virtqueue(unsigned int index,
>   }
>   EXPORT_SYMBOL_GPL(vring_new_virtqueue);
>   
> -void vring_del_virtqueue(struct virtqueue *_vq)
> +static void vring_free(struct virtqueue *_vq)
>   {
>   	struct vring_virtqueue *vq = to_vvq(_vq);
>   
> -	spin_lock(&vq->vq.vdev->vqs_list_lock);
> -	list_del(&_vq->list);
> -	spin_unlock(&vq->vq.vdev->vqs_list_lock);
> -
>   	if (vq->we_own_ring) {
>   		if (vq->packed_ring) {
>   			vring_free_queue(vq->vq.vdev,
> @@ -2339,6 +2335,18 @@ void vring_del_virtqueue(struct virtqueue *_vq)
>   		kfree(vq->split.desc_state);
>   		kfree(vq->split.desc_extra);
>   	}
> +}
> +
> +void vring_del_virtqueue(struct virtqueue *_vq)
> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +
> +	spin_lock(&vq->vq.vdev->vqs_list_lock);
> +	list_del(&_vq->list);
> +	spin_unlock(&vq->vq.vdev->vqs_list_lock);
> +
> +	vring_free(_vq);
> +
>   	kfree(vq);
>   }
>   EXPORT_SYMBOL_GPL(vring_del_virtqueue);

