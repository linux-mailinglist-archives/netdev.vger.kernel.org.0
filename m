Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8690E6E16CA
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 23:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjDMV7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 17:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjDMV7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 17:59:04 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430D419D;
        Thu, 13 Apr 2023 14:59:03 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id m21so6700079qtg.0;
        Thu, 13 Apr 2023 14:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681423142; x=1684015142;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PDgsmvntZxPx62gk3cawBNyY3nzlrOuECA/cAlSvltE=;
        b=LUVd9p0rYEZN8Tf5nzU3LuwRs/F7Gq2jnHW8IcmlWHGCzF4zLuJz9GB/Waw94kkCKa
         y9fsdIaf1JjSMJv38CVkBrZ/eh7r6P2wVodLZZb0j5zNJZ+rpJB0zqp7fjgT6duDyUPG
         r6qxmlNx5OEhj0l9Mo/OzKxSDTJaWZEKy+HdwcE42zIpvQvyZn77J1TEovR9dPtsKrIG
         etEueHXKd/RmM104QfEGq1N4c+8G3ghjUXOqusTiVUi18tpLFYox0kv1QhyiHsXVT6OJ
         5CAqEsjFnqJ2SdLsKQN+JMB5vBZBJrkNvi+IvOJ+DKet8RelDQvdno5T/45b4vs10o8T
         6i1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681423142; x=1684015142;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PDgsmvntZxPx62gk3cawBNyY3nzlrOuECA/cAlSvltE=;
        b=VbngxCk6H7vesSkUnhV0HKxsPFHDWIN2NgPyHVkGXbRm95vRurigRymrcQbqoxBVZA
         fXl4bJvjcOizO7GKzt/Qs+Hr0JBnV55jtHNti+W5oWQHj5VyjIBHeZAfVCw75EpC2QNu
         QaYaLW0Zn+ViWvnV5edyxQuF36rJVWwkc1C83j/tS2Z840kb+qUDGsdEZsu6dqFIHboz
         gLh/S6wKWkU/HU+ARy3IUUqTy2DQn1GQLy8Bh9oH5oTHKnGsmLNZyfmrLO+AFGY7HWH4
         Vv+4FGw4VvO0xO1ZA/LaZNEObnjZEBB81oKj3p+p7fYzRbrz8nvZL2ye3ZLaf/gZRWW5
         iQsA==
X-Gm-Message-State: AAQBX9clwokE/vRhbQiGtYlkPgYRzHGDxWhIw/0nYTvbFLds2Thgfk5+
        rXJIW18m6Dq9clnudX3PSWs=
X-Google-Smtp-Source: AKy350Zrl2sfZ8kixrcnme9nha9a0qrx+Tbo+zinjcSzVT9lgARqCBlOpt1PxAmNqvrD4DakrUHAIA==
X-Received: by 2002:a05:622a:8a:b0:3e3:7c94:7270 with SMTP id o10-20020a05622a008a00b003e37c947270mr5444222qtw.59.1681423142239;
        Thu, 13 Apr 2023 14:59:02 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id l18-20020ac87252000000b003bf9f9f1844sm772549qtp.71.2023.04.13.14.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 14:59:01 -0700 (PDT)
Date:   Thu, 13 Apr 2023 17:59:01 -0400
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
Message-ID: <64387b25619ba_1479cd29457@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230413114402.50225-1-amy.saq@antgroup.com>
References: <20230413114402.50225-1-amy.saq@antgroup.com>
Subject: RE: [PATCH v8] net/packet: support mergeable feature of virtio
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

> Changelog
> =

> V7 -> V8:
> * remove redundant variables;
> * resolve KCSAN warning.
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
>  net/packet/af_packet.c         | 93 ++++++++++++++++++++--------------=

>  net/packet/diag.c              |  2 +-
>  net/packet/internal.h          |  2 +-
>  4 files changed, 58 insertions(+), 40 deletions(-)
> =

> @@ -2250,7 +2250,7 @@ static int tpacket_rcv(struct sk_buff *skb, struc=
t net_device *dev,
>  	__u32 ts_status;
>  	bool is_drop_n_account =3D false;
>  	unsigned int slot_id =3D 0;
> -	bool do_vnet =3D false;
> +	int vnet_hdr_sz =3D 0;
>  =

>  	/* struct tpacket{2,3}_hdr is aligned to a multiple of TPACKET_ALIGNM=
ENT.
>  	 * We may add members to them until current aligned size without forc=
ing
> @@ -2308,10 +2308,9 @@ static int tpacket_rcv(struct sk_buff *skb, stru=
ct net_device *dev,
>  		netoff =3D TPACKET_ALIGN(po->tp_hdrlen +
>  				       (maclen < 16 ? 16 : maclen)) +
>  				       po->tp_reserve;
> -		if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR)) {
> -			netoff +=3D sizeof(struct virtio_net_hdr);
> -			do_vnet =3D true;
> -		}
> +		vnet_hdr_sz =3D READ_ONCE(po->vnet_hdr_sz);
> +		if (vnet_hdr_sz)
> +			netoff +=3D vnet_hdr_sz;
>  		macoff =3D netoff - maclen;
>  	}
>  	if (netoff > USHRT_MAX) {
> @@ -2337,7 +2336,6 @@ static int tpacket_rcv(struct sk_buff *skb, struc=
t net_device *dev,
>  			snaplen =3D po->rx_ring.frame_size - macoff;
>  			if ((int)snaplen < 0) {
>  				snaplen =3D 0;
> -				do_vnet =3D false;
>  			}
>  		}
>  	} else if (unlikely(macoff + snaplen >
> @@ -2351,7 +2349,6 @@ static int tpacket_rcv(struct sk_buff *skb, struc=
t net_device *dev,
>  		if (unlikely((int)snaplen < 0)) {
>  			snaplen =3D 0;
>  			macoff =3D GET_PBDQC_FROM_RB(&po->rx_ring)->max_frame_len;
> -			do_vnet =3D false;

here and in the block above the existing behavior must be maintained:
vnet_hdr_sz must be reset to zero in these cases.

>  		}
>  	}
>  	spin_lock(&sk->sk_receive_queue.lock);
> @@ -2367,7 +2364,7 @@ static int tpacket_rcv(struct sk_buff *skb, struc=
t net_device *dev,
>  		__set_bit(slot_id, po->rx_ring.rx_owner_map);
>  	}
>  =

> -	if (do_vnet &&
> +	if (vnet_hdr_sz &&
>  	    virtio_net_hdr_from_skb(skb, h.raw + macoff -
>  				    sizeof(struct virtio_net_hdr),
>  				    vio_le(), true, 0)) {
