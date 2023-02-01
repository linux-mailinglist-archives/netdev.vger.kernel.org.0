Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D7E6870DF
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 23:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbjBAWOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 17:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjBAWOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 17:14:38 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711825CD2F;
        Wed,  1 Feb 2023 14:14:36 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4P6bn62ypXz4x1h;
        Thu,  2 Feb 2023 09:14:34 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1675289675;
        bh=YFfw2YwVG8nBLtq3SvzjgJr1V9bmJFsi8jJYV90rfEU=;
        h=Date:From:To:Cc:Subject:From;
        b=T4NoxU8m3nDM0jiDl6X+ASE0dWQrg+xiU6SM00u3c+mSshN39JmXtHPc+OeltQ+GM
         ZvpLfekx8lgMiW7OIroFbTu+iKdq5kz0sUQ3tS3qBLW4NALY6Bg5AMXTMWqys+aaqK
         Mc1Lt/7NZ3ifzgGv3hu41EuzvPP2WdWG6sX3iEdwJZo5mlg/kcMrnVcqL5lLkOmsmr
         fKfoX9sjx5gonMK00/0hsVjTfZUsKOkICeIDTq0apjb0isP4Qp5g3zxynkq9bssDxg
         fLkWsCVmc4TlaWak6Jlw1vckpfzao13xPR9SjvwnAflJFnwG7BGcoPTRZCuW8SIGoP
         tLXyB7SjHcY1Q==
Date:   Thu, 2 Feb 2023 09:14:33 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Leon Romanovsky <leon@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Jianbo Liu <jianbol@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: linux-next: manual merge of the mlx5-next tree with the net-next
 tree
Message-ID: <20230202091433.7fb9d936@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_//TZsRvBpt4GevlMgNASltMA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_//TZsRvBpt4GevlMgNASltMA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mlx5-next tree got a conflict in:

  include/linux/mlx5/driver.h

between commit:

  fe298bdf6f65 ("net/mlx5: Prepare for fast crypto key update if hardware s=
upports it")

from the net-next tree and commit:

  2fd0e75727a8 ("net/mlx5e: Propagate an internal event in case uplink netd=
ev changes")

from the mlx5-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc include/linux/mlx5/driver.h
index 234334194b38,cc48aa308269..000000000000
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@@ -674,7 -675,7 +675,8 @@@ struct mlx5e_resources=20
  	} hw_objs;
  	struct devlink_port dl_port;
  	struct net_device *uplink_netdev;
 +	struct mlx5_crypto_dek_priv *dek_priv;
+ 	struct mutex uplink_netdev_lock;
  };
 =20
  enum mlx5_sw_icm_type {

--Sig_//TZsRvBpt4GevlMgNASltMA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPa5EkACgkQAVBC80lX
0Gx2aAf9EmcWb9zoKSWQDjcdqOiQk4eGpofA4UCbDhqlSCPT6xwBGVQ7V2vd9eDc
3kSBzUz5Fx+CT/Q6z30nWZr5uhq1EXniJi9kwD7u+aSMn61wuMFMWlipP3mvg57E
3R9UETrs804ZKAq6RgYsgoDlVign9e28PEMS/MpxytN//CCT0v8MBRyguNTrcUHx
5fcUIx/bePk51034MoxhhafoTghyDqejw6pO0RNoQn4Un6jEhfDMOiJRT1wlYzzb
so875RkJYNkAsqrVfY53UhFazHlUcetUYLf+gOfH1XxRvMtlbTppENY0zAST2h5p
UT0mvxql6TexsUBEMx/rkZuVVUDvUA==
=mtXb
-----END PGP SIGNATURE-----

--Sig_//TZsRvBpt4GevlMgNASltMA--
