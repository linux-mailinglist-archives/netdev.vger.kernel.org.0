Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9265E55140F
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 11:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239558AbiFTJSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 05:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240728AbiFTJSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 05:18:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18F5B7665
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 02:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655716723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AXb8PQzSuHtcxtD5+f9CgGG707rMaJ28CjJj10Bwyow=;
        b=aUMvY68iOiUTGi0RU/p+n+hSIVH2rJo8d6ffKxHhkE7uKFIlSmY7BtZa+RLO/MtTgaIiOC
        lqImVpT9vLyxa3Xerv18u19Ur79j2WRyO3c+rLLXc6gKq7+qrpO2pNEWcM2o+ns5bMiJOX
        5QZ90KYxPspThhftnXR1GlYpRzqAn1Q=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-89r5TlZcN_CJv-nOV3ui6A-1; Mon, 20 Jun 2022 05:18:42 -0400
X-MC-Unique: 89r5TlZcN_CJv-nOV3ui6A-1
Received: by mail-lj1-f200.google.com with SMTP id l25-20020a2e99d9000000b0025a681a760dso391393ljj.6
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 02:18:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AXb8PQzSuHtcxtD5+f9CgGG707rMaJ28CjJj10Bwyow=;
        b=V41sw1zPgjX5Nt2T3xVsh8aGOto2jTVGZGtLFbpFiJ007JOTQsuDdBnjD+od59obnY
         4gpCAMyMjnwnRZ9jaotgOF2o4OUBOHAnHq0y2re8mEtIP5QkddQftHlbNwVfwATqdfZ1
         LFVo4RpOMvBNziIE9So9mqh5hPawfGGuXZAU8/WT/dxn82Q85HBTj9TiVpgITehXmJsW
         p5vfy/3wa0LYCjJYFfU8U79Frruc0VOj7P6WQfHSMNABnH5/vExSm7hrCLzjbsaXYSi/
         W65qDtwxRs5jME4yHHurTtNcEAgbuXgjGQhECaTgQIeA8QT/Ebt68uLl3wPtvESHIaMK
         HkgQ==
X-Gm-Message-State: AJIora/HB9Wo34O3Tk7VWT3I8Po5pCz6uZeR7nqau0kl/Dus8ViODpmJ
        ptRxgNsadb+KhYdzsLB8gQbH+Rv7oMcgkZcglst7xDzr95hYLbaDF0DPJtJMejh7+lq99460+7p
        2OooJPc6uJu/pRAZ5M7xt5rEOJZBQsHY+
X-Received: by 2002:a2e:3a16:0:b0:255:7811:2827 with SMTP id h22-20020a2e3a16000000b0025578112827mr11190681lja.130.1655716720473;
        Mon, 20 Jun 2022 02:18:40 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tgaoFSoLISRFH9h+lSO0AXM25Aoq8+VJEqPR3rbJHlSQaKiS3xClDL7guWIBhuvU/zP5YTgnYDl5S5lhrRRnk=
X-Received: by 2002:a2e:3a16:0:b0:255:7811:2827 with SMTP id
 h22-20020a2e3a16000000b0025578112827mr11190676lja.130.1655716720289; Mon, 20
 Jun 2022 02:18:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220620051115.3142-1-jasowang@redhat.com> <20220620051115.3142-4-jasowang@redhat.com>
 <20220620050446-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220620050446-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 20 Jun 2022 17:18:29 +0800
Message-ID: <CACGkMEsEq3mu6unXx1VZuEFgDCotOc9v7fcwJG-kXEqs6hXYYg@mail.gmail.com>
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

On Mon, Jun 20, 2022 at 5:09 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Jun 20, 2022 at 01:11:15PM +0800, Jason Wang wrote:
> > We use to do the following steps during .remove():
>
> We currently do
>
>
> > static void cfv_remove(struct virtio_device *vdev)
> > {
> >       struct cfv_info *cfv = vdev->priv;
> >
> >       rtnl_lock();
> >       dev_close(cfv->ndev);
> >       rtnl_unlock();
> >
> >       tasklet_kill(&cfv->tx_release_tasklet);
> >       debugfs_remove_recursive(cfv->debugfs);
> >
> >       vringh_kiov_cleanup(&cfv->ctx.riov);
> >       virtio_reset_device(vdev);
> >       vdev->vringh_config->del_vrhs(cfv->vdev);
> >       cfv->vr_rx = NULL;
> >       vdev->config->del_vqs(cfv->vdev);
> >       unregister_netdev(cfv->ndev);
> > }
> > This is racy since device could be re-opened after dev_close() but
> > before unregister_netdevice():
> >
> > 1) RX vringh is cleaned before resetting the device, rx callbacks that
> >    is called after the vringh_kiov_cleanup() will result a UAF
> > 2) Network stack can still try to use TX virtqueue even if it has been
> >    deleted after dev_vqs()
> >
> > Fixing this by unregistering the network device first to make sure not
> > device access from both TX and RX side.
> >
> > Fixes: 0d2e1a2926b18 ("caif_virtio: Introduce caif over virtio")
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> >  drivers/net/caif/caif_virtio.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
> > index 66375bea2fcd..a29f9b2df5b1 100644
> > --- a/drivers/net/caif/caif_virtio.c
> > +++ b/drivers/net/caif/caif_virtio.c
> > @@ -752,9 +752,8 @@ static void cfv_remove(struct virtio_device *vdev)
> >  {
> >       struct cfv_info *cfv = vdev->priv;
> >
> > -     rtnl_lock();
> > -     dev_close(cfv->ndev);
> > -     rtnl_unlock();
> > +     /* Make sure NAPI/TX won't try to access the device */
> > +     unregister_netdev(cfv->ndev);
> >
> >       tasklet_kill(&cfv->tx_release_tasklet);
> >       debugfs_remove_recursive(cfv->debugfs);
> > @@ -764,7 +763,6 @@ static void cfv_remove(struct virtio_device *vdev)
> >       vdev->vringh_config->del_vrhs(cfv->vdev);
> >       cfv->vr_rx = NULL;
> >       vdev->config->del_vqs(cfv->vdev);
> > -     unregister_netdev(cfv->ndev);
> >  }
>
>
> This gives me pause, callbacks can now trigger after device
> has been unregistered. Are we sure this is safe?

It looks safe, for RX NAPI is disabled. For TX, tasklet is disabled
after tasklet_kill(). I can add a comment to explain this.

> Won't it be safer to just keep the rtnl_lock around
> the whole process?

It looks to me we rtnl_lock can't help in synchronizing with the
callbacks, anything I miss?

Thanks

>
> >  static struct virtio_device_id id_table[] = {
> > --
> > 2.25.1
>

