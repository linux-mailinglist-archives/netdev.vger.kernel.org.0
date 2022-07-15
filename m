Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A81F575F5C
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 12:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbiGOK3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 06:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiGOK3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 06:29:44 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5AB5D5B4;
        Fri, 15 Jul 2022 03:29:41 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LknfQ3Tg5z4xMW;
        Fri, 15 Jul 2022 20:29:34 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1657880976;
        bh=bqpck9qXiLgGXy3pehpjRmLSLJxC7X3rsD323WSFrwE=;
        h=Date:From:To:Cc:Subject:From;
        b=iPwlFZL0q5mfku7CxJ6pIAjh7bFVShunhPkIdjJmfIIcrOkV60NDkQ0Q8zFlNh84i
         mfkxazMyVXNAI/0ndvLf3NDBprpIg6XqtN2GqVVOaG79rrIRbNBpn+IQbdkkf5n5u8
         08bQFc4cmQ6g4uvixTWoDOKVwzE7mBcs9dsMAsHl/29tolTQUnTTr61UPUyCQJLscc
         2t9ZshcOGotXGIcgR046WAQTm4KCWSAxWTfdJWqdWH1MlQm8a22ZdkW+ZkJ6oIKMLr
         yu/lOC15DFrR2TiM/lZ2f0jLMU+Wo4X+Lv9leBT893GKy+DdRlFlVSZfSI6nLX6UNc
         nTfRNemNTUeow==
Date:   Fri, 15 Jul 2022 20:29:33 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Yury Norov <yury.norov@gmail.com>, Dave Airlie <airlied@linux.ie>,
        David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Matt Roper <matthew.d.roper@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ratheesh Kannoth <rkannoth@marvell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the bitmap tree
Message-ID: <20220715202933.661a3c79@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/TL/efpjyde5+J69K0R.hLrs";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/TL/efpjyde5+J69K0R.hLrs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bitmap tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/gpu/drm/i915/gt/intel_sseu.c: In function 'intel_sseu_print_ss_info=
':
drivers/gpu/drm/i915/gt/intel_sseu.c:868:52: error: format '%u' expects arg=
ument of type 'unsigned int', but argument 4 has type 'long unsigned int' [=
-Werror=3Dformat=3D]
  868 |                 seq_printf(m, "  %s Geometry DSS: %u\n", type,
      |                                                   ~^
      |                                                    |
      |                                                    unsigned int
      |                                                   %lu
  869 |                            bitmap_weight(sseu->geometry_subslice_ma=
sk.xehp,
      |                            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~
      |                            |
      |                            long unsigned int
  870 |                                          XEHP_BITMAP_BITS(sseu->geo=
metry_subslice_mask)));
      |                                          ~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/i915/gt/intel_sseu.c:871:51: error: format '%u' expects arg=
ument of type 'unsigned int', but argument 4 has type 'long unsigned int' [=
-Werror=3Dformat=3D]
  871 |                 seq_printf(m, "  %s Compute DSS: %u\n", type,
      |                                                  ~^
      |                                                   |
      |                                                   unsigned int
      |                                                  %lu
  872 |                            bitmap_weight(sseu->compute_subslice_mas=
k.xehp,
      |                            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~
      |                            |
      |                            long unsigned int
  873 |                                          XEHP_BITMAP_BITS(sseu->com=
pute_subslice_mask)));
      |                                          ~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors
In file included from include/linux/printk.h:573,
                 from include/linux/kernel.h:29,
                 from arch/x86/include/asm/percpu.h:27,
                 from arch/x86/include/asm/nospec-branch.h:14,
                 from arch/x86/include/asm/paravirt_types.h:40,
                 from arch/x86/include/asm/ptrace.h:97,
                 from arch/x86/include/asm/math_emu.h:5,
                 from arch/x86/include/asm/processor.h:13,
                 from arch/x86/include/asm/timex.h:5,
                 from include/linux/timex.h:67,
                 from include/linux/time32.h:13,
                 from include/linux/time.h:60,
                 from include/linux/stat.h:19,
                 from include/linux/module.h:13,
                 from drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_has=
