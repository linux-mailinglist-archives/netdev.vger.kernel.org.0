Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1C86AE555
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjCGPt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjCGPtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:49:55 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309BA28855
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 07:49:53 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id z6so14831051qtv.0
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 07:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678204192;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W1vi3+Ks9So4N5IHlm8qOtdDpWhHI7XZsnsCZCaWEJI=;
        b=gg9U8UJvjlzFxFf6ESbwC6MGy06GzpOEfqb6Rldz3AEFr70SU+AlzvlKfedde1xKqf
         ynME6MnRC8x7AuA0apC8xr92WsTa86KTX12veyHmy27rqntBDaaG5G0HXGlejws7hTxy
         zJNlPtRGnWdWzC3wgponL27ZhWgFs5q7JL+Njss3FgZOxOTS6U1Ux5T8cr67bLvHJlis
         2BS+WgrOuq9UhRNoswLGvzCycZujTLPf2jwXWy9Xy97+n/11Iv7P+SAtW2CpQbg/5P90
         Na5g95htWuKNcv9ll2inCQ5fc4KASTSKafmxAb9V/aAqHBubjWJHIEK53aEW3kpDhKYk
         ahhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678204192;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=W1vi3+Ks9So4N5IHlm8qOtdDpWhHI7XZsnsCZCaWEJI=;
        b=d6iPtfWnrFYSf02AADbNHadmgo0ZCrBdGdbKl/PBFCmV2L1VARVzljVGztF+qSeKul
         QdWPWasX44Aw/oNFKJsTY5ECCbWvabpLwdKuE5qlZJs42YxCFvq/uXtsmX2PggEo9TZ3
         rxszf+VyzHn2fEsZypKlyRAuheRJ9KDNiL4fQmpZekKdGykJpTisMP8kCn7rnmHxrz5R
         zdh6aGlxnXfmaNoKxB4iIFwYJiJMOnFw5aOlWNA0kvkUdNobOqZodgdE5+vJKFBiTcyu
         N98IjM0sHQ9FM5+7hf/H8nh4m/8UHUp+rn9tWz0yFtVfReZ0ZaC6wRTNepFhBhRQNvv6
         YO2g==
X-Gm-Message-State: AO0yUKXroMjpcMRwUxodKXJ/k9xqlPu7VmmTe4ctpf4PVWc+2kkiZVTC
        pL1QPlLNPzA0FX6FfU6FtmcOJwyN0Ko=
X-Google-Smtp-Source: AK7set9YMeoQwxX8Hyg3rRTKCbAonn6cb+y6TkHLGr0gTKNsXVvJPUlr+To10ougCz6TU73ZJ2b0+A==
X-Received: by 2002:a05:622a:11cb:b0:3c0:3f85:584b with SMTP id n11-20020a05622a11cb00b003c03f85584bmr1105181qtk.46.1678204192160;
        Tue, 07 Mar 2023 07:49:52 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id i185-20020a37b8c2000000b0073b79edf46csm9640873qkf.83.2023.03.07.07.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 07:49:51 -0800 (PST)
Date:   Tue, 07 Mar 2023 10:49:51 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>,
        netdev@vger.kernel.org
Cc:     willemdebruijn.kernel@gmail.com, mst@redhat.com,
        davem@davemloft.net, jasowang@redhat.com,
        =?UTF-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>,
        =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>
Message-ID: <64075d1f7ccfc_efd1020865@willemb.c.googlers.com.notmuch>
In-Reply-To: <1678168911-337042-1-git-send-email-amy.saq@antgroup.com>
References: <1678168911-337042-1-git-send-email-amy.saq@antgroup.com>
Subject: RE: [PATCH v3] net/packet: support mergeable feature of virtio
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

> With this mergeable feature enabled by virtio-user, packet sockets with=

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

> Besides, has_vnet_hdr field in struct packet_sock is removed since all =

> the information it provides is covered by vnet_hdr_sz field: a packet
> socket has a vnet header if and only if its vnet_hdr_sz is not zero.
> =

> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
> ---
> =

