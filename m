Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E20C172C40
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 00:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbgB0X3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 18:29:47 -0500
Received: from ozlabs.org ([203.11.71.1]:48847 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729391AbgB0X3r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 18:29:47 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48T85h46BWz9sPk;
        Fri, 28 Feb 2020 10:29:44 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1582846185;
        bh=AimF7zFnDLGiRjkIKIYbj4qkmOdhvGUC2m3nzv39Agk=;
        h=Date:From:To:Cc:Subject:From;
        b=mrN83AWcJ6/btlCRyg5pW8NkyQhOA/1Ts8Pf/WhimzGfcGLOi/vg3PO9gZgU0WvKE
         LJcGxzRvNM8aCmAxWkMgWLyKD7pIqr8qwnQ0fIP+caPEg2XDd2m9hgJ66OpWacYYb8
         2LvS9ZJU2oDDz93KP6GU7bv5T9XIGi/JKpwCuNt2j0Mec1yprm0ClAQz42hpdoVtNc
         3mTW02Wb6NoBeTY5evNOjET3Crr7+PLbEmIhwmydRfs6f3eNYVEgqR607aftAlQhmv
         AYBSIjf05qy/qylLpFrX5mfQtN/oaALjwMy5t4QbdYx4FGpOaLWvzaCkhbDbbemsuD
         mDGgStFbndM4w==
Date:   Fri, 28 Feb 2020 10:29:42 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200228102942.54a6fb76@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/C.hgIVj1Jct2d93PVo6HLu3";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/C.hgIVj1Jct2d93PVo6HLu3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/smc/smc_core.h

between commit:

  51e3dfa8906a ("net/smc: fix cleanup for linkgroup setup failures")

from the net tree and commits:

  ba9520604209 ("net/smc: remove unused parameter of smc_lgr_terminate()")
  5f78fe968d76 ("net/smc: simplify normal link termination")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/smc/smc_core.h
index 234ae25f0025,5695c7bc639e..000000000000
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@@ -296,8 -290,7 +290,8 @@@ struct smc_clc_msg_accept_confirm
  struct smc_clc_msg_local;
 =20
  void smc_lgr_forget(struct smc_link_group *lgr);
 +void smc_lgr_cleanup_early(struct smc_connection *conn);
- void smc_lgr_terminate(struct smc_link_group *lgr, bool soft);
+ void smc_lgr_terminate_sched(struct smc_link_group *lgr);
  void smc_port_terminate(struct smc_ib_device *smcibdev, u8 ibport);
  void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid,
  			unsigned short vlan);

--Sig_/C.hgIVj1Jct2d93PVo6HLu3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5YUOYACgkQAVBC80lX
0Gy+7QgAh4GZUYZETO9wUtc7CK12z39t2M8I09br8zGCJrR2eo4d2t+u3Dk3hvzK
EEedxJRjP779+WliOim3TStCh6yIn68CvLfhuNF131QnAsXdRAPJxgPbJ6l6qf2b
bs46pY4M10F7Ba8ekRO5J698uxM35cvC2qMn3TUplgX8XbS0CR+fWsVgjVF+iK9X
O9JafPF6l/vvF0YuJp5SSF67ICsPQovJkYe42Fe6YHLZ8nb3oshV29b2TTC+xh7W
Dy5T2WBtvgdXmzBn4Ix4fWonav7pOG+pWgGAR9JXk1vOCQRdyW+P8NIfOA0ZDMwT
4/iOD+ZiC03a3mCoohvwKoNtbUQF2g==
=QsW9
-----END PGP SIGNATURE-----

--Sig_/C.hgIVj1Jct2d93PVo6HLu3--
