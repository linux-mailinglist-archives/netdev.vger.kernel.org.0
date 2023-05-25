Return-Path: <netdev+bounces-5248-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54557710691
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 09:42:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C20191C20E6F
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 07:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E532ABE61;
	Thu, 25 May 2023 07:42:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CFDA923
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 07:42:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4601BD9
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 00:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685000516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xLlszakwtl2NiocvGs5LQWEAprM6Y0QlYDNKUyv6EwY=;
	b=cOroiditd0MOexVSXuQga57C1bFPl83+FYQQFnOvQTPRcTla2igE/Ld4/x/uexc6nWL8ru
	knJcKMXWOajt+Sg7UL8T4xWnkdMLaRRZbc99rw0O887ekkNuSqonVkZJIr4FzjnZ+3Ne8+
	TCX4jTu/uc0IwMHIOW1pv2lydKRN/R8=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-c1hzCK6fP_KDDFsxFIDTyg-1; Thu, 25 May 2023 03:41:54 -0400
X-MC-Unique: c1hzCK6fP_KDDFsxFIDTyg-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-623a43db679so7014396d6.1
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 00:41:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685000514; x=1687592514;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xLlszakwtl2NiocvGs5LQWEAprM6Y0QlYDNKUyv6EwY=;
        b=jNxdkJrxiThVzu430iyLr/6UTH4BgNvi+WaFYxF4jXmeoq7pXjvjvBmZPl4jjBKX2q
         jy0hWuUvhwu+35bT2qcCud5c79R2GqPy5d4kR33eXrXQwbffUnJlFBAbuartygN9La02
         RSlIOFa4D7cVukoq6alFw0II3y1c6k9xyoHFutkfZQn36drmUn9UEOusDGFC6M+YCyqI
         XsqZP8atxzqTeACE8YGeIEZFyIMSce8eG3vsewI3EsaQ7fWBv0+zjSpmtNEMi19X2lTI
         rbnqHEto6Pow13m+lG7rq+CtNJmJQy+G7mG4syfiy1nttmdWSQEpzQjs6+wiWwlGjxr3
         6TMg==
X-Gm-Message-State: AC+VfDyhSA1F6dp5Xg0DBOLXmX7ZQSGPWSi+w8XX2FlbdTxL2AeSIiD7
	ULtv/70x0tvvkbo/JkdtjSa1hjBn3k2e+VDJkMNO9XCI8cz2UTgVvynzx/sCE6wivaHTrR9Gt24
	y18wyUATHruHsA1Ab
X-Received: by 2002:a05:6214:d4e:b0:56f:52ba:cce6 with SMTP id 14-20020a0562140d4e00b0056f52bacce6mr569114qvr.19.1685000514249;
        Thu, 25 May 2023 00:41:54 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5qH+YWw5yHuyI4A93GN69Ss1hSLcoPsLz80aHg9NVN0huU1YrbOORiES+yuWNgP5FGs17w4g==
X-Received: by 2002:a05:6214:d4e:b0:56f:52ba:cce6 with SMTP id 14-20020a0562140d4e00b0056f52bacce6mr569095qvr.19.1685000513802;
        Thu, 25 May 2023 00:41:53 -0700 (PDT)
Received: from redhat.com ([191.101.160.247])
        by smtp.gmail.com with ESMTPSA id e14-20020a0cf74e000000b005dd8b9345besm214153qvo.86.2023.05.25.00.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 00:41:53 -0700 (PDT)
Date: Thu, 25 May 2023 03:41:47 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: xuanzhuo@linux.alibaba.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, alvaro.karsz@solid-run.com
Subject: Re: [PATCH V3 net-next 1/2] virtio-net: convert rx mode setting to
 use workqueue
Message-ID: <20230525033750-mutt-send-email-mst@kernel.org>
References: <20230524081842.3060-1-jasowang@redhat.com>
 <20230524081842.3060-2-jasowang@redhat.com>
 <20230524050604-mutt-send-email-mst@kernel.org>
 <CACGkMEvm=MJz5e2C_7U=yjrvoo7pxsr=tRAL29OdxJDWhvtiSQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEvm=MJz5e2C_7U=yjrvoo7pxsr=tRAL29OdxJDWhvtiSQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 11:43:34AM +0800, Jason Wang wrote:
