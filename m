Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483F6478570
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 08:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbhLQHLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 02:11:05 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:5074 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229503AbhLQHLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 02:11:04 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BH2LVJ9014958;
        Fri, 17 Dec 2021 07:10:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=JY4OddkzfAisqW1pR6jm1AQvxNeAzahu2eVp61iz8L4=;
 b=HiqhY/XfbJqX4KHJtRHRJyXPCnuUH8t7jufT3VnZ/3HlVKEd/8laOej0W3bqktyXfB+M
 fgWjOEUboLtHVjagATQOciEaOllhKW4kFEIuRcbXDxcGPunV3PWhSzWVNin2J5WXdMdm
 HfiKn0zfQ7NZ67EKyVJevHtY0yzZrlu0HTgTZUowPpFHyOIDkt8PdGII+ntp7ENmELh6
 y9HWg3fg/5NtvQ/N8B5vX69eCsEurO92wgDCPnmvX9i6rikJNGQ/K/E/BIG4t3r7DJmG
 b19KWgDNc4IViif1tFMIpT3mWGSLNrjvPufOFQ9Dj7Bt8WMCnIC7ezvYkdtbFCniiIZn 9g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cykm5d213-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 07:10:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BH79tWO133113;
        Fri, 17 Dec 2021 07:10:52 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3020.oracle.com with ESMTP id 3cvnev5cph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 07:10:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CL9vB01VVqq9hlrbmTK/0PNO859ZuPeIXZ9s4hchW3E742KspgB1wVed/ztZloPWd4lmHh4O6S1jhhwHRth+dda1RdYikXO3Tqly64ighcnIQHlmTMDxkG/f9A+vwHTvuMTkFSRid2gwXsE0t4NN9DNK4tyyHbXPuSrdyv1gOydh78BJ6v+/lF7eaZyO0At2allmi7/qhizIT7+NyS3vC3wu1gAkxrvHjMDU0JaieeekHtG0ekTtWl5Uof90ObVEZRoLn/TuEIl0P6nX/oPcEU3ChjpKUG+vi9h9XH8wSPJUTuaviCwu4v37DuESikf2chaVGr4qiDuV5ifWw7NfDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JY4OddkzfAisqW1pR6jm1AQvxNeAzahu2eVp61iz8L4=;
 b=eMXNzCCEtG/BT76VJLG/YoMTJhdjOAvjv1EfWaS/KxpMH5u/idmfxdemyDOIK0y/G8aViPkhHf8xJKYaLi15MN4bU+rjF1bJJVd0/Mht2bRLjfhzyTN3ubQEVwiw0nuEVOz6qzGHDjV7QhyF+3+K0olfBC9jgvWdBdg9slPJCueZ2STrWtKZ9JDzLDWPRoaYS767ou5KtYLJyQc6p6CI+LsjlPHlbJDRy5R7mEuyGllYLqIBlrrtDEnHgPDKhJw3OmKuBbu4wxHkstU0KT8NSvaDrKzS8yl+KaGcqxbQMVjQF9urNdFJeKB5S7yZzrkSHaNoPkwme9Sqhetv1LgEJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JY4OddkzfAisqW1pR6jm1AQvxNeAzahu2eVp61iz8L4=;
 b=mE2eyqMv7LfAgvBVHge+acDz7OcuZjLZ+QwdO9W7/LlMxFfI20pUG6+jry3ZTDgTOeJ3antmnFvtOfkhR7/TRNjJwTY8qzjXIBaC4joh2sd9EF531PLUHNzDFreKUJw8HW9uecKC5ZeryPIWjO1j6hUs0w/3ZmpMtcjcxijHkpM=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW4PR10MB5863.namprd10.prod.outlook.com
 (2603:10b6:303:18e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Fri, 17 Dec
 2021 07:10:50 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4801.016; Fri, 17 Dec 2021
 07:10:50 +0000
Date:   Fri, 17 Dec 2021 10:10:37 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: ethernet: mtk_eth_soc: delete some dead code
Message-ID: <20211217071037.GE26548@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0165.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::18) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75725a57-d518-47e3-630e-08d9c12c5afc
X-MS-TrafficTypeDiagnostic: MW4PR10MB5863:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB58638A77F960BB6D3ECB06C28E789@MW4PR10MB5863.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ebii+Y43Jt6QKQWTXaMoK0hTA3sZ2r5/7pWhDyNhinuVXa0MGuitQy3/5M3DkCOM1bScSgix6bLmyGD44PEANtU1zf+svhn2Ng6or26BNLP1/NdmMpb3/LmKQw5/bnEKhLbA82jolaH9JxLcV2mdDeHdip6ChRLnXJmcu+eKfkmaD+i5Q5M8lvYxfNlGLTgiQCA140TfsaQ8sTzZEeQuKcWjB3J4aryBl05KcInFaKFhBsdhymEZ80WFwgdC168ZY/G1IMq718bejUHO0kz1w11zmpE5poIUrmOzr+LNJzk0yAiw+ERBnCIPsTPfqd3tdXPYm8DxJTHk5xukBJA+hSU7gzrdhH+TBcUljIaw/piwU/hT+pRpvkma8Amxd+fKK1NrBiPUpQtX77AQe607Ib6VcI2W5ZAAPsXKsYDsjxGs9Qavksc9Ex0sgu9aIrI+BL/EieYMFax5Vj2K945dh01Pf+iM4GNs0F7fBVvmU16Vjp3+b6Mfc74Tmsmzv5CC87QtpiSQAYEcVFkdoUL1e6xzhqg56IjwsIdYaT5ngnY4W5LYL5R35B9UlrlnOdpjYhXlCKS3MdOSyf6TCoHJuorYOjuvfDe8Cyv+Z9AingxjgB6M1ymjAfiATRwgiE9/n/koU6ZaAm+WLpJsX94kt4neLzbbm2a3nx8t/DxKvuGYf10waFhO4SC7L7f7ayOCIbolNEcIPYu92ZdA6u244g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(8936002)(33656002)(6506007)(186003)(6916009)(6486002)(86362001)(66556008)(83380400001)(6512007)(316002)(4744005)(66946007)(5660300002)(54906003)(66476007)(8676002)(33716001)(9686003)(44832011)(38350700002)(6666004)(2906002)(1076003)(38100700002)(26005)(508600001)(4326008)(52116002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hrMOLYkuJGvW7pEu/NLbKxcOzpLdorl8VSqUdlgEto+MVfFudIWaavvKXVb2?=
 =?us-ascii?Q?b5u8ItydRrzahEWNfoBerfwR5dTnAlwxsH9e5TLoK3LdMltY/n7xrBdvsfV0?=
 =?us-ascii?Q?M1+Idg5bsLVytp9XWmHTgHFup2D+r6acBZdsEi23Cl2rlRJA6ttzxRKeHmK4?=
 =?us-ascii?Q?FXKQ7fzpbvXAUhvUrADFTotSu7R5QDw+z29G2JKm+hSYZPJfRLS571TM1eYF?=
 =?us-ascii?Q?U3wp3M80sd84QeDRXC2VJqZaAflJaJDFP/dGXN//nt4tiKK/QyF8wxbOh3IH?=
 =?us-ascii?Q?6qpciec3jNYfEpKCKP57HmXLgDFu/a+u9Uq/bTNyQ7TLBFBANKorUUJzAt9c?=
 =?us-ascii?Q?mwb4ob3yBiJkSMZN8BOFmofviSod+34Wx/Ze261VfyCq7q3l74Binlo+SdO8?=
 =?us-ascii?Q?V1+XEB5CR1bhi4fh8B1BLmyee9gnKJY7UuunxfTXKT27S23HT9e2LkIKnYiL?=
 =?us-ascii?Q?AsRexbnGI7m9axDFwYajtH73mVvT9vQ2e8PV6NjGWT3gFq8Dnp5wiyfx/QLy?=
 =?us-ascii?Q?RxyxX2cCupv9XryGgSzjC96o1HsbNNqnmmHxETqzpz/buxEop1jzc10Ju054?=
 =?us-ascii?Q?OSckvyBnEUXNfdKCI9/EkpkdLdmL53bQxyB3hRoQq/Q8X9Ca/7O+/rNt2/9E?=
 =?us-ascii?Q?pikpp2I/eLj/zVYR/PEB5fsnJLNnhDFJtjfADcvbPEWEuEWU0ikEhYJdMo+b?=
 =?us-ascii?Q?hPk0A1dP/tgpUNII8aXoA4Z92/pEmB2ocNGm/H2RlC4tFhqttQDvELaFuwhZ?=
 =?us-ascii?Q?z5iPVdR2CLRIQSmDpK9sSNCbba1DoumZE+c87Ud48+vXANUSWXVRv7OOEFVa?=
 =?us-ascii?Q?JpX+mTRx8dBqIdCAAe9+AdPnP/Ni7OCvQIh5aN5JU3et6C4Bm2/HXZlklShQ?=
 =?us-ascii?Q?CAKUYVmdIB/h7J8Emo/omZqEdbLvny/uCLp8AHlBkLqJ1lQB/VIjXvU/WcSJ?=
 =?us-ascii?Q?o9Uws19p3SMh4ojpSfYcdQcvOKW8a5A84HhB6lklwVzMGzc6wgp5ByY25kGd?=
 =?us-ascii?Q?N21gCRVsGC3QDN8n3U/N2GnJwruTldcDXApQ2Z9LZpWyGeWvzSf3ASNESrcs?=
 =?us-ascii?Q?Y5+tR2ejfLdBdihMZ6YlfAbkvRSAVqFMZC7MRIiOxKB1MDMg4jo5Gs1W4Yzs?=
 =?us-ascii?Q?kN7vNGwjMoFBGbtfvfBSUePCoCRelSUcyya+Pdm0xKIwZR239Nj2/EiCibar?=
 =?us-ascii?Q?qidF/nVEQk+I3PXmwdbP/Y/tPlPbk0d+QqRl6yOhIj0jXziDJSvG7536ulhn?=
 =?us-ascii?Q?zmCzdGObF83Vvqkj2fdDSiiHtsmcyMZEORfTkVf/nw/LwOD7QrZddsc64bA5?=
 =?us-ascii?Q?vjHsL8YFy9l0LIkGBuQkaA/3gFphV9ZYp+xOKyCU85XSSRJ1/L1AchQfsJyC?=
 =?us-ascii?Q?dzZpmZj85inYSAl4bL6eTVQ0WVpHVlbLf7gINaRucjWuJzAEYJ/rovDRzluo?=
 =?us-ascii?Q?iNiNaicTGY2MrK27UWqHlWZzANCgamFV+OLN2js+ALKO8cR2/4EhgN4quz04?=
 =?us-ascii?Q?nHb6GjO8FGmyxf34FV34+nvfll7aqpR3zvyxcYuUAPTA2+vScuKZ+XsjsBpA?=
 =?us-ascii?Q?C3PAit3WIRrjMQQpdesnmPRv5W+M+TQecy+kWCqUiKfrgKKrX+EbRImKXilq?=
 =?us-ascii?Q?5HTGY5rMRMYLe2LnBwAheMECAq+QHoGyakRlVjpdK6Y3hdOxim/HLtdW1qb6?=
 =?us-ascii?Q?FxzWpLZGVbILpMtdt7PmnqFw+LY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75725a57-d518-47e3-630e-08d9c12c5afc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 07:10:50.0016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 61muO7oL34G4twupGh2MreXCnJ4Ir1fEIlE2VTAmNYj9+UhUvzsRUhk+pPp/jWb/hTACqSiFvB9wV53rQOycDU1qxKv9p73dVuWXXAniVck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5863
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10200 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112170040
X-Proofpoint-GUID: XhbiDkmn928bQ-W6nv39dmQzWVVeU88M
X-Proofpoint-ORIG-GUID: XhbiDkmn928bQ-W6nv39dmQzWVVeU88M
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The debugfs_create_dir() function never returns NULL.  It does return
error pointers but in normal situations like this there is no need to
check for errors.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
index 98b1d3577bcd..d4b482340cb9 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
@@ -207,9 +207,6 @@ int mtk_ppe_debugfs_init(struct mtk_ppe *ppe)
 	struct dentry *root;
 
 	root = debugfs_create_dir("mtk_ppe", NULL);
-	if (!root)
-		return -ENOMEM;
-
 	debugfs_create_file("entries", S_IRUGO, root, ppe, &fops_all);
 	debugfs_create_file("bind", S_IRUGO, root, ppe, &fops_bind);
 
-- 
2.20.1

