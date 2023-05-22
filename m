Return-Path: <netdev+bounces-4211-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 671CF70BA7E
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:52:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88343280EDD
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 10:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EADDBBA32;
	Mon, 22 May 2023 10:52:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80D0BE46
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 10:52:03 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F233510D2;
	Mon, 22 May 2023 03:51:37 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34M9laC7007778;
	Mon, 22 May 2023 10:51:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=iHMcw4trvGKtrIGkpf8XG8SyeLt/2qeBIumRjnFKYng=;
 b=DPxcyh09on0kz3NXoyltuSmP86Z9+7SNRtJRxpO7Tzv2T6xdFgHHt2OJOwKOYpyTk8q3
 m3mK2gcHLr+Zgy5VcDc81TIv7bcaUC52LjlN7SFmKlOmjqYL7PGgeEp3isJ6mDnvIcza
 EehL2GpBCCUI4nDAwUPmFYqh5EUkGoA6ZDPJwMKhUGPKaPprp1JS7BNPOQJRp8WdC/O5
 nlhTUJoKU516OFct5NWlcpN0Ho5PRxpR/EAvHyTosH3cKzinPmuTa1Fnw6d90twN9LtS
 hItZE31qzKQ1tr5UpWyhbRm6rMV6olUW5BCuisl8SSlmXq4di22c5sNn+2c/yQXVAu7E 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qqawenuky-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 May 2023 10:51:17 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34MAGv3l022256;
	Mon, 22 May 2023 10:51:16 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qqawenuk4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 May 2023 10:51:16 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34MANAnA030387;
	Mon, 22 May 2023 10:51:14 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qppdk0w98-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 May 2023 10:51:14 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34MApAHp18678398
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 May 2023 10:51:10 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3CE0220043;
	Mon, 22 May 2023 10:51:10 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A08B02004B;
	Mon, 22 May 2023 10:51:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 May 2023 10:51:09 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Ralf Baechle <ralf@linux-mips.org>
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
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-hams@vger.kernel.org
Subject: [PATCH v5 22/44] net: handle HAS_IOPORT dependencies
Date: Mon, 22 May 2023 12:50:27 +0200
Message-Id: <20230522105049.1467313-23-schnelle@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 1mk8XQxidzjBpOd3ym4THR_HsUqkt2I3
X-Proofpoint-GUID: Feg9xuGRmFUwYGJRugYLdNUEB3HNjTEX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-22_06,2023-05-22_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 clxscore=1015 malwarescore=0 phishscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 lowpriorityscore=0
 mlxlogscore=912 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305220089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In a future patch HAS_IOPORT=n will result in inb()/outb() and friends
not being declared. We thus need to add HAS_IOPORT as dependency for
those drivers requiring them. For the DEFXX driver the use of I/O
ports is optional and we only need to fence specific code paths. It also
turns out that with HAS_IOPORT handled explicitly HAMRADIO does not need
the !S390 dependency and successfully builds the bpqether driver.

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Maciej W. Rozycki <macro@orcam.me.uk>
Co-developed-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 drivers/net/Kconfig                  | 2 +-
 drivers/net/arcnet/Kconfig           | 2 +-
 drivers/net/can/cc770/Kconfig        | 1 +
 drivers/net/can/sja1000/Kconfig      | 1 +
 drivers/net/ethernet/3com/Kconfig    | 4 ++--
 drivers/net/ethernet/8390/Kconfig    | 6 +++---
 drivers/net/ethernet/amd/Kconfig     | 4 ++--
 drivers/net/ethernet/fujitsu/Kconfig | 2 +-
 drivers/net/ethernet/intel/Kconfig   | 2 +-
 drivers/net/ethernet/sis/Kconfig     | 4 ++--
 drivers/net/ethernet/smsc/Kconfig    | 2 +-
 drivers/net/ethernet/ti/Kconfig      | 2 +-
 drivers/net/ethernet/via/Kconfig     | 1 +
 drivers/net/ethernet/xircom/Kconfig  | 2 +-
 drivers/net/fddi/defxx.c             | 2 +-
 drivers/net/hamradio/Kconfig         | 6 +++---
 drivers/net/wan/Kconfig              | 2 +-
 net/ax25/Kconfig                     | 2 +-
 18 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index d0a1ed216d15..817322605825 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -476,7 +476,7 @@ source "drivers/net/ipa/Kconfig"
 
 config NET_SB1000
 	tristate "General Instruments Surfboard 1000"
