Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C7243421C
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 01:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhJSXgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 19:36:33 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:52101 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhJSXgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 19:36:33 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HYqp05qNvz4xbP;
        Wed, 20 Oct 2021 10:34:16 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1634686457;
        bh=a2YGRENPpVP9X/6KzFVetTvNS4DQSPpW45kTm2eue9c=;
        h=Date:From:To:Cc:Subject:From;
        b=oUrOFknEhT2tupjpczyp0VYw8y7L//ckrVnbl95bCPNGjNalGBIKNYiLGtGbF+DQg
         sKhXg+CrTMWqLn1Xs/uZ69aQ1x2TNH6tGJ6+TROfsInUP/OdfBHnwgL5QoUdc6zioQ
         LSYqRPXIHs3ijokgV+M4vSN6Zdkmfq6BmKEYFD7fVXN1EwJ8A5aP3ytzUjhr2y/739
         47zN9gdmdgorftxumvmNfRCBS0+nelV3yaCk/ZkJFlEdvW0emzzuozG4FaTSk5H66i
         +VIPW/IuFJWixlEDWSd7k3kwXJky2Ul6tsjgXiC3NLipA9DZnSorcM6Ajwt2XJlruC
         ntyUUs40GCJaw==
Date:   Wed, 20 Oct 2021 10:34:14 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Aharon Landau <aharonl@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Maor Gottlieb <maorg@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: linux-next: manual merge of the net-next tree with the rdma tree
Message-ID: <20211020103414.3e7533f4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/bNvDVWR+DvTaT6EPwJ+Gii_";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/bNvDVWR+DvTaT6EPwJ+Gii_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  include/linux/mlx5/fs.h

between commit:

  b8dfed636fc6 ("net/mlx5: Add priorities for counters in RDMA namespaces")

from the rdma tree and commit:

  425a563acb1d ("net/mlx5: Introduce port selection namespace")

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

diff --cc include/linux/mlx5/fs.h
index f2c3da2006d9,7a43fec63a35..000000000000
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@@ -83,8 -83,7 +83,9 @@@ enum mlx5_flow_namespace_type=20
  	MLX5_FLOW_NAMESPACE_RDMA_RX,
  	MLX5_FLOW_NAMESPACE_RDMA_RX_KERNEL,
  	MLX5_FLOW_NAMESPACE_RDMA_TX,
 +	MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS,
 +	MLX5_FLOW_NAMESPACE_RDMA_TX_COUNTERS,
+ 	MLX5_FLOW_NAMESPACE_PORT_SEL,
  };
 =20
  enum {

--Sig_/bNvDVWR+DvTaT6EPwJ+Gii_
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFvVfYACgkQAVBC80lX
0Gz/vgf+NQ1i+LJBGV2jG+t967hX+9jwXOO6DazWxOAkczm7HlCGnNjOHELDN307
y2Ip928sPeLL1kqwYJwqIUAXb06diAdtvvoa9wgFRG/JjwBfnM1JHcD9u990ZiSu
XWAQjv7Lsepp1QjbHWqiSgU83XF51fNix86M4HIBANLCGg581j28KdGL3gPPa9qF
o2PEqre9mHOSzkdA7o20BWWgGoPMUbQM4QCuuAuJE9k9C8YKKY15wmRpkKf1oTX0
10sgydLIUw+eHDvWOw33v//JbU7KCtv/gtdv+daYqwH23CJT461lWt7CMqnFIg4H
1pGSYSCsUtLmpi+wAj6i4lMwEVuEtA==
=r2BJ
-----END PGP SIGNATURE-----

--Sig_/bNvDVWR+DvTaT6EPwJ+Gii_--
