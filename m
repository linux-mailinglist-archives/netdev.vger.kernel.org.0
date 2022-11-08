Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBF8621A82
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbiKHR0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234089AbiKHR0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:26:31 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2061.outbound.protection.outlook.com [40.107.95.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEC44FFB7
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 09:26:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ARLIQVh8PZNz73pUma9tRegwVb5l0/fUg9SMB8iDRwo3UC8Y/59cp/vwnbX0HPKrx7tb2LGDRSm/Mkh3z1x4n95VC/Oz7cf0OwJxV2MjwW0NP/Qgk6Ivhp4vinCEEoUmAy7/AnMkYgnVwRuypuJHWwAfHOS9LsFXTretzLo7gZFNToy/qI5h0HCmJSJxa2pku4a0ZNZBZs6D07iFnvnGgCykkeWLdvZaEnIL1lYdFZl4qHkkX/TkkEQeiN/x2cKuErXvy3mx3aWcIllQYaFe3C+VVm8As2qk7fDWeoVEog1NbfS1scW0c+JlwDnUPkDczhg7xecS98FYT5muThu0Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JBqXvh/xxIlCyP1O7HuwysdOrMlm+f0BQPFvmuFBnrA=;
 b=IfOgiU5dBeiCLseyit277BHqNX2rs9rOwNRoBlCdJ+HrOd381KwRT7FuUpH0Bt7E2hdCC8s0hPKRSIHV9Phd105qM223O7iuhBRUbBDPjrGipcIMdzJ367ceY4XdjDUuEoCs8mJ44EJPEgzPpbTTHMiNjX8VWxVpZ6FW1fdSswLUU4x3KvAMqJDOBDmnoAvHEcyZNJZLiiHnpCud6sb47bfCjthUliD9ycaMfFDGkgmhJhvmmaPCX0nLeMi76zBqBwy+0aQLCYkm32qBDwaO6CfKjyB8O20HMNU3D6GgBSmuguBR5pVy+DwHCu5efNWiy4r0Axp3oJjcmgpYsWZxrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JBqXvh/xxIlCyP1O7HuwysdOrMlm+f0BQPFvmuFBnrA=;
 b=FMOW0hYupoo/aZhick+DKUbIhnZpiOErWh9flNhy6mXqmOqJ4+heXUo3jF2YE/Vt3PcCWj0/b2gu9a3ybndKgA1i3w39K/9ssiQ70EO/pyAeJObt9EEVbgUnc0vEpWm7s53Ygu5xd7umEGZERq7yYwqulMzgxY3g9m9WQfkbQ8k=
Received: from MW4PR03CA0056.namprd03.prod.outlook.com (2603:10b6:303:8e::31)
 by SJ1PR12MB6074.namprd12.prod.outlook.com (2603:10b6:a03:45f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Tue, 8 Nov
 2022 17:26:26 +0000
Received: from CO1NAM11FT088.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::3e) by MW4PR03CA0056.outlook.office365.com
 (2603:10b6:303:8e::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25 via Frontend
 Transport; Tue, 8 Nov 2022 17:26:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT088.mail.protection.outlook.com (10.13.175.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Tue, 8 Nov 2022 17:26:26 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 11:26:25 -0600
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Tue, 8 Nov 2022 11:26:24 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 10/11] sfc: validate MAE action order
Date:   Tue, 8 Nov 2022 17:24:51 +0000
Message-ID: <586b672920631f86885620a624de7de0a3b21419.1667923490.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1667923490.git.ecree.xilinx@gmail.com>
References: <cover.1667923490.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT088:EE_|SJ1PR12MB6074:EE_
X-MS-Office365-Filtering-Correlation-Id: 862d317a-ab2d-4daa-715c-08dac1ae5d96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J2CWwCOKhl1omzQFezVhn+2LHkPbe0AkfpGyQq0/K+2ifSNyuyDsMnTzPJRVJN0roqPEFhlijqCa3y7vW3xQ3ZwLQV3sJnYcLrOmjBPiht6v15nBF2CCKWteKitGSn+hLPY3VggIVOeapBJVMRjHLKA1HIw2I11Hljnjs1tt9BvdTZbdXY1+a1Vv3OH9wIQFxD1ZxRmV/x9D2PHYzOw+2LLOvLsmMVkVI8WonaEQUR1gn9G48dC/HVI6TPSlMqMtDKZ5acMMkPGATp7JbqPv56YuolRk6f4fNmZ/r/dSSX/ajQzuyVf0P9NSxh6xNwpDORQh1wfWgtsH3vy4p3NM4PAuIhjIOuTt45TftP9ocYyJroMi4xOMDoxvmIeXv9dS3jk0EbStdvnjOSdfidTIqD1Ct8PLkir5Bmg1zbbWZqgUv4M1MEl6HdWRHfFmpn/tH5aGuen+V66k6GlOEKQ4AIFsMwU77UEjz+Qze5rITr6vro/jZnELaayJ4v2VsznJnGl6PKRaSUUVZHF1NEdwFsD+phJ+Otwi77ZbZ6nexM8206IDSi9uTVpG+b4MnjdTAxp+O6oCsk6TsTZfsMJ6eUTS2QIgkEsE0eJl3rrXiV81Z9i105Sm7Nebw1BPCEyD39yyk/wCOMgqFoOP0Q+YtgvnASB2E38WiBL7ffKsASGv5oJeXmWn4VvIsTUnaWaDNYZMJEwJ1LJ6u4cxwvKd+pW7DRqE/9L60wzNhmq5uJb96/HO2bVkuXf1tdjVqHi2UdGpeqbPx4sn3JkiIAJb/eE4g1J/ZEIEVpq/25o1mjqWFMoXSz/ckck/fLbLJI+Z
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199015)(36840700001)(40470700004)(46966006)(8676002)(41300700001)(4326008)(6636002)(70586007)(36860700001)(70206006)(316002)(2876002)(110136005)(81166007)(5660300002)(8936002)(54906003)(356005)(36756003)(426003)(40460700003)(47076005)(55446002)(26005)(40480700001)(9686003)(186003)(336012)(2906002)(86362001)(478600001)(82740400003)(83380400001)(6666004)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 17:26:26.3394
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 862d317a-ab2d-4daa-715c-08dac1ae5d96
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT088.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6074
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
