Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A70E687304
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 02:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbjBBBai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 20:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjBBBa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 20:30:28 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA486C12E
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 17:30:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axXiigIDRsWqa9Z0NQYiPxr0Ng1srvJfKRmSkfNkmgLGaZNbl0A9KSKlu7AFaoHCUet0TkoAiHXKDOGW/jpZflMBJ8RSA5uQ1RL4UHu2+d7LzXVjX3ojGF8aadLF0FCDP6agskS2ihGdy+g4TvFDugTI66WDFkiatEVHIzPisQrpukOgTv2jSEpqfLLEy38dfG5xhAft2lc9SaGgE2ZKZ1U2taSQDCQX55WR8w5BNoGZAoWlVFcVT2UWgO4T++IPnKxTovqdcHxuWpbGsBSCn4W4irYA2sLWxRR11/nJuyiMiZ5LKQQfHJv9kxxHDSSmAE/mQXyUj7fd7ku/QefilQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7iOgK0xifN66Bqda3t98g47TV9jvi0vuGu6ha5TKx3o=;
 b=eXZJaCV7PU0gqVHoTBwhl3yMVhli74aM5k6MGoqBhqH/DDEYCnZWINWC0m3+3ELLlcWpKucrBRi+Gvu1Vn6XZkwBXfuz23m/uFNeNQ1v7p51uF5sSm3gWBKpM+Yw/tHEFHsjyJH5U5b+e11QeUb47rzqOtyCRVbaNpHODqVrsk5T44++dbUlv8vFr3tlUVWDY3tBp1FaSK2p3dXF+45brMOflU2TLyXXAKgY7K/kE4U3uBYgXhRwsvGDbCTyvDyaled3/KlQL+fLNfDcvKR68AQV03jxKmE07tPxxGj/aClRLSBJFYtim175F2d02LyOVKAF1dZtXGJhN+ldCWtp3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7iOgK0xifN66Bqda3t98g47TV9jvi0vuGu6ha5TKx3o=;
 b=ift1BX0akOFvONYH9gzcmjMu4QI5wWkYS5w/g7o2VGybImPV9oPXJ/yOOntgP+uaXVIbzW42VsTY3/6d3tHU9MWod32tAY55Ujf+fZqgYi+rF1gmxUxVxqEZr9+EZWLwR9IaDs55FKGumbbU6EGZgcgQmfVGTr4trnSjF1BdnAE=
Received: from DS7PR05CA0058.namprd05.prod.outlook.com (2603:10b6:8:2f::11) by
 BL1PR12MB5032.namprd12.prod.outlook.com (2603:10b6:208:30a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Thu, 2 Feb
 2023 01:30:24 +0000
Received: from DS1PEPF0000E632.namprd02.prod.outlook.com
 (2603:10b6:8:2f:cafe::6c) by DS7PR05CA0058.outlook.office365.com
 (2603:10b6:8:2f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25 via Frontend
 Transport; Thu, 2 Feb 2023 01:30:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E632.mail.protection.outlook.com (10.167.17.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.21 via Frontend Transport; Thu, 2 Feb 2023 01:30:23 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 1 Feb
 2023 19:30:21 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Neel Patel <neel.patel@amd.com>,
        Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH net 4/6] ionic: clean interrupt before enabling queue to avoid credit race
Date:   Wed, 1 Feb 2023 17:30:00 -0800
Message-ID: <20230202013002.34358-5-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E632:EE_|BL1PR12MB5032:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b75c1ee-dad4-407a-e7f2-08db04bd0e48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ea174H8JZTebE2lyoX309sFyMR5ozRWmKcAcpKC+op77Rf2Q2iwaD3PkJceuVyLBe974AU/CBLxleZbvEyv6EP0yaldWn4q9DTjVjjhHeRuhwo9tmYzhtaOrySxbjiIn4xcDPVmeKD4m4HLeYTF1qYyJBbYkxgTJ1WHPILL+FwgHJk3bhgsFiQxmX8LMiKDg8fYoL4gAn8TUzC01jHv8oj432T9YpKZY6MjXlbGZRoWR4ZbpnNQ0Ze23qPqBVavYbKFodSI9roXZBqlyWWN3npo7mF2N3WGEfmzy9o5YpYB/6v8JSZJb6R9ThPPEG3gdlEe6f8Fs/CSfmbi5/+h1RNExaY0DOwxnjrUjtXRcnHikBWHYfA2sDfWfISTtlGgHWaVitBMpC6nu24gmCoVqiWOVQSxUjNmuIUY3lrwi+u5rY6e4d1QYQ38G1fgXPcN06Q2vY6qTXcTUlPOuN8RfE2T6dpe52mJ9Rn993EoL+iyBo+9MjiuTl5kn/5LPGNJstAmX4lwMNrACtuyTRrcOQAH88SqMGI1RwOIPSWuvwpDUpZEgiTwtg61Np0nsWUZDTtQT/vpd03Z3SHEtTKQk4Ny0X167vAB3uXF42V0ducelAFLzDeFlDl84WNCs4h8vCOmpcm94sm22MzrBPzTBJbQGwm9eCZAR5W70Dppny5SWv0xYKOreU7AsXOICSQV5yoDhrLVZXgLgnqQJtlqIsxRks7vUut76x1Q6sr/F0mYceHRG709NQV1ucNiJdBCg2grdDGdby/YGKpOPUMjAqw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(5660300002)(44832011)(41300700001)(8936002)(478600001)(36860700001)(4326008)(47076005)(70206006)(70586007)(8676002)(6666004)(26005)(36756003)(1076003)(16526019)(186003)(83380400001)(336012)(110136005)(2616005)(2906002)(82740400003)(40480700001)(40460700003)(86362001)(81166007)(356005)(54906003)(316002)(426003)(82310400005)(210963003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 01:30:23.7264
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b75c1ee-dad4-407a-e7f2-08db04bd0e48
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E632.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5032
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
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index c08d0762212c..90a3ad4a6ea0 100644
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