-	depends on PNP
+	depends on ISA && PNP
 	help
 	  This is a driver for the General Instrument (also known as
 	  NextLevel) SURFboard 1000 internal
diff --git a/drivers/net/arcnet/Kconfig b/drivers/net/arcnet/Kconfig
index a51b9dab6d3a..d1d07a1d4fbc 100644
--- a/drivers/net/arcnet/Kconfig
+++ b/drivers/net/arcnet/Kconfig
@@ -4,7 +4,7 @@
 #
 
 menuconfig ARCNET
-	depends on NETDEVICES && (ISA || PCI || PCMCIA)
+	depends on NETDEVICES && (ISA || PCI || PCMCIA) && HAS_IOPORT
 	tristate "ARCnet support"
 	help
 	  If you have a network card of this type, say Y and check out the
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
index 4b2f9cb17fc3..01168db4c106 100644
--- a/drivers/net/can/sja1000/Kconfig
+++ b/drivers/net/can/sja1000/Kconfig
@@ -87,6 +87,7 @@ config CAN_PLX_PCI
 
 config CAN_SJA1000_ISA
 	tristate "ISA Bus based legacy SJA1000 driver"
+	depends on ISA
 	help
 	  This driver adds legacy support for SJA1000 chips connected to
 	  the ISA bus using I/O port, memory mapped or indirect access.
diff --git a/drivers/net/ethernet/3com/Kconfig b/drivers/net/ethernet/3com/Kconfig
index 706bd59bf645..1fbab79e2be4 100644
--- a/drivers/net/ethernet/3com/Kconfig
+++ b/drivers/net/ethernet/3com/Kconfig
@@ -44,7 +44,7 @@ config 3C515
 
 config PCMCIA_3C574
 	tristate "3Com 3c574 PCMCIA support"
-	depends on PCMCIA
+	depends on PCMCIA && HAS_IOPORT
 	help
 	  Say Y here if you intend to attach a 3Com 3c574 or compatible PCMCIA
 	  (PC-card) Fast Ethernet card to your computer.
@@ -54,7 +54,7 @@ config PCMCIA_3C574
 
 config PCMCIA_3C589
 	tristate "3Com 3c589 PCMCIA support"
-	depends on PCMCIA
+	depends on PCMCIA && HAS_IOPORT
 	help
 	  Say Y here if you intend to attach a 3Com 3c589 or compatible PCMCIA
 	  (PC-card) Ethernet card to your computer.
diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
index a4130e643342..345f250781c6 100644
--- a/drivers/net/ethernet/8390/Kconfig
+++ b/drivers/net/ethernet/8390/Kconfig
@@ -19,7 +19,7 @@ if NET_VENDOR_8390
 
 config PCMCIA_AXNET
 	tristate "Asix AX88190 PCMCIA support"
-	depends on PCMCIA
+	depends on PCMCIA && HAS_IOPORT
 	help
 	  Say Y here if you intend to attach an Asix AX88190-based PCMCIA
 	  (PC-card) Fast Ethernet card to your computer.  These cards are
@@ -117,7 +117,7 @@ config NE2000
 
 config NE2K_PCI
 	tristate "PCI NE2000 and clones support (see help)"
-	depends on PCI
+	depends on PCI && HAS_IOPORT
 	select CRC32
 	help
 	  This driver is for NE2000 compatible PCI cards. It will not work
@@ -146,7 +146,7 @@ config APNE
 
 config PCMCIA_PCNET
 	tristate "NE2000 compatible PCMCIA support"
-	depends on PCMCIA
+	depends on PCMCIA && HAS_IOPORT
 	select CRC32
 	help
 	  Say Y here if you intend to attach an NE2000 compatible PCMCIA
