Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745CE4E1F2D
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 03:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344244AbiCUC5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 22:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344239AbiCUC5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 22:57:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC73D59A5E
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 19:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647831357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NO2jMNKPbBxPcOjWsAxlUEBqWe3bFA7aWl8mJ0qi/hQ=;
        b=SJERbUuEW5pbPy1o+b79ZcejzhI67aS3uqPNU6GyVjK11PNYkJOvb7C7nCF3+qUmCiK4tV
        4Gtqg8HsSayYBsIDwTCcheo6DWWH5QWJdN7rHKuJc5+g/v3zydHRPslVXE1Y2SaVcgiWn6
        xSpRUSdTRJwtrV6DU3LoZLjXhdUwVrs=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-VTBT-kuOPDWMHbVM57CgYg-1; Sun, 20 Mar 2022 22:55:55 -0400
X-MC-Unique: VTBT-kuOPDWMHbVM57CgYg-1
Received: by mail-lf1-f71.google.com with SMTP id d14-20020a05651233ce00b004475964142aso3404312lfg.21
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 19:55:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NO2jMNKPbBxPcOjWsAxlUEBqWe3bFA7aWl8mJ0qi/hQ=;
        b=q+9ddu7ZmGkRzwgEFDxzs/pwWhE6CT/dAiWUuxhiQnoqIOjdLDlqd6kyd8SFQcF6O0
         UEHRa5m3EgaF+7e7M24gmKQYlrpLhxpiU4xBCQGv2AB1qHuQW2J+lmOZIA1G+/M8vhWz
         MTHgsb+xVx8InS4kfztIDBBLiyhoTusZynj4S9f+or4J7LJHKWx17Qj0+xcE5s9HCrcg
         1hOWD+PRCzhR1ex7dPIMUTw+wDwM1UoP49CidfCHTZyZ0qM4NLu2xFFTiHrZUOu8upVE
         QYrJS1N7NdcY4mxJ8+rer+Lhd1PxK68xPQUqseizUBxXQ06h8f0IZMM9P5sAjbeDJHqL
         K6Pg==
X-Gm-Message-State: AOAM532uBR2zZKLrISCY64+VKM7fcCcnd0HwwmRjQVUOF17+n1jyJFPs
        lBTMejU97cmQESpSoDSP0h+3C+42K0KmVfYFm1+XMWJdsHEaXYwwjAIVUdd0LhnhWmrW0aJc/kR
        dscYwNAGgCgr39tRPyfOMjq0uyRvKTtcl
X-Received: by 2002:a2e:824e:0:b0:249:7e3d:c862 with SMTP id j14-20020a2e824e000000b002497e3dc862mr4913444ljh.97.1647831354089;
        Sun, 20 Mar 2022 19:55:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyn4DYJfL7k43PA+Q+9rNfsf0PxiZcBUxbi0IZnQ1UxD/sDF7hmUd0d6p8+yDx5iXE6+RNwYtqAi0iA6OLkqTs=
X-Received: by 2002:a2e:824e:0:b0:249:7e3d:c862 with SMTP id
 j14-20020a2e824e000000b002497e3dc862mr4913431ljh.97.1647831353900; Sun, 20
 Mar 2022 19:55:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220320074449.4909-1-mail@anirudhrb.com>
In-Reply-To: <20220320074449.4909-1-mail@anirudhrb.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 21 Mar 2022 10:55:42 +0800
Message-ID: <CACGkMEtRrmXP-xjggRRSeoJT=9JTAXktPnZdvK-KYbKr4Zxc8g@mail.gmail.com>
Subject: Re: [PATCH v2] vhost: handle error while adding split ranges to iotlb
To:     Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 20, 2022 at 3:45 PM Anirudh Rayabharam <mail@anirudhrb.com> wrote:
>
> vhost_iotlb_add_range_ctx() handles the range [0, ULONG_MAX] by
> splitting it into two ranges and adding them separately. The return
> value of adding the first range to the iotlb is currently ignored.
> Check the return value and bail out in case of an error.
>
> Fixes: e2ae38cf3d91 ("vhost: fix hung thread due to erroneous iotlb entries")
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>
> v2:
> - Add "Fixes:" tag and "Reviewed-by:".
>
> v1:
> https://lore.kernel.org/kvm/20220312141121.4981-1-mail@anirudhrb.com/
>
> ---
>  drivers/vhost/iotlb.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
> index 40b098320b2a..5829cf2d0552 100644
> --- a/drivers/vhost/iotlb.c
> +++ b/drivers/vhost/iotlb.c
> @@ -62,8 +62,12 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
>          */
>         if (start == 0 && last == ULONG_MAX) {
>                 u64 mid = last / 2;
> +               int err = vhost_iotlb_add_range_ctx(iotlb, start, mid, addr,
> +                               perm, opaque);
> +
> +               if (err)
> +                       return err;
>
> -               vhost_iotlb_add_range_ctx(iotlb, start, mid, addr, perm, opaque);
>                 addr += mid + 1;
>                 start = mid + 1;
>         }
> --
> 2.35.1
>

