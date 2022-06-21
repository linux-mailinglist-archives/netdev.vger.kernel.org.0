Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1998055299A
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 05:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244144AbiFUDKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 23:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbiFUDKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 23:10:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4AD111A3B6
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 20:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655780999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5I/A1okM/VsKaRtsTRbiZ/e/0xvi8RkHlF5r4h4SXBQ=;
        b=PUscAvNReY2b2bu/IM4OhImtzky4+BeDf5R/1deiiPzd08H0rSSFbCJofgyNTIlcro9imx
        J0i0sDNrronqedO9v3/vz79DNhNoILNHi3HP9A5AJ5Bog8YUT6sCW9yPJatWAnC3kUxmyR
        ptPvorJtfAfaYP1tUZ3SByHMGq9Lreg=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-pMqkcZ78O1u7jv-NiEpPbA-1; Mon, 20 Jun 2022 23:09:58 -0400
X-MC-Unique: pMqkcZ78O1u7jv-NiEpPbA-1
Received: by mail-lf1-f69.google.com with SMTP id g40-20020a0565123ba800b004791450e602so6305150lfv.17
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 20:09:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5I/A1okM/VsKaRtsTRbiZ/e/0xvi8RkHlF5r4h4SXBQ=;
        b=KiyGIvi5Z/pOpdI6oUAlcUqOiQWsmmubIXrgBgbakRQ4i9YvkW9VrsPbMDyVdzQkHw
         pfKhHKgTctLducpdEPvfssx4rUkaYUkBHXtGRZYwtrzxv6z+qkIMjB1aRedxp8MVdUNh
         aDP18cLc8pziQiIBS56XsSJYV61nTM6oqyCy3xwY6Hk9Op5TBdKJciADsNFXy+e0QCr+
         rTVMzbYsdEh3t3mA08ZrEpol97ZsBEJLZ+Y5n7nsxq7M6I+e4ovv9PUw+41niukPhDS1
         WLl1uzTN7KYhgKZhaqRiPjGSTVgmcqxbtko2r2nFcMNM5burnsLEPglzWO8XqkmI2rAq
         /HZA==
X-Gm-Message-State: AJIora9VbfPjckl1IignP66ocj7RqoIeJNR1CAJ5GdhjgMkrtpjVdHQ/
        0Rj69GsCVTec/DBOTnAVXsakHvm1Wn0misrAv+ksbD8T57Uh70VwzG2Pdb4rVxH3dWKh76PkJaW
        DoKtGvbFYk33YmWseQuPIA1Npmxcu5MUk
X-Received: by 2002:a05:6512:3f0f:b0:47f:6f89:326 with SMTP id y15-20020a0565123f0f00b0047f6f890326mr4639285lfa.124.1655780996572;
        Mon, 20 Jun 2022 20:09:56 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ue+R/3XG0+CAI6OS7Ckr2jK0FXWYnX/c2+y3CX07qDkE24gA6WB9ZJH62m4USzgEMZO/3NXKymWjN8StBbZr4=
X-Received: by 2002:a05:6512:3f0f:b0:47f:6f89:326 with SMTP id
 y15-20020a0565123f0f00b0047f6f890326mr4639277lfa.124.1655780996353; Mon, 20
 Jun 2022 20:09:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220620051115.3142-1-jasowang@redhat.com> <20220620051115.3142-4-jasowang@redhat.com>
 <20220620050446-mutt-send-email-mst@kernel.org> <CACGkMEsEq3mu6unXx1VZuEFgDCotOc9v7fcwJG-kXEqs6hXYYg@mail.gmail.com>
 <20220620061607-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220620061607-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 21 Jun 2022 11:09:45 +0800
