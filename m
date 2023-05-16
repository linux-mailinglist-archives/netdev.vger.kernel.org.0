Return-Path: <netdev+bounces-2979-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FDDE704D43
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:02:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 358D52815F9
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:02:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4594224EBA;
	Tue, 16 May 2023 12:02:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335CE24EA6
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 12:02:49 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED8B3583;
	Tue, 16 May 2023 05:02:47 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GAeknw016987;
	Tue, 16 May 2023 11:05:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sK8gFGA/W1SofVZ9l7XObYImFH6PogOuHHBJuClZcaw=;
 b=Z7kU6CgPLx0U97fMTrSTysSz4xdiSSOyeQHscupgGnMDNKCaA7atxu/BRZZM4Vxx4VdH
 i5OpYWe41P1c9nPmLCiHEsUkb6YjVyzCAXKkTbsIgvIypAdLUnYAqgvgoZDcXWODGfJD
 kwiXd8yLZpxinXrK3Jqtx3C7E5giZchKQ+27KCUs+7vH4nEVKkiXB9vlfjEWZ9vGaWYt
 ok6n3yHP/jObaD5bypI4c4MZmsCf7o3Dho/F0z4hMdWUCrd7a3Toh+AgYvRNrySeLF4S
 RdjxOOMwFezlqTR7QuetfRxjH1sqtKQ+PPAIM4mPqPwqWJZEfyCb+qs26+eNxHf1lTIy 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qm82f0sqe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 May 2023 11:05:18 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34GB4jnL000453;
	Tue, 16 May 2023 11:04:45 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qm82f0pg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 May 2023 11:04:45 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34G5sHHX025422;
	Tue, 16 May 2023 11:00:56 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qj1tdsjr8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 May 2023 11:00:56 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34GB0shx37815020
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 May 2023 11:00:54 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D61F2004E;
	Tue, 16 May 2023 11:00:54 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B804320043;
	Tue, 16 May 2023 11:00:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 May 2023 11:00:53 +0000 (GMT)
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
Subject: [PATCH v4 18/41] mISDN: add HAS_IOPORT dependencies
Date: Tue, 16 May 2023 13:00:14 +0200
Message-Id: <20230516110038.2413224-19-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230516110038.2413224-1-schnelle@linux.ibm.com>
References: <20230516110038.2413224-1-schnelle@linux.ibm.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rvRpznGl4X566GhLdPOMY0DgPszr9prw
X-Proofpoint-ORIG-GUID: vKzlUi7iAtx4e7ZdHUfFZ9X6q2fFLO1R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_04,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 spamscore=0 suspectscore=0 mlxlogscore=967 impostorscore=0 malwarescore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305160094
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
Note: The HAS_IOPORT Kconfig option was added in v6.4-rc1 so
      per-subsystem patches may be applied independently

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


