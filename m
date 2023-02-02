Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783C568894F
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 22:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbjBBV4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 16:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjBBVz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 16:55:59 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2041.outbound.protection.outlook.com [40.107.212.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55C0589A1
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 13:55:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fMm2X9feuvDDe5q6FhLsBT0LFsH6Qp+z9uhRLHxsOTfrF4Jm40FSGA4t1eOcwpmnxX0woK5ZsJevnG6GsFjb7YEVYH+W1U+omXPnSN1wj6ktLp7s29DIY3tyGSBIuDZyXTm2HQ4FUnghyncIc7fXcZ0svt0PlvEsjtmtDa8gTzj5EaTrRaTyFe1sUs8GYNQn2z3pbB/y3JrhXwXM0OZUCxWDJL+OqYXu6iy7gl+EBAiHwC9nHNpVkRYKz3goiL2Y80kEaqikFwhLEvrmOQ9IWva5XWz/MYCrg+fAsVK/gPt8ZkRL+VYhyUURYC/irQWK8q7waaFzTMMErCxP7AtbyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wk3Zmt4YWEOu01VPu52+l4AzR2y+c1XV75eNbRoT7RU=;
 b=DLMGhU+qbxsTSlYlz5Ry0F4CT9N8EjjB64Z493tveTwD9jxKMKHkCL6Me99P8p/67D78chugIy44jhOL6QUN+TvlSnPSXqBchDwlpIQw1PeDfIB7zi4NWuF+T4pOCbcY+X2RK33mn5BbRH5RNK6qcEuMA4YMy0DSB+zEwpP/5zyJx5CSz9/P8pwsCtFoX5zqDUGX8cuLSixKS0q9MCefMLS3gwJMTVdjaQ9051Vhe8xRnrSI4/WI/rWaUDzFY8z3yDA5BlncJiyMyfX8+LpAZqy/RM1yTbalJWmRTqKVk2PK7dRjL/OoDd8OwoteoH9qL+6ZiPC8GCSGhHtXsLWBWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wk3Zmt4YWEOu01VPu52+l4AzR2y+c1XV75eNbRoT7RU=;
 b=pY/lMKSH3k3QHUdn1vg3afJeV96Xebz51IViI+koDiuRaS/2yuunfYntnntfeClAE8w+laLAQ+dGg6Xp/vDEZK5dv0DWRwxWdT2liidw4IRxgWdqkxWMi901CuvoA6bytuoE6EXHfBzIEvQhF9VP/mfjHFI31zbxfJA8B7gvrO8=
Received: from MW4PR04CA0148.namprd04.prod.outlook.com (2603:10b6:303:84::33)
 by DM4PR12MB5088.namprd12.prod.outlook.com (2603:10b6:5:38b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 21:55:55 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::d8) by MW4PR04CA0148.outlook.office365.com
 (2603:10b6:303:84::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 21:55:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.28 via Frontend Transport; Thu, 2 Feb 2023 21:55:55 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 15:55:53 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Neel Patel <neel.patel@amd.com>,
        Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v2 net 1/3] ionic: clean interrupt before enabling queue to avoid credit race
Date:   Thu, 2 Feb 2023 13:55:35 -0800
Message-ID: <20230202215537.69756-2-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230202215537.69756-1-shannon.nelson@amd.com>
References: <20230202215537.69756-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT053:EE_|DM4PR12MB5088:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e298169-8ed9-4920-c12b-08db056842a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FozlcbgUaxcTuckNFUY5xzrN/Hj4E0wAjM0X+dttlwH7IbigtQQJZBKgQpJOsW/OMz9zASAb7TCKjd9SCte65eFSu6QDJWJNZGUHMOb1WfHJmr/+qEpuOKahVVY5XkqK8fD1XHeZ39OhYH/9/UKsjLMD+c4VrUZMk7jH6NC/pWLAvGf/GyQnxSBhw4359caTTLwQCqHRjpEIfE2T64QaEIvDxqiDLFSG4OBcKYBrSTVV6A93AduMnSPKaE5ocmFFMTZaM1g3o+0CkqK7mHnx+ZmgPfTU9ujQvGIvF7ClIT89SvomBafcD6kOBoZNc0AmL768ywbD2prsW/aQYnm8OT3WsA38ST7psABV8Iu8pAtIrRSwcGNKHzkFKPp2mhSENKDD9R4fPb561LB/dbP3HHa6Pli45hiCBKhXzHHOn7flmDS8LTOomSEHZ1qyB6f2WpkdVlrCuz0gn5NzjZ4eX+e7m6T3ozL38vqSSVKHCS+kVmJEhw2k1UZNnKeUADvxOA/MJkk7HSrfu43wKe8okb0yXNpaWWm2kbm1z6v8hU7nf3kRrvXJ49pM+3rTi/73eO15tlBsl3kCXC/Pe3LX0p45IYysQA4XU58JL9eVUTQu3jI76nx//7xZt9fG1fyEt3Na9IMy+sqSCwThtk6ty3Yay5lKGaDYouNjN/rIYDSB8E5KbSDrXp34DypF3zOZarjGFEMy0JP5g4RjGI+nsIILnK/UjSd7bIPiqKtOMpVEsVXsLtIHcmNTgerPTh63z7+nckJH40f8wWkhsNcWpA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199018)(36840700001)(46966006)(40470700004)(478600001)(47076005)(16526019)(2616005)(186003)(1076003)(426003)(40460700003)(83380400001)(6666004)(26005)(336012)(5660300002)(44832011)(2906002)(36756003)(82310400005)(316002)(8676002)(54906003)(110136005)(40480700001)(41300700001)(8936002)(4326008)(70586007)(70206006)(81166007)(82740400003)(356005)(36860700001)(86362001)(210963003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 21:55:55.4678
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e298169-8ed9-4920-c12b-08db056842a7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5088
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neel Patel <neel.patel@amd.com>

Clear the interrupt credits before enabling the queue rather
than after to be sure that the enabled queue starts at 0 and
that we don't wipe away possible credits after enabling the
queue.

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Signed-off-by: Neel Patel <neel.patel@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 4dd16c487f2b..5e2dfa79f0e4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -269,6 +269,7 @@ static int ionic_qcq_enable(struct ionic_qcq *qcq)
 			.oper = IONIC_Q_ENABLE,
 		},
 	};
