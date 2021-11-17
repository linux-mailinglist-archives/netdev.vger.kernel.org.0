Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF284541C6
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 08:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbhKQH15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 02:27:57 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:7850 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232831AbhKQH15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 02:27:57 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH6bVYt002071;
        Wed, 17 Nov 2021 07:24:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=IsawUQeVcNwMuW9+1OvYPfY2IgQjk+QzanOzFnoVk70=;
 b=fJG9OUZl5jVesvJRb4clmhjJ3ygdXHj2q1nHdCwYBODlcqSkx3Owctj4FSeOzuuBhXjF
 11gxZbI6z9bGkBEPtT5KPjmHnQ7Mu4xQgzH5Yf5wtONYRvZ5IbkrQ/gmXk9iA4orktA2
 XV0fXaTP1fPjGqBSmMUTSDtlzg9bT+gxyCQ9LXl2P85mruFndiXbSRQNn3x+IwrDHvfA
 vPvlNA+UfgB3/8bb6cuXScuQnsBUAq63ol26FvgBHEHQUVBmCu5cf6oNloOAc8C3gF+6
 pZnmjvhXlo6ajkOwyM+3YBhmDIdWXZugxwN5BPeSVCSWeDVjgBVC2/wknTBT3NTwmWPB Zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhtvwch1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Nov 2021 07:24:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH7L5Y0050777;
        Wed, 17 Nov 2021 07:24:48 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2172.outbound.protection.outlook.com [104.47.73.172])
        by userp3020.oracle.com with ESMTP id 3caq4tu6s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Nov 2021 07:24:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=csMI7bgXHmH43u6F1FTK1yD1UbDUrNgrZZq/TwEKFc5l/eWBg69iHdvrSRvHR4bdeMT2DZXdHwF7wrFF8s9fjJaO6ysKhWsDnra9eXiZW1U8WNZARIpmpZ+hLd4FvH1djOyaWVM8R7f6y/foRpIbfwV8hpJnGpDakyNENUKnIev5Y5RRbGuYSfDK2NPxQWbQMBmsuBCHgSXA4E/26/SPO9xv32ho3IJgz+dmcHU2Em5ybtXJTwvFRCqojiC8efyxb+3mWPPAxmlLMCaAGDp9l3YuZaj7DE0ntXnYmQloaI+DdXLPwrhs6haY5012qyu4QthWMxZXP3cnAnZIVBXUug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IsawUQeVcNwMuW9+1OvYPfY2IgQjk+QzanOzFnoVk70=;
 b=bFa2ozUOeUNJytRQ1FAd/d6QknqYAXcoZmRTVhbbnphlmFGl3gkayJS9NxcrmmIC7Ahacn/B+QjpDK6mVOLAVOo7IJZNxzkgg6EBMtlHi9v8MjACpteRWkYCmt4j5IJGLrPJQMuDbA0B+fDwLXqD08ZULuk4h12kj9bkezoKeJHvGHq7yFfIC2mtUaP/qn8TP/onWmVE4K0iD5KPofXN9esbvQrfXsUQuUlUVnSJh7qqVlRhJ4WVH2qZJxKNaU9nWvcD8wVMHps9DM2K1nArgTfx56IA/RiKtPzOIajaQrnVQsPlkQAN0oyjTPY8pDD+BeyAvhpU0Ww7yUTg2lqHjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IsawUQeVcNwMuW9+1OvYPfY2IgQjk+QzanOzFnoVk70=;
 b=JLh4la+L38Xt95sRHZ+Uc94QGkk42qIOIhs5u7nIrm0VWnhWS0RzZ/Yf+AcR9DGQec6OQj/rOny0qKYlq3xDAadZPkIPCzvfG9ZSJrbrBiaZfKem0p72s2wlyHEbdB+W+aPcksXe9mArlFpSGKeZaivXf0PFQQ4mM8UlLGkr6hk=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2093.namprd10.prod.outlook.com
 (2603:10b6:301:36::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Wed, 17 Nov
 2021 07:24:45 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4690.016; Wed, 17 Nov 2021
 07:24:45 +0000
Date:   Wed, 17 Nov 2021 10:24:33 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] dpaa2-eth: Fix use after free in dpaa2_eth_remove()
Message-ID: <20211117072433.GB5237@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0108.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::23) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by ZR0P278CA0108.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Wed, 17 Nov 2021 07:24:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 091778f2-8944-4523-7b90-08d9a99b5499
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2093:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB20934086EFE36CCCA57715DC8E9A9@MWHPR1001MB2093.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v/fqrK/l8C04I4TBgXYI12dKP/Sg35XT4NL7eYe41sur+dF2+gkRixqjH2i+5xAVVL49tGAIopsPtLPxjCvzEraZeQjXiN+oCdqjv1iXqqf+OrNt15Pm5q8cC40v3EK08Ozef44rvuWze54IytzOnO9U+EDUFXIr2RU/V35o8Z6+Od+CnNKUhFtmaH0PgW7Oow1C4nexSLMqIMEEAS3g1YVKulyRHgZjfbF+n0jOgCja+mLKZhERGJ/Pl/nHlG/QSDPIeduihQRpWaRyi5nacvgSO06QkKyZMgIiBX1MrNTzFL+JRXV/ZYhguwH2MDByGVXPh3oS8SiBGmjd9HB8852i5i0F8Q6ePr8WMst7OEQ9JzhskCQ+p/onzK8cf2A9h2wV8o5inzaZpL9GeTSLcoD0WiWSeToonK71q1iEv22GtG1NPAbFvrCM6GTkngYAA/E+ZE6xp/gdEH9IL06tJ1HNMonxpDoY3GNPq/nMm/wF3G/pEaKTrxnLK2TBP95N1K8PL4ZBXxM6dT+8w6pzjZ2EJy1yWvdegIlQpf5dK2CeAn/bb1wHRpKQqM6iUMFbc86wftcVFnlbeydTuBVDnzTOrFjR41iBahT/8QwvDANAVKtHtZi0oQHUzzQRHYsUMVF5BnpbpAGYwIzdGtEukKpKnym5uLFxPG986jKWhXHQjJGD7ngBnTAfBAcm2ej0iE66TlJZGjKJ1aBvxW+Zkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(8676002)(26005)(4326008)(86362001)(6666004)(9576002)(5660300002)(508600001)(44832011)(2906002)(66946007)(38100700002)(38350700002)(55016002)(66556008)(8936002)(54906003)(83380400001)(6916009)(6496006)(956004)(1076003)(9686003)(316002)(33716001)(52116002)(4744005)(186003)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VF7n7VA/6npw7WuCSG6a7X5UjXefatzTzB8tNPu4gn1/x4y7fOfVULBxuh8r?=
 =?us-ascii?Q?nrxoTPSZR/l0JOZrDj0pCnrFHxLlJR5fVD45K0cWvNnK08fsUImpgowGqQG2?=
 =?us-ascii?Q?HkCri1QgEWscPRAQ2YCyXh1KwW94rSfq/mRi9rKDKSkJVU5a4sytiBAGO3TW?=
 =?us-ascii?Q?e9QD9xkgFHxpkeKoJ4FtrG1CfM4Lhja8mZ9CtLSFhuWSUCq8PqKQZ2sYZ4nE?=
 =?us-ascii?Q?bYTvfIwnp19C54r1AGkU8OBxh09XmMVd0vJpLFbYqklFOTdQ0vQUIXu9/tt1?=
 =?us-ascii?Q?gu3tR5m2exJZs/QHeJAJMNZ+fRh/rk3ca0DfcSRw4j90vshNtjBsG1Om3hMw?=
 =?us-ascii?Q?45eQWas943LvuLIFaMZrIH/BVFe0PHpQS0CRydwip5KBAaXgpWEnBl9JRyWB?=
 =?us-ascii?Q?iU1Eu9LNFDuEqPctko0KFZvwTKfJ12uwj1cpicDnp//FguhUKWC97VPU2yg5?=
 =?us-ascii?Q?f0BQDj7/yEl7yNdkCTM3i61c56SY5GuPAFtmMtoof90PF45rrLT6dBzrn0gC?=
 =?us-ascii?Q?GVQWUtEgLtnaQ52VAw74aglpgTNqwYBbbpZT29g5X3eMABTpDxA8JFvOXEbJ?=
 =?us-ascii?Q?eacX9E8o0IdbaNr7e00EB+9KTWOg5/kFx+3RA4gB94FeK5RMavIdnq2rHJqS?=
 =?us-ascii?Q?aASkB3iy2f2u0c1QNBdtnDiXfmp0zUuDwVk9dGYhVXipr/tQTpqgN4kc8ckj?=
 =?us-ascii?Q?9EjWNrWlUbXzWI0GxANiwK+PIV+HOedB3UnDC1e+Wtx0ipl6MQe+9jA7kuUo?=
 =?us-ascii?Q?EC/otls+HunUoaL2IC0SPFY/ELZ3D9F5NhB7TYMG9ttoLLg4wfrgIrgvdESd?=
 =?us-ascii?Q?CDvzxJkZ39qctqKa/i7dE/rMI9HOts0Z+SBwHy12Sq92tpzJa2H5d0M/XMZi?=
 =?us-ascii?Q?Hqnxxb1lMMTDCswC4DIyWIGMHCTUxUtqSxs7unlXzpCz10ymG99k8CNWL+4g?=
 =?us-ascii?Q?cYHOhZlfGA4G3nxWXyRBsuNeUaUbZllv69ShyhNEsBKryVeCr7K/fp+HZ7vU?=
 =?us-ascii?Q?Ag/YQsqUM0Hso9ljZZSKcGIrXhp6L4+S1giEcL1lkJjeaYiQdKiUjY3sEgoY?=
 =?us-ascii?Q?JMegI8HUh3ZuG0kZhMhQf3Z4cjDHMQpxhcoNBJVGg8/bPUMl6U0ycDGXnCM/?=
 =?us-ascii?Q?JphpjDtnEjGxxSy0E7XGBtB27yM8rS9W4fUsIhEn9wKwu3zWaCJHgejwRk6a?=
 =?us-ascii?Q?KZC/+gKMSESsdMEJelQzw8Zk4rGZc5aycikzxsaLg79SMX0jOea+a/wuxBwm?=
 =?us-ascii?Q?6elpngjHWZ1QzFJZlQTpXMniz+1rnvw0CmCoE6/tbkVr0zJpFgh7yXaegsrL?=
 =?us-ascii?Q?vj0UiJ5ktMiSugJV9emgxOmVE9JsMtxSSqD5rAyzwD4IMAr4A5+grp7rZC9o?=
 =?us-ascii?Q?lrIAh2ekGyMsQoUa6AIJBy62e5WOTQpjc2rYlcheI88A1K4TpS1PF6KGKU+z?=
 =?us-ascii?Q?2vb+v+3vCGbTymsodKEdbfOZwEO1YMv18PvHRERIBhGnFFvyHyRIt1mr06er?=
 =?us-ascii?Q?wSDrfm6dcM1sTi3aIpQ5450dQJL3QLHaQHpjg6gUkuSVs0gknTMOx0bB1oJn?=
 =?us-ascii?Q?uvwuEkXEKmhIod5j2+8H9nQD8fz9EwpXBNs29ynwDy24V5Ga3o4t/JnJ5Q8W?=
 =?us-ascii?Q?O2VVX9V9eHt27nmswHJY3pekPQdu7K14XJV0wcBjQsWtEMr0PkmvoEjUKsJU?=
 =?us-ascii?Q?8fWnMeX46r7h2WU0Ku++ch3dcCQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 091778f2-8944-4523-7b90-08d9a99b5499
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 07:24:45.5714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LMxIba0b4k8jsI9gISI/BY4IyV7NeQqkxb5F94G5jLONB4hSM1jcFctsm76/Tip/b09pjt5ly2lQDwXLXyJbSJwcQTMmh+6YN2athrqE+mk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2093
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170034
X-Proofpoint-GUID: t8-CuheKMhbE6l4ThLVlLG2ZmYymSz3A
X-Proofpoint-ORIG-GUID: t8-CuheKMhbE6l4ThLVlLG2ZmYymSz3A
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This debug message dereferences "net_dev" but it was freed on the line
before.  Just delete it.

Fixes: 7472dd9f6499 ("staging: fsl-dpaa2/eth: Move print message")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 714e961e7a77..e82874119d38 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4552,8 +4552,6 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 
 	free_netdev(net_dev);
 
-	dev_dbg(net_dev->dev.parent, "Removed interface %s\n", net_dev->name);
-
 	return 0;
 }
 
-- 
2.20.1

