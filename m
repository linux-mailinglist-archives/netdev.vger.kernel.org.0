Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE62552AF4
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 08:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345491AbiFUGZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 02:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236786AbiFUGZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 02:25:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2661318B09
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 23:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655792727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9vkl6K79nfxbxKEX0DIwGmMpY5XA3ZSnIwpY7DQqp7w=;
        b=eSzslpyTJHofoflz89ieUbk8od3e8tGgLbovuZvYX47DfWgfTwfLWHFqZbYPiqtur+rvae
        /rSlYofP7XGC/y8SbhvFEfoSyOJqpRD7kFF8RRPUnmb+brWs8+YPAeIh5bNVR8+QGQHyTc
        BP+AWUWRqpHtzdI8BB7sba/W9kT0ySg=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-L2zn5wSSPAq1OrV1-aXbJw-1; Tue, 21 Jun 2022 02:25:25 -0400
X-MC-Unique: L2zn5wSSPAq1OrV1-aXbJw-1
Received: by mail-lf1-f69.google.com with SMTP id bq4-20020a056512150400b0047f7f36efc6so465199lfb.9
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 23:25:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9vkl6K79nfxbxKEX0DIwGmMpY5XA3ZSnIwpY7DQqp7w=;
        b=eloH0TwvTPJnnyGNbWtbNcjuBghghbb5rSAeP1wURYLXJn+TomRMly0cw0TQYArlar
         6gkcvtDVakEMwydyTCpWhoN5tObyswi+tq9WRr//2pmznCkrd/ydnc/XzjOeWH/lygkW
         uF1mXjXt0kMm9D19aWcoda46+5A96ilDMXevu5H2wJ8wWNKuPXe3srI2xJqu5mzeJAfc
         pEyICSA8LC8rNYEhrSHrLIigXwU5JLl3ZQdnrDNEE2qd41Q0UY9u7lG3sf7cB/h7Nsnh
         86d/Ch2+wF5KYWMr0Z71pblD99fyunlc4/7+Htri72JCTbSBhCMQ9EbbMiMt6IKcm5Cx
         G8cw==
X-Gm-Message-State: AJIora8d11bHY+RCicl1KMKDV56Jp6xDp3GIESvTwYxKHvF1t+/Anbff
        oOo8VzUCWS3O68GCkVipDd83XGiqLWDAvpDzv3kmisJuAA1ChFJ2kXhwe22g7Fy3LUUqx8FVQLp
        FspnY6i4WogZJP2HpWLsBRHUhUuUR+Dst
X-Received: by 2002:a05:6512:158d:b0:47f:718c:28b5 with SMTP id bp13-20020a056512158d00b0047f718c28b5mr4440722lfb.397.1655792724196;
        Mon, 20 Jun 2022 23:25:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1snQmZAFq0OU2yReyGppSCc3x0Hn6RAHMizDeVt63/wmQvk3IeHI+fzf6PkF3AfRAf8B/1aJkCfPGcPZar/K3M=
X-Received: by 2002:a05:6512:158d:b0:47f:718c:28b5 with SMTP id
 bp13-20020a056512158d00b0047f718c28b5mr4440713lfb.397.1655792723972; Mon, 20
 Jun 2022 23:25:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220620051115.3142-1-jasowang@redhat.com> <20220620051115.3142-4-jasowang@redhat.com>
 <20220620050446-mutt-send-email-mst@kernel.org> <CACGkMEsEq3mu6unXx1VZuEFgDCotOc9v7fcwJG-kXEqs6hXYYg@mail.gmail.com>
 <20220620061607-mutt-send-email-mst@kernel.org> <CACGkMEu7k2X6S0tSsuGOb-Ta+MzzYE5NzHgrhR2H1vgmcLqjCw@mail.gmail.com>
 <20220621020013-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220621020013-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 21 Jun 2022 14:25:13 +0800
Message-ID: <CACGkMEtQPWmV297_4oak2KxGhXYgef-eevB3KsC7RDy8mSMbNA@mail.gmail.com>
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

