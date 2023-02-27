Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7636A4706
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 17:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjB0Qb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 11:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjB0Qbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 11:31:55 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A754E4EE9
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 08:31:53 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id m4so4818511qvq.3
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 08:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L82fqdF8zp+mWeB8+hn0/02wNSt3ZTyudI4TjM2g+i4=;
        b=mbeY0c3T2mcn3pyuTBH9lhidhCOG+KL3t1LFMBdNAkCEVAmE29wXJlacMPFRaQrxJI
         CH56ftuuZR+52Um5eLzCIAkEinHjwzJyEY8yNwN6uRsBWXQYVBEy0npKX3gW3eMBoPXC
         Oy5Pjdjy86Ixc+fLZsshG3ABMtuXT5KsnyDfnRarKyQ2Hj/Tbcp3IQJd8RjpHQeK/cHn
         f4104EZhW4TUe1djOgMD1Vm22TOT5N/VsgrYZA7FY9cCMTpdxkcFljOrC0iTxRk2Qm5F
         T8VWr/0echziERCEjfF80BmHEgqL9t1VFZ1QETzHGAO9jQM/Dg5b2qPMwu+t2ycZ0DYW
         VhpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=L82fqdF8zp+mWeB8+hn0/02wNSt3ZTyudI4TjM2g+i4=;
        b=VpYttU7RI7fT5BgevzFllj6r3TLND4sikoMVFHSamzi50gkUf5nvmajC+ILCrBa3sS
         g1hPktoNQ1r1LSiDquQi09SbY2BU1Mv9/c7LoyoC2MTVX4vlT8aOfa8xyMwPtsXkvKch
         pihGvM5k5KpreZK/atiEpoZQGXHb2Yn7unSGJK3vrA+FDQ4FKBUplxwfxoUMuEeWJ9V5
         IEgJ5con1Ku/QtC4xUm+L4c1K/mURVTTPBXtukoDHkgCipdvg2snLbAnrLM8PxfPNaCo
         scgjF+pKGA95nHP7WM611iCR0fNjs36KzKBQnGeXpNU89Qa2mQYkI6QeuArNcBvAY+c4
         4TJA==
X-Gm-Message-State: AO0yUKX04F5PN4X1iaMu+e18tyQP2ATb8fMJBMeT1eb4lSPhD64EnC23
        Ij5+22b6U3cxE7DNyRfHMsw=
X-Google-Smtp-Source: AK7set+X6pQM0ZSCDJARNzXTL76zyACNb24j0bbv389aE+WLFCDVO0BJUm200sy1A9+22ZuAVGTibQ==
X-Received: by 2002:a05:6214:2a82:b0:56c:15c9:b5f0 with SMTP id jr2-20020a0562142a8200b0056c15c9b5f0mr115662qvb.17.1677515512615;
        Mon, 27 Feb 2023 08:31:52 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id m27-20020a05620a13bb00b0073b587194d0sm5098692qki.104.2023.02.27.08.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 08:31:52 -0800 (PST)
Date:   Mon, 27 Feb 2023 11:31:51 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>,
        netdev@vger.kernel.org
Cc:     willemdebruijn.kernel@gmail.com, mst@redhat.com,
        davem@davemloft.net, jasowang@redhat.com,
        =?UTF-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>,
        =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>
Message-ID: <63fcdaf7e3e9d_1684422084b@willemb.c.googlers.com.notmuch>
In-Reply-To: <1677497625-351024-1-git-send-email-amy.saq@antgroup.com>
References: <1677497625-351024-1-git-send-email-amy.saq@antgroup.com>
Subject: RE: [PATCH v2] net/packet: support mergeable feautre of virtio
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

> Mergeable buffers, as a virtio feature, is worthy to support: packets
> that larger than one-mbuf size will be dropped in vhost worker's
> handle_rx if mrg_rxbuf feature is not used, but large packets
> cannot be avoided and increasing mbuf's size is not economical.
> =

> With this virtio feature enabled, packet sockets with hardcoded 10-byte=

> virtio net header will parse mac head incorrectly in packet_snd by taki=
ng
> the last two bytes of virtio net header as part of mac header as well.
> This incorrect mac header parsing will cause packet be dropped due to
> invalid ether head checking in later under-layer device packet receivin=
g.
> =

