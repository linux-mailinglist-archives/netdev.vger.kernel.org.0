Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012C16DB891
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 05:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjDHDVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 23:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjDHDU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 23:20:59 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B602CD32D;
        Fri,  7 Apr 2023 20:20:56 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id s12so38449792qtx.11;
        Fri, 07 Apr 2023 20:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680924056; x=1683516056;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FIEkv+iy4cAIpccv3RxUsdlo98yUg7pHBt0rOFERnc0=;
        b=oLWyUoipkQyE1PXhRCWLKaDvQlwnSVlxPM48IXGd1nM5O0aCKXrw1N4QSKTF5BYQ8u
         2mZefWVobIgFegFxGPA0K2ViX4lSE0YuFiLMT7C6eNo4kfkUHVPmxInHw8BzAI6X9Ul2
         JbDgbLJE8D9QCaIJ8p5KjP9bEi9uvnPlYTX8ItQKDSFS0Eez4ZAimt3X4Oq3jPkDDZOZ
         YsDpnx7wXcYYIaiY97hnCDybjTu5k0NcSax35E9CHTtEQC3p7jrHqNS49vng6yatMkCL
         Uyz5hdGnZY8G7AfbfzKbHtC7ObrwjR8G6QuN26V4afq7oHQ4/9WTCuwzxWFbgmAh8Lw3
         HzGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680924056; x=1683516056;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FIEkv+iy4cAIpccv3RxUsdlo98yUg7pHBt0rOFERnc0=;
        b=QAP+pEOeOB0emJ44aLePBKG5CJVwRrezuT1s9ilhyOVXGInqeFNMtl3nTWL6kjfTTN
         klJ8nUqvwwZtdSe16dTf4IBnmzg08mIyE9M0CNEYBgge65iPQxkIpNFfIfy1cX9Wpv1m
         qQ+QuYhlwl/FOnd9FCKYayoaxiHegPjDvuI293JoI1ypoTePOFMHJ7orySMjEtA1X/c+
         N8bqOW2+4V2dag1eNB+frY/llHKs/+JPvQQwb6CTPAhc4d/22AAhm5qMxVnbcNuciQx2
         E9TEnCBCDGHpdXl1E2tW/r18fmrsQEccP6erx0u9BXa4sXZ5zzJGHdEx0+IszpN4TRox
         sgHQ==
X-Gm-Message-State: AAQBX9f0XRn5P/mJ+bTt9UGakSZAgDWbxTmc/FJ5wNigJi8jFwI2RMo4
        RS8qvbmPWmB6lx7AcW6eVwgKE82qXhY=
X-Google-Smtp-Source: AKy350ZqCWA7W8Nwg+Jpu7mqbrOazoOPSDSWAhWn8f8ASOD+ke+5hsVMK5OwtFEHQxrxUfC/ApF+GQ==
X-Received: by 2002:ac8:4e87:0:b0:3e6:94d6:7bab with SMTP id 7-20020ac84e87000000b003e694d67babmr5169159qtp.34.1680924055631;
        Fri, 07 Apr 2023 20:20:55 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id w23-20020ac86b17000000b003e6948a8966sm518829qts.21.2023.04.07.20.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 20:20:55 -0700 (PDT)
Date:   Fri, 07 Apr 2023 23:20:54 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>,
        =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Message-ID: <6430dd96dcbad_1363629454@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230407115454.178143-1-amy.saq@antgroup.com>
References: <20230407115454.178143-1-amy.saq@antgroup.com>
Subject: RE: [PATCH v7] net/packet: support mergeable feature of virtio
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

> V6 -> V7:
> * addresses coding style comments.
> =

> V5 -> V6:
> * rebase patch based on 6.3-rc2.
> =

> V4 -> V5:
> * add READ_ONCE() macro when initializing local vnet_hdr_sz variable;
> * fix some nits. =

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

> V2 -> V3:
> * remove has_vnet_hdr field and use vnet_hdr_sz to indicate whether
> there is a vnet header;
> * refactor PACKET_VNET_HDR and PACKET_VNET_HDR_SZ sockopt to remove
> redundant code.
> =

> V1 -> V2:
> * refactor the implementation of PACKET_VNET_HDR and PACKET_VNET_HDR_SZ=

> socketopts to get rid of redundate code;
> * amend packet_rcv_vnet in af_packet.c to avoid extra function invocati=
on.
> =

