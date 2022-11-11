Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF5D624F4A
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 02:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbiKKBOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 20:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbiKKBNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 20:13:43 -0500
Received: from tarta.nabijaczleweli.xyz (unknown [139.28.40.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 37130A47D;
        Thu, 10 Nov 2022 17:13:42 -0800 (PST)
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
        by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id 766A4A18;
        Fri, 11 Nov 2022 02:13:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
        s=202211; t=1668129221;
        bh=CLNSvc89ZjC9lbK/GTozDbmxsjEnpiPpGv/XJ9hwdJQ=;
        h=Date:From:Cc:Subject:References:In-Reply-To:From;
        b=RX1RxBik8iPH4VuXBVnzZryq49kWAjE15EFD/Cq5OThuHcpOX0A9GGvugUSQPhCEj
         UlPWpf+eDBfGrdsOjuVr7o20dWdxYxPmDxC3eaqEUhGMYjMs9/kTEbXfjmO3z8CIO3
         aSowIpiWZqKHp3HFMdUHcIMy9JWNEIaMBU89bgfQJO9OhErLUg3Wz1Slr59e26CTZh
         VLLCCnYYxlh8QwWhJS549CVm9b118C7DPhiI6fMd2cmal+pz3T55acxi26nxs/+0MF
         BhVc7Tkgys+en6Zrlt7hT5zS2UKXEk5wpquOgZEqPDBLu7ZcdS/9gtm+5C2ba+GJqc
         cvtph5HyEkD4Q==
Date:   Fri, 11 Nov 2022 02:13:40 +0100
From:   Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= 
        <nabijaczleweli@nabijaczleweli.xyz>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Thomas Sailer <t.sailer@alumni.ethz.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 01/15] hamradio: baycom: remove BAYCOM_MAGIC
Message-ID: <eb74a21919c64e85d91a9f8bd74cc31e3416bd89.1668128257.git.nabijaczleweli@nabijaczleweli.xyz>
References: <cover.1668128257.git.nabijaczleweli@nabijaczleweli.xyz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="c64z323at4b56yfc"
Content-Disposition: inline
In-Reply-To: <cover.1668128257.git.nabijaczleweli@nabijaczleweli.xyz>
User-Agent: NeoMutt/20220429
X-Spam-Status: No, score=1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        MISSING_HEADERS,PDS_OTHER_BAD_TLD,PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--c64z323at4b56yfc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Before being defanged in v2.6.12-rc1, the magic was validated on each
netdev_priv() invocation; after, it's set exactly once per port on probe
and checked exactly once per port on unload: it's useless. Kill it.

Notably, magic-number.rst has never had the right value for it with the
new-in-Linux-2.1.105 network-based driver, rendering this documentation
worse than useless.

Link: https://lore.kernel.org/linux-doc/YyMlovoskUcHLEb7@kroah.com/
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Ahelenia Ziemia=C5=84ska <nabijaczleweli@nabijaczleweli.xyz>
---
 Documentation/process/magic-number.rst            |  1 -
 .../translations/it_IT/process/magic-number.rst   |  1 -
 .../translations/zh_CN/process/magic-number.rst   |  1 -
 .../translations/zh_TW/process/magic-number.rst   |  1 -
 drivers/net/hamradio/baycom_epp.c                 | 15 ++-------------
 5 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/Documentation/process/magic-number.rst b/Documentation/process=
/magic-number.rst
index 64b5948fc1d4..87353e0207c1 100644
--- a/Documentation/process/magic-number.rst
+++ b/Documentation/process/magic-number.rst
@@ -73,7 +73,6 @@ APM_BIOS_MAGIC        0x4101           apm_user          =
       ``arch/x86/kerne
 FASYNC_MAGIC          0x4601           fasync_struct            ``include/=
linux/fs.h``
 SLIP_MAGIC            0x5302           slip                     ``drivers/=
net/slip.h``
 MGSLPC_MAGIC          0x5402           mgslpc_info              ``drivers/=
char/pcmcia/synclink_cs.c``
-BAYCOM_MAGIC          0x19730510       baycom_state             ``drivers/=
net/baycom_epp.c``
 HDLCDRV_MAGIC         0x5ac6e778       hdlcdrv_state            ``include/=
linux/hdlcdrv.h``
 KV_MAGIC              0x5f4b565f       kernel_vars_s            ``arch/mip=
s/include/asm/sn/klkernvars.h``
 CODA_MAGIC            0xC0DAC0DA       coda_file_info           ``fs/coda/=
coda_fs_i.h``
diff --git a/Documentation/translations/it_IT/process/magic-number.rst b/Do=
cumentation/translations/it_IT/process/magic-number.rst
index 02eb7eb2448e..a96712bd8a68 100644
--- a/Documentation/translations/it_IT/process/magic-number.rst
+++ b/Documentation/translations/it_IT/process/magic-number.rst
@@ -79,7 +79,6 @@ APM_BIOS_MAGIC        0x4101           apm_user          =
       ``arch/x86/kerne
 FASYNC_MAGIC          0x4601           fasync_struct            ``include/=
linux/fs.h``
 SLIP_MAGIC            0x5302           slip                     ``drivers/=
net/slip.h``
 MGSLPC_MAGIC          0x5402           mgslpc_info              ``drivers/=
char/pcmcia/synclink_cs.c``
-BAYCOM_MAGIC          0x19730510       baycom_state             ``drivers/=
net/baycom_epp.c``
 HDLCDRV_MAGIC         0x5ac6e778       hdlcdrv_state            ``include/=
linux/hdlcdrv.h``
 KV_MAGIC              0x5f4b565f       kernel_vars_s            ``arch/mip=
s/include/asm/sn/klkernvars.h``
 CODA_MAGIC            0xC0DAC0DA       coda_file_info           ``fs/coda/=
coda_fs_i.h``
diff --git a/Documentation/translations/zh_CN/process/magic-number.rst b/Do=
cumentation/translations/zh_CN/process/magic-number.rst
index 0617ce125e12..44f3a29fce57 100644
--- a/Documentation/translations/zh_CN/process/magic-number.rst
+++ b/Documentation/translations/zh_CN/process/magic-number.rst
@@ -62,7 +62,6 @@ APM_BIOS_MAGIC        0x4101           apm_user          =
       ``arch/x86/kerne
 FASYNC_MAGIC          0x4601           fasync_struct            ``include/=
linux/fs.h``
 SLIP_MAGIC            0x5302           slip                     ``drivers/=
net/slip.h``
 MGSLPC_MAGIC          0x5402           mgslpc_info              ``drivers/=
char/pcmcia/synclink_cs.c``
-BAYCOM_MAGIC          0x19730510       baycom_state             ``drivers/=
net/baycom_epp.c``
 HDLCDRV_MAGIC         0x5ac6e778       hdlcdrv_state            ``include/=
linux/hdlcdrv.h``
 KV_MAGIC              0x5f4b565f       kernel_vars_s            ``arch/mip=
s/include/asm/sn/klkernvars.h``
 CODA_MAGIC            0xC0DAC0DA       coda_file_info           ``fs/coda/=
coda_fs_i.h``
diff --git a/Documentation/translations/zh_TW/process/magic-number.rst b/Do=
cumentation/translations/zh_TW/process/magic-number.rst
index f3f7082e17c6..0fde3183e82a 100644
--- a/Documentation/translations/zh_TW/process/magic-number.rst
+++ b/Documentation/translations/zh_TW/process/magic-number.rst
@@ -65,7 +65,6 @@ APM_BIOS_MAGIC        0x4101           apm_user          =
       ``arch/x86/kerne
 FASYNC_MAGIC          0x4601           fasync_struct            ``include/=
linux/fs.h``
 SLIP_MAGIC            0x5302           slip                     ``drivers/=
net/slip.h``
 MGSLPC_MAGIC          0x5402           mgslpc_info              ``drivers/=
char/pcmcia/synclink_cs.c``
-BAYCOM_MAGIC          0x19730510       baycom_state             ``drivers/=
net/baycom_epp.c``
 HDLCDRV_MAGIC         0x5ac6e778       hdlcdrv_state            ``include/=
linux/hdlcdrv.h``
 KV_MAGIC              0x5f4b565f       kernel_vars_s            ``arch/mip=
s/include/asm/sn/klkernvars.h``
 CODA_MAGIC            0xC0DAC0DA       coda_file_info           ``fs/coda/=
coda_fs_i.h``
diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/bayco=
m_epp.c
index 791b4a53d69f..8f018703e74d 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -45,13 +45,9 @@
 /* --------------------------------------------------------------------- */
=20
 #define BAYCOM_DEBUG
-#define BAYCOM_MAGIC 19730510
=20
 /* --------------------------------------------------------------------- */
=20
-static const char paranoia_str[] =3D KERN_ERR=20
-	"baycom_epp: bad magic number for hdlcdrv_state struct in routine %s\n";
-
 static const char bc_drvname[] =3D "baycom_epp";
 static const char bc_drvinfo[] =3D KERN_INFO "baycom_epp: (C) 1998-2000 Th=
omas Sailer, HB9JNX/AE4WA\n"
 "baycom_epp: version 0.7\n";
@@ -152,8 +148,6 @@ static struct net_device *baycom_device[NR_PORTS];
  */
=20
 struct baycom_state {
-	int magic;
-
         struct pardevice *pdev;
 	struct net_device *dev;
 	unsigned int work_running;
@@ -1210,7 +1204,6 @@ static void __init baycom_epp_dev_setup(struct net_de=
vice *dev)
 	 * initialize part of the baycom_state struct
 	 */
 	bc->dev =3D dev;
-	bc->magic =3D BAYCOM_MAGIC;
 	bc->cfg.fclk =3D 19666600;
 	bc->cfg.bps =3D 9600;
 	/*
@@ -1279,12 +1272,8 @@ static void __exit cleanup_baycomepp(void)
 		struct net_device *dev =3D baycom_device[i];
=20
 		if (dev) {
-			struct baycom_state *bc =3D netdev_priv(dev);
-			if (bc->magic =3D=3D BAYCOM_MAGIC) {
-				unregister_netdev(dev);
-				free_netdev(dev);
-			} else
-				printk(paranoia_str, "cleanup_module");
+			unregister_netdev(dev);
+			free_netdev(dev);
 		}
 	}
 	parport_unregister_driver(&baycom_epp_par_driver);
--=20
2.30.2

--c64z323at4b56yfc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmNtocQACgkQvP0LAY0m
WPHDVhAAstg9jWXp75Un6VrU+otwggCOvW+M2Y0a4dgC/YNA7mLtd54EZGqHYHH+
AzS0CeTCFzX3gbBEuvo11aaHYYzG8ooUXPKwjfSkUkuV1RFkuyuY0BzoLArZwWXT
/TLR7cC9YEXy8y8j48LNgf7YEq1/XY5NJObdtvRXcGE4aNGXX5K9RL9UCpZwRfw/
N8yDZCAYFi70QplXy3HZbYy6DUK+BquvaGzh7gBhNMzTxmtnr9RtSBlFfdLx/0mU
zfSwDzzc425QJLJDYWpr+CZ/8UARKC/j7SMtWjbczXwYd1w8wgYJehpbirsJ/b58
SARsa4ZQHLWuuKmHzBVNjMuz+R1biGqSD/gFvq7xkFx+YEPhKOX3uL3wnPWaPSDq
WCUqTCuCMZIl3KI2K+Y1RLxdI7kpCNROqnjkBncmaMmW2rUjB7F48SRQ8OLm39G6
xbFbcbMaczIk5rzYPWQQ2mrUHu5eKZDvWNsbwWMbMI/vZ9Vm8v45gNCFVJ4T3ctA
cfwqS7GxPLppnQ3hg+bCKVMTEn12RqjGoMbm5JNRoYLUwtUHdL/dqR3KR5A1AFWx
qvRMiJO+qasM4newd6odxgV+uNB51pWZkdzxk3utZEsWdLatCbrP6hZo+/ufSvyk
wnI9am21xxUzfd41vaJn2v5cMT7Jm64/jKhvV+HcXBmuzqGqlmQ=
=50/v
-----END PGP SIGNATURE-----

--c64z323at4b56yfc--
