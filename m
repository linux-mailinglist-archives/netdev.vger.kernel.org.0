Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23498250FD1
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 05:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgHYDE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 23:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728175AbgHYDEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 23:04:53 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A30DC061574;
        Mon, 24 Aug 2020 20:04:53 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BbDPF10T7z9sTK;
        Tue, 25 Aug 2020 13:04:49 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1598324690;
        bh=lhIqz0KHpNDTmGHLdzVh8OUSERGOE3vTU7qYSXb9H0M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ogCUT23ikQY9/IXgkqJbt/3Rzwz16zo2Akhi97eCg3F2rcU+onlZe5f8jjuVFNJWl
         yYtfcQmsJgFlecHghQNn1zrK4QZ1zzO2E+JqlZHIWzoUuatU/p1CzF8hWkfPwLPwYS
         DlSDjpD/mkyKMsaxwfGQl1II8wYFNMri1E6L/IqB2YNWCfpXNTi4Kiv5uC2duCQW/X
         CqpRfE7VTREB72C4ZpIeefE+uS56yQF2PSzrIS408WCyM9dZv09f/wBSUWrj9gflnd
         YKevMVcbSwyj6QnF3qm8BjtE3kGtx4323R5D+vfbk5YDDB2wfiZP9iDCgQWn2ZPGp+
         zJ5XBZdrBQs2g==
Date:   Tue, 25 Aug 2020 13:04:45 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20200825130445.655885f8@canb.auug.org.au>
In-Reply-To: <CAADnVQLr8dU799ZrUnrBBDCtDxPyybZwrMFs5CAOHHW5pnLHHA@mail.gmail.com>
References: <20200821111111.6c04acd6@canb.auug.org.au>
        <20200825112020.43ce26bb@canb.auug.org.au>
        <CAADnVQLr8dU799ZrUnrBBDCtDxPyybZwrMFs5CAOHHW5pnLHHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/UdHhr.Z1_ueRZo/AaeqreTx";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/UdHhr.Z1_ueRZo/AaeqreTx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Alexei,

On Mon, 24 Aug 2020 18:25:44 -0700 Alexei Starovoitov <alexei.starovoitov@g=
mail.com> wrote:
>
> On Mon, Aug 24, 2020 at 6:20 PM Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
> >
> > On Fri, 21 Aug 2020 11:11:11 +1000 Stephen Rothwell <sfr@canb.auug.org.=
au> wrote: =20
> > >
> > > After merging the bpf-next tree, today's linux-next build (x86_64
> > > allmodconfig) failed like this:
> > >
> > > Auto-detecting system features:
> > > ...                        libelf: [  [31mOFF [m ]
> > > ...                          zlib: [  [31mOFF [m ]
> > > ...                           bpf: [  [32mon [m  ]
> > >
> > > No libelf found
> > > make[5]: *** [Makefile:284: elfdep] Error 1
> > >
> > > Caused by commit
> > >
> > >   d71fa5c9763c ("bpf: Add kernel module with user mode driver that po=
pulates bpffs.")
> > >
> > > [For a start, can we please *not* add this verbose feature detection
> > > output to the nrormal build?]
> > >
> > > This is a PowerPC hosted cross build.
> > >
> > > I have marked BPF_PRELOAD as BROKEN for now. =20
> >
> > Still getting this failure ... =20
>=20
> I don't have powerpc with crosscompiler to x86 to reproduce.
> What exactly the error?

Just as above.

> bpf_preload has:
> "depends on CC_CAN_LINK"
> which is exactly the same as bpfilter.
> You should have seen this issue with bpfilter for years now.

Well, I haven't :-)  It just started the other day when that commit
appeared.

--=20
Cheers,
Stephen Rothwell

--Sig_/UdHhr.Z1_ueRZo/AaeqreTx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9Ef80ACgkQAVBC80lX
0GztqQgAnLGgzIRqWxxHypLlA/LvG2w9edly23uy0BJN03RXPa3Cvpew2ncoHwfs
MVduYmtGBYedqewae9ZmSVtuRqh73ANCoit0FahXeEbj4Cwi4rw5RIaGP/Qsojbb
c2xFtgRRDVzeEsyS7ZQo9t+UF7s6DNkkO/pMeLViDDujGspbJQiNeBH9bBoAH48Y
evzfAso+xprMeAdn/EPe46g2C2SyS8b+PDIUVpOqZo4bosBmZs39B4XhLm5OXXi3
p/D2H4uxaaHkm4BBBKgU0Za1SgwElOFfy8+ckGB78fuBe9ZndFsmyl4TH1MAkhGv
FChh4XLX8Lp0gIso/bf1HauoK7fUUA==
=sTUQ
-----END PGP SIGNATURE-----

--Sig_/UdHhr.Z1_ueRZo/AaeqreTx--
