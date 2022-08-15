Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3464B595250
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 08:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiHPGEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 02:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiHPGDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 02:03:49 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B022C2E19CD;
        Mon, 15 Aug 2022 16:36:24 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id ha11so8262108pjb.2;
        Mon, 15 Aug 2022 16:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=jXfmFWyPTI+/X9q6YSHrJyPzaAFzd5pRVR1VGmA59ow=;
        b=ZUpPnnTP2SeMrbSXwPX7TejLi5n/sg43tnIuviaoBDPf7szFy14G/Zm/d34T16qUeV
         tU9ym01zECetIx2f/W5H651WscbCumYf3f3L9u2Mmqf2kJ1g+l4TvGDNh9X3GWZdtjr3
         PxLVyDsbcz3zvyLyiTuVSCkcYJOJWifqML0hzBaFvU4xbhdaDq6+zxdCNZZTWV7lHMXs
         pWggQ/K4SKGSJID46FK3VA7StW/Vga2++z50+dGb7X33RU5w+Zs13ehrcVlCuoJ42txk
         XbMIJWcmqsI9Wo3ymQnnJUWGUEUqNFSbrgJvY/WxEwdY5bmR9fqSQ03LPs/pyN/hffDt
         8xhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=jXfmFWyPTI+/X9q6YSHrJyPzaAFzd5pRVR1VGmA59ow=;
        b=Kd35td+R9AWG3wPulBKYQRz6dO3UA0kRQWHoHFI8CankTUdxtstje4UkngImEHg+kE
         FmsOxvf9CQOea+G15f5gNxMCEiHnZfx28Ca6FcHMGSdK7k4l2JK+G5gLMjwGNTGF00Wh
         ka4Pj+OTvt9Z3xXsVAxsK04nPkN09jviWMlYjuDfIorXQ1b1VmNtgqMpqVCaG8m71nQh
         xXvoQhtEesAWlf7Jw/yYu1nmefOwHCbu2lnAFDGyPmvzU/AA74ixrZ7w7UXEXcDBKblo
         Eo2PUodn8dofM7xDc/kt/BwIFmOQPxLb1yrrhi+K4iwIxehE4JY49lWouCMzxziKYPo7
         ePkQ==
X-Gm-Message-State: ACgBeo070RquXtOtNX488T3a8tNCqxIXaL6lqvPscZRavOqeulGadp4u
        tpUmQVB3HAwX791IY+ZAnT8=
X-Google-Smtp-Source: AA6agR4i/Lselxo0AHv145hK8gytkCZZZ32/Q8nJ7bBvGMnJ7eQAw+KQLokHJ1E+lcUggJFlO4NT0w==
X-Received: by 2002:a17:903:11cd:b0:170:cde8:18b7 with SMTP id q13-20020a17090311cd00b00170cde818b7mr19364760plh.165.1660606583904;
        Mon, 15 Aug 2022 16:36:23 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q3-20020a17090a304300b001f2c22fa4ddsm4959475pjl.50.2022.08.15.16.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 16:36:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 15 Aug 2022 16:36:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andres Freund <andres@anarazel.de>
Subject: Re: [PATCH v3 1/5] virtio_net: Revert "virtio_net: set the default
 max ring size by find_vqs()"
Message-ID: <20220815233618.GA653119@roeck-us.net>
References: <20220815215938.154999-1-mst@redhat.com>
 <20220815215938.154999-2-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815215938.154999-2-mst@redhat.com>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 06:00:25PM -0400, Michael S. Tsirkin wrote:
> This reverts commit 762faee5a2678559d3dc09d95f8f2c54cd0466a7.
> 
> This has been reported to trip up guests on GCP (Google Cloud).
> The reason is that virtio_find_vqs_ctx_size is broken on legacy
> devices. We can in theory fix virtio_find_vqs_ctx_size but
> in fact the patch itself has several other issues:
> 
> - It treats unknown speed as < 10G
> - It leaves userspace no way to find out the ring size set by hypervisor
> - It tests speed when link is down
> - It ignores the virtio spec advice:
>         Both \field{speed} and \field{duplex} can change, thus the driver
>         is expected to re-read these values after receiving a
>         configuration change notification.
> - It is not clear the performance impact has been tested properly
> 
> Revert the patch for now.
> 
> Reported-by: Andres Freund <andres@anarazel.de>
> Link: https://lore.kernel.org/r/20220814212610.GA3690074%40roeck-us.net
> Link: https://lore.kernel.org/r/20220815070203.plwjx7b3cyugpdt7%40awork3.anarazel.de
> Link: https://lore.kernel.org/r/3df6bb82-1951-455d-a768-e9e1513eb667%40www.fastmail.com
> Link: https://lore.kernel.org/r/FCDC5DDE-3CDD-4B8A-916F-CA7D87B547CE%40anarazel.de
> Fixes: 762faee5a267 ("virtio_net: set the default max ring size by find_vqs()")
> Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Tested-by: Andres Freund <andres@anarazel.de>
> Tested-by: From: Guenter Roeck <linux@roeck-us.net>

