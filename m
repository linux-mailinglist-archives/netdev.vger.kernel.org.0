Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20A415197C8
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345216AbiEDHH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345198AbiEDHHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:07:13 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2081.outbound.protection.outlook.com [40.107.100.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5782C22B1F
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 00:03:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BjT5F7Ix4KWX8/7+JX3IAKBFTatE7PKma/0fD10t65KGZp2TCVTrpVfcJJzx4UUavGdgBBv9uaEvBdwmEWcloH6PPlhdid75CTuBT0smGt5WMMUewsKCfa+eqL42iZ9MSMYZaWsOw6DRyxnzlmp5GQrqzLCM30xHqnypzvb9mEYzlAdHRJqqTUMxvZ81IhK7/z3DquthDK1wp/veOAP4xSCLOamdmNLNjhL0cxKszevitgzJXzHTZERp6LoMw5Lsymy8a13HMuK7CcMOfJRQgDup7YKDdayGV6JR75jKGXlJowG/Hocnzolq3idfaLW4cwfSErzG3/c6VUU+l9dCug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PD+RzM+qDsHUjZVa/rgvwX50IzaiF37gEMOeXzry4Mk=;
 b=FR1qmwBMuAAVtygL1EOcxyIElG/3Fu7O6Ua8Q2zTLeCrGjYK5FHzMFlh2W4FCvwp9u+6HtrR0oCPygfFokbGGHfwlyQWeLdrq2QBA+f7Lv47kTFvNJCgttQcv8Wnns2G68Ix41qlLf9dUkG0SGwkNXUa9aMprZFNGt7pY5btlkk+jwU3Cb5nuN6u9FsjtxzsmlNPmAYZgsPTj4sIXFJobw4wQ2w3xMBLVQSTpGV/I89AN+MAbGRH6Gwr1oftyS1vxMvtTKF2Xqfad1KDniRChl42tUj7ATezSjqTZVMr8ajCwGnd9wVg8rEefZKqGXhr4zIwgJ3VsAUyDzmZHK0meA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PD+RzM+qDsHUjZVa/rgvwX50IzaiF37gEMOeXzry4Mk=;
 b=gKSCvGM7ptHXEW0U+AxjKuFG0Wjo7i2Va2AlRMRh9OsCiqf2gR/h83PJggoTsY9/CJbLNXI82aqlJg6Cw827KhaOD9ySV/0r3cgO9cm+0Jl7mVzA+AhDWaEmHjxSi5yhZGiaRmCSRx46cL54IFdaHsHIjEuwsQpbNFZBpeOVLvq8xccHzAZvAiMwa4rbboqDSrgpLhZXzJ+uqFXvKdm4CyEcfcbcYrFIgZ3Uw1zFJt9zniGtpVIQlxtzNdx9YS8m/fvqCuuZ6w3B8RGe6uGAbgy+JYF4YB2d2h3Dk/+Kf5tdDJT5cmHfSq0iiVb7sJxjEUVnO0DWqNXa96nCMYLePQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by MN2PR12MB4503.namprd12.prod.outlook.com (2603:10b6:208:264::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 07:03:22 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 07:03:22 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 09/15] net/mlx5e: TC, fix decap fallback to uplink when int port not supported
Date:   Wed,  4 May 2022 00:02:50 -0700
Message-Id: <20220504070256.694458-10-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504070256.694458-1-saeedm@nvidia.com>
References: <20220504070256.694458-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0036.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::49) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af7be76d-af0b-49a9-007d-08da2d9c2d2b
X-MS-TrafficTypeDiagnostic: MN2PR12MB4503:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4503CB2AF4321B29CE874872B3C39@MN2PR12MB4503.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y1OBLnZRgeazHoGr4VwhWYK3a4hiDrFg8M5pH1cuFuGutacqsCL+i3FM0goB1P3Z7/GgJNxJGz60W95Bid3iAgSPDdtVEEBbEWhD9+SCdwEdlaiHkNy3LLHGIHdDC5sF9wB9uaQxUvgDQH0Xfeijqu0Wdn6R1KGBcbYiAUf6ode9vmRsiJcgyEXJ+SSfZv+TlI/9Gk2X2Qa+q3MnJu4g7S3TwixV0xA+H4JHdV9yKYZVoImktXbwdXSHL1ja+rH7v1JvhmSP7qHw+MLfiH/0BDWgcOiE0DPobcXmDoJsp4JnchGtZmOxyknQYCMaN8iHu01EYHYDJ4Ek0dJIJY1V7xOSNt+GnSZiSPyBi4mOMVqBqN3Y5cAyE5Ylf8YZk0m5vdyTy/5T/9ENKvDPjygaRyj5YZw50HaipuTWJ4ROWNgI6fWf2U4ln6iJTS0/vd9/YHpWd+S5wyAVWjYbsMc7srYUMBrvF1cn5n/1c+LQcdnKoriAOKmRL1btgCEgaJPY7PbZ6t8qFtnpToQdWx7gJLw1scQK+EmSLDbt6vAa5XyzwBmQp2lHg9KnDfWQeUzcEUd2s3vLIkuEgRvxG+GzUXQ6YY9y/h03CgibE+FGrQe4xLALJPGbQpii3MY8gifS/94iRrbqkPeW7vQpLnvczg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(107886003)(6506007)(2906002)(36756003)(8676002)(508600001)(6486002)(38100700002)(66946007)(4326008)(6512007)(66556008)(66476007)(86362001)(8936002)(316002)(5660300002)(186003)(54906003)(1076003)(110136005)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lbBO+TCPhOEO+ptKa/yOxCZaaUEq6geEt0RJ9PZPxsLPKqsm4BawzkyNt+gT?=
 =?us-ascii?Q?hnGvwiidOodgMGac4Bwfh46evZ5Rj7WMXxDNz/bxxFmbSK73sSlZ4qeeT1ux?=
 =?us-ascii?Q?EaBc/ZaeSmWMRxWGMtWaIMKNAN6RWd288L00fKx3nUhzkcKF9EX89EWxi7El?=
 =?us-ascii?Q?DhZ06P+kuZG5eTEoqUszFSEtww2doIR8vYixOqTbeLy3b85ENahfVuu2g8Sb?=
 =?us-ascii?Q?tescfHYarg42mRFzKNIper5ISJAiXIH41aNQxoJfH0HdzZ9uDTrXK554pjCL?=
 =?us-ascii?Q?56/yurd/j8yAW3xdBGMZImPmrcziogR6LLOtMAasvZd3H40ARjoglGDmU41V?=
 =?us-ascii?Q?O4FzGXpQSWBVnVwAa1u3lCPCf/DH6Oj3ZH7GRuOKwPC9GDSWtUJhtzwBPe8L?=
 =?us-ascii?Q?+Krhe0ylsNRHJgwvmoEU4/bTFPETYPNPK+CTCFMyUm5nPIMSBLc1Sbd9Fw21?=
 =?us-ascii?Q?+5Zm6eZ8lTsjLt1fR4J/XWD71C2nq2zm8uPsfr8ol1cs76KNVNV+57RuxCSA?=
 =?us-ascii?Q?kROKy5PGkFvI/cgPnOoYrxYobmFUZgeHXbk2E4LCDQ2fFfBc02siXNYhM5TO?=
 =?us-ascii?Q?HMzmRrts9+BjOFvUkTdDP+MVMSsB+DySFsic4BHF4qImgeH6B/gbch2KfebU?=
 =?us-ascii?Q?rwM/V4sP3d8K7b+2pFU4U2SgexHxl1FwdqpCSuo0/NaNn+ZbpMCoIu+8Cc4K?=
 =?us-ascii?Q?ncsv/TsKDV+kU5wLjO1ivCMkVmNh5yT1WjpxpwKpCRJcrzWBpNW4YWDDhezN?=
 =?us-ascii?Q?8iY8DkYjAdfZmRAaZH0d/fnbXMq6UNmUz5t9RJxL1E9P9SZyKCwA6xQJmsFK?=
 =?us-ascii?Q?ajdG+UsA2cviGfHw+rinF1H0ckvDDCSkq5M5NcuiAQEoxMU1vua5IJuVzStP?=
 =?us-ascii?Q?1GHBw3VpSfy8yrH+yrC9KVjcLpWVMw3a1P5OkLpwqtm28VN9RnGRCw8tkiBj?=
 =?us-ascii?Q?BrWDmcZxa3Onk8EaNMSrnUqzC7SybLf/kefU1mxul9Fe0bQ9XAqzCRsFjXQT?=
 =?us-ascii?Q?30Stu0LW/oDSg0RF3M6X1nLiq2rCUnuJ6Aybza6geY29NhBMPpQuajaI+QIe?=
 =?us-ascii?Q?3SsoGMhHKB4BP1834MvCesBRyXRpw02pKZdOCg4LcDBOg2aQkoSwxJefXE0P?=
 =?us-ascii?Q?FgFFRsjcfQaQNYqUmiUda2IB89uYKc0MDcr4ucOadaOBWs4Ll3rcVeYu4BDc?=
 =?us-ascii?Q?DeH+HWkzeHO3rzHdBkDyABIwbvLVDHdeBvuC2hAcYLOW6m6lXMWhxxSPXKzP?=
 =?us-ascii?Q?cEdibBLc9SpCLA92YmUXjLHFvsvcW3XG2EGwi2CS/C79u1Bz+j9+5GFy/ce0?=
 =?us-ascii?Q?aE6Vg/JU1q5T9Nw0W50perwjEzEcUfhV6juGHlU/BMtw6uQizCyxcFUcgKlG?=
 =?us-ascii?Q?05dbPYgUolSkSID0MPclJrvQ9XtUd1JdIkKUQxsPAEcG/M459pnIZ9jj1dlI?=
 =?us-ascii?Q?TH+yD53dRpxOqgDZ6wZiONZgQ2i/JfMmA1sqY//4D9RG2oasMf3yN4Gkh4f0?=
 =?us-ascii?Q?jFa4jdtPBarYOur42ObZv4sOmAwyv1Atjq6JfjkzewYbC0rKKyS0G+JdfbG2?=
 =?us-ascii?Q?AJ9iM1XmfaJUiLONr3pARWqfSGIo8ag5n7XhRYfQQoY6eyRpLe8+xhxEfVAR?=
 =?us-ascii?Q?cXlUbhqDHQWJLV2BHKzM2feg9zbiXGFXTtQ8zlMEl2w0o/7GjczkES5eMdY6?=
 =?us-ascii?Q?i3XXTNohJv85lXCp0iViU04IMOUHuKXRWsEtKi3E99MYejuXuDOlMAlkcyx/?=
 =?us-ascii?Q?yBmzTV5kBkmYk1xmtIu/CLRRf757PT0Vc7m3O+6TYnOicH3bRIp6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af7be76d-af0b-49a9-007d-08da2d9c2d2b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:03:22.4474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WEsD6d03ckVnFBvHAfti1X8l8seATFJg/VBVkseV9IBLayyDuR0NrDQG0gbQNZDkH8HAqUokgebyx4IeGc3BkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4503
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

