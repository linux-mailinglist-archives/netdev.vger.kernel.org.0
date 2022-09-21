Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255A75BF287
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 03:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiIUBAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 21:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiIUBAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 21:00:38 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5EF061D61;
        Tue, 20 Sep 2022 18:00:36 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MXKpV0sl3z4xG9;
        Wed, 21 Sep 2022 11:00:34 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1663722034;
        bh=6QDTqgQo2rzctjzh9u+FzDbnJTlzeS0nFvNJBLeP5mk=;
        h=Date:From:To:Cc:Subject:From;
        b=aE5SyH0e9xmbsNVsWbSUWBAGGIbsz+x+gg26+zhumB1NVSkiizToxuNAKHstPiM1h
         Y6NcnK9kRAX5aiU4t71T/+M0/uMgysZaKFBmMIhoLkoWEkRvHPo3EG3T4dNFt6WfLt
         9Q5IsfUrfjRig60v73estJ7sfREPk8WFiPNNsxjPRSgafIte0XOmvPM1HR0ZOhW50j
         Z8X/ikWP6k00j2y7WrYBXy1yM++x98HpnDBteSYJkjB+sF4BRJU5CajYOrXfkSfa2O
         LzqWYSIO5sQDggiiLe8kHdf47ftqVjfK5KlA/YGfn3aJriZBTBXNovjbIthBRczqdt
         aeYZbo9r00Peg==
Date:   Wed, 21 Sep 2022 11:00:32 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lee Jones <lee@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with Linus' tree
Message-ID: <20220921110032.7cd28114@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fe+07vzApcqattfLvlSkYoW";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/fe+07vzApcqattfLvlSkYoW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/pinctrl/pinctrl-ocelot.c

between commit:

  c297561bc98a ("pinctrl: ocelot: Fix interrupt controller")

from Linus' tree and commit:

  181f604b33cd ("pinctrl: ocelot: add ability to be used in a non-mmio conf=
iguration")

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

diff --cc drivers/pinctrl/pinctrl-ocelot.c
index c7df8c5fe585,340ca2373429..000000000000
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@@ -2086,12 -2008,11 +2081,11 @@@ static int ocelot_pinctrl_probe(struct=20
 =20
  	regmap_config.max_register =3D OCELOT_GPIO_SD_MAP * info->stride + 15 * =
4;
 =20
- 	info->map =3D devm_regmap_init_mmio(dev, base, &regmap_config);
- 	if (IS_ERR(info->map)) {
- 		dev_err(dev, "Failed to create regmap\n");
- 		return PTR_ERR(info->map);
- 	}
+ 	info->map =3D ocelot_regmap_from_resource(pdev, 0, &regmap_config);
+ 	if (IS_ERR(info->map))
+ 		return dev_err_probe(dev, PTR_ERR(info->map),
+ 				     "Failed to create regmap\n");
 -	dev_set_drvdata(dev, info->map);
 +	dev_set_drvdata(dev, info);
  	info->dev =3D dev;
 =20
  	/* Pinconf registers */

--Sig_/fe+07vzApcqattfLvlSkYoW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMqYjAACgkQAVBC80lX
0Gz5DQf/fS1TWtxqM96KbnLu2AF/xad+FxkQoBTmqhkj9GbHLheRPdGFHtL+wT9S
Dzl5jze9VRm1e4PuUflh/h+Ht8R4tXzF7v139xmVB7hdMa9Lue64EFODD7GacmgU
qSGVQq3FEIikmb/jcwMfWaTu4mSP6blLMub/GH1UTAB+hG7XhS0SduccmwBKsDob
lfluLbgaIntrxVYEJeGn2hOX+iCLFOWxYqxVIqjDYE0I86p6DJtAWfB5254HtIpf
9hEki4ujTGRhZOsVTJZiytHiflD7yGVG3dFT/Qd0DspvXd8clqW+h67sgU5Nc3RE
VKvHZvf5aMfAdT1ekktp+I86qqInJg==
=YIJC
-----END PGP SIGNATURE-----

--Sig_/fe+07vzApcqattfLvlSkYoW--
