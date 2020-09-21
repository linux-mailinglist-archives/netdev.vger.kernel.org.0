Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DB3271E23
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 10:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgIUIjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 04:39:15 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:64898 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgIUIjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 04:39:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600677554; x=1632213554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NPP63fdZ5LEC5L16o8EsLZT3LayBNEAZrV0KRJR728M=;
  b=B1xNeWe6OAlB5XscdjwlFi78uBw2GvemyRTjvScAEM+4ENYQIeoMVpx7
   +TPZHARAdexXE/XDvDZ5SXCmPSEBsSiZpEQx/Kj1SIol8RaPVRMWaVU0Q
   Fk6zuAX/C8gniKjqAY53rO20GNNAP4E3rB1JYzPAc+h2Z6wbeax8uqdQV
   A=;
X-IronPort-AV: E=Sophos;i="5.77,286,1596499200"; 
   d="scan'208";a="77823739"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 21 Sep 2020 08:39:14 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com (Postfix) with ESMTPS id 909CAA1C23;
        Mon, 21 Sep 2020 08:39:13 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.162.38) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 21 Sep 2020 08:39:05 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>, Amit Bernstein <amitbern@amazon.com>
Subject: [PATCH V2 net-next 5/7] net: ena: Change RSS related macros and variables names
Date:   Mon, 21 Sep 2020 11:37:40 +0300
Message-ID: <20200921083742.6454-6-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921083742.6454-1-shayagr@amazon.com>
References: <20200921083742.6454-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.38]
X-ClientProxiedBy: EX13D31UWC003.ant.amazon.com (10.43.162.34) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The formal name changes to "ENA_ADMIN_RSS_INDIRECTION_TABLE_CONFIG".
Indirection is the ability to reference "something" using "something else"
instead of the value itself.
Indirection table, as the name implies, is the ability to reference
CPU/Queue value using hash-to-CPU table instead of CPU/Queue itself.

This patch renames the variable keys_num, which describes the number of
words in the RSS hash key, to key_parts which makes its purpose clearer
in RSS context.

Signed-off-by: Amit Bernstein <amitbern@amazon.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 .../device_drivers/ethernet/amazon/ena.rst    |  2 +-
 .../net/ethernet/amazon/ena/ena_admin_defs.h  |  7 +++---
 drivers/net/ethernet/amazon/ena/ena_com.c     | 22 +++++++++----------
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
index 11af6388ea87..a666913d9b5b 100644
--- a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
+++ b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
@@ -274,7 +274,7 @@ RSS
   inputs for hash functions.
 - The driver configures RSS settings using the AQ SetFeature command
   (ENA_ADMIN_RSS_HASH_FUNCTION, ENA_ADMIN_RSS_HASH_INPUT and
-  ENA_ADMIN_RSS_REDIRECTION_TABLE_CONFIG properties).
+  ENA_ADMIN_RSS_INDIRECTION_TABLE_CONFIG properties).
 - If the NETIF_F_RXHASH flag is set, the 32-bit result of the hash
   function delivered in the Rx CQ descriptor is set in the received
   SKB.
diff --git a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
index 9e6d1e28c909..4164eacc5c28 100644
--- a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
@@ -5,6 +5,7 @@
 #ifndef _ENA_ADMIN_H_
 #define _ENA_ADMIN_H_
 
