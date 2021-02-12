Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6879C319819
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 02:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhBLBpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 20:45:44 -0500
Received: from ozlabs.org ([203.11.71.1]:44251 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229547AbhBLBpm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 20:45:42 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DcGXC2SMFz9sCD;
        Fri, 12 Feb 2021 12:44:58 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1613094299;
        bh=JZa0GbZBzrmj0j7yTVtgKU0e3zwCa5BJ1ExITG7fqeI=;
        h=Date:From:To:Cc:Subject:From;
        b=ZbuLMNQuI1Ts0Gdo9LLv0joW2MGHLGNwO7QBwg23+snFqen1fbspnkGEM6Z1RLLBB
         5WlwfvYAxi6ejWCfVhn9KTwc761fMdyba1NhsboQKSt/YgyUmfBOtc5Pa1fPt5GFv+
         zII3taZDKBIcCEvaBVJqTwv+X5uPv5FIPd2evNKXn/Q0HC8TFIt9CF8ugYTnrh8EaS
         IGoaPToejRyP/ZsFC/O7TWQew5AMtoFdY6kIEQUQ8VjPWEpa81ikhzf7h06Ka5gqjK
         75aal0ZK4MimBUsXWCpO6s3UGzpBeTmSGVat4dHmVMTZKjCiIF+hJHsbAK/wHxUncI
         pRkhA2QzoS9bA==
Date:   Fri, 12 Feb 2021 12:44:58 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Paul Blakey <paulb@nvidia.com>, wenxu <wenxu@ucloud.cn>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210212124458.3d008bb5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/6Qw0qki3tbQTW04+YhDizmu";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/6Qw0qki3tbQTW04+YhDizmu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  include/uapi/linux/pkt_cls.h

between commit:

  1bcc51ac0731 ("net/sched: cls_flower: Reject invalid ct_state flags rules=
")

from the net tree and commits:

  7baf2429a1a9 ("net/sched: cls_flower add CT_FLAGS_INVALID flag support")
  8c85d18ce647 ("net/sched: cls_flower: Add match on the ct_state reply fla=
g")

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

diff --cc include/uapi/linux/pkt_cls.h
index 88f4bf0047e7,afe6836e44b1..000000000000
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@@ -591,8 -591,8 +591,10 @@@ enum=20
  	TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED =3D 1 << 1, /* Part of an existing c=
onnection. */
  	TCA_FLOWER_KEY_CT_FLAGS_RELATED =3D 1 << 2, /* Related to an established=
 connection. */
  	TCA_FLOWER_KEY_CT_FLAGS_TRACKED =3D 1 << 3, /* Conntrack has occurred. */
+ 	TCA_FLOWER_KEY_CT_FLAGS_INVALID =3D 1 << 4, /* Conntrack is invalid. */
+ 	TCA_FLOWER_KEY_CT_FLAGS_REPLY =3D 1 << 5, /* Packet is in the reply dire=
ction. */
 +
 +	__TCA_FLOWER_KEY_CT_FLAGS_MAX,
  };
 =20
  enum {

--Sig_/6Qw0qki3tbQTW04+YhDizmu
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAl3ZoACgkQAVBC80lX
0GwUJgf+N0+9cqubNkMr/ch+3WvQA+6qvxbdiS1UqTaNNfcEI4jZkndERB8C2Xga
AxnSFyjGeVCwD9RPzYE26hQEQwVlfsrJUcdkNzoJRimY+l/UCBPkZAJxR7CgWiwo
mVfZW46PqcwJqX82YKAO/4jaQ06M7XYGHzSiZxAp7dbae4W5jYbQ17nY7b3eacOn
wIPI9rdjK6PYjUdgSVKywSmZFW5kVh7w4v3778TI9ZKX2SuWeKdzilky63kpahJS
zFW3E/wf90W8UrzP2Jcd5BmTPH6tWqI2ifo9Qu5omqdfXm0a/kIQGF69/e69qjVa
PSuZgX1R+AHw1CTEHozbWhvXj6TVEQ==
=RnV1
-----END PGP SIGNATURE-----

--Sig_/6Qw0qki3tbQTW04+YhDizmu--
