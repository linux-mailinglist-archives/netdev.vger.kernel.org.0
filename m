Return-Path: <netdev+bounces-11563-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 964787339F9
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 21:35:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7D121C20F93
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:35:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C00F91EA80;
	Fri, 16 Jun 2023 19:35:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48411B914
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 19:35:25 +0000 (UTC)
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C2235A0;
	Fri, 16 Jun 2023 12:35:23 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 213431C0E70; Fri, 16 Jun 2023 21:35:22 +0200 (CEST)
Date: Fri, 16 Jun 2023 21:35:21 +0200
From: Pavel Machek <pavel@denx.de>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Osama Muhammad <osmtendev@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S . Miller" <davem@davemloft.net>,
	krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 4/6] nfcsim.c: Fix error checking for
 debugfs_create_dir
Message-ID: <ZIy5ecuHQUP1wUu2@duo.ucw.cz>
References: <20230615114016.649846-1-sashal@kernel.org>
 <20230615114016.649846-4-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pxvocpSbgigqWfO6"
Content-Disposition: inline
In-Reply-To: <20230615114016.649846-4-sashal@kernel.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--pxvocpSbgigqWfO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 9b9e46aa07273ceb96866b2e812b46f1ee0b8d2f ]
>=20
> This patch fixes the error checking in nfcsim.c.
> The DebugFS kernel API is developed in
> a way that the caller can safely ignore the errors that
> occur during the creation of DebugFS nodes.

I don't think this is good idea; user will wonder why he can't see
debugfs files, and pr_err() is quite suitable way to handle this.

Anyway, this does not really fix a bug, so we should not be putting it
into stable.

Best regards,
								Pavel

>  drivers/nfc/nfcsim.c | 4 ----
>  1 file changed, 4 deletions(-)
>=20
> diff --git a/drivers/nfc/nfcsim.c b/drivers/nfc/nfcsim.c
> index 533e3aa6275cd..cf07b366500e9 100644
> --- a/drivers/nfc/nfcsim.c
> +++ b/drivers/nfc/nfcsim.c
> @@ -345,10 +345,6 @@ static struct dentry *nfcsim_debugfs_root;
>  static void nfcsim_debugfs_init(void)
>  {
>  	nfcsim_debugfs_root =3D debugfs_create_dir("nfcsim", NULL);
> -
> -	if (!nfcsim_debugfs_root)
> -		pr_err("Could not create debugfs entry\n");
> -
>  }
> =20
>  static void nfcsim_debugfs_remove(void)

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--pxvocpSbgigqWfO6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZIy5eQAKCRAw5/Bqldv6
8leTAJ0ThYWaZ8JRFKMl8B8izHMZGm82CQCgjlPLfPVE1r8QIS26e8qGShfD+CU=
=Onr6
-----END PGP SIGNATURE-----

--pxvocpSbgigqWfO6--

