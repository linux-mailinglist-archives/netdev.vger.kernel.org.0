Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39A46195502
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 11:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgC0KTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 06:19:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12990 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726360AbgC0KTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 06:19:48 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02R9XHa1094074
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 06:19:48 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 300jev617y-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 06:19:48 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Fri, 27 Mar 2020 10:19:42 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 27 Mar 2020 10:19:40 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02RAJg7M26476900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 10:19:42 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77F8B4C046;
        Fri, 27 Mar 2020 10:19:42 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A003B4C040;
        Fri, 27 Mar 2020 10:19:41 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Mar 2020 10:19:41 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 2/3] s390/qeth: make OSN / OSX support configurable
Date:   Fri, 27 Mar 2020 11:19:33 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327101934.31040-1-jwi@linux.ibm.com>
References: <20200327101934.31040-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20032710-0012-0000-0000-000003990663
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032710-0013-0000-0000-000021D607DC
Message-Id: <20200327101934.31040-3-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-27_02:2020-03-26,2020-03-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270087
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The last machine generation that supports OSN is z13, and OSX is only
supported up to z14. Allow users and distros to decide whether they
still need support for these device types.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/Kconfig          | 16 ++++++++++++++++
 drivers/s390/net/qeth_core_main.c |  4 ++++
 drivers/s390/net/qeth_core_mpc.h  | 11 +++++++++++
 drivers/s390/net/qeth_l2_main.c   |  2 ++
 4 files changed, 33 insertions(+)

diff --git a/drivers/s390/net/Kconfig b/drivers/s390/net/Kconfig
index ced896d1534a..36633387b952 100644
--- a/drivers/s390/net/Kconfig
+++ b/drivers/s390/net/Kconfig
@@ -91,6 +91,22 @@ config QETH_L3
 	  To compile as a module choose M. The module name is qeth_l3.
 	  If unsure, choose Y.
 
+config QETH_OSN
+	def_bool !HAVE_MARCH_Z14_FEATURES
+	prompt "qeth OSN device support"
+	depends on QETH
+	help
+	  This enables the qeth driver to support devices in OSN mode.
+	  If unsure, choose N.
+
+config QETH_OSX
+	def_bool !HAVE_MARCH_Z15_FEATURES
+	prompt "qeth OSX device support"
+	depends on QETH
+	help
+	  This enables the qeth driver to support devices in OSX mode.
+	  If unsure, choose N.
+
 config CCWGROUP
 	tristate
 	default (LCS || CTCM || QETH)
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index d06d9f847388..24fd17b347fe 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4951,12 +4951,16 @@ static struct ccw_device_id qeth_ids[] = {
 					.driver_info = QETH_CARD_TYPE_OSD},
 	{CCW_DEVICE_DEVTYPE(0x1731, 0x05, 0x1732, 0x05),
 					.driver_info = QETH_CARD_TYPE_IQD},
+#ifdef CONFIG_QETH_OSN
 	{CCW_DEVICE_DEVTYPE(0x1731, 0x06, 0x1732, 0x06),
 					.driver_info = QETH_CARD_TYPE_OSN},
+#endif
 	{CCW_DEVICE_DEVTYPE(0x1731, 0x02, 0x1732, 0x03),
 					.driver_info = QETH_CARD_TYPE_OSM},
+#ifdef CONFIG_QETH_OSX
 	{CCW_DEVICE_DEVTYPE(0x1731, 0x02, 0x1732, 0x02),
 					.driver_info = QETH_CARD_TYPE_OSX},
+#endif
 	{},
 };
 MODULE_DEVICE_TABLE(ccw, qeth_ids);
diff --git a/drivers/s390/net/qeth_core_mpc.h b/drivers/s390/net/qeth_core_mpc.h
index 6f304fdbb073..d89a04bfd8b0 100644
--- a/drivers/s390/net/qeth_core_mpc.h
+++ b/drivers/s390/net/qeth_core_mpc.h
@@ -74,8 +74,19 @@ enum qeth_card_types {
 #define IS_IQD(card)	((card)->info.type == QETH_CARD_TYPE_IQD)
 #define IS_OSD(card)	((card)->info.type == QETH_CARD_TYPE_OSD)
 #define IS_OSM(card)	((card)->info.type == QETH_CARD_TYPE_OSM)
+
+#ifdef CONFIG_QETH_OSN
 #define IS_OSN(card)	((card)->info.type == QETH_CARD_TYPE_OSN)
+#else
+#define IS_OSN(card)	false
+#endif
+
+#ifdef CONFIG_QETH_OSX
 #define IS_OSX(card)	((card)->info.type == QETH_CARD_TYPE_OSX)
+#else
+#define IS_OSX(card)	false
+#endif
+
 #define IS_VM_NIC(card)	((card)->info.is_vm_nic)
 
 #define QETH_MPC_DIFINFO_LEN_INDICATES_LINK_TYPE 0x18
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 766ea0d07a24..974b4596b78d 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -869,6 +869,7 @@ struct qeth_discipline qeth_l2_discipline = {
 };
 EXPORT_SYMBOL_GPL(qeth_l2_discipline);
 
+#ifdef CONFIG_QETH_OSN
 static void qeth_osn_assist_cb(struct qeth_card *card,
 			       struct qeth_cmd_buffer *iob,
 			       unsigned int data_length)
@@ -945,6 +946,7 @@ void qeth_osn_deregister(struct net_device *dev)
 	return;
 }
 EXPORT_SYMBOL(qeth_osn_deregister);
+#endif
 
 /* SETBRIDGEPORT support, async notifications */
 
-- 
2.17.1

