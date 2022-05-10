Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93BD520D66
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 07:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236904AbiEJGB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 02:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236461AbiEJGB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 02:01:58 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FF7266F34
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 22:58:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i3lVMSSepjltZXecA1bZg4/BPM4KQnbIkFd10/QKkPBTWq3rrqFk44XPP7KKztpHQGaD4+zKThksLvg1ORCI6mm5UI0LIu08u4/M/w6uvDdm/7KC/bgHGkqr6OY29SfxNb4R+m9L+Hgo+1NRursV085lmKgNQ9cV0CcT4r+jeLH1INikE21vGaMlJN3/ck9jmOI/5xJVNg2Emb5FPsL17XiyjpDJ5aCxvYZyUkA2ggCAMZMFspKRgylGye5A/lQ7nBhF4jv6XJ5UPjdUCjU8mqE8zezXMquh99LYnEiS7exuodccqwtpRSs99bnNFT85Z4s2keel40UdUi5IZiiTWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wtKTIkYcFwdZJmdygMoxhthS7FuchNejDIOSfLbNMD8=;
 b=eumKrzSHnm9lM73K/gF3v7Pk6tKNBtt2yYyo1ORFAYVXxW8VR3OO5J04O89gs5nFYLREdultOG4ayd71w7fIWYG5hPUl8P5b+HXArYsa5aJr0covmfjy1LnPCFaapRL0diSOeXkEgqpWd1A3IPYZs2xoLNGXWrAeEZPq4UL1g2ikZQog6hka318xH7qmHGQpdReDp7X7GTngn90KIEa/bvdFziu2hE3rDmz475kU0eGxWr0OyfhsfHvUPp83/ioD52xq43v1c33PTDB0Cb76lIrQMvDLG1AofWSJ/T6U8uCw6IoMUpHBlYoM3FXBnxxSq3DJLExbFkGsYiRlpYwhiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtKTIkYcFwdZJmdygMoxhthS7FuchNejDIOSfLbNMD8=;
 b=mzQGzRE6RTkyhlvM+DJf1cr7Cvucn+EL1fFoJ/dP8ElS9DedakJGEteB++6SMRm1XUnLIOzTPBXyeLWbrPf5R5e+yKxxtQRoNuUYOBWY5Qtwo7YFCXo5HOIcjM2G+z3sb2jPpAepzETDP9xJaHBdQcQvreC1ShuROAKgAD3BCctQC4pmEa9glGtAwCHbfuo595RvvBt1plEFxA0c5vw9WHtq17T3kM889mdXPWcnjSC8YVApUBGNMWXrm40w0kNUwJ4ZsQFalgvv7knpT5Ejo8lGmcJTsuWLOXwp3MXSpLEvZfbkAGmXdq7YZu1+qzwKvWjBb45OtpNdvbagWfa1AA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY5PR12MB6383.namprd12.prod.outlook.com (2603:10b6:930:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Tue, 10 May
 2022 05:58:00 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 05:58:00 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Gavin Li <gavinl@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/15] net/mlx5: Add exit route when waiting for FW
Date:   Mon,  9 May 2022 22:57:29 -0700
Message-Id: <20220510055743.118828-2-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510055743.118828-1-saeedm@nvidia.com>
References: <20220510055743.118828-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0045.namprd02.prod.outlook.com
 (2603:10b6:a03:54::22) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 830da621-8cea-4768-d1c8-08da324a09b9
