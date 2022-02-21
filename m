Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13BDE4BDEE4
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355724AbiBULRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 06:17:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355954AbiBULPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 06:15:41 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8385F4B;
        Mon, 21 Feb 2022 02:54:58 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21L9WUZg002355;
        Mon, 21 Feb 2022 10:54:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=glkbg++XiiklfCjkn3ChrKY1JAlcFqvJvgwInzV370s=;
 b=RUVcZs2Q+gcBBcZhu+p6ow3MC3hZj0GJ0sV5+wpe++QF1UsuDVknMBf7HVzfha62uXFg
 +X591Zfm3oTheDUP9Kr8nhvxEsmHuCdq6TBPBXzcCwe7f1qrl6TlFfHbG1HFwqww5T33
 zxO/+626dlCvg+rTq7F6GUfoa7Q5VCNUNEyOkh3z+0+q2EnZDXmjBv2vc4MD0W0zAIlF
 1WX55l0Q/mARjSAjSL40jMYwEMkzSXVylLqwRlNJnig0DK6ugiEVDb31nBnZ9bJ+aj1D
 +WN0ew/3dTzpcUduIpwsZOh3QVyI+2ciUhwTC8OKgYPMqX/uC49Ho+lxte1Dx+MWgM4X QA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ear5t3t46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 10:54:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21LAomjS006558;
        Mon, 21 Feb 2022 10:54:52 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3030.oracle.com with ESMTP id 3eapkejbq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 10:54:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zn+qjPPugpFEcb4tk2Cn8TYErqAYvEvbxOApEPKRhfUdTA9K3aVajv1TCur7kqpvFFsAeOgjhn2MERgdbD0w1GH1KC0i5yAF6pkeetSppETm2WMptAEq+emKlzHvFXdFAn+2wF9io/9BmdSy2Q2549q0YUCEqWSw5WWrjgCnkQ2SzonXWSBhfeFktQJghYdJpfau6MDjysD1M0ITgFmfDo9gxoHk1hfADMpHqnlLuLWVT7dv9nYQg/RiiyQHSsSTwhOKQAPMLlIPvSfODjzyrgfNvW4Shv7c+oY726dWSTxAhp6HySqK9qZICrlUckHd4ec7JrW/ufBG8Z6vMdBIgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=glkbg++XiiklfCjkn3ChrKY1JAlcFqvJvgwInzV370s=;
 b=NWOB8Wv3bzlXJYUs1dhM43ZznOtiIpt0FCcO3TxOlvmXxulvt/sOFJijdUvfzN35BY+WI+TlPrsm8+ISNQ3X3kNroGwBGyI3yPGk78IsC+jYmbpnX3TXVxwCuP+aiIr0gHWz56kjDyWy60lo1mvzcEBG++3cTLl34t0WCr2Qmuvj7Gi8NT67YdiLq3cJj4q3Y4RrGhuCEZu56rxpdh0x53mCgXA3Igrt4UEsYqBVK0M2xUIgrkYkom+OswdkwJN4ySPyfrW7liGb7T6O5+F/pKpSrvlt9XmbcePujHviTVVcT254tAbqFklMS+vrz4Bk0xvkrFsJwJPEsjfl6ZINYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glkbg++XiiklfCjkn3ChrKY1JAlcFqvJvgwInzV370s=;
 b=i9TwTtwnLJlwq5uK4px2m5yfKp+0Qp/cWqcg+5xECZbVvFiU/po/0wbLYfLg29IDv3se4DECAKUw74nWU4voRrlpjy8dwm1VTnd5eyuukkHT+ypbatbCHqlaJPJfNzyBvvmy7PZeh2GWmlkweHMuPQFOzMJPkT1SgN+x7y1e7uY=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4450.namprd10.prod.outlook.com
 (2603:10b6:303:93::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Mon, 21 Feb
 2022 10:54:50 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 10:54:50 +0000
Date:   Mon, 21 Feb 2022 13:54:40 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Joseph CHAMG <josright123@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Joseph CHAMG <josright123@gmail.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH v2 net-next] net: dm9051: Fix use after free in
 dm9051_loop_tx()
