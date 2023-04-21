Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6C36EACB5
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbjDUOVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbjDUOVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:21:09 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CF2125B0
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:20:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z+3T2cLugpXCcVh8xRNoY+m6DqmAbpm+W6Bry1XqIWMS0T3vJGuiNsjC4psSqYwyR7SyNMffCYYeVIjTkO+UDljKq/kXjiePS1rWocOJWe81gYoc4gUtbK6bZTilUxP8m1s7CtXAQmQSlZQ4Vaom81jfWsNxpzgvPYV3lSON4A6821h6KpdCPSgQ2wqQlCVCCWP9r2GosRXrg+sprrhx8Ytg5NogotZmmbDOW6RiNyWAy7LM25qOuj/RMCvPFmKKNLaHAyHzNiBf6jBYJEDNAzBrEI6Kjflu6NHQIsbEwaZtW0LgS8TwERX+ilontrukbO+yYHQtjABKGRlshNJV2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LpgMbO/iAO7Qqe3rrVNOioel0PNCkHp6Ee4yZw4sDhI=;
 b=jdm4YgIHjXtsrtpXZKknN/T+BTvS+M6ktb8pSfi7Rnm36Goeo5qwdUriYlmQxV31UBCuILzx82jN2SCxQP50xoAW3QOrZtiVRzlSKRs6tENn0diCUAmERjiONPMPCAlpZcjhsl8/zk3s/tBr9d9LZu+zr/Q3KMQG6KC1wy059LrgwP4BBuKtyuXspJdyg/YKesC6Az9EyDfLCVkKafxWOeECbIvlfKO7jgxSL0SdlAI+bllJOjmVWcixi5V0Bpb/cC2hcqW8AfWeZuTdx33ZrP4PaXa6O+uBDYktplhx5UPYcII01E5LHOBX5EB1eBtlQaurC9nPgJYYKv4mxy9oDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpgMbO/iAO7Qqe3rrVNOioel0PNCkHp6Ee4yZw4sDhI=;
 b=SF9jzu2U36LYi9V4r2X0WRZ8LYvaHMySbFfBAreiofk90wHhC3dr0wmFzgihlC941gHm+kEqodU8CHvWw1vxOPIXk5G37cxa13Ffw7X8ZaHfe2EGaT7VZDamBu72qZ91p2b+b9+lf2Eq367T90ITyGYIu9XsLzpYOzWGJUD3dCI=