On Tue, Jun 21, 2022 at 2:00 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Jun 21, 2022 at 11:09:45AM +0800, Jason Wang wrote:
> > On Mon, Jun 20, 2022 at 6:18 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Mon, Jun 20, 2022 at 05:18:29PM +0800, Jason Wang wrote:
> > > > On Mon, Jun 20, 2022 at 5:09 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > >
> > > > > On Mon, Jun 20, 2022 at 01:11:15PM +0800, Jason Wang wrote:
> > > > > > We use to do the following steps during .remove():
> > > > >
> > > > > We currently do
> > > > >
> > > > >
> > > > > > static void cfv_remove(struct virtio_device *vdev)
> > > > > > {
> > > > > >       struct cfv_info *cfv = vdev->priv;
> > > > > >
> > > > > >       rtnl_lock();
> > > > > >       dev_close(cfv->ndev);
> > > > > >       rtnl_unlock();
> > > > > >
> > > > > >       tasklet_kill(&cfv->tx_release_tasklet);
> > > > > >       debugfs_remove_recursive(cfv->debugfs);
> > > > > >
> > > > > >       vringh_kiov_cleanup(&cfv->ctx.riov);
> > > > > >       virtio_reset_device(vdev);
> > > > > >       vdev->vringh_config->del_vrhs(cfv->vdev);
> > > > > >       cfv->vr_rx = NULL;
> > > > > >       vdev->config->del_vqs(cfv->vdev);
> > > > > >       unregister_netdev(cfv->ndev);
> > > > > > }
> > > > > > This is racy since device could be re-opened after dev_close() but
> > > > > > before unregister_netdevice():
> > > > > >
> > > > > > 1) RX vringh is cleaned before resetting the device, rx callbacks that
> > > > > >    is called after the vringh_kiov_cleanup() will result a UAF
> > > > > > 2) Network stack can still try to use TX virtqueue even if it has been
> > > > > >    deleted after dev_vqs()
> > > > > >
> > > > > > Fixing this by unregistering the network device first to make sure not
> > > > > > device access from both TX and RX side.
> > > > > >
> > > > > > Fixes: 0d2e1a2926b18 ("caif_virtio: Introduce caif over virtio")
> > > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > > ---
> > > > > >  drivers/net/caif/caif_virtio.c | 6 ++----
> > > > > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
> > > > > > index 66375bea2fcd..a29f9b2df5b1 100644
> > > > > > --- a/drivers/net/caif/caif_virtio.c
> > > > > > +++ b/drivers/net/caif/caif_virtio.c
> > > > > > @@ -752,9 +752,8 @@ static void cfv_remove(struct virtio_device *vdev)
> > > > > >  {
> > > > > >       struct cfv_info *cfv = vdev->priv;
> > > > > >
> > > > > > -     rtnl_lock();
> > > > > > -     dev_close(cfv->ndev);
> > > > > > -     rtnl_unlock();
> > > > > > +     /* Make sure NAPI/TX won't try to access the device */
> > > > > > +     unregister_netdev(cfv->ndev);
> > > > > >
> > > > > >       tasklet_kill(&cfv->tx_release_tasklet);
> > > > > >       debugfs_remove_recursive(cfv->debugfs);
> > > > > > @@ -764,7 +763,6 @@ static void cfv_remove(struct virtio_device *vdev)
> > > > > >       vdev->vringh_config->del_vrhs(cfv->vdev);
> > > > > >       cfv->vr_rx = NULL;
> > > > > >       vdev->config->del_vqs(cfv->vdev);
> > > > > > -     unregister_netdev(cfv->ndev);
> > > > > >  }
> > > > >
> > > > >
> > > > > This gives me pause, callbacks can now trigger after device
> > > > > has been unregistered. Are we sure this is safe?
> > > >
> > > > It looks safe, for RX NAPI is disabled. For TX, tasklet is disabled
> > > > after tasklet_kill(). I can add a comment to explain this.
> > >
> > > that waits for outstanding tasklets but does it really prevent
> > > future ones?
> >
> > I think so, it tries to test and set TASKLET_STATE_SCHED which blocks
> > the future scheduling of a tasklet.
> >
> > Thanks
>
> But then in the end it clears it, does it not?

Right, so we need to reset before taskset_kill().

Thanks

>
> > >
> > > > > Won't it be safer to just keep the rtnl_lock around
> > > > > the whole process?
> > > >
> > > > It looks to me we rtnl_lock can't help in synchronizing with the
> > > > callbacks, anything I miss?
> > > >
> > > > Thanks
> > >
> > > good point.
> > >
> > >
> > > > >
> > > > > >  static struct virtio_device_id id_table[] = {
> > > > > > --
> > > > > > 2.25.1
> > > > >
> > >
>

