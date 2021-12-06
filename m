Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D7346A652
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 20:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349498AbhLFUA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 15:00:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24812 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349578AbhLFUAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 15:00:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638820635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sL3D1WB/9Yy1suI5mATprV109LO2M6XsXaqz/s17rxU=;
        b=YWQJ5HnLMVp09qvaO23/P7ZkJwdEELZHKy+MxKpn3+kQU9S2Yxk5zwUqCqpTuBOdo8aGgk
        5zZl5+g4LFs/dirn+pkIW/bCJvtgj+sCN8359wkGxM1FZV0UwnWMXMsvwneWfIfCZxqcAK
        BLDbZlNYbYecsTisMUah3D5dzRLUfIk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-q1KtDApbMEaJ2_vaHQK_zg-1; Mon, 06 Dec 2021 14:57:12 -0500
X-MC-Unique: q1KtDApbMEaJ2_vaHQK_zg-1
Received: by mail-wm1-f72.google.com with SMTP id l6-20020a05600c4f0600b0033321934a39so373763wmq.9
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 11:57:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sL3D1WB/9Yy1suI5mATprV109LO2M6XsXaqz/s17rxU=;
        b=L0ZYQLzhsgALO+CNnrukV7SrY+Z3Vd8mQWOd5RbXjsFhphKftw86hPbH2hCkHOSQ9u
         cdPK8rRgSSfnMppBI90vlrUsGKPgDFGBrSvgji8o4+VxCMGqeaZmiTuqEYEtaX7LUxiy
         COoaJ3JainYnpPUpx+MHWRw+d1sfiV/pmDZpz9soF79yhsLmF/cQYd42RhG1msvwuxAH
         JkT89ImTH1lF14M0f5/Nk3w07dyN+joTLawqMVl3A1Pbf4mDLCw+mZQbh4R1uV57gi6g
         LjyyyS+pOMsVGrRBb74yKqOUbnZ/jTTRPCqV2R04D94j3KbF6BQ45Ex9rCoJgDM95bwQ
         5mqg==
X-Gm-Message-State: AOAM5317ix5U7JASPVpPw2jXlGKNtwzCoizXs7kZD9mIMU0PJz5a/5QR
        OJz6BDX2eIGJkZYY1xIrUmdZngcn9a+FCJ/7QD/V/0Qv3EfRe9lzhOE+7a3fAX2UQl2rdeWZJsv
        /B84/weaeE0grWV67
X-Received: by 2002:a1c:488:: with SMTP id 130mr815237wme.157.1638820631212;
        Mon, 06 Dec 2021 11:57:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwwkVvGKJSs8kSbzJ5A4iK/zDTE+kdNiGmq8OfxslW/COEIFNXrj8aZjVD96TzfbqVMixCWwQ==
X-Received: by 2002:a1c:488:: with SMTP id 130mr815183wme.157.1638820630882;
        Mon, 06 Dec 2021 11:57:10 -0800 (PST)
Received: from localhost (net-37-182-17-175.cust.vodafonedsl.it. [37.182.17.175])
        by smtp.gmail.com with ESMTPSA id e8sm12038083wrr.26.2021.12.06.11.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 11:57:10 -0800 (PST)
Date:   Mon, 6 Dec 2021 20:57:08 +0100
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
Message-ID: <Ya5rFFqzXy5adxbs@lore-desk>
References: <cover.1638272238.git.lorenzo@kernel.org>
 <81319e52462c07361dbf99b9ec1748b41cdcf9fa.1638272238.git.lorenzo@kernel.org>
 <61ad94bde1ea6_50c22081e@john.notmuch>
 <Ya4nI6DKPmGOpfMf@lore-desk>
 <61ae458a58d73_88182082b@john.notmuch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hOQqi1YYOcr53TRN"
Content-Disposition: inline
In-Reply-To: <61ae458a58d73_88182082b@john.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hOQqi1YYOcr53TRN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi wrote:
> > > Lorenzo Bianconi wrote:
> > > > From: Eelco Chaudron <echaudro@redhat.com>
> > > >=20
> > > > This change adds support for tail growing and shrinking for XDP mul=
ti-buff.
> > > >=20
> > > > When called on a multi-buffer packet with a grow request, it will w=
ork
> > > > on the last fragment of the packet. So the maximum grow size is the
> > > > last fragments tailroom, i.e. no new buffer will be allocated.
> > > > A XDP mb capable driver is expected to set frag_size in xdp_rxq_inf=
o data
> > > > structure to notify the XDP core the fragment size. frag_size set t=
o 0 is
> > > > interpreted by the XDP core as tail growing is not allowed.
> > > > Introduce __xdp_rxq_info_reg utility routine to initialize frag_siz=
e field.
> > > >=20
> > > > When shrinking, it will work from the last fragment, all the way do=
wn to
> > > > the base buffer depending on the shrinking size. It's important to =
mention
> > > > that once you shrink down the fragment(s) are freed, so you can not=
 grow
