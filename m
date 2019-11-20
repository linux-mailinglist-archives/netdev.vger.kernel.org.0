Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16B3510421D
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 18:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbfKTR3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 12:29:52 -0500
Received: from mout.gmx.net ([212.227.15.18]:36813 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbfKTR3s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 12:29:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1574270981;
        bh=YbZVvDMYTz0y6LgxeZnY6Fd0f4gyXOO04f134owozUs=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=MnRTMejHz5bF4ev8qIzmx383VF1VEqj8NUXF72pkb9ZwAJVDStnDBEjl2x/RoZLAS
         4Fq7nGzv+kGemnKlgUgHYIJk5DDNlkf8XpXgEnlgZ1DCQ/efLxaZ8oLK7RrVql3Bqj
         jkCXstGHKSG2ZXqgxD0Jx8RkNZK+5/gC2ZHbpA58=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.139]) by mail.gmx.com
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MwQXH-1hfNo00iP7-00sLNn; Wed, 20 Nov 2019 18:29:41 +0100
From:   Stefan Wahren <wahrenst@gmx.net>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Wahren <stefan.wahren@in-tech.com>,
        Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH net 2/2] net: qca_spi: Move reset_count to struct qcaspi
Date:   Wed, 20 Nov 2019 18:29:13 +0100
Message-Id: <1574270953-4119-3-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574270953-4119-1-git-send-email-wahrenst@gmx.net>
References: <1574270953-4119-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:fwmwbMLJ+KXmQ7oeEX2XGFZuaBaM+qmcaBA9J82T5v8vls7WIHl
 w9Dp9WdgvjMzL/XBfg15QbrDgjo36F0y3Gj2eAfsaruE6XNJqhHDJxHifA2NSUn70Mch5kO
 vjwKbztmTb9GfpcuMa2R6ojxTfiuxR/HHGtDTZOEGBtrJts0MKhRYD7/g3Fz6woJSQMZGzV
 kPua5+doxp0W4PiTUHXgA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:TcQ8cVLnAl0=:VldT7wp2+9l42TJ9wJAwoo
 Nm6dSw2WmL2yltINj/90RjKNEgA1Kqy2s4inxtqzIPGdYNiJWgsvB0ff9MA8fpyVFPL39PsOz
 wCykcI+ts3L+o/DVR6eh3bQ+8HL1FqIV/hEKgjRXCG26vnc3dCfAGB8Xs4UVeXLErMh30+XVt
 qKPv52KZ0w+wjJKtVPnsutxRkf6P1vY+So/g/c7XJSMm/Tb+7nsBeKeAwSe1aHlNveJyjB3QY
 0X8z/WI3olEni0yeKntjZ5ixOcvwLOA6VO+q6q4ciwWkgCyu+KhrR6GMKgvofVNN2X69zGynV
 ldej8ZAh/JszRKIfhq3UGNa84KZ8cgbjgKUth9vIhZqM425uG/ePKAbA2ZKwPIVTXBjHZ4ym+
 Ds/kA5QtwHmZj7wpOPP7oKky2gbj/z8p1BCmDaE3389uH4PftsfmLWAvOgzSyHVPrQHR49VVE
 LnTZcCk3Xm75vh2CinO4Z8mbRBXNiNL6tVwkoLeaCQd+2ZygpeRqRQMs24UjvGV9Nm3bXar34
 fMYlz93T3B5mPMdg8vIuKcsWa5D65AjSeUbSoF90bTLuNvmAaCQOf7nItdxPU0i3B07scu2Sx
 K+/cKstrleRMRgtkNwaILSgEWfbvEpndPo7nbPIky6vMVOrwA+Eh3lpsGSqHMpCqJeIJ3haC4
 pTZB71hs1RsFdoDjv2Qby1qHjNe6NL7L/7Hg2l64Z9vaVROf+R0ekRI45V21FTfd7PG4cAntE
 aJ8gS6XxCNNzbi/aExW8KGf9aHPxu9gmgirOOshuEDqc38SsV4oG6gLAh2dQwE1qdSDcRam80
 ATVJXyrAcFvfo8ohAdrV02OHlfM83nTJJ6JpQofsKp8h3iAUPX7vSrjq9eTi133ZUqueskd9L
 8Ix5x+6psb/p9j+o/EIshW0FfijHrUgHBfDs82w01TbykhijHt5T88J7TWjygyH3GRXfC9c1L
 foRttl6Ui69AYoRQPmprYYpJIF3/xGPjX6TgZZRgjdt2GFtyDfdWnpWFOdRe4LbA9yapsocTc
 OXRa+5FV16XgJeY4N95IGUniniy37qTEWvBXkKnbtdlTmq3p+SCBEyhlksjBf+9Jv6ZP143mb
 cKXLYawKOmH+AdmwmYdxm04op0sfvec1YVLcdcbJcm76tgvHsk94oWwISrKFk5iezGUDTZr61
 zawC7Xj+6r2YgBRk7yJ5c8sx5eqfncl5644K11DwTj1QZsfEJlQRMatvxcrV9+7+oHLBicALk
 +sqHit9rBkjOTGORw6rV9nWiA8q4EPEKhk19WwA==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Wahren <stefan.wahren@in-tech.com>

