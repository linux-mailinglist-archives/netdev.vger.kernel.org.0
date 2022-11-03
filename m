Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8672E6182C8
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 16:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbiKCP26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 11:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbiKCP2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 11:28:09 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E247D1B9D1
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 08:28:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LkvPlX24kWpjh5n21VjAMtr2YOXyUfdeeYeVR6IoYeRyF39TTXR4dPp3DkDMIvZ0T4FpFY4cSAEG+sRCK1UHGtSkaXPL/sw8nkVS6soa84LNh24vm9f9t5ohtbteeXvtLmbbUcCz6GbPUl70pbudrlSIWsf6C9wc//+j2iNUs1HTw7hQU2wAMkMeXg7I9Iv3Mi/oT0skFvV9QJOxACNIZAehphLn6CDOEc98IbQ2ea8URTkOl8E031T9VbQr1Y3//cKpW2wh4XI6AnANteE575GQGKxviXOg/M6nSK7OQAI1vF5G729kfDHXNMP9CvA3RKPwVxmNl91vnDHNZd1VSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RdBf05axzOIrSp5vNjVFrX/2eGJ6ElRZxq1GmFdNSgQ=;
 b=BwnHZvjDKE5zA9yHrFaQ2ESHf54WXs/5zT5rn7W2G2E5t7AeknRo3r2NESttqmWUJsVCGqshei4nTZUiJ2PtVfmytXWSt0qG1bvTw8GJz/pI2VT4nfolEWPNEEBTqc4DDUo3I7Mb+yQnxXfKWVoTi9ErtAAREf0zWZzQMPtAs0c7bYKii0OlKAca3SFK6ksGn9d2Vi1cG0hD4pVh0d6nBIScXjzou+Qr+B1cVd8AYiQDbew5GDos+QMaFDpJ3AjfCu2be2zUH8Eq3hWo6S/pfikaT2YVtLkMV73FsPjhOgbHIMqFzjL0QmlXUnW532d65Q7DL3A43o/ojDfU8Ek3UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdBf05axzOIrSp5vNjVFrX/2eGJ6ElRZxq1GmFdNSgQ=;
 b=KPzKbvU66AD3YIA6ZN5k6mA97oKQxN1BNvZU+o13ttKfbgeU5g3daTU9XdmL6JsfHn8IblUHwxbvqXreYhezcOxj4lRLPQYBJYNOGBbZyY4vB38OdjOQiKX/lPP5dXrqiMqk3cOavDU+karowOv3ExMJ7Sq/X+V1P3I33HGyrVc=
Received: from DS7P222CA0020.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::16) by
 IA0PR12MB8086.namprd12.prod.outlook.com (2603:10b6:208:403::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.19; Thu, 3 Nov 2022 15:28:06 +0000
Received: from DM6NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2e:cafe::28) by DS7P222CA0020.outlook.office365.com
 (2603:10b6:8:2e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22 via Frontend
 Transport; Thu, 3 Nov 2022 15:28:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT082.mail.protection.outlook.com (10.13.173.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Thu, 3 Nov 2022 15:28:06 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 10:28:05 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 08:28:05 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Thu, 3 Nov 2022 10:28:03 -0500
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 4/5] sfc: add Layer 3 flag matches to ef100 TC offload
Date:   Thu, 3 Nov 2022 15:27:30 +0000
Message-ID: <d5e29a11b6c07664a5d7177cf62e6e110b2dfe62.1667412458.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1667412458.git.ecree.xilinx@gmail.com>
References: <cover.1667412458.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT082:EE_|IA0PR12MB8086:EE_
X-MS-Office365-Filtering-Correlation-Id: 328e22c4-cf0e-475f-4aa0-08dabdb00188
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z9n7kk1u6g70XqRXz7r9mgjgKJTWOZGyHdSLyHyY7e4pEDjtJNijTwLLuP/tfZ5YUiCPPF9U+Vafuj4i33OZml9i2XCH5kP5M2ZQ+y/MNcXxo3PxAbA2H4Uz8AsSObyuToq4iMcpsyAuBjkMpo3VItxL2wCKjSK3eUiyXVLWP/KOvfyrjK1/cigk9foSfwXJysMSqXHofQZ5VWGmPTHPfQj7YxL/isKBBM23i4eJOqEPQeJNoyu6qKvPCXVfJUQO5ajZLz/2TzdQpMFpJQpf6C3GXiIQlXNCm8/RtwxMipyVVr50e6QuhTSmxkm6ahE82Ao2u1jSK0DXtiVh3KeKgkDxr7whwoRAy7/njPqdrcr0lfS7WdDIMrwysg0id1V4ErrTvo4YGYgpCGhCrZfVSTe8ynXpaauDpuhX7gV8LUaQh4b8yCyRFGp2aH7XInZJQMUJ3+M0kSFlNgxDrwaYx/h9htyDBMTTsePhj8eu66Re1ATM3MPdl5HFcXE+6gN5DY0si8/wNk0wrkQe/m2W7EknOlN88m0Bhkdw/qewM+x0Mdfpu2vunfuWLWJWFIbv3xzxEiivcc16tUzkdlepnyFSWlLr8Sn+voYhMqZ0BJa3Yw8yEPI0QVp8yReksdyj07a2JP43UbGSnHlyHtLVo8lCEmmkEV3KqjEliyv/7mR2J4jXrtnowaDoEPQN11FBTpz72BABxVdCkfC9eNmqRa9DWWzZUWHlR8PCYTVvKzfCiC6rhQpqIZqZhZ5gN6ZMdlAFuN1PY1pNqCquDZPxMLv2mTH4qnp/uwvHDPp+zZUr8NRIhrledIcPEh9y1h1J
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(81166007)(36756003)(82310400005)(70206006)(41300700001)(47076005)(316002)(5660300002)(40460700003)(40480700001)(8936002)(110136005)(6636002)(2876002)(2906002)(54906003)(70586007)(9686003)(26005)(83380400001)(4326008)(186003)(356005)(82740400003)(336012)(478600001)(36860700001)(86362001)(55446002)(426003)(6666004)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 15:28:06.3168
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 328e22c4-cf0e-475f-4aa0-08dabdb00188
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8086
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Support matching on ip_frag and ip_firstfrag.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c | 25 +++++++++++++++++++++++++
 drivers/net/ethernet/sfc/tc.c  | 10 +++++++++-
 drivers/net/ethernet/sfc/tc.h  |  1 +
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index b894fc658867..e24436ba699c 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -263,6 +263,18 @@ static int efx_mae_match_check_cap_typ(u8 support, enum mask_type typ)
 				       mask_type_name(typ), #_field);	       \
 	rc;								       \
 })
