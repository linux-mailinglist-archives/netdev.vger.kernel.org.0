Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F9B40BC6C
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 01:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236104AbhIOABF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 20:01:05 -0400
Received: from ozlabs.org ([203.11.71.1]:60299 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233774AbhIOABE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 20:01:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1631663984;
        bh=R9Y73i6jxJulHJI7ZuddoZPKGKLu47+OjNkBe64unGw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UMp1lQHVrAZr3GTivd0VgUpE0PkfzOm/tGDhMkisA92G3/zBNbfxLIAyDIMzYIPlx
         H4Ndqu2HnecgTZ3xsulKpslFONtGKL0O5z3eITQ61HyjlVKrMaq02Djj8SXttlMp5k
         vl60/fCcqePwnPd/jsAaos6tjOi5fUivUZiQelM5i+lAZ7aVMRGXmRUQ2+wKmUPtNn
         NOTlO93TjJAQB+x6Y+yetobM6Poc8jYo+sw/Tep5M1G+Rdl553yUQ4miqLyCtWZAUG
         Uthylv1MmE7N1Y/S/OH0iqjc8y1I/v3FwMv7JqPdRpoxFMqLEq0ysLHHBkbtYGFIi2
         +uMUez5B9ihFA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4H8L1W17kcz9sRK;
        Wed, 15 Sep 2021 09:59:43 +1000 (AEST)
Date:   Wed, 15 Sep 2021 09:59:42 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20210915095942.3f8c2dcc@canb.auug.org.au>
In-Reply-To: <CAEf4BzZ7LKNZ8w8=6PGTUxfp2ea_HOBJL=dZocdsyWjKqZ2LhQ@mail.gmail.com>
References: <20210914113730.74623156@canb.auug.org.au>
        <CAEf4BzYt4XnHr=zxAEeA2=xF_LCNs_eqneO1R6j8=PMTBo5Z5w@mail.gmail.com>
        <20210915093802.02303754@canb.auug.org.au>
        <CAEf4BzZ7LKNZ8w8=6PGTUxfp2ea_HOBJL=dZocdsyWjKqZ2LhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/8ZM1p4qNwCn2_DxiOBc19s1";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/8ZM1p4qNwCn2_DxiOBc19s1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrii,

On Tue, 14 Sep 2021 16:40:37 -0700 Andrii Nakryiko <andrii.nakryiko@gmail.c=
om> wrote:
>
> On Tue, Sep 14, 2021 at 4:38 PM Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
> >
> > Hi Andrii,
> >
> > On Tue, 14 Sep 2021 16:25:55 -0700 Andrii Nakryiko <andrii.nakryiko@gma=
il.com> wrote: =20
> > >
> > > On Mon, Sep 13, 2021 at 6:37 PM Stephen Rothwell <sfr@canb.auug.org.a=
u> wrote: =20
> > > >
> > > > After merging the bpf-next tree, today's linux-next build (perf) fa=
iled
> > > > like this:
> > > >
> > > > util/bpf-event.c: In function 'btf__load_from_kernel_by_id':
> > > > util/bpf-event.c:27:8: error: 'btf__get_from_id' is deprecated: lib=
bpf v0.6+: use btf__load_from_kernel_by_id instead [-Werror=3Ddeprecated-de=
clarations]
> > > >    27 |        int err =3D btf__get_from_id(id, &btf);
> > > >       |        ^~~
> > > > In file included from util/bpf-event.c:5:
> > > > /home/sfr/next/next/tools/lib/bpf/btf.h:54:16: note: declared here
> > > >    54 | LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
> > > >       |                ^~~~~~~~~~~~~~~~
> > > > cc1: all warnings being treated as errors
> > > >
> > > > Caused by commit
> > > >
> > > >   0b46b7550560 ("libbpf: Add LIBBPF_DEPRECATED_SINCE macro for sche=
duling API deprecations") =20
> > >
> > > Should be fixed by [0], when applied to perf tree. Thanks for reporti=
ng!
> > >
> > >   [0] https://patchwork.kernel.org/project/netdevbpf/patch/2021091417=
0004.4185659-1-andrii@kernel.org/ =20
> >
> > That really needs to be applied to the bpf-next tree (presumably with
> > the appropriate Acks).
> > =20
>=20
> This is perf code that's not in bpf-next yet.

Then you need to think of a solution for the bpf-next tree, as it will
not build (allmodconfig) when combined with Linus' current tree.  And
when it is merged into the net-next tree, that tree will be broken as
well.

--=20
Cheers,
Stephen Rothwell

--Sig_/8ZM1p4qNwCn2_DxiOBc19s1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFBN24ACgkQAVBC80lX
0Gw2fwf/fIp66HvUvmbnMDSenQDfaiVIoTTXBoLnsj2dmT7isSHBFoy7lGkvG6IC
Q3RluBKeTvd0Sbpi3P94ey557e22YI7QX6tTZDmHrSgEp0uWv9liWjp6JH0tdSUG
UR/CQ9AEyORNyIsrHhKX66JqKTgWB3kqAA6GD0k/GsK/rHH7OS8kzhUPHR8DWCoz
g+6DMljrjcoNVwWamW2f4klXKqCMWuR1mONsPGs/l/RUUCNkaBP8lGWL6Sa7lo3T
lXxbppvs+njjnAy40J0V4kJKCaA0HJd7A6PiQiOcyLrqSvpp6KapfMsEovFmPggj
BWftA9T4IaBPqX6BAWTq0HafCahLDQ==
=pxlX
-----END PGP SIGNATURE-----

--Sig_/8ZM1p4qNwCn2_DxiOBc19s1--
