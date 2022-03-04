Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328304CD6E2
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 15:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240032AbiCDO5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 09:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239994AbiCDO5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 09:57:14 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11DF1BD9B0;
        Fri,  4 Mar 2022 06:56:26 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 224EFO2h020774;
        Fri, 4 Mar 2022 14:55:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=dQYmymtcbQDv4rr4vMNkQ0DaSEZx37fpH01/Rb0H9zs=;
 b=ruhzj7b+Pb9kYgpWJzV2Tw7Sn1W24J/ejPmojCiLX6oRjU4+XrSDen694dxXhgLPQEfu
 68tDGzkgi4smGd2XGKfcBT0sFMW3Bu9dG1MyivvpzNSqkvFeWwVbnTKKMxIXp2e3f0uv
 OtCTET8QTwNLbkFCGaIOgomg41HScuyuVHW+jpPAFOWMpGdcLbos5VCgvwzzxLsfnuHY
 gnz/8wbytYsBi6WOinAfHXjKnofif5/GqPRqpUh8PPd+N424p4gEzn58+25Le7JrpBeX
 XHD13w+ZtGDwwkRsPga15CojJGjvyL507GtbGbcpQF8I7gTHHdkM96f+nYiEXgsLTSWX 6w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hw1ymg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 14:55:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 224EZUGF130215;
        Fri, 4 Mar 2022 14:55:20 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by userp3020.oracle.com with ESMTP id 3ek4jh0831-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 14:55:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBDfJkL9lnkMZ4kRNTEjQZCCUAOt4D3uDdZRM1PDqn/17qrGeg0s7b+JXKtbpfO2pH1Q+fI3yuJIms8vI1xGwkW6x5pbZmk9RKpAXgc7DJXYQaUGHAKwIGNysnz6lhoc3XW3oUdGrokzrIrFmFsz+pbZM7ZqIfSyv0ukyrQbIETkWhmnuNgwZ+5VFwKANbfBeSvQWWXFPVtUvIkiQu66zqpsxdM6gQY/zYisw7825dGRAdVxMnaZQFTykTv2kfqmct1qOu7zaYalKX29cXxfI3EWWjKAbO2G8bfwfrrpbW3IFrH8s3RRMIgQyBXOf6EYO2P8GJ7xZTe7DkdG9RHEEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dQYmymtcbQDv4rr4vMNkQ0DaSEZx37fpH01/Rb0H9zs=;
 b=bdg7TNdc7a6eExAORK5ZMkFnvOTqiKDx3BUt/B0gnMjpvTDAHIM4R55/IYBhjo5rRhAAupeC8iCqUKXzIvdN/OCjXY3sN1fabnzk5SOf2tYZgSfBNyQQaQ/fzYqZldF7toiaM7ES/6RYmloSoppSHfYrO0czuBcaYbZ9Vmy0HrgV7O1QQSNjIB3zU+/8aK20zqbwxglIbq5PwKp/W6ktri1caXgTXFdtej0NkFjI5+JwbF+uMZ2YWzgAudUQ3BP+f3latWPu1KnRXe4DR6qSAPV1kt5PkmTz0ohzTNSGTDRoD75Cpt2oxNcVXug+Ejr+xLcLkgdczvwHAWY8PJIu0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dQYmymtcbQDv4rr4vMNkQ0DaSEZx37fpH01/Rb0H9zs=;
 b=vNgAVsfxjLM9etJBctOEYmKkLYWPGbjbM3iiqwo6n+fDi7OZr7G0GseFWaqCC2TJnKhOU2p84tVT3cCJsZkqPOsNsF1adfNhhyZSoVQ2NKHI1SGGdqpbCxQF+7k0PVag8ElfohljmXYYE3jL+h2vplxyAdeQ7RIPyTuQzlieT8c=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DM6PR10MB3977.namprd10.prod.outlook.com (2603:10b6:5:1d0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 4 Mar
 2022 14:55:17 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 14:55:17 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH net-next v6 2/3] net: tun: split run_ebpf_filter() and pskb_trim() into different "if statement"