> By adding extra field vnet_hdr_sz with utilizing holes in struct
> packet_sock to record current using virtio net header size and supporti=
ng
> extra sockopt PACKET_VNET_HDR_SZ to set specified vnet_hdr_sz, packet
> sockets can know the exact length of virtio net header that virtio user=

> gives.
> In packet_snd, tpacket_snd and packet_recvmsg, instead of using hardcod=
e
> virtio net header size, it can get the exact vnet_hdr_sz from correspon=
ding
> packet_sock, and parse mac header correctly based on this information t=
o
> avoid the packets being mistakenly dropped.
> =

> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>

net-next is closed

> @@ -2311,7 +2312,7 @@ static int tpacket_rcv(struct sk_buff *skb, struc=
t net_device *dev,
>  				       (maclen < 16 ? 16 : maclen)) +
>  				       po->tp_reserve;
>  		if (po->has_vnet_hdr) {
> -			netoff +=3D sizeof(struct virtio_net_hdr);
> +			netoff +=3D po->vnet_hdr_sz;
>  			do_vnet =3D true;
>  		}
>  		macoff =3D netoff - maclen;
> @@ -2552,16 +2553,23 @@ static int __packet_snd_vnet_parse(struct virti=
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
> +	/* move iter to point to the start of mac header */
> +	if (ret =3D=3D 0)
> +		iov_iter_advance(&msg->msg_iter, vnet_hdr_sz - sizeof(struct virtio_=
net_hdr));
> +	return ret;

Let's make the error path the exception

        if (ret)
                return ret;

And maybe avoid calling iov_iter_advance if vnet_hdr_sz =3D=3D sizeof(*vn=
et_hdr)

>  	case PACKET_VNET_HDR:
> +	case PACKET_VNET_HDR_SZ:
>  	{
>  		int val;
> +		int hdr_len =3D 0;
>  =

>  		if (sock->type !=3D SOCK_RAW)
>  			return -EINVAL;
> @@ -3931,11 +3945,23 @@ static void packet_flush_mclist(struct sock *sk=
)
>  		if (copy_from_sockptr(&val, optval, sizeof(val)))
>  			return -EFAULT;
>  =

> +		if (optname =3D=3D PACKET_VNET_HDR_SZ) {
> +			if (val !=3D sizeof(struct virtio_net_hdr) &&
> +			    val !=3D sizeof(struct virtio_net_hdr_mrg_rxbuf))
> +				return -EINVAL;
> +			hdr_len =3D val;
> +		}
> +

    } else {
            hdr_len =3D sizeof(struct virtio_net_hdr);
    }

>  		lock_sock(sk);
>  		if (po->rx_ring.pg_vec || po->tx_ring.pg_vec) {
>  			ret =3D -EBUSY;
>  		} else {
> -			po->has_vnet_hdr =3D !!val;
> +			if (optname =3D=3D PACKET_VNET_HDR) {
> +				po->has_vnet_hdr =3D !!val;
> +				if (po->has_vnet_hdr)
> +					hdr_len =3D sizeof(struct virtio_net_hdr);
> +			}
> +			po->vnet_hdr_sz =3D hdr_len;

then this is not needed
>  			ret =3D 0;
>  		}
>  		release_sock(sk);
> @@ -4070,6 +4096,9 @@ static int packet_getsockopt(struct socket *sock,=
 int level, int optname,
>  	case PACKET_VNET_HDR:
>  		val =3D po->has_vnet_hdr;
>  		break;
> +	case PACKET_VNET_HDR_SZ:
> +		val =3D po->vnet_hdr_sz;
> +		break;
>  	case PACKET_VERSION:
>  		val =3D po->tp_version;
>  		break;
> diff --git a/net/packet/internal.h b/net/packet/internal.h
> index 48af35b..e27b47d 100644
> --- a/net/packet/internal.h
> +++ b/net/packet/internal.h
> @@ -121,7 +121,8 @@ struct packet_sock {
>  				origdev:1,
>  				has_vnet_hdr:1,
>  				tp_loss:1,
> -				tp_tx_has_off:1;
> +				tp_tx_has_off:1,
> +				vnet_hdr_sz:8;	/* vnet header size should use */

has_vnet_hdr is no longer needed when adding vnet_hdr_sz. removing that s=
implifies the code

drop the comment. That is quite self explanatory from the variable name.

>  	int			pressure;
>  	int			ifindex;	/* bound device		*/
>  	__be16			num;
> -- =

> 1.8.3.1
> =



