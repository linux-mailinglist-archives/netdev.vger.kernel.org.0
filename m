Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A2D4D3E1D
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 01:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238981AbiCJA3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 19:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238921AbiCJA3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 19:29:53 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F498E2354;
        Wed,  9 Mar 2022 16:28:53 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KDVKr2LhWz4xx3;
        Thu, 10 Mar 2022 11:28:47 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1646872128;
        bh=69IltSWc5o0iKXbctJHQdUBYwac8oILYaV3n91gri8I=;
        h=Date:From:To:Cc:Subject:From;
        b=hTY8Ri7U4WjB0W1bk7FqN2rZSsAGaqoIxJc3Y9tuyO3Ol45sNmf3rlIQn6KFRf1eO
         OhJButdlJfi68hEU+YNOiQLMbuQ1iwpl2NQOFK+YG4Mxdg52Rx2K2TuXlMC2ilB18O
         NgIGntq2o7zcdm6knd46XP3fHo+BCif5mLunHGygqCJNp24okqygsgxzv7n2fytqHz
         Ka584c2N8vlRqwpKgv/NiYx+SdW8kLbRB9kp9KrbgSpUf5ZlO2rpKe1sgKoJuJhVQx
         d/kDkck21yAJCJGV6ZnwowkVAwxrUvGvxPHuBtVAOm/4NS9t+BPgaj5TPKoW4D2rlB
         So2woaPdj6spQ==
Date:   Thu, 10 Mar 2022 11:28:43 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Dave Ertman <david.m.ertman@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Sudhansu Sekhar Mishra <sudhansu.mishra@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20220310112843.3233bcf1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/1uryEHPS3.I_=SBHeeItHFe";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/1uryEHPS3.I_=SBHeeItHFe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/intel/ice/ice.h

between commit:

  97b0129146b1 ("ice: Fix error with handling of bonding MTU")

from the net tree and commit:

  43113ff73453 ("ice: add TTY for GNSS module for E810T device")

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

diff --cc drivers/net/ethernet/intel/ice/ice.h
index 3121f9b04f59,dc42ff92dbad..000000000000
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@@ -481,9 -484,10 +484,11 @@@ enum ice_pf_flags=20
  	ICE_FLAG_LEGACY_RX,
  	ICE_FLAG_VF_TRUE_PROMISC_ENA,
  	ICE_FLAG_MDD_AUTO_RESET_VF,
+ 	ICE_FLAG_VF_VLAN_PRUNING,
  	ICE_FLAG_LINK_LENIENT_MODE_ENA,
  	ICE_FLAG_PLUG_AUX_DEV,
 +	ICE_FLAG_MTU_CHANGED,
+ 	ICE_FLAG_GNSS,			/* GNSS successfully initialized */
  	ICE_PF_FLAGS_NBITS		/* must be last */
  };
 =20

--Sig_/1uryEHPS3.I_=SBHeeItHFe
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIpRjsACgkQAVBC80lX
0Gy6Hwf7BOG+Moz1hUgilYu21YaD2/PHnmx6k1qDvhJ+bq6iquBpiMC8vxynvZ5X
Ju9+apOYo/4eZqUBspMJ/0GswRbK7/dHioCVOzOXPSDs9e+SZAu7AkkCwZoFsmXv
SldlCqaLy031k6dEgQA1VWbjveZ2X/fp9aEQKAZMogn1bW0VH0MgHl2R055Jd7df
sg+OZh7Ic+1/Dnu5CEdxRvqifomnInyq9V+9WlKILCvUrYkMsMM4wUnF+R801kA0
y3uCfaE5dKCLtdwAJ7H4OJhOKUBXrJUdhufuIVeg2L7zwQYQrTU+GrKRa3viWgpO
tqiHCETPP6KQl5kjkW2nJxRM9vrq3g==
=Ak+s
-----END PGP SIGNATURE-----

--Sig_/1uryEHPS3.I_=SBHeeItHFe--
