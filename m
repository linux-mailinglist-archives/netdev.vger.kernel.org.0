Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77A268E38E
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 23:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjBGWrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 17:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBGWrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 17:47:09 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323341422A;
        Tue,  7 Feb 2023 14:47:04 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PBJCl4FWrz4xxJ;
        Wed,  8 Feb 2023 09:46:58 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1675810020;
        bh=P1+2yR2zPHMLQNlCBWy7GQs27yRvZDYPL0p+TeY0y2U=;
        h=Date:From:To:Cc:Subject:From;
        b=EHDuh/fTrz6PCn9HuZxfdFDjtZlZCBjzHoD0RGKU1UdmmKdS0pLr6i2l+j1IsRVjU
         iHqhtAvFzKdLSMrQhLoH97wg264/ClyTa77ZWByUqxDhLdRAUjb5ZfWwibWwUiUY86
         x4pIP+GQ52CuMua1OK3o2EHlg1PlGlTVrAb8BvUuqeOBJlzWD3uxFtfmTJOG0wOFvA
         t4oiVOb2s5s0BlnKALZckQDTlzh78pME2HtiYRuWpyH4X5+GfgGCTVEyylvlnxHljT
         2jaONguOJ03zhakC0r0wbqJWDQYiZlmpPQ1Wcv4ZFHm3lHWTRsjbZDWIhbay/E6l+I
         H+y0/Kd70oIeg==
Date:   Wed, 8 Feb 2023 09:46:57 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20230208094657.379f2b1a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/+8DOz_+V1FFnl7K3zhMZ5WD";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/+8DOz_+V1FFnl7K3zhMZ5WD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/devlink/leftover.c (net/core/devlink.c in the net tree)

between commit:

  565b4824c39f ("devlink: change port event netdev notifier from per-net to=
 global")

from the net tree and commits:

  f05bd8ebeb69 ("devlink: move code to a dedicated directory")
  687125b5799c ("devlink: split out core code")

from the net-next tree.

I fixed it up (I used the latter version of this file and applied the
following merge fix up) and can carry the fix as necessary. This is now
fixed as far as linux-next is concerned, but any non trivial conflicts
should be mentioned to your upstream maintainer when your tree is
submitted for merging.  You may also want to consider cooperating with
the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 8 Feb 2023 09:43:53 +1100
Subject: [PATCH] fxup for "devlink: split out core code"

interacting with "devlink: change port event netdev notifier from per-net t=
o global"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/devlink/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index aeffd1b8206d..a4f47dafb864 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -205,7 +205,7 @@ struct devlink *devlink_alloc_ns(const struct devlink_o=
ps *ops,
 		goto err_xa_alloc;
=20
 	devlink->netdevice_nb.notifier_call =3D devlink_port_netdevice_event;
-	ret =3D register_netdevice_notifier_net(net, &devlink->netdevice_nb);
+	ret =3D register_netdevice_notifier(&devlink->netdevice_nb);
 	if (ret)
 		goto err_register_netdevice_notifier;
=20
@@ -266,8 +266,7 @@ void devlink_free(struct devlink *devlink)
 	xa_destroy(&devlink->snapshot_ids);
 	xa_destroy(&devlink->ports);
=20
-	WARN_ON_ONCE(unregister_netdevice_notifier_net(devlink_net(devlink),
-						       &devlink->netdevice_nb));
+	WARN_ON_ONCE(unregister_netdevice_notifier(&devlink->netdevice_nb));
=20
 	xa_erase(&devlinks, devlink->index);
=20
--=20
2.35.1

--=20
Cheers,
Stephen Rothwell

--Sig_/+8DOz_+V1FFnl7K3zhMZ5WD
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPi1OEACgkQAVBC80lX
0Gyr6Af8D5ccqmxFbA9hgoiZb052vn+jecHB0bGwMBeCv2FaVstxixIYVh8HyeBE
hVCzGlnlVGxUyS1BUEF2a//zzvEfh3xwGbXajTyIyM0VPEWizeTFYUIOHWeOJVY4
+Ku8c8TAUwfFiCNkY46a2nZ8dfUaxiAPiiwjONyui021vs/6VkNxNktG9572gBAp
tA8XKPvhca7InaLs8Kgyh0+IktME7jyxeAc31nYSEU6UtOZcEAzmCOXDqfAgI1Hp
X+pfzsPtGD/EFO+f2d6MG07frwAlfbuJpZHXhNTw+lZpniEp9NlF/95LFbC1BASq
r+1OolyiN55c2v1rEu+oe3hf8phR0Q==
=Cig5
-----END PGP SIGNATURE-----

--Sig_/+8DOz_+V1FFnl7K3zhMZ5WD--
