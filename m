Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A442643CB4
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 06:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbiLFFc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 00:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiLFFcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 00:32:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37CE22534
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 21:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670304713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M4jYQApmL+usNuNEAfFw2Nb6ZS+E8atQWPQ4LsFIloQ=;
        b=TSsT/W7FXWAc/QPq/VXKf1L8MJaxEiKpNeH+HI15GC9YQip/W/g1p83y3N6p+DgnNFoQXV
        fX1mMVF3/9vaF7zW9D4t4veftOOtz6ogb8tKcmkd5LzMudkn4+iVlwW6yQv+cr0DodeqKX
        TsyeMFGy4wi23d+zgGBcOeDEO0v93Vc=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-497-AXdn3erZOai6uyO7GXzEvQ-1; Tue, 06 Dec 2022 00:31:48 -0500
X-MC-Unique: AXdn3erZOai6uyO7GXzEvQ-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-144799384a5so3126528fac.12
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 21:31:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M4jYQApmL+usNuNEAfFw2Nb6ZS+E8atQWPQ4LsFIloQ=;
        b=7L/ns9jRjn6u6oTIku8KVlfdVj9iR7mBaxts9ClRLk1ZnWAb6OnpRcCXp2w4x/SJuj
         67AIEgBWprC57F0ymCF0jYZRPxWk88EOLo6vLZZpVlWQc7KfhVoGTJrN2AzQHqRBSWQx
         E1xiEGWhdr57bJbAzPn8aC2HzsCUisFDT4bqSmZDQ3+/Yuk43p3v5gZkxAP6dWEd7Zl2
         QQO5bVTSLptabQ9Vet2+ONrArip9eFYmyklwLNGLY7goxyar5E6uNmpmCLxDOlEQDhxE
         iO/zBL7inGWd5DQ9mg7TVrF+leGvg8Cm5Z2kXC0+WFX40i41GhP/JFOaceoJ/tczTAKS
         T17w==
X-Gm-Message-State: ANoB5pmKyzRQ45/l+bbuWFmpFQZ/LMAFYkfDzn36yqLo968H6fWMos1J
        qZB6IprQvQW1cYkPCw7VcZETph3aV+Md1vrRoyT+qNpj9bQnEY/opwYO7F6cpTFIS7Ea0nwsHqM
        bG6vu4+lbYnHIwwgHIkiY4U8ry1HmYCMq
X-Received: by 2002:a05:6870:b9b:b0:144:b22a:38d3 with SMTP id lg27-20020a0568700b9b00b00144b22a38d3mr2688934oab.280.1670304707842;
        Mon, 05 Dec 2022 21:31:47 -0800 (PST)
X-Google-Smtp-Source: AA0mqf51i0iUaFszXKYuaebvANrMUwYCsYmCwpdlwO+FrUNB/le+UKxGmQ4fEzSosOe7boGZe7/P92lxILNsX3YRVxw=
X-Received: by 2002:a05:6870:b9b:b0:144:b22a:38d3 with SMTP id
 lg27-20020a0568700b9b00b00144b22a38d3mr2688925oab.280.1670304707639; Mon, 05
 Dec 2022 21:31:47 -0800 (PST)
MIME-Version: 1.0
References: <20221122074348.88601-1-hengqi@linux.alibaba.com> <20221122074348.88601-4-hengqi@linux.alibaba.com>
In-Reply-To: <20221122074348.88601-4-hengqi@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 6 Dec 2022 13:31:36 +0800
Message-ID: <CACGkMEu_WTLJ4QRJ4_KevGLFAu=L7qgY6zV0McnSsDe2TLRawQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/9] virtio_net: update bytes calculation for xdp_frame
To:     Heng Qi <hengqi@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
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

On Tue, Nov 22, 2022 at 3:44 PM Heng Qi <hengqi@linux.alibaba.com> wrote:
>
> Update relative record value for xdp_frame as basis
> for multi-buffer xdp transmission.
>
> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/net/virtio_net.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8f7d207d58d6..d3e8c63b9c4b 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -658,7 +658,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>                 if (likely(is_xdp_frame(ptr))) {
>                         struct xdp_frame *frame = ptr_to_xdp(ptr);
>
> -                       bytes += frame->len;
> +                       bytes += xdp_get_frame_len(frame);
>                         xdp_return_frame(frame);
>                 } else {
>                         struct sk_buff *skb = ptr;
> @@ -1604,7 +1604,7 @@ static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
>                 } else {
>                         struct xdp_frame *frame = ptr_to_xdp(ptr);
>
> -                       bytes += frame->len;
> +                       bytes += xdp_get_frame_len(frame);
>                         xdp_return_frame(frame);
>                 }
>                 packets++;
> --
> 2.19.1.6.gb485710b
>

