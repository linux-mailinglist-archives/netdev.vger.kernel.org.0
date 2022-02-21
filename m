Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25934BD596
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 06:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344589AbiBUFiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 00:38:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244147AbiBUFiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 00:38:23 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E92540A2E;
        Sun, 20 Feb 2022 21:38:01 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21L5403Q023560;
        Mon, 21 Feb 2022 05:35:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=N1cLy4kzTKIJrAOO0ot5ovD1x2Zpu3q24Lnj5DxmZG8=;
 b=DrbezGE1jrsFJVwwxYv2IUzCY1a2hvZKfJU/9HDOKN+cQ3MU1RHGhnYSq7uowClu/3ll
 GY9lr0YIcmjjzQjR0MOdndtFIVyb+QHLzeqhaL5G1miM8yncCcC6AHvUz+pF0Dhs0i8k
 5qvCAqVC/D5Jh4MQLVywq0earzcGM51E6xe/7Fj2MP7FaPK8WcrJm73WvWeqOSH4PajO
 5v3pdI7sQWNIH6duXMyYmXjANNhFxrsrht2DNk83IDstpmt8Op1PRNWAuCwjrixH7b+B
 fASeNRzk3HDILLQzAuvG47uGYlOOr7tpleThPI2aeA0jzXdXmNK2E50A484FNHThJlhC oA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eaqb3b4k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 05:35:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21L5UkVa019493;
        Mon, 21 Feb 2022 05:35:18 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by aserp3030.oracle.com with ESMTP id 3eapke8nxk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 05:35:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sbw/mKQaMXst1Ruza291Z0iCrItSfVMJFHA5tYvBPDCKYNW+K+uIi0C3hE2Fq20uE1aZSd/5N5hpSwx2QPacQ3xJtyARKJRQNQz7s3zbzlxF8osz4LyvLePGhTdTp/mBVTn+yFDvOPmGSAjDX/kJfWjHemrHaG0dxUgB27xqSD3nf5gIpFPnmvahgy9BoUebF9JEtnQ3f5DdGQ20cFdMWitcqg96kBxTAmYx0lD0CPiTfnI1DkhRt+e1kvJhVu0/vFAidieNrw68J7L6zegYiyn8w3JRn+omISR3tb4IP1IqFIPRDEbehj5O+lFSwtrdBW1S/UtGjXXZ1QzM03TWAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N1cLy4kzTKIJrAOO0ot5ovD1x2Zpu3q24Lnj5DxmZG8=;
 b=A5sSBL/hY0Qu7ZZs7FyWNh60wmtzzYpIhcwLjUQI0uNaGmIgsF1/YiTIJd1I9v4SZNeYGoj2cnOzX+DP8/YWJOAmrYt/jALbIEqE/u8el2AbLO85wBMHc2lkvoaPYosEbi1/QRZ3wyPEyX/WAwjBWgUnxQbREY/0mplY97SE7A7RhspAk7haIg2Y2BMqyA+dKDfQ/nIqHu3qBunntjHLgriArQpeXl1oHlbwkub/WhTVVFKgtdp8i7uMwrVY9Fr8Dx97wGWbpXR07ja0Uj0Hz06Pwr71VIHdZG7Fz+9m3muz0MgOJDYhOIrGA4Z/yNYbIl2TCVz+OPGWZBohIOCdLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1cLy4kzTKIJrAOO0ot5ovD1x2Zpu3q24Lnj5DxmZG8=;
 b=fPODCU923J2cnSiO9pGvhDI/b9VEFqpFYE7dWkj0bCNJBYSkVwAVB+mQGWMebaMwyTqeIp4oeX0963Fm8KupzJNFxBCp4xQNtyORbMhpX8eEOgkXspYOagohSJ+FYWw+3fkF6WHlL1ji6VH3ohPzA0BF3dWVGJUxV3xvXwTILm8=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by MWHPR10MB1533.namprd10.prod.outlook.com (2603:10b6:300:26::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Mon, 21 Feb
 2022 05:35:16 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 05:35:16 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH net-next v3 3/4] net: tun: split run_ebpf_filter() and pskb_trim() into different "if statement"
