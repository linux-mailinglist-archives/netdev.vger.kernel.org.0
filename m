Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B44B589DCF
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 16:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239941AbiHDOnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 10:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbiHDOnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 10:43:49 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A38D100B;
        Thu,  4 Aug 2022 07:43:46 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274EbrqC031573;
        Thu, 4 Aug 2022 14:43:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=FojdGhZ6ctUvuuWYOO5WauC4INIb8go2GyaCcQ75z9c=;
 b=Qx+tx5BuHgwJrjmhSuntKf+3KBPhbx6H1XXXQSSkBadvX/oJ53ZQhCMdjxPJTTsTW6QJ
 3vhNoCu1uUNJMIY6htsYjz6giYw8uuFEYOfnFAvAOAxw1GRPkcbznbh/RDvBAUwBPkEw
 zA3yaJIFZZKficGENCSvbaZEgy70JTM5jhLLuv+b68sxklG+shKaZgS4/K/qRv/fgOe8
 m/hhmTtlRlPWKbRn/Z6rZJJxhADv1ccQ69qUOTyDTK7IwR9WFnUo8t/afUxftIC09b1o
 Sy9JJ8OSimmdXY38PsGAJ25lZBK024R7w7ihYnUSBwm/xnDH0M+e9CWXeDjS0AdhyEzp wA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmw6tn402-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 14:43:38 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274DUCuX030864;
        Thu, 4 Aug 2022 14:43:37 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34c005-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 14:43:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FAYuxbcTfcE+7ALTu38ckLWnQ70HWktYsF0AtM0X6oHmJs1sg6Zvx3FgLmICKOnc0HK99+H38xTR/uEY/B/lPLhdnp5h3wRbVk8DgbvTPOq7p/rG2+IwTa0l0Fc6c0L535xFuL0yb0LbU/c/mNW5uwC0Q/UVDkTLIA9W3RWFF7ltB65txpYdtFUfWGNhuziudB+Ds7IS1aIjEIU4NIrp4IH80xlWcyAQbDAjfxAIMryipiRP74iEu5jHHLJvgJPiI6fJRz/hTB3gjyQoaCBz8Ghl8MRU0qykizqp+M9yolz1Z+O5NdzpGwb1rZnmOSim/QNxByb6FNfQYk8yJy8VFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FojdGhZ6ctUvuuWYOO5WauC4INIb8go2GyaCcQ75z9c=;
 b=E4P6r/IR1U4pqynRtTeHdTKo4saXJlTO/TWdV2uLb79jlp46jxM/2dBwElVWStQhtvP9gW7zuibDZMmL29REgfqK4lDarMP5DI/Z96IGjBwOX9wx05QU9y2eVWX5zL/cP5txadJXuONF1kXGJan7CTNdAKlZlC4Ww7teZnfn1kxYDBrjxWjAmFO+AhZghovSE8ReNYWspfzbn/zp6K6OduNIUQgSH8vPciY0QtOFQ3X4xtZQEjTCLBkh1pnr/G5ImFmvYLN4XmRHFOewIFk9MfqhLbHyPG7DNYTzOrvNGcx2179bfLcQv3np2pwoQjyn5O8XhW8n0v3ycj6SKTtq7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FojdGhZ6ctUvuuWYOO5WauC4INIb8go2GyaCcQ75z9c=;
 b=j0uKIrkrSeCLHDnkSV3kBno7TTnhQeRenP7u1whOnsXKJK/xtUE8on2HWgofBbBSFImAko1tVcCFBuaFmNrFoHQnlAKn/8OvEf0iAXUnk1/2cWXge2IW+ZunrQhL90AzWVCtXAIUXJvUsW9VjR07pQRv+pXTXzX/LpLyOxK/LXY=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN6PR10MB1475.namprd10.prod.outlook.com
 (2603:10b6:404:44::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 14:43:34 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 14:43:34 +0000
Date:   Thu, 4 Aug 2022 17:43:21 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Saeed Mahameed <saeedm@nvidia.com>, Lama Kayal <lkayal@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] net/mlx5e: Fix use after free in mlx5e_fs_init()
Message-ID: <YuvbCRstoxopHi4n@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0172.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::6) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85b1fd80-1837-4230-cc86-08da7627b547
X-MS-TrafficTypeDiagnostic: BN6PR10MB1475:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4lGOyjpRARqGxPQkVfWtXppZArakVjY1AldBxHeAUxWveFu8BgYcuxmsNl1EuBvM+YH2B2Ecj5mHElMZgjWzkJzEg4Sb5tVt3y1Ee93IV3qNn5JSChVX91gXfhagkBM7SS4h0U0QP2RZ20fbtBuwY7huwtjZZAudUzXlEkWlGUZWb1HUvMadop6NTsN/djPGz4goZR4y0tx4/FXqNY5ly2DU/h0kw9wVJd7cwb97hW0vR2D2cQF6PhbpzmMY2JRXBMiVB+cvuXDVcD87ZEJtXy87d+EjLKpxPY7dxntF4M9kWiVIQcWjxyKNGi3vBs4JyNa7lcfpgvWQd4/ztBArC5JMB4EnbVm+q07bXrsidrhSL+Woa1PpunGPP2yllTSBVMNMoBTUU8/4KRFQPHW9S+Bg4tIvpJUU3Jz9Ngs+4alPaTQJStczBlo2lhdDQou6LTEtoPD+d5Tq4rYcDAdVB8pNoCVfedlzEQOOLgIC1/wIz389FgzdZa1aHMJTYfDqScQWqMmISwjz/FQQLvNMQYS0wT+RUkrmTy/9Hyt0DSlgXPAtl4zXUZZSiy56N0XdEjLFpFpN46YPK4/SDX/bQNH/PpN8P6ML0BP1vvG7+ceW29cmYlPqjC58cWUHW3gHv7po+Th2Z7Q9P/T47xoah7S1n2fcDtVrApVAt1OB1skKXC/DkRIvFuK8uLMnRzsjFkYCr9nx56pJnobZa69WLDNR/GZ/9WTBHglOjXSqnVQfaB9Uhw0VJ3o5cLqnqlZlk7tanJVPay+YRBwtBLGa6W1lmPKZLtSScOrYww961kA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(346002)(39860400002)(396003)(366004)(376002)(38350700002)(2906002)(6666004)(6506007)(86362001)(52116002)(8676002)(66476007)(66946007)(7416002)(66556008)(38100700002)(41300700001)(8936002)(4326008)(5660300002)(4744005)(6486002)(44832011)(478600001)(110136005)(54906003)(186003)(316002)(6512007)(9686003)(26005)(83380400001)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tc5ukhDSxOVA/H3oaYSeA8DtvHnsJcHxKuRPEANT9ms7omtI0xu252NNLjoh?=
 =?us-ascii?Q?PlcluN1ZYO0sB1NoNfSj7sejRs7zE3kW+65YASEcwvlnHvrAILuAIMZA9mtm?=
 =?us-ascii?Q?lQXODbcE/MWSG1loISNEDclr6S9U8PKEbGp1lA1kZhUVeFNO6OtKL5t9u/bI?=
 =?us-ascii?Q?607sQcWoOz/O/Wd0bYDHgom7GxqBJnKWz0HDmX+sDCbwZWvZFkZGCSmsAzQT?=
 =?us-ascii?Q?26YUX7gXFeTRcPaIw09jFgz2HPvYUeieAXMiZGUwR6j62sokD87yg3y1mgAZ?=
 =?us-ascii?Q?nj0BgADdlyYnLqXjN414ZVdCwEtigdKCzgLHG5e2iBlSv93ymhhKBIvQXLZW?=
 =?us-ascii?Q?ltxoP9VG/kzDcAqZ0LrjQkLXA+hTqd9+bZWhI0NaU/i8OpYG3G94BbaJeENc?=
 =?us-ascii?Q?sCxY20BVWlaeWnA+kG0RPWhvtVSK2lzWD2vBzgRL50byUy5yHizu2Uwkyu17?=
 =?us-ascii?Q?KbViarjKT6/EqSGxUrcpqvcx7zTq0qtSl2EaYqMYtBxTkzRqCIUzymdIo4IL?=
 =?us-ascii?Q?CKnJWTbhZusgJgPy8WAE6Dh0udbQJTIvXf20UshJikFzgUdm9+v1DL61L5Zc?=
 =?us-ascii?Q?8q5r6489X1yW+JpmP1G0ZveziQhERVVTjY0OZeCAPGhX24kEPUt4i2la1S6Q?=
 =?us-ascii?Q?HFchOCGE5W62Tw8kRpzeNyMKy7Tdzq5ciw5XLJma8nSXmT0da9wxmhjmy/Cd?=
 =?us-ascii?Q?BTYB50zSrXofoqvtbCQ9JaxwTb06t7uT5zZeukvHSOeOVDXYZHkCdHWLrmHa?=
 =?us-ascii?Q?JBVDwmf5opdzrExej0FBWMfr0Dghcd1ecH/Vb/whjE0YAwQvg3OtLQdW+vzT?=
 =?us-ascii?Q?cicvSINYx8H06ixsbCpLX9F2lIpxOLOez4u/YmIG1VjcUO/XQDOwwVrn0INi?=
 =?us-ascii?Q?AjvzW8KrFb3FHvPOsbmoZIujQOsQnTNhdql7N9/FBXIDh/Pvd7kYFdz8GjSg?=
 =?us-ascii?Q?sh781t0SuJSZQDKtms7tseOizCCwdmKkfrb/q5czJGKD96OTYidoofa+XToM?=
 =?us-ascii?Q?VdpZfJaN0kW0Uf4gcL8MMMfCrgKxTKMHm1yyUpyFGbZbJ/s5So4SP1ZNU0sj?=
 =?us-ascii?Q?zkercqcZBVG6a/qQJ0DygDNHM7uRTEbqrIKOHsDfV5T/JYO69RyxKkknvDFg?=
 =?us-ascii?Q?lQNPp3pgUSEwYRzViB+u6NgJZNi1DtLDn5iAggq6PdqaH0oRlwrIfoGwinJO?=
 =?us-ascii?Q?GEUxZeb7KSm1TWJeeSeuUUYmwdy8pVYW6fpN7tIRo7SaTQtopcCqwPHhkpAD?=
 =?us-ascii?Q?W/ubJb0kphlONSeKXQLwN+2D8OOewjx3iHEH3NoBwan2BHSGxEF5lxgOOjsz?=
 =?us-ascii?Q?FpQljNcg6V5458OFHfgtafpWZZmdQKVq+jFwc69kN+CjNZ3v5jqUZXW0BRnD?=
 =?us-ascii?Q?swcLmz5VyNOg5nM2BxWJl8TAnpIW4ih6ij8Ai50/T7qdcH0YnRhSSi9SMvkH?=
 =?us-ascii?Q?f+dI/RZ+dnP2xEVGRgp3e2/jX5m5H0+Gate1ESQapq259bY/BZAWwUN3htDG?=
 =?us-ascii?Q?73DGe7d6oNiy28WYPEa4hf7NFq/AhrLA9/jUx2TZhxFsux9I14oZ4vsvM2Hc?=
 =?us-ascii?Q?RO7TxcmBJ1gydMIpbUM+tzfudHnUbgmctwjwJl+nCYjequNaO/BAqKoN3ge2?=
 =?us-ascii?Q?Yg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85b1fd80-1837-4230-cc86-08da7627b547
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 14:43:34.4623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xHZNQZsBC1F4t7lxfgeqFwbOSZSyBtiQJ2uTga0dwxeKyc9B3bYs6OXcHHTUVuBu4zbt7kPU/59NEoMKJhK1cRyObGmT1vHJnI+4gQyrAvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1475
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040065
X-Proofpoint-GUID: xSD0oMM3_yNxs7ztZPx2hR94s5bdzyQQ
X-Proofpoint-ORIG-GUID: xSD0oMM3_yNxs7ztZPx2hR94s5bdzyQQ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call mlx5e_fs_vlan_free(fs) before kvfree(fs).

Fixes: af8bbf730068 ("net/mlx5e: Convert mlx5e_flow_steering member of mlx5e_priv to pointer")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This applies to net but I never really understand how mellanox patches
work...

 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index e2a9b9be5c1f..e0ce5a233d0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1395,10 +1395,11 @@ struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
 	}
 
 	return fs;
-err_free_fs:
-	kvfree(fs);
+
 err_free_vlan:
 	mlx5e_fs_vlan_free(fs);
+err_free_fs:
+	kvfree(fs);
 err:
 	return NULL;
 }
-- 
2.35.1

