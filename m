Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D946F20F7
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 00:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346852AbjD1WiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 18:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346828AbjD1WiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 18:38:03 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20608.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662E959DA;
        Fri, 28 Apr 2023 15:37:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exKd0P5m7/vAa2SphfFBgnkCd9vLi4H6A8xgoSDzUDMViH5deTKLIAwVXZ+drr9A2yazaR/5K7f8h8H32wMlTdNTtnao87O8SvZV2Pq5uB53GXy960KBIWGAiIvDt6dPCcmUMmS8sSV9dly0o15zOu4aHPfKO28zye2bvMzo9He+UoWmjMWKByPmH2ueWcJWaOup2bXX84/MVFoYcbsBUrb6Jquuv5MumE2KSx49ICi4W2TOd6keVNzgzkQePffhRg5gqsz2rugm10XiGclS9fsQxlqcaMrCOTxgFTwy++UkaAs7jJJaLO1ItmFczIzF+QbNIL0o7TeWHQfepCNKmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VGqIbEi2Dws6Nh8Vb+4WJHJUjlwhkBjvy701pGKlw/Y=;
 b=gnknoyfoYebAwMtda0CtPduykvIXka52pFj8/SiCiR7+BFSU/qOdz5HtPEmt8s1aVDLdkC+jhnCqOof+hw8BkEabtsBtBZ5dU3b1/eJdqsg5Aa23L5TBRnnkUU4kds+44ZIqeZo1Whr3zkidNNtbNnhlQzxa08Y2R/A1WR+RKVwmitBneHnOFCGXmx8QsVEaOaRXOHWmJYh9qSu0u2Ay1yyl4Z+8meVl2BQ/g5OYkytbScPKutsjgrHbTEDotLtw8nqmfcw8PAmB8tZ0KWOybgRdA8t/NHOGUt781DF4Hyl1ibETGwUNHNrjn5ZDP/o6RNeJLeJRYja5wNvJSthzoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VGqIbEi2Dws6Nh8Vb+4WJHJUjlwhkBjvy701pGKlw/Y=;
 b=QNa+1K80vxNTqopGuc5Yr4opAcTuTHmJHoHkiVKJje2FKeAxXqKRWg7WuGaxZPN8o8zFeZIdpoUJ5DQafckY3jycM/T3yq9gexgcZs2p/N2gTIESF4ENh5JCXTEX80XM1y7Sh03IVDFeP5edgwLOhMx7xIfAV65rWbxG1GYWPi7n2GlyAUgwz0VSQaBbg82y9MWYcSYgzGGrvN0v7+5lKZDd6fmtpIJPcx4aw9LTKjaBeFi06vemQNzU6ZZ++7rzh8ri4qAROHRP1ooONHlpVU7nSVJimS06JJeXWauVVKAL9sIkao+4uSlqc0xGYESBJTgspDCjUKdy/WEGfFQ4IQ==
