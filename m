Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD96113737
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 22:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbfLDVow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 16:44:52 -0500
Received: from ozlabs.org ([203.11.71.1]:34703 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727982AbfLDVow (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 16:44:52 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47Ssns0sfHz9sPT;
        Thu,  5 Dec 2019 08:44:48 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1575495889;
        bh=uA8eVLm8OL/wsGD7lo1Mt9Zb2Yma2lJuOdQyi3QyBUI=;
        h=Date:From:To:Cc:Subject:From;
        b=ljabVyo91OMUruCfb/Qh0treE1vGHbbQwaaBZmjEyGrHRipdh5qR0usGsbU6cP3Zd
         vLoND+sZkUOu1OBmQkflFi3clcLiZIJ41HjBKljfGXsJzrzNjJA59EYo1R0/GcnhYC
         J2vEJPyMMvYfddCe6G7saUDG2Isb1JDNrQyMUpxN4TrmmrjoxwphhSCMRNkP9owneO
         PQcQlPS2Zut30OL7LZRm6vQeModInKIMvCqBPNVulPsVlbq557AqdmjR+pYsNeJ8eH
         XRPJU5xOqyJnmiWA8YQ265e+A3YEon+LLK/X7R6AQazjkg7BOP5J6xNH50kiISYag2
         0XcTBYgJbZnBw==
Date:   Thu, 5 Dec 2019 08:44:40 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: linux-next: build warning after merge of the net tree
Message-ID: <20191205084440.1d2bb0fa@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ycwelL/amL7DWg+TMsX/aXK";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ycwelL/amL7DWg+TMsX/aXK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c: In function 'mlx5e_tc_=
tun_create_header_ipv6':
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:332:20: warning: 'n' ma=
y be used uninitialized in this function [-Wmaybe-uninitialized]
  332 |  struct neighbour *n;
      |                    ^

Introduced by commit

  6c8991f41546 ("net: ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst=
_lookup")

It looks like a false positive.

--=20
Cheers,
Stephen Rothwell

--Sig_/ycwelL/amL7DWg+TMsX/aXK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3oKMgACgkQAVBC80lX
0Gwuagf/dwTzdNY0ZdBpgEh3JIFmhEXUn34yRJy3fVMo3YRWjzb3yUQduB+kSun1
fu/cbdifMmQCmBFbmvVep3zyzo9oX1xeagP/syWSfLRUIPw9TE25MHiaOXS0+aIa
bfuOS8WhDDHf9NFePAP9siyrH2YT5fZimLhU6TUeB3Cn4Fl/robGE6JPLtQtbzuR
oLHRTdMgY13qM9bAZd8FeR3JXHXaGGWNs8iQpSKaZPEV7Le6rGxZGezmjo9DTINd
Ix3XCIqkfb06D/HN3al8sAWjHKgeIqoIIxGuNVYFg8AbdaEYdtdWtcWZJlVJw+/S
H0IYcKAGxUuLhV8THoE1t3rHlcg7Qw==
=azJe
-----END PGP SIGNATURE-----

--Sig_/ycwelL/amL7DWg+TMsX/aXK--
