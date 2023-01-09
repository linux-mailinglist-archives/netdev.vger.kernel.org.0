Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6193662728
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236620AbjAINdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236966AbjAINci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:32:38 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EEA1EEDE
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:32:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YxXi5TViZNkmWjbfKTZBEXPy9p+EC+X02ometo8qmOgPe2CroU45ggp+IiweFtp4dpTksGb5mO5fPllPSW6FXRrk2aMJ+Yr/wMxD8qD8gufEFIFVosN8hahtJ+sIMm8rrfHMShPoMpsO+Pa+5vW+aTcjvXBBjfduoU4IakrTNaIsagC6yPtjwGfLrlsvmO9/Fmh/QgqVOZoB5QvByaPYMVzQR6gz6SCaiEmtZw7+cr434Mgui67cb9QUMgeCFo/3hcu2j8FB4Hxuof7XjHJKxFkj1G6YzUUUE7yPiCdncLOsEHe7pfF2ws5QjHlKhtOV7afATo6JGEfVG2P+JV4eAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aHB2D/qQJMDSC7Hh/9lXum4hZJkuDMih95zxy4hryPo=;
 b=OhOgKP4i17pIYhloZXp66gq4fBOto1L0XItFMbZCOh3zwYyX4Gwf4F18JyAoSZtUYjxWHX3PIandZGRJ62dzO0unMaCPjXfSgbATNntX7UPy5MX9bugpNCF2PoWNrifgsXdUfwrV3eSlNGpI+jobqYjpB+l0bSF0GPPDmQ+HO/cBHs2TMm1snDzx4VKojcbDmZ9KyO11LUbN5+1GnJzejwXba7iyr0iGN4SZGqSw5di6ob8gkzhQTqkPxHcGJ3SncBikXHTyG5JBHnSl8CvOuXW+aW3SeRBcApLG7NQmt+6m2q5SOx8Ja8Td07vMP4JPLtVRTKFYEx1I6LIjCFURjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aHB2D/qQJMDSC7Hh/9lXum4hZJkuDMih95zxy4hryPo=;
 b=pwoSIozE4WzGCH1kwlU/Z3+dE6IMYjjr/1y45QhpPcBOwRtiD8vzZ61ZxDgdaETXkl2VxrIrBn9rKfY1oo146269ccko2OcuOJngqD95+o7vnBGqzg0XWqYbsmjwSNlyxZwk2ZrwUGnrMriLBUym2Y3U4lbRwvAw33xj/z8AZt9jNKw6ALanftH3KdEe5qu5iJDtXwCkBKgYx5XcAbiJ9gGy77MTpPBughT8mZMuUrTmakur5hVYIpSl/BLmu+vMnn6Y9DVoI9bEF96KmHYLv1R7ADV9ArsGLH9epJumTEZ6C3oktVgQY/6IGLVtgitKXdvASByEwkEzOtURsFrBuw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5056.namprd12.prod.outlook.com (2603:10b6:5:38b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 13:32:36 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:32:36 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v8 11/25] nvme-tcp: Add modparam to control the ULP offload enablement
