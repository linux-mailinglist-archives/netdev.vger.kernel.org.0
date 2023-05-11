Return-Path: <netdev+bounces-1934-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28B796FFAD5
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 21:49:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44F571C21097
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 19:49:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 921569470;
	Thu, 11 May 2023 19:49:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C74A929
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 19:49:18 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E625DD851
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:48:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JDDciaca8tjAs3FfSLbn1uZ41I/JGHuWaZHEHDKrJlvPEtk9fjIgdxk+1H90i/QkvdDXmnwGap4aqJ7OdsK0p37Kh3DvYWCukY/9jWaOP56SBJcEWfzzIuj2RkDW7t70gbaM5JxwCZLhzCmX+Tji03ZAQ3HBgklngsdrXptEbYMuqRpLctH8SDvSXJ1aWb/05a+wnyvfXieE0xryBjNnLeDrJxiH//snaa5Xx6+6DEI/VBQpeQXqUQSSTuL3M96xKVVm6Nq29uqfqwRzS1ALP/m2bZo7bU70cXsiWeNXgBFxdKoAYWSMoutYW8oKjfx97OEuO0RLIP+zOZOngX1xOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vRzTP3ByJtSmlb6PtsQvqx+9+CgbIJ3c4hw3GQCbPcs=;
 b=kj1FOBm6Sw9QuNtTHvpTDG0o3vEaswg7uHMgQZwkG3VCQQBUIFbE8V/0T7YsmSCE95AHp5r2TfE6fM75onkrydnBKaA4fPNDsgkaMuMUBJVKLbrJiYHXyCLWptSO0SZuk8BChcZ+AVobJG2lLeJIuuFC8Gs03joqzavBJHrFmycVcoHMH9Lf85r/yo4mB6lheTMZalXrno9lQBPCjP2k/v7fKu2m8Exqe5fZ7jyu1YXA3zRAFgupnXlbg9CTtduKWCxxJWnNUjPhp9QxZupK4wLvHJwS3bBrRdAVSpkNAN2SYrDojnh89vdYPCxUOrgmExE21QySuZrcAXCf+VBUig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vRzTP3ByJtSmlb6PtsQvqx+9+CgbIJ3c4hw3GQCbPcs=;
 b=aQqtutmWWO/RgBC3Vg7fefQVu/wgiA5Y97yPJiHy3UlJvfEOvV/4KJWM6L4IpVk/lMC8g55yUcokjiSHg59qBliFPfco0WlPjuS0pvC/Q1LEosN0BiuYS67pNhsCBWtb187Tyce5D7q04M3MCoWYMWB6uMvqrZBmHVWcDj93yJs=
