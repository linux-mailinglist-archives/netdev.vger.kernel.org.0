Return-Path: <netdev+bounces-5493-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CD97711CA5
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 03:31:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99664281655
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 01:31:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B24C417CB;
	Fri, 26 May 2023 01:31:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC9317C9
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 01:31:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8A0189
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685064709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H0kCOd6zZFv7bAvvBeo0wUHiEHw+jtzkrolNnIKKHFY=;
	b=LjqsNPJHrTQfV0bIljMPetlrYtITwW87HUXYmfp7vMyBgTimaWBb9Eo9rQXaQC7sb2RxXZ
	jKtr1eluZ6RQYQT9Hb7vzLcwFfVMS+CBskttvBm2H7RcgXlakAEkKRg71xoZAyd6Y4Mexu
	zqjXllijs1+Uok1hjCVnXs0XD6OQY+Y=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-f9rdgurbOWimHxDVN-I7_g-1; Thu, 25 May 2023 21:31:47 -0400
X-MC-Unique: f9rdgurbOWimHxDVN-I7_g-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-4f4b2a2040bso72497e87.0
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:31:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685064706; x=1687656706;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H0kCOd6zZFv7bAvvBeo0wUHiEHw+jtzkrolNnIKKHFY=;
        b=H1jmvM/tFvtW4a/ZHyreYCmC56RqvUdkLOTgozS36j0DyDroM5AQU4jY5s+JWRNXLa
         WDK9BW18lBTJ0xPP1FXkoSYEHl47OTmJq9fHo4bET027PyL9gpXQ9B41GaHuxk93fcCH
         dJRVyFJzYRYAbuVNDqiuxyvHNZ+6WF+mUMdwm83PU/Pz/pUqFnuEbaM/CqaS7JeCnIjM
         NUJ+zFSEdJEGHrFvxVYsgp+kgpZw+p7YkC7S6RD05AQZ2XeDBANIDxZdsrYi7KibkXKZ
         UOvC1ykG05DXfE+9P7Riiz87otkj4Bz07CR6i1LfDXyYDuOUQX87TTkFEbJ5RJUPyhAR
         Y1Cg==
X-Gm-Message-State: AC+VfDzBs87I8jN/OUn6Q/Wrosa6TvcPQGykz52uYgMkOreLj+S5XQwX
	ERyiLeOK23kTDA2g4GQY5PZ5l8muHqWRX6wvhX5boWgtPqh84bBL10PMFmeDW8xpQDvL+X2aKSn
	dauhBJjvzkS1h1qJCYp8lUJNd1LqD0VFe
X-Received: by 2002:ac2:5926:0:b0:4f3:b258:fee4 with SMTP id v6-20020ac25926000000b004f3b258fee4mr4546lfi.59.1685064706409;
        Thu, 25 May 2023 18:31:46 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ42AdCfrI+6WFJ/soB09uftcaVkd1k5xpC2LlL0MHfrmY7ShJUXBM/xwj8CeIYPn5vW0zmH4Zy4ClWMwUvdO1A=
X-Received: by 2002:ac2:5926:0:b0:4f3:b258:fee4 with SMTP id
 v6-20020ac25926000000b004f3b258fee4mr4541lfi.59.1685064706005; Thu, 25 May
 2023 18:31:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230524081842.3060-1-jasowang@redhat.com> <20230524081842.3060-2-jasowang@redhat.com>
 <20230524050604-mutt-send-email-mst@kernel.org> <CACGkMEvm=MJz5e2C_7U=yjrvoo7pxsr=tRAL29OdxJDWhvtiSQ@mail.gmail.com>
 <20230525033750-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230525033750-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 26 May 2023 09:31:34 +0800
