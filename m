Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C37646E653
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbhLIKNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:13:30 -0500
Received: from mail-dm6nam10on2081.outbound.protection.outlook.com ([40.107.93.81]:9145
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233194AbhLIKN3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 05:13:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rk8A15IDRgdBuiyVQq3GRKGVWy+HSiMLCnj62SYNlOcuHTgkcVDZTz5GohHvYkV1X4B8Ssqm9CrMrMTmb95pPxHrCnjPy88yvR4nUUjNa7xdtDxCEr9gz+cqq47zCMIX11Qu6DruK13qoaYfHkr8Xzy/d3hX6/a0BjaYoQj3yfN9Q360NdvycLYyPPSRAxRIveE6lBYeK26tH1bZCbLk5Yiwc/D+TEqIOsf+q3gzs4xZuZFU6TL2sJHhhsixTGaMrxZrHzPjNQFoJFtprBk/FvsEoRonsG0Hgs72eC2KcKc6KEo986Oi7HkOosAiWxqO/0jCUIGkjJe80Zqntn5Ktg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=90aVpqkTbFJMsC31yGZI3UUVH9eqJVH5bfuuBYGoWGw=;
 b=nKS/4vZ921ipRDmqT0zW2yUWqanJC6iR6PrFRxcy++XRt/wXD+uGcLow6euq2WYnL4p7dSVhl/HNDE62PEYGkJ7/cJMJOy4oyE05cbs7zwhi/2QoG5R9KITB4laUt4XXgqLTaWjURJ849ZbGs2BXTELVleNUvSuRe8xkl587+RebybEc305Unzvt2aNX8IMGJSBM7sLjDFscyBUfXT+Uf3ma6N6uGrJSEMrraqLBd9Aj/+EW03YnaVpZ1Mm0XlEyVEuD6GgZpRs4Tiia+51gnLgUyNeSXa815Stld9eohIeK6lTj11dTuq9GiqgxV44h/bNbmsXQgUzH6KrFgTPvKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90aVpqkTbFJMsC31yGZI3UUVH9eqJVH5bfuuBYGoWGw=;
 b=V6+MqDuTAPYWg2Su6Y+f8jgheGQM7U4XOqGEPK645CcKBYQrFlXmfl9vSVsjPQFaKLjJ2Ml0HHulc+g62RzS+Ku6SC9SfqAB0eU20SYnsgC/yBH/bSiy50coYpbuyMO+CHcbcknRjQ+S5u9fWNROcPso3bpaDTAs8IAy+gnpjz94O/VqDCmdkC65pH3AF7qauaH76wrq6DZfwl99E8uU3CKluwKjRdia92lku6IjsxUER6zJMTZqq5rHjrN72/Q2MpacYtOvrKdeJ4WPm6we+xc2I20CM6rTJsCdE17Vxztyz8bEopgPjwcHq94SQyVvQIomUL+C9/GWJWtZmZiXuw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5373.namprd12.prod.outlook.com (2603:10b6:5:39a::17)
 by DM4PR12MB5311.namprd12.prod.outlook.com (2603:10b6:5:39f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 9 Dec
 2021 10:09:55 +0000
Received: from DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac]) by DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac%7]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 10:09:55 +0000
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     jiri@nvidia.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v4 1/7] net/mlx5: Introduce log_max_current_uc_list_wr_supported bit
Date:   Thu,  9 Dec 2021 12:09:23 +0200
Message-Id: <20211209100929.28115-2-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20211209100929.28115-1-shayd@nvidia.com>
References: <20211209100929.28115-1-shayd@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0076.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::17) To DM4PR12MB5373.namprd12.prod.outlook.com
 (2603:10b6:5:39a::17)
