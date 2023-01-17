Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62DF466DBC2
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236545AbjAQLEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbjAQLEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:04:20 -0500
Received: from air.basealt.ru (air.basealt.ru [194.107.17.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CDA2A99B;
        Tue, 17 Jan 2023 03:04:18 -0800 (PST)
Received: by air.basealt.ru (Postfix, from userid 490)
        id 7CAC82F2022C; Tue, 17 Jan 2023 11:04:17 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
Received: from localhost (broadband-188-32-10-232.ip.moscow.rt.ru [188.32.10.232])
        by air.basealt.ru (Postfix) with ESMTPSA id 6CF1B2F2022A;
        Tue, 17 Jan 2023 11:04:14 +0000 (UTC)
Date:   Tue, 17 Jan 2023 14:04:14 +0300
From:   "Alexey V. Vissarionov" <gremlin@altlinux.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Raja Mani <rmani@qca.qualcomm.com>,
        Suraj Sumangala <surajs@qca.qualcomm.com>,
        Vivek Natarajan <nataraja@qca.qualcomm.com>,
        Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, lvc-project@linuxtesting.org,
        "Alexey V. Vissarionov" <gremlin@altlinux.org>
Subject: [PATCH] ath6kl: minor fix for allocation size
Message-ID: <20230117110414.GC12547@altlinux.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Although the "param" pointer occupies more or equal space compared
to "*param", the allocation size should use the size of variable
itself.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: bdcd81707973cf8a ("Add ath6kl cleaned up driver")
Signed-off-by: Alexey V. Vissarionov <gremlin@altlinux.org>

diff --git a/drivers/net/wireless/ath/ath6kl/bmi.c b/drivers/net/wireless/a=
th/ath6kl/bmi.c
index bde5a10d470c8e74..af98e871199d317f 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.c
+++ b/drivers/net/wireless/ath/ath6kl/bmi.c
@@ -246,7 +246,7 @@ int ath6kl_bmi_execute(struct ath6kl *ar, u32 addr, u32=
 *param)
 		return -EACCES;
 	}
=20
-	size =3D sizeof(cid) + sizeof(addr) + sizeof(param);
+	size =3D sizeof(cid) + sizeof(addr) + sizeof(*param);
 	if (size > ar->bmi.max_cmd_size) {
 		WARN_ON(1);
 		return -EINVAL;



--=20
Alexey V. Vissarionov
gremlin =F0=F2=E9 altlinux =F4=FE=EB org; +vii-cmiii-ccxxix-lxxix-xlii
GPG: 0D92F19E1C0DC36E27F61A29CD17E2B43D879005 @ hkp://keys.gnupg.net

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJjxoCuAAoJEFv2F9znRj5KRfIQAKOtCsMbHx5QVZZ5ciUVwZCP
2xcj4qRP7/GVJ8w87ip8n8QzRcMVaYposz3eLLGrXqUtb5UzWLCCpknXydwyXcsG
JMeR3l05cJzA7q2oyN3gtwwO37cA78U+vj5zCM1kooLuVdtlvZkBI6lIPIkUtgLz
VXsthfQbf2GRAMMHuJdZz8trH3xo8/FDAeEZKi6/r9lOc3v+cLewnQ+cUO85HSB7
lf4r0/cge8vFcDdMLq6WOO9X+zIeVvTYndo6ji1PUlf4mBOZbagWLsyIYjAxbvv/
W9l8N4K5AFX2ns/7kw8/ubf3Zx1e9H7iEHquAuMLPIh9knBuzIhLOQlfFG6b7zgs
6DF6I5HxX6ok20P62MoTbXNJF4I9JHWSEsg1Hr5D2Phvn3QRoGF5gu/L0IBxanRi
BUHKZzq+L6R013Wx/T3O7ifU3gHO9BidBIWLhU8+uAZ3VBB0DPUxPpO+dnNWoVtM
9ObMF5ecbwN9xsnIR+mNq4cK4pfd7YQeQ7PAN5fGK3Jq+fV8w79msRef4VQFOnmQ
GcNInjCp91KOdRoZBujkvZJmMy3cWOAvOIninLO3wIwHDHOPCrDc/KeWUWYayj8i
lzEE4GYNgdYb10l3GceadGV4m8EOguvF2Dnascwj+blBDNLFMxTzhpPOOxlSYJf/
rFtQugNyq60h3LY1TtDi
=V3e7
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