Date:   Fri,  4 Mar 2022 06:55:06 -0800
Message-Id: <20220304145507.1883-3-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220304145507.1883-1-dongli.zhang@oracle.com>
References: <20220304145507.1883-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0034.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::47) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99d28df1-a729-4c05-e157-08d9fdeefea6
X-MS-TrafficTypeDiagnostic: DM6PR10MB3977:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB39773A762167287E1D8933B3F0059@DM6PR10MB3977.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XYFj/b/A6k/NjIxmo3hv4B1FNNo3xOhIvBwYu92seXdrSLzrIlMQyKBPtXU2SfcSY3bbkXA0QnAybl/rM5dhOJLpL74XQpz49jLw5V7R7cu/QhQavbXh6KeE/xyo+V/ir7sMEblnJocymxBJG6l1sm2CGomwCjKZZBphnwXrFIcmXgoTcqQLc4GwBPb1newZ4Nu/5jv2mQC2iTnl/wx3dFUGmLdbQurUU0ayvzOJak7J/TWXSfXgrVoX7YE6OW2tY0NXGewES0RsNL7/7dnTMewxPGKZusI/mecCGHwMl+iFVnbyElkleVtij9Lhjr9oC03+1VWBgLwmQOXPcdUXxkSWJS4aKowiTfykLQFsc8odkQK0y4LFWU6PJkC6yhgfdSAZJE+dapVdRF585RBAof5XpNUmkXYdjssdOxzpCjeY4XLwhkS+VLIpjhgE0DRRq1JiKVYRcLWZ/zZeCLvrm5vh2vcR4blNyZwEsrcxs8D3MHJAeHidnNZpVw3wnOIQ7sjSQNXnxyeQm5t4nBR7OplZq9O2Q6inxR/2EdJ5I4dIu2cVakpSFHE+rluhREOKzrFXOPNmUU5C5MJjcJLrJP0uJ7PMhzLHoMQ9mUwDPY2qjPUIOMDCa5aE46YvSUuUHCZxL9J0zWiAz//71WjLMSKJOWfnHItD9oJp/zKN+tnU0fJcGdt7pDkW63jV2/Ci4Vo+sBj8KJh24mft+1tn5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6486002)(316002)(86362001)(38100700002)(52116002)(1076003)(2616005)(6666004)(38350700002)(6512007)(6506007)(83380400001)(66556008)(66476007)(4744005)(44832011)(66946007)(7416002)(4326008)(2906002)(36756003)(8936002)(5660300002)(8676002)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jVIvFbV36/m6GHGKPjd/Nfi3XPpKhroVk1Li417No3escY53Uzu/FHLdjsDv?=
 =?us-ascii?Q?vLEFi2jwz/cP/uVyNL6D3giD6XMacTlynLVfzMZOOd46aw6Ub5i1hsvKxi5Z?=
 =?us-ascii?Q?Niejh1jdb9vZ6s6gh476mbXzJMuB4PN9Egyl9x62SwWxybP+OBSNCo99M/B5?=
 =?us-ascii?Q?BhzLGg+kPqvj/vs9GHt421EP6oNOmrPTrGkIN4nixg9MPOvPkV+V0z96Nl+g?=
 =?us-ascii?Q?izPcqzisO82EV+6ogDawur7qWf8py9FphUCOze5+fFGzU6f185Q6IEJpFlzE?=
 =?us-ascii?Q?cGs+A7GsOd6+uvRMHzohcdJ1NEws5bo0li6lY6OzOyn2olrCnEidmFy+3EqS?=
 =?us-ascii?Q?o4D/vT3SJtK68Nhlkqk1SKJ6RapZgxAtIN2SwcU7/ewzR4b9c7gueyEo8pFg?=
 =?us-ascii?Q?5sMWPCmoi9GbcgnpAFv5WRLuXZkPwkGIpObi2dJBVxVq6aDRPDWHiH5ye/zV?=
 =?us-ascii?Q?p60yWWE30bGr4TU3t7Ff7E9iR+5PeHbHKmXCVVEivSVNl+EN4bfSKQq6SD7k?=
 =?us-ascii?Q?XXxQ31ORgt0C+rWANQQInOSCFlg//GZG0FTwLTqeF4Zz6KXDu8IaBHeZirGL?=
 =?us-ascii?Q?6bujkP5JEXUU7j9ujmos6QFqCZq+3qxWXh8rxpJckjdOWLZ1lTUCkhRkNQ2a?=
 =?us-ascii?Q?dPej+gWczk7PaCMHQepP8HvLwV85dAVvnVnDieD5hzKw51TgXG4oq02PTWRj?=
 =?us-ascii?Q?8EmsPVaXF/mMYD/h0vnrKUSvkcc5t1U3oph3OzhIrQsCKj4G1118HdR8pQ+7?=
 =?us-ascii?Q?6pJ/RGod1MUCSF5POd07Jto7yV4wGKZofhNlZ3CcfOLsiXupRV4513sXgSK6?=
 =?us-ascii?Q?CjAhVl4awp7Cp/hNQfaFUgsAbRZbjCLgkggfBc8RMgMD6Qtp+4UVV6ASxRd7?=
 =?us-ascii?Q?SEhgQbuDDVkHy9OMRetpNIQiRxFRFvP4TnE3pMG6Ep+veNED07oFd8sDnkQj?=
 =?us-ascii?Q?7FyFN8JdGwydTn7ZKBbcYKlnRBbMQrv6mI0S9pxM8+0bZKDHDaAoGHfTl+YP?=
 =?us-ascii?Q?FOVavlFJpVtHOAzK5+QDJFic6iO27oTSlyjdOJfvduvwZVjFPH2N2udrWzQC?=
 =?us-ascii?Q?dmZ5XzcWrd4B5cSJL6M9BFeNwRiiEsrsJQu5/4mdZHgu8AxqlDaUacHnY2Cd?=
 =?us-ascii?Q?DG6jUpK4IaKAj01iLvlS9BsteoWUNfgSyeUl6bL2djERuHRHw6iVeZmKP4lZ?=
 =?us-ascii?Q?8rhEQ1HNRRgd243BPj1BclnjLkA/dvz/dwxDVUmZGQWLT9budjyvvRttuRFx?=
 =?us-ascii?Q?eCj/GscL8Zm/AKluVTq0lc+5UTU3O2TSfhvr17UFiqE3JwwpnsmFCbcXxr5Z?=
 =?us-ascii?Q?Uv1p/nAz0VzV62CkmzrfdgkmVpsdL6Epd18Ywbxt8a97yrNjLPPp9hOd1RAZ?=
 =?us-ascii?Q?/kSbS6oEU+b2RxrFduIEd8ybA8a5czJJGb307HsYLxszoqmx5yMBy3rf7HCY?=
 =?us-ascii?Q?2E9935DP+fEgTIacz45DJ/lwJH0xi1CGm46TsSuoP7BI1JAXSBdQWY46yRYO?=
 =?us-ascii?Q?5ZCP7/GteS67lOOZss/A9hH1ozyGRg46oXtRpBHy1/a65cEO0alxmIFNkw/D?=
 =?us-ascii?Q?Y7JWlDdEqqK5vUT8nFEf56QdD6Esb3nOBpJ8Asgmd4ouCs060PTiWfA5DEnf?=
 =?us-ascii?Q?99oZNlxsr7vMXhk1stonDOM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99d28df1-a729-4c05-e157-08d9fdeefea6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 14:55:16.7747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1qqo1gRsbwqbdi0z2Oyl12Ef/e862v1HGPouaZqCX5ehl25GmNPmPeA9UKIDKyNO0BFtkYjyb+GENPT9sW/37w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3977
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10276 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040080
X-Proofpoint-ORIG-GUID: HHdY0y4WrUN45xT1Y8-Fdnqh0jORzxUC
X-Proofpoint-GUID: HHdY0y4WrUN45xT1Y8-Fdnqh0jORzxUC
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 drivers/net/tun.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 2a0d8a5d7aec..6e06c846fe82 100644
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
2.17.1

