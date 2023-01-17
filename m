Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB49D66E26C
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbjAQPjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbjAQPhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:37:24 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFF215553
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:37:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HipBy3PXA/T9ydwVQG3q78d31D0Udh0INrdmmpOKGnAhJLt0fWJmJ4y/+ecCrIgzjK2sjtkn4jHmyV+mJ+DS17hA6c528kbXXazejC4muvv5taDXJ7ibeG8rVcChrU1csUUdfyNoA2rTZVS1tapaAX8145oGWv5SEE4b2j32bEpz8ZplzPqJYYfJXweHJ55WMv4b2PgkGNqkjaWL5byBvNXvcw+eo4E5y7fW5mTu3D1LaxmEXBTM7ZuKGzaSNFFPlETuYdT1+jwvLHC6qWTZxN+kbMGkf4qVh7JpKGSJeA0m7Vi7c9IcCvd3M11kZrtPO+pCZRa7Qe1MIzQmSInGrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LiGJvShpJ03jwrUL4wbBrlyWonI94aW5RvDE9YAEQg4=;
 b=cbVZVSnmIu6Y2dmhMQ4l+czSAd+ovNyvZ1oajkcSKVJjAsaRh4+EsHsP3IcZFhbAhwp9fLSFZyAKdtdL4F/JvkURt/XmzjmIna1wlqVc9PNJs7bZWfRZ1Q1gRxcFEYW34thg7O+NSSmU9pGQoEM7qQk5gijyfec4vyTRts7u9dYSfmzkoPlEvXVfFHvj00czdzzlTm0ef7I2pMavp2yufGyLhZE6CBYWHc2aK9m+BHGkSVX+3ddlLsCCln0qbwIqxQVqgoo4JtlLEixvEdvkCHkN4Y326W4JsJUSI3HPwokyxm5429D+KaFlIEnoErtq5miAKd5Jrnr3B9RbKXF98g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LiGJvShpJ03jwrUL4wbBrlyWonI94aW5RvDE9YAEQg4=;
 b=utjjfl4/SpHHUt6ayQxwHpggIQIzXj5K5fQFrfrDAj+IWJfkoCOmRxZty8cO5nVHItuoGpssASVdkZAFnZuyGD6hieICyboX/z3WXCiR6Nekfq3O0mC3raxLjLeUjnuKkcM6aT5pptbLC8RExqDTcrQX5tydoslb8+NARuhQk0fhCiPSjpmZm0GrfcoyWdcNx3xyQkAHxGLxLWYxSPW9mOirEjMJR4iZt+slc8IofJSuLPtF7CY8qitRhcJRya5iQQKkgH/P0xJZ1iQAucu+cA3IL4Vh2S1ChOthYv3QyqUJLEUvSGmZ8hmCzBrjCvtZ1FhYi63cDaSowMuazBqbDQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH7PR12MB8177.namprd12.prod.outlook.com (2603:10b6:510:2b4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 15:37:12 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 15:37:12 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v9 11/25] nvme-tcp: Add modparam to control the ULP offload enablement
