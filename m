Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934F669060D
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjBILEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjBILEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:04:40 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CFB7EDA;
        Thu,  9 Feb 2023 03:04:36 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319AtAPb023365;
        Thu, 9 Feb 2023 11:04:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=cwJ1knHTB099pnKVLyWNPdoaJAXcduGRe2VIIXyQbD4=;
 b=MtKblGLuF3EeeWDLuVyx4gc1yK/MhjepZu9r5tDo/xZPpjQVhMOqyeXehnU8Vmly+kuV
 aoGEw2thswKbzKQ3/wxRkWk7tA+sUM9v0p+O0MsEJGRh2s2dqwAp5QAQZA2zZpHTQkSz
 5fbl71Bj1vZQTLcBbp+LjdeaOudoAXnDV/8Rb4Vf127iBL02sMNdiOqWDCpAOJUJTlor
 ZedWAma1Iv00ZAddXf9R9IYsYbS213fBnH6ebBBQs7GnYqyRvTArJ8W+zNgKDZZetgqd
 v3Eo00z3KGBTb/vr+mXOUZN/7YQILMljAZedgBCb9VitciA9luyKQmjVDxEw6PCG0Rs9 Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmygjg76n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 11:04:33 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 319AtkMT024902;
        Thu, 9 Feb 2023 11:04:33 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmygjg75v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 11:04:33 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 318MYcI1005521;
        Thu, 9 Feb 2023 11:04:30 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3nhf06vada-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 11:04:30 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319B4Rpr23855716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 11:04:27 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B2A020040;
        Thu,  9 Feb 2023 11:04:27 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4A972004B;
        Thu,  9 Feb 2023 11:04:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu,  9 Feb 2023 11:04:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id B77C0E12A7; Thu,  9 Feb 2023 12:04:26 +0100 (CET)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Jules Irenge <jbi.octave@gmail.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next v2 4/4] s390/qeth: Convert sprintf/snprintf to scnprintf
Date:   Thu,  9 Feb 2023 12:04:24 +0100
Message-Id: <20230209110424.1707501-5-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230209110424.1707501-1-wintera@linux.ibm.com>
References: <20230209110424.1707501-1-wintera@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iiLiOs2hatZU0bLeKsu1xA5VS9ZYrK6J
X-Proofpoint-GUID: 4WQJZqOsWn_G1rD7BVCYBp8HEwZuYTmt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_08,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090105
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thorsten Winkler <twinkler@linux.ibm.com>

This LWN article explains the rationale for this change
https: //lwn.net/Articles/69419/
Ie. snprintf() returns what *would* be the resulting length,
while scnprintf() returns the actual length.

Reported-by: Jules Irenge <jbi.octave@gmail.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Thorsten Winkler <twinkler@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 14 ++++----
 drivers/s390/net/qeth_ethtool.c   |  6 ++--
 drivers/s390/net/qeth_l2_main.c   | 53 ++++++++++++++++---------------
 drivers/s390/net/qeth_l3_main.c   |  4 +--
 drivers/s390/net/qeth_l3_sys.c    |  4 +--
 5 files changed, 42 insertions(+), 39 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 8bd9fd51208c..1d5b207c2b9e 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2801,9 +2801,11 @@ static void qeth_print_status_message(struct qeth_card *card)
 		 * of the level OSA sets the first character to zero
 		 * */
 		if (!card->info.mcl_level[0]) {
-			sprintf(card->info.mcl_level, "%02x%02x",
-				card->info.mcl_level[2],
-				card->info.mcl_level[3]);
+			scnprintf(card->info.mcl_level,
+				  sizeof(card->info.mcl_level),
+				  "%02x%02x",
+				  card->info.mcl_level[2],
+				  card->info.mcl_level[3]);
 			break;
 		}
 		fallthrough;
@@ -6090,7 +6092,7 @@ void qeth_dbf_longtext(debug_info_t *id, int level, char *fmt, ...)
 	if (!debug_level_enabled(id, level))
 		return;
 	va_start(args, fmt);
-	vsnprintf(dbf_txt_buf, sizeof(dbf_txt_buf), fmt, args);
+	vscnprintf(dbf_txt_buf, sizeof(dbf_txt_buf), fmt, args);
 	va_end(args);
 	debug_text_event(id, level, dbf_txt_buf);
 }