diff --git a/drivers/net/ethernet/amd/Kconfig b/drivers/net/ethernet/amd/Kconfig
index f8cc8925161c..b39c6f3e1eda 100644
--- a/drivers/net/ethernet/amd/Kconfig
+++ b/drivers/net/ethernet/amd/Kconfig
@@ -56,7 +56,7 @@ config LANCE
 
 config PCNET32
 	tristate "AMD PCnet32 PCI support"
-	depends on PCI
+	depends on PCI && HAS_IOPORT
 	select CRC32
 	select MII
 	help
@@ -122,7 +122,7 @@ config MVME147_NET
 
 config PCMCIA_NMCLAN
 	tristate "New Media PCMCIA support"
-	depends on PCMCIA
+	depends on PCMCIA && HAS_IOPORT
 	help
 	  Say Y here if you intend to attach a New Media Ethernet or LiveWire
 	  PCMCIA (PC-card) Ethernet card to your computer.
diff --git a/drivers/net/ethernet/fujitsu/Kconfig b/drivers/net/ethernet/fujitsu/Kconfig
index 0a1400cb410a..06a28bce5d27 100644
--- a/drivers/net/ethernet/fujitsu/Kconfig
+++ b/drivers/net/ethernet/fujitsu/Kconfig
@@ -18,7 +18,7 @@ if NET_VENDOR_FUJITSU
 
 config PCMCIA_FMVJ18X
 	tristate "Fujitsu FMV-J18x PCMCIA support"
-	depends on PCMCIA
+	depends on PCMCIA && HAS_IOPORT
 	select CRC32
 	help
 	  Say Y here if you intend to attach a Fujitsu FMV-J18x or compatible
diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 9bc0a9519899..f48289a82a16 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -41,7 +41,7 @@ config E100
 
 config E1000
 	tristate "Intel(R) PRO/1000 Gigabit Ethernet support"
-	depends on PCI
+	depends on PCI && HAS_IOPORT
 	help
 	  This driver supports Intel(R) PRO/1000 gigabit ethernet family of
 	  adapters.  For more information on how to identify your adapter, go
diff --git a/drivers/net/ethernet/sis/Kconfig b/drivers/net/ethernet/sis/Kconfig
index 775d76d9890e..7e498bdbca73 100644
--- a/drivers/net/ethernet/sis/Kconfig
+++ b/drivers/net/ethernet/sis/Kconfig
@@ -19,7 +19,7 @@ if NET_VENDOR_SIS
 
 config SIS900
 	tristate "SiS 900/7016 PCI Fast Ethernet Adapter support"
-	depends on PCI
+	depends on PCI && HAS_IOPORT
 	select CRC32
 	select MII
 	help
@@ -35,7 +35,7 @@ config SIS900
 
 config SIS190
 	tristate "SiS190/SiS191 gigabit ethernet support"
-	depends on PCI
+	depends on PCI && HAS_IOPORT
 	select CRC32
 	select MII
 	help
diff --git a/drivers/net/ethernet/smsc/Kconfig b/drivers/net/ethernet/smsc/Kconfig
index 5f22a8a4d27b..13ce9086a9ca 100644
--- a/drivers/net/ethernet/smsc/Kconfig
+++ b/drivers/net/ethernet/smsc/Kconfig
@@ -54,7 +54,7 @@ config SMC91X
 
 config PCMCIA_SMC91C92
 	tristate "SMC 91Cxx PCMCIA support"
-	depends on PCMCIA
+	depends on PCMCIA && HAS_IOPORT
 	select CRC32
 	select MII
 	help
diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index fce06663e1e1..20068acce9fe 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -161,7 +161,7 @@ config TI_KEYSTONE_NETCP_ETHSS
 
 config TLAN
 	tristate "TI ThunderLAN support"
-	depends on (PCI || EISA)
+	depends on (PCI || EISA) && HAS_IOPORT
 	help
 	  If you have a PCI Ethernet network card based on the ThunderLAN chip
 	  which is supported by this driver, say Y here.
