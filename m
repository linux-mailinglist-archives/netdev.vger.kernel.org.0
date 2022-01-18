Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477B54930A9
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 23:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349434AbiARWZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 17:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344326AbiARWZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 17:25:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C6FC061574;
        Tue, 18 Jan 2022 14:25:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD79CB816E1;
        Tue, 18 Jan 2022 22:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9470C340E0;
        Tue, 18 Jan 2022 22:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642544712;
        bh=j2Cd01/viTSrQHKzCHQBOhnDALAM9LtuZADlpFGNZwA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FrKlOGRB1lsMHlr6tLY1NYail73Emo9Or1qOgiUvtQpIM7Fl0UVf9EgatR/HyQd2C
         JbpBzbYyU4Tajo4Qbqc+g28J15c0Mvg81gHOCoNSeiEGh3sx9ZnEVvX4McIdYnqlPO
         LN14F2jk9Wds+RU7A3MnjOihtqEmnSzeL+te7M3aznBpb3SvbveqW2rQyXW/DH+cTP
         ImtOWdzx+qEc546uY9ChGBqTiJZWHTynbwU3ptUbGMjnojQ4A93b/ZlIsunLxr7ag6
         2BemWUIPBfAmwsXO8lchfOjFgcF/m+TlFzCmgOkyXqMoJA1lVWM83/52kSKXKmvvZT
         FUSN6zkuGB4LQ==
Date:   Tue, 18 Jan 2022 23:25:08 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v22 bpf-next 12/23] bpf: add multi-frags support to the
 bpf_xdp_adjust_tail() API
Message-ID: <Yec+REpSiOLthoVx@lore-desk>
References: <cover.1642439548.git.lorenzo@kernel.org>
 <087fe9459f451a2dfed4054b693251029f57f848.1642439548.git.lorenzo@kernel.org>
 <20220118202041.uk6ann4w366v4xlf@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bDQQm4SYwOlekJcN"
Content-Disposition: inline
In-Reply-To: <20220118202041.uk6ann4w366v4xlf@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bDQQm4SYwOlekJcN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Jan 17, 2022 at 06:28:24PM +0100, Lorenzo Bianconi wrote:
> >  BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
> >  {
> >  	void *data_hard_end =3D xdp_data_hard_end(xdp); /* use xdp->frame_sz =
*/
> >  	void *data_end =3D xdp->data_end + offset;
> > =20
> > +	if (unlikely(xdp_buff_has_frags(xdp))) { /* xdp multi-frags */
> > +		if (offset < 0)
> > +			return bpf_xdp_multi_frags_shrink_tail(xdp, -offset);
> > +
> > +		return bpf_xdp_multi_frags_increase_tail(xdp, offset);
> > +	}
>=20
> "multi frags" isn't quite correct here and in other places.
> It sounds like watery water.
> Saying "xdp frags" is enough to explain that xdp has fragments.
> Either multiple fragments or just one fragment doesn't matter.
> I think it would be cleaner to drop "multi".

ack, I will fix it.

Regards,
Lorenzo

--bDQQm4SYwOlekJcN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYec+RAAKCRA6cBh0uS2t
rNRjAQDtnYOYVj/eUH2xIuD7ULC5svpH2gLsqPzc57CgQKZHkAEA9gU4DJzx95Fe
8vXBVF5gnWo5Q74ymGm2+FXq2cIAPgY=
=q1k9
-----END PGP SIGNATURE-----

--bDQQm4SYwOlekJcN--
