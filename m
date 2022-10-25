Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22AF60CE4A
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiJYOEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbiJYODo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:03:44 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2087.outbound.protection.outlook.com [40.107.95.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D295196097
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:01:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W7m4K+n3YTOnaiI9IhY2mdGWh+XPlC2bL2dVFIEgXiGcZGH5901GBOr8yrlW2Nc1rRTSIIfQQj7iaSPsmpPOzQ1xYb5GRY/MCTpXh/iGsD6g1JKV+VJZ6hzBUZCPNG+FKYAYlUokrCwsrh12J5sVnf0k/XRQefK82ClyHE16AgKG7HLNuf4Ayesug5UNlJgksVXXT/5y4CHu2ClUKAhcjHrexPNH7BnCZhCTsvheyn0jAQRjys77df5WbaKVccSzm8iHXTQdQeOXTWExT49Vndj+rtOUuQCRAbfV2+MsVnFEX+DCkbKnCDVYlwqbIatR+jUuu0fvy1nhFNYLO8sPvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zNDIscZ7F2lsxc2BNTO6nxpU7ZwfDs+k/KK3GXWo1YI=;
 b=gouQ4tKvqX4gdkAW1z5xgAOvrPckoXDInARztU8FVX2v1xQe/PXj4acPuKjD/5jqJh0QHVRb70pTRxv4x5EZyMJuUiacBEBpk+snHbWfiQB1i0B/Pj9tdSKCTnngG8uu9bG3ed3Jw+uHjACqIY07pGFH/AQOgzJfEDhnuDVlsSXQKdbSHL+a4m3w9zYXXkBQYtu91LaTto81que7kYu2bT/8n1O6UCSBsjEHTrSrQwcAAOb48ZegWOuxnEQdsgz9WZeNvtKRW6hHt+e9i0Lgyzo/KKQ/T6f6xQiu4SIEBAwrNlCovqDkqLr9EFl4zAJrRSReyyOr4M0RfmgafSXUPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNDIscZ7F2lsxc2BNTO6nxpU7ZwfDs+k/KK3GXWo1YI=;
 b=K3lmuCmt/fU8l4euB95tuf241ZgvAslsf7NqRb0b6qdhW39RjkV/sRWLzDHRYZWxu+x+wNcrfGJcu2AeTM4/VMZFL9D4va/EYYn2CmI8uP03m2gLr3/EnJe765BK905dlKxMENrd4IZyt7EQErpi2dCzqQT4ZPM7ahCr1RCQFqjgimS8j24rKv7aWQ2xOwhR9pFseiTEltP4ClFUt9vcfemwIzq/JgY30GuwJD/tcSw8Ktq2gqxGX3Ty17P7EQtD4NovRM+99qputUGm0bOYVJXCibB+3SdXqpuKsqcCbp/7BXW+vUHI6krcrjkLfy1DNFpWYYj31fmPpo6+GvkaZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by BL3PR12MB6521.namprd12.prod.outlook.com (2603:10b6:208:3bd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Tue, 25 Oct
 2022 14:00:54 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871%3]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 14:00:53 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v7 08/23] nvme-tcp: Deal with netdevice DOWN events
