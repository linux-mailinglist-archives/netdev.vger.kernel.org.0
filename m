Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13BD5E84E4
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 23:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbiIWVas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 17:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiIWVaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 17:30:22 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384FE9C2EA
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 14:30:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NK0pp0g1wt2MtTemz8nkUrDW1iy94dzf6b77M3zmWHF05J00LY4opBQN/nHYBV+oGNGHZ9t6NYWZ7WYmxuWvKqWYT6GyNWJSzODXPut8kIc7RNxxdIQyC/BufzHbIi4Bb5LN3L2oyh+JGnVaziRvHz5qTgH6AK3AJyMBuZ/Ss4Hp9OsoF0bEULq0TQ7mFtdWAv3ByJmJCpABW1p7ceXod0x19Btc82JAp/zEb2jJFMKmk2SzT3JnSndooy+WpyHwWizQkjws/YDXKN7RI0wixKvhqoDMHBcv09WVKf2CB+luD0ijPc5S4F269CBa1wFU2wd2i7WTf4Z11H6l/Zu9aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1iv7RxQpZ5sc+x6S7pSnYJaB7mDMujOJKfC3rZcmGg=;
 b=HBKwq4jvDmvG+3sDbbWvHIrBJiqTGFKtRKTbiMsREy2Kf3fZMC9zwXyaOdfHlQ8j7He8SqfcEMPutzZ7YuviItU/vaB7gvUTekbpgkgLz2Ds8IbGRvKar17Mcs6IUySQfI6QW/kyOEhDprm0B5GXscBamLq9gSFFkP0Qs38T+4IU/VanXWwxBfcGnCtVRKiqJ4k91Cc671zHNpA628a4/kSbMKGWirq4VUaZcIoXI2I6CejUulxy1hDKydUepqQ5efQ6DifbgVIC2Rf2XSD9PB3414ua3ICzqEyBn7J9Y7Wn/o1Pdy+907GxqqKfbRg777O2qjkACFdr7VwTxugyyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1iv7RxQpZ5sc+x6S7pSnYJaB7mDMujOJKfC3rZcmGg=;
 b=L/X3PmztiYNQTP6V75/yXaVib+GOnC3crZOdK3tgVVM/6EXwrrDOJ7z2qKtUdh5TwYpFcpy+7mpi4eB5Ys5kQmEf7L80S2zHZ96bKtWBXT7dPfdeUe+VgvbFrocQ/uJRYegF93U/5jQGORguSSo5nM7dhtNAKjBdrw4r4NlXqOMqwa+U+84r23qfGM9IuObPaCCPmBpCGNBuQUUBgAgeSUNsxyjG+egMy0Mu5Xdh8hUWZgXnzSd/+VDK3fUHL5BXezHLvm3rgIrbjsqwMKmnBOmT3YXCW+Ngd0UjekdgI3R1CGJn5RzTQJGyl3vbB3Ew68KCFOERxGFpzqDwo6AGOw==
