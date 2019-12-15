Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA9011FBBD
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 00:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfLOXFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 18:05:21 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:50453 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbfLOXFV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 18:05:21 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47bg3f0NzNz9sP6;
        Mon, 16 Dec 2019 10:05:17 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1576451118;
        bh=784n75LssZqq0BD3ApIFwrO1v+2m+UVROA25VXJx33c=;
        h=Date:From:To:Cc:Subject:From;
        b=EYxQ6HYbpWD7HWKYQfMZ3cbBsxopENyiUXSGZhH4eWyT4jaYDxVi2HwL1nKIgAzFn
         i8K5iYzU2u7Hyk3/Vb90ZAHGS3Kdy4o1Wze+gxS7khziWLZq5DFGLv1fCCQEdwg1Xc
         YxuvN2SEulRjXslGODI6jhIU61qIfJtadJ/SnkyDUmBfJF2dCWwvFQOwPKsdZYAANH
         MEdob+BuIZ/nE4Gol3flCXZZpTN2ErgKY0A5BfUElzOwVQ080SwgtQ5uhXT450koow
         M3EMaw+eoZsrpYiyecWzYWQbzGRyV7DFRRgC1be+uDHhuu/382gNe+odviKnaDtc92
         nzRhK3Gk/MYJA==
Date:   Mon, 16 Dec 2019 10:05:16 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20191216100516.22d2d85f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/kO=0q4ENmladIFze3Wkvczy";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/kO=0q4ENmladIFze3Wkvczy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/amazon/ena/ena_netdev.c

between commit:

  24dee0c7478d ("net: ena: fix napi handler misbehavior when the napi budge=
t is zero")

from the net tree and commit:

  548c4940b9f1 ("net: ena: Implement XDP_TX action")

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

diff --cc drivers/net/ethernet/amazon/ena/ena_netdev.c
index 948583fdcc28,26954fde4766..000000000000
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@@ -1237,9 -1861,8 +1861,8 @@@ static int ena_io_poll(struct napi_stru
  {
  	struct ena_napi *ena_napi =3D container_of(napi, struct ena_napi, napi);
  	struct ena_ring *tx_ring, *rx_ring;
-=20
 -	u32 tx_work_done;
 -	u32 rx_work_done;
 +	int tx_work_done;
 +	int rx_work_done =3D 0;
  	int tx_budget;
  	int napi_comp_call =3D 0;
  	int ret;

--Sig_/kO=0q4ENmladIFze3Wkvczy
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl32vCwACgkQAVBC80lX
0GzjWgf/fhKAC7ROSD+Ay7jyW01YhtFCfStpWnu2JvaxGC32ZACZbK+DMxnhQuqR
UnvHWnzfq8qnUHZp3Jw8DmseaXc/Z0RU3wK3VyojTL8exsnAjW8DNYQ6SkpM7wNW
uFTD1qF1VSax5cuLhh4QX0876qwbECeA3gqiP8vM7t15jvbGtTmvGUeEa4S1DxsZ
U2ZNoXrpdmEk9FZrmcTn1OmOIlgpn/pKfA6uwERgWHcOX9lOEI1k6mo5Xe+JXAQT
vqq+1BIcgR2XBa6SRiwoDFEEPuQlJUtomQ11CpM4ShyZNN9nGACEW1sLJJBXFq4B
1329RiHXQQwyxKo+ohPFahwtiffS/Q==
=SXQM
-----END PGP SIGNATURE-----

--Sig_/kO=0q4ENmladIFze3Wkvczy--
