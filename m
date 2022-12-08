Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D67646A73
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiLHI0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLHI0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:26:37 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389F813CD7
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 00:26:37 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E8EE322D8E;
        Thu,  8 Dec 2022 08:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670487995; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x7s+9sySfkZmC7tHP9c6Zwy+gz2YstyyuPHCVXtGe/A=;
        b=r8zilYSxRVtt6Y+FLPQ9gS6okhqq2uO3i/0+VD6N1C9RiYQXisI/M2WGiO9G+FKlPbrVKB
        gM5uAjoxInHroa+B1dijHZi5RzRZJ1MtxEdhmmLGG1y0OBHmKZwJTqlMk8IP0bAQ2/wIsK
        +q+sGDehl18dGZ1nkPnOVCB6VJT7/Fk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670487995;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x7s+9sySfkZmC7tHP9c6Zwy+gz2YstyyuPHCVXtGe/A=;
        b=13gb5GugIwfA0INSAXqIztGs4JW3GVVyCSFc2EFMt2T3H1Z5tkjLSBBU2RjKdE2e9hk7LO
        lbX2s6KhIRq1gKAQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id DCBA32C141;
        Thu,  8 Dec 2022 08:26:35 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 845536045E; Thu,  8 Dec 2022 09:26:35 +0100 (CET)
Date:   Thu, 8 Dec 2022 09:26:35 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v2 02/13] ethtool: fix trivial issue in allocation
Message-ID: <20221208082635.2hplh3yejabllaao@lion.mk-sys.cz>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
 <20221208011122.2343363-3-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="resafrxjrepfisu2"
Content-Disposition: inline
In-Reply-To: <20221208011122.2343363-3-jesse.brandeburg@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--resafrxjrepfisu2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 07, 2022 at 05:11:11PM -0800, Jesse Brandeburg wrote:
> Fix the following warning by changing the type being multiplied by to
> the type being assigned to.
>=20
> Description: Result of 'calloc' is converted to a pointer of type
> 'unsigned long', which is incompatible with sizeof operand type 'long'
> File: /home/jbrandeb/git/ethtool/rxclass.c
> Line: 527
>=20
> Fixes: 5a3279e43f2b ("rxclass: Replace global rmgr with automatic variabl=
e/parameter")
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
>  rxclass.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/rxclass.c b/rxclass.c
> index 6cf81fdafc85..ebdd97960e5b 100644
> --- a/rxclass.c
> +++ b/rxclass.c
> @@ -524,7 +524,7 @@ static int rmgr_init(struct cmd_context *ctx, struct =
rmgr_ctrl *rmgr)
>  	}
> =20
>  	/* initialize bitmap for storage of valid locations */
> -	rmgr->slot =3D calloc(1, BITS_TO_LONGS(rmgr->size) * sizeof(long));
> +	rmgr->slot =3D calloc(1, BITS_TO_LONGS(rmgr->size) * sizeof(unsigned lo=
ng));

While at it, maybe we should take the cleanup one step further and use
sizeof(*rmgr->slot) or sizeof(rmgr->slot[0]) instead. And perhaps it
would also make sense to follow the logic of calloc() arguments and use

	calloc(BITS_TO_LONGS(rmgr->size), sizeof(rmgr->slot[0]))

Michal


>  	if (!rmgr->slot) {
>  		perror("rmgr: Cannot allocate memory for RX class rules");
>  		return -1;
> --=20
> 2.31.1
>=20

--resafrxjrepfisu2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmORn7cACgkQ538sG/LR
dpWz2Af/e5T8IAdxbd1bpGZegtXGFO8ByP/S7mrEy+nbRuCkqDDWkGs0JpgWVVqn
pX7xFwoivsFlucKjpSOGbOoUcGBl+N5teMzluQ4QPj2875EShFp246JyCnQ05DAQ
ZHmQ+KxZnWZ+uV349GJq1wwCmGAWTRBfwEEgj35VTWvREMOcO++3+YlvjnRGOtUw
T3LyGN4GGjfW60Q/nIxPZp8ZzmHjId6dSUgyAEnqXXQxJnhr6UucRbcaZUnTrNd/
WXkdbzVqJaO3siy4uEK2AOCOmDKWVdYNo0nN+aqj28dHd6E+B/zqwnj/oxw2MVSV
6kBCYDliVXiFCdsAUSeMaMq3DG/Q/w==
=9MTO
-----END PGP SIGNATURE-----

--resafrxjrepfisu2--
