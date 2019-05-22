Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92BB4270EC
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730114AbfEVUlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:41:08 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:59466 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729938AbfEVUlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:41:07 -0400
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4MKbTG3017123;
        Wed, 22 May 2019 21:41:02 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : in-reply-to :
 references; s=jan2016.eng;
 bh=FwvXBlslcYLmy3AG7mrdtPV1pU+TP2G/tCNgxUsboGM=;
 b=Y/wA8zCvyZWF2XHqxrtpdjQk9oxTcZsZMH9R2EIKfm2kWUpDiVTm4DXWAzTbZdFUF9/3
 cRuqWrj3dEdu2aW+D+kZNATqqibH9l1Qp+IQXw2nFBAWRxp929usq5TViG3Y/5cZ7Jh9
 TbE430sq59F8tNXdrsOCMqVEjzD/Plfz8tN2hxzg8M5xEstQnMVisiHT1j1eSVoyuTTZ
 fTo18C9lfRispfe73t5WQr/AxKYvwRKuB5fOsw9RGJhyY24m/mMcNwGncfzgSuetlAUo
 KNAl42anFZObTphRbzJyifypwQ+29tUfCdxJcs0dk16sU239XPOa7vqJONN6P01Sk8WW zA== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 2sn8r5170x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 May 2019 21:41:01 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x4MKX5oF011403;
        Wed, 22 May 2019 16:41:00 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint1.akamai.com with ESMTP id 2sjdcvsjuf-4;
        Wed, 22 May 2019 16:41:00 -0400
