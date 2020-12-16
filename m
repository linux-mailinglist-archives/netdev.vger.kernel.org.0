Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6152DB832
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 02:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgLPBEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 20:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727741AbgLPBEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 20:04:31 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D98EC0613D3;
        Tue, 15 Dec 2020 17:03:51 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CwcMQ28Lhz9sSn;
        Wed, 16 Dec 2020 12:03:45 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1608080627;
        bh=cQaV2jbS3HmMgFsTkGbTXR5ExwBawARpfAYivTjhXt0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nN2Juom3On3n3ghtqBd5FVXxrPvyxpHPrfWvaFeNOaQCmJTJal/hmsf6tVpYh77Rn
         Lc+3V+2uZ6LUlqdN6ylbVqxSUVxivVTxEzHev/xEbDAl4ysf5j6dQ82GKcwEdZ+5oz
         Z0xRTCpxOyblSDBqumqxRnTdlKOZtFxwOEZ0wQsSI8qJ5mfV8S/4y49iUSSPUQnFJb
         MItw+D2uGlY4LBzC2msOrV7fA7YOCx18xC1or3GQt+vuk0485T3EL5kUA7iTt5FTNT
         OJWYr5J19CS8gPutSeqYiRXGPmm+5Oi7tZ0GS4+LpKlpFZqJYNG7XS9clq+aJN5ito
         9wy2Kr7bucc7A==
Date:   Wed, 16 Dec 2020 12:03:45 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steve French <stfrench@microsoft.com>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Cabrero <scabrero@suse.de>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20201216120345.429d9e21@canb.auug.org.au>
In-Reply-To: <20201214131438.7c9b2f30@canb.auug.org.au>
References: <20201214131438.7c9b2f30@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/q5eVTRs0yh/ptO8mBQFA_t5";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/q5eVTRs0yh/ptO8mBQFA_t5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 14 Dec 2020 13:14:38 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the net-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> fs/cifs/cifs_swn.c: In function 'cifs_swn_notify':
> fs/cifs/cifs_swn.c:450:4: error: implicit declaration of function 'nla_st=
rlcpy'; did you mean 'nla_strscpy'? [-Werror=3Dimplicit-function-declaratio=
n]
>   450 |    nla_strlcpy(name, info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_NAME=
],
>       |    ^~~~~~~~~~~
>       |    nla_strscpy
>=20
> Caused by commit
>=20
>   872f69034194 ("treewide: rename nla_strlcpy to nla_strscpy.")
>=20
> interacting with commit
>=20
>   27228d73f4d2 ("cifs: Set witness notification handler for messages from=
 userspace daemon")
>=20
> from the cifs tree.
>=20
> I have applied the following merge fix patch.
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 14 Dec 2020 13:09:27 +1100
> Subject: [PATCH] fixup for "treewide: rename nla_strlcpy to nla_strscpy."
>=20
> conflicting with
>=20
> "cifs: Set witness notification handler for messages from userspace daemo=
n"
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  fs/cifs/cifs_swn.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
> index 642c9eedc8ab..d762d442dfa5 100644
> --- a/fs/cifs/cifs_swn.c
> +++ b/fs/cifs/cifs_swn.c
> @@ -447,7 +447,7 @@ int cifs_swn_notify(struct sk_buff *skb, struct genl_=
info *info)
>  		int state;
> =20
>  		if (info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_NAME]) {
> -			nla_strlcpy(name, info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_NAME],
> +			nla_strscpy(name, info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_NAME],
>  					sizeof(name));
>  		} else {
>  			cifs_dbg(FYI, "%s: missing resource name attribute\n", __func__);

This fixup is now needed when the cifs tree is merged with Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/q5eVTRs0yh/ptO8mBQFA_t5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/ZXPEACgkQAVBC80lX
0Gz6pAf7BFuB7xg7zQktIrJKkz76aJ4SijfmcLvfTb3OszPio5j3ydCke4MmV0Ny
+opqZU94f58XBT67cuz8lpg/wfabx8F5QJoN28p+MgBKvCcOf6r1mZdReqeD2vqi
tWBBsiLeCNkT8mpw/M+PxS7k2Jlx7+ghcw9nxvVkWJFT+Hsqo3KLBHOt00QhzrRA
ObxMwDPaaaopaMFLu071bN2kSnqbrmvnZBr6BZeRkKbykMpynFl8Qgq88oTGdnua
FXLAnW43ox66XI6j4v9e281ziC7siU5Sqz2q8cV+MJheyuD9GOtfpFw1eUNL4H/x
253339KfOPZp0ArWe51xy0tzn4VqWg==
=Eaao
-----END PGP SIGNATURE-----

--Sig_/q5eVTRs0yh/ptO8mBQFA_t5--