Date:   Tue, 25 Oct 2022 16:59:43 +0300
Message-Id: <20221025135958.6242-9-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221025135958.6242-1-aaptel@nvidia.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0165.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::10) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|BL3PR12MB6521:EE_
X-MS-Office365-Filtering-Correlation-Id: fe1a3a93-25fc-446a-f7d5-08dab69154dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IVkckBP3h/fLKq04VNEMpT+iDLXE1x1Qvv8Ea0nenIXYF4K43/4tqsZ6VluF25NgBuMa6rs0r81jXnzeInWVMj9rWVLgbI/M9H+N5xZgPWxsdN6n6BODl0hVy1ZUv/r+H1rs7F9oqw1MaT3O7iMr03z1jTyq+BCuRb5gxXYyF6NGZALz9J7US6CoswIti64qBAlRrndec/PsGVpYAIOcO9YGeTRLDPtaA+kTh+3Gkzsj2r7PW5ZRzeuIyQz/IPf6fNOL2DHjyZXO0Xw3J0Uw6xV8ox/cuC6Yr0pSiORgCTVal0PRvU3K25NPSmtzvtYZO7KbDK9816g1lliQEALmi83kCCE3vfyD/q7f8x1ephknlxOZgasB/rdaXDbTchFgEd163h08J0heuUNP9w/tu98nwgguTIUgyltx5aGPncJ0HlUdsDiaMMrMqOhyLC2MlLmVCFY6m1FUmXVL/GaFIIiXWvholaz5tDP7hL1FmHZkp9zDEGN4DOYjQjj898rrfZYlIvDmpdnnqDctIsEwDuSY2mcqlzJUhqZKt0eD6Buf7nB88AC8R9AL/2BlU2jvDwroVP3FdDy11Fu0cy5vMxfFEQmO9LV09RlvOpevm9SRRgq8sYbsCjaV/VGxbczHOCyy1S9weN0obV4OmNzEwBhs6HRCv9trJ15Gf2rhU2SwHLlDhHQa4SY5pYRQwzn6H2ieVH9tds4XjK67mRmRgGA8HW3KH3ZDaXz6Ay9UBDs6EMeRd+CWlgCHuQ0Pqsbd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199015)(921005)(83380400001)(1076003)(186003)(2616005)(86362001)(38100700002)(2906002)(41300700001)(8936002)(5660300002)(478600001)(7416002)(26005)(6506007)(6666004)(6486002)(4326008)(8676002)(66556008)(66476007)(316002)(6636002)(66946007)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NN5o0Aj0Wnhk3ktbOJ3N5TbPeerjSsi9BElz2aIu5Ouxi6RnzT7cLWD26uin?=
 =?us-ascii?Q?yZdWF73nY9OlVU/jvACG1It1ciwdbVlzVVlZXo/o74Y1fA0wZip/uDuMEzvy?=
 =?us-ascii?Q?TydKyVcGUXwhB+Lhc8KTJf3P/S5UgLfz8DkIv1xqSqmUdixCgdszV/bOXQxG?=
 =?us-ascii?Q?q/an7TGRd6PzUvaEWuRzNQjfO8Pr6fDs1lgFiZ29ILZNK96jEBQfT7G5vqnL?=
 =?us-ascii?Q?jewd0OMZoN1e0SyMAu9yah8o649LfIuG07viGZ9Ze4RSNtJ4GlfFhLO3elL+?=
 =?us-ascii?Q?Cs4jpgXtVaoj0l4O6g9N6vZiFzrgwBnwuVHKVqQ9T85RF7Aybz2VFbHzf3cU?=
 =?us-ascii?Q?nd0TuXHKa60DdLmIDsojCiW6xe9ePmUMWRPCvL3Uf1sgCwZjXuir6jgkYKL6?=
 =?us-ascii?Q?lwvhdY10T+mJ/f2gDlt0fa73WYMzbhm/KV14DN0DXPlBDntaihrxdUzx/mot?=
 =?us-ascii?Q?RDk4ro0Iik16SusYNKGM1Qh2di8+mioUOed730nxX1pDPPWsqKI/s7eDNe8y?=
 =?us-ascii?Q?BMWSUmMoL4SrnDWtVvPVaym/bFFGEDy0/A+2FFc66c24ANnFujnXVeJUy9R5?=
 =?us-ascii?Q?9DaQ0myfoe+EzNDqPexHgDhindulMq9fGEvRJnGoLIfy5f9KjUK4jv3pFEX5?=
 =?us-ascii?Q?4UV4wX6hwR1KAXjdftAvrGCUqBSfufVW4HX6DJcYdRq17br/l2pYyo2QV++j?=
 =?us-ascii?Q?0kVNU618VWzX2Zj4GdYcVi5hW0M61V8Hg0dF8LNu5OumvILGPQKmE7PW09es?=
 =?us-ascii?Q?6+Flpd1obW1YDBZTIAiSAMVO25Wb3PD1VyJvfVZwYu7sWIFXr53/DnCtm5DZ?=
 =?us-ascii?Q?wsKsr2XLFOQUI1YnqL+gWm/7BwUZf5HLt68BvArvAE9/VxpJ+7d3VVocQAJv?=
 =?us-ascii?Q?k2dsfmJGfX+w6gFmgeF8l5fk0pstfwnBJuweQD7SljWvoOwHTewNdlVAUBCh?=
 =?us-ascii?Q?gCoPOyxyn3r7MX58hWDMRfEV4ixQamCqhPW7pmokSQFe3pKPt6JDoJCpzXt/?=
 =?us-ascii?Q?TDOnv0r/r+8Ht7G5z/f1VIiahxk0BXqc8ugOo0t9lWIz8cfPcXPnAPcGNPez?=
 =?us-ascii?Q?uFLTLQJ+8ngnJ4GcCF2Sb00fHWqHBOiOmJ5cVRRevQUu4f0LC2+HtX3N9w6L?=
 =?us-ascii?Q?pMMEGWD05ZHlahsoJ77jNP4C9UvQG9JBi5f4HIkuNnHeQ8Obsioyk8km2nnt?=
 =?us-ascii?Q?ScqHGQKHn4A8MR9yMRnGW5jBTA2MrmfRQtmiaC0eZlf6XKBhWc3VmdfAD7HH?=
 =?us-ascii?Q?9Sl4Ha1cmmtIgdw87rgIb8stKMFCbq4UHtUpACrxeu2z4np4U5IAtZMagaum?=
 =?us-ascii?Q?cNSyyP/H58vppzv19blE5tSB7JDHyDgify3e9OAp85DH6Toldbm6qPxsnoGY?=
 =?us-ascii?Q?HbzEmAdi9h+54YdBKBbk0d5ptot4Txvhmkc5gNeexkQGBT/ZnOZPvOvNRKZn?=
 =?us-ascii?Q?CCGZyCbntIF8vnMiGt+cX8DGZ7bGJpAyVfCnD6J72dul33t+6O/hOAoxd13S?=
 =?us-ascii?Q?hvAzQgJFpYrxFLm3FJBtrvdTEn/bjqbThPllhKVfXYwd88nn4eyTshfObpHi?=
 =?us-ascii?Q?i47Ix2d5UuoKiDB/siODfgbz53UKuCeuecuhMC4w?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe1a3a93-25fc-446a-f7d5-08dab69154dd
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 14:00:53.9193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uW2HzRJc1k1UlIPgC31m1LMe+/UBPgiC2TrPdIW+jE+hH981wt+lxroRQ/0J5KjCcFwGe9D4y49GgO7cpvtGPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6521
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 2197f643a071..8d83faf18321 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -203,6 +203,7 @@ struct nvme_tcp_ctrl {
 
 static LIST_HEAD(nvme_tcp_ctrl_list);
 static DEFINE_MUTEX(nvme_tcp_ctrl_mutex);
+static struct notifier_block nvme_tcp_netdevice_nb;
 static struct workqueue_struct *nvme_tcp_wq;
 static const struct blk_mq_ops nvme_tcp_mq_ops;
 static const struct blk_mq_ops nvme_tcp_admin_mq_ops;
@@ -3087,6 +3088,30 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
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
@@ -3101,13 +3126,26 @@ static struct nvmf_transport_ops nvme_tcp_transport = {
 
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
@@ -3115,6 +3153,7 @@ static void __exit nvme_tcp_cleanup_module(void)
 	struct nvme_tcp_ctrl *ctrl;
 
 	nvmf_unregister_transport(&nvme_tcp_transport);
+	unregister_netdevice_notifier(&nvme_tcp_netdevice_nb);
 
 	mutex_lock(&nvme_tcp_ctrl_mutex);
 	list_for_each_entry(ctrl, &nvme_tcp_ctrl_list, list)
-- 
2.31.1

