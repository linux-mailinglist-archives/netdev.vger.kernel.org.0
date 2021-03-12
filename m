Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54AB3382FB
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 02:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhCLBAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 20:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhCLBAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 20:00:22 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92B3C061574;
        Thu, 11 Mar 2021 17:00:21 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DxSCh5CFBz9sS8;
        Fri, 12 Mar 2021 12:00:16 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1615510818;
        bh=K1mjmvJnS0hdZYQYBLWAyCAHxLXVq2cl3kLuR2P/fHE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D9tyytCzbB72I+MrDKkJVPCxJS3YA4GRg5oY6AYCpNJeA6W0bJ0w5+YAuTQW5dwMH
         1k3KoYxKweh2HOvyH2/3eBh9ujDV/1/+JLkqLgHOpNqnLcd1nwbj3pl3RnRX8yqB2s
         n0vZAxymBBK+w1U2yGONB02viRFiPvN54f4xS+8iRn3zOKi9/68B9rkHsX/Ivk4kyO
         06pwB2HGlCUODtYSX3i3g60l1pkRzZC+CEPnQBEW2dC8MIRRRSqOG3zlVoDXZpKOJP
         wbTcNKY8F8ofe3a70nT0zjmEm4gVQC23QpgtVB3JE0q5x68drFhQ41EvC2nty6zNjl
         qGrce/aZYl3rA==
Date:   Fri, 12 Mar 2021 12:00:14 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20210312120014.62ced6dd@canb.auug.org.au>
In-Reply-To: <bad04c3d-c80e-16c1-0f5a-4d4556555a81@intel.com>
References: <20210311114723.352e12f8@canb.auug.org.au>
        <bad04c3d-c80e-16c1-0f5a-4d4556555a81@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/t=a52UBf41bT3PeQ019YY2H";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/t=a52UBf41bT3PeQ019YY2H
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Bj=C3=B6rn,

[Cc'ing a few (maybe) interested parties]

On Thu, 11 Mar 2021 07:47:03 +0100 Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel=
.com> wrote:
>
> On 2021-03-11 01:47, Stephen Rothwell wrote:
> >=20
> > After merging the bpf-next tree, today's linux-next build (perf) failed
> > like this:
> >=20
> > make[3]: *** No rule to make target 'libbpf_util.h', needed by '/home/s=
fr/next/perf/staticobjs/xsk.o'.  Stop.
>=20
> It's an incremental build issue, as pointed out here [1], that is
> resolved by cleaning the build.

Does this mean there is a deficiency in the dependencies in our build syste=
m?

> [1] https://lore.kernel.org/bpf/CAEf4BzYPDF87At4=3D_gsndxof84OiqyJxgAHL7_=
jvpuntovUQ8w@mail.gmail.com/
>=20
> > Caused by commit
> >=20
> >    7e8bbe24cb8b ("libbpf: xsk: Move barriers from libbpf_util.h to xsk.=
h")
> >=20
> > I have used the bpf tree from next-20210310 for today.

I have set my system to remove the object directory before building
after merging the bpf-next tree for now.

--=20
Cheers,
Stephen Rothwell

--Sig_/t=a52UBf41bT3PeQ019YY2H
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBKvR4ACgkQAVBC80lX
0Gw3IggApbt1eN7iGnvSh74cALvXoRNEnZoycNxv73WF4O98GYRQlQsi73lCmdx8
xwEkwWXEqDAs/eYyVOdP47m7rnVT0uS+pcYn9fypHZyJ9XS62ohBOLwCQqIhfQH7
oOlP7IOSL9ZdVCBSLW1ppNQV0QLek+LleIVDzLQn9733VYU2cC4eTBD53Nsiefz4
e1A6txZ0MfKitgdNg1UUFhlN1m9RnVRHPONdl3zjPq+XMq0BgBeM5xe+pMXhKAMA
TNOxm2BaEHPhVwv/DC3DqcRxncHUAJS4CsxUDSaEe0pJ33kAH0/jDFrt/qXOTw/X
84AOrV6lkIvgLf3PLs+eIBkBEc3OFw==
=P8+W
-----END PGP SIGNATURE-----

--Sig_/t=a52UBf41bT3PeQ019YY2H--