+#define ENA_ADMIN_RSS_KEY_PARTS              10
 
 enum ena_admin_aq_opcode {
 	ENA_ADMIN_CREATE_SQ                         = 1,
@@ -37,7 +38,7 @@ enum ena_admin_aq_feature_id {
 	ENA_ADMIN_MAX_QUEUES_EXT                    = 7,
 	ENA_ADMIN_RSS_HASH_FUNCTION                 = 10,
 	ENA_ADMIN_STATELESS_OFFLOAD_CONFIG          = 11,
-	ENA_ADMIN_RSS_REDIRECTION_TABLE_CONFIG      = 12,
+	ENA_ADMIN_RSS_INDIRECTION_TABLE_CONFIG      = 12,
 	ENA_ADMIN_MTU                               = 14,
 	ENA_ADMIN_RSS_HASH_INPUT                    = 18,
 	ENA_ADMIN_INTERRUPT_MODERATION              = 20,
@@ -716,11 +717,11 @@ enum ena_admin_hash_functions {
 };
 
 struct ena_admin_feature_rss_flow_hash_control {
-	u32 keys_num;
+	u32 key_parts;
 
 	u32 reserved;
 
-	u32 key[10];
+	u32 key[ENA_ADMIN_RSS_KEY_PARTS];
 };
 
 struct ena_admin_feature_rss_flow_hash_function {
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 065098e10582..2e2366d406f6 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1055,11 +1055,10 @@ static void ena_com_hash_key_fill_default_key(struct ena_com_dev *ena_dev)
 		(ena_dev->rss).hash_key;
 
 	netdev_rss_key_fill(&hash_key->key, sizeof(hash_key->key));
-	/* The key is stored in the device in u32 array
-	 * as well as the API requires the key to be passed in this
-	 * format. Thus the size of our array should be divided by 4
+	/* The key buffer is stored in the device in an array of
+	 * uint32 elements.
 	 */
-	hash_key->keys_num = sizeof(hash_key->key) / sizeof(u32);
+	hash_key->key_parts = ENA_ADMIN_RSS_KEY_PARTS;
 }
 
 static int ena_com_hash_key_allocate(struct ena_com_dev *ena_dev)
@@ -1123,7 +1122,7 @@ static int ena_com_indirect_table_allocate(struct ena_com_dev *ena_dev,
 	int ret;
 
 	ret = ena_com_get_feature(ena_dev, &get_resp,
-				  ENA_ADMIN_RSS_REDIRECTION_TABLE_CONFIG, 0);
+				  ENA_ADMIN_RSS_INDIRECTION_TABLE_CONFIG, 0);
 	if (unlikely(ret))
 		return ret;
 
@@ -2335,7 +2334,7 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
 			}
 			memcpy(hash_key->key, key, key_len);
 			rss->hash_init_val = init_val;
-			hash_key->keys_num = key_len >> 2;
+			hash_key->key_parts = key_len / sizeof(hash_key->key[0]);
 		}
 		break;
 	case ENA_ADMIN_CRC32:
@@ -2390,7 +2389,8 @@ int ena_com_get_hash_key(struct ena_com_dev *ena_dev, u8 *key)
 		ena_dev->rss.hash_key;
 
 	if (key)
-		memcpy(key, hash_key->key, (size_t)(hash_key->keys_num) << 2);
+		memcpy(key, hash_key->key,
+		       (size_t)(hash_key->key_parts) * sizeof(hash_key->key[0]));
 
 	return 0;
 }
@@ -2585,9 +2585,9 @@ int ena_com_indirect_table_set(struct ena_com_dev *ena_dev)
 	int ret;
 
 	if (!ena_com_check_supported_feature_id(
-		    ena_dev, ENA_ADMIN_RSS_REDIRECTION_TABLE_CONFIG)) {
+		    ena_dev, ENA_ADMIN_RSS_INDIRECTION_TABLE_CONFIG)) {
 		pr_debug("Feature %d isn't supported\n",
-			 ENA_ADMIN_RSS_REDIRECTION_TABLE_CONFIG);
+			 ENA_ADMIN_RSS_INDIRECTION_TABLE_CONFIG);
 		return -EOPNOTSUPP;
 	}
 
@@ -2602,7 +2602,7 @@ int ena_com_indirect_table_set(struct ena_com_dev *ena_dev)
 	cmd.aq_common_descriptor.opcode = ENA_ADMIN_SET_FEATURE;
 	cmd.aq_common_descriptor.flags =
 		ENA_ADMIN_AQ_COMMON_DESC_CTRL_DATA_INDIRECT_MASK;
-	cmd.feat_common.feature_id = ENA_ADMIN_RSS_REDIRECTION_TABLE_CONFIG;
+	cmd.feat_common.feature_id = ENA_ADMIN_RSS_INDIRECTION_TABLE_CONFIG;
 	cmd.u.ind_table.size = rss->tbl_log_size;
 	cmd.u.ind_table.inline_index = 0xFFFFFFFF;
 
@@ -2640,7 +2640,7 @@ int ena_com_indirect_table_get(struct ena_com_dev *ena_dev, u32 *ind_tbl)
 		sizeof(struct ena_admin_rss_ind_table_entry);
 
 	rc = ena_com_get_feature_ex(ena_dev, &get_resp,
-				    ENA_ADMIN_RSS_REDIRECTION_TABLE_CONFIG,
+				    ENA_ADMIN_RSS_INDIRECTION_TABLE_CONFIG,
 				    rss->rss_ind_tbl_dma_addr,
 				    tbl_size, 0);
 	if (unlikely(rc))
-- 
2.17.1

