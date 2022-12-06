Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49D4643CA2
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 06:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbiLFFWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 00:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiLFFWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 00:22:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFFC21E3E
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 21:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670304063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KRACJ5x8yLje2KPJIBBBoJLn6lBedOJvNjahTYfPLk0=;
        b=Edg1uvbtQtCl9DW3JCcEaIryNxM3AIXfpWt6E3clpTYppgIOdUl3vpO79Fn4wPEX+atFMa
        PxTycOljwuvsQt3s/ZBZf5rZSOoMjgq6DH83NYRenXDOxlT+cIMaQ3gzaEMNy+wEYbAF8f
        q59pXTvv4XYLLYwbQBAxbzFMfNgcVaY=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-122-P_UsDRreO5apJxDNfRwW2A-1; Tue, 06 Dec 2022 00:21:02 -0500
X-MC-Unique: P_UsDRreO5apJxDNfRwW2A-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-14496b502dfso2518241fac.17
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 21:21:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KRACJ5x8yLje2KPJIBBBoJLn6lBedOJvNjahTYfPLk0=;
        b=O2jfxli3IrMWrLK8v+5lZKmCAcD3Kd3nxaNarq4HwwvwHkm2jiFDO8NcKFXuP0y0nk
         m2OLKbQZtgb04sLP+i10PLZBW+5y1p7pyyV71Atai/e1jMNwx2xVmzQVzh1dGuYocNKW
         8uWVCrOJFCng76gi1OPlEn/BLQnZzsH+g3+e1yoIdd/0GUmhbzse9nTVj2DcEy4Nmanp
         SZ3ywV3YpKndmY1dK0jFkF5rYmk2qifuTHG1vRiwomR/j5KutMuqKJwFdxNgfD3xLeNt
         aDLI9qVXDo/H1a8gU2hSdV6WC3dZvU2PwFUSOYCYhmjbUE/ubsHJy+UdPca/gLGcbHgu
         /wLA==
X-Gm-Message-State: ANoB5pmQunMW8pkevTzHTvU74Bo23RP6aIu6EtY2a1hJzr8wuy+SUoN6
        HLehMBoJY1K0hoHtawJrnUIaX/gprHwoLrzZJ+9C+50ZicPk3nIndcpLtSqfE+XXscZTqPFs5zz
        y7ywSQVJnPYU6/R6K7AyiY9QwbDNa36h6
X-Received: by 2002:aca:1a12:0:b0:35c:303d:fe37 with SMTP id a18-20020aca1a12000000b0035c303dfe37mr4024661oia.35.1670304061385;
        Mon, 05 Dec 2022 21:21:01 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7yQi8cnUumH6KXlDIcpmSaQ8JhCuasF5uUEjFok4iCPzJ6njUk3h2o7PQ6i2Ty8KPNoNL0qL2JYkOM55lE07w=
X-Received: by 2002:aca:1a12:0:b0:35c:303d:fe37 with SMTP id
 a18-20020aca1a12000000b0035c303dfe37mr4024648oia.35.1670304061044; Mon, 05
 Dec 2022 21:21:01 -0800 (PST)
MIME-Version: 1.0
References: <20221122074348.88601-1-hengqi@linux.alibaba.com> <20221122074348.88601-2-hengqi@linux.alibaba.com>
In-Reply-To: <20221122074348.88601-2-hengqi@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 6 Dec 2022 13:20:49 +0800
Message-ID: <CACGkMEvLbpNry+ROQof=tPOoX0W3-qths6493uvjBpb0nNinBQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/9] virtio_net: disable the hole mechanism for xdp
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
> XDP core assumes that the frame_size of xdp_buff and the length of
> the frag are PAGE_SIZE. But before xdp is set, the length of the prefilled
> buffer may exceed PAGE_SIZE, which may cause the processing of xdp to fail,
> so we disable the hole mechanism when xdp is loaded.
>
> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 9cce7dec7366..c5046d21b281 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1419,8 +1419,11 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
>                 /* To avoid internal fragmentation, if there is very likely not
>                  * enough space for another buffer, add the remaining space to
>                  * the current buffer.
> +                * XDP core assumes that frame_size of xdp_buff and the length
> +                * of the frag are PAGE_SIZE, so we disable the hole mechanism.
>                  */
> -               len += hole;
> +               if (!vi->xdp_enabled)

How is this synchronized with virtnet_xdp_set()?

I think we need to use headroom here since it did:

static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
{
        return vi->xdp_enabled ? VIRTIO_XDP_HEADROOM : 0;
}

Otherwise xdp_enabled could be re-read which may lead bugs.

Thanks

> +                       len += hole;
>                 alloc_frag->offset += hole;
>         }
>
> --
> 2.19.1.6.gb485710b
>