Received: from BN7PR02CA0010.namprd02.prod.outlook.com (2603:10b6:408:20::23)
 by SJ1PR12MB6194.namprd12.prod.outlook.com (2603:10b6:a03:458::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Fri, 23 Sep
 2022 21:30:01 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::2a) by BN7PR02CA0010.outlook.office365.com
 (2603:10b6:408:20::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20 via Frontend
 Transport; Fri, 23 Sep 2022 21:30:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Fri, 23 Sep 2022 21:30:00 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 23 Sep
 2022 16:29:59 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 23 Sep 2022 16:29:57 -0500
From:   <ecree@xilinx.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: [PATCH net-next 6/6] sfc: bare bones TC offload on EF100
Date:   Fri, 23 Sep 2022 22:05:38 +0100
Message-ID: <6f967e0a4fef964ea3d6e4d188833a6ef40d6aaf.1663962653.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1663962652.git.ecree.xilinx@gmail.com>
References: <cover.1663962652.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT005:EE_|SJ1PR12MB6194:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c94287a-ad02-48c9-b31e-08da9daac57a
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ygQUpjC+dPZwI20m5DA8NF9YJ3jC1Iz77iNMqECyelpXIpMCuG0rm4XcqQn7cvJ35bW+CIomYPUbYdicShafOxITYcahhpcZKTtKpn3jk5/bcCJeRzHAmgJFpwn3GP/8Z5QOSBXynejsHovpUgQKZIcY5HT1rVFG7YLVs/lEw6QEmUiTtZ5YrTQQVMieOiIXHn/rfWWdppyEpi/tE3onB1A77C2SA5K0750o3uYVV2/GKACyS6gcn5usNMc80/FpkFw37PsX5BSHqOeepow7w2OuL6NLtXGCB/tsXtE522oKLMS29Gi5+Sdf0T/uCjBdNYLKYiZ4dGag2ty34BhRr1kNfXkxiQnbEfgotUFYh9Z1aY/1z/zBEleSuxTxBWJtPOyy75PcciDY+Yir21SD10SicIno8xX06Z81Pt+DM3EDAKo4dz423bBivzxv4VRNPlfHPT/k9awEjS+BgX3JQeL28xd2x7XkX2+1N0xcJERNcqFapHwpQdKy6kehfx8aOj/+N0QTU/KlB9lPnJ+aRF7I9vMMnViih2StTW6VwD/mKqTTce9dSA/KZmA7W9DRJ0NZl3s2uxVs5Pyj9cRwHTgCzW72+nLiph9f0iI9cw7F3LCHdEjLH7MjuLvRj3ggvafQKkVTBUVQhYPTBEXNwh114H612/Geh74ks5rCvi1+faVNftCT8Lh2ElMux17fKLoxX8DbdT1B2ju4J2ov+RDmd8pW1E2DPh+f3SyEHj5XLxTkwWsGHN+TMWxLbbGQ2I66WhfmP1N/IxtwgXM6vaV3UQnY/gCv1pt0g4JlyMMTyzt5becSS1tVzlff+K+E
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(136003)(346002)(451199015)(40470700004)(36840700001)(46966006)(26005)(40480700001)(47076005)(8676002)(83380400001)(9686003)(82740400003)(36860700001)(36756003)(6666004)(186003)(8936002)(336012)(316002)(54906003)(42882007)(81166007)(82310400005)(110136005)(55446002)(83170400001)(478600001)(70206006)(4326008)(70586007)(356005)(41300700001)(5660300002)(30864003)(40460700003)(2906002)(2876002)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 21:30:00.8875
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c94287a-ad02-48c9-b31e-08da9daac57a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6194
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

This is the absolute minimum viable TC implementation to get traffic to
 VFs and allow them to be tested; it supports no match fields besides
 ingress port, no actions besides mirred and drop, and no stats.
Example usage:
    tc filter add dev $PF parent ffff: flower skip_sw \
        action mirred egress mirror dev $VFREP
    tc filter add dev $VFREP parent ffff: flower skip_sw \
        action mirred egress redirect dev $PF
 gives a VF unfiltered access to the network out the physical port ($PF
 acts here as a physical port representor).
More matches, actions, and counters will be added in subsequent patches.

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c  | 109 +++++++++++++
 drivers/net/ethernet/sfc/mae.h  |   4 +
 drivers/net/ethernet/sfc/mcdi.h |  10 ++
 drivers/net/ethernet/sfc/tc.c   | 272 ++++++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/tc.h   |   2 +
 5 files changed, 397 insertions(+)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 19138b2d2f5c..874c765b2465 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -168,6 +168,111 @@ int efx_mae_get_caps(struct efx_nic *efx, struct mae_caps *caps)
 				       caps->action_rule_fields);
 }
 
