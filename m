Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1166B79DC
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjCMOFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjCMOFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:05:09 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6D8515E9
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 07:05:07 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id r5so13192034qtp.4
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 07:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678716306;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Dfmiq5UESwnPdnNewNSswGwV2dgh1eKgCJkwVrQzbo=;
        b=eneeduDivFmPfAfdHiErBL3mEkIFemhZinx0x7TBgdHPadRlP5I27lL/ag+gnShB83
         dao+B5+jAkzdEMdNKbDMg1SglcufamA0I9FuGx4CAGrmnyx3qPfymIOoXACcPfDhdMiU
         jMsrCTIx9DTxuxsmyK/6Mw++2yfTqBjeEGFJZTUZeYqQ1uMLIzcdX1eWw/eeOfA62ipQ
         WAzZwSdiwLCiA07giOM0VUIweF1UtPxht+QthGsi42n2u1XUi2ypOjdaeDn29xXLIPq7
         oL8OPmNWo80wcwNSefTyafMc3/6EaKSkWFJbaXIuur7DDEjscuAm1rQvT+8iSxJVfRF7
         gFhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678716306;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1Dfmiq5UESwnPdnNewNSswGwV2dgh1eKgCJkwVrQzbo=;
        b=bXZYT1wKeL7N8kMUvz7wLyNTpRcwXgIiKEKv7nnaq9W1HRUSE8MZCERxDMGt7uAPlU
         u6p+xs/NoGcCMJK7UoyNSI2X0wb5IUixtJyvx1LN/Q1X6lz68CMwzG9yrjRl68VfSrFz
         lutu9ANch4dhv1sQ8Z54Q4FsZMPCEe/EPdbrv8FDeCL8BYPru3P48py+yUTuD4OBTDwZ
         qJchLHYOPYNaM6z7w0QXr2J9pm2ML0725Bs7pd3LemJ1fRU0ImCI2lby2QGdyILqV61s
         A1bOKTIfMPQc/V+icdduNFINgCzxL5dXF0g+61hnSLVJ9XOaMkmrGJKCw6vdg0htybKK
         y+FQ==
X-Gm-Message-State: AO0yUKVT3NItkRMUJA/RFuRJL6ALsJdorzRslOSQJR8t2JWyTZsMo6GI
        sLwuHEO++oRtYehqUaiVEfM=
X-Google-Smtp-Source: AK7set+nsK0z3/5B/bHdRI3FgN7mfx7OseO3Rjc2E6LJrH4dZYZXriQVkU7LAl9AnDRRo5R1bSuggQ==
X-Received: by 2002:a05:622a:13:b0:3b6:3b60:e0 with SMTP id x19-20020a05622a001300b003b63b6000e0mr56461444qtw.31.1678716306060;
        Mon, 13 Mar 2023 07:05:06 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id d28-20020ac800dc000000b003bd0f0b26b0sm5533630qtg.77.2023.03.13.07.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 07:05:05 -0700 (PDT)
Date:   Mon, 13 Mar 2023 10:05:04 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>,
        netdev@vger.kernel.org
Cc:     willemdebruijn.kernel@gmail.com, mst@redhat.com,
        davem@davemloft.net, jasowang@redhat.com,
        =?UTF-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>,
        =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>
Message-ID: <640f2d90acf60_28b1eb2086c@willemb.c.googlers.com.notmuch>
In-Reply-To: <1678689073-101893-1-git-send-email-amy.saq@antgroup.com>
References: <1678689073-101893-1-git-send-email-amy.saq@antgroup.com>
Subject: RE: [PATCH v4] net/packet: support mergeable feature of virtio
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
> net headers to be 12-byte long.
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

> V3 -> V4:
> * read po->vnet_hdr_sz once during vnet_hdr_sz and use vnet_hdr_sz loca=
lly =

> to avoid race condition;
> * modify how to check non-zero po->vnet_hdr_sz;
> * separate vnet_hdr_sz as a u8 field in struct packet_sock instead of 8=
-bit
> in an int field.
> =

>  include/uapi/linux/if_packet.h |  1 +
>  net/packet/af_packet.c         | 87 +++++++++++++++++++++++++++-------=
--------
>  net/packet/diag.c              |  2 +-
>  net/packet/internal.h          |  2 +-
>  4 files changed, 59 insertions(+), 33 deletions(-)
> =

