Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505D923CC51
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 18:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgHEQho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 12:37:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:58320 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727115AbgHEQfg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 12:35:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 77372B698;
        Wed,  5 Aug 2020 11:03:47 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id BD5856075E; Wed,  5 Aug 2020 13:03:30 +0200 (CEST)
Date:   Wed, 5 Aug 2020 13:03:30 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Lars Wendler <polynomial-c@gentoo.org>
Cc:     netdev@vger.kernel.org
Subject: Re: ethtool-5.8: test-driver uses bashisms
Message-ID: <20200805110330.hb2lgm6vxdwlxnlw@lion.mk-sys.cz>
References: <20200805084606.0593491a@abudhabi.paradoxon.rec>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cqcgl2ipqqahjkdy"
Content-Disposition: inline
In-Reply-To: <20200805084606.0593491a@abudhabi.paradoxon.rec>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cqcgl2ipqqahjkdy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 05, 2020 at 08:46:06AM +0200, Lars Wendler wrote:
> Hi Michal,
>=20
> I hope you are the right person to reach out for this matter.
>=20
> Running the test-driver script from ethtool-5.8 release with /bin/dash
> results in an endless loop that constantly emits the following two
> lines:
>=20
>   ./test-driver: 62: [: --test-name: unexpected operator
>   ./test-driver: 78: [[: not found
>=20
> This is because the script contains two bashisms which make the while
> loop to never exit when the script is not being run with a shell that
> knows about these bash extensions.
>=20
> The attached patch fixes this.

This is really unfortunate. The problem is that this script is not part
of ethtool codebase, it is copied from automake installation instead.
In this case, the script using [[...]] comes from automake 1.15 (which
I have on my development system).

AFAICS automake 1.16 has a newer version of test-driver script and the
main difference is the use of [...] tests instead of [[...]]. I'll
update automake on my development machine and open a bug to backport the
change to openSUSE Leap 15.2 package to prevent repeating this problem.

Michal

--cqcgl2ipqqahjkdy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl8qkfsACgkQ538sG/LR
dpWeKQf/Q5OahQXew6kFg8WzrLb57+HLcCwVPwWBQtfsTMr+ID2bAb/7m29QSnMT
d6mhG1pQ+Fw7qoFZbCtl2+AyYmumE2LS6RbS1uhrsllyaDC3hXdWTILdHL77e92D
uXQAx8wTNByIulUtuskbN4sCN3rdhTkiPhQOlpXLiVP6b3dGEKAgxSuiILi0J5Eg
yxRah7hvNRCTTfnhmXiv/ei9uyrPa56G0O6yHfhayhihBfBLvWW9EffVXgEoI7y9
999D2354rsVJTepzimMR5odvbnSBbOhjvKPR3xIWvKid60kxxngd892S4LGrYTYd
X04tddPdK0FC5xSJ0yyZVanK23Eo+w==
=0ph/
-----END PGP SIGNATURE-----

--cqcgl2ipqqahjkdy--
