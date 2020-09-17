Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7035926D15C
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 04:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgIQCxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 22:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgIQCxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 22:53:00 -0400
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 22:53:00 EDT
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E96C06178B
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 19:47:41 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BsLwl3xmlz9sSW;
        Thu, 17 Sep 2020 12:47:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1600310855;
        bh=t7gDy3HQShyClQS/wpwcGgnRoswh/b2yiyij2Bde5no=;
        h=Date:From:To:Cc:Subject:From;
        b=NwK8Ztdvz3LHpJ1Q4NWQrL2uH/0YadfwrH0FFXG1s3GFPxWlUwa0+G6pmqJnml1pf
         YKoP2NpqNxPvAYhPzDOIIPtJtme4sSJHbm4mPhkymDxHCmPTW0du/TErYZpzi4kQz9
         cWyHRg7/G5ujyGXUoQMgbknMDVSaPZ2e+ws+HMMvm3sbuEv/cdcrdraFiSvQPwFv5t
         J3XUX++P+lrzFxwOtmDfvxgvnnmbOjspeP+uyruEbKiQk+OX6OTcRd0ZuO0kYNaZVv
         ZHN/aVGWx5f15hLNQgkwRMIrqVvUDUa/ysUS8xF3QX8OJR07BDBxhh9pT26kzs6Xmc
         7yPwmYajDtOEw==
Date:   Thu, 17 Sep 2020 12:47:34 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200917124734.250793b1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/gA2diz/RaKZuwM_+0YOfN6s";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/gA2diz/RaKZuwM_+0YOfN6s
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/ipv4/route.c

between commit:

  2fbc6e89b2f1 ("ipv4: Update exception handling for multipath routes via s=
ame device")

from the net tree and commit:

  8b4510d76cde ("net: gain ipv4 mtu when mtu is not locked")

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

diff --cc net/ipv4/route.c
index 58642b29a499,2c05b863ae43..000000000000
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@@ -1015,10 -1013,9 +1015,10 @@@ out:	kfree_skb(skb)
  static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u3=
2 mtu)
  {
  	struct dst_entry *dst =3D &rt->dst;
 +	struct net *net =3D dev_net(dst->dev);
- 	u32 old_mtu =3D ipv4_mtu(dst);
  	struct fib_result res;
  	bool lock =3D false;
+ 	u32 old_mtu;
 =20
  	if (ip_mtu_locked(dst))
  		return;

--Sig_/gA2diz/RaKZuwM_+0YOfN6s
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9izkYACgkQAVBC80lX
0Gz35gf/Rlg2W34UB0eBDPBQBObUB86EA4M6CjRWeXtASGMAF3mnxXGHFktCF3Jm
ykpmCHhc4pFfzaaw5L0liNj7hs3b98fnF0xwEv2ZpMRHVjcEqysAZ5DZKvMDf69X
rlwMF+fORB1kVDBbnyXFBKMaTYk8ZaNkoqo9m+z00TvwED3pbWOaRDRpR0hLUT0L
iZD/rI2pBVIbfvRUFOapd2WLheP83EjQFsHcUCz83zriWchp5l6qxLIPaQ6JN5IG
7GoH2ZOixbl1MOX/GuBouMoVzeTX1H9op39a/cGou8yedr68puzpj1am3kpm7AnH
KzWO/mOkmgFj+0GLrb5T0xGmYcs3dg==
=lrQd
-----END PGP SIGNATURE-----

--Sig_/gA2diz/RaKZuwM_+0YOfN6s--