Received: from DM5PR07CA0051.namprd07.prod.outlook.com (2603:10b6:4:ad::16) by
 BL1PR12MB5996.namprd12.prod.outlook.com (2603:10b6:208:39c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 19:48:12 +0000
Received: from DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::be) by DM5PR07CA0051.outlook.office365.com
 (2603:10b6:4:ad::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22 via Frontend
 Transport; Thu, 11 May 2023 19:48:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT045.mail.protection.outlook.com (10.13.173.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6387.20 via Frontend Transport; Thu, 11 May 2023 19:48:12 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 11 May
 2023 14:48:11 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Thu, 11 May 2023 14:48:10 -0500
From: <edward.cree@amd.com>
To: <linux-net-drivers@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
	<habetsm.xilinx@gmail.com>
Subject: [PATCH v2 net-next 1/4] sfc: release encap match in efx_tc_flow_free()
Date: Thu, 11 May 2023 20:47:28 +0100
Message-ID: <b743482384e7f6f29e54255f31a910ce72fce8d2.1683834261.git.ecree.xilinx@gmail.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT045:EE_|BL1PR12MB5996:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c3822c1-a563-41ce-e3e4-08db5258a789
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2UXHeIVb3M7gcOYU6ml1XD+4lgLZDnIH6+6P05cJ98008YLhxwckjbxGX5gvLTFRwPlB4q6bttwdC3A+mIOFRbxhQHRuhf6QDUOxc+fhc8T8gH0lQiyc4XvqmEFVx0YjbcV7HbmD/a9KODUXLTdxqTiKgR45rY4OWjt+cTHDqNwSp9FeX8ZrO+oFAieEom0/sH7UhTPFebBHTbtjrVTR3DSjQvb47C0zq+/kmh0e4Y5GQBctsVdxZW7HN0EqGru719i1r74SlAcbF2VE+cz52QZiZOp/hLuKOSRKMPYlPba0BYwT6YLRAzMUYFnWlgcobUfo3r6X3wOc3dZXSXAPsX77jJVjSwrBbvheRoEWLRgq/gwYxF/Z3fQdnX4Imv2p03C/BFQwNpfOSPZGLIL/ugLhTUQEN3IckrFnNLs6Zi63hWFlGabWAhZGpYUcgfGzsdnbxS3gdTga9py0VunniQMri+M+dEEMtQQIJDGdlHjfRZ0cmOW1bx5lVHbnpK/+TfvzGhsWdMzU42DGf4toOcwsE1M7Bp9wQ1Q5x4jvwJlKx364eJKdBdlTGsCquXPXS0fx6mJlPNUv+iiPXJdFg0aAzVeA+um8oJglRQ3c5U7pE7+O2+mSt8aN/dl8J3frh8K1YTpTsF0bzB3IT4ccJedh4R+FgfzBGlvG9MkU3d2oJUptYuBioGpdS3o1oKs53zrRo3QGlF28i/n+X9WwVqaSRDJEQZdD6TKtEbzD1NE=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(39860400002)(136003)(451199021)(36840700001)(46966006)(40470700004)(478600001)(47076005)(83380400001)(336012)(9686003)(426003)(36860700001)(86362001)(55446002)(40480700001)(26005)(316002)(81166007)(54906003)(4326008)(110136005)(356005)(70586007)(82740400003)(70206006)(186003)(6666004)(8676002)(41300700001)(8936002)(5660300002)(2876002)(40460700003)(2906002)(82310400005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 19:48:12.3707
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c3822c1-a563-41ce-e3e4-08db5258a789
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5996
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Edward Cree <ecree.xilinx@gmail.com>

When force-freeing leftover entries from our match_action_ht, call
 efx_tc_delete_rule(), which releases all the rule's resources, rather
 than open-coding it.  The open-coded version was missing a call to
 release the rule's encap match (if any).
It probably doesn't matter as everything's being torn down anyway, but
 it's cleaner this way and prevents further error messages potentially
 being logged by efx_tc_encap_match_free() later on.
Move efx_tc_flow_free() further down the file to avoid introducing a
 forward declaration of efx_tc_delete_rule().

Fixes: 17654d84b47c ("sfc: add offloading of 'foreign' TC (decap) rules")
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/tc.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 0327639a628a..236b44a4215e 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -132,23 +132,6 @@ static void efx_tc_free_action_set_list(struct efx_nic *efx,
 	/* Don't kfree, as acts is embedded inside a struct efx_tc_flow_rule */
 }
 
-static void efx_tc_flow_free(void *ptr, void *arg)
-{
-	struct efx_tc_flow_rule *rule = ptr;
-	struct efx_nic *efx = arg;
-
-	netif_err(efx, drv, efx->net_dev,
-		  "tc rule %lx still present at teardown, removing\n",
-		  rule->cookie);
-
-	efx_mae_delete_rule(efx, rule->fw_id);
-
-	/* Release entries in subsidiary tables */
-	efx_tc_free_action_set_list(efx, &rule->acts, true);
-
-	kfree(rule);
-}
-
 /* Boilerplate for the simple 'copy a field' cases */
 #define _MAP_KEY_AND_MASK(_name, _type, _tcget, _tcfield, _field)	\
 if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_##_name)) {		\
@@ -1454,6 +1437,21 @@ static void efx_tc_encap_match_free(void *ptr, void *__unused)
 	kfree(encap);
 }
 
+static void efx_tc_flow_free(void *ptr, void *arg)
+{
+	struct efx_tc_flow_rule *rule = ptr;
+	struct efx_nic *efx = arg;
+
+	netif_err(efx, drv, efx->net_dev,
+		  "tc rule %lx still present at teardown, removing\n",
+		  rule->cookie);
+
+	/* Also releases entries in subsidiary tables */
+	efx_tc_delete_rule(efx, rule);
+
+	kfree(rule);
+}
+
 int efx_init_struct_tc(struct efx_nic *efx)
 {
 	int rc;

