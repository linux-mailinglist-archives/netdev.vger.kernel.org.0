Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E7231C53F
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 03:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhBPCFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 21:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhBPCFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 21:05:44 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A447CC061574;
        Mon, 15 Feb 2021 18:05:03 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DfknH0vRTz9sVR;
        Tue, 16 Feb 2021 13:04:50 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1613441099;
        bh=kvCcIU1t45YHZth8tA+kMgS21Ahdt4LFOatlqMWBQIQ=;
        h=Date:From:To:Cc:Subject:From;
        b=We+Qpfac7qm3Mp5ItKtb5TTIfodvAOIkocJ6SU5VlNwKRZj6l/NgLEtrIG8y4WKCm
         suJ94IcSj8Kcu8C0oAszGY72GdXgNa4V/XiNJSuoRTZmgpXRSau3HZcXRiAJqSrPdo
         V/ag24wa4yePGUr/w3l3LwHdVvcTMsubOzC3XbgN8iJ+BgdEEy8JSYGA18Avoaxt0v
         07COM7yOzyPBJRbLrW/48a5NB4zHXp3H0fn+kIo0e6xCTStf3Cahc6dPt9dpOnQ4oh
         uveoa6ZqNJjpvgAoU0ZHMPMHBjqddZ9yk82f36c01/mT/GX6tz8E/O9ZzjcbjnlYEU
         1SzCkfymJQOpw==
Date:   Tue, 16 Feb 2021 13:04:49 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        ARM <linux-arm-kernel@lists.infradead.org>
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: linux-next: manual merge of the net-next tree with the arm-soc tree
Message-ID: <20210216130449.3d1f0338@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/LZtJ7tX3KO73GqKh+6aYHk0";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/LZtJ7tX3KO73GqKh+6aYHk0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got conflicts in:

  arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts
  arch/arm64/boot/dts/toshiba/tmpv7708.dtsi

between commits:

  4fd18fc38757 ("arm64: dts: visconti: Add watchdog support for TMPV7708 So=
C")
  0109a17564fc ("arm: dts: visconti: Add DT support for Toshiba Visconti5 G=
PIO driver")

from the arm-soc tree and commit:

  ec8a42e73432 ("arm: dts: visconti: Add DT support for Toshiba Visconti5 e=
thernet controller")

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

diff --cc arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts
index 2407b2d89c1e,48fa8776e36f..000000000000
--- a/arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts
+++ b/arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts
@@@ -42,11 -42,20 +42,29 @@@
  	clock-names =3D "apb_pclk";
  };
 =20
 +&wdt {
 +	status =3D "okay";
 +	clocks =3D <&wdt_clk>;
 +};
 +
 +&gpio {
 +	status =3D "okay";
++};`
++
+ &piether {
+ 	status =3D "okay";
+ 	phy-handle =3D <&phy0>;
+ 	phy-mode =3D "rgmii-id";
+ 	clocks =3D <&clk300mhz>, <&clk125mhz>;
+ 	clock-names =3D "stmmaceth", "phy_ref_clk";
+=20
+ 	mdio0 {
+ 		#address-cells =3D <1>;
+ 		#size-cells =3D <0>;
+ 		compatible =3D "snps,dwmac-mdio";
+ 		phy0: ethernet-phy@1 {
+ 			device_type =3D "ethernet-phy";
+ 			reg =3D <0x1>;
+ 		};
+ 	};
  };
diff --cc arch/arm64/boot/dts/toshiba/tmpv7708.dtsi
index 4264f3e6ac9c,3366786699fc..000000000000
--- a/arch/arm64/boot/dts/toshiba/tmpv7708.dtsi
+++ b/arch/arm64/boot/dts/toshiba/tmpv7708.dtsi
@@@ -134,12 -134,20 +134,26 @@@
  		#clock-cells =3D <0>;
  	};
 =20
 +	wdt_clk: wdt-clk {
 +		compatible =3D "fixed-clock";
 +		clock-frequency =3D <150000000>;
 +		#clock-cells =3D <0>;
 +	};
 +
+ 	clk125mhz: clk125mhz {
+ 		compatible =3D "fixed-clock";
+ 		clock-frequency =3D <125000000>;
+ 		#clock-cells =3D <0>;
+ 		clock-output-names =3D "clk125mhz";
+ 	};
+=20
+ 	clk300mhz: clk300mhz {
+ 		compatible =3D "fixed-clock";
+ 		clock-frequency =3D <300000000>;
+ 		#clock-cells =3D <0>;
+ 		clock-output-names =3D "clk300mhz";
+ 	};
+=20
  	soc {
  		#address-cells =3D <2>;
  		#size-cells =3D <2>;
@@@ -402,11 -399,16 +416,22 @@@
  			status =3D "disabled";
  		};
 =20
 +		wdt: wdt@28330000 {
 +			compatible =3D "toshiba,visconti-wdt";
 +			reg =3D <0 0x28330000 0 0x1000>;
 +			status =3D "disabled";
 +		};
++
+ 		piether: ethernet@28000000 {
+ 			compatible =3D "toshiba,visconti-dwmac", "snps,dwmac-4.20a";
+ 			reg =3D <0 0x28000000 0 0x10000>;
+ 			interrupts =3D <GIC_SPI 156 IRQ_TYPE_LEVEL_HIGH>;
+ 			interrupt-names =3D "macirq";
+ 			snps,txpbl =3D <4>;
+ 			snps,rxpbl =3D <4>;
+ 			snps,tso;
+ 			status =3D "disabled";
+ 		};
  	};
  };
 =20

--Sig_/LZtJ7tX3KO73GqKh+6aYHk0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmArKEIACgkQAVBC80lX
0GxUgAf/Xo7rh9vMOYzUGBvGckdIQeqet/arxxs3LaHOteUk55CqPywpESGYqh4z
cbz4gopENeufOenC/l0p6F+uNkoNcmUhBKUrPivzSBxxvA3DQeNG2uJoI/oeYbJj
gJJTxSx836S9aSJ3Kx2ZrTHJwG2v8YCtqPwNuJA4up4pIIeoyWQ2aDaPeEGNviuv
1nqyU3h0ShrHv4AjDC1KQx/QPQejT4d1s1Meh+Xxo61yqxLT0+vx6WGDLYID245M
jBOY+M0ELUMweqI/E8hOqZdFHXr3bRpA6OqYXQQZbd0SZoffZTkjSvsJb8eOutrW
1A/HkDpwD1Sl81l9umDkE8/yJ9y1cw==
=bDdD
-----END PGP SIGNATURE-----

--Sig_/LZtJ7tX3KO73GqKh+6aYHk0--
