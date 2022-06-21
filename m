Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361D0552AAE
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 08:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344211AbiFUGAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 02:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbiFUGAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 02:00:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0EE11220C6
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 23:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655791235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HpI8G7xwI35B9Nl13pX8pLeBi7qUikVCYP4oyWd8eYk=;
        b=Pi0fhIiqroeufIhx9rBxHHStJIr6fdpYgfpSg6A5up1Q45nQm4jWF10HEKcjmSEFSjO+bn
        MoVzOUOnpVPsWR6O6s7F0UosM1xVcMSDf+AXAtl3+MMwGui1hFDcWE6829prDm9lkPFK2D
        Lx4qVBvMfP7MgUm24TkpuZH1BU0oykA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-Gsx9qZfzOGWhV9JlurZEPg-1; Tue, 21 Jun 2022 02:00:34 -0400
X-MC-Unique: Gsx9qZfzOGWhV9JlurZEPg-1
Received: by mail-wm1-f70.google.com with SMTP id ay28-20020a05600c1e1c00b0039c5cbe76c1so7979479wmb.1
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 23:00:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HpI8G7xwI35B9Nl13pX8pLeBi7qUikVCYP4oyWd8eYk=;
        b=HHsUwnpXetzgjDYpVDMbnL3GsN0bH0iRxzvnqjPbWD8ML1KaIqhpaMt3bY1QyNpcTs
         rgmbzf4nwDNtKGHVP57bl93zMVGAhOB7u1N53M4qqyl6Kab64t5qBZQowWghROYRvPL/
         g76Png1uI/eChRgJdsNtlnk7M+kUFdAUlmVZtE1Sl5P9n4RBAPy0pNsI14qbSP//rJrB
         O661jRl90ScJLP4k8ZJmcEH/5bKB1p26W94nTFdgN1jHkWOQTtpx2UcGVsmtsRNotjA6
         z5/MkNesZ+1xmuHSk/5OuWgUgrA5wh1nMSxiKZPCpOG65rovR4UcqhIu8h0UDhi7TtWk
         XOrA==
X-Gm-Message-State: AJIora/7V5HC/XMo6YrgofV6KB1qgPowW7Dye8tMIWtIUHEr+pMPrrKL
        lpaJ6wFFf/DOXn0KJexPZHRtWUADQ6pdZKNhERVTbeHjVJGPPPUHv6mm0r5ZpeH6ne7iHWO5WUt
        DwGYItCtdwD32qx5i
X-Received: by 2002:adf:db48:0:b0:21b:9733:e134 with SMTP id f8-20020adfdb48000000b0021b9733e134mr1868385wrj.396.1655791233025;
        Mon, 20 Jun 2022 23:00:33 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ueVVv0nYzdNBCnl0LzuMmMaJJwbfPo6vYbVgN8zyrf0qI4HmI616IJk704Hm+OV6yGEEGYsQ==
X-Received: by 2002:adf:db48:0:b0:21b:9733:e134 with SMTP id f8-20020adfdb48000000b0021b9733e134mr1868373wrj.396.1655791232802;
        Mon, 20 Jun 2022 23:00:32 -0700 (PDT)
Received: from redhat.com ([2.53.15.87])
        by smtp.gmail.com with ESMTPSA id i27-20020a1c541b000000b0039c5ab7167dsm21126194wmb.48.2022.06.20.23.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 23:00:32 -0700 (PDT)
Date:   Tue, 21 Jun 2022 02:00:28 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        erwan.yvin@stericsson.com
Subject: Re: [PATCH 3/3] caif_virtio: fix the race between reset and netdev
 unregister
Message-ID: <20220621020013-mutt-send-email-mst@kernel.org>
References: <20220620051115.3142-1-jasowang@redhat.com>
 <20220620051115.3142-4-jasowang@redhat.com>
 <20220620050446-mutt-send-email-mst@kernel.org>
 <CACGkMEsEq3mu6unXx1VZuEFgDCotOc9v7fcwJG-kXEqs6hXYYg@mail.gmail.com>
 <20220620061607-mutt-send-email-mst@kernel.org>
 <CACGkMEu7k2X6S0tSsuGOb-Ta+MzzYE5NzHgrhR2H1vgmcLqjCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEu7k2X6S0tSsuGOb-Ta+MzzYE5NzHgrhR2H1vgmcLqjCw@mail.gmail.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 21, 2022 at 11:09:45AM +0800, Jason Wang wrote:
