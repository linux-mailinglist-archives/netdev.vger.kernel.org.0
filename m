Return-Path: <netdev+bounces-979-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C29C16FBB09
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 00:28:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9581228112B
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 22:28:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79DC2125D9;
	Mon,  8 May 2023 22:27:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615EE1096B;
	Mon,  8 May 2023 22:27:59 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E4A65B6;
	Mon,  8 May 2023 15:27:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIwYvA27LJvXxOTWmfnrR6KR7tqZqK5Aqnm2z8gVAFECmIAyG4lKFQmHlq3ajyA3sPlbCuNWtb6qnsep+gf1sZNLF8F/yxEtIXEJrozFgkOU5wodFDsMIdcve4NHsmh18szlTY2EyVGdIbWSvPKtrjAJERVxKdToMJNELpgagcihOgr7VwdST65it5Lqbv39JuWZsdTGNAea9PUupVis8/d9911phRPNYRT3cb4YGUczMZhmIA1AS5cWaA51OAHscyTopnxLYhEYFGifIaeOGzBxJ2ouPUQSF6u34qWibOiHRAjDYN2QLv5shw0nRb0QrJj9b/feaubJUQOI4/H85w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ennsg2hTxwS0jfu86YisJFXvSchiY6qPDX4BGx03KA=;
 b=CdBjcJY/yRSawyCG+EXhyq3WBvnRfGHiHLXvhKmbBcjzvTPMqNEkYDUu3l3Gf/ySmvxpCpqPPcAcw7EtLgIK/SK/f0AvUMG4llnWGIRbaPZ9uh2pu0whujnHMcRO8a63H1dtInbWOv/XCzQ7JUSsAfaxwl01i64nn+4MMN4SV/47AzQeKcvKogQvpw0KoiHtJzWkvDehzSA+qXLb3JSKb0ZjRCVBxCjArmrJoN5w1+wUYBR+BqlQECs8DQdnKx+/asAaMVVS3o7T3g68bxR//ya7cPfkexC1wILPHHVxABMTOBluZonfTSvbLNPqTV2CSCXOe5KJwgyCIOj9ej+fDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ennsg2hTxwS0jfu86YisJFXvSchiY6qPDX4BGx03KA=;
 b=bZTj5VOLk6wFuXF4UXj3uAZ+qwAABUkozECKIzzfCT59UHIAQ+aWVhVRhQGMZMS7ACabPzvwhr47yhINgs+Pv0YfSxw+sKhLqigozLGoSCOguJU3Xh5Zl5WOFB87tRWiYyvpKcahqNRagZYtD4tY1JwjGT+PWtIc+bjL97OxzXSWwA/4k+eIq25lqJbANSoCDi6Np5kzyjngqRegflMYI9XxkOoArtYDUbEMPre9dc85HqUpYQXPC0ZtHmSBTwuc+d+OtHmaEN4hKJvIeEagN5XavvPG2Kw8djOYfPTbSsk12DOMBwAansNEeFKCUt6E4tEF9QQHbY9Go64aB3bSEA==
Received: from BYAPR06CA0057.namprd06.prod.outlook.com (2603:10b6:a03:14b::34)
 by IA0PR12MB7724.namprd12.prod.outlook.com (2603:10b6:208:430::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 22:27:55 +0000
Received: from CO1NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:14b:cafe::45) by BYAPR06CA0057.outlook.office365.com
 (2603:10b6:a03:14b::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32 via Frontend
 Transport; Mon, 8 May 2023 22:27:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT039.mail.protection.outlook.com (10.13.174.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.33 via Frontend Transport; Mon, 8 May 2023 22:27:53 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 8 May 2023
 15:27:38 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 8 May 2023
 15:27:38 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 8 May
 2023 15:27:36 -0700
From: Feng Liu <feliu@nvidia.com>
To: <virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
CC: Jason Wang <jasowang@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Simon Horman
	<simon.horman@corigine.com>, Bodong Wang <bodong@nvidia.com>, Feng Liu
	<feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net v4] virtio_net: Fix error unwinding of XDP initialization
Date: Mon, 8 May 2023 18:27:08 -0400
Message-ID: <20230508222708.68281-1-feliu@nvidia.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT039:EE_|IA0PR12MB7724:EE_
X-MS-Office365-Filtering-Correlation-Id: b3a7a9a5-a931-4c09-4a48-08db50137727
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	T93VVkd47M4xR6mxBNVfTMFogqGK210nbm2i6Qz+zyQPDQZT7MUexh/Po44zIvmfJBSh+Df9fasbmvlweM2xOC3AJfoTu0Ep0yKvFdXF8cxN4tuXByZqd8UU8nU3qow+uypVA4K81yTN4GNQB+7Ck/lRH8RtZGPceOXVPZNUHqZ9uhINRqcWQMqCBu2aLed93yfh/4El7HPIbDbCHGn06+k4zLmNxUssRIFSn4eWPK3FvxSzVvQv71C9+AePycZ8bf4yNgRlHSlF3vReO11n+BoZoVvf08nx+KC+oURWwx4kiYnV40M5TzbpWnD9V+EzW2MwoUmPDU363jpu7GmlBSMLYBO39BaDUDLxANLmSI/YU7A9IuooksMEYjBJ0upabc0wKXi2eAijCeALkAk97Drx4hBaaiR26dkPa9cwj2yHouYtVXyv6V46+blwBoDeAkwd2KssdiOsmrf/B8MR+lNEevG3D5hz6pQwEIjbjpZ5Bvl/ST7Ubi+m7FML/yRv8Q3pgAmVwVIsaEKKh+o3hs9R3l1NerKQGJnBrMbpHqOyEOCWRdP6Q2CdyzQ5hLvOVs45UOUKmuom9Obbc8HPFg3AD96h17oIttR9mKNBCIEeB8hxS668Zv8IpmxBii5hqxzSvvFPj0id/90YEhI4xa+4QpSIpPcJ4a6+3doM3B/v24FkphKr63BqDqw7EqZRdjtbbAQgiDrCcSDJNjgpNA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199021)(40470700004)(36840700001)(46966006)(36756003)(86362001)(316002)(4326008)(54906003)(7696005)(110136005)(70586007)(6666004)(70206006)(82310400005)(40480700001)(8676002)(5660300002)(478600001)(2906002)(82740400003)(8936002)(7636003)(356005)(41300700001)(36860700001)(186003)(2616005)(1076003)(26005)(107886003)(336012)(83380400001)(426003)(47076005)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 22:27:53.5159
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3a7a9a5-a931-4c09-4a48-08db50137727
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7724
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When initializing XDP in virtnet_open(), some rq xdp initialization
may hit an error causing net device open failed. However, previous
rqs have already initialized XDP and enabled NAPI, which is not the
expected behavior. Need to roll back the previous rq initialization
to avoid leaks in error unwinding of init code.

