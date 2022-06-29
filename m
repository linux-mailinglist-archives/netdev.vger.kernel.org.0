Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4ADB55F90C
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 09:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbiF2H3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 03:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbiF2H3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 03:29:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4BDD81E3C6
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 00:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656487742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xiRibrSvAoM6W9wAB2ExJi4FE4mfhgvmaHhoHqyyRbM=;
        b=gB8Nql5SXNsUF6dmmVpG5I5KMaKTIKSpoNciiNgJTaEOMsPXFuUnkJjNiUu3E6zhaygM9E
        MP8N1GCUkOh9++ikGljJciW4Z+1M4ymQUzOjzL5nlpclowjfdMgCGqLZQVkXnnwtaql1MX
        IVnuXscDbaor8X0lBnWPN9Fmi2LRKvk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-If3hwZgLOj2QlCVpwLgXUQ-1; Wed, 29 Jun 2022 03:29:00 -0400
X-MC-Unique: If3hwZgLOj2QlCVpwLgXUQ-1
Received: by mail-wm1-f71.google.com with SMTP id j35-20020a05600c1c2300b003a167dfa0ecso513827wms.5
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 00:29:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xiRibrSvAoM6W9wAB2ExJi4FE4mfhgvmaHhoHqyyRbM=;
        b=XiB7yisuRVSIhcr3yyb9/Zmb4R4bbufiknvGkzZXSMwLwZIOhaTNE28b808njMIQM2
         lYIcreTtiy5ESshcFaU2UGpDCpF0zCQI9/ykQribhjY2kgFpLE7c9A7Bd6er5e2CQyTi
         vpLZu+z03kqi4qvBXGQziPKwDk6+yKAyvp+HaXn5W05PCtODDMTtKc3KT1+07PBUm16j
         Q++LkQ0H7n5JYEMFN7NjbdihMp/0sUHjgU3GWnpiyeRNHzickfVvWTGjEnI0PBsGl4Rj
         21hyocbAqcFe5I8FRQQ/1eMSlyNll8gUBIdGR0XA8H75SqsJ82wLF8kKEkC2F5xwNq+m
         5XJQ==
X-Gm-Message-State: AJIora+3W3WfPG3UtYlRaxWpA2dPbGC2OyW3+SeavXZ6YUUzbdSFlbOV
        p7cvwqNDBIlg+276w8Yk5JQL/vB6jMBhSpFkh+tnzYQAlIN0/XUC1V2FWMKWhBaroztLHf74dP0
        i69CAMsKOHGsduWKm
X-Received: by 2002:a7b:cf18:0:b0:3a0:54b3:d848 with SMTP id l24-20020a7bcf18000000b003a054b3d848mr2058473wmg.3.1656487738711;
        Wed, 29 Jun 2022 00:28:58 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tfysaLsrnPck1jxZb3L9c6KAMx3q01zMPf4AMhC3h7kyffbacEWnGaGpxGMi+HZGbpOMCBGQ==
X-Received: by 2002:a7b:cf18:0:b0:3a0:54b3:d848 with SMTP id l24-20020a7bcf18000000b003a054b3d848mr2058448wmg.3.1656487738440;
        Wed, 29 Jun 2022 00:28:58 -0700 (PDT)
Received: from redhat.com ([2.52.23.204])
        by smtp.gmail.com with ESMTPSA id u3-20020a05600c210300b003a044fe7fe7sm2075973wml.9.2022.06.29.00.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 00:28:57 -0700 (PDT)
Date:   Wed, 29 Jun 2022 03:28:53 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-net: fix the race between refill work and close
Message-ID: <20220629032106-mutt-send-email-mst@kernel.org>
References: <20220628090324.62219-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628090324.62219-1-jasowang@redhat.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 05:03:24PM +0800, Jason Wang wrote:
> We try using cancel_delayed_work_sync() to prevent the work from
> enabling NAPI. This is insufficient since we don't disable the the
> source the scheduling

can't parse this sentence

> of the refill work. This means an NAPI

what do you mean "an NAPI"? a NAPI poll callback?

> after
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
> ---
>  drivers/net/virtio_net.c | 38 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index db05b5e930be..21bf1e5c81ef 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -251,6 +251,12 @@ struct virtnet_info {
>  	/* Does the affinity hint is set for virtqueues? */
>  	bool affinity_hint_set;
>  
> +	/* Is refill work enabled? */
> +	bool refill_work_enabled;
> +
> +	/* The lock to synchronize the access to refill_work_enabled */
> +	spinlock_t refill_lock;
> +
>  	/* CPU hotplug instances for online & dead */
>  	struct hlist_node node;
>  	struct hlist_node node_dead;
> @@ -348,6 +354,20 @@ static struct page *get_a_page(struct receive_queue *rq, gfp_t gfp_mask)
>  	return p;
>  }
>  
> +static void enable_refill_work(struct virtnet_info *vi)
> +{
> +	spin_lock(&vi->refill_lock);
> +	vi->refill_work_enabled = true;
> +	spin_unlock(&vi->refill_lock);
> +}
> +
> +static void disable_refill_work(struct virtnet_info *vi)
> +{
> +	spin_lock(&vi->refill_lock);
> +	vi->refill_work_enabled = false;
> +	spin_unlock(&vi->refill_lock);
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
> +			if (vi->refill_work_enabled)
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
> +	enable_refill_work(vi);
> +
>  	for (i = 0; i < vi->max_queue_pairs; i++) {
>  		if (i < vi->curr_queue_pairs)
>  			/* Make sure we have some buffers: if oom use wq. */
> @@ -2033,6 +2059,8 @@ static int virtnet_close(struct net_device *dev)
>  	struct virtnet_info *vi = netdev_priv(dev);
>  	int i;
>  
> +	/* Make sure NAPI doesn't schedule refill work */
> +	disable_refill_work(vi);
>  	/* Make sure refill_work doesn't re-enable napi! */
>  	cancel_delayed_work_sync(&vi->refill);
>  
> @@ -2776,6 +2804,9 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
>  	netif_tx_lock_bh(vi->dev);
>  	netif_device_detach(vi->dev);
>  	netif_tx_unlock_bh(vi->dev);
> +	/* Make sure NAPI doesn't schedule refill work */
> +	disable_refill_work(vi);
> +	/* Make sure refill_work doesn't re-enable napi! */
>  	cancel_delayed_work_sync(&vi->refill);
>  
>  	if (netif_running(vi->dev)) {
> @@ -2799,6 +2830,8 @@ static int virtnet_restore_up(struct virtio_device *vdev)
>  
>  	virtio_device_ready(vdev);
>  
> +	enable_refill_work(vi);
> +
>  	if (netif_running(vi->dev)) {
>  		for (i = 0; i < vi->curr_queue_pairs; i++)
>  			if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
> @@ -3548,6 +3581,7 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	vdev->priv = vi;
>  
>  	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
> +	spin_lock_init(&vi->refill_lock);
>  
>  	/* If we can receive ANY GSO packets, we must allocate large ones. */
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||


Can't say I love all the extra state but oh well.

> -- 
> 2.25.1

