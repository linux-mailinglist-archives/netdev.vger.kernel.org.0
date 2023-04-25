Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7696EDCED
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 09:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbjDYHmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 03:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbjDYHm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 03:42:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9387293
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 00:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682408504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vgtdiCdfMaL2IrJBuUV1QXhdAi7SKOJBtJL5aY2h2cc=;
        b=ITGW8aWVStXqq3rThNQcv7c9Hlpv1L7XSE/p7pOLxZb3V06tGXx6oZ2hvffCditCiXAczB
        cBtdJt6fY3yQxTFjm2aaNv8fg/xf+hgNe/uIHYenwna3mSQsT116tN4XtGjfP6jBopuOdp
        cVHEW1HHspWYltwWoT5e23BdvCESrsE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-bml-2tRVPvWMEfxQ5wtRrA-1; Tue, 25 Apr 2023 03:41:42 -0400
X-MC-Unique: bml-2tRVPvWMEfxQ5wtRrA-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-4ec9e0761c6so5443675e87.1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 00:41:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682408500; x=1685000500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vgtdiCdfMaL2IrJBuUV1QXhdAi7SKOJBtJL5aY2h2cc=;
        b=iLsIMLUgFGXyKkJFWWbuxhRuFWsSWMbY3GVzJc4E1nFplivJx88eYge0J7s2d45FxZ
         /8kbnDwTcWA6gWryC0YLff1Q5aAElpiKxI2x4vGZBdYM7vlFeZZfnmV3d2LuVW9io3YU
         E0w55W5MlFE5w3AOr+buCezfkMGNLsq0A3MdQvqMnd9oAcAMWyvwZ3RLR44hK+7CjYFA
         d66MDnj7w/UGickns5C78OHo/gdaINkwnPsnXqmXdWkWg3YTrgHVHiru2qFAM5eci3Ks
         sPq5S7ahttbNAMLPJqCR48ZX6uAOa6dnxjEkS8ZNWmor01k9nb/sOnWR8rk6Iss7+Tkx
         rO1A==
X-Gm-Message-State: AAQBX9cNcECnWBaGEoYC3munagxTX273ATQEKYBXDxPhEt8Vbs3RpRd5
        f0/htbaG9GjIWKfld5W0e8WHR3eux+3SVB1Pr/8htQZmI8c4stXJCv78x8g89AG8Ux/eRz0AqhG
        OHZnTQ+mhV+AGt/ZsGmYMIpXHzv524Kn4
X-Received: by 2002:a2e:b545:0:b0:2a7:6bcd:d8ba with SMTP id a5-20020a2eb545000000b002a76bcdd8bamr3586481ljn.3.1682408500559;
        Tue, 25 Apr 2023 00:41:40 -0700 (PDT)
X-Google-Smtp-Source: AKy350YtbsDQ78FOkCn5PwXZvtQ47STnF7zTV74XDSGcUXlb0/2BkgSi60VfkPJBn54CRLDkO8ajP3e/Op9gmlv53QU=
X-Received: by 2002:a2e:b545:0:b0:2a7:6bcd:d8ba with SMTP id
 a5-20020a2eb545000000b002a76bcdd8bamr3586468ljn.3.1682408500213; Tue, 25 Apr
 2023 00:41:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230423105736.56918-1-xuanzhuo@linux.alibaba.com> <20230423105736.56918-8-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230423105736.56918-8-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 25 Apr 2023 15:41:28 +0800
Message-ID: <CACGkMEsNLa9ETksZBi-fkni3c0FzpdNFr-y87Gt48-QKuLDPtg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 07/15] virtio_net: auto release xdp shinfo
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
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 6:57=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> virtnet_build_xdp_buff_mrg() and virtnet_xdp_handler() auto
> release xdp shinfo then the caller no need to careful the xdp shinfo.

Thinking of this, I think releasing frags in
virtnet_build_xdp_buff_mrg() is fine. But for virtnet_xdp_handler(),
it's better to be done by the caller, since the frags were prepared by
the caller anyhow.

Thanks

