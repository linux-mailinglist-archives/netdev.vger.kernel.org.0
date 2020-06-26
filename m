Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C15220ADA3
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 09:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbgFZH7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 03:59:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728947AbgFZH7M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 03:59:12 -0400
Received: from localhost (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75F2820768;
        Fri, 26 Jun 2020 07:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593158351;
        bh=TgRD4P4RFbz/zY6B2X9PvySeBPPBmsZKpTlotxkspNY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=le7LvK+U8QDSrALvJfyl4pwUfhJKocfeK4hX5RODIWRPSou7Ofldq3LkC/GmnDmSg
         Ni7SWog+KotUTPCiFqsUI2sOXK9q/A0nhaF+B1Eq25kCsGSe9qYK5MXs803tjBOw1d
         2DaLtdNVsZQTliqaMsTtLDf23PDJWKHaNNDo3oeU=
Date:   Fri, 26 Jun 2020 09:59:06 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, brouer@redhat.com, toke@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        andrii.nakryiko@gmail.com
Subject: Re: [PATCH v4 bpf-next 6/9] bpf: cpumap: implement XDP_REDIRECT for
 eBPF programs attached to map entries
Message-ID: <20200626075906.GA2206@localhost.localdomain>
References: <cover.1593012598.git.lorenzo@kernel.org>
 <ef1a456ba3b76a61b7dc6302974f248a21d906dd.1593012598.git.lorenzo@kernel.org>
 <01248413-7675-d35e-323e-7d2e69128b45@iogearbox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <01248413-7675-d35e-323e-7d2e69128b45@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 6/24/20 5:33 PM, Lorenzo Bianconi wrote:

[...]

> > +	if (stats->redirect)
> > +		xdp_do_flush_map();
> > +
> > +	rcu_read_unlock_bh(); /* resched point, may call do_softirq() */
> >   	xdp_clear_return_frame_no_direct();
>=20
> Hm, this looks incorrect. Why do you call the xdp_clear_return_frame_no_d=
irect() /after/
> the possibility where there is a rescheduling point for softirq?

Hi Daniel,

yes, right. Thx for spotting this, I will fix in v5.

Regards,
Lorenzo

>=20
> >   	return nframes;
> >=20
>=20

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXvWqxwAKCRA6cBh0uS2t
rKegAQD+YLojj4YDzE52McPy74ZSmTh3ux16LEeLDu5BWfADlQD8C/rJJmCszT6S
SJ/WWNPVIVmQpfYZp4uT4e+gzycDuQg=
=Wh3y
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