> > > > again to the original size.
> > > >=20
> > > > Acked-by: Jakub Kicinski <kuba@kernel.org>
> > > > Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> > > > ---
>=20
> [...]
>=20
> pasting full function here to help following along.
>=20
> +
> +static int bpf_xdp_mb_shrink_tail(struct xdp_buff *xdp, int offset)
> +{
> +	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
> +	int i, n_frags_free =3D 0, len_free =3D 0;
> +
> +	if (unlikely(offset > (int)xdp_get_buff_len(xdp) - ETH_HLEN))
> +		return -EINVAL;
> +
> +	for (i =3D sinfo->nr_frags - 1; i >=3D 0 && offset > 0; i--) {
> +		skb_frag_t *frag =3D &sinfo->frags[i];
> +		int size =3D skb_frag_size(frag);
> +		int shrink =3D min_t(int, offset, size);
> +
> +		len_free +=3D shrink;
> +		offset -=3D shrink;
> +
> +		if (unlikely(size =3D=3D shrink)) {
> +			struct page *page =3D skb_frag_page(frag);
> +
> +			__xdp_return(page_address(page), &xdp->rxq->mem,
> +				     false, NULL);
> +			n_frags_free++;
> +		} else {
> +			skb_frag_size_set(frag, size - shrink);
> +			break;
> +		}
> +	}
> +	sinfo->nr_frags -=3D n_frags_free;
> +	sinfo->xdp_frags_size -=3D len_free;
> +
> +	if (unlikely(offset > 0)) {
> +		xdp_buff_clear_mb(xdp);
> +		xdp->data_end -=3D offset;
> +	}
> +
> +	return 0;
> +}
> +
>=20
> > >=20
> > > hmm whats the case for offset to !=3D 0? Seems with initial unlikely
> > > check and shrinking while walking backwards through the frags it
> > > should be zero? Maybe a comment would help?
> >=20
> > Looking at the code, offset can be > 0 here whenever we reduce the mb f=
rame to
> > a legacy frame (so whenever offset will move the boundary into the line=
ar
> > area).
>=20
> But still missing if we need to clear the mb bit or not when we shrink do=
wn
> to a single frag. I think its fine, but worth double checking. As an exam=
ple
> consider I shrink 2k from a 3k pkt with two frags, one full 2k and another
> 1k extra,
>=20
> On the first run through,
>=20
>  i =3D 1;
>  offset =3D 2k
>=20
> +	for (i =3D sinfo->nr_frags - 1; i >=3D 0 && offset > 0; i--) {
> +		skb_frag_t *frag =3D &sinfo->frags[i];
> +		int size =3D skb_frag_size(frag);
> +		int shrink =3D min_t(int, offset, size);
>=20
> shrink =3D 1k; // min_t(int, offset, size) -> size
>=20
> +
> +		len_free +=3D shrink;
> +		offset -=3D shrink;
>=20
> offset =3D 1k
>=20
> +		if (unlikely(size =3D=3D shrink)) {
> +			struct page *page =3D skb_frag_page(frag);
> +
> +			__xdp_return(page_address(page), &xdp->rxq->mem,
> +				     false, NULL);
> +			n_frags_free++;
>=20
> Will free the frag
>=20
> Then next run through
>=20
> i =3D 0;
> offset =3D 1k;
>=20
> +		skb_frag_t *frag =3D &sinfo->frags[i];
> +		int size =3D skb_frag_size(frag);
> +		int shrink =3D min_t(int, offset, size);
>=20
> shrink =3D 1k; // min_t(int, offset, size) -> offset
>=20
> +
> +		len_free +=3D shrink;
> +		offset -=3D shrink;
>=20
> offset =3D 0k
>=20
> +
> +		if (unlikely(size =3D=3D shrink)) { ...
> +		} else {
> +			skb_frag_size_set(frag, size - shrink);
> +			break;
> +		}
>=20
> Then later there is the check 'if (unlikely(offset > 0) { ...}', but that
> wont hit this case and we shrunk it back to a single frag. Did we want
> to clear the mb in this case? I'm not seeing how it harms things to have
> the mb bit set just trying to follow code here.

If I followed correctly your example, we will have sinfo->nr_frags =3D 1 at=
 the
end of the processing (since the first fragment has 2k size), right?
If so mb bit must be set to 1. Am I missing something?
Re-looking at the code I guess we should clear mb bit using sinfo->nr_frags
instead:

	if (!sinfo->nr_frags)
		xdp_buff_clear_mb(xdp);

Agree?

Regards,
Lorenzo

>=20
> Would offset > 0 indicate we weren't able to shrink the xdp buff enough
> for some reason. Need some coffee perhaps.
>=20
> Thanks,
> John
>=20

--hOQqi1YYOcr53TRN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYa5rFAAKCRA6cBh0uS2t
rAPmAQCw3qlOwQ4AECWUfuNGM+s/hDHQ3e5wt0RqbLpfSR9ThgD/XLRSBEG/jDXs
05b1gtNYMwXk/OSCJM7ZmvEwRbVp6Q8=
=bbI4
-----END PGP SIGNATURE-----

--hOQqi1YYOcr53TRN--

