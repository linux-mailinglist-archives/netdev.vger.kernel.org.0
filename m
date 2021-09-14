Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE95440BC4B
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 01:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235854AbhINXj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 19:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235724AbhINXj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 19:39:28 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19222C061574;
        Tue, 14 Sep 2021 16:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1631662686;
        bh=alohV9o9u2R335EYwz1AS38KPO3EM5BzTbTyYcFJYTM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vG/qOAMiCPWEVZSXcmU1D4qWCXRxCB7VzLXbA8B2rcho+hcFf5eKhObbE0lzJ5vZz
         j58eZN1JkW64NjXQIbQgCgm8oR3gYxISuPy3T7sFWZZBEoC+rPJ7cY9v/4KNct1e33
         cVRI9Z9ZTlAxTOt9Ew3QWKGIzVtuZ/daO1qqCn0dJnGsMo/x+8LGYEu4PBoImmf1TO
         dEd30d8YLQMPqQmjEfQjFz5DxvZ9BePSLC4j0aOf6xjO3HAUW0HnP5KNvY6d5rHzNr
         0COnX2BIdvMjc+QYgHmRRKFOTImT1LlkMk+pWB9vv4HLhoQZ6DklTo3I0tF3yHgdXq
         xeXV6d/SyZ0SQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4H8KXZ2zfGz9sVq;
        Wed, 15 Sep 2021 09:38:06 +1000 (AEST)
Date:   Wed, 15 Sep 2021 09:38:02 +1000
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
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20210915093802.02303754@canb.auug.org.au>
In-Reply-To: <CAEf4BzYt4XnHr=zxAEeA2=xF_LCNs_eqneO1R6j8=PMTBo5Z5w@mail.gmail.com>
References: <20210914113730.74623156@canb.auug.org.au>
        <CAEf4BzYt4XnHr=zxAEeA2=xF_LCNs_eqneO1R6j8=PMTBo5Z5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/X.7P.+6.LF08bL+0_fN_qU+";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/X.7P.+6.LF08bL+0_fN_qU+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrii,

On Tue, 14 Sep 2021 16:25:55 -0700 Andrii Nakryiko <andrii.nakryiko@gmail.c=
om> wrote:
>
> On Mon, Sep 13, 2021 at 6:37 PM Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
> >
> > After merging the bpf-next tree, today's linux-next build (perf) failed
> > like this:
> >
> > util/bpf-event.c: In function 'btf__load_from_kernel_by_id':
> > util/bpf-event.c:27:8: error: 'btf__get_from_id' is deprecated: libbpf =
v0.6+: use btf__load_from_kernel_by_id instead [-Werror=3Ddeprecated-declar=
ations]
> >    27 |        int err =3D btf__get_from_id(id, &btf);
> >       |        ^~~
> > In file included from util/bpf-event.c:5:
> > /home/sfr/next/next/tools/lib/bpf/btf.h:54:16: note: declared here
> >    54 | LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
> >       |                ^~~~~~~~~~~~~~~~
> > cc1: all warnings being treated as errors
> >
> > Caused by commit
> >
> >   0b46b7550560 ("libbpf: Add LIBBPF_DEPRECATED_SINCE macro for scheduli=
ng API deprecations") =20
>=20
> Should be fixed by [0], when applied to perf tree. Thanks for reporting!
>=20
>   [0] https://patchwork.kernel.org/project/netdevbpf/patch/20210914170004=
.4185659-1-andrii@kernel.org/

That really needs to be applied to the bpf-next tree (presumably with
the appropriate Acks).

--=20
Cheers,
Stephen Rothwell

--Sig_/X.7P.+6.LF08bL+0_fN_qU+
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFBMlsACgkQAVBC80lX
0Gw38gf9H4etVyKQCLG/Wm70Fp8R5CwfKdBvj2swfyre0OujinSgRVnEKWzaPb10
m6XSGL95zoYXcoeVBiG5WyxlL2PH1EYfO2BR+UhdnfPXH1hCx5up/s/5XCj/jPqe
EIBUA2ETHcljl6N4U4Z7O6EXJxYVEYURepFuopGgTzbEQIhqAw71ET8BFgiJGrP0
tY+7goqm8ikcl4nWSo3tISw5tyhOFO0vfkSNpBVCrk1cvf2HsiLwrZIE2N9ITCxS
t/aVBVb3/0BGECZKTZts8DPrJ6LWqMviZI1ulV6MQisK2uRPzaQfQiLhh+ny1PdN
LGEEamXajPmXBHhvdnlLHEs4vh6FPA==
=2WDc
-----END PGP SIGNATURE-----

--Sig_/X.7P.+6.LF08bL+0_fN_qU+--