When resolving the decap route device for a tunnel decap rule,
the result may be an OVS internal port device.

Prior to adding the support for internal port offload, such case
would result in using the uplink as the default decap route device
which allowed devices that can't support internal port offload
to offload this decap rule.

This behavior got broken by adding the internal port offload which
will fail in case the device can't support internal port offload.

To restore the old behavior, use the uplink device as the decap
route as before when internal port offload is not supported.

Fixes: b16eb3c81fe2 ("net/mlx5: Support internal port as decap route device")
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 378fc8e3bd97..d87bbb0be7c8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -713,6 +713,7 @@ int mlx5e_tc_tun_route_lookup(struct mlx5e_priv *priv,
 			      struct net_device *filter_dev)
 {
 	struct mlx5_esw_flow_attr *esw_attr = flow_attr->esw_attr;
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5e_tc_int_port *int_port;
 	TC_TUN_ROUTE_ATTR_INIT(attr);
 	u16 vport_num;
@@ -747,7 +748,7 @@ int mlx5e_tc_tun_route_lookup(struct mlx5e_priv *priv,
 		esw_attr->rx_tun_attr->vni = MLX5_GET(fte_match_param, spec->match_value,
 						      misc_parameters.vxlan_vni);
 		esw_attr->rx_tun_attr->decap_vport = vport_num;
-	} else if (netif_is_ovs_master(attr.route_dev)) {
+	} else if (netif_is_ovs_master(attr.route_dev) && mlx5e_tc_int_port_supported(esw)) {
 		int_port = mlx5e_tc_int_port_get(mlx5e_get_int_port_priv(priv),
 						 attr.route_dev->ifindex,
 						 MLX5E_TC_INT_PORT_INGRESS);
-- 
2.35.1

