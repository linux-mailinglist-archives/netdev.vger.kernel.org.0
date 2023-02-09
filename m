Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F472690C1C
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 15:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbjBIOpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 09:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjBIOpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 09:45:39 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D395EBD4
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 06:45:38 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id x71so1691828ybg.6
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 06:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xD66qCQs+hQY3/koLcmNxJ0tZP17x86GUxms3XUjO6Y=;
        b=Yzfovr7fIRPq400BMOMFxCK1ccCPj+YMobWevsbI4Voh9Lsz7UORIlROu6cFwjhHuQ
         TcpstUZpijw9+B0W2Tvn5hSY8WtYwKcEomUSP+qtqizNDpwyJJvS0kqvx2Bzy8MkQvw9
         iv8NGHbJMPO4Bqizoc9wwALPs8nTCiCKXh34kKQZ1xPPXJI6Q5HHCtVqb+YSONhXOjSg
         S6EmoY5VXLXVXHMGeMbjd+r7l0nodEjdn4bX+TVAUSTZGaRqAO5DUFFZh2n+zzQDadQo
         x3ojkQp84Dt5GYwHY2/G6CEDbLcZ+vAfCxBWnBTbVYFYSwQP53DfmUI94JeKiWpwvwon
         cvng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xD66qCQs+hQY3/koLcmNxJ0tZP17x86GUxms3XUjO6Y=;
        b=sjlLBBPBYwm8bgDhjoUlcyxZ3anLkATpp0jQLSXFDbm++R+lO0p9LZB1bjb4HqST7N
         tpwEEbE24VHd5PwLcCpdUuc7oddy3c2sZVWlJJz/DDwPdV83mkAEAIo6O1DRJRDhNWLS
         YBl366xB7+YYr3nfwD8rWeT7WDVZCjfmfKXsf2awy5eqYwbAiKTsePp+MlAdw2j65s3f
         J6bZV4q24/gSd6qmacSEoS/V6/m24I+/bRwFXVgacoNHRn9JK9ikXI9JxjrC0+oeRBi1
         fuk2EfYSOTixs2WglMn9nt7Kxe4WrsaSgsdk6WwCJSuec0BfluOlRcwJKW8EH4Lvda5Z
         RiAg==
X-Gm-Message-State: AO0yUKWoA1n3glCtsmbSZqEWfF9vi5EY0AD7/IdVYiy76vipdDVKPzW1
        0kEqygZNPTxMvrmBDEkdqcalFhNdKb8mxIpbcZloGg==
X-Google-Smtp-Source: AK7set9pzB6Su/YVFJ0/tx7KAWjQG8HwOQ7+Q4k0D+t5f1weLnGXKAaU9EPIakagRByLYKxE9VpEeSwXwky5Ckh0bjQ=
X-Received: by 2002:a25:f504:0:b0:8c7:f1f7:35a4 with SMTP id
 a4-20020a25f504000000b008c7f1f735a4mr615771ybe.104.1675953937463; Thu, 09 Feb
 2023 06:45:37 -0800 (PST)
MIME-Version: 1.0
References: <1675946595-103034-1-git-send-email-amy.saq@antgroup.com> <1675946595-103034-2-git-send-email-amy.saq@antgroup.com>
In-Reply-To: <1675946595-103034-2-git-send-email-amy.saq@antgroup.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Thu, 9 Feb 2023 09:45:01 -0500
Message-ID: <CA+FuTSdDxsJs4n+6EsKuRyikiomRoqu5uo3dUj3zd4oY5maUBw@mail.gmail.com>
Subject: Re: [PATCH 1/2] net/packet: add socketopt to set/get vnet_hdr_sz
To:     =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>
Cc:     netdev@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        mst@redhat.com, davem@davemloft.net, jasowang@redhat.com,
        =?UTF-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 9, 2023 at 7:43 AM =E6=B2=88=E5=AE=89=E7=90=AA(=E5=87=9B=E7=8E=
=A5) <amy.saq@antgroup.com> wrote:
>
> From: "Jianfeng Tan" <henry.tjf@antgroup.com>
>
> Raw socket can be used as the backend for kernel vhost, like tap.

Please refer to PF_PACKET sockets as packet sockets.

"raw" sockets is ambiguous: it is also used to refer to type SOCK_RAW
of other socket families.

> However, in current raw socket implementation, it use hardcoded virtio
> net header length, which will cause error mac header parsing when some
> virtio features that need virtio net header other than 10-byte are used.

This series only adds support for skipping past two extra bytes.

The 2-byte field num_buffers in virtio_net_hdr_mrg_rxbuf is used for
coalesced buffers. That is not a feature packet sockets support.

How do you intend to use this? Only ever with num_buffers =3D=3D 1?

We have to make ABI changes sparingly. It would take another setsockopt
to signal actual use of this feature.

If adding an extended struct, then this also needs to be documented in
the UAPI headers.

