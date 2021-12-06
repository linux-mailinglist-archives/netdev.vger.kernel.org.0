Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0A0469B18
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 16:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355773AbhLFPMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 10:12:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40878 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355893AbhLFPK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 10:10:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638803247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bRKmGdLY2fUWKKHUgHI293yHzRYcG6oRNhra2eapoo0=;
        b=aqgmCPC3fnkK0h6eFubxaYeuXjHFqMIo8fCnEgzyeFBkHjjW5DKDvK2KxBgOPDK7s/w9ZX
        SinmOfczSVICpBB7udTHa87R1RgMdLJ/krUCwbAPjb8wnqHjqxw6XUR3JdaJzyhToHtWp3
        TM8M+TmLpt54yshoNz6K5qt5f/MVDBo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-379-E_4IBWETNy6Yg98D-umaIg-1; Mon, 06 Dec 2021 10:07:26 -0500
X-MC-Unique: E_4IBWETNy6Yg98D-umaIg-1
Received: by mail-wm1-f71.google.com with SMTP id 187-20020a1c02c4000000b003335872db8dso6248879wmc.2
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 07:07:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bRKmGdLY2fUWKKHUgHI293yHzRYcG6oRNhra2eapoo0=;
        b=nba8qewGh2+0RZtiVyYjzaeo5MV+2xf++SPZbNI21qHKxSvCVoRYyWK+6/2nRNVHuE
         OavDjMeslFx0CICq1YliY/5NMrFYiP0ym1Bm8gbusKvwG7MQFGtDEKXBuqD46eLO9qKY
         hpbwpM+J6oeB41GwMFufxVXVFOtfSdzpKphbXY+E3ydEyLjnPGzlQwExZlJPkxwUiT4j
         cUbWjmVkEQIudeuPoplhKkMwFY+pvFRfsgEYVXn19EMAHR7dJuh0X9X+a2QwJUAC45td
         dGxwbQ04XPC0/wHdhWajcPsrU5q69/pVw+OLsGxDm2ciLqiQakVmsoQCpEnV4ySO/vmD
         4Rcw==
X-Gm-Message-State: AOAM533Bk/zaHWvx+HUchFYp3KmNltp6rON1suzqvbF7pBfDhLJRLsGr
        UiSe7kfujPGhAXNSD1Rd45xPcQwVZZTLmHOUTV7X3B+tyUdD+YmU3dHgYXQIkd3+CCJOOXjHOvW
        9UJoU3R6Zt9y8P40K
X-Received: by 2002:a1c:7d8e:: with SMTP id y136mr39185465wmc.121.1638803242400;
        Mon, 06 Dec 2021 07:07:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyXWKPJqRFEMzlK6FGDepzkucq+GtnMdEe4lf/+qwdygfeh7vVi+20eDVoeiddAIjWifEQA1w==
X-Received: by 2002:a1c:7d8e:: with SMTP id y136mr39185043wmc.121.1638803238394;
        Mon, 06 Dec 2021 07:07:18 -0800 (PST)
Received: from localhost (net-37-182-17-175.cust.vodafonedsl.it. [37.182.17.175])
        by smtp.gmail.com with ESMTPSA id a10sm14047916wmq.27.2021.12.06.07.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 07:07:17 -0800 (PST)
Date:   Mon, 6 Dec 2021 16:07:15 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v19 bpf-next 12/23] bpf: add multi-buff support to the
 bpf_xdp_adjust_tail() API
Message-ID: <Ya4nI6DKPmGOpfMf@lore-desk>
References: <cover.1638272238.git.lorenzo@kernel.org>
 <81319e52462c07361dbf99b9ec1748b41cdcf9fa.1638272238.git.lorenzo@kernel.org>
 <61ad94bde1ea6_50c22081e@john.notmuch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VEUM44tNPQgAcisC"
Content-Disposition: inline
In-Reply-To: <61ad94bde1ea6_50c22081e@john.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--VEUM44tNPQgAcisC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi wrote:
> > From: Eelco Chaudron <echaudro@redhat.com>
> >=20
> > This change adds support for tail growing and shrinking for XDP multi-b=
uff.
> >=20
> > When called on a multi-buffer packet with a grow request, it will work
> > on the last fragment of the packet. So the maximum grow size is the
> > last fragments tailroom, i.e. no new buffer will be allocated.
> > A XDP mb capable driver is expected to set frag_size in xdp_rxq_info da=
ta
> > structure to notify the XDP core the fragment size. frag_size set to 0 =
is
> > interpreted by the XDP core as tail growing is not allowed.
> > Introduce __xdp_rxq_info_reg utility routine to initialize frag_size fi=
eld.
> >=20
> > When shrinking, it will work from the last fragment, all the way down to
> > the base buffer depending on the shrinking size. It's important to ment=
ion
> > that once you shrink down the fragment(s) are freed, so you can not grow
> > again to the original size.
> >=20
> > Acked-by: Jakub Kicinski <kuba@kernel.org>
> > Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c |  3 +-
> >  include/net/xdp.h                     | 16 ++++++-
> >  net/core/filter.c                     | 67 +++++++++++++++++++++++++++
> >  net/core/xdp.c                        | 12 +++--
> >  4 files changed, 90 insertions(+), 8 deletions(-)
>=20
> Some nits and one questiopn about offset > 0 on shrink.

