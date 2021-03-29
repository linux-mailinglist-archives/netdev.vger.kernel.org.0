Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B59734C11D
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhC2B33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhC2B30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 21:29:26 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD8DC061574;
        Sun, 28 Mar 2021 18:29:22 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F7w3L3S0Dz9sVb;
        Mon, 29 Mar 2021 12:29:17 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1616981359;
        bh=tS36/yvn4T/WdxBeAhOqfBAnHoRss1JiIniZ0G+CTpI=;
        h=Date:From:To:Cc:Subject:From;
        b=ppvSGQ+sNcv9C+wOOj53cSXWZ2sZtR9Z2BIEMbeURFA6fINkJGRReXe/PgvF4rRKR
         xMOpjp+zBtyERG0eQ6CA4/F1gQRhChjAAOsa881Xe06Xe78yw7bHK/euCTz7HSric7
         goMohvGF3pFaZnaWHfpVksOjCjsgmF5bV1a5G1GDlvd8HNLyRViDiMlEpVqFDJ+xw1
         RvM8U1R1E9gfGd8NU9VM0Q7kolxXSsouxqoHjZkkrGJTHVrb4W3oHScoIjqybQWAyb
         XQbm5mqlMbr6mzGR2oIiq6LNBJNU1gcOsdLJ+trE+HHrhaR69rXF1GpCTIbtMYJgB/
         kiRQi+kizNXJw==
Date:   Mon, 29 Mar 2021 12:29:16 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>
Subject: linux-next: manual merge of the net-next tree with the bpf tree
Message-ID: <20210329122916.5921aad9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/n0RbQghcvDC=ieBcA8WQy2v";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/n0RbQghcvDC=ieBcA8WQy2v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  include/linux/bpf.h

between commit:

  861de02e5f3f ("bpf: Take module reference for trampoline in module")

from the bpf tree and commit:

  69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")

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

diff --cc include/linux/bpf.h
index fdac0534ce79,39dce9d3c3a5..000000000000
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@@ -40,7 -40,7 +40,8 @@@ struct bpf_local_storage
  struct bpf_local_storage_map;
  struct kobject;
  struct mem_cgroup;
 +struct module;
+ struct bpf_func_state;
 =20
  extern struct idr btf_idr;
  extern spinlock_t btf_idr_lock;

--Sig_/n0RbQghcvDC=ieBcA8WQy2v
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBhLWwACgkQAVBC80lX
0Gxtdgf+NOlt2Yc59onwnfYuBU7k+VWAgxK9UP1APSJRyUA8JwoUmUhOGu75Wbin
uUyCApb7Kmj1kkvWw9exigqwQwyrEKJHjWDGlnzKmozt4WjVjEWW61BaAyly54aT
IPUir2fox180Tx7BkFdM3SmUAO0CVtxoH64E8AnXCwuqnKGirgLof8jAZMxGgnaj
O0alMeVR90pU99R/s3OoNFB3FHwb4xsiNCXz/1eUcD1iN/tUOiI5urYsmgi/5HKw
jqIFQoa/9PXbGCgblD7oOUZGYxaFQv7AQkj4lBxw3IP/NDZU1DgrZN3YIkwiXwNM
3dSs3Y7iw0unzCSXidDYUaxDNrub9A==
=5+8n
-----END PGP SIGNATURE-----

--Sig_/n0RbQghcvDC=ieBcA8WQy2v--
