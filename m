Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284D869225A
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 16:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbjBJPgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 10:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbjBJPgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 10:36:21 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D45F77BA0
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 07:36:18 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id g18so6124872qtb.6
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 07:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EsGheAneyT/l9DvsZ4r+d4OwOpyiE3YxTEwLXW0dXT0=;
        b=lFVdBLUtTTmHESUIvReXIKY9iUNcVF5Nz/5JKXn18WDjby3jWGjJqE+BkNjJPcMO4P
         iU6obiRy7qMHc8vgmSP1njU6CSE0maVu2094pWJUs3zsjGL5/97yLZmehyusXmMST+us
         fBngcQxWwFkkx4iVgkHfk+Vre8l24eXqJDEFh7G0wBjgmiGzyAvLjIhaeuNrF1KOysTM
         gQ4gV1kXYkAKdQGmwIYTv+1aWc3Bs5gGuPt6861r+QUOYJa3n9nLwbwSJ/HTCisNj55K
         Fq8Ssih0wx59kfX52PcNgnureoOOejYawRbOw3wzD5mY7zG03ErKFMEPqaBBfcFV/qRn
         rbGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EsGheAneyT/l9DvsZ4r+d4OwOpyiE3YxTEwLXW0dXT0=;
        b=R/BKqlCOwa5G419rbAQMdngs0Awir/eEXStPOBd5YXFnuz6MLRAoy5IZybH0BCogSk
         Cf9kBizdqiup28yhs/d3Ore6N3tA8w5CW62Lw3VH90JIRUMNYDwSeGmvZjUZmxLO/sBg
         arRw0D9ejNxtfYaVY4nFyXaC8zd1FAVgZjZP55/tAaa2WZHmsVZrh5FEmMoHvUUjCRwt
         c/nwZ7kSbnaqXPkt4w/4/IMctcE+VlaK3iqO61e/el+8ZtrOdHKs9jRs3lXHcK3R4bwI
         M69T4W4E5v42TRB1L8YzYg0uYr4jQIYyTkSdI/c6GpVoBQwZ9uxebaj5Lo+8dIG9nTgl
         Z0hA==
X-Gm-Message-State: AO0yUKUACe3vfF7ohLmCkdCmaRQE6Dv8HCGGBsW8GFS9qXN7iPXYmmXV
        ACF8qP+f/Rs4RNcp9GGaLHaXd5dB/kE=
X-Google-Smtp-Source: AK7set83geS9ZL02oYgwAD/fnRWYvDsSJhnnvG5nX4Zme4GFdxmleQWSe0wcOj8Mz72axAqxYnSvRQ==
X-Received: by 2002:ac8:5887:0:b0:3b8:6a3b:3bfc with SMTP id t7-20020ac85887000000b003b86a3b3bfcmr26891733qta.24.1676043377211;
        Fri, 10 Feb 2023 07:36:17 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id 128-20020a370586000000b00721b773b40asm3858901qkf.4.2023.02.10.07.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 07:36:16 -0800 (PST)
Date:   Fri, 10 Feb 2023 10:36:16 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>
Cc:     netdev@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        davem@davemloft.net, jasowang@redhat.com,
        =?UTF-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>
Message-ID: <63e664707f792_1b03a820836@willemb.c.googlers.com.notmuch>
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

If packet sockets do not act on the contents of these extended fields,
it's probably better to leave them opaque.

This patch series probably should be one patch. The new option in the
first patch modifies the data path. Now there is one SHA1 at which its
behavior would not work.

> =

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

    struct virtio_net_hdr_mrg_rxbuf vnet_hdr { .num_buffers =3D 0 };

    ..

    ret =3D memcpy_to_msg(msg, (void *)&vnet_hdr, vnet_hdr_sz);

To avoid the iov_iter_advance and properly initialize those bytes.

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



