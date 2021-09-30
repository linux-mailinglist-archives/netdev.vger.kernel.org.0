Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C7541E30F
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 23:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348825AbhI3VNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 17:13:51 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:51652 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348668AbhI3VNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 17:13:50 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id CCDF51FE56;
        Thu, 30 Sep 2021 21:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1633036326; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z6P2DP/GSTuCnJK/661zrtmo/3uTYvAAe+XwIMxE5dk=;
        b=S/Y6eKmLRNbHd9weHavZzOLETtA+NMy/ePX2YElPfawumim+BSpPcSOCeDlEEATqd2QM4Z
        g/ipeiOKtC8nw2nAvZd7vUpIlTFmkT+eYvqIL0fT8ANBucWVjDFUIpBkVkUTZkEC2YuOVo
        Wa0JFgX6DBquD2e6e/VbnWM9GEdxvKs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1633036326;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z6P2DP/GSTuCnJK/661zrtmo/3uTYvAAe+XwIMxE5dk=;
        b=MfK7gz4/tsUKw/7y+yPHunn6aawGsF9uJ5/7k64qDzDeXoW+0iyWKlVbOMd2wcr5b1z975
        1Sp8jo4CXCMSB4Dg==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id B9DBAA3B81;
        Thu, 30 Sep 2021 21:12:06 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 36C87603E0; Thu, 30 Sep 2021 23:12:04 +0200 (CEST)
Date:   Thu, 30 Sep 2021 23:12:04 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, vadimp@nvidia.com, moshe@nvidia.com,
        popadrian1996@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH ethtool-next 1/7] cmis: Fix CLEI code parsing
Message-ID: <20210930211204.3lcghvpe5xn4p2za@lion.mk-sys.cz>
References: <20210917144043.566049-1-idosch@idosch.org>
 <20210917144043.566049-2-idosch@idosch.org>
 <20210930202133.rspuswnnbnnhlgeb@lion.mk-sys.cz>
 <YVYg3rBB1/a2dlxw@shredder>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jozxc5yxiosifow2"
Content-Disposition: inline
In-Reply-To: <YVYg3rBB1/a2dlxw@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jozxc5yxiosifow2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 30, 2021 at 11:41:02PM +0300, Ido Schimmel wrote:
> On Thu, Sep 30, 2021 at 10:21:33PM +0200, Michal Kubecek wrote:
> > On Fri, Sep 17, 2021 at 05:40:37PM +0300, Ido Schimmel wrote:
> > > From: Ido Schimmel <idosch@nvidia.com>
> > >=20
> > > In CMIS, unlike SFF-8636, there is no presence indication for the CLEI
> > > code (Common Language Equipment Identification) field. The field is
> > > always present, but might not be supported. In which case, "a value of
> > > all ASCII 20h (spaces) shall be entered".
> > >=20
> > > Therefore, remove the erroneous check which seems to be influenced fr=
om
> > > SFF-8636 and only print the string if it is supported and has a non-z=
ero
> > > length.
> > >=20
> > > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> > > ---
> > >  cmis.c | 8 +++++---
> > >  cmis.h | 3 +--
> > >  2 files changed, 6 insertions(+), 5 deletions(-)
> > >=20
> > > diff --git a/cmis.c b/cmis.c
> > > index 1a91e798e4b8..2a48c1a1d56a 100644
> > > --- a/cmis.c
> > > +++ b/cmis.c
> > > @@ -307,6 +307,8 @@ static void cmis_show_link_len(const __u8 *id)
> > >   */
> > >  static void cmis_show_vendor_info(const __u8 *id)
> > >  {
> > > +	const char *clei =3D (const char *)(id + CMIS_CLEI_START_OFFSET);
> > > +
> > >  	sff_show_ascii(id, CMIS_VENDOR_NAME_START_OFFSET,
> > >  		       CMIS_VENDOR_NAME_END_OFFSET, "Vendor name");
> > >  	cmis_show_oui(id);
> > > @@ -319,9 +321,9 @@ static void cmis_show_vendor_info(const __u8 *id)
> > >  	sff_show_ascii(id, CMIS_DATE_YEAR_OFFSET,
> > >  		       CMIS_DATE_VENDOR_LOT_OFFSET + 1, "Date code");
> > > =20
> > > -	if (id[CMIS_CLEI_PRESENT_BYTE] & CMIS_CLEI_PRESENT_MASK)
> > > -		sff_show_ascii(id, CMIS_CLEI_START_OFFSET,
> > > -			       CMIS_CLEI_END_OFFSET, "CLEI code");
> > > +	if (strlen(clei) && strcmp(clei, CMIS_CLEI_BLANK))
> > > +		sff_show_ascii(id, CMIS_CLEI_START_OFFSET, CMIS_CLEI_END_OFFSET,
> > > +			       "CLEI code");
> > >  }
> > > =20
> > >  void qsfp_dd_show_all(const __u8 *id)
> >=20
> > Is it safe to assume that the string will be always null terminated?
>=20
> No. You want to see strnlen() and strncmp() instead?

Yes, that would solve the problem. Actually, "strlen(clei)" could be
also replaced with "*clei" or "clei[0]" as a string is empty if and only
if its first byte is null.

Michal

> > Looking at the code below, CMIS_CLEI_BLANK consists of 10 spaces which
> > would fill the whole block at offsets 0xBE through 0xC7 with spaces and
> > offset 0xC8 is used as CMIS_PWR_CLASS_OFFSET. Also, sff_show_ascii()
> > doesn't seem to expect a null terminated string, rather a space padded
> > one.

--jozxc5yxiosifow2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmFWKB0ACgkQ538sG/LR
dpVA8gf/eKAodt61mqrminfYeg7qwjrql5fBFLj/1aMRVMcscyFnQ4+MJmccAUYR
ZAQyZ9hqQFfxpTXm48uZceWP3lXuv6WqcXrvFcOeDqu982PQ+t6NUa6O/m7xG2OA
QdKP+8WqCw0ii6cDkVLwV3m1vc4Tcr88nCIYby8zUr9s9+cpklzjDXPxUe18R3IF
O4kgBZ08sMXIGbOqMzQlHeZeA5WEV3SBu4SYH8Tt2TVt1NJNUkOKfo5Gr0Iid57I
nfW1p8flM2jvicZgA5idv1+FntmZFhUnhUcRyMve8KYwkzTjBZgYTYoRqHEQCWxT
ZQ8VYuxTEJPMQ6Vh85t8+MUgXNC1pA==
=t9EP
-----END PGP SIGNATURE-----

--jozxc5yxiosifow2--
