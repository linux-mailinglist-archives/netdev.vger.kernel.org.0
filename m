Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B53D589875
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 09:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239067AbiHDHgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 03:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238980AbiHDHgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 03:36:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 676DA6555
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 00:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659598569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3/muRkmZux4hv+ibTgAF3IB/lKVb0GckZo4ERwwvrw0=;
        b=NlUhqNN6KHptMYoYZ6vZiOWOw802dYVby3t+JaZG4beaDuIiGkLZ7kSQPPPTcytlD9LE8a
        2cgKq/fo0/w+UbFEyeWhW4KEk3i8/4UKr/nCCMll5DIaDadn5c27dSGzH58OF43RtTJpBs
        KS5YPHGdNSzOOY2GkLYcJlb72jkfsco=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418-EbRA70g4MtypJQT8HQ0IBA-1; Thu, 04 Aug 2022 03:36:06 -0400
X-MC-Unique: EbRA70g4MtypJQT8HQ0IBA-1
Received: by mail-lj1-f200.google.com with SMTP id j15-20020a2e850f000000b0025e6da69e18so769022lji.18
        for <netdev@vger.kernel.org>; Thu, 04 Aug 2022 00:36:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3/muRkmZux4hv+ibTgAF3IB/lKVb0GckZo4ERwwvrw0=;
        b=cIUtXWbsfnrDaFnJCR3oijnTw175+hAA4DZM3nS0TFnen71/P3BriIZaU+Y53wbJQA
         Wt1aRfdhj7TxNgKYyscDgJ8hIZ5jWeZOOwUWXFmLb2jL2xJzAxiHeGojGX/uhI47ij1o
         1ZXntAb6/6MCiONmEEs/nIqSGI4TSV85zArc8EAeFdvGDtOeBMslxSZ5xidpkgnbdO6p
         twQZh8/xhSzV6r0k3/HJn1nIAqhC9eUE0o76BKU1vfnORm8adDdBGLtYz6QlmT1vbraj
         02IiknGUr+jzS1HwJxFQRyuGIPCwBuJaeTRsxy5WE4r2vAQ5xgk3T/+m7zEyeixiEGzv
         DVJA==
X-Gm-Message-State: ACgBeo2+Td6Y2r9KdEhISqxNkg2rZMx5ZvDasA7QIJETGDU7UxntewDO
        XaXssfaoAAALNoUb6NsF3SSsiHqKMgIIsV37iMcf74MJcAgehBAaDYb/T0whn/+Nv0QMaw6PVDU
        s9XNXt9x5IyBr1tJXC6a13AGal9WTS6Rr
X-Received: by 2002:a2e:944d:0:b0:25e:6fbf:4a02 with SMTP id o13-20020a2e944d000000b0025e6fbf4a02mr175941ljh.323.1659598564897;
        Thu, 04 Aug 2022 00:36:04 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4WyJkqP9zMTF5pOWPqJ+IHorwZ+JCDjdZHzX+TqrbwcI3nlP/+2xwwglAHxYjDerGDb9kg/2qog+EM2jKNg38=
X-Received: by 2002:a2e:944d:0:b0:25e:6fbf:4a02 with SMTP id
 o13-20020a2e944d000000b0025e6fbf4a02mr175928ljh.323.1659598564723; Thu, 04
 Aug 2022 00:36:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220804063248.104523-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20220804063248.104523-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 4 Aug 2022 15:35:53 +0800
Message-ID: <CACGkMEvDE2mBHx7BOt0c6VswwzaJ4nTfb3+MMbRE=NS90YRAvA@mail.gmail.com>
Subject: Re: [PATCH net] virtio_net: fix memory leak inside XPD_TX with mergeable
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 4, 2022 at 2:33 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> When we call xdp_convert_buff_to_frame() to get xdpf, if it returns
> NULL, we should check if xdp_page was allocated by xdp_linearize_page().
> If it is newly allocated, it should be freed here alone. Just like any
> other "goto err_xdp".
>
> Fixes: 44fa2dbd4759 ("xdp: transition into using xdp_frame for ndo_xdp_xmit")
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/net/virtio_net.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ec8e1b3108c3..3b3eebad3977 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1057,8 +1057,11 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>                 case XDP_TX:
>                         stats->xdp_tx++;
>                         xdpf = xdp_convert_buff_to_frame(&xdp);
> -                       if (unlikely(!xdpf))
> +                       if (unlikely(!xdpf)) {
> +                               if (unlikely(xdp_page != page))
> +                                       put_page(xdp_page);
>                                 goto err_xdp;
> +                       }
>                         err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
>                         if (unlikely(!err)) {
>                                 xdp_return_frame_rx_napi(xdpf);
> --
> 2.31.0
>

