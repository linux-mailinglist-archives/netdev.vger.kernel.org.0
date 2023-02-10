Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41173691F7B
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 14:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbjBJNEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 08:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbjBJNEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 08:04:06 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E183F77167
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 05:04:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2zwkyT7XGlMLdhaAQo3i3gGp1PAQACWWyBNgfeTOfd6fV1EHm76gcga7FOSKEIJuhf5JtO+pR/MTuTUln4cpDmaesYEnIBHuOksrehA3Dxu+GW/qsZ/ijEwmNPLm/5Ssc3H9JlndgzNo9xBtZZ2jFhpB/qUVu16tDQL58yhMtVnQaDtrzANMHdYdsR3N4GuY57vDdmp1dfFSgxHIJRMwzXQtQbcbuIfRmf7HFSmCMISO9+OxyrzQfEDvcwPl7AL9beDCN7SsMQs8O9WxO38hk5fxnIbqGdrbS5ZSuebsYp4OIF+1+ssrEI2JAftIENVIuJes0ittukM5HDtLaGiqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SXTFXFj8qmmqr+ihbU+DaE20bDJQQ0nfsflUg846rbE=;
 b=A4uC00Jbkku877YS6U7exk3gGBUoP8nJ9s/xNnaBI/AZNN3uNF4xj8oCscjTFpjfWViWsa8FoWlx3GblwmYCUyKjQt7II1Xd7j5WNdsmRsIOQJta0Sfo15UKwKqECItsCwhXd2WPbYxY9U7C1L/BJ7foUWdgCkAoh5hFlxm2zpWvczEjH2l+tInocZgsBKcSEASeu8fp7g+o+s7a1arepCGrwGIi600x6GVE1S7RbENwyuWBeBgA3fy9fnFzGJYyY/u46mSmRWD/y1qFArGxBRL0EN+Q5kZFedlWm2s9KPhx+LuVey9sVP8eTzlfRCU13aLaJ3V1eEkDP3YMGrPGtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXTFXFj8qmmqr+ihbU+DaE20bDJQQ0nfsflUg846rbE=;
 b=TLmP7sJjVbRWuvbyC/AKnhVkgr/Xd/lstn2HujEMEhnkJnVX2BWHWLnQip5NKsoS3Yi3cLksVJpOSyMXjdVwhaXS8GeW1inDZs7pK3OKhmFm/gDcr4DrzKL7w3+UJHDXfNr1Te0pQJ3lXGxc1F1Q1R8WTLEbW0sTYphlUcyGoLQ=
Received: from BN0PR04CA0033.namprd04.prod.outlook.com (2603:10b6:408:e8::8)
 by SJ0PR12MB5454.namprd12.prod.outlook.com (2603:10b6:a03:304::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 13:03:56 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e8:cafe::19) by BN0PR04CA0033.outlook.office365.com
 (2603:10b6:408:e8::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21 via Frontend
 Transport; Fri, 10 Feb 2023 13:03:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.21 via Frontend Transport; Fri, 10 Feb 2023 13:03:56 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 07:03:55 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 07:03:54 -0600
Received: from xhdipdslab59.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Fri, 10 Feb 2023 07:03:51 -0600
From:   Harsh Jain <h.jain@amd.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <thomas.lendacky@amd.com>,
        <Raju.Rangoju@amd.com>, <Shyam-sundar.S-k@amd.com>,
        <harshjain.prof@gmail.com>, <abhijit.gangurde@amd.com>,
        <puneet.gupta@amd.com>, <nikhil.agarwal@amd.com>,
        <tarak.reddy@amd.com>, <netdev@vger.kernel.org>
CC:     Harsh Jain <h.jain@amd.com>
Subject: [PATCH  5/6] net: ethernet: efct: Add ethtool support
Date:   Fri, 10 Feb 2023 18:33:20 +0530
Message-ID: <20230210130321.2898-6-h.jain@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230210130321.2898-1-h.jain@amd.com>
References: <20230210130321.2898-1-h.jain@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT009:EE_|SJ0PR12MB5454:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fc31377-3999-44ee-11b2-08db0b67448a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8gLqqJNwq7RSdeVV943rNKBRb1k+FmJ5zHeLa1my8zjaRze2TPyLDZYKwqiywwgxL21QehYDGaAC0MlkhwPbuaW/FjhTsqCHPoZHmdVSkm1EZ0EqUVdDys00+LfeVoRq/ki4Q7U3750Wr8/dq6mzPzWdveBVCZjBSWTac6VUO0m9SZik3kVgb8eUfVpgrEA/C3AfXn7mCxDNWenwunbYQpHXpkZd07TBYRB719DkYbX9UvFln6kELEG8DRBYUt+OmFnl5xV/JftD5YqcuPyDE8eRgb2t/3LErCQH0qsA6SUv/oML/r7iRrtnxKW3WcqlIjX4SxaZuA8D9QtzuUuuFmDGpspR38iW09ztAx8TnWFbkfpXlYYCa8xgTrsIhzhEoWgEjqPets5eg3xQLoidboo81QAVt6nGc+CMr9k4JJyopcO78zZ+tF5Ip7XP+h7jQtra17e8sI9KMNkG+d6Pt790y7TtUafZjmDwrQxS8RerbLjfFHbFaReylWV7owVJqfgyxWEk+RxfK49PSgjMnuIMSHPOrvXT9qPs0RJ8my4P9z/+xpU7/zrokGe4y64TX0aM/Z4/ABtg3KhP/tvM0eKCls/EH2sR2P2o9I+NIccZOEAX2ZFiiRiRlxnLjfmW1ypXi3CTyCJr7eMIuRPK7gEfq8iqX97joir39kFRecdU/doKTEkX8w3E25tNhTHtcgm34dGkFN0lvQ5a8CTMOVEpO1sHkclkcETdX31eN/yaSoR3gzAy/mxjrEdWNcES
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(396003)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(356005)(81166007)(921005)(36756003)(82740400003)(86362001)(5660300002)(36860700001)(70206006)(8936002)(41300700001)(110136005)(316002)(4326008)(8676002)(40480700001)(40460700003)(82310400005)(30864003)(2906002)(47076005)(83380400001)(336012)(426003)(2616005)(478600001)(70586007)(6666004)(186003)(1076003)(26005)(36900700001)(579004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 13:03:56.1712
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fc31377-3999-44ee-11b2-08db0b67448a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5454
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the driver interfaces required for support by the ethtool utility.

Signed-off-by: Abhijit Gangurde<abhijit.gangurde@amd.com>
Signed-off-by: Puneet Gupta <puneet.gupta@amd.com>
Signed-off-by: Nikhil Agarwal<nikhil.agarwal@amd.com>
Signed-off-by: Tarak Reddy<tarak.reddy@amd.com>
Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/net/ethernet/amd/efct/efct_common.c  |  160 +++
 drivers/net/ethernet/amd/efct/efct_ethtool.c | 1286 ++++++++++++++++++
 drivers/net/ethernet/amd/efct/efct_netdev.c  |    1 +
 3 files changed, 1447 insertions(+)
 create mode 100644 drivers/net/ethernet/amd/efct/efct_ethtool.c

diff --git a/drivers/net/ethernet/amd/efct/efct_common.c b/drivers/net/ethernet/amd/efct/efct_common.c
index a8e454d4e8a8..dbdb2f62cb79 100644
--- a/drivers/net/ethernet/amd/efct/efct_common.c
+++ b/drivers/net/ethernet/amd/efct/efct_common.c
@@ -1008,6 +1008,166 @@ void efct_clear_interrupt_affinity(struct efct_nic *efct)
 	}
 }
 
