Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB9E1D4537
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 07:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgEOF2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 01:28:45 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:46107 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725899AbgEOF2o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 01:28:44 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49NcQK13Bmz9sT8;
        Fri, 15 May 2020 15:28:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1589520522;
        bh=sjZPEx98jKfSUT+oFkRxErP0wKXkP0n+li1XeXx8L0c=;
        h=Date:From:To:Cc:Subject:From;
        b=F2YOZ5e8EeuWsC30SDFgXaJCjQ9NAVVkA7hoirCSAlJplawvr3YUK0KIHLY7bL+2C
         TZl/FBMvrpwvVTyj7SPR/zF3gXPpgJ+0GNPLj4i+oIZAzdFUZtFuPOCdVL/sjyVFZn
         GWk0lXjpHrScqTvJM47PckKKLb6gfJ4txDnx2kWY3tvn6F/f8f3f2IhHbzPo6iGs3C
         3Qa13tOrBoams6SlYy2JXUlzSZGFrYpYmWUhhMZCNCjLeULcxbCTdqpggze1ys88cH
         Aege9rdmzibVjzhV58JKGGbL5c+1RF5kBZHmElgvDOO68Ei9XlpyW4qFI7RCUYGRhd
         M9xkMuPyNsuKw==
Date:   Fri, 15 May 2020 15:28:38 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Rob Herring <robherring2@gmail.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alex Elder <elder@linaro.org>
Subject: linux-next: manual merge of the devicetree tree with the net-next
 tree
Message-ID: <20200515152838.551bb944@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/qTz1s0EtMguppuYLY5rSzZE";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/qTz1s0EtMguppuYLY5rSzZE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the devicetree tree got a conflict in:

  Documentation/devicetree/bindings/net/qcom,ipa.yaml

between commit:

  8456c54408a2 ("dt-bindings: net: add IPA iommus property")

from the net-next tree and commit:

  fba5618451d2 ("dt-bindings: Fix incorrect 'reg' property sizes")

from the devicetree tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc Documentation/devicetree/bindings/net/qcom,ipa.yaml
index 7b749fc04c32,b2ac7606095b..000000000000
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@@ -171,10 -162,9 +169,10 @@@ examples
                  modem-init;
                  modem-remoteproc =3D <&mss_pil>;
 =20
 +                iommus =3D <&apps_smmu 0x720 0x3>;
-                 reg =3D <0 0x1e40000 0 0x7000>,
-                         <0 0x1e47000 0 0x2000>,
-                         <0 0x1e04000 0 0x2c000>;
+                 reg =3D <0x1e40000 0x7000>,
+                         <0x1e47000 0x2000>,
+                         <0x1e04000 0x2c000>;
                  reg-names =3D "ipa-reg",
                              "ipa-shared",
                              "gsi";

--Sig_/qTz1s0EtMguppuYLY5rSzZE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6+KIYACgkQAVBC80lX
0GxWuAf9FKYqZB81Iy5sUxmNsP2EG1Rd+cOY0Ge0BXqL5qVUGHMynnRLF6tYWlVv
jPMMLBp+3curjcNAk6QspKL6ZqSLavNXOupArdBdmOudte3YCZUDtNZzK05HT5aP
fEpjskFq1r0bJwANLROFL9tKgdoWFscWxV+jDzMHQmPZlmTJh3hd97nklgQeISp0
g3NL1NA6r0L5u8DwgLq5sGHP0J8p7LF9JHB5HQF07wsrvyIsMW0SxXhBdcLj+e0O
+vbVaHYKjGvYRi+pgHflDwPKOyLVxB4QcJYBMLU9kchoxKY2Ti56fv8C2ADAFUXv
NvVjFRZkc1KE5FB0JlztoGGob/q0Mw==
=gg+y
-----END PGP SIGNATURE-----

--Sig_/qTz1s0EtMguppuYLY5rSzZE--
