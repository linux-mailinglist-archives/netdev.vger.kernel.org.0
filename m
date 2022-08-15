Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F79159293D
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 08:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbiHOGAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 02:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232866AbiHOGAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 02:00:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 03442659F
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 23:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660543229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lAdBQK0QiV5b4wlrykjTQFv9XF+6GUWZgv1gebJc3GA=;
        b=HIlX8HoHsqPMnsQBIOMfUbn1dfKWKo2KIN5uIkqv9nRaN0gsvwQMZTnHtrZsIY7rqFnG83
        h0A41dClad3isNR67d6pex+4SjKlD+i9DOQHDZCUZ23zxpJT57JDm121Hdw6sz3huMd/sJ
        9KRt0tQjhbl7JOyn9DDkkJ+hUTCSsOM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-169-A7B_txCfPueTU_kW_Xr8OA-1; Mon, 15 Aug 2022 02:00:27 -0400
X-MC-Unique: A7B_txCfPueTU_kW_Xr8OA-1
Received: by mail-ed1-f71.google.com with SMTP id y14-20020a056402440e00b0044301c7ccd9so4133512eda.19
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 23:00:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=lAdBQK0QiV5b4wlrykjTQFv9XF+6GUWZgv1gebJc3GA=;
        b=zxlsuKNsECl1sDk/+LTjN+Qqy/BItGXab5oPNjTcVFagq7RoHOJG1Qb+J+mTUcwDV4
         jF1xWRRFNwYTJLg7YYWCd4GdPP/vTTGPK6vpPpVgvzfeat0qcnTqfAU3xrf1q60/a5S5
         qJMa99Ghu0OP9nkQMs2XGTRDjAELdxKzuEsJZU7kh7uNg5XyLZ3nqhTspy8/jl+VTNOk
         Hi6rnq444ebCOOKV/+wnIcmwGo/6hxmU4WOltGI3lBcAtc0HlAmaWnmLP80UdQEJoj5U
         M1re1abbRJCfhZjpx99WcszVpiE8Hq3+Kz7XUf1mYRvp94UiAs18yPt+Bkyiz3BKqz61
         yAJg==
X-Gm-Message-State: ACgBeo3wRnQ7e5VWZPUYoPGe4M6sDdkRsk1KmlL60Ngv6JWsElKN7aFg
        UYHocsXC5jHbBCPCqSqlxCkKsyHuOZmercGVXmRJ+NOOugZS0iPzp3o/Ti0gNPLSDgpP8pgWYTu
        JGxbBInLDJ7KOHpe3
X-Received: by 2002:a17:907:1c89:b0:734:d05c:582e with SMTP id nb9-20020a1709071c8900b00734d05c582emr9323878ejc.282.1660543226550;
        Sun, 14 Aug 2022 23:00:26 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7ajggNt5I/GyHHzN8RtwufAK7sHaSR68oGYohV/XNRYX67jjVhq0Tw36JfrmGRYRVhC7SPJg==
X-Received: by 2002:a17:907:1c89:b0:734:d05c:582e with SMTP id nb9-20020a1709071c8900b00734d05c582emr9323840ejc.282.1660543226308;
        Sun, 14 Aug 2022 23:00:26 -0700 (PDT)
Received: from redhat.com ([2.54.169.49])
        by smtp.gmail.com with ESMTPSA id dk19-20020a170906f0d300b0072fd1e563e2sm3743539ejb.177.2022.08.14.23.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Aug 2022 23:00:25 -0700 (PDT)
Date:   Mon, 15 Aug 2022 02:00:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jason Wang <jasowang@redhat.com>,
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
Subject: Re: [PATCH v14 37/42] virtio_net: set the default max ring size by
 find_vqs()
Message-ID: <20220815015405-mutt-send-email-mst@kernel.org>
References: <20220801063902.129329-1-xuanzhuo@linux.alibaba.com>
 <20220801063902.129329-38-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801063902.129329-38-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 01, 2022 at 02:38:57PM +0800, Xuan Zhuo wrote:
> Use virtio_find_vqs_ctx_size() to specify the maximum ring size of tx,
> rx at the same time.
> 
>                          | rx/tx ring size
> -------------------------------------------
> speed == UNKNOWN or < 10G| 1024
> speed < 40G              | 4096
> speed >= 40G             | 8192
> 
> Call virtnet_update_settings() once before calling init_vqs() to update
> speed.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Jason Wang <jasowang@redhat.com>

