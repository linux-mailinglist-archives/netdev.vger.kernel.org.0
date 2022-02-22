Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A33F4BF9AD
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 14:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbiBVNnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 08:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiBVNno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 08:43:44 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87AC119843;
        Tue, 22 Feb 2022 05:43:18 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21MCPJtc032176;
        Tue, 22 Feb 2022 13:43:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=tbQay5rmI/aOXYoj4rdxAyhNJ+Ke5aeoDAcaNFnsUh8=;
 b=G+DVAOTjgY8tzPyeHWelPbdxrYUYHegPSAKS7xTCBbaxAdTtnrn8K3yPyp10hqsti0Tb
 XJf40P5uuiU6jNRr8Mzo9XjmGYw62t1dvqhWtLSR/yHmQqnlrDssSiV21sibrfwDRixJ
 SWOZGwqGuSnAOBUQDmv2/Vp/B90BrxrkMmVV8SCU6pPBKdVu9YYLRQB9gC7mN5K/Npd5
 EN4o/ftZuZbZijZaiSkJEgo7mOgwRDcuuXZ94BMreuSdoMcRTRcsM7lWun6CZNBpCPdV
 7pHY5X0+MMYQV3d3g/hgw75apz5J9Dc+ZOBFctV3eajibix58YGuUNeidtb+9cTwsLu7 HQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecv6erxaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 13:43:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21MDedCO164678;
        Tue, 22 Feb 2022 13:43:04 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by userp3020.oracle.com with ESMTP id 3eat0mwc9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 13:43:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eP6/FY1pySsPGLlriqm35rhvpdyLYYu+7ggTR4u4v6ni+2jL+v3Zau7irFTWi6XAVCVq9rJus2+OOWXq83dOVX4ipIp6vSSu/rpEIBZYQK0HryhGLqentI0FE5mrq/3LkbqBxx1/ycY4EKDC3RZxvQ7+QWzLEqYDFwElrzwG/Tbksmb6hK5tvwjpxzs6UQoPxfz9Q+JsgZQYfHFlpZZQ0OU3664yOL21W3cGODsUO99SX/Kmg0fXcOl47lUi5WiBCiE24L0afBYz33tFhT5N/ykn79qC/QMRVU/uOiHsqxSGxkJeAWmfCKrT4nFXJttFozMUG1H4VQHYe1/7gxoAyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tbQay5rmI/aOXYoj4rdxAyhNJ+Ke5aeoDAcaNFnsUh8=;
 b=ioTf3DGZkupT00iJCTYI7MvLS5LyVIMbXVnOkvl9ROEOsTaPflYX/MDThRnQ5HrRqdnWHIrJsHVRme6+xtiPkxJjib1L7x2LZDmPUsWLo/tZ2oEkWRblh+xha/Nam4oN69R2G2GOdzMuZX+NDK9UH2t+xWbWC9lYMkRmiWXSN6ucgGuo2YpNl1wKsDMR/Pl1fG5/a+OAOEuM2h9orPxbDdH42Xo64rxJnnh9UVsyRSAaAE1ue5m9E+I7K3vzDoEF7++k05y3YFSo7VjH6N/luwTfMyym2kGjJmSGlhzeKWeUX+/TlLGQYdgtH//anlgpliQ34O0rccI19Qyb8qqmfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbQay5rmI/aOXYoj4rdxAyhNJ+Ke5aeoDAcaNFnsUh8=;
 b=xOMfOoJcH3DYCFvqvQ8E3d3kCk72r0D90qTQR8/KlQIxhoLcTvsjG0y5d7Jr8BtkL+LPSQPRG7Lu2KvmQlD+dBGNtzIT7ytAbuY579LRnjeOk0fB40x80VHbHgyfqt9+aE9nia7M9p2viIPrHtMBMfU2mEkOhHJ33KHiHCUGAbs=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN8PR10MB3700.namprd10.prod.outlook.com
 (2603:10b6:408:bc::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Tue, 22 Feb
 2022 13:43:02 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 13:43:02 +0000
Date:   Tue, 22 Feb 2022 16:42:51 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] udp_tunnel: Fix end of loop test in
 udp_tunnel_nic_unregister()
