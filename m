Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3929D6D3BE4
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 04:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbjDCCpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 22:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbjDCCpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 22:45:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188ABB74F
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 19:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680489860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4d82zEx4OoGYJZ5IgbT3LPSSEyoH17uMTnlYcS8X6gQ=;
        b=AM/A8RB3C1ckcqE859RlLU+/SMmEUjD4CU5nMW2CWVmD0CEesDR+/EsWxRhPfWuWIYzncy
        rxir4v5HuhOr5xY0VSwPbiQ3Xgb7NcajqqD5cpH2DGo2CD97uPboWYAgmiOkbpWZd9UKLy
        VntjMLqJEaATWJxA8FwcJmt4oInW1wQ=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-qvAicn4INiChM2B6fr5cZA-1; Sun, 02 Apr 2023 22:44:19 -0400
X-MC-Unique: qvAicn4INiChM2B6fr5cZA-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-18032227bc5so4905344fac.9
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 19:44:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680489857; x=1683081857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4d82zEx4OoGYJZ5IgbT3LPSSEyoH17uMTnlYcS8X6gQ=;
        b=xq0uv/mkZnAuMVdM4JiQZw8sSLVWrnnQg/hfHPISFWDPsdNGeC8Mqwv7IZXKAq+1ob
         XdggjmLbbrXGxgBpIxB842EFUnNAmUto2xobfx6nSirmcrBk35UtzsiYrh0s83brFGQ2
         gjPaG5+ZVPf2itEC7pT/loDr89y3G5C3C/A3TDtRQDzNyu+ok2RLLENemDVWc+nIUJQH
         JuoaduwnBTiWCCIYYVFjLHVlTEdBQOajL/5S/b7BbmTo2ECQ7/zXsdifX23R8bUCMD0a
         ZyVibZeX8DkezlQLQ0CDgXYsu7fqvz4yujeE0lxr700KYWnXx9QkkEADTyHBvYeegOhn
         1wfw==
X-Gm-Message-State: AAQBX9c6TLoDFuE34dvgo/m7hAO8emJHvR3ArKpSWI64Y9wljbD7XJrH
        X/WILV8UIyBUhb6xqoLIyd070DqXv6JEEvB0oVBRqumj+5DXERZOVLcb6UGDTH6JSDOnxgszmAk
        w9tF8kDqwM9uT+7k4rsRAspRBK/S7vM7RJ58xuizg7Wl8Xg==
X-Received: by 2002:a9d:60d1:0:b0:694:3b4e:d8d7 with SMTP id b17-20020a9d60d1000000b006943b4ed8d7mr6690130otk.0.1680489857288;
        Sun, 02 Apr 2023 19:44:17 -0700 (PDT)
X-Google-Smtp-Source: AKy350aG3SqJ3tAJaPAN6kmGpZJmi0WlfB9MsHdiIUSihP4G1Zc6hDQsqReofmN/xPuHOQbkb3ufvr+FcLUmpCOXAks=
X-Received: by 2002:a9d:60d1:0:b0:694:3b4e:d8d7 with SMTP id
 b17-20020a9d60d1000000b006943b4ed8d7mr6690122otk.0.1680489857074; Sun, 02 Apr
 2023 19:44:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230328120412.110114-1-xuanzhuo@linux.alibaba.com> <20230328120412.110114-5-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230328120412.110114-5-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 3 Apr 2023 10:44:05 +0800
Message-ID: <CACGkMEv+dG0B82Mc+V+A_K1A97M0LLfbF5pwrW6v_M3hp1vDiQ@mail.gmail.com>
Subject: Re: [PATCH net-next 4/8] virtio_net: separate the logic of freeing
 xdp shinfo
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 8:04=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> This patch introduce a new function that releases the
> xdp shinfo. The subsequent patch will reuse this function.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/net/virtio_net.c | 27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 72b9d6ee4024..09aed60e2f51 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -798,6 +798,21 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>         return ret;
>  }
>
> +static void put_xdp_frags(struct xdp_buff *xdp)
> +{
> +       struct skb_shared_info *shinfo;
> +       struct page *xdp_page;
> +       int i;
> +
> +       if (xdp_buff_has_frags(xdp)) {
> +               shinfo =3D xdp_get_shared_info_from_buff(xdp);
> +               for (i =3D 0; i < shinfo->nr_frags; i++) {
> +                       xdp_page =3D skb_frag_page(&shinfo->frags[i]);
> +                       put_page(xdp_page);
> +               }
> +       }
> +}
> +
>  static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buf=
f *xdp,
>                                struct net_device *dev,
>                                unsigned int *xdp_xmit,
> @@ -1312,12 +1327,9 @@ static struct sk_buff *receive_mergeable(struct ne=
t_device *dev,
>         xdp_prog =3D rcu_dereference(rq->xdp_prog);
>         if (xdp_prog) {
>                 unsigned int xdp_frags_truesz =3D 0;
> -               struct skb_shared_info *shinfo;
> -               struct page *xdp_page;
>                 struct xdp_buff xdp;
>                 void *data;
>                 u32 act;
> -               int i;
>
>                 data =3D mergeable_xdp_prepare(vi, rq, xdp_prog, ctx, &fr=
ame_sz, &num_buf, &page,
>                                              offset, &len, hdr);
> @@ -1348,14 +1360,7 @@ static struct sk_buff *receive_mergeable(struct ne=
t_device *dev,
>                         goto err_xdp_frags;
>                 }
>  err_xdp_frags:
> -               if (xdp_buff_has_frags(&xdp)) {
> -                       shinfo =3D xdp_get_shared_info_from_buff(&xdp);
> -                       for (i =3D 0; i < shinfo->nr_frags; i++) {
> -                               xdp_page =3D skb_frag_page(&shinfo->frags=
[i]);
> -                               put_page(xdp_page);
> -                       }
> -               }
> -
> +               put_xdp_frags(&xdp);
>                 goto err_xdp;
>         }
>         rcu_read_unlock();
> --
> 2.32.0.3.g01195cf9f
>