X-MS-TrafficTypeDiagnostic: CY5PR12MB6383:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB6383D6BC528623D849EA1F5CB3C99@CY5PR12MB6383.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MeznUurAVvcj7QJy5k0u0fzjNsieefkHO+RFs9Zghamd3KbcTYtPG/+HU+p5bZ70mby/5Iq8DK8Vo95cZ84l3Wy/baDFGUKQCPRdhCqTj9tAZId1g33ZkccG1JzUbJcSzn2+KBn4VqkD8BBiIrPJ+HIt5FYfra3W0x+oa8vIDA89aa5LbdKWyrcFLY4nsZ8rSDtRykglANh5ufPmCNF2bJRTb7MOBL4UR6f089ufq7SIbAnHMxAIb0WD9PJPnohxCUSJ2F4LJlqSq/rgPOVGz1TEMYsy7cqTlEt8LrICGjgd1BFsTRIIAPeNPmFtOQSmJ1ld/9zX28HvmpxdBFR4adsNnLYIxhfvafGhx/bd7PG/JUlIfDtlxelWGIU5MWgM4LaM/aBpVnQa2Rj7kvHizdh8UmZiElTY32PFt2srFGKV5byBP9Tn+ND9hKhJ01pVnl7gnafhufpCoHj0D9Ed8cHcc5B95wdeFJbbOyNVSJK5+lbGDk2zQ5bAwfZJqKUGrbqqGK9CcAF3DJXT2XXM1cZ1PMyzxXwR1bqjd5baKzkzF8ISBDuG1HVwmRWKfWa1/hNDkipbkePNBnAiKR+6Qd0PVDynFqDSTqYsdyX7hJM0OuWYoCEN9iFrAsQcU97qb047ty5VWd/fcNIfBRYj8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(316002)(8676002)(36756003)(2906002)(6506007)(107886003)(2616005)(1076003)(83380400001)(38100700002)(186003)(4326008)(8936002)(6486002)(5660300002)(508600001)(6666004)(66556008)(66946007)(66476007)(86362001)(6512007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nPwMVuu40PEZZHeKip5eeSX9eCBD0bFegHqpA3tTRfDHYFKiRY9pqk6eubI8?=
 =?us-ascii?Q?7qIP9bH8Q3YSb5HLum3iJr34GCcvHI9EsxiUE8MtLkhLnQ2ynxaeaCkd4rMG?=
 =?us-ascii?Q?yAKVqWU4U5NWkugrGXFneh3LRo2pLhjzqIyJDx2FApxhAvUqSR0a5S/7JMBr?=
 =?us-ascii?Q?+JhnIRLdK6ugNAkAZMeASFK4URlCZGW9lsZePBX5MqELW33sphA6G94htskl?=
 =?us-ascii?Q?19f+WctNCnYLIt09VcStqfWIG0bJZRSyiYLlDkzTf7YdyHIVm32Tiz3WE9DV?=
 =?us-ascii?Q?Td4AwSWwAkYv62BhDYdr5hj0DcPtb66xRw+7QqNrTXukNOeFmVAL+l8KVXSm?=
 =?us-ascii?Q?iwYjvHUBwetpWMnyldmiEKXbRtpDDX4lwZnii09k4qrh3003AVenXweCBRyq?=
 =?us-ascii?Q?t4h6X2wTLHbUuLym+hzTBDA7cC6/wzoRKr2mKMcBF6OmHRwn2LNVWRf+K4qW?=
 =?us-ascii?Q?Kd9G2u/UO1jqiIWjM4IgmPa0UPfp6rOEkhPhC0uRfI6+H2vnZiDAfEyX3SGu?=
 =?us-ascii?Q?oSbxl7HeZmfVJm2X4TJW90XA6daMxpiQrBNJiFLe7vYRRzQNr1S7MN3if621?=
 =?us-ascii?Q?KPxuff5nqNJGRQoZ93zsIeGr2W2N92hkMCkgSeRzqpn04HeEmSOyPpuyYp8x?=
 =?us-ascii?Q?Jr5L3kJ+1SNkvI3yvfMvOw+/XFyE8ZH3FHUEbtBH0qcjxI7hIGKVnXz28+Eg?=
 =?us-ascii?Q?nyKzqqbTmXP+UM6Wae4TpexggzJTNKgEeGFuWI3eJtgiJI+SA+oCxcxgEq5T?=
 =?us-ascii?Q?nrgNMlw1BeZTkj8+3WhcVpMHOBLM77wplY9/o5dbZeLQKFGTaEdUpLg6IS2g?=
 =?us-ascii?Q?6vFBLUhVtRXxC3d95921OPwy4yqQuYPj0vmc0onaZYSmkeC2KIyV3EBZdKrw?=
 =?us-ascii?Q?/tE0uAmwOE2kDpC8ngyLEeB8SO+O+J/rfDts/0+gWOO52nqZqI+45waXRD38?=
 =?us-ascii?Q?H9HEBI5DxtIB34DStCzT1e6oWhoaRSoOVOqPwu6+3nGw4U49IyuseVfKi7N4?=
 =?us-ascii?Q?1q4hn23uwA74hUdFJFBAAqdFsG++Tx1uVYtoueBB+aC1EgF491DlYV9LEZgt?=
 =?us-ascii?Q?CzRc0eOoq+Id9xgAJeYO6aWSkjbwjrJXAGUSNzDOQRm3c+zR8AQnJJ5jahB2?=
 =?us-ascii?Q?L+TQ/VuZhaIPWpGjgH5pTLIHPbwccH02pXMY8KXtnZEllILrQolX8nLDKolS?=
 =?us-ascii?Q?FsOscGCw1raPTkXbC+UByzINrvzbf1OG5hMQT1K0t5KrB9wBfOxNi6G7lAfT?=
 =?us-ascii?Q?JEsMvv5PXrsUUrjMoLe8UBkkmO0yt+qB6ZwxAY6Jn5Q4XAhw2k02bjqxY5QP?=
 =?us-ascii?Q?s8T/2KajbGiFC/TBMiHTstoPHJBqa4IJSXlL3IAUKcZyTMu9RPpLHmX5KR+S?=
 =?us-ascii?Q?iMkfaZerg084oNf7exJnxEcEaX4KXG2zppzTYgTp0aVb+p5gaEr10HgCxQn3?=
 =?us-ascii?Q?U21FsG4g4/79Hyb1Z6DAJh/dZt/RVK6z36wehPVz1k73yr6VTMR5b/ieGHO7?=
 =?us-ascii?Q?JT0sEeWeUVRNHRtW93m+A1bVH4/gUQ4XSB0FsvlPOa23OQDqIkUvWEbhVDg2?=
 =?us-ascii?Q?6kY54aZEoZ2eghBgf9HdjnJe0qjzSYARSf9zmMzo21mNhYq3pxFfBIE/xIbj?=
 =?us-ascii?Q?0De5FkNuXkCDZag13hIAKhCy42aE5NJua1UyAUVKCmxED2lGFv9HGRF58Xsm?=
 =?us-ascii?Q?dhkOs/EkK0PVUe68v4S8RMFUIx5DsHTPpUepDZNumEyMl+2T19WFzJB9MMhF?=
 =?us-ascii?Q?VYR0hyG3E9KDWMP4T1FbMaKxyudTYryBv81BAHxH1+jKzyGB7rhL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 830da621-8cea-4768-d1c8-08da324a09b9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 05:57:59.9737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +/AE/4BwzQSTNJrV3CceNSlKPPzSHtwwObkDfS3o/giaLRuyQuQPABfZxzVIXrpGbJlNqKYTh/TdVFTfo/o+YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6383
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gavin Li <gavinl@nvidia.com>

Currently, removing a device needs to get the driver interface lock before
doing any cleanup. If the driver is waiting in a loop for FW init, there
is no way to cancel the wait, instead the device cleanup waits for the
loop to conclude and release the lock.

To allow immediate response to remove device commands, check the TEARDOWN
flag while waiting for FW init, and exit the loop if it has been set.

Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 5 ++++-
 include/linux/mlx5/driver.h                    | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 35e48ef04845..f28a3526aafa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -189,7 +189,8 @@ static int wait_fw_init(struct mlx5_core_dev *dev, u32 max_wait_mili,
 		fw_initializing = ioread32be(&dev->iseg->initializing);
 		if (!(fw_initializing >> 31))
 			break;
-		if (time_after(jiffies, end)) {
+		if (time_after(jiffies, end) ||
+		    test_and_clear_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state)) {
 			err = -EBUSY;
 			break;
 		}
@@ -1602,6 +1603,7 @@ static void remove_one(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	struct devlink *devlink = priv_to_devlink(dev);
 
+	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
 	devlink_unregister(devlink);
 	mlx5_sriov_disable(pdev);
 	mlx5_crdump_disable(dev);
@@ -1785,6 +1787,7 @@ static void shutdown(struct pci_dev *pdev)
 	int err;
 
 	mlx5_core_info(dev, "Shutdown was called\n");
+	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
 	err = mlx5_try_fast_unload(dev);
 	if (err)
 		mlx5_unload_one(dev);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index ff47d49d8be4..f327d0544038 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -632,6 +632,7 @@ enum mlx5_device_state {
 
 enum mlx5_interface_state {
 	MLX5_INTERFACE_STATE_UP = BIT(0),
+	MLX5_BREAK_FW_WAIT = BIT(1),
 };
 
 enum mlx5_pci_status {
-- 
2.35.1

