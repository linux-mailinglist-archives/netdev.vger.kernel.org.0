Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274BE2804C5
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 19:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732932AbgJARMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 13:12:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48998 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732213AbgJARLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 13:11:53 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 091H3ukt056364;
        Thu, 1 Oct 2020 13:11:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=GHmI2UthygvcfnHvuF13yT+zX9lcgIC9ZcKx7EbsE4g=;
 b=lXXqlJ1kT02wd9Y5Cs7Wpnexij9s1dwAf9RsqmAzqXqL9zHduOu3ebzMSMM6S13E2mhK
 h0YGGpq4q5NDqXrRPDa1f340p6aJQD+wiOQzcju7aLsXGJJOsB4apnbVrRRwpT/HlUZc
 jf9iQpkwpAOAHRodhQ73a4mRzShHQhmqzUYxUvs23JA1YyzsWA2v4D3o20zQKrHZcDwv
 qCy5I4F/LOSu0XneNwRLhHOeQLXZst1ZSeTlQ1ImHZxd0aPo9GDOZ3mwlc5j4MX3Ollm
 oARSSYeUFjfTfvBu8RsBVszk0AkKubaj4C/SwnTHbr9UPCU2zOIPi2Y+u8fXkILIKOKn iA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33wg81fva9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 13:11:50 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 091H49LT018554;
        Thu, 1 Oct 2020 17:11:46 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 33sw97wrt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 17:11:46 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 091HBi8912583310
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Oct 2020 17:11:44 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 023C4A4053;
        Thu,  1 Oct 2020 17:11:44 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF316A4059;
        Thu,  1 Oct 2020 17:11:43 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Oct 2020 17:11:43 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 6/7] s390/qeth: static checker cleanups
Date:   Thu,  1 Oct 2020 19:11:35 +0200
Message-Id: <20201001171136.46830-7-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001171136.46830-1-jwi@linux.ibm.com>
References: <20201001171136.46830-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_05:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 suspectscore=2 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010010139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Add/delete some blanks, white spaces and braces.
- Fix misindentations.
- Adjust a deprecated header include, and htons() conversion.
- Remove extra 'return' statements.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  7 ++++---
 drivers/s390/net/qeth_core_main.c | 18 +++++++++---------
 drivers/s390/net/qeth_l2_main.c   |  5 ++---
 drivers/s390/net/qeth_l3_main.c   |  7 +++----
 drivers/s390/net/qeth_l3_sys.c    |  8 ++++----
 5 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 39d17ea2eb78..f73b4756ed5e 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -177,8 +177,8 @@ struct qeth_vnicc_info {
 /**
  * some more defs
  */
-#define QETH_TX_TIMEOUT		100 * HZ
-#define QETH_RCD_TIMEOUT	60 * HZ
+#define QETH_TX_TIMEOUT		(100 * HZ)
+#define QETH_RCD_TIMEOUT	(60 * HZ)
 #define QETH_RECLAIM_WORK_TIME	HZ
 #define QETH_MAX_PORTNO		15
 
@@ -1069,7 +1069,8 @@ extern struct qeth_dbf_info qeth_dbf[QETH_DBF_INFOS];
 
 struct net_device *qeth_clone_netdev(struct net_device *orig);
 struct qeth_card *qeth_get_card_by_busid(char *bus_id);
-void qeth_set_allowed_threads(struct qeth_card *, unsigned long , int);
+void qeth_set_allowed_threads(struct qeth_card *card, unsigned long threads,
+			      int clear_start_mask);
 int qeth_threads_running(struct qeth_card *, unsigned long);
 int qeth_set_offline(struct qeth_card *card, bool resetting);
 
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 5fd614278f30..93c9b30ab17a 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -17,6 +17,7 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/log2.h>
+#include <linux/io.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
 #include <linux/mii.h>
@@ -35,7 +36,6 @@
 
 #include <asm/ebcdic.h>
 #include <asm/chpid.h>
-#include <asm/io.h>
 #include <asm/sysinfo.h>
 #include <asm/diag.h>
 #include <asm/cio.h>
@@ -209,9 +209,8 @@ static void qeth_clear_working_pool_list(struct qeth_card *card)
 
 	QETH_CARD_TEXT(card, 5, "clwrklst");
 	list_for_each_entry_safe(pool_entry, tmp,
-			    &card->qdio.in_buf_pool.entry_list, list){
-			list_del(&pool_entry->list);
-	}
+				 &card->qdio.in_buf_pool.entry_list, list)
+		list_del(&pool_entry->list);
 
 	for (i = 0; i < ARRAY_SIZE(queue->bufs); i++)
 		queue->bufs[i].pool_entry = NULL;
