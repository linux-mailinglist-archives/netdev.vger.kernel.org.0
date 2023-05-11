Return-Path: <netdev+bounces-1935-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28B126FFAD6
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 21:50:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9E41281963
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 19:50:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17A8C9472;
	Thu, 11 May 2023 19:49:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DB5944C
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 19:49:30 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2040.outbound.protection.outlook.com [40.107.212.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14C31FCC
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:48:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrdfPAjpGBd+2pBd3m54RkuGCmlstVIMg9jDXm2u3flXPCUUmL6h2wwGUTqxTNeY7bACcy1Ho+F3EVPG4JcyiVVJo+ZQBlc8P8XaagW4oCQGSaZZL3PgaGryBu4nPxzD90ldy5EScOLUKWFgfoWXTXQwd7PempHUzArMP8e2U3ehr7oANr/DjCV4JyDflY+SN+r+ryAMBRDYcW2LyMMSVPrGuwugwtT8Sbj7WxmCUzxJsstZ6RFMBI2UQVTb8CjTU+xaTdGnQPPSegIrWeFZzpVUZeUc5HD3nE2P7KJNtl3+eUfws07TphN8gnVW/0Qh4BfGMSsmuMH5chrPfijbtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BSzAdEK04vNt6ErVafwaqFfLWUi0s/vXFyT5m90KSuQ=;
 b=D2bmnXm4SaTFOMQPNIwDTI2EtUjC0Vbhalngy2uAtUwYQXKjT+1M7Zko1NXLgJAVbv1MUIB1JgoJPKPEC1yPWKkjET9lAsgVGYPcnvihyS9E9iJc7YjJjjKWtaRNl5zaqajk/grjytgcoS9qOYFe73yaUB65wlw6CfOaiL0csubjbXsEqesmnr+o1JgHVTZPxlkbY0p3yCkQTo0wNNWmjoZflhKNFf55ConDVfT5kMnaAJnjDVNYwm2VjUOb6LKKKRJALHe5aywQVKC4j3AuntBYpfpJe8rRLBrn2QeBqD4ey/sflIwZkJfQ11xVNy9WZCJoYEDAszK5vFQU4nLLXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BSzAdEK04vNt6ErVafwaqFfLWUi0s/vXFyT5m90KSuQ=;
 b=r9pToEfKnu0i0CSbNp7xH9bvFg+fTP1hgw1EjdG8ix+9muOMrfDPLJM8KTpkIpmSW/UT28iHoBwawcppKhjYiazAM0XeiFKCSzwkM7WARcdAmVNydEgGHlPWq33VIA9kouLkojHGlOnjP7verkvBS9NBhblAmjyDJIJmuiAiacI=
Received: from DS7PR05CA0075.namprd05.prod.outlook.com (2603:10b6:8:57::16) by
 PH7PR12MB5617.namprd12.prod.outlook.com (2603:10b6:510:133::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.19; Thu, 11 May 2023 19:48:14 +0000
Received: from DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::c3) by DS7PR05CA0075.outlook.office365.com
 (2603:10b6:8:57::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.7 via Frontend
 Transport; Thu, 11 May 2023 19:48:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT032.mail.protection.outlook.com (10.13.173.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6387.22 via Frontend Transport; Thu, 11 May 2023 19:48:13 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 11 May
 2023 14:48:12 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Thu, 11 May 2023 14:48:11 -0500
From: <edward.cree@amd.com>
To: <linux-net-drivers@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
	<habetsm.xilinx@gmail.com>
Subject: [PATCH v2 net-next 2/4] sfc: populate enc_ip_tos matches in MAE outer rules
Date: Thu, 11 May 2023 20:47:29 +0100
Message-ID: <b808fda84945d966a025424f75486ca3d5f2f587.1683834261.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1683834261.git.ecree.xilinx@gmail.com>
References: <cover.1683834261.git.ecree.xilinx@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT032:EE_|PH7PR12MB5617:EE_
X-MS-Office365-Filtering-Correlation-Id: e2b1a339-6860-4f2e-c1a3-08db5258a841
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	86FOPnOEKvIyWVL1jYSSi8I6hW3Dm3SwvyDhVwKiCq2h+nSpCzUf42LTOOlUh+aAs3N7Hoi8zBBpW5imzcY0Cy+nar2i6twsRICErBXFUHPpJjZmkPOAUFw3sHGzcrcYXSAKHi5Gl9ewyCibdSPbul9B29sXzYPhJAToqfrkMM16KYZ0QxeiSQngBC8hudHo7epdyTEpo8mIaigVJKobuUATGTGzVKRe8HysktJAZhjv7gMlZqpsUKU8s3AHF8v9BkcEhKLaAlCEacTv7i0fIOkahoOVu8SYzT2tru3IJ39xgWNFVksL+mLC4183o8bPfa+vw3moVUe8eHr1TyM/pdsez+3HNTsmOSECAwNV1JfQvxntUgRL1GpEjulp0XDVSYgKsf4h5fNXmjRecTkfn2Evc7V5HeWSH7vzVabxJ3nJygksiAfM20WN4NJjdaGxN/AxXAmKrlWt8eiR02GPT0Cma3e74DqD1OQ1owwiQuKUACn4PDPCRKBDrZByUvYK5jQMflfJu8iaOBUD/6YESwqx0l32bmBHe0tehPV6qUxxjs+GLa7Pc3RoFXIIAYZIfisCz8uo+62r/uIyCX2TrrQc11nTdq7FnThHFn28GJuNmaVu447WvGzbKw/KKnPAwYQfpGh2dYBlTxvzATnlSARWH0zgQtMe49AOS1GCI/YqUzWw4IItf6zUEN7kMkn/Uq/ei2dyFlb4kRrnjNS4GDqH/aZfZEQepJznOmSE0CJZXSlreKgGfIG9Irzht9Ra/xKhvH2+p+K9PJUF2VibSg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(346002)(376002)(396003)(451199021)(40470700004)(46966006)(36840700001)(47076005)(36860700001)(426003)(336012)(83380400001)(40460700003)(40480700001)(186003)(81166007)(41300700001)(70586007)(70206006)(8676002)(8936002)(5660300002)(356005)(82740400003)(2906002)(9686003)(316002)(4326008)(26005)(478600001)(86362001)(54906003)(110136005)(36756003)(2876002)(82310400005)(55446002)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 19:48:13.5757
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2b1a339-6860-4f2e-c1a3-08db5258a841
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5617
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Edward Cree <ecree.xilinx@gmail.com>

Currently tc.c will block them before they get here, but following
 patch will change that.
Use the extack message from efx_mae_check_encap_match_caps() instead
 of writing a new one, since there's now more being fed in than just
 an IP version.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
v2: fix transient build breakage by moving encap->ip_tos[_mask] addition
to this patch.
---
 drivers/net/ethernet/sfc/mae.c | 16 +++++++++++++++-
 drivers/net/ethernet/sfc/mae.h |  1 +
 drivers/net/ethernet/sfc/tc.c  |  9 +++------
 drivers/net/ethernet/sfc/tc.h  |  1 +
 4 files changed, 20 insertions(+), 7 deletions(-)

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
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 04cced6a2d39..8d2abca26c23 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -78,6 +78,7 @@ struct efx_tc_encap_match {
 	__be32 src_ip, dst_ip;
 	struct in6_addr src_ip6, dst_ip6;
 	__be16 udp_dport;
+	u8 ip_tos, ip_tos_mask;
 	struct rhash_head linkage;
 	enum efx_encap_type tun_type;
 	refcount_t ref;

