Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC43D55D6B4
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbiF0Gd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 02:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbiF0GdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 02:33:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2361A271E
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 23:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656311603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k4eRa49m+YdcPBeD5jFFPN5PIxxfzxkdDaDDwK1F1sg=;
        b=JM3lm2PIbeGb5zF3ISGjAXBObG6DrppUjDs27XXnqUZvM+4F6+a52dSX6iMzCqNbSA+9rg
        Sv0exqGN0o79FcUh1qh/PMI8w8Qm5fW2Vw3BvDTi1O8xfaWf0pojQy7PTrPapPxfdQC/bo
        5VQO8sqYu2aYABZWrm/OAXhfMlbNM1k=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-mmFehIuDNgiO4kgmZWm_sw-1; Mon, 27 Jun 2022 02:33:21 -0400
X-MC-Unique: mmFehIuDNgiO4kgmZWm_sw-1
Received: by mail-lf1-f71.google.com with SMTP id bi38-20020a0565120ea600b0047f640eaee0so4243315lfb.4
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 23:33:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k4eRa49m+YdcPBeD5jFFPN5PIxxfzxkdDaDDwK1F1sg=;
        b=RzCtudbMoDnaTrNxnsFkejV+eP88dmctqFdEWxi/v+/T1T9WfkMeN4uFg2FlTmQzGs
         ugXSoM2wp/tXxNVjQYVVctVbBNjOAWRubC6fdBCnHdt74Xc4QAoIhvyBm/qzxsLnfGcu
         M6NEiQL/9jgDIyEepHRnQion/Rq+n/Q3MytaGFYF/wPh3DudoD+maH/onYpnZGXIQtPR
         sp42wKUfaFc2HEpsT5vMnYivrup4Dnyz+TsOalMN7uKewcofB+Wy5Xgkhet/qPt5Qf21
         IWpJHHMZIxrivXq6LqBN+0vWGAWhoLmXvNqfpbAo0gQYMBbmhkUgufTJ9hEkWA2ncbIu
         BReA==
X-Gm-Message-State: AJIora80iRCB93MRKcHauZouuDy0eJGPUob3Pdwd8cDE3s8Tk2gstEa+
        Sd6Qc21bIsJlLNks1ONNLtr0y/Ouu4TkmPEB/ePqlCmo3hvRCb7Ab/qEi0Y7OBpLygnOqUBI1oR
        21xBGnkwIZYmgI5OcA6Mjc+COEl5oK4Ht
X-Received: by 2002:a05:6512:22c3:b0:47f:704b:3820 with SMTP id g3-20020a05651222c300b0047f704b3820mr7251446lfu.411.1656311600157;
        Sun, 26 Jun 2022 23:33:20 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u4kj9/LdxwlhRoiiAperrqoK4EQmj2BMt0PLamzAFFQv2Cn7vjYYLmaS1CdNqkHAmYF6tQcTMfpNkQ98/wUfQ=
X-Received: by 2002:a05:6512:22c3:b0:47f:704b:3820 with SMTP id
 g3-20020a05651222c300b0047f704b3820mr7251428lfu.411.1656311599885; Sun, 26
 Jun 2022 23:33:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220617072949.30734-1-jasowang@redhat.com>
In-Reply-To: <20220617072949.30734-1-jasowang@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 27 Jun 2022 14:33:08 +0800
Message-ID: <CACGkMEstGdmCCVKVXAWsWZXZNiYs7+P3yOtZG2cVNai=F5NyUg@mail.gmail.com>
Subject: Re: [PATCH] virtio-net: fix race between ndo_open() and virtio_device_ready()
To:     mst <mst@redhat.com>, jasowang <jasowang@redhat.com>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 3:29 PM Jason Wang <jasowang@redhat.com> wrote:
>
> We used to call virtio_device_ready() after netdev registration. This
> cause a race between ndo_open() and virtio_device_ready(): if
> ndo_open() is called before virtio_device_ready(), the driver may
> start to use the device before DRIVER_OK which violates the spec.
>
> Fixing this by switching to use register_netdevice() and protect the
> virtio_device_ready() with rtnl_lock() to make sure ndo_open() can
> only be called after virtio_device_ready().
>
> Fixes: 4baf1e33d0842 ("virtio_net: enable VQs early")
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Ok, I think we're fine with this. So I will repost against -net.

If we spot issues with unregistering, we can use a separate patch for that.

Thanks

> ---
>  drivers/net/virtio_net.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index db05b5e930be..8a5810bcb839 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3655,14 +3655,20 @@ static int virtnet_probe(struct virtio_device *vdev)
>         if (vi->has_rss || vi->has_rss_hash_report)
>                 virtnet_init_default_rss(vi);
>
> -       err = register_netdev(dev);
> +       /* serialize netdev register + virtio_device_ready() with ndo_open() */
> +       rtnl_lock();
> +
> +       err = register_netdevice(dev);
>         if (err) {
>                 pr_debug("virtio_net: registering device failed\n");
> +               rtnl_unlock();
>                 goto free_failover;
>         }
>
>         virtio_device_ready(vdev);
>
> +       rtnl_unlock();
> +
>         err = virtnet_cpu_notif_add(vi);
>         if (err) {
>                 pr_debug("virtio_net: registering cpu notifier failed\n");
> --
> 2.25.1
>

