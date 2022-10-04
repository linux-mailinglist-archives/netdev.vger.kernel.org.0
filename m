Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEAA5F3AEF
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 03:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiJDBLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 21:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJDBLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 21:11:14 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C3114090;
        Mon,  3 Oct 2022 18:11:12 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MhKQj3bzdz4xDn;
        Tue,  4 Oct 2022 12:11:08 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1664845870;
        bh=4bxGGTMu13dnzgcclih/sMnhB87pdwZTVYBryKLacfM=;
        h=Date:From:To:Cc:Subject:From;
        b=mWTId7ahfCfMzPw2a49aCYdf6WwXNHf1n1pmVk41eQfq29kK2eCLUo8mvaG2BkTF2
         7/OS8n5CpzRpf7GKkQ5DGJICWqQx6ojBp3jrs+afkMENfl0bvRNoCnMuY/Em78igEW
         D2juG/NlelyXwzO9p6xLifoJ8B5QzEGRTPCc2LdtisgyySHcyjIRCizHNlTcLMFxoN
         ZHiJD8mqKxQd7ufcez4SZZBYwkI/IH7hO52on0nLOzQlW/m7Y0iDRLRcw/aBFdaU/h
         ya74/C0WrTdW3neZYm1wV1hAOFZ+0MQQXrZdsQYpaB72EY1xAwDrVXpNNkpxAkbRyT
         JD7dbiWeuLeFQ==
Date:   Tue, 4 Oct 2022 12:11:07 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20221004121107.5dd88137@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ytz3KZpvQ.5sKo4TD9BZxs8";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ytz3KZpvQ.5sKo4TD9BZxs8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/mediatek/mtk_ppe.c

between commit:

  ae3ed15da588 ("net: ethernet: mtk_eth_soc: fix state in __mtk_foe_entry_c=
lear")

from the net tree and commit:

  9d8cb4c096ab ("net: ethernet: mtk_eth_soc: add foe_entry_size to mtk_eth_=
soc")

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

diff --cc drivers/net/ethernet/mediatek/mtk_ppe.c
index 148ea636ef97,887f430734f7..000000000000
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@@ -410,9 -439,10 +439,10 @@@ __mtk_foe_entry_clear(struct mtk_ppe *p
 =20
  	hlist_del_init(&entry->list);
  	if (entry->hash !=3D 0xffff) {
- 		ppe->foe_table[entry->hash].ib1 &=3D ~MTK_FOE_IB1_STATE;
- 		ppe->foe_table[entry->hash].ib1 |=3D FIELD_PREP(MTK_FOE_IB1_STATE,
- 							      MTK_FOE_STATE_INVALID);
+ 		struct mtk_foe_entry *hwe =3D mtk_foe_get_entry(ppe, entry->hash);
+=20
+ 		hwe->ib1 &=3D ~MTK_FOE_IB1_STATE;
 -		hwe->ib1 |=3D FIELD_PREP(MTK_FOE_IB1_STATE, MTK_FOE_STATE_UNBIND);
++		hwe->ib1 |=3D FIELD_PREP(MTK_FOE_IB1_STATE, MTK_FOE_STATE_INVALID);
  		dma_wmb();
  	}
  	entry->hash =3D 0xffff;

--Sig_/ytz3KZpvQ.5sKo4TD9BZxs8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmM7iCsACgkQAVBC80lX
0GxqwQf/b9X9UC3jX2gauCcSua8eTT/iCI862eJjxtrZMhCqHY1hrAPgxzP7ZjeY
MouzU+PcAzPxI/p5PfM+B9wCL2dZ4LKkk5ifcgfhHWHSkzSIwNRIL3Clf20eFWrg
p7JCoh/VmSNKfnAnk4vWSBuGfPUVO29D/3gOWBYDPFe17IvdP1XdoUdSFhhWEoru
iegtfRQP+h8aPR6H3FT1kcMFq6dpaehg+dEyvZZw9tAJ5JOoG8pcOC7Y9LAKs24q
+uzVYSmqNc5TX9W6IhBmCa/ytrTfRnB7FrU8gJtXE+nja3AmGxHRajMp3Owim0zD
nw39Unc+ksAi/6KwDw6pTBWpnUDmgg==
=jUVy
-----END PGP SIGNATURE-----

--Sig_/ytz3KZpvQ.5sKo4TD9BZxs8--