h.c:9:
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c: In function 'rvu_=
npc_exact_alloc_mem_table_entry':
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:454:27: error: for=
mat '%u' expects argument of type 'unsigned int', but argument 5 has type '=
long unsigned int' [-Werror=3Dformat=3D]
  454 |         dev_dbg(rvu->dev, "%s: No space in 4 way exact way, weight=
=3D%u\n", __func__,
      |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~
include/linux/dynamic_debug.h:134:29: note: in definition of macro '__dynam=
ic_func_call'
  134 |                 func(&id, ##__VA_ARGS__);               \
      |                             ^~~~~~~~~~~
include/linux/dynamic_debug.h:166:9: note: in expansion of macro '_dynamic_=
func_call'
  166 |         _dynamic_func_call(fmt,__dynamic_dev_dbg,               \
      |         ^~~~~~~~~~~~~~~~~~
include/linux/dev_printk.h:155:9: note: in expansion of macro 'dynamic_dev_=
dbg'
  155 |         dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
      |         ^~~~~~~~~~~~~~~
include/linux/dev_printk.h:155:30: note: in expansion of macro 'dev_fmt'
  155 |         dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
      |                              ^~~~~~~
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:454:9: note: in ex=
pansion of macro 'dev_dbg'
  454 |         dev_dbg(rvu->dev, "%s: No space in 4 way exact way, weight=
=3D%u\n", __func__,
      |         ^~~~~~~
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:454:69: note: form=
at string is defined here
  454 |         dev_dbg(rvu->dev, "%s: No space in 4 way exact way, weight=
=3D%u\n", __func__,
      |                                                                    =
~^
      |                                                                    =
 |
      |                                                                    =
 unsigned int
      |                                                                    =
%lu
In file included from include/linux/device.h:15,
                 from include/linux/pci.h:37,
                 from drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_has=
h.c:10:
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c: In function 'rvu_=
npc_exact_alloc_id':
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:492:35: error: for=
mat '%d' expects argument of type 'int', but argument 4 has type 'long unsi=
gned int' [-Werror=3Dformat=3D]
  492 |                 dev_err(rvu->dev, "%s: No space in id bitmap (%d)\n=
",
      |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/dev_printk.h:110:30: note: in definition of macro 'dev_printk=
_index_wrap'
  110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                  =
     \
      |                              ^~~
include/linux/dev_printk.h:144:56: note: in expansion of macro 'dev_fmt'
  144 |         dev_printk_index_wrap(_dev_err, KERN_ERR, dev, dev_fmt(fmt)=
, ##__VA_ARGS__)
      |                                                        ^~~~~~~
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:492:17: note: in e=
xpansion of macro 'dev_err'
  492 |                 dev_err(rvu->dev, "%s: No space in id bitmap (%d)\n=
",
      |                 ^~~~~~~
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:492:64: note: form=
at string is defined here
  492 |                 dev_err(rvu->dev, "%s: No space in id bitmap (%d)\n=
",
      |                                                               ~^
      |                                                                |
      |                                                                int
      |                                                               %ld
In file included from include/linux/device.h:15,
                 from include/linux/pci.h:37,
                 from drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_has=
h.c:10:
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c: In function 'rvu_=
npc_exact_alloc_cam_table_entry':
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:525:36: error: for=
mat '%u' expects argument of type 'unsigned int', but argument 4 has type '=
long unsigned int' [-Werror=3Dformat=3D]
  525 |                 dev_info(rvu->dev, "%s: No space in exact cam table=
, weight=3D%u\n", __func__,
      |                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~
include/linux/dev_printk.h:110:30: note: in definition of macro 'dev_printk=
_index_wrap'
  110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                  =
     \
      |                              ^~~
include/linux/dev_printk.h:150:58: note: in expansion of macro 'dev_fmt'
  150 |         dev_printk_index_wrap(_dev_info, KERN_INFO, dev, dev_fmt(fm=
t), ##__VA_ARGS__)
      |                                                          ^~~~~~~
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:525:17: note: in e=
xpansion of macro 'dev_info'
  525 |                 dev_info(rvu->dev, "%s: No space in exact cam table=
, weight=3D%u\n", __func__,
      |                 ^~~~~~~~
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:525:78: note: form=
at string is defined here
  525 |                 dev_info(rvu->dev, "%s: No space in exact cam table=
, weight=3D%u\n", __func__,
      |                                                                    =
         ~^
      |                                                                    =
          |
      |                                                                    =
          unsigned int
      |                                                                    =
         %lu
cc1: all warnings being treated as errors

Caused by commit

  31563fb891aa ("lib/bitmap: change type of bitmap_weight to unsigned long")

interacting with commits

  b87d39019651 ("drm/i915/sseu: Disassociate internal subslice mask represe=
ntation from uapi")

from the drm tree and

  b747923afff8 ("octeontx2-af: Exact match support")

from the net-next tree.

I have applied the following merge resolution patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 15 Jul 2022 20:20:15 +1000
Subject: [PATCH] fix up for bitmap_weight return value changing

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/gpu/drm/i915/gt/intel_sseu.c                     | 4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_sseu.c b/drivers/gpu/drm/i915/gt=
/intel_sseu.c
index c6d3050604c8..79fa564785b6 100644
--- a/drivers/gpu/drm/i915/gt/intel_sseu.c
+++ b/drivers/gpu/drm/i915/gt/intel_sseu.c
@@ -865,10 +865,10 @@ void intel_sseu_print_ss_info(const char *type,
 	int s;
=20
 	if (sseu->has_xehp_dss) {
-		seq_printf(m, "  %s Geometry DSS: %u\n", type,
+		seq_printf(m, "  %s Geometry DSS: %lu\n", type,
 			   bitmap_weight(sseu->geometry_subslice_mask.xehp,
 					 XEHP_BITMAP_BITS(sseu->geometry_subslice_mask)));
-		seq_printf(m, "  %s Compute DSS: %u\n", type,
+		seq_printf(m, "  %s Compute DSS: %lu\n", type,
 			   bitmap_weight(sseu->compute_subslice_mask.xehp,
 					 XEHP_BITMAP_BITS(sseu->compute_subslice_mask)));
 	} else {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/dri=
vers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index 1195b690f483..2f4ce41df83c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -451,7 +451,7 @@ static int rvu_npc_exact_alloc_mem_table_entry(struct r=
vu *rvu, u8 *way,
 	}
 	mutex_unlock(&table->lock);
=20
-	dev_dbg(rvu->dev, "%s: No space in 4 way exact way, weight=3D%u\n", __fun=
c__,
+	dev_dbg(rvu->dev, "%s: No space in 4 way exact way, weight=3D%lu\n", __fu=
nc__,
 		bitmap_weight(table->mem_table.bmap, table->mem_table.depth));
 	return -ENOSPC;
 }
@@ -489,7 +489,7 @@ static bool rvu_npc_exact_alloc_id(struct rvu *rvu, u32=
 *seq_id)
 	idx =3D find_first_zero_bit(table->id_bmap, table->tot_ids);
 	if (idx =3D=3D table->tot_ids) {
 		mutex_unlock(&table->lock);
-		dev_err(rvu->dev, "%s: No space in id bitmap (%d)\n",
+		dev_err(rvu->dev, "%s: No space in id bitmap (%lu)\n",
 			__func__, bitmap_weight(table->id_bmap, table->tot_ids));
=20
 		return false;
@@ -522,7 +522,7 @@ static int rvu_npc_exact_alloc_cam_table_entry(struct r=
vu *rvu, int *index)
 	idx =3D find_first_zero_bit(table->cam_table.bmap, table->cam_table.depth=
);
 	if (idx =3D=3D table->cam_table.depth) {
 		mutex_unlock(&table->lock);
-		dev_info(rvu->dev, "%s: No space in exact cam table, weight=3D%u\n", __f=
unc__,
+		dev_info(rvu->dev, "%s: No space in exact cam table, weight=3D%lu\n", __=
func__,
 			 bitmap_weight(table->cam_table.bmap, table->cam_table.depth));
 		return -ENOSPC;
 	}
--=20
2.35.1

--=20
Cheers,
Stephen Rothwell

--Sig_/TL/efpjyde5+J69K0R.hLrs
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmLRQY0ACgkQAVBC80lX
0Gz8rgf9FGiVCloB9lKWlqt7t7b2Bw3zJC/vKBO+96jf6deD8tRNWVULtpXhYIWy
XwBOF3sNSpsTRUPjeP8S2txf9w7tysyUS7estRayi36YZZl6ExgId9luDMygO2Fp
slK/aa85/f3wd9V/UvSdPxifSc9tAmCnjOG26/F1LzG23UUbIM9DPeIBFnXa8Em9
4jgNRMbodGFgpfBV1Jw6EZ2ksCa5V9BkqJCO9IWb4CBSNpUPmdMYdcS74r0fDv6L
qdcn++AgpByRuZqfkcM9h/nXrcFrwtHneAibF4tcP22mh7aGsf5JFnzCGveSTTjG
jgIglAqjTjHVUUttbaqttddlgqzjUw==
=2+Wp
-----END PGP SIGNATURE-----

--Sig_/TL/efpjyde5+J69K0R.hLrs--
