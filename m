Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D89517CAB
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 06:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiECEq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 00:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbiECEqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 00:46:18 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FE33E0F5
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 21:42:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5OlGbYOB2vj3tOS21Cd8HkqcOeJaDXOCYcf16qqob4RkOcF/ZSFYTSmyd0T12QC580NPK5PuSVCh7mNpUpm4tp5lC23qYgSbFxK1FGF2ekMf3KeD72sQ28Q+Y5wzR9gFdgUbB9o5fFpF+rfdnELOHESsVi5esWpBnwQQGdUn8kpVqX3NZVouy7+psYnTeYG8pKZVHzAXyTk4oMOY+hzXbG9m6atlQ9p4M/IJTMUVY/0g9FnY/IM0p2MNPraNcl/8F129kF4u0/VgSqLTllcPlk4LFfgPE/wAGuhMLvzoMtGtlQ8wCTqFNDhx1y7GK66aXIeeXyCtFoP12gpS+Dx7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7xkyD6BJeelUrDK+my+Zeexj96tkR+Dn2xVlP/P/LbM=;
 b=URXD7GnrkXLXqwI8lzXhno8jLm8z9XaulrION59Qy8FjeWjqHpqVWtGEeV+qpfOkZuUiIHVRmg3HGup/0HMRIGJQooUdmirDbHnGallxjuVDo0FQLcsLQgK+HCKN9cgIXAsxup3UCwwZYOdIq5+kNFhjOuvJiIByS6Y4ubQjY/9bXABRZTc3ssRe96tjNOUfqE1rCTkZv2m0B7M91T53txYwA6fBMZhBwfS4k6dN+JUURxkgYzXYQGcxgszqjZwAqr/QP9EMjU7f9X8lMBgd7GndywX+3/NsduOojWJoiGakZbccmTkDBl2uaVz7DxpFeIcbmMJyj1GklvwnxaOwGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7xkyD6BJeelUrDK+my+Zeexj96tkR+Dn2xVlP/P/LbM=;
 b=AWUtEQHSez6fUYFQoINoyQ7+jrjD8bydoat6bRHKcw2lyFHQ7nX0oGM2U/nJillKGfuNj7kxj9EWAe6CZXY0u4sNKBVuee4qhbEC9WMgPiFfImP7XkVhE493FjBH3Hcm6cTTKEMFEuA30LCUFRvBjUAEVgrGz6ryjUiDMgE6Go8IIO0+CHpS/usLxM4tsjf38Ce4z50nWfYrCFS+3PdLhP3WEPQ7QP9F+6YpfS69nWYwK6CCw0KetM2DAKmjv44BHovFahWcRSddrVbp/EjQddnc/FevsJisbZEQ09UnWhh8mRFIdrDH84AcGX3Hs6fKJVfkEXdUr6u74J9LwDQD8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 04:42:43 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 04:42:43 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/15] net/mlx5: Print initializing field in case of timeout
