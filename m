Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87A0605C20
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbiJTKVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiJTKUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:20:41 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07079BC614
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:20:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DEUCVmAhg+qIgX+vf91cjo1TnvnoPBMEhAm2ceAIjXfAjr3/o+hvINofLviYJ9ZhWHfUDnDY584UelWClqjq6UWlPPtCMcT6wqk8iaHUYMUv3nYg8vbRLdqpUN/x9jpxOgjovIlwzmOKCFvwSJih8q+bPjO/GepyoiWb5my9m2qoi/StYLm/dBE2wKoiDNbsJGelFAZctCsaM/fqZS4+RUPLHLr4CjiBOriDeEC6HS/vE3sZ0zrt6eRngKETGt9EeAdjzfB2ipFp+qvUZvj61fGnzht/RoLMgsaeoX6cEH/f+x6vZv3/k46tEqahO6NXhmhqeYQyIXUjmjWNkbWUSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PvIIjdH9a7Ez6xzAn4xpP4+gXwzcAvz0P1WnG+5sMCo=;
 b=K8OKHyq1mPJdXmTsHMP1EblOMZQCaDQLPlgj65Z5tRAFZBB2dlhcYmh3b4UIebFLL3zyYFixZTOcsCS+AOjV4YZeAEiu8Q2ETGGVjEQbzu1Iu3ZPispQEFYbXUX0sdko8y/5qF/3BBLtEHfebuSbj5jTF3LdnXUI6Ln6EcxVY5/eX/T0OIieEo78CVd+lLBB8kRsWixV4MbeiLgpg4jAasYyaPzrHRUqu4QlnUzpkZJ6uU4Wh7cN+5CP8T5iujv08P/gnwTmEQHvZSYEILCYWi0xpI74fNhymLJEqRWn0BGUCtDIhgioWBm+Z29nFilbkPD3ppQhDtTcgz5gE/yt5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PvIIjdH9a7Ez6xzAn4xpP4+gXwzcAvz0P1WnG+5sMCo=;
 b=PPBcm9sXWshtCIGJp/wa4p3x0i13kdXUPuzxzccjSNo6P8JlRJLrJGZKPCZQVHiMj5l2s6u0TWTCKQHxopIuMhGyhTfAc7NquUsd7Vbg4F9gKwGtSGu5sOvZXWqPQXUZiROYkilzp4OyKLa0bd0xzLVAFgAz+x8m1e5coHYLCcUAwl0qG59wuP/+XTrRNrBBozk9BnkDZr+jR4jcG0HMtFHyX2sAUxoXs4kEa1l71NhnLPC8OIPzr9CbSwZ0nOMwIiOfEC0MS/qE/yt1tYqCItIHXTQ7jhdNlak5+WKAr5A2y8YJMeGxtTIhXI1/wXoieSw9FUuFxjxYmta1t76FRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5133.namprd12.prod.outlook.com (2603:10b6:5:390::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Thu, 20 Oct
 2022 10:19:32 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088%3]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 10:19:32 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v6 08/23] nvme-tcp: Deal with netdevice DOWN events
