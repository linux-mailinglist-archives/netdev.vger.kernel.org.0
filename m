Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4415A55544
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 19:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbfFYRAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 13:00:04 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45192 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728506AbfFYRAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 13:00:04 -0400
Received: by mail-qk1-f195.google.com with SMTP id s22so13162680qkj.12
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 10:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BMc+tsEUNehEeh5ES9s+2032ve7Ky7NzNIjTOPHc8VA=;
        b=iV6P8MAylQHFe9nlIhWgKFZeT88nSGt6UD7MM0vZPAltVfUVC7VguXT/Jh7n8pRPCa
         ceTMXyjwRI/kEcb+tPVCwt2tuWBueRAqsXWIjJlziHVU1C8m70k3wjTXXhIaVF9SSYmr
         qBBORBDoA8LpEmQzHWczLX7ne+feudlJXLhoAVoA1OAo1A7ETVPnzMj8YcN87oDy46+9
         xb/qv97ZBhGMOCCpXe6Qvs37nNcI9hnBlRwb+ylrxDEOGdgQIfG5M+HTJsPgZYSLR2mf
         emqe4Zj02W23bPdyW1Jop86yRl3BEem7UEAylLcKDdzIJ7vGgu5HnZUQ6cE9LQ2kri6l
         O4Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BMc+tsEUNehEeh5ES9s+2032ve7Ky7NzNIjTOPHc8VA=;
        b=e72ldolbrjuEEiqqL2ifEU34VvNqqz5WQkRo3AuUzmBbwkTgJdEDgHzVbet1AwXw8j
         RvlXSITjOtLAZ9AfIb9xarp3FRvYw+PROSnFMQoFJhFCTNodjQJstCIu03PGsgXdv4zh
         IcaLIgYRHt1Tpm2uluzlsJndxwaS2ADToX4Mtc7JB8FUvnG62lCaOAIdCCyE2D27GZ6Z
         mUuWsNqUYx3dPcs0TipJfLLXujljZzVLcbopx9j6u/+5cXo86q1i4i5rKQtYK8flPAGp
         zS0xXrRaxdoCHmVByyAYWBRGIebAn9Goz+XEF9QRVC1rnILNeNqRoj1IMirArlLk15Vz
         yFig==
X-Gm-Message-State: APjAAAUIrWJuHRqakbZqzGmZ7yT1ckb4tRBwdNDTZy3aisWNjpucpwze
        wiSWWJbaHUlGgGbImda1kqQrP+g+HiM=
X-Google-Smtp-Source: APXvYqwELEL85cruACcvssGWTD8LY0ilQPUkO2fnBmHJS/ALxAAk78JjahwnAtepjFe7C88FrmpTQw==
X-Received: by 2002:a37:84e:: with SMTP id 75mr22149287qki.499.1561482002877;
        Tue, 25 Jun 2019 10:00:02 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w16sm10197206qtc.41.2019.06.25.10.00.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 10:00:02 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        nafea@amazon.com, dwmw2@infradead.org, sameehj@amazon.com,
        zorik@amazon.com, saeedb@amazon.com, netanel@amazon.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next] Revert "net: ena: ethtool: add extra properties retrieval via get_priv_flags"
Date:   Tue, 25 Jun 2019 09:59:56 -0700
Message-Id: <20190625165956.19278-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 315c28d2b714 ("net: ena: ethtool: add extra properties retrieval via get_priv_flags").

As discussed at netconf and on the mailing list we can't allow
for the the abuse of private flags for exposing arbitrary device
labels.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../net/ethernet/amazon/ena/ena_admin_defs.h  | 16 ----
 drivers/net/ethernet/amazon/ena/ena_com.c     | 56 --------------
 drivers/net/ethernet/amazon/ena/ena_com.h     | 32 --------
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 75 +++----------------
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 14 ----
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  2 -
 6 files changed, 11 insertions(+), 184 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
index c8638f7b5b8e..d19f2ecf8e84 100644
--- a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
@@ -32,8 +32,6 @@
 #ifndef _ENA_ADMIN_H_
 #define _ENA_ADMIN_H_
 
