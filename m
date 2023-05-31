Return-Path: <netdev+bounces-6649-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60D4D7172D8
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 03:07:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 026AA2813F7
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 01:07:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E603ED9;
	Wed, 31 May 2023 01:07:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FA9EB8
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 01:07:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DEBF9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 18:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685495260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2a4YKqXAVZsfIDOnK1o6EetH++cnzg6vwlfUs57fikU=;
	b=hcJB1m/YFc5MXdNS26DrNXL3BYzKitQrni3zfZtjrtc9RcuCZWVAN9pEq31j1nR06xCkUe
	Kr85kquD1NZy6pbcF951BIoGVXeCS+QT+TRrm5biv9YmDwmujjz+P91sA7ormVU94wCBfA
	9Jb8+b0gGX8XB+BY4+Mzi9memJOxC40=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-168-5fvELGdiN0Ovm7Ef4saKmQ-1; Tue, 30 May 2023 21:07:38 -0400
X-MC-Unique: 5fvELGdiN0Ovm7Ef4saKmQ-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2af2ffb4e5aso26830461fa.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 18:07:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685495257; x=1688087257;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2a4YKqXAVZsfIDOnK1o6EetH++cnzg6vwlfUs57fikU=;
        b=Y22jFu3dqi9sLkVdpbkFuYcJ8ZkQNmu0pg+OUTS35/BtpSkrxFamlqqsAWueis4FcS
         pcjG18wbo11qs4gMnuyvwZrRjdcyaK9DlWHB8O3xwUqOs0kF+umAlVPxjFbJq2Kahi6q
         iYlptqZI6hfyjLWzLfqAjLaqRARuvwpJxnDebLMeUC95vbrz7vlJv78rftI/tJZEd8o+
         IEMdnOpwa1wndKbx9z0J0Cqr5fbb++0ljC28EvrB/PwSNQBhsyh/rOJVNzxZVNbjrnVw
         3KZ5p0qkszXfojIPV7Nrel6TDl210ycon/DrIvfQw7j9AytuiMFucYEuxx7qdmvXRLSO
         nw9w==
X-Gm-Message-State: AC+VfDzbxPNLAm2+ECvP3s0bn7q+wzfCF+Pic95P8pCSO6mmQn97hMWK
	Rb5El5vNbtswFTbfuCAByuVn4CLsvZIWWtpUsV2AwjpE/LNiadocmbM6xP7HYYUTG1IgrtwBO7y
	aUUBnevOKUWUPidCdAcUATySScHxWVzXC
X-Received: by 2002:a2e:83d5:0:b0:2a8:bf74:61cc with SMTP id s21-20020a2e83d5000000b002a8bf7461ccmr1603357ljh.26.1685495257101;
        Tue, 30 May 2023 18:07:37 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5mcll9hwd9ORK2nSdd4ipN83XKS3tVT9bk0w17vjAvbvyIAcRZLtd9f4CeW67BqYPZlHXbCkMUDPf6FxvjQes=
X-Received: by 2002:a2e:83d5:0:b0:2a8:bf74:61cc with SMTP id
 s21-20020a2e83d5000000b002a8bf7461ccmr1603346ljh.26.1685495256793; Tue, 30
 May 2023 18:07:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230524081842.3060-1-jasowang@redhat.com> <20230524081842.3060-2-jasowang@redhat.com>
 <20230524050604-mutt-send-email-mst@kernel.org> <CACGkMEvm=MJz5e2C_7U=yjrvoo7pxsr=tRAL29OdxJDWhvtiSQ@mail.gmail.com>
 <20230525033750-mutt-send-email-mst@kernel.org> <CACGkMEtCA0-NY=qq_FnGzoY+VXmixGmBV3y80nZWO=NmxdRWmw@mail.gmail.com>
 <20230528073139-mutt-send-email-mst@kernel.org> <CACGkMEvcjjGRfNYeZaG0hS8R2fnpve62QFv_ReRTXxCUKwf36w@mail.gmail.com>