Date:   Thu, 20 Oct 2022 13:18:23 +0300
Message-Id: <20221020101838.2712846-9-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221020101838.2712846-1-aaptel@nvidia.com>
References: <20221020101838.2712846-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0010.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::22) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5133:EE_
X-MS-Office365-Filtering-Correlation-Id: 701457eb-b151-4c73-ff5e-08dab2849446
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VDdbNZ+DknEhpi6jro1d1AQTp98dsoZqKxxgx9Tm1p303U9NkFtGCSoXEUyLnwshMm24pj9atdtxdZqgkDiUcUMTU8Ndy8Ul/arJc7TLFmjBcFg5/mpXHZoQVOAxMAZ0cu1oSrxg2bZ7YV+Wq36qpU/S3/0pPxeSX9ekvOBXjKbkGBcK7bBJgKdWiC8XE//AQXDiYqTd2SOerPnIyNi5CP4RHKMdPWYkB1+aTAmt72cbZ75mmwqBwVds0p546exzGhz+Z4CYlAPjda0vEpe2GFayQBoR35jCc8ZJi0KD1jV9Gmdmx0J6aIlbbDZu4EZ2xVPERkH0dKp4v4mx8jSQx1r36mWCHvpWCLJDg5Nbn1q3mtmvprVogRX3Ax77ZOmFffubxwsn9sWbOmX5Lg8/WyPps2pRUuZNN2jxl3r69Dw4wfHwMIrd6tuAufKdQPn8JpfYyazJZFKCho+XNs6lxmfgWnQGX4HZwBUZicNXx8Av1vWRF2uAWDVxfT7ALyNis16x/RCPfPt89toeoa6V0Ds1E75Mlaa2Lx1CBhA28TLjgpn4isC3SAESLTWLfaU2DfdDvY22zFnwZ5ORoezt95ZrbluslkTimxPfPCA3bmWYXyF23Bf5mmln/wSZv/DMDvlWuz2upGvQxcCu3WClFcjy3J1mMwl+F5al9u6P0Mys04pmMMTx5kp19KrcU8P/CqfL6SHo+PHXBn1qyc03GsIJxyEY7K3UZOyhK32UhoClc9YliKXqX2X94PDXGoL9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(451199015)(6506007)(6512007)(26005)(4326008)(86362001)(2906002)(921005)(8936002)(7416002)(5660300002)(36756003)(41300700001)(66476007)(8676002)(66556008)(38100700002)(83380400001)(66946007)(316002)(6486002)(6636002)(186003)(2616005)(1076003)(6666004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HAMp3SiI9Kl6MIhdfGaFGQIXT82SZsZvRjtLJaqP85F+zPRKnYeaRnq8tUqJ?=
 =?us-ascii?Q?Rf+zZLfuUa2v1zh08Ju4B4TkS5+w8VIbiYoB6FBkxIfDKN5z8vvSb+aibS+7?=
 =?us-ascii?Q?yxFc6OFnL6S2jjzpWUWdnVmlXKxfwgVpg1W3gLRm2gE5ST2wf5crOujqdKVI?=
 =?us-ascii?Q?Z6j6RuyxWAxNUQjhrpRQipM9B5Mu8DiPx2Gl9EOL0CBOWpHvhQJWlXhlhzys?=
 =?us-ascii?Q?Vx6WRvRR9mf863ZEbLvmrOQoSG0X5Y/5o19BIBFKs5zdE/LYWZbap/Kln0B/?=
 =?us-ascii?Q?vuEQPo8TUXwWIU4xs+yHi05cot/dyVP8OcXUysj9ebqsW7PMF124xJ0Tqh1S?=
 =?us-ascii?Q?fUAm2zhOfCGEdwAicdfDC3yk5XTXYxX7H4C8m3hY+RW0H4bPxmI3CnA9A20/?=
 =?us-ascii?Q?axgK8s+f0mgvWJOWiuf01avx+zKJEIt89e/xrsxLANdFPqzphSgpyZmdfWO0?=
 =?us-ascii?Q?Fm5BRWSh2al/l8IkalQ5s0kPPTqeuamQTEyLnokiE02mqU75PDdxdaGjrZtf?=
 =?us-ascii?Q?SIbwbHz1OTCA1D/JRi8xQd5CLqsM037Mzp/hdbamehAuEf0NjNDoJpNtIFPf?=
 =?us-ascii?Q?/KrKFO/1RQwh5ybOZaOUzVLf9TiCdgqXWV1egSjIPdCY4VHWHwqbC3Gmlp6H?=
 =?us-ascii?Q?copQ26U/4qXTghRNRsrhMXFEc+yliwafYTlFZQoQ8qEjThL0IJx47K+fO5lo?=
 =?us-ascii?Q?8+8Gmj0Pyw5O2YvHpUrl8a3hxFk7GBJ6qHuoasihDtq4oY5Po6L5LskLY6W8?=
 =?us-ascii?Q?aJZwotzWiLHx2EoJExkuEmfU4jBHgs2o0FfI3/cRWcshVUnHajr1zKo3Ym5Q?=
 =?us-ascii?Q?v53sVmt9qskkkJQLPijGZXDLn4AbXoaXaYCu2nfWhU9mLsEQt5wLncOWYpCx?=
 =?us-ascii?Q?0zVJ0YsumEggIO9xUCpL3CVgBcOLMYQvKI/BQtKmBH37jo1dcbktVqbKp1oo?=
 =?us-ascii?Q?d6e8h5WHr2UzbmLDxFlznpmR7Se8q3T48hV3AeUzCvfVbCzIqzvVrHsgA9ZG?=
 =?us-ascii?Q?5QuqAE3E9g2fHnijVfyxQiVsl8xv+rAcwX10QrVUIPNGkcB5GUmdFd3iTpF6?=
 =?us-ascii?Q?Z+l1a3Q7xqql1KiFpQNekSRxidGZxTyQJMsiyH6rRnbz6AIgqQDbNxUdc1bT?=
 =?us-ascii?Q?oe4SqZKX/CXEE1e6M4Z5As6DZXIVFePfXrE+anF//sU6PMHkJ8NFvRKKsqzj?=
 =?us-ascii?Q?SAe4+VEsNNEKbve64xpZkGW4H1pyKme/d6jWG937dTBkpfUIYmXNUg7JL191?=
 =?us-ascii?Q?HDpWHziESY0kAnlevI51kHZ+2iz+FbDONpSGPylkOyiXM999EARFPdhtdxKF?=
 =?us-ascii?Q?aSnFUptm2L4m5NQrT25bPSaIXRo6x1ZkaM7K+PmidnsqXW5OQJK13IR2WO/2?=
 =?us-ascii?Q?Oq4srZHtYgwTqw6I6WAm6gcKv9j8oxQOdFi+Nbt+UJfnLL53BNnd1Jpo0hy5?=
 =?us-ascii?Q?gDWWIniXmogInqEvhOmhyVhh/1bJJnBKq8/rIW50gIPm/QeLX+tPwcKkaeDw?=
 =?us-ascii?Q?FhGsuS9q2kiMBcszzCGY2E0T5JnUEzKpHcpjpmec4oQxckrh2CgHjefTdqXC?=
 =?us-ascii?Q?txtpwfH7Kq/ffDm6STkb8yuPUoX8qPJVO+4GEgMP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 701457eb-b151-4c73-ff5e-08dab2849446
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 10:19:32.0705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 78PeQOSgjI2yU+myRDMlMoXhgsu5JYXJK8BM1c/M4gtHN/a07wD9So/vBX+hmJHv+gLwYrybbW6LjhuM0Nn//g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5133
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Or Gerlitz <ogerlitz@nvidia.com>

