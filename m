Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 281A76F2B7
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 13:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfGULPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 07:15:25 -0400
Received: from kadath.azazel.net ([81.187.231.250]:56334 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbfGULPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 07:15:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1tnrJi+AVVp5klDJhjbBjdJJZR/tmqMRQuK9f4CKrco=; b=Njb73C9DcB4DtBnECIb2P0Dh7q
        RrNaP2FpnkXk8Y7h8B8J8UA23EALyQZ3GTgDE7XESCbF9DAFXPZiI7XbWpbiN0/3Fq3wva7INZsnt
        nMN5jzRzV2MblR0IUfuMx8reei6yE7sx5jVICpbNaR5OgHTXWrvcZ+EKzYS/fjYOgZH5Hg5tj77R5
        QlDdVe7MSoW0l4Ktk3y75hCPeyv9byJ2TSRRm7yxksm6+UWWgxdnRKEtNyb7yG7OVfdHpCmVxnCXJ
        zO/x7FA7SxtjTDNcZYCNrsm3nFA7ujUEY/5B6wYfOko44tzZmN8i9Fq7potMQNEHrrXdBfKseppzz
        mkkQCz/A==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hp9oF-0002iF-8L; Sun, 21 Jul 2019 12:15:19 +0100
Date:   Sun, 21 Jul 2019 12:15:17 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: ENOBUILD in nf_tables
Message-ID: <20190721111517.GD23346@azazel.net>
References: <20190719100743.2ea14575@cakuba.netronome.com>
 <20190720074443.nteynyxuptizbkdx@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jy6Sn24JjFx/iggw"
Content-Disposition: inline
In-Reply-To: <20190720074443.nteynyxuptizbkdx@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jy6Sn24JjFx/iggw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-07-20, at 09:44:43 +0200, Pablo Neira Ayuso wrote:
> On Fri, Jul 19, 2019 at 10:07:43AM -0700, Jakub Kicinski wrote:
> > I hit the following build breakage on net with the config attached.
> >
> > GCC 9, doesn't seem like your just-posted series fixes this?
>
> $ gcc -v
> ...
> gcc version 9.1.0
>
> $ make
>   ...
>   CC      include/net/netfilter/nf_tables_offload.h.s
>   ...
> $
>
> Works for me here.

I think the compiler version is a red herring.  I reproduced the failure
with gcc-8 (Debian 8.3.0-6) and gcc-9 (Debian 9.1.0-4).  The problem is
that CONFIG_HEADER_TEST is defined and nf_tables_offload.h is not on the
header-test blacklist, but includes nf_tables.h, which is.

J.

--jy6Sn24JjFx/iggw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl00SToACgkQ0Z7UzfnX
9sNHSw//WIvIf+PnEJXLcjBYp4BQ7aLCwhBj+13s2o9xWaZj+kf7QMbe71x4VMy6
bu30A53cP1eL5FaQi48jQuTA9uLSFlfdn1AOrojfWJ/mjB+HpAAt2v9KokqqqG2k
2nah/a+VN5JZtJm8htOS9QWnwk9YHeMsIOrrwTig3moUlW5hcCEtAPYDXDhPlHLK
pKVGZK4QKYec3HeOn3o49W9z1f1grRrtSt42ZfvN+TaKsead5Ei1eDTHBanoyk8M
M1HnUhYPbMriv3HlR9pMINvhTqKEKF5CtvdxUl5vlum2lJB1OdyepmcRCb0IOVO/
EvZyzM1WlCE07TAAvSaVyqtDRwbyNQTP4qEd+BaoXA+KtTR/OSFT/6sfa2b/9kGP
Mm73ZqWfffEydoTUPgf6jMCyT/Z7DJtMPMb4PDmZQGCLhRPNH7UHspp8u/Mljr2n
bZTGa7kP3fz9OY3gQLAsQ5PERi+rX2a0HPu8ij545Yg3d6uGfgtLAgGG2cNPuQ6i
Xl76B8vCyVO2AvJZkI0gENrr7el2JNLXEZEpiLMl1FPmXWUGv2bcgjDVkyPtVArG
tg+LymjgfmC8F2vRAN4SdYBMGwboxFDjP6bwCzus6epMCQBGLQ05TRaifcZaQnK5
vEGSRNV4cKGD1pUhO4X6WZuxN7Dmj9csabW5Q1dKjP+sKnnpwcI=
=d6eP
-----END PGP SIGNATURE-----

--jy6Sn24JjFx/iggw--
