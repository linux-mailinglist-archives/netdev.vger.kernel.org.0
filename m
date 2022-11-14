Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A537462810F
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237479AbiKNNRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:17:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237979AbiKNNQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:16:56 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C8C2B61B
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:16:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FoA8BnOL5Rt3HcZhCfxEqO5MgG+AnfWj+6ln8sNjsm4JEW4WHW7s7oNbrj9naTF9Q5IuBBwL4C4ZTb/tl9KDjH97jlazHGb03fa9qneiQSCCKv7BW639WGhXRpLrRPBcczQhAN7/2K3rdZsZutI/eSMd/Rb/GJ3q7G032sGKNMEsJjq3TKeN6pPOz/DFg0f3L6tBXKTNEXkBXSHaFJh16rsi4IXyeCmvSdTPNMwYR4Zplhj5whkNmBG7OWuqJ2w9x9kZX5dlxyvMF14RQl8IhsmfjGjNjIhFxGOG+2VsaC8fokmC3+QZDrdQL0HZs+2YrL9eSFnNbrhoYsjDlJTHNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JBqXvh/xxIlCyP1O7HuwysdOrMlm+f0BQPFvmuFBnrA=;
 b=WT5R24sgiA7oUm86dXzlKwYGyfmRbWVT6wv/gH9ojFgjZKI7VGtCqGoCNVNd90pHOyAKQja0+djov3X+x9SsQXM8aUrs5XdM7AC2H+0IbfkUwZ020mdxb8U4IAPsUsY21pRs9rpjS1r/xI6w50ljthyGLwoN/lQ8MMvWeYO/TKHAhUyNz/DQnaO5OxzikkIKEN1t9ks9afRh6NgHUf9b5iLmO3LC/5bHTF8AVbf2lZM+8xOOXyiTWq0b8IFkKnpM0kBUOIB/rWze7AvOuV6speAm2nZgdP9sy18OYJyxulY3ZmVoRbSLNDwR3py/kIpq6tmSgX1JMCl04j9liTz7fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JBqXvh/xxIlCyP1O7HuwysdOrMlm+f0BQPFvmuFBnrA=;
 b=iMaVCWF8rD5TXjSv3OTzOdb4IWhUzKWT+ff2/6iDYWN67+kVaIDyD8tMPK9c6/xmdWble+kLYcgSS95V0vGGugpSgOwUxLT2TdriZzcr7CjFU4b7VcmoLG+73bEJpHWGwy+loQIZQg+Wd4w8immZ2cxqjPamAf8u6ryX9UEhPHE=
Received: from DS7PR06CA0003.namprd06.prod.outlook.com (2603:10b6:8:2a::27) by
 MW4PR12MB5641.namprd12.prod.outlook.com (2603:10b6:303:186::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.17; Mon, 14 Nov 2022 13:16:31 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::b2) by DS7PR06CA0003.outlook.office365.com
 (2603:10b6:8:2a::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17 via Frontend
 Transport; Mon, 14 Nov 2022 13:16:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.12 via Frontend Transport; Mon, 14 Nov 2022 13:16:31 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 14 Nov
 2022 07:16:30 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 14 Nov
 2022 05:16:30 -0800
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 14 Nov 2022 07:16:29 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 11/12] sfc: validate MAE action order
Date:   Mon, 14 Nov 2022 13:16:00 +0000
Message-ID: <802ad2b9574492af9d0eef230d7e4aea57b84efd.1668430870.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1668430870.git.ecree.xilinx@gmail.com>
References: <cover.1668430870.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT040:EE_|MW4PR12MB5641:EE_
X-MS-Office365-Filtering-Correlation-Id: 1103f614-740c-4936-be59-08dac642726a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eMXLN6561Rtw3dD+SKaP0LM+WXW/uypfUD1bxe6ud2HMROAZv/b+ml6TH1OUwLeHr1D+U60Q2ZUZCLdPu9Eg+/JZlTExNCN0XM2q8vj+PygeSvHLinAspvMEndvYZKG1eWrzYyHu6EpW8yzDGsNxgDHgtV29syR/refZ+WPWlLV8i1Mw4lu+QA0nAjKNLvQOFFi8/FmxxciQvmvVwwQhTLtU0cjhi8HMEhoQnI47YGnRd2+swu7sy/1i+eId0jU6MK07nAOV/xPqswy28rtRGNbA+/k/AZvnlm78dkOk34aMeaNwDdQduq2tpphlTDtqmEnoFyRTzg0xUU4Q+5PgVnvb86qgq0uY9Eg5EvSaezWPdC9VMqxWBgCmm5AvjikPuTG6G9q44ssCmmN71+ZhmAOykk7TbptHRhDlFcD6RSpVZoLSpfVZ9QbbWtvQCUytmnAuXvKcAORbKQbva5C5xk9k0+SNneKcXxFQYOlaz9kBQSIiKzWEQSBrrHtwAHv7fHf2kaqvARs7cKdoTK8Kk1rR+rjncu4zqD0o/1EuQynFYDzaXK2s2sX78jbckIaLt3ym0gkjhERUgAeIlyjyvGzHjek4kwgQR1LPc9M3g4WQ/6XMlXO6dobmzkaF+75wIGGtro9+O+iuqbWzg98IPBdISflxPY7F/XzxQ6QjmB+ukfGXue8Z69VRctscn1edZnCjXJcRKNzlYxUjdDc5CydPFqO5LlYcVS4jfEJLkkyiGXWl8WKMrm9PD7iie+Dl3nANGSjgRHjElzzgVI5Pr4FMesfRZ+sZnV4QBtDLZBYZoJ0ZcXsFgbY0x8O14tQV
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(136003)(376002)(451199015)(46966006)(40470700004)(36840700001)(40480700001)(8936002)(36756003)(55446002)(86362001)(81166007)(82740400003)(40460700003)(356005)(36860700001)(2906002)(2876002)(47076005)(83380400001)(426003)(82310400005)(5660300002)(41300700001)(9686003)(6636002)(186003)(336012)(6666004)(26005)(8676002)(4326008)(478600001)(70586007)(316002)(54906003)(70206006)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 13:16:31.4992
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1103f614-740c-4936-be59-08dac642726a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5641
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

