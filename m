Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6213560113F
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 16:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiJQOiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 10:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiJQOiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 10:38:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBA86612B;
        Mon, 17 Oct 2022 07:38:09 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29HEIM5b024717;
        Mon, 17 Oct 2022 14:37:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=ptU1yk+JMtzht1Jb40giSX3Af3cU3deikCRsD4AlfpE=;
 b=wQ8O2yibRzQ6g8O8Ppy2uLmf3Yyib4rKNYys3LbEZB2BQV8BUl/3sDSy2yWiaDW6DtyG
 aEDZ9/QBIPXEl7qKfFT+7bP7hExl+iyUVrQ5rXuxISctWpLpGHoR/anYn9HOc4Y6rouE
 z+N8oQjhYNgJDznQKds5xKa5BWlTV4Dr7zMKKNBNHdHPHqCD+6psHqxxNqDflmASlTTT
 VA3ut6i3/7/0Xg6Sh83VuP/MX+3zLm71e8ddKvrXsxm5XIGv2Xobj5Jp8yEVv+ngH2mW
 lp8NU0DUeuze+o4ax7HvNAch6H4A5IUSKZ3gp6sOrCg0rYmFj2w4VfRvwElphKKqah0h SA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k91ra18cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 14:37:53 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29HCXQ1g015884;
        Mon, 17 Oct 2022 14:37:41 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hr8y5sv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 14:37:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwLGMiGyxAKrUBbCjDaVFgqvr7PW17WKiLVIFiPYT9g9YdKjWzfOFEY1eSuOPrAzEpsuAiy8yrrss4yxcQ0Z4JTiE148CxNpxoqeg6PqRzZbHvnjjI2qhqtNOZ7naXylakK3hj7tlHKmhPH6UU5ys2in7yIvVmcn2d+JhPCa2Wz1574E/SQZ8UvCioUURvhHIF4bQrTcMN+ZW2D8i61gxh/AbwvUuP3kZ7QNabkq6yVIjGGC/Kjpod5ROoSmIum7gZdIvjIA8OWIAnBAs+3BdTW3pBtJ3xwPrDEaQhGQwGedwzvbIiIErT77ePF1/d3pRdTdJqI7Hjh+iVCPNqNTmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ptU1yk+JMtzht1Jb40giSX3Af3cU3deikCRsD4AlfpE=;
 b=jEubPFLxlUbTm9cdB2WWnxXLGjMKq4eU85xtBkA9s+LaY82izHLqw2whj7QvtF1d+FXmcBzvjyJIJ7d7/gknRJJaSYDleScJYEGmQXoGK2NonmGNGN9pOGoeWm/VLpN2Q6Cu2UP1iahaNZgHL3CGrBBjUJyJTep8INwaqZPKo9ZsULwnnn0KwyDSmw0l1L/3EPlT7Ed+VcJiiLKs5oZs+YZLatz+PqOTUJeRG176eNyezlHc26y6OsZ4zYM8ZRw9yQwWzFeWtuuZ3jQiVb8Es6nbWbfNPPZWOilV1K7rgwdKxgZHEea2TU+Dl3nVGuN47doSWQyAL7upVLhdA9DvDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptU1yk+JMtzht1Jb40giSX3Af3cU3deikCRsD4AlfpE=;
 b=JcUUJfLKYV6CeD8lPYMpE2EmrmHLvP9tmCAfByAiJ7votBtejGh/gLW7aV8LOIyXd+KrPWMfFx+AgongpP92tiWeeaL+QcDhrqdZvpYb2OeDbqM02sCfGkqMRQ7aAWQ0pA1Dyerssb+Y6ymwxnEzVP0kJveDTXwhkmdBGz/GmLM=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH2PR10MB4135.namprd10.prod.outlook.com
 (2603:10b6:610:ac::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Mon, 17 Oct
 2022 14:37:39 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec%4]) with mapi id 15.20.5676.031; Mon, 17 Oct 2022
 14:37:39 +0000