>  /*
> @@ -2310,8 +2310,8 @@ static int tpacket_rcv(struct sk_buff *skb, struc=
t net_device *dev,
>  		netoff =3D TPACKET_ALIGN(po->tp_hdrlen +
>  				       (maclen < 16 ? 16 : maclen)) +
>  				       po->tp_reserve;
> -		if (po->has_vnet_hdr) {
> -			netoff +=3D sizeof(struct virtio_net_hdr);
> +		if (po->vnet_hdr_sz !=3D 0) {
> +			netoff +=3D po->vnet_hdr_sz;

no need to test !=3D 0 here and elsewhere, just if (po->vnet_hdr_sz)

>  			do_vnet =3D true;
>  		}
>  		macoff =3D netoff - maclen;
> @@ -2552,16 +2552,27 @@ static int __packet_snd_vnet_parse(struct virti=
o_net_hdr *vnet_hdr, size_t len)
>  }
>  =

>  static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *sk=
b,
> @@ -2730,6 +2741,7 @@ static int tpacket_snd(struct packet_sock *po, st=
ruct msghdr *msg)
>  	int status =3D TP_STATUS_AVAILABLE;
>  	int hlen, tlen, copylen =3D 0;
>  	long timeo =3D 0;
> +	int vnet_hdr_sz;

since po->vnet_hdr_sz is touched in the hot path anyway, initialize
it here and use the local var everywhere. Else this might race with
updates too header length.
>  =

>  	mutex_lock(&po->pg_vec_lock);
>  =

> @@ -2780,7 +2792,7 @@ static int tpacket_snd(struct packet_sock *po, st=
ruct msghdr *msg)
>  	size_max =3D po->tx_ring.frame_size
>  		- (po->tp_hdrlen - sizeof(struct sockaddr_ll));
>  =

> -	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !po->has_vnet_hdr)=

> +	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && po->vnet_hdr_sz =3D=
=3D 0)
>  		size_max =3D dev->mtu + reserve + VLAN_HLEN;
>  =

>  	reinit_completion(&po->skb_completion);
> @@ -2809,10 +2821,11 @@ static int tpacket_snd(struct packet_sock *po, =
struct msghdr *msg)
>  		status =3D TP_STATUS_SEND_REQUEST;
>  		hlen =3D LL_RESERVED_SPACE(dev);
>  		tlen =3D dev->needed_tailroom;
> -		if (po->has_vnet_hdr) {
> +		if (po->vnet_hdr_sz !=3D 0) {
>  			vnet_hdr =3D data;
> -			data +=3D sizeof(*vnet_hdr);
> -			tp_len -=3D sizeof(*vnet_hdr);
> +			vnet_hdr_sz =3D po->vnet_hdr_sz;

.. in particularly here, where vnet_hdr_sz is first checked and then copi=
ed
to a local var in a separate step.

> +			data +=3D vnet_hdr_sz;
> +			tp_len -=3D vnet_hdr_sz;
>  			if (tp_len < 0 ||
>  			    __packet_snd_vnet_parse(vnet_hdr, tp_len)) {
>  				tp_len =3D -EINVAL;
> @@ -2837,7 +2850,7 @@ static int tpacket_snd(struct packet_sock *po, st=
ruct msghdr *msg)
>  					  addr, hlen, copylen, &sockc);
>  		if (likely(tp_len >=3D 0) &&
>  		    tp_len > dev->mtu + reserve &&
> -		    !po->has_vnet_hdr &&
> +		    (po->vnet_hdr_sz =3D=3D 0) &&
>  		    !packet_extra_vlan_len_allowed(dev, skb))
>  			tp_len =3D -EMSGSIZE;
>  =

> @@ -2856,7 +2869,7 @@ static int tpacket_snd(struct packet_sock *po, st=
ruct msghdr *msg)
>  			}
>  		}
>  =

> -		if (po->has_vnet_hdr) {
> +		if (po->vnet_hdr_sz !=3D 0) {
>  			if (virtio_net_hdr_to_skb(skb, vnet_hdr, vio_le())) {
>  				tp_len =3D -EINVAL;
>  				goto tpacket_error;
> @@ -2947,6 +2960,7 @@ static int packet_snd(struct socket *sock, struct=
 msghdr *msg, size_t len)
>  	int offset =3D 0;
>  	struct packet_sock *po =3D pkt_sk(sk);
>  	bool has_vnet_hdr =3D false;

remove has_vnet_hdr, which is now superfluous.

> +	int vnet_hdr_sz;
>  	int hlen, tlen, linear;
>  	int extra_len =3D 0;
>  =

> @@ -2990,8 +3004,9 @@ static int packet_snd(struct socket *sock, struct=
 msghdr *msg, size_t len)
>  =

>  	if (sock->type =3D=3D SOCK_RAW)
>  		reserve =3D dev->hard_header_len;
> -	if (po->has_vnet_hdr) {
> -		err =3D packet_snd_vnet_parse(msg, &len, &vnet_hdr);
> +	if (po->vnet_hdr_sz !=3D 0) {
> +		vnet_hdr_sz =3D po->vnet_hdr_sz;

same here

> +		err =3D packet_snd_vnet_parse(msg, &len, &vnet_hdr, vnet_hdr_sz);
>  		if (err)
>  			goto out_unlock;
>  		has_vnet_hdr =3D true;
> @@ -3068,7 +3083,7 @@ static int packet_snd(struct socket *sock, struct=
 msghdr *msg, size_t len)
>  		err =3D virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
>  		if (err)
>  			goto out_free;
> -		len +=3D sizeof(vnet_hdr);
> +		len +=3D vnet_hdr_sz;
>  		virtio_net_hdr_set_proto(skb, &vnet_hdr);
>  	}
>  =

> @@ -3451,11 +3466,11 @@ static int packet_recvmsg(struct socket *sock, =
struct msghdr *msg, size_t len,
>  =

>  	packet_rcv_try_clear_pressure(pkt_sk(sk));
>  =

> -	if (pkt_sk(sk)->has_vnet_hdr) {
> -		err =3D packet_rcv_vnet(msg, skb, &len);
> +	if (pkt_sk(sk)->vnet_hdr_sz !=3D 0) {
> +		vnet_hdr_len =3D pkt_sk(sk)->vnet_hdr_sz;

and here

> +		err =3D packet_rcv_vnet(msg, skb, &len, vnet_hdr_len);
>  		if (err)
>  			goto out_free;
> -		vnet_hdr_len =3D sizeof(struct virtio_net_hdr);
>  	}
>  =

>  	/* You lose any data beyond the buffer you gave. If it worries
> @@ -3921,8 +3936,10 @@ static void packet_flush_mclist(struct sock *sk)=

>  		return 0;
>  	}
>  	case PACKET_VNET_HDR:
> +	case PACKET_VNET_HDR_SZ:
>  	{
>  		int val;
> +		int hdr_len =3D 0;
>  =

>  		if (sock->type !=3D SOCK_RAW)
>  			return -EINVAL;
> @@ -3931,11 +3948,21 @@ static void packet_flush_mclist(struct sock *sk=
)
>  		if (copy_from_sockptr(&val, optval, sizeof(val)))
>  			return -EFAULT;
>  =

> +		if (optname =3D=3D PACKET_VNET_HDR_SZ) {
> +			if (val !=3D sizeof(struct virtio_net_hdr) &&
> +			    val !=3D sizeof(struct virtio_net_hdr_mrg_rxbuf))
> +				return -EINVAL;
> +			hdr_len =3D val;

val =3D=3D 0 is also a a correct value

> +		} else {
> +			if (!!val)
> +				hdr_len =3D sizeof(struct virtio_net_hdr);

no need for !! when testing non-zero.

and instead of initializing to zero on initial variable definition:

    hdr_len =3D val ? sizeof(struct virtio_net_hdr) : 0;

> +		}
> +
>  		lock_sock(sk);
>  		if (po->rx_ring.pg_vec || po->tx_ring.pg_vec) {
>  			ret =3D -EBUSY;
>  		} else {
> -			po->has_vnet_hdr =3D !!val;
> +			po->vnet_hdr_sz =3D hdr_len;
>  			ret =3D 0;
>  		}
>  		release_sock(sk);
> @@ -4068,7 +4095,10 @@ static int packet_getsockopt(struct socket *sock=
, int level, int optname,
>  		val =3D po->origdev;
>  		break;
>  	case PACKET_VNET_HDR:
> -		val =3D po->has_vnet_hdr;
> +		val =3D !!po->vnet_hdr_sz;
> +		break;
> +	case PACKET_VNET_HDR_SZ:
> +		val =3D po->vnet_hdr_sz;
>  		break;
>  	case PACKET_VERSION:
>  		val =3D po->tp_version;
> diff --git a/net/packet/diag.c b/net/packet/diag.c
> index 07812ae..4e544da 100644
> --- a/net/packet/diag.c
> +++ b/net/packet/diag.c
> @@ -27,7 +27,7 @@ static int pdiag_put_info(const struct packet_sock *p=
o, struct sk_buff *nlskb)
>  		pinfo.pdi_flags |=3D PDI_AUXDATA;
>  	if (po->origdev)
>  		pinfo.pdi_flags |=3D PDI_ORIGDEV;
> -	if (po->has_vnet_hdr)
> +	if (po->vnet_hdr_sz !=3D 0)
>  		pinfo.pdi_flags |=3D PDI_VNETHDR;
>  	if (po->tp_loss)
>  		pinfo.pdi_flags |=3D PDI_LOSS;
> diff --git a/net/packet/internal.h b/net/packet/internal.h
> index 48af35b..9b52d93 100644
> --- a/net/packet/internal.h
> +++ b/net/packet/internal.h
> @@ -119,9 +119,9 @@ struct packet_sock {
>  	unsigned int		running;	/* bind_lock must be held */
>  	unsigned int		auxdata:1,	/* writer must hold sock lock */
>  				origdev:1,
> -				has_vnet_hdr:1,
>  				tp_loss:1,
> -				tp_tx_has_off:1;
> +				tp_tx_has_off:1,
> +				vnet_hdr_sz:8;

just a separate u8 variable , rather than 8 bits in a u32.

>  	int			pressure;
>  	int			ifindex;	/* bound device		*/
>  	__be16			num;
> -- =

> 1.8.3.1
> =