Also extract helper functions of disable and enable queue pairs.
Use newly introduced disable helper function in error unwinding and
virtnet_close. Use enable helper function in virtnet_open.

Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---

v3 -> v4
feedbacks from Jiri Pirko
- Add symmetric helper function virtnet_enable_qp to enable queues.
- Error handle:  cleanup current queue pair in virtnet_enable_qp,
  and complete the reset queue pairs cleanup in virtnet_open.
- Fix coding style.
feedbacks from Parav Pandit
- Remove redundant debug message and white space.

v2 -> v3
feedbacks from Michael S. Tsirkin
- Remove redundant comment.

v1 -> v2
feedbacks from Michael S. Tsirkin
- squash two patches together.

---
 drivers/net/virtio_net.c | 58 ++++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 17 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8d8038538fc4..df7c08048fa7 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1868,6 +1868,38 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 	return received;
 }
 
+static void virtnet_disable_qp(struct virtnet_info *vi, int qp_index)
+{
+	virtnet_napi_tx_disable(&vi->sq[qp_index].napi);
+	napi_disable(&vi->rq[qp_index].napi);
+	xdp_rxq_info_unreg(&vi->rq[qp_index].xdp_rxq);
+}
+
+static int virtnet_enable_qp(struct virtnet_info *vi, int qp_index)
+{
+	struct net_device *dev = vi->dev;
+	int err;
+
+	err = xdp_rxq_info_reg(&vi->rq[qp_index].xdp_rxq, dev, qp_index,
+			       vi->rq[qp_index].napi.napi_id);
+	if (err < 0)
+		return err;
+
+	err = xdp_rxq_info_reg_mem_model(&vi->rq[qp_index].xdp_rxq,
+					 MEM_TYPE_PAGE_SHARED, NULL);
+	if (err < 0)
+		goto err_xdp_reg_mem_model;
+
+	virtnet_napi_enable(vi->rq[qp_index].vq, &vi->rq[qp_index].napi);
+	virtnet_napi_tx_enable(vi, vi->sq[qp_index].vq, &vi->sq[qp_index].napi);
+
+	return 0;
+
+err_xdp_reg_mem_model:
+	xdp_rxq_info_unreg(&vi->rq[qp_index].xdp_rxq);
+	return err;
+}
+
 static int virtnet_open(struct net_device *dev)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
@@ -1881,22 +1913,17 @@ static int virtnet_open(struct net_device *dev)
 			if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
 				schedule_delayed_work(&vi->refill, 0);
 
-		err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i, vi->rq[i].napi.napi_id);
+		err = virtnet_enable_qp(vi, i);
 		if (err < 0)
-			return err;
-
-		err = xdp_rxq_info_reg_mem_model(&vi->rq[i].xdp_rxq,
-						 MEM_TYPE_PAGE_SHARED, NULL);
-		if (err < 0) {
-			xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
-			return err;
-		}
-
-		virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
-		virtnet_napi_tx_enable(vi, vi->sq[i].vq, &vi->sq[i].napi);
+			goto err_enable_qp;
 	}
 
 	return 0;
+
+err_enable_qp:
+	for (i--; i >= 0; i--)
+		virtnet_disable_qp(vi, i);
+	return err;
 }
 
 static int virtnet_poll_tx(struct napi_struct *napi, int budget)
@@ -2305,11 +2332,8 @@ static int virtnet_close(struct net_device *dev)
 	/* Make sure refill_work doesn't re-enable napi! */
 	cancel_delayed_work_sync(&vi->refill);
 
-	for (i = 0; i < vi->max_queue_pairs; i++) {
-		virtnet_napi_tx_disable(&vi->sq[i].napi);
-		napi_disable(&vi->rq[i].napi);
-		xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
-	}
+	for (i = 0; i < vi->max_queue_pairs; i++)
+		virtnet_disable_qp(vi, i);
 
 	return 0;
 }
-- 
2.37.1 (Apple Git-137.1)


