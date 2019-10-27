Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEC3BE6A44
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 01:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbfJ0X77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 19:59:59 -0400
Received: from ozlabs.org ([203.11.71.1]:60967 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726909AbfJ0X76 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 19:59:58 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 471ZbG5qmXz9sPc;
        Mon, 28 Oct 2019 10:59:54 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1572220794;
        bh=QrSoyHYQ0Ycn44hBKdEsLJOcly+kFqqej3PJVjHb4yw=;
        h=Date:From:To:Cc:Subject:From;
        b=GAyoknIG1bd68tjPtfnpgWkHFBCTUZEIuuOkvn4TqxEmqIcivrpCQbFXudf5Bk+bC
         nt9RomkheYzaZPaGIToV7GhVnz+o3YJct0T6zVhc4gawpXe16Qk9NZfhly3lgbL+Yu
         gGFMMk/3ainXo4VuARXr/dartV9sPqyF/QkrWSQG6E3sCR8VDinHkkmccxh4f0wSJZ
         C7L17jZzHpLp7J0/hskidPDHlwap7SVlgoJOrOrnTcPfonJQbFN2s95ymlUlEmhrDc
         gS8iQvIbJY/7jZPo33dsxvwivQlDHgSypQKoKA9to3t/612RLrhPMUd0QMbnpoG7J7
         3/j9RqrA6770Q==
Date:   Mon, 28 Oct 2019 10:59:34 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Taehee Yoo <ap420073@gmail.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20191028105934.5c0ea3b0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/kK6aRZVlZsqijIZJLsg9PQv";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/kK6aRZVlZsqijIZJLsg9PQv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  include/linux/netdevice.h

between commit:

  ab92d68fc22f ("net: core: add generic lockdep keys")

from the net tree and commits:

  ff92741270bf ("net: introduce name_node struct to be used in hashlist")
  36fbf1e52bd3 ("net: rtnetlink: add linkprop commands to add and delete al=
ternative ifnames")

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

diff --cc include/linux/netdevice.h
index c20f190b4c18,3207e0b9ec4e..000000000000
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@@ -925,7 -925,16 +925,17 @@@ struct dev_ifalias=20
  struct devlink;
  struct tlsdev_ops;
 =20
+ struct netdev_name_node {
+ 	struct hlist_node hlist;
+ 	struct list_head list;
+ 	struct net_device *dev;
+ 	const char *name;
+ };
+=20
+ int netdev_name_node_alt_create(struct net_device *dev, const char *name);
+ int netdev_name_node_alt_destroy(struct net_device *dev, const char *name=
);
+=20
 +
  /*
   * This structure defines the management hooks for network devices.
   * The following hooks can be defined; unless noted otherwise, they are

--Sig_/kK6aRZVlZsqijIZJLsg9PQv
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl22L2YACgkQAVBC80lX
0GzgtggAlddLT6NHCp4RDHqUsSFctlKCqeCArCK9c842OFIlQQH9nlhCNA6rMghT
8wdHy2kFfvIw4RviCT1j4+QHLv2BESJBdumDHl2Fje2lxPKkvYt6hPsU3fEWZDGT
QuqeHB1dlzEQPlW58OJWRs5OLoOISIj6tzjQLaHu+CA/lVSQnWCYLmPRwkBrgAnz
EshwKsqmewDQF24YPZaVDwuq6QkltrOsL1HJ48RhT10AMbxe8+opf3LVoRIO5dQo
DdbVTH4099lO6M+esnxDcOHoidanDlkRMsVG8ZHiCLtVybtUmGn6XyDbq+hMJH+k
WVpNsBBQwlx8Q+gPa3sLi6i7llW6ow==
=vPrl
-----END PGP SIGNATURE-----

--Sig_/kK6aRZVlZsqijIZJLsg9PQv--
