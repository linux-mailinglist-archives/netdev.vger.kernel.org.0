Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F199F57FA6F
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 09:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiGYHq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 03:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiGYHqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 03:46:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 20D711275D
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 00:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658735210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eMlcbANKfJle3FD3sp54e/O4tglNGsQHuCzPBZAyo74=;
        b=YNF+K+kjlZQ1yAiAJavBCvadPt8ZpswUEma3X8PwUUX0Q/mRUVr08Pt22zjM+YcUOgN0ev
        IrQMxOhR2uYv2QPq0wUU4K1te1OWaRrdwq1LLezboGI6B/NaCe9zUFOmW7zdm9lZ5IqlOZ
        6q9bElwn4b8C19Y26V9bUgXZiVhRuew=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-89bOFr7uM7OfoAGI3kAnrQ-1; Mon, 25 Jul 2022 03:46:48 -0400
X-MC-Unique: 89bOFr7uM7OfoAGI3kAnrQ-1
Received: by mail-wm1-f70.google.com with SMTP id ay19-20020a05600c1e1300b003a315c2c1c0so8293723wmb.7
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 00:46:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=eMlcbANKfJle3FD3sp54e/O4tglNGsQHuCzPBZAyo74=;
        b=SKSP/czUrQv5uxURJIUhXFrB42HlO1L5jks1uQbF6abERqnKEAYc+8NgMMhumjjZ8B
         Z7hioZDI6ea61Qfu0TMGXVuLnGgeZUapqy3M+T9mQoX2JqknRWa8rR1m8Xx9jq0W9rXN
         UMBI6eLoMy/gh4rX52SAs5uEWHBEoHrNeGqXFkNEdCJlbvpB6oR0paSRrkJgiWiLgQ8j
         S+kEXDGFjpoaeUGHDHsUWOwMmyxeEMuJ2rxfo8YX/Jy0wpfxFRVjuWeaI5Qkif8M2Nx0
         ZIon07Ew15XI4ACkDeXPU3E9xE07Q4wx2XukP91Om85s1WUkwH4DcCwwJeeQkgfONilu
         Ha3A==
X-Gm-Message-State: AJIora8ZRN7Oynrso2ZvMQMLWiVh6GTOGwYVVbn895b6oM4fc0YsO8RV
        73WR8tXdQJT6PZXaTLR2lU6pzlpAX4NQBLkqd2ElwZgBxPifCdFzdVd4fYWfJFF/p9/Usmll8rm
        P+qbjPef5w1b4F1X1
X-Received: by 2002:a05:6000:2a8:b0:21d:8c81:7eb0 with SMTP id l8-20020a05600002a800b0021d8c817eb0mr6637329wry.460.1658735206810;
        Mon, 25 Jul 2022 00:46:46 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uGAeaP6zG5DACZXn3IdfwA62T9sMZ4jbNP6FGASI/iTgfCErmmuIHtpCle49XWZvsGwGlhNA==
X-Received: by 2002:a05:6000:2a8:b0:21d:8c81:7eb0 with SMTP id l8-20020a05600002a800b0021d8c817eb0mr6637306wry.460.1658735206495;
        Mon, 25 Jul 2022 00:46:46 -0700 (PDT)
Received: from redhat.com ([2.55.46.46])
        by smtp.gmail.com with ESMTPSA id d5-20020adff845000000b0021dd08ad8d7sm11473081wrq.46.2022.07.25.00.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 00:46:45 -0700 (PDT)
Date:   Mon, 25 Jul 2022 03:46:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH V6] virtio-net: fix the race between refill work and close
Message-ID: <20220725034545-mutt-send-email-mst@kernel.org>
References: <20220725072159.3577-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725072159.3577-1-jasowang@redhat.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 03:21:59PM +0800, Jason Wang wrote:
> We try using cancel_delayed_work_sync() to prevent the work from
> enabling NAPI. This is insufficient since we don't disable the source
> of the refill work scheduling. This means an NAPI poll callback after
> cancel_delayed_work_sync() can schedule the refill work then can
> re-enable the NAPI that leads to use-after-free [1].
> 
> Since the work can enable NAPI, we can't simply disable NAPI before
> calling cancel_delayed_work_sync(). So fix this by introducing a
> dedicated boolean to control whether or not the work could be
> scheduled from NAPI.
> 
> [1]
> ==================================================================
> BUG: KASAN: use-after-free in refill_work+0x43/0xd4
> Read of size 2 at addr ffff88810562c92e by task kworker/2:1/42
> 
> CPU: 2 PID: 42 Comm: kworker/2:1 Not tainted 5.19.0-rc1+ #480
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> Workqueue: events refill_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x34/0x44
>  print_report.cold+0xbb/0x6ac
>  ? _printk+0xad/0xde
>  ? refill_work+0x43/0xd4
>  kasan_report+0xa8/0x130
>  ? refill_work+0x43/0xd4
>  refill_work+0x43/0xd4
>  process_one_work+0x43d/0x780
>  worker_thread+0x2a0/0x6f0
>  ? process_one_work+0x780/0x780
>  kthread+0x167/0x1a0
>  ? kthread_exit+0x50/0x50
>  ret_from_fork+0x22/0x30
>  </TASK>
> ...
> 
> Fixes: b2baed69e605c ("virtio_net: set/cancel work on ndo_open/ndo_stop")
> Signed-off-by: Jason Wang <jasowang@redhat.com>

