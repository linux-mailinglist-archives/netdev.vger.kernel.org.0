Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A6B6EACB3
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbjDUOVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjDUOVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:21:08 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059CA118EF
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:20:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D5B+/RcbjxfJnNYE/Hpc1Ao+KiodFMVYHfKc3NF/TaxtMdAEJumBeNX3xb34rJfwIkGD8/D1UcziqOHI86j08NaI68jgWqhTVEKxbuq2nWzHP7txcR+w9503SFLFk8C0bV0BfrC/5gwx+7MJetWkf3lQ8EcVIbyGgj8hHycTMgvihvVFeDapn2CvfZu7X04g75Kd+OsXbr5NHvuJXkgj3XK37keyHIXjLHagT1sYAExXYWdvA2bPe8tTEriI7bQe+7sl3+u3s+mJO7m0b7Cv/2FEmXKRwohT4uWIlaW4EsavRovYI48wDN2NrfCS6uXmL5hFoM8ZPW979hzcDwQ9HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FwCRSk1O1BXeiOB7oJ7R7mbt0WvS5pN0Gcz68NosPz4=;
 b=WHLrCZV18srPdbM/u+DK1sEpfJFYuZOfVF2gArh4wBabMzZ7PGndioVA6VElg3NTMYsxUlB+Qg9Xn7zbvrVCtR09IkQNED9Kp14jswY7KEeBs78gAboYLJhqTy6OF47F7heZjhjmIgHNnDhBU2dVsArx96JSTinowWDaNn7A1sxHUPkBy2+OdmAGEnEBNuwHQscpQioIcqi7uqcFOSVeZN3uOfvXZL7dlPnljjaG83KFuLFJesECJMfQPKLchR8MdlkNMFA0UdV6DvHrIxUbMEJwiYCqKPmaulNrA1eKJ6PIP45n5FFnaDCRXdwAUn0FFkUoEpBshuAz7E6RNfrgsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FwCRSk1O1BXeiOB7oJ7R7mbt0WvS5pN0Gcz68NosPz4=;
 b=Qm0mZzwt/hmDtLD5/IJBa+uywSO6QdPwTThhfzcY7w3kBdRGMCLe+1QP6Bx7t55PjgWvjYqgRIav7zvOn//RMyD2hgN92475juXEerDt9sWWMKl5Ygetp2gPsCKJNYn44fKvMASY/k7iYgbIWP2sLAwfhCvotm8CtkNmOVTCAn0=
Received: from DS7PR03CA0212.namprd03.prod.outlook.com (2603:10b6:5:3ba::7) by
 MW4PR12MB7483.namprd12.prod.outlook.com (2603:10b6:303:212::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 14:20:50 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::4d) by DS7PR03CA0212.outlook.office365.com
 (2603:10b6:5:3ba::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.26 via Frontend
 Transport; Fri, 21 Apr 2023 14:20:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.27 via Frontend Transport; Fri, 21 Apr 2023 14:20:49 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 21 Apr
 2023 09:20:49 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 21 Apr
 2023 09:20:48 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Fri, 21 Apr 2023 09:20:47 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>,
        Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: [PATCH net-next 1/4] sfc: release encap match in efx_tc_flow_free()
Date:   Fri, 21 Apr 2023 15:19:51 +0100
Message-ID: <582c6a33290ce7aa59fdf5f4319ea03ca24bf715.1682086533.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1682086533.git.ecree.xilinx@gmail.com>
References: <cover.1682086533.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT068:EE_|MW4PR12MB7483:EE_
X-MS-Office365-Filtering-Correlation-Id: 49b68527-dec8-44f2-cf27-08db42739b50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ld1klClvRiPbxCe+UkVa8CZXKu7X5e13AQyOHyzD1jvhdGfYIGOVziVuS9Dts4Dx2SHgQ9z5vuamj+t4F8hhqTqE9KfQRJ0u7xToiTIfN0EcIGe78ffucBvyarMcHCI0QfuekZCVGrUBowxNQGwtSsomQ67rVdbmtcOqHpXQ0swhu8rfePTbTIiXYdH7v8sTmYuHkOjEpv5qu1OZimC7yK2r+WtwhUpKKH6IDsm+75xi0PlKiOvprhZ1i44G/W88W5jbT/gjwHaDIvxpau4fDJp6XcWVmGUx6wL614pLrdmC9kAEGk0VKEIycqroe3QOpi8A556p/wE2OuQ/DHnh9Ie/Xrr0j6wnCROZcDaZtPuV/3jPNLx2U9NdiGth9hsvD7nrk3oTPOHi3hz6rcmr3XR7GDkp495jy6kXh7tF5wKb7SM/1q2S+SmwA/XG/Bp0AMwzA6zdNmzk3lS/rri2fvthrnPU5wmmv3Twl9hO7eQi6fq2VlmF7+Gaae9iJkp575QgaaBLjlNqcisavHqUiSE3t1UcORWYo5jL1z4O/w+1HtQH3NGDOwYgqJsTGtZIYcoz8dtW4n3MGMFO4uEKlFCrtqJAFpzwSrV64g1sOKFzoR5vDJYtZVK5FR/nqeWLHbV8NgkP/QuL6DncM2MzpfstnZGUtBynm+QMtxWF/S+Xa9gau1FlaUD0Ww/w8Kf8XMGCHqD0oH0rczw6UlcZBJzuSmgiSA/0HOD79nWNYU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(396003)(376002)(451199021)(40470700004)(46966006)(36840700001)(336012)(8676002)(8936002)(41300700001)(4326008)(5660300002)(316002)(70206006)(70586007)(81166007)(356005)(2876002)(2906002)(54906003)(82310400005)(55446002)(478600001)(110136005)(6666004)(86362001)(426003)(186003)(9686003)(82740400003)(40460700003)(83380400001)(36860700001)(26005)(40480700001)(47076005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 14:20:49.6712
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49b68527-dec8-44f2-cf27-08db42739b50
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7483
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
Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
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
