Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3506552C19C
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 19:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240944AbiERRho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 13:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240889AbiERRhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 13:37:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7745C179C06;
        Wed, 18 May 2022 10:37:40 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IGgwCS001104;
        Wed, 18 May 2022 17:37:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=5he2Bmb7uBgubgTtXsV8vr36ZgCkZsMl4CxZVmFD6ks=;
 b=vclCD1bsCZm1A186hZoUEHfsuytP4eiOX+A2GCdA45yCQPM+Ldc7/BQM1ehB+mnuD2VU
 oyITGsRABNtkr6kPLqKQXyXxHbVJlEMLSiOkjOniXwc9F+J61r+H7Y3mzFhfvYZbyMh/
 2O4nS01RuGQCRmRZ8re2IPF3hNYml0uLOd82R/ItLsOh0baUZERnQ8ugVJOR6b1icXiC
 l7wgjfcA68WZM/QN85hnedlOaB42EPun8JvaASfKjSOOJds3rPm6au/pDp357W/44fj6
 t5kAvRj+oKe3YdIdK3L0dJzHK/lKBd9QN9Gpy3EaOWPxdPch98jAUOZFoE93U5M54363 Hg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241sa28m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 17:37:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24IHa1gk033856;
        Wed, 18 May 2022 17:37:28 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22va15tg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 17:37:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEbmNQYwxVVBUNNNq6/bWC8Fll2tmnAPvAP5U4lS6SGSuGmi+23KRLhphGfm+bdkPKMbtjVenOL7TWTBU5isFMScI7ES/uNDPhmGm1qhugtA4KDS2QUAqY7wU0h/KA3FcDFxPU6zu3wqAZuCmky6uMhSDlP404469hwMginvwUrROp4RNUHGD+N/noYYPrk7tQ3aVdHH3VCjrqouOo5wkpvfeXKocEAIjZUGgq/X6j+xxJ00Zr348OaC1K26vknR5FrBjzwKzTSAZ6yr1VRqtLDQ2NrYsJ1jx/TkamEdiFjCLyV/v5+GpEGALq4pdKaNK1XdZhNUq/ypnhsCdVY+Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5he2Bmb7uBgubgTtXsV8vr36ZgCkZsMl4CxZVmFD6ks=;
 b=fwENsZ5f1gAj+D8TVk1pQf872djYjBl5Vnv1t+TucKpcPG/nKQ9PWaBP5kCE4pAI/9Urb/jSIEQQOLcN+8KTiZa/B4ZBYKKsTDGBRcxUdmGLjMNNy3s+/hx0zjeEijXIAbyNsMvLnkfqyGa8HH8Qt13Sjte3xPaTK5WRrXKb6Lgk32wMOXHH+1LD+PPVKxKWEjKvfxYXUq/UvlwwE+N691SXY5viHsFZSEqzdOESz2GwR2wp0kwL9j2aNsrvjbqUKKD6M07PRr/jvoCCWqQ6r4EvnMfuXUlULDfRno6DyXrZ9LUKb7nWo44JDr+W5r+v27Tiqd/hPbn3ZU7+AdUkkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5he2Bmb7uBgubgTtXsV8vr36ZgCkZsMl4CxZVmFD6ks=;
 b=FeOYYDHSWdbg73Elgs2+9BDxmOPavhbMW8t3lnmjujQ9x7AnWCD9J1CDuwApfTFN8rJZQ3KpUwJ9uWYUfighstSalLOAb/dTqSLmglS95dYMxCm8tN9f6Y6OCZl1kb3RYToH1txP5i+QbJBpLDIsXLIpqSHldThq8fxnK8kceGk=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1485.namprd10.prod.outlook.com
 (2603:10b6:300:25::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Wed, 18 May
 2022 17:37:26 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 17:37:26 +0000
Date:   Wed, 18 May 2022 20:37:15 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Wells Lu <wellslutw@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: ethernet: SP7021: fix a use after free of
 skb->len
Message-ID: <YoUuy4iTjFAcSn03@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0104.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::19) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e075d575-a774-46c3-d6b1-08da38f51295
X-MS-TrafficTypeDiagnostic: MWHPR10MB1485:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1485ADB1F03F84623A0F8FA28ED19@MWHPR10MB1485.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +9mwCocApzOzo2o3A9uuODI3u8x5pS8Ssgkl81D6rsT2CSgNu8ve1brb1G4OH7sH3RLj7aD2y/ECwZCU07FBfg+a205K1iDsBufKmFiGV0lF+O3yL3at3bJF2j1O2Ljv+uhNkc8cVHVYp5msZB5j1EqnAY+zZVlCNXVNqF1UgQMxAuDYH5YLGP9+K6eVyXqm2+o4gvYJUnxJ5W2I/XYaOLHGSF4dhH4HcZ37TcDMxHMvRV+WDzoT77fUkYIEaKkrnoaOJyhFsbj0YKrqrZncT4sqlIwBtBaXdVm1xy8Bjy14IHcp3zM8aYAqvsDppl8jDLY6pdHG/PU9NQRsbiYNHHwB8gI/2+r2wZEtyz28Sbq9/tz5vcht943HbdVQBShbNInpFe0teCaD305msH18iP0iGrKyaLnEVrTYQY9zbxDa180Gxjsx6wPrfFASnxgXnvQgrQ+/rPgPOPRfMGV8dJhr48U4/etxvhz/noGQl3rjr1NTY7aIJI0zUJ2yleNreBnmPYDwNoXJPYLhBkpGfKAsxTvoyl5hU9w6GgIzT8Kb43+QzeB8Pig5XvXDOp7vW1y8YHed4wAQdmkOQMWZWdbab/JV1578iK1PP8wqyk5cYpIAVxawY82Qb8Z2izcVQFbNMxKM1P0s+nWXq81mCHRxP8n385+qoI22YDbPZ4VQWFCalxF3P+gm5V41dDX736MFjYqgeIa63Pi5zkD45A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6666004)(54906003)(186003)(8676002)(4326008)(38100700002)(6506007)(5660300002)(2906002)(26005)(66946007)(33716001)(6486002)(44832011)(66556008)(66476007)(52116002)(38350700002)(6512007)(9686003)(8936002)(83380400001)(86362001)(316002)(6916009)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q23c4G00sTnnenY6hqCMfugYTrzRY2XCSMNzShU12LXEzlBz+jdiLa+pWEGf?=
 =?us-ascii?Q?1FN10W3xxjNSq+fs3Fi9HUKiKrigX6S6ygXkEJ/XuooaoCjaAixDqrbbIoGg?=
 =?us-ascii?Q?1vUqO3P/7ByZ7J3iaYEgrqsglhydAlHX3dlmiqcGCzfBs3YhD1D2LnjVEw+n?=
 =?us-ascii?Q?IHHHuOT+f6EOncVvlHNNJKNbnvmlKSZ91d7aVwjjm7LmJDTaz5raWtA1JsNg?=
 =?us-ascii?Q?3ZPv940ncezZvH57DPPCJ46NTfaSzGEi8bkADGa7FHbwki4EdFT+KpHpFMZ+?=
 =?us-ascii?Q?1cMds54FPDCx7o5pcDou6YDNmpzTGOybCFhMkkenFxIlnRpFBBbV1AG1wyA9?=
 =?us-ascii?Q?NIOZAABBspAP8u6+fxp5UBZiDD4n1usfNbp/riLLfmYFRij4n67JhY2cSJuM?=
 =?us-ascii?Q?bCoY0WKfoRuabBFBI/+jF6Z/yLzK5s01BQ1CdVPmg6mQOt//72KHqgowR3gl?=
 =?us-ascii?Q?tg7LGLBkzWAoP3ZQo30JLW4dJjXazJPFT8X1jJ6nGFMqrJJJr0RuTAQ5xxkM?=
 =?us-ascii?Q?/3KoL7GNNohVFXRhs2s0gck53KmW8YJzEvD+dmGpzB0Rdvn+TJid/rDkkI0a?=
 =?us-ascii?Q?eCmeOl1gen4l4on5n3qtR4iAnO5PwWwo+5WcsCQWPA9KlamT0pxrDeqe/ump?=
 =?us-ascii?Q?Wg6McLfh88hqPkhlGDZsVsCMH/JdqkhENTRcPoNevaK5tearoYdmiTv834XZ?=
 =?us-ascii?Q?C24LmA+HuoS8bxGgthg0heqjgTgC4r/vlVIwbXsUE6FBA7xBwJ7TP4XjNB5K?=
 =?us-ascii?Q?+R2b79ahh+Xu9LUh2TIWlMWKwPc1c25at/nQAHV0diSi48Yu1dnwnI52JYeN?=
 =?us-ascii?Q?z3Ofl1q9t+mfh0WC4GfsaVFx8U0MsC2bYI4ZmygFvs5wLvZCFPq+Dd+hz9Us?=
 =?us-ascii?Q?ZZRgdfPk37pqjeNAYQkUAIqo5xblJDmWhHYDdrGTvE96OMw6AgbYrVCTWXBM?=
 =?us-ascii?Q?P1hoCXX4xXB1sINq9d6rqQsz7GajSW2pZZiw9r/fSBLgbLG4tgkf09ylF7bi?=
 =?us-ascii?Q?gx3UjrP5H5drX3/5SGCrCWtquRfnpiBTaVAAYC98vm5wKkurXq1qq3cdRgKX?=
 =?us-ascii?Q?Yc73LO8KtqCrlyFFmeIdmf1slPn/KJuA4Arwq2wwds9go7EkmPNVfRkT5q60?=
 =?us-ascii?Q?RHwmDMGRT3zrcSXWT+OeSJtAqXGcYw6pTNVr/bF5y4VEDieqvQTqdf/ODAjN?=
 =?us-ascii?Q?ceOelUDHPZI8fCTZiJ3i+F6KF5KXmLiM0saNyDeJ9lvleJVoAyS4XyJFq7rn?=
 =?us-ascii?Q?Wkei0dHVR+xY7YJlJS2737MK6NhcACu32O0AmI6XfUqsLOdnDkDiObS69mT8?=
 =?us-ascii?Q?MjYp1hQQDYU/2wVTfrlkfwN3Ms4gZe4GLjueOHgFk3yFyXAhRJu2jdb1Bsjf?=
 =?us-ascii?Q?X+UI6a/oQb0NQlawltsZmONY2u+lattzLjf13P1RW8NcS3bkcVIb1TPkzPry?=
 =?us-ascii?Q?S9y+itWzV0u8ytXQTTfm5W+Fbco93o5swaje19AUQ9VO2uk0lfvmE1k5xmu8?=
 =?us-ascii?Q?SmIsZaCUohEfAqawTewi9VXhjtu/KQ0BQtACl7muUsAkQh0yM7pcJH8dcxLY?=
 =?us-ascii?Q?Up1KDTwDWNT//+/x8X6zhvBZulPmFm0i1/P+a9fAI4BlxXJ3/0ZPkwSK7ffD?=
 =?us-ascii?Q?d2hvgqKiSl3K9+Tf4pFgEsi6DOaEPi1LoVt9gP/wT3vbx9GqA5YeEvt3LQz2?=
 =?us-ascii?Q?trEyBElyxIWBJwMhKCJfCsWaqpC/2fQny9AJz3aTxpZNDMJ0GmwkNuZP6OO7?=
 =?us-ascii?Q?fTiqgzxAi+nqC8LrDTyJAvAb13iB+Kw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e075d575-a774-46c3-d6b1-08da38f51295
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 17:37:25.9580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OtZnRv3cZvmgwTID7Hqka2qTE1a+cKaCp5Ewbnnh/G+LB8y3BfSSnPTGnp+KpyytXt9DEd2t4H8KwtVvAX7fxk+L3XxFo0Vi6iRuB7HWfUA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1485
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_06:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205180105
X-Proofpoint-GUID: CHOaUNMLRSxKAyPLKpFkN_ezu3jU3Yq3
X-Proofpoint-ORIG-GUID: CHOaUNMLRSxKAyPLKpFkN_ezu3jU3Yq3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netif_receive_skb() function frees "skb" so store skb->len before
it is freed.

