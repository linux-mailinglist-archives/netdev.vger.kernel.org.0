Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BE4692265
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 16:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbjBJPjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 10:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbjBJPjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 10:39:35 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E77F77B9A
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 07:39:34 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id z5so6123706qtn.8
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 07:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Lzy26c6AeshZBHzxE5+S2w72nF68Ebkx7ZJQaq4/ok=;
        b=MAki9gXeheqNkP0BgY0e4GANkGPkvsY82u9cHmERYKR77cxm2zMHTxD7A+YZ+CtMxf
         cyVWfjhem2tJBG1hc69JMVQZnE17YGIN+qtQxF++oLnuYD8fBAjerNaYiatZTpmJRelu
         Bqv5MmPE0eepWzkM3Tmea6mdTHeMTVdC3xY5Kzq/N4TK1vLUks9+dKkzcbQT2FqM5PVb
         BQtwnxuo8r4EEDcanS56IBa6bKA4RfRh86X9WeVs6UERFkgGKN0JVHgIcdTgWGZCZtAX
         jMTwhdH7qmYnSiAMx64BZqxsGURt0fC0S6OS/TXVrHg5CzGdK8Q/45MayWyOVR/s8wsm
         N3LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9Lzy26c6AeshZBHzxE5+S2w72nF68Ebkx7ZJQaq4/ok=;
        b=sANHwnR+idO6ElnMLxVvTjmOyFYRH2CsWt1Bjtcw49EUPtMFfHhkGDSb2CfuPrT2je
         P3FKB0+Ifvhzt2+fwMW9Hwz5uGcV94+Vv4NmA7u0noKSIVq3N18XlvvGx9ZUKfH3m9Ep
         RJab5XTXfiFtOj/TrY3PqJ+f3QYatxIsRqqEeXg5QAcZ2VsoIEk4R/vFOS27aybv21l9
         dSMln3n/FzePOoYVgM8jEi55xI6vR4q+1etoTpoxbu00yVG3EE2dBI/rk0K4aaGaeKk5
         D6dKDwc8dEj7J90SEbt/vGZTsJDY7tVYLgA6PAY6QO/cM6ZM+1lnVohzVeBB6cbyNUwG
         TgSA==
X-Gm-Message-State: AO0yUKVtKHVyCp4VYEgRU5w0sRbyxERlemrf+Mie8UQEh13SeAmddujK
        4FP2GOifiSsAZjxZU1POcR4=
X-Google-Smtp-Source: AK7set+Eq0gIZFtTfaJsKCCqKTvC/gCt6+dOgpzAZKKozRPs2JDpn+JHCV3VohMl79RmxcNG5Y3WsA==
X-Received: by 2002:ac8:5c48:0:b0:3b6:a1c2:f63c with SMTP id j8-20020ac85c48000000b003b6a1c2f63cmr26900709qtj.33.1676043573125;
        Fri, 10 Feb 2023 07:39:33 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id d4-20020ac86144000000b003b9bca1e093sm3545592qtm.27.2023.02.10.07.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 07:39:32 -0800 (PST)
Date:   Fri, 10 Feb 2023 10:39:32 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>
Cc:     netdev@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        davem@davemloft.net, jasowang@redhat.com,
        =?UTF-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>
Message-ID: <63e665348b566_1b03a820873@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230210030710-mutt-send-email-mst@kernel.org>
References: <1675946595-103034-1-git-send-email-amy.saq@antgroup.com>
 <1675946595-103034-3-git-send-email-amy.saq@antgroup.com>
 <20230209080612-mutt-send-email-mst@kernel.org>
 <858f8db1-c107-1ac5-bcbc-84e0d36c981d@antgroup.com>
 <20230210030710-mutt-send-email-mst@kernel.org>
Subject: Re: [PATCH 2/2] net/packet: send and receive pkt with given
 vnet_hdr_sz
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

Michael S. Tsirkin wrote:
> On Fri, Feb 10, 2023 at 12:01:03PM +0800, =E6=B2=88=E5=AE=89=E7=90=AA(=E5=
=87=9B=E7=8E=A5) wrote:
> > =

> > =E5=9C=A8 2023/2/9 =E4=B8=8B=E5=8D=889:07, Michael S. Tsirkin =E5=86=99=
=E9=81=93:
> > > On Thu, Feb 09, 2023 at 08:43:15PM +0800, =E6=B2=88=E5=AE=89=E7=90=AA=
(=E5=87=9B=E7=8E=A5) wrote:
> > > > From: "Jianfeng Tan" <henry.tjf@antgroup.com>
> > > > =

> > > > When raw socket is used as the backend for kernel vhost, currentl=
y it
> > > > will regard the virtio net header as 10-byte, which is not always=
 the
> > > > case since some virtio features need virtio net header other than=

> > > > 10-byte, such as mrg_rxbuf and VERSION_1 that both need 12-byte v=
irtio
> > > > net header.
> > > > =

