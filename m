Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D2C20362A
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgFVLuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727952AbgFVLuM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 07:50:12 -0400
Received: from localhost (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78892206D7;
        Mon, 22 Jun 2020 11:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592826612;
        bh=ZH+00OZclsORf8w1jSz2YeR4TOIxjgPqi0ljLU4FRO0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d/1Ql+jckicAzmjC1XjxQcn4wp7jMqZWN4lBWxYQLmNhDbU7LFi107FITy1YmFvoM
         Xh6L7ZB/dSnsqYx2QEnECa/H3R47hSWvVQ3mH1s5/+numE/qfqSUeb5tgsMSwuoED6
         Bws7Q345ozIHu3YJR58x6j4by/mp1+14GWuinw/I=
Date:   Mon, 22 Jun 2020 13:50:07 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, toke@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org
Subject: Re: [PATCH v2 bpf-next 3/8] cpumap: formalize map value as a named
 struct
Message-ID: <20200622115007.GB14425@localhost.localdomain>
References: <cover.1592606391.git.lorenzo@kernel.org>
 <804b20c4f6fdda24f81e946c5c67c37c55d9f590.1592606391.git.lorenzo@kernel.org>
 <20200622113313.6f56244d@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JP+T4n/bALQSJXh8"
Content-Disposition: inline
In-Reply-To: <20200622113313.6f56244d@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sat, 20 Jun 2020 00:57:19 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > As it has been already done for devmap, introduce 'struct bpf_cpumap_va=
l'
> > to formalize the expected values that can be passed in for a CPUMAP.
> > Update cpumap code to use the struct.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  include/uapi/linux/bpf.h       |  9 +++++++++
> >  kernel/bpf/cpumap.c            | 25 +++++++++++++------------
> >  tools/include/uapi/linux/bpf.h |  9 +++++++++
> >  3 files changed, 31 insertions(+), 12 deletions(-)
> >=20
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 19684813faae..a45d61bc886e 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3774,6 +3774,15 @@ struct bpf_devmap_val {
> >  	} bpf_prog;
> >  };
> > =20
> > +/* CPUMAP map-value layout
> > + *
> > + * The struct data-layout of map-value is a configuration interface.
> > + * New members can only be added to the end of this structure.
> > + */
> > +struct bpf_cpumap_val {
> > +	__u32 qsize;	/* queue size */
> > +};
> > +
>=20
> Nitpicking the comment: /* queue size */
> It doesn't provide much information to the end-user.
>=20
> What about changing it to: /* queue size to remote target CPU */

Yes, I agree. I will fix it in v3.

Regards,
Lorenzo

> ?
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--JP+T4n/bALQSJXh8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXvCa7AAKCRA6cBh0uS2t
rCd1AP9onNtkqFasFYqxr5CQgKqke1VhKA84xUnqcvPlTizm2gD/Z8Lb0quCYSKl
UoRNWBvoXHrAYZXaeczMsEgwLdKhNgo=
=tMRP
-----END PGP SIGNATURE-----

--JP+T4n/bALQSJXh8--