Hi John,

thx for the review.

>=20
> >  void xdp_rxq_info_unreg(struct xdp_rxq_info *xdp_rxq);
> >  void xdp_rxq_info_unused(struct xdp_rxq_info *xdp_rxq);
> >  bool xdp_rxq_info_is_reg(struct xdp_rxq_info *xdp_rxq);
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index b9bfe6fac6df..ace67957e685 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -3831,11 +3831,78 @@ static const struct bpf_func_proto bpf_xdp_adju=
st_head_proto =3D {
> >  	.arg2_type	=3D ARG_ANYTHING,
> >  };
> > =20
> > +static int bpf_xdp_mb_increase_tail(struct xdp_buff *xdp, int offset)
> > +{
> > +	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > +	skb_frag_t *frag =3D &sinfo->frags[sinfo->nr_frags - 1];
> > +	struct xdp_rxq_info *rxq =3D xdp->rxq;
> > +	int size, tailroom;
>=20
> These could be 'unsized int'.

ack, I will fix it.

>=20
> > +
> > +	if (!rxq->frag_size || rxq->frag_size > xdp->frame_sz)
> > +		return -EOPNOTSUPP;
> > +
> > +	tailroom =3D rxq->frag_size - skb_frag_size(frag) - skb_frag_off(frag=
);
> > +	if (unlikely(offset > tailroom))
> > +		return -EINVAL;
> > +
> > +	size =3D skb_frag_size(frag);
> > +	memset(skb_frag_address(frag) + size, 0, offset);
> > +	skb_frag_size_set(frag, size + offset);
>=20
> Could probably make this a helper skb_frag_grow() or something in
> skbuff.h we have sub, add, put_zero, etc. there.

I guess we can just use skb_frag_size_add() here.

>=20
> > +	sinfo->xdp_frags_size +=3D offset;
> > +
> > +	return 0;
> > +}
> > +
> > +static int bpf_xdp_mb_shrink_tail(struct xdp_buff *xdp, int offset)
> > +{
> > +	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > +	int i, n_frags_free =3D 0, len_free =3D 0;
> > +
> > +	if (unlikely(offset > (int)xdp_get_buff_len(xdp) - ETH_HLEN))
> > +		return -EINVAL;
> > +
> > +	for (i =3D sinfo->nr_frags - 1; i >=3D 0 && offset > 0; i--) {
> > +		skb_frag_t *frag =3D &sinfo->frags[i];
> > +		int size =3D skb_frag_size(frag);
> > +		int shrink =3D min_t(int, offset, size);
> > +
> > +		len_free +=3D shrink;
> > +		offset -=3D shrink;
> > +
> > +		if (unlikely(size =3D=3D shrink)) {
>=20
> not so sure about the unlikely.

I will let Eelco comment on it since he is the author of the patch.

>=20
> > +			struct page *page =3D skb_frag_page(frag);
> > +
> > +			__xdp_return(page_address(page), &xdp->rxq->mem,
> > +				     false, NULL);
> > +			n_frags_free++;
> > +		} else {
> > +			skb_frag_size_set(frag, size - shrink);
>=20
> skb_frag_size_sub() maybe, but you need to pull out size anyways
> so its not a big deal to me.

ack, I agree to use skb_frag_size_sub().

>=20
> > +			break;
> > +		}
> > +	}
> > +	sinfo->nr_frags -=3D n_frags_free;
> > +	sinfo->xdp_frags_size -=3D len_free;
> > +
> > +	if (unlikely(offset > 0)) {
>=20
> hmm whats the case for offset to !=3D 0? Seems with initial unlikely
> check and shrinking while walking backwards through the frags it
> should be zero? Maybe a comment would help?

Looking at the code, offset can be > 0 here whenever we reduce the mb frame=
 to
a legacy frame (so whenever offset will move the boundary into the linear
area).

Regards,
Lorenzo

>=20
> > +		xdp_buff_clear_mb(xdp);
> > +		xdp->data_end -=3D offset;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
> >  {
> >  	void *data_hard_end =3D xdp_data_hard_end(xdp); /* use xdp->frame_sz =
*/
> >  	void *data_end =3D xdp->data_end + offset;
> > =20
> > +	if (unlikely(xdp_buff_is_mb(xdp))) { /* xdp multi-buffer */
> > +		if (offset < 0)
> > +			return bpf_xdp_mb_shrink_tail(xdp, -offset);
> > +
> > +		return bpf_xdp_mb_increase_tail(xdp, offset);
> > +	}
> > +
> >  	/* Notice that xdp_data_hard_end have reserved some tailroom */
> >  	if (unlikely(data_end > data_hard_end))
> >  		return -EINVAL;
>=20
> [...]
>=20
> Thanks,
> John
>=20

--VEUM44tNPQgAcisC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYa4nIwAKCRA6cBh0uS2t
rOXSAP4srMHC/Tl681UMpPM+TCu+HKzfJ2O30bhgS0ZWRwe2UwEA6lJM/UOUEW2i
rsKREZ3djB9+WdWpSyQ5MJyIhbGeiwM=
=J6cj
-----END PGP SIGNATURE-----

--VEUM44tNPQgAcisC--