Date:   Mon,  2 May 2022 21:41:58 -0700
Message-Id: <20220503044209.622171-5-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503044209.622171-1-saeedm@nvidia.com>
References: <20220503044209.622171-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0386.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::31) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6a5b888-c728-4c16-1ea7-08da2cbf5cfd
X-MS-TrafficTypeDiagnostic: BY5PR12MB4322:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB432258341F467BFA4B49B4F7B3C09@BY5PR12MB4322.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4LGxC16QEOAQlAcpZ4460V5dgVwHI4BP81aFZ9PYyn0eCdmRF4YQ5oRC2nPhoMt+Z+NHwk0EJVoaoHy6VtzVsns277KHOo9SvmKwv3CK6cyGspByNsTOS9DnDyxeidHqiRJz1mHkLSzGWGe4aM7afTwiN9MCGCdXpkxPy6Xb3Aae7h6PKTnxCmzGxqA4v396C5LC6Iy8kmFrdesj0BMGQpsKh4/GjlkGtH6CHfbs7bHKSC9NXWpGvlj3YU56LI0gxLbAZn65cX+LhOm1z/gh9v1cC4C57lQr1DfqQftTAeVXygXha/9+3FSkQW38OZkfklv4V87yRLtG53kbrZY0SWklzo820blEqJl1qFwOg2Evb1kreOAxtqWPeF106bNjzObI3rAS9KftOwoD8PhKUJE8IJeXnT+0Xiwqd7yJ+G3H0ZXo7XtZQY9M2kiZ0LYjyvz6p+bclLUHCF7Ud14fQC9B/Kby7Cur0tC/EANLFB+t8K6MA4g1tLwoIMQ5HeaF/94Ix4evLTzJ+LiU3Gk9fslrQb33f2gV4WRPZyliupdvpKikv95kZ4Pc3HNqA/KCNKO+I8KYQ6VP8V09hFJz27q76F2scl1W8+GxxzepslQ3OcroHVbFQBb56gdcRkS9cHhz38PzKOXDHF7yVc5tlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66476007)(66556008)(8936002)(6666004)(8676002)(66946007)(83380400001)(6512007)(6486002)(1076003)(2906002)(508600001)(86362001)(2616005)(186003)(36756003)(107886003)(5660300002)(316002)(6506007)(38100700002)(110136005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AS0bdcYVdeN2lml+Kl5xNqO3P32+6ZqffvrWUElyHWTLDZ160M4hoJMZHmfk?=
 =?us-ascii?Q?WPv/DEWJE4HxwsQxZiu1IJfUuNL+FWJxbhoaZjgKr1qJfjJkMbf/iwB1x9Dj?=
 =?us-ascii?Q?mTraZ4K8+nxz37mHdYUMM2zXy3FImSVUoq8GoKDwrBe02dPsc26+w5+XruGE?=
 =?us-ascii?Q?XMu8ow/Ry5ZJMwpBI1eFkz6tZ9uemA2tivzwfu2Jq4/FSusSCILsrzpZ4BQK?=
 =?us-ascii?Q?94IIm/Nl+VUV3rNledxss+Pf7behtgiJ5j4uLOLoCKRIfpNibmTU72QItGpY?=
 =?us-ascii?Q?vBxr4oUS3wRoYGmGQCGftkcM1GumtOw7a/JjJRJeszqDEWSEfQm1pkQajVBW?=
 =?us-ascii?Q?9xpOrm4s0YrgG3+uxhe9Mu06mVxMEfGUMg1iIfhkFkML6y8IXjvOcPuZ13W/?=
 =?us-ascii?Q?ndHaepgmVjUNNRzGUcIOURHYo4Yo5ywEN/Z6425wxNmbVmAtemoFERPTNU+n?=
 =?us-ascii?Q?3m9/uGY3DsAHRCIaJNg2MGCTg5hW/xugFdHSKca8Q/P7HlK/7o0NNFXtuINB?=
 =?us-ascii?Q?7ASCTpnye4vTZK+p9GL/SOG8Xib0bygdyRG9RiGw/cPHvdhAOx3VRyO+n/FC?=
 =?us-ascii?Q?PchlxJzoTN3k/FSl0s2fz+SVYFxu7Odk9HuDKuVz6NojJk0w8XBWSObWX3vD?=
 =?us-ascii?Q?qjBsgX5Nom309ez6LzpLYgX9TeQjIfrJDT9MQ0viSmjekOf+tD2JeUNiZDg0?=
 =?us-ascii?Q?taYGBBfzta7A4X+diRyznuiD4UvFcAa2r9K2nKUHJP7u53z6CArz0XneGIaG?=
 =?us-ascii?Q?7cCKD+Gb2E/hK+/scEnCM7m19iNx0onPZgCBaCiuUVLGDV5PQLfOxLuwtV4z?=
 =?us-ascii?Q?6zvKWqjF9K1MogacyKJZ4YRy8arj/Q+jsJeRDvvmQZZ3emKosTCpZ9OEhX3b?=
 =?us-ascii?Q?kuIUwAMW8e/LC//kIitcKlsuv8458u/5K07WHVhS32wFdG5lK8IYIOZENXLb?=
 =?us-ascii?Q?AGnVprqVQYcX9pVR+wjpCM0ri4FJxOviEKGvBs/UuCZdGO7dc8dLmwfVaTMF?=
 =?us-ascii?Q?iL+KRYwjT1n5++GKWQSPKalv5hYTt6O1coQRdibz1SesuYxFXzjhGcQ5F/0T?=
 =?us-ascii?Q?P5rCjAA08Kzl4hQtXYr4ti5VjDpZYJYm4cMvg9NHA5qufE7Tx2aWpduailhQ?=
 =?us-ascii?Q?8NmWayW2Bl5qQWv3tuu7ROLvVJPjNQoAzhSw7Bc7WJwaxku2xH1AsltJfrtT?=
 =?us-ascii?Q?KhlZJl8gq3vf4h7zff8dsclBc4ObrTT4B2BDVsfxyXu8a/vSqTRZWv2gsYY0?=
 =?us-ascii?Q?FlUNxPzCgvBpRD6KIGjV5N4ytKa4078q6UVZe3h9C5ge+5ZS4RVzS7EtIYh+?=
 =?us-ascii?Q?LN9oQfm6uZbCudZErhNp6H7JGndzhk0ZvgdWfOLCHrxeyFU0UnMUqdMHsRFf?=
 =?us-ascii?Q?rx0SHh6sHLcUAzvINB6/CqiKoAeSZOZd4lR7mmVWQEjP5db8Jngsa/f5Jxbn?=
 =?us-ascii?Q?PnHmiKmTEEwi4Jlk7p8naWch6rfdJi5F/oGFYt/DivtHJojckoq/MT+rfgeu?=
 =?us-ascii?Q?3P1x0o/OnUjo+lkozphYNtVd3IzG4ySM52MEh0sRLfx9WOZOHPNNBohlBhzh?=
 =?us-ascii?Q?3Kcc9HTiZdiTyBtxW0t8lmBovRpFmhj+AwnT8xwF2GjPrTjHwwI8zKAnXXow?=
 =?us-ascii?Q?fEKkfAuZXljTHF6f6WLiG+BRQT2765paj3ZMZ5iN0yalNJWDSjRERpa4te3q?=
 =?us-ascii?Q?JzeSYL6dGgll60C9DAJvlmalr0mfZaimiAVH+wgpsUICX6Qt1JZxscqYIcPM?=
 =?us-ascii?Q?fVfSi7/NNJKWnGPHVwxX5NceTtBO6JQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6a5b888-c728-4c16-1ea7-08da2cbf5cfd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 04:42:43.8064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tnKf/h5AIbxoZtN8EG3gmnzgIK/h6cHgzO9caOk017z7y+NJbdRZM4uvRk2e3FVr8Wn6UyyclvctPW0qZ5FKXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4322
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Print the initializing field in case of FW couldn't initialize before
timeout. This will help to better understand the root cause in some
cases.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index d504c8cb8f96..95d7712c2d9a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -177,30 +177,29 @@ static struct mlx5_profile profile[] = {
 	},
 };
 
