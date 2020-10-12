Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCB228C349
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 22:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbgJLUuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 16:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgJLUuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 16:50:22 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86F1C0613D0;
        Mon, 12 Oct 2020 13:50:21 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C99mT3wmGz9sSn;
        Tue, 13 Oct 2020 07:50:17 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1602535818;
        bh=YUhO3LaBBnxchR2B7Hh4aVMkJSvy8cXmxp+QLkuloM8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GbKdciGWDXoVsuUGJVKrod7kNRy5kw99IxLh/3mRLQKiQgcVL642MN87rxJD3FUJV
         3lyoGipdeHtqx9uI1Kl09NOD1NlA7+1TaXJJuUZikmIM/dJlAKtxensySEd3w6SYzO
         IdY8jT7cWB2uq/LwBJNGsfLf5SzLOJNeREebMqd53n8CyJUjEWBabNMvtjBRKfgIFl
         7JJksu1rZviSlnDjmJcire6PMULoSJqlssr3w1xbw3bVu/17Ne7+QZRjpbX7Ji78We
         1Uz5/xrP8bUe1lHXAdfIQaPK2XHE26MJ2DWa40CeOxk1aWgrPToQGDy0x1SDbmamRx
         v/sVSYq5/D3+Q==
Date:   Tue, 13 Oct 2020 07:50:16 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: merge window is open. bpf-next is still open.
Message-ID: <20201013075016.61028eee@canb.auug.org.au>
In-Reply-To: <CAADnVQKn=CxcOpjSWLsD+VC5rviC6sMfrhw5jrPCU60Bcx5Ssw@mail.gmail.com>
References: <CAADnVQ+ycd8T4nBcnAwr5FHX75_JhWmqdHzXEXwx5udBv8uwiQ@mail.gmail.com>
        <20201012110046.3b2c3c27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAADnVQKn=CxcOpjSWLsD+VC5rviC6sMfrhw5jrPCU60Bcx5Ssw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/WQYHjQDj8tSUW..gW_rk0cz";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/WQYHjQDj8tSUW..gW_rk0cz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Alexei,

On Mon, 12 Oct 2020 13:15:16 -0700 Alexei Starovoitov <alexei.starovoitov@g=
mail.com> wrote:
>
> You mean keep pushing into bpf-next/master ?
> The only reason is linux-next.
> But coming to think about it again, let's fix linux-next process instead.
>=20
> Stephen,
> could you switch linux-next to take from bpf.git during the merge window
> and then go back to bpf-next.git after the merge window?
> That will help everyone. CIs wouldn't need to flip flop.
> People will keep basing their features on bpf-next/master all the time, e=
tc.
> The only inconvenience is for linux-next. I think that's a reasonable tra=
de-off.
> In other words bpf-next/master will always be open for new features.
> After the merge window bpf-next/master will get rebased to rc1.

I already fetch bpf.git#master all the time (that is supposed to be
fixes for the current release and gets merged into the net tree, right?)

How about this: you create a for-next branch in the bpf-next tree and I
fetch that instead of your master branch.  What you do is always work
in your master branch and whenever it is "ready", you just merge master
into for-next and that is what linux-next works with (net-next still
merges your master branch as now).  So the for-next branch consists
only of consecutive merges of your master branch.

During the merge window you do *not* merge master into for-next (and,
in fact, everything in for-next should have been merged into the
net-next tree anyway, right?) and then when -rc1 is released, you reset
for-next to -rc1 and start merging master into it again.

This way the commit SHA1s are stable and I don't have to remember to
switch branches/trees every merge window (which I would forget
sometimes for sure :-)).
--=20
Cheers,
Stephen Rothwell

--Sig_/WQYHjQDj8tSUW..gW_rk0cz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl+EwYgACgkQAVBC80lX
0Gy/Qgf/cvvvkk2O3hpxESyVTDJEn7+6KERQumpV5ZJoxjjvIiV13MM/wDAHjwcd
jtkTi9EDRvTgz58NKWttLoWMKr+SjQS+Y3Jy4a1fOYuGxpD9UYGImyKIo3cVgIZ/
qXHcKzUT78uifnJWXrZMSqALZWbJNu8MXfEWfEl+81B6ZuYg7hlfO46ZELStxY8H
hqE7toqQlUy0sP3/x6EHm2sz+/mouy4PNt2ViCR/hloRnBVqWCW9N7PUna9KatLi
JH4psdGDNYGHBUsXDcXiwkMLBbUvIfJjkDiKuxQVt8OUDKvXsbH+zWVwZK44BxOh
eilB24Od+LdOcJPT+rZqS+QyGHeCxw==
=xj0d
-----END PGP SIGNATURE-----

--Sig_/WQYHjQDj8tSUW..gW_rk0cz--
