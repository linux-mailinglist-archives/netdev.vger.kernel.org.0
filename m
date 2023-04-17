Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0D56E3E51
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 05:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjDQDmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 23:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjDQDl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 23:41:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4FC121
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 20:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681702872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dcVP21Kh+o9APGXTTKImofL+e7FukjqIuewUZeN4MOQ=;
        b=N7RbU1mmtoO6s8ZPXNwyl+Z695274q2w2FCxY5Iz2YUSeWBWWMF+6auLeYOLQ0uNQT4jgm
        2xNShqlqnCZxvovEG747kCqw/+szlbawNf7/v5Wa9MSAxZROyLtosa0NFw4VI39NzGChKo
        usc8RSYgllbHZj6XWw5V98aKxW1J58g=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-7-6NEzxpNn-2dMW7i_1BTg-1; Sun, 16 Apr 2023 23:41:11 -0400
X-MC-Unique: 7-6NEzxpNn-2dMW7i_1BTg-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-1878d25889dso6399174fac.15
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 20:41:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681702870; x=1684294870;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dcVP21Kh+o9APGXTTKImofL+e7FukjqIuewUZeN4MOQ=;
        b=hNdbFWRLb/XmqZC221BuJY0/EDtpPO8OFxQc+nGMdJnyn/Cbqth3AjGTrIHpBSQvnZ
         a8Hec1l+k7d44wI68DQgY4wOUsRh2NqrJsmhPmCBnwFzv8LtLKQqK7HFZEPji3vigs6/
         XB9Tg8o0Ab7vRHz7X+iA/A/qqWBaeH/hiHdmBAzgkwCLMp+2AaFJJdSNDtnhnzi0HLKF
         xZwE16pc3ykwo76mPMVczFY9jzsbEAPYOEAyOuX/3XLbxc5c/I7f5QT5slRNzbsfLC9I
         wVWlz9hihmLApQxGj1OJREe+TkySER+9yE9nhQR1B1IvYknTP548PA0GAi6QPEAtm8Nr
         8X5Q==
X-Gm-Message-State: AAQBX9dsJ1QdSswxokK3Gmh+1CersT3jL0hSsFeC0E33QqfNkFYKN+2Z
        G4CloYWzDR7KpbFOWxgRzGWDBaqkAGqOHVRcQQUkmwZDnSsQIPbdqWlTLHdIDj1owu9K/rGCmGe
        xqNRzA3OVQTJl7tdqeoO1RUCHytxRfiZf
X-Received: by 2002:a05:6870:73cf:b0:187:e1d0:ea18 with SMTP id a15-20020a05687073cf00b00187e1d0ea18mr1348782oan.9.1681702870350;
        Sun, 16 Apr 2023 20:41:10 -0700 (PDT)
X-Google-Smtp-Source: AKy350YfUe2U6dtyhxge8JJ3LDSrj5GUNX7EY9D1Jl8PvaOABoFylIG1ufGRyUzuWnzClNxrcat8Y72qJtDOhmUJ6xE=
X-Received: by 2002:a05:6870:73cf:b0:187:e1d0:ea18 with SMTP id
 a15-20020a05687073cf00b00187e1d0ea18mr1348770oan.9.1681702870042; Sun, 16 Apr
 2023 20:41:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230413064027.13267-1-jasowang@redhat.com> <20230413064027.13267-2-jasowang@redhat.com>
 <20230413121525-mutt-send-email-mst@kernel.org> <CACGkMEunn1Z3n8yjVaWLqdV502yjaCBSAb_LO4KsB0nuxXmV8A@mail.gmail.com>
 <20230414031947-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230414031947-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 17 Apr 2023 11:40:58 +0800
Message-ID: <CACGkMEtutGn0CoJhoPHbzPuqoCLb4OCT6a_vB_WPV=MhwY0DXg@mail.gmail.com>
Subject: Re: [PATCH net-next V2 1/2] virtio-net: convert rx mode setting to
 use workqueue
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, maxime.coquelin@redhat.com,
        alvaro.karsz@solid-run.com, eperezma@redhat.com,
        xuanzhuo@linux.alibaba.com, david.marchand@redhat.com,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 3:21=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Fri, Apr 14, 2023 at 01:04:15PM +0800, Jason Wang wrote:
> > Forget to cc netdev, adding.
> >
> > On Fri, Apr 14, 2023 at 12:25=E2=80=AFAM Michael S. Tsirkin <mst@redhat=
.com> wrote:
> > >
> > > On Thu, Apr 13, 2023 at 02:40:26PM +0800, Jason Wang wrote:
> > > > This patch convert rx mode setting to be done in a workqueue, this =
is
> > > > a must for allow to sleep when waiting for the cvq command to
> > > > response since current code is executed under addr spin lock.
> > > >
> > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > >
> > > I don't like this frankly. This means that setting RX mode which woul=
d
> > > previously be reliable, now becomes unreliable.
> >
> > It is "unreliable" by design:
> >
> >       void                    (*ndo_set_rx_mode)(struct net_device *dev=
);
> >
> > > - first of all configuration is no longer immediate
> >
> > Is immediate a hard requirement? I can see a workqueue is used at least=
:
> >
> > mlx5e, ipoib, efx, ...
> >
> > >   and there is no way for driver to find out when
> > >   it actually took effect
> >
> > But we know rx mode is best effort e.g it doesn't support vhost and we
> > survive from this for years.
> >
> > > - second, if device fails command, this is also not
> > >   propagated to driver, again no way for driver to find out
> > >
> > > VDUSE needs to be fixed to do tricks to fix this
> > > without breaking normal drivers.
> >
> > It's not specific to VDUSE. For example, when using virtio-net in the
> > UP environment with any software cvq (like mlx5 via vDPA or cma
> > transport).
> >
> > Thanks
>
> Hmm. Can we differentiate between these use-cases?

It doesn't look easy since we are drivers for virtio bus. Underlayer
details were hidden from virtio-net.

Or do you have any ideas on this?

Thanks

>
> > >
> > >
> > > > ---
> > > > Changes since V1:
> > > > - use RTNL to synchronize rx mode worker
> > > > ---
> > > >  drivers/net/virtio_net.c | 55 ++++++++++++++++++++++++++++++++++++=
+---
> > > >  1 file changed, 52 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index e2560b6f7980..2e56bbf86894 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -265,6 +265,12 @@ struct virtnet_info {
> > > >       /* Work struct for config space updates */
> > > >       struct work_struct config_work;
> > > >
> > > > +     /* Work struct for config rx mode */
> > > > +     struct work_struct rx_mode_work;
> > > > +
> > > > +     /* Is rx mode work enabled? */
> > > > +     bool rx_mode_work_enabled;
> > > > +
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
> > > > @@ -2310,9 +2330,11 @@ static int virtnet_close(struct net_device *=
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
> > > > @@ -2325,6 +2347,8 @@ static void virtnet_set_rx_mode(struct net_de=
vice *dev)
> > > >       if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_RX))
> > > >               return;
> > > >
> > > > +     rtnl_lock();
> > > > +
> > > >       vi->ctrl->promisc =3D ((dev->flags & IFF_PROMISC) !=3D 0);
> > > >       vi->ctrl->allmulti =3D ((dev->flags & IFF_ALLMULTI) !=3D 0);
> > > >
> > > > @@ -2342,14 +2366,19 @@ static void virtnet_set_rx_mode(struct net_=
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
> > > > @@ -2370,6 +2399,8 @@ static void virtnet_set_rx_mode(struct net_de=
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
> > > > @@ -2377,9 +2408,19 @@ static void virtnet_set_rx_mode(struct net_d=
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
> > > >  static int virtnet_vlan_rx_add_vid(struct net_device *dev,
> > > >                                  __be16 proto, u16 vid)
> > > >  {
> > > > @@ -3150,6 +3191,8 @@ static void virtnet_freeze_down(struct virtio=
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
> > > So now configuration is not propagated to device.
> > > Won't device later wake up in wrong state?
> > >
> > >
> > > > @@ -3172,6 +3215,7 @@ static int virtnet_restore_up(struct virtio_d=
evice *vdev)
> > > >       virtio_device_ready(vdev);
> > > >
> > > >       enable_delayed_refill(vi);
> > > > +     enable_rx_mode_work(vi);
> > > >
> > > >       if (netif_running(vi->dev)) {
> > > >               err =3D virtnet_open(vi->dev);
> > > > @@ -3969,6 +4013,7 @@ static int virtnet_probe(struct virtio_device=
 *vdev)
> > > >       vdev->priv =3D vi;
> > > >
> > > >       INIT_WORK(&vi->config_work, virtnet_config_changed_work);
> > > > +     INIT_WORK(&vi->rx_mode_work, virtnet_rx_mode_work);
> > > >       spin_lock_init(&vi->refill_lock);
> > > >
> > > >       if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF)) {
> > > > @@ -4077,6 +4122,8 @@ static int virtnet_probe(struct virtio_device=
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
> > > > @@ -4174,6 +4221,8 @@ static void virtnet_remove(struct virtio_devi=
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