That's very clean, thanks!

Acked-by: Michael S. Tsirkin <mst@redhat.com>



> ---
>  drivers/net/virtio_net.c | 37 ++++++++++++++++++++++++++++++++++---
>  1 file changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 356cf8dd4164..ec8e1b3108c3 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -242,9 +242,15 @@ struct virtnet_info {
>  	/* Packet virtio header size */
>  	u8 hdr_len;
>  
> -	/* Work struct for refilling if we run low on memory. */
> +	/* Work struct for delayed refilling if we run low on memory. */
>  	struct delayed_work refill;
>  
> +	/* Is delayed refill enabled? */
> +	bool refill_enabled;
> +
> +	/* The lock to synchronize the access to refill_enabled */
> +	spinlock_t refill_lock;
> +
>  	/* Work struct for config space updates */
>  	struct work_struct config_work;
>  
> @@ -348,6 +354,20 @@ static struct page *get_a_page(struct receive_queue *rq, gfp_t gfp_mask)
>  	return p;
>  }
>  
> +static void enable_delayed_refill(struct virtnet_info *vi)
> +{
> +	spin_lock_bh(&vi->refill_lock);
> +	vi->refill_enabled = true;
> +	spin_unlock_bh(&vi->refill_lock);
> +}
> +
> +static void disable_delayed_refill(struct virtnet_info *vi)
> +{
> +	spin_lock_bh(&vi->refill_lock);
> +	vi->refill_enabled = false;
> +	spin_unlock_bh(&vi->refill_lock);
> +}
> +
>  static void virtqueue_napi_schedule(struct napi_struct *napi,
>  				    struct virtqueue *vq)
>  {
> @@ -1527,8 +1547,12 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
>  	}
>  
>  	if (rq->vq->num_free > min((unsigned int)budget, virtqueue_get_vring_size(rq->vq)) / 2) {
> -		if (!try_fill_recv(vi, rq, GFP_ATOMIC))
> -			schedule_delayed_work(&vi->refill, 0);
> +		if (!try_fill_recv(vi, rq, GFP_ATOMIC)) {
> +			spin_lock(&vi->refill_lock);
> +			if (vi->refill_enabled)
> +				schedule_delayed_work(&vi->refill, 0);
> +			spin_unlock(&vi->refill_lock);
> +		}
>  	}
>  
>  	u64_stats_update_begin(&rq->stats.syncp);
> @@ -1651,6 +1675,8 @@ static int virtnet_open(struct net_device *dev)
>  	struct virtnet_info *vi = netdev_priv(dev);
>  	int i, err;
>  
> +	enable_delayed_refill(vi);
> +
>  	for (i = 0; i < vi->max_queue_pairs; i++) {
>  		if (i < vi->curr_queue_pairs)
>  			/* Make sure we have some buffers: if oom use wq. */
> @@ -2033,6 +2059,8 @@ static int virtnet_close(struct net_device *dev)
>  	struct virtnet_info *vi = netdev_priv(dev);
>  	int i;
>  
> +	/* Make sure NAPI doesn't schedule refill work */
> +	disable_delayed_refill(vi);
>  	/* Make sure refill_work doesn't re-enable napi! */
>  	cancel_delayed_work_sync(&vi->refill);
>  
> @@ -2792,6 +2820,8 @@ static int virtnet_restore_up(struct virtio_device *vdev)
>  
>  	virtio_device_ready(vdev);
>  
> +	enable_delayed_refill(vi);
> +
>  	if (netif_running(vi->dev)) {
>  		err = virtnet_open(vi->dev);
>  		if (err)
> @@ -3535,6 +3565,7 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	vdev->priv = vi;
>  
>  	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
> +	spin_lock_init(&vi->refill_lock);
>  
>  	/* If we can receive ANY GSO packets, we must allocate large ones. */
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> -- 
> 2.25.1

