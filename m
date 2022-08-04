Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC7A589DC5
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 16:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240126AbiHDOk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 10:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240184AbiHDOkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 10:40:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACCC4D4CC;
        Thu,  4 Aug 2022 07:40:09 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274EbpU3019258;
        Thu, 4 Aug 2022 14:39:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=K7M96HkyYYDujdwClXqXxaTRySl/K7qOTHUJ8E5H2rA=;
 b=HW6CVEWDl/UFtTvvDcqVLnhMB0m2ivirh3tz0KiOoHLB7iSX443GiKV1zuQtF0QTzcew
 GZneFLeF8T71SqHIfZ7kigRte5u3H0PkGyZyVIOll5QEF3koplk+J9pa5Z6B83kxfX2e
 GDFWCHJzam26VE/yyWXw24DVkQ7otE/PAIaeLmdxcKz/nHqlWcBsBcCahmYv4t82g2WQ
 UEA0Z9v4N6Nv9ywbvBsaA5uaAvj/gceU/KaXh/2MhfHlmrv9edcQKykWc8GUlMwpMGA3
 DkccQTAOmBJlblgJOrU4PUUV4BoqoxsxhnlJuY535eHfQVu5TzB3AFSffejjy0VdGdq4 ig== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmue2w862-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 14:39:47 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274BjOaP014203;
        Thu, 4 Aug 2022 14:39:46 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34de1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 14:39:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbGHOO1AsnTlBm1/4+0bSzxkGfrJ9qOpTBUR1qI6yo4fkchCqq6rbCNNHm8y7s+Z2u6d21R8Be662pdBG7gAn320QtBGQApc8avjlbLiu7tOZuwDmAXboQEOiTL107nLinxCt90L/Qw8GL/tQrkQfaYCs7I/z+EhufYPZyLc6v8M0LmRNYwxSzhnYZtAMUlDceUYQ/HWwTXvgQxOLMsOVhihdgcH8cuNDVt/dlZXzEuftpCwcBfcACrFLn0rxQzudq6KXj5c/5qQLitv/zXGhfVvLARzJk0Uj3zLNeLe+xEPXICpEAp4uvde8cr3UrI6WdfIQnuRqSwIAJvGSGQZpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K7M96HkyYYDujdwClXqXxaTRySl/K7qOTHUJ8E5H2rA=;
 b=ogdDhHKU3XajsbGxO7EaMBKgSiPw99iv8jlaZgrwqK9PT0oyAHk9yIXUxfAOYjrjXiHLR2xMOsAcr4vsaBB13wH9weHzksS8tBafkDH2O/QSx1k8jW0L6U1tVzxnqkrKCfVDsYq8sywkObHNQSoxdtPL4iabPDno26TlDLQC13bfnvpXpI97/ac3N6sjUmu5/hbuLHnYi88hQFlemWrrSb1MBjiR1C8r9oVA5A16e9T9FUbf8Iha9GpOI9m11Aj5iJToS37DgKQUpINJTcInhFD5NyBKkZ2jRKdrykElaUxxHmT7X60IAshep7PJPQvka4wKqXtzggyNsdyOt+u7Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7M96HkyYYDujdwClXqXxaTRySl/K7qOTHUJ8E5H2rA=;
 b=fwwTtongX7YzasZEqo+7OopZxzic8ux9rD/pcisLkYaQZN1HaNzwfQvP7q6Pm4GcD74ZyEbPwclx55QnYqyrHmmKQ1sdc4XNaCtyg5ttcbitFL49uc11aD3kDcyjdI//BJzxtpnDgclXvLJoJEkyxgAX19xLd0TJX2dh1+xSxeg=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH2PR10MB4374.namprd10.prod.outlook.com
 (2603:10b6:610:af::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 14:39:44 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 14:39:44 +0000
Date:   Thu, 4 Aug 2022 17:39:31 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net/mlx5: Unlock on error in mlx5_sriov_enable()
Message-ID: <YuvaI7lIzW6e/Mf6@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0190.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::17) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15371b86-ef7f-4221-614e-08da76272bdd
X-MS-TrafficTypeDiagnostic: CH2PR10MB4374:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Z499VA1OxXwzrhbGQsWnGqAjBMjD0Cj7EUnSF3BWOaaA2Du3TXvcalqxV2axWvgtIJh+Ea5k2I3dj9/VxdUVTnEReY+j4YtnRo/WJnXQuFexiY7S0K2Ea+0pc6HJDc7u7ZIvHbKVOldh8TbvhB/DDBmiyp//k0Rx/4IJ1EmeYb2aPZ2tmvN1E51JKaKpwPwAUecLKfx5YPTfio9l4b0cvfsU3B6BgGxe+KjP7w0DSKBV5qyUn10Ji4ccR6iJKfRthdrpn604c2fL6jUjADCbCx9MjIezO2kAOD8fpFzJznPpT3TW6LnxiMF/DvQd9hj59nJhdE0KIc35YCzPg80hrGX6X2F/JcH+ZLigSbuV/fsuObM3ACOrPNbb6alDQH31uM4ME5TJ3Ze+46ippEO96oYY4lv3rSQQNDw6w0Ffkas6hbgEqWdjXWFB0LEttg34dTBtkF+yE19iC6jqbjM2NElsec69Ms7jgqywex1PoxCuNXA7gbm7quQ5Jd58H46C6LbnLYyAG11GvV3Yjg0rl0G3slBzIHRZxuy8S47ZzGUSwY6QtyUY3zPizhiz7rmzK0/8qHckXFN3cPOkj50T66E7XI35AbJz5bJp3eRrQ8VD/qFBoG+bJ/2rn4kYn/N+pN6A+hAFaLHEdg+LQRM6PuakyT3seEUKuRg5T30RCphkZygbpkL++jyBThx1wpbCTBI7vfzNB36GAx3jcaCYLN8hWQ/0Bcf8Pn5NvN43gJQV23haahY/HQwhx06v3tGSQyQvX8i3mKSP5GMFNbFs2oBNWxKpXx/NAKwcNdAYf8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(136003)(346002)(366004)(396003)(39860400002)(186003)(38350700002)(38100700002)(83380400001)(8936002)(4326008)(8676002)(66476007)(66556008)(66946007)(5660300002)(33716001)(4744005)(44832011)(7416002)(2906002)(6512007)(6666004)(478600001)(41300700001)(6486002)(9686003)(26005)(6506007)(52116002)(110136005)(54906003)(316002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FjURbRoWfbGyelLIUPr60Fne11IF9xxic66t9Lcx76N0trwIFuvHImWpAFbv?=
 =?us-ascii?Q?aL5kRwOu1njptHuDo1CZUe2YLAgBpvRfDT7s6EVw/nwsGY0lR54PYUWMSzB3?=
 =?us-ascii?Q?XZVtlzz7RigRfyacYgVFIqAVOVZh6oVECcIYhUkLAiSKFVA3tl7t9+/cPZft?=
 =?us-ascii?Q?k4LuQVtr62hDMkvKgP8Wc2lcw7v7jGJjaXTsIUUvIcd+6+EMS19ArDxDEblu?=
 =?us-ascii?Q?LXPvG0K4Qt8kGOWWUmk1+5p0a1yiFbTLmt5sBAhnkaOfWpDCafkxtJWO3Z5I?=
 =?us-ascii?Q?+ZlQVKL7jJHBephBV9eTDJFvxtIg6HS24fYqr5LLoo0L7A+bSPP5EP9M/9FI?=
 =?us-ascii?Q?xeHK84H0net1vKXLpnms/dBEZVCfpsJvQzbZ+BroU23jsvSrmE4+WUFZ6/pg?=
 =?us-ascii?Q?dq1oxZIraHNP9M3fBal/D9nfYuIm+mEMVKL7fc2i9AZsJuCZ0vwUg5wtia0d?=
 =?us-ascii?Q?WiIcwd/7P5VAyET99lbzRhZn7kCtvBgi7aMHkccxg6+na7DQzgjqsM2oKThV?=
 =?us-ascii?Q?n4/+Wn3KlK6W+axt4IfylOyc9i9E94Y5DhqBJLRuzxSmO1zIIU1bGvVZkQod?=
 =?us-ascii?Q?oOlNmIS2LTyrotg0POuZbPMdFvxB2SBemI8lvOHxbjtzrIk6hXDMKv1r3Stl?=
 =?us-ascii?Q?akqEuF2JykUu4ppH2ZTrPIaWvkkGB238ztofJk5cesZdznF4Bny83Sh5Mbrt?=
 =?us-ascii?Q?OyIxnqOjrj6hpAcZZk489mRJ4XYnn/HblGK8etg/poIXq6Ire8rmfaTAf9f7?=
 =?us-ascii?Q?QIl+yeWmFF3IbcYEHBgZnDS6Lh5yMITHmQbusn0VZ/8n5H4kl1z4sEQtMM0z?=
 =?us-ascii?Q?pb5a8tbpcf1/Zac6tl2iKq0RlLDhix4zTZxw3+X5SjMlBuxv6u32Kcim79rq?=
 =?us-ascii?Q?jodd6frW9765mM6mRrrw9kv5NGAfss/CT96nK5hNp78xEuNH3EQL6Vc8lko7?=
 =?us-ascii?Q?75gRkN+ICi8OLzOHLBakqMMQgk4eqQ6vTCldktbRqAAAGtp5TXw1yx4JioDp?=
 =?us-ascii?Q?BX69zG8CZSKqBJqM2tRkMNWhmbdVfJOqsjXEglP99mqTS5v9uoaE7TtOOLcF?=
 =?us-ascii?Q?ACdpyhUs679WSvMk9K8FLVejXZXaez0ONR/mWFhFTN+vAlBy7LhCfRdJPLnE?=
 =?us-ascii?Q?Mj0YE0c/n9uCn99sYzuOn0q3A8S/7K3m5lbF/UvuqeVddwVmeOK+7qrgF00o?=
 =?us-ascii?Q?jFXyGwsm7xzUjmKm6rpgMfU5/+xoF1CYrYwe08kUGYioYm79RqICvM5LEcaK?=
 =?us-ascii?Q?lrlZMgeOunYlPfe8eLfNz3SjCap4LRRy/QT+OODy30Ztjrht8WZDCtYXhKKp?=
 =?us-ascii?Q?QCsqGetmAHqKgi4HfPnzgJFbAMQINZ++C65tnXdAIMMl5yaltmKv9zZE7k4/?=
 =?us-ascii?Q?W8uczvbNOzEHrS1P7aDVJzw1WR+eLp29lfX3oKwmb5nZJ8Ode6JzOaT/HkmK?=
 =?us-ascii?Q?bMmCThUNWgCB4AnTtlyoIfmhTk1fFQrf13ZJlaDB5TINNv/mhnU95S2g4bAI?=
 =?us-ascii?Q?IxOtZ2/rHYeYx+MXDD2DJQ7Cyr83wZ0JB5RyZJx3i1JtMPKY15M3Oj7yewU1?=
 =?us-ascii?Q?ZUiwG0vIAeviRnNjxZvh9NL9o3xoqPtHnRJU0INLHwTwt5Arv9fXDbwTOCXa?=
 =?us-ascii?Q?XQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15371b86-ef7f-4221-614e-08da76272bdd
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 14:39:44.0264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fCkzJp3fTUOQHnnziCCwfF3vw5QFP9jfAioEPUIQwGPTad0h2njWk64TiJgvaigyLoIObo6q8qHiYScz1B7K9y8slWP1wENCn1JwRRo//jM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040064
X-Proofpoint-ORIG-GUID: IQkO0-9UqCsJqG6aUHZHDaIPzFJncRY3
X-Proofpoint-GUID: IQkO0-9UqCsJqG6aUHZHDaIPzFJncRY3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlock before returning if mlx5_device_enable_sriov() fails.

Fixes: 84a433a40d0e ("net/mlx5: Lock mlx5 devlink reload callbacks")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index ee2e1b7c1310..c0e6c487c63c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -159,11 +159,11 @@ static int mlx5_sriov_enable(struct pci_dev *pdev, int num_vfs)
 
 	devl_lock(devlink);
 	err = mlx5_device_enable_sriov(dev, num_vfs);
+	devl_unlock(devlink);
 	if (err) {
 		mlx5_core_warn(dev, "mlx5_device_enable_sriov failed : %d\n", err);
 		return err;
 	}
-	devl_unlock(devlink);
 
 	err = pci_enable_sriov(pdev, num_vfs);
 	if (err) {
-- 
2.35.1

