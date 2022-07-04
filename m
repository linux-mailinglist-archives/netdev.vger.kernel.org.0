Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CB2564E7C
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 09:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiGDHO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 03:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbiGDHO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 03:14:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 478F525D0
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 00:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656918866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PVTHS1ZmH+V40UZeEp3beBk5LSH440YhC3MlV0TsXgg=;
        b=aW+gJvcEZ+Vkiv7cMox2WgfXa9pz+GHjIQGSfIypRkwRBqW+VR3V21LoBpurdj5ZT7Bfy9
        HfxLSRA9I22ynT8NR829iOeO+ncjmnt0+zoe9YIHWDvMbMN2c/tlwathyIAt8bA96eniVY
        AYnH3BF0mMs1t0Ab70WnJcaP3UrAfyA=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-47-aE7lpL4zP32h47fxo_kZKQ-1; Mon, 04 Jul 2022 03:14:23 -0400
X-MC-Unique: aE7lpL4zP32h47fxo_kZKQ-1
Received: by mail-lf1-f70.google.com with SMTP id q22-20020a0565123a9600b0047f6b8e1babso2768433lfu.21
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 00:14:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PVTHS1ZmH+V40UZeEp3beBk5LSH440YhC3MlV0TsXgg=;
        b=K22iuYZEMrCYLzyVzj9zcQA2qCgffXsYGUVKuHZAvS4yj2yXHaGrmVe+CMTRBJNAFb
         Zch2ObA+3/4vwMuqWpyNrNQ3mNBwx69Wj3X3egav4iHc/P/8mVic+or3GMQY6v3YBGa0
         LDK73phvL+zGiHfa4J6OSW3rC05aZo0CEKxqmNuicY8Mdmde30LEBp9eSy/BmPnpbqkI
         Gl4GCPIUNth58+FWBz0L7l8mcTw7wwC8bFP+xhGMMMzAjnfHqV6rG/u0bfGDcvbYveCQ
         eNciN6460TcwKtkVry2nbwRjoMIDMU5Gz7XgCUjN3iWVqpAm4/5yAV7X8pIrTHG3m1C0
         8ezQ==
X-Gm-Message-State: AJIora+eySTvWeuwZtqilAj5jLzokVVkPnNnXuqVmXdHL3+PN7vuKg4W
        Lk3QlHrRQLmfC4UAId+jAIZqNs/O7aNK9BQ4q/wgmSfwGBwwoKw1fHAPcsv4C7VRGa7vY2tVxUS
        6Q+fThA5DDjQ54S8PvhRuym0DiIGpxcXh
X-Received: by 2002:ac2:51a5:0:b0:47f:79a1:5c02 with SMTP id f5-20020ac251a5000000b0047f79a15c02mr17575382lfk.575.1656918859907;
        Mon, 04 Jul 2022 00:14:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1st9OtbMb2bdAIcQAsqbqDqoOOn+3D0TXfeZJarxhdYFG9SQaOWqqLQRjRU/lhGsZfI6R5iZYM6ZVes5RTMDn8=
X-Received: by 2002:ac2:51a5:0:b0:47f:79a1:5c02 with SMTP id
 f5-20020ac251a5000000b0047f79a15c02mr17575344lfk.575.1656918859025; Mon, 04
 Jul 2022 00:14:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220704041948.13212-1-jasowang@redhat.com> <20220704021656-mutt-send-email-mst@kernel.org>
 <CACGkMEsOy6kgaj+Q0vYxDBy7JEd=DUm7KLKo7AjGCi2ay5ciKQ@mail.gmail.com> <20220704030124-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220704030124-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 4 Jul 2022 15:14:07 +0800
Message-ID: <CACGkMEvi-CT6c7qqTPh7-Vqr-2gGdX6G1FP52hqQFL3q0r=tOg@mail.gmail.com>
Subject: Re: [PATCH net V4] virtio-net: fix the race between refill work and close
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     davem <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 4, 2022 at 3:03 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Jul 04, 2022 at 02:32:45PM +0800, Jason Wang wrote:
> > On Mon, Jul 4, 2022 at 2:19 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Mon, Jul 04, 2022 at 12:19:48PM +0800, Jason Wang wrote:
> > > > We try using cancel_delayed_work_sync() to prevent the work from
> > > > enabling NAPI. This is insufficient since we don't disable the source
> > > > of the refill work scheduling. This means an NAPI poll callback after
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
> > > > Changes since V3:
> > > > - rebase to -net
> > > > Changes since V2:
> > > > - use spin_unlock()/lock_bh() in open/stop to synchronize with bh
> > > > Changes since V1:
> > > > - Tweak the changelog
> > > > ---
> > > >  drivers/net/virtio_net.c | 35 +++++++++++++++++++++++++++++++++--
> > > >  1 file changed, 33 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index 356cf8dd4164..68430d7923ac 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -251,6 +251,12 @@ struct virtnet_info {
> > > >       /* Does the affinity hint is set for virtqueues? */
> > > >       bool affinity_hint_set;
> > > >
> > > > +     /* Is refill work enabled? */
> > >
> > > refilling enabled
> >
> > I think it should be reill work, we try refill first, if fail we
> > schedule the work:
> >
> >                 if (!try_fill_recv(vi, rq, GFP_ATOMIC))
> >                         schedule_delayed_work(&vi->refill, 0);
> >
> > Thanks
>
> maybe "delayed refill"? It's not "work" it's a work struct.
> I'm trying to be consistent with:
>         /* Work struct for refilling if we run low on memory. */
>         struct delayed_work refill;

Ok, that's fine.

Will post a new version.

Thanks

>
>
> > >
> > > > +     bool refill_work_enabled;
> > >
> > >
> > > refill_work -> refill?
> > >
> > > > +
> > > > +     /* The lock to synchronize the access to refill_work_enabled */
> > >
> > > .. and refill
> > >
> > > And maybe put these field near the refill field.
> > >
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
> > > > +     spin_lock_bh(&vi->refill_lock);
> > > > +     vi->refill_work_enabled = true;
> > > > +     spin_unlock_bh(&vi->refill_lock);
> > > > +}
> > > > +
> > > > +static void disable_refill_work(struct virtnet_info *vi)
> > > > +{
> > > > +     spin_lock_bh(&vi->refill_lock);
> > > > +     vi->refill_work_enabled = false;
> > > > +     spin_unlock_bh(&vi->refill_lock);
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
> > > > @@ -2792,6 +2820,8 @@ static int virtnet_restore_up(struct virtio_device *vdev)
> > > >
> > > >       virtio_device_ready(vdev);
> > > >
> > > > +     enable_refill_work(vi);
> > > > +
> > > >       if (netif_running(vi->dev)) {
> > > >               err = virtnet_open(vi->dev);
> > > >               if (err)
> > > > @@ -3535,6 +3565,7 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > >       vdev->priv = vi;
> > > >
> > > >       INIT_WORK(&vi->config_work, virtnet_config_changed_work);
> > > > +     spin_lock_init(&vi->refill_lock);
> > > >
> > > >       /* If we can receive ANY GSO packets, we must allocate large ones. */
> > > >       if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> > > > --
> > > > 2.25.1
> > >
>