Received: from BN8PR04CA0066.namprd04.prod.outlook.com (2603:10b6:408:d4::40)
 by CH2PR12MB4972.namprd12.prod.outlook.com (2603:10b6:610:69::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 14:20:53 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::27) by BN8PR04CA0066.outlook.office365.com
 (2603:10b6:408:d4::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.26 via Frontend
 Transport; Fri, 21 Apr 2023 14:20:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.27 via Frontend Transport; Fri, 21 Apr 2023 14:20:53 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 21 Apr
 2023 09:20:50 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 21 Apr
 2023 09:20:50 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Fri, 21 Apr 2023 09:20:49 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>,
        Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: [PATCH net-next 2/4] sfc: populate enc_ip_tos matches in MAE outer rules
Date:   Fri, 21 Apr 2023 15:19:52 +0100
Message-ID: <d1fd9a055378a5e0f969d0ecb69ca2a4cd8257bb.1682086533.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1682086533.git.ecree.xilinx@gmail.com>
References: <cover.1682086533.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT036:EE_|CH2PR12MB4972:EE_
X-MS-Office365-Filtering-Correlation-Id: 864e75b0-e751-4dba-92ad-08db42739db5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jFGounRZ5RN9+jRqxMZKZiu0CuHOKLTWdr3LZYzsFfuoW8XcYKWe7xNMf3ke05Z37dSFSvzpPhPAwRz/zXkdYsJ4z5ufGmKDnla4XW+2dr1ldSzXGjFbHXfc9kxzE30a7+hhIjgCPboDe84SiimiOlaC1GpNLITL1xpM0LSMz4nqmAfBi4oP1tf7TY+MbPmp3euj2HnCjivWuF+WCF/Jik6bfaZMAqwndvActLMG6XvzuycJczIC5uNr2e3zs1npp6C+n66fp+NE3JB5J5OGmrkjRRWuiG0/xBzonDqPa1jmFI7jSz0QvnNOXthkt+GXjd0hFJ7YcFsvEQ9cJiROQq/JcUJYwpRtEB5rNwpUP9j3V8C1iO8y7scd1W3ikFvj7d0Bsf5ZakV3aIMuAkwtCmpyjzYMEAgzD2GD3j8YCUBMZPcLKz95Tz218DudtxI1oWbOIfvG4Z5gX44ZUrBqmxOGbDGMWbV82uFcmxAMi72u55xVkBuKqJuL9SVkr6bJDe1zFB1ID4Hgi9xv1FqTK+se+hI+DmWZvMhKIAYrIiNH/+/noS9Ww0rInDmHuQcnKUDetsHgbpmbReiy8M7nKSlrUdG2V7yylMo6gx55+HPak4GVKzxtUzVn4A6PpFSdyVDGVzHjrwHlUuDePwxA1ajDnJ04bz5X30kEwIaESZCCDFDibFKh61ufDAx5MLVCe2FQLoqmp1n2c5LkW6fYXRngv5Gmny95rb4BrN5t99k=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(426003)(336012)(36860700001)(83380400001)(47076005)(36756003)(186003)(82310400005)(478600001)(6666004)(54906003)(110136005)(70586007)(70206006)(5660300002)(8936002)(8676002)(4326008)(356005)(41300700001)(81166007)(82740400003)(316002)(40460700003)(40480700001)(2876002)(9686003)(2906002)(26005)(86362001)(55446002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 14:20:53.7183
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 864e75b0-e751-4dba-92ad-08db42739db5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4972
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Currently tc.c will block them before they get here, but following
 patch will change that.
Use the extack message from efx_mae_check_encap_match_caps() instead
 of writing a new one, since there's now more being fed in than just
 an IP version.

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c | 16 +++++++++++++++-
 drivers/net/ethernet/sfc/mae.h |  1 +
 drivers/net/ethernet/sfc/tc.c  |  9 +++------
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 49706a7b94bf..8f4bb5d36ad8 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -482,12 +482,14 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
 	rc;								       \
 })
 /* Checks that the fields needed for encap-rule matches are supported by the
- * MAE.  All the fields are exact-match.
+ * MAE.  All the fields are exact-match, except possibly ENC_IP_TOS.
  */
 int efx_mae_check_encap_match_caps(struct efx_nic *efx, bool ipv6,
+				   u8 ip_tos_mask,
 				   struct netlink_ext_ack *extack)
 {
 	u8 *supported_fields = efx->tc->caps->outer_rule_fields;
+	enum mask_type typ;
 	int rc;
 
 	if (CHECK(ENC_ETHER_TYPE))
@@ -504,6 +506,14 @@ int efx_mae_check_encap_match_caps(struct efx_nic *efx, bool ipv6,
 	if (CHECK(ENC_L4_DPORT) ||
 	    CHECK(ENC_IP_PROTO))
 		return rc;
+	typ = classify_mask(&ip_tos_mask, sizeof(ip_tos_mask));
+	rc = efx_mae_match_check_cap_typ(supported_fields[MAE_FIELD_ENC_IP_TOS],
+					 typ);
+	if (rc) {
+		NL_SET_ERR_MSG_FMT_MOD(extack, "No support for %s mask in field %s",
+				       mask_type_name(typ), "enc_ip_tos");
+		return rc;
+	}
 	return 0;
 }
 #undef CHECK
@@ -1003,6 +1013,10 @@ int efx_mae_register_encap_match(struct efx_nic *efx,
 				~(__be16)0);
 	MCDI_STRUCT_SET_BYTE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_IP_PROTO, IPPROTO_UDP);
 	MCDI_STRUCT_SET_BYTE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_IP_PROTO_MASK, ~0);
+	MCDI_STRUCT_SET_BYTE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_IP_TOS,
+			     encap->ip_tos);
+	MCDI_STRUCT_SET_BYTE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_IP_TOS_MASK,
+			     encap->ip_tos_mask);
 	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_OUTER_RULE_INSERT, inbuf,
 			  sizeof(inbuf), outbuf, sizeof(outbuf), &outlen);
 	if (rc)
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index 9226219491a0..cec61bfde4d4 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -82,6 +82,7 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
 			     const struct efx_tc_match_fields *mask,
 			     struct netlink_ext_ack *extack);
 int efx_mae_check_encap_match_caps(struct efx_nic *efx, bool ipv6,
+				   u8 ip_tos_mask,
 				   struct netlink_ext_ack *extack);
 int efx_mae_check_encap_type_supported(struct efx_nic *efx,
 				       enum efx_encap_type typ);
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 236b44a4215e..c2dda3ae5492 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -410,12 +410,9 @@ static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
 		return -EOPNOTSUPP;
 	}
 
-	rc = efx_mae_check_encap_match_caps(efx, ipv6, extack);
-	if (rc) {
-		NL_SET_ERR_MSG_FMT_MOD(extack, "MAE hw reports no support for IPv%d encap matches",
-				       ipv6 ? 6 : 4);
-		return -EOPNOTSUPP;
-	}
+	rc = efx_mae_check_encap_match_caps(efx, ipv6, match->mask.enc_ip_tos, extack);
+	if (rc)
+		return rc;
 
 	encap = kzalloc(sizeof(*encap), GFP_USER);
 	if (!encap)
