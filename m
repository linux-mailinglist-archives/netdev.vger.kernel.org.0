Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3114C4C2EBA
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 15:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbiBXOyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 09:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbiBXOyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 09:54:19 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9FDA194ABA;
        Thu, 24 Feb 2022 06:53:49 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYIT7000642;
        Thu, 24 Feb 2022 14:53:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=xqAAbIjCnEQ3Gkx+z/gztFQjCMbw5lUFXbpLtETrYRE=;
 b=Y+gHFo+8SibniWQ5p4qKalA21VDFVyuwK3M0u74OifF7BX1foYBTT52FrdcrF5lGxGUX
 zvFHn8ElDxAtlJsraawCnmfs7AsSTfOKja+G77ag0T70vxT5c/yTVWH5BZzjuxrvvbPS
 e5kIfBY3gYhPPgzjkP9Au6+j302SSGR6hf4UaIizUdXMbTFO8raH5+0W13ItjYvzWJBX
 ZI/WZHJsa1LFqGhpwvZWzRE1g1W05ET2qedfPZx6pdhfSvuHiaDCqcu6lS1f17FdSZ3D
 udBvLs2gK7wJa7u8PvqosFW3lFYBCrxGeAQAqRAYqG5nmd92M+D3tXNUl9QOWTTgCulD Cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecv6eyeux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 14:53:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OEoYVk149022;
        Thu, 24 Feb 2022 14:53:38 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by aserp3020.oracle.com with ESMTP id 3eb483q0ag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 14:53:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SV46yJ8KyNi3t5D4As40xPp+cUrCyh+FxCsI1yVWKFGvgCy9tn3FgCmKhxwjkm7H5njjvy/dgTD3e5A+prkwcNncOPl5PpH5MlwTijL98cyYfTQp8yaGu+APqkujD0HEpci8ZbhlUCTgjagvmw0KLuFNyKlRtg7JPqTbzb4qA2Ags1eNZtDcIpnvHcB31FYpUaq0niQIxFdDzQy3uAEBkX76m7Y4ns+TeOiVV/2WKSv4J89LAH5X5cG3VgbSF+gY2BR8R1VYcsBYLItzUAS94RbM7cKxaeq4+31r73ZwBDrzpvEwK6OpTJPLUrf6SgHj+N+15suGyPCS9HBA6ypgOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xqAAbIjCnEQ3Gkx+z/gztFQjCMbw5lUFXbpLtETrYRE=;
 b=QI3CuWrDHTk4EAzP0FY5/ZynSfpRTxxd7uptQ43YORPJylA+ZQ1hG3PUISiaet+MUs1z2mDzFt+8fmosgywgfkLcB+obv0nyEuqmJhCYPbDs3HQK8LxlpXZyVAF/otFclBO2N1ww7UVo1GBS58MCxhfXQZt55uNJuV8X/BcVNhRo3Vy6kJ7fNYTjygkGsuPDevfBwBvHY8gW0msi/jLFYyhySIiFg5F6wBCqbSpZ9y1+GqCdXL0b73xltwwWsjTfyqk6klM4+PjB4XNFaegTz8rp5qnG77+mIUaWWlwXzKPfpGvLSRZn2LQ4o5r3+4URx9lU6nTYrONLdMM0LoaevA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xqAAbIjCnEQ3Gkx+z/gztFQjCMbw5lUFXbpLtETrYRE=;
 b=SQ5FhvbUMsLCba6WH++5gKa3efwCBTHQ3KERTGubmaKaOCq2uo8U/IlFClBgYnkvy7AFeNZh6h43Nf1n6AyMaqDW2l3FfDDffDHKEhXa4jlmclR1icGZFCCtk0QdRQH0e8i2XNUFDG2nX38/tyJNu4BFNmaT5sBA6Q8AkPqVqCg=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM6PR10MB3324.namprd10.prod.outlook.com
 (2603:10b6:5:1ad::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 14:53:36 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.4995.027; Thu, 24 Feb 2022
 14:53:36 +0000
Date:   Thu, 24 Feb 2022 17:53:25 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] net/mlx5e: TC, Fix use after free in
 mlx5e_clone_flow_attr_for_post_act()