-#define ENA_ADMIN_EXTRA_PROPERTIES_STRING_LEN 32
-#define ENA_ADMIN_EXTRA_PROPERTIES_COUNT     32
 
 enum ena_admin_aq_opcode {
 	ENA_ADMIN_CREATE_SQ                         = 1,
@@ -62,8 +60,6 @@ enum ena_admin_aq_feature_id {
 	ENA_ADMIN_MAX_QUEUES_NUM                    = 2,
 	ENA_ADMIN_HW_HINTS                          = 3,
 	ENA_ADMIN_LLQ                               = 4,
-	ENA_ADMIN_EXTRA_PROPERTIES_STRINGS          = 5,
-	ENA_ADMIN_EXTRA_PROPERTIES_FLAGS            = 6,
 	ENA_ADMIN_MAX_QUEUES_EXT                    = 7,
 	ENA_ADMIN_RSS_HASH_FUNCTION                 = 10,
 	ENA_ADMIN_STATELESS_OFFLOAD_CONFIG          = 11,
@@ -599,14 +595,6 @@ struct ena_admin_set_feature_mtu_desc {
 	u32 mtu;
 };
 
-struct ena_admin_get_extra_properties_strings_desc {
-	u32 count;
-};
-
-struct ena_admin_get_extra_properties_flags_desc {
-	u32 flags;
-};
-
 struct ena_admin_set_feature_host_attr_desc {
 	/* host OS info base address in OS memory. host info is 4KB of
 	 * physically contiguous
@@ -926,10 +914,6 @@ struct ena_admin_get_feat_resp {
 		struct ena_admin_feature_intr_moder_desc intr_moderation;
 
 		struct ena_admin_ena_hw_hints hw_hints;
-
-		struct ena_admin_get_extra_properties_strings_desc extra_properties_strings;
-
-		struct ena_admin_get_extra_properties_flags_desc extra_properties_flags;
 	} u;
 };
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 56781609c3af..911a2e7a375a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1896,62 +1896,6 @@ int ena_com_get_link_params(struct ena_com_dev *ena_dev,
 	return ena_com_get_feature(ena_dev, resp, ENA_ADMIN_LINK_CONFIG, 0);
 }
 
-int ena_com_extra_properties_strings_init(struct ena_com_dev *ena_dev)
-{
-	struct ena_admin_get_feat_resp resp;
-	struct ena_extra_properties_strings *extra_properties_strings =
-			&ena_dev->extra_properties_strings;
-	u32 rc;
-
-	extra_properties_strings->size = ENA_ADMIN_EXTRA_PROPERTIES_COUNT *
-		ENA_ADMIN_EXTRA_PROPERTIES_STRING_LEN;
-
-	extra_properties_strings->virt_addr =
-		dma_alloc_coherent(ena_dev->dmadev,
-				   extra_properties_strings->size,
-				   &extra_properties_strings->dma_addr,
-				   GFP_KERNEL);
-	if (unlikely(!extra_properties_strings->virt_addr)) {
-		pr_err("Failed to allocate extra properties strings\n");
-		return 0;
-	}
-
-	rc = ena_com_get_feature_ex(ena_dev, &resp,
-				    ENA_ADMIN_EXTRA_PROPERTIES_STRINGS,
-				    extra_properties_strings->dma_addr,
-				    extra_properties_strings->size, 0);
-	if (rc) {
-		pr_debug("Failed to get extra properties strings\n");
-		goto err;
-	}
-
-	return resp.u.extra_properties_strings.count;
-err:
-	ena_com_delete_extra_properties_strings(ena_dev);
-	return 0;
-}
-
-void ena_com_delete_extra_properties_strings(struct ena_com_dev *ena_dev)
-{
-	struct ena_extra_properties_strings *extra_properties_strings =
-				&ena_dev->extra_properties_strings;
-
-	if (extra_properties_strings->virt_addr) {
-		dma_free_coherent(ena_dev->dmadev,
-				  extra_properties_strings->size,
-				  extra_properties_strings->virt_addr,
-				  extra_properties_strings->dma_addr);
-		extra_properties_strings->virt_addr = NULL;
-	}
-}
-
-int ena_com_get_extra_properties_flags(struct ena_com_dev *ena_dev,
-				       struct ena_admin_get_feat_resp *resp)
-{
-	return ena_com_get_feature(ena_dev, resp,
-				   ENA_ADMIN_EXTRA_PROPERTIES_FLAGS, 0);
-}
-
 int ena_com_get_dev_attr_feat(struct ena_com_dev *ena_dev,
 			      struct ena_com_dev_get_features_ctx *get_feat_ctx)
 {
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index 4700d92a317b..0d3664fe260d 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -352,12 +352,6 @@ struct ena_host_attribute {
 	dma_addr_t host_info_dma_addr;
 };
 
-struct ena_extra_properties_strings {
-	u8 *virt_addr;
-	dma_addr_t dma_addr;
-	u32 size;
-};
-
 /* Each ena_dev is a PCI function. */
 struct ena_com_dev {
 	struct ena_com_admin_queue admin_queue;
@@ -386,7 +380,6 @@ struct ena_com_dev {
 	struct ena_intr_moder_entry *intr_moder_tbl;
 
 	struct ena_com_llq_info llq_info;
-	struct ena_extra_properties_strings extra_properties_strings;
 };
 
 struct ena_com_dev_get_features_ctx {
@@ -620,31 +613,6 @@ int ena_com_validate_version(struct ena_com_dev *ena_dev);
 int ena_com_get_link_params(struct ena_com_dev *ena_dev,
 			    struct ena_admin_get_feat_resp *resp);
 
-/* ena_com_extra_properties_strings_init - Initialize the extra properties strings buffer.
- * @ena_dev: ENA communication layer struct
- *
- * Initialize the extra properties strings buffer.
- */
-int ena_com_extra_properties_strings_init(struct ena_com_dev *ena_dev);
-
-/* ena_com_delete_extra_properties_strings - Free the extra properties strings buffer.
- * @ena_dev: ENA communication layer struct
- *
- * Free the allocated extra properties strings buffer.
- */
-void ena_com_delete_extra_properties_strings(struct ena_com_dev *ena_dev);
-
-/* ena_com_get_extra_properties_flags - Retrieve extra properties flags.
- * @ena_dev: ENA communication layer struct
- * @resp: Extra properties flags.
- *
- * Retrieve the extra properties flags.
- *
- * @return - 0 on Success negative value otherwise.
- */
-int ena_com_get_extra_properties_flags(struct ena_com_dev *ena_dev,
-				       struct ena_admin_get_feat_resp *resp);
-
 /* ena_com_get_dma_width - Retrieve physical dma address width the device
  * supports.
  * @ena_dev: ENA communication layer struct
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index b46f069ac0eb..b997c3ce9e2b 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -198,24 +198,15 @@ static void ena_get_ethtool_stats(struct net_device *netdev,
 	ena_dev_admin_queue_stats(adapter, &data);
 }
 
-static int get_stats_sset_count(struct ena_adapter *adapter)
-{
-	return  adapter->num_queues * (ENA_STATS_ARRAY_TX + ENA_STATS_ARRAY_RX)
-		+ ENA_STATS_ARRAY_GLOBAL + ENA_STATS_ARRAY_ENA_COM;
-}
-
 int ena_get_sset_count(struct net_device *netdev, int sset)
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
 
-	switch (sset) {
-	case ETH_SS_STATS:
-		return get_stats_sset_count(adapter);
-	case ETH_SS_PRIV_FLAGS:
-		return adapter->ena_extra_properties_count;
-	default:
+	if (sset != ETH_SS_STATS)
 		return -EOPNOTSUPP;
-	}
+
+	return  adapter->num_queues * (ENA_STATS_ARRAY_TX + ENA_STATS_ARRAY_RX)
+		+ ENA_STATS_ARRAY_GLOBAL + ENA_STATS_ARRAY_ENA_COM;
 }
 
 static void ena_queue_strings(struct ena_adapter *adapter, u8 **data)
@@ -257,54 +248,26 @@ static void ena_com_dev_strings(u8 **data)
 	}
 }
 
-static void get_stats_strings(struct ena_adapter *adapter, u8 *data)
+static void ena_get_strings(struct net_device *netdev, u32 sset, u8 *data)
 {
+	struct ena_adapter *adapter = netdev_priv(netdev);
 	const struct ena_stats *ena_stats;
 	int i;
 
+	if (sset != ETH_SS_STATS)
+		return;
+
 	for (i = 0; i < ENA_STATS_ARRAY_GLOBAL; i++) {
 		ena_stats = &ena_stats_global_strings[i];
+
 		memcpy(data, ena_stats->name, ETH_GSTRING_LEN);
 		data += ETH_GSTRING_LEN;
 	}
+
 	ena_queue_strings(adapter, &data);
 	ena_com_dev_strings(&data);
 }
 
-static void get_private_flags_strings(struct ena_adapter *adapter, u8 *data)
-{
-	struct ena_com_dev *ena_dev = adapter->ena_dev;
-	u8 *strings = ena_dev->extra_properties_strings.virt_addr;
-	int i;
-
-	if (unlikely(!strings)) {
-		adapter->ena_extra_properties_count = 0;
-		return;
-	}
-
-	for (i = 0; i < adapter->ena_extra_properties_count; i++) {
-		strlcpy(data, strings + ENA_ADMIN_EXTRA_PROPERTIES_STRING_LEN * i,
-			ETH_GSTRING_LEN);
-		data += ETH_GSTRING_LEN;
-	}
-}
-
-static void ena_get_strings(struct net_device *netdev, u32 sset, u8 *data)
-{
-	struct ena_adapter *adapter = netdev_priv(netdev);
-
-	switch (sset) {
-	case ETH_SS_STATS:
-		get_stats_strings(adapter, data);
-		break;
-	case ETH_SS_PRIV_FLAGS:
-		get_private_flags_strings(adapter, data);
-		break;
-	default:
-		break;
-	}
-}
-
 static int ena_get_link_ksettings(struct net_device *netdev,
 				  struct ethtool_link_ksettings *link_ksettings)
 {
@@ -479,7 +442,6 @@ static void ena_get_drvinfo(struct net_device *dev,
 	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
-	info->n_priv_flags = adapter->ena_extra_properties_count;
 }
 
 static void ena_get_ringparam(struct net_device *netdev,
@@ -856,20 +818,6 @@ static int ena_set_tunable(struct net_device *netdev,
 	return ret;
 }
 
-static u32 ena_get_priv_flags(struct net_device *netdev)
-{
-	struct ena_adapter *adapter = netdev_priv(netdev);
-	struct ena_com_dev *ena_dev = adapter->ena_dev;
-	struct ena_admin_get_feat_resp get_resp;
-	u32 rc;
-
-	rc = ena_com_get_extra_properties_flags(ena_dev, &get_resp);
-	if (!rc)
-		return get_resp.u.extra_properties_flags.flags;
-
-	return 0;
-}
-
 static const struct ethtool_ops ena_ethtool_ops = {
 	.get_link_ksettings	= ena_get_link_ksettings,
 	.get_drvinfo		= ena_get_drvinfo,
@@ -892,7 +840,6 @@ static const struct ethtool_ops ena_ethtool_ops = {
 	.get_channels		= ena_get_channels,
 	.get_tunable		= ena_get_tunable,
 	.set_tunable		= ena_set_tunable,
-	.get_priv_flags		= ena_get_priv_flags,
 };
 
 void ena_set_ethtool_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 20ec8ff03aaf..664e3ed97ea9 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2472,14 +2472,6 @@ static void ena_config_debug_area(struct ena_adapter *adapter)
 	ena_com_delete_debug_area(adapter->ena_dev);
 }
 
-static void ena_extra_properties_strings_destroy(struct net_device *netdev)
-{
-	struct ena_adapter *adapter = netdev_priv(netdev);
-
-	ena_com_delete_extra_properties_strings(adapter->ena_dev);
-	adapter->ena_extra_properties_count = 0;
-}
-
 static void ena_get_stats64(struct net_device *netdev,
 			    struct rtnl_link_stats64 *stats)
 {
@@ -3578,9 +3570,6 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ena_config_debug_area(adapter);
 
-	adapter->ena_extra_properties_count =
-		ena_com_extra_properties_strings_init(ena_dev);
-
 	memcpy(adapter->netdev->perm_addr, adapter->mac_addr, netdev->addr_len);
 
 	netif_carrier_off(netdev);
@@ -3620,7 +3609,6 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 err_rss:
-	ena_extra_properties_strings_destroy(netdev);
 	ena_com_delete_debug_area(ena_dev);
 	ena_com_rss_destroy(ena_dev);
 err_free_msix:
@@ -3687,8 +3675,6 @@ static void ena_remove(struct pci_dev *pdev)
 
 	ena_com_delete_host_info(ena_dev);
 
-	ena_extra_properties_strings_destroy(netdev);
-
 	ena_release_bars(ena_dev, pdev);
 
 	pci_disable_device(pdev);
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index f2b6e2e0504d..efbcffd22215 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -378,8 +378,6 @@ struct ena_adapter {
 	u32 last_monitored_tx_qid;
 
 	enum ena_regs_reset_reason_types reset_reason;
-
-	u8 ena_extra_properties_count;
 };
 
 void ena_set_ethtool_ops(struct net_device *netdev);
-- 
2.21.0