Received: from bos-lpjec.kendall.corp.akamai.com (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 536021FC76;
        Wed, 22 May 2019 20:40:30 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net, edumazet@google.com
Cc:     ycheng@google.com, ilubashe@akamai.com, netdev@vger.kernel.org,
        Christoph Paasch <cpaasch@apple.com>
Subject: [PATCH net-next 4/6] tcp: add support for optional TFO backup key to /proc/sys/net/ipv4/tcp_fastopen_key
Date:   Wed, 22 May 2019 16:39:36 -0400
Message-Id: <9cfe2b526d51324770c52510e2bbaf7e7d9b4d27.1558557001.git.jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558557001.git.jbaron@akamai.com>
References: <cover.1558557001.git.jbaron@akamai.com>
In-Reply-To: <cover.1558557001.git.jbaron@akamai.com>
References: <cover.1558557001.git.jbaron@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905220143
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905220144
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the ability to add a backup TFO key as:

# echo "x-x-x-x,x-x-x-x" > /proc/sys/net/ipv4/tcp_fastopen_key

The key before the comma acks as the primary TFO key and the key after the
comma is the backup TFO key. This change is intended to be backwards
compatible since if only one key is set, userspace will simply read back
that single key as follows:

# echo "x-x-x-x" > /proc/sys/net/ipv4/tcp_fastopen_key
# cat /proc/sys/net/ipv4/tcp_fastopen_key
x-x-x-x

Signed-off-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 net/ipv4/sysctl_net_ipv4.c | 95 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 71 insertions(+), 24 deletions(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 72dc8ca..90f09e4 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -277,55 +277,97 @@ static int proc_allowed_congestion_control(struct ctl_table *ctl,
 	return ret;
 }
 
+static int sscanf_key(char *buf, __le32 *key)
+{
+	u32 user_key[4];
+	int i, ret = 0;
+
+	if (sscanf(buf, "%x-%x-%x-%x", user_key, user_key + 1,
+		   user_key + 2, user_key + 3) != 4) {
+		ret = -EINVAL;
+	} else {
+		for (i = 0; i < ARRAY_SIZE(user_key); i++)
+			key[i] = cpu_to_le32(user_key[i]);
+	}
+	pr_debug("proc TFO key set 0x%x-%x-%x-%x <- 0x%s: %u\n",
+		 user_key[0], user_key[1], user_key[2], user_key[3], buf, ret);
+
+	return ret;
+}
+
 static int proc_tcp_fastopen_key(struct ctl_table *table, int write,
 				 void __user *buffer, size_t *lenp,
 				 loff_t *ppos)
 {
 	struct net *net = container_of(table->data, struct net,
 	    ipv4.sysctl_tcp_fastopen);
-	struct ctl_table tbl = { .maxlen = (TCP_FASTOPEN_KEY_LENGTH * 2 + 10) };
-	struct tcp_fastopen_context *ctxt;
-	u32  user_key[4]; /* 16 bytes, matching TCP_FASTOPEN_KEY_LENGTH */
-	__le32 key[4];
-	int ret, i;
+	/* maxlen to print the list of keys in hex (*2), with dashes
+	 * separating doublewords and a comma in between keys.
+	 */
+	struct ctl_table tbl = { .maxlen = ((TCP_FASTOPEN_KEY_LENGTH *
+					    2 * TCP_FASTOPEN_KEY_MAX) +
+					    (TCP_FASTOPEN_KEY_MAX * 5)) };
+	struct tcp_fastopen_context *ctx;
+	u32 user_key[TCP_FASTOPEN_KEY_MAX * 4];
+	__le32 key[TCP_FASTOPEN_KEY_MAX * 4];
+	char *backup_data;
+	int ret, i = 0, off = 0, n_keys = 0;
 
 	tbl.data = kmalloc(tbl.maxlen, GFP_KERNEL);
 	if (!tbl.data)
 		return -ENOMEM;
 
 	rcu_read_lock();
-	ctxt = rcu_dereference(net->ipv4.tcp_fastopen_ctx);
-	if (ctxt)
-		memcpy(key, ctxt->key, TCP_FASTOPEN_KEY_LENGTH);
-	else
-		memset(key, 0, sizeof(key));
+	ctx = rcu_dereference(net->ipv4.tcp_fastopen_ctx);
+	if (ctx) {
+		n_keys = tcp_fastopen_context_len(ctx);
+		memcpy(&key[0], &ctx->key[0], TCP_FASTOPEN_KEY_LENGTH * n_keys);
+	}
 	rcu_read_unlock();
 
-	for (i = 0; i < ARRAY_SIZE(key); i++)
+	if (!n_keys) {
+		memset(&key[0], 0, TCP_FASTOPEN_KEY_LENGTH);
+		n_keys = 1;
+	}
+
+	for (i = 0; i < n_keys * 4; i++)
 		user_key[i] = le32_to_cpu(key[i]);
 
-	snprintf(tbl.data, tbl.maxlen, "%08x-%08x-%08x-%08x",
-		user_key[0], user_key[1], user_key[2], user_key[3]);
+	for (i = 0; i < n_keys; i++) {
+		off += snprintf(tbl.data + off, tbl.maxlen - off,
+				"%08x-%08x-%08x-%08x",
+				user_key[i * 4],
+				user_key[i * 4 + 1],
+				user_key[i * 4 + 2],
+				user_key[i * 4 + 3]);
+		if (i + 1 < n_keys)
+			off += snprintf(tbl.data + off, tbl.maxlen - off, ",");
+	}
+
 	ret = proc_dostring(&tbl, write, buffer, lenp, ppos);
 
 	if (write && ret == 0) {
-		if (sscanf(tbl.data, "%x-%x-%x-%x", user_key, user_key + 1,
-			   user_key + 2, user_key + 3) != 4) {
+		backup_data = strchr(tbl.data, ',');
+		if (backup_data) {
+			*backup_data = '\0';
+			backup_data++;
+		}
+		if (sscanf_key(tbl.data, key)) {
 			ret = -EINVAL;
 			goto bad_key;
 		}
-
-		for (i = 0; i < ARRAY_SIZE(user_key); i++)
-			key[i] = cpu_to_le32(user_key[i]);
-
-		tcp_fastopen_reset_cipher(net, NULL, key, NULL,
+		if (backup_data) {
+			if (sscanf_key(backup_data, key + 4)) {
+				ret = -EINVAL;
+				goto bad_key;
+			}
+		}
+		tcp_fastopen_reset_cipher(net, NULL, key,
+					  backup_data ? key + 4 : NULL,
 					  TCP_FASTOPEN_KEY_LENGTH);
 	}
 
 bad_key:
-	pr_debug("proc FO key set 0x%x-%x-%x-%x <- 0x%s: %u\n",
-		user_key[0], user_key[1], user_key[2], user_key[3],
-	       (char *)tbl.data, ret);
 	kfree(tbl.data);
 	return ret;
 }
@@ -933,7 +975,12 @@ static struct ctl_table ipv4_net_table[] = {
 		.procname	= "tcp_fastopen_key",
 		.mode		= 0600,
 		.data		= &init_net.ipv4.sysctl_tcp_fastopen,
-		.maxlen		= ((TCP_FASTOPEN_KEY_LENGTH * 2) + 10),
+		/* maxlen to print the list of keys in hex (*2), with dashes
+		 * separating doublewords and a comma in between keys.
+		 */
+		.maxlen		= ((TCP_FASTOPEN_KEY_LENGTH *
+				   2 * TCP_FASTOPEN_KEY_MAX) +
+				   (TCP_FASTOPEN_KEY_MAX * 5)),
 		.proc_handler	= proc_tcp_fastopen_key,
 	},
 	{
-- 
2.7.4

