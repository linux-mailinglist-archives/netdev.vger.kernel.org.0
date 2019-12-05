Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 668E31149FD
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 00:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfLEXs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 18:48:29 -0500
Received: from ozlabs.org ([203.11.71.1]:56681 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbfLEXs3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 18:48:29 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47TXV16jTyz9sPL;
        Fri,  6 Dec 2019 10:48:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1575589706;
        bh=LqzQbfLl8Zqqq/SmWmoA4Bd493YpOIgE5M54kgTA95A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GcKgDgi6otnA5KsAJjeAy18kMV5KhKN2RlZ8u0vH0Z+0tL8OPeQOXvoFqMOuNgrZk
         uHo1uIvR52fYsY90jaSRxTiUH8CyiJrHChtHZAaZxlsex8bQEIHxnKYTthKwKLnZxj
         P25Eb6gNurKa8wv10QXQxbVyNrbr1RduRQmTZNfMSUyt+ASyipgOVSUhdUscJfOr5n
         nYC02SkWCnei1YF7ey+avzNWyc7m2/WHaQ7hTk5GNWYCevEwsu05q3YUu8HOH1ZQNd
         dBJstVCx8wJcswxHzTszgvlJT4+Y4uZclA/DAPXrthA5klmk2s69hmkg+c2s7Fkk95
         1QYUfbMS97LRg==
Date:   Fri, 6 Dec 2019 10:48:23 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, sd@queasysnail.net,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: build warning after merge of the net tree
Message-ID: <20191206104823.36998638@canb.auug.org.au>
In-Reply-To: <20191205.145739.377846077558856039.davem@davemloft.net>
References: <20191205084440.1d2bb0fa@canb.auug.org.au>
        <20191205.145739.377846077558856039.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/omqz+cIt1PeUBh=k/463SEO";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/omqz+cIt1PeUBh=k/463SEO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Thu, 05 Dec 2019 14:57:39 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> I think it is a false positive as well.  It looks like the compiler
> has trouble seeing through ptr error guards.
>=20
> In the new code the compiler can only see that the return value in the
> error case is non-zero, not necessarily that it is < 0 which is the
> guard against uninitialized accesses of 'obj'.
>=20
> It will satisfy this property, but through the various casts and
> implicit demotions, this information is lost on the compiler.
>=20
> My compiler didn't emit this warning FWIW.
>=20
> gcc (GCC) 8.3.1 20190223 (Red Hat 8.3.1-2)
>=20
> I'm unsure how to handle this, setting 'n' to explicitly be NULL
> is bogus because the compiler now will think that a NULL deref
> happens since the guard isn't guarding the existing assignment.

Yeah, not much we can do.

x86_64-linux-gnu-gcc (Debian 9.2.1-19) 9.2.1 20191109

--=20
Cheers,
Stephen Rothwell

--Sig_/omqz+cIt1PeUBh=k/463SEO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3pl0cACgkQAVBC80lX
0Gzacgf/VzBiN5tEZJWyB0vFs6DjdFofAMmVqp9gtYO3Nlh4pOqkqX5qBXRHaIF4
PzlUEKM5fBRHm4yTm5/9awsvkmEeWG4NVsR5GVmZ0vI+Q10628xD581xAD1NTFJz
dM5HaLk3xWh3KIWj6F/5KIFQooF/Mw7jhKa5K9gl4pqATfWRaU2IhhPYzRk56Ngz
aWRqpk0lxl/Z0Zd3t+zSt2c0T5hgbzI20WwRaHZpCFhnXalINnUEpdRtHenmJyVT
v7XnxEgdx8b717vLYPiI5HIW3cfTsO0puAvH/1JrIPuLKOviTSdQGiPcxDoGCZmn
7YdoqNNcT0d83to6vrCUjgKgTOx8og==
=s6dT
-----END PGP SIGNATURE-----

--Sig_/omqz+cIt1PeUBh=k/463SEO--