Date:   Mon, 17 Oct 2022 17:37:29 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net/mlx5e: Fix a couple error codes
Message-ID: <Y01oqQHl8ItXuR5H@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: LO4P265CA0064.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2af::20) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|CH2PR10MB4135:EE_
X-MS-Office365-Filtering-Correlation-Id: 973b683e-b807-40a9-390e-08dab04d23f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1QWxz9x95fxlfSxaDRjb/Ize+JoJ6H69IdOPErI4TFvBbpAn7+TJt6tHYDidjabnpzJN99F4QVjBgELTh7Mt6y39Pksq2ncjBsTAbgCj4xLgsQLkKRSpulhBtdW77wG36DEslqsmEa5i7j0wRFOcE7X6f5YINXd04oTI3f1Fh+RL9HOwNyb+CLk4LqPlx1QQwR/aWD8Lux/sHI6Z3N/PQT4g+bjvDD8eEqifG1Pcr7PJURrNi3HqGBgqN3s5LODVVfU1b8tKRqHO331xmtvHDKDJhjiuukh+1VfhwHA9rd5Uzon/4k+P/qizmoUwR/ZGYDAXkFWxAkMIWGp4Qa6uJ7P4bdQONOXuQcLSpLZzfA0Wrb9phs2M8/NueCcQjf9let6ZbzxAF0ylSr122e20spPhcYkvKPrUA7etc901+cNb3aCxxSbsR2BEOe+CkXITkofPAWhCPK0lQLkn7etBN/1jsDA+CjTOfAPrHX4BCHv5ORR3VDJALYrTYVAYAfLmtGriDLgaQqNLtT9mPb2fy5Q1kXYXXvf5RxIbgkuXDavWFSDInqDGNTJoPFXFNcOLCN22ZL6nC3Y/js5HbgvPmUqCZOumBuL7/pKTQTM+aIiXsHYg/tdlTgcw29cr69Z1S0u20NXKZFRM9q48X87MKzngGe3Rf39S6A8hZU+e/kuN+yjeyoQsSpniIllTKl9DvwQgTsobUEQLx4jviN7JZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199015)(86362001)(38100700002)(6506007)(186003)(2906002)(5660300002)(7416002)(44832011)(6666004)(26005)(9686003)(6512007)(478600001)(83380400001)(6486002)(316002)(33716001)(110136005)(54906003)(66946007)(66556008)(66476007)(4326008)(41300700001)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Uy/DfawEnQOCXHZNM32vw9tpn5rR8uZq8kqbv2+BrNd9Krd17S9Fzd05M5A7?=
 =?us-ascii?Q?q55SDWkhoRmLj01Zka+TDSATDDYrw8M3t7yW5FVrz2dtQuHAnfYUiS2bwZuB?=
 =?us-ascii?Q?qOwB9/KWkcKld8jAiNZD0AiUAl+eLjtykKdIGgNYwLfbaqEDYFrdKg2FaH7T?=
 =?us-ascii?Q?h+snoJcwRlDhChahd7clnNyXDCJ2fGR+lLAfUc9NNuQwD9KOOJ2J9/QQFOGQ?=
 =?us-ascii?Q?m3lfiVsLpuPygA8IqwCguFO+saVP7GaMMwSLSDAmeuQGtRZCmH8zYDufi+1P?=
 =?us-ascii?Q?UMVS6hjKxfzAv0PgUh9m+lYxXHu2msuODsxxrqInYnl9V9xrp6O2ojXw/Hjb?=
 =?us-ascii?Q?ZeypiKX2B9wxgMGoL9RngJC9n//hZNPNQu8yRLIZjW90B7ROhTBOVRYLiNAj?=
 =?us-ascii?Q?nuKBAqkGoW4m5KLb3Tp2T8CNmn80dd1UZojVMsKG79a4r2GQ98VfirnSPtHZ?=
 =?us-ascii?Q?5HNpRCp+PJFUHO1ER4OeVBuHH1SWwp454WAshi4Ao6VKpqrL4hyMPfIJbk/J?=
 =?us-ascii?Q?3AZUOi3L6tyWAyyVqxMVq/wwsj+qlUUW+3YAjDxRPpx//EJpLCTYDP8DLTxN?=
 =?us-ascii?Q?0fuMyFtlaQ1/2CKpLGz6Hgq7/pqTPLUt0A9qU8K3zZdHlbxi9ynzV15xWF/0?=
 =?us-ascii?Q?Nbc9f5Bb30EsqorOoTXq3ZJ8GOy1l2YM1FQOkEr1cEBIc2Cn33TolyuEutpM?=
 =?us-ascii?Q?vZgkXtxT6Dc7/aD2GQBzPYYg5/gZn0xjOtD+Wd4KRMICu7fkWR8iyCFuzNl2?=
 =?us-ascii?Q?OwYgQTvdMT/bC+5HgEuOwwF5WW6AF/DddTPOjisJk+UNRDY8f/cowuuYAPQz?=
 =?us-ascii?Q?lI6SyWrCKxDeM/5UyHDoMqBdseDMcmwb5TTkK3xoyC1qY4GOy21nen4AhDZG?=
 =?us-ascii?Q?4PIsh5iLG4D3IgI1xKaZVtMT1mWvcojb9U8QXFIb3WJYhyr7N0H+l6gt+26/?=
 =?us-ascii?Q?YIkEmxy4i6/qJniTZTbQae746h8Ch8qCvhChmYWq6EWVzS9RQ/0iO3u8yadq?=
 =?us-ascii?Q?Gz3X/Mt6qC1l/3QITkeLDHYFcGpSPr9wIJplp8eT4T2MsiTjkCkuDBuBNJ2J?=
 =?us-ascii?Q?sU6IPDpDU0AjtYocBt8ZnbDvoU98Wb+ONzM3gHf2tVO9+7PovjE3otZayvnk?=
 =?us-ascii?Q?bkmnponjiVZhz+RkCHZUpxEg9IgPSGY/3iZ5indWu96DS3jJNUkhYvngjDW+?=
 =?us-ascii?Q?xOiCQtwpLCBIPYNbS14UzpIQRTIfxJBGlVrO38KIvGI4ChmCBl/G1XGhczrU?=
 =?us-ascii?Q?apmZEeWQJcyVcYfvHtPQRSH5RefOerGl0nK7+j/9NrEqKAGm0ng3w2xdluqm?=
 =?us-ascii?Q?MZTJiCm3FgosU1r+/bMbcIp29rC2y4tpKiMimkahSq4ahP0O7XjoIJahF9gK?=
 =?us-ascii?Q?Hxt/Cvml8yJ3bpsZzU/e7WaLyMkRKuGsihTV5CgoJhXZm1wQ70QTHGf6QX8d?=
 =?us-ascii?Q?iIV6zrqWglOeCAFKvaGUk2FgfSe2GkawmatoPe3I1m46+THwhuvMYAgkxF3p?=
 =?us-ascii?Q?5ALujVAslY1/UXJV+iSL674YxgoDlWxc9ZLChFkxrI2gyxYGn3q+D32zfZFE?=
 =?us-ascii?Q?KiaBl0oeHYyYlksFPE8fN48t59WvR3gJB+he3U/1m7eCmm8F3YKH87dEsdQO?=
 =?us-ascii?Q?Eg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 973b683e-b807-40a9-390e-08dab04d23f0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 14:37:39.1543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ovvEmVtRp2XRH3BW+IuZSfYlFXxOpORz0G57WpDFAJjVtLg91mn+ZKN4YEyLTQdxIUShFbBOjiB/xC4syFdkV5i12Ih9GuHGXbfXpAOGU6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4135
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_11,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210170084
X-Proofpoint-GUID: Q4s7wr6rmlsDeqejcx3XyHgOLOIkdDv6
X-Proofpoint-ORIG-GUID: Q4s7wr6rmlsDeqejcx3XyHgOLOIkdDv6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If kvzalloc() fails then return -ENOMEM.  Don't return success.

