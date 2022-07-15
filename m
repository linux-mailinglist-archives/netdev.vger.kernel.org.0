Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42532575D6D
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 10:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbiGOI13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 04:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiGOI12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 04:27:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822F6255A9;
        Fri, 15 Jul 2022 01:27:27 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26F4uFOx032708;
        Fri, 15 Jul 2022 08:27:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=9FoZf4/qZXiunLvzhMrmfRDmPFhWGJ1UycWaAAPaXLU=;
 b=jNvpLqlxSYaORGp2yAmFsD+Zf6Q9IQWXc54MXiTBuhwj0jC4tK7CIJvk6SiPJ1wuEwJJ
 NXR/K1i1z0RrInyZtAEupFmavdkwp/UcUgCJ5Pmb2pzsh3qU2wkR8s6swS/2BcNg48Fw
 2gTYWsY6XOF6hctxDC9z+osGZTvBBu7N0j0gI7ntrtoWSUTgiD/XYxNwGMsk4lrSBEPZ
 SLpIPC1mOQB1maOLvoZ4WxmrOEsNUj5/qd5rPr912od6WRJA14F2kUhTm48U7yWzxStX
 gncqvPKf/U8J4gZtWgojSHJBKzl5a5JZqGsqu3mVpiZCcH8/UP3eix0V/zbsCwB1k6nL RQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71r1erjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jul 2022 08:27:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26F8AiVA006107;
        Fri, 15 Jul 2022 08:27:17 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h7046f5rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jul 2022 08:27:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SpGamx3D/2tB+5fQDeL3Ui/IJ1ALgoDCBOvtm11BBIs9/aBYDYejZjrj6WToMdcZKTeOPzUP3Zsw6lr3ajTZk55Z6s+MiFEZY6QkM5iOka538rgvU6XbLvrld0DJZbXj5HZNJ+dDCqDuwUMAWnJ5Vc8y2RKZe3up1PpoM5IZijOAuKk/7IEzjXr6Q6halfVpU4ULWa+0VXuFrQBIfT23ZchhWnBKClZ1+GmULAYFIbOJsspvpi+GXz9eCzcxn7edEhe1oXXCOjVH1O3sWWoYDnUQbdcS7bq3BzWZ8Qn41m9kloA4M9VXRGq3vK/8j7kZoBIb8f9nziaHMFugyyFH+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9FoZf4/qZXiunLvzhMrmfRDmPFhWGJ1UycWaAAPaXLU=;
 b=ij8hhSDWNY1/v+Yw5PvdFeKB0yeOHn0qfOVV6bCivPISPiEK3WBKLdZWa9vq2KmoJGxWC4rqUloH4w842jOWGQyPZVmWjv3VRsi1xxDPn431fDmWuWPiJD+0t0GexZt9chNxwAl93+H22fTe8wFP5oRa1i1Wu0DS+RcYnc14540wNBjXLp4bjPssmBwo8kdVL31aXuAnwvQXnsZUG241tUpg6BsJxwxXLb2U/dIGveglfENjzwpWl7Jq1ARQk9ebOiMLBJ+zz9TwL884yXVZhHFIEtmXBaRcK3nfzscEE5u8pXo53ywbLTfpyEJ28KGTRvtds5CM9cr8OVo/N4Xtfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9FoZf4/qZXiunLvzhMrmfRDmPFhWGJ1UycWaAAPaXLU=;
 b=qj5g3IkMc4hHunvin0sc7tPZapuSWhY4DqkRJQ2xbXP73wSGyNKou938FGVdvK8L+oH42EYutrWLuU/nLHQaYlteOVZF+4sS9HLw5G/MaDtf/TA+Cn/R0A8vIL3I9MY2KUaIkpMr5BJBj+3h9jvMVRuhlUElPrf46CzZBmVnfFw=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM5PR10MB1593.namprd10.prod.outlook.com
 (2603:10b6:3:e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Fri, 15 Jul
 2022 08:27:15 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5438.014; Fri, 15 Jul 2022
 08:27:15 +0000
Date:   Fri, 15 Jul 2022 11:27:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net/mlx5: unlock on error path in
 esw_vfs_changed_event_handler()
Message-ID: <YtEk1+hx8VHmxfa0@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0127.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::6) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e18fa0e0-a703-4590-cf3e-08da663bd2cb
X-MS-TrafficTypeDiagnostic: DM5PR10MB1593:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bhuo9Q5dGu9C4NXdlyOh8J6ITitzycTGjyLs2g/ehIBvmHwcC5yB0nR0Rx5d9zrlPE+0h71yby5b43uRVyResN2iUJy8f/6o0VdsxQAzTLoQigVZlNmjdb+4k7jJlT6AB9quUoYt02TrBDHe3v2YlUyGA61PSpyrZMnUVjje52n7my3IzN1+1iKaKf6YJMmvdsvBs9Jgx3maQyVrSPv/nai2sVVx55FoJm6TiNCJ9Uxwv/1hth0vHsvd72DA6zyahC/new+qfP+ErEBPcNGYwBtypsVKNgih02NqkFjaJmwglzl8Xhbrs06bLdhOeoyk8+ExNVuMdYusn/uujmmCALffaGXLekHqy9avWCUl9kASGH8zHj80E7Nk7aKh0izm54X1FWfCDp9+sFAjxEnh3lkEZrQ8nukmAGmZU7RU7BWcXlqkTD64N/3bvWMVpUOZVpxZ6qSUJW4gzNr5yvHdceiu5zHSpm9dD37chyEqN0EQbGYRI+F7tB+uEvrye8YdkLM0bzScjABpaDIwOxvVL5RroMw6etJxss+ZH7APzZxI1dIz82q9Sng+IzbW1OwfqlTbB2j8fdavB3XoSCIC+vl33ySHU8CtPY5X9cz/PuNmP5/xTUmEr/VpSLEvo/6HD2LHe/a/FOZvm8uNa1rPikYLnMLbufoJLa1Yc30/S14DIzx1csFbKZBjNk9MgqJGwye7ZSME1ak6NTbWKafmjK65BC74qwxj5ZEXWyF45AN6Ixy8GBLfice2ojcdHo3eOSO9mgfmGLjG6I+UPawJ/yjP7z38Miw+YYwXdZ9u0+Dny90loG7VGUAtM1rksK6ELHKgT8h2OpeOm8MlQLJ9Ng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(376002)(39860400002)(396003)(366004)(136003)(44832011)(186003)(5660300002)(8936002)(66946007)(38350700002)(4326008)(66556008)(316002)(86362001)(8676002)(7416002)(6512007)(9686003)(4744005)(66476007)(6506007)(2906002)(54906003)(6486002)(110136005)(38100700002)(33716001)(83380400001)(478600001)(52116002)(41300700001)(6666004)(26005)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OvkynnAuxgND2IVQQiIi+ytxniHFZzZevHdQJbukBeMFjy268kLS+UNNqauP?=
 =?us-ascii?Q?zqLcFnWfJ1wmfR/nJMoiS6Qi69xrEkMe/JbxW6snV8lFB3tLxcAwD7Jd7cIK?=
 =?us-ascii?Q?WZkQR7uGUw8B04pk1TuG6XzuqBSNtGtkODWGvyJQHJGGp6PjuKa80E1F9RXY?=
 =?us-ascii?Q?icybfji7DK/DrbQaM/yXd+whiRkthrUhrnzMqGZsiFK3GN7zzIIBBJBlnKlA?=
 =?us-ascii?Q?0E1rIlcjP756wOReQFgcDCtVmnJGIbG7/TpzrF2WkaD3RypgfQlOq3ryyoc6?=
 =?us-ascii?Q?NGCVyVMXmjje1BEKa9TxiCZQnjFnqy9omqjbTU6SIGOfDktpr2pTfMhk4r7n?=
 =?us-ascii?Q?6SEhp8rasYcxdCwzNWyWYtG35JMLPSutkDNbipzEsuuTi0dkAHDvwORWLIrP?=
 =?us-ascii?Q?miX8Y0kTb4s+U4TKME3jajacvD6+5ywUpawYKavUiSGq5Dw7sSF6btWI5Nuf?=
 =?us-ascii?Q?/YrEL1emd/g3GPSaU3MNtXoEsYU54yOJGW7KBFb5IAGkXIU1UcMcPoFZTKhE?=
 =?us-ascii?Q?nkGyH/ftJmRMlEDPRKkRUQ39OqpW8DGLS1/RXUpbmciTpeU5mavZ/3HrNTZT?=
 =?us-ascii?Q?sw7mh9w76nXHITNDt/KElOvCI5844CarRCNz4WbC18qt3GzV9pe94CYJ5qPp?=
 =?us-ascii?Q?p0VWXkBTRlZxjY9mYy5C534wgCLXaUt9Ciwb7NrrBftbBiTdKLefFB7AoPoj?=
 =?us-ascii?Q?DXOb95IlmMrEBfSGKcCb0MAnyVlkNjj/v96yLx93OR+r3iHkT3FCo4g/j8SQ?=
 =?us-ascii?Q?9Twj4AZ6AwaEilFz7CoqPE8qXO5l9X1Kqm28VMQhCUFZTBIhn7OJUTSYhqQh?=
 =?us-ascii?Q?T0UcxXErANQfxG03Xti24yQ7G5XKKVZzkMz/aV2u2mnBu3DgpfChq+Ued3qP?=
 =?us-ascii?Q?IxKQxtfVloGK5zVK6wlapX2B2TAto7Xs661LhrA9C3lvMIoaS+t5yiyN+aN4?=
 =?us-ascii?Q?6uJ5rvXBoZaMBmVme78lw46MsCpFSG3NsipHYECx+iZs8Nac33cv4GP3+Qn5?=
 =?us-ascii?Q?U43UcavS3T1OXLT84r70oP3SeajCfV58NG2QNcXeEhsdmC54WZ3KteNfnlNt?=
 =?us-ascii?Q?MzK2AQCbNpABO0yDt2dUOJfrLD3N0EsGuxatksVkiKiz5SRfpyd9rXuejst3?=
 =?us-ascii?Q?wD2tpsC5arlufFQhCxBomqnIztjucY8pBmxCzEzm6ybaBKQSJA2AIMgx+cKR?=
 =?us-ascii?Q?WegAdFLBYu4O64EwQPcwVFZOdOpl5JuL++fNo/gVvePYa3Trbxhc3YVMEvPr?=
 =?us-ascii?Q?Pk/xC1DQa6xZWhDjWGpXwX40q+64McfX4Ry4qWoLxGdtkEiJJW89Zk9T7uYd?=
 =?us-ascii?Q?s0D0Ec/9KKdbhj8pWK9Ccvk/kVq1PyiQojmiI6CS1JrXxNS4f5MQohZPiuwP?=
 =?us-ascii?Q?zGqKn+wolYTDLETHgiiFuyZJMH1Hqmw2Pz2z3HjT/hmQH2GV49hNUxplxdY7?=
 =?us-ascii?Q?I0JN5DnGbJt0Okyy0zX+c2iMfVD9M3IGpdMdZQXHs6zMf/mhs6e1T30F8ZYV?=
 =?us-ascii?Q?SD3wQ/2lwDS8qb2jzDyc8/lg7sJv5KU3/7ir6/U9kR4k5vx6k26yeLyK7Zj8?=
 =?us-ascii?Q?KSbe9I/46HGrxQYsxlFcxIDFBfbscPCALPRiReL4WAxNvuLJQbNFgYTSam65?=
 =?us-ascii?Q?CQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e18fa0e0-a703-4590-cf3e-08da663bd2cb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 08:27:15.4834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6qqhK8tf/T9ymFlLrPHCC999EIMUj2JV1EvMpvKUND6fn4onM8iLZpYZnm8zgCmIKUCOaVgFxGwpTrCFbBC7zdfiw7Kg6hHOVerXamJ3KmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1593
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-15_03:2022-07-14,2022-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207150035
X-Proofpoint-ORIG-GUID: qH7p33yEuzmaw6L3nDZ-2aCs_BJtGv5T
X-Proofpoint-GUID: qH7p33yEuzmaw6L3nDZ-2aCs_BJtGv5T
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlock before returning on this error path.

Fixes: f1bc646c9a06 ("net/mlx5: Use devl_ API in mlx5_esw_offloads_devlink_port_register")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index d3da52e3fc67..78e8883b2e83 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3104,8 +3104,10 @@ esw_vfs_changed_event_handler(struct mlx5_eswitch *esw, const u32 *out)
 
 		err = mlx5_eswitch_load_vf_vports(esw, new_num_vfs,
 						  MLX5_VPORT_UC_ADDR_CHANGE);
-		if (err)
+		if (err) {
+			devl_unlock(devlink);
 			return;
+		}
 	}
 	esw->esw_funcs.num_vfs = new_num_vfs;
 	devl_unlock(devlink);
-- 
2.35.1

