Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150E6697498
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 03:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbjBOC5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 21:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBOC5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 21:57:42 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FEF2B639;
        Tue, 14 Feb 2023 18:57:40 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PGjRg1rGVz4x4q;
        Wed, 15 Feb 2023 13:57:35 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1676429856;
        bh=SuXpWZnEeQFvY/oeKHZrR5GwTlkroYww7DMqncK//mk=;
        h=Date:From:To:Cc:Subject:From;
        b=M3Wfg1uf/0W5iQnJJ6oXNGFVjHfRu7odY7ooaP4Wj2qmjYPPAUs9KMv+5kbU3Sez4
         edB0V5kuibXnkusRLsVph+6gciQc7vMFhQ5EYq89pi5dQzYhkYv7IhHlkACj7/Yrz7
         p1iR/ISutxdWc89+PpTrJmOPhxsO5YQatsStwxWtrqlkpwZj7PLsmvPGMnzI+e7Apl
         xSdZOlrCEbWwz5aFp69NM8KCqGEabVJMEaZ3ql0k5UnyJvvWv0XsPgS2nddv4+Ee7M
         kw9F6J7H0mJGE3daP9aVmWsknhze4yVvFSBdg43pZbh2y2qx+d6/NXLotzcL6Edafd
         Avc9aG0h+OQyA==
Date:   Wed, 15 Feb 2023 13:57:34 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Yafang Shao <laoar.shao@gmail.com>
Subject: linux-next: manual merge of the mm tree with the bpf-next tree
Message-ID: <20230215135734.4dffcd39@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fUyJ4JZH/K==rq=60W7H0TR";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/fUyJ4JZH/K==rq=60W7H0TR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mm tree got conflicts in:

  include/linux/memcontrol.h
  mm/memcontrol.c

between commit:

  b6c1a8af5b1e ("mm: memcontrol: add new kernel parameter cgroup.memory=3Dn=
obpf")

from the bpf-next tree and commit:

  2006d382484e ("mm: memcontrol: rename memcg_kmem_enabled()")

from the mm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc include/linux/memcontrol.h
index e7310363f0cb,5567319027d1..000000000000
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@@ -1776,17 -1776,11 +1776,17 @@@ struct obj_cgroup *get_obj_cgroup_from_
  int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size);
  void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size);
 =20
 +extern struct static_key_false memcg_bpf_enabled_key;
 +static inline bool memcg_bpf_enabled(void)
 +{
 +	return static_branch_likely(&memcg_bpf_enabled_key);
 +}
 +
- extern struct static_key_false memcg_kmem_enabled_key;
+ extern struct static_key_false memcg_kmem_online_key;
 =20
- static inline bool memcg_kmem_enabled(void)
+ static inline bool memcg_kmem_online(void)
  {
- 	return static_branch_likely(&memcg_kmem_enabled_key);
+ 	return static_branch_likely(&memcg_kmem_online_key);
  }
 =20
  static inline int memcg_kmem_charge_page(struct page *page, gfp_t gfp,
@@@ -1860,12 -1854,7 +1860,12 @@@ static inline struct obj_cgroup *get_ob
  	return NULL;
  }
 =20
 +static inline bool memcg_bpf_enabled(void)
 +{
 +	return false;
 +}
 +
- static inline bool memcg_kmem_enabled(void)
+ static inline bool memcg_kmem_online(void)
  {
  	return false;
  }
diff --cc mm/memcontrol.c
index 186a3a56dd7c,3e3cdb9bed95..000000000000
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@@ -348,11 -345,8 +348,11 @@@ static void memcg_reparent_objcgs(struc
   * conditional to this static branch, we'll have to allow modules that do=
es
   * kmem_cache_alloc and the such to see this symbol as well
   */
- DEFINE_STATIC_KEY_FALSE(memcg_kmem_enabled_key);
- EXPORT_SYMBOL(memcg_kmem_enabled_key);
+ DEFINE_STATIC_KEY_FALSE(memcg_kmem_online_key);
+ EXPORT_SYMBOL(memcg_kmem_online_key);
 +
 +DEFINE_STATIC_KEY_FALSE(memcg_bpf_enabled_key);
 +EXPORT_SYMBOL(memcg_bpf_enabled_key);
  #endif
 =20
  /**

--Sig_/fUyJ4JZH/K==rq=60W7H0TR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPsSh4ACgkQAVBC80lX
0Gxa+Qf/abbZhDuKtWmpJs/t/LThpHp4uYKNTFBA66rnXueNTp2NXIZHQt4IT4Ix
btNitQjfYVfWWDfNVgBVh8jNO8qRiUqqEkXEjIjZThn0z41SzMQ0DlUS6XDOIwsY
lj1Bc4TU3JFWI7uufu5htz2qXpQKte+Zd2TC7Qy4/a6b62WHPE9KbA3ALPP77FqD
nYKkrXgygFCRggy9l80lCgNduw1Z3DT5yFkyOLaaxfHfJpxds2VCxCKgFcr+gQIN
gMqqoWUcoakXNhjnXrtxchz2YIiU7lYkOs7yyWGC6CDLtK4nNrwI/dfiKr3Hj80E
azCVuBAWa1jGN0ySrpMqIFCiVTVwfg==
=OmX7
-----END PGP SIGNATURE-----

--Sig_/fUyJ4JZH/K==rq=60W7H0TR--