> diff --git a/include/uapi/linux/if_packet.h b/include/uapi/linux/if_pac=
ket.h
> index 78c981d..9efc423 100644
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
> index 8ffb19c..06b9893 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -2092,18 +2092,18 @@ static unsigned int run_filter(struct sk_buff *=
skb,
>  }
>  =

>  static int packet_rcv_vnet(struct msghdr *msg, const struct sk_buff *s=
kb,
> -			   size_t *len)
> +			   size_t *len, int vnet_hdr_sz)
>  {
> -	struct virtio_net_hdr vnet_hdr;
> +	struct virtio_net_hdr_mrg_rxbuf vnet_hdr =3D { .num_buffers =3D 0 };
>  =

> -	if (*len < sizeof(vnet_hdr))
> +	if (*len < vnet_hdr_sz)
>  		return -EINVAL;
> -	*len -=3D sizeof(vnet_hdr);
> +	*len -=3D vnet_hdr_sz;
>  =

> -	if (virtio_net_hdr_from_skb(skb, &vnet_hdr, vio_le(), true, 0))
> +	if (virtio_net_hdr_from_skb(skb, (struct virtio_net_hdr *)&vnet_hdr, =
vio_le(), true, 0))
>  		return -EINVAL;
>  =

> -	return memcpy_to_msg(msg, (void *)&vnet_hdr, sizeof(vnet_hdr));
> +	return memcpy_to_msg(msg, (void *)&vnet_hdr, vnet_hdr_sz);
>  }
>  =

>  /*
> @@ -2253,6 +2253,7 @@ static int tpacket_rcv(struct sk_buff *skb, struc=
t net_device *dev,
>  	bool is_drop_n_account =3D false;
>  	unsigned int slot_id =3D 0;
>  	bool do_vnet =3D false;
> +	int vnet_hdr_sz;
>  =

>  	/* struct tpacket{2,3}_hdr is aligned to a multiple of TPACKET_ALIGNM=
ENT.
>  	 * We may add members to them until current aligned size without forc=
ing
> @@ -2310,8 +2311,9 @@ static int tpacket_rcv(struct sk_buff *skb, struc=
t net_device *dev,
>  		netoff =3D TPACKET_ALIGN(po->tp_hdrlen +
>  				       (maclen < 16 ? 16 : maclen)) +
>  				       po->tp_reserve;
> -		if (po->has_vnet_hdr) {
> -			netoff +=3D sizeof(struct virtio_net_hdr);
> +		vnet_hdr_sz =3D po->vnet_hdr_sz;
> +		if (vnet_hdr_sz) {
> +			netoff +=3D vnet_hdr_sz;
>  			do_vnet =3D true;
>  		}
>  		macoff =3D netoff - maclen;
> @@ -2552,16 +2554,27 @@ static int __packet_snd_vnet_parse(struct virti=
o_net_hdr *vnet_hdr, size_t len)
>  }
>  =

>  static int packet_snd_vnet_parse(struct msghdr *msg, size_t *len,
> -				 struct virtio_net_hdr *vnet_hdr)
> +				 struct virtio_net_hdr *vnet_hdr, int vnet_hdr_sz)
>  {
> -	if (*len < sizeof(*vnet_hdr))
> +	int ret;
> +
> +	if (*len < vnet_hdr_sz)
>  		return -EINVAL;
> -	*len -=3D sizeof(*vnet_hdr);
> +	*len -=3D vnet_hdr_sz;
>  =

>  	if (!copy_from_iter_full(vnet_hdr, sizeof(*vnet_hdr), &msg->msg_iter)=
)
>  		return -EFAULT;
>  =

> -	return __packet_snd_vnet_parse(vnet_hdr, *len);
> +	ret =3D __packet_snd_vnet_parse(vnet_hdr, *len);
> +

nit: please drop the whitespace line

> +	if (ret)
> +		return ret;
> +
> +	/* move iter to point to the start of mac header */
> +	if (vnet_hdr_sz !=3D sizeof(struct virtio_net_hdr))
> +		iov_iter_advance(&msg->msg_iter, vnet_hdr_sz - sizeof(struct virtio_=
net_hdr));
> +
> +	return 0;
>  }
>  =

