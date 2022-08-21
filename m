Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395DF59B6BD
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 01:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbiHUX2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 19:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiHUX2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 19:28:19 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217AD2720
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 16:28:15 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id DF75D34D69;
        Sun, 21 Aug 2022 23:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1661124493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lZpxidJlJxSY4IHwlNqwNq/tyu9mMwGunX06GCSdS+Q=;
        b=B00ku0LQ3q3haV6s/Z4aBZU6iFTSg7+XklYuno640IAWDQvhqqq7teyWhXCUAL/w3wnWbU
        j0gcst3cyGzX3+qKSxCa8Ner1aF+oWQNJZ4dpuMpFTqP73vqngAto9KMGKBsyJFyPB/kIu
        tFS85+G1FB45cHQchp52VaiedxlsDaA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1661124493;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lZpxidJlJxSY4IHwlNqwNq/tyu9mMwGunX06GCSdS+Q=;
        b=fYnNCQzkTN4Jwel+HBS4xIMY3Wq0AjDtjbdFa+bFvN1CXTge/yZ+nuGXiPg0VJtCr9IOYb
        S912bJBIv8Ny8EBQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D06662C141;
        Sun, 21 Aug 2022 23:28:13 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 37EEA603F0; Mon, 22 Aug 2022 01:28:11 +0200 (CEST)
Date:   Mon, 22 Aug 2022 01:28:11 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Tomasz =?utf-8?Q?Mo=C5=84?= <tomasz.mon@camlingroup.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Krzysztof =?utf-8?Q?Drobi=C5=84ski?= 
        <k.drobinski@camlintechnologies.com>
Subject: Re: [PATCH ethtool v2] ethtool: fix EEPROM byte write
Message-ID: <20220821232811.a2dlidrm5i62n6yu@lion.mk-sys.cz>
References: <20220819101049.1939033-1-tomasz.mon@camlingroup.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wpavv7b4kt5xyvaj"
Content-Disposition: inline
In-Reply-To: <20220819101049.1939033-1-tomasz.mon@camlingroup.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wpavv7b4kt5xyvaj
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 19, 2022 at 12:10:49PM +0200, Tomasz Mo=F1 wrote:
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
> Fix the issue by setting length to 1 when value is specified and length
> is omitted. Exit with error if length is specified to value other than 1
> and value is specified.
>=20
> Fixes: 923c3f51c444 ("ioctl: check presence of eeprom length argument pro=
perly")
> Signed-off-by: Tomasz Mo=F1 <tomasz.mon@camlingroup.com>
> ---
> changes in v2:
>   - set the length to 1 only if not specified by user
>   - exit with error if length is not 1
>=20
> v1: https://lore.kernel.org/netdev/20220819062933.1155112-1-tomasz.mon@ca=
mlingroup.com/
> ---
>  ethtool.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>=20
> diff --git a/ethtool.c b/ethtool.c
> index 89613ca..7b400da 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -3529,12 +3529,16 @@ static int do_seeprom(struct cmd_context *ctx)
>  		return 74;
>  	}
> =20
> -	if (seeprom_value_seen)
> +	if (seeprom_value_seen && !seeprom_length_seen)
>  		seeprom_length =3D 1;
> -
> -	if (!seeprom_length_seen)
> +	else if (!seeprom_length_seen)
>  		seeprom_length =3D drvinfo.eedump_len;

It would probably look a bit nicer like this:

	if (!seeprom_length_seen)
		seeprom_length =3D seeprom_value_seen ? 1 : drvinfo.eedump_len;

but that's just matter of taste so let's take it as it is.

Michal

> =20
> +	if (seeprom_value_seen && (seeprom_length !=3D 1)) {
> +		fprintf(stderr, "value requires length 1\n");
> +		return 1;
> +	}
> +
>  	if (drvinfo.eedump_len < seeprom_offset + seeprom_length) {
>  		fprintf(stderr, "offset & length out of bounds\n");
>  		return 1;
> --=20
> 2.25.1
>=20

--wpavv7b4kt5xyvaj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmMCv4UACgkQ538sG/LR
dpXFrAf+NI21ytTcSIrodWMDhuvw3M+c+QCrtIxoiCaULlbMhPVF4rz3J3OrIhFn
W8P76Dsg0+eSFGH2LQVwDGOM78YVOhnNnoncvdYkKhqPmYbK32FtJLTkYXmroLn/
UGeoG0IG02WfrKqJiS7BcjIbkMHdxbdsh2P230OpvMKQ4Bo2CoE0AVD40xchdIHn
Ma3m2BBEKAwnxY9YjMEgzhQ9mCWtJ/xdgrBrZPU/MqIQ8YWfQeu0+LAAPSo2WXHZ
bHvXe1zYr2eyhyDPOLUrR8IvCYGk5bwNBpJogjtGVh9VP/GgJiIt+SEiaipW1V5L
XYriV6fCOoz64z/gRRJGstqyQYw+hQ==
=3gUe
-----END PGP SIGNATURE-----

--wpavv7b4kt5xyvaj--
