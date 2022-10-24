Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CA3609E0B
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 11:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiJXJas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 05:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiJXJac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 05:30:32 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732BC49B5E
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 02:30:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OBlY6meJl8vE4BsAz+12AQUUhGfzpsnXU4B1r0tYE/3bT94ljDUYIsxpbJm1FLtfJumn9nv96mks+1EFk98ahXzeeHIChO4eD2BPGVe6F3Sana3yL4oyHK2Znyp3ZtyI/xd/di+DJS2DHjw37vLZdVkYn9yKd4J2+q8ONPG3RgjH8Dmn8KcKZyZW1V5O7r1PLb5yx2iUeWv+Wf7IVrj+/a3ownnmWGzrnVvjrmarszAMQYCvLVkK/0BdXKSriGqFNmZbbIsvV3GRPef75m+MB30ZjkW8yfHGo7WyqXVysczsPTP7LeQghkS6nTstspmkXixequmeRaXEuH4HtOuq1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fa86n8gaD59PsofhNsSbHk6vtq1e+crTjpk660LiLOM=;
 b=T8JfgJ58JJ8O+Okk2eALN+R6mrmgzOztUnWEyte9QPfb9VQNP/DlzO3JybbJmXhNeWFC16vL1Dfet4JENeuOgDgAOCbnHRCYrswVTupt93druKeX6zEzfHiOz3osZ6plb9BUsZxkSaDG81ry3E3jf3RbrYCAx+gy5excpGbeqXpvK99dHos4KEre1rJ/ImdvoeDH8k8bx3t4KjgirZuaUihWazbZg2P/0E8NSdVW7KWbjflGeDEPIqlXy4+tet5vsurLmIc0v8+FbOCNuZTxIF/pLviv/4/ngnDQsnQm9nlCh92BRyg9WhWuXA2KJaoVkiMcpKkGyL8ChdWjD+TmKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fa86n8gaD59PsofhNsSbHk6vtq1e+crTjpk660LiLOM=;
 b=XH9CBpSYYUwTk2l/w83yt0fpU0IFCLGw9V7LZNZY9d1FMKr8XNQ8ls+pjd2wAJh5F4iK3kWiuj5nWe9EO6cNicB6N0RoX/1Bz/oxE6i/ZDtn3eFUgUliVSlhwy8VsFQ9K8oQpLO75KKWG+qpzZxHIt26cs9lvTZPbIWkE4kmpv8=
Received: from BN0PR04CA0180.namprd04.prod.outlook.com (2603:10b6:408:eb::35)
 by MN0PR12MB6003.namprd12.prod.outlook.com (2603:10b6:208:37f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Mon, 24 Oct
 2022 09:30:29 +0000
Received: from BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::37) by BN0PR04CA0180.outlook.office365.com
 (2603:10b6:408:eb::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28 via Frontend
 Transport; Mon, 24 Oct 2022 09:30:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT068.mail.protection.outlook.com (10.13.177.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Mon, 24 Oct 2022 09:30:29 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 24 Oct
 2022 04:30:28 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Mon, 24 Oct 2022 04:30:27 -0500
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 4/5] sfc: add Layer 3 flag matches to ef100 TC offload
Date:   Mon, 24 Oct 2022 10:29:24 +0100
Message-ID: <468d6bc820d682f91ea9215953df90f87b01b881.1666603600.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1666603600.git.ecree.xilinx@gmail.com>
References: <cover.1666603600.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT068:EE_|MN0PR12MB6003:EE_
X-MS-Office365-Filtering-Correlation-Id: 08b325db-d696-4c81-8cbd-08dab5a26407
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rh8BYm0YTD77Vk7f8Vzd0A/xs/mDNSqkeZMl6+reOGbEDlVpeRMN5DVDl0ga+buqRtgB37H1Pj9iskAEVTwzmWM1itOTFhr5IZz2msnJomT/v5wj3PVzlEPU/T0d6EqBnkKN1b17dKbHQsBK49DGsp8NUvLXsxtOC8JwxYSQB7A8OWoedP//HCzvZJYUHA3h9jnworpWcqo8soTv/MtJF2PGe0C4n0D2rMz0gnEqRrYG4FFgmLDzvqtWJna4fk8mNjl/RCUOgiqkCzJAdTaYQC7YiERuat1MBTeG+u7wEhe2a8kg/trYqojrnJTKLMQrkaqwZfZuNJ/RhiHBPjxwGn1qAaS0tkY8m+37j+X9LfGdDwr8u7ZyfdDp/jy19rIHIEzBaGxHrCRaIi7gHMRvwqnqmIqjBe/dVbYrdHvKhmwn/QV3uqhDhtJc8OY/hUZ++MOH1w91Pz4CzbXsn/AD0uW6E/3P5tqeOGUnXz2RkkegM5V3RrqF/UB3s2oDBbngL+win64xceFr7nBzElUvvlUTQDEcKQid//ALSLzHW6XZD2h3wQUqWoH13TWY49dYBw5CVO5Dkf6TGQx1AHQDn6TEWv7VNOqhVxRhEx4MrutZyuh1+kHrMq8VOWT0rlXJfipbLK1t7wraT2UOqpBblSzdg4tqdZUbjNgLExXEbxA/y8YeXYbgMMotT1ByklDnXIrSfT1opz1MnwSeXu5z/gWqXIrN3MbDMt4K4gvZ53t6N6lpHYRNU7jas0qFEtKfQ85bN5/AZhbWA5G+yUmyUj91/DfLR1mr+EZrshKFuNavB7R2eZP27taBRJDNhdGL
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(70206006)(70586007)(9686003)(4326008)(6666004)(47076005)(86362001)(82740400003)(36756003)(186003)(5660300002)(2876002)(2906002)(8936002)(41300700001)(82310400005)(8676002)(356005)(40480700001)(26005)(336012)(426003)(36860700001)(40460700003)(81166007)(55446002)(6636002)(110136005)(54906003)(83380400001)(316002)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 09:30:29.3423
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08b325db-d696-4c81-8cbd-08dab5a26407
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6003
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
 drivers/net/ethernet/sfc/mae.c | 26 ++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/tc.c  | 10 +++++++++-
 drivers/net/ethernet/sfc/tc.h  |  1 +
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 74de6a907a80..76b75b3975d5 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -264,6 +264,19 @@ static int efx_mae_match_check_cap_typ(u8 support, enum mask_type typ)
 		return rc;						       \
 	}								       \
 } while (0)
+/* Booleans need special handling */
+#define CHECK_BIT(_mcdi, _field)	do {				       \
+	enum mask_type typ = mask->_field ? MASK_ONES : MASK_ZEROES;	       \
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
 
 int efx_mae_match_check_caps(struct efx_nic *efx,
 			     const struct efx_tc_match_fields *mask,
@@ -300,9 +313,12 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
 	CHECK(SRC_IP6, src_ip6);
 	CHECK(DST_IP6, dst_ip6);
 #endif
+	CHECK_BIT(IS_IP_FRAG, ip_frag);
+	CHECK_BIT(IP_FIRST_FRAG, ip_firstfrag);
 	CHECK(RECIRC_ID, recirc_id);
 	return 0;
 }
+#undef CHECK_BIT
 #undef CHECK
 
 static bool efx_mae_asl_id(u32 id)
@@ -472,6 +488,16 @@ static int efx_mae_populate_match_criteria(MCDI_DECLARE_STRUCT_PTR(match_crit),
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