> By adding extra field vnet_hdr_sz in packet_sock to record virtio net
> header size that current raw socket should use and supporting extra
> sockopt PACKET_VNET_HDR_SZ to allow user level set specified vnet header
> size to current socket, raw socket will know the exact virtio net header
> size it should use instead of hardcoding to avoid incorrect header
> parsing.
>
> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
> ---
>  include/uapi/linux/if_packet.h |  1 +
>  net/packet/af_packet.c         | 34 ++++++++++++++++++++++++++++++++++
>  net/packet/internal.h          |  3 ++-
>  3 files changed, 37 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/if_packet.h b/include/uapi/linux/if_packe=
t.h
> index 78c981d..9efc423 100644
> --- a/include/uapi/linux/if_packet.h
> +++ b/include/uapi/linux/if_packet.h
> @@ -59,6 +59,7 @@ struct sockaddr_ll {
>  #define PACKET_ROLLOVER_STATS          21
>  #define PACKET_FANOUT_DATA             22
>  #define PACKET_IGNORE_OUTGOING         23
> +#define PACKET_VNET_HDR_SZ             24
>
>  #define PACKET_FANOUT_HASH             0
>  #define PACKET_FANOUT_LB               1
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 8ffb19c..8389f18 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -3936,11 +3936,42 @@ static void packet_flush_mclist(struct sock *sk)
>                         ret =3D -EBUSY;
>                 } else {
>                         po->has_vnet_hdr =3D !!val;
> +                       /* set vnet_hdr_sz to default value */
> +                       if (po->has_vnet_hdr)
> +                               po->vnet_hdr_sz =3D sizeof(struct virtio_=
net_hdr);
> +                       else
> +                               po->vnet_hdr_sz =3D 0;
>                         ret =3D 0;
>                 }
>                 release_sock(sk);
>                 return ret;
>         }
> +       case PACKET_VNET_HDR_SZ:
> +       {
> +               int val;
> +
> +               if (sock->type !=3D SOCK_RAW)
> +                       return -EINVAL;
> +               if (optlen < sizeof(val))
> +                       return -EINVAL;
> +               if (copy_from_user(&val, optval, sizeof(val)))
> +                       return -EFAULT;

This duplicates the code in PACKET_VNET_HR. I'd prefer:

        case PACKET_VNET_HDR:
        case PACKET_VNET_HDR_SZ:

        .. sanity checks and copy from user ..

        if (optname =3D PACKET_VNET_HDR)
                val =3D sizeof(struct virtio_net_hdr);

And move the check for valid lengths before taking the lock.

> +
> +               lock_sock(sk);
> +               if (po->rx_ring.pg_vec || po->tx_ring.pg_vec) {
> +                       ret =3D -EBUSY;
> +               } else {
> +                       if (val =3D=3D sizeof(struct virtio_net_hdr) ||
> +                           val =3D=3D sizeof(struct virtio_net_hdr_mrg_r=
xbuf)) {
> +                               po->vnet_hdr_sz =3D val;
> +                               ret =3D 0;
> +                       } else {
> +                               ret =3D -EINVAL;
> +                       }
> +               }
> +               release_sock(sk);
> +               return ret;
> +       }
>         case PACKET_TIMESTAMP:
>         {
>                 int val;
> @@ -4070,6 +4101,9 @@ static int packet_getsockopt(struct socket *sock, i=
nt level, int optname,
>         case PACKET_VNET_HDR:
>                 val =3D po->has_vnet_hdr;
>                 break;
> +       case PACKET_VNET_HDR_SZ:
> +               val =3D po->vnet_hdr_sz;
> +               break;
>         case PACKET_VERSION:
>                 val =3D po->tp_version;
>                 break;
> diff --git a/net/packet/internal.h b/net/packet/internal.h
> index 48af35b..e27b47d 100644
> --- a/net/packet/internal.h
> +++ b/net/packet/internal.h
> @@ -121,7 +121,8 @@ struct packet_sock {
>                                 origdev:1,
>                                 has_vnet_hdr:1,
>                                 tp_loss:1,
> -                               tp_tx_has_off:1;
> +                               tp_tx_has_off:1,
> +                               vnet_hdr_sz:8;  /* vnet header size shoul=
d use */

This location looks fine from the point of view of using holes in the
struct:


        /* --- cacheline 12 boundary (768 bytes) --- */
        struct packet_ring_buffer  rx_ring;              /*   768   200 */
        /* --- cacheline 15 boundary (960 bytes) was 8 bytes ago --- */
        struct packet_ring_buffer  tx_ring;              /*   968   200 */
        /* --- cacheline 18 boundary (1152 bytes) was 16 bytes ago --- */
        int                        copy_thresh;          /*  1168     4 */
        spinlock_t                 bind_lock;            /*  1172     4 */
        struct mutex               pg_vec_lock;          /*  1176    32 */
        unsigned int               running;              /*  1208     4 */
        unsigned int               auxdata:1;            /*  1212: 0  4 */
        unsigned int               origdev:1;            /*  1212: 1  4 */
        unsigned int               has_vnet_hdr:1;       /*  1212: 2  4 */
        unsigned int               tp_loss:1;            /*  1212: 3  4 */
        unsigned int               tp_tx_has_off:1;      /*  1212: 4  4 */

        /* XXX 27 bits hole, try to pack */

        /* --- cacheline 19 boundary (1216 bytes) --- */

>         int                     pressure;
>         int                     ifindex;        /* bound device         *=
/
>         __be16                  num;
> --
> 1.8.3.1
>
