Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6F568894E
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 22:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbjBBV4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 16:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233119AbjBBVz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 16:55:59 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498F159273
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 13:55:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GasCePTEkEL2Ds8FQAPSvO6L0KPtn4SwUFvG7QMHxDwXm1/pmbzUpYYKu4mYqiW1x23O8x8IgGM3Zync4KUFjv8JY6J2F0mzSlJa0R61dqs1rlFje95v+Cem9XPjtEfqW1PVMz8tiQi/o4DzCzBrAHZ45BrtiD0OlrEx8GqAiIRoYv4/rBKb9lw52DKwiFvgvVWixQwHiBTaxgWKXgwFma2Eo5vc2e5W4RHjruPUbZii8zAvcbTAzbs0j8X9y3xsP6iBYolT+SKuQNW8aibahR23eEpltTq73nbBhSzOdjUGvlsOQW4lHgA6zndwGyY7EoLLTx+ba97fRINLcW+wRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L2bR3reAp9Qj91uNgUyv0X0DGZjcc4OtI06oWZ2I4ks=;
 b=L69oSkBTwN3wF+1SQXO2sYgdoatGD4uk2CaDUV7ea3HmdXwWJxKLcajx1P3RLl9uVTe93R773E1Mdbvup1dISys8xZeTAewxWfk66vp2AUl1/Irin195vTamYvuuyIuYfi6ISuTMEb3srZZQxPt0F6CGQF9Td8Z318VUz18XE2xlA8oYdLUGqnJ5tsEegx/VT9tnKN2UJobeizeUoVYVEfuDqYsY0CET84L+lMVRU2ru5x4oFsSWHd0BdPvU97hFgfXIpxDSaBIq8fMlcbOi1ghLda2AglTrmkI9qXiPfMhVFmjYcZLBduetGr4dQktYrp3PeBvn5GpRS3s7y+rulg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2bR3reAp9Qj91uNgUyv0X0DGZjcc4OtI06oWZ2I4ks=;
 b=hRc83hqG2OAjYHYOj4TP3YjWCOTDGLbu5yYbsBxJhDoVqj09484+dmm9oA1ARfjNjp6knJj+ttqYoEMBhPVVfObXAkk4EPAbMRXmS9whAZlcwIm79d2gVr9SlGp03mdxJK44SHp77XSZLs9EfyjLVmnpePU53hpSjtEe38EgsTk=
Received: from MW4PR04CA0136.namprd04.prod.outlook.com (2603:10b6:303:84::21)
 by DM4PR12MB5841.namprd12.prod.outlook.com (2603:10b6:8:64::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 21:55:56 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::95) by MW4PR04CA0136.outlook.office365.com
 (2603:10b6:303:84::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 21:55:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.28 via Frontend Transport; Thu, 2 Feb 2023 21:55:56 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 15:55:54 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v2 net 2/3] ionic: clear up notifyq alloc commentary
Date:   Thu, 2 Feb 2023 13:55:36 -0800
Message-ID: <20230202215537.69756-3-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT053:EE_|DM4PR12MB5841:EE_
X-MS-Office365-Filtering-Correlation-Id: 748bef29-c3e2-44bc-9422-08db056842fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cyB6L2XW2Ka0lrswZel62o5KuuVD/mXCi+53gxJxY8KLDzRmF1xymnr+T/qCVztSO6uETMaDiJSpD2hBsipYUxfoeLCk6SQoXDi9zcNeOclu1SJrrkDUmxkNL4fTHMTwmO9BV4Q6CO0UevkEGY77wvNK2AUuWwsm9/P/+sA+V5sZXYR5Ddn/o3/A/+kYrDQrmIqBtS8vYFIAvqpHbN8x2ZwiUynYI0aO+J9M2dHu51x+w4RFIcE8e354ti1JgwBCaHGc33MgkT6ichFqfmK6UaWJtJ6nMGpJhzs6IxoKXipQm3JuLUaJx5ac+4IEFlm0Ia8WWeLLdQwNGXP+F6/GKSI7y0Nq/vzW1vwezRTqks9YeDNxmNe5dw7/ZnMT1RCSv06eBwnP0NLK163DHGEWQvVQp5TNvAiL7oDbTs4rLEjwsOG6LkPlVgsVNHLRC+a9iplgZlCNvtGSBw5+FdLiHMhYQ52Vlhus6Po0ToRYANP+ad4mLmlcXKBgAU2a6mzeKbgfXTNvUMsyP56TNykOM7uW226kFOlfjHu10d/Tt6BcNrZovnBzLa1/GhHIVCHBSgb/Dv26SrZrrDcM6MrfJ/Xx4vdbGzLaJ3FfSIj7CDatCAgFnQ+XY2bqdsHDqyR3vRN29KbU7mBYx/1Mnq2pJu28Zc2gkRZ7Ug7dRVUx3mBG90ibF9911nMalgRZwxuBs9/tnK8haJUZ/vkPf2IrgFw5HR62hgSe7hOegPezrOo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199018)(36840700001)(40470700004)(46966006)(26005)(1076003)(336012)(83380400001)(70586007)(426003)(70206006)(186003)(16526019)(36756003)(40460700003)(86362001)(81166007)(356005)(82310400005)(47076005)(36860700001)(40480700001)(8936002)(41300700001)(54906003)(110136005)(316002)(6666004)(4326008)(2616005)(8676002)(82740400003)(44832011)(5660300002)(2906002)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 21:55:56.0303
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 748bef29-c3e2-44bc-9422-08db056842fd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5841
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
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 5e2dfa79f0e4..e51d8be7911c 100644
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

