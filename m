Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6238857FA2D
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 09:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbiGYHXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 03:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiGYHXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 03:23:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C1C48BE05
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 00:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658733815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5gVPZ15oKTx4YFpWtn7iRcbivnFTQaA0UE6DVIGy5xk=;
        b=A/iScEkeF8i9VhdhA+TZw4CXLCluepPvuuJbpoBT+FXwl9WXkDHiGQAX1UKo8GKurEmZ/D
        0dsbIe6l024sWF2lA3CD1AUa9qDqccVuBWIv6qiAye0rc4LruV7OsZpGx3vRPWHxmbJ2Ud
        foi+PQ6cP+Lf6HqyjVjqIj+GFbtdmAo=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-crcwr5M9O1yn-zpWBofJbw-1; Mon, 25 Jul 2022 03:23:34 -0400
X-MC-Unique: crcwr5M9O1yn-zpWBofJbw-1
Received: by mail-lj1-f200.google.com with SMTP id u7-20020a2e2e07000000b0025e08e5df3cso541148lju.10
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 00:23:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5gVPZ15oKTx4YFpWtn7iRcbivnFTQaA0UE6DVIGy5xk=;
        b=nu5x30PVznigDf4u8X0MgO8HalhETGH0f0zj02B3/BLnFc4p54MHUCUtFlnAZJK0aq
         Utf2VN0Xf8iXaPniyQGbgpfXMYg9U3oEyo6Oxr1XdagXpJYhk873m0YvIRpq+/tI+irZ
         30Apj9DjBZMQk0wV+IFoEOm/cOPnkTBjHxjC/jR5C+GG3m4lpH6H/27+4OScWk+uf1mZ
         5370s8pA0R21rw3uMGKRz4JX9zJPbO/TPv0E5PXxFkjrLPVBpUsdbmj01t6/qEMFVCNn
         cEABGDQBtWYuxPyEXjDSOeWb23lCSWwvlzoW1RZKSXVWCRn421yyNpeCCkZRl+Nj6lc/
         zqRA==
X-Gm-Message-State: AJIora/9xZNf1UzwosOjvTp9S0U0Ma7JhgG11/K0rE7Ih3Po6R8K6eij
        +w1UMK+bTFOerBuJJbbLHEkaQkmZ8UKa60ZvPLSEP+3yBN1Gv2h4FCe9IgoqaBknZK1FOO9PQQP
        oEF11FoP7ajwluOKohQ7m4NfCi3hMxYsM
X-Received: by 2002:a2e:b0c6:0:b0:25e:b20:94b4 with SMTP id g6-20020a2eb0c6000000b0025e0b2094b4mr604807ljl.487.1658733812282;
        Mon, 25 Jul 2022 00:23:32 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1te2mwKhOtT3UYsmRdLN7AeAgWGsddnz/jqMInfJgM2ZT9nSU3vKd86uko01AypSbRhO202uE9MtHg24X1xnvI=
X-Received: by 2002:a2e:b0c6:0:b0:25e:b20:94b4 with SMTP id
 g6-20020a2eb0c6000000b0025e0b2094b4mr604800ljl.487.1658733812056; Mon, 25 Jul
 2022 00:23:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220725072159.3577-1-jasowang@redhat.com>
In-Reply-To: <20220725072159.3577-1-jasowang@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 25 Jul 2022 15:23:21 +0800
Message-ID: <CACGkMEs9qaT6jskNcqtjzMnMAMj1=U9h_+n+XSpT7GBaY38jrQ@mail.gmail.com>
Subject: Re: [PATCH V6] virtio-net: fix the race between refill work and close
To:     mst <mst@redhat.com>, davem <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 3:22 PM Jason Wang <jasowang@redhat.com> wrote:
>
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

In case this is not too late, the patch is for -net. (otherwise i can repost).

Thanks

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
>  drivers/net/virtio_net.c | 37 ++++++++++++++++++++++++++++++++++---
>  1 file changed, 34 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 356cf8dd4164..ec8e1b3108c3 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -242,9 +242,15 @@ struct virtnet_info {
>         /* Packet virtio header size */
>         u8 hdr_len;
>
> -       /* Work struct for refilling if we run low on memory. */
> +       /* Work struct for delayed refilling if we run low on memory. */
>         struct delayed_work refill;
>
> +       /* Is delayed refill enabled? */
> +       bool refill_enabled;
> +
> +       /* The lock to synchronize the access to refill_enabled */
> +       spinlock_t refill_lock;
> +
>         /* Work struct for config space updates */
>         struct work_struct config_work;
>
> @@ -348,6 +354,20 @@ static struct page *get_a_page(struct receive_queue *rq, gfp_t gfp_mask)
>         return p;
>  }
>
> +static void enable_delayed_refill(struct virtnet_info *vi)
> +{
> +       spin_lock_bh(&vi->refill_lock);
> +       vi->refill_enabled = true;
> +       spin_unlock_bh(&vi->refill_lock);
> +}
> +
> +static void disable_delayed_refill(struct virtnet_info *vi)
> +{
> +       spin_lock_bh(&vi->refill_lock);
> +       vi->refill_enabled = false;
> +       spin_unlock_bh(&vi->refill_lock);
> +}
> +
>  static void virtqueue_napi_schedule(struct napi_struct *napi,
>                                     struct virtqueue *vq)
>  {
> @@ -1527,8 +1547,12 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
>         }
>
>         if (rq->vq->num_free > min((unsigned int)budget, virtqueue_get_vring_size(rq->vq)) / 2) {
> -               if (!try_fill_recv(vi, rq, GFP_ATOMIC))
> -                       schedule_delayed_work(&vi->refill, 0);
> +               if (!try_fill_recv(vi, rq, GFP_ATOMIC)) {
> +                       spin_lock(&vi->refill_lock);
> +                       if (vi->refill_enabled)
> +                               schedule_delayed_work(&vi->refill, 0);
> +                       spin_unlock(&vi->refill_lock);
> +               }
>         }
>
>         u64_stats_update_begin(&rq->stats.syncp);
> @@ -1651,6 +1675,8 @@ static int virtnet_open(struct net_device *dev)
>         struct virtnet_info *vi = netdev_priv(dev);
>         int i, err;
>
> +       enable_delayed_refill(vi);
> +
>         for (i = 0; i < vi->max_queue_pairs; i++) {
>                 if (i < vi->curr_queue_pairs)
>                         /* Make sure we have some buffers: if oom use wq. */
> @@ -2033,6 +2059,8 @@ static int virtnet_close(struct net_device *dev)
>         struct virtnet_info *vi = netdev_priv(dev);
>         int i;
>
> +       /* Make sure NAPI doesn't schedule refill work */
> +       disable_delayed_refill(vi);
>         /* Make sure refill_work doesn't re-enable napi! */
>         cancel_delayed_work_sync(&vi->refill);
>
> @@ -2792,6 +2820,8 @@ static int virtnet_restore_up(struct virtio_device *vdev)
>
>         virtio_device_ready(vdev);
>
> +       enable_delayed_refill(vi);
> +
>         if (netif_running(vi->dev)) {
>                 err = virtnet_open(vi->dev);
>                 if (err)
> @@ -3535,6 +3565,7 @@ static int virtnet_probe(struct virtio_device *vdev)
>         vdev->priv = vi;
>
>         INIT_WORK(&vi->config_work, virtnet_config_changed_work);
> +       spin_lock_init(&vi->refill_lock);
>
>         /* If we can receive ANY GSO packets, we must allocate large ones. */
>         if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> --
> 2.25.1
>

