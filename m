Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4BA8624F6A
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 02:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbiKKBQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 20:16:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbiKKBPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 20:15:15 -0500
Received: from tarta.nabijaczleweli.xyz (unknown [139.28.40.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75B002124C;
        Thu, 10 Nov 2022 17:14:40 -0800 (PST)
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
        by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id C64A8452;
        Fri, 11 Nov 2022 02:14:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
        s=202211; t=1668129279;
        bh=XRnEX2VezQMkuazgxD7F8iFgqKQr9+bZpaNouakmEn4=;
        h=Date:From:Cc:Subject:References:In-Reply-To:From;
        b=LoOr1h5IxF2I5nvfVnHWo1iw273I5Po3fHa1P7xCk5EA0g2b48QrUQJzChJVVQjvj
         75guOspF4pBnL3khWq7Na/Vye65srHFSgNs+4VrQYbjJMvwCrZFF7VxliDNjvE6a+I
         5rGAfWL5BH8T7RX0TKtRGOKVrcJYxkqD+1gYwHTZirHOG/HSlc/EE96esqbruDZrpn
         Ft6+M61tZ+P1Ps1tyNdQfYEbDo4i3Bl/owITyxyDYdr7m6CqNj7usMwkOhGgJ1h9au
         tWxo57/wAGXRdNXJ+aFm/GENBSYsCK5LfsK09ULo1AkEuzwWqkkMUvPIjtyWNL3xb2
         84hhtoBc1mr+Q==
Date:   Fri, 11 Nov 2022 02:14:38 +0100
From:   Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= 
        <nabijaczleweli@nabijaczleweli.xyz>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Duoming Zhou <duoming@zju.edu.cn>,
        Huang Pei <huangpei@loongson.cn>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH v3 12/15] drivers: net: slip: remove SLIP_MAGIC
Message-ID: <570435f7a54ff9fbb55a7e970ae8f082b88a6454.1668128257.git.nabijaczleweli@nabijaczleweli.xyz>
References: <cover.1668128257.git.nabijaczleweli@nabijaczleweli.xyz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uvnkwibhrdezqczq"
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


--uvnkwibhrdezqczq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

According to Greg, in the context of magic numbers as defined in
magic-number.rst, "the tty layer should not need this and I'll gladly
take patches".

We have largely moved away from this approach, and we have better
debugging instrumentation nowadays: kill it.

Additionally, all SLIP_MAGIC checks just early-exit instead of noting
the bug, so they're detrimental, if anything.

Link: https://lore.kernel.org/linux-doc/YyMlovoskUcHLEb7@kroah.com/
Reviewed-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Ahelenia Ziemia=C5=84ska <nabijaczleweli@nabijaczleweli.xyz>
---
 Documentation/process/magic-number.rst                |  1 -
 .../translations/it_IT/process/magic-number.rst       |  1 -
 .../translations/zh_CN/process/magic-number.rst       |  1 -
 .../translations/zh_TW/process/magic-number.rst       |  1 -
 drivers/net/slip/slip.c                               | 11 +++++------
 drivers/net/slip/slip.h                               |  4 ----
 6 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/Documentation/process/magic-number.rst b/Documentation/process=
/magic-number.rst
index 3b3e607e1cbc..e59c707ec785 100644
--- a/Documentation/process/magic-number.rst
+++ b/Documentation/process/magic-number.rst
@@ -69,6 +69,5 @@ Changelog::
 Magic Name            Number           Structure                File
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 FASYNC_MAGIC          0x4601           fasync_struct            ``include/=
linux/fs.h``
-SLIP_MAGIC            0x5302           slip                     ``drivers/=
net/slip.h``
 CCB_MAGIC             0xf2691ad2       ccb                      ``drivers/=
scsi/ncr53c8xx.c``
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
diff --git a/Documentation/translations/it_IT/process/magic-number.rst b/Do=
cumentation/translations/it_IT/process/magic-number.rst
index e8c659b6a743..37a539867b6f 100644
--- a/Documentation/translations/it_IT/process/magic-number.rst
+++ b/Documentation/translations/it_IT/process/magic-number.rst
@@ -75,6 +75,5 @@ Registro dei cambiamenti::
 Nome magico           Numero           Struttura                File
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 FASYNC_MAGIC          0x4601           fasync_struct            ``include/=
linux/fs.h``
-SLIP_MAGIC            0x5302           slip                     ``drivers/=
net/slip.h``
 CCB_MAGIC             0xf2691ad2       ccb                      ``drivers/=
scsi/ncr53c8xx.c``
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
diff --git a/Documentation/translations/zh_CN/process/magic-number.rst b/Do=
cumentation/translations/zh_CN/process/magic-number.rst
index 2105af32187c..8a3a3e872c52 100644
--- a/Documentation/translations/zh_CN/process/magic-number.rst
+++ b/Documentation/translations/zh_CN/process/magic-number.rst
@@ -58,6 +58,5 @@ Linux =E9=AD=94=E6=9C=AF=E6=95=B0
 =E9=AD=94=E6=9C=AF=E6=95=B0=E5=90=8D              =E6=95=B0=E5=AD=97      =
       =E7=BB=93=E6=9E=84                     =E6=96=87=E4=BB=B6
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 FASYNC_MAGIC          0x4601           fasync_struct            ``include/=
linux/fs.h``
-SLIP_MAGIC            0x5302           slip                     ``drivers/=
net/slip.h``
 CCB_MAGIC             0xf2691ad2       ccb                      ``drivers/=
scsi/ncr53c8xx.c``
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
diff --git a/Documentation/translations/zh_TW/process/magic-number.rst b/Do=
cumentation/translations/zh_TW/process/magic-number.rst
index 793a0ae9fb7c..7ace7834f7f9 100644
--- a/Documentation/translations/zh_TW/process/magic-number.rst
+++ b/Documentation/translations/zh_TW/process/magic-number.rst
@@ -61,6 +61,5 @@ Linux =E9=AD=94=E8=A1=93=E6=95=B8
 =E9=AD=94=E8=A1=93=E6=95=B8=E5=90=8D              =E6=95=B8=E5=AD=97      =
       =E7=B5=90=E6=A7=8B                     =E6=96=87=E4=BB=B6
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 FASYNC_MAGIC          0x4601           fasync_struct            ``include/=
linux/fs.h``
-SLIP_MAGIC            0x5302           slip                     ``drivers/=
net/slip.h``
 CCB_MAGIC             0xf2691ad2       ccb                      ``drivers/=
scsi/ncr53c8xx.c``
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index 6865d32270e5..95f5c79772e7 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -426,7 +426,7 @@ static void slip_transmit(struct work_struct *work)
=20
 	spin_lock_bh(&sl->lock);
 	/* First make sure we're connected. */
-	if (!sl->tty || sl->magic !=3D SLIP_MAGIC || !netif_running(sl->dev)) {
+	if (!sl->tty || !netif_running(sl->dev)) {
 		spin_unlock_bh(&sl->lock);
 		return;
 	}
@@ -690,7 +690,7 @@ static void slip_receive_buf(struct tty_struct *tty, co=
nst unsigned char *cp,
 {
 	struct slip *sl =3D tty->disc_data;
=20
-	if (!sl || sl->magic !=3D SLIP_MAGIC || !netif_running(sl->dev))
+	if (!sl || !netif_running(sl->dev))
 		return;
=20
 	/* Read the characters out of the buffer */
@@ -761,7 +761,6 @@ static struct slip *sl_alloc(void)
 	sl =3D netdev_priv(dev);
=20
 	/* Initialize channel control data */
-	sl->magic       =3D SLIP_MAGIC;
 	sl->dev	      	=3D dev;
 	spin_lock_init(&sl->lock);
 	INIT_WORK(&sl->tx_work, slip_transmit);
@@ -809,7 +808,7 @@ static int slip_open(struct tty_struct *tty)
=20
 	err =3D -EEXIST;
 	/* First make sure we're not already connected. */
-	if (sl && sl->magic =3D=3D SLIP_MAGIC)
+	if (sl)
 		goto err_exit;
=20
 	/* OK.  Find a free SLIP channel to use. */
@@ -886,7 +885,7 @@ static void slip_close(struct tty_struct *tty)
 	struct slip *sl =3D tty->disc_data;
=20
 	/* First make sure we're connected. */
-	if (!sl || sl->magic !=3D SLIP_MAGIC || sl->tty !=3D tty)
+	if (!sl || sl->tty !=3D tty)
 		return;
=20
 	spin_lock_bh(&sl->lock);
@@ -1080,7 +1079,7 @@ static int slip_ioctl(struct tty_struct *tty, unsigne=
d int cmd,
 	int __user *p =3D (int __user *)arg;
=20
 	/* First make sure we're connected. */
-	if (!sl || sl->magic !=3D SLIP_MAGIC)
+	if (!sl)
 		return -EINVAL;
=20
 	switch (cmd) {
diff --git a/drivers/net/slip/slip.h b/drivers/net/slip/slip.h
index 3d7f88b330c1..d7dbedd27669 100644
--- a/drivers/net/slip/slip.h
+++ b/drivers/net/slip/slip.h
@@ -50,8 +50,6 @@
=20
=20
 struct slip {
-  int			magic;
-
   /* Various fields. */
   struct tty_struct	*tty;		/* ptr to TTY structure		*/
   struct net_device	*dev;		/* easy for intr handling	*/
@@ -100,6 +98,4 @@ struct slip {
 #endif
 };
=20
-#define SLIP_MAGIC 0x5302
-
 #endif	/* _LINUX_SLIP.H */
--=20
2.30.2

--uvnkwibhrdezqczq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmNtof4ACgkQvP0LAY0m
WPF7txAAqYTBlNdjEqyRFVYm7nWFIK9kDqijhb5lre58NkyUFLmeu+75VoLFJGPP
NwWaPpgq/pdP23Ui+rwkU9rDoGxAjg6m3WlKxvrBbK2PmJAZMOyHfr5INOKVbmjr
DZhixuFIpr9su3K3RqPLuflGUPpemGwIq2RXyDhbr0phl04rP8Zza+WuH3QioOIV
FegoIkKQLtTJEiG3BRa590kTOqqSXE2LrPbV2nBQsjdO7W9LGocvNfon2Vzyv3AF
wDpVuUWVe/23CLNee8OFKR2xSsrpDpLCFB+5jGyCER36nhWi+ksiFlc3ATKnhBzY
vJi0ObTYh4FzNfs8jEXI7JRUF33+MX+bfp17GscwVDnDEprPZ6V+pwsMKONOIV9V
BIpnI3985EUUL2mUM6lk8a2USDTu3/F5b0AS/tc6j8Eex7gig+2vCg4ezaaIakxw
XOYFYdjzLc2iXu4+1AckzEam9/wFL7r/p83u5Qx8An49PE1srNf7mCLlOQmRd6cj
g6YtQtL96sebZYAexIFsQtr1O+nx72BzdQ2b4tQAbTpB/JVLbP9GMQoUnzrZ8O94
eNzmbspvruAaH6k0nZ87RuP7XLGnlgqIL7R6rYNc+w3tNb3pObFX8LSNpC92BZV9
nQxGx66ZDENVMFe0BtJ0KoUPT4Xt7+vEPU6iPbQnmjzPvQ7f2tI=
=KmN1
-----END PGP SIGNATURE-----

--uvnkwibhrdezqczq--