>  static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *sk=
b,
> @@ -2730,6 +2743,7 @@ static int tpacket_snd(struct packet_sock *po, st=
ruct msghdr *msg)
>  	int status =3D TP_STATUS_AVAILABLE;
>  	int hlen, tlen, copylen =3D 0;
>  	long timeo =3D 0;
> +	int vnet_hdr_sz =3D po->vnet_hdr_sz;

nit: order variables longest to shortest ("reverse christmas tree")
>  =

>  	mutex_lock(&po->pg_vec_lock);
>  =

> @@ -2780,7 +2794,7 @@ static int tpacket_snd(struct packet_sock *po, st=
ruct msghdr *msg)
>  	size_max =3D po->tx_ring.frame_size
>  		- (po->tp_hdrlen - sizeof(struct sockaddr_ll));
>  =

> -	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !po->has_vnet_hdr)=

> +	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !vnet_hdr_sz)
>  		size_max =3D dev->mtu + reserve + VLAN_HLEN;
>  =

>  	reinit_completion(&po->skb_completion);
> @@ -2809,10 +2823,10 @@ static int tpacket_snd(struct packet_sock *po, =
struct msghdr *msg)
>  		status =3D TP_STATUS_SEND_REQUEST;
>  		hlen =3D LL_RESERVED_SPACE(dev);
>  		tlen =3D dev->needed_tailroom;
> -		if (po->has_vnet_hdr) {
> +		if (vnet_hdr_sz) {
>  			vnet_hdr =3D data;
> -			data +=3D sizeof(*vnet_hdr);
> -			tp_len -=3D sizeof(*vnet_hdr);
> +			data +=3D vnet_hdr_sz;
> +			tp_len -=3D vnet_hdr_sz;
>  			if (tp_len < 0 ||
>  			    __packet_snd_vnet_parse(vnet_hdr, tp_len)) {
>  				tp_len =3D -EINVAL;
> @@ -2837,7 +2851,7 @@ static int tpacket_snd(struct packet_sock *po, st=
ruct msghdr *msg)
>  					  addr, hlen, copylen, &sockc);
>  		if (likely(tp_len >=3D 0) &&
>  		    tp_len > dev->mtu + reserve &&
> -		    !po->has_vnet_hdr &&
> +		    !vnet_hdr_sz &&
>  		    !packet_extra_vlan_len_allowed(dev, skb))
>  			tp_len =3D -EMSGSIZE;
>  =

> @@ -2856,7 +2870,7 @@ static int tpacket_snd(struct packet_sock *po, st=
ruct msghdr *msg)
>  			}
>  		}
>  =

