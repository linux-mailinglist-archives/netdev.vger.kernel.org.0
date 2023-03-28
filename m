Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D95D96CC7FA
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 18:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjC1Qah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 12:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233169AbjC1QaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 12:30:10 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119A3B446
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 09:30:09 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id cn12so9104893qtb.8
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 09:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680021008;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hDyRL74XB2Rk/GlawTgYmlU+JXB/jglO4Y+2NxXw9dY=;
        b=n9j+Id/fdr/yI2M/h2Rt0nNB1PA9EI7WV2hN8AZa//unxchl+hAl53q6niCzgwCPrR
         umoZRXk93FIu3UIx9+6VZeVwq/jBPQeM8b7INvh6Gwk/iyB0FSEHJ1pMki59oNkzs1ww
         Pux0Ev0zbsREmlRqnXKa8kfWJBaGVGnSj1iw2cDiDdS13Js/wLP6wOS+EEHHcxuNuU2f
         f5ZssLPaGZIhTNteemUMJ6qmQLfVSjUsBAvIrn46DYzNZGhNGR+aF6mD7gTnWaApJ1/Z
         1w0bjjQGIewGv/OMMSz87Uij0uVtLbaSgNgx62IaKJDxbMQmOn/qUDik/WaGi/5jNCF7
         EBXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680021008;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hDyRL74XB2Rk/GlawTgYmlU+JXB/jglO4Y+2NxXw9dY=;
        b=bUpD9AP//+LEChLOwHrOydrOeXIbuWZCHfp69uVhxyVR/HifB4nodanmIUezMbszTW
         uDDojL8Dt7y5XXE6qSZ9R/nCGOhA6yCRbweU1UQQyaRAF1EbqB7WjR2RuleQDHm1AgJc
         dkwCXIU3LpWgBOe3gpmXaMwcgHQz/HeeQ6/Cbm2/yQF1BXVFReaR3P7vVl6CjPAdoM8S
         2c4XMSiLT/0z+5tBcyAtRCdWYWIcy7Jo2zwPWLxkbG1NP+pKSDrjfWKr6J0pHMPYA0F3
         fTW7oPunu0oOhM1iMBRYLGMxaJx7IkrIS3CUXyyLyJYl5nIKc22PWaEBBlX3R118Z8VX
         pAIQ==
X-Gm-Message-State: AO0yUKUKRCMesFKq80tRtVBkVf+haz13baoLUEfLqB7KfMzcxORPRKbs
        Ky4Am3Lq5wiuhabTw2EZtfI=
X-Google-Smtp-Source: AK7set8Afcm9FDYAdOs4T9HBm6rmXdi6AJS1EH98yMcHndu86xxI9yuUGWw6yVwn/qBXDYckaAo1Eg==
X-Received: by 2002:a05:622a:1ba5:b0:3d2:a927:21bc with SMTP id bp37-20020a05622a1ba500b003d2a92721bcmr27465420qtb.18.1680021008089;
        Tue, 28 Mar 2023 09:30:08 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id h15-20020ac8744f000000b003e3914c6839sm1420306qtr.43.2023.03.28.09.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 09:30:07 -0700 (PDT)
Date:   Tue, 28 Mar 2023 12:30:07 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>,
        netdev@vger.kernel.org
Cc:     willemdebruijn.kernel@gmail.com, mst@redhat.com,
        davem@davemloft.net, jasowang@redhat.com,
        =?UTF-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>,
        =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>
Message-ID: <6423160f46e56_1bf1c92089e@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230327153641.204660-1-amy.saq@antgroup.com>
References: <20230327153641.204660-1-amy.saq@antgroup.com>
Subject: RE: [PATCH v6] net/packet: support mergeable feature of virtio
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=E6=B2=88=E5=AE=89=E7=90=AA(=E5=87=9B=E7=8E=A5) wrote:
> From: Jianfeng Tan <henry.tjf@antgroup.com>
> =

> Packet sockets, like tap, can be used as the backend for kernel vhost.
> In packet sockets, virtio net header size is currently hardcoded to be
> the size of struct virtio_net_hdr, which is 10 bytes; however, it is no=
t
> always the case: some virtio features, such as mrg_rxbuf, need virtio
> net header to be 12-byte long.
> =

> Mergeable buffers, as a virtio feature, is worthy of supporting: packet=
s
> that are larger than one-mbuf size will be dropped in vhost worker's
> handle_rx if mrg_rxbuf feature is not used, but large packets
> cannot be avoided and increasing mbuf's size is not economical.
> =

> With this virtio feature enabled by virtio-user, packet sockets with
> hardcoded 10-byte virtio net header will parse mac head incorrectly in
> packet_snd by taking the last two bytes of virtio net header as part of=

> mac header.
> This incorrect mac header parsing will cause packet to be dropped due t=
o
> invalid ether head checking in later under-layer device packet receivin=
g.
> =

> By adding extra field vnet_hdr_sz with utilizing holes in struct
> packet_sock to record currently used virtio net header size and support=
ing
> extra sockopt PACKET_VNET_HDR_SZ to set specified vnet_hdr_sz, packet
> sockets can know the exact length of virtio net header that virtio user=

> gives.
> In packet_snd, tpacket_snd and packet_recvmsg, instead of using
> hardcoded virtio net header size, it can get the exact vnet_hdr_sz from=

> corresponding packet_sock, and parse mac header correctly based on this=

> information to avoid the packets being mistakenly dropped.
> =

> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
> ---
> =

> V5 -> V6:
> * rebase patch based on 6.3-rc2
> =

>  include/uapi/linux/if_packet.h |  1 +
>  net/packet/af_packet.c         | 88 +++++++++++++++++++++-------------=

>  net/packet/diag.c              |  2 +-
>  net/packet/internal.h          |  2 +-
>  4 files changed, 59 insertions(+), 34 deletions(-)
> =

> diff --git a/include/uapi/linux/if_packet.h b/include/uapi/linux/if_pac=
ket.h
> index 78c981d6a9d4..9efc42382fdb 100644
> --- a/include/uapi/linux/if_packet.h
> +++ b/include/uapi/linux/if_packet.h
> @@ -59,6 +59,7 @@ struct sockaddr_ll {
>  #define PACKET_ROLLOVER_STATS		21
>  #define PACKET_FANOUT_DATA		22
>  #define PACKET_IGNORE_OUTGOING		23
> +#define PACKET_VNET_HDR_SZ		24
>  =

>  #define PACKET_FANOUT_HASH		0
>  #define PACKET_FANOUT_LB		1
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 497193f73030..b13536767cbe 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -2090,18 +2090,18 @@ static unsigned int run_filter(struct sk_buff *=
skb,
>  }
>  =


> @@ -3925,11 +3938,19 @@ packet_setsockopt(struct socket *sock, int leve=
l, int optname, sockptr_t optval,
>  		if (copy_from_sockptr(&val, optval, sizeof(val)))
>  			return -EFAULT;
>  =

> +		hdr_len =3D val ? sizeof(struct virtio_net_hdr) : 0;
> +		if (optname =3D=3D PACKET_VNET_HDR_SZ) {
> +			if (val && val !=3D sizeof(struct virtio_net_hdr) &&
> +			    val !=3D sizeof(struct virtio_net_hdr_mrg_rxbuf))
> +				return -EINVAL;
> +			hdr_len =3D val;
> +		}
> +

Since the below requires a change, I'd prefer

    if (optname =3D=3D PACKET_VNET_HDR_SZ) {
            ...
    } else {
            hdr_len =3D val ? sizeof(struct virtio_net_hdr) : 0;
    }

Rather than first doing that and then modifying val in the case of
PACKET_VNET_HDR_SZ.

>  		lock_sock(sk);
>  		if (po->rx_ring.pg_vec || po->tx_ring.pg_vec) {
>  			ret =3D -EBUSY;
>  		} else {
> -			packet_sock_flag_set(po, PACKET_SOCK_HAS_VNET_HDR, val);
> +			po->vnet_hdr_sz =3D hdr_len;

Needs to use WRITE_ONCE to match the READ_ONCE elsewhere

>  			ret =3D 0;
>  		}
>  		release_sock(sk);
> @@ -4062,7 +4083,10 @@ static int packet_getsockopt(struct socket *sock=
, int level, int optname,
>  		val =3D packet_sock_flag(po, PACKET_SOCK_ORIGDEV);
>  		break;
>  	case PACKET_VNET_HDR:
> -		val =3D packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR);
> +		val =3D !!po->vnet_hdr_sz;
> +		break;
> +	case PACKET_VNET_HDR_SZ:
> +		val =3D po->vnet_hdr_sz;
>  		break;
>  	case PACKET_VERSION:
>  		val =3D po->tp_version;
> diff --git a/net/packet/diag.c b/net/packet/diag.c
> index de4ced5cf3e8..5cf13cf0b862 100644
> --- a/net/packet/diag.c
> +++ b/net/packet/diag.c
> @@ -27,7 +27,7 @@ static int pdiag_put_info(const struct packet_sock *p=
o, struct sk_buff *nlskb)
>  		pinfo.pdi_flags |=3D PDI_AUXDATA;
>  	if (packet_sock_flag(po, PACKET_SOCK_ORIGDEV))
>  		pinfo.pdi_flags |=3D PDI_ORIGDEV;
> -	if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR))
> +	if (po->vnet_hdr_sz)
>  		pinfo.pdi_flags |=3D PDI_VNETHDR;
>  	if (packet_sock_flag(po, PACKET_SOCK_TP_LOSS))
>  		pinfo.pdi_flags |=3D PDI_LOSS;
> diff --git a/net/packet/internal.h b/net/packet/internal.h
> index 27930f69f368..63f4865202c1 100644
> --- a/net/packet/internal.h
> +++ b/net/packet/internal.h
> @@ -118,6 +118,7 @@ struct packet_sock {
>  	struct mutex		pg_vec_lock;
>  	unsigned long		flags;
>  	int			ifindex;	/* bound device		*/
> +	u8			vnet_hdr_sz;

Did you use pahole to find a spot that is currently padding?

This looks good in principle, an int followed by __be16.

>  	__be16			num;
>  	struct packet_rollover	*rollover;
>  	struct packet_mclist	*mclist;
> @@ -139,7 +140,6 @@ enum packet_sock_flags {
>  	PACKET_SOCK_AUXDATA,
>  	PACKET_SOCK_TX_HAS_OFF,
>  	PACKET_SOCK_TP_LOSS,
> -	PACKET_SOCK_HAS_VNET_HDR,
>  	PACKET_SOCK_RUNNING,
>  	PACKET_SOCK_PRESSURE,
>  	PACKET_SOCK_QDISC_BYPASS,
> -- =

> 2.19.1.6.gb485710b
> =



