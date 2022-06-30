Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFFF560EE9
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 04:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiF3CC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 22:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiF3CCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 22:02:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C06153B28C
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 19:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656554573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J/UlDUYLqcigwLE0YX1GEgm9aBSIjsFv7Xe/qygcons=;
        b=iuP7n8wI4pManZONehuWxadCWt/II13GXnoJ0GKHtXdq5wtUZxRW1QaeE4kaH2n3PLBrCq
        /wTgfpXCBfwsii2quZKi6jdJBFLNfLnRI8QwaaqxhDWbxyfn4VfFzyPJlirDin8AIYSl6n
        SX+f1khr3hgbzqcufLXXzcV+gPCFdAQ=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-DCvOmG0rPKCKZbCbx3x_Qw-1; Wed, 29 Jun 2022 22:02:52 -0400
X-MC-Unique: DCvOmG0rPKCKZbCbx3x_Qw-1
Received: by mail-lf1-f70.google.com with SMTP id z13-20020a056512308d00b004811694f893so5384859lfd.6
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 19:02:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J/UlDUYLqcigwLE0YX1GEgm9aBSIjsFv7Xe/qygcons=;
        b=D/7mdu8xZafG95fXFJs5CUDT7pqvaAI+bh09PD/yKa0vc7zsl5T2PWB54cS2Qwfj/U
         K/qMDFY2M7+zorwE3W/L4b/XC/YVp9GAaIhjeKnil636DsMZrSeyxnBdWP6Sm9TQI8zo
         tJFgGqLNsbdLidZoixAUW3x4Flpggfzbi2cmncxmpc7xwa6Lvos+ZfNL6T7UI6GZgs/z
         H3N4jnzLIOzoVonrnF7dwP51UybmyeXdzV2VWNjFZU6G8q9bfwaDRaaDALGoa1hntwL/
         LGRGhZroG/MZxREI8TJELXNbejWtDRSef8NDYivDFouSwOWeNw7xgYsxt2Ix5h3oZv6g
         rDlw==
X-Gm-Message-State: AJIora8F3rCabjw1xj2rhAJ6QokgLO8Ok5czxNwYNeShLM2aqpfbqSwh
        /UVlidlqsExkzZwSAzPKmY7VT3nrjdzZuKrJIUzGoO779/8h+MqaYu0rNetcOTQrKe8OfpufZy5
        ofre4w3mT/SKdpOnV9PdNd4/+o/kWamuw
X-Received: by 2002:a05:6512:ba1:b0:47f:c0bd:7105 with SMTP id b33-20020a0565120ba100b0047fc0bd7105mr4189908lfv.641.1656554570228;
        Wed, 29 Jun 2022 19:02:50 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vNWTkihH6pkvrKBypqbOdBygONDjZHT10055+uG0wsOWlT9KEnhkOxnH/nAVszCO8LguXU0b09dd97g9Blvrs=
X-Received: by 2002:a05:6512:ba1:b0:47f:c0bd:7105 with SMTP id
 b33-20020a0565120ba100b0047fc0bd7105mr4189900lfv.641.1656554569999; Wed, 29
 Jun 2022 19:02:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220628090324.62219-1-jasowang@redhat.com> <20220629032106-mutt-send-email-mst@kernel.org>
 <CACGkMEutEYHf8kO_6gpk5BrMAndJPd8wDAPG2_Z9pxSiXXNDCw@mail.gmail.com> <20220629044316-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220629044316-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 30 Jun 2022 10:02:38 +0800
Message-ID: <CACGkMEu5cHnPn737UCzEtuNh8WA8kjMn2irfowpRacGTWu8SXw@mail.gmail.com>
Subject: Re: [PATCH] virtio-net: fix the race between refill work and close
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 4:45 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Jun 29, 2022 at 04:36:12PM +0800, Jason Wang wrote:
> > On Wed, Jun 29, 2022 at 3:29 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Tue, Jun 28, 2022 at 05:03:24PM +0800, Jason Wang wrote:
> > > > We try using cancel_delayed_work_sync() to prevent the work from
> > > > enabling NAPI. This is insufficient since we don't disable the the
> > > > source the scheduling
> > >
> > > can't parse this sentence
> >
> > I actually meant "we don't disable the source of the refill work scheduling".
> >
> > >
> > > > of the refill work. This means an NAPI
> > >
> > > what do you mean "an NAPI"? a NAPI poll callback?
> >
> > Yes.
>
> pls post with a fixed log then.

Yes.

