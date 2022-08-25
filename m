Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC505A11BA
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 15:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241332AbiHYNRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 09:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233371AbiHYNRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 09:17:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB177201B6;
        Thu, 25 Aug 2022 06:17:51 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27PD93xD030009;
        Thu, 25 Aug 2022 13:17:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=t+jPR63iNUIni0+qEpDF+ADRMLverfo0ocj1FSxLrqA=;
 b=J2NuzRZjNYGgVYIqe3+wc4uuA0pMUJUjbPLweLfLvQ2m1rBKpjqvs+R46ocPcPx6U6A0
 Q9qZ0Pu6gDnBEta4w/7Gmv5cyPFjTG/6YN7s2DsIE99eD9YpWj6WzrgSO+rqxfACHc3p
 9HEsJMXFzHpO8eXLr0PnXlh1K8ZZPa/V131uXwyXnYeaMAeOpb3gFlGTKUCXyv0csEYU
 IGLviCSrAztPisDkol1lf+jY5OOvVSD09hWEeBdVrfbJ7JTSruEjBcvtQsIXEtvjQsC3
 2ZKeTL1VH9oiukPLLzJ8pZkAQwhbgx2HVgqKDD2a5TbuYppjotM75YeyULgDCEMp4pV4 ZA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j4w23xg17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 13:17:34 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27PBTpR4008987;
        Thu, 25 Aug 2022 13:17:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j5n6pax69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 13:17:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tmb998Ns4Were88wC9s8j2appjemTPW6w9Fv+Nhps2K68a3lB6p0jzi8uhWmEETPgyIF5L8lMBj47d9y/X9klnM0sYuHbA4LNoWDML5GEyTa8aFowdJu5LUsLQ/zX5I7K3aqyaLZ3cthPXaVfAm8Oj7Zo2VZZBieUCZZVvK8wXFL3+QchDmLpMTWm+DTpzkiBa8+rPcaK0pjediTlgi1221elyaayoUKpv9El4COXfm7oEWzoO1loOw5uqYF4aQGjluXBDh/FCtpgJwFj7cHsUiVOID91xAw3QpKnWnd6nM4as106T6EYCZSmNtaErRDWZXYW1QHk/6OD+Lw8omjfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t+jPR63iNUIni0+qEpDF+ADRMLverfo0ocj1FSxLrqA=;
 b=TeIuGYlAM0W1RvyIB5EwReW7edEgefx+HHaQl+DFcna5jIjmRBS5n7qjPYZavZ0q+LYFB4RvZifJHRsi9Kog0lvQv5VDErn95OySPgrAiu0TjhTskMmFv7zNwk36/Gr63oGU9GOJl8PxBE7cNRqspWvuoqaRkE2szYTgu2quwvjhNmciqzCIUEomOPHA8dFSe71soBW0xnVl2CcQJD41pcyhzlDSYz3kW/mLrztPc6i2RRZTHo8CtNdclKmWOGhs8a9txBAioxtXH4v+Ij3ITeeEhl6GWNSs4DqTKajxFiK5SuRVuayO62IKJIo8snbG/kwVhI7oCqKRt+toB5Io8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+jPR63iNUIni0+qEpDF+ADRMLverfo0ocj1FSxLrqA=;
 b=jg6a8Bs35iQ82MW/UfPzuPoOTytRpn2vur8G0NcPNR0EPtSovNjiSfIh32wGRn84TamB92vmUgU3PQTxQ1OmIkooo9BjxAefRAeGJ28aZoHRGc3db2pYNDfGoB8sjdic7Ch1UHw28+aK0Bh2Rar/EH7BVk3HDxkbgbtatiLhOAE=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by PH0PR10MB4646.namprd10.prod.outlook.com
 (2603:10b6:510:38::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Thu, 25 Aug
 2022 13:17:31 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5546.024; Thu, 25 Aug 2022
 13:17:31 +0000
Date:   Thu, 25 Aug 2022 16:17:19 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Camelia Groza <camelia.groza@nxp.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: fman: memac: Uninitialized variable on error
 path
Message-ID: <Ywd2X6gdKmTfYBxD@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0047.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::16) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79ca6500-47ea-4a40-5f63-08da869c2a49
X-MS-TrafficTypeDiagnostic: PH0PR10MB4646:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y10OkWci8aJcM7TiRv054plK171sp/stKhDyM6zKLsiCeK9ylDEixzH4B0U37abFeC79dV7raosxeTFIICRWlGR3s4J616zFib0BZaDv/tEY8w0qW3OaUbFbHskXrsG8HNb1v5bMfQhYuOD6XMqcJgsYzqxlkz37AnKBTSAdXCgi0tnIaDd41kPzEhxEEETVcOAqyQq/QPQUcHUABFSmOSvWf8EIhcn39XiAnoBxI8rH8V5hbCnctS5VuSKLNcrCVaIwhtkM1JaulVqc5QJ4pNHnMN6i4fnSgJCk3niVQKZxQn31dva/6mKiHYDORiIN2d/47RDFZROKLV7BO6COMJb3qMGI0+1BMrnPIX+WxyfAZjXZliQdpIKO/mAR8DYWZKOTxkdQL0lEX15dTlTLFS3oRpPDz3CbdDdzjPMKVrejxPeJfrGAK622Tru/DcxTJUUfjc1Kvv2ffaQOoqgKXpJaBJNjp/jkKvAaCLOIeh52GUPfwo3bHbX06ojjeImYu+5n7XTMxhPG+ZsjiYjqfKuC1oyBGXEL4/VA6mEbqS5rYUco2HN95itPFbdQGAKH3VLW4XsuamfPWwS0Hh9mjeywmZEIeOGS+K5hmAwyIaz2LnSUrEWf3PiwfgWucwzGGTq1zaJbXgjIWABxuMxiZgSDn4Dfa5WhOlgqQntlMg5xkbl7xNoJ5H6ICJyMKygoeclOPtGyYfV8kNOTP5mlZd44CezTOvyklx8b5zYgiksd53xxRcYonMswdyIrYW1J6ne5SXS+NxjEVMxh67TeCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(39860400002)(396003)(376002)(136003)(366004)(4744005)(6506007)(6666004)(26005)(2906002)(8936002)(6512007)(52116002)(44832011)(5660300002)(9686003)(33716001)(83380400001)(186003)(38100700002)(86362001)(38350700002)(110136005)(54906003)(66476007)(41300700001)(66946007)(4326008)(316002)(8676002)(478600001)(6486002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6NY4rIbGEV2lhYHZiUAmHzdvs0uVlhercnE1ZANGhRWnkvcAAxYQ/Ft3BJQw?=
 =?us-ascii?Q?0rjdQ/fX8Dpg2sEVnrbZtnYLF7IpRSZUzhGgX/DnaqSVcecH4SKGC9DrzXWp?=
 =?us-ascii?Q?f+JR3UK0vkmuapj7LSF8so3+a7l69Zz4yjRBOkRhS6gBb51qdpQfyuBNmad4?=
 =?us-ascii?Q?ervPy3j7mWNdWBZM9mHIlfnLraoLUmR3BYoKC4yciqWnRFHr8jhSwke0Z4Py?=
 =?us-ascii?Q?Z88+Av3rSFU5IedXPIpBl8XbCofWz1yucus+EySEEFVg1pKp1n866XVGiOKd?=
 =?us-ascii?Q?dKmPOJOagrdIxhVumc4K+BiCLKNgf8tm2extoGMXm7NO1OOJDeyfrdpK2ch5?=
 =?us-ascii?Q?jaZClu8suA7Q0bBILXtsiOOD/L8VwIBZxxuwtUefLKKVoynqDFWSOfpg+pXq?=
 =?us-ascii?Q?ETMJQfs2vjPUjkBnJbYHD1+d2fnTslu54lXWP7PAs87+fC9pZzoOZIxVc0K7?=
 =?us-ascii?Q?eBcbtfpuqgdlNzpsVwuzVOvjxYW5kcj08Ejx5jfoLDIKeljrNImWAuCGBnzm?=
 =?us-ascii?Q?NvfJEOvQjuZfp/3Ibo5ryOe3vrRg8Aap71aSs01gsKMnpcmifHP5OdyKFtZl?=
 =?us-ascii?Q?s6anx/h9cUcTUpZTaiyvmJLISIo7GCER5bMFAOV1EqA5oIQp+unRePLvGz49?=
 =?us-ascii?Q?ZlrHOPIXn1/B2KXSnnFtu/svWaWp/2QTaoInLwXZMLGzk3SlrIfdNCIh2Mx4?=
 =?us-ascii?Q?kJ6Kd3vdltt6ZBxgl98IdFrq+dC2m1RICrz8ZGDM6xnMZjGeMqdFk7OBSY55?=
 =?us-ascii?Q?6bX11TT5xw6b8skfH6YW1EgcsdVaRH8i1ZImCNgMNVfx82pIjwsUNLVeyYkv?=
 =?us-ascii?Q?npipiS8BsuOLWD4lMrOlkpGzqFW026JhpY/vrCDaIlna224ubzBLMa0kM6JH?=
 =?us-ascii?Q?dDxvMs+rhTZGUTOhw39BNa7RJkhGrKWZJNrHZ7Iy/bXOFYL5NNK8olTxc66f?=
 =?us-ascii?Q?RVlFCHh2kp7g5aL/4qkOgmGRu2X66w8FwOC5MElUy1j64x73SFwVNdISwa3A?=
 =?us-ascii?Q?Jlb4in8EU7iysPeSA2EpBVUfrx0MVEoh+Sv3PGoggvW3IGFe/5ijiG3ld1oL?=
 =?us-ascii?Q?M6v5aYWv7Ae5eR2yE1Oklcj32T/edZ+XDmXw1hRptnRHeyXPSycw4+NSgC+Y?=
 =?us-ascii?Q?5A/pSM0nQD1NNnePJdadfRCEQ+iq3CZfgNnQMo62xfxevB2VlOhJ3ljrjTH+?=
 =?us-ascii?Q?XM5/qbsEPd9O+Y9YgO/4Nw6wQsUFIk5CF4ARIZcOv0UPONtg6QKjdKO/GY9d?=
 =?us-ascii?Q?uElOcU+S2zOMQIIzF/8pLlPMum+tvrzcqIdqs5aNbOSaxtSgZ9Lchibv84OV?=
 =?us-ascii?Q?g1opfl6upHClU4tQH4qStPebpnUxHFv35mTZ0sYZm/B1fYAgYJ+KM0jAqFIz?=
 =?us-ascii?Q?Ke5uRqHOJJYAcocaBzu2FUgt8itjHGPo/7YFvWv2Anx7HXwwMHj26efLTD0U?=
 =?us-ascii?Q?2D21giez8nunxqep+TfItOn6l2ljNgf3uwE4xCV8pFy3MC/mZBnpypB3zVpL?=
 =?us-ascii?Q?EcH6MMfUODv+ZBgUwU9/zVjJN7034oafbcwFedOmmp+VIZMuLO7tLifM5GVq?=
 =?us-ascii?Q?ULtbbmsgUHaMvdjM+NyGuHJwZoIvWy1ExbyPfCkDfPi1StL/zQ7lGZukUTDl?=
 =?us-ascii?Q?xQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79ca6500-47ea-4a40-5f63-08da869c2a49
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 13:17:31.0224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9HsruP7t32Yxu2XuiFESkGRjpJKrjMc905Fhw/h2YHD5J8wFRAOnMNHPm+WtTorMmQLihdBzoGx3W2keadbzza9LWe2YBAXRLXWZgZwINDU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4646
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_05,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208250051
X-Proofpoint-ORIG-GUID: b-3SKJELf3J7W6oV2KIu1t5Wi12Nm59f
X-Proofpoint-GUID: b-3SKJELf3J7W6oV2KIu1t5Wi12Nm59f
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "fixed_link" is only allocated sometimes but it's freed
unconditionally in the error handling.  Set it to NULL so we don't free
uninitialized data.

Fixes: 9ea4742a55ca ("net: fman: Configure fixed link in memac_initialization")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/freescale/fman/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index c376b9bf657d..f9a3f85760fb 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -389,7 +389,7 @@ static int memac_initialization(struct mac_device *mac_dev,
 {
 	int			 err;
 	struct fman_mac_params	 params;
-	struct fixed_phy_status *fixed_link;
+	struct fixed_phy_status *fixed_link = NULL;
 
 	mac_dev->set_promisc		= memac_set_promiscuous;
 	mac_dev->change_addr		= memac_modify_mac_address;
-- 
2.35.1

