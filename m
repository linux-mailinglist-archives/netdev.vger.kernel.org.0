Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D28E6CA18A
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 12:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbjC0KhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 06:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbjC0KhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 06:37:15 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375B12D40
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 03:37:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WcWUsQ5rANbXPw0h98Q8/IpkEfRMSmXknPquHTV83PqPENrb1fFcPdzP7kVJUpc2pJYiyPzEQZUT28tkKE+Hj6eYVdKKOvWledft4z7Cs76kp6PtY9/HtJwqfTltrMObs7MSc8nJ31CJTlStgGGPIRaI953VNuytrNvXY7ZYOHDfRgx9alSIqXJrfX+JEgIWnrlewe3D8u9nlw4ii6YHNwBQiEDWOfcOu3ut1GgkactkNnVlMAbpoXnpbzG+gSV8BdUaSB5FQguEqnMjoWTqV2ne8SUI4AixsT0HxpJ8vMpAAUg/cFRoOe43CjTL7bs5NrJHQzTfS0x+MYOpMw6+hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=75VNSEuhvarstbSHsoZsBlUPEARSoLkxqcc+rWnZTCA=;
 b=QpORFkPIPDpJ8qNoQ6lvoEsG/DrjlZBym3bmlQoOqH9j3GatqkuefxaGQKhTkl4sIaU19Tp6CDR8G0u9HKnc7B8d5asx6kios2cY6RLthF6RMjOLA7QlLvRpThSzA+6r5VucmhL1Ujp+TUHT4RnPKz2+hx2HeQakGtCwjpGF++Hd+kvCXNoUKr7fES7PS6HEcC3djHnYGU5O/Jea/7lgD6PGmjzOCttEWXS0KhefrOKKtdaE+8CqBJTp5eiYgoDlrICW4/lemDEwFSieHB2UngtdkcJzi84yMhl64tpIBr39TfREywdQQ1LvyIK8+Ea2bgGw3V0DWFbZR//Kiro/CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75VNSEuhvarstbSHsoZsBlUPEARSoLkxqcc+rWnZTCA=;
 b=1VvGYMXrFfOcJNobN+TyHawr8WfGn5xN2dk+e7rOnGXo9q9efqa5vPjXtTGc8ACXQ2aM3I3xkin404sFYkdfSHM+9Ank79LoZHtaTd1qgd7GFWEEqArFuhXn1T4DDrXw9e/vbDRM+0O1QV7r1Iw6bQKD8E+xeIK2KUZl2E8GJCo=
