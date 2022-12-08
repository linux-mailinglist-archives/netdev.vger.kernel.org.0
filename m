Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B464646EFB
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 12:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiLHLuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 06:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiLHLt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 06:49:56 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB6489313
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 03:48:51 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 57831337B2;
        Thu,  8 Dec 2022 11:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670500129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p8FeT0GLMYEcKy8ISsrJOFDfnwXAjRZgV3cdFmFKuPA=;
        b=DilmmwqlpiXJWoH3pUMQp7EEAYmk4NxNi5fwDHtEcDFPLV+6pKM/jPoi4UFBfn7soCjqZc
        GqpkdSZxgDL8RlTBHQGv8z0vvfFGllTlsQVYtzuZVVZe+AiaWuvkRj/AVYjLXDM36rpOsi
        +xjUxbdZAMWCz0uc9souEVgZTrwmOa8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670500129;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p8FeT0GLMYEcKy8ISsrJOFDfnwXAjRZgV3cdFmFKuPA=;
        b=Hv65VcRnLyQebTx96k2sEvG6K71zBGlzGTf2MFjHSvz6h3exSNwBLGDn0lv0odjDrZFZyS
        P3UWFBosdYcy5SAQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 539412C141;
        Thu,  8 Dec 2022 11:48:49 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 21CB96045E; Thu,  8 Dec 2022 12:48:49 +0100 (CET)
Date:   Thu, 8 Dec 2022 12:48:49 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v2 13/13] ethtool: fix bug and use standard
 string parsing
Message-ID: <20221208114849.xlanfoasf3ivzek2@lion.mk-sys.cz>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
 <20221208011122.2343363-14-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bibpvbfelae7ngf5"
Content-Disposition: inline
In-Reply-To: <20221208011122.2343363-14-jesse.brandeburg@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bibpvbfelae7ngf5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 07, 2022 at 05:11:22PM -0800, Jesse Brandeburg wrote:
> The parse_reset function was open-coding string parsing routines and can
> be converted to using standard routines. It was trying to be tricky and
> parse partial strings to make things like "mgmt" and "mgmt-shared"
> strings mostly use the same code. This is better done with strncmp().
>=20
> This also fixes an array overflow bug where it's possible for the for
> loop to access past the end of the input array, which is bad.
>=20
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
>  ethtool.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
>=20
> diff --git a/ethtool.c b/ethtool.c
> index 4776afe89e23..d294b5f8d92a 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -5280,17 +5280,21 @@ static int do_get_phy_tunable(struct cmd_context =
*ctx)
>  static __u32 parse_reset(char *val, __u32 bitset, char *arg, __u32 *data)
>  {
>  	__u32 bitval =3D 0;
> -	int i;
> +	int vallen =3D strlen(val);
> +	int strret;
> =20
>  	/* Check for component match */
> -	for (i =3D 0; val[i] !=3D '\0'; i++)
> -		if (arg[i] !=3D val[i])
> -			return 0;
> +	strret =3D strncmp(arg, val, vallen);
> +	if (strret < 0)
> +		return 0;

Shouldn't this be "if (strret)"? Unless I missed something, this would
lead to e.g. "zzzz-shared" being matched for "mgmt-shared" (with usual
locale) because you would get strret > 0 here and strcmp() =3D=3D 0 below.

> =20
> -	/* Check if component has -shared specified or not */
> -	if (arg[i] =3D=3D '\0')
> +	/* if perfect match to val
> +	 * else
> +	 * Check if component has -shared specified or not
> +	 */
> +	if (strret =3D=3D 0)
>  		bitval =3D bitset;

And this should be "if (!arg[vallen])", I believe.

Michal

> -	else if (!strcmp(arg+i, "-shared"))
> +	else if (!strcmp(arg + vallen, "-shared"))
>  		bitval =3D bitset << ETH_RESET_SHARED_SHIFT;
> =20
>  	if (bitval) {
> --=20
> 2.31.1
>=20

--bibpvbfelae7ngf5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmORzx0ACgkQ538sG/LR
dpUFVQf/atMMfSU2SlYlHhOvw0hgedUhaewA/2Bz0cWAgq+srU6jxcioXNxglS9r
oGvxbNTXpX9z03MvWXcVGOAemZdVVmEK+bFRYMksuDmiS19pd+/sqvklC1aXofpK
iOMlzvUUWkE53pOZklWeYyhZlVTAxXbOQwu8eUG0CpbgLDkJ8ID8m23OQYVv+yv3
ZzzXF5lOsZYysT5JSn3YJB7bvl/HYe0LbPGdwJa3tOy1VYh7tujDcyKYGDdPkIJv
KGL1OEXZPb9Oua1wtyCL/xvMSCaAICfWAdgDqjxa6JOlZ6RPk/pibV7B69ThtR4z
AUVupAxy9O6VKTTiKbPiL370kZRl/Q==
=K6B8
-----END PGP SIGNATURE-----

--bibpvbfelae7ngf5--
