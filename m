Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E056842EAE3
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 10:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236479AbhJOIFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 04:05:41 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:34239 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236558AbhJOIF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 04:05:29 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HVzJl43Tbz4xbR;
        Fri, 15 Oct 2021 19:02:31 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1634284953;
        bh=R+Dew7oG0+VgNPPu/06EeBFFcsXthayhzgYMAdHZ8yY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bjo/oBH013fyfT8xHR8WLteHKX+PFwj0e8WjhoyWs+9NWZl2TmtyPUtvoPMK1OOL5
         x0dFkO/8rz77dJoUhe3g2CPTFknWggc/LnC03vP4iERz6kvi6Pv8tAujb7QVaO8x6v
         gbONLX9fJeq1sIM4JtXUZ54FAarOgjmtZN7FQWD3RreR5CMEA9N1pu84Wj52uiIXc8
         Cd9gGOvmxkr1KSA7ZNUXJE/zVJzuJwWuZUAfKGcLMXcKiPJhCgfzpiya6yNiGfN/nv
         3x2+K7Q2lqj2f5AgBvxWC4PQKRvWnQA8Pg8uzTQ0cdE2jOExTZVO86RXFc/drv5R6a
         fyqzAEZdEbmiw==
Date:   Fri, 15 Oct 2021 19:02:30 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the kspp-gustavo tree
Message-ID: <20211015190230.1ff7f7d2@canb.auug.org.au>
In-Reply-To: <20211015000752.GA1159064@embeddedor>
References: <20211015104840.4e1ceb89@canb.auug.org.au>
        <20211015000752.GA1159064@embeddedor>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/bHB84B5PchELJNiyS7Fr1Er";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/bHB84B5PchELJNiyS7Fr1Er
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Gustavo,

On Thu, 14 Oct 2021 19:07:52 -0500 "Gustavo A. R. Silva" <gustavoars@kernel=
.org> wrote:
>
> On Fri, Oct 15, 2021 at 10:48:40AM +1100, Stephen Rothwell wrote:
> >=20
> > After merging the kspp-gustavo tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > In file included from include/linux/bpf_verifier.h:9,
> >                  from kernel/bpf/verifier.c:12:
> > kernel/bpf/verifier.c: In function 'jit_subprogs':
> > include/linux/filter.h:366:4: error: cast between incompatible function=
 types from 'unsigned int (*)(const void *, const struct bpf_insn *)' to 'u=
64 (*)(u64,  u64,  u64,  u64,  u64)' {aka 'long long unsigned int (*)(long =
long unsigned int,  long long unsigned int,  long long unsigned int,  long =
long unsigned int,  long long unsigned int)'} [-Werror=3Dcast-function-type]
> >   366 |   ((u64 (*)(u64, u64, u64, u64, u64))(x)) =20
> [..]
> >=20
> >   21078041965e ("Makefile: Enable -Wcast-function-type")
> >=20
> > I have used the kspp-gustavo tree from next-20211013 for today. =20
>=20
> Please, merge my -next tree. All the warnings above are already fixed in
> bpf-next by commit:
>=20
> 	3d717fad5081 ("bpf: Replace "want address" users of BPF_CAST_CALL with B=
PF_CALL_IMM")
>=20
> So, once you merge bpf-next, those warnings will go away.

Well, I really prefer for trees in linux-next to have no dependencies
like this.  For one thing, you cannot test your tree as Linus will
because an allmodconfig build of your tree alone fails.  For another,
if Linus merges your tree before net-next (which will merge bpf-next
before the merge window), he will yell at you (and me) for breaking his
tree.  And in the general case, it could be possible that Linus will
decide to not merge the tree containing the fix (unlikely for the
net-next tree).

Also, the trees in linux-next are merged in whatever order I take a
fancy to (and sometimes I do move them around).  I could not have known
that there was a dependency between these 2 trees (well, actually I
could have if I could remember back to Sept 30 when I first reported
this :-( ) and (given that I merge over 350 trees) it would be a pain
to have to keep track (and keep moving trees around.

So it is a pity that 3d717fad5081 was not in a small branch that could
be merged into both trees.  You could, of course, also apply it to your
tree and we could put up with any resulting conflicts.

This discussion has been had before ... trees that Linus is asked to
merge should be fairly much standalone ...
--=20
Cheers,
Stephen Rothwell

--Sig_/bHB84B5PchELJNiyS7Fr1Er
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFpNZYACgkQAVBC80lX
0GwhlAf/fwsPeS1ZiplTp5olTunNsJm7EvtnVS7IYbS9/PqjmiyyklsmSn7cIH9j
6w+U9GoMrLrgEhJ8B6z+4LaVoSh/wWTvUHs2Ya+sXiO4tHGWIuA8eNyMUIcBDLbw
7PupHBixiWx/rIHmfV0bHpqmi92ZG4/k1Rjqge0fnN6dVo3ByK+KICDRp6entioV
CntohXhq8V3A7UtJBtSV7WTh+VPb9mVOpAqszLBlX3v/agahg2AceZbYKrQQOmIH
28PBE8yIFRBgW37gJTNgNH+C+MLfXvqQrIiMB4Z/Ayz75hdquInCQeoYG7+v0bYS
rjPKPc+iRMJp3GXkmOjGCYbXZi5gYg==
=XSE2
-----END PGP SIGNATURE-----

--Sig_/bHB84B5PchELJNiyS7Fr1Er--