> On Wed, May 24, 2023 at 5:15 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Wed, May 24, 2023 at 04:18:41PM +0800, Jason Wang wrote:
> > > This patch convert rx mode setting to be done in a workqueue, this is
> > > a must for allow to sleep when waiting for the cvq command to
> > > response since current code is executed under addr spin lock.
> > >
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > > Changes since V1:
> > > - use RTNL to synchronize rx mode worker
> > > ---
> > >  drivers/net/virtio_net.c | 55 +++++++++++++++++++++++++++++++++++++---
> > >  1 file changed, 52 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 56ca1d270304..5d2f1da4eaa0 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -265,6 +265,12 @@ struct virtnet_info {
> > >       /* Work struct for config space updates */
> > >       struct work_struct config_work;
> > >
> > > +     /* Work struct for config rx mode */
> >
> > With a bit less abbreviation maybe? setting rx mode?
> 
> That's fine.
> 
> >
> > > +     struct work_struct rx_mode_work;
> > > +
> > > +     /* Is rx mode work enabled? */
> >
> > Ugh not a great comment.
> 
> Any suggestions for this. E.g we had:
> 
>         /* Is delayed refill enabled? */

/* OK to queue work setting RX mode? */


> >
> > > +     bool rx_mode_work_enabled;
> > > +
> >
> >
> >
> > >       /* Does the affinity hint is set for virtqueues? */
> > >       bool affinity_hint_set;
> > >
> > > @@ -388,6 +394,20 @@ static void disable_delayed_refill(struct virtnet_info *vi)
> > >       spin_unlock_bh(&vi->refill_lock);
> > >  }
> > >
> > > +static void enable_rx_mode_work(struct virtnet_info *vi)
> > > +{
> > > +     rtnl_lock();
> > > +     vi->rx_mode_work_enabled = true;
> > > +     rtnl_unlock();
> > > +}
> > > +
> > > +static void disable_rx_mode_work(struct virtnet_info *vi)
> > > +{
> > > +     rtnl_lock();
> > > +     vi->rx_mode_work_enabled = false;
> > > +     rtnl_unlock();
> > > +}
> > > +
> > >  static void virtqueue_napi_schedule(struct napi_struct *napi,
> > >                                   struct virtqueue *vq)
> > >  {
> > > @@ -2341,9 +2361,11 @@ static int virtnet_close(struct net_device *dev)
> > >       return 0;
> > >  }
> > >
> > > -static void virtnet_set_rx_mode(struct net_device *dev)
> > > +static void virtnet_rx_mode_work(struct work_struct *work)
> > >  {
> > > -     struct virtnet_info *vi = netdev_priv(dev);
> > > +     struct virtnet_info *vi =
> > > +             container_of(work, struct virtnet_info, rx_mode_work);
> > > +     struct net_device *dev = vi->dev;
> > >       struct scatterlist sg[2];
> > >       struct virtio_net_ctrl_mac *mac_data;
> > >       struct netdev_hw_addr *ha;
> > > @@ -2356,6 +2378,8 @@ static void virtnet_set_rx_mode(struct net_device *dev)
> > >       if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_RX))
> > >               return;
> > >
> > > +     rtnl_lock();
> > > +
> > >       vi->ctrl->promisc = ((dev->flags & IFF_PROMISC) != 0);
> > >       vi->ctrl->allmulti = ((dev->flags & IFF_ALLMULTI) != 0);
> > >
> > > @@ -2373,14 +2397,19 @@ static void virtnet_set_rx_mode(struct net_device *dev)
> > >               dev_warn(&dev->dev, "Failed to %sable allmulti mode.\n",
> > >                        vi->ctrl->allmulti ? "en" : "dis");
> > >
> > > +     netif_addr_lock_bh(dev);
> > > +
> > >       uc_count = netdev_uc_count(dev);
> > >       mc_count = netdev_mc_count(dev);
> > >       /* MAC filter - use one buffer for both lists */
> > >       buf = kzalloc(((uc_count + mc_count) * ETH_ALEN) +
> > >                     (2 * sizeof(mac_data->entries)), GFP_ATOMIC);
> > >       mac_data = buf;
> > > -     if (!buf)
> > > +     if (!buf) {
> > > +             netif_addr_unlock_bh(dev);
> > > +             rtnl_unlock();
> > >               return;
> > > +     }
> > >
> > >       sg_init_table(sg, 2);
> > >
> > > @@ -2401,6 +2430,8 @@ static void virtnet_set_rx_mode(struct net_device *dev)
> > >       netdev_for_each_mc_addr(ha, dev)
> > >               memcpy(&mac_data->macs[i++][0], ha->addr, ETH_ALEN);
> > >
> > > +     netif_addr_unlock_bh(dev);
> > > +
> > >       sg_set_buf(&sg[1], mac_data,
> > >                  sizeof(mac_data->entries) + (mc_count * ETH_ALEN));
> > >
> > > @@ -2408,9 +2439,19 @@ static void virtnet_set_rx_mode(struct net_device *dev)
> > >                                 VIRTIO_NET_CTRL_MAC_TABLE_SET, sg))
> > >               dev_warn(&dev->dev, "Failed to set MAC filter table.\n");
> > >
> > > +     rtnl_unlock();
> > > +
> > >       kfree(buf);
> > >  }
> > >
> > > +static void virtnet_set_rx_mode(struct net_device *dev)
> > > +{
> > > +     struct virtnet_info *vi = netdev_priv(dev);
> > > +
> > > +     if (vi->rx_mode_work_enabled)
> > > +             schedule_work(&vi->rx_mode_work);
> > > +}
> > > +
> >
> > >  static int virtnet_vlan_rx_add_vid(struct net_device *dev,
> > >                                  __be16 proto, u16 vid)
> > >  {
> > > @@ -3181,6 +3222,8 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
> > >
> > >       /* Make sure no work handler is accessing the device */
> > >       flush_work(&vi->config_work);
> > > +     disable_rx_mode_work(vi);
> > > +     flush_work(&vi->rx_mode_work);
> > >
> > >       netif_tx_lock_bh(vi->dev);
> > >       netif_device_detach(vi->dev);
> >
> > Hmm so queued rx mode work will just get skipped
> > and on restore we get a wrong rx mode.
> > Any way to make this more robust?
> 
> It could be done by scheduling a work on restore.
> 
> Thanks


> >
> >
> > > @@ -3203,6 +3246,7 @@ static int virtnet_restore_up(struct virtio_device *vdev)
> > >       virtio_device_ready(vdev);
> > >
> > >       enable_delayed_refill(vi);
> > > +     enable_rx_mode_work(vi);
> > >
> > >       if (netif_running(vi->dev)) {
> > >               err = virtnet_open(vi->dev);
> > > @@ -4002,6 +4046,7 @@ static int virtnet_probe(struct virtio_device *vdev)
> > >       vdev->priv = vi;
> > >
> > >       INIT_WORK(&vi->config_work, virtnet_config_changed_work);
> > > +     INIT_WORK(&vi->rx_mode_work, virtnet_rx_mode_work);
> > >       spin_lock_init(&vi->refill_lock);
> > >
> > >       if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF)) {
> > > @@ -4110,6 +4155,8 @@ static int virtnet_probe(struct virtio_device *vdev)
> > >       if (vi->has_rss || vi->has_rss_hash_report)
> > >               virtnet_init_default_rss(vi);
> > >
> > > +     enable_rx_mode_work(vi);
> > > +
> > >       /* serialize netdev register + virtio_device_ready() with ndo_open() */
> > >       rtnl_lock();
> > >
> > > @@ -4207,6 +4254,8 @@ static void virtnet_remove(struct virtio_device *vdev)
> > >
> > >       /* Make sure no work handler is accessing the device. */
> > >       flush_work(&vi->config_work);
> > > +     disable_rx_mode_work(vi);
> > > +     flush_work(&vi->rx_mode_work);
> > >
> > >       unregister_netdev(vi->dev);
> > >
> > > --
> > > 2.25.1
> >