Currently the only actions supported are COUNT and DELIVER, which can only
 happen in the right order; but when more actions are added, it will be
 necessary to check that they are only used in the same order in which the
 hardware performs them (since the hardware API takes an action *set* in
 which the order is implicit).  For instance, a VLAN pop must not follow a
 VLAN push.  Most practical use-cases should be unaffected by these
 restrictions.
Add a function efx_tc_flower_action_order_ok() that checks whether it is
 appropriate to add a specified action to the existing action-set.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/tc.c | 50 +++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 1cfc50f2398e..bf4979007f31 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -284,6 +284,29 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 	return 0;
 }
 
+/* For details of action order constraints refer to SF-123102-TC-1§12.6.1 */
+enum efx_tc_action_order {
+	EFX_TC_AO_COUNT,
+	EFX_TC_AO_DELIVER
+};
+/* Determine whether we can add @new action without violating order */
+static bool efx_tc_flower_action_order_ok(const struct efx_tc_action_set *act,
+					  enum efx_tc_action_order new)
+{
+	switch (new) {
+	case EFX_TC_AO_COUNT:
+		if (act->count)
+			return false;
+		fallthrough;
+	case EFX_TC_AO_DELIVER:
+		return !act->deliver;
+	default:
+		/* Bad caller.  Whatever they wanted to do, say they can't. */
+		WARN_ON_ONCE(1);
+		return false;
+	}
+}
+
 static int efx_tc_flower_replace(struct efx_nic *efx,
 				 struct net_device *net_dev,
 				 struct flow_cls_offload *tc,
@@ -383,6 +406,25 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 		     fa->id == FLOW_ACTION_DROP) && fa->hw_stats) {
 			struct efx_tc_counter_index *ctr;
 
+			/* Currently the only actions that want stats are
+			 * mirred and gact (ok, shot, trap, goto-chain), which
+			 * means we want stats just before delivery.  Also,
+			 * note that tunnel_key set shouldn't change the length
+			 * — it's only the subsequent mirred that does that,
+			 * and the stats are taken _before_ the mirred action
+			 * happens.
+			 */
+			if (!efx_tc_flower_action_order_ok(act, EFX_TC_AO_COUNT)) {
+				/* All supported actions that count either steal
+				 * (gact shot, mirred redirect) or clone act
+				 * (mirred mirror), so we should never get two
+				 * count actions on one action_set.
+				 */
+				NL_SET_ERR_MSG_MOD(extack, "Count-action conflict (can't happen)");
+				rc = -EOPNOTSUPP;
+				goto release;
+			}
+
 			if (!(fa->hw_stats & FLOW_ACTION_HW_STATS_DELAYED)) {
 				NL_SET_ERR_MSG_FMT_MOD(extack, "hw_stats_type %u not supported (only 'delayed')",
 						       fa->hw_stats);
@@ -413,6 +455,14 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 		case FLOW_ACTION_REDIRECT:
 		case FLOW_ACTION_MIRRED:
 			save = *act;
+
+			if (!efx_tc_flower_action_order_ok(act, EFX_TC_AO_DELIVER)) {
+				/* can't happen */
+				rc = -EOPNOTSUPP;
+				NL_SET_ERR_MSG_MOD(extack, "Deliver action violates action order (can't happen)");
+				goto release;
+			}
+
 			to_efv = efx_tc_flower_lookup_efv(efx, fa->dev);
 			if (IS_ERR(to_efv)) {
 				NL_SET_ERR_MSG_MOD(extack, "Mirred egress device not on switch");