Date:   Sun, 20 Feb 2022 21:34:39 -0800
Message-Id: <20220221053440.7320-4-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220221053440.7320-1-dongli.zhang@oracle.com>
References: <20220221053440.7320-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SA1P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::21) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e6bbdc2-9474-44b2-1b6f-08d9f4fbf0a7
X-MS-TrafficTypeDiagnostic: MWHPR10MB1533:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB15336AAD7BE8391BEBFBFD93F03A9@MWHPR10MB1533.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ll9iJE6LSXx5twcoYsuzSwl1MI8vmsWgDyEPiWZ4HXa4EwaHLTq3zmQpz3qUCbPHBrN/nGWS3KwvRIiWmAF9nDYLpw22v2kNx98Ef21u+b/p0oOU6AoVV/SA7GQ8Rm+wf/OXeAKJRv63oNzTT4UB47gR1UJsS5mfjYvWFnrKbcca9vvTkLqEo1WloXrL3jKS37eyJZLNJRw1wpKNP61WCPvXtToEfQQgeIOzVhDBrX6XdvA/OvA5AmfQdL1HWRG/ZKHoYAfSkZtCTg2hAPw8TvZo93skmytgjn3OGTcziy1DkDFVNc7aKfV+RqRoeogJbS+ljC4hvj0E4YmjBFvakkEOvN2cbpEP9/BbiJjD4q+LLIKsXj7XHtYmE5gAeHFUYxAsLQrYEY4irDnj1mgvw1+qIwi+icXzMRPL28ErGmEmi+O6X5E967xLR2YBszrMbNizWClSPukJF3Sx2tV4dN4s1uonRxZh6Fdkct6eSWOIT1Tj1b0SuhMa3j+gaStzsBmRhDt2AYynzoxOB8AB/18D6AhGNEhL++K/4Cvqxyaml2740nV0Cb7Dj5msd511H8UmIAAOwRCKRcuMkPjfFb3DCbUVvMEqbidN0VCfhH/hC5eJG/6sWVc95UG0gnCN5/ZNxQUtWnRM0fpKzUYpPxU/AHPnjfmE/RyxxWuAxcR/bseQOajTOeHWJeAxnjt3G6of13nE8TXqcflrOxgQfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(38100700002)(38350700002)(83380400001)(4744005)(36756003)(7416002)(44832011)(5660300002)(2906002)(8936002)(2616005)(8676002)(6486002)(6506007)(26005)(52116002)(186003)(66946007)(66556008)(6512007)(1076003)(66476007)(6666004)(508600001)(316002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D8gArPugwwYqdubGUIoKYLMOCZGXTrgeTO2Z305lz6vHlNqhkQfwAL2AoGpH?=
 =?us-ascii?Q?ahrUROXB4VZh10quymuvXQJrvZwRX2OVeNaodNA4F8Cq4AdCi/HiQrlbI57g?=
 =?us-ascii?Q?sUl4HaM2r0ggHSLWeZ1lLXb/t6mx1ILX/LzuL+fCJ9cYtMpm5Nj4l2F8czhS?=
 =?us-ascii?Q?74JpRvdcT8sLChrUaUl2QLeJAdt4hRwsgAA7gGtZGdDIIyubYhUfhPBmFFtu?=
 =?us-ascii?Q?/zEbiU3kA3Gg9F9yePGDD4buphoGsSJJrjfZiAIy1Fz/J/cvjvtz7GK/gaeB?=
 =?us-ascii?Q?9BMdFRzNSqKDoqKpBEwHx8Owd4AkwYOxjj+u0ZNhdmrP+0p20yWfgDrNQVv5?=
 =?us-ascii?Q?uVjrNEg9rtd4Ix1booIoYJnGMbEIgyvthy4GGmIoxTVVWJ34VwP6jsYR6c/v?=
 =?us-ascii?Q?3nY8eQoAMlHgrm3243hU0+PeBURyq8BM55LpgIlccOgnLtuzPSsAY5vyD/SY?=
 =?us-ascii?Q?prB9wArww2S8Zn2IVHs9N6wUwN49k7Osu4ui2DxWRLN+WQe6tIrRqscHLKPL?=
 =?us-ascii?Q?JnkbD/v2EUi6srw0rCmLNu6jMxcZUySkJNLIAjMFDzg9yZmHUNvdAqxdn+SU?=
 =?us-ascii?Q?EVPoMXuNrh6WhU5yBpWlKjIcFVaI1f8wIhLNzeomh+Ox+vEqHsyy5csKh7/r?=
 =?us-ascii?Q?HBbpOe8PmLmeUdIfBq56Q9Fqe/c+NvU+yB1AkP6thG/m7afi0tt+Mpbgllki?=
 =?us-ascii?Q?qHoVEGSHf9G7zJD23U7RgCctJBTKrq1T1I4tt77WdzaywKowAXBwkclcLBsK?=
 =?us-ascii?Q?9WkiT00UyLy07bZNkzljPqhyOSoJa6j8cTVO+dLT9QEbU3S+G7b5Q0BoSuIW?=
 =?us-ascii?Q?h/v7OWXp69QCOnojxdAosDNm8a9W3MovEzYBDHvoxywCE4SoCYmL6T9MAnsM?=
 =?us-ascii?Q?sNc1YloTcjjrSQhXHOv2+Ofw2DvVoPg6TONCWoJbE4Eyz2erGqxbW6rgOhGm?=
 =?us-ascii?Q?wsacdYF4PIkdzO+kHcHRlUK8LDe8O4Z00dlDc19bmwp1PO+v1NZsrPu92s66?=
 =?us-ascii?Q?/BGyrRXPXOzvstkJng/nMXmaXCZdQgm9plNZ894lf/8EUn7CzQ90wq3OntBt?=
 =?us-ascii?Q?5vQ1cMV2DqeO53IdxxyY5IaryI/RXxnBgZPxCwsZLhrvLAPA5fZlQ5yffqQ6?=
 =?us-ascii?Q?BJ9iyquhHBT+sVt4lHW/z3fvU0oFRZWc+TS6NSPZ9DLAhrSh8A8OT17ClQ1y?=
 =?us-ascii?Q?kex4HlD7JhM61mprjQys1BvZYS1UZyPOpQOYDY1IJZlGwPHmJ9fUUegVEAGG?=
 =?us-ascii?Q?Q+Fc0ox/0pCN9QdbGD7kvjocqbEFqZtmVfIHFXRMctw2KHiYzK331PAyYwLp?=
 =?us-ascii?Q?oaDt37ikZ2amOzGwPrLF59cD4whRK8xd4v1JD9LcYBmtmVx8NSe4laJCNhRf?=
 =?us-ascii?Q?WRW57sRKzkom5a5b4j9XliGqbjravrUhLGk8IKODa2Qymcw5HY+IjqVdn05U?=
 =?us-ascii?Q?SbthKX4xAgfzYy6oZ3prrGfq7wP7cIh2bQsupkF4awBkmMZopK7iUg4den/9?=
 =?us-ascii?Q?wvTWKMd1PjrSsdT+1/Op4Mfr2sypdmbsfgE4sy0T4qHmfvAosWDEiehLzSFF?=
 =?us-ascii?Q?wkibwhVuBjYQ1WT1I8MST4RKGlVzAEVUukhgyhJ3P1lur08IFSW7/3q66o1q?=
 =?us-ascii?Q?OfHEo7FDpqRNQ7T14OvFC+g=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e6bbdc2-9474-44b2-1b6f-08d9f4fbf0a7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 05:35:16.3275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aXecv/aqjkO4C8+RbMVtyNgwFj4GejkOuMNiSLeT8bn8J+wb7jP09gfDsz52NkjOTgrfMPuN4m1rRN2ieEBEqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1533
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10264 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202210034
X-Proofpoint-ORIG-GUID: fUPzTuBSxCMZQn7KL0Vy8ba_LHgC2vYB
X-Proofpoint-GUID: fUPzTuBSxCMZQn7KL0Vy8ba_LHgC2vYB
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional change.

Just to split the if statement into different conditions to use
kfree_skb_reason() to trace the reason later.

Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/net/tun.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index fed8544..aa27268 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1086,7 +1086,10 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto drop;
 
 	len = run_ebpf_filter(tun, skb, len);
-	if (len == 0 || pskb_trim(skb, len))
+	if (len == 0)
+		goto drop;
+
+	if (pskb_trim(skb, len))
 		goto drop;
 
 	if (unlikely(skb_orphan_frags_rx(skb, GFP_ATOMIC)))
-- 
1.8.3.1