>
> > >
> > > > after
> > > > cancel_delayed_work_sync() can schedule the refill work then can
> > > > re-enable the NAPI that leads to use-after-free [1].
> > > >
> > > > Since the work can enable NAPI, we can't simply disable NAPI before
> > > > calling cancel_delayed_work_sync(). So fix this by introducing a
> > > > dedicated boolean to control whether or not the work could be
> > > > scheduled from NAPI.
> > > >
> > > > [1]
> > > > ==================================================================
> > > > BUG: KASAN: use-after-free in refill_work+0x43/0xd4
> > > > Read of size 2 at addr ffff88810562c92e by task kworker/2:1/42
> > > >
> > > > CPU: 2 PID: 42 Comm: kworker/2:1 Not tainted 5.19.0-rc1+ #480
> > > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> > > > Workqueue: events refill_work
> > > > Call Trace:
> > > >  <TASK>
> > > >  dump_stack_lvl+0x34/0x44
> > > >  print_report.cold+0xbb/0x6ac
> > > >  ? _printk+0xad/0xde
> > > >  ? refill_work+0x43/0xd4
> > > >  kasan_report+0xa8/0x130
> > > >  ? refill_work+0x43/0xd4
> > > >  refill_work+0x43/0xd4
> > > >  process_one_work+0x43d/0x780
> > > >  worker_thread+0x2a0/0x6f0
> > > >  ? process_one_work+0x780/0x780
> > > >  kthread+0x167/0x1a0
> > > >  ? kthread_exit+0x50/0x50
> > > >  ret_from_fork+0x22/0x30
> > > >  </TASK>
> > > > ...
> > > >
> > > > Fixes: b2baed69e605c ("virtio_net: set/cancel work on ndo_open/ndo_stop")
> > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > ---
> > > >  drivers/net/virtio_net.c | 38 ++++++++++++++++++++++++++++++++++++--
> > > >  1 file changed, 36 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index db05b5e930be..21bf1e5c81ef 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -251,6 +251,12 @@ struct virtnet_info {
> > > >       /* Does the affinity hint is set for virtqueues? */
> > > >       bool affinity_hint_set;
> > > >
> > > > +     /* Is refill work enabled? */
> > > > +     bool refill_work_enabled;
> > > > +
> > > > +     /* The lock to synchronize the access to refill_work_enabled */
> > > > +     spinlock_t refill_lock;
> > > > +
> > > >       /* CPU hotplug instances for online & dead */
> > > >       struct hlist_node node;
> > > >       struct hlist_node node_dead;
> > > > @@ -348,6 +354,20 @@ static struct page *get_a_page(struct receive_queue *rq, gfp_t gfp_mask)
> > > >       return p;
> > > >  }
> > > >
> > > > +static void enable_refill_work(struct virtnet_info *vi)
> > > > +{
> > > > +     spin_lock(&vi->refill_lock);
> > > > +     vi->refill_work_enabled = true;
> > > > +     spin_unlock(&vi->refill_lock);
> > > > +}
> > > > +
> > > > +static void disable_refill_work(struct virtnet_info *vi)
> > > > +{
> > > > +     spin_lock(&vi->refill_lock);
> > > > +     vi->refill_work_enabled = false;
> > > > +     spin_unlock(&vi->refill_lock);
> > > > +}
> > > > +
> > > >  static void virtqueue_napi_schedule(struct napi_struct *napi,
> > > >                                   struct virtqueue *vq)
> > > >  {
> > > > @@ -1527,8 +1547,12 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
> > > >       }
> > > >
> > > >       if (rq->vq->num_free > min((unsigned int)budget, virtqueue_get_vring_size(rq->vq)) / 2) {
> > > > -             if (!try_fill_recv(vi, rq, GFP_ATOMIC))
> > > > -                     schedule_delayed_work(&vi->refill, 0);
> > > > +             if (!try_fill_recv(vi, rq, GFP_ATOMIC)) {
> > > > +                     spin_lock(&vi->refill_lock);
> > > > +                     if (vi->refill_work_enabled)
> > > > +                             schedule_delayed_work(&vi->refill, 0);
> > > > +                     spin_unlock(&vi->refill_lock);
> > > > +             }
> > > >       }
> > > >
> > > >       u64_stats_update_begin(&rq->stats.syncp);
> > > > @@ -1651,6 +1675,8 @@ static int virtnet_open(struct net_device *dev)
> > > >       struct virtnet_info *vi = netdev_priv(dev);
> > > >       int i, err;
> > > >
> > > > +     enable_refill_work(vi);
> > > > +
> > > >       for (i = 0; i < vi->max_queue_pairs; i++) {
> > > >               if (i < vi->curr_queue_pairs)
> > > >                       /* Make sure we have some buffers: if oom use wq. */
> > > > @@ -2033,6 +2059,8 @@ static int virtnet_close(struct net_device *dev)
> > > >       struct virtnet_info *vi = netdev_priv(dev);
> > > >       int i;
> > > >
> > > > +     /* Make sure NAPI doesn't schedule refill work */
> > > > +     disable_refill_work(vi);
> > > >       /* Make sure refill_work doesn't re-enable napi! */
> > > >       cancel_delayed_work_sync(&vi->refill);
> > > >
> > > > @@ -2776,6 +2804,9 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
> > > >       netif_tx_lock_bh(vi->dev);
> > > >       netif_device_detach(vi->dev);
> > > >       netif_tx_unlock_bh(vi->dev);
> > > > +     /* Make sure NAPI doesn't schedule refill work */
> > > > +     disable_refill_work(vi);
> > > > +     /* Make sure refill_work doesn't re-enable napi! */
> > > >       cancel_delayed_work_sync(&vi->refill);
> > > >
> > > >       if (netif_running(vi->dev)) {
> > > > @@ -2799,6 +2830,8 @@ static int virtnet_restore_up(struct virtio_device *vdev)
> > > >
> > > >       virtio_device_ready(vdev);
> > > >
> > > > +     enable_refill_work(vi);
> > > > +
> > > >       if (netif_running(vi->dev)) {
> > > >               for (i = 0; i < vi->curr_queue_pairs; i++)
> > > >                       if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
> > > > @@ -3548,6 +3581,7 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > >       vdev->priv = vi;
> > > >
> > > >       INIT_WORK(&vi->config_work, virtnet_config_changed_work);
> > > > +     spin_lock_init(&vi->refill_lock);
> > > >
> > > >       /* If we can receive ANY GSO packets, we must allocate large ones. */
> > > >       if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> > >
> > >
> > > Can't say I love all the extra state but oh well.
> >
> > I couldn't find a better way. The tricky part is that NAPI and refill
> > can schedule each other so we need a third state.
> >
> > Thanks
>
>
> I wonder whether we can add a napi flag that says going away
> do not schedule, and have napi_enable/napi_disable fail then.

Probably, but not for -stable at least.

We can try it in the future.

Thanks

>
> > >
> > > > --
> > > > 2.25.1
> > >
>