>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 5f37a1cef61e..c6bf425e8844 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -825,7 +825,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_p=
rog, struct xdp_buff *xdp,
>                 xdpf =3D xdp_convert_buff_to_frame(xdp);
>                 if (unlikely(!xdpf)) {
>                         netdev_dbg(dev, "convert buff to frame failed for=
 xdp\n");
> -                       return XDP_DROP;
> +                       goto drop;
>                 }
>
>                 err =3D virtnet_xdp_xmit(dev, 1, &xdpf, 0);
> @@ -833,7 +833,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_p=
rog, struct xdp_buff *xdp,
>                         xdp_return_frame_rx_napi(xdpf);
>                 } else if (unlikely(err < 0)) {
>                         trace_xdp_exception(dev, xdp_prog, act);
> -                       return XDP_DROP;
> +                       goto drop;
>                 }
>                 *xdp_xmit |=3D VIRTIO_XDP_TX;
>                 return act;
> @@ -842,7 +842,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_p=
rog, struct xdp_buff *xdp,
>                 stats->xdp_redirects++;
>                 err =3D xdp_do_redirect(dev, xdp, xdp_prog);
>                 if (err)
> -                       return XDP_DROP;
> +                       goto drop;
>
>                 *xdp_xmit |=3D VIRTIO_XDP_REDIR;
>                 return act;
> @@ -854,8 +854,12 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_=
prog, struct xdp_buff *xdp,
>                 trace_xdp_exception(dev, xdp_prog, act);
>                 fallthrough;
>         case XDP_DROP:
> -               return XDP_DROP;
> +               break;
>         }
> +
> +drop:
> +       put_xdp_frags(xdp);
> +       return XDP_DROP;
>  }
>
>  static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
> @@ -1190,7 +1194,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_de=
vice *dev,
>                                  dev->name, *num_buf,
>                                  virtio16_to_cpu(vi->vdev, hdr->num_buffe=
rs));
>                         dev->stats.rx_length_errors++;
> -                       return -EINVAL;
> +                       goto err;
>                 }
>
>                 stats->bytes +=3D len;
> @@ -1209,7 +1213,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_de=
vice *dev,
>                         pr_debug("%s: rx error: len %u exceeds truesize %=
lu\n",
>                                  dev->name, len, (unsigned long)(truesize=
 - room));
>                         dev->stats.rx_length_errors++;
> -                       return -EINVAL;
> +                       goto err;
>                 }
>
>                 frag =3D &shinfo->frags[shinfo->nr_frags++];
> @@ -1224,6 +1228,10 @@ static int virtnet_build_xdp_buff_mrg(struct net_d=
evice *dev,
>
>         *xdp_frags_truesize =3D xdp_frags_truesz;
>         return 0;
> +
> +err:
> +       put_xdp_frags(xdp);
> +       return -EINVAL;
>  }
>
>  static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
> @@ -1353,7 +1361,7 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>                 err =3D virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp, dat=
a, len, frame_sz,
>                                                  &num_buf, &xdp_frags_tru=
esz, stats);
>                 if (unlikely(err))
> -                       goto err_xdp_frags;
> +                       goto err_xdp;
>
>                 act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit=
, stats);
>
> @@ -1361,7 +1369,7 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>                 case XDP_PASS:
>                         head_skb =3D build_skb_from_xdp_buff(dev, vi, &xd=
p, xdp_frags_truesz);
>                         if (unlikely(!head_skb))
> -                               goto err_xdp_frags;
> +                               goto err_xdp;
>
>                         rcu_read_unlock();
>                         return head_skb;
> @@ -1370,11 +1378,8 @@ static struct sk_buff *receive_mergeable(struct ne=
t_device *dev,
>                         rcu_read_unlock();
>                         goto xdp_xmit;
>                 default:
> -                       break;
> +                       goto err_xdp;
>                 }
> -err_xdp_frags:
> -               put_xdp_frags(&xdp);
> -               goto err_xdp;
>         }
>         rcu_read_unlock();
>
> --
> 2.32.0.3.g01195cf9f
>

