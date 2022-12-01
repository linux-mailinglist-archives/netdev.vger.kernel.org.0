Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E7D63EBEA
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 10:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiLAJDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 04:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiLAJDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 04:03:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A04A5130D
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 01:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669885332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GbYH4zENy89CzwfflFgwIWWGhamSM9hTJZawssPcIIk=;
        b=EIiuMntjLoOIJmbm2u6Q1t5X80cuQxM+djRxWzpRJ3SWGFNyEoJJNfgt34EcB7QWHWXaz+
        Iqwnw3sjxy4iA4Y73dKR1aeXE7bH8vYx08c3v7L6ZU+rvtp2oBxkLVnRVmxkm4OdkyKnrZ
        mJusS7r+ZYx1XjQSnkJxai/6pZ+z6dc=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-407-BGwe744oOZKR7nGPcNLTRA-1; Thu, 01 Dec 2022 04:02:10 -0500
X-MC-Unique: BGwe744oOZKR7nGPcNLTRA-1
Received: by mail-oo1-f72.google.com with SMTP id m23-20020a4a3917000000b004a08a7cca84so105445ooa.1
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 01:02:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GbYH4zENy89CzwfflFgwIWWGhamSM9hTJZawssPcIIk=;
        b=H1MjcgCB5jmkcFRseVZ4bid9vbb4SuzP7hZVjuxjHKOi8vblWshj44E30XhrvIrE7K
         2PeaxwMBQdLBUOgsMhDpP6Ai6qpQDzbZ4qewL0QF8eaBd7rxsa3sATAJmFcz1HkLmddc
         9Qym4rLdgiQFwo6DiyOLRU4M1OzYRsucSSr8qHzFH+2YdCekE7MXAtAkgigNbGq9fLcI
         s/bHeRkNI2w0Z9+65VKQbtR2rAYBWsveigNvVlJQOxAw18TvpOUGfgXgmgwaiLvOBnpH
         m+Op2482YeVj8BB50NuqSbIPAyjkihWkuLiRK8swfKNtQikREzpzoCaOu9BURnGHKAQO
         dGwA==
X-Gm-Message-State: ANoB5pn6QjPXO+12Tp1kBF0g7VBCJbh824Svinq0kMcl0z41qf2SyHZ/
        iK4goi7Jpe1GYCucOfylNJfkwxPAxp1LV7SHpug4iNcFh64zdvB4XSjhZHj6zTXWIvufGGl/Qjv
        oIqVqwBTCvtYqHAvNv1eixUyL36XNXbqB
X-Received: by 2002:a05:6870:1e83:b0:132:7b3:29ac with SMTP id pb3-20020a0568701e8300b0013207b329acmr25998078oab.35.1669885330135;
        Thu, 01 Dec 2022 01:02:10 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7tUBOklO4FBQwcg/EeqBEyl7DGUatKoKhFtd+FqPjTxyHkl7yQq5uNlEzKseBa4w5SnURhdbimUzdSSGOuqsc=
X-Received: by 2002:a05:6870:1e83:b0:132:7b3:29ac with SMTP id
 pb3-20020a0568701e8300b0013207b329acmr25998067oab.35.1669885329828; Thu, 01
 Dec 2022 01:02:09 -0800 (PST)
MIME-Version: 1.0
References: <20221123102207.451527-1-asmetanin@yandex-team.ru>
In-Reply-To: <20221123102207.451527-1-asmetanin@yandex-team.ru>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 1 Dec 2022 17:01:58 +0800
Message-ID: <CACGkMEs3gdcQ5_PkYmz2eV-kFodZnnPPhvyRCyLXBYYdfHtNjw@mail.gmail.com>
Subject: Re: [PATCH] vhost_net: revert upend_idx only on retriable error
To:     Andrey Smetanin <asmetanin@yandex-team.ru>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yc-core@yandex-team.ru
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

On Wed, Nov 23, 2022 at 6:24 PM Andrey Smetanin
<asmetanin@yandex-team.ru> wrote:
>
> Fix possible virtqueue used buffers leak and corresponding stuck
> in case of temporary -EIO from sendmsg() which is produced by
> tun driver while backend device is not up.
>
> In case of no-retriable error and zcopy do not revert upend_idx
> to pass packet data (that is update used_idx in corresponding
> vhost_zerocopy_signal_used()) as if packet data has been
> transferred successfully.

Should we mark head.len as VHOST_DMA_DONE_LEN in this case?

Thanks

>
> Signed-off-by: Andrey Smetanin <asmetanin@yandex-team.ru>
> ---
>  drivers/vhost/net.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 20265393aee7..93e9166039b9 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -934,13 +934,16 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>
>                 err = sock->ops->sendmsg(sock, &msg, len);
>                 if (unlikely(err < 0)) {
> +                       bool retry = err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS;
> +
>                         if (zcopy_used) {
>                                 if (vq->heads[ubuf->desc].len == VHOST_DMA_IN_PROGRESS)
>                                         vhost_net_ubuf_put(ubufs);
> -                               nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
> -                                       % UIO_MAXIOV;
> +                               if (retry)
> +                                       nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
> +                                               % UIO_MAXIOV;
>                         }
> -                       if (err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS) {
> +                       if (retry) {
>                                 vhost_discard_vq_desc(vq, 1);
>                                 vhost_net_enable_vq(net, vq);
>                                 break;
> --
> 2.25.1
>

