Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006CE599740
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 10:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345594AbiHSI1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 04:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346751AbiHSI1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 04:27:21 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39009E833D
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 01:27:20 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E27DB3F5DF;
        Fri, 19 Aug 2022 08:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660897638; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ASwbbpD77n1Gm5/54eKDAOqUPMGDqFZmHfwJYWwj99Y=;
        b=FRj2Fa/rMq70EbJ1ok5yl+yr/s42Zo/gBhNJf2nLpYghPE2l5Vm5jlCdiom39wfSz+kH30
        8GsS2y5F+nz2aISRN3LGgOxgi0KoJAOCcL4xxRtR0HgZQaEjRQX+Wl3pmpeyLGgi+zXGNP
        Cq1+v8IqE0c6/Nn2l5fP0v+9db9xwTc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660897638;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ASwbbpD77n1Gm5/54eKDAOqUPMGDqFZmHfwJYWwj99Y=;
        b=1mWB7bgtW7UtT8Ic+81xSYuqYrs44m1GmTsu1oMiMPY5Oc8GvkdzpPtBNg6jTKb84GAz2J
        ctGm2ATH77NF2BCQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id F2EAA2C145;
        Fri, 19 Aug 2022 08:27:17 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id CB7616094A; Fri, 19 Aug 2022 10:27:17 +0200 (CEST)
Date:   Fri, 19 Aug 2022 10:27:17 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Tomasz =?utf-8?Q?Mo=C5=84?= <tomasz.mon@camlingroup.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Krzysztof =?utf-8?Q?Drobi=C5=84ski?= 
        <k.drobinski@camlintechnologies.com>
Subject: Re: [PATCH ethtool] ethtool: fix EEPROM byte write
Message-ID: <20220819082717.5w36vkp4jnsbdisg@lion.mk-sys.cz>
References: <20220819062933.1155112-1-tomasz.mon@camlingroup.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xsxzo2h34p5ju3ix"
Content-Disposition: inline
In-Reply-To: <20220819062933.1155112-1-tomasz.mon@camlingroup.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xsxzo2h34p5ju3ix
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 19, 2022 at 08:29:33AM +0200, Tomasz Mo=F1 wrote:
> ethtool since version 1.8 supports EEPROM byte write:
>   # ethtool -E DEVNAME [ magic N ] [ offset N ] [ value N ]
>=20
> ethtool 2.6.33 added EEPROM block write:
>   # ethtool -E ethX [ magic N ] [ offset N ] [ length N ] [ value N ]
>=20
> EEPROM block write introduced in 2.6.33 is backwards compatible, i.e.
> when value is specified the length is forced to 1 (commandline length
> value is ignored).
>=20
> The byte write behaviour changed in ethtool 5.9 where the value write
> only works when value parameter is specified together with length 1.
> While byte writes to any offset other than 0, without length 1, simply
> fail with "offset & length out of bounds" error message, writing value
> to offset 0 basically erased whole EEPROM. That is, the provided byte
> value was written at offset 0, but the rest of the EEPROM was set to 0.
>=20
> Fix the issue by forcing length to 1 when value is provided.
>=20
> Fixes: 923c3f51c444 ("ioctl: check presence of eeprom length argument pro=
perly")
> Signed-off-by: Tomasz Mo=F1 <tomasz.mon@camlingroup.com>
> ---
>  ethtool.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/ethtool.c b/ethtool.c
> index 89613ca..b9602ce 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -3531,8 +3531,7 @@ static int do_seeprom(struct cmd_context *ctx)
> =20
>  	if (seeprom_value_seen)
>  		seeprom_length =3D 1;
> -
> -	if (!seeprom_length_seen)
> +	else if (!seeprom_length_seen)
>  		seeprom_length =3D drvinfo.eedump_len;
> =20
>  	if (drvinfo.eedump_len < seeprom_offset + seeprom_length) {

I don't like the idea of silently ignoring the length parameter if value
is used. We should rather issue an error for invalid combination of
parameters, i.e. value present and length different from 1.

Michal

--xsxzo2h34p5ju3ix
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmL/SV8ACgkQ538sG/LR
dpXReQgAjd5/xF2hBYQQbohvLYVOeVidOjqOhBtGrVPMfSzmmbvk/mrG4ayg9wyy
uOFZHiGBfVn+8HEbAiqqQBBLHdhfMHqcZGXfpUs1gcFsR6/rcdtkQl1AkugTJ4hu
lln2TchVZDdZLW8vnb11bYGqvqi2DUWXl48phjQI+tggtvJJal7PRuTJWTjeiAvL
wwLPjT6SG0nqosurNdAaKBo74JSmgRdthX45l057v5rVpbaMEgS1RHdB4yahOQJB
vmGC2+RToYXpI/VB9P+6tY0EbIHKR0/g1EBY/3JUrInfz34AEnSqckJOovGMmflG
hLzDv3EgrV3ZO9syb3tS8gAdEgqk5Q==
=4cTc
-----END PGP SIGNATURE-----

--xsxzo2h34p5ju3ix--
