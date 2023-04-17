Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB966E4785
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbjDQMVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbjDQMVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:21:23 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C2B7EE1
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:20:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wv/AHpc4HiFuM4hdonmvHYaFBGi/LbFBnPj6/0fMA5aqJpwpsgzJ+ItSx0VB3Hp78nx1ItZ6Lro1zetWGn/gNyvCIXTCIyYXlZgutNlgnZ1/elGIIlg+6qRZZlUIlgYoYgFDKXoHMM83NibDOLD21SYCW6zYfCJIAXVAxDfaBHGZdj5+wPvdQnMDzSSL7L3DNsmlujWB7Szf2rrcQh698oU7XyJKWkFTbrA1jz1MK5ie+QWZ5PLecW+wDy+ViRtmIumOofsVs0c22KKgP87T4OmNQomiUafvIT+pFm4aqGIROeqK+ORA4cb03s3uOi5+10qNOSDCXwl8BUOyLgbvYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vO2UyVBMOzUnObnmpt5DnbcBfdgiAhd/8UrYmhKdrCw=;
 b=gQeUflD25Ykq6KHCiZ91A1W+GeZxFs3qSJLEAwo0T4wZJBzEaThhbQ6fdo8lhEWYPWmZXxPU4+7HGGSFsHMasICCSZe9UTPG+XAVgYYuhWGDgkDJdZNX919tjCkm2dFKF7Q+sQBb0st3VVHEOegIToSdPJ3JnXiFL5OCd36BLba0OjK+qijfDCFetmyWDJp0h9tIXFfibKuG4AwmDOJQqVbpUABBJawO7zV9kf8LWbnsiiLUOHk22fIvSnIVLXh+5SBLUooPgVFrBWhIAtH1kt0LbXD/DROJiZd8+dZ6wk4Bmjv8htw+WLSwg3vqdoBhAYWul2GuBJFrlafiojCiYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vO2UyVBMOzUnObnmpt5DnbcBfdgiAhd/8UrYmhKdrCw=;
 b=Yjb/g9ug/LC5ozYwINK+g+e8qCzEOZ67wps8/jJCB8v0llJ+VwZYZXueZE+O/VQbXRiH4RSBjqOXn/+rt6Z+bLnxeUM0GzCRsqOyglD83P5GrHMBhiTazYt7JV1jSYDPJjQmqJme4DhsgttmkV5fLY3f2Wy2UbOiUSzOz2eciaG4Z50z1XiDRQhB6iJeioH/CxIKNAl2kTTWD7Nh8YE8SdCCPnbgv56Wk3nQ86NL/hCfmjeRi5yjcTZEe9V17vIoGbLZTelV3bogvuTQaGZlm+jocAy8EsfN/YT+yENGjPrFL+NZAk2At2nLFhGZVHxLBa5D0sF2fc3ShRA4Jg881w==
Received: from BN1PR10CA0029.namprd10.prod.outlook.com (2603:10b6:408:e0::34)
 by DS0PR12MB8444.namprd12.prod.outlook.com (2603:10b6:8:128::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Mon, 17 Apr
 2023 12:20:41 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e0:cafe::ae) by BN1PR10CA0029.outlook.office365.com
 (2603:10b6:408:e0::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Mon, 17 Apr 2023 12:20:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.19 via Frontend Transport; Mon, 17 Apr 2023 12:20:40 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 17 Apr 2023
 05:20:20 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 17 Apr
 2023 05:20:20 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 17 Apr
 2023 05:20:17 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        Henning Fehrmann <henning.fehrmann@aei.mpg.de>,
        "Oliver Behnke" <oliver.behnke@aei.mpg.de>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 09/15] net/mlx5e: XDP, Consider large muti-buffer packets in Striding RQ params calculations
