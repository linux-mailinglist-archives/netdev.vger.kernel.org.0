Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6AB514B57
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 15:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376550AbiD2Nz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 09:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376483AbiD2Nzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 09:55:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4611266FA1;
        Fri, 29 Apr 2022 06:51:37 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TDh14V008386;
        Fri, 29 Apr 2022 13:51:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=RuNBazYj+JNVu/qMqfX0KCglXCFM5o0C7nuGcmd1qoU=;
 b=GKlhLsdpEHYMlQinMB418qp8wmzJCCx3sUFHnMnacJe5qehxJB+mSiTEU84r3L1SZ2Xt
 96Taj6HtFZMSmoORrtmD2KJwKkO5tgfqcmZhGRYykGqztcANrZDIInzctQsmrM++HP+Y
 wb2v48IaGru+aOH235oJCZ+L1aQ6rhYG5xjnBmjU1XU4bcwF5V9AzYIGSpIM/E2/N7S0
 2ufTlsLbKQfVDNd5q+1DhasbM86LlHSoVl4IlSFsAxiVVN0j0sMXNJvCEIwso0Yfp83n
 +Hu+fsv+E+jVQhFjq3eyHlivQ/PPDyDgAWKyT/BVUyaPPXj+M6P/Xx+KVti4Jp6zBxja 4g== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3frh55r5pq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 13:51:31 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23TDQsUo016000;
        Fri, 29 Apr 2022 13:51:29 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3fpuygb96u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 13:51:29 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23TDpRuR51904806
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 13:51:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CDF84C044;
        Fri, 29 Apr 2022 13:51:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAF294C040;
        Fri, 29 Apr 2022 13:51:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 29 Apr 2022 13:51:26 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pci@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org (open list:ISDN/mISDN SUBSYSTEM)
Subject: [RFC v2 19/39] mISDN: add HAS_IOPORT dependencies
Date:   Fri, 29 Apr 2022 15:50:29 +0200
Message-Id: <20220429135108.2781579-32-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220429135108.2781579-1-schnelle@linux.ibm.com>
References: <20220429135108.2781579-1-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OwjiZNdHGAX5ZP-HpR4mI-Ym34rseOzo
X-Proofpoint-GUID: OwjiZNdHGAX5ZP-HpR4mI-Ym34rseOzo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_06,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0
 clxscore=1011 mlxlogscore=572 priorityscore=1501 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
2.32.0

