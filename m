Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38286DB73F
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 01:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjDGXhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 19:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjDGXhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 19:37:06 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2051.outbound.protection.outlook.com [40.107.244.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37398E1A9
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 16:37:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Crnjs/vLJVR3Io6gsMM+AnffwqNw02PSNDbLpP8DOOZchlKG6e9q7jPkEQGUtIfta4pe5bxngVebK6howFN9+vFHqqo4daFOPQUiMXWfTs8eae78eefPI7G9zB/0AZOFbPLtba57EC4cYvqyvvbHOFUf6qknjkCzGDXkfvTbSgUKW9ApBaX5j6MDx9UeN3skdBhTbChKyHU31DKaRBmbR01va0Oge7VwpZluQ/MhdDSQCMkJReI9yYnhgLTuVTSSHEMMZJQdycSu+noP3eONmcor024lliCf9VDFckY4cmSu+1v3wKSpe8WY5XAKoNVvpWA7TNB6vboyPVlkgI05XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xO8SOk5PJ/tGQzqJB84n2OhXaj8JZLgTdco1yWZodQg=;
 b=M3Ybf8PmzbxrNWmYlpqQq499wcQ9Okxoyviifs9viOurUopRz/eOUW33asM94PSS4Q3YIIkPOh3jZc4vVxbPDO+TUtBEh8fPrL4J790RtcTPgALT5i1rfJW9mZEddIqZ4JPQRfGhehmIamPDsg40X3CGqJQzoYC6C+D5E4nSpcqk0e40Xu4bbA4sZdlQW/xeb7W0+hstxU3rR8150TNR0cB1se+PT9d6a3VUqVP4S94cXkqibsGZawkXJJSx+KB/0hJfFbaCpiXyVFoAGcUBOKk1rRt3m04LY0ypIfdYalM96KLOJma0GfGkBtQbxOD5B1NpHjfFhH8xOt0IxoSY3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xO8SOk5PJ/tGQzqJB84n2OhXaj8JZLgTdco1yWZodQg=;
 b=q1xHC/jE9r5IwM2BMq4Hxr70Evo8M6OBT6tayC4JZoHBj9sfpsfAUnbw6DkauJw7EiEnnujlV2iKL5sH+oGPhPnA4GEB9Y5VO3omUHn4SBci/Hlv+ihQLWBYGjxU3k7/r/fJLksHyL8kPMI2K3qr4UOCbSRvhXxkAz7LbdjnYis=
Received: from MW2PR2101CA0036.namprd21.prod.outlook.com (2603:10b6:302:1::49)
 by LV2PR12MB5773.namprd12.prod.outlook.com (2603:10b6:408:17b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Fri, 7 Apr
 2023 23:36:59 +0000
Received: from CO1NAM11FT072.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::cd) by MW2PR2101CA0036.outlook.office365.com
 (2603:10b6:302:1::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.18 via Frontend
 Transport; Fri, 7 Apr 2023 23:36:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT072.mail.protection.outlook.com (10.13.174.106) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.21 via Frontend Transport; Fri, 7 Apr 2023 23:36:58 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 18:36:56 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <shannon.nelson@amd.com>,
        <brett.creeley@amd.com>, <neel.patel@amd.com>
Subject: [PATCH net] ionic: Fix allocation of q/cq info structures from device local node
Date:   Fri, 7 Apr 2023 16:36:45 -0700
Message-ID: <20230407233645.35561-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT072:EE_|LV2PR12MB5773:EE_
X-MS-Office365-Filtering-Correlation-Id: 4010c9ca-ace7-45d6-77d3-08db37c0fab7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HC7y0lT90+6SQAyvJUjszd29CL6BO2bOfr8sO6RzoJDDeNFV6Q6FABJgYEcuCoJMOfAKny9sBvdI1e216s7GMQVJ+VZYXMxfzia5OwMlbMZKdMrVw1K0KRPuoBkXzM8kIL9fQd8/xpsxCroZG+kL3d2X5jgzyE0rbPi6/1MOWPDTUdny9TwUCP0FR2tV/+89A2iKHgrFNM7GviMX5ACznfjYK7UHBgbVsDGH2xzcV0Jv5FU/emYlqqDIiI98/3/ffSbfKyqLH4Bly0l4I0QBpZ2admEyhRMJvUCtrF81mvqhbWHgAbuMoBP/YcYAgd3j/pHfgvBqNIWqVpUSbaVFXsgoJ6qH4OfWkRgfcOgDedN/lBWebDzTz7faiZ/fGCBfGMGOM/uvqfbxZvItDwmz00eoEAWCY/TlDu2ai6jt3CzRNcuP56LQC05VqEMaejljElG0MVshgyL6uSvnGNcbhlHhrXjgf1mfoIKYN4WN9PSr/nbKnkeF6iUBZq+Szrt10sXaa6oSolU+8uw6zk3comMQtCU06/FnlEWV9hWy3ValZ4Z8cEgdhoZNfNU2tNSWTKTFCrUDuinBr7SPOtnPboObUCCE77+7iNH/QrV8S+7xMBlVNLFv9TgILJnlrtz7eSqv6Fckkxw9zAqTVxh8mqXbk9yGwl7xRePiauZ+vDbx0Z2Vn2AMf/m8e7XvXofUa2jpluAizVGbHQjjjXbRxgHSIGmp593sNb6TqhnEESg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(346002)(376002)(136003)(451199021)(46966006)(36840700001)(40470700004)(47076005)(70586007)(40460700003)(36756003)(356005)(426003)(8676002)(81166007)(2906002)(40480700001)(44832011)(70206006)(8936002)(4326008)(82740400003)(82310400005)(41300700001)(336012)(6666004)(26005)(36860700001)(86362001)(83380400001)(110136005)(478600001)(54906003)(16526019)(186003)(2616005)(5660300002)(316002)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 23:36:58.1071
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4010c9ca-ace7-45d6-77d3-08db37c0fab7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT072.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5773
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 116dce0ff047 ("ionic: Use vzalloc for large per-queue related
buffers") made a change to relieve memory pressure by making use of
vzalloc() due to the structures not requiring DMA mapping. However,
it overlooked that these structures are used in the fast path of the
driver and allocations on the non-local node could cause performance
degredation. Fix this by first attempting to use vzalloc_node()
using the device's local node and if that fails try again with
vzalloc().

Fixes: 116dce0ff047 ("ionic: Use vzalloc for large per-queue related buffers")
Signed-off-by: Neel Patel <neel.patel@amd.com>
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 24 ++++++++++++-------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 957027e546b3..2c4e226b8cf1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -560,11 +560,15 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 	new->q.dev = dev;
 	new->flags = flags;
 
-	new->q.info = vzalloc(num_descs * sizeof(*new->q.info));
+	new->q.info = vzalloc_node(num_descs * sizeof(*new->q.info),
+				   dev_to_node(dev));
 	if (!new->q.info) {
-		netdev_err(lif->netdev, "Cannot allocate queue info\n");
-		err = -ENOMEM;
-		goto err_out_free_qcq;
+		new->q.info = vzalloc(num_descs * sizeof(*new->q.info));
+		if (!new->q.info) {
+			netdev_err(lif->netdev, "Cannot allocate queue info\n");
+			err = -ENOMEM;
+			goto err_out_free_qcq;
+		}
 	}
 
 	new->q.type = type;
@@ -581,11 +585,15 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 	if (err)
 		goto err_out;
 
-	new->cq.info = vzalloc(num_descs * sizeof(*new->cq.info));
+	new->cq.info = vzalloc_node(num_descs * sizeof(*new->cq.info),
+				    dev_to_node(dev));
 	if (!new->cq.info) {
-		netdev_err(lif->netdev, "Cannot allocate completion queue info\n");
-		err = -ENOMEM;
-		goto err_out_free_irq;
+		new->cq.info = vzalloc(num_descs * sizeof(*new->cq.info));
+		if (!new->cq.info) {
+			netdev_err(lif->netdev, "Cannot allocate completion queue info\n");
+			err = -ENOMEM;
+			goto err_out_free_irq;
+		}
 	}
 
 	err = ionic_cq_init(lif, &new->cq, &new->intr, num_descs, cq_desc_size);
-- 
2.17.1

