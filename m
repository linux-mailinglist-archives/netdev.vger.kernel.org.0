Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276606B931B
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 13:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjCNMPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 08:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbjCNMN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 08:13:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441F37C3E4;
        Tue, 14 Mar 2023 05:13:04 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32EBe1rT024111;
        Tue, 14 Mar 2023 12:12:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=cw3Hnac9T5XMpvF57L4Nhob9BUYv7xSOWKE0S9ZBQyU=;
 b=g1/lhnv3x0D2UiZOrDSXWAHrSpl/UYDuwEFluEhRkm2rT7DzpQdslRZ3J8Acd9XnFDPI
 tbsAfNstIg6vsnIT2carK3i1jKPxkOgKSvA1IIf0hvPOyCoNxubNcJlVo1ZDbhzjCFyv
 d0Ro+aDkhmPDJ+G/ZA3NH0pb7d1wNXnGkBPagZGQxtwioKyGtbtgd/gR+5fEGvY9vuYM
 g+M3+nRPXdYQd/BTGXPfdHHrr6vC13jZtB0nRv4cyR77Vz1E+Skt5JwfvmEOHDd/Kcia
 utGoZgVxMO9F2VstSXg5qruR4uKxTtyp9TgU9TC/so+d9HLMo47razZkmpa5HtaJT45b SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3papbac5uv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 12:12:41 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32EBak0a020629;
        Tue, 14 Mar 2023 12:12:40 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3papbac5tm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 12:12:40 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32E6EFmO030078;
        Tue, 14 Mar 2023 12:12:38 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3p8gwfct6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 12:12:38 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32ECCZZX48693856
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 12:12:36 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2A742007B;
        Tue, 14 Mar 2023 12:12:35 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 675642007C;
        Tue, 14 Mar 2023 12:12:35 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 14 Mar 2023 12:12:35 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Arnd Bergmann <arnd@arndb.de>, Karsten Keil <isdn@linux-pingi.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pci@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH v3 18/38] mISDN: add HAS_IOPORT dependencies
Date:   Tue, 14 Mar 2023 13:11:56 +0100
Message-Id: <20230314121216.413434-19-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230314121216.413434-1-schnelle@linux.ibm.com>
References: <20230314121216.413434-1-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d_Qa1fLaSceXZwK9dOPEGyutzMR1VVnQ
X-Proofpoint-ORIG-GUID: fJIGx9H3LvvwLKvDh1FbFXE9E-OIdria
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-14_06,2023-03-14_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 clxscore=1011 mlxlogscore=844 phishscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303140103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a future patch HAS_IOPORT=n will result in inb()/outb() and friends
not being declared. We thus need to add HAS_IOPORT as dependency for
those drivers using them. With that the !S390 dependency on ISDN can be
removed as all drivers without HAS_IOPORT requirement now build.

Co-developed-by: Arnd Bergmann <arnd@kernel.org>
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
2.37.2

