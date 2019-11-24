Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38968108189
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 04:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfKXDZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 22:25:23 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:55737 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726676AbfKXDZX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Nov 2019 22:25:23 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47LFsp0N58z9sPW;
        Sun, 24 Nov 2019 14:25:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1574565919;
        bh=ubSCmS66KKKESIxFDLf0lj/eHA89i005gCLItb6k47c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BlrN/MwjAMFE9hQcqp+8JkTyqU9OFemRs41MyR6YELs1DTVYtILBwh2IJmnc6fKQN
         h5weWSWIZ8RjZGv81n1rfDYw5T4GXkVVrdxJ3ACv0fW+xDsxXO9K2OKIQhJcklLW8G
         pVcYnIG/hJGL3yUEPyfMllX6tz9hd83EDK9REP0LU5vAeIM5RzrqVuD0pufFjSjlr7
         TaAjpcQmrvU4R0r+X5EjbSWd1S1ABIBO98Q6Fc5RHxnXQxbauFUhsFJMcLjaSXBVg+
         jOeKRnqpVIa1IjlY26+doUwSkXwxYIaJHBjYCsoPn45Oj9GNM+agOOv9O/QPR2QFni
         nkk0+80lVQYsw==
Date:   Sun, 24 Nov 2019 14:25:11 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Dave Miller <davem@davemloft.net>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <edumazet@google.com>,
        <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH v2] powerpc: Add const qual to local_read() parameter
Message-ID: <20191124142511.529543bf@canb.auug.org.au>
In-Reply-To: <20191120011451.28168-1-mpe@ellerman.id.au>
References: <20191120011451.28168-1-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/HD_8++.mXadlTKPd0aZXGLH";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/HD_8++.mXadlTKPd0aZXGLH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 20 Nov 2019 12:14:51 +1100 Michael Ellerman <mpe@ellerman.id.au> wr=
ote:
>
> From: Eric Dumazet <edumazet@google.com>
>=20
> A patch in net-next triggered a compile error on powerpc:
>=20
>   include/linux/u64_stats_sync.h: In function 'u64_stats_read':
>   include/asm-generic/local64.h:30:37: warning: passing argument 1 of 'lo=
cal_read' discards 'const' qualifier from pointer target type
>=20
> This seems reasonable to relax powerpc local_read() requirements.
>=20
> Fixes: 316580b69d0a ("u64_stats: provide u64_stats_t type")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: kbuild test robot <lkp@intel.com>
> Acked-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
>  arch/powerpc/include/asm/local.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> v2: mpe: Update change log with compiler warning, resend to netdev so it =
appears
> in the netdev patchwork.
>=20
> Dave can you take this in the net tree so the window of the breakage is a=
s small
> as possible please?

I see that you marked this as "Not Applicable" in patchwork.

Michael meant the net-next tree which contains commit

  316580b69d0a ("u64_stats: provide u64_stats_t type")

Please consider applying this patch.

> diff --git a/arch/powerpc/include/asm/local.h b/arch/powerpc/include/asm/=
local.h
> index fdd00939270b..bc4bd19b7fc2 100644
> --- a/arch/powerpc/include/asm/local.h
> +++ b/arch/powerpc/include/asm/local.h
> @@ -17,7 +17,7 @@ typedef struct
> =20
>  #define LOCAL_INIT(i)	{ (i) }
> =20
> -static __inline__ long local_read(local_t *l)
> +static __inline__ long local_read(const local_t *l)
>  {
>  	return READ_ONCE(l->v);
>  }
> --=20
> 2.21.0
>=20

--=20
Cheers,
Stephen Rothwell

--Sig_/HD_8++.mXadlTKPd0aZXGLH
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3Z+BcACgkQAVBC80lX
0GzVvggAidrUoqlfyGMzIYgPyz7jnI4y/46XiGjrX8L+IvWQDPBcspWAAmEvZ/Bx
lnicYPiVhBq7eMs4hdJMZQ2OW3S/6td1uMLqujGrbl0N79KH1cSbIkymz50PZxP6
IiGA7D5VgeFLYidH4RMKruYvm0AqKA+N8GxK3lAgoxludsbcCUzbhlR4hAfyAsfB
LbtxHdLu1sWTqBNXdBCxlUC7wfpGcvYHaKBMm70SUTgL/LaVmvX0WtF+7vOdF19x
H1f7fNCa7bJlF+u0Osb3O4k5OWKg/JUviXqdstK/4HSKo09onYrrYb0m8Fdka+Lr
iuX+vJKwH5yUukRNsLeV0IZjtlX3hQ==
=6WC4
-----END PGP SIGNATURE-----

--Sig_/HD_8++.mXadlTKPd0aZXGLH--
