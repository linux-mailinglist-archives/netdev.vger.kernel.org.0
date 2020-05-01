Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFEB41C0C3C
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 04:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgEACl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 22:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728012AbgEACl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 22:41:57 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD18C035494;
        Thu, 30 Apr 2020 19:41:56 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49CxNJ3jFWz9sRY;
        Fri,  1 May 2020 12:41:52 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1588300913;
        bh=vUF1fXtpIoKJqTpWNPfnW5x1ycGQaYIW4GV4pb93qXc=;
        h=Date:From:To:Cc:Subject:From;
        b=eYQGDTA5bAn1VyClZ0fNAx5OdZYWL7oQpEyFqoVf4TzPe0s5C/c/tCTWzlMGq2a9e
         cNOndxGtbxPmcYFP25SMc2377uPhkYmFeqGFm6+7NvdofhFgTM/d0e5lYsPkhRZb+/
         xm3LjcNaawsUFIZenbrosq2BpotdqnBmzmdp1tysxHGOd49PbB0qV7L1qfRcG8WCFg
         /j2dqeLZ6fjlv/PkYZtviUjgAiOYwwn4japLnJepnvsnHQiOM57oBHa8OuKzo62H36
         x0ulcWE3Pm37QeBDX70AFic6q1T4mrYL3OiFimNwyc1NIyuyhhSPCD7C07D8TShmcz
         lhlYB61z6GvKw==
Date:   Fri, 1 May 2020 12:41:16 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200501124116.794c82ee@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/hudxFM=ID.usjgK48nTX2ne";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/hudxFM=ID.usjgK48nTX2ne
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  include/net/mptcp.h

between commit:

  cfde141ea3fa ("mptcp: move option parsing into mptcp_incoming_options()")

from the net tree and commit:

  071c8ed6e88d ("tcp: mptcp: use mptcp receive buffer space to select rcv w=
indow")

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

diff --cc include/net/mptcp.h
index 3bce2019e4da,5288fba56e55..000000000000
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@@ -68,8 -68,13 +68,10 @@@ static inline bool rsk_is_mptcp(const s
  	return tcp_rsk(req)->is_mptcp;
  }
 =20
+ void mptcp_space(const struct sock *ssk, int *space, int *full_space);
+=20
 -void mptcp_parse_option(const struct sk_buff *skb, const unsigned char *p=
tr,
 -			int opsize, struct tcp_options_received *opt_rx);
  bool mptcp_syn_options(struct sock *sk, const struct sk_buff *skb,
  		       unsigned int *size, struct mptcp_out_options *opts);
 -void mptcp_rcv_synsent(struct sock *sk);
  bool mptcp_synack_options(const struct request_sock *req, unsigned int *s=
ize,
  			  struct mptcp_out_options *opts);
  bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,

--Sig_/hudxFM=ID.usjgK48nTX2ne
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6rjEwACgkQAVBC80lX
0GyeTwgAkps7ZAfwWEf59WesPtHVUi1cy4pZ/UwKctzDHiMSKSM7I7/mKbVNrCdn
EdYo1zRxM6tbmXXdWxAA8Q3ab/3DPq10z6BiBuI9/qift1fZ3k2G8ZS0JYl6sE2s
rf83xx1SPB2ls1f+tif7ZG+tXzMLI8NszDBYjd4w/gsVDtE/OJ+3dykl5Z1pr2M4
1OLHb+c5h0MdFJAlbFwVs/xKFeabQn1CViBpIsW6khv4sm4TLVhgUjUvj3WRw1zO
ICvFfNtGDe7H9LTv3LNqOPSTTHaCgJ092VrMZWnUR83J7lHMM6q69Kz7OUkEDT/M
P+Xo6QFhk1mUsEScoh49jKwPhJ+d4Q==
=90ZQ
-----END PGP SIGNATURE-----

--Sig_/hudxFM=ID.usjgK48nTX2ne--
