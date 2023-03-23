Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7831B6C71D3
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 21:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjCWUro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 16:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbjCWUrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 16:47:41 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C610B2B290
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 13:47:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZqatGDereFJW3vsBvqYdr4Q4sMn+PvfsW+CZ6TRj2DOhAuvW1x9eP0pKhLANPb3HcvIeozYiomlzF8TP+G0f4BLquQVWMBN3DLgYZOp26LTWxr7ewALI/5pGrEowtMJvyXsGBqX04ICSL90R+4wjNaVDgWRGgZ4hQWpycvpBMJMCktNLUbc7OwO1abwhs3IFRDPR3SQHnRVs+7NscdyyZD4RJyQO/V/I0DcjCBQGtX5aVtnxltsIzOx81f8ZL2SzgYvPc6nixjqP2ZjQq5EZ/rLAAL2oN1wWiyQrXYT7pUJyzoo3XHuM2B0GjpAPuf+OgLTJZPu2bY2wN5qqZ0Kmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EIn0tqv/DZKqVogprhmDM7uGl9BK7kherNmsDQlH94k=;
 b=bJuTPDmC7zb69XPeZpjaQ9B3ObXc92E2vMFTH3UPZuAdWROmBLOQ6HRqZSoBvjpQASOYlBCyPwpXAnqimk66V9aJRFxexuDy7eBria0LP+OSnr2PGYFqPX3AU+1ulRp8OEAIEuea5RyVuv03jb2YGkg7elS3reg2kwI+b1LL1YRbypizgB1SsIDHblORVNWOJePYemTIiN9OO8wAwYVc87i5tHl4gVncZg0psqCKDOnD7dJLUplxM+udcfCcAdZgKGz6gcZmrWVbmMEyEWXKNZPQa068+smd5GlFtK1HCqEVtTuyMMxc7sLgrLFQ0yMCkL7JVOhuHzIX7g64zN6K2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EIn0tqv/DZKqVogprhmDM7uGl9BK7kherNmsDQlH94k=;
 b=J2gWABnYqNFPd4efaYWapBTsS1SvbGH7O8mdE3odyZuSVJPaIDQVdV2u5ODstY91Fg/FG6GEyfeEfq+oanV5ZwLga+7CSae5eY6VsFIiKXCtu29YN++VSfJCK0IiI/13QxfNtd/D9ts4jy5KXiaK88JzYjDO5T5WnufOyUbbqTY=
Received: from BN1PR13CA0003.namprd13.prod.outlook.com (2603:10b6:408:e2::8)
 by SA3PR12MB7781.namprd12.prod.outlook.com (2603:10b6:806:31a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 20:47:36 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::96) by BN1PR13CA0003.outlook.office365.com
 (2603:10b6:408:e2::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.6 via Frontend
 Transport; Thu, 23 Mar 2023 20:47:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Thu, 23 Mar 2023 20:47:35 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 23 Mar
 2023 15:47:35 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 23 Mar
 2023 15:47:34 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Thu, 23 Mar 2023 15:47:33 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next v2 1/6] sfc: document TC-to-EF100-MAE action translation concepts
Date:   Thu, 23 Mar 2023 20:45:09 +0000
Message-ID: <6d89d6a33c33e5353c3c431f1f4957bf293269e7.1679603051.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1679603051.git.ecree.xilinx@gmail.com>
References: <cover.1679603051.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT060:EE_|SA3PR12MB7781:EE_
X-MS-Office365-Filtering-Correlation-Id: e5977ebd-acb7-4558-a1cd-08db2bdfd506
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pZsLBIQVJ/LCTUzzcQXwuSBXxMV1Fu2ESjFemvOFaq0HLs7cN7fhyL+xr1kUbYPBp2bk4l3LxRLNwdghRYPS4oTDrODnbs0DrIOqARa13kDfsS1g3e0SRS1QXa2let//CL68qWaSjN64dXVH27fxRMbJjl+R22FHgIv9oCaIxb5mkNQh0S1XDHs7KFy7n/a3hFf9mCA0Db7LV0gxDY47w0JJHOeoYeKbIWC0xKvw/IkqWeH5CCuMXPF8JDxMe0B1lu3QLFaRTw6HCFzkZgRbc3sbIOaSRhqLy4H8rjiwnDfkCuWj50nfbgdZio+fN12EIsQOH4FlxTiNJdmRhx6H49RYP0PNIRK5+H+a4AAqYztctT9BNwKTzG7FeVbRXPMFzED/NKVMDh/KkQhjYweI2JLJaO4CV/X4cdXWP6igaVSvoDhxBhTq5LyJCBFvtSRciMWWXvN/3hERQWWz2QZ4On3ZfYxQNgEs1+D+4UEkHFS6mCCoZv8iXURrKghBWmOs3wTsYRetsLxj8NnHeypVWqaug9eLfRc7Tkop9gUePpDOHekURBlNpWx/+uTxtYnY77D6PENG0Hh0sxFGUCO45XbKN3TbZL4pLUlcKRp7nbS1LAnZjomfRTPV4QzB7bIERuGk5Jynf9dTzOEod6Ztcd7OBjgSlxPpIYbohF3DDdmVYvKECMHyIwBkpOeGBbJi19eNxn8c5/WAAx6NqsZgSiTc2ekXQS/atGNsr146A1c=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(136003)(376002)(396003)(451199018)(40470700004)(46966006)(36840700001)(36756003)(40460700003)(8676002)(70206006)(54906003)(4326008)(110136005)(36860700001)(70586007)(81166007)(41300700001)(5660300002)(82740400003)(8936002)(426003)(47076005)(316002)(26005)(6666004)(186003)(478600001)(9686003)(83380400001)(336012)(86362001)(82310400005)(55446002)(40480700001)(356005)(2876002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 20:47:35.4271
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5977ebd-acb7-4558-a1cd-08db2bdfd506
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7781
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