Received: from MW4PR03CA0279.namprd03.prod.outlook.com (2603:10b6:303:b5::14)
 by MW6PR12MB8960.namprd12.prod.outlook.com (2603:10b6:303:23e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 22:37:44 +0000
Received: from CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::c7) by MW4PR03CA0279.outlook.office365.com
 (2603:10b6:303:b5::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.24 via Frontend
 Transport; Fri, 28 Apr 2023 22:37:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT045.mail.protection.outlook.com (10.13.175.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.25 via Frontend Transport; Fri, 28 Apr 2023 22:37:44 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 28 Apr 2023
 15:37:32 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 28 Apr
 2023 15:37:32 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Fri, 28 Apr
 2023 15:37:30 -0700
From:   Feng Liu <feliu@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Feng Liu <feliu@nvidia.com>, "William Tu" <witu@nvidia.com>,
        Parav Pandit <parav@nvidia.com>
Subject: [PATCH net v1 1/2] virtio_net: Fix error unwinding of XDP initialization
Date:   Fri, 28 Apr 2023 18:37:12 -0400
Message-ID: <20230428223712.67499-1-feliu@nvidia.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT045:EE_|MW6PR12MB8960:EE_
X-MS-Office365-Filtering-Correlation-Id: 630cbd54-b5d5-4e8a-6938-08db48392f18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eaAbERAKqri5HWQIh+4/VIRY5eYP/FGkVZflHVbICQR8c/UhOLQ+g0SSkY49OnEFQAujfGMtna+Z6/FdxKKGQ3QZQMaP1r3SYGTbrOkijvcU1aioB74SwJMjLlyv77jQZOlDVGijHS+S4H8CaqPbLp8NNVj34AZepFXz5exHa4ptqZaBD3ZOM7M3zIW0WHV6JtLPjD5vBCiO2YsFE+hc0Ws7Yt6gSCGyEbC5h+bZZ0npbovvevyIfjq+Rw2aCm3kuswsHyy7eCkSliK4MOM8LWfuI9Y6a1l4WG+JS2uEGDxsW3uRsJCXfJRRx+iObo7hHsyapJxZFVm1AsC95K+iDD6sTtwUK+XPrkIB0xddHRIDEtKTeIWPQL1lGjvgQr60KEeL9drKYikhknvVMVwBqX5Wkm/LAOnPttzYpHOEljRGQa6LM+kwnka8Faxy5NuQK1wbQZcFnOoYHmvz+qkiw7xKsTEPH+OYf4sgSLBmBiBpJ9PliRqAQIdeGCoep+Hzh/NDoy/w0OyXxtskiSa+MIksNf9Fhcdi1MPwvippJOTNZWc6FK9hwZ9FIG8f5MqM0kod6tCTsDKKxrca5e+H+rzDcZbJ7uERcth86CvbQsub44E81T2SFbfBimVjJzT5QSo6ea5McZVKm6GYMQW3wxOFpl12D6jbpLKPZ4zMaAzYXdITMhi2fpy2K/vaxrW/KnXHCQhX09iejy3RdChf0w==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(346002)(396003)(451199021)(40470700004)(36840700001)(46966006)(1076003)(26005)(40460700003)(186003)(54906003)(110136005)(478600001)(82310400005)(8676002)(7696005)(5660300002)(6666004)(36756003)(8936002)(2906002)(82740400003)(41300700001)(70206006)(4326008)(86362001)(316002)(70586007)(7636003)(356005)(107886003)(40480700001)(2616005)(83380400001)(336012)(426003)(36860700001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 22:37:44.2271
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 630cbd54-b5d5-4e8a-6938-08db48392f18
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8960
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When initializing XDP in virtnet_open(), some rq xdp initialization
may hit an error causing net device open failed. However, previous
rqs have already initialized XDP and enabled NAPI, which is not the
expected behavior. Need to roll back the previous rq initialization
to avoid leaks in error unwinding of init code.

Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: William Tu <witu@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
---
 drivers/net/virtio_net.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8d8038538fc4..fc6ee833a09f 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1868,6 +1868,13 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 	return received;
 }
 
+static void virtnet_disable_qp(struct virtnet_info *vi, int qp_index)
+{
+	virtnet_napi_tx_disable(&vi->sq[qp_index].napi);
+	napi_disable(&vi->rq[qp_index].napi);
+	xdp_rxq_info_unreg(&vi->rq[qp_index].xdp_rxq);
+}
+
 static int virtnet_open(struct net_device *dev)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
@@ -1883,20 +1890,27 @@ static int virtnet_open(struct net_device *dev)
 
 		err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i, vi->rq[i].napi.napi_id);
 		if (err < 0)
-			return err;
+			goto err_xdp_info_reg;
 
 		err = xdp_rxq_info_reg_mem_model(&vi->rq[i].xdp_rxq,
 						 MEM_TYPE_PAGE_SHARED, NULL);
-		if (err < 0) {
-			xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
-			return err;
-		}
+		if (err < 0)
+			goto err_xdp_reg_mem_model;
 
 		virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
 		virtnet_napi_tx_enable(vi, vi->sq[i].vq, &vi->sq[i].napi);
 	}
 
 	return 0;
+
+	/* error unwinding of xdp init */
+err_xdp_reg_mem_model:
+	xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
+err_xdp_info_reg:
+	for (i = i - 1; i >= 0; i--)
+		virtnet_disable_qp(vi, i);
+
+	return err;
 }
 
 static int virtnet_poll_tx(struct napi_struct *napi, int budget)
-- 
2.37.1 (Apple Git-137.1)

