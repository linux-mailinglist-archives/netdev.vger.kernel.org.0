Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC275571AC
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiFWEkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242341AbiFWDzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 23:55:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 447D4EE07
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 20:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655956505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7r6qmkZmyFSR/QZW2a5u/i7ubHA3ZPKofanFmUp6yzI=;
        b=cS+BdbqC3K5IvpqrAnWOay9cbj/9S+weJHCMhEmFnvX5v54zqZhCGyHDT59dO5x+RPhMc6
        YhCSp/gLrAMC7qnp3VF8s2V9AQNEOc5JY+XKroqnau3pWNUV7/d+JyNurshbFann2EO1Wf
        xLtZjcKsQiTDpMV36JO1XDLUJae3kRQ=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-278-IpeYuQFGPx2uzkRUtXs5MQ-1; Wed, 22 Jun 2022 23:55:03 -0400
X-MC-Unique: IpeYuQFGPx2uzkRUtXs5MQ-1
Received: by mail-lf1-f70.google.com with SMTP id c21-20020a056512105500b00479762353a4so9440704lfb.8
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 20:55:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7r6qmkZmyFSR/QZW2a5u/i7ubHA3ZPKofanFmUp6yzI=;
        b=4sHNevxeoQwWX/8CYwIlFsknHEaHJ4qSKstLO0ehQ1uh5CUOds/dcYASKulPrezemg
         zF+at5KyDLqQFNRpGrNisyroWf5d9twFokfw7+NNf6ICpEaNTa/2F9MxrCcWC77Rn9Xp
         Es7Yz/m2+8xzM/kC5hUfj8O5vQERt9k7QaStKQ3RV7K41hYS1fr8gLO47M62WP039njO
         3RHTVTk9aX0jCtp1KAT+fMXnniSGd+6/cJCTwu86Rg6MEFiAmnUbySrV5mQXRXGaP8KY
         2dbKbmKgGyUEbnWt2bqcK/RO2VjrKFsr55f8ZnyRrLtuIC/HE6kJ2SpJx7wP/Kdct+jj
         SHbA==
X-Gm-Message-State: AJIora9wHwFwsRdd9icerzaZACHTwd4I6rDce6rveW5NPAoSfqp6EVcy
        JewwHWmG32Oatwquy4MAqg3i0rWgoovhtEj1MpBWMMt2/0ppvrkcU55PpZvYAwXcg68AzdTkdS1
        PO4JHl3V/5sFQN7EjM/vJWNafKNZeG0nn
X-Received: by 2002:a2e:8958:0:b0:25a:852a:c302 with SMTP id b24-20020a2e8958000000b0025a852ac302mr3663580ljk.130.1655956501262;
        Wed, 22 Jun 2022 20:55:01 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vrF3BW4ecp7uMp7ixhwZNP6zrC/7mtr9RBqWZSr7h7Xd5f5VroJYLw4ej6faDfjvvTZLb0DpnhA3R+kdmS/XI=
X-Received: by 2002:a2e:8958:0:b0:25a:852a:c302 with SMTP id
 b24-20020a2e8958000000b0025a852ac302mr3663568ljk.130.1655956501094; Wed, 22
 Jun 2022 20:55:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220622151407.51232-1-sgarzare@redhat.com>
In-Reply-To: <20220622151407.51232-1-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 23 Jun 2022 11:54:50 +0800
Message-ID: <CACGkMEsW7OAWHZvD6rjGtCE6t3BmEvpz=PmQvbHh1hMq-6RwhA@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: call vhost_vdpa_cleanup during the release
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 11:14 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> Before commit 3d5698793897 ("vhost-vdpa: introduce asid based IOTLB")
> we call vhost_vdpa_iotlb_free() during the release to clean all regions
> mapped in the iotlb.
>
> That commit removed vhost_vdpa_iotlb_free() and added vhost_vdpa_cleanup()
> to do some cleanup, including deleting all mappings, but we forgot to call
> it in vhost_vdpa_release().
>
> This causes that if an application does not remove all mappings explicitly
> (or it crashes), the mappings remain in the iotlb and subsequent
> applications may fail if they map the same addresses.
>
> Calling vhost_vdpa_cleanup() also fixes a memory leak since we are not
> freeing `v->vdev.vqs` during the release from the same commit.
>
> Since vhost_vdpa_cleanup() calls vhost_dev_cleanup() we can remove its
> call from vhost_vdpa_release().
>
> Fixes: 3d5698793897 ("vhost-vdpa: introduce asid based IOTLB")
> Cc: gautam.dawar@xilinx.com
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/vhost/vdpa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 5ad2596c6e8a..23dcbfdfa13b 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1209,7 +1209,7 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
>         vhost_dev_stop(&v->vdev);
>         vhost_vdpa_free_domain(v);
>         vhost_vdpa_config_put(v);
> -       vhost_dev_cleanup(&v->vdev);
> +       vhost_vdpa_cleanup(v);
>         mutex_unlock(&d->mutex);
>
>         atomic_dec(&v->opened);
> --
> 2.36.1
>

