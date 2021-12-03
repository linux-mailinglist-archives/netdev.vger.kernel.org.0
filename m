Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9667E467492
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 11:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379795AbhLCKPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 05:15:25 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:1458 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1379758AbhLCKPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 05:15:25 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B38iCdo007655;
        Fri, 3 Dec 2021 10:11:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=Tys7SczqkePRXLxHWLuErcHLz0g95utR/cUJipk8Tog=;
 b=wUvXy0VwtU/MR2IFiP34THeYps69TD5Fiobh6sB8YAum2N8M621pDJnhNBCMZlS/Js82
 XZTRQmJx3fFXTR4F4dEqUbxrGnzEZTHKZUD+YNfQzU1G707W+XA1YJuPBWf8+jlG4GHv
 dgTaTqBcrwg9ft5ELlSc6JR/+mD92OfHI1WceHj2CRAfvjpNmXEO/gZbimids32GOCdd
 HmDc3dUoET2DY4urWWrkWB5SpyVNGx4Ryu4eCGKbr7ORUpFNLd89m7jkIsWPiLvxwtdt
 LhFBUw1l/HTJZvZSvSz4fP0OzEHeO+wqkz4CqoCHTM4BJeB5BvpyJdTDcZRZfZQKwQYS iQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cp9gkxptj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 10:11:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B39uRlX148916;
        Fri, 3 Dec 2021 10:11:52 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by userp3020.oracle.com with ESMTP id 3cke4w1004-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 10:11:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a5zqLuJqHEg3/iWhCQwJnK7ZKkLoDv9JSfRpaK5J4jax2eq7RXLbCdUJZCpnmsZb1L6wARhdqJ8v5Yap4GTiAx8zs5Ydy/fPHgULwxlPAoZcnpuOwI47Ruf/Satt0Kq5Pf7zT1wd45+xBoDR5wG1iY6PPWpG0uulfrtdCZNImegpa70uwssQljyWqrC+YlviXbkXjg/yeid3XiKca6joKO7/KWHa2oQ9IW9At5cG5BRSsoZ7gRcLACPvzhRlu4+V/BADnCK1uJUviVfDKfG1BmJ5v/F34mc840Cos0KZRtsXx/Wj6hEPyQX40/I6P/3luU25lKFbG9Ll0gx3VbFcHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tys7SczqkePRXLxHWLuErcHLz0g95utR/cUJipk8Tog=;
 b=TXDEma+Cg5juHdJ/LgqadWDxikLPShsWT96C8U9Q58Jz+j2A5sRnUNqqGQCUzppYNvPscSTspDOWzvEfjlvL0WUheQ7T8s96ggm6WchnekULgbA3CASJPNeCWH83fagmYnsGjVViZbuIrh3EynYjOcQtGRyMwAiBnJh5eiKF+v3tZ4ANmQfeoWSIfogurw2duRU6XxSW8/dPDVAL3p+6388d2uQi0k7ovclgqbutYHT+yhIi4sjtkPIppNjqlKBJZvZ8SbLkeLEiEu6TtVDoTT+lDu+IGEvAS4N/4TBelAUXA6Y9swgaKf5XzTBjuUeYC4Pu4ufBdGea32lnuvQHNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tys7SczqkePRXLxHWLuErcHLz0g95utR/cUJipk8Tog=;
 b=s7cQDrolm2caeq/wWcOQTlDEjuSdc9+2JQRnXw2+ETx1YySztiBeCrgNOynkR3/oAB7WJhColPiIrRC8yIu67rzQ2DBOwWITlCsCqWWu7CzT7J+3Xwcu7kmXIACmD2bUKUjbS2DwWS3BxgeguEyGPt+qXG3AxxZjR9AzyygaDMA=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO6PR10MB5460.namprd10.prod.outlook.com
 (2603:10b6:5:35e::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Fri, 3 Dec
 2021 10:11:50 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4734.027; Fri, 3 Dec 2021
 10:11:50 +0000
Date:   Fri, 3 Dec 2021 13:11:28 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Joyce Ooi <joyce.ooi@intel.com>,
        Vince Bridgers <vbridgers2013@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: altera: set a couple error code in probe()
Message-ID: <20211203101128.GG2480@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0167.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::15) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by ZR0P278CA0167.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:45::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Fri, 3 Dec 2021 10:11:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8565eb59-5c8d-4406-85c5-08d9b64552b9
X-MS-TrafficTypeDiagnostic: CO6PR10MB5460:
X-Microsoft-Antispam-PRVS: <CO6PR10MB546099EA36A224CBEA7161368E6A9@CO6PR10MB5460.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:862;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cC8snui3WVJbpmMgX35QIC2BjvGyUX8G4RjDgpZMPXgA1iHDLJRdF16wjFYCGz1PphfuoVBfBqKHm8Yxzcd+5xLOXtzU5Sb2zGR1bY2BQa1oShtHtADjTlOyu/6ReEpsmnY8jJuepzCu3V+T+/jEIxvV59mV0OUkubswXoHSQAK3+IyJcxlvvOwhZtPR9KrPIfmPFFp8RzhKjqMNoBfWqa7J0MiVXSs4DBJOYirgIxEHyjqTJ8XzM+pd5UROBBhbxPyC3VcAJmFGJfR0pF7dQatdHHm1N0j82dO7yi5QAmKvo6zXlAz3MjpBspWwAtNREEBAzUjtqGsaeYypt8T/hi90xCyKp2wcJiC+0PWChIVm88N8NtIPfkK3YZTCQKPzdrh38jFHFD2qwlCUSm3BmvlQstfowXflN4Lgy9RWMqJdDTs0wof0o3GPbl06I2StneEtUjb1HecTrCzoRx5RBMoR0OhfdxmFgslvJbnnK14H5GC/U+LXBU/jypJB7wK5R5WQ/RY1G9/Ay7TUR2Usqvc1YbgAtChS8YbCK5A6DAA+6dxIjFvu+kADeRwbq7a24eNgISuozIvt4H40eLUtXBbnVriVaGMR2CzWENlKhZZg0Y1nUc6JXNFGDvECbIhMWqdjswXHXTFsY8owdtsVJi7B4FiDW/8asOgGKYPS5Zk+eQzXsaEOhuabba+WaeT4FU8kiwujJLvQxTTQ6B1zOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(1076003)(38350700002)(956004)(316002)(86362001)(54906003)(38100700002)(508600001)(8676002)(8936002)(26005)(4326008)(6666004)(6496006)(66556008)(9576002)(186003)(33716001)(55016003)(9686003)(33656002)(66946007)(52116002)(83380400001)(5660300002)(44832011)(110136005)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zdJbl4cwhjcA/WX869zSLSRC86kwkI0oqTPDtWrVvyTt8bdvgFKwau7d3ZIw?=
 =?us-ascii?Q?HR6DPy5mNcVrQ60AUF3+pPBryhXRf9TwQ4tjn9K4RrFjEIGPVA1pxc74iF59?=
 =?us-ascii?Q?xxsEXbKnty9lYQwEiyu9BgMj75c36nq2jfebWAsKpuK0MwX205dNCr3tADtp?=
 =?us-ascii?Q?JHi9w7PiKKMd3hc42IFQ3+NcdCLP9qE/YDWCss1F3LA/NqprXSWm0uu5W13A?=
 =?us-ascii?Q?n8au53WAVvDBh7vXfLZBuvGFJsdnzYX2H/0vwDjiWbdTxhmAmH+Aw6nS/0sL?=
 =?us-ascii?Q?tA9S9N9iGaKsiNgdXFp97vkMSQlXFt13BtL0tnzvyp5lKz/wUafxnCBfi6MM?=
 =?us-ascii?Q?cXMXjXZES2NBqxonrD7BuMwSQE2uC9vttFvZkSAXWHDJn1P4c6X3xjLspqn7?=
 =?us-ascii?Q?Eeny3hgUx2z/ZchJtDCL9V4nRREPG2sbZ1PI8b7RYnX1adAuI9TC9k8Ixfkg?=
 =?us-ascii?Q?JDmcA2eB40oRf78sG8oCpFNIa4ptxUg/TpYjjzc05PKT+j6iDenqzhS3/pqW?=
 =?us-ascii?Q?sxChj291U33cJcuJGWufNgwRYcA+FLWFiWY/uVtOnVDlgFk2ELcsXuRglkg2?=
 =?us-ascii?Q?VoYYvOuYmfCC3wODncgXU77ZuXoRlmJexGArMiefdQm2pvlq8fEeaQgtMfhD?=
 =?us-ascii?Q?9A/6smEa8qgqjzbDeODQsWVz+RJu3JvpdDtZJUGVTkl2sIX1h16QZXrAMU4P?=
 =?us-ascii?Q?v9wik9eyfjGmLyc43NZW76hNA0mvxbHcOylYGWjXxs9jOO92sJ7IxmfbhqNH?=
 =?us-ascii?Q?Z+ztVAF+TN5A4jJdnxleacus+6EzoGLLtrBXC4jGeVWtS8X6WgqMAQPRWJCy?=
 =?us-ascii?Q?lPmKS5H4mxwlI8lJsm+V/1VFJxgKHA6xBZtlCag/rDRgYSDk6MrMcqnJYgU2?=
 =?us-ascii?Q?h7/5Hms7aLioO+5i4vYduzXvH94H+lfLR18rXDos2BwvNIMsT6CPzStDYYO6?=
 =?us-ascii?Q?KOZss6c9FiA5kHJ3n0rZeQ2/cW0pK51VsJ7PpP7ZlX41S7SxD1TGuTYpeVZM?=
 =?us-ascii?Q?UZfJResyEVesns7mSPZvZ5TFaruhH2468CG5xlPaFmMB5TaZxbsfoy1omO2I?=
 =?us-ascii?Q?jXO2Imy2G+bVl5K0DqMTaLi0/wiU3lvBeXBc1X8MxxDgKXWXsaUJGhwdRBfy?=
 =?us-ascii?Q?OcF4xZdzZGw13oO81ciPgHrhIzJzJ/hwqmF1HygJA2HwJ4CRFxeWm864gePU?=
 =?us-ascii?Q?edMnsgH+AjLqh5A+l2X1TsIPjd5yFrzSQlRWciKqkfOB+Vm9TXO7Y/hi3M3E?=
 =?us-ascii?Q?rgYWUPEk7aPx2g8UVQbOTxcJCcz80jMjsG5K8aRmCjNtb1rp/jqkjpzwGfs4?=
 =?us-ascii?Q?c+UT+FkZlOnre7dRN3zCTAT6JJagwP4XPhpt0GtRXudFeXFv1WxutSi+Qtk3?=
 =?us-ascii?Q?md0HGnmkVax2vHgfd+8GuuPc7sk2gMOhDO9NRKs/x70xV+zOsZKIVMZUhH5q?=
 =?us-ascii?Q?LWCwPpf8AeZlbsCqTMcDp/dBo0oBCT5kVDKbqcMFg5ilnwmL+LqE5NqA6A0T?=
 =?us-ascii?Q?QCN2eC5+DXKebrYVE0H7+OpOVLlLUxpbxgR/LZ07IYYxSx8Oa93DHaXy2Don?=
 =?us-ascii?Q?IA6ngV0KfJtHFjE14H083qe/pHtQ+JYhWqm6wIqav4850b7gzptxGIH0WfTz?=
 =?us-ascii?Q?WT/Jt+WF89bqtd6jzEOs8zrBXEITBTPrnW+55ES79Iw1AoOEwsr3oy2lDMA3?=
 =?us-ascii?Q?iU64alCrA7VeBR8AW8bArFzzMbQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8565eb59-5c8d-4406-85c5-08d9b64552b9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 10:11:50.7773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1sd8a66O0Es0DQZfhmcXJnEJvTsehZBIj6mwFbXIYpJZQu6wsHftbirxV7ohBxnliBFbev1F9QqCQLE0VMh6ccOzA50gwEhH5lXa5IkFGZc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5460
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10186 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112030062
X-Proofpoint-ORIG-GUID: ZOPU9SJShFXmZul4Nh2rK-zVsLBZ9ZTr
X-Proofpoint-GUID: ZOPU9SJShFXmZul4Nh2rK-zVsLBZ9ZTr
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two error paths which accidentally return success instead of
a negative error code.

Fixes: bbd2190ce96d ("Altera TSE: Add main and header file for Altera Ethernet Driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/altera/altera_tse_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index d75d95a97dd9..993b2fb42961 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1430,16 +1430,19 @@ static int altera_tse_probe(struct platform_device *pdev)
 		priv->rxdescmem_busaddr = dma_res->start;
 
 	} else {
+		ret = -ENODEV;
 		goto err_free_netdev;
 	}
 
-	if (!dma_set_mask(priv->device, DMA_BIT_MASK(priv->dmaops->dmamask)))
+	if (!dma_set_mask(priv->device, DMA_BIT_MASK(priv->dmaops->dmamask))) {
 		dma_set_coherent_mask(priv->device,
 				      DMA_BIT_MASK(priv->dmaops->dmamask));
-	else if (!dma_set_mask(priv->device, DMA_BIT_MASK(32)))
+	} else if (!dma_set_mask(priv->device, DMA_BIT_MASK(32))) {
 		dma_set_coherent_mask(priv->device, DMA_BIT_MASK(32));
-	else
+	} else {
+		ret = -EIO;
 		goto err_free_netdev;
+	}
 
 	/* MAC address space */
 	ret = request_and_map(pdev, "control_port", &control_port,
-- 
2.20.1