MIME-Version: 1.0
Received: from nps-server-23.mtl.labs.mlnx (94.188.199.18) by AM6P193CA0076.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:88::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 10:09:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdb1a576-303c-4aca-ab9e-08d9bafc0c5a
X-MS-TrafficTypeDiagnostic: DM4PR12MB5311:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5311D4DC782EE3B59500937BCF709@DM4PR12MB5311.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WSNwn8EPV1SKXsnQK3MQ/iO4IeSBqCRk6MJRo13IKpMEPWepHYwnz4oPpPeMO7p2yt5bDeOHaCSXbTphqnazzicL2yOk0dRwJTiRwcEqmKbeID8HJQxKfREHT0HIXfv9w8BhqtnD7BIb8mWTbyjrQbqrj9c8h3cKbIThrFWj39kW/EcH7QaMlsKKdDPJkiDKYSG4GbSLioKShpoikOxsd5xqOgMQ6LvQkSpesGiHKuZxA68pJdpMkxAkRtWoQtbCvL6Mrt0FlGQAp82JFVhSGI27P5vIW2EyuQsHRmWWq9na3dFA+AlKNWUS+dFXMG1UhmvSqZUg0/IB4OG1FgNOrTe/aQOwJE+PICkWhLsIQ12ivwmv8VHH9RIQnMqRpdOf/C9OtVxMcZjiGeC1lJ27XqglCZopLA8cnitoN/D7EhaPjf9vO1xDHlb4uwnDtlNTXm3EksAjeUgL9VLPtEXNXcdZQ6YSJKzsLZ42Ks8W6/newL7nis5LwSLx725XdNyxL14/yswcpdgrgKgqVeVV8txgILz1dFvPyTHrOf29mNMewL4+Fs7CMvzrZmaeAim1AOsWan08dSIr4wq4Y9CKYlIOG4RAM75f116ZpGo5LcRRtaoZ4g5AJ7AP77J8OFPb0qHibu0zmBQT+zjtzrnQbkSFtxzsJr6b6m1yHryo6ewFcrg7OuDwhlaE13g64GTI88527oD384ZhhO/qvrclYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66476007)(66556008)(956004)(38100700002)(38350700002)(2616005)(508600001)(6666004)(26005)(6506007)(1076003)(4326008)(52116002)(5660300002)(4744005)(316002)(8936002)(54906003)(110136005)(107886003)(2906002)(8676002)(186003)(6512007)(36756003)(6486002)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ABKJtSI9h08/AqEhF9yTZxco295nqgwcgpogfj/7/Ms6A64b6SgZlMEPJH+5?=
 =?us-ascii?Q?7+xv0ckmWNN/fHLzMRzElOJct+kI2gFq8lhsqT3Oeg2miAr6F9FtkSZJ1y2Y?=
 =?us-ascii?Q?hawFDNex7G3ytTspabapkgz13HK/zVqFqr5kggBFoNYnpacrRBaT/FTBY73k?=
 =?us-ascii?Q?zOsQ6uz+5+tyUeJoYJFTiJaySeFq/42N3bfMwqqMb065Y2l8BAg5yu4+aikW?=
 =?us-ascii?Q?QLgj/Zl+jBflxHzwy/Knqg92RyvHuR/O2soUUIqAT/+ROl6zoD8vgsoPE4Gm?=
 =?us-ascii?Q?YD8GdEFE5j9NzkIWHzZnnwkQ8gMlN81+Z8H+AWaQf3g1ng0QWk6abX/O16u3?=
 =?us-ascii?Q?KHzpyS9O2bPIh0eU+6bfOygKgHFARcIfs65YDfWlcrjwEyiXZH0UwgNvXSUC?=
 =?us-ascii?Q?NHlJfVduVzY12w1llyYC+cZLNUdjuFFzQbF2iEY6YhocTpbnCggLhZi45lbr?=
 =?us-ascii?Q?KTes5CH5ilUKyRs+MwoE3v7DloA58KNSu+BUIm0tg4lnyWpC5PkRjnRkQ+X/?=
 =?us-ascii?Q?J0en8BUreek2zGyhHV9g216Gxh4WzJquDYUHIohZbyVB7G5+6kPJ2VW7RqyE?=
 =?us-ascii?Q?fcL8g0IM7sgd1lxmQN3fa7/KdVlZQ49ob6MzBRhfS+gzN9ESA7HJ6VNrTXq7?=
 =?us-ascii?Q?3F7W8nQk/qO/n+qEBpLesols1xPO/45M3mAc7roII+kWVk7dciz/jZlY6Zfn?=
 =?us-ascii?Q?iDzl7wvUx4UYyJCoHIgobOPpcAj3NWfTKjdZgCQKdBk2GS3pt+iuXuSk+fl+?=
 =?us-ascii?Q?7di76w2DySPjn+18NgbidhFRJd36ekqIBQUk58U23JVe2nY8bhqyyPIKN5Yh?=
 =?us-ascii?Q?VtzxFZzOOss7PV++F+V8lH4AvkaxL82P19ysyJ+obP6jYHG0E8yih2MC6ls9?=
 =?us-ascii?Q?AT7ftQe6m5g3cBFZxGpkI13DPpyswOpP/ebp5du9lkDX5elCnVgxSaba2tsW?=
 =?us-ascii?Q?o3OR0vrD2DdquRJDVukqtmtRtFxTPtTDH1zUvNDova+m2cI2yJ0UwFGgC/rR?=
 =?us-ascii?Q?OqZVLxZfPeqL31GEqEizD7/ooOQb/+h+NnAH5dWMnKQARfBGPfa6+WahHE0K?=
 =?us-ascii?Q?SVo7mzBdsWItJko8d5XeL4apTdcnUJd2TnLHW8RR8/7wRfjKG3fz5voGZtRQ?=
 =?us-ascii?Q?FO1j4X4IXSc8IQUCj2T7WVhTMN5QJC+2tLjtzbYWv7llfTBqLzJvubSd9ydK?=
 =?us-ascii?Q?RJNfdbEZ7A2zksSr9G4AnKTki/vy2hWbqY+ChCKqGv5Jm3nT+bbS8BUFfTcX?=
 =?us-ascii?Q?NRQ9KZfjcHFO/TNfNwUIrENaD2bW0Uq1LXD3JTiCx4ng7WtTdzglO0KGp3nq?=
 =?us-ascii?Q?Gau7VzgTOB+AgLy7ZZm9pvHw/WB+Fmgaqozg8B5K3+oCa9EpROQl0uABk0ud?=
 =?us-ascii?Q?sZ38q3YFL4Jk6AcStd3PCqzDWZh0Tipv989xgjFpry/2iJcVy/OKGmR6FiY7?=
 =?us-ascii?Q?NT5w8c6RziGVXuzhm55HvQlEUkY+FS7HMVleBr42wI1FmW8mMVkbmxUUwKWa?=
 =?us-ascii?Q?LweqiYC3fEg05MKC+MKoc7KALAinb04DOEJhlDwso8EEBkmdFO094bnpwc08?=
 =?us-ascii?Q?v4vbkWTTIa8FJ+ByOc98UIrBjOKbfUUHs3QJWjusbr4d22Ln8AXNLxLe3fwY?=
 =?us-ascii?Q?y30uAK6uVGrwtUzUw7kTG54=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdb1a576-303c-4aca-ab9e-08d9bafc0c5a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 10:09:55.4077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QgAv/+tVsJNXpwpO9g25XEZHAZoVA2COsShReFIN40kwHxgMT7uUvjqu3IpQmgCDRolqJHQVV8vB2IR7BhkEKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5311
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Downstream patch will use this bit in order to know whether the device
supports changing of max_uc_list.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index fbaab440a484..e9db12aae8f9 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1621,7 +1621,7 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         ext_stride_num_range[0x1];
 	u8         roce_rw_supported[0x1];
-	u8         reserved_at_3a2[0x1];
+	u8         log_max_current_uc_list_wr_supported[0x1];
 	u8         log_max_stride_sz_rq[0x5];
 	u8         reserved_at_3a8[0x3];
 	u8         log_min_stride_sz_rq[0x5];
-- 
2.21.3