Received: from BN9PR03CA0590.namprd03.prod.outlook.com (2603:10b6:408:10d::25)
 by BL3PR12MB6620.namprd12.prod.outlook.com (2603:10b6:208:38f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Mon, 27 Mar
 2023 10:37:11 +0000
Received: from BL02EPF000100D0.namprd05.prod.outlook.com
 (2603:10b6:408:10d:cafe::b9) by BN9PR03CA0590.outlook.office365.com
 (2603:10b6:408:10d::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.42 via Frontend
 Transport; Mon, 27 Mar 2023 10:37:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL02EPF000100D0.mail.protection.outlook.com (10.167.241.204) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Mon, 27 Mar 2023 10:37:11 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Mar
 2023 05:37:10 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 27 Mar 2023 05:37:09 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <michal.swiatkowski@linux.intel.com>,
        <simon.horman@corigine.com>
Subject: [PATCH net-next v3 1/6] sfc: document TC-to-EF100-MAE action translation concepts
Date:   Mon, 27 Mar 2023 11:36:03 +0100
Message-ID: <6d89d6a33c33e5353c3c431f1f4957bf293269e7.1679912088.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1679912088.git.ecree.xilinx@gmail.com>
References: <cover.1679912088.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000100D0:EE_|BL3PR12MB6620:EE_
X-MS-Office365-Filtering-Correlation-Id: 90496ce0-6c54-4864-1983-08db2eaf3911
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZL+nl+kexM99LDuAo4eUB3fe/ZCvzpowqEDojQi83rks1fXRg9GdTxDUBoizwwG9ylwCegd2SbP2p3iCK+19X4Yo/3iEqQg+l+CEWk1fAxAVMdhxDGx1/bVVvT5yq9Q/txuTaQuOkLBczPZ/OMAvfioG2CQJhdZWga18a1ABnvOuoupg6So+1WoKiO0XgbVsBsH9wVUDE7F9dPsSvLY2LM1ycI/WQgjXRkTOcnmuWiT6r3xFdN28EKfNWTipjvlP1IZQbbF860BsE6b7CWgEpaerYaAgx4QWYpkRC/BM8HM8seYWVBLmOd3W4t5s67GA7S00BL/ubK+a+gUr87rGdoPHU9EoxpGRR4/mCpH6T0kajiU1E/mi9Xz6VmbLbDzd5SgZ5u+iS48T7n99AmFlN0MKgEMCg+7EjWMi+IvdyVxDcanqxGaXXwFAO8ftw7lsuCEMADGERgPkJjSNxvxzuIKjHXMmw+38I4+VYHyD7x0Tj15FYbM4x4HVp1RQRUJsc/p3+D0yIATq/52O92B8vELekGhF2kVXeauYxwyx4dZ653xIsbQBmFCaKVzUSEKJb1jl4IF+kOIteXH9Slt7uM1jZqRHKdasaPm2xYAUKT0H48MzdprmhzM7ArjT76khfehBFdAEldcqN5AMI3FXoFks2+SqJd40vY0aWEPOYGpSbPZOqriw1VX62DwYEft970i/9qYdMLyxVgvXzcYDSbRFyNy+aS3+tGel9jaXGtY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(39860400002)(376002)(451199021)(36840700001)(40470700004)(46966006)(9686003)(186003)(26005)(316002)(8676002)(4326008)(70586007)(70206006)(54906003)(110136005)(478600001)(6666004)(41300700001)(8936002)(336012)(5660300002)(2906002)(83380400001)(47076005)(426003)(40460700003)(36860700001)(2876002)(82740400003)(36756003)(86362001)(40480700001)(81166007)(82310400005)(55446002)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 10:37:11.4164
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90496ce0-6c54-4864-1983-08db2eaf3911
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000100D0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6620
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Includes an explanation of the lifetime of the 'cursor' action-set `act`.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
Changed in v2: newly added patch
---
 drivers/net/ethernet/sfc/tc.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 2b07bb2fd735..34c1ff87ba5e 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -66,7 +66,7 @@ static const struct rhashtable_params efx_tc_match_action_ht_params = {
 static void efx_tc_free_action_set(struct efx_nic *efx,
 				   struct efx_tc_action_set *act, bool in_hw)
 {
-	/* Failure paths calling this on the 'running action' set in_hw=false,
+	/* Failure paths calling this on the 'cursor' action set in_hw=false,
 	 * because if the alloc had succeeded we'd've put it in acts.list and
 	 * not still have it in act.
 	 */
@@ -407,6 +407,30 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 		goto release;
 	}
 
+	/**
+	 * DOC: TC action translation
+	 *
+	 * Actions in TC are sequential and cumulative, with delivery actions
+	 * potentially anywhere in the order.  The EF100 MAE, however, takes
+	 * an 'action set list' consisting of 'action sets', each of which is
+	 * applied to the _original_ packet, and consists of a set of optional
+	 * actions in a fixed order with delivery at the end.
+	 * To translate between these two models, we maintain a 'cursor', @act,
+	 * which describes the cumulative effect of all the packet-mutating
+	 * actions encountered so far; on handling a delivery (mirred or drop)
+	 * action, once the action-set has been inserted into hardware, we
+	 * append @act to the action-set list (@rule->acts); if this is a pipe
+	 * action (mirred mirror) we then allocate a new @act with a copy of
+	 * the cursor state _before_ the delivery action, otherwise we set @act
+	 * to %NULL.
+	 * This ensures that every allocated action-set is either attached to
+	 * @rule->acts or pointed to by @act (and never both), and that only
+	 * those action-sets in @rule->acts exist in hardware.  Consequently,
+	 * in the failure path, @act only needs to be freed in memory, whereas
+	 * for @rule->acts we remove each action-set from hardware before
+	 * freeing it (efx_tc_free_action_set_list()), even if the action-set
+	 * list itself is not in hardware.
+	 */
 	flow_action_for_each(i, fa, &fr->action) {
 		struct efx_tc_action_set save;
 		u16 tci;
