Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63FC3687305
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 02:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbjBBBaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 20:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjBBBa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 20:30:29 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2059.outbound.protection.outlook.com [40.107.100.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648AD76412
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 17:30:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pe1OwsiuGNHli1z+Bm7fSdq7YIvWUVrmzeKGldO/t6wFnKtktZS/d415iIt4YP4hbFwM5fhZod5R3xEwftW/tCj8b3HQelSrtRLJfUT1YAFbiZshomuD8z58G4talfAL/dcyK+SKk0riUPPwIX3y4a07yWWwyAiAe/TxZjBdV/8nb2F1dckf0Cj7vElkKS1SKSVVtSByOLhf0q7Ey6a2/VH9HCaDbF9bjUIJh7cBBFn/VIToapuL/7ROxZ5EHD7xxGgADTWLDPTTfraZ26aIyT5MSCRo2Y6+I0aKjSuNNaEC7VSttGKSQnbVthToQO1haoKr29JO1/7vqJvbBxjd9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GembllYsddk+fTseI2KVlvidrWiegJe8XZ0wzvhZLWw=;
 b=d9uihZGtwIeHvzQXGossi9/+o+o27u3gxcwZcTzXTgYK2PM8X7I7kAqaQA2kCOCbP01Ga2WUzj5BcrpWB9A4gLeBhQMHvWsyuad/reMJ0wYGBrjfdSAuESdzHdNSGLtqgQzPzVqSRt+0AauejLpw3F5CikNmo+VefnF3Pf2SPXceYaF2YOH+qzAZyqvwG1+PltA4iHu1PXlqE+D4lEYqJNT36soqzlqD1zZHU90+vx9/xZZGkPROHCJT6Tw8jd4mKcqt2Sg5X5f7WRBqunimIjxyhsSjZSBwuWp3tOH4hExZmb/w93JrkYHUNsBqEfl+B6hQmQjcx6RzP8Ri4dqBQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GembllYsddk+fTseI2KVlvidrWiegJe8XZ0wzvhZLWw=;
 b=NRmiHRN+vUH31/8PnZnnMBN+jSpF6So62MxZe5VJ1jqRMz19tZIad7OPqMuy9aIjMK8a+wjzaDMB/jVFKiaptkstAFOAFhFySer/eZaZ4F+XYCs+wPyUu0FvBuin2SZD0zn9ol/EX59DeZS9eFj4dwfJduMNOqEkR28vKD88sB4=
Received: from DS7PR05CA0046.namprd05.prod.outlook.com (2603:10b6:8:2f::14) by
 DM4PR12MB6010.namprd12.prod.outlook.com (2603:10b6:8:6a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.27; Thu, 2 Feb 2023 01:30:24 +0000
Received: from DS1PEPF0000E632.namprd02.prod.outlook.com
 (2603:10b6:8:2f:cafe::af) by DS7PR05CA0046.outlook.office365.com
 (2603:10b6:8:2f::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22 via Frontend
 Transport; Thu, 2 Feb 2023 01:30:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E632.mail.protection.outlook.com (10.167.17.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.21 via Frontend Transport; Thu, 2 Feb 2023 01:30:24 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 1 Feb
 2023 19:30:22 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH net 5/6] ionic: clear up notifyq alloc commentary
Date:   Wed, 1 Feb 2023 17:30:01 -0800
Message-ID: <20230202013002.34358-6-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230202013002.34358-1-shannon.nelson@amd.com>
References: <20230202013002.34358-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E632:EE_|DM4PR12MB6010:EE_
X-MS-Office365-Filtering-Correlation-Id: 83691cb8-ae13-4935-93be-08db04bd0eb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IgHG5x6SNsJcprafHlJAOBQrO0lKzLsRXRSy54GuVu2xnGrIG6SPaIzcFn6n3UuXMnzKrAMI26B4/L6qIsUZNDg0paMToRVQIQNm4Awr501cPjT/16IdkKv2hRcG/HjXahbRWJqOZ3L/VEDhC46ZqSv92qRGchxGsEiCgo0NsTHW7FH88OQvwpAlk35JzEucyN/Qhx7L/qx4uKB6rX7eCF+rWU8a9rabqefFasfKNQOMaJK+Zs7h8NWhLCTRP22X+XP1hvezjUbcK2vyJoMDFc4ohz0H4E6sgfNlUBsy0WTjvEUH95vYeAzsRFfYAB6lhOu4BwGuGQ3tRFP+NprcFLdfXloGJmR0rGRL/HvC0WFaTWUY+vKiEljIcYWXhvNaXor/UR9mL0OpxZKMm7Sg+gBP/DlZM5rXYPwpjjIa3SNX+ixQOy2dgaSl75CcBtJx3bdDLBzv1E3APPMwdCwtoddCwz4lj7vDYTvgB8Yb6kUV9tAc8LAeCQWHmIz1+NJFxEr1op91cjgtCAKI0RK9J9Wd0u6YfhlZmlaHf/79UtnhYyITOoMy3SymR36MiDuJISH+DWfHc8mUvxdZL1MOUcrY0ytwr1/CEDAV5WLQAtS+IBnIqzG0wSWKkKBxab/VA5ymyrak8nnqrOqcoMYvluZa7z2ibBYNdelwKdsZNnJOxa6QAdjbbelG3qARCStcnV7Sbdrom/rUicQXMmtLuudsYotgNRVSmP+cr6OUX3A=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199018)(36840700001)(46966006)(40470700004)(6666004)(47076005)(426003)(44832011)(336012)(41300700001)(26005)(186003)(16526019)(2616005)(36756003)(40460700003)(1076003)(54906003)(110136005)(81166007)(8936002)(2906002)(316002)(82310400005)(356005)(70206006)(70586007)(40480700001)(83380400001)(86362001)(82740400003)(5660300002)(8676002)(36860700001)(478600001)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 01:30:24.4608
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83691cb8-ae13-4935-93be-08db04bd0eb6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E632.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6010
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure the q+cq alloc for NotifyQ is clearly documented
and don't bother with unnecessary local variables.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 90a3ad4a6ea0..486fc0bcc0ad 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -573,13 +573,15 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 	}
 
 	if (flags & IONIC_QCQ_F_NOTIFYQ) {
-		int q_size, cq_size;
+		int q_size;
 
-		/* q & cq need to be contiguous in case of notifyq */
+		/* q & cq need to be contiguous in NotifyQ, so alloc it all in q
+		 * and don't alloc qc.  We leave new->qc_size and new->qc_base
+		 * as 0 to be sure we don't try to free it later.
+		 */
 		q_size = ALIGN(num_descs * desc_size, PAGE_SIZE);
-		cq_size = ALIGN(num_descs * cq_desc_size, PAGE_SIZE);
-
-		new->q_size = PAGE_SIZE + q_size + cq_size;
+		new->q_size = PAGE_SIZE + q_size +
+			      ALIGN(num_descs * cq_desc_size, PAGE_SIZE);
 		new->q_base = dma_alloc_coherent(dev, new->q_size,
 						 &new->q_base_pa, GFP_KERNEL);
 		if (!new->q_base) {
-- 
2.17.1

