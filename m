Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9496B8660
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjCMXye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjCMXy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:54:29 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183D619F1E;
        Mon, 13 Mar 2023 16:54:26 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PbD5q6gSmz4whr;
        Tue, 14 Mar 2023 10:54:22 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1678751665;
        bh=T0N+rXIbClzSIFFsBqWugRWo9U1U5OtD1gue76ktyYo=;
        h=Date:From:To:Cc:Subject:From;
        b=IodiPqO7SvTvCuvWRiCg3vHnSD9pqmlmnKqxXYjtntkJmSuX9gf5XRDMJafIYV1M8
         G5EOBBisIhXhTt/6S+vqgy9UkawFueBq1Jb7ouj9HjRrS7qM66sR2sowJlQIYVTYt6
         WzzO4VsBNgoIdQZ9xxLKip1UUFZZOekNf11jANuUqxelBUQc+N7jZ1/WXcnC88BZa7
         FYbIso6E5pIuwwJ1vVKj951EeaSPQEuG4MpDIWLgkKtryuYuQJ+CXScP4MW+iwgmGz
         ZOKF9cG7rQMytn3pxWG5TzcqUO7faqN9jqphb3fHhHeJH1rzNCl/TfebqrFsYpdnyM
         L6Z5cQeSnPLbg==
Date:   Tue, 14 Mar 2023 10:54:21 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        Avraham Stern <avraham.stern@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20230314105421.3608efae@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/MEZkc5nIJ4_ySymOX4LxTp.";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/MEZkc5nIJ4_ySymOX4LxTp.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/wireless/nl80211.c

between commit:

  b27f07c50a73 ("wifi: nl80211: fix puncturing bitmap policy")

from the net tree and commit:

  cbbaf2bb829b ("wifi: nl80211: add a command to enable/disable HW timestam=
ping")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

Thanks for the heads up.

--=20
Cheers,
Stephen Rothwell

diff --cc net/wireless/nl80211.c
index 4f63059efd81,0a31b1d2845d..000000000000
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@@ -810,8 -805,10 +810,11 @@@ static const struct nla_policy nl80211_
  	[NL80211_ATTR_MLD_ADDR] =3D NLA_POLICY_EXACT_LEN(ETH_ALEN),
  	[NL80211_ATTR_MLO_SUPPORT] =3D { .type =3D NLA_FLAG },
  	[NL80211_ATTR_MAX_NUM_AKM_SUITES] =3D { .type =3D NLA_REJECT },
 -	[NL80211_ATTR_PUNCT_BITMAP] =3D NLA_POLICY_RANGE(NLA_U8, 0, 0xffff),
 +	[NL80211_ATTR_PUNCT_BITMAP] =3D
 +		NLA_POLICY_FULL_RANGE(NLA_U32, &nl80211_punct_bitmap_range),
+=20
+ 	[NL80211_ATTR_MAX_HW_TIMESTAMP_PEERS] =3D { .type =3D NLA_U16 },
+ 	[NL80211_ATTR_HW_TIMESTAMP_ENABLED] =3D { .type =3D NLA_FLAG },
  };
 =20
  /* policy for the key attributes */

--Sig_/MEZkc5nIJ4_ySymOX4LxTp.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmQPt60ACgkQAVBC80lX
0GzG0Qf/S/+TJT8EYGeMTSio88Y3eGykDwxmvZpm1MTYQ4MoYkNVQJvq8fulq7Ee
1srl8kfjYJQ6/usDxPNXuzY6rbLvD/aKQ6A4uxF3Oj+G4tJ5w09l42KX6rl2U6zs
sW02ofFCrbhOTM4HVMWtlg4YADo8djPPK9cltHF56i8bZttY1gfHi1Ga9Jp+N8A5
c5dLgPtEInnlN0AKhd3YxnhmldL9IoqEQLjPzBrORj2YlN2a6f78eIBawgeYbW9d
v7EE5fnbGSSFOjCm140Pa/vXZws/sMAWyTo0/fftOfBjI0WmVd9socANHKS9ABWw
FM7I4tRzkkPLewTlTjivu1fv5Zj/0Q==
=PA4D
-----END PGP SIGNATURE-----

--Sig_/MEZkc5nIJ4_ySymOX4LxTp.--
