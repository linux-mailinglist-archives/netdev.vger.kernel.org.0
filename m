Return-Path: <netdev+bounces-4210-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A2B970BA6A
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:51:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 043311C20A02
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 10:51:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AD15BA32;
	Mon, 22 May 2023 10:51:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E67DBA29
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 10:51:45 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB2EE5A;
	Mon, 22 May 2023 03:51:30 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34MAHRSP005526;
	Mon, 22 May 2023 10:51:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Eya5n8SYoD6iVTKWrBjyhQ0SEXz4plmKMHsS9S/BAco=;
 b=j1dKD/OKoXrHUuEf5woWp5zNJycjWiq5hOjzzWXYidcnDb7DzWTlwvwDKO7Hi5Z8B9QM
 QUr15iQG15j9XDqVp9DoUDFRo+smDUYEvqp+yt+c34FXZ+p3E7Z/OE3c5b6rMEKUjzAh
 quhz35i9wi+WxdlODumLyHIzXxw5GXIEya9c7liJKGT0XTJ4xLIGO6R9RaiRAszmVg8S
 ukOM+aSfMd4lQBZh0VVmWsrG5zaiyTsmuMRJ2h87iKR8sqFqa/Py7cU1ukzS046V6eaD
 batGcxRjzVlsU5/DtCaudo1exXQx2J7v0eLfFkynLgqAZrgXXrkHRWUDGxLP6flQH3UL BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qq78bh2k5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 May 2023 10:51:15 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34MAShFu013591;
	Mon, 22 May 2023 10:51:14 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qq78bh2h8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 May 2023 10:51:14 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
	by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34M6KApJ015110;
	Mon, 22 May 2023 10:51:10 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3qppbmgrw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 May 2023 10:51:10 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34MAp7GH8192616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 May 2023 10:51:07 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 90AF52004E;
	Mon, 22 May 2023 10:51:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 37D182004B;
	Mon, 22 May 2023 10:51:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 May 2023 10:51:06 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>, Karsten Keil <isdn@linux-pingi.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pci@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH v5 20/44] mISDN: add HAS_IOPORT dependencies
Date: Mon, 22 May 2023 12:50:25 +0200
Message-Id: <20230522105049.1467313-21-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230522105049.1467313-1-schnelle@linux.ibm.com>
References: <20230522105049.1467313-1-schnelle@linux.ibm.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xuXwvEEWcIDWKtivvMmAjkBo7InOnKLx
X-Proofpoint-GUID: gtQjnL-FLFPAM4NIBQ9rwyjkborAPGA5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-22_06,2023-05-22_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 malwarescore=0 phishscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=846 adultscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305220089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In a future patch HAS_IOPORT=n will result in inb()/outb() and friends
not being declared. We thus need to add HAS_IOPORT as dependency for
those drivers using them. With that the !S390 dependency on ISDN can be
removed as all drivers without HAS_IOPORT requirement now build.

Co-developed-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@kernel.org>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 drivers/isdn/Kconfig                |  1 -
 drivers/isdn/hardware/mISDN/Kconfig | 12 ++++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/isdn/Kconfig b/drivers/isdn/Kconfig
index 2690e2c5a158..6fd1b3f84a29 100644
--- a/drivers/isdn/Kconfig
+++ b/drivers/isdn/Kconfig
@@ -6,7 +6,6 @@
 menuconfig ISDN
 	bool "ISDN support"
 	depends on NET && NETDEVICES
-	depends on !S390 && !UML
 	help
 	  ISDN ("Integrated Services Digital Network", called RNIS in France)
 	  is a fully digital telephone service that can be used for voice and
diff --git a/drivers/isdn/hardware/mISDN/Kconfig b/drivers/isdn/hardware/mISDN/Kconfig
index 078eeadf707a..a35bff8a93f5 100644
--- a/drivers/isdn/hardware/mISDN/Kconfig
+++ b/drivers/isdn/hardware/mISDN/Kconfig
@@ -14,7 +14,7 @@ config MISDN_HFCPCI
 
 config MISDN_HFCMULTI
 	tristate "Support for HFC multiport cards (HFC-4S/8S/E1)"
-	depends on PCI || CPM1
+	depends on (PCI || CPM1) && HAS_IOPORT
 	depends on MISDN
 	help
 	  Enable support for cards with Cologne Chip AG's HFC multiport
@@ -43,7 +43,7 @@ config MISDN_HFCUSB
 config MISDN_AVMFRITZ
 	tristate "Support for AVM FRITZ!CARD PCI"
 	depends on MISDN
-	depends on PCI
+	depends on PCI && HAS_IOPORT
 	select MISDN_IPAC
 	help
 	  Enable support for AVMs FRITZ!CARD PCI cards
@@ -51,7 +51,7 @@ config MISDN_AVMFRITZ
 config MISDN_SPEEDFAX
 	tristate "Support for Sedlbauer Speedfax+"
 	depends on MISDN
-	depends on PCI
+	depends on PCI && HAS_IOPORT
 	select MISDN_IPAC
 	select MISDN_ISAR
 	help
@@ -60,7 +60,7 @@ config MISDN_SPEEDFAX
 config MISDN_INFINEON
 	tristate "Support for cards with Infineon chipset"
 	depends on MISDN
-	depends on PCI
+	depends on PCI && HAS_IOPORT
 	select MISDN_IPAC
 	help
 	  Enable support for cards with ISAC + HSCX, IPAC or IPAC-SX
@@ -69,14 +69,14 @@ config MISDN_INFINEON
 config MISDN_W6692
 	tristate "Support for cards with Winbond 6692"
 	depends on MISDN
-	depends on PCI
+	depends on PCI && HAS_IOPORT
 	help
 	  Enable support for Winbond 6692 PCI chip based cards.
 
 config MISDN_NETJET
 	tristate "Support for NETJet cards"
 	depends on MISDN
-	depends on PCI
+	depends on PCI && HAS_IOPORT
 	depends on TTY
 	select MISDN_IPAC
 	select MISDN_HDLC
-- 
2.39.2