+static int efct_validate_flow(struct efct_nic *efct, const struct ethtool_rx_flow_spec *rule)
+{
+	const struct ethtool_tcpip4_spec *ip_entry = &rule->h_u.tcp_ip4_spec;
+	const struct ethtool_tcpip4_spec *ip_mask = &rule->m_u.tcp_ip4_spec;
+	struct efct_mcdi_filter_table *table;
+
+	/* Check that user wants us to choose the location */
+	if (rule->location != RX_CLS_LOC_ANY)
+		return -EINVAL;
+
+	if (rule->ring_cookie >= efct->rxq_count && rule->ring_cookie != RX_CLS_FLOW_DISC) {
+		netif_err(efct, drv, efct->net_dev, "Invalid queue id %lld\n", rule->ring_cookie);
+		return -EINVAL;
+	}
+	table = efct->filter_table;
+	if (rule->flow_type != TCP_V4_FLOW && rule->flow_type != UDP_V4_FLOW) {
+		netif_err(efct, drv, efct->net_dev, "Flow type %u not supported, Only IPv4 TCP/UDP is supported\n",
+			  rule->flow_type);
+		goto err;
+	}
+	if (ip_mask->psrc || ip_mask->ip4src || ip_mask->tos) {
+		netif_err(efct, drv, efct->net_dev, "Source IP, port, tos not supported\n");
+		goto err;
+	} else if ((ip_entry->ip4dst & ip_mask->ip4dst) == MULTICAST_ADDR_START) {
+		if (ip_entry->pdst) {
+			netif_err(efct, drv, efct->net_dev, "Destination port not supported in IP multicast\n");
+			goto err;
+		}
+		if (table->entry[EFCT_MCDI_FILTER_TBL_ROWS - 1].spec) {
+			netif_err(efct, drv, efct->net_dev, "Filter already exist at Multicast location %u\n",
+				  EFCT_MCDI_FILTER_TBL_ROWS - 1);
+			return -EBUSY;
+		}
+	} else if (ip_mask->ip4dst != IP4_ADDR_MASK || ip_mask->pdst != PORT_MASK) {
+		netif_err(efct, drv, efct->net_dev, "Exact match required for destination IP and port\n");
+			goto err;
+	}
+	return 0;
+err:
+	return -EOPNOTSUPP;
+}
+
+int efct_fill_spec(struct efct_nic *efct, const struct ethtool_rx_flow_spec *rule,
+		   struct efct_filter_spec *spec)
+{
+	const struct ethtool_tcpip4_spec *ip_entry = &rule->h_u.tcp_ip4_spec;
+	const struct ethtool_tcpip4_spec *ip_mask = &rule->m_u.tcp_ip4_spec;
+	struct efct_filter_spec *spec_in_table = NULL;
+	struct efct_mcdi_filter_table *table;
+	int rc = 0, ins_index = -1, index;
+	u32 flow_type;
+
+	rc = efct_validate_flow(efct, rule);
+	if (rc)
+		return rc;
+
+	spec->queue_id = rule->ring_cookie;
+	table = efct->filter_table;
+	flow_type = rule->flow_type;
+	if (ip_mask->ip4dst == IP4_ADDR_MASK && ip_mask->pdst == PORT_MASK) {
+		spec->match_fields =
+			((1 << MC_CMD_FILTER_OP_V3_IN_MATCH_ETHER_TYPE_LBN) |
+			 (1 << MC_CMD_FILTER_OP_V3_IN_MATCH_IP_PROTO_LBN));
+		spec->ether_type = htons(ETH_P_IP);
+		spec->ip_proto = (flow_type == TCP_V4_FLOW ? IPPROTO_TCP
+				  : IPPROTO_UDP);
+		spec->match_fields |=
+			(1 << MC_CMD_FILTER_OP_V3_IN_MATCH_DST_IP_LBN);
+		spec->dst_ip = ip_entry->ip4dst;
+		spec->match_fields |=
+			(1 << MC_CMD_FILTER_OP_V3_IN_MATCH_DST_PORT_LBN);
+		spec->dst_port = ip_entry->pdst;
+	} else if ((ip_entry->ip4dst & ip_mask->ip4dst) == MULTICAST_ADDR_START) {
+		spec->match_fields =
+			(1 << MC_CMD_FILTER_OP_V3_IN_MATCH_UNKNOWN_IPV4_MCAST_DST_LBN);
+		ins_index = EFCT_MCDI_FILTER_TBL_ROWS - 1;
+		goto success;
+	} else {
+		netif_err(efct, drv, efct->net_dev,
+			  "Unsupported filter\n");
+		return -EOPNOTSUPP;
+	}
+
+	for (index = 0; index < EFCT_MCDI_FILTER_TBL_ROWS; index++) {
+		//TODO hash table implementation
+		spec_in_table = (struct efct_filter_spec *)table->entry[index].spec;
+		if (!spec_in_table) {
+			if (ins_index < 0)
+				ins_index = index;
+		} else if (efct_filter_spec_equal(spec, spec_in_table)) {
+			ins_index = index;
+			break;
+		}
+	}
+
+	if (ins_index < 0) {
+		netif_err(efct, drv, efct->net_dev,
+			  "No free index found, %d\n", rc);
+		return -EBUSY;
+	}
+
+success:
+	rc = ins_index;
+	return rc;
+}
+
+int efct_delete_rule(struct efct_nic *efct, u32 id)
+{
+	struct efct_filter_spec *spec_in_table;
+	struct efct_mcdi_filter_table *table;
+	int rc;
+
+	if (!efct) {
+		pr_err("Invalid client passed\n");
+		return -ENODEV;
+	}
+
+	table = efct->filter_table;
+	if (!table || !table->entry) {
+		netif_err(efct, drv, efct->net_dev,
+			  "Invlid filter table\n");
+		return -EINVAL;
+	}
+
+	down_write(&table->lock);
+
+	if (table->entry[id].handle == EFCT_HANDLE_INVALID) {
+		netif_err(efct, drv, efct->net_dev,
+			  "Invalid filter is passed, id: %d\n", id);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	table->entry[id].ref_cnt--;
+	if (table->entry[id].ref_cnt) {
+		netif_dbg(efct, drv, efct->net_dev,
+			  "There are other active clients for this filter, id: %d\n", id);
+		rc = 0;
+		goto out;
+	}
+
+	spec_in_table = (struct efct_filter_spec *)table->entry[id].spec;
+	rc = efct_mcdi_filter_remove(efct, table->entry[id].handle);
+	if (rc) {
+		netif_err(efct, drv, efct->net_dev,
+			  "efct_mcdi_filter_remove failed, rc: %d\n", rc);
+		goto out;
+	}
+	if (spec_in_table->queue_id != RX_CLS_FLOW_DISC)
+		efct->rxq[spec_in_table->queue_id].filter_count--;
+
+	/*Removing exclusive client if filter count is zero*/
+	kfree(spec_in_table);
+	table->entry[id].spec = (unsigned long)NULL;
+	table->entry[id].handle = EFCT_HANDLE_INVALID;
+out:
+	up_write(&table->lock);
+	return rc;
+}
+
 int efct_get_phys_port_id(struct net_device *net_dev, struct netdev_phys_item_id *ppid)
 {
 	struct efct_nic *efct = efct_netdev_priv(net_dev);
diff --git a/drivers/net/ethernet/amd/efct/efct_ethtool.c b/drivers/net/ethernet/amd/efct/efct_ethtool.c
new file mode 100644
index 000000000000..2e60f1b82296
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_ethtool.c
@@ -0,0 +1,1286 @@
+// SPDX-License-Identifier: GPL-2.0
+/****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#include "mcdi.h"
+#include "efct_reflash.h"
+#include "efct_nic.h"
+#include "efct_evq.h"
+#include "mcdi_functions.h"
+#include "mcdi_port_common.h"
+#include "efct_common.h"
+#ifdef CONFIG_EFCT_PTP
+#include "efct_ptp.h"
+#endif
+
+struct efct_sw_stat_desc {
+	const char *name;
+	enum {
+		EFCT_ETHTOOL_STAT_SOURCE_rx_queue,
+		EFCT_ETHTOOL_STAT_SOURCE_tx_queue,
+		EFCT_ETHTOOL_STAT_SOURCE_ev_queue,
+	} source;
+	u32 offset;
+	u64 (*get_stat)(void *field); /* Reader function */
+};
+
+/* Initialiser for a struct efct_sw_stat_desc with type-checking */
+#define EFCT_ETHTOOL_STAT(stat_name, source_name, field, field_type, \
+			  get_stat_function) {			\
+	.name = #stat_name,						\
+	.source = EFCT_ETHTOOL_STAT_SOURCE_##source_name,		\
+	.offset = ((((field_type *)0) ==				\
+		      &((struct efct_##source_name *)0)->field) ?	\
+		    offsetof(struct efct_##source_name, field) :		\
+		    offsetof(struct efct_##source_name, field)),		\
+	.get_stat = get_stat_function,					\
+}
+
+static u64 efct_get_u64_stat(void *field)
+{
+	return *(u64 *)field;
+}
+
+#define EFCT_ETHTOOL_U64_RXQ_STAT(field)				\
+		EFCT_ETHTOOL_STAT(field, rx_queue, n_##field,	\
+			 u64, efct_get_u64_stat)
+#define EFCT_ETHTOOL_U64_TXQ_STAT(field)                        \
+	EFCT_ETHTOOL_STAT(field, tx_queue, n_##field,           \
+			  u64, efct_get_u64_stat)
+#define EFCT_ETHTOOL_U64_EVQ_STAT(field)                        \
+	EFCT_ETHTOOL_STAT(field, ev_queue, n_##field,           \
+			  u64, efct_get_u64_stat)
+
+static const struct efct_sw_stat_desc efct_sw_stat_desc[] = {
+	EFCT_ETHTOOL_U64_TXQ_STAT(tx_stop_queue),
+
+	EFCT_ETHTOOL_U64_EVQ_STAT(evq_time_sync_events),
+	EFCT_ETHTOOL_U64_EVQ_STAT(evq_error_events),
+	EFCT_ETHTOOL_U64_EVQ_STAT(evq_flush_events),
+	EFCT_ETHTOOL_U64_EVQ_STAT(evq_unsol_overflow),
+	EFCT_ETHTOOL_U64_EVQ_STAT(evq_unhandled_events),
+
+	EFCT_ETHTOOL_U64_RXQ_STAT(rx_ip_hdr_chksum_err),
+	EFCT_ETHTOOL_U64_RXQ_STAT(rx_tcp_udp_chksum_err),
+	EFCT_ETHTOOL_U64_RXQ_STAT(rx_mcast_mismatch),
+	EFCT_ETHTOOL_U64_RXQ_STAT(rx_merge_events),
+	EFCT_ETHTOOL_U64_RXQ_STAT(rx_merge_packets),
+	EFCT_ETHTOOL_U64_RXQ_STAT(rx_alloc_skb_fail),
+	EFCT_ETHTOOL_U64_RXQ_STAT(rx_broadcast_drop),
+	EFCT_ETHTOOL_U64_RXQ_STAT(rx_other_host_drop),
+	EFCT_ETHTOOL_U64_RXQ_STAT(rx_nbl_empty),
+	EFCT_ETHTOOL_U64_RXQ_STAT(rx_buffers_posted),
+	EFCT_ETHTOOL_U64_RXQ_STAT(rx_rollover_events),
+	EFCT_ETHTOOL_U64_RXQ_STAT(rx_aux_pkts),
+};
+
+#define EFCT_ETHTOOL_SW_STAT_COUNT ARRAY_SIZE(efct_sw_stat_desc)
+
+#define EFCT_EVQ_NAME(_evq) "evq%d", (_evq)->index
+
+static void efct_ethtool_get_drvinfo(struct net_device *net_dev,
+				     struct ethtool_drvinfo *info)
+{
+	struct efct_device *efct_dev;
+	struct efct_nic *efct;
+
+	efct = efct_netdev_priv(net_dev);
+	efct_dev = efct_nic_to_device(efct);
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	if (!in_interrupt()) {
+		efct_mcdi_print_fwver(efct, info->fw_version, sizeof(info->fw_version));
+		efct_mcdi_erom_ver(efct, info->erom_version, sizeof(info->erom_version));
+	} else {
+		strscpy(info->fw_version, "N/A", sizeof(info->fw_version));
+		strscpy(info->erom_version, "N/A", sizeof(info->erom_version));
+	}
+	strscpy(info->bus_info, pci_name(efct_dev->pci_dev), sizeof(info->bus_info));
+	info->n_priv_flags = 0;
+}
+
+static size_t efct_describe_per_queue_stats(struct efct_nic *efct, u8 *strings)
+{
+	size_t n_stats = 0;
+	int i;
+
+	for (i = 0; i < EFCT_MAX_CORE_TX_QUEUES; i++) {
+		n_stats++;
+		if (strings) {
+			snprintf(strings, ETH_GSTRING_LEN,
+				 "tx-%u.tx_packets", efct->txq[i].txq_index);
+			strings += ETH_GSTRING_LEN;
+		}
+	}
+
+	for (i = 0; i < efct->rxq_count; i++) {
+		n_stats++;
+		if (strings) {
+			snprintf(strings, ETH_GSTRING_LEN,
+				 "rx-%u.rx_packets", efct->rxq[i].index);
+			strings += ETH_GSTRING_LEN;
+		}
+	}
+
+	return n_stats;
+}
+
+/**
+ * efct_fill_test - fill in an individual self-test entry
+ * @test_index:		Index of the test
+ * @strings:		Ethtool strings, or %NULL
+ * @data:		Ethtool test results, or %NULL
+ * @test:		Pointer to test result (used only if data != %NULL)
+ * @unit_format:	Unit name format (e.g. "evq%d")
+ * @unit_id:		Unit id (e.g. 0 for "evq0")
+ * @test_format:	Test name format (e.g. "loopback.\%s.tx.sent")
+ * @test_id:		Test id (e.g. "PHYXS" for "loopback.PHYXS.tx_sent")
+ *
+ * Fill in an individual self-test entry.
+ */
+static void efct_fill_test(u32 test_index, u8 *strings, u64 *data,
+			   int *test, const char *unit_format, int unit_id,
+			   const char *test_format, const char *test_id)
+{
+	char unit_str[ETH_GSTRING_LEN], test_str[ETH_GSTRING_LEN];
+
+	/* Fill data value, if applicable */
+	if (data)
+		data[test_index] = *test;
+
+	/* Fill string, if applicable */
+	if (strings) {
+		if (strchr(unit_format, '%'))
+			snprintf(unit_str, sizeof(unit_str),
+				 unit_format, unit_id);
+		else
+			strcpy(unit_str, unit_format);
+		snprintf(test_str, sizeof(test_str), test_format, test_id);
+		snprintf(strings + test_index * ETH_GSTRING_LEN,
+			 ETH_GSTRING_LEN,
+			 "%-6s %-24s", unit_str, test_str);
+	}
+}
+
+/**
+ * efct_ethtool_fill_self_tests - get self-test details
+ * @efct:		Efct NIC
+ * @tests:	Efct self-test results structure, or %NULL
+ * @strings:	Ethtool strings, or %NULL
+ * @data:		Ethtool test results, or %NULL
+ *
+ * Get self-test number of strings, strings, and/or test results.
+ *
+ * The reason for merging these three functions is to make sure that
+ * they can never be inconsistent.
+ *
+ * Return: number of strings (equals number of test results).
+ */
+static int efct_ethtool_fill_self_tests(struct efct_nic *efct,
+					struct efct_self_tests *tests,
+				 u8 *strings, u64 *data)
+{
+	unsigned long evq_active_mask;
+	struct efct_ev_queue *evq;
+	u32 n = 0;
+	int i;
+
+	evq_active_mask = efct->evq_active_mask;
+	efct_fill_test(n++, strings, data, &tests->phy_alive, "phy", 0, "alive", NULL);
+	efct_fill_test(n++, strings, data, &tests->interrupt,
+		       "core", 0, "interrupt", NULL);
+
+	/* Event queues */
+	for_each_set_bit(i, &evq_active_mask, efct->max_evq_count) {
+		if (efct->evq[i].type == EVQ_T_AUX)
+			continue;
+		evq = &efct->evq[i];
+		efct_fill_test(n++, strings, data,
+			       tests ? &tests->eventq_dma[evq->index] : NULL,
+			       EFCT_EVQ_NAME(evq),
+			      "eventq.dma", NULL);
+		efct_fill_test(n++, strings, data,
+			       tests ? &tests->eventq_int[evq->index] : NULL,
+			       EFCT_EVQ_NAME(evq),
+			       "eventq.int", NULL);
+	}
+
+	return n;
+}
+
+static int efct_ethtool_get_sset_count(struct net_device *net_dev, int string_set)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+	int count;
+
+	switch (string_set) {
+	case ETH_SS_STATS:
+		count = efct->type->describe_stats(efct, NULL);
+#ifdef CONFIG_EFCT_PTP
+		count += efct_ptp_describe_stats(efct, NULL);
+#endif
+		count += (EFCT_ETHTOOL_SW_STAT_COUNT +
+				efct_describe_per_queue_stats(efct, NULL));
+		return  count;
+	case ETH_SS_TEST:
+		return efct_ethtool_fill_self_tests(efct, NULL, NULL, NULL);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void efct_ethtool_get_strings(struct net_device *net_dev, u32 string_set, u8 *strings)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+	int i;
+
+	switch (string_set) {
+	case ETH_SS_STATS:
+		strings += (efct->type->describe_stats(efct, strings) * ETH_GSTRING_LEN);
+#ifdef CONFIG_EFCT_PTP
+		strings += (efct_ptp_describe_stats(efct, strings) * ETH_GSTRING_LEN);
+#endif
+		for (i = 0; i < EFCT_ETHTOOL_SW_STAT_COUNT; i++)
+			strscpy(strings + i * ETH_GSTRING_LEN,
+				efct_sw_stat_desc[i].name, ETH_GSTRING_LEN);
+		strings += EFCT_ETHTOOL_SW_STAT_COUNT * ETH_GSTRING_LEN;
+		strings += (efct_describe_per_queue_stats(efct, strings) *
+			    ETH_GSTRING_LEN);
+		break;
+	case ETH_SS_TEST:
+		efct_ethtool_fill_self_tests(efct, NULL, strings, NULL);
+		break;
+
+	default:
+		/* No other string sets */
+		break;
+	}
+}
+
+static void efct_ethtool_get_stats(struct net_device *net_dev,
+				   struct ethtool_stats __always_unused *stats, u64 *data)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+	const struct efct_sw_stat_desc *stat;
+	int i, j;
+
+	/* Get NIC statistics */
+	spin_lock_bh(&efct->stats_lock);
+	data += efct_update_stats_common(efct, data, NULL);
+	spin_unlock_bh(&efct->stats_lock);
+#ifdef CONFIG_EFCT_PTP
+	data += efct_ptp_update_stats(efct, data);
+#endif
+	/* efct->stats is obtained in update_stats and held */
+
+	/*Get SW stats*/
+	for (i = 0; i < EFCT_ETHTOOL_SW_STAT_COUNT; i++) {
+		stat = &efct_sw_stat_desc[i];
+		switch (stat->source) {
+		case EFCT_ETHTOOL_STAT_SOURCE_rx_queue:
+			data[i] = 0;
+			for (j = 0; j < efct->rxq_count; j++)
+				data[i] += stat->get_stat((u8 *)&efct->rxq[j]
+						+ stat->offset);
+		break;
+		case EFCT_ETHTOOL_STAT_SOURCE_tx_queue:
+			data[i] = 0;
+			for (j = 0; j < EFCT_MAX_CORE_TX_QUEUES; j++)
+				data[i] += stat->get_stat((u8 *)&efct->txq[j]
+						+ stat->offset);
+		break;
+		case EFCT_ETHTOOL_STAT_SOURCE_ev_queue:
+			data[i] = 0;
+			for (j = 0; j < (efct->rxq_count + EFCT_MAX_CORE_TX_QUEUES); j++)
+				data[i] += stat->get_stat((u8 *)&efct->evq[j]
+						+ stat->offset);
+		break;
+		}
+	}
+	data += EFCT_ETHTOOL_SW_STAT_COUNT;
+	for (i = 0; i < EFCT_MAX_CORE_TX_QUEUES; i++) {
+		data[0] = efct->txq[i].tx_packets;
+		data++;
+	}
+
+	for (i = 0; i < efct->rxq_count; i++) {
+		data[0] = efct->rxq[i].rx_packets;
+		data++;
+	}
+}
+
+static u32 efct_ethtool_get_msglevel(struct net_device *net_dev)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+
+	return efct->msg_enable;
+}
+
+static void efct_ethtool_set_msglevel(struct net_device *net_dev, u32 msg_enable)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+
+	efct->msg_enable = msg_enable;
+}
+
+static void efct_get_tx_moderation(struct efct_nic *efct, u32 *tx_usecs)
+{
+	struct efct_ev_queue *evq;
+	int i = 0;
+
+	evq = efct->evq;
+	for (i = 0; i < efct->max_evq_count; i++) {
+		if (evq[i].type == EVQ_T_TX) {
+			*tx_usecs = DIV_ROUND_CLOSEST(evq[i].irq_moderation_ns, 1000);
+			break;
+		}
+	}
+}
+
+static void efct_get_rx_moderation(struct efct_nic *efct, u32 *rx_usecs)
+{
+	struct efct_ev_queue *evq;
+	int i = 0;
+
+	evq = efct->evq;
+	for (i = 0; i < efct->max_evq_count; i++) {
+		if (evq[i].type == EVQ_T_RX) {
+			*rx_usecs = DIV_ROUND_CLOSEST(evq[i].irq_moderation_ns, 1000);
+			break;
+		}
+	}
+}
+
+static int efct_ethtool_get_coalesce(struct net_device *net_dev,
+				     struct ethtool_coalesce *coalesce,
+				     struct kernel_ethtool_coalesce *kernel_coal,
+				     struct netlink_ext_ack *extack)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+	u32 tx_usecs, rx_usecs;
+
+	tx_usecs = 0;
+	rx_usecs = 0;
+	efct_get_tx_moderation(efct, &tx_usecs);
+	efct_get_rx_moderation(efct, &rx_usecs);
+	coalesce->tx_coalesce_usecs = tx_usecs;
+	coalesce->tx_coalesce_usecs_irq = 0;
+	coalesce->rx_coalesce_usecs = rx_usecs;
+	coalesce->rx_coalesce_usecs_irq = 0;
+	coalesce->use_adaptive_rx_coalesce = efct->irq_rx_adaptive;
+
+	return 0;
+}
+
+static int efct_ethtool_set_coalesce(struct net_device *net_dev,
+				     struct ethtool_coalesce *coalesce,
+				     struct kernel_ethtool_coalesce *kernel_coal,
+				     struct netlink_ext_ack *extack)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+	struct efct_ev_queue *evq;
+	u32 tx_usecs, rx_usecs;
+	u32 timer_max_us;
+	bool tx = false;
+	bool rx = false;
+	int i;
+
+	tx_usecs = 0;
+	rx_usecs = 0;
+	timer_max_us = efct->timer_max_ns / 1000;
+	evq = efct->evq;
+
+	if (coalesce->rx_coalesce_usecs_irq || coalesce->tx_coalesce_usecs_irq) {
+		netif_err(efct, drv, efct->net_dev, "Only rx/tx_coalesce_usecs are supported\n");
+		return -EINVAL;
+	}
+
+	efct->irq_rx_adaptive = coalesce->use_adaptive_rx_coalesce;
+
+	efct_get_tx_moderation(efct, &tx_usecs);
+	efct_get_rx_moderation(efct, &rx_usecs);
+
+	/* Nothing to do if values set by the user are same */
+	if (coalesce->tx_coalesce_usecs == tx_usecs && coalesce->rx_coalesce_usecs == rx_usecs)
+		return 0;
+
+	if (coalesce->rx_coalesce_usecs != rx_usecs) {
+		rx_usecs = coalesce->rx_coalesce_usecs;
+		rx = true;
+	}
+
+	if (coalesce->tx_coalesce_usecs != tx_usecs) {
+		tx_usecs = coalesce->tx_coalesce_usecs;
+		tx = true;
+	}
+
+	if (tx_usecs > timer_max_us || rx_usecs > timer_max_us)
+		return -EINVAL;
+
+	efct->irq_rx_moderation_ns = rx_usecs * 1000;
+	for (i = 0; i < efct->max_evq_count; i++) {
+		if (tx && evq[i].type == EVQ_T_TX)
+			evq[i].irq_moderation_ns = tx_usecs * 1000;
+		else if (rx && evq[i].type == EVQ_T_RX)
+			evq[i].irq_moderation_ns = rx_usecs * 1000;
+		else
+			continue;
+		efct_mcdi_ev_set_timer(&evq[i], evq[i].irq_moderation_ns,
+				       MC_CMD_SET_EVQ_TMR_IN_TIMER_MODE_INT_HLDOFF, false);
+	}
+
+	return 0;
+}
+
+static void efct_ethtool_get_ringparam(struct net_device *net_dev,
+				       struct ethtool_ringparam *ring,
+				       struct kernel_ethtool_ringparam *kring,
+				       struct netlink_ext_ack *ext_ack)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+
+	ring->rx_max_pending = RX_MAX_DRIVER_BUFFS * (DIV_ROUND_UP(efct->rxq[0].buffer_size,
+								   efct->rxq[0].pkt_stride));
+	ring->rx_pending = efct->rxq[0].num_entries;
+	ring->tx_max_pending = efct->txq[0].num_entries;
+	ring->tx_pending = efct->txq[0].num_entries;
+}
+
+static int efct_ethtool_set_ringparam(struct net_device *net_dev,
+				      struct ethtool_ringparam *ring,
+				      struct kernel_ethtool_ringparam *kring,
+				      struct netlink_ext_ack *ext_ack)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+	u32 entries_per_buff, min_rx_num_entries;
+	bool if_up = false;
+	int rc;
+
+	if (ring->tx_pending != efct->txq[0].num_entries) {
+		netif_err(efct, drv, efct->net_dev,
+			  "Tx ring size changes not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (ring->rx_pending == efct->rxq[0].num_entries)
+		/* Nothing to do */
+		return 0;
+
+	min_rx_num_entries = RX_MIN_DRIVER_BUFFS * DIV_ROUND_UP(efct->rxq[0].buffer_size,
+								efct->rxq[0].pkt_stride);
+	entries_per_buff = DIV_ROUND_UP(efct->rxq[0].buffer_size, efct->rxq[0].pkt_stride);
+	if (ring->rx_pending % entries_per_buff || ring->rx_pending < min_rx_num_entries) {
+		netif_err(efct, drv, efct->net_dev,
+			  "Unsupported RX ring size. Should be multiple of %u and more than %u",
+			  entries_per_buff, min_rx_num_entries);
+		return -EINVAL;
+	}
+
+	ASSERT_RTNL();
+
+	if (netif_running(net_dev)) {
+		dev_close(net_dev);
+		if_up = true;
+	}
+
+	mutex_lock(&efct->state_lock);
+	rc = efct_realloc_rx_evqs(efct, ring->rx_pending);
+	mutex_unlock(&efct->state_lock);
+
+	if (rc) {
+		netif_err(efct, drv, efct->net_dev,
+			  "Failed reallocate rx evqs. Device disabled\n");
+		return rc;
+	}
+
+	if (if_up)
+		rc = dev_open(net_dev, NULL);
+
+	return rc;
+}
+
+static u32 ethtool_speed_to_mcdi_cap(bool duplex, u32 speed)
+{
+	if (duplex) {
+		switch (speed) {
+		case 10:     return 1 << MC_CMD_PHY_CAP_10FDX_LBN;
+		case 100:    return 1 << MC_CMD_PHY_CAP_100FDX_LBN;
+		case 1000:   return 1 << MC_CMD_PHY_CAP_1000FDX_LBN;
+		case 10000:  return 1 << MC_CMD_PHY_CAP_10000FDX_LBN;
+		case 40000:  return 1 << MC_CMD_PHY_CAP_40000FDX_LBN;
+		case 100000: return 1 << MC_CMD_PHY_CAP_100000FDX_LBN;
+		case 25000:  return 1 << MC_CMD_PHY_CAP_25000FDX_LBN;
+		case 50000:  return 1 << MC_CMD_PHY_CAP_50000FDX_LBN;
+		}
+	} else {
+		switch (speed) {
+		case 10:     return 1 << MC_CMD_PHY_CAP_10HDX_LBN;
+		case 100:    return 1 << MC_CMD_PHY_CAP_100HDX_LBN;
+		case 1000:   return 1 << MC_CMD_PHY_CAP_1000HDX_LBN;
+		}
+	}
+
+	return 0;
+}
+
+int efct_mcdi_phy_set_ksettings(struct efct_nic *efct,
+				const struct ethtool_link_ksettings *settings,
+			       unsigned long *advertising)
+{
+	const struct ethtool_link_settings *base = &settings->base;
+	struct efct_mcdi_phy_data *phy_cfg = efct->phy_data;
+	u32 caps;
+	int rc;
+
+	memcpy(advertising, settings->link_modes.advertising,
+	       sizeof(__ETHTOOL_DECLARE_LINK_MODE_MASK()));
+
+	/* Remove flow control settings that the MAC supports
+	 * but that the PHY can't advertise.
+	 */
+	if (~phy_cfg->supported_cap & (1 << MC_CMD_PHY_CAP_PAUSE_LBN))
+		__clear_bit(ETHTOOL_LINK_MODE_Pause_BIT, advertising);
+	if (~phy_cfg->supported_cap & (1 << MC_CMD_PHY_CAP_ASYM_LBN))
+		__clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, advertising);
+
+	if (base->autoneg)
+		caps = ethtool_linkset_to_mcdi_cap(advertising) |
+					1 << MC_CMD_PHY_CAP_AN_LBN;
+	else
+		caps = ethtool_speed_to_mcdi_cap(base->duplex, base->speed);
+	if (!caps)
+		return -EINVAL;
+
+	rc = efct_mcdi_set_link(efct, caps, efct_get_mcdi_phy_flags(efct),
+				0, SET_LINK_SEQ_IGNORE);
+	if (rc) {
+		if (rc == -EINVAL)
+			netif_dbg(efct, link, efct->net_dev,
+				  "invalid link settings: autoneg=%u advertising=%*pb speed=%u duplex=%u translated to caps=%#x\n",
+				  base->autoneg, __ETHTOOL_LINK_MODE_MASK_NBITS,
+				  settings->link_modes.advertising, base->speed,
+				  base->duplex, caps);
+		return rc;
+	}
+
+	/* Rather than storing the original advertising mask, we
+	 * convert the capabilities we're actually using back to an
+	 * advertising mask so that (1) get_settings() will report
+	 * correct information (2) we can push the capabilities again
+	 * after an MC reset.
+	 */
+	mcdi_to_ethtool_linkset(efct, phy_cfg->media, caps, advertising);
+
+	return 0;
+}
+
+static int efct_ethtool_get_link_ksettings(struct net_device *net_dev,
+					   struct ethtool_link_ksettings *out) //check this def
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+
+	mutex_lock(&efct->mac_lock);
+	efct_mcdi_phy_get_ksettings(efct, out);
+	mutex_unlock(&efct->mac_lock);
+
+	return 0;
+}
+
+static int efct_ethtool_set_link_ksettings(struct net_device *net_dev,
+					   const struct ethtool_link_ksettings *settings)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+	int rc;
+
+	mutex_lock(&efct->mac_lock);
+	rc = efct_mcdi_phy_set_ksettings(efct, settings, advertising);
+	if (rc == 0)
+		efct_link_set_advertising(efct, advertising);
+	mutex_unlock(&efct->mac_lock);
+
+	return rc;
+}
+
+static void efct_ethtool_get_pauseparam(struct net_device *net_dev,
+					struct ethtool_pauseparam *pause)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+
+	pause->rx_pause = !!(efct->wanted_fc & EFCT_FC_RX);
+	pause->tx_pause = !!(efct->wanted_fc & EFCT_FC_TX);
+	pause->autoneg = !!(efct->wanted_fc & EFCT_FC_AUTO);
+}
+
+static int efct_ethtool_set_pauseparam(struct net_device *net_dev,
+				       struct ethtool_pauseparam *pause)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+	u8 wanted_fc, old_fc;
+	u32 old_adv;
+	int rc = 0;
+
+	mutex_lock(&efct->mac_lock);
+	wanted_fc = ((pause->rx_pause ? EFCT_FC_RX : 0) |
+		     (pause->tx_pause ? EFCT_FC_TX : 0) |
+		     (pause->autoneg ? EFCT_FC_AUTO : 0));
+	//TODO: Verify below limitation is true for X3?
+	if ((wanted_fc & EFCT_FC_TX) && !(wanted_fc & EFCT_FC_RX)) {
+		netif_dbg(efct, drv, efct->net_dev,
+			  "Flow control unsupported: tx ON rx OFF\n");
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if ((wanted_fc & EFCT_FC_AUTO) &&
+	    !(efct->link_advertising[0] & ADVERTISED_Autoneg)) {
+		netif_dbg(efct, drv, efct->net_dev,
+			  "Autonegotiation is disabled\n");
+		rc = -EINVAL;
+		goto out;
+	}
+
+	old_adv = efct->link_advertising[0];
+	old_fc = efct->wanted_fc;
+	efct_link_set_wanted_fc(efct, wanted_fc);
+	if (efct->link_advertising[0] != old_adv ||
+	    (efct->wanted_fc ^ old_fc) & EFCT_FC_AUTO) {
+		rc = efct_mcdi_port_reconfigure(efct);
+		if (rc) {
+			netif_err(efct, drv, efct->net_dev,
+				  "Unable to advertise requested flow control setting\n");
+			efct->link_advertising[0] = old_adv;
+			efct->wanted_fc = old_fc;
+			goto out;
+		}
+	}
+
+	/* Reconfigure the MAC. The PHY *may* generate a link state change event
+	 * if the user just changed the advertised capabilities, but there's no
+	 * harm doing this twice
+	 */
+	(void)efct_mac_reconfigure(efct);
+
+out:
+	mutex_unlock(&efct->mac_lock);
+
+	return rc;
+}
+
+static int efct_ethtool_get_ts_info(struct net_device *net_dev,
+				    struct ethtool_ts_info *ts_info)
+{
+#ifdef CONFIG_EFCT_PTP
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+#endif
+	/* Software capabilities */
+	ts_info->so_timestamping = (SOF_TIMESTAMPING_RX_SOFTWARE |
+				    SOF_TIMESTAMPING_TX_SOFTWARE |
+				    SOF_TIMESTAMPING_SOFTWARE);
+	ts_info->phc_index = -1;
+#ifdef CONFIG_EFCT_PTP
+	efct_ptp_get_ts_info(efct, ts_info);
+#endif
+	return 0;
+}
+
+static int efct_ethtool_reset(struct net_device *net_dev, u32 *flags)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+	u32 reset_flags = *flags;
+	int rc;
+
+	rc = efct->type->map_reset_flags(&reset_flags);
+	if (rc >= 0) {
+		rc = efct_reset(efct, rc);
+		if (!rc)
+			*flags = reset_flags;
+	}
+
+	if (*flags & ETH_RESET_MAC) {
+		netif_info(efct, drv, efct->net_dev,
+			   "Resetting statistics.\n");
+		efct->stats_initialised = false;
+		efct->type->pull_stats(efct);
+		efct->type->update_stats(efct, true);
+		*flags &= ~ETH_RESET_MAC;
+		rc = 0;
+	}
+
+	return rc;
+}
+
+static int efct_ethtool_get_fecparam(struct net_device *net_dev, struct ethtool_fecparam *fecparam)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+	int rc;
+
+	mutex_lock(&efct->mac_lock);
+	rc = efct_mcdi_phy_get_fecparam(efct, fecparam);
+	mutex_unlock(&efct->mac_lock);
+
+	return rc;
+}
+
+/* Identify device by flashing LEDs */
+static int efct_ethtool_phys_id(struct net_device *net_dev, enum ethtool_phys_id_state state)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+	enum efct_led_mode mode = EFCT_LED_DEFAULT;
+
+	switch (state) {
+	case ETHTOOL_ID_ON:
+		mode = EFCT_LED_ON;
+		break;
+	case ETHTOOL_ID_OFF:
+		mode = EFCT_LED_OFF;
+		break;
+	case ETHTOOL_ID_INACTIVE:
+		mode = EFCT_LED_DEFAULT;
+		break;
+	case ETHTOOL_ID_ACTIVE:
+		return 1;	/* cycle on/off once per second */
+	}
+
+	return efct_mcdi_set_id_led(efct, mode);
+}
+
+static int efct_ethtool_set_rule(struct efct_nic *efct, struct ethtool_rx_flow_spec *rule)
+{
+	struct efct_mcdi_filter_table *table = efct->filter_table;
+	struct efct_filter_spec spec, *spec_in_table = NULL;
+	int rc = 0, ins_index = -1;
+	u64 handle = 0;
+
+	memset(&spec, 0, sizeof(spec));
+
+	if (!table || !table->entry) {
+		netif_err(efct, drv, efct->net_dev,
+			  "Invlid filter table\n");
+		return -ENODEV;
+	}
+
+	down_write(&table->lock);
+
+	rc = efct_fill_spec(efct, rule, &spec);
+	if (rc < 0)
+		goto out;
+
+	ins_index = rc;
+
+	spec_in_table = (struct efct_filter_spec *)table->entry[ins_index].spec;
+	if (!spec_in_table) {
+		spec_in_table = kmalloc(sizeof(*spec_in_table), GFP_ATOMIC);
+		if (!spec_in_table) {
+			rc = -ENOMEM;
+			goto out;
+		}
+
+		if (spec.queue_id == RX_CLS_FLOW_DISC) {
+			*spec_in_table = spec;
+			goto insert;
+		}
+
+		*spec_in_table = spec;
+	} else {
+		netif_dbg(efct, drv, efct->net_dev,
+			  "The given spec already exists on the queue %lld\n",
+			  spec_in_table->queue_id);
+		rc = -EEXIST;
+		goto out;
+	}
+
+insert:
+	table->entry[ins_index].spec = (unsigned long)spec_in_table;
+	rc = efct_mcdi_filter_insert(efct, &spec, &handle);
+	if (rc) {
+		netif_err(efct, drv, efct->net_dev,
+			  "efct_mcdi_filter_insert failed, rc: %d\n", rc);
+		kfree(spec_in_table);
+		table->entry[ins_index].spec = (unsigned long)NULL;
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if (spec.queue_id != RX_CLS_FLOW_DISC)
+		efct->rxq[spec.queue_id].filter_count++;
+	table->entry[ins_index].handle = handle;
+	table->entry[ins_index].ref_cnt = 1;
+
+	rule->location = ins_index;
+	netif_dbg(efct, drv, efct->net_dev,
+		  "rxq_out:%lld, filter index 0x%x\n", spec.queue_id, ins_index);
+
+out:
+	up_write(&table->lock);
+	return rc;
+}
+
+static int efct_ethtool_set_rxnfc(struct net_device *net_dev, struct ethtool_rxnfc *info)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+
+	if (!efct)
+		return -ENODEV;
+
+	switch (info->cmd) {
+	case ETHTOOL_SRXCLSRLINS:
+		return efct_ethtool_set_rule(efct, &info->fs);
+	case ETHTOOL_SRXCLSRLDEL:
+		return efct_delete_rule(efct, info->fs.location);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int efct_ethtool_rule_cnt(struct efct_nic *efct)
+{
+	struct efct_mcdi_filter_table *table = efct->filter_table;
+	int count = 0, index = 0;
+
+	for (index = 0; index < EFCT_MCDI_FILTER_TBL_ROWS; index++) {
+		if (table->entry[index].handle == EFCT_HANDLE_INVALID)
+			continue;
+		count++;
+	}
+
+	return count;
+}
+
+static void efct_ethtool_get_ids_arr(struct efct_nic *efct, u32 *buf, u32 size)
+{
+	struct efct_mcdi_filter_table *table = efct->filter_table;
+	int n = 0, index = 0;
+
+	for (index = 0; index < EFCT_MCDI_FILTER_TBL_ROWS; index++) {
+		if (table->entry[index].handle == EFCT_HANDLE_INVALID) {
+			continue;
+		} else {
+			if (n < size)
+				buf[n++] = index;
+		}
+	}
+}
+
+static int efct_ethtool_get_rule(struct efct_nic *efct, struct ethtool_rx_flow_spec *rule)
+{
+	struct ethtool_tcpip4_spec *ip_entry = &rule->h_u.tcp_ip4_spec;
+	struct ethtool_tcpip4_spec *ip_mask = &rule->m_u.tcp_ip4_spec;
+	struct efct_mcdi_filter_table *table = efct->filter_table;
+	struct efct_filter_spec *spec;
+
+	spec = (struct efct_filter_spec *)table->entry[rule->location].spec;
+	if (!spec) {
+		netif_err(efct, drv, efct->net_dev, "Invalid rule location specified\n");
+		return -EINVAL;
+	}
+
+	rule->ring_cookie = spec->queue_id;
+
+	if ((spec->match_fields & (1 << MC_CMD_FILTER_OP_V3_IN_MATCH_ETHER_TYPE_LBN)) &&
+	    (spec->match_fields & (1 << MC_CMD_FILTER_OP_V3_IN_MATCH_IP_PROTO_LBN)) &&
+			spec->ether_type == htons(ETH_P_IP) &&
+			(spec->ip_proto == IPPROTO_TCP || spec->ip_proto == IPPROTO_UDP)) {
+		rule->flow_type = ((spec->ip_proto == IPPROTO_TCP) ? TCP_V4_FLOW : UDP_V4_FLOW);
+		if ((spec->match_fields & (1 << MC_CMD_FILTER_OP_V3_IN_MATCH_DST_IP_LBN)) &&
+		    (spec->match_fields & (1 << MC_CMD_FILTER_OP_V3_IN_MATCH_DST_PORT_LBN))) {
+			ip_entry->ip4dst = spec->dst_ip;
+			ip_mask->ip4dst = IP4_ADDR_MASK;
+			ip_entry->pdst = spec->dst_port;
+			ip_mask->pdst = PORT_MASK;
+		}
+	} else if (spec->match_fields &
+		   (1 << MC_CMD_FILTER_OP_V3_IN_MATCH_UNKNOWN_IPV4_MCAST_DST_LBN)) {
+		rule->flow_type = UDP_V4_FLOW;
+		ip_mask->ip4dst = MULTICAST_DST_MASK;
+		ip_entry->ip4dst = MULTICAST_ADDR_START;
+	}
+
+	return 0;
+}
+
+static int efct_ethtool_get_rxnfc(struct net_device *net_dev, struct ethtool_rxnfc *info,
+				  u32 *rule_locs)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+	int rc = 0;
+
+	if (!efct)
+		return -ENODEV;
+
+	switch (info->cmd) {
+	case ETHTOOL_GRXRINGS:
+		info->data = efct->rxq_count;
+		return 0;
+
+	case ETHTOOL_GRXCLSRLCNT:
+		info->data = EFCT_MCDI_FILTER_TBL_ROWS;
+		info->data |= RX_CLS_LOC_SPECIAL;
+		info->rule_cnt = efct_ethtool_rule_cnt(efct);
+		return 0;
+
+	case ETHTOOL_GRXCLSRULE:
+		rc = efct_ethtool_get_rule(efct, &info->fs);
+		if (rc < 0)
+			return rc;
+		return 0;
+
+	case ETHTOOL_GRXCLSRLALL:
+		info->rule_cnt = efct_ethtool_rule_cnt(efct);
+		info->data = EFCT_MCDI_FILTER_TBL_ROWS;
+		efct_ethtool_get_ids_arr(efct, rule_locs, info->rule_cnt);
+		return 0;
+
+	default:
+		return -EOPNOTSUPP;
+	}
+	return 0;
+}
+
+static int efct_ethtool_get_module_info(struct net_device *net_dev,
+					struct ethtool_modinfo *modinfo)
+{
+	struct efct_nic *efct;
+	int ret;
+
+	efct = efct_netdev_priv(net_dev);
+	mutex_lock(&efct->mac_lock);
+	ret = efct_mcdi_phy_get_module_info_locked(efct, modinfo);
+	mutex_unlock(&efct->mac_lock);
+
+	return ret;
+}
+
+static int efct_ethtool_get_module_eeprom(struct net_device *net_dev,
+					  struct ethtool_eeprom *ee,
+				   u8 *data)
+{
+	struct efct_nic *efct;
+	int ret;
+
+	efct = efct_netdev_priv(net_dev);
+	mutex_lock(&efct->mac_lock);
+	ret = efct_mcdi_phy_get_module_eeprom_locked(efct, ee, data);
+	mutex_unlock(&efct->mac_lock);
+
+	return ret;
+}
+
+static int efct_ethtool_get_module_eeprom_by_page(struct net_device *net_dev,
+						  const struct ethtool_module_eeprom *page_data,
+						  struct netlink_ext_ack *extack)
+{
+	struct efct_nic *efct;
+	int ret;
+
+	efct = efct_netdev_priv(net_dev);
+	mutex_lock(&efct->mac_lock);
+	ret = efct_mcdi_get_eeprom_page_locked(efct, page_data, extack);
+	mutex_unlock(&efct->mac_lock);
+
+	return ret;
+}
+
+#define IRQ_TIMEOUT HZ
+
+static int efct_test_phy_alive(struct efct_nic *efct, struct efct_self_tests *tests)
+{
+	int rc = 0;
+
+	rc = efct_mcdi_phy_test_alive(efct);
+	netif_dbg(efct, drv, efct->net_dev, "%s PHY liveness selftest\n",
+		  rc ? "Failed" : "Passed");
+	tests->phy_alive = rc ? -1 : 1;
+
+	return rc;
+}
+
+static int efct_nic_irq_test_irq_cpu(struct efct_nic *efct)
+{
+	return READ_ONCE(efct->last_irq_cpu);
+}
+
+static int efct_nic_irq_test_start(struct efct_nic *efct)
+{
+	if (!efct->type->irq_test_generate)
+		return -EOPNOTSUPP;
+
+	efct->last_irq_cpu = -1;
+	//Make sure value get updated before raising interrupt
+	smp_wmb();
+
+	return efct->type->irq_test_generate(efct);
+}
+
+/**************************************************************************
+ *
+ * Interrupt and event queue testing
+ *
+ **************************************************************************/
+
+/* Test generation and receipt of interrupts */
+static int efct_test_interrupts(struct efct_nic *efct,
+				struct efct_self_tests *tests)
+{
+	unsigned long timeout, wait;
+	int cpu;
+	int rc;
+
+	netif_dbg(efct, drv, efct->net_dev, "testing interrupts\n");
+	tests->interrupt = -1;
+
+	rc = efct_nic_irq_test_start(efct);
+	if (rc == -EOPNOTSUPP) {
+		netif_dbg(efct, drv, efct->net_dev,
+			  "direct interrupt testing not supported\n");
+		tests->interrupt = 0;
+		return 0;
+	}
+
+	timeout = jiffies + IRQ_TIMEOUT;
+	wait = 1;
+
+	/* Wait for arrival of test interrupt. */
+	netif_dbg(efct, drv, efct->net_dev, "waiting for test interrupt\n");
+	do {
+		schedule_timeout_uninterruptible(wait);
+		cpu = efct_nic_irq_test_irq_cpu(efct);
+		if (cpu >= 0)
+			goto success;
+		wait *= 2;
+	} while (time_before(jiffies, timeout));
+
+	netif_err(efct, drv, efct->net_dev, "timed out waiting for interrupt\n");
+	return -ETIMEDOUT;
+
+ success:
+	netif_dbg(efct, drv, efct->net_dev, "test interrupt seen on CPU%d\n", cpu);
+	tests->interrupt = 1;
+	return 0;
+}
+
+static void efct_nic_event_test_start(struct efct_ev_queue *evq)
+{
+	if (!evq->efct->type->ev_test_generate)
+		return;
+
+	evq->event_test_cpu = -1;
+	evq->event_test_napi = -1;
+	//Make sure value get updated before raising interrupt
+	smp_wmb();
+	evq->efct->type->ev_test_generate(evq);
+}
+
+static int efct_test_eventq_irq(struct efct_nic *efct,
+				struct efct_self_tests *tests)
+{
+	unsigned long *napi_ran, *dma_pend, *int_pend;
+	int dma_pending_count, int_pending_count;
+	unsigned long evq_active_mask;
+	unsigned long timeout, wait;
+	int bitmap_size;
+	bool dma_seen;
+	int evq_count;
+	bool int_seen;
+	int rc;
+	int i;
+
+	evq_active_mask = efct->evq_active_mask;
+	evq_count = fls64(evq_active_mask);
+	bitmap_size = DIV_ROUND_UP(evq_count, BITS_PER_LONG);
+
+	napi_ran = kcalloc(bitmap_size, sizeof(unsigned long), GFP_KERNEL);
+	dma_pend = kcalloc(bitmap_size, sizeof(unsigned long), GFP_KERNEL);
+	int_pend = kcalloc(bitmap_size, sizeof(unsigned long), GFP_KERNEL);
+
+	if (!napi_ran || !dma_pend || !int_pend) {
+		rc = -ENOMEM;
+		goto out_free;
+	}
+
+	dma_pending_count = 0;
+	int_pending_count = 0;
+
+	for_each_set_bit(i, &evq_active_mask, efct->max_evq_count) {
+		if (efct->evq[i].type == EVQ_T_AUX) {
+			//Cleared bit to avoid later checks
+			clear_bit(i, &evq_active_mask);
+			continue;
+		}
+		set_bit(efct->evq[i].index, dma_pend);
+		set_bit(efct->evq[i].index, int_pend);
+		efct_nic_event_test_start(&efct->evq[i]);
+		dma_pending_count++;
+		int_pending_count++;
+	}
+
+	timeout = jiffies + IRQ_TIMEOUT;
+	wait = 1;
+
+	/* Wait for arrival of interrupts.  NAPI processing may or may
+	 * not complete in time, but we can cope in any case.
+	 */
+	do {
+		schedule_timeout_uninterruptible(wait);
+
+		for_each_set_bit(i, &evq_active_mask, efct->max_evq_count) {
+			if (efct->evq[i].event_test_napi > -1) {
+				set_bit(efct->evq[i].index, napi_ran);
+				clear_bit(efct->evq[i].index, dma_pend);
+				clear_bit(efct->evq[i].index, int_pend);
+				dma_pending_count--;
+				int_pending_count--;
+			} else {
+				if (efct_nic_event_present(&efct->evq[i])) {
+					clear_bit(efct->evq[i].index, dma_pend);
+					dma_pending_count--;
+				}
+				if (efct_nic_event_test_irq_cpu(&efct->evq[i]) >= 0) {
+					clear_bit(efct->evq[i].index, int_pend);
+					int_pending_count--;
+				}
+			}
+		}
+
+		wait *= 2;
+	} while ((dma_pending_count || int_pending_count) &&
+		 time_before(jiffies, timeout));
+
+	for_each_set_bit(i, &evq_active_mask, efct->max_evq_count) {
+		dma_seen = !test_bit(efct->evq[i].index, dma_pend);
+		int_seen = !test_bit(efct->evq[i].index, int_pend);
+
+		tests->eventq_dma[efct->evq[i].index] = dma_seen ? 1 : -1;
+		tests->eventq_int[efct->evq[i].index] = int_seen ? 1 : -1;
+
+		if (dma_seen && int_seen) {
+			netif_dbg(efct, drv, efct->net_dev,
+				  "%d event queue passed (with%s NAPI)\n",
+				  efct->evq[i].index,
+				  test_bit(efct->evq[i].index, napi_ran) ?
+				  "" : "out");
+		} else {
+			/* Report failure and whether either interrupt or DMA
+			 * worked
+			 */
+			netif_err(efct, drv, efct->net_dev,
+				  "%d timed out waiting for event queue\n",
+				  efct->evq[i].index);
+			if (int_seen)
+				netif_err(efct, drv, efct->net_dev,
+					  "Event queue %d saw interrupt during event queue test\n",
+					  efct->evq[i].index);
+			if (dma_seen)
+				netif_err(efct, drv, efct->net_dev,
+					  "Event queue %d event was generated, but failed to trigger an interrupt\n",
+					  efct->evq[i].index);
+		}
+	}
+
+	rc = (dma_pending_count || int_pending_count) ? -ETIMEDOUT : 0;
+
+out_free:
+	kfree(int_pend);
+	kfree(dma_pend);
+	kfree(napi_ran);
+
+	return rc;
+}
+
+static int efct_selftest(struct efct_nic *efct, struct efct_self_tests *tests)
+{
+	int rc_test = 0;
+	int  rc;
+
+	/* Online (i.e. non-disruptive) testing
+	 * This checks interrupt generation, event delivery and PHY presence.
+	 */
+	rc = efct_test_phy_alive(efct, tests);
+	if (rc)
+		rc_test = rc;
+	rc = efct_test_interrupts(efct, tests);
+	if (rc && !rc_test)
+		rc_test = rc;
+	rc = efct_test_eventq_irq(efct, tests);
+	if (rc && !rc_test)
+		rc_test = rc;
+
+	return rc_test;
+}
+
+static void efct_ethtool_self_test(struct net_device *net_dev,
+				   struct ethtool_test *test, u64 *data)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+	struct efct_self_tests efct_tests;
+	bool already_up;
+	int rc;
+
+	memset(&efct_tests, 0, sizeof(efct_tests));
+	efct_tests.eventq_dma = kcalloc(efct->max_evq_count,
+					sizeof(efct_tests. eventq_dma),
+					GFP_KERNEL);
+	efct_tests.eventq_int = kcalloc(efct->max_evq_count,
+					sizeof(efct_tests.eventq_int),
+					GFP_KERNEL);
+
+	if (!efct_tests.eventq_dma || !efct_tests.eventq_int) {
+		rc = -ENOMEM;
+		goto fail;
+	}
+
+	already_up = (efct->net_dev->flags & IFF_UP);
+	/* We need rx buffers and interrupts. */
+	if (!already_up) {
+		rc = dev_open(efct->net_dev, NULL);
+		if (rc) {
+			netif_err(efct, drv, efct->net_dev,
+				  "failed opening device.\n");
+			goto out;
+		}
+	}
+	mutex_lock(&efct->state_lock);
+	rc = efct_selftest(efct, &efct_tests);
+	mutex_unlock(&efct->state_lock);
+	if (!already_up)
+		dev_close(efct->net_dev);
+out:
+	efct_ethtool_fill_self_tests(efct, &efct_tests, NULL, data);
+fail:
+	kfree(efct_tests.eventq_dma);
+	kfree(efct_tests.eventq_int);
+	if (rc)
+		test->flags |= ETH_TEST_FL_FAILED;
+}
+
+const struct ethtool_ops efct_ethtool_ops = {
+	.supported_coalesce_params = (ETHTOOL_COALESCE_USECS | ETHTOOL_COALESCE_USE_ADAPTIVE_RX),
+	.get_drvinfo		= efct_ethtool_get_drvinfo,
+	.get_sset_count		= efct_ethtool_get_sset_count,
+	.get_priv_flags		= NULL,
+	.get_strings		= efct_ethtool_get_strings,
+	.get_ethtool_stats	= efct_ethtool_get_stats,
+	.get_msglevel           = efct_ethtool_get_msglevel,
+	.set_msglevel           = efct_ethtool_set_msglevel,
+	.get_coalesce		= efct_ethtool_get_coalesce,
+	.set_coalesce		= efct_ethtool_set_coalesce,
+	.get_ringparam      = efct_ethtool_get_ringparam,
+	.set_ringparam      = efct_ethtool_set_ringparam,
+	.get_link_ksettings     = efct_ethtool_get_link_ksettings,
+	.set_link_ksettings     = efct_ethtool_set_link_ksettings,
+	.get_link		= ethtool_op_get_link,
+	.get_pauseparam		= efct_ethtool_get_pauseparam,
+	.set_pauseparam		= efct_ethtool_set_pauseparam,
+	.reset = efct_ethtool_reset,
+	.get_fecparam		= efct_ethtool_get_fecparam,
+	.get_ts_info		= efct_ethtool_get_ts_info,
+	.set_phys_id		= efct_ethtool_phys_id,
+	.get_rxnfc              = efct_ethtool_get_rxnfc,
+	.set_rxnfc              = efct_ethtool_set_rxnfc,
+	.get_module_info	= efct_ethtool_get_module_info,
+	.get_module_eeprom	= efct_ethtool_get_module_eeprom,
+	.get_module_eeprom_by_page = efct_ethtool_get_module_eeprom_by_page,
+	.self_test		= efct_ethtool_self_test,
+};
diff --git a/drivers/net/ethernet/amd/efct/efct_netdev.c b/drivers/net/ethernet/amd/efct/efct_netdev.c
index b6a69dfc720a..0d984d5a499a 100644
--- a/drivers/net/ethernet/amd/efct/efct_netdev.c
+++ b/drivers/net/ethernet/amd/efct/efct_netdev.c
@@ -447,6 +447,7 @@ int efct_register_netdev(struct efct_nic *efct)
 
 	net_dev->min_mtu = EFCT_MIN_MTU;
 	net_dev->max_mtu = EFCT_MAX_MTU;
+	net_dev->ethtool_ops = &efct_ethtool_ops;
 	efct->netdev_notifier.notifier_call = efct_netdev_event;
 	rc = register_netdevice_notifier(&efct->netdev_notifier);
 	if (rc) {
-- 
2.25.1