+	int ret;
 
 	idev = &lif->ionic->idev;
 	dev = lif->ionic->dev;
@@ -276,16 +277,24 @@ static int ionic_qcq_enable(struct ionic_qcq *qcq)
 	dev_dbg(dev, "q_enable.index %d q_enable.qtype %d\n",
 		ctx.cmd.q_control.index, ctx.cmd.q_control.type);
 
+	if (qcq->flags & IONIC_QCQ_F_INTR)
+		ionic_intr_clean(idev->intr_ctrl, qcq->intr.index);
+
+	ret = ionic_adminq_post_wait(lif, &ctx);
+	if (ret)
+		return ret;
+
+	if (qcq->napi.poll)
+		napi_enable(&qcq->napi);
+
 	if (qcq->flags & IONIC_QCQ_F_INTR) {
 		irq_set_affinity_hint(qcq->intr.vector,
 				      &qcq->intr.affinity_mask);
-		napi_enable(&qcq->napi);
-		ionic_intr_clean(idev->intr_ctrl, qcq->intr.index);
 		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
 				IONIC_INTR_MASK_CLEAR);
 	}
 
-	return ionic_adminq_post_wait(lif, &ctx);
+	return 0;
 }
 
 static int ionic_qcq_disable(struct ionic_lif *lif, struct ionic_qcq *qcq, int fw_err)
-- 
2.17.1