diff --git a/drivers/net/ethernet/via/Kconfig b/drivers/net/ethernet/via/Kconfig
index da287ef65be7..00773f5e4d7e 100644
--- a/drivers/net/ethernet/via/Kconfig
+++ b/drivers/net/ethernet/via/Kconfig
@@ -20,6 +20,7 @@ config VIA_RHINE
 	tristate "VIA Rhine support"
 	depends on PCI || (OF_IRQ && GENERIC_PCI_IOMAP)
 	depends on PCI || ARCH_VT8500 || COMPILE_TEST
+	depends on HAS_IOPORT
 	depends on HAS_DMA
 	select CRC32
 	select MII
diff --git a/drivers/net/ethernet/xircom/Kconfig b/drivers/net/ethernet/xircom/Kconfig
index 7497b9bea511..bfbdcf758afb 100644
--- a/drivers/net/ethernet/xircom/Kconfig
+++ b/drivers/net/ethernet/xircom/Kconfig
@@ -19,7 +19,7 @@ if NET_VENDOR_XIRCOM
 
 config PCMCIA_XIRC2PS
 	tristate "Xircom 16-bit PCMCIA support"
-	depends on PCMCIA
+	depends on PCMCIA && HAS_IOPORT
 	help
 	  Say Y here if you intend to attach a Xircom 16-bit PCMCIA (PC-card)
 	  Ethernet or Fast Ethernet card to your computer.
diff --git a/drivers/net/fddi/defxx.c b/drivers/net/fddi/defxx.c
index 1fef8a9b1a0f..0fbbb7286008 100644
--- a/drivers/net/fddi/defxx.c
+++ b/drivers/net/fddi/defxx.c
@@ -254,7 +254,7 @@ static const char version[] =
 #define DFX_BUS_TC(dev) 0
 #endif
 
-#if defined(CONFIG_EISA) || defined(CONFIG_PCI)
+#ifdef CONFIG_HAS_IOPORT
 #define dfx_use_mmio bp->mmio
 #else
 #define dfx_use_mmio true
diff --git a/drivers/net/hamradio/Kconfig b/drivers/net/hamradio/Kconfig
index a94c7bd5db2e..887c61971841 100644
--- a/drivers/net/hamradio/Kconfig
+++ b/drivers/net/hamradio/Kconfig
@@ -83,7 +83,7 @@ config SCC_TRXECHO
 
 config BAYCOM_SER_FDX
 	tristate "BAYCOM ser12 fullduplex driver for AX.25"
-	depends on AX25 && !S390
+	depends on AX25 && HAS_IOPORT
 	select CRC_CCITT
 	help
 	  This is one of two drivers for Baycom style simple amateur radio
@@ -103,7 +103,7 @@ config BAYCOM_SER_FDX
 
 config BAYCOM_SER_HDX
 	tristate "BAYCOM ser12 halfduplex driver for AX.25"
-	depends on AX25 && !S390
+	depends on AX25 && HAS_IOPORT
 	select CRC_CCITT
 	help
 	  This is one of two drivers for Baycom style simple amateur radio
@@ -151,7 +151,7 @@ config BAYCOM_EPP
 
 config YAM
 	tristate "YAM driver for AX.25"
-	depends on AX25 && !S390
+	depends on AX25 && HAS_IOPORT
 	help
 	  The YAM is a modem for packet radio which connects to the serial
 	  port and includes some of the functions of a Terminal Node
diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index dcb069dde66b..417e2c2d349d 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -178,7 +178,7 @@ config C101
 
 config FARSYNC
 	tristate "FarSync T-Series support"
-	depends on HDLC && PCI
+	depends on HDLC && PCI && HAS_IOPORT
 	help
 	  Support for the FarSync T-Series X.21 (and V.35/V.24) cards by
 	  FarSite Communications Ltd.
diff --git a/net/ax25/Kconfig b/net/ax25/Kconfig
index d3a9843a043d..f769e8f4bd02 100644
--- a/net/ax25/Kconfig
+++ b/net/ax25/Kconfig
@@ -4,7 +4,7 @@
 #
 
 menuconfig HAMRADIO
-	depends on NET && !S390
+	depends on NET
 	bool "Amateur Radio support"
 	help
 	  If you want to connect your Linux box to an amateur radio, answer Y
-- 
2.39.2