In-Reply-To: <CACGkMEvcjjGRfNYeZaG0hS8R2fnpve62QFv_ReRTXxCUKwf36w@mail.gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 31 May 2023 09:07:25 +0800
Message-ID: <CACGkMEtgZ_=L2noqdADgNTr_E7s3adw=etvcFt3G7ZERQq43_g@mail.gmail.com>
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 9:21=E2=80=AFAM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Sun, May 28, 2023 at 7:39=E2=80=AFPM Michael S. Tsirkin <mst@redhat.co=
m> wrote:
> >
> > On Fri, May 26, 2023 at 09:31:34AM +0800, Jason Wang wrote:
> > > On Thu, May 25, 2023 at 3:41=E2=80=AFPM Michael S. Tsirkin <mst@redha=
t.com> wrote:
> > > >
> > > > On Thu, May 25, 2023 at 11:43:34AM +0800, Jason Wang wrote:
> > > > > On Wed, May 24, 2023 at 5:15=E2=80=AFPM Michael S. Tsirkin <mst@r=
edhat.com> wrote:
> > > > > >
> > > > > > On Wed, May 24, 2023 at 04:18:41PM +0800, Jason Wang wrote:
> > > > > > > This patch convert rx mode setting to be done in a workqueue,=
 this is
> > > > > > > a must for allow to sleep when waiting for the cvq command to
> > > > > > > response since current code is executed under addr spin lock.
> > > > > > >
> > > > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > > > ---
> > > > > > > Changes since V1:
> > > > > > > - use RTNL to synchronize rx mode worker
> > > > > > > ---
> > > > > > >  drivers/net/virtio_net.c | 55 ++++++++++++++++++++++++++++++=
+++++++---
> > > > > > >  1 file changed, 52 insertions(+), 3 deletions(-)
> > > > > > >
> > > > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_ne=
t.c
> > > > > > > index 56ca1d270304..5d2f1da4eaa0 100644
> > > > > > > --- a/drivers/net/virtio_net.c
> > > > > > > +++ b/drivers/net/virtio_net.c
> > > > > > > @@ -265,6 +265,12 @@ struct virtnet_info {
> > > > > > >       /* Work struct for config space updates */
> > > > > > >       struct work_struct config_work;
> > > > > > >
> > > > > > > +     /* Work struct for config rx mode */
> > > > > >
> > > > > > With a bit less abbreviation maybe? setting rx mode?
> > > > >
> > > > > That's fine.
> > > > >
> > > > > >
> > > > > > > +     struct work_struct rx_mode_work;
> > > > > > > +
> > > > > > > +     /* Is rx mode work enabled? */
> > > > > >
> > > > > > Ugh not a great comment.
> > > > >
> > > > > Any suggestions for this. E.g we had:
> > > > >
> > > > >         /* Is delayed refill enabled? */
> > > >
> > > > /* OK to queue work setting RX mode? */
> > >
> > > Ok.
> > >
> > > >
> > > >
> > > > > >
> > > > > > > +     bool rx_mode_work_enabled;
> > > > > > > +
> > > > > >
> > > > > >
> > > > > >
> > > > > > >       /* Does the affinity hint is set for virtqueues? */
> > > > > > >       bool affinity_hint_set;
> > > > > > >
> > > > > > > @@ -388,6 +394,20 @@ static void disable_delayed_refill(struc=
t virtnet_info *vi)
> > > > > > >       spin_unlock_bh(&vi->refill_lock);
> > > > > > >  }
> > > > > > >
> > > > > > > +static void enable_rx_mode_work(struct virtnet_info *vi)
> > > > > > > +{
> > > > > > > +     rtnl_lock();
> > > > > > > +     vi->rx_mode_work_enabled =3D true;
> > > > > > > +     rtnl_unlock();
> > > > > > > +}
> > > > > > > +
> > > > > > > +static void disable_rx_mode_work(struct virtnet_info *vi)
> > > > > > > +{
> > > > > > > +     rtnl_lock();
> > > > > > > +     vi->rx_mode_work_enabled =3D false;
> > > > > > > +     rtnl_unlock();
> > > > > > > +}
> > > > > > > +
> > > > > > >  static void virtqueue_napi_schedule(struct napi_struct *napi=
,
> > > > > > >                                   struct virtqueue *vq)
> > > > > > >  {
> > > > > > > @@ -2341,9 +2361,11 @@ static int virtnet_close(struct net_de=
vice *dev)
> > > > > > >       return 0;
> > > > > > >  }
> > > > > > >
> > > > > > > -static void virtnet_set_rx_mode(struct net_device *dev)
> > > > > > > +static void virtnet_rx_mode_work(struct work_struct *work)
> > > > > > >  {
> > > > > > > -     struct virtnet_info *vi =3D netdev_priv(dev);
> > > > > > > +     struct virtnet_info *vi =3D
> > > > > > > +             container_of(work, struct virtnet_info, rx_mode=
_work);
> > > > > > > +     struct net_device *dev =3D vi->dev;
> > > > > > >       struct scatterlist sg[2];
> > > > > > >       struct virtio_net_ctrl_mac *mac_data;
> > > > > > >       struct netdev_hw_addr *ha;
> > > > > > > @@ -2356,6 +2378,8 @@ static void virtnet_set_rx_mode(struct =
net_device *dev)
> > > > > > >       if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_RX)=
)
> > > > > > >               return;
> > > > > > >
> > > > > > > +     rtnl_lock();
> > > > > > > +
> > > > > > >       vi->ctrl->promisc =3D ((dev->flags & IFF_PROMISC) !=3D =
0);
> > > > > > >       vi->ctrl->allmulti =3D ((dev->flags & IFF_ALLMULTI) !=
=3D 0);
> > > > > > >
> > > > > > > @@ -2373,14 +2397,19 @@ static void virtnet_set_rx_mode(struc=
t net_device *dev)
> > > > > > >               dev_warn(&dev->dev, "Failed to %sable allmulti =
mode.\n",
> > > > > > >                        vi->ctrl->allmulti ? "en" : "dis");
> > > > > > >
> > > > > > > +     netif_addr_lock_bh(dev);
> > > > > > > +
> > > > > > >       uc_count =3D netdev_uc_count(dev);
> > > > > > >       mc_count =3D netdev_mc_count(dev);
> > > > > > >       /* MAC filter - use one buffer for both lists */
> > > > > > >       buf =3D kzalloc(((uc_count + mc_count) * ETH_ALEN) +
> > > > > > >                     (2 * sizeof(mac_data->entries)), GFP_ATOM=
IC);
> > > > > > >       mac_data =3D buf;
> > > > > > > -     if (!buf)
> > > > > > > +     if (!buf) {
> > > > > > > +             netif_addr_unlock_bh(dev);
> > > > > > > +             rtnl_unlock();
> > > > > > >               return;
> > > > > > > +     }
> > > > > > >
> > > > > > >       sg_init_table(sg, 2);
> > > > > > >
> > > > > > > @@ -2401,6 +2430,8 @@ static void virtnet_set_rx_mode(struct =
net_device *dev)
> > > > > > >       netdev_for_each_mc_addr(ha, dev)
> > > > > > >               memcpy(&mac_data->macs[i++][0], ha->addr, ETH_A=
LEN);
> > > > > > >
> > > > > > > +     netif_addr_unlock_bh(dev);
> > > > > > > +
> > > > > > >       sg_set_buf(&sg[1], mac_data,
> > > > > > >                  sizeof(mac_data->entries) + (mc_count * ETH_=
ALEN));
> > > > > > >
> > > > > > > @@ -2408,9 +2439,19 @@ static void virtnet_set_rx_mode(struct=
 net_device *dev)
