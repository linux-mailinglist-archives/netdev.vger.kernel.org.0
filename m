Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3252A67D13D
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbjAZQX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjAZQX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:23:27 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DD15A36C
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:22:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSzKws2y+4JuDTOtAtxOmej9bASz7P13IMaIjGsd11GdufjllpBQ2zsoWiE0QaxTLOXzziAmAucoFZb74MOlHcInfB2Fg6sFvANsSMRuszPPuqJNutI1aTXfYwgCQNWeFWc2cYJ3cxa+bYR5kcvQmXwpZe6jCOQfpgODqCgJN8pFbCJN62RdSUMv9abI0p78tQ1BGcU2DGWVR89U2/JeP8QJsoPMn6bwoYR+RGreBsZQp2x2Lw8k3uGSS0DGFxAsx8jCesG8yQIhF+jxjAPG25iGu6FKBAgdHlBGO6uxoWOMYIVAHPz4YtOI7vwxmP5cNG1B3y9PHhu9YHrjaznu6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jCiauWn99ADUgnt49BHQiM1fFhjd6SAs013ftypHSBs=;
 b=Im64RpBNDmCUYP4ZNGyQJ7yflb1q5Q8UrsnGnP4o/xeV4g6KJg9mTri/MMiebXeyxWSACJUW44qpp+Pcj+Ouv14t2fjqn7bVdlPyqYaGyH3WPilAqTvDKaxph0F0MtSU+0znElTJwSZ4eEIO2QGYFnJQ4moAGudbz/ZOdCZESU0G8hZukad637JBvdost2MSPuYbVeSQyVC08b32J1+GYERWCTbPVwMt438C0iuZP0UzHuWwJR71KDJIgkirX4Sgs3yBoEa7BWDIZDNd5n20HOAn9KsXH1uD9zURKp8xNjf5Sbx0l+A4u/RIg/7IiAiM30x37F8onodAKDEWTv1dIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jCiauWn99ADUgnt49BHQiM1fFhjd6SAs013ftypHSBs=;
 b=N8Sls9XpsNc+fFxlTptUTE8p4cAX0BbRCxj8c6aKdujgnGDfWW6W6JGghwhhaKPpUBORbUBM2TvfOWufunwyQhg5N6teRnkDIcbVeKWq04d8kD9BNzI17TnaXpxmlba3b34U2DLg3SAcrcXHN/Qm0ludGHdDkeTV8MDZhO24y2kOwCkheFXTt3xciHMqdQLly7yAWJr+Ub4R09DAesdOZAAEIMVaZsmb4trumzrfmwRqMd2O0BuTix2ASUGCl507SAIYcmPI3xBqCLuPHbqgwuuwNplq9m2j4viX0CWID1cU2RoOs5RaJwlcFNrrS4bFtynfAEifhemD+th9NGEEhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by CY5PR12MB6180.namprd12.prod.outlook.com (2603:10b6:930:23::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 16:22:58 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%6]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 16:22:58 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v10 11/25] nvme-tcp: Add modparam to control the ULP offload enablement
