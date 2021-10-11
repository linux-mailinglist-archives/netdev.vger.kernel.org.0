Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD474296F9
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 20:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhJKShd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 14:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229824AbhJKShc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 14:37:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E97460E08;
        Mon, 11 Oct 2021 18:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633977332;
        bh=YMTwEFlCrUNpTRcI3iiQX/0GSAFWkaZK37U8NGLlP2o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mVbOT7m9lLE0hYZ/CItGzawBgHGj9XciRjWJBsePZ5vxAlj5GwvZZbiVihxusxkew
         m41ROl0D0EDj15eKhKR27hN+9nbylODGKrDQR5HfKlNYXGidxaBFYEMOiJIlWvwf7A
         nZpGgb6I46lo6U/jOihCIO4BM+gZFt0AK8xwNxdrRh4jjpzr++FtXuTkZIHsNDLOlr
         H386levTsCeg+LwckEtl39TeyJeALy1WXk/AAsbW5GU9QSR/tpi0TbKFawaHB8R1fQ
         CNDF/uJuuF/3tLx8iC0St+qRKHofdpsrQaE10UA/ldXpELP9BWIPKAiV3vo3joIRk2
         GfNSbMtfxSooA==
Date:   Mon, 11 Oct 2021 20:35:28 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v15 bpf-next 17/18] net: xdp: introduce bpf_xdp_pointer
 utility routine
Message-ID: <YWSD8O0lw6kaGmRD@lore-desk>
References: <cover.1633697183.git.lorenzo@kernel.org>
 <911989270cd187c98a65edabc709eb1f49af3e51.1633697183.git.lorenzo@kernel.org>
 <20211008181026.0b94149a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="T3ayD93ZkuGJg3r3"
Content-Disposition: inline
In-Reply-To: <20211008181026.0b94149a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--T3ayD93ZkuGJg3r3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri,  8 Oct 2021 14:49:55 +0200 Lorenzo Bianconi wrote:
> > +BPF_CALL_4(bpf_xdp_load_bytes, struct xdp_buff *, xdp, u32, offset,
> > +	   void *, buf, u32, len)
> > +{
> > +	void *ptr;
> > +
> > +	if (!buf)
> > +		return -EINVAL;
>=20
> Can we make the verifier ensure it's not NULL?

I guess we can use ARG_PTR_TO_MEM instead of ARG_PTR_TO_UNINIT_MEM

>=20
> > +	ptr =3D bpf_xdp_pointer(xdp, offset, len, buf);
> > +	if (ptr !=3D buf)
> > +		memcpy(buf, ptr, len);
>=20
> Don't we need to return an error in case offset + length > frame size?

ack, I will fix it.

Regards,
Lorenzo

>=20
> > +	return 0;
> > +}

--T3ayD93ZkuGJg3r3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYWSD8AAKCRA6cBh0uS2t
rMoMAQDKA3csqlagWkSvIpWkjI761ZxSdY23pPLAgmd1Cg+YWQD7BHjofly3foMh
mMwyM6OyW//kP3zjWmoVx0BZ6vrzPwE=
=gm8X
-----END PGP SIGNATURE-----

--T3ayD93ZkuGJg3r3--
