Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587A748020E
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 17:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhL0Qop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 11:44:45 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46864 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230128AbhL0QoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 11:44:12 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BRGfoR6017518;
        Mon, 27 Dec 2021 16:43:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eo6zE487cpKaOW4tRHAPwXKzTXoz+NYW/y/7HK1Bt4g=;
 b=mjx6tdKZgzbzBMl671YEH988ZpEryJ+ftI8Zewnohls89MWKz0n/zmzwZvmLN9iv0f4g
 ZiIeyV2qJKEENPvrA9jkXsq/g7a9dsX6eumwZ0y4HDB1VIbYVqD6ccbfJRBm/b0SGaVx
 40NJCsnf9YkgqqWw9Vykq2SYiRNT9vz1AGLMEq6rWsSSedWreVUzFPd+e8sVtfoPNr4o
 UlEJr0RB6w6zo4BUBR5dbetmhCXTZBQS4FGJeY31GzSsq5TfZhbTgXSS8Ye+yO/vMOdk
 Elb9wbVguGJgGRQnhb8ZT3doTSyIgU16p5g6pB0T0Hje7+NynbihHBWlCKbqZH+as7P/ qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d7h7u80wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Dec 2021 16:43:46 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BRGhjlP023997;
        Mon, 27 Dec 2021 16:43:46 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d7h7u80w3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Dec 2021 16:43:45 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BRGhXDB028626;
        Mon, 27 Dec 2021 16:43:44 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3d5tx92sq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Dec 2021 16:43:43 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BRGhfE143057636
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Dec 2021 16:43:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DE30A405C;
        Mon, 27 Dec 2021 16:43:41 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B30D8A405F;
        Mon, 27 Dec 2021 16:43:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Dec 2021 16:43:40 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        John Garry <john.garry@huawei.com>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-csky@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: [RFC 17/32] net: Kconfig: add HAS_IOPORT dependencies
Date:   Mon, 27 Dec 2021 17:43:02 +0100
Message-Id: <20211227164317.4146918-18-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211227164317.4146918-1-schnelle@linux.ibm.com>
References: <20211227164317.4146918-1-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: r1PMtT0i8NwLvGeQcDuE90R1l_Qh7u0E
X-Proofpoint-ORIG-GUID: -8qZcipZwuL7bq32zdyuniaG3OuaHw__
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-27_08,2021-12-24_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 spamscore=0 impostorscore=0 mlxscore=0 phishscore=0 mlxlogscore=914
 clxscore=1011 priorityscore=1501 bulkscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112270080
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a future patch HAS_IOPORT=n will result in inb()/outb() and friends
not being declared. We thus need to add HAS_IOPORT as dependency for
those drivers using them.

Co-developed-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 drivers/net/Kconfig              | 2 +-
 drivers/net/can/cc770/Kconfig    | 1 +
 drivers/net/can/sja1000/Kconfig  | 1 +
 drivers/net/ethernet/via/Kconfig | 1 +
 drivers/net/hamradio/Kconfig     | 6 +++---
 5 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 6cccc3dc00bc..362d20c9a571 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -476,7 +476,7 @@ source "drivers/net/ipa/Kconfig"
 
 config NET_SB1000
 	tristate "General Instruments Surfboard 1000"
-	depends on PNP
+	depends on ISAPNP
 	help
 	  This is a driver for the General Instrument (also known as
 	  NextLevel) SURFboard 1000 internal
diff --git a/drivers/net/can/cc770/Kconfig b/drivers/net/can/cc770/Kconfig
index 9ef1359319f0..467ef19de1c1 100644
--- a/drivers/net/can/cc770/Kconfig
+++ b/drivers/net/can/cc770/Kconfig
@@ -7,6 +7,7 @@ if CAN_CC770
 
 config CAN_CC770_ISA
 	tristate "ISA Bus based legacy CC770 driver"
+	depends on ISA
 	help
 	  This driver adds legacy support for CC770 and AN82527 chips
 	  connected to the ISA bus using I/O port, memory mapped or
diff --git a/drivers/net/can/sja1000/Kconfig b/drivers/net/can/sja1000/Kconfig
index 110071b26921..be1943a27ed0 100644
--- a/drivers/net/can/sja1000/Kconfig
+++ b/drivers/net/can/sja1000/Kconfig
@@ -87,6 +87,7 @@ config CAN_PLX_PCI
 
 config CAN_SJA1000_ISA
 	tristate "ISA Bus based legacy SJA1000 driver"
+	depends on ISA
 	help
 	  This driver adds legacy support for SJA1000 chips connected to
 	  the ISA bus using I/O port, memory mapped or indirect access.
diff --git a/drivers/net/ethernet/via/Kconfig b/drivers/net/ethernet/via/Kconfig
index 0ca7d8f7bfde..25add3d64859 100644
--- a/drivers/net/ethernet/via/Kconfig
+++ b/drivers/net/ethernet/via/Kconfig
@@ -20,6 +20,7 @@ config VIA_RHINE
 	tristate "VIA Rhine support"
 	depends on LEGACY_PCI || (OF_IRQ && GENERIC_PCI_IOMAP)
 	depends on LEGACY_PCI || ARCH_VT8500 || COMPILE_TEST
+	depends on HAS_IOPORT
 	depends on HAS_DMA
 	select CRC32
 	select MII
diff --git a/drivers/net/hamradio/Kconfig b/drivers/net/hamradio/Kconfig
index 441da03c23ee..61c0bc156870 100644
--- a/drivers/net/hamradio/Kconfig
+++ b/drivers/net/hamradio/Kconfig
@@ -117,7 +117,7 @@ config SCC_TRXECHO
 
 config BAYCOM_SER_FDX
 	tristate "BAYCOM ser12 fullduplex driver for AX.25"
-	depends on AX25 && !S390
+	depends on AX25 && HAS_IOPORT
 	select CRC_CCITT
 	help
 	  This is one of two drivers for Baycom style simple amateur radio
@@ -137,7 +137,7 @@ config BAYCOM_SER_FDX
 
 config BAYCOM_SER_HDX
 	tristate "BAYCOM ser12 halfduplex driver for AX.25"
-	depends on AX25 && !S390
+	depends on AX25 && HAS_IOPORT
 	select CRC_CCITT
 	help
 	  This is one of two drivers for Baycom style simple amateur radio
@@ -185,7 +185,7 @@ config BAYCOM_EPP
 
 config YAM
 	tristate "YAM driver for AX.25"
-	depends on AX25 && !S390
+	depends on AX25 && HAS_IOPORT
 	help
 	  The YAM is a modem for packet radio which connects to the serial
 	  port and includes some of the functions of a Terminal Node
-- 
2.32.0