Fixes: fd3040b9394c ("net: ethernet: Add driver for Sunplus SP7021")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/sunplus/spl2sw_int.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sunplus/spl2sw_int.c b/drivers/net/ethernet/sunplus/spl2sw_int.c
index 69b1e2e0271e..a37c9a4c281f 100644
--- a/drivers/net/ethernet/sunplus/spl2sw_int.c
+++ b/drivers/net/ethernet/sunplus/spl2sw_int.c
@@ -29,6 +29,7 @@ int spl2sw_rx_poll(struct napi_struct *napi, int budget)
 	u32 mask;
 	int port;
 	u32 cmd;
+	u32 len;
 
 	/* Process high-priority queue and then low-priority queue. */
 	for (queue = 0; queue < RX_DESC_QUEUE_NUM; queue++) {
@@ -63,10 +64,11 @@ int spl2sw_rx_poll(struct napi_struct *napi, int budget)
 			skb_put(skb, pkg_len - 4); /* Minus FCS */
 			skb->ip_summed = CHECKSUM_NONE;
 			skb->protocol = eth_type_trans(skb, comm->ndev[port]);
+			len = skb->len;
 			netif_receive_skb(skb);
 
 			stats->rx_packets++;
-			stats->rx_bytes += skb->len;
+			stats->rx_bytes += len;
 
 			/* Allocate a new skb for receiving. */
 			new_skb = netdev_alloc_skb(NULL, comm->rx_desc_buff_size);
-- 
2.35.1

