Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF869537A0C
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 13:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbiE3LlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 07:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235603AbiE3LlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 07:41:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978AA813D8;
        Mon, 30 May 2022 04:41:08 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24UBY0ki018415;
        Mon, 30 May 2022 11:40:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=ClE//N1ZdtYHI7rNVcCNPc2bdU+f12cLXCh2+wZ1kEo=;
 b=fuwTS2l5mT5E9SqX95vO2xffuJjtl+V9gKi/Imx3vMfrRxVC1TO2zu3OawTNhe9FQrHo
 +VOzs4dD4Tx9byu6Zb581Gnm/0YKaGX44l9h0G+2QYnkXwEQ/Zif7gpR4sJHDy3VVk1E
 cfxOyCnEyXpQt1SbP+yR8FAzPiA9X7NePWkzbVgD5423wRz3OyNoAph2bIk4G6COFgs/
 LKzw/9aYyGl2CdGoYZrbELV72AcqYYJa+nDjlnyUphqeAzZ3pQ6Eqyiz7Rg0x90WFrfP
 2Jw7aQC3mHSWryQ7ekoe/EkhdLMA3uTksMx90bUGjYYq4DuQU3jvxR/oaGZLEHj6WqF4 mg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc4xjtqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 11:40:59 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24UBVkJm006449;
        Mon, 30 May 2022 11:40:58 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8p0nuyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 11:40:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QAP8nEOTAVXLxfZO+nHU1D2mxpSmHgG/ciKtkU+wchHdsd5kt6tO6oU5tC8XFdlB54s9jae5Mpbr+Pc8bhaK5mJ3LIQF1z24KqiZ+iEFW9tED0jVGaZaDkAjw8/yAIHnjoc1bntkB+xToDlgjrjrg0dGvKO528kEDIhx8lz7E9l3a/2aLNAS6EdZLyJpCnFpChHhVEIg6Ck71L0VRF/uohdQC1xLOgSKcpuCCnIFmeA+ma8Z514FvguWABu1WiJ+HsF8rp5C/s6F7yosi7o9F9iPT0HWUjWkdi6qxYg1WHwgkca97j1yy8YuyX7O4tnc9zz8SWnye2gCtcq6dejNcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ClE//N1ZdtYHI7rNVcCNPc2bdU+f12cLXCh2+wZ1kEo=;
 b=F18l97lMPX3EQrF8fcpgVKB7EVMBqG+72YkaPntakbg2U8FKb3d0C2hzgDgg39MMc0iAlur9KsHi6mz4mkm9g3u8SAbTCc044e5+GJeP02f/+hOneRwjyudVh1TwWWWGaU2pjAQI8Ea2M9qYh4GY1/1qLm+TWzGAyMDVeZX/BFllRWyBC4fDaYkhKXkthJmmdS/ZrtUA4u+wtlGcEAYM2mGoNCcwDPZvG3uBOr80Unl6MlxLv8JVSh+V2s8ZOawgjfzMSQZAVabaGttV1fQv1ZwRC0pRYrT/yK0FbRUPP3QnSxzdS163UBFhD/bil1aby4i6/mTZ0R9Y+tDpKZ7KOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ClE//N1ZdtYHI7rNVcCNPc2bdU+f12cLXCh2+wZ1kEo=;
 b=k9s05Lkw7lvJOyPZ/E9AiDW2Jysx3fO4W/P/abrNaG/xsUbkfVxRJwVfXCEZhKewy+vWH3mpI4HbCqom6dVDZOVrZ/rT25ZnoXAc5/1yMqHGnU+XZP6uXZ3WyjcAQlyTjgdZk0WBwdYCyQo1JkVpKo3GUAfCPzBbU+wqzx4SAUY=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by PH0PR10MB5871.namprd10.prod.outlook.com
 (2603:10b6:510:149::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Mon, 30 May
 2022 11:40:56 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5293.019; Mon, 30 May 2022
 11:40:55 +0000
Date:   Mon, 30 May 2022 14:40:42 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH (mellanox tree)] net/mlx5: delete dead code in
 mlx5_esw_unlock()
