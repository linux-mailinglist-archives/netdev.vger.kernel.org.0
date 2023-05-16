Return-Path: <netdev+bounces-2967-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E76A704BD3
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:09:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42E8C281063
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 11:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D1B934CDE;
	Tue, 16 May 2023 11:08:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4189534CC0
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 11:08:57 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D427696;
	Tue, 16 May 2023 04:08:30 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GB45IY006515;
	Tue, 16 May 2023 11:07:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8hiZ9JbF34R9RC3GTi14AhS0XmFDs03a8j1pLNXYbs8=;
 b=RIcJ5ZDC1A079INP59M0L3AYND5GOXcUmHwDzKbhNH49B+KK47n77ImMdSNivJLVhZKs
 LPOwCOtlJeZ1BiupFBRu0Ecqb/7QKv62ibOosYi7l9UN38XNkxtytcLG+E+1UxaAJW1I
 czf+Qrlk8UUyz3zzhOqxUVQ/dxeJa1kn8h5ibY4iOZGNM8Riysb8w07luivT18AmeiAQ
 lwuiHnM+/FsUJlLOskf9DZXtajVQSnKSHVECm9b4eaHBBbiTggYTjcpK2TKTAL1WKCEA
 kLZdPKD8ewvdlejeLoZBJbGSQVOfSt08UFdiud5bTZErQ92Vn2DHtTav/oJHjDKdqcLN gQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qm8mrr8wc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 May 2023 11:07:23 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34GB4Wf3008467;
	Tue, 16 May 2023 11:06:25 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qm8mrr88n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 May 2023 11:06:25 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34G5iarA019416;
	Tue, 16 May 2023 11:01:18 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qj264sk9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 May 2023 11:01:18 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34GB1FtX46137720
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 May 2023 11:01:15 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AE29E20043;
	Tue, 16 May 2023 11:01:15 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 409C320040;
	Tue, 16 May 2023 11:01:15 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 May 2023 11:01:15 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jouni Malinen <j@w1.fi>
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
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 40/41] wireless: add HAS_IOPORT dependencies
Date: Tue, 16 May 2023 13:00:36 +0200
Message-Id: <20230516110038.2413224-41-schnelle@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: -AXyIouq8jC1cPpj9pJ3WiafnsqTUYgR
X-Proofpoint-GUID: vWpcmIAtZTmCCgxhes2zMAqi_Nskfmgk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_04,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 spamscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305160094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In a future patch HAS_IOPORT=n will result in inb()/outb() and friends
not being declared. We thus need to add HAS_IOPORT as dependency for
those drivers using them.

Co-developed-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@kernel.org>
Acked-by: Kalle Valo <kvalo@kernel.org>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
Note: The HAS_IOPORT Kconfig option was added in v6.4-rc1 so
      per-subsystem patches may be applied independently

 drivers/net/wireless/atmel/Kconfig           | 2 +-
 drivers/net/wireless/intersil/hostap/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/atmel/Kconfig b/drivers/net/wireless/atmel/Kconfig
index ca45a1021cf4..bafdd57b049a 100644
--- a/drivers/net/wireless/atmel/Kconfig
+++ b/drivers/net/wireless/atmel/Kconfig
@@ -14,7 +14,7 @@ if WLAN_VENDOR_ATMEL
 
 config ATMEL
 	tristate "Atmel at76c50x chipset  802.11b support"
-	depends on CFG80211 && (PCI || PCMCIA)
+	depends on CFG80211 && (PCI || PCMCIA) && HAS_IOPORT
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	select FW_LOADER
diff --git a/drivers/net/wireless/intersil/hostap/Kconfig b/drivers/net/wireless/intersil/hostap/Kconfig
index c865d3156cea..2edff8efbcbb 100644
--- a/drivers/net/wireless/intersil/hostap/Kconfig
+++ b/drivers/net/wireless/intersil/hostap/Kconfig
@@ -56,7 +56,7 @@ config HOSTAP_FIRMWARE_NVRAM
 
 config HOSTAP_PLX
 	tristate "Host AP driver for Prism2/2.5/3 in PLX9052 PCI adaptors"
-	depends on PCI && HOSTAP
+	depends on PCI && HOSTAP && HAS_IOPORT
 	help
 	Host AP driver's version for Prism2/2.5/3 PC Cards in PLX9052 based
 	PCI adaptors.
-- 
2.39.2