@@ -481,6 +480,7 @@ static void qeth_cleanup_handled_pending(struct qeth_qdio_out_q *q, int bidx,
 			    atomic_read(&c->state) ==
 			      QETH_QDIO_BUF_HANDLED_DELAYED) {
 				struct qeth_qdio_out_buffer *f = c;
+
 				QETH_CARD_TEXT(f->q->card, 5, "fp");
 				QETH_CARD_TEXT_(f->q->card, 5, "%lx", (long) f);
 				/* release here to avoid interleaving between
@@ -507,7 +507,6 @@ static void qeth_cleanup_handled_pending(struct qeth_qdio_out_q *q, int bidx,
 	}
 }
 
-
 static void qeth_qdio_handle_aob(struct qeth_card *card,
 				 unsigned long phys_aob_addr)
 {
@@ -884,6 +883,7 @@ static void qeth_issue_ipa_msg(struct qeth_ipa_cmd *cmd, int rc,
 {
 	const char *ipa_name;
 	int com = cmd->hdr.command;
+
 	ipa_name = qeth_get_ipa_cmd_name(com);
 
 	if (rc)
@@ -1253,7 +1253,7 @@ static int qeth_get_problem(struct qeth_card *card, struct ccw_device *cdev,
 			return 0;
 		}
 		QETH_CARD_TEXT(card, 2, "DGENCHK");
-			return -EIO;
+		return -EIO;
 	}
 	return 0;
 }
@@ -1600,7 +1600,7 @@ static void qeth_start_kernel_thread(struct work_struct *work)
 	struct task_struct *ts;
 	struct qeth_card *card = container_of(work, struct qeth_card,
 					kernel_thread_starter);
-	QETH_CARD_TEXT(card , 2, "strthrd");
+	QETH_CARD_TEXT(card, 2, "strthrd");
 
 	if (card->read.state != CH_STATE_UP &&
 	    card->write.state != CH_STATE_UP)
@@ -3416,7 +3416,6 @@ static void qeth_get_trap_id(struct qeth_card *card, struct qeth_trap_id *tid)
 		memcpy(tid->vmname, info322->vm[0].name, sizeof(tid->vmname));
 	}
 	free_page(info);
-	return;
 }
 
 static int qeth_hw_trap_cb(struct qeth_card *card,
@@ -4998,7 +4997,6 @@ static void qeth_determine_capabilities(struct qeth_card *card)
 		card->options.cq = QETH_CQ_NOTAVAILABLE;
 	}
 
-
 out_offline:
 	if (ddev_offline == 1)
 		qeth_stop_channel(channel);
@@ -6050,6 +6048,7 @@ EXPORT_SYMBOL_GPL(qeth_send_simple_setassparms_prot);
 static void qeth_unregister_dbf_views(void)
 {
 	int x;
+
 	for (x = 0; x < QETH_DBF_INFOS; x++) {
 		debug_unregister(qeth_dbf[x].id);
 		qeth_dbf[x].id = NULL;
@@ -6413,6 +6412,7 @@ static int qeth_core_set_offline(struct ccwgroup_device *gdev)
 static void qeth_core_shutdown(struct ccwgroup_device *gdev)
 {
 	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
+
 	qeth_set_allowed_threads(card, 0, 1);
 	if ((gdev->state == CCWGROUP_ONLINE) && card->info.hwtrap)
 		qeth_hw_trap(card, QETH_DIAGS_TRAP_DISARM);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index a88d0a01e9a5..28f6dda95736 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -183,7 +183,7 @@ static void qeth_l2_fill_header(struct qeth_qdio_out_q *queue,
 	/* VSWITCH relies on the VLAN
 	 * information to be present in
 	 * the QDIO header */
-	if (veth->h_vlan_proto == __constant_htons(ETH_P_8021Q)) {
+	if (veth->h_vlan_proto == htons(ETH_P_8021Q)) {
 		hdr->hdr.l2.flags[2] |= QETH_LAYER2_FLAG_VLAN;
 		hdr->hdr.l2.vlan_id = ntohs(veth->h_vlan_TCI);
 	}
@@ -877,7 +877,7 @@ static const struct net_device_ops qeth_l2_netdev_ops = {
 	.ndo_set_mac_address    = qeth_l2_set_mac_address,
 	.ndo_vlan_rx_add_vid	= qeth_l2_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid   = qeth_l2_vlan_rx_kill_vid,
-	.ndo_tx_timeout	   	= qeth_tx_timeout,
+	.ndo_tx_timeout		= qeth_tx_timeout,
 	.ndo_fix_features	= qeth_fix_features,
 	.ndo_set_features	= qeth_set_features,
 	.ndo_bridge_getlink	= qeth_l2_bridge_getlink,
@@ -1125,7 +1125,6 @@ void qeth_osn_deregister(struct net_device *dev)
 	QETH_CARD_TEXT(card, 2, "osndereg");
 	card->osn_info.assist_cb = NULL;
 	card->osn_info.data_cb = NULL;
-	return;
 }
 EXPORT_SYMBOL(qeth_osn_deregister);
 #endif
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index e7244aa4d191..b1c1d2510d55 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -97,7 +97,7 @@ static bool qeth_l3_is_addr_covered_by_ipato(struct qeth_card *card,
 		return false;
 
 	qeth_l3_convert_addr_to_bits((u8 *) &addr->u, addr_bits,
-				  (addr->proto == QETH_PROT_IPV4)? 4:16);
+				     (addr->proto == QETH_PROT_IPV4) ? 4 : 16);
 	list_for_each_entry(ipatoe, &card->ipato.entries, entry) {
 		if (addr->proto != ipatoe->proto)
 			continue;
@@ -540,7 +540,7 @@ int qeth_l3_add_ipato_entry(struct qeth_card *card,
 		if (ipatoe->proto != new->proto)
 			continue;
 		if (!memcmp(ipatoe->addr, new->addr,
-			    (ipatoe->proto == QETH_PROT_IPV4)? 4:16) &&
+			    (ipatoe->proto == QETH_PROT_IPV4) ? 4 : 16) &&
 		    (ipatoe->mask_bits == new->mask_bits)) {
 			rc = -EEXIST;
 			break;
@@ -572,7 +572,7 @@ int qeth_l3_del_ipato_entry(struct qeth_card *card,
 		if (ipatoe->proto != proto)
 			continue;
 		if (!memcmp(ipatoe->addr, addr,
-			    (proto == QETH_PROT_IPV4)? 4:16) &&
+			    (proto == QETH_PROT_IPV4) ? 4 : 16) &&
 		    (ipatoe->mask_bits == mask_bits)) {
 			list_del(&ipatoe->entry);
 			qeth_l3_update_ipato(card);
@@ -2139,7 +2139,6 @@ static struct qeth_card *qeth_l3_get_card_from_dev(struct net_device *dev)
 static int qeth_l3_ip_event(struct notifier_block *this,
 			    unsigned long event, void *ptr)
 {
-
 	struct in_ifaddr *ifa = (struct in_ifaddr *)ptr;
 	struct net_device *dev = ifa->ifa_dev->dev;
 	struct qeth_ipaddr addr;
diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
index 351763ae9b9c..997fbb7006a7 100644
--- a/drivers/s390/net/qeth_l3_sys.c
+++ b/drivers/s390/net/qeth_l3_sys.c
@@ -285,7 +285,7 @@ static ssize_t qeth_l3_dev_ipato_enable_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%i\n", card->ipato.enabled? 1:0);
+	return sprintf(buf, "%u\n", card->ipato.enabled ? 1 : 0);
 }
 
 static ssize_t qeth_l3_dev_ipato_enable_store(struct device *dev,
@@ -330,7 +330,7 @@ static ssize_t qeth_l3_dev_ipato_invert4_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%i\n", card->ipato.invert4? 1:0);
+	return sprintf(buf, "%u\n", card->ipato.invert4 ? 1 : 0);
 }
 
 static ssize_t qeth_l3_dev_ipato_invert4_store(struct device *dev,
@@ -450,7 +450,7 @@ static ssize_t qeth_l3_dev_ipato_add_store(const char *buf, size_t count,
 		return -ENOMEM;
 
 	ipatoe->proto = proto;
-	memcpy(ipatoe->addr, addr, (proto == QETH_PROT_IPV4)? 4:16);
+	memcpy(ipatoe->addr, addr, (proto == QETH_PROT_IPV4) ? 4 : 16);
 	ipatoe->mask_bits = mask_bits;
 
 	rc = qeth_l3_add_ipato_entry(card, ipatoe);
@@ -501,7 +501,7 @@ static ssize_t qeth_l3_dev_ipato_invert6_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%i\n", card->ipato.invert6? 1:0);
+	return sprintf(buf, "%u\n", card->ipato.invert6 ? 1 : 0);
 }
 
 static ssize_t qeth_l3_dev_ipato_invert6_store(struct device *dev,
-- 
2.17.1