Message-ID: <CACGkMEu7k2X6S0tSsuGOb-Ta+MzzYE5NzHgrhR2H1vgmcLqjCw@mail.gmail.com>
Subject: Re: [PATCH 3/3] caif_virtio: fix the race between reset and netdev unregister
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        erwan.yvin@stericsson.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 6:18 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Jun 20, 2022 at 05:18:29PM +0800, Jason Wang wrote:
> > On Mon, Jun 20, 2022 at 5:09 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Mon, Jun 20, 2022 at 01:11:15PM +0800, Jason Wang wrote:
> > > > We use to do the following steps during .remove():
> > >
> > > We currently do
> > >
> > >
> > > > static void cfv_remove(struct virtio_device *vdev)
> > > > {
> > > >       struct cfv_info *cfv = vdev->priv;
> > > >
> > > >       rtnl_lock();
> > > >       dev_close(cfv->ndev);
> > > >       rtnl_unlock();
> > > >
> > > >       tasklet_kill(&cfv->tx_release_tasklet);
> > > >       debugfs_remove_recursive(cfv->debugfs);
> > > >
> > > >       vringh_kiov_cleanup(&cfv->ctx.riov);
> > > >       virtio_reset_device(vdev);
> > > >       vdev->vringh_config->del_vrhs(cfv->vdev);
> > > >       cfv->vr_rx = NULL;
> > > >       vdev->config->del_vqs(cfv->vdev);
> > > >       unregister_netdev(cfv->ndev);
> > > > }
> > > > This is racy since device could be re-opened after dev_close() but
> > > > before unregister_netdevice():
> > > >
> > > > 1) RX vringh is cleaned before resetting the device, rx callbacks that
> > > >    is called after the vringh_kiov_cleanup() will result a UAF
> > > > 2) Network stack can still try to use TX virtqueue even if it has been
> > > >    deleted after dev_vqs()
> > > >
> > > > Fixing this by unregistering the network device first to make sure not
> > > > device access from both TX and RX side.
> > > >
> > > > Fixes: 0d2e1a2926b18 ("caif_virtio: Introduce caif over virtio")
> > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > ---
> > > >  drivers/net/caif/caif_virtio.c | 6 ++----
> > > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
> > > > index 66375bea2fcd..a29f9b2df5b1 100644
> > > > --- a/drivers/net/caif/caif_virtio.c
> > > > +++ b/drivers/net/caif/caif_virtio.c
> > > > @@ -752,9 +752,8 @@ static void cfv_remove(struct virtio_device *vdev)
> > > >  {
> > > >       struct cfv_info *cfv = vdev->priv;
> > > >
> > > > -     rtnl_lock();
> > > > -     dev_close(cfv->ndev);
> > > > -     rtnl_unlock();
> > > > +     /* Make sure NAPI/TX won't try to access the device */
> > > > +     unregister_netdev(cfv->ndev);
> > > >
> > > >       tasklet_kill(&cfv->tx_release_tasklet);
> > > >       debugfs_remove_recursive(cfv->debugfs);
> > > > @@ -764,7 +763,6 @@ static void cfv_remove(struct virtio_device *vdev)
> > > >       vdev->vringh_config->del_vrhs(cfv->vdev);
> > > >       cfv->vr_rx = NULL;
> > > >       vdev->config->del_vqs(cfv->vdev);
> > > > -     unregister_netdev(cfv->ndev);
> > > >  }
> > >
> > >
> > > This gives me pause, callbacks can now trigger after device
> > > has been unregistered. Are we sure this is safe?
> >
> > It looks safe, for RX NAPI is disabled. For TX, tasklet is disabled
> > after tasklet_kill(). I can add a comment to explain this.
>
> that waits for outstanding tasklets but does it really prevent
> future ones?

I think so, it tries to test and set TASKLET_STATE_SCHED which blocks
the future scheduling of a tasklet.

Thanks

>
> > > Won't it be safer to just keep the rtnl_lock around
> > > the whole process?
> >
> > It looks to me we rtnl_lock can't help in synchronizing with the
> > callbacks, anything I miss?
> >
> > Thanks
>
> good point.
>
>
> > >
> > > >  static struct virtio_device_id id_table[] = {
> > > > --
> > > > 2.25.1
> > >
>

