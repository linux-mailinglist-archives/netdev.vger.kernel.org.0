Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED7C646DAF
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 12:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiLHLAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 06:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiLHK7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 05:59:53 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A87C36C73
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 02:52:49 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 10ADD208AF;
        Thu,  8 Dec 2022 10:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670496768; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U+u/iSPoWplrNQyCys3yJY6NJG9o1Cm72/uVVcd6U1M=;
        b=mei3vjpzK6JGGDKRrGgzCXfj0vck0Z3sLo5gcbW4CUY7d9WByxUFSFqVhfBn3ffRcAZK1z
        i+K+3VwgTjgoM/oZ9Eh/aN0LhkcmX7/RgJtrihn4rvF1BWK2fNMJ4YPdSzEIR54vyaQx6d
        oj2520XNn2OApwzsUHkz+UwCaOUxCCg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670496768;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U+u/iSPoWplrNQyCys3yJY6NJG9o1Cm72/uVVcd6U1M=;
        b=KFD4aq/5vKhdUppL/ASpw1xUb6TGhNvO0U/IcWbBA+2/ITCyUG0jqwpTX4iwj/d6fO78Zr
        xO8lE1Dx47Ek4SCg==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id CAD3F2C166;
        Thu,  8 Dec 2022 10:52:45 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id D442B6045E; Thu,  8 Dec 2022 11:52:47 +0100 (CET)
Date:   Thu, 8 Dec 2022 11:52:47 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v2 11/13] ethtool: fix missing free of memory
 after failure
Message-ID: <20221208105247.vpb5aqn6hp3unjqx@lion.mk-sys.cz>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
 <20221208011122.2343363-12-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xpvcux2yp4wfaijz"
Content-Disposition: inline
In-Reply-To: <20221208011122.2343363-12-jesse.brandeburg@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xpvcux2yp4wfaijz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 07, 2022 at 05:11:20PM -0800, Jesse Brandeburg wrote:
> cppcheck warns:
> test-common.c:106:2: error: Common realloc mistake: 'block' nulled but no=
t freed upon failure [memleakOnRealloc]
>  block =3D realloc(block, sizeof(*block) + size);
>  ^
>=20
> Fix the issue by storing a local copy of the old pointer and using that
> to free the original if the realloc fails, as the manual for realloc()
> suggests.
>=20
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

Acked-by: Michal Kubecek <mkubecek@suse.cz>

> ---
>  test-common.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/test-common.c b/test-common.c
> index e4dac3298577..b472027140f6 100644
> --- a/test-common.c
> +++ b/test-common.c
> @@ -97,15 +97,18 @@ void test_free(void *ptr)
> =20
>  void *test_realloc(void *ptr, size_t size)
>  {
> -	struct list_head *block =3D NULL;
> +	struct list_head *block =3D NULL, *oldblock;
> =20
>  	if (ptr) {
>  		block =3D (struct list_head *)ptr - 1;
>  		list_del(block);
>  	}
> -	block =3D realloc(block, sizeof(*block) + size);
> -	if (!block)
> +	oldblock =3D block;
> +	block =3D realloc(oldblock, sizeof(*oldblock) + size);
> +	if (!block) {
> +		free(oldblock);
>  		return NULL;
> +	}
>  	list_add(block, &malloc_list);
>  	return block + 1;
>  }
> --=20
> 2.31.1
>=20

--xpvcux2yp4wfaijz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmORwfsACgkQ538sG/LR
dpUTUggAy6z+A0v3SDuVe1eEGOoTqmFJLAXzVPrLujGM/gbc9s6PUbAYX44NQAJT
LkdfPgxlDEi6MXyLGFBD+AmtWfLP4vcm1YCYTxd2WOq1oMx/OfSmtulSLcVsc7Cc
QJSJKiP/qh9WJaM0UJ079igVpRertfikr31FsLjvTeTnGNh5LZu/CyPH/plYlgKP
6R2kJeQdlwDlwlx3xmUMVXtmVaoQaNaMCjXtVhD0jgxF2jfVYpKglPeOnAfqXd/3
6A3X24sTkl8SbB9Wwuj/+82TXGSAmMY4B0SNYq0l0FlcP9VSStf8IIyNJdRfzICR
emDhJTfFh+dhSLX4eN2rTJ4Akrl9MQ==
=J8WJ
-----END PGP SIGNATURE-----

--xpvcux2yp4wfaijz--
