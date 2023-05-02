Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2C16F493D
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 19:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbjEBRlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 13:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234437AbjEBRlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 13:41:51 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CBDC3;
        Tue,  2 May 2023 10:41:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZjdbYef3cgFU0YHr1dWl+MqSPmVqHredtckBMo1gA86gGvDE+4UNySQwPHhqqwkDRSPAM3R0ZrdI4giphpu9MAL8dGeNBHSGTmTxmeRKv+yKXHk3J6bLXmv6HCOykt2ui2+cNVwCeg4i39Z6PBpSQjImwkUCxitBFSSsoDhFWmbAnMALK4B128z4zqd/rWAplML0DnGSxLpH3iLXY7M42NA+49X/Q3vzCDEYVW/X7Ay00ikq1cGM3jbWF4M4dGmcz5QUKjon8yUIaTk+S0MugbdaAURcSYd2eg7rZewihFEItuVdlZVOdNi/NjzTDr39dY5FDqnVyONmdEwbtZxpWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Y68f86rlg26ncTi7MRdWfYxV6CtPY4Le/9FCMH5Q44=;
 b=A/W+a2Oiyb+Kx+ga6UGR2qBMtT8w13d0UZblQigugEqJTicO/VDHPqwz7vw62RabFcJpioZezXCO0qqeo5OH6SvH00cjM8oeYtucohLDvyk8UTqwpfkN7c3zR92XCYvSHBdbEijW9Y1/8wLtIEN8W2TW8O33Bd0IqtyjhuOMj3sUF899gnRpxcvC2WA1Vpsjed45w0a6VRVIHnSO2S6PApFEB8ZnUPS1WwByT1lhZeNj6hPJQ298Gpl9zBXBrRJ4rmqcFj0kRWUSu2NWI/ari8lMu5xmNAbzfQPFTs1mxTtKkti+Iy7UGQQmIieBNw4CtHsiIoh85fFWsG3uX78Ayg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Y68f86rlg26ncTi7MRdWfYxV6CtPY4Le/9FCMH5Q44=;
 b=YE7o2+Ff5qnEq8OoGUfegrsPXXdL6mdX2jJaNqYgM8YnNOfsHRD1hkqyIWpsPvlE+VZFqSe9TXK158381teJtVh6lGd7q2xWtTnboj1qMejXIGAbI7gZo++R5usrGdQCP37Ep/J6gVeXbU0yvOkem8eK4QpLRkb5FcCjSBtFUwLg6kFy40P49JRY69u84KLjtoZzmKZMALA3tsLVMfsnG2ismV7oGS6Z2aEndIaxLtc3DgjwOd+mfn9haQXF39neUXTViD8Q6T66zW5b4VuoqGLUzQGJ8indirNy75ReoUO/QyLg504dprih5kjy+nkCNguRbjaHz7PYfbFd05iZ5w==
Received: from BN8PR03CA0016.namprd03.prod.outlook.com (2603:10b6:408:94::29)
 by BN9PR12MB5147.namprd12.prod.outlook.com (2603:10b6:408:118::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 17:41:47 +0000
Received: from BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:94:cafe::94) by BN8PR03CA0016.outlook.office365.com
 (2603:10b6:408:94::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.20 via Frontend
 Transport; Tue, 2 May 2023 17:41:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT048.mail.protection.outlook.com (10.13.177.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.21 via Frontend Transport; Tue, 2 May 2023 17:41:47 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 2 May 2023
 10:41:38 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 2 May 2023 10:41:37 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Tue, 2 May
 2023 10:41:36 -0700
From:   Feng Liu <feliu@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Simon Horman <simon.horman@corigine.com>,
        Feng Liu <feliu@nvidia.com>, William Tu <witu@nvidia.com>,
        Parav Pandit <parav@nvidia.com>
Subject: [PATCH net v2] virtio_net: Fix error unwinding of XDP initialization
Date:   Tue, 2 May 2023 13:41:34 -0400
Message-ID: <20230502174134.32276-1-feliu@nvidia.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT048:EE_|BN9PR12MB5147:EE_
X-MS-Office365-Filtering-Correlation-Id: e0eb4fc4-2250-446c-aaea-08db4b3480c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tBnGmMjTOo+1tWu6gNwV22XwORnesxGLcpZWSN05XRpIK3RMvOa6s6gvU+654urDx5qs6OtEEvdMV99xzOV3a0Hl56HMkVYnKJf2cSnBjC13b99z56HTeIFmux0RHkJ/ogM8DQ0oAeU3kmaghOARwXGEenkaYiWK7YAIkJsPvyM+CV36p4FHits6L9KOw8VMzcZyGLJQ5RvdE+knO9sTV0JdmDi0gN9eIjpSrwOoiOOUkPLRXLg56kcHyEh2n/4MeBumOF+EqmuaA35DR1/VsBhR7CifjJBl/W00ycH95WhQaHSHavgZolFfiA4Br7DPM6sHwhyPEf5fkIy/Wdd/iEWOG37vimeawViuUcrJnI0CnrUfUnkQrtmkofUiUKW2iTSlokQBGfamTdYefVe4vy+PxqLVebc9d7+HIZxMp8aZWdYRyhkoRssSdFngBwJvG0Pq1YUSXRdQsWgJAzcYnQdYGQ8+D+dwxnTcfWv5g0TT/L12uILcFOXewStofYag4A9QrzR82c0PcNkRtX21HYq2T77Nf810uIDcjw8bC1Defwq+hULZWfFD5JNGnb4qYEH/GZ5fCvf2tXCxNUrkVArquggFjtUqOR/7j8EzB5x5B4nrg85l9OGqtcIbFTQLi0XTs/avDyFZlFYnSuNNO6GDdev3HB3Pn4NfyJyvT+/F4iXgP6s1ZJ7qj/1tIqM8aH/Ew2i3ssvOCVC2GlQdsg==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199021)(40470700004)(46966006)(36840700001)(82740400003)(186003)(7636003)(356005)(1076003)(26005)(107886003)(36860700001)(47076005)(2616005)(336012)(83380400001)(426003)(5660300002)(8676002)(8936002)(82310400005)(2906002)(36756003)(40460700003)(40480700001)(110136005)(86362001)(54906003)(478600001)(7696005)(316002)(41300700001)(70586007)(4326008)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 17:41:47.1821
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0eb4fc4-2250-446c-aaea-08db4b3480c7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5147
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

Also extract a helper function of disable queue pairs, and use newly
introduced helper function in error unwinding and virtnet_close;

Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: William Tu <witu@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8d8038538fc4..5cd78e154d14 100644
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
@@ -2305,11 +2319,8 @@ static int virtnet_close(struct net_device *dev)
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