Message-ID: <20220221105440.GA10045@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0008.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::18) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b189f72c-e5cc-4a44-a646-08d9f528956f
X-MS-TrafficTypeDiagnostic: CO1PR10MB4450:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB4450A32E74317E1B5DA9EF408E3A9@CO1PR10MB4450.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W40OHOZ39lO/h7jrAv4nlh8U5cxN8heKRXTGj4MlLyf+PR53UziejDyF/XTwXnYmPOIRuR1pFwkQ69fTFI/ASCvOIqexgjUjKLeIKESQ/N1An7yz6s4oT0gXUCiwfqQSsTH8QWFGoSx6rVKfCqmhbykt58QIjqoX0yFjbz9svImX00I0mP7poNVfLw3rIr9Lmk+puIXrGqT39k8W9HIgwGSmz1ig842chWbn5J+farO9RwMAe4M8vHPTdCnZqRmj2w/eKOZRaystOapeTC82rVjxvlNy/4NzMLV0AT4OdABKN3gNVJlhU9vnyz2g+ydK0ro+3GKT+zK/6xpmoaPutDn0NGQlsxn8cNzlgiIJDuISPN2oAg8Qli7qfQPrVpDQM4/VwTEOyqaM/vlsIqx/EbP3PXInnwUgJXOxHuWLpAfI1VYNJHEvcpMaK1QOpooLugyBbNMbBDpdOe9SA6xLe/GeGwLChhrQaD/baiJFnTXoovsK7+FjRrjSsx6eIj0HNwyRwXWyFLIj86J7zCUZvs4NN1F2AItTsfY48KuBxdM97AU2toYe0FdJIKQ8a85xj/tX4CRZFpBVIaYX6F4ljXId/BCh78j43mPSlyiSOtMX8WSgHMn1Ad2X9/Ge1vvPqsaz+EdJa9MjoeyqcwqXOnlpeglTM08KqB8GcCD3xtvom/Op/22ZYeTqlhjZFdS1IF6BFFo71yig6uhb+Tv6eQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33716001)(33656002)(83380400001)(54906003)(110136005)(316002)(4326008)(1076003)(2906002)(66556008)(66476007)(6506007)(9686003)(6512007)(38350700002)(6486002)(508600001)(44832011)(38100700002)(8676002)(5660300002)(6666004)(4744005)(186003)(66946007)(86362001)(26005)(8936002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VEoDB1KZ9kKLNIuwrrMAYwwPehQb+vnSaaWYkBRKcvCMWxdCTYouvjduMSSM?=
 =?us-ascii?Q?TIAF+BRIZITMGEiide6ciMPAIYtZ96uRj9Ncw8J4SA2Ynb5yBPhGF0393oWW?=
 =?us-ascii?Q?NGb/hjr0HqO7cZ4JdlPUEVBLsHmpXKWteJ6x3UfhNogb4/McKlbTRzJSNaDs?=
 =?us-ascii?Q?J6GCO01sfg8y8P1IIMl/olZzCD+U3h+7LfqEpYBL0jlLOtzd2wTGHVXm0mep?=
 =?us-ascii?Q?FRgJGg2TxkyY6Fa31nm/eXZUIoEiS3N7LPPPd3e8zHGoJEBhcg5qhCcD0trn?=
 =?us-ascii?Q?Dg0LaF0D5ZOHj1xM2btAyxlv3akeZSQcMcgZhUsoh72/16RaBt0VxXu2Sj6P?=
 =?us-ascii?Q?vA+rfO9HoUmIJnm1jutv1jLaiDnNVIIAcVCmRtXRi/+5z+BP6V1XT7voV7Yf?=
 =?us-ascii?Q?coTHwgs6J0OdQeb05YvYy0wZN9veDb7ZdwkuGBZOo4GDSvMTy+GpPdpLWaa1?=
 =?us-ascii?Q?L5kWxW9t88gha9CeURSkNxY6W0roVWsaaMxO25lLoypz1yPAKU6+aD14wrs3?=
 =?us-ascii?Q?tvcHs44Bmga7iP6bQkQs+tYXzQt48kPFzIfFgs4KM3Y4mvNJuSj8RhWxn1zq?=
 =?us-ascii?Q?USbG7+98zmFdekAFrt+zMniOxvQKA001xUQLTpIe8AKFeMBrovCQIyZl66G5?=
 =?us-ascii?Q?6XkrSkdI94PcQq0vqv7tQVImznvBQ9GW+4w6+q+FMCwv6/QIgWAZvv2osZdF?=
 =?us-ascii?Q?az3URy9/CraX/QT9j5X5CVr5U5tvqHPalssOXeLxqtWSob3N8TVMBH78ri1A?=
 =?us-ascii?Q?13ILW6GNdDP5qG/Nm/z8tCGMCCgOLtZAYaagivGtng9Tpq64oslZByV5MO6q?=
 =?us-ascii?Q?VLaXQ+WbMFixveXpcn6pF1aufYndNl1hcUMCKf7TKyH8j3HvuPfJw8mEfXNZ?=
 =?us-ascii?Q?4zL4qr4zCVgeYXWrkpkiYh4YoVnUACv18e/fsDN9TfPC/yVP1XznHQwc0cqC?=
 =?us-ascii?Q?SkBRSiK9uiUVinacNMJ/CbF+8LWrnlAX5QREOPhm5dq2eaP8j4PvNMLRDuP0?=
 =?us-ascii?Q?acv5bRCeF5VkAB3dYFW3EzlhFmedYYfS3qhvXHnNF0bWeqeR3PvW1lJ8JZu6?=
 =?us-ascii?Q?atxWULKX+KmB3YHDgm9I7RC0NSXCCWYICDC3MifZex3Gzdf8/kODZmrTUY8K?=
 =?us-ascii?Q?WJ1O/Y4TDUHaRNY88GFA027NvEYO4c7rG1y5vhmMHmER8OMy0Ua7C9f9alDy?=
 =?us-ascii?Q?gnWq3TbNmmGUdv83KzDshsx8JUjl1iR3zusToeTpSPMH+ju8l9g6U6Y9wJSy?=
 =?us-ascii?Q?Cv8WsOrGDivzxEeyaaYoEHvrhourUyk3iJK9XF0hhvhQo0KqUYo5V0r3EH5R?=
 =?us-ascii?Q?XWj6mD8QA/HiROYyx+wEBUrI4F1d6pJyQgc1uZIy6oQ7QBJb6QFzda4KwKqB?=
 =?us-ascii?Q?ddGagAZM7q7muY7pHSTVeSaM+ub4WB0GaH+2CiOChMXnS1cOnLNLAAx2JZ56?=
 =?us-ascii?Q?HH4I0bjPlbvhxyORM6m6m3A7fA1+eVEW2vkN3BVXtKoJdZe+8E6igUWjZSlU?=
 =?us-ascii?Q?y6Vx68h5zm53SKrjvjwwZRoVt4T6azdTUjynWo9qtml3HApkslfY0KioQuLX?=
 =?us-ascii?Q?nsRKSJiDFMIbKQgX2OxRc1n8sfu/6thKNEiWAEeptIh4NxWrxDT3uHV4JlQS?=
 =?us-ascii?Q?mBtGcG8HRKEA5Ai4KxYmE5hzBWdiWLGTzmIP6+88qGZkX+MmzdfLwdB7nmeM?=
 =?us-ascii?Q?/dB/tA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b189f72c-e5cc-4a44-a646-08d9f528956f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 10:54:50.5504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LG91i/ipChvLMIVznlGr5d3bZwuKA+iDJ9NTXKQUm7UijpOPuwlhMUKc0jsWCV4X2GYxG49Y9OQlWFXmDnGJ9VEpJ76LjA2Tw+te8EmJ6G0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4450
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10264 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202210064
X-Proofpoint-GUID: e7qTKJJwLw-YItpoKkFuDj-sdizu0_HM
X-Proofpoint-ORIG-GUID: e7qTKJJwLw-YItpoKkFuDj-sdizu0_HM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code dereferences "skb" after calling dev_kfree_skb().

Fixes: 2dc95a4d30ed ("net: Add dm9051 driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Only record successful transfers

 drivers/net/ethernet/davicom/dm9051.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/davicom/dm9051.c b/drivers/net/ethernet/davicom/dm9051.c
index a63d17e669a0..20cdca06d267 100644
--- a/drivers/net/ethernet/davicom/dm9051.c
+++ b/drivers/net/ethernet/davicom/dm9051.c
@@ -845,17 +845,19 @@ static int dm9051_loop_tx(struct board_info *db)
 
 	while (!skb_queue_empty(&db->txq)) {
 		struct sk_buff *skb;
+		unsigned int len;
 
 		skb = skb_dequeue(&db->txq);
 		if (skb) {
 			ntx++;
 			ret = dm9051_single_tx(db, skb->data, skb->len);
+			len = skb->len;
 			dev_kfree_skb(skb);
 			if (ret < 0) {
 				db->bc.tx_err_counter++;
 				return 0;
 			}
-			ndev->stats.tx_bytes += skb->len;
+			ndev->stats.tx_bytes += len;
 			ndev->stats.tx_packets++;
 		}
 
-- 
2.20.1

