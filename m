Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB697104CA9
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 08:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfKUHeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 02:34:17 -0500
Received: from ozlabs.org ([203.11.71.1]:40223 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbfKUHeR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 02:34:17 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47JWXP0Vqmz9sPT;
        Thu, 21 Nov 2019 18:34:12 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1574321654;
        bh=pHBKt/pIY8/pjggPAOVBDfJjTlf2BbnB05Uov87WqvI=;
        h=Date:From:To:Cc:Subject:From;
        b=VxbBSn76Z6vf8xj15aFRw6osvug0l9Ufr0h6eQWilkoNexlE0bfOBa894L3JopsaZ
         WaoBvWVQBbFyusX+FWnKIz6vmPl0JSy8Jjct6VDIwuPxvPdzCl8Q6um7IwQVWBK3o/
         suWdyMgjX2Wdq/booEetrcnFLMkZXeha2IZb/k51uCWee5yHkxQbWn06aFfG9o1KEV
         1aOEvj4xPmPMcOUsbbLzfoxxq+5lX16zdnfSHnQo/rRcnMsd5d2zT4hdGb0dS2D9rO
         fIUtduC0aJ9LAdWKGNa8DsZMcXG5vU8G+MlxNuS+xSNgLzazn2RiU/Xu7jxvRo/EHm
         o8wlB4vLlgD1w==
Date:   Thu, 21 Nov 2019 18:34:04 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20191121183404.6e183d06@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/gFd=x/UNjRv++bq.voC0wX8";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/gFd=x/UNjRv++bq.voC0wX8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

[Sorry, I should have reported this earlier]

After merging the net-next tree, today's linux-next build (powerpc
allyesconfig) produced this warning:

net/netfilter/nf_flow_table_offload.c: In function 'nf_flow_rule_match':
net/netfilter/nf_flow_table_offload.c:80:21: warning: unsigned conversion f=
rom 'int' to '__be16' {aka 'short unsigned int'} changes value from '327680=
' to '0' [-Woverflow]
   80 |   mask->tcp.flags =3D TCP_FLAG_RST | TCP_FLAG_FIN;
      |                     ^~~~~~~~~~~~

Introduced by commit

  c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")

--=20
Cheers,
Stephen Rothwell

--Sig_/gFd=x/UNjRv++bq.voC0wX8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3WPewACgkQAVBC80lX
0GyIegf9FP8sPu8uRe2P5VhysaTMn+lMv4Wuj2nhSYtF4kyfYIktFH9/bYHEDCyM
sas2ghltHdxd7433oEr9eZK2m8TwKzw1brMBOFl2TTvORKnK8xmKGMcXlOk0H0Vb
z5pFF5V+yoefHZTQznF0uFil8QsSJwbrSAhAosYEWcC4O2L0OewE9DaRlJQCs7dA
7amWOV1G5Sa9PnyZ4H3NRbp2foxXOGuNDKDPaWRgwagthu3xt5obfpgKgxGAW07P
X+1f7rY67mJR/NGKr6/H4jTYzUXqd4GHmu+B7uUYgs0LCNjc6GuTo7o6Q8D8cKr+
WJHmdG4PiC+jk4o8TezaC6ifqAIdYA==
=faZe
-----END PGP SIGNATURE-----

--Sig_/gFd=x/UNjRv++bq.voC0wX8--