For ddp setup/teardown and resync, the offloading logic
uses HW resources at the NIC driver such as SQ and CQ.

These resources are destroyed when the netdevice does down
and hence we must stop using them before the NIC driver
destroys them.

Use netdevice notifier for that matter -- offloaded connections
are stopped before the stack continues to call the NIC driver
close ndo.

We use the existing recovery flow which has the advantage
of resuming the offload once the connection is re-set.

This also buys us proper handling for the UNREGISTER event
b/c our offloading starts in the UP state, and down is always
there between up to unregister.

Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/host/tcp.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 76aed532186c..11d9197f59ab 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -203,6 +203,7 @@ struct nvme_tcp_ctrl {
 
 static LIST_HEAD(nvme_tcp_ctrl_list);
 static DEFINE_MUTEX(nvme_tcp_ctrl_mutex);
+static struct notifier_block nvme_tcp_netdevice_nb;
 static struct workqueue_struct *nvme_tcp_wq;
 static const struct blk_mq_ops nvme_tcp_mq_ops;
 static const struct blk_mq_ops nvme_tcp_admin_mq_ops;
@@ -3097,6 +3098,30 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
 	return ERR_PTR(ret);
 }
 
+static int nvme_tcp_netdev_event(struct notifier_block *this,
+				 unsigned long event, void *ptr)
+{
+	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
+	struct nvme_tcp_ctrl *ctrl;
+
+	switch (event) {
+	case NETDEV_GOING_DOWN:
+		mutex_lock(&nvme_tcp_ctrl_mutex);
+		list_for_each_entry(ctrl, &nvme_tcp_ctrl_list, list) {
+			if (ndev != ctrl->offloading_netdev)
+				continue;
+			nvme_tcp_error_recovery(&ctrl->ctrl);
+		}
+		mutex_unlock(&nvme_tcp_ctrl_mutex);
+		flush_workqueue(nvme_reset_wq);
+		/*
+		 * The associated controllers teardown has completed, ddp contexts
+		 * were also torn down so we should be safe to continue...
+		 */
+	}
+	return NOTIFY_DONE;
+}
+
 static struct nvmf_transport_ops nvme_tcp_transport = {
 	.name		= "tcp",
 	.module		= THIS_MODULE,
@@ -3111,13 +3136,26 @@ static struct nvmf_transport_ops nvme_tcp_transport = {
 
 static int __init nvme_tcp_init_module(void)
 {
+	int ret;
+
 	nvme_tcp_wq = alloc_workqueue("nvme_tcp_wq",
 			WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
 	if (!nvme_tcp_wq)
 		return -ENOMEM;
 
+	nvme_tcp_netdevice_nb.notifier_call = nvme_tcp_netdev_event;
+	ret = register_netdevice_notifier(&nvme_tcp_netdevice_nb);
+	if (ret) {
+		pr_err("failed to register netdev notifier\n");
+		goto out_free_workqueue;
+	}
+
 	nvmf_register_transport(&nvme_tcp_transport);
 	return 0;
+
+out_free_workqueue:
+	destroy_workqueue(nvme_tcp_wq);
+	return ret;
 }
 
 static void __exit nvme_tcp_cleanup_module(void)
@@ -3125,6 +3163,7 @@ static void __exit nvme_tcp_cleanup_module(void)
 	struct nvme_tcp_ctrl *ctrl;
 
 	nvmf_unregister_transport(&nvme_tcp_transport);
+	unregister_netdevice_notifier(&nvme_tcp_netdevice_nb);
 
 	mutex_lock(&nvme_tcp_ctrl_mutex);
 	list_for_each_entry(ctrl, &nvme_tcp_ctrl_list, list)
-- 
2.31.1