Message-ID: <20220224145325.GA6793@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0158.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::17) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45d2eef4-b6d2-402e-d48b-08d9f7a56f3b
X-MS-TrafficTypeDiagnostic: DM6PR10MB3324:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3324297EF4ABEF4051D056318E3D9@DM6PR10MB3324.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rFkuWb6GSqzM/RTNas5sTRGl3NYkTFx3/nkDqDWVcyTZeKFYf0zrVQ5ZQhzAjKCNimHpDd7D6y4vJqvw/Q9tCXmvMDZQ+dNYQQ8XyADyd+I5V6WMDrnlHTFa9lh00i5KcDp63hN/AOKv4uFkOBSWvpqEddlSK3097fvMJqv4Cn2VkpwiCBElRbnA2oywTNUlW23VaKKc7CkQjPSHmJ0J1vxK/G13qpJ+RIhRA3cclxHXRsdkJpUkfUQZbp6ojka2Z6eb2m9DwWR9TTUGfEVziVsAunQxIo4CyF8hL/bSXMRoAO4JFwLYDSmYg/VCa2rfNW8nbn4cTHVeAl0gG1deuumydXLQX1oanXvhX3gS/0ViFRE4IfGwwDsR5B4MJn3ff69AKaBlAZuritMTW+wBvyYcdBoLgvi+dV96mxbWDUE/qzbpzP1LzKRx6RfP0gPcMdok3OdP5G5pSkWfYfBzgu3cLrH/Xkfj0rsowL/bWESZnQEqZ3RWQRGkWNK2Tsx7T0HZqCeMWWxIbRzsGY9oKriYfM3vOhNy+lpt7tiqj9CyOfFzAlEDA5sLyzky64AYyVOZtMJBXpAA07jhL26bT5SlFAsijJlu8RCKowxZCLDx/kajhe+N8o0fXqVJvXzr0q+iXGJ/6lnVYMnMkOpvkHvoTZVvLIu4+xCMF0/+m28aQtyGXFXK2kbrsqN7+hAwuoabwB1I8wrdXWkloYxVsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(186003)(26005)(316002)(52116002)(66946007)(8676002)(508600001)(110136005)(66556008)(6512007)(9686003)(6486002)(6666004)(33716001)(86362001)(1076003)(6506007)(66476007)(33656002)(83380400001)(4326008)(44832011)(38100700002)(4744005)(5660300002)(8936002)(2906002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bmORSOxKHTjvXEI9lDrPf5qHClNExZDcq1sgfLDV4Q2fVSR/vwx5NpmipMpF?=
 =?us-ascii?Q?w7lHSxhoLgKrEgMXLXS8ws+rElPdwoQObgqcy0Z1X4nUGkttZf6sz0cr64G1?=
 =?us-ascii?Q?G7a4Ih/yY36eZH8wq0dDSiwa33hBZLFWbd5jIiJFYITt56NVhZypDMt9Y02Y?=
 =?us-ascii?Q?CqcjbOVVEb1qrJplP1fulwAz78bNOmsRz9WyTkv0wW90GlmkKEfqPD6bro2U?=
 =?us-ascii?Q?8Ar6x5Ya85ukyGujQSiI7O569h1lpTpRdftdckttr/KZBTD9arNFDEnFu3NB?=
 =?us-ascii?Q?IH88bls+qglS8PdveHCtT+dS2TspWSf2vkzIcuMBLNkRUm7bAV5vAahtY9or?=
 =?us-ascii?Q?0w+t7kQsKsOtAc1+HNHAtH4VZ7Oxx3g/8RLNsKUWW2sbTj5RDQ5Nz8gxsMjK?=
 =?us-ascii?Q?U2P6ZLlr9uOKdw9g/L2GkJM1cKPUFUnL+F1w97ggM+XBlnXh7VkEhbhOIxd0?=
 =?us-ascii?Q?1OYCEeQxSA8yS3jY/07ABl0IaYOOpTYP1yIwde4IKb2pr97WOkxJ6lRLdMwi?=
 =?us-ascii?Q?MDDgHzGiqG8HUmZ241F5RM6loR4c9rJlIXstbl0OUvlVHayKDYLNuPQ3j5rG?=
 =?us-ascii?Q?X7FJvgWVHtf2FnzerSRFFahywy+OHboSwnI5uvjhqnmYKht1liIlU75+FQ0A?=
 =?us-ascii?Q?boB45Cd6vd2NJnKB8uoKA6fDNbMqVNwKFoq/xvEPStyXsaMUIPPAifzWlASh?=
 =?us-ascii?Q?O0ttHQeDztBHFnAfgL/KmfDPgMR2IjFBZvOqd90wtO7THsDfpJiEyYZwUd85?=
 =?us-ascii?Q?EQUUdyaaKKutcxFlLM3Cawg9EmH7YG9z5SN0hXOaWwCotQL/JarThd2b87g4?=
 =?us-ascii?Q?uIHzaXWU0nhTJiSbxx6PMsy2hHyF0XKJ9cHCpXq/GjQhS30Bj0CYaPXl+qIo?=
 =?us-ascii?Q?Aw5cFe2dXqHnIJSHbLow8IQ/SN4O8b6N8lEJab+0XwBmHTH77aF7TwoCmqv/?=
 =?us-ascii?Q?MvVOfH989VQF0CVistmhxgHInahiwqbXiHY7zwpXDT+Ty/0Vr6Ykd8emaXxh?=
 =?us-ascii?Q?tgR1gFMZzPpxzzH9NzwAwnou7V0FJjymOadMwkCL9RI4lJPMKLMtn5QLvpeI?=
 =?us-ascii?Q?27Sgz5cVXZKJqiT6HFo5L5nMc68c76F5TNd7E+Nyc5CPHwi5UQFUKBiGcIJx?=
 =?us-ascii?Q?/r9Q8Gi2lv/fd1xETRXZFGeUXGTTo6i8l0mvZnj5h9k9mOMvzmE7YPTx8qmJ?=
 =?us-ascii?Q?zrcFwWpsWcrWVfnahFnPL0AoBZsWteicA+dzfNzC0xyvGMBgMvCgRsIDxsA4?=
 =?us-ascii?Q?RA/TE+bf4V7pBA7dECcvngXVB0sLiVUMbOOjMqlWmlI9HYsOr2LPkWph8c7+?=
 =?us-ascii?Q?iwNL9N0DtBge8hqRTpLvZswB7C5DZtp2AERJ/4L/W5mDhxN7J+HHjmO4iT0F?=
 =?us-ascii?Q?0wefbWbj9MPDH9U7FeXvDqudorS2tvfoqTL/pGiMPsXoBuQiUtRyGxLsR7Qy?=
 =?us-ascii?Q?PqWINNYDxgDX4eYW8ogPFVQQtSsufYtQPwVxOCUTTunZncw2IWEu/lMbQmmF?=
 =?us-ascii?Q?bimDiXjvucC0zPRWvceg7ZQipCtEb3JhXtC5iaRGX1h/ojJn4IUdBDuzD2oO?=
 =?us-ascii?Q?VQO1Bl+/KpfQZqy3gKTUWCqv1OfvFCCVAL55lCnsWbWQw4Omduk54SbdSoF5?=
 =?us-ascii?Q?S9bx0hBWx/CCPh7NJAXMRvHE8acjjSN0zPTJPpOxBKQckyIiyx8dsx5RHQvw?=
 =?us-ascii?Q?3A6Pxw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45d2eef4-b6d2-402e-d48b-08d9f7a56f3b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 14:53:35.9679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Po8ZPse9TlRyqYavSDDMn8AKppcd4JH+nHCTnc9uE8oRzSTYhVO3pmVymRZraGEege5VcP1XhECjLAe0YjS+mZIncziPFi0NhI3gnXxZCk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3324
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240089
X-Proofpoint-GUID: pBWvgx-YGbWQ2XHogCqBnK-KhSlLG7C5
X-Proofpoint-ORIG-GUID: pBWvgx-YGbWQ2XHogCqBnK-KhSlLG7C5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This returns freed memory leading to a use after free.  It's supposed to
return NULL.

Fixes: 8300f225268b ("net/mlx5e: Create new flow attr for multi table actions")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This goes through Saeed's tree not the net tree.

 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 76a015dfc5fc..c0776a4a3845 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3398,7 +3398,7 @@ mlx5e_clone_flow_attr_for_post_act(struct mlx5_flow_attr *attr,
 	if (!attr2 || !parse_attr) {
 		kvfree(parse_attr);
 		kfree(attr2);
-		return attr2;
+		return NULL;
 	}
 
 	memcpy(attr2, attr, attr_sz);
-- 
2.20.1