>  include/uapi/linux/if_packet.h |  1 +
>  net/packet/af_packet.c         | 89 ++++++++++++++++++++++------------=

>  net/packet/diag.c              |  2 +-
>  net/packet/internal.h          |  2 +-
>  4 files changed, 60 insertions(+), 34 deletions(-)
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
> index 497193f73030..69044341fb8c 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -2090,18 +2090,18 @@ static unsigned int run_filter(struct sk_buff *=
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
> @@ -2251,6 +2251,7 @@ static int tpacket_rcv(struct sk_buff *skb, struc=
t net_device *dev,
>  	bool is_drop_n_account =3D false;
>  	unsigned int slot_id =3D 0;
>  	bool do_vnet =3D false;
> +	int vnet_hdr_sz;

I had missed this earlier, but do_vnet is now redundant.
Akin to has_vnet_hdr in packet_snd.

More importantly, there is a path with do_vnet that hardcodes the
assumed header length:

        if (do_vnet &&
            virtio_net_hdr_from_skb(skb, h.raw + macoff -
                                    sizeof(struct virtio_net_hdr),
                                    vio_le(), true, 0)) {

This needs to use vnet_hdr_sz.

Please also review the entire af_packet.c if there are other
remaining hardcoded values that should be replaced with
vnet_hdr_sz.

>  =

>  	/* struct tpacket{2,3}_hdr is aligned to a multiple of TPACKET_ALIGNM=
ENT.
>  	 * We may add members to them until current aligned size without forc=
ing
> @@ -2308,8 +2309,9 @@ static int tpacket_rcv(struct sk_buff *skb, struc=
t net_device *dev,
>  		netoff =3D TPACKET_ALIGN(po->tp_hdrlen +
>  				       (maclen < 16 ? 16 : maclen)) +
>  				       po->tp_reserve;
> -		if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR)) {
> -			netoff +=3D sizeof(struct virtio_net_hdr);
> +		vnet_hdr_sz =3D READ_ONCE(po->vnet_hdr_sz);
> +		if (vnet_hdr_sz) {
> +			netoff +=3D vnet_hdr_sz;
>  			do_vnet =3D true;
>  		}
>  		macoff =3D netoff - maclen;
> @@ -2551,16 +2553,26 @@ static int __packet_snd_vnet_parse(struct virti=
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
> @@ -2722,6 +2734,7 @@ static int tpacket_snd(struct packet_sock *po, st=
ruct msghdr *msg)
>  	void *ph;
>  	DECLARE_SOCKADDR(struct sockaddr_ll *, saddr, msg->msg_name);
>  	bool need_wait =3D !(msg->msg_flags & MSG_DONTWAIT);
> +	int vnet_hdr_sz =3D READ_ONCE(po->vnet_hdr_sz);
>  	unsigned char *addr =3D NULL;
>  	int tp_len, size_max;
>  	void *data;
> @@ -2779,8 +2792,7 @@ static int tpacket_snd(struct packet_sock *po, st=
ruct msghdr *msg)
>  	size_max =3D po->tx_ring.frame_size
>  		- (po->tp_hdrlen - sizeof(struct sockaddr_ll));
>  =

> -	if ((size_max > dev->mtu + reserve + VLAN_HLEN) &&
> -	    !packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR))
> +	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !vnet_hdr_sz)
>  		size_max =3D dev->mtu + reserve + VLAN_HLEN;
>  =

>  	reinit_completion(&po->skb_completion);
> @@ -2809,10 +2821,11 @@ static int tpacket_snd(struct packet_sock *po, =
struct msghdr *msg)
>  		status =3D TP_STATUS_SEND_REQUEST;
>  		hlen =3D LL_RESERVED_SPACE(dev);
>  		tlen =3D dev->needed_tailroom;
> -		if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR)) {
> +
> +		if (vnet_hdr_sz) {
>  			vnet_hdr =3D data;
> -			data +=3D sizeof(*vnet_hdr);
> -			tp_len -=3D sizeof(*vnet_hdr);
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
> -		    !packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR) &&
> +		    !vnet_hdr_sz &&
>  		    !packet_extra_vlan_len_allowed(dev, skb))
>  			tp_len =3D -EMSGSIZE;
>  =

> @@ -2856,7 +2869,7 @@ static int tpacket_snd(struct packet_sock *po, st=
ruct msghdr *msg)
>  			}
>  		}
>  =

> -		if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR)) {
> +		if (vnet_hdr_sz) {
>  			if (virtio_net_hdr_to_skb(skb, vnet_hdr, vio_le())) {
>  				tp_len =3D -EINVAL;
>  				goto tpacket_error;
> @@ -2946,7 +2959,7 @@ static int packet_snd(struct socket *sock, struct=
 msghdr *msg, size_t len)
>  	struct virtio_net_hdr vnet_hdr =3D { 0 };
>  	int offset =3D 0;
>  	struct packet_sock *po =3D pkt_sk(sk);
> -	bool has_vnet_hdr =3D false;
> +	int vnet_hdr_sz =3D READ_ONCE(po->vnet_hdr_sz);
>  	int hlen, tlen, linear;
>  	int extra_len =3D 0;
>  =

> @@ -2990,11 +3003,11 @@ static int packet_snd(struct socket *sock, stru=
ct msghdr *msg, size_t len)
>  =

>  	if (sock->type =3D=3D SOCK_RAW)
>  		reserve =3D dev->hard_header_len;
> -	if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR)) {
> -		err =3D packet_snd_vnet_parse(msg, &len, &vnet_hdr);
> +
> +	if (vnet_hdr_sz) {
> +		err =3D packet_snd_vnet_parse(msg, &len, &vnet_hdr, vnet_hdr_sz);
>  		if (err)
>  			goto out_unlock;
> -		has_vnet_hdr =3D true;
>  	}
>  =

>  	if (unlikely(sock_flag(sk, SOCK_NOFCS))) {
> @@ -3064,11 +3077,11 @@ static int packet_snd(struct socket *sock, stru=
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

> @@ -3408,7 +3421,7 @@ static int packet_recvmsg(struct socket *sock, st=
ruct msghdr *msg, size_t len,
>  	struct sock *sk =3D sock->sk;
>  	struct sk_buff *skb;
>  	int copied, err;
> -	int vnet_hdr_len =3D 0;
> +	int vnet_hdr_len =3D READ_ONCE(pkt_sk(sk)->vnet_hdr_sz);
>  	unsigned int origlen =3D 0;
>  =

>  	err =3D -EINVAL;
> @@ -3449,11 +3462,10 @@ static int packet_recvmsg(struct socket *sock, =
struct msghdr *msg, size_t len,
>  =

>  	packet_rcv_try_clear_pressure(pkt_sk(sk));
>  =

> -	if (packet_sock_flag(pkt_sk(sk), PACKET_SOCK_HAS_VNET_HDR)) {
> -		err =3D packet_rcv_vnet(msg, skb, &len);
> +	if (vnet_hdr_len) {
> +		err =3D packet_rcv_vnet(msg, skb, &len, vnet_hdr_len);
>  		if (err)
>  			goto out_free;
> -		vnet_hdr_len =3D sizeof(struct virtio_net_hdr);
>  	}
>  =

>  	/* You lose any data beyond the buffer you gave. If it worries
> @@ -3915,8 +3927,9 @@ packet_setsockopt(struct socket *sock, int level,=
 int optname, sockptr_t optval,
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
> @@ -3925,11 +3938,20 @@ packet_setsockopt(struct socket *sock, int leve=
l, int optname, sockptr_t optval,
>  		if (copy_from_sockptr(&val, optval, sizeof(val)))
>  			return -EFAULT;
>  =

> +		if (optname =3D=3D PACKET_VNET_HDR_SZ) {
> +			if (val && val !=3D sizeof(struct virtio_net_hdr) &&
> +			    val !=3D sizeof(struct virtio_net_hdr_mrg_rxbuf))
> +				return -EINVAL;
> +			hdr_len =3D val;
> +		} else {
> +			hdr_len =3D val ? sizeof(struct virtio_net_hdr) : 0;
> +		}
> +
>  		lock_sock(sk);
>  		if (po->rx_ring.pg_vec || po->tx_ring.pg_vec) {
>  			ret =3D -EBUSY;
>  		} else {
> -			packet_sock_flag_set(po, PACKET_SOCK_HAS_VNET_HDR, val);
> +			WRITE_ONCE(po->vnet_hdr_sz, hdr_len);
>  			ret =3D 0;
>  		}
>  		release_sock(sk);
> @@ -4062,7 +4084,10 @@ static int packet_getsockopt(struct socket *sock=
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

always read with READ_ONCE to avoid KCSAN warnings

This also applies to the getsockopt

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



