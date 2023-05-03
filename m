Return-Path: <netdev+bounces-45-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 899846F4E2B
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 02:35:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A823F1C209BB
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 00:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3F467EB;
	Wed,  3 May 2023 00:35:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E77A7E
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 00:35:45 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381021FCD;
	Tue,  2 May 2023 17:35:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AANTvLTGBs3r355bvT5VK80lBlAbE/kj876PHjwiEbq3LJRa0ynXs9p4JhRqZnyenP50riBE14N0m11j/HRWQIrL+5j8hW0/tqfbgsSeZ21CVyD7upj55BIq5HC7lnj4bqHnQNwdps/LwHknL9pUIalbdneEPBdu3qAPR+OcRyhIrAHwABKERCpcQxSyibxCj2xI7lHOXQ4R39Ixr/AfPWHYq3RdSK++Jkjwu2L2ANUitsQ55jx0nCkgN7XzcoLSXYhLOHrwqoR5ikk9vVRVvM0FzU6GohHs5eyNeWALctYOhsAuT9hWuTZmh9688YjfB6n0FDl9tBToUsF6EWQ1Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l0dydVMy2bxhep3iWtB0yQEsLD03CTU3waxBeMKkJoQ=;
 b=Dc8nEWLJtxN/DvANqGaL0AwZbouRRjtY7h/B5IHKpvyDVUB8oP/xzvbzqdVYJyJQSa2ei45OjPL9zdeeyfCS8vcg9VtjEx1zizF7x9WDcNSyrbpJQJ+rD9lcXsV+/kYqqMhCNz0zjVfxOZNdjAFEAAFJZ0kn04VE4zknv9XgOWY/457MHaA98X8vTBFx8+P05fRWuY5eMSh0nRLhW1l+hSvzsmzcQUU+H4r3GCftZ8CkPptJY3IghmVSPvzZ61jtte4WjeG/5buvJbDTaqj9fVbCasJ8Hcfvm1Zrg/ab9qNJN6Os+y04qh682CcI6ve9zfpqYZS8G9hPUygO7/QcwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0dydVMy2bxhep3iWtB0yQEsLD03CTU3waxBeMKkJoQ=;
 b=QiFkCGi9HrVpt5Ooxq2oTGe7Vj8w46V8DdTq5/arizbU+iOaJg3LqAqaq5ANLZ4h0RYF6dYEBysIu8wA6EEjgzeDk/tiNbK3YXa+P1NuiNqaERLc1ryudpzylhVPYN84KgLwFxbuGn+98OHzajgr2uC8r2W4vLN14WGzWqOLQA+78yaAv5CkNYnpohr+RHIW1D1n7wml6GFOKk/GdM1DS4WrwLCzyeuf98+vFeHzqw0zhP8icXJzcRz7w4CNbR0gnrF0qNxO4UZUNLDRSs8Ac12Hg4kAb3ElklRd7UcNiJq1yPbInV1cylH3Ok9bSOb4RmuQIHAPJDt2rWggFAARxQ==