> On Mon, Jun 20, 2022 at 6:18 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Jun 20, 2022 at 05:18:29PM +0800, Jason Wang wrote:
> > > On Mon, Jun 20, 2022 at 5:09 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Mon, Jun 20, 2022 at 01:11:15PM +0800, Jason Wang wrote:
> > > > > We use to do the following steps during .remove():
> > > >
> > > > We currently do
> > > >
> > > >
> > > > > static void cfv_remove(struct virtio_device *vdev)
> > > > > {
> > > > >       struct cfv_info *cfv = vdev->priv;
> > > > >
> > > > >       rtnl_lock();
> > > > >       dev_close(cfv->ndev);
> > > > >       rtnl_unlock();
> > > > >
> > > > >       tasklet_kill(&cfv->tx_release_tasklet);
> > > > >       debugfs_remove_recursive(cfv->debugfs);
> > > > >
> > > > >       vringh_kiov_cleanup(&cfv->ctx.riov);
> > > > >       virtio_reset_device(vdev);
> > > > >       vdev->vringh_config->del_vrhs(cfv->vdev);
> > > > >       cfv->vr_rx = NULL;
> > > > >       vdev->config->del_vqs(cfv->vdev);
> > > > >       unregister_netdev(cfv->ndev);
> > > > > }
> > > > > This is racy since device could be re-opened after dev_close() but
> > > > > before unregister_netdevice():
> > > > >
> > > > > 1) RX vringh is cleaned before resetting the device, rx callbacks that
> > > > >    is called after the vringh_kiov_cleanup() will result a UAF
> > > > > 2) Network stack can still try to use TX virtqueue even if it has been
> > > > >    deleted after dev_vqs()
> > > > >
> > > > > Fixing this by unregistering the network device first to make sure not
> > > > > device access from both TX and RX side.
> > > > >
> > > > > Fixes: 0d2e1a2926b18 ("caif_virtio: Introduce caif over virtio")
> > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > ---
> > > > >  drivers/net/caif/caif_virtio.c | 6 ++----
> > > > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
> > > > > index 66375bea2fcd..a29f9b2df5b1 100644
> > > > > --- a/drivers/net/caif/caif_virtio.c
> > > > > +++ b/drivers/net/caif/caif_virtio.c
> > > > > @@ -752,9 +752,8 @@ static void cfv_remove(struct virtio_device *vdev)
> > > > >  {
> > > > >       struct cfv_info *cfv = vdev->priv;
> > > > >
> > > > > -     rtnl_lock();
> > > > > -     dev_close(cfv->ndev);
> > > > > -     rtnl_unlock();
> > > > > +     /* Make sure NAPI/TX won't try to access the device */
> > > > > +     unregister_netdev(cfv->ndev);
> > > > >
> > > > >       tasklet_kill(&cfv->tx_release_tasklet);
> > > > >       debugfs_remove_recursive(cfv->debugfs);
> > > > > @@ -764,7 +763,6 @@ static void cfv_remove(struct virtio_device *vdev)
> > > > >       vdev->vringh_config->del_vrhs(cfv->vdev);
> > > > >       cfv->vr_rx = NULL;
> > > > >       vdev->config->del_vqs(cfv->vdev);
> > > > > -     unregister_netdev(cfv->ndev);
> > > > >  }
> > > >
> > > >
> > > > This gives me pause, callbacks can now trigger after device
> > > > has been unregistered. Are we sure this is safe?
> > >
> > > It looks safe, for RX NAPI is disabled. For TX, tasklet is disabled
> > > after tasklet_kill(). I can add a comment to explain this.
> >
> > that waits for outstanding tasklets but does it really prevent
> > future ones?
> 
> I think so, it tries to test and set TASKLET_STATE_SCHED which blocks
> the future scheduling of a tasklet.
> 
> Thanks

But then in the end it clears it, does it not?

> >
> > > > Won't it be safer to just keep the rtnl_lock around
> > > > the whole process?
> > >
> > > It looks to me we rtnl_lock can't help in synchronizing with the
> > > callbacks, anything I miss?
> > >
> > > Thanks
> >
> > good point.
> >
> >
> > > >
> > > > >  static struct virtio_device_id id_table[] = {
> > > > > --
> > > > > 2.25.1
> > > >
> >