The reset counter is specific for every QCA700x chip. So move this
into the private driver struct. Otherwise we get unpredictable reset
behavior in setups with multiple QCA700x chips.

Fixes: 291ab06ecf67 (net: qualcomm: new Ethernet over SPI driver for QCA70=
00)
Signed-off-by: Stefan Wahren <stefan.wahren@in-tech.com>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
=2D--
 drivers/net/ethernet/qualcomm/qca_spi.c | 9 ++++-----
 drivers/net/ethernet/qualcomm/qca_spi.h | 1 +
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/etherne=
t/qualcomm/qca_spi.c
index 351f24f..baac016 100644
=2D-- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -496,7 +496,6 @@ qcaspi_qca7k_sync(struct qcaspi *qca, int event)
 	u16 signature =3D 0;
 	u16 spi_config;
 	u16 wrbuf_space =3D 0;
-	static u16 reset_count;

 	if (event =3D=3D QCASPI_EVENT_CPUON) {
 		/* Read signature twice, if not valid
@@ -549,13 +548,13 @@ qcaspi_qca7k_sync(struct qcaspi *qca, int event)

 		qca->sync =3D QCASPI_SYNC_RESET;
 		qca->stats.trig_reset++;
-		reset_count =3D 0;
+		qca->reset_count =3D 0;
 		break;
 	case QCASPI_SYNC_RESET:
-		reset_count++;
+		qca->reset_count++;
 		netdev_dbg(qca->net_dev, "sync: waiting for CPU on, count %u.\n",
-			   reset_count);
-		if (reset_count >=3D QCASPI_RESET_TIMEOUT) {
+			   qca->reset_count);
+		if (qca->reset_count >=3D QCASPI_RESET_TIMEOUT) {
 			/* reset did not seem to take place, try again */
 			qca->sync =3D QCASPI_SYNC_UNKNOWN;
 			qca->stats.reset_timeout++;
diff --git a/drivers/net/ethernet/qualcomm/qca_spi.h b/drivers/net/etherne=
t/qualcomm/qca_spi.h
index eb9af45..d13a67e 100644
=2D-- a/drivers/net/ethernet/qualcomm/qca_spi.h
+++ b/drivers/net/ethernet/qualcomm/qca_spi.h
@@ -94,6 +94,7 @@ struct qcaspi {

 	unsigned int intr_req;
 	unsigned int intr_svc;
+	u16 reset_count;

 #ifdef CONFIG_DEBUG_FS
 	struct dentry *device_root;
=2D-
2.7.4