@@ -6330,8 +6332,8 @@ static int qeth_core_probe_device(struct ccwgroup_device *gdev)
 		goto err_dev;
 	}
 
-	snprintf(dbf_name, sizeof(dbf_name), "qeth_card_%s",
-		dev_name(&gdev->dev));
+	scnprintf(dbf_name, sizeof(dbf_name), "qeth_card_%s",
+		  dev_name(&gdev->dev));
 	card->debug = qeth_get_dbf_entry(dbf_name);
 	if (!card->debug) {
 		rc = qeth_add_dbf_entry(card, dbf_name);
diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index e250f49535fa..c1caf7734c3e 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -172,7 +172,7 @@ static void qeth_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 		qeth_add_stat_strings(&data, prefix, card_stats,
 				      CARD_STATS_LEN);
 		for (i = 0; i < card->qdio.no_out_queues; i++) {
-			snprintf(prefix, ETH_GSTRING_LEN, "tx%u ", i);
+			scnprintf(prefix, ETH_GSTRING_LEN, "tx%u ", i);
 			qeth_add_stat_strings(&data, prefix, txq_stats,
 					      TXQ_STATS_LEN);
 		}
@@ -192,8 +192,8 @@ static void qeth_get_drvinfo(struct net_device *dev,
 		sizeof(info->driver));
 	strscpy(info->fw_version, card->info.mcl_level,
 		sizeof(info->fw_version));
-	snprintf(info->bus_info, sizeof(info->bus_info), "%s/%s/%s",
-		 CARD_RDEV_ID(card), CARD_WDEV_ID(card), CARD_DDEV_ID(card));
+	scnprintf(info->bus_info, sizeof(info->bus_info), "%s/%s/%s",
+		  CARD_RDEV_ID(card), CARD_WDEV_ID(card), CARD_DDEV_ID(card));
 }
 
 static void qeth_get_channels(struct net_device *dev,
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index c6ded3fdd715..9f13ed170a43 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1255,37 +1255,38 @@ static void qeth_bridge_emit_host_event(struct qeth_card *card,
 
 	switch (evtype) {
 	case anev_reg_unreg:
-		snprintf(str[i], sizeof(str[i]), "BRIDGEDHOST=%s",
-				(code & IPA_ADDR_CHANGE_CODE_REMOVAL)
-				? "deregister" : "register");
+		scnprintf(str[i], sizeof(str[i]), "BRIDGEDHOST=%s",
+			  (code & IPA_ADDR_CHANGE_CODE_REMOVAL)
+			  ? "deregister" : "register");
 		env[i] = str[i]; i++;
 		if (code & IPA_ADDR_CHANGE_CODE_VLANID) {
-			snprintf(str[i], sizeof(str[i]), "VLAN=%d",
-				addr_lnid->lnid);
+			scnprintf(str[i], sizeof(str[i]), "VLAN=%d",
+				  addr_lnid->lnid);
 			env[i] = str[i]; i++;
 		}
 		if (code & IPA_ADDR_CHANGE_CODE_MACADDR) {
-			snprintf(str[i], sizeof(str[i]), "MAC=%pM",
-				addr_lnid->mac);
+			scnprintf(str[i], sizeof(str[i]), "MAC=%pM",
+				  addr_lnid->mac);
 			env[i] = str[i]; i++;
 		}
-		snprintf(str[i], sizeof(str[i]), "NTOK_BUSID=%x.%x.%04x",
-			token->cssid, token->ssid, token->devnum);
+		scnprintf(str[i], sizeof(str[i]), "NTOK_BUSID=%x.%x.%04x",
+			  token->cssid, token->ssid, token->devnum);
 		env[i] = str[i]; i++;
-		snprintf(str[i], sizeof(str[i]), "NTOK_IID=%02x", token->iid);
+		scnprintf(str[i], sizeof(str[i]), "NTOK_IID=%02x", token->iid);
 		env[i] = str[i]; i++;
-		snprintf(str[i], sizeof(str[i]), "NTOK_CHPID=%02x",
-				token->chpid);
+		scnprintf(str[i], sizeof(str[i]), "NTOK_CHPID=%02x",
+			  token->chpid);
 		env[i] = str[i]; i++;
-		snprintf(str[i], sizeof(str[i]), "NTOK_CHID=%04x", token->chid);
+		scnprintf(str[i], sizeof(str[i]), "NTOK_CHID=%04x",
+			  token->chid);
 		env[i] = str[i]; i++;
 		break;
 	case anev_abort:
-		snprintf(str[i], sizeof(str[i]), "BRIDGEDHOST=abort");
+		scnprintf(str[i], sizeof(str[i]), "BRIDGEDHOST=abort");
 		env[i] = str[i]; i++;
 		break;
 	case anev_reset:
-		snprintf(str[i], sizeof(str[i]), "BRIDGEDHOST=reset");
+		scnprintf(str[i], sizeof(str[i]), "BRIDGEDHOST=reset");
 		env[i] = str[i]; i++;
 		break;
 	}
@@ -1314,17 +1315,17 @@ static void qeth_bridge_state_change_worker(struct work_struct *work)
 		NULL
 	};
 
-	snprintf(env_locrem, sizeof(env_locrem), "BRIDGEPORT=statechange");
-	snprintf(env_role, sizeof(env_role), "ROLE=%s",
-		(data->role == QETH_SBP_ROLE_NONE) ? "none" :
-		(data->role == QETH_SBP_ROLE_PRIMARY) ? "primary" :
-		(data->role == QETH_SBP_ROLE_SECONDARY) ? "secondary" :
-		"<INVALID>");
-	snprintf(env_state, sizeof(env_state), "STATE=%s",
-		(data->state == QETH_SBP_STATE_INACTIVE) ? "inactive" :
-		(data->state == QETH_SBP_STATE_STANDBY) ? "standby" :
-		(data->state == QETH_SBP_STATE_ACTIVE) ? "active" :
-		"<INVALID>");
+	scnprintf(env_locrem, sizeof(env_locrem), "BRIDGEPORT=statechange");
+	scnprintf(env_role, sizeof(env_role), "ROLE=%s",
+		  (data->role == QETH_SBP_ROLE_NONE) ? "none" :
+		  (data->role == QETH_SBP_ROLE_PRIMARY) ? "primary" :
+		  (data->role == QETH_SBP_ROLE_SECONDARY) ? "secondary" :
+		  "<INVALID>");
+	scnprintf(env_state, sizeof(env_state), "STATE=%s",
+		  (data->state == QETH_SBP_STATE_INACTIVE) ? "inactive" :
+		  (data->state == QETH_SBP_STATE_STANDBY) ? "standby" :
+		  (data->state == QETH_SBP_STATE_ACTIVE) ? "active" :
+		  "<INVALID>");
 	kobject_uevent_env(&data->card->gdev->dev.kobj,
 				KOBJ_CHANGE, env);
 	kfree(data);
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 1cf4e354693f..af4e60d2917e 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -47,9 +47,9 @@ int qeth_l3_ipaddr_to_string(enum qeth_prot_versions proto, const u8 *addr,
 			     char *buf)
 {
 	if (proto == QETH_PROT_IPV4)
-		return sprintf(buf, "%pI4", addr);
+		return scnprintf(buf, INET_ADDRSTRLEN, "%pI4", addr);
 	else
-		return sprintf(buf, "%pI6", addr);
+		return scnprintf(buf, INET6_ADDRSTRLEN, "%pI6", addr);
 }
 
 static struct qeth_ipaddr *qeth_l3_find_addr_by_ip(struct qeth_card *card,
diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
index f3986c6e21b9..9f90a860ca2c 100644
--- a/drivers/s390/net/qeth_l3_sys.c
+++ b/drivers/s390/net/qeth_l3_sys.c
@@ -252,8 +252,8 @@ static ssize_t qeth_l3_dev_hsuid_store(struct device *dev,
 		goto out;
 	}
 
-	snprintf(card->options.hsuid, sizeof(card->options.hsuid),
-		 "%-8s", tmp);
+	scnprintf(card->options.hsuid, sizeof(card->options.hsuid),
+		  "%-8s", tmp);
 	ASCEBC(card->options.hsuid, 8);
 	memcpy(card->dev->perm_addr, card->options.hsuid, 9);
 
-- 
2.37.2

