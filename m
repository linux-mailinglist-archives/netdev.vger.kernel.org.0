Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3EFA4F71BE
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 03:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234075AbiDGByl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 21:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbiDGByk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 21:54:40 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A02197AE3;
        Wed,  6 Apr 2022 18:52:42 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KYksb2gpgz4xYN;
        Thu,  7 Apr 2022 11:52:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1649296357;
        bh=37PlGlI3sxbpW9G0FpFMd9eeoJZa466BjwDqkD8YDE4=;
        h=Date:From:To:Cc:Subject:From;
        b=T2GXYphQ1dElKh0u4lISQDZ/xGuhnbst8ttsLrbeUfQrGgYGkuAiN9WIVGJETX8+5
         gMGKrd4sHb8cmS/UbtMgpcWKnfF6Cnt9DJux4ZdZXLxLm5QQ6oRGU0QQSvhRZeT9YL
         CKN4qOZhBnJRehHM7I+8MDFEavU0ipd2o2nUA0OBimfIIlfIgucKqSspk1vVTdo4gB
         tHYLT0l7vsbWHhc1NzgQJlV14fYwDy41quFqCst8r9uJrPtk73Exssdnzu0Z/2sHqf
         7FJU9JHcnjDHvgnIjk3EC3y80ZTgVsH0L9RfO3Fczu1kqroWaUskoEykGWmibMTxOG
         Rpt8e/z1SE3kA==
Date:   Thu, 7 Apr 2022 11:52:23 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Shuah Khan <skhan@linuxfoundation.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Ricardo Ribalda <ribalda@chromium.org>
Subject: linux-next: manual merge of the kunit-next tree with the net-next
 tree
Message-ID: <20220407115223.0b37dcea@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/RjfmePM/RmZdOu7RrCX12KI";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/RjfmePM/RmZdOu7RrCX12KI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kunit-next tree got a conflict in:

  net/mctp/test/route-test.c

between commit:

  f4b41f062c42 ("net: remove noblock parameter from skb_recv_datagram()")

from the net-next tree and commit:

  741c9286ffad ("mctp: test: Use NULL macros")

from the kunit-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/mctp/test/route-test.c
index 24df29e135ed,17d9c49000c5..000000000000
--- a/net/mctp/test/route-test.c
+++ b/net/mctp/test/route-test.c
@@@ -360,8 -360,8 +360,8 @@@ static void mctp_test_route_input_sk(st
 =20
  	} else {
  		KUNIT_EXPECT_NE(test, rc, 0);
 -		skb2 =3D skb_recv_datagram(sock->sk, 0, 1, &rc);
 +		skb2 =3D skb_recv_datagram(sock->sk, MSG_DONTWAIT, &rc);
- 		KUNIT_EXPECT_PTR_EQ(test, skb2, NULL);
+ 		KUNIT_EXPECT_NULL(test, skb2);
  	}
 =20
  	__mctp_route_test_fini(test, dev, rt, sock);

--Sig_/RjfmePM/RmZdOu7RrCX12KI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJOQ9cACgkQAVBC80lX
0Gwk/Af+NX7EEjJKgtU1RbTjfSAt2U1E4LtxCoQX8Ycf8Uuj/TKZMLjuxaDy2C5Q
CAgN3RC7O19PUoiiz9yhVb5xhxMVrZcxmVOSwCab4oGhxu7cqMSqLcAfLjQvpuy6
D+P2sdvh8DgeAr35mzQJSPexGMrl2csxeN8p/mchxwiiNr39x5x3E5lJq5jol/kJ
K9mzopQD2bF/RTegWATUKJBKfkv6r4OlIsElzav+qejRh6CNe3KJGWnL/G/7ElBU
ACdefCGguzVI9BZndJsunAQwsL3BsN0KJoEnWws/zis9AXEtsl0QpBOvKvkMDqcJ
Ukzg13xlMXDfyQf1bu35s1fkRSc5yg==
=vPRf
-----END PGP SIGNATURE-----

--Sig_/RjfmePM/RmZdOu7RrCX12KI--
