Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0186F69A27D
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 00:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjBPXkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 18:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBPXkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 18:40:20 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999704D61D;
        Thu, 16 Feb 2023 15:40:18 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PHrz468HRz4x5c;
        Fri, 17 Feb 2023 10:40:16 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1676590817;
        bh=p65Yo3Ha1p0WjPcHA/W572Ft0NLlUcUxtz4s3R8X+iM=;
        h=Date:From:To:Cc:Subject:From;
        b=oofnZEWkf6fEHk8VstohJNWoXKp5KGpuNWscVuO1rICAuVlzvMCZxqXbI6wrNtR6I
         /oEx+yJirw28bd5dwPlBnJXpwM7eOAT9Ocrk6o/SRvHRXbYRLBdx6UGqB3swGc1ydQ
         AeQfiOfmJmnlWeOReHLKjV0cBfHUJomknefgnAsxYT34NeMpZXOAyMTzeSnVM/iNNi
         KqQwyeDBoGhJKOBXgNZFT7h4jkQWMh92rf7o2uix+7+1ZGW63bJTUx9vE+Z37nKYNr
         LsC2fKsdtP+kqA6TJm1e1iqArZ9caVr90+ibvLPufwCA3iLyQnmOuVz6llMHCiyos4
         DNTqyvJY6vllQ==
Date:   Fri, 17 Feb 2023 10:40:15 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Ido Schimmel <idosch@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: linux-next: manual merge of the net-next tree with Linus' tree
Message-ID: <20230217104015.3472a131@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/IsrmcyfBhL615cTZKSKAKw4";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/IsrmcyfBhL615cTZKSKAKw4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/devlink/leftover.c

between commit:

  b20b8aec6ffc ("devlink: Fix netdev notifier chain corruption")

from Linus' tree and commits:

  dbeeca81bd93 ("devlink: Split out dev get and dump code")
  7d7e9169a3ec ("devlink: move devlink reload notifications back in between=
 _down() and _up() calls")
  a131315a47bb ("devlink: send objects notifications during devlink reload")

from the net-next tree.

I fixed it up (I used the latter version of this file and applied the
following merge fix patch) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 17 Feb 2023 10:37:43 +1100
Subject: [PATCH] fix for "devlink: Fix netdev notifier chain corruption"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/devlink/dev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/devlink/dev.c b/net/devlink/dev.c
index b40153fa2680..bf1d6f1bcfc7 100644
--- a/net/devlink/dev.c
+++ b/net/devlink/dev.c
@@ -343,8 +343,6 @@ static void devlink_reload_netns_change(struct devlink =
*devlink,
 	 * reload process so the notifications are generated separatelly.
 	 */
 	devlink_notify_unregister(devlink);
-	move_netdevice_notifier_net(curr_net, dest_net,
-				    &devlink->netdevice_nb);
 	write_pnet(&devlink->_net, dest_net);
 	devlink_notify_register(devlink);
 }
--=20
2.39.1

--=20
Cheers,
Stephen Rothwell

--Sig_/IsrmcyfBhL615cTZKSKAKw4
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPuvt8ACgkQAVBC80lX
0GxbUgf/XuM1uE/p6y9RR966U0ivnzxEtWX/xd62LzsUHk7hdx3I5xFza/1tJ8cg
837RnaGWmQohZj3qAMrvt1EjoPO3y7bei3hf3RIoztM2ItNQa5JQQdJRYmctcphC
csG+YKY1kZPfq3dN6LPbfJxmeHQDZ2pJ7qFUBfW3HJ+aJZ6O597Ug/MG5hUVaTHT
pjWOlCoaw53Kb09MfgJeoVZv4YlnN2VKV8p4HM1nMB9w557gz6UHRVJoKMDXdRcc
v2084Q1li9XWo4ohpOsGBq4+wxPZYhnyuDRD0mQkejzgB/rZR6SnNc4uNJXWo6PO
Wfk6geMIdPb1Z7L+v3VRtBDwPOVaKQ==
=LzY4
-----END PGP SIGNATURE-----

--Sig_/IsrmcyfBhL615cTZKSKAKw4--
