Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E706362228D
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 04:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiKIDZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 22:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbiKIDZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 22:25:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7596419294
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 19:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667964277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F1qirjMG3kZUXL8rp78PkVsEriIi9ata3YC3IMmDFgo=;
        b=Rigx1i/2Ku9x3DLO5JOv66QoRAjFAwSu3neFsFQP7BdHMOqVhaPvr6OhOmOTdFtYqXCjG8
        Vsx7rRBBKheMAVSShyfO8qKpYM+iMbfvvDYGK5gdiS2bkkwCIIkqQAVVBv3FFIia1vSjV7
        xhwEL7dH2PAnBcJMIYO1JbuKUThpkLw=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-9-8jcVadeqNCu4MPmrXliNEA-1; Tue, 08 Nov 2022 22:24:36 -0500
X-MC-Unique: 8jcVadeqNCu4MPmrXliNEA-1
Received: by mail-ot1-f71.google.com with SMTP id o3-20020a9d6d03000000b0066c577eefc4so7881027otp.22
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 19:24:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F1qirjMG3kZUXL8rp78PkVsEriIi9ata3YC3IMmDFgo=;
        b=RfxCPwwbe0qa4jv+ecx7yNrAi/8SSB7Iq2kkfEK+WIfOhoOPr47BkH3Zg1FVHbU4MD
         b8H35MEwAkf4vhTSA40JloM26bgpzLO7lVm4YiaQ4QKHL2A0vy0cJiuOCjOgN0ysQsGe
         PRvj7tnHbTIN0HtGnb0VGkrFz9CkeKdOSnWVFeviErb8PVvzBehm+nCXWTP595oVamLs
         udhq+aBCPEDjRwTft3clSac+EBCJKUVp8Poe27Ip5/mHwtyH9kbllxkAUR3qfgRtYpdi
         udJ+hywfTnfwyvVz+GBUyxOw6AWuOSL0ZmXsUNUSu2VX/CpnaDf2eUnvyaqE6kSMAaai
         pOgg==
X-Gm-Message-State: ACrzQf2ZxUUiJdh+FL6vK5FvQBbm+pmaPx/rQ4+uxaENrco539nHn8Ee
        6Bs4yrA3PrsRg3IkUxPbrbTTCgvLZMFWfXi7qJzhJBuEFuwEoJLZ/0HQZSCSp9hXnvgZLXOUNdX
        bnRKund9ChNIjaw1fCAiIpZxvtcmpafM/
X-Received: by 2002:a4a:2ccf:0:b0:49e:b502:3a2b with SMTP id o198-20020a4a2ccf000000b0049eb5023a2bmr9788967ooo.57.1667964275438;
        Tue, 08 Nov 2022 19:24:35 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4TS8SZHDk+F11XcIXyOjWg7x3CStUwgN7DXqTHrvfbCTUgELD600O6A1TkWZj32gJcP6VoqsHMRgJlXrNy6A0=
X-Received: by 2002:a4a:2ccf:0:b0:49e:b502:3a2b with SMTP id
 o198-20020a4a2ccf000000b0049eb5023a2bmr9788965ooo.57.1667964275202; Tue, 08
 Nov 2022 19:24:35 -0800 (PST)
MIME-Version: 1.0
References: <20221108103437.105327-1-sgarzare@redhat.com> <20221108103437.105327-2-sgarzare@redhat.com>
In-Reply-To: <20221108103437.105327-2-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 9 Nov 2022 11:24:23 +0800
Message-ID: <CACGkMEu+T1zX0XQbe2NR24MBC1LfV6ECv6vOm7ofrvqCJZ4avA@mail.gmail.com>
Subject: Re: [PATCH 1/2] vringh: fix range used in iotlb_translate()
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 8, 2022 at 6:34 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> vhost_iotlb_itree_first() requires `start` and `last` parameters
> to search for a mapping that overlaps the range.
>
> In iotlb_translate() we cyclically call vhost_iotlb_itree_first(),
> incrementing `addr` by the amount already translated, so rightly
> we move the `start` parameter passed to vhost_iotlb_itree_first(),
> but we should hold the `last` parameter constant.
>
> Let's fix it by saving the `last` parameter value before incrementing
> `addr` in the loop.
>
> Fixes: 9ad9c49cfe97 ("vringh: IOTLB support")
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/vhost/vringh.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 11f59dd06a74..828c29306565 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -1102,7 +1102,7 @@ static int iotlb_translate(const struct vringh *vrh,
>         struct vhost_iotlb_map *map;
>         struct vhost_iotlb *iotlb = vrh->iotlb;
>         int ret = 0;
> -       u64 s = 0;
> +       u64 s = 0, last = addr + len - 1;
>
>         spin_lock(vrh->iotlb_lock);
>
> @@ -1114,8 +1114,7 @@ static int iotlb_translate(const struct vringh *vrh,
>                         break;
>                 }
>
> -               map = vhost_iotlb_itree_first(iotlb, addr,
> -                                             addr + len - 1);
> +               map = vhost_iotlb_itree_first(iotlb, addr, last);
>                 if (!map || map->start > addr) {
>                         ret = -EINVAL;
>                         break;
> --
> 2.38.1
>

