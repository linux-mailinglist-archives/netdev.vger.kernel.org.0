Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3232608D0
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 05:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgIHDAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 23:00:08 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:37173 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728188AbgIHDAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 23:00:05 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BlqdH1TH1z9sT6;
        Tue,  8 Sep 2020 13:00:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1599534003;
        bh=CQHN0e/Qn6UFNS+n67zmmyp7Fusk1jwKZkCaWPvtNf8=;
        h=Date:From:To:Cc:Subject:From;
        b=ERXWzrnPfFSmoVIRraPjIQ/onRfVmc884U8Na7Ku1MMhzJWd/gVKA2GRSPcQ06BIa
         4F/SHqr5XHnFn8WwRm6XxyOO4mljeQE9BTt/nudmEAEAkGRLVWPHlvlv0E2EqWXeDP
         4LtYWHhru9MK9M1vB53TIvaVs3MOY4ayr2qTuaXMgP3E3x0Ry1YJdDB9Gq1x0FyLcX
         if3U+lxaoJlM/CPwKPvOm8+H0fR3ogNlZHWMP9qDtKXH90PWIIKONQGQuxZzt6V3e/
         RJUy4N5eBlwvhRitYCIvhbF3dQ0l1qaReGh2zkFHwDWPiXnsUYm5zGpaFaOKl0FWDl
         eNOibKiTUGIJQ==
Date:   Tue, 8 Sep 2020 13:00:00 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20200908130000.7d33d787@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/0QZPUHBHJ9Zkw26n/AB6g6B";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/0QZPUHBHJ9Zkw26n/AB6g6B
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

net/bridge/br_multicast.c: In function 'br_multicast_find_port':
net/bridge/br_multicast.c:1818:21: warning: unused variable 'br' [-Wunused-=
variable]
 1818 |  struct net_bridge *br =3D mp->br;
      |                     ^~

Introduced by commit

  0436862e417e ("net: bridge: mcast: support for IGMPv3/MLDv2 ALLOW_NEW_SOU=
RCES report")

Maybe turning mlock_dereference into a static inline function would help.

--=20
Cheers,
Stephen Rothwell

--Sig_/0QZPUHBHJ9Zkw26n/AB6g6B
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9W87AACgkQAVBC80lX
0Gwztgf9Hh2jrtu1RZqYuFJwNmxvdAOWUVelOVXq0kiT/OO7wuFzMD4wNcojcwyj
HJDJsmFHrEaLh5clmSNYFK9LE/h1pmOCQYQmhDGUjOs9CnqrvlWrpBxsz60+8EtL
556vbIvsZRImj/43lwpKbiTevG+J/JfjYw7vlkEMIzv9bFl1SlcFgmwFyziSxSWW
vbQ9BfdO3qNWpi5cn5UvCFqyoUzyPElQNxrP3JLIKGOt+a4oloMjMWwmIdysShcA
CVOengcuKzNIO2eRnVjBKMCyP+N2lc6ual2yKqVSpzmEbF7pbZogu3dYYxe7clbo
IGELVZvZHG8SbxGTCV4WnxEsIYn+IA==
=xjf+
-----END PGP SIGNATURE-----

--Sig_/0QZPUHBHJ9Zkw26n/AB6g6B--