Message-ID: <CACGkMEtCA0-NY=qq_FnGzoY+VXmixGmBV3y80nZWO=NmxdRWmw@mail.gmail.com>
Subject: Re: [PATCH V3 net-next 1/2] virtio-net: convert rx mode setting to
 use workqueue
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: xuanzhuo@linux.alibaba.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	alvaro.karsz@solid-run.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 3:41=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Thu, May 25, 2023 at 11:43:34AM +0800, Jason Wang wrote:
> > On Wed, May 24, 2023 at 5:15=E2=80=AFPM Michael S. Tsirkin <mst@redhat.=
com> wrote:
> > >
> > > On Wed, May 24, 2023 at 04:18:41PM +0800, Jason Wang wrote:
> > > > This patch convert rx mode setting to be done in a workqueue, this =
is
> > > > a must for allow to sleep when waiting for the cvq command to
> > > > response since current code is executed under addr spin lock.
> > > >
> > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > ---
> > > > Changes since V1:
> > > > - use RTNL to synchronize rx mode worker
> > > > ---
> > > >  drivers/net/virtio_net.c | 55 ++++++++++++++++++++++++++++++++++++=
+---
> > > >  1 file changed, 52 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index 56ca1d270304..5d2f1da4eaa0 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -265,6 +265,12 @@ struct virtnet_info {
> > > >       /* Work struct for config space updates */
> > > >       struct work_struct config_work;
> > > >
> > > > +     /* Work struct for config rx mode */
> > >
> > > With a bit less abbreviation maybe? setting rx mode?
> >
> > That's fine.
> >
> > >
> > > > +     struct work_struct rx_mode_work;
> > > > +
> > > > +     /* Is rx mode work enabled? */
> > >
> > > Ugh not a great comment.
> >
> > Any suggestions for this. E.g we had:
> >
> >         /* Is delayed refill enabled? */
>
> /* OK to queue work setting RX mode? */

Ok.

>
>
> > >
> > > > +     bool rx_mode_work_enabled;
> > > > +
> > >
> > >
> > >
> > > >       /* Does the affinity hint is set for virtqueues? */
> > > >       bool affinity_hint_set;
> > > >
> > > > @@ -388,6 +394,20 @@ static void disable_delayed_refill(struct virt=
net_info *vi)
> > > >       spin_unlock_bh(&vi->refill_lock);
> > > >  }
> > > >
> > > > +static void enable_rx_mode_work(struct virtnet_info *vi)
> > > > +{
> > > > +     rtnl_lock();
> > > > +     vi->rx_mode_work_enabled =3D true;
> > > > +     rtnl_unlock();
> > > > +}
> > > > +
> > > > +static void disable_rx_mode_work(struct virtnet_info *vi)
> > > > +{
> > > > +     rtnl_lock();
> > > > +     vi->rx_mode_work_enabled =3D false;
> > > > +     rtnl_unlock();
> > > > +}
> > > > +
> > > >  static void virtqueue_napi_schedule(struct napi_struct *napi,
> > > >                                   struct virtqueue *vq)
> > > >  {
> > > > @@ -2341,9 +2361,11 @@ static int virtnet_close(struct net_device *=
dev)
> > > >       return 0;
> > > >  }
> > > >
> > > > -static void virtnet_set_rx_mode(struct net_device *dev)
> > > > +static void virtnet_rx_mode_work(struct work_struct *work)
> > > >  {
> > > > -     struct virtnet_info *vi =3D netdev_priv(dev);
> > > > +     struct virtnet_info *vi =3D
> > > > +             container_of(work, struct virtnet_info, rx_mode_work)=
;
> > > > +     struct net_device *dev =3D vi->dev;
> > > >       struct scatterlist sg[2];
> > > >       struct virtio_net_ctrl_mac *mac_data;
> > > >       struct netdev_hw_addr *ha;
> > > > @@ -2356,6 +2378,8 @@ static void virtnet_set_rx_mode(struct net_de=
vice *dev)
> > > >       if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_RX))
> > > >               return;
> > > >
> > > > +     rtnl_lock();
> > > > +
> > > >       vi->ctrl->promisc =3D ((dev->flags & IFF_PROMISC) !=3D 0);
> > > >       vi->ctrl->allmulti =3D ((dev->flags & IFF_ALLMULTI) !=3D 0);
> > > >
> > > > @@ -2373,14 +2397,19 @@ static void virtnet_set_rx_mode(struct net_=
device *dev)
> > > >               dev_warn(&dev->dev, "Failed to %sable allmulti mode.\=
n",
> > > >                        vi->ctrl->allmulti ? "en" : "dis");
> > > >
> > > > +     netif_addr_lock_bh(dev);
> > > > +
> > > >       uc_count =3D netdev_uc_count(dev);
> > > >       mc_count =3D netdev_mc_count(dev);
> > > >       /* MAC filter - use one buffer for both lists */
> > > >       buf =3D kzalloc(((uc_count + mc_count) * ETH_ALEN) +
> > > >                     (2 * sizeof(mac_data->entries)), GFP_ATOMIC);
> > > >       mac_data =3D buf;
> > > > -     if (!buf)
> > > > +     if (!buf) {
> > > > +             netif_addr_unlock_bh(dev);
> > > > +             rtnl_unlock();
> > > >               return;
> > > > +     }
> > > >
> > > >       sg_init_table(sg, 2);
> > > >
> > > > @@ -2401,6 +2430,8 @@ static void virtnet_set_rx_mode(struct net_de=
vice *dev)
> > > >       netdev_for_each_mc_addr(ha, dev)
> > > >               memcpy(&mac_data->macs[i++][0], ha->addr, ETH_ALEN);
> > > >
> > > > +     netif_addr_unlock_bh(dev);
> > > > +
> > > >       sg_set_buf(&sg[1], mac_data,
> > > >                  sizeof(mac_data->entries) + (mc_count * ETH_ALEN))=
;
> > > >
> > > > @@ -2408,9 +2439,19 @@ static void virtnet_set_rx_mode(struct net_d=
evice *dev)
> > > >                                 VIRTIO_NET_CTRL_MAC_TABLE_SET, sg))
> > > >               dev_warn(&dev->dev, "Failed to set MAC filter table.\=
n");
> > > >
> > > > +     rtnl_unlock();
> > > > +
> > > >       kfree(buf);
> > > >  }
> > > >
> > > > +static void virtnet_set_rx_mode(struct net_device *dev)
> > > > +{
> > > > +     struct virtnet_info *vi =3D netdev_priv(dev);
> > > > +
> > > > +     if (vi->rx_mode_work_enabled)
> > > > +             schedule_work(&vi->rx_mode_work);
> > > > +}
> > > > +
> > >
> > > >  static int virtnet_vlan_rx_add_vid(struct net_device *dev,
> > > >                                  __be16 proto, u16 vid)
> > > >  {
> > > > @@ -3181,6 +3222,8 @@ static void virtnet_freeze_down(struct virtio=
_device *vdev)
> > > >
> > > >       /* Make sure no work handler is accessing the device */
> > > >       flush_work(&vi->config_work);
> > > > +     disable_rx_mode_work(vi);
> > > > +     flush_work(&vi->rx_mode_work);
> > > >
> > > >       netif_tx_lock_bh(vi->dev);
> > > >       netif_device_detach(vi->dev);
> > >
> > > Hmm so queued rx mode work will just get skipped
> > > and on restore we get a wrong rx mode.
> > > Any way to make this more robust?
> >
> > It could be done by scheduling a work on restore.

Rethink this, I think we don't need to care about this case since the
user processes should have been frozened. And that the reason we don't
even need to hold RTNL here.

Thanks

> >
> > Thanks
>
>
> > >
> > >
> > > > @@ -3203,6 +3246,7 @@ static int virtnet_restore_up(struct virtio_d=
evice *vdev)
> > > >       virtio_device_ready(vdev);
> > > >
> > > >       enable_delayed_refill(vi);
> > > > +     enable_rx_mode_work(vi);
> > > >
> > > >       if (netif_running(vi->dev)) {
> > > >               err =3D virtnet_open(vi->dev);
> > > > @@ -4002,6 +4046,7 @@ static int virtnet_probe(struct virtio_device=
 *vdev)
> > > >       vdev->priv =3D vi;
> > > >
> > > >       INIT_WORK(&vi->config_work, virtnet_config_changed_work);
> > > > +     INIT_WORK(&vi->rx_mode_work, virtnet_rx_mode_work);
> > > >       spin_lock_init(&vi->refill_lock);
> > > >
> > > >       if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF)) {
> > > > @@ -4110,6 +4155,8 @@ static int virtnet_probe(struct virtio_device=
 *vdev)
> > > >       if (vi->has_rss || vi->has_rss_hash_report)
> > > >               virtnet_init_default_rss(vi);
> > > >
> > > > +     enable_rx_mode_work(vi);
> > > > +
> > > >       /* serialize netdev register + virtio_device_ready() with ndo=
_open() */
> > > >       rtnl_lock();
> > > >
> > > > @@ -4207,6 +4254,8 @@ static void virtnet_remove(struct virtio_devi=
ce *vdev)
> > > >
> > > >       /* Make sure no work handler is accessing the device. */
> > > >       flush_work(&vi->config_work);
> > > > +     disable_rx_mode_work(vi);
> > > > +     flush_work(&vi->rx_mode_work);
> > > >
> > > >       unregister_netdev(vi->dev);
> > > >
> > > > --
> > > > 2.25.1
> > >
>


