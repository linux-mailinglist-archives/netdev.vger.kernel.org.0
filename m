Return-Path: <netdev+bounces-11822-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C49C734990
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 02:54:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02BF5280FB4
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 00:54:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 010511114;
	Mon, 19 Jun 2023 00:54:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56D4110B
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 00:54:37 +0000 (UTC)
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7C7199;
	Sun, 18 Jun 2023 17:54:35 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4QkrrP47JKz4wgC;
	Mon, 19 Jun 2023 10:54:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1687136070;
	bh=UGzDDf6+2/OAPf09/wxh38XnQsJqOh/a9BOPRdmOeVQ=;
	h=Date:From:To:Cc:Subject:From;
	b=JJ9IgFgrqRdWyPHeiLzWx9in/kR7/UtwtodhP+T+XwdBMjTlFPNe3u5n8qus8kPZo
	 VRmcZFtdFScQPG9pUy9RnjD6qsIxCJyl5cfZ7uE0PnQJGBDHx1lrDaQ8v+JtvjIscY
	 WqI+zlFfxE2zUAE64hQsVjyvpNMSE1YMY+h2Ub44voZTzCTQ6kUYVCVdgAZmz2aJCs
	 Trvy5Hgokl4Yr6tQI/cyypXEo9yUVNg4rJM1OmxUDI3n3q+DTGck8jTntMAwMh33+s
	 prfFbRJkTQiRyfYLtDMsIMuWOC8zWJWSeJwXAoMydel//Yb7XORos8/g92QMsgjZYz
	 M7n6AQfdZ8bJg==
Date: Mon, 19 Jun 2023 10:54:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: Networking <netdev@vger.kernel.org>, Guillaume Nault
 <gnault@redhat.com>, Jakub Kicinski <kuba@kernel.org>, Linux Kernel Mailing
 List <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>, Magali Lemes <magali.lemes@canonical.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20230619105427.4a0df9b3@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/x7PcscfeSFP7Kyq/4C7U+Yp";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/x7PcscfeSFP7Kyq/4C7U+Yp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  tools/testing/selftests/net/fcnal-test.sh

between commit:

  d7a2fc1437f7 ("selftests: net: fcnal-test: check if FIPS mode is enabled")

from the net tree and commit:

  dd017c72dde6 ("selftests: fcnal: Test SO_DONTROUTE on TCP sockets.")

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

diff --cc tools/testing/selftests/net/fcnal-test.sh
index ee6880ac3e5e,05b5c4af7a08..000000000000
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@@ -1223,7 -1283,10 +1290,10 @@@ ipv4_tcp_novrf(
  	run_cmd nettest -d ${NSA_DEV} -r ${a}
  	log_test_addr ${a} $? 1 "No server, device client, local conn"
 =20
 -	ipv4_tcp_md5_novrf
 +	[ "$fips_enabled" =3D "1" ] || ipv4_tcp_md5_novrf
+=20
+ 	ipv4_tcp_dontroute 0
+ 	ipv4_tcp_dontroute 2
  }
 =20
  ipv4_tcp_vrf()

--Sig_/x7PcscfeSFP7Kyq/4C7U+Yp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmSPp0MACgkQAVBC80lX
0GyQOgf/W1COtAPl8x0lAkHUCHBAmW7xCkco3BBYDCXDffXmwm3QfkOQSi5dLHI3
C4pH+RtRzAhy69QIuen5LQQ9LOGp47Ov8mPSjWx53hxwhu46PlB1s4EH+/rkDYa2
kPiIh8Xcmy+f1jpyOAEn22mpofz1t8SQrYGBxhtVdKXjejrULRFNgA+RhBFSQo11
e5LAgKL1yH5cKynK7B3DapJynQCQPd8oPmEaS2CFMzKLyRWhcRlAX70JcPhUksFz
IWFJygJuRAz4sDZcxRMOEoDaEJTBrEU8GTU++DHKFgYhX+xKbCTmobVYG795I/OT
Rk+BQscmdxQiSRvxIC4F9THtfMGWmw==
=Tf4J
-----END PGP SIGNATURE-----

--Sig_/x7PcscfeSFP7Kyq/4C7U+Yp--