-static int fw_initializing(struct mlx5_core_dev *dev)
-{
-	return ioread32be(&dev->iseg->initializing) >> 31;
-}
-
 static int wait_fw_init(struct mlx5_core_dev *dev, u32 max_wait_mili,
 			u32 warn_time_mili)
 {
 	unsigned long warn = jiffies + msecs_to_jiffies(warn_time_mili);
 	unsigned long end = jiffies + msecs_to_jiffies(max_wait_mili);
+	u32 fw_initializing;
 	int err = 0;
 
-	while (fw_initializing(dev)) {
+	do {
+		fw_initializing = ioread32be(&dev->iseg->initializing);
+		if (!(fw_initializing >> 31))
+			break;
 		if (time_after(jiffies, end)) {
 			err = -EBUSY;
 			break;
 		}
 		if (warn_time_mili && time_after(jiffies, warn)) {
-			mlx5_core_warn(dev, "Waiting for FW initialization, timeout abort in %ds\n",
-				       jiffies_to_msecs(end - warn) / 1000);
+			mlx5_core_warn(dev, "Waiting for FW initialization, timeout abort in %ds (0x%x)\n",
+				       jiffies_to_msecs(end - warn) / 1000, fw_initializing);
 			warn = jiffies + msecs_to_jiffies(warn_time_mili);
 		}
 		msleep(mlx5_tout_ms(dev, FW_PRE_INIT_WAIT));
-	}
+	} while (true);
 
 	return err;
 }
-- 
2.35.1