Date:   Mon,  9 Jan 2023 15:31:02 +0200
Message-Id: <20230109133116.20801-12-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230109133116.20801-1-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0580.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::16) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5056:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b5b8070-a784-4d2b-2dea-08daf245f87a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WwzJmgz1/dEz/+LWSi55lSzxQWXKwTdZV1yT8JGvvZKT8+gtufCJKxvdVvXCkNGls/tnpGYUagxgrS/yxgJarChUkWb2t/G/yAiAhBIFi4ROL1RMBSZOjgXpo9BnqjrYVIqK3Gb34fkLE5ZghBCCluvVATdm7cpfSS3LL0oF8e8tr51AVmY/LWOwuXGU0PJj5rodSgQd6H1vIzLCj+dVd9pt1llYe39S6YfEskrnTxV903zFDwXcGEmDQmNfh9gMwuzc4xM0PwpOzxq6si7zAzs8YjOT6Hs/MRN0OHUFgduIUqH+ZjTRD0x3j9kCU8e6s6IJr4o164aryudfvZZHcJWxFXpCdRxfBx2fpw1+ZR1+FoGpy8IMi4m+zpiq4zwRpcj44UU1bwjg1Wbs9kHc1TWvpDrXBsX5ocKmlfeamH8ZId61Bgh8IXAwa5twNfA1ICts0dOTHbJrQ4ab/B1w/C3rI/QVGE5DolrJE0gPrLVgMHscRvKKF+euPVS6NSteRHZ2GVboKB+P+eTaw+bu3bhQfWfaiD26eNH9GJNpcRIqZuz4lZqxASP8TugxxM9Mv5KZI64BLPM0WS2ZzChtmEYBlCMyiFR5vnL+cKcnOXZZxIDx8u8vCjlH1KDFFwflbzyYJFlQZOFkgyQ5IWH1lQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(451199015)(2906002)(83380400001)(1076003)(2616005)(66476007)(7416002)(66556008)(5660300002)(66946007)(6666004)(107886003)(26005)(186003)(36756003)(8936002)(6506007)(6512007)(478600001)(38100700002)(8676002)(41300700001)(6486002)(86362001)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XqXTB5YjaGrBeuNKjN2FeBGNyIwq/Ouyrlhau1zJH1UO0BVWUL4TQ31NuPn2?=
 =?us-ascii?Q?TeYMFgQgGm6qsXnpabjgJwBmYWbiUiDHdn7fLKqQLVCy8mIL0ENawcKpBM08?=
 =?us-ascii?Q?NGaGG4NsP8DmwxrS97PBMQRXZ1GbGeyjbRnOleHz1OFECESpVy34FALbqGMO?=
 =?us-ascii?Q?uXpQpbdrjGGdo3Ry8LVf5D8YwnjGZ1bSSgRcFDfJ9cpQlEOJA6x+177FZuTp?=
 =?us-ascii?Q?FjHFy/r77M3dGp4bOEIJQ9p3gWUFUa2+HhFbSQZc8n8TKhgTurK6EFN+A8TW?=
 =?us-ascii?Q?2CKfvXwOYy/rZl4e/U2N7w7rbe3RrwD+z+P8pUpS7+vxIhdfLMFjwwKzrRCC?=
 =?us-ascii?Q?cpJIJWI78xOY/VzLATwVEyN+mKFxum4xQFhRFKkaGGJJ2unSNZS9d+rtSsOh?=
 =?us-ascii?Q?mWbGSEx8BXREisBYjWZn4WNfFwppYyyLCoaGyQgIUYiBPZKbfYntj03aOMD0?=
 =?us-ascii?Q?NbRi4VnmDaL5oAXezggVds+uEAiZFmJKjGHI8O66/8SY8fsY3hORrvCqt+CE?=
 =?us-ascii?Q?xqidJ299GR/M52GGB29nMYbdH8xWDhjCLm0Ra9QXEtqje1gFyDL/+07Cqzff?=
 =?us-ascii?Q?kFBpdWL0CJGBOpBjJZ1sTodGRpHbzr+cG44xcD/WeGF9Bh076vLh5o3xn6IW?=
 =?us-ascii?Q?GdeynPIfE/lhhreJRGiBzod6do9bpZWxu/EqPCyyFU8K2M7E4B0fx630Fhdk?=
 =?us-ascii?Q?7DqF0tRMm5JmOS3PapWHoC0swM0BJLiRdPZqx4ptAmyVJobCAXp+EFwJv+dN?=
 =?us-ascii?Q?6Aw1HbPtuIfMmPRxjpI+ErFNN5MUncZRu5CrFe8IgxEHMcPB8+fOvWH56B0M?=
 =?us-ascii?Q?8UeNUUm/okIrrxARMvtJX7qqui21ut+h6oyKE0KqXc1Tlqi1YpF5QPqrLvDY?=
 =?us-ascii?Q?dTXlnDNYpoqhtlSuh0XnNALaxDcDr97bmkOP3QNB3msOThSUDnr2Red6eF7E?=
 =?us-ascii?Q?e822VMqBVQlFgo9GCXhwN7D/60Uf2Ab0Wkrt82rNUvJkzOxfuktoqFNtH1LE?=
 =?us-ascii?Q?tYZMDC0LpvQvI7oGT9BttKvusEVs3t4Xf5JwyhmaTWVmo6BK/DeLjvxPJ2s4?=
 =?us-ascii?Q?YhN5qzI4T12+KTH5H9asm6NYQF5EyhLhoCunN1GruML2XwaiLzsc/qdJXWHk?=
 =?us-ascii?Q?7fPat4ciqdvWTUAFtnzesCzOeptxzm7zVhSj2oj87COxMtL5T0qbEs4pUCGK?=
 =?us-ascii?Q?OyWnYJuclwJUuPxFdhMbmuN+hwnUvCU/UYHJf0mMUxn78FD0yMBUkoG6Xdp3?=
 =?us-ascii?Q?tafFqXE6rIuUQ9nhXUeNlTt2cP2LWg9ORqoVTzvddtJ9AFYF4P3uCJ8vuPZN?=
 =?us-ascii?Q?noTATAL2VvNANvlqMc24L1alvr7WYKNOnqCSZ+BOkDBI5c3SZ4+MzBBXF+Bk?=
 =?us-ascii?Q?ZgsxW86LFoSU856FDSACUlzq3QwqjQUYmQQjnX3FFTd5yP6oE01lFxYS1NnJ?=
 =?us-ascii?Q?DkquABurWot1D3mCazRD1VXGQ1cD2awKjx4l/Gi6FyiF2W1wRZXDEZcfu98K?=
 =?us-ascii?Q?3RgjgmaQoP7AKEdW6ef3gtsBHwqrs4TIUsbgdMqJ/k3tk9Y9afOsswokUuTq?=
 =?us-ascii?Q?UbssxTrDZM1ux8LBoIfFCqYgU4+BQejv8tg5aIQb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b5b8070-a784-4d2b-2dea-08daf245f87a
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:32:36.2706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: my5lb4i01Ds423K1VLEaVHkmmKW/BJkwkyuC4ey/VvAqDUsIdevUc1OfujsL4N6Oii3r7pBMAc6fvcmPZXcIGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5056
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ulp_offload module parameter to the nvme-tcp module to control
ULP offload at the NVMe-TCP layer.

