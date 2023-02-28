Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1F26A5254
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 05:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjB1Eb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 23:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjB1Eb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 23:31:56 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B08C26857
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 20:31:55 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id ay9so9232799qtb.9
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 20:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zn7RrUSBdNPze5DszbRpmZm4y1mKOuaKrU30yVg7mPU=;
        b=bxMM5Y3GtXS2FGE16Szz9iNMPWAy6uzUoUHFjAilILu1kG28anJWydSnVgfKtm8ITe
         9TJskxeUwoDTxJs2ghdF1lTZw0OnfFKjGqhcBaifUwD1Q+yZkzOkgeBz5mQ/66e620ML
         12E5azLN9e7Q+GCNvyx8wjrg7akQIUgDg5Lw09pRY0r8JsgJcjY5z8C26NkqEaHtBPjB
         bf7LExp5mttgbO91+ogUrlROfK9gB9+iEyqT9zhU+9Hq5KYK8JVMOpJpqCgaWpSk5PEF
         lncaL7jSOdDkXkRAyX3fJPwah+DIDwCwxDk+oWzCSdKNiOew5EK02Pz+zA04YXXIBGjB
         Awww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zn7RrUSBdNPze5DszbRpmZm4y1mKOuaKrU30yVg7mPU=;
        b=FsoINvL8PJ16ncLWdiKBfGMG8UFJwfUFbLYcI2fbx9GN2qbvC26b6rUbT2blzJiZPL
         oXwpO3Wvx6DDtbCsDbnfcl5wvPEydtq4ScgfEjtTh4ZVCaPr+DrpnmdrNtom+BjtAnLj
         Zyyw8HPvXkB7gHtrLOr/oX9mji9Q1tGBrgAOCwWo2O2jTrd39oin3Uo19Tq6QAJvkV+W
         J7ywotnsG5ZFGCFJPowtTf7H/V86j+MkSHCNyMz+cIoCXzKcLtDFpX/hr6ErF55Qgz/G
         oow4foG/UIgqf5iu9JZjVecs8/w5rg7mZ6hPZyApkNjsGGeO5Suemt0aS/Df73cCMaT8
         b1Fg==
X-Gm-Message-State: AO0yUKWWpN6KGFpmfAkGzWcwuFwi0nbnWS5mrqhKQCaWG86yQu3o5kSZ
        WLNPvsvr1LCosCtPbXX/aLA=
X-Google-Smtp-Source: AK7set/vwzCZOujapRRuyFwWmPwLETHxA4CAA89y89wzFQWyctwmlvUvoXfQALKRVc96Mxllgg4aHA==
X-Received: by 2002:ac8:5b85:0:b0:3bf:bb2c:449c with SMTP id a5-20020ac85b85000000b003bfbb2c449cmr2952339qta.15.1677558714130;
        Mon, 27 Feb 2023 20:31:54 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id d21-20020ac86155000000b003b2ea9b76d0sm5841138qtm.34.2023.02.27.20.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 20:31:53 -0800 (PST)
Date:   Mon, 27 Feb 2023 23:31:53 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     mst@redhat.com, davem@davemloft.net, jasowang@redhat.com,
        =?UTF-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>
Message-ID: <63fd83b98d020_18126f2089b@willemb.c.googlers.com.notmuch>
In-Reply-To: <4fee48b3-fac0-9de6-1edd-b3f3b246dab0@antgroup.com>
References: <1677497625-351024-1-git-send-email-amy.saq@antgroup.com>
 <63fcdaf7e3e9d_1684422084b@willemb.c.googlers.com.notmuch>
 <4fee48b3-fac0-9de6-1edd-b3f3b246dab0@antgroup.com>
Subject: Re: [PATCH v2] net/packet: support mergeable feautre of virtio
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
> =

> =E5=9C=A8 2023/2/28 =E4=B8=8A=E5=8D=8812:31, Willem de Bruijn =E5=86=99=
=E9=81=93:
> > =E6=B2=88=E5=AE=89=E7=90=AA(=E5=87=9B=E7=8E=A5) wrote:
> >> From: Jianfeng Tan <henry.tjf@antgroup.com>
> >>
> >> Packet sockets, like tap, can be used as the backend for kernel vhos=
t.
> >> In packet sockets, virtio net header size is currently hardcoded to =
be
> >> the size of struct virtio_net_hdr, which is 10 bytes; however, it is=
 not
> >> always the case: some virtio features, such as mrg_rxbuf, need virti=
o
> >> net header to be 12-byte long.
> >>
> >> Mergeable buffers, as a virtio feature, is worthy to support: packet=
s
> >> that larger than one-mbuf size will be dropped in vhost worker's
> >> handle_rx if mrg_rxbuf feature is not used, but large packets
> >> cannot be avoided and increasing mbuf's size is not economical.
> >>
> >> With this virtio feature enabled, packet sockets with hardcoded 10-b=
yte
> >> virtio net header will parse mac head incorrectly in packet_snd by t=
aking
> >> the last two bytes of virtio net header as part of mac header as wel=
l.
> >> This incorrect mac header parsing will cause packet be dropped due t=
o
> >> invalid ether head checking in later under-layer device packet recei=
ving.
> >>
> >> By adding extra field vnet_hdr_sz with utilizing holes in struct
> >> packet_sock to record current using virtio net header size and suppo=
rting
> >> extra sockopt PACKET_VNET_HDR_SZ to set specified vnet_hdr_sz, packe=
t
> >> sockets can know the exact length of virtio net header that virtio u=
ser
> >> gives.
> >> In packet_snd, tpacket_snd and packet_recvmsg, instead of using hard=
code
> >> virtio net header size, it can get the exact vnet_hdr_sz from corres=
ponding
> >> packet_sock, and parse mac header correctly based on this informatio=
n to
> >> avoid the packets being mistakenly dropped.
> >>
> >> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
> >> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
> >> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
> > net-next is closed
> =

