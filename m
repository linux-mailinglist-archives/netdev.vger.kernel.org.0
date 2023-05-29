Return-Path: <netdev+bounces-5978-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 370847141A2
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 03:21:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6447280D19
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 01:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27A8C627;
	Mon, 29 May 2023 01:21:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F6F7C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 01:21:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC017BD
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 18:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685323297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jRboE5I0SRRDrF1SEw1w2ie0hUe/SapzMbi4K8/lSwo=;
	b=IAVBpkVea5/cdaFXoosB3LJz7HOquptDkV5BNnbBRy9mfgnzT7IwzRANEySp4iuCf+56ND
	q1Vnrop5psxlysjTdcscSbSZTCAvMZ+3YUilolMZRWA+GEbnHviGptRNsXkoZTcMktAbQM
	1mzknLKK1wsy5ob91+uaBuQyuEwIV48=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-62-HDByYuiIOryZxoE6cTK5ZQ-1; Sun, 28 May 2023 21:21:35 -0400
X-MC-Unique: HDByYuiIOryZxoE6cTK5ZQ-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2b05714a774so11404121fa.1
        for <netdev@vger.kernel.org>; Sun, 28 May 2023 18:21:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685323294; x=1687915294;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jRboE5I0SRRDrF1SEw1w2ie0hUe/SapzMbi4K8/lSwo=;
        b=PRLpGbbFeGpe8JxFdHnyQ8RoMkXtKPpM3MkZOeu0UlTJ8Bh/Y9zUMwQR/wEqFGi4YE
         MmHbeVL4Aa9etEovXMBsAvLl2Wi7kcHA4jyxU+XQAoqc5Fbe2eBeCukOyM8u11iwPze5
         Th0LQXq08jiTwao8MjIDfEFQaB8oxgAVzYbmOPoEXi9l8OmTqYEKItfMjDDrM3++fCp+
         xhJ9Bji16H+WcOlAsGQCFnUFnbUxonBD1T1VEk0rNNjgDbGGAjBdJTKeO+ZvHHqgBs/b
         EXy/JbxNR3buU6XTIZBgGGRnKIPBRZRZxP/5pbRjYUDTEANXsDqlj2RxdVfgUV0JEsd7
         IFoA==
X-Gm-Message-State: AC+VfDyLALsu9y8sRB1FeHb2N9ySCA3lQE8/AtHHt0Ehj6pP3CIp6kj2
	kfw72oz+Uy4W97QGxRP1FTRdBXJh0Wt8E+0WFcz7qe7bwA5zETX92QGIYpg+q5Q2G4taViw3YRW
	gaZUJVnuAclWcrdXDV28EGNciBVIPGgpP
X-Received: by 2002:a05:651c:103b:b0:2af:2088:2548 with SMTP id w27-20020a05651c103b00b002af20882548mr3351420ljm.21.1685323294044;
        Sun, 28 May 2023 18:21:34 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6Kg07odPok1mdzPXs0HAFAv23D18/pYqhOKE9PgjFglnQ61GcVmzx9bqJteIa9LDbtm572mPL52Am1k7VDScA=
X-Received: by 2002:a05:651c:103b:b0:2af:2088:2548 with SMTP id
 w27-20020a05651c103b00b002af20882548mr3351413ljm.21.1685323293731; Sun, 28
 May 2023 18:21:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230524081842.3060-1-jasowang@redhat.com> <20230524081842.3060-2-jasowang@redhat.com>
 <20230524050604-mutt-send-email-mst@kernel.org> <CACGkMEvm=MJz5e2C_7U=yjrvoo7pxsr=tRAL29OdxJDWhvtiSQ@mail.gmail.com>
 <20230525033750-mutt-send-email-mst@kernel.org> <CACGkMEtCA0-NY=qq_FnGzoY+VXmixGmBV3y80nZWO=NmxdRWmw@mail.gmail.com>
 <20230528073139-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230528073139-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 29 May 2023 09:21:21 +0800
