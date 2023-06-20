Return-Path: <netdev+bounces-12142-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 556B8736654
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:35:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7875C1C20BEE
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:35:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60026BE62;
	Tue, 20 Jun 2023 08:35:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DD6C2C2
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 08:35:02 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3748010D5;
	Tue, 20 Jun 2023 01:35:00 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35K8L6JG003242;
	Tue, 20 Jun 2023 08:34:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=r9k7lQi40ou1RYEywLI3ovULoECVCMnO/PCd772XS7k=;
 b=nMhmyNiVEF+PjAJTmbpXRTjxFfHXoZ8/4EkJZ1Wyqw6DAqYMq68GJDLAc0BUWE1KvBHK
 7HC3BI+h6NAFLS1Wme0LtZSJRfe2bp6JVDr9x7L+YxRPLzGSh9I81QXegDcc0SZTaUgy
 qn63+ThzikjjaWJNE1z2EQLhesOM+3l0ahSccpZhI0IuP5GDz2+xSwtZKDY9nl0sEtS8
 AdoFAR6CcEuU8kK3+O+I1175LQN2E6ckXVKixc/tOseqdFjl5Bl4qJY4bKpSGAQAxwW1
 +Aa7ezSj7uOVvRxYZtnRAEo6ZTVgx2YvHMb/c7zwn156y9/G0u9CS0SlSqxnjydtGZJi cA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rb8hbrdjt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Jun 2023 08:34:51 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35K8LNOS003902;
	Tue, 20 Jun 2023 08:34:50 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rb8hbrdfh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Jun 2023 08:34:50 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
	by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35K3VHQw002721;
	Tue, 20 Jun 2023 08:34:47 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3r94f59f6y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Jun 2023 08:34:47 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35K8YiDM60883284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jun 2023 08:34:44 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 12AD620040;
	Tue, 20 Jun 2023 08:34:44 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E6E2320043;
	Tue, 20 Jun 2023 08:34:43 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 20 Jun 2023 08:34:43 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
	id A0E00E0943; Tue, 20 Jun 2023 10:34:43 +0200 (CEST)
From: Alexandra Winter <wintera@linux.ibm.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next 4/4] s390/ctcm: Convert sprintf/snprintf to scnprintf
Date: Tue, 20 Jun 2023 10:34:11 +0200
Message-Id: <20230620083411.508797-5-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230620083411.508797-1-wintera@linux.ibm.com>
References: <20230620083411.508797-1-wintera@linux.ibm.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T0k3veFl7649hfTy4viChnCXnBaVtsID
X-Proofpoint-ORIG-GUID: afCmnWecz482-i6IHhiwdZw0FGylFsqO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-20_05,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 phishscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 impostorscore=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306200076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Thorsten Winkler <twinkler@linux.ibm.com>

This LWN article explains the rationale for this change
https: //lwn.net/Articles/69419/
Ie. snprintf() returns what *would* be the resulting length,
while scnprintf() returns the actual length.

Note that ctcm_print_statistics() writes the data into the kernel log
and is therefore not suitable for sysfs_emit(). Observable behavior is
not changed, as there may be dependencies.

Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Thorsten Winkler <twinkler@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/ctcm_dbug.c  |  2 +-
 drivers/s390/net/ctcm_main.c  |  6 +++---
 drivers/s390/net/ctcm_main.h  |  1 +
 drivers/s390/net/ctcm_mpc.c   | 18 ++++++++++--------
 drivers/s390/net/ctcm_sysfs.c | 36 +++++++++++++++++------------------
 5 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/drivers/s390/net/ctcm_dbug.c b/drivers/s390/net/ctcm_dbug.c
index f7ec51db3cd6..b6f0e2f114b4 100644
--- a/drivers/s390/net/ctcm_dbug.c
+++ b/drivers/s390/net/ctcm_dbug.c
@@ -70,7 +70,7 @@ void ctcm_dbf_longtext(enum ctcm_dbf_names dbf_nix, int level, char *fmt, ...)
 	if (!debug_level_enabled(ctcm_dbf[dbf_nix].id, level))
 		return;
 	va_start(args, fmt);
-	vsnprintf(dbf_txt_buf, sizeof(dbf_txt_buf), fmt, args);
+	vscnprintf(dbf_txt_buf, sizeof(dbf_txt_buf), fmt, args);
 	va_end(args);
 
 	debug_text_event(ctcm_dbf[dbf_nix].id, level, dbf_txt_buf);
diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index e0fdd54bfeb7..79fac5314e67 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -1340,7 +1340,7 @@ static int add_channel(struct ccw_device *cdev, enum ctcm_channel_types type,
 					goto nomem_return;
 
 	ch->cdev = cdev;
-	snprintf(ch->id, CTCM_ID_SIZE, "ch-%s", dev_name(&cdev->dev));
+	scnprintf(ch->id, CTCM_ID_SIZE, "ch-%s", dev_name(&cdev->dev));
 	ch->type = type;
 
 	/*
@@ -1505,8 +1505,8 @@ static int ctcm_new_device(struct ccwgroup_device *cgdev)
 
 	type = get_channel_type(&cdev0->id);
 
-	snprintf(read_id, CTCM_ID_SIZE, "ch-%s", dev_name(&cdev0->dev));
-	snprintf(write_id, CTCM_ID_SIZE, "ch-%s", dev_name(&cdev1->dev));
+	scnprintf(read_id, CTCM_ID_SIZE, "ch-%s", dev_name(&cdev0->dev));
+	scnprintf(write_id, CTCM_ID_SIZE, "ch-%s", dev_name(&cdev1->dev));
 
 	ret = add_channel(cdev0, type, priv);
 	if (ret) {
diff --git a/drivers/s390/net/ctcm_main.h b/drivers/s390/net/ctcm_main.h
index 90bd7b3f80c3..25164e8bf13d 100644
--- a/drivers/s390/net/ctcm_main.h
+++ b/drivers/s390/net/ctcm_main.h
@@ -100,6 +100,7 @@ enum ctcm_channel_types {
 #define CTCM_PROTO_MPC		4
 #define CTCM_PROTO_MAX		4
 
+#define CTCM_STATSIZE_LIMIT	64
 #define CTCM_BUFSIZE_LIMIT	65535
 #define CTCM_BUFSIZE_DEFAULT	32768
 #define MPC_BUFSIZE_DEFAULT	CTCM_BUFSIZE_LIMIT
diff --git a/drivers/s390/net/ctcm_mpc.c b/drivers/s390/net/ctcm_mpc.c
index 8ac213a55141..64996c86defc 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -144,9 +144,9 @@ void ctcmpc_dumpit(char *buf, int len)
 
 	for (ct = 0; ct < len; ct++, ptr++, rptr++) {
 		if (sw == 0) {
-			sprintf(addr, "%16.16llx", (__u64)rptr);
+			scnprintf(addr, sizeof(addr), "%16.16llx", (__u64)rptr);
 
-			sprintf(boff, "%4.4X", (__u32)ct);
+			scnprintf(boff, sizeof(boff), "%4.4X", (__u32)ct);
 			bhex[0] = '\0';
 			basc[0] = '\0';
 		}
@@ -155,7 +155,7 @@ void ctcmpc_dumpit(char *buf, int len)
 		if (sw == 8)
 			strcat(bhex, "	");
 
-		sprintf(tbuf, "%2.2llX", (__u64)*ptr);
+		scnprintf(tbuf, sizeof(tbuf), "%2.2llX", (__u64)*ptr);
 
 		tbuf[2] = '\0';
 		strcat(bhex, tbuf);
@@ -171,8 +171,8 @@ void ctcmpc_dumpit(char *buf, int len)
 			continue;
 		if ((strcmp(duphex, bhex)) != 0) {
 			if (dup != 0) {
-				sprintf(tdup,
-					"Duplicate as above to %s", addr);
+				scnprintf(tdup, sizeof(tdup),
+					  "Duplicate as above to %s", addr);
 				ctcm_pr_debug("		       --- %s ---\n",
 						tdup);
 			}
@@ -197,14 +197,16 @@ void ctcmpc_dumpit(char *buf, int len)
 			strcat(basc, " ");
 		}
 		if (dup != 0) {
-			sprintf(tdup, "Duplicate as above to %s", addr);
+			scnprintf(tdup, sizeof(tdup),
+				  "Duplicate as above to %s", addr);
 			ctcm_pr_debug("		       --- %s ---\n", tdup);
 		}
 		ctcm_pr_debug("   %s (+%s) : %s  [%s]\n",
 					addr, boff, bhex, basc);
 	} else {
 		if (dup >= 1) {
-			sprintf(tdup, "Duplicate as above to %s", addr);
+			scnprintf(tdup, sizeof(tdup),
+				  "Duplicate as above to %s", addr);
 			ctcm_pr_debug("		       --- %s ---\n", tdup);
 		}
 		if (dup != 0) {
@@ -291,7 +293,7 @@ static struct net_device *ctcmpc_get_dev(int port_num)
 	struct net_device *dev;
 	struct ctcm_priv *priv;
 
-	sprintf(device, "%s%i", MPC_DEVICE_NAME, port_num);
+	scnprintf(device, sizeof(device), "%s%i", MPC_DEVICE_NAME, port_num);
 
 	dev = __dev_get_by_name(&init_net, device);
 
diff --git a/drivers/s390/net/ctcm_sysfs.c b/drivers/s390/net/ctcm_sysfs.c
index 98680c2cc4e4..0c5d8a3eaa2e 100644
--- a/drivers/s390/net/ctcm_sysfs.c
+++ b/drivers/s390/net/ctcm_sysfs.c
@@ -86,24 +86,24 @@ static void ctcm_print_statistics(struct ctcm_priv *priv)
 		return;
 	p = sbuf;
 
-	p += sprintf(p, "  Device FSM state: %s\n",
-		     fsm_getstate_str(priv->fsm));
-	p += sprintf(p, "  RX channel FSM state: %s\n",
-		     fsm_getstate_str(priv->channel[CTCM_READ]->fsm));
-	p += sprintf(p, "  TX channel FSM state: %s\n",
-		     fsm_getstate_str(priv->channel[CTCM_WRITE]->fsm));
-	p += sprintf(p, "  Max. TX buffer used: %ld\n",
-		     priv->channel[WRITE]->prof.maxmulti);
-	p += sprintf(p, "  Max. chained SKBs: %ld\n",
-		     priv->channel[WRITE]->prof.maxcqueue);
-	p += sprintf(p, "  TX single write ops: %ld\n",
-		     priv->channel[WRITE]->prof.doios_single);
-	p += sprintf(p, "  TX multi write ops: %ld\n",
-		     priv->channel[WRITE]->prof.doios_multi);
-	p += sprintf(p, "  Netto bytes written: %ld\n",
-		     priv->channel[WRITE]->prof.txlen);
-	p += sprintf(p, "  Max. TX IO-time: %u\n",
-		     jiffies_to_usecs(priv->channel[WRITE]->prof.tx_time));
+	p += scnprintf(p, CTCM_STATSIZE_LIMIT, "  Device FSM state: %s\n",
+		       fsm_getstate_str(priv->fsm));
+	p += scnprintf(p, CTCM_STATSIZE_LIMIT, "  RX channel FSM state: %s\n",
+		       fsm_getstate_str(priv->channel[CTCM_READ]->fsm));
+	p += scnprintf(p, CTCM_STATSIZE_LIMIT, "  TX channel FSM state: %s\n",
+		       fsm_getstate_str(priv->channel[CTCM_WRITE]->fsm));
+	p += scnprintf(p, CTCM_STATSIZE_LIMIT, "  Max. TX buffer used: %ld\n",
+		       priv->channel[WRITE]->prof.maxmulti);
+	p += scnprintf(p, CTCM_STATSIZE_LIMIT, "  Max. chained SKBs: %ld\n",
+		       priv->channel[WRITE]->prof.maxcqueue);
+	p += scnprintf(p, CTCM_STATSIZE_LIMIT, "  TX single write ops: %ld\n",
+		       priv->channel[WRITE]->prof.doios_single);
+	p += scnprintf(p, CTCM_STATSIZE_LIMIT, "  TX multi write ops: %ld\n",
+		       priv->channel[WRITE]->prof.doios_multi);
+	p += scnprintf(p, CTCM_STATSIZE_LIMIT, "  Netto bytes written: %ld\n",
+		       priv->channel[WRITE]->prof.txlen);
+	p += scnprintf(p, CTCM_STATSIZE_LIMIT, "  Max. TX IO-time: %u\n",
+		       jiffies_to_usecs(priv->channel[WRITE]->prof.tx_time));
 
 	printk(KERN_INFO "Statistics for %s:\n%s",
 				priv->channel[CTCM_WRITE]->netdev->name, sbuf);
-- 
2.39.2