> -		if (po->has_vnet_hdr) {
> +		if (vnet_hdr_sz) {
>  			if (virtio_net_hdr_to_skb(skb, vnet_hdr, vio_le())) {
>  				tp_len =3D -EINVAL;
>  				goto tpacket_error;
> @@ -2946,7 +2960,7 @@ static int packet_snd(struct socket *sock, struct=
 msghdr *msg, size_t len)
>  	struct virtio_net_hdr vnet_hdr =3D { 0 };
>  	int offset =3D 0;
>  	struct packet_sock *po =3D pkt_sk(sk);
> -	bool has_vnet_hdr =3D false;
> +	int vnet_hdr_sz =3D po->vnet_hdr_sz;
>  	int hlen, tlen, linear;
>  	int extra_len =3D 0;
>  =

> @@ -2990,11 +3004,11 @@ static int packet_snd(struct socket *sock, stru=
ct msghdr *msg, size_t len)
>  =

>  	if (sock->type =3D=3D SOCK_RAW)
>  		reserve =3D dev->hard_header_len;
> -	if (po->has_vnet_hdr) {
> -		err =3D packet_snd_vnet_parse(msg, &len, &vnet_hdr);
> +

nit: drop extra whitespace line

> +	if (vnet_hdr_sz) {
> +		err =3D packet_snd_vnet_parse(msg, &len, &vnet_hdr, vnet_hdr_sz);
>  		if (err)
>  			goto out_unlock;
> -		has_vnet_hdr =3D true;
>  	}
>  =

>  	if (unlikely(sock_flag(sk, SOCK_NOFCS))) {
> @@ -3064,11 +3078,11 @@ static int packet_snd(struct socket *sock, stru=
ct msghdr *msg, size_t len)
>  =

>  	packet_parse_headers(skb, sock);
>  =

> -	if (has_vnet_hdr) {
> +	if (vnet_hdr_sz) {
>  		err =3D virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
>  		if (err)
>  			goto out_free;
> -		len +=3D sizeof(vnet_hdr);
> +		len +=3D vnet_hdr_sz;
>  		virtio_net_hdr_set_proto(skb, &vnet_hdr);
>  	}
>  =

> @@ -3410,7 +3424,7 @@ static int packet_recvmsg(struct socket *sock, st=
ruct msghdr *msg, size_t len,
>  	struct sock *sk =3D sock->sk;
>  	struct sk_buff *skb;
>  	int copied, err;
> -	int vnet_hdr_len =3D 0;
> +	int vnet_hdr_len =3D pkt_sk(sk)->vnet_hdr_sz;
>  	unsigned int origlen =3D 0;
>  =

>  	err =3D -EINVAL;
> @@ -3451,11 +3465,10 @@ static int packet_recvmsg(struct socket *sock, =
struct msghdr *msg, size_t len,
>  =

>  	packet_rcv_try_clear_pressure(pkt_sk(sk));
>  =

> -	if (pkt_sk(sk)->has_vnet_hdr) {
> -		err =3D packet_rcv_vnet(msg, skb, &len);
> +	if (vnet_hdr_len) {
> +		err =3D packet_rcv_vnet(msg, skb, &len, vnet_hdr_len);
>  		if (err)
>  			goto out_free;
> -		vnet_hdr_len =3D sizeof(struct virtio_net_hdr);
>  	}
>  =

>  	/* You lose any data beyond the buffer you gave. If it worries
> @@ -3921,8 +3934,9 @@ static void packet_flush_mclist(struct sock *sk)
>  		return 0;
>  	}
>  	case PACKET_VNET_HDR:
> +	case PACKET_VNET_HDR_SZ:
>  	{
> -		int val;
> +		int val, hdr_len;
>  =

>  		if (sock->type !=3D SOCK_RAW)
>  			return -EINVAL;
> @@ -3931,11 +3945,19 @@ static void packet_flush_mclist(struct sock *sk=
)
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
>  		lock_sock(sk);
>  		if (po->rx_ring.pg_vec || po->tx_ring.pg_vec) {
>  			ret =3D -EBUSY;
>  		} else {
> -			po->has_vnet_hdr =3D !!val;
> +			po->vnet_hdr_sz =3D hdr_len;
>  			ret =3D 0;
>  		}
>  		release_sock(sk);
> @@ -4068,7 +4090,10 @@ static int packet_getsockopt(struct socket *sock=
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
> index 07812ae..dfec603 100644
> --- a/net/packet/diag.c
> +++ b/net/packet/diag.c
> @@ -27,7 +27,7 @@ static int pdiag_put_info(const struct packet_sock *p=
o, struct sk_buff *nlskb)
>  		pinfo.pdi_flags |=3D PDI_AUXDATA;
>  	if (po->origdev)
>  		pinfo.pdi_flags |=3D PDI_ORIGDEV;
> -	if (po->has_vnet_hdr)
> +	if (po->vnet_hdr_sz)
>  		pinfo.pdi_flags |=3D PDI_VNETHDR;
>  	if (po->tp_loss)
>  		pinfo.pdi_flags |=3D PDI_LOSS;
> diff --git a/net/packet/internal.h b/net/packet/internal.h
> index 48af35b..154c6bb 100644
> --- a/net/packet/internal.h
> +++ b/net/packet/internal.h
> @@ -119,9 +119,9 @@ struct packet_sock {
>  	unsigned int		running;	/* bind_lock must be held */
>  	unsigned int		auxdata:1,	/* writer must hold sock lock */
>  				origdev:1,
> -				has_vnet_hdr:1,
>  				tp_loss:1,
>  				tp_tx_has_off:1;
> +	u8			vnet_hdr_sz;
>  	int			pressure;
>  	int			ifindex;	/* bound device		*/
>  	__be16			num;
> -- =

> 1.8.3.1
> =