I've been looking at this patchset because of the resent
reported crashes, and I'm having second thoughts about this.

Do we really want to second-guess the device supplied
max ring size? If yes why?

Could you please share some performance data that motivated this
specific set of numbers?

Also why do we intepret UNKNOWN as "very low"?
I'm thinking that should definitely be "don't change anything".

Finally if all this makes sense then shouldn't we react when
speed changes?

Could you try reverting this and showing performance results
before and after please? Thanks!

> ---
>  drivers/net/virtio_net.c | 42 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 38 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8a5810bcb839..40532ecbe7fc 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3208,6 +3208,29 @@ static unsigned int mergeable_min_buf_len(struct virtnet_info *vi, struct virtqu
>  		   (unsigned int)GOOD_PACKET_LEN);
>  }
>  
> +static void virtnet_config_sizes(struct virtnet_info *vi, u32 *sizes)
> +{
> +	u32 i, rx_size, tx_size;
> +
> +	if (vi->speed == SPEED_UNKNOWN || vi->speed < SPEED_10000) {
> +		rx_size = 1024;
> +		tx_size = 1024;
> +
> +	} else if (vi->speed < SPEED_40000) {
> +		rx_size = 1024 * 4;
> +		tx_size = 1024 * 4;
> +
> +	} else {
> +		rx_size = 1024 * 8;
> +		tx_size = 1024 * 8;
> +	}
> +
> +	for (i = 0; i < vi->max_queue_pairs; i++) {
> +		sizes[rxq2vq(i)] = rx_size;
> +		sizes[txq2vq(i)] = tx_size;
> +	}
> +}
> +
>  static int virtnet_find_vqs(struct virtnet_info *vi)
>  {
>  	vq_callback_t **callbacks;
> @@ -3215,6 +3238,7 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
>  	int ret = -ENOMEM;
>  	int i, total_vqs;
>  	const char **names;
> +	u32 *sizes;
>  	bool *ctx;
>  
>  	/* We expect 1 RX virtqueue followed by 1 TX virtqueue, followed by
> @@ -3242,10 +3266,15 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
>  		ctx = NULL;
>  	}
>  
> +	sizes = kmalloc_array(total_vqs, sizeof(*sizes), GFP_KERNEL);
> +	if (!sizes)
> +		goto err_sizes;
> +
>  	/* Parameters for control virtqueue, if any */
>  	if (vi->has_cvq) {
>  		callbacks[total_vqs - 1] = NULL;
>  		names[total_vqs - 1] = "control";
> +		sizes[total_vqs - 1] = 64;
>  	}
>  
>  	/* Allocate/initialize parameters for send/receive virtqueues */
> @@ -3260,8 +3289,10 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
>  			ctx[rxq2vq(i)] = true;
>  	}
>  
> -	ret = virtio_find_vqs_ctx(vi->vdev, total_vqs, vqs, callbacks,
> -				  names, ctx, NULL);
> +	virtnet_config_sizes(vi, sizes);
> +
> +	ret = virtio_find_vqs_ctx_size(vi->vdev, total_vqs, vqs, callbacks,
> +				       names, sizes, ctx, NULL);
>  	if (ret)
>  		goto err_find;
>  
> @@ -3281,6 +3312,8 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
>  
>  
>  err_find:
> +	kfree(sizes);
> +err_sizes:
>  	kfree(ctx);
>  err_ctx:
>  	kfree(names);
> @@ -3630,6 +3663,9 @@ static int virtnet_probe(struct virtio_device *vdev)
>  		vi->curr_queue_pairs = num_online_cpus();
>  	vi->max_queue_pairs = max_queue_pairs;
>  
> +	virtnet_init_settings(dev);
> +	virtnet_update_settings(vi);
> +
>  	/* Allocate/initialize the rx/tx queues, and invoke find_vqs */
>  	err = init_vqs(vi);
>  	if (err)
> @@ -3642,8 +3678,6 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	netif_set_real_num_tx_queues(dev, vi->curr_queue_pairs);
>  	netif_set_real_num_rx_queues(dev, vi->curr_queue_pairs);
>  
> -	virtnet_init_settings(dev);
> -
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_STANDBY)) {
>  		vi->failover = net_failover_create(vi->dev);
>  		if (IS_ERR(vi->failover)) {
> -- 
> 2.31.0

