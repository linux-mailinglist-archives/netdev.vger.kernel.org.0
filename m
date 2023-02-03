Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C38996899B8
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbjBCN3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjBCN3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:29:31 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2060.outbound.protection.outlook.com [40.107.95.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AC39DCA4
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:28:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCoVFzsyPQUgWMsIRSaKB1aIslRc4NeLTPyzP4+eax/RLbpUGTjKQJLbzU7YJ5A3lINRx4gkAfqF89poKr32MhFfVfsrf+39t8icFG/+38D5Qufd53dvfKYfvdpTBEDigXw0quKQdmS0kuP71+Wd00ifrciU2FmzBqCkM9CKyMoimZPXuCf9Qr0F/FkYrP3ccwQLQmJkqC6mobV9ngfXpv/ttj30/GaqHIiusZq8F8FoLpUycsMy9dHq+PvY0q0I6HG037UOUaHvpaohtX7VNnEJNcFJIlxbGQQmrIjj/QnZfQnR4A+fFzOqGQY7YOyXDDWbVnzL1d/1kLdmn6hKdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jCiauWn99ADUgnt49BHQiM1fFhjd6SAs013ftypHSBs=;
 b=E8l19AK9Rxu3LTSq9qYgLqz9+OCE/qOf2oSw+UmuSlzNJB9zpVkdx1OLhbMvqEGud9vBY3+Szjjugw3tMTmgYZqUdrYLKlm9Spo2/ni8aMWyU6yZADvFw4HJAkXZTOkYTQqIwOpouIusLt6No64K8l2mc9NMJMmdQtbHMCjeWPWneiqGe6vhqjpfutcJj5fUxUhNUZkN/MdhqqZT6DRn0TaxTOO20ZUXbudO6ZTeIFBcw7dkzkin3V8GRBMoEZAhSwd8RVEZp+UPFbIrYIYLrYIGbR9SUW4jQuLKnrgr042NGHvvnD5qnk1+ZwmX9nopB10I+5+yxzvs+1PqS2gVFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jCiauWn99ADUgnt49BHQiM1fFhjd6SAs013ftypHSBs=;
 b=irp4UPwtAZmxUr7k8KC0jYfY/qjWpNoChl6ndhKxbze+Lf6JtenDQs6rEG9y/ps/INaCOrKZZYeHmX5U5RRu5MHiF12ck1XxohbmExuhyVQwS5qK/VzCWS/jiyPjtwHZcpE5sDKptE2UAd8lXbIl+zGpC6ikhKBOe79K/TwHalpuSjl7pYFiC1x8wqswMwpzr2bLElHFqAx70h0VmiZkKOg1lnATdBFRkB23sQLWpRi5Cn6bY+h3gXxm0Wm5dZTak6wkbMbZsk+tm3EAZJpgXci0FZWS3AvLzXMadUGL1wd3i9O87Tg9dilDpS2DhKkgXFlAjttBnE4g6ZfarEJmtg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by MW3PR12MB4476.namprd12.prod.outlook.com (2603:10b6:303:2d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 13:28:34 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%4]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 13:28:34 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v11 11/25] nvme-tcp: Add modparam to control the ULP offload enablement
