Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA5066E26D
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjAQPjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbjAQPhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:37:15 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BECA42BEB
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:37:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rf/QRUmLbNrb1/wbC9euCw47qcgiqStMcmtfiDR/OQOvfF4fveMaPXO7GZdOWVujyIQTS33tibFKqqKr/ek65pccvUiwLq+nmUHfDNQoldQ5MsIruJnYPI9sfj2wR8eNBZZyYFJGUaDroKqW3Xy725FPEEOax7vLxxRL70dFkqhJvJRSIiQgrEn3ljRPIPECsOxgX5BIavkAMqGWzB/mG+FEHWv9Ms5vjQndVs1KQbfgvKobapcGdwzr2H57SzV1D63pz6kfei7pXgFHpAiG2F1M/koUOMJ03fo++rCgk2CSl2fsv6plvWTBospaKzz9yL6lVPs7IowNDANG51d4qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x7yfvkA3bd5u615OoE30qtC0UjEXrp5ePeMjehEllAU=;
 b=VMA126ZxPSp/H2v0mVWQumu85jLP/t57sjgia17AI73p2F2mQUG+XZZDOVw8sU+MfJdK/dtl3yC40bwI37V+9QNLO3zGFaqa/lPT2PjPBmJu3wxP5mwdkj9il3mPMptiXRpTrcNEj6tVArCJYAiUKbHdpoMVwwBQvsFgTEwl3H3Q1IYqE5+1M1sVKxKkF63rZT+48V4RQHERJAklgreAnm8EfhHtn30AOhO54ZQCA4hUtkSt3gpIC3WiMg9VVHoModhjygaa+z5X1UzoxfCt74+yx/k/N9NJF5yewGm4M+SwZGGX2/koxBU+fqXXtGtVU5tn28iLyfiOPrmuH6IZdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7yfvkA3bd5u615OoE30qtC0UjEXrp5ePeMjehEllAU=;
 b=EqgAo+bOJOeSzeHyGm/tcgtVzTKTLIA0qjbeE5cZ255Mx+1D8ViyY46Wbv0MKEiSgHq8fzKhZtjdyi0Zyn1sRabhnE4Rx7xNj+ELDFjniEfM/tLGc6gPIXjxlAcfnMn96Uel1l5D2TJ2LFQv7YDdbM0spUcCTgSMkydTsNOrxCUvWlH8acpJmHXofKI9UayqQ3llzBHmgP3VDWTqe+3bGF/HebF2TDd3RAsFCjF9ruY+F0jVrFzLyTwcwjtQeJJlwbyaRzQ96BfrsU28j0v6WQNF94viUmvTHXTKg5Du+M+pzfW/0yAtGw7Na6EyEkR7E2vR8f0ZH7S3HlHraxgQCw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH7PR12MB8177.namprd12.prod.outlook.com (2603:10b6:510:2b4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 15:37:05 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 15:37:05 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Or Gerlitz <ogerlitz@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, yorayz@nvidia.com,
        borisp@nvidia.com
Subject: [PATCH v9 10/25] nvme-tcp: Deal with netdevice DOWN events
Date:   Tue, 17 Jan 2023 17:35:20 +0200
Message-Id: <20230117153535.1945554-11-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230117153535.1945554-1-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO6P123CA0051.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::7) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH7PR12MB8177:EE_
X-MS-Office365-Filtering-Correlation-Id: bb14a971-3fb6-4895-f90f-08daf8a0afd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lRLfyfgisNRTNTNjiUOOPftpSsc7+x9CmzRa+VTb3ATzkNBz0oDT2gcAPqBe2IJeUM32ROB0lz2i+m77szMSJkGlr19yTcfZP2dCMLaCcUrBkj9rb6Lw8R1Tb7NnsLQliEJUsf9+Msny+PHTQb7kDBdX8Gx5NGbW+fnaIbgot5aIlnO+mcublCsxl7tA2qpnVBleZY76SsGb9UCAGG3dKoidAe7OyJPhl8hs3xHPhsms/26OOVx4hM3dKv0KKySI3VjRfQouvxEPHxqXxa/yQnCbgqZO9I1rI3hShP6ZXXiSuWlRHAPpgDfxhtKp0tDlK5iUdr2Ka8i1ydln2XYUQ0QaUWDU7avdouccQ4KfdVmkUC+eXbJ0KpESuB7nEq2GCogF3UUK0JvB0ehthaTDLg9TQDIYFAa09BqTKP6xSrewjHoJMXFfPLa+oLP3ocAsQgeim4OhRTraTKFKKcCAqgmEWJrIIy4eqPQYUTU0CluCPI4jimEcpbaFW2H6oT8agFUcY4mmUUdLZckGfoXq2ZD5J26J91SbLJJAbj/oV7M52CsBK4711kmfKGgYScd5XTDYxn+p4+LfmX1RC9vbFUmlmKvLVOQTc07yb7s5RgVifH+y0prJrFKkucK64qmZ2i7usVk3Ts0+pBO4j4U9OQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199015)(83380400001)(1076003)(186003)(6512007)(26005)(2906002)(86362001)(8676002)(66946007)(66476007)(8936002)(6486002)(66556008)(6506007)(38100700002)(6666004)(478600001)(36756003)(107886003)(5660300002)(54906003)(316002)(2616005)(41300700001)(4326008)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y8ahWTwAkJrZwkUeZoBxrQ+rnpv8UIsucI7ytteYNVcYe8Mm/bwRyqw49bFZ?=
 =?us-ascii?Q?qYIapgwFkG1qImorUAVlBwahpjPzo6RpqijihBK/SrpBv+hYwE0xX6olGDQm?=
 =?us-ascii?Q?B4ICEDpot0dWIgbVlolkvS6C/YqwbROxBit6+WGmDsELfs+H9VxFoytjrRKu?=
 =?us-ascii?Q?+c47e3/iY7uA8wX+le1fHG1NtBYc0g+Rweo9MaRm3t8Pvnyua3ry5ZjcA9Yz?=
 =?us-ascii?Q?NGk8JIdcrMwX58JHnxN8YLnDJ15MfI0h2cLxVhhmlSs+nowJTHCovaQU6i4y?=
 =?us-ascii?Q?wBaKgo9dVLPDPSWnZdv64w3NaOWgA5hT5VPtBVYFGe8wn/tlMURTcNNegCEu?=
 =?us-ascii?Q?NTsrGA8FzUxT3SH9rJghYnB9P6/r1vvR+15C/6rEUMm+8nBAdFI/tfQiTNlA?=
 =?us-ascii?Q?a4cUGM5BTo2riH4LcOaSLM15Ya891cBWq7QwwP9WthYgJgiYrcyutrt1grMo?=
 =?us-ascii?Q?C8qo/YOBiGm8IZ6qFsEsgbFTmQ2//IAFyYVCo26Eh4Uzmmquqofzelx1d9zI?=
 =?us-ascii?Q?plpQduvQhMramQlXitOLG+bm4g5QNrxuY521OYa/9qWzI+9Bxcb1YaB1Jecs?=
 =?us-ascii?Q?iuTKMeS0b6dF/DBiSeH2gQz+JBzqDusxyCzCSL9jqziSmfiBwBamDK4cKaC0?=
 =?us-ascii?Q?9Q2S0WkcO06JHw+w0QdxuNT4LhL/Pwfp8hUgQ3LgtFeEEOIzfC/DsRi5uL3O?=
 =?us-ascii?Q?DdIqihXxF3oBNBqEQenLXVARFUFpVYeD0nIYwRqGZWey9r7zoZVZ096DovjB?=
 =?us-ascii?Q?qX6PtXdB+U+20ZHQrpnRActxL3PYHGOmiX4E7rvCgBs+i1erzYBHeeIbEiRU?=
 =?us-ascii?Q?G/RMY8WO+KG8ujMq06rTo1hdPD6gJr02SZIg9r9TeFTbaZbg5b1W12R8Rb2n?=
 =?us-ascii?Q?CQLunv+YVJ0yNVZgjKwc1ae7+iTa1gy0n9NfY0kQCj6NYQoWnWnJY5LbjhC9?=
 =?us-ascii?Q?Y07WnW6t7oz+1xQf/J50sbl+Vv8hYP7zAjMfPLpzIS5ExW0olsQ5uI1C7+jZ?=
 =?us-ascii?Q?0CHh904wF+NjSHW4gUHKlwudLshrNP/sJ7k048ycKN5Y927tjIAzreUGIpUy?=
 =?us-ascii?Q?tO9UvvoFb5xUAO+0j+sZ4l4n7wJEEDxxIjJ98yoVZZ8OL2XDr+ldWNFhysW5?=
 =?us-ascii?Q?Lq7TUJNh+1KiUJnMnGMIQT7h4C6EFUUjBIkWaLChXsPARj03W7ZoLftLuzJH?=
 =?us-ascii?Q?A60dOij03HrMnWBhDqJdsuEKocg3H+8yHIbPSwsyofaM/0HbOSwIOPnP7DIx?=
 =?us-ascii?Q?QA3pAsFLiGtUQ4xFWywZkgs8sxPKSIaLUwnmR/Dr7VmujRn1tbUtRfpJeuHT?=
 =?us-ascii?Q?uVvoP7Fugq7xIQZ8Hj1JPYb/7DCpY7kUIzIbMr59Tm3THKGOba8Az3W8AzB+?=
 =?us-ascii?Q?fQjGaSzrmWiuYdvHiJObmRSyUEl4ZiGrP0WbpAalRZzkFSOU2l3mnPsW4H3h?=
 =?us-ascii?Q?sAHz9QzvdPjGNM8vSE+aMIuGzqdKmrqD7PMN/g3nBeZG+AYKYt2cDeYTxO8g?=
 =?us-ascii?Q?+XKiAwimUKOPyp4Oh4OCnQ8VD+5AWyauinpFgGOLaapA1KfF/zm60g+HLjeB?=
 =?us-ascii?Q?GeURwHQ9PxeIXwr40KyhlyEQ5L6X/ON8nTPhkLjA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb14a971-3fb6-4895-f90f-08daf8a0afd5
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:37:05.6556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A/5tgE7MDrWED35Xvh6vdTVcpwY/j6KS4t4uih/s9e9xl/t1I4VXvuXGZapJ9Xb02HqPQZv07tMwb6k6Q5Rx0A==
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
 drivers/nvme/host/tcp.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 87259574ee1a..8b1ebbdcda8e 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -203,6 +203,7 @@ struct nvme_tcp_ctrl {
 
 static LIST_HEAD(nvme_tcp_ctrl_list);
 static DEFINE_MUTEX(nvme_tcp_ctrl_mutex);
+static struct notifier_block nvme_tcp_netdevice_nb;
 static struct workqueue_struct *nvme_tcp_wq;
 static const struct blk_mq_ops nvme_tcp_mq_ops;
 static const struct blk_mq_ops nvme_tcp_admin_mq_ops;
@@ -3126,6 +3127,31 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
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
+		 * The associated controllers teardown has completed,
+		 * ddp contexts were also torn down so we should be
+		 * safe to continue...
+		 */
+	}
+	return NOTIFY_DONE;
+}
+
 static struct nvmf_transport_ops nvme_tcp_transport = {
 	.name		= "tcp",
 	.module		= THIS_MODULE,
@@ -3140,13 +3166,26 @@ static struct nvmf_transport_ops nvme_tcp_transport = {
 
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
@@ -3154,6 +3193,7 @@ static void __exit nvme_tcp_cleanup_module(void)
 	struct nvme_tcp_ctrl *ctrl;
 
 	nvmf_unregister_transport(&nvme_tcp_transport);
+	unregister_netdevice_notifier(&nvme_tcp_netdevice_nb);
 
 	mutex_lock(&nvme_tcp_ctrl_mutex);
 	list_for_each_entry(ctrl, &nvme_tcp_ctrl_list, list)
-- 
2.31.1