Fixes: 3b20949cb21b ("net/mlx5e: Add MACsec RX steering rules")
Fixes: e467b283ffd5 ("net/mlx5e: Add MACsec TX steering rules")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
index d7743303432a..46354475f564 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
@@ -250,7 +250,7 @@ static int macsec_fs_tx_create(struct mlx5e_macsec_fs *macsec_fs)
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
 	u32 *flow_group_in;
-	int err = 0;
+	int err;
 
 	ns = mlx5_get_flow_namespace(macsec_fs->mdev, MLX5_FLOW_NAMESPACE_EGRESS_MACSEC);
 	if (!ns)
@@ -261,8 +261,10 @@ static int macsec_fs_tx_create(struct mlx5e_macsec_fs *macsec_fs)
 		return -ENOMEM;
 
 	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
-	if (!flow_group_in)
+	if (!flow_group_in) {
+		err = -ENOMEM;
 		goto out_spec;
+	}
 
 	tx_tables = &tx_fs->tables;
 	ft_crypto = &tx_tables->ft_crypto;
@@ -898,7 +900,7 @@ static int macsec_fs_rx_create(struct mlx5e_macsec_fs *macsec_fs)
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
 	u32 *flow_group_in;
-	int err = 0;
+	int err;
 
 	ns = mlx5_get_flow_namespace(macsec_fs->mdev, MLX5_FLOW_NAMESPACE_KERNEL_RX_MACSEC);
 	if (!ns)
@@ -909,8 +911,10 @@ static int macsec_fs_rx_create(struct mlx5e_macsec_fs *macsec_fs)
 		return -ENOMEM;
 
 	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
-	if (!flow_group_in)
+	if (!flow_group_in) {
+		err = -ENOMEM;
 		goto free_spec;
+	}
 
 	rx_tables = &rx_fs->tables;
 	ft_crypto = &rx_tables->ft_crypto;
-- 
2.35.1