Date:   Fri,  3 Feb 2023 15:26:51 +0200
Message-Id: <20230203132705.627232-12-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230203132705.627232-1-aaptel@nvidia.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0376.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::28) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|MW3PR12MB4476:EE_
X-MS-Office365-Filtering-Correlation-Id: 533f6cba-383f-446f-80ce-08db05ea8cb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F5G45g1zzBD3sV2Mktkctp88tiWFn24PhC2vOKBVQ9Ja/QPJV7D1Ljz69xYvi1zIAI8ncnIgUWPEkLM9LOB5+SAuJQjIguc+5MZb2oSfIPHQoi9U7jrYeTdJLT5q0+kfz0vsmVki58L+1LvpQ13q7YSivbVk6bIF+w9JWES+2QXB1DWLikYgTnl0nVoHAvdAHWEf01wSXWqFnXY1gXe45TME3d975+wp5qSuB2EbYZc6rrYKy2TjJO5TEIC1yBHg6BeZVtc6DCY2D0eb0q03NTsUl5srIAeTWLcj8jVDhY9O5ScsEWTmGSP3C76e4vgMq9hsJtISOQQ4SzwkeUdGE7p4cqKGjk7dvsAMZhD0COTcmrDD5NAAA306Pfl7P0h5OWIv6BaGiRRHetst3jA/auoaeD6WfihbtDlYvQ6MTZbRaaVJbuH4/gKm531OoGY7B6RIyHjDciMNnGXdLTPjzdo73mGRR/pXgQUceSoPubH8l7wA9pDEmg+ADW7CNmqSYl0kGOpsE/8WLvFLMUsecHV4bbcV7ppCf0fBAzzAwiKeapN5rz3OyIB+oaBy6F34Yo489nLhQ4ZugAu11gI0i5PBUeKCy8hh/CbQ7EjlcwmHihASJyJIyJjPBnO5lwMvhcCABmbnnAw6x2nmI/8vJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(451199018)(186003)(6512007)(38100700002)(1076003)(6506007)(83380400001)(36756003)(2906002)(26005)(7416002)(478600001)(6666004)(6486002)(107886003)(86362001)(41300700001)(66476007)(66556008)(8676002)(2616005)(316002)(4326008)(66946007)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eMVP/+iR+y6mnYIoIQNZo+x8xmTIDY94n8BUDNeDnr0Os0AG2yErHFr8T55v?=
 =?us-ascii?Q?eeARD4bIBVT2v2MIX93RLGxAUnzWrRdKuGv9cz2bfPs2U4Bpu9oWQo3zgt7V?=
 =?us-ascii?Q?7asygY8D8cDR0od9fg+m41ulw08mVtBe/JmwyA6hXiYmd2jhYeSbOfXWdRFD?=
 =?us-ascii?Q?zY6C18TIg0CrQwKRQe6N/NMKDgwjZQvfHiX+StsbQHaK476WtHmV78jOuj5f?=
 =?us-ascii?Q?VOyzXmvi9+vcDb9bBXXHr+jlWvfyoo1y+nU7BScs5oKKBz3Sl6ZfO4nlp6l8?=
 =?us-ascii?Q?i/pYP7PFfGc0q77+UzNFwuMKrU+hf/4Creh0CCnTkveoHrDwJXy+ftbe1BCl?=
 =?us-ascii?Q?6JMfkUNKfHcoQdKwTIDgAzerqEKL1kIEYhTB4E3XbEVlO/ldogdmSWhem10P?=
 =?us-ascii?Q?5qL19I1KuRKMXGyFS2IdSQDy+jjtqWt4lfK4ij2m7yBO8yf9GhtrKuqjGz6A?=
 =?us-ascii?Q?7vmBEKIDhErMXND/3KwjS9TgDH2ftaCN+nmVZGDIhLCArV9Bq1TY3JCQb4+x?=
 =?us-ascii?Q?b6LDfpBH96i8jgNDYyAbEhS7MflStKqDG3gvGQHe0KSCxPAufRWDAUm8DjNM?=
 =?us-ascii?Q?RS7c+twm0ij8SJ/hpS8kQRNN4PlIwYpHtC7eHlMWEmUmu7ZCOZFFgSYBdIhn?=
 =?us-ascii?Q?mA7e2bVBHQB1q4ihCBaD5w+b945wdaN3zSYwXnNAwEP9JwP+X8iqbZqlGGic?=
 =?us-ascii?Q?Q1bhrwhpDPKerf0cjGP4P8/GYQQaUbvxUwIqfaflWtT73f3nHZTCsK5KDcpv?=
 =?us-ascii?Q?k5oe090lAj9GEnNT28uotjIws0v/D6WICLuUs3hqP3JR9DUSyLAxp6GsRD2j?=
 =?us-ascii?Q?WpVLJkpGs6+MPBZhhCkWgGZzIZDHKePLxKS4aU/k5RlDrDDLSjEX31xewG69?=
 =?us-ascii?Q?0MsihdzhoMYMTypcbrQ4F0hzjCzN9GDUvMaU0uwftsto+vav2i9Se87op88F?=
 =?us-ascii?Q?f9qtM0qB4M/Wf0nJvAS3Xr0oi7mKnEmFW9aZGwOz4IouALbY/nGAZ1f16vdt?=
 =?us-ascii?Q?M5aKOjwJqXgKGa5+Hty+YZEmV7AbJ6pMh6/AxBH/yxAXLiFiNnMIfR9+kTdc?=
 =?us-ascii?Q?WHCU1ZACe4XyEBoTtpVkVgGsZllz3nEyR+XWW4Bd1gTDWEydWHeQTFq/ofJu?=
 =?us-ascii?Q?GawBoMwdplFFyZq2ifQwvtub+CrXjLgC6byFzyE7G2VXzQEu2XRgazyRCmAS?=
 =?us-ascii?Q?yqzE6cVfWN8JeDAPt9z53CF0+qr6nL79Gyxk8GOksWS/wf0y6Lu8pJYYqUWF?=
 =?us-ascii?Q?zlsJnjhSRmkeYUaEo+Jg2ljA2XVsWe1tan6V0CS2u7u6w3dAiSerJh4Xo5oS?=
 =?us-ascii?Q?S1IBEp0cgU/qz4ispmYeCd4I62xOIbWaWVBR/v62T+gAJrN3IgL9bSCFu9vA?=
 =?us-ascii?Q?fMTeSNMswXKvVhh9joAgmD+zEbpOnqMHiCI3lma/W76KV8cATm71q8VHx3L3?=
 =?us-ascii?Q?YdkOjzVNusaeiAQt+j9A4ICvJR4jXDbtEb76JPCQdnca698e9x3oqCZ76RJD?=
 =?us-ascii?Q?pqki4wZy3hoIJHtHHXtj2nPaM+mq1qRoBq+E8QRUhkNC2kHE0qeTLVNeqthA?=
 =?us-ascii?Q?+siFc31Dj93nWcnzUWNcJeBgMJ2NvQjJ+KANKefy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 533f6cba-383f-446f-80ce-08db05ea8cb0
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 13:28:34.5170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E3EWpE2VI7QIZdpHAhcNY2kNfi1GiG/Ni3fSEWF9OnGxbqYVYrTSx53vnQ7k8y5Ab/DA6fE/LhtOrFyG1oOJPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4476
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
index 732f7636a6fc..77422f49fc76 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -35,6 +35,16 @@ static int so_priority;
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
@@ -317,6 +327,9 @@ static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
 {
 	int ret;
 
+	if (!ulp_offload)
+		return false;
+
 	if (!netdev || !is_netdev_ulp_offload_active(netdev, NULL) ||
 	    !netdev->netdev_ops->ulp_ddp_ops->limits)
 		return false;
@@ -456,6 +469,9 @@ static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 					 netdev->ulp_ddp_caps.active);
 	int ret;
 
+	if (!ulp_offload)
+		return 0;
+
 	config.nvmeotcp.pfv = NVME_TCP_PFV_1_0;
 	config.nvmeotcp.cpda = 0;
 	config.nvmeotcp.dgst =
@@ -510,6 +526,9 @@ static void nvme_tcp_offload_limits(struct nvme_tcp_queue *queue,
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