Date:   Mon, 17 Apr 2023 15:18:57 +0300
Message-ID: <20230417121903.46218-10-tariqt@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230417121903.46218-1-tariqt@nvidia.com>
References: <20230417121903.46218-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT005:EE_|DS0PR12MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: a2cba755-749b-4d3d-f534-08db3f3e28d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yncr8qPWUW9VeFK/38VTMQCKcNjmQCuHGBKdrfCbkSZs4OaSVX/sxWKNlIYIGmuRjmGSz47FuUPeAEK7LEqpol7+DbybN11z+eLPSDufTfLRSXIdguUb0HmDzxZw3T0bE4pes5VeXVB7aZW0zbQ7/Qsw6xjzdCEnXIzQt+U4jfXATvvyMCg6pQHm0Dl3JYtEboV0qRbNR9fVij+FiLFKECPeCWPpLP09ymzSVJbB1G2MANainGeIplyShSrT8ZIGbORYUw750b1jhnOJ15cNUpkh2YnB9aza4/Jctp/rmR4jGVcAlQwit7eGFVu74fnYiQ8ICwVXGKp1hVWTNdgkY5IcZKubTcYmJ/7MkEClpfkkvvL/XGWF4+WaL7BSGCXH9FSUKN9mauDzPkzPnbjq3m3sW2YCNmpJk2L9HV9L04aSGve5Uj3kPg4Mlqlrg6J614cia3gmz9IxM8WgPf5yVwtDLeNazT+nlH8kZxHDAxCGblkFp4TTsbYQyMyArldlVhyloqHre343rqvui7cn0szGaBLZPN7hugEck2kDLG/jPJdytVP4+5wpp9i8udF6qpiVTcEa5rHsojvQbzCl+RQBBY7Oo1PeL3uURSGgUFg+hWXn2gRXxU2S9jk3Dnk9MNdglz9FIzk3g4ZIs64rwsPN3HgACxQpUroVPgFNLPI8kseLGlz2w8H4EwICyWWFMMupzTp4TI+sDxksmlMyGfJ0UkxuUz4KOaCtnfxOGlaUhOYrOwIllasIk2ZuOGJ6zfuQN6hppoorbm16J/lN8oHRQxr/PukLzE0cIFBvhFk=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(2906002)(336012)(5660300002)(7416002)(41300700001)(2616005)(8936002)(426003)(82310400005)(34020700004)(186003)(83380400001)(47076005)(1076003)(356005)(7636003)(86362001)(82740400003)(107886003)(26005)(36860700001)(8676002)(316002)(7696005)(6666004)(478600001)(54906003)(4326008)(36756003)(110136005)(40460700003)(70586007)(40480700001)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:20:40.6084
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2cba755-749b-4d3d-f534-08db3f3e28d1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8444
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function mlx5e_rx_get_linear_stride_sz() returns PAGE_SIZE immediately
in case an XDP program is attached. The more accurate formula is
ALIGN(sz, PAGE_SIZE), to prevent two packets from residing on the same
page.

The assumption behind the current code is that sz <= PAGE_SIZE holds for
all cases with XDP program set.

This is true because it is being called from:
- 3 times from Striding RQ flows, in which XDP is not supported for such
  large packets.
- 1 time from Legacy RQ flow, under the condition
  mlx5e_rx_is_linear_skb().

No functional change here, just removing the implied assumption in
preparation for supporting XDP multi-buffer in Striding RQ.

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 31f3c6e51d9e..196862e67af3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -253,17 +253,20 @@ static u32 mlx5e_rx_get_linear_stride_sz(struct mlx5_core_dev *mdev,
 					 struct mlx5e_xsk_param *xsk,
 					 bool mpwqe)
 {
+	u32 sz;
+
 	/* XSK frames are mapped as individual pages, because frames may come in
 	 * an arbitrary order from random locations in the UMEM.
 	 */
 	if (xsk)
 		return mpwqe ? 1 << mlx5e_mpwrq_page_shift(mdev, xsk) : PAGE_SIZE;
 
-	/* XDP in mlx5e doesn't support multiple packets per page. */
-	if (params->xdp_prog)
-		return PAGE_SIZE;
+	sz = roundup_pow_of_two(mlx5e_rx_get_linear_sz_skb(params, false));
 
-	return roundup_pow_of_two(mlx5e_rx_get_linear_sz_skb(params, false));
+	/* XDP in mlx5e doesn't support multiple packets per page.
+	 * Do not assume sz <= PAGE_SIZE if params->xdp_prog is set.
+	 */
+	return params->xdp_prog && sz < PAGE_SIZE ? PAGE_SIZE : sz;
 }
 
 static u8 mlx5e_mpwqe_log_pkts_per_wqe(struct mlx5_core_dev *mdev,
-- 
2.34.1

