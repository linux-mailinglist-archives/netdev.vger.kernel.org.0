Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21D427F844
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 05:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730868AbgJADwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 23:52:41 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:49727 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbgJADwk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 23:52:40 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C1zjK6tQFz9sVH;
        Thu,  1 Oct 2020 13:52:37 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1601524358;
        bh=gCAT7PYuRTzz3YkKtze9ptscMbAyN0IEBzt3bY9bTGQ=;
        h=Date:From:To:Cc:Subject:From;
        b=gM+8vo9Bznn5OC3R32jb8bpMkElXkqqvTtuV0V74b/XqSWcgMxFc/KEbEXqaj9Y7+
         0rwJuI2cWnkOHkIRF1FB/FzAeOyEeAc7mOhw46WQq/6cfA/qsJhAzosCcuUunceE27
         eiAxMezNIHga2TNkzUNhYnjTfd9loBFuH0BTdHb3wbD6doknrWMA+gDhy3cAnKLh8i
         VadCzvWHW2CYz+ob3nfxh+VC+LK2l5JFKUZ6qY1BqsJIb/4SlBTzGmbIUevfgm/MAq
         /4Tjw9kapn4/n3kn/O1t9LhEfBac3J0dPcdmjB1Lx0lY4ZJP048+XqQBub70bIS/fP
         +UWpLSZcBHJZA==
Date:   Thu, 1 Oct 2020 13:52:37 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Geliang Tang <geliangtang@gmail.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20201001135237.6ec2468a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Xi1Cp4gLlSyPSukUV7g=1JA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Xi1Cp4gLlSyPSukUV7g=1JA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/mptcp/protocol.h

between commit:

  1a49b2c2a501 ("mptcp: Handle incoming 32-bit DATA_FIN values")

from the net tree and commit:

  5c8c1640956e ("mptcp: add mptcp_destroy_common helper")

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

diff --cc net/mptcp/protocol.h
index 20f04ac85409,7cfe52aeb2b8..000000000000
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@@ -387,7 -407,8 +407,8 @@@ void mptcp_data_ready(struct sock *sk,=20
  bool mptcp_finish_join(struct sock *sk);
  void mptcp_data_acked(struct sock *sk);
  void mptcp_subflow_eof(struct sock *sk);
 -bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq);
 +bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq, =
bool use_64bit);
+ void mptcp_destroy_common(struct mptcp_sock *msk);
 =20
  void __init mptcp_token_init(void);
  static inline void mptcp_token_init_request(struct request_sock *req)

--Sig_/Xi1Cp4gLlSyPSukUV7g=1JA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl91UoUACgkQAVBC80lX
0GzlOQgApUn7XBMil9BuKY+GtJSLDWnvKm0AX3W8QwtRWA50cU0DBk8TXCYrN8tL
MSaL/brv651s87L0vCB49bPRUswqsAHycnPTdGS+Qp/1js8zMjJ9OFosMO/Ap3sB
jKtw7BK0wDzWaKoOzUbAcSKhb8c0nAgEeXtWYiaKb6QRLMV1q409Sw6pGxOpZgWU
r6rB8OcBk7lFcK8rkWos9rJHybdjha+sDhhzzBC13jrg/3gIGKxel/DxLHtnUH8f
3pz7zRtRt0u1ezxxuDKJSUNmOP45uY1vLkfxdQL0KrIspJPMxV7yqBCGpt6H3/Yp
ktfGkm4dlVKOfrkwi4yUuHp5kekB2w==
=UdjP
-----END PGP SIGNATURE-----

--Sig_/Xi1Cp4gLlSyPSukUV7g=1JA--