> =

> May we still send the revision of this patch and/or keep discussing =

> during the merge window? We understand that new features will not be =

> took until the merge window finishes.

That is certainly fine. If patches are not expected to be merged,
perhaps label them RFC to avoid confusion.

> =

> =

> >
> >> @@ -2311,7 +2312,7 @@ static int tpacket_rcv(struct sk_buff *skb, st=
ruct net_device *dev,
> >>   				       (maclen < 16 ? 16 : maclen)) +
> >>   				       po->tp_reserve;
> >>   		if (po->has_vnet_hdr) {
> >> -			netoff +=3D sizeof(struct virtio_net_hdr);
> >> +			netoff +=3D po->vnet_hdr_sz;
> >>   			do_vnet =3D true;
> >>   		}
> >>   		macoff =3D netoff - maclen;
> >> @@ -2552,16 +2553,23 @@ static int __packet_snd_vnet_parse(struct vi=
rtio_net_hdr *vnet_hdr, size_t len)
> >>   }
> >>   =

> >>   static int packet_snd_vnet_parse(struct msghdr *msg, size_t *len,
> >> -				 struct virtio_net_hdr *vnet_hdr)
> >> +				 struct virtio_net_hdr *vnet_hdr, int vnet_hdr_sz)
> >>   {
> >> -	if (*len < sizeof(*vnet_hdr))
> >> +	int ret;
> >> +
> >> +	if (*len < vnet_hdr_sz)
> >>   		return -EINVAL;
> >> -	*len -=3D sizeof(*vnet_hdr);
> >> +	*len -=3D vnet_hdr_sz;
> >>   =

> >>   	if (!copy_from_iter_full(vnet_hdr, sizeof(*vnet_hdr), &msg->msg_i=
ter))
> >>   		return -EFAULT;
> >>   =

> >> -	return __packet_snd_vnet_parse(vnet_hdr, *len);
> >> +	ret =3D __packet_snd_vnet_parse(vnet_hdr, *len);
> >> +
> >> +	/* move iter to point to the start of mac header */
> >> +	if (ret =3D=3D 0)
> >> +		iov_iter_advance(&msg->msg_iter, vnet_hdr_sz - sizeof(struct virt=
io_net_hdr));
> >> +	return ret;
> > Let's make the error path the exception
> >
> >          if (ret)
> >                  return ret;
> >
> > And maybe avoid calling iov_iter_advance if vnet_hdr_sz =3D=3D sizeof=
(*vnet_hdr)
> >
> >>   	case PACKET_VNET_HDR:
> >> +	case PACKET_VNET_HDR_SZ:
> >>   	{
> >>   		int val;
> >> +		int hdr_len =3D 0;
> >>   =

> >>   		if (sock->type !=3D SOCK_RAW)
> >>   			return -EINVAL;
> >> @@ -3931,11 +3945,23 @@ static void packet_flush_mclist(struct sock =
*sk)
> >>   		if (copy_from_sockptr(&val, optval, sizeof(val)))
> >>   			return -EFAULT;
> >>   =

> >> +		if (optname =3D=3D PACKET_VNET_HDR_SZ) {
> >> +			if (val !=3D sizeof(struct virtio_net_hdr) &&
> >> +			    val !=3D sizeof(struct virtio_net_hdr_mrg_rxbuf))
> >> +				return -EINVAL;
> >> +			hdr_len =3D val;
> >> +		}
> >> +
> >      } else {
> >              hdr_len =3D sizeof(struct virtio_net_hdr);
> >      }
> >
> >>   		lock_sock(sk);
> >>   		if (po->rx_ring.pg_vec || po->tx_ring.pg_vec) {
> >>   			ret =3D -EBUSY;
> >>   		} else {
> >> -			po->has_vnet_hdr =3D !!val;
> >> +			if (optname =3D=3D PACKET_VNET_HDR) {
> >> +				po->has_vnet_hdr =3D !!val;
> >> +				if (po->has_vnet_hdr)
> >> +					hdr_len =3D sizeof(struct virtio_net_hdr);
> >> +			}
> >> +			po->vnet_hdr_sz =3D hdr_len;
> > then this is not needed
> >>   			ret =3D 0;
> >>   		}
> >>   		release_sock(sk);
> >> @@ -4070,6 +4096,9 @@ static int packet_getsockopt(struct socket *so=
ck, int level, int optname,
> >>   	case PACKET_VNET_HDR:
> >>   		val =3D po->has_vnet_hdr;
> >>   		break;
> >> +	case PACKET_VNET_HDR_SZ:
> >> +		val =3D po->vnet_hdr_sz;
> >> +		break;
> >>   	case PACKET_VERSION:
> >>   		val =3D po->tp_version;
> >>   		break;
> >> diff --git a/net/packet/internal.h b/net/packet/internal.h
> >> index 48af35b..e27b47d 100644
> >> --- a/net/packet/internal.h
> >> +++ b/net/packet/internal.h
> >> @@ -121,7 +121,8 @@ struct packet_sock {
> >>   				origdev:1,
> >>   				has_vnet_hdr:1,
> >>   				tp_loss:1,
> >> -				tp_tx_has_off:1;
> >> +				tp_tx_has_off:1,
> >> +				vnet_hdr_sz:8;	/* vnet header size should use */
> > has_vnet_hdr is no longer needed when adding vnet_hdr_sz. removing th=
at simplifies the code
> =

> =

> So we are going to indicate whether the packet socket has a vnet header=
 =

> based on vnet_hdr_sz it is set to, right?

That's the idea. That has all state. The boolean doesn't add any useful i=
nfo.