+/* Booleans need special handling */
+#define CHECK_BIT(_mcdi, _field)	({				       \
+	enum mask_type typ = mask->_field ? MASK_ONES : MASK_ZEROES;	       \
+									       \
+	rc = efx_mae_match_check_cap_typ(supported_fields[MAE_FIELD_ ## _mcdi],\
+					 typ);				       \
+	if (rc)								       \
+		NL_SET_ERR_MSG_FMT_MOD(extack,				       \
+				       "No support for %s mask in field %s",   \
+				       mask_type_name(typ), #_field);	       \
+	rc;								       \
+})
 
 int efx_mae_match_check_caps(struct efx_nic *efx,
 			     const struct efx_tc_match_fields *mask,
@@ -299,10 +311,13 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
 	    CHECK(SRC_IP6, src_ip6) ||
 	    CHECK(DST_IP6, dst_ip6) ||
 #endif
+	    CHECK_BIT(IS_IP_FRAG, ip_frag) ||
+	    CHECK_BIT(IP_FIRST_FRAG, ip_firstfrag) ||
 	    CHECK(RECIRC_ID, recirc_id))
 		return rc;
 	return 0;
 }
+#undef CHECK_BIT
 #undef CHECK
 
 static bool efx_mae_asl_id(u32 id)
@@ -472,6 +487,16 @@ static int efx_mae_populate_match_criteria(MCDI_DECLARE_STRUCT_PTR(match_crit),
 	}
 	MCDI_STRUCT_SET_DWORD(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_INGRESS_MPORT_SELECTOR_MASK,
 			      match->mask.ingress_port);
+	EFX_POPULATE_DWORD_2(*_MCDI_STRUCT_DWORD(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_FLAGS),
+			     MAE_FIELD_MASK_VALUE_PAIRS_V2_IS_IP_FRAG,
+			     match->value.ip_frag,
+			     MAE_FIELD_MASK_VALUE_PAIRS_V2_IP_FIRST_FRAG,
+			     match->value.ip_firstfrag);
+	EFX_POPULATE_DWORD_2(*_MCDI_STRUCT_DWORD(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_FLAGS_MASK),
+			     MAE_FIELD_MASK_VALUE_PAIRS_V2_IS_IP_FRAG,
+			     match->mask.ip_frag,
+			     MAE_FIELD_MASK_VALUE_PAIRS_V2_IP_FIRST_FRAG,
+			     match->mask.ip_firstfrag);
 	MCDI_STRUCT_SET_BYTE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_RECIRC_ID,
 			     match->value.recirc_id);
 	MCDI_STRUCT_SET_BYTE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_RECIRC_ID_MASK,
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index d992fafc844e..1a9cc2ad1335 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -168,7 +168,15 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 				break;
 			}
 
-		if (fm.mask->flags) {
+		if (fm.mask->flags & FLOW_DIS_IS_FRAGMENT) {
+			match->value.ip_frag = fm.key->flags & FLOW_DIS_IS_FRAGMENT;
+			match->mask.ip_frag = true;
+		}
+		if (fm.mask->flags & FLOW_DIS_FIRST_FRAG) {
+			match->value.ip_firstfrag = fm.key->flags & FLOW_DIS_FIRST_FRAG;
+			match->mask.ip_firstfrag = true;
+		}
+		if (fm.mask->flags & ~(FLOW_DIS_IS_FRAGMENT | FLOW_DIS_FIRST_FRAG)) {
 			NL_SET_ERR_MSG_FMT_MOD(extack, "Unsupported match on control.flags %#x",
 					       fm.mask->flags);
 			return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index aebe9c251b2c..d2b61926657b 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -38,6 +38,7 @@ struct efx_tc_match_fields {
 #ifdef CONFIG_IPV6
 	struct in6_addr src_ip6, dst_ip6;
 #endif
+	bool ip_frag, ip_firstfrag;
 };
 
 struct efx_tc_match {