Date:   Tue, 17 Jan 2023 17:35:21 +0200
Message-Id: <20230117153535.1945554-12-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230117153535.1945554-1-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0449.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::29) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH7PR12MB8177:EE_
X-MS-Office365-Filtering-Correlation-Id: ea125200-16fd-4ea2-b786-08daf8a0b3d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YMDHdR3Ikh8ISYgNyAkJvNImxsNzypOPZCOcVrSh6i60ZjgM9WHvd0qX3wAPGlw41bwIvxbbZJwyJvj9MuZELk4Znwjmt16qoamGdL62zm3kSrETUr36KR1HnMkNqvAMuiKTOc37iQGA/J4bzGC5o2BspCdgLvGh10e3nP3hRBN+KDi5V2N1IO+PS1wnhEbnnulci4AOhlRtH9ADfCnaOqpE6kQOK3sOM0N9L9sAC5X3RJ+Ltjxjpw7WgDDR/ADJbvi3AkLeHb34vyOOxctKsbqpj4fEsQKl/YroITqVkyW594ItIBvt4O91ezuM2hhPx6Hqln5y3gZuohngsZI8slw5yfs3fV5GX5WtJ/bTMUwDM45JdG0BeY9B6y0UvXyMDmzb6kK+qmTUoQc/pzF3qQps2Em5Bn/0bmda/sjmiFuTRlLZOiKdKHgVF6qZYKEcQc14BMe+dzfvygu+Go2VONcgWzOJgwgbMyLwE0xzZnLI9bkTyCarql5UX1RBYGhWNaOPJKDfgDEjNn7cR7gIR++t+lJA+rB3eY7ND1KwaHhOqMg0C4N2ngBwess2VHbuEU/L8ta44thPWJTKpDrEreBDHc5AeIDhROvoeaaj3/xFm+JG0l8oW17rmKS7svxyQF7UIDi8IjqyQ+iWVeeckw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199015)(83380400001)(1076003)(186003)(6512007)(26005)(2906002)(86362001)(8676002)(66946007)(66476007)(8936002)(6486002)(66556008)(6506007)(38100700002)(6666004)(478600001)(36756003)(107886003)(5660300002)(316002)(2616005)(41300700001)(4326008)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hSJnwznsfa7FOIsQlnnkslu3qVi50Kt+otvLzZgGTuLsLE3JJ5O9kJnM9AtP?=
 =?us-ascii?Q?3KQR4A3pbPQVRImA0i0O+y9CKf1+9mIH9715e8SMm8o3tIGTpoOMG81x42ZD?=
 =?us-ascii?Q?yZvG465cyK/hKfc7m89HbZnWimF03h+D3u1kyNwA6nT3+eCYmuU7i0dTLO0A?=
 =?us-ascii?Q?0Bpb3PU0dLtdvM7LDvqJTqq5QPtOuvtlsW7FD5C6ZHdt+yAmqASe0sEvCJTy?=
 =?us-ascii?Q?Tk8HN01HIjxoRSmo49ZMbnKuqF8rJ2w/CKb9Quh+0QTSQ9xJkBFGNWliFdU7?=
 =?us-ascii?Q?RGIGEIisA3WT+/P7lHtTQHdetRdwaOpRU4qGqoI0cDUoWWNItn1SZntyt86c?=
 =?us-ascii?Q?k/NjffoGiUr8WMDeekI/UjS08mgYf2GahyeV7cDKBZBnepLJ14INbo22l+4T?=
 =?us-ascii?Q?WVFRnT1cv6U5KIr+HDThUAXIm80KiZL7oRJetM1hJjpWHTUUvhL8Bf86f0rO?=
 =?us-ascii?Q?vlZNQJ3YHiA2ck4btj7SZoY6M3mv6f4Xeb62mvZyJVXett8VlpCwJweYiXi2?=
 =?us-ascii?Q?2ut/HTlkyxG2CeOKCvV/+jrySo607gCY5LlAm7qbhev8V4v9tpP7w222tW22?=
 =?us-ascii?Q?36W1QCos8hfh9Cnp9Ctol+SUL3HHmVmsUWyltKQSxQxu+zO5SIEAIwj5L/jz?=
 =?us-ascii?Q?7ghjA5mT2l0nKO8ayMiyYuiBZNVEG0whZxr586PjE0YmTAcPLAkhPPt+vGEJ?=
 =?us-ascii?Q?CtjVLqkLQuW1Kq2QNCuAk8F7sWIpIUXwve3byWhT7+Ahg5MqTDO6mvuTbBHZ?=
 =?us-ascii?Q?2pgkf+O43ZuLG6HCKiIMvaG9D6pCtUC0xeU8ffU1G+uTSibUA1aV9SiMW18p?=
 =?us-ascii?Q?JVrRBd3pL9ervvGus+kV/79zQQ0DOto7aNHjiYqfyXRHzpXXaj5B/UfZzNEB?=
 =?us-ascii?Q?tLnbAwEkRSPZkUsaEtVEcPa0s7AsSOyGEukLIrC933/lMSwsV5DErrnkQLJO?=
 =?us-ascii?Q?GmrdQvwrpyhAE35Ua2NQTnC0xptJdYxIQhSgVbnGBcSNLtcVteDlj0dTomCV?=
 =?us-ascii?Q?30X2tmJ6DTILDZ0EAsJ3Q2koHlYnnsJjU9aHdwLvCUYEkJb/gI6cU77SIJgt?=
 =?us-ascii?Q?kteGLlTH9/8O+T7pso2DOCJiCGngQV9e5X7rgFhZan6Casfr2LRSXs3MSlJw?=
 =?us-ascii?Q?NlgMZEIltuEhBK2eUmFOPxp/9jwg/W/7F2HDmdKzigEgLK1gj5VZ+pvujQgX?=
 =?us-ascii?Q?crv0dbwxAXlRVPujjQEDBQmpiyC6UH4KHDwlQdUUzf4EC2HMRH4u+th9YBOv?=
 =?us-ascii?Q?oTnomQpaHWQb0jifKMCO+m0F7xf4CbwCLf1LEsP/Z//VxooMw4BRdC5oO31h?=
 =?us-ascii?Q?ldSVI+10/gVCJ7bT0hRDN+dTRcI/BGSvSmExUGCKjsHX4On7UeHMpYIYtgUE?=
 =?us-ascii?Q?Ns2pzYordffseD5dY0QwfZPY+0sMwiBDiw5mqwIMfnW0XlYrp5mMFIPMtNwf?=
 =?us-ascii?Q?DQbA5hwa5u/3nK7/pFv5uBIgUzaf/FT3Jt5oJGiLp9ZH2IwaEpfK9pvpteAA?=
 =?us-ascii?Q?C0M0ERRoKFRXgYf16pclfbnwkNR8mgezPIScV16qC5Z5dvtpU0bw3HPxtcdV?=
 =?us-ascii?Q?1fdF+HIc796AEl/OKHUQ7VDDMg6ExuPfi6+6xU/4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea125200-16fd-4ea2-b786-08daf8a0b3d2
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:37:12.3451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ITtcpnqGNdLxLZlqI2OggN0zX1aHOofhUL7U+c1WogwvUK8EA1xDmxaXWSx9Nf6xXniltIV7oPYY1T79xsI7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8177
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
index 8b1ebbdcda8e..3d7bf5136b5a 100644
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
@@ -316,6 +326,9 @@ static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
 {
 	int ret;
 
+	if (!ulp_offload)
+		return false;
+
 	if (!netdev || !is_netdev_ulp_offload_active(netdev, NULL) ||
 	    !netdev->netdev_ops->ulp_ddp_ops->limits)
 		return false;
@@ -455,6 +468,9 @@ static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 					 netdev->ulp_ddp_caps.active);
 	int ret;
 
+	if (!ulp_offload)
+		return 0;
+
 	config.nvmeotcp.pfv = NVME_TCP_PFV_1_0;
 	config.nvmeotcp.cpda = 0;
 	config.nvmeotcp.dgst =
@@ -509,6 +525,9 @@ static void nvme_tcp_offload_limits(struct nvme_tcp_queue *queue,
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