s/From: //

> ---
>  drivers/net/virtio_net.c | 42 ++++------------------------------------
>  1 file changed, 4 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index d934774e9733..ece00b84e3a7 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3432,29 +3432,6 @@ static unsigned int mergeable_min_buf_len(struct virtnet_info *vi, struct virtqu
>  		   (unsigned int)GOOD_PACKET_LEN);
>  }
>  
> -static void virtnet_config_sizes(struct virtnet_info *vi, u32 *sizes)
> -{
> -	u32 i, rx_size, tx_size;
> -
> -	if (vi->speed == SPEED_UNKNOWN || vi->speed < SPEED_10000) {
> -		rx_size = 1024;
> -		tx_size = 1024;
> -
> -	} else if (vi->speed < SPEED_40000) {
> -		rx_size = 1024 * 4;
> -		tx_size = 1024 * 4;
> -
> -	} else {
> -		rx_size = 1024 * 8;
> -		tx_size = 1024 * 8;
> -	}
> -
> -	for (i = 0; i < vi->max_queue_pairs; i++) {
> -		sizes[rxq2vq(i)] = rx_size;
> -		sizes[txq2vq(i)] = tx_size;
> -	}
> -}
> -
>  static int virtnet_find_vqs(struct virtnet_info *vi)
>  {
>  	vq_callback_t **callbacks;
> @@ -3462,7 +3439,6 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
>  	int ret = -ENOMEM;
>  	int i, total_vqs;
>  	const char **names;
> -	u32 *sizes;
>  	bool *ctx;
>  
>  	/* We expect 1 RX virtqueue followed by 1 TX virtqueue, followed by
> @@ -3490,15 +3466,10 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
>  		ctx = NULL;
>  	}
>  
> -	sizes = kmalloc_array(total_vqs, sizeof(*sizes), GFP_KERNEL);
> -	if (!sizes)
> -		goto err_sizes;
> -
>  	/* Parameters for control virtqueue, if any */
>  	if (vi->has_cvq) {
>  		callbacks[total_vqs - 1] = NULL;
>  		names[total_vqs - 1] = "control";
> -		sizes[total_vqs - 1] = 64;
>  	}
>  
>  	/* Allocate/initialize parameters for send/receive virtqueues */
> @@ -3513,10 +3484,8 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
>  			ctx[rxq2vq(i)] = true;
>  	}
>  
> -	virtnet_config_sizes(vi, sizes);
> -
> -	ret = virtio_find_vqs_ctx_size(vi->vdev, total_vqs, vqs, callbacks,
> -				       names, sizes, ctx, NULL);
> +	ret = virtio_find_vqs_ctx(vi->vdev, total_vqs, vqs, callbacks,
> +				  names, ctx, NULL);
>  	if (ret)
>  		goto err_find;
>  
> @@ -3536,8 +3505,6 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
>  
>  
>  err_find:
> -	kfree(sizes);
> -err_sizes:
>  	kfree(ctx);
>  err_ctx:
>  	kfree(names);
> @@ -3897,9 +3864,6 @@ static int virtnet_probe(struct virtio_device *vdev)
>  		vi->curr_queue_pairs = num_online_cpus();
>  	vi->max_queue_pairs = max_queue_pairs;
>  
> -	virtnet_init_settings(dev);
> -	virtnet_update_settings(vi);
> -
>  	/* Allocate/initialize the rx/tx queues, and invoke find_vqs */
>  	err = init_vqs(vi);
>  	if (err)
> @@ -3912,6 +3876,8 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	netif_set_real_num_tx_queues(dev, vi->curr_queue_pairs);
>  	netif_set_real_num_rx_queues(dev, vi->curr_queue_pairs);
>  
> +	virtnet_init_settings(dev);
> +
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_STANDBY)) {
>  		vi->failover = net_failover_create(vi->dev);
>  		if (IS_ERR(vi->failover)) {
> -- 
> MST
> 