> > > > Instead of hardcoding virtio net header length to 10 bytes, tpack=
et_snd,
> > > > tpacket_rcv, packet_snd and packet_recvmsg now get the virtio net=
 header
> > > > size that is recorded in packet_sock to indicate the exact virtio=
 net
> > > > header size that virtio user actually prepares in the packets. By=
 doing
> > > > so, it can fix the issue of incorrect mac header parsing when the=
se
> > > > virtio features that need virtio net header other than 10-byte ar=
e
> > > > enable.
> > > > =

> > > > Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
> > > > Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
> > > > Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
> > > Does it handle VERSION_1 though? That one is also LE.
> > > Would it be better to pass a features bitmap instead?
> > =

> > =

> > Thanks for quick reply!
> > =

> > I am a little confused abot what "LE" presents here?
> =

> LE =3D=3D little_endian.
> Little endian format.
> =

> > For passing a features bitmap to af_packet here, our consideration is=

> > whether it will be too complicated for af_packet to understand the vi=
rtio
> > features bitmap in order to get the vnet header size. For now, all th=
e
> > virtio features stuff is handled by vhost worker and af_packet actual=
ly does
> > not need to know much about virtio features. Would it be better if we=
 keep
> > the virtio feature stuff in user-level and let user-level tell af_pac=
ket how
> > much space it should reserve?
> =

> Presumably, we'd add an API in include/linux/virtio_net.h ?

Better leave this opaque to packet sockets if they won't act on this
type info.
 =

This patch series probably should be a single patch btw. As else the
socket option introduced in the first is broken at that commit, since
the behavior is only introduced in patch 2.

> > > =

> > > =

> > > > ---
> > > >   net/packet/af_packet.c | 48 +++++++++++++++++++++++++++++++++--=
-------------
> > > >   1 file changed, 33 insertions(+), 15 deletions(-)
> > > > =

> > > > diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> > > > index ab37baf..4f49939 100644
> > > > --- a/net/packet/af_packet.c
> > > > +++ b/net/packet/af_packet.c
> > > > @@ -2092,18 +2092,25 @@ static unsigned int run_filter(struct sk_=
buff *skb,
> > > >   }
> > > >   static int packet_rcv_vnet(struct msghdr *msg, const struct sk_=
buff *skb,
> > > > -			   size_t *len)
> > > > +			   size_t *len, int vnet_hdr_sz)
> > > >   {
> > > >   	struct virtio_net_hdr vnet_hdr;
> > > > +	int ret;
> > > > -	if (*len < sizeof(vnet_hdr))
> > > > +	if (*len < vnet_hdr_sz)
> > > >   		return -EINVAL;
> > > > -	*len -=3D sizeof(vnet_hdr);
> > > > +	*len -=3D vnet_hdr_sz;
> > > >   	if (virtio_net_hdr_from_skb(skb, &vnet_hdr, vio_le(), true, 0)=
)
> > > >   		return -EINVAL;
> > > > -	return memcpy_to_msg(msg, (void *)&vnet_hdr, sizeof(vnet_hdr));=

> > > > +	ret =3D memcpy_to_msg(msg, (void *)&vnet_hdr, sizeof(vnet_hdr))=
;
> > > > +
> > > > +	/* reserve space for extra info in vnet_hdr if needed */
> > > > +	if (ret =3D=3D 0)
> > > > +		iov_iter_advance(&msg->msg_iter, vnet_hdr_sz - sizeof(vnet_hdr=
));
> > > > +

How about

    struct virtio_net_hdr_mrg_rxbuf vnet_hdr =3D { .num_buffers =3D 0 };

    ..

    ret =3D memcpy_to_msg(msg, (void *)&vnet_hdr, vnet_hdr_sz);

To initialize data correctly and avoid the extra function call.

> > > > +	return ret;
> > > >   }
> > > >   /*
> > > > @@ -2311,7 +2318,7 @@ static int tpacket_rcv(struct sk_buff *skb,=
 struct net_device *dev,
> > > >   				       (maclen < 16 ? 16 : maclen)) +
> > > >   				       po->tp_reserve;
> > > >   		if (po->has_vnet_hdr) {
> > > > -			netoff +=3D sizeof(struct virtio_net_hdr);
> > > > +			netoff +=3D po->vnet_hdr_sz;
> > > >   			do_vnet =3D true;
> > > >   		}
> > > >   		macoff =3D netoff - maclen;
> > > > @@ -2552,16 +2559,23 @@ static int __packet_snd_vnet_parse(struct=
 virtio_net_hdr *vnet_hdr, size_t len)
> > > >   }
> > > >   static int packet_snd_vnet_parse(struct msghdr *msg, size_t *le=
n,
> > > > -				 struct virtio_net_hdr *vnet_hdr)
> > > > +				 struct virtio_net_hdr *vnet_hdr, int vnet_hdr_sz)
> > > >   {
> > > > -	if (*len < sizeof(*vnet_hdr))
> > > > +	int ret;
> > > > +
> > > > +	if (*len < vnet_hdr_sz)
> > > >   		return -EINVAL;
> > > > -	*len -=3D sizeof(*vnet_hdr);
> > > > +	*len -=3D vnet_hdr_sz;
> > > >   	if (!copy_from_iter_full(vnet_hdr, sizeof(*vnet_hdr), &msg->ms=
g_iter))
> > > >   		return -EFAULT;
> > > > -	return __packet_snd_vnet_parse(vnet_hdr, *len);
> > > > +	ret =3D __packet_snd_vnet_parse(vnet_hdr, *len);
> > > > +
> > > > +	/* move iter to point to the start of mac header */
> > > > +	if (ret =3D=3D 0)
> > > > +		iov_iter_advance(&msg->msg_iter, vnet_hdr_sz - sizeof(struct v=
irtio_net_hdr));
> > > > +	return ret;
> > > >   }
> > > >   static int tpacket_fill_skb(struct packet_sock *po, struct sk_b=
uff *skb,
> > > > @@ -2730,6 +2744,7 @@ static int tpacket_snd(struct packet_sock *=
po, struct msghdr *msg)
> > > >   	int status =3D TP_STATUS_AVAILABLE;
> > > >   	int hlen, tlen, copylen =3D 0;
> > > >   	long timeo =3D 0;
> > > > +	int vnet_hdr_sz;
> > > >   	mutex_lock(&po->pg_vec_lock);
> > > > @@ -2811,8 +2826,9 @@ static int tpacket_snd(struct packet_sock *=
po, struct msghdr *msg)
> > > >   		tlen =3D dev->needed_tailroom;
> > > >   		if (po->has_vnet_hdr) {
> > > >   			vnet_hdr =3D data;
> > > > -			data +=3D sizeof(*vnet_hdr);
> > > > -			tp_len -=3D sizeof(*vnet_hdr);
> > > > +			vnet_hdr_sz =3D po->vnet_hdr_sz;
> > > > +			data +=3D vnet_hdr_sz;
> > > > +			tp_len -=3D vnet_hdr_sz;
> > > >   			if (tp_len < 0 ||
> > > >   			    __packet_snd_vnet_parse(vnet_hdr, tp_len)) {
> > > >   				tp_len =3D -EINVAL;
> > > > @@ -2947,6 +2963,7 @@ static int packet_snd(struct socket *sock, =
struct msghdr *msg, size_t len)
> > > >   	int offset =3D 0;
> > > >   	struct packet_sock *po =3D pkt_sk(sk);
> > > >   	bool has_vnet_hdr =3D false;
> > > > +	int vnet_hdr_sz;
> > > >   	int hlen, tlen, linear;
> > > >   	int extra_len =3D 0;
> > > > @@ -2991,7 +3008,8 @@ static int packet_snd(struct socket *sock, =
struct msghdr *msg, size_t len)
> > > >   	if (sock->type =3D=3D SOCK_RAW)
> > > >   		reserve =3D dev->hard_header_len;
> > > >   	if (po->has_vnet_hdr) {
> > > > -		err =3D packet_snd_vnet_parse(msg, &len, &vnet_hdr);
> > > > +		vnet_hdr_sz =3D po->vnet_hdr_sz;
> > > > +		err =3D packet_snd_vnet_parse(msg, &len, &vnet_hdr, vnet_hdr_s=
z);
> > > >   		if (err)
> > > >   			goto out_unlock;
> > > >   		has_vnet_hdr =3D true;
> > > > @@ -3068,7 +3086,7 @@ static int packet_snd(struct socket *sock, =
struct msghdr *msg, size_t len)
> > > >   		err =3D virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
> > > >   		if (err)
> > > >   			goto out_free;
> > > > -		len +=3D sizeof(vnet_hdr);
> > > > +		len +=3D vnet_hdr_sz;
> > > >   		virtio_net_hdr_set_proto(skb, &vnet_hdr);
> > > >   	}
> > > > @@ -3452,10 +3470,10 @@ static int packet_recvmsg(struct socket *=
sock, struct msghdr *msg, size_t len,
> > > >   	packet_rcv_try_clear_pressure(pkt_sk(sk));
> > > >   	if (pkt_sk(sk)->has_vnet_hdr) {
> > > > -		err =3D packet_rcv_vnet(msg, skb, &len);
> > > > +		vnet_hdr_len =3D pkt_sk(sk)->vnet_hdr_sz;
> > > > +		err =3D packet_rcv_vnet(msg, skb, &len, vnet_hdr_len);
> > > >   		if (err)
> > > >   			goto out_free;
> > > > -		vnet_hdr_len =3D sizeof(struct virtio_net_hdr);
> > > >   	}
> > > >   	/* You lose any data beyond the buffer you gave. If it worries=

> > > > -- =

> > > > 1.8.3.1
> =