Message-ID: <CACGkMEvcjjGRfNYeZaG0hS8R2fnpve62QFv_ReRTXxCUKwf36w@mail.gmail.com>
Subject: Re: [PATCH V3 net-next 1/2] virtio-net: convert rx mode setting to
 use workqueue
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: xuanzhuo@linux.alibaba.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	alvaro.karsz@solid-run.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 28, 2023 at 7:39=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Fri, May 26, 2023 at 09:31:34AM +0800, Jason Wang wrote:
> > On Thu, May 25, 2023 at 3:41=E2=80=AFPM Michael S. Tsirkin <mst@redhat.=
com> wrote:
> > >
> > > On Thu, May 25, 2023 at 11:43:34AM +0800, Jason Wang wrote:
> > > > On Wed, May 24, 2023 at 5:15=E2=80=AFPM Michael S. Tsirkin <mst@red=
hat.com> wrote:
> > > > >
> > > > > On Wed, May 24, 2023 at 04:18:41PM +0800, Jason Wang wrote:
> > > > > > This patch convert rx mode setting to be done in a workqueue, t=
his is
> > > > > > a must for allow to sleep when waiting for the cvq command to
> > > > > > response since current code is executed under addr spin lock.
> > > > > >
> > > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > > ---
> > > > > > Changes since V1:
> > > > > > - use RTNL to synchronize rx mode worker
> > > > > > ---
> > > > > >  drivers/net/virtio_net.c | 55 ++++++++++++++++++++++++++++++++=
+++++---
> > > > > >  1 file changed, 52 insertions(+), 3 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.=
c
> > > > > > index 56ca1d270304..5d2f1da4eaa0 100644
> > > > > > --- a/drivers/net/virtio_net.c
> > > > > > +++ b/drivers/net/virtio_net.c
> > > > > > @@ -265,6 +265,12 @@ struct virtnet_info {
> > > > > >       /* Work struct for config space updates */
> > > > > >       struct work_struct config_work;
> > > > > >
> > > > > > +     /* Work struct for config rx mode */
> > > > >
> > > > > With a bit less abbreviation maybe? setting rx mode?
> > > >
> > > > That's fine.
> > > >
> > > > >
> > > > > > +     struct work_struct rx_mode_work;
> > > > > > +
> > > > > > +     /* Is rx mode work enabled? */
> > > > >
> > > > > Ugh not a great comment.
> > > >
> > > > Any suggestions for this. E.g we had:
> > > >
> > > >         /* Is delayed refill enabled? */
> > >
> > > /* OK to queue work setting RX mode? */
> >
> > Ok.
> >
> > >
> > >
> > > > >
> > > > > > +     bool rx_mode_work_enabled;
> > > > > > +
> > > > >
> > > > >
> > > > >
> > > > > >       /* Does the affinity hint is set for virtqueues? */
> > > > > >       bool affinity_hint_set;
> > > > > >
> > > > > > @@ -388,6 +394,20 @@ static void disable_delayed_refill(struct =
virtnet_info *vi)
> > > > > >       spin_unlock_bh(&vi->refill_lock);
> > > > > >  }
> > > > > >
> > > > > > +static void enable_rx_mode_work(struct virtnet_info *vi)
> > > > > > +{
> > > > > > +     rtnl_lock();
> > > > > > +     vi->rx_mode_work_enabled =3D true;
> > > > > > +     rtnl_unlock();
> > > > > > +}
> > > > > > +
> > > > > > +static void disable_rx_mode_work(struct virtnet_info *vi)
> > > > > > +{
> > > > > > +     rtnl_lock();
> > > > > > +     vi->rx_mode_work_enabled =3D false;
> > > > > > +     rtnl_unlock();
> > > > > > +}
> > > > > > +
> > > > > >  static void virtqueue_napi_schedule(struct napi_struct *napi,
> > > > > >                                   struct virtqueue *vq)
> > > > > >  {
> > > > > > @@ -2341,9 +2361,11 @@ static int virtnet_close(struct net_devi=
ce *dev)
> > > > > >       return 0;
> > > > > >  }
> > > > > >
> > > > > > -static void virtnet_set_rx_mode(struct net_device *dev)
> > > > > > +static void virtnet_rx_mode_work(struct work_struct *work)
> > > > > >  {
> > > > > > -     struct virtnet_info *vi =3D netdev_priv(dev);
> > > > > > +     struct virtnet_info *vi =3D
> > > > > > +             container_of(work, struct virtnet_info, rx_mode_w=
ork);
> > > > > > +     struct net_device *dev =3D vi->dev;
> > > > > >       struct scatterlist sg[2];
> > > > > >       struct virtio_net_ctrl_mac *mac_data;
> > > > > >       struct netdev_hw_addr *ha;
> > > > > > @@ -2356,6 +2378,8 @@ static void virtnet_set_rx_mode(struct ne=
t_device *dev)
> > > > > >       if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_RX))
> > > > > >               return;
> > > > > >
> > > > > > +     rtnl_lock();
> > > > > > +
> > > > > >       vi->ctrl->promisc =3D ((dev->flags & IFF_PROMISC) !=3D 0)=
;
> > > > > >       vi->ctrl->allmulti =3D ((dev->flags & IFF_ALLMULTI) !=3D =
0);
> > > > > >
> > > > > > @@ -2373,14 +2397,19 @@ static void virtnet_set_rx_mode(struct =
net_device *dev)
> > > > > >               dev_warn(&dev->dev, "Failed to %sable allmulti mo=
de.\n",
> > > > > >                        vi->ctrl->allmulti ? "en" : "dis");
> > > > > >
> > > > > > +     netif_addr_lock_bh(dev);
> > > > > > +
> > > > > >       uc_count =3D netdev_uc_count(dev);
> > > > > >       mc_count =3D netdev_mc_count(dev);
> > > > > >       /* MAC filter - use one buffer for both lists */
> > > > > >       buf =3D kzalloc(((uc_count + mc_count) * ETH_ALEN) +
> > > > > >                     (2 * sizeof(mac_data->entries)), GFP_ATOMIC=
);
> > > > > >       mac_data =3D buf;
> > > > > > -     if (!buf)
> > > > > > +     if (!buf) {
> > > > > > +             netif_addr_unlock_bh(dev);
> > > > > > +             rtnl_unlock();
> > > > > >               return;
> > > > > > +     }
> > > > > >
> > > > > >       sg_init_table(sg, 2);
> > > > > >
> > > > > > @@ -2401,6 +2430,8 @@ static void virtnet_set_rx_mode(struct ne=
t_device *dev)
> > > > > >       netdev_for_each_mc_addr(ha, dev)
> > > > > >               memcpy(&mac_data->macs[i++][0], ha->addr, ETH_ALE=
N);
> > > > > >
> > > > > > +     netif_addr_unlock_bh(dev);
> > > > > > +
> > > > > >       sg_set_buf(&sg[1], mac_data,
> > > > > >                  sizeof(mac_data->entries) + (mc_count * ETH_AL=
EN));
> > > > > >
> > > > > > @@ -2408,9 +2439,19 @@ static void virtnet_set_rx_mode(struct n=
et_device *dev)
> > > > > >                                 VIRTIO_NET_CTRL_MAC_TABLE_SET, =
sg))
> > > > > >               dev_warn(&dev->dev, "Failed to set MAC filter tab=
le.\n");
> > > > > >
> > > > > > +     rtnl_unlock();
> > > > > > +
> > > > > >       kfree(buf);
> > > > > >  }
> > > > > >
> > > > > > +static void virtnet_set_rx_mode(struct net_device *dev)
> > > > > > +{
> > > > > > +     struct virtnet_info *vi =3D netdev_priv(dev);
> > > > > > +
> > > > > > +     if (vi->rx_mode_work_enabled)
> > > > > > +             schedule_work(&vi->rx_mode_work);
> > > > > > +}
> > > > > > +
> > > > >
> > > > > >  static int virtnet_vlan_rx_add_vid(struct net_device *dev,
> > > > > >                                  __be16 proto, u16 vid)
> > > > > >  {
> > > > > > @@ -3181,6 +3222,8 @@ static void virtnet_freeze_down(struct vi=
rtio_device *vdev)
> > > > > >
> > > > > >       /* Make sure no work handler is accessing the device */
> > > > > >       flush_work(&vi->config_work);
> > > > > > +     disable_rx_mode_work(vi);
> > > > > > +     flush_work(&vi->rx_mode_work);
> > > > > >
> > > > > >       netif_tx_lock_bh(vi->dev);
> > > > > >       netif_device_detach(vi->dev);
> > > > >
> > > > > Hmm so queued rx mode work will just get skipped
> > > > > and on restore we get a wrong rx mode.
> > > > > Any way to make this more robust?
> > > >
> > > > It could be done by scheduling a work on restore.
> >
> > Rethink this, I think we don't need to care about this case since the
> > user processes should have been frozened.
>
> Yes but not the workqueue. Want to switch to system_freezable_wq?

Yes, I will do it in v2.

Thanks

>
> > And that the reason we don't
> > even need to hold RTNL here.
> >
> > Thanks
> >
> > > >
> > > > Thanks
> > >
> > >
> > > > >
> > > > >
> > > > > > @@ -3203,6 +3246,7 @@ static int virtnet_restore_up(struct virt=
io_device *vdev)
> > > > > >       virtio_device_ready(vdev);
> > > > > >
> > > > > >       enable_delayed_refill(vi);
> > > > > > +     enable_rx_mode_work(vi);
> > > > > >
> > > > > >       if (netif_running(vi->dev)) {
> > > > > >               err =3D virtnet_open(vi->dev);
> > > > > > @@ -4002,6 +4046,7 @@ static int virtnet_probe(struct virtio_de=
vice *vdev)
> > > > > >       vdev->priv =3D vi;
> > > > > >
> > > > > >       INIT_WORK(&vi->config_work, virtnet_config_changed_work);
> > > > > > +     INIT_WORK(&vi->rx_mode_work, virtnet_rx_mode_work);
> > > > > >       spin_lock_init(&vi->refill_lock);
> > > > > >
> > > > > >       if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF)) {
> > > > > > @@ -4110,6 +4155,8 @@ static int virtnet_probe(struct virtio_de=
vice *vdev)
> > > > > >       if (vi->has_rss || vi->has_rss_hash_report)
> > > > > >               virtnet_init_default_rss(vi);
> > > > > >
> > > > > > +     enable_rx_mode_work(vi);
> > > > > > +
> > > > > >       /* serialize netdev register + virtio_device_ready() with=
 ndo_open() */
> > > > > >       rtnl_lock();
> > > > > >
> > > > > > @@ -4207,6 +4254,8 @@ static void virtnet_remove(struct virtio_=
device *vdev)
> > > > > >
> > > > > >       /* Make sure no work handler is accessing the device. */
> > > > > >       flush_work(&vi->config_work);
> > > > > > +     disable_rx_mode_work(vi);
> > > > > > +     flush_work(&vi->rx_mode_work);
> > > > > >
> > > > > >       unregister_netdev(vi->dev);
> > > > > >
> > > > > > --
> > > > > > 2.25.1
> > > > >
> > >
>


