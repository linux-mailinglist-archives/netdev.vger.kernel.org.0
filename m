Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13EF9609E06
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 11:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiJXJa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 05:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiJXJaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 05:30:20 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C2642ACB
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 02:30:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PPdMKdEZVbCrWJ0N0VeE6Nyw99ujt867J9e3H2llq1jDOMLqur4rG/aVhMJqgwN+6blUZI6OYk+OFzjnDFIVzVAhWsR6+nFaT6wnQBCmuCLod9lS+j41jS5PVspfyPRS0KdiBUbFzyh2SkMoCqWczw1tiL45dE1QYmtGB450MTNW3PzanWlEsCeXToAwdSZphRf7r+LChv3zQDMRDz/i5fHMV9FLgItgXIEqGE65P2PTwNeIpBSsmfa6x5y6vSmqHc2QZKDSxkp8kZITX/XSEEDPbCT5qdHTJNB9I2PkHPzR54PC4SGbcyjjGSWwvEmPC2U34gDDiWaanjcOJpYCkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uX9yTJVfx243DT4rn/clx3tkrELYka32ZoIkzHfPejg=;
 b=IVMSzsS81cAU/cqwpnXSjGBcowKFehSbjvWSx6c1G+uG0xoC6mjBJRHfmkd39PEkM4en1hKfo8hL0OFBM4RmtXMycDGovF0KseWjIVsqvvpf1IKPSrTFBEMIE2Pu0ZE4u8s3UfDZOIfTPn7B45TPlRgh/HtQpUlsVa+erOIg5Y4pjVMgPPg9PtBbxWU5PrAO1aqcTh98S0R4aCOGszgjgW1Jly52Xyq+e3lMUBGpIXV7vilTJ3tbpqkT3whUw9arsS09Qi+FpD2Hwz273DFEmP5jr/y27DLWBuKGqh2aGKTRp6+CZbIfqDxmc/Ty9IxzZcWiOCWDpNB6Zm1C50+dMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uX9yTJVfx243DT4rn/clx3tkrELYka32ZoIkzHfPejg=;
 b=LAe54f5tw7piFIuRM+l2pr8JtWAVrkNMBfXtaAnJFBXuziTHbGBvgsYKgqYGnBCSapU0L3DO1xzDakiFAKRyUE+X7tM1MtoNvkG8n2kR9VgtX2C3QuprFt1RTPiQZazp8dcgn0By0Lbwtxlhy78ylRkE1pFBkCvnClG2vxQlrFg=
Received: from BN9PR03CA0041.namprd03.prod.outlook.com (2603:10b6:408:fb::16)
 by MN0PR12MB6197.namprd12.prod.outlook.com (2603:10b6:208:3c6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Mon, 24 Oct
 2022 09:30:11 +0000
Received: from BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fb:cafe::61) by BN9PR03CA0041.outlook.office365.com
 (2603:10b6:408:fb::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26 via Frontend
 Transport; Mon, 24 Oct 2022 09:30:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT058.mail.protection.outlook.com (10.13.177.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Mon, 24 Oct 2022 09:30:11 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 24 Oct
 2022 04:30:10 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 24 Oct
 2022 04:30:10 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Mon, 24 Oct 2022 04:30:08 -0500
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 1/5] sfc: check recirc_id match caps before MAE offload
Date:   Mon, 24 Oct 2022 10:29:21 +0100
Message-ID: <d3da32136ba31c553fa267381eb6a01903525814.1666603600.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1666603600.git.ecree.xilinx@gmail.com>
References: <cover.1666603600.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT058:EE_|MN0PR12MB6197:EE_
X-MS-Office365-Filtering-Correlation-Id: 16c61920-2fbf-4089-1da7-08dab5a25924
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gm8EzIVUin1/oLZTf7uHBJI5oLrA75s/W1rIwR7sw0L+0cvnu5P6MbIT5A0wk5jqGOInM4Gg2rZirouZlZlqNhiw7awSbU6MxgfLQig2ztKLWcWfVnJ/9I6WcmnlUFiYG70zXiik4wwbsrVjUwVDrQCQC6206uzFuiE67EF2JTGz+PlXbQ6e+K6Jcrh4XlANAven3r3rKkRRcT/hQxqc6Eq7JrQOplky3yMog73MnLHCe8yaJUUZxn6XgTkX9iZwFBjm17hWAyXOJxfRY7c89idKP3kVnIAFj2SG9v2J4NUBMdR/wVLaXf513B07iPADvftJTUoxc8UJlQIbPyISH7oqssu4QNJ0cVUAK6M5SOOiVl6aEPXGFKWR4d/LKhgUGvc0mAp5C3BDdHN+TkQZd4FJ2Zi23ATMA04dmdBKxC60ZmLwl+8o+D3vWqG+jqSvq3BoEdAbu8f+JNM8coFLesjyNFtCNy3Aue35DHCSJBceMIpVpWIzewDgevt69in0uK9SnljozwHhs45ggTCkKsRBARIRau82b0tIGeoGKO90uZqpeBVN2jdfmdfTSivt5esfkap1j7GA9/lsDwOyL/D3fvCeYmTPyEz0bwAuE+zfddawewe+pzTf9wPSvtavomL29PG+9K2Ags1KS0lxiwRCT79BkKPDB+YX5BFqeCYUUUDMLknz85abL6/KeT5OdnEcmdYeoRNGzEku0/4Bc+02p9aDkcsfeWu+GIDgZxPXGLtrW201mEgZFqnxrfEybMKdXTLUEHMfnPvqBmMmG/RRSrdqJdsmDMsBxaB9dA8RKgdi1Y0UMK2vYs5lliiM
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(346002)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(36860700001)(82310400005)(478600001)(2906002)(110136005)(54906003)(316002)(70586007)(70206006)(4326008)(8676002)(6666004)(356005)(41300700001)(26005)(8936002)(6636002)(9686003)(5660300002)(81166007)(36756003)(82740400003)(83380400001)(55446002)(40460700003)(186003)(336012)(2876002)(86362001)(426003)(47076005)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 09:30:11.0746
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16c61920-2fbf-4089-1da7-08dab5a25924
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6197
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

Offloaded TC rules always match on recirc_id in the MAE, so we should
 check that the MAE reported support for this match before attempting
 to insert the rule.

Fixes: d902e1a737d4 ("sfc: bare bones TC offload on EF100")
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 6f472ea0638a..4ceb8c8f5548 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -250,6 +250,21 @@ static int efx_mae_match_check_cap_typ(u8 support, enum mask_type typ)
 	}
 }
 
+/* Validate field mask against hardware capabilities.  May return from caller */
+#define CHECK(_mcdi, _field)	do {					       \
+	enum mask_type typ = classify_mask((const u8 *)&mask->_field,	       \
+					   sizeof(mask->_field));	       \
+									       \
+	rc = efx_mae_match_check_cap_typ(supported_fields[MAE_FIELD_ ## _mcdi],\
+					 typ);				       \
+	if (rc) {							       \
+		NL_SET_ERR_MSG_FMT_MOD(extack,				       \
+				       "No support for %s mask in field %s",   \
+				       mask_type_name(typ), #_field);	       \
+		return rc;						       \
+	}								       \
+} while (0)
+
 int efx_mae_match_check_caps(struct efx_nic *efx,
 			     const struct efx_tc_match_fields *mask,
 			     struct netlink_ext_ack *extack)
@@ -269,6 +284,7 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
 				       mask_type_name(ingress_port_mask_type));
 		return rc;
 	}
+	CHECK(RECIRC_ID, recirc_id);
 	return 0;
 }
 