+/* Bit twiddling:
+ * Prefix: 1...110...0
+ *      ~: 0...001...1
+ *    + 1: 0...010...0 is power of two
+ * so (~x) & ((~x) + 1) == 0.  Converse holds also.
+ */
+#define is_prefix_byte(_x)	!(((_x) ^ 0xff) & (((_x) ^ 0xff) + 1))
+
+enum mask_type { MASK_ONES, MASK_ZEROES, MASK_PREFIX, MASK_OTHER };
+
+static const char *mask_type_name(enum mask_type typ)
+{
+	switch (typ) {
+	case MASK_ONES:
+		return "all-1s";
+	case MASK_ZEROES:
+		return "all-0s";
+	case MASK_PREFIX:
+		return "prefix";
+	case MASK_OTHER:
+		return "arbitrary";
+	default: /* can't happen */
+		return "unknown";
+	}
+}
+
+/* Checks a (big-endian) bytestring is a bit prefix */
+static enum mask_type classify_mask(const u8 *mask, size_t len)
+{
+	bool zeroes = true; /* All bits seen so far are zeroes */
+	bool ones = true; /* All bits seen so far are ones */
+	bool prefix = true; /* Valid prefix so far */
+	size_t i;
+
+	for (i = 0; i < len; i++) {
+		if (ones) {
+			if (!is_prefix_byte(mask[i]))
+				prefix = false;
+		} else if (mask[i]) {
+			prefix = false;
+		}
+		if (mask[i] != 0xff)
+			ones = false;
+		if (mask[i])
+			zeroes = false;
+	}
+	if (ones)
+		return MASK_ONES;
+	if (zeroes)
+		return MASK_ZEROES;
+	if (prefix)
+		return MASK_PREFIX;
+	return MASK_OTHER;
+}
+
+static int efx_mae_match_check_cap_typ(u8 support, enum mask_type typ)
+{
+	switch (support) {
+	case MAE_FIELD_UNSUPPORTED:
+	case MAE_FIELD_SUPPORTED_MATCH_NEVER:
+		if (typ == MASK_ZEROES)
+			return 0;
+		return -EOPNOTSUPP;
+	case MAE_FIELD_SUPPORTED_MATCH_OPTIONAL:
+		if (typ == MASK_ZEROES)
+			return 0;
+		fallthrough;
+	case MAE_FIELD_SUPPORTED_MATCH_ALWAYS:
+		if (typ == MASK_ONES)
+			return 0;
+		return -EINVAL;
+	case MAE_FIELD_SUPPORTED_MATCH_PREFIX:
+		if (typ == MASK_OTHER)
+			return -EOPNOTSUPP;
+		return 0;
+	case MAE_FIELD_SUPPORTED_MATCH_MASK:
+		return 0;
+	default:
+		return -EIO;
+	}
+}
+
+int efx_mae_match_check_caps(struct efx_nic *efx,
+			     const struct efx_tc_match_fields *mask,
+			     struct netlink_ext_ack *extack)
+{
+	const u8 *supported_fields = efx->tc->caps->action_rule_fields;
+	__be32 ingress_port = cpu_to_be32(mask->ingress_port);
+	enum mask_type ingress_port_mask_type;
+	int rc;
+
+	/* Check for _PREFIX assumes big-endian, so we need to convert */
+	ingress_port_mask_type = classify_mask((const u8 *)&ingress_port,
+					       sizeof(ingress_port));
+	rc = efx_mae_match_check_cap_typ(supported_fields[MAE_FIELD_INGRESS_PORT],
+					 ingress_port_mask_type);
+	if (rc) {
+		efx_tc_err(efx, "No support for %s mask in field ingress_port\n",
+			   mask_type_name(ingress_port_mask_type));
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported mask type for ingress_port");
+		return rc;
+	}
+	return 0;
+}
+
 static bool efx_mae_asl_id(u32 id)
 {
 	return !!(id & BIT(31));
@@ -335,6 +440,10 @@ static int efx_mae_populate_match_criteria(MCDI_DECLARE_STRUCT_PTR(match_crit),
 	}
 	MCDI_STRUCT_SET_DWORD(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_INGRESS_MPORT_SELECTOR_MASK,
 			      match->mask.ingress_port);
+	MCDI_STRUCT_SET_BYTE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_RECIRC_ID,
+			     match->value.recirc_id);
+	MCDI_STRUCT_SET_BYTE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_RECIRC_ID_MASK,
+			     match->mask.recirc_id);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index 2b49a88b303c..3e0cd238d523 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -37,6 +37,10 @@ struct mae_caps {
 
 int efx_mae_get_caps(struct efx_nic *efx, struct mae_caps *caps);
 
+int efx_mae_match_check_caps(struct efx_nic *efx,
+			     const struct efx_tc_match_fields *mask,
+			     struct netlink_ext_ack *extack);
+
 int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act);
 int efx_mae_free_action_set(struct efx_nic *efx, u32 fw_id);
 
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index 26bc69f76801..1f18e9dc62e8 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -201,6 +201,12 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 	((u8 *)(_buf) + (_offset))
 #define MCDI_PTR(_buf, _field)						\
 	_MCDI_PTR(_buf, MC_CMD_ ## _field ## _OFST)
+/* Use MCDI_STRUCT_ functions to access members of MCDI structuredefs.
+ * _buf should point to the start of the structure, typically obtained with
+ * MCDI_DECLARE_STRUCT_PTR(structure) = _MCDI_DWORD(mcdi_buf, FIELD_WHICH_IS_STRUCT);
+ */
+#define MCDI_STRUCT_PTR(_buf, _field)					\
+	_MCDI_PTR(_buf, _field ## _OFST)
 #define _MCDI_CHECK_ALIGN(_ofst, _align)				\
 	((_ofst) + BUILD_BUG_ON_ZERO((_ofst) & (_align - 1)))
 #define _MCDI_DWORD(_buf, _field)					\
@@ -208,6 +214,10 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 #define _MCDI_STRUCT_DWORD(_buf, _field)				\
 	((_buf) + (_MCDI_CHECK_ALIGN(_field ## _OFST, 4) >> 2))
 
+#define MCDI_STRUCT_SET_BYTE(_buf, _field, _value) do {			\
+	BUILD_BUG_ON(_field ## _LEN != 1);				\
+	*(u8 *)MCDI_STRUCT_PTR(_buf, _field) = _value;			\
+	} while (0)
 #define MCDI_BYTE(_buf, _field)						\
 	((void)BUILD_BUG_ON_ZERO(MC_CMD_ ## _field ## _LEN != 1),	\
 	 *MCDI_PTR(_buf, _field))
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index bc8c3cab4db8..ac20d94398c9 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -9,6 +9,7 @@
  * by the Free Software Foundation, incorporated herein by reference.
  */
 
+#include <net/pkt_cls.h>
 #include "tc.h"
 #include "tc_bindings.h"
 #include "mae.h"
@@ -42,6 +43,20 @@ struct efx_rep *efx_tc_flower_lookup_efv(struct efx_nic *efx,
 	return efv;
 }
 
+/* Convert a driver-internal vport ID into an external device (wire or VF) */
+s64 efx_tc_flower_external_mport(struct efx_nic *efx, struct efx_rep *efv)
+{
+	u32 mport;
+
+	if (IS_ERR(efv))
+		return PTR_ERR(efv);
+	if (!efv) /* device is PF (us) */
+		efx_mae_mport_wire(efx, &mport);
+	else /* device is repr */
+		efx_mae_mport_mport(efx, efv->mport, &mport);
+	return mport;
+}
+
 static const struct rhashtable_params efx_tc_match_action_ht_params = {
 	.key_len	= sizeof(unsigned long),
 	.key_offset	= offsetof(struct efx_tc_flow_rule, cookie),
@@ -109,6 +124,260 @@ static void efx_tc_flow_free(void *ptr, void *arg)
 	kfree(rule);
 }
 
+static int efx_tc_flower_parse_match(struct efx_nic *efx,
+				     struct flow_rule *rule,
+				     struct efx_tc_match *match,
+				     struct netlink_ext_ack *extack)
+{
+	struct flow_dissector *dissector = rule->match.dissector;
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
+		struct flow_match_control fm;
+
+		flow_rule_match_control(rule, &fm);
+
+		if (fm.mask->flags) {
+			efx_tc_err(efx, "Unsupported match on control.flags %#x\n",
+				   fm.mask->flags);
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported match on control.flags");
+			return -EOPNOTSUPP;
+		}
+	}
+	if (dissector->used_keys &
+	    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
+	      BIT(FLOW_DISSECTOR_KEY_BASIC))) {
+		efx_tc_err(efx, "Unsupported flower keys %#x\n", dissector->used_keys);
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported flower keys encountered");
+		return -EOPNOTSUPP;
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic fm;
+
+		flow_rule_match_basic(rule, &fm);
+		if (fm.mask->n_proto) {
+			EFX_TC_ERR_MSG(efx, extack, "Unsupported eth_proto match\n");
+			return -EOPNOTSUPP;
+		}
+		if (fm.mask->ip_proto) {
+			EFX_TC_ERR_MSG(efx, extack, "Unsupported ip_proto match\n");
+			return -EOPNOTSUPP;
+		}
+	}
+
+	return 0;
+}
+
+static int efx_tc_flower_replace(struct efx_nic *efx,
+				 struct net_device *net_dev,
+				 struct flow_cls_offload *tc,
+				 struct efx_rep *efv)
+{
+	struct flow_rule *fr = flow_cls_offload_flow_rule(tc);
+	struct netlink_ext_ack *extack = tc->common.extack;
+	struct efx_tc_flow_rule *rule = NULL, *old;
+	struct efx_tc_action_set *act = NULL;
+	const struct flow_action_entry *fa;
+	struct efx_rep *from_efv, *to_efv;
+	struct efx_tc_match match;
+	s64 rc;
+	int i;
+
+	if (!tc_can_offload_extack(efx->net_dev, extack))
+		return -EOPNOTSUPP;
+	if (WARN_ON(!efx->tc))
+		return -ENETDOWN;
+	if (WARN_ON(!efx->tc->up))
+		return -ENETDOWN;
+
+	from_efv = efx_tc_flower_lookup_efv(efx, net_dev);
+	if (IS_ERR(from_efv)) {
+		/* Might be a tunnel decap rule from an indirect block.
+		 * Support for those not implemented yet.
+		 */
+		return -EOPNOTSUPP;
+	}
+
+	if (efv != from_efv) {
+		/* can't happen */
+		efx_tc_err(efx, "for %s efv is %snull but from_efv is %snull\n",
+			   netdev_name(net_dev), efv ? "non-" : "",
+			   from_efv ? "non-" : "");
+		if (efv)
+			NL_SET_ERR_MSG_MOD(extack, "vfrep filter has PF net_dev (can't happen)");
+		else
+			NL_SET_ERR_MSG_MOD(extack, "PF filter has vfrep net_dev (can't happen)");
+		return -EINVAL;
+	}
+
+	/* Parse match */
+	memset(&match, 0, sizeof(match));
+	rc = efx_tc_flower_external_mport(efx, from_efv);
+	if (rc < 0) {
+		EFX_TC_ERR_MSG(efx, extack, "Failed to identify ingress m-port");
+		return rc;
+	}
+	match.value.ingress_port = rc;
+	match.mask.ingress_port = ~0;
+	rc = efx_tc_flower_parse_match(efx, fr, &match, extack);
+	if (rc)
+		return rc;
+
+	if (tc->common.chain_index) {
+		EFX_TC_ERR_MSG(efx, extack, "No support for nonzero chain_index");
+		return -EOPNOTSUPP;
+	}
+	match.mask.recirc_id = 0xff;
+
+	rc = efx_mae_match_check_caps(efx, &match.mask, extack);
+	if (rc)
+		return rc;
+
+	rule = kzalloc(sizeof(*rule), GFP_USER);
+	if (!rule)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&rule->acts.list);
+	rule->cookie = tc->cookie;
+	old = rhashtable_lookup_get_insert_fast(&efx->tc->match_action_ht,
+						&rule->linkage,
+						efx_tc_match_action_ht_params);
+	if (old) {
+		netif_dbg(efx, drv, efx->net_dev,
+			  "Already offloaded rule (cookie %lx)\n", tc->cookie);
+		rc = -EEXIST;
+		NL_SET_ERR_MSG_MOD(extack, "Rule already offloaded");
+		goto release;
+	}
+
+	/* Parse actions */
+	act = kzalloc(sizeof(*act), GFP_USER);
+	if (!act) {
+		rc = -ENOMEM;
+		goto release;
+	}
+
+	flow_action_for_each(i, fa, &fr->action) {
+		struct efx_tc_action_set save;
+
+		if (!act) {
+			/* more actions after a non-pipe action */
+			EFX_TC_ERR_MSG(efx, extack, "Action follows non-pipe action");
+			rc = -EINVAL;
+			goto release;
+		}
+
+		switch (fa->id) {
+		case FLOW_ACTION_DROP:
+			rc = efx_mae_alloc_action_set(efx, act);
+			if (rc) {
+				EFX_TC_ERR_MSG(efx, extack, "Failed to write action set to hw (drop)");
+				goto release;
+			}
+			list_add_tail(&act->list, &rule->acts.list);
+			act = NULL; /* end of the line */
+			break;
+		case FLOW_ACTION_REDIRECT:
+		case FLOW_ACTION_MIRRED:
+			save = *act;
+			to_efv = efx_tc_flower_lookup_efv(efx, fa->dev);
+			if (IS_ERR(to_efv)) {
+				EFX_TC_ERR_MSG(efx, extack, "Mirred egress device not on switch");
+				rc = PTR_ERR(to_efv);
+				goto release;
+			}
+			rc = efx_tc_flower_external_mport(efx, to_efv);
+			if (rc < 0) {
+				EFX_TC_ERR_MSG(efx, extack, "Failed to identify egress m-port");
+				goto release;
+			}
+			act->dest_mport = rc;
+			act->deliver = 1;
+			rc = efx_mae_alloc_action_set(efx, act);
+			if (rc) {
+				EFX_TC_ERR_MSG(efx, extack, "Failed to write action set to hw (mirred)");
+				goto release;
+			}
+			list_add_tail(&act->list, &rule->acts.list);
+			act = NULL;
+			if (fa->id == FLOW_ACTION_REDIRECT)
+				break; /* end of the line */
+			/* Mirror, so continue on with saved act */
+			act = kzalloc(sizeof(*act), GFP_USER);
+			if (!act) {
+				rc = -ENOMEM;
+				goto release;
+			}
+			*act = save;
+			break;
+		default:
+			efx_tc_err(efx, "Unhandled action %u\n", fa->id);
+			rc = -EOPNOTSUPP;
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
+			goto release;
+		}
+	}
+
+	if (act) {
+		/* Not shot/redirected, so deliver to default dest */
+		if (from_efv == EFX_EFV_PF)
+			/* Rule applies to traffic from the wire,
+			 * and default dest is thus the PF
+			 */
+			efx_mae_mport_uplink(efx, &act->dest_mport);
+		else
+			/* Representor, so rule applies to traffic from
+			 * representee, and default dest is thus the rep.
+			 * All reps use the same mport for delivery
+			 */
+			efx_mae_mport_mport(efx, efx->tc->reps_mport_id,
+					    &act->dest_mport);
+		act->deliver = 1;
+		rc = efx_mae_alloc_action_set(efx, act);
+		if (rc) {
+			EFX_TC_ERR_MSG(efx, extack, "Failed to write action set to hw (deliver)");
+			goto release;
+		}
+		list_add_tail(&act->list, &rule->acts.list);
+		act = NULL; /* Prevent double-free in error path */
+	}
+
+	netif_dbg(efx, drv, efx->net_dev,
+		  "Successfully parsed filter (cookie %lx)\n",
+		  tc->cookie);
+
+	rule->match = match;
+
+	rc = efx_mae_alloc_action_set_list(efx, &rule->acts);
+	if (rc) {
+		EFX_TC_ERR_MSG(efx, extack, "Failed to write action set list to hw");
+		goto release;
+	}
+	rc = efx_mae_insert_rule(efx, &rule->match, EFX_TC_PRIO_TC,
+				 rule->acts.fw_id, &rule->fw_id);
+	if (rc) {
+		EFX_TC_ERR_MSG(efx, extack, "Failed to insert rule in hw");
+		goto release_acts;
+	}
+	return 0;
+
+release_acts:
+	efx_mae_free_action_set_list(efx, &rule->acts);
+release:
+	/* We failed to insert the rule, so free up any entries we created in
+	 * subsidiary tables.
+	 */
+	if (act)
+		efx_tc_free_action_set(efx, act, false);
+	if (rule) {
+		rhashtable_remove_fast(&efx->tc->match_action_ht,
+				       &rule->linkage,
+				       efx_tc_match_action_ht_params);
+		efx_tc_free_action_set_list(efx, &rule->acts, false);
+	}
+	kfree(rule);
+	return rc;
+}
+
 static int efx_tc_flower_destroy(struct efx_nic *efx,
 				 struct net_device *net_dev,
 				 struct flow_cls_offload *tc)
@@ -151,6 +420,9 @@ int efx_tc_flower(struct efx_nic *efx, struct net_device *net_dev,
 
 	mutex_lock(&efx->tc->mutex);
 	switch (tc->command) {
+	case FLOW_CLS_REPLACE:
+		rc = efx_tc_flower_replace(efx, net_dev, tc, efv);
+		break;
 	case FLOW_CLS_DESTROY:
 		rc = efx_tc_flower_destroy(efx, net_dev, tc);
 		break;
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index baf1e67b58a5..196fd74ed973 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -43,6 +43,7 @@ struct efx_tc_action_set {
 struct efx_tc_match_fields {
 	/* L1 */
 	u32 ingress_port;
+	u8 recirc_id;
 };
 
 struct efx_tc_match {
@@ -64,6 +65,7 @@ struct efx_tc_flow_rule {
 };
 
 enum efx_tc_rule_prios {
+	EFX_TC_PRIO_TC, /* Rule inserted by TC */
 	EFX_TC_PRIO_DFLT, /* Default switch rule; one of efx_tc_default_rules */
 	EFX_TC_PRIO__NUM
 };