Message-ID: <YpStOhUL4j7KBSqt@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0065.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::16) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2446f3a-705c-4d0a-79f8-08da42314229
X-MS-TrafficTypeDiagnostic: PH0PR10MB5871:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5871561449C36096028CB6D48EDD9@PH0PR10MB5871.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n9xizpYh2ac9J8Uai/iTuuzqv75SfzqOuJGCNvF3Aoe4iFhsdUpwcqAddOuMt8LSngT39CgEYWj0P0mja1+6R4MCKDpevutz9wYNusNox+j9hCr7930vmYXHB8ju6o8wswIV50dMT5K3KVEbRDhqj24xpGWCIzfjuCwTXf7oNFBlBdQIfueS4HkvuLqcQvt8fUZTlM0pf4VEh/u1et5xYSqEh9LlWpnnhtmuPvv4/Zmwl5OgdVUgx68b4Dx2O0cdFj3BzW1mLkPRPvckSUVtXlCh/NZtfWMYri0HYdS9zS49Pmh9C70IzbvpRLuJJydgKs41FvBnQpG2qP/TtdAJW6AX/omkDwt3P5tXjsxfCxQdqDn+vkDMZ6J5awZN7fq74X+gSzp676TSjBQnwlKQ3TveKrP50H5S6bv9RQym7Lvv7vE8on4ZPJ0/p7Rk9EbKuLtHe3NWliIA0r5LJdBiGOwMmO2oAUccWW8GzqEJLc+m7DoAv81hhz2fFd+qPW23n16eBvVM3uDcq+G+A3/XXnqMEiUnqGnqEaCzAWX07IpsfBeuqBuXCo3uTbGugPw6ALdwgEVFZFJXAwqUPjdM36MjU/zDzPSPgHVBFSOJC1KuyZepghanxZFKyd9hra4/mKBvtkRk8mCmwhrZlkdOmd8wSGJYV7qTAKeQfWeJNySg60VRRqsk7L3xt1bKktBZ9fAuQmtyPcNnrEN2Xv3yOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(86362001)(8936002)(66946007)(6506007)(9686003)(6666004)(6512007)(26005)(316002)(6916009)(54906003)(52116002)(2906002)(8676002)(66556008)(38100700002)(38350700002)(186003)(66476007)(5660300002)(4326008)(33716001)(44832011)(6486002)(83380400001)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jsm+fCC+WAff8rcUvubYq2HpI9qyKAMPTMDaB+gk05mnXc2wazm0ZwZsTXyg?=
 =?us-ascii?Q?JgqClgtWMt10T8WBhsRHbafZtAC1kQrXgtN9f4Npeen5D644r3Gjbrm5WRHq?=
 =?us-ascii?Q?tnoH6lXdxiUg1OB7cOgFgB5UDNjmV76u4EAsY4vzXWnRPThpr+uFWpOkP2I1?=
 =?us-ascii?Q?UtAtqSO4ZBr1xCl3uw9f2FdIiSqm8t5FLgU4+eZ/6EtRoJzLQoE+/Nfw/Ggj?=
 =?us-ascii?Q?TEJnqKEyivP5DHcQ6xrs9UcCUDw3+nEBKicSoJfwn2tB2CmviEBffrpj2+ob?=
 =?us-ascii?Q?eMaQvbn3rOrnYa8qGSN0GEA1ceVjbkcx5ah2YupOJqcBIF4yUnQyMI8z33u9?=
 =?us-ascii?Q?8TsJpsOAezFe1E36OfnLMw07z9Fw7cuJLxMQKlW13XOKZUaj/An6TGVsUnKb?=
 =?us-ascii?Q?brQyLrIg6kF356DzA7ZnDrPGnLxPZSKM65ahpk4WFce6MU//5HgPHcsh5rUN?=
 =?us-ascii?Q?Z8GthgC/48OpjO5dg6BpyRI9l0s0cCHXW1hpvh4W69TJyOLZ4VSVQU4/cNWT?=
 =?us-ascii?Q?fAmN7HC+SwSmcYACOyfkXxRyy6w/GGPke1MAlFVfyOtABlk6aIU16gietETV?=
 =?us-ascii?Q?E5/+dkkexSBp7wE/zR56S6nX3yWyoo0BOoUpnX9vpBR4kcgjpCk9Jp+4puK6?=
 =?us-ascii?Q?TajQQ/ub2CsNo+EMSl0eDXqFQUrlvG/oa1RXGiD8457+SyZGWjRmiLP7uFAa?=
 =?us-ascii?Q?pfWN1sqOfuQ232vrGxanISwZWHL3cK1H02pU4Co2+JlSlh2B7uVUguvGy2AA?=
 =?us-ascii?Q?J0thDnRSGXEaoqgb8leU9jO+BpL2L0NW4feaELb8U5plrGDLmwtNBzu08ZPO?=
 =?us-ascii?Q?SGEshfSaKz+lnKeMJ4vxyhuj9TcCb1ZJo6V40CwjxIobJSZwtXI0v4l0/ne/?=
 =?us-ascii?Q?B4V7Bwx+HsNr92Jync1e/myti5PwMCkYsLulxxjVpIA1OV4ZbqTlg3ZuSwTS?=
 =?us-ascii?Q?XYsRHsxWV02PfaC/6TOriNmIalQcPi7sm3oUSxojSqxAXaSoX7WUAyZgqMZQ?=
 =?us-ascii?Q?Va/dCkFrRARgM/dJmmjVFhWdO0fKQTdwcJzsUdYtMoXxyVDbeQmL5iHb/vuC?=
 =?us-ascii?Q?vGPIJGjCzUy0Xz89san0CIHoL/IcOK1u6M7PDFDlCACj2evXfvTu9HNuxTLj?=
 =?us-ascii?Q?oIvjJSdAeyIZGRp1paltGUT0+rs9q/rDChlmoP505Ty8c8dSkZIdakb4KE2o?=
 =?us-ascii?Q?0a8CeRTHvCkdzqVrJzd6vFC7ZqJRjJQ4fRtfVSiCrSvcq1Lnnc2/rufRGDqa?=
 =?us-ascii?Q?Tzm4E5BMgYgF/nWt824npjlBDaaq+nk01a/qUwgc+YivFPAaRR+kXKx+Pnwr?=
 =?us-ascii?Q?J7CRFfOVpEeU0PH8rwXVNtSrPAooHsY6ScAuSbcPxdJUngiv7aMpz3h8iyuk?=
 =?us-ascii?Q?GhznJvaE7cFAVI/S+D3cwd/L7jGM+pbesTGAc9Hbp7Q+sK/XCXfwMUwnFMC6?=
 =?us-ascii?Q?alMpT8ykBbOcAAiEz1aQKkU84SpGjNDqBUMLXqSpGlPHKk1Zkx+A5C2EUxK4?=
 =?us-ascii?Q?5pvBzO9GJiBIwrjuhoN7ifny63ZzRlZZbP+FeWM4UOWXXiItohHmwtEUyDeQ?=
 =?us-ascii?Q?aiRO3C+biD9RfeyzCass6WIZvKyJO3TP0x2g41F1LjwZD5EKGrKOA9NE3OqZ?=
 =?us-ascii?Q?a3WND6v+HiioF6XfbzBWc9CvMgyv6blVtJCCwUW3shEmhK/Qp/YnAzq4a56t?=
 =?us-ascii?Q?tDlq9/8BNsQ8UCaZpoULy2jaijIS8gd1+aGmJad9laWq6zlOT0kD6F1FNUET?=
 =?us-ascii?Q?eSVleNCcqERm7lY0/HviBx7aRtMUI9s=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2446f3a-705c-4d0a-79f8-08da42314229
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2022 11:40:55.8441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dqovn8k903LwJ5yx/mGnHgBWqFrIPnUmQlu9YP+HK1iHt7gXglrX9viJ+np/QU3nyoV3922I1dgKZR6a2ZbYL4CQmiaX+eSrvpSgMhU2BCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5871
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-30_04:2022-05-30,2022-05-30 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205300060
X-Proofpoint-GUID: BxydhdLoMyXSdg2WA6xwJXP6SgTSPXl2
X-Proofpoint-ORIG-GUID: BxydhdLoMyXSdg2WA6xwJXP6SgTSPXl2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch complains about this function:

    drivers/net/ethernet/mellanox/mlx5/core/eswitch.c:2000 mlx5_esw_unlock()
    warn: inconsistent returns '&esw->mode_lock'.

Before commit ec2fa47d7b98 ("net/mlx5: Lag, use lag lock") there
used to be a matching mlx5_esw_lock() function and the lock and
unlock functions were symmetric.  But now we take the long
unconditionally and must unlock unconditionally as well.

As near as I can tell this is dead code and can just be deleted.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 719ef26d23c0..3e662e389be4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1995,8 +1995,6 @@ int mlx5_esw_try_lock(struct mlx5_eswitch *esw)
  */
 void mlx5_esw_unlock(struct mlx5_eswitch *esw)
 {
-	if (!mlx5_esw_allowed(esw))
-		return;
 	up_write(&esw->mode_lock);
 }
 
-- 
2.35.1

