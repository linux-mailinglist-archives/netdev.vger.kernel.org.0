Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C3D21CCE9
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 03:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgGMByV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 21:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgGMByU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 21:54:20 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F507C061794;
        Sun, 12 Jul 2020 18:54:20 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B4msg4jsVz9sDX;
        Mon, 13 Jul 2020 11:54:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1594605256;
        bh=jrjCvMTcjkrp5HFa2/PbO/nfMjWZFR1zrU8zP/HMwc8=;
        h=Date:From:To:Cc:Subject:From;
        b=ktLlyuBotZxHsUbyZRb3/GDvW4tQf1Y+agM2xcPvX1Hc03y4I9lVefnD3HQX0rBAy
         srXolpUTtxa+F+yXhZOVBqg2G1nOV+BlZRiw1mOWxTaucYpxZrT7c2+RKqWJ8+IEj6
         vdPjZRtezUJFS1zGHvMclv7y6nxzCM6+5QHXERnwb3kNqjcSod7dWch4BcV/9GosPI
         LdCTz5ZYt9Y4wDs4x3CuwGTK/Swq+jM3Bv/Th9up1UOGR/qvWahUcRsoWCQbiyzlBJ
         s6CaSTgsQhltPvHI8jlXgyp35ceNmzpfgMfoniqZIMJ/Ndp1mjLOjISKK1LeNTzebV
         aquSggRVxW8Ug==
Date:   Mon, 13 Jul 2020 11:54:12 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20200713115412.28aac287@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/vrR5qWedZlO8KpSvwGFY_D4";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/vrR5qWedZlO8KpSvwGFY_D4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

net/bridge/br_netlink_tunnel.c: In function '__vlan_tunnel_handle_range':
net/bridge/br_netlink_tunnel.c:271:26: error: implicit declaration of funct=
ion 'br_vlan_can_enter_range'; did you mean 'br_vlan_valid_range'? [-Werror=
=3Dimplicit-function-declaration]
  271 |  if (v && curr_change && br_vlan_can_enter_range(v, *v_end)) {
      |                          ^~~~~~~~~~~~~~~~~~~~~~~
      |                          br_vlan_valid_range

Caused by commit

  94339443686b ("net: bridge: notify on vlan tunnel changes done via the ol=
d api")

CONFIG_BRIDGE_VLAN_FILTERING is not set for this build.

I have reverted that commit for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/vrR5qWedZlO8KpSvwGFY_D4
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8LvsQACgkQAVBC80lX
0GwFMAf9FF94vzPkkmTbIMN1a7Mer6wM9dgJZSXTtE7xSs7QwgLnYFd8HKiAJwLs
O9sCFHO3RETmYnjqy4h3qWXzbTfakDBIRDABGZdJ9I/h0FHZXjp8LGWdid2B/Pw6
ftmBG0ckgAgfW+k5/MpK9eTMMbRozi1eBTtgJBoqH69VNrdAt6V6YinxB2F2xbXg
sIfv1DENzsggguY3v72cXiU4YfUUnwXJooiXQaxW40rmHlncm9XJnMJOKbwpNxnv
INLZSEy0y+0j2AzdoCsSTJcrHbiIujexGKeMmnlXeXxNPwvjfGCp08448aCaxdgc
VxFwm6+uFoqOe0BmQEwFtcYyAoYj6g==
=z+Mo
-----END PGP SIGNATURE-----

--Sig_/vrR5qWedZlO8KpSvwGFY_D4--