> > > > > > >                                 VIRTIO_NET_CTRL_MAC_TABLE_SET=
, sg))
> > > > > > >               dev_warn(&dev->dev, "Failed to set MAC filter t=
able.\n");
> > > > > > >
> > > > > > > +     rtnl_unlock();
> > > > > > > +
> > > > > > >       kfree(buf);
> > > > > > >  }
> > > > > > >
> > > > > > > +static void virtnet_set_rx_mode(struct net_device *dev)
> > > > > > > +{
> > > > > > > +     struct virtnet_info *vi =3D netdev_priv(dev);
> > > > > > > +
> > > > > > > +     if (vi->rx_mode_work_enabled)
> > > > > > > +             schedule_work(&vi->rx_mode_work);
> > > > > > > +}
> > > > > > > +
> > > > > >
> > > > > > >  static int virtnet_vlan_rx_add_vid(struct net_device *dev,
> > > > > > >                                  __be16 proto, u16 vid)
> > > > > > >  {
> > > > > > > @@ -3181,6 +3222,8 @@ static void virtnet_freeze_down(struct =
virtio_device *vdev)
> > > > > > >
> > > > > > >       /* Make sure no work handler is accessing the device */
> > > > > > >       flush_work(&vi->config_work);
> > > > > > > +     disable_rx_mode_work(vi);
> > > > > > > +     flush_work(&vi->rx_mode_work);
> > > > > > >
> > > > > > >       netif_tx_lock_bh(vi->dev);
> > > > > > >       netif_device_detach(vi->dev);
> > > > > >
> > > > > > Hmm so queued rx mode work will just get skipped
> > > > > > and on restore we get a wrong rx mode.
> > > > > > Any way to make this more robust?
> > > > >
> > > > > It could be done by scheduling a work on restore.
> > >
> > > Rethink this, I think we don't need to care about this case since the
> > > user processes should have been frozened.
> >
> > Yes but not the workqueue. Want to switch to system_freezable_wq?
>
> Yes, I will do it in v2.

Actually, this doesn't work. Freezable workqueue can only guarantee
when being freezed the new work will be queued and not scheduled until
thaw. So the ktrhead that is executing the workqueue is not freezable.
The busy loop (even with cond_resched()) will force suspend in this
case.

I wonder if we should switch to using a dedicated kthread for
virtio-net then we can allow it to be frozen.

Thanks


>
> Thanks
>
> >
> > > And that the reason we don't
> > > even need to hold RTNL here.
> > >
> > > Thanks
> > >
> > > > >
> > > > > Thanks
> > > >
> > > >
> > > > > >
> > > > > >
> > > > > > > @@ -3203,6 +3246,7 @@ static int virtnet_restore_up(struct vi=
rtio_device *vdev)
> > > > > > >       virtio_device_ready(vdev);
> > > > > > >
> > > > > > >       enable_delayed_refill(vi);
> > > > > > > +     enable_rx_mode_work(vi);
> > > > > > >
> > > > > > >       if (netif_running(vi->dev)) {
> > > > > > >               err =3D virtnet_open(vi->dev);
> > > > > > > @@ -4002,6 +4046,7 @@ static int virtnet_probe(struct virtio_=
device *vdev)
> > > > > > >       vdev->priv =3D vi;
> > > > > > >
> > > > > > >       INIT_WORK(&vi->config_work, virtnet_config_changed_work=
);
> > > > > > > +     INIT_WORK(&vi->rx_mode_work, virtnet_rx_mode_work);
> > > > > > >       spin_lock_init(&vi->refill_lock);
> > > > > > >
> > > > > > >       if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF)) {
> > > > > > > @@ -4110,6 +4155,8 @@ static int virtnet_probe(struct virtio_=
device *vdev)
> > > > > > >       if (vi->has_rss || vi->has_rss_hash_report)
> > > > > > >               virtnet_init_default_rss(vi);
> > > > > > >
> > > > > > > +     enable_rx_mode_work(vi);
> > > > > > > +
> > > > > > >       /* serialize netdev register + virtio_device_ready() wi=
th ndo_open() */
> > > > > > >       rtnl_lock();
> > > > > > >
> > > > > > > @@ -4207,6 +4254,8 @@ static void virtnet_remove(struct virti=
o_device *vdev)
> > > > > > >
> > > > > > >       /* Make sure no work handler is accessing the device. *=
/
> > > > > > >       flush_work(&vi->config_work);
> > > > > > > +     disable_rx_mode_work(vi);
> > > > > > > +     flush_work(&vi->rx_mode_work);
> > > > > > >
> > > > > > >       unregister_netdev(vi->dev);
> > > > > > >
> > > > > > > --
> > > > > > > 2.25.1
> > > > > >
> > > >
> >