Received: from MW4PR03CA0309.namprd03.prod.outlook.com (2603:10b6:303:dd::14)
 by DS0PR12MB6536.namprd12.prod.outlook.com (2603:10b6:8:d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Wed, 3 May
 2023 00:35:40 +0000
Received: from CO1NAM11FT105.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::a7) by MW4PR03CA0309.outlook.office365.com
 (2603:10b6:303:dd::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.20 via Frontend
 Transport; Wed, 3 May 2023 00:35:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT105.mail.protection.outlook.com (10.13.175.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.20 via Frontend Transport; Wed, 3 May 2023 00:35:40 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 2 May 2023
 17:35:29 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 2 May 2023
 17:35:29 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Tue, 2 May
 2023 17:35:28 -0700
From: Feng Liu <feliu@nvidia.com>
To: <virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
CC: Jason Wang <jasowang@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Simon Horman
	<simon.horman@corigine.com>, Bodong Wang <bodong@nvidia.com>, Feng Liu
	<feliu@nvidia.com>, William Tu <witu@nvidia.com>, Parav Pandit
	<parav@nvidia.com>
Subject: [PATCH net v3] virtio_net: Fix error unwinding of XDP initialization
Date: Tue, 2 May 2023 20:35:25 -0400
Message-ID: <20230503003525.48590-1-feliu@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT105:EE_|DS0PR12MB6536:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cbf5dd2-da67-4970-0b6b-08db4b6e5244
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OhX5DrIOncjBLhtbtHbkqA+qRL7TU08frWIdi/YIl+SP1sCLTmI+10avVNrqC6oL1AVo2JFZijwRVmG2UMqlpMlXnfTw03pDQY2tomfL6NJY7ZEOGIhE3L3IbQhT4tuP0srmeWQ/qLrY747NTwhfR4dE/UIeaXc1LtPTRlCDfpZ6ih9AfzSwlVMXiPTrHDRedHNpOkcZJ9bRqKb1eJrRz70XaVjQ/UGFL3phUsYXnFyZ4CSCHoS0ekRUFq1Jy7gNxrqubRXdcPFc9ETt/sMAU69+PUF/u0z6MEWAiKhj8OmVKlSL2wNMnCaOXi76o6JKVWCNQe+OHU0Jm3kc6K0DZeFHT2vbXjDMENijDFXJuH7c5zXSdKpYRe3TWfYsBvWosl98pCQCEpPh8CWwV6epTAhi3jrbvI9PZTVah8iyErJVvKKoTLOm62KqDh9FYGKJeAB6OISnEYbliUg6Q3F8AGYObr3kWRYabwSu5MQTDhhfKtwabMSHuhmJMCf08HDQ2uoBXBtup8G3dkgsz7AdO+eBY3Bk97PBy0OQQWiCdF2oAXQwOs5BmOV43XXWs/SNAKusv2qg76vpcj023fd3Px82ow2OQzC4azX4mp/ks9TaSG8LmevDGLtLBIoWTNZWHKH7RZZHYI0yPksjNZJNj9TGgcbmhBxUp+m8W4H8ywdqRDdw6M2RYy3Av1k/Khb1R1I4bLSl6SI40Eafe1dcyA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199021)(40470700004)(46966006)(36840700001)(86362001)(36756003)(82740400003)(356005)(7636003)(36860700001)(336012)(426003)(2616005)(47076005)(40460700003)(107886003)(1076003)(26005)(83380400001)(186003)(6666004)(110136005)(7696005)(478600001)(82310400005)(54906003)(70206006)(4326008)(8936002)(316002)(41300700001)(5660300002)(2906002)(70586007)(40480700001)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 00:35:40.0796
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cbf5dd2-da67-4970-0b6b-08db4b6e5244
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT105.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6536
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When initializing XDP in virtnet_open(), some rq xdp initialization
may hit an error causing net device open failed. However, previous
rqs have already initialized XDP and enabled NAPI, which is not the
expected behavior. Need to roll back the previous rq initialization
to avoid leaks in error unwinding of init code.

Also extract a helper function of disable queue pairs, and use newly
introduced helper function in error unwinding and virtnet_close;

Issue: 3383038
Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: William Tu <witu@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Change-Id: Ib4c6a97cb7b837cfa484c593dd43a435c47ea68f
---
 drivers/net/virtio_net.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8d8038538fc4..3737cf120cb7 100644
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
@@ -1883,20 +1890,26 @@ static int virtnet_open(struct net_device *dev)
 
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
+err_xdp_reg_mem_model:
+	xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
+err_xdp_info_reg:
+	for (i = i - 1; i >= 0; i--)
+		virtnet_disable_qp(vi, i);
+
+	return err;
 }
 
 static int virtnet_poll_tx(struct napi_struct *napi, int budget)
@@ -2305,11 +2318,8 @@ static int virtnet_close(struct net_device *dev)
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