Date:   Thu, 26 Jan 2023 18:21:22 +0200
Message-Id: <20230126162136.13003-12-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230126162136.13003-1-aaptel@nvidia.com>
References: <20230126162136.13003-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0181.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::6) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|CY5PR12MB6180:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e1679bb-f93d-4099-0f6f-08daffb99633
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: odu3dS/FdVBWTRm3SfprJ0wehpotq6Nhvl02IgZTg+SvddJ858B+fhlQayQqHo2kLK/1pJhQTMnj7RzJ2vgjSV4ZxR5MIwXXmq+lavi1kIxZ6zf34tJrGLDLQPZsbxHU7LMle9lyZlRwsulcNR7DRgqrBwcBg/tJjy0x/juguAB4vF5QM/O4LS5JAsXNz2vMZz9VhP6Q8ebUw7thzDeF2QOxenfQEfbkLNn0O+5V6M5oHkRYPXjkjZJ4PIoNMZzyYMbNa1NXRjaeLsCOzF6u++zTrWqzME6XcuBOTRbOeODveCSEjwOk/tbFyUvGemL3vwxsDSNi2V/dH7d2pbIQhsQoMP1FQM2uMdsRD3hjYpyR0p6HZZR7WGTM6Hl31KplLFpU70FcqLAMagSOz+/Yooap113zFpenQvqmmxOhusTzFej6S4AX0IwkITh7HCSISyKa4qkj4xoiyWgyVZxCsZaLfmAaF8ASBrfuXMstPqmHyfwGswmM1tIg9CU+8Val+lnqVA03QA7jNQHKj7BcDO+yksdG5Apvigy9v6fRNVE+S6V8+B2PvBvMe5O/vl3FbwGXRa5b1WbCuTNTxAnhn/qSBzgRyWO1s9tR69Zxu5fLTKtM8PM4cibaCkR0XAi8qX8LRpWzR6XFUxO2HBG/9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199018)(36756003)(8676002)(316002)(478600001)(6666004)(107886003)(1076003)(6506007)(6486002)(5660300002)(7416002)(66946007)(2906002)(4326008)(66556008)(66476007)(8936002)(41300700001)(38100700002)(6512007)(26005)(2616005)(83380400001)(86362001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?11tGhxDwgvkWjpFrtX8JTAnBTSO7pc/sACttqbqsq6YdJHcpXlZKXsCQve5O?=
 =?us-ascii?Q?YVdkJ8rCAWkQOVvyP6ggEg8tjU6yRxHuL+Re+rtUTG0zDkB7MW0SzPB7+AOm?=
 =?us-ascii?Q?S1zBkFgT3PIfu/S68/itehqUy5iEJON4buYkDugv2qVoupgFQgnPnor4a+un?=
 =?us-ascii?Q?JfAEnOKdC9cLhsuWISaI9KkodNhc+8Go7UpevrpliI4sjw6LLC9zwlklTNF8?=
 =?us-ascii?Q?V0cSp6rMl4YYl5/r0+l3H81WCExMnkRtAFgTp9EVHDS/kawIgosdr4x9hQsa?=
 =?us-ascii?Q?W90X37+9AzJRI3LEHyFVxVdfRfiNJgxk5iWMfK1EfVGsTGdN0jEzxRf+xU8l?=
 =?us-ascii?Q?VYQcGlvrzRAzn/5hEkfa0hqMNN1b2qEGGdLQkCh4t9eLXQ6zpcC5qIJ+VdjY?=
 =?us-ascii?Q?F78DziTFVyRx53GunV8pFu9SBsrbb2PL4sB0JRsN0YbxHJ2LmneQe2kEKMhF?=
 =?us-ascii?Q?hfhQqAORD3mI+RyIoovye7CKOuripE25aEgZj7P7I0WkNK6YN6lJnK/CASNo?=
 =?us-ascii?Q?WUvWVtEEz2AiBifiWb45R4vv8tX9ng1KVIM4Y/L5Hq+SCmPcxxxN5hKaLd/5?=
 =?us-ascii?Q?fwY0GtlpCDhIn17LPkEPwydZeLd4gx+AtHsmevVHdEkXpnGjbzfvgajCPRws?=
 =?us-ascii?Q?BrEOi0TluMWJcQqUv492yeGA7IPPjlnwf9+lMurWguhltl2n2uXgTZ6HfslU?=
 =?us-ascii?Q?bmk0fMTdJmb+nkJBi4z9sM1b+maX8ZQzeA6tpDLeCGFx/pOkj+y8B3jKFG0+?=
 =?us-ascii?Q?XzxXV3WhtfbyLWrs4RdX3iEb52kqlD1/xp5+Cy6IZpWp0k7aj9PYn1qg/LVN?=
 =?us-ascii?Q?zXGlVQAMXmCRdjBKLXFh2rx43uj4JKTue0W8tNO6FpHzQNXh5bnicx/MetjE?=
 =?us-ascii?Q?61QOZgH02CcIr+57E9xsyop+ZpTKBqSWX7hFPp+Q7y08VCxWNMDb5/YA8nl9?=
 =?us-ascii?Q?jleInewcW2U/ixmznRKjr/BzR/MwotylJD3WVRNqWYyQn9B398AmoMBdf8s1?=
 =?us-ascii?Q?gmexqvWQqXNqz+Cb65yxkfTQGBhVH90E2EJiksbZzYNveXlkrrj9Fux60JjW?=
 =?us-ascii?Q?qmSonKzNZw2ayxX4QRNl9ssWzPDU68EA9fU1YLSe7v0hFhF+UIIjrjWy4hwK?=
 =?us-ascii?Q?TAAp02bgX0DQmt3wKrOZCwJgE0wrZKz5e/8uXVrb5bFzbsLzx0es3CAwB0FO?=
 =?us-ascii?Q?LQm0Uct07cVAOiHdBcHeeS73sZ3a48TX/lz2zKRQYLhPIT7h9QBtdcaGg8aa?=
 =?us-ascii?Q?MoAcf9zWmO1PXQ13Dl/ev2db//ilJoPtm7CRKPpi8ZaGCXOOb7cIYYbdOOqK?=
 =?us-ascii?Q?0BBcL+ooJtrJFEW3P84r+xB5h/KEEjvc0xGq285XElYfg/FXAikJbR3J7Wn7?=
 =?us-ascii?Q?DbFkWDbS3DzFHjkaMPLXpXHaHKQmXuk7WTpL0sQ+W0kauC7RUpVSUJmO1TVl?=
 =?us-ascii?Q?TqXSpV2aYV1I8Fdk/3nsciEYPHB1EELdwkUSL0QXDS/mDGKXrDBC5dnZ/+DN?=
 =?us-ascii?Q?+bRwq1O9Xu3wrpTk2PncSeN4HwGKlQkluN408Z6CbQq4MH/+ZJbLEkDMoYa2?=
 =?us-ascii?Q?5xAww7papxcTdhWR0S3lORaexGIlh+968XYjn7ea?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e1679bb-f93d-4099-0f6f-08daffb99633
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 16:22:58.1713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NghRavhxWCej7+EIBqSTDdOvtQjVxC00vw188Q+GRofNkFM3ptKvFmK1uyPuIqnbJMciFM38pdPX58hlKaLMwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6180
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

