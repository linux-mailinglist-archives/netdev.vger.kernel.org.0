Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84AA514BD8
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 15:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376792AbiD2N6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 09:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376685AbiD2N5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 09:57:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54DDCEE25;
        Fri, 29 Apr 2022 06:52:04 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TDh14h008386;
        Fri, 29 Apr 2022 13:51:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=K4n4o7YXCgp339mIN18ePP8hJRhIVvRKgfFIdbm/FzU=;
 b=r/8ztM3DeUxrhrwLe7Wzj7x0ydC24Kc7RpsotnB3aYxUNiBA33m4aDQGKsqZzPYMERgU
 dnkohJ9vVDs9F1THkqBvT+084LR1aB9dyxk6XlHNrgLMd5DKpO0kQx+ke3mEyFxvkV2J
 IjJwI6NqmdrvsnTXqvqzOmPbjt2d/mV8eHs8BvKCv3DBVEmb+x8+94VjGQRL2wVYxaBF
 zLUGEEV/AzZz9/X5X+1OuyIj7YWdbmZRAtAjQNiHXjq1rhsRxoxgYEQbSf7bLMq7TOuR
 7HOJEtFLhjB9pGlTIud2TWHNu8zA8G8iNlmNW5L/tfmqFg3iGqXvwV14V9uoRX/YPkfm iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3frh55r61x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 13:51:55 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23TDketc022854;
        Fri, 29 Apr 2022 13:51:54 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3frh55r616-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 13:51:54 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23TDQfA7021506;
        Fri, 29 Apr 2022 13:51:52 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3fm93917ry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 13:51:52 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23TDpnTr15925518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 13:51:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCE8E4C040;
        Fri, 29 Apr 2022 13:51:49 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5917B4C044;
        Fri, 29 Apr 2022 13:51:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 29 Apr 2022 13:51:49 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pci@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jouni Malinen <j@w1.fi>,
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: [RFC v2 38/39] wireless: add HAS_IOPORT dependencies
Date:   Fri, 29 Apr 2022 15:51:07 +0200
Message-Id: <20220429135108.2781579-70-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220429135108.2781579-1-schnelle@linux.ibm.com>
References: <20220429135108.2781579-1-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LkT0e9uwRCPbE8YAamp5GWwhNaIhdD8L
X-Proofpoint-GUID: chLt91eDVvLhzOlXefciDTd0Om4gxJp8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_06,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0
 clxscore=1011 mlxlogscore=856 priorityscore=1501 suspectscore=0
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
those drivers using them.

Co-developed-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
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
2.32.0

