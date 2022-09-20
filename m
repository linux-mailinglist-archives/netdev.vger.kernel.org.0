Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1B85BD9FC
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 04:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiITCQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 22:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiITCQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 22:16:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BC613E9F
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 19:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663640209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zo86NMsPHctYgO0mGry59i4eN15QEnWKnYhNdcDx8JY=;
        b=cb5nP6V5VFGTAq3pcXx8nOu7oosYaMmx903UrAf1jMN6URR0iKsvJpgv648g65TrYHsf0V
        AHZ4OrWiS2wzjLJLoTK0h0xWKy10NP6lf7vf9E1dA8U6jwPweZbygC6DiGyWhTiApY6BM9
        9hEn6HTIy6uDXwz8Flhw5sP7d475Gek=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-564-VaamoJhfNkauEJ4ChXz7sQ-1; Mon, 19 Sep 2022 22:16:46 -0400
X-MC-Unique: VaamoJhfNkauEJ4ChXz7sQ-1
Received: by mail-ua1-f70.google.com with SMTP id k48-20020ab01633000000b003af70af1b2aso399195uae.18
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 19:16:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Zo86NMsPHctYgO0mGry59i4eN15QEnWKnYhNdcDx8JY=;
        b=NGQ/xhpjcHu9KpUPbjYcznMj4Ln9RdOg2owH8Mk2UvcWCC/d7aBFSjHPl3DV0LP7wS
         /euZHjXjzPO9Bd88l2c0NZ8lPer4L4aMiJZMgGu/5l2na4fK6/4pD7Z1BuY0p8y5Zubc
         ft/l9rZSeahIkBQXNWh6wIt6lVcPEpUIaoHxLGQFDp8jbypuVv6L9thcMvMcVgV/jPF3
         iG4O1+640AhllbCRK51tTKjZ118FrFhaIy25EyxpEhXerNzl2fuD0OzhOo/REk6ossWB
         mIHAKUlc1CokQbIwbORhquiCeOidetDXLija4z+L6ZLc0KS6rmWsMBlsqcQhdvLtv+j1
         zLtg==
X-Gm-Message-State: ACrzQf20cOh2CLOnvxythvf3+E6dCPIyyK5hQDUTtWCH3fUiGu/FStyw
        5tOe2YRkilXd77VaErFDZezSNYXyv4FGsIxyNq77X/u/Kh2xFZRWaK8o9rVAMXnBwyZGZU1dKmk
        1PhnN3FyxOBvk6QvK01AphJR5tQ/a0Ayo
X-Received: by 2002:a67:e218:0:b0:398:4d8c:8037 with SMTP id g24-20020a67e218000000b003984d8c8037mr7419386vsa.4.1663640205507;
        Mon, 19 Sep 2022 19:16:45 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7FViMHfT3HYQIWmkPbYd8yvNIQikjkhJmN/lsyJbFbvnrbHHcisI8cT5S05cjpkvJJbjMWFTxmicgwYqVdCPA=
X-Received: by 2002:a67:e218:0:b0:398:4d8c:8037 with SMTP id
 g24-20020a67e218000000b003984d8c8037mr7419382vsa.4.1663640205244; Mon, 19 Sep
 2022 19:16:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220909085712.46006-1-lingshan.zhu@intel.com> <20220909085712.46006-3-lingshan.zhu@intel.com>
In-Reply-To: <20220909085712.46006-3-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 20 Sep 2022 10:16:33 +0800
Message-ID: <CACGkMEsYARr3toEBTxVcwFi86JxK0D-w4OpNtvVdhCEbAnc8ZA@mail.gmail.com>
Subject: Re: [PATCH 2/4] vDPA: only report driver features if FEATURES_OK is set
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 9, 2022 at 5:05 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> vdpa_dev_net_config_fill() should only report driver features
> to userspace after features negotiation is done.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/vdpa.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index 798a02c7aa94..29d7e8858e6f 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -819,6 +819,7 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>         struct virtio_net_config config = {};
>         u64 features_device, features_driver;
>         u16 val_u16;
> +       u8 status;
>
>         vdev->config->get_config(vdev, 0, &config, sizeof(config));
>
> @@ -834,10 +835,14 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>         if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>                 return -EMSGSIZE;
>
> -       features_driver = vdev->config->get_driver_features(vdev);
> -       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
> -                             VDPA_ATTR_PAD))
> -               return -EMSGSIZE;
> +       /* only read driver features after the feature negotiation is done */
> +       status = vdev->config->get_status(vdev);
> +       if (status & VIRTIO_CONFIG_S_FEATURES_OK) {

Any reason this is not checked in its caller as what it used to do before?

Thanks

> +               features_driver = vdev->config->get_driver_features(vdev);
> +               if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
> +                                     VDPA_ATTR_PAD))
> +                       return -EMSGSIZE;
> +       }
>
>         features_device = vdev->config->get_device_features(vdev);
>
> --
> 2.31.1
>