Message-ID: <20220222134251.GA2271@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0196.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::22) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90a52c5e-d7f1-4032-31c8-08d9f6093ec0
X-MS-TrafficTypeDiagnostic: BN8PR10MB3700:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB37007E0D7957C9DF0B43D32E8E3B9@BN8PR10MB3700.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7i2qia9V7NYPapOwdoI1NyCDGsJeCgWZxeT03tcotnieEL3TTMx3wSZVpKlepg2ke5d16dGX8PMLgWUiDB4dG2GE28SHyW4X0m5XLu4wOylP8b+qHmm8q7/Yaai8TM1vi6D9v4vtJkgHaVya4MYtc0c/bPIS8c8IRZe1t0UIiUIH6qyzMwzdn0znMMbXiZoy6L9BOb5lLviszoJO2QF8H1fvHN8RZlFIn4yRyL/YQvxjEulAS9/ZT27uhvY06JZghEsII8FkWrsUGJAVCOndWvRA6VDMS0cNQLTVSBF5rv7aKAjf0/6DdJL+C14z/nkndFLBIr7kJY0oI+YZmRzHMWMBsYgb8+F3ji4xPJ1JQEadCyUY0tdu1+SoYoFKJTkSBr+b7Ji+k08OWhDz23HiPDe3VMplF2hiCppVs7Z8KdOC1wqdB86gy7kMcx52K5GoJbtDAJ7q7py+dtz/vxzgikQ7Y6EJA6D4yD4aK2kLMtc00LbC/dxfOysTd0dUe4EJjhNtw+rnByAKtm9rLTMU88+qD922umzrrf+xX6fYUrIh74orvogoDY0pl1xATOVS/ejTTpv5VRYO+sMhQLDOjKLzN0qnjAA+R8bfez8WcuROir88q0uMFCfxdvrqNdenzhkoiDPMtkMVAR1wUUGJBo7RjmsNDLjMMGHtE5aGm7m1BbONs6CPC5F6/AfU5pswd0TgSfRLIrTKUFiS4g2Sjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66556008)(66476007)(8676002)(66946007)(4326008)(508600001)(2906002)(33656002)(6486002)(316002)(6666004)(38350700002)(38100700002)(44832011)(6506007)(52116002)(83380400001)(54906003)(5660300002)(1076003)(9686003)(6512007)(110136005)(26005)(186003)(86362001)(33716001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1JA+MnOXQo8A1vdaXQeXN9jl6wBqTPUpiuiSkliO4W5WO0exNLlVrfXPcdqs?=
 =?us-ascii?Q?pFBTvIy2mOiGg2gsrTFuKnwby6aVQBfdeZ2C/En1gEH3z3ndgsA9SRdAbeXR?=
 =?us-ascii?Q?W3Gqf1jf4fwBrsxqE/cnJwsdp5cdXhYH4zCyVCJzXMDIBoxYf+RNLP9k8xlW?=
 =?us-ascii?Q?XZgZnFyCXGroq99emP/NNw30IvoFK0ml3OuPIvuUpdGuO94R+R/TT1+yehoV?=
 =?us-ascii?Q?TgYElOJEjzcbhd/Y2/CUC/t+nHRnRfmrxQKNkWoJYoXvpq24bDd8xaxwU/yr?=
 =?us-ascii?Q?7Fo8pGCpDQNAgvffYUWdGO0KXLPG93tWO+mH0ghfCWts3SKGdFq5UuQB/u5X?=
 =?us-ascii?Q?ZDjBoYAj4e+rjSnlh3/h3SKWSXUgOko2kf3bZtocEaNUnOhP7Aayo7ZIRkEp?=
 =?us-ascii?Q?/qyHgdUquD4R37NPpWRMxkuhFwU1U8q5Wy9fgD5iIhxw5Vj+FO8UEvlHcF3r?=
 =?us-ascii?Q?CUakmqdQcNzekmZC9NrvoKqKAprEfA953sHQ3JHMx7SwKY8FUPcT1ozg9z5W?=
 =?us-ascii?Q?9SJcD68VT3MBtdhBiZUYSIQigmxFKD9eWTspfphYpYe/GWoRuw+WoyfaiB+v?=
 =?us-ascii?Q?NXTNWqlkGFWdL4XMxmyBC+srKNWNo17n3+sLwTq2hfbgYhp+xYJ2nYmEkbpp?=
 =?us-ascii?Q?nDxnc1BquGj0/8lEUNXtqfg5jXkNx3qB5YM7+Yq5U0GwmPM6/f3uWCbmQn5d?=
 =?us-ascii?Q?TLmjigwhprWdTMEpe7UCXOeTnHdfbF8PJSoKbCzf2NU9nSWxA9Sw6XQgZ+Lh?=
 =?us-ascii?Q?pEsre+X9TJ35M8D0CCKLXcNY1dwy43lu3A9sgiGIKj7Umlo7iPbv2Dvc+FvB?=
 =?us-ascii?Q?f+xIC1zMUkx9nPeaZ9kJEH8lpSHUOJiHEzaJunzWT+iQOXfyTuFbuIWm9VgR?=
 =?us-ascii?Q?+BowAToBCRjIvF8XBrZlJorS9H/gIZOHNpByd2tHkVomOCIu2uuTMzudx6zy?=
 =?us-ascii?Q?EPAqUUbz/rNn5f73Mn7W/VRRoDANQABssS4Wy1f5cVJHe8lS6F2/HO0MHxHk?=
 =?us-ascii?Q?5eo3WGvZGSA0xUgZe27eAvoOJQJ/gIjcaEtIMklUz+MldMq4/rqB13mPuU00?=
 =?us-ascii?Q?ZB1UkuBKdVZA5IIyKloKqcjKSntCKTGuU8GOU+PqaBUoaEl0swulzlgatUjy?=
 =?us-ascii?Q?5URIQPKZ4Yhlh+w15mSqn2sCZ5PxKLZLOp1QtdVq1CGu/T83dh15CVBCcvDT?=
 =?us-ascii?Q?ho2gUocVEarre3QY25hr3G6eXZ83voe3HvPTx6V2Pp5YGVqhiQSbIWCNUdFH?=
 =?us-ascii?Q?MVJmRFr8D09Ur1uJvA6vVUHQIJE/KjlRqjRRLGnsFBKxfCJmWhiTzd/3r/OK?=
 =?us-ascii?Q?ETbglsSN4R5/NAkQLob1NQVVsq1i3+tcEb2BgdyhszZGpmGGpSRzYDF4lwa6?=
 =?us-ascii?Q?2FpbQf7b8FPmPOSbdW72rN/l6gJV9Ji3iRuJCa9Gj9PX+mRHN+Am8RqZI1zN?=
 =?us-ascii?Q?O6HXB73KZ1qgoaSu34du9Ouby6JU4/5h3JkwEXUZYC/G4a9LYlI4wiZKnTvK?=
 =?us-ascii?Q?kcknleEh6aUXvP+AITuqJ1YfIK4pQQNdx9cqxa5WCqh6OOOBjX2tDflHFq7S?=
 =?us-ascii?Q?wAm1v7mwmGuqw7d8obUAREuiNWmJQomcthzEOitPJ2GOMhc2vadv8RrQLaSj?=
 =?us-ascii?Q?J82T/6NHhTaA4O00ds9le9jsskkH0rnLyWxIjQGiuq1NNrKr2PUxRZNkno3O?=
 =?us-ascii?Q?lHhscA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90a52c5e-d7f1-4032-31c8-08d9f6093ec0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 13:43:02.0838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IxLyj+8UzvdrHRiz1+PdKY3RscCvXV84f6VAzQ0hTt0VppOQPzp9uJnF6cbdiVm0x3FA2EVJuc+fGCYHEpzONvfvQibAapMWUGN4CnRxv7U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3700
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10265 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202220083
X-Proofpoint-GUID: e-89wkwne84bfCpLK00pVjc5lMu8mLs1
X-Proofpoint-ORIG-GUID: e-89wkwne84bfCpLK00pVjc5lMu8mLs1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test is checking if we exited the list via break or not.  However
if it did not exit via a break then "node" does not point to a valid
udp_tunnel_nic_shared_node struct.  It will work because of the way
the structs are laid out it's the equivalent of
"if (info->shared->udp_tunnel_nic_info != dev)" which will always be
true, but it's not the right way to test.

Fixes: 74cc6d182d03 ("udp_tunnel: add the ability to share port tables")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/ipv4/udp_tunnel_nic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp_tunnel_nic.c b/net/ipv4/udp_tunnel_nic.c
index b91003538d87..bc3a043a5d5c 100644
--- a/net/ipv4/udp_tunnel_nic.c
+++ b/net/ipv4/udp_tunnel_nic.c
@@ -846,7 +846,7 @@ udp_tunnel_nic_unregister(struct net_device *dev, struct udp_tunnel_nic *utn)
 		list_for_each_entry(node, &info->shared->devices, list)
 			if (node->dev == dev)
 				break;
-		if (node->dev != dev)
+		if (list_entry_is_head(node, &info->shared->devices, list))
 			return;
 
 		list_del(&node->list);
-- 
2.20.1