Turn ULP offload off be default, regardless of the NIC driver support.

Overall, in order to enable ULP offload:
- nvme-tcp ulp_offload modparam must be set to 1
- netdev->ulp_ddp_caps.active must have ULP_DDP_C_NVME_TCP and/or
  ULP_DDP_C_NVME_TCP_DDGST_RX capabilities flag set.

Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
---
 drivers/nvme/host/tcp.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 52e0db53d067..1ce9de41a2f5 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -34,6 +34,16 @@ static int so_priority;
 module_param(so_priority, int, 0644);
 MODULE_PARM_DESC(so_priority, "nvme tcp socket optimize priority");
 
+#ifdef CONFIG_ULP_DDP
+/* NVMeTCP direct data placement and data digest offload will not
+ * happen if this parameter false (default), regardless of what the
+ * underlying netdev capabilities are.
+ */
+static bool ulp_offload;
+module_param(ulp_offload, bool, 0644);
+MODULE_PARM_DESC(ulp_offload, "Enable or disable NVMeTCP ULP support");
+#endif
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 /* lockdep can detect a circular dependency of the form
  *   sk_lock -> mmap_lock (page fault) -> fs locks -> sk_lock
@@ -315,6 +325,9 @@ static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
 {
 	int ret;
 
+	if (!ulp_offload)
+		return false;
+
 	if (!netdev || !is_netdev_ulp_offload_active(netdev, NULL) ||
 	    !netdev->netdev_ops->ulp_ddp_ops->ulp_ddp_limits)
 		return false;
@@ -453,6 +466,9 @@ static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 					 netdev->ulp_ddp_caps.active);
 	int ret;
 
+	if (!ulp_offload)
+		return 0;
+
 	config.nvmeotcp.pfv = NVME_TCP_PFV_1_0;
 	config.nvmeotcp.cpda = 0;
 	config.nvmeotcp.dgst = queue->hdr_digest ? NVME_TCP_HDR_DIGEST_ENABLE : 0;
@@ -504,6 +520,9 @@ static void nvme_tcp_offload_limits(struct nvme_tcp_queue *queue, struct net_dev
 {
 	struct ulp_ddp_limits limits = {.type = ULP_DDP_NVME };
 
+	if (!ulp_offload)
+		return;
+
 	if (!nvme_tcp_ddp_query_limits(netdev, &limits)) {
 		queue->ctrl->offloading_netdev = NULL;
 		return;
-- 
2.31.1

