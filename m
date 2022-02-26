Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6110B4C54B4
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 09:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiBZIvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 03:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbiBZIvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 03:51:36 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF0912F414;
        Sat, 26 Feb 2022 00:51:02 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21Q4n0pQ008190;
        Sat, 26 Feb 2022 08:50:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/Qgbgk7RygSEFtZ9CbmgcKa+pLOuDiBUYoKyAp/54ok=;
 b=yQggVUP7ltBbyl+3ZC3hniYjE4OCJ7OBDckMbr+xBdhoA71WsrLtYbc1T3aUuitxCavF
 BddcbspNMtyCOpmxN6OEDm/fb/60bZ1U+uMgteV1xAyjPtvfyU3ngexLDHuOjUN7MRfX
 ZA7sxxe9kbw19I9LED+XDpD5fSkspacMpIikMoPqUaQTVW3tXSRg2T+eWQbA9TEmKCyc
 Sp5ma11ngQBmQnrEzvTuay8sB0aBlcuxlG1ttAHWzkkpt93ElN2zGaTGVQS4hreyxRuk
 zFWr3ENsOhV0kZSt265AclpcR1IjE2NaiuuqwHgMoY4vNOwNWb5VDUAECrsYzZXAkw9c CQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efb02gdu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 08:50:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21Q8kO7s005020;
        Sat, 26 Feb 2022 08:50:00 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3030.oracle.com with ESMTP id 3ef9askqdw-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 08:49:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4OpiIRyYt1J3YB3tnAKATVJJ2Rhs94R8HpkO7bkRNXNq9+3LYVZ2IWt2ZPsmA3trGCUtlKuXldiaYBJnRTQW8HuubkJhRDpTQuM6Bwi0jlDHmx0bmNqTowjrAbdZjm/G0//XlxLA3Wd61vYa3T/3rtSy2JCiV9hnRJPEFyqZR3SIqUwgjG/lCKX3ngDIkl6YbSg3C96JUmY+nHmetkjEfDSii226Zv6m3QZSVQKCCc/Bywb3u4bRzka247IDKPdxbtxk0kxcLsBeQbA+rFsaZkRQanlQE6LjJe5HS98S2NGgjrQrQrHdI1T4Afc7J9+0TjM8DwnWyovu99nKa1m3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Qgbgk7RygSEFtZ9CbmgcKa+pLOuDiBUYoKyAp/54ok=;
 b=HyR6BLWprrjvrX0DijzBwP8keByMMTFZK4gvkUbheo9id2QJHJylwFttVVoC18ZIWFUOXXf2eh8PYQJh0bLFudN/wkIf+oT6nFyQMUWqLDwxMka1P5Co0k3sCd2nLkLogT8to6r9z5c33Fu3Ao53fsXxTfRTs4QJ2aKR3hoIEIHUvj6fnvHMetEUegLPYZld1WfxxRs4gPNOs280Wz+Qnvdm9fKpU5wsBl+jQ1ZeLwETrtjTuM+7wQtOem31p71+TL2tJP1SaljR1H9BSXiFExdefqv+qQ72gNubbDUw4Hf9qYk+WBGLs0Ob3zAiPkCAV/9zAw7weNTQUScut3hv6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Qgbgk7RygSEFtZ9CbmgcKa+pLOuDiBUYoKyAp/54ok=;
 b=RqqNl6AcoSRCau5b4TCEJyoYOeQKcRSyWK4SXg7AaKAxcPsMFE8eXZn38nRzHFKw21WVjrbuSS39uhn8aaIhpQEtkObl695ZwgLV6xhzNfb8Y+NzQbz1XM76Wd8IQAtI7ibSoJKyuiOfp6yWuFTBZve98MjzakfXpKqkX4nyjNM=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CY4PR10MB1768.namprd10.prod.outlook.com (2603:10b6:910:c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Sat, 26 Feb
 2022 08:49:56 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5017.025; Sat, 26 Feb 2022
 08:49:55 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH net-next v4 3/4] net: tun: split run_ebpf_filter() and pskb_trim() into different "if statement"
Date:   Sat, 26 Feb 2022 00:49:28 -0800
Message-Id: <20220226084929.6417-4-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220226084929.6417-1-dongli.zhang@oracle.com>
References: <20220226084929.6417-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0196.namprd05.prod.outlook.com
 (2603:10b6:a03:330::21) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a79b842a-38d8-4f7f-0034-08d9f904f5ff
X-MS-TrafficTypeDiagnostic: CY4PR10MB1768:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1768731F3CDD011DD7AD751CF03F9@CY4PR10MB1768.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5uuOq1b9yUKxhN4Z4Eo1M3cKyltOLNXxjQZ6g+2zWrV8voxD5MM/vHDHIK5Gx+Vvx3p2wE9BM8Of07mmAwjrOJ8mwiBtmaBMpHydHqYrRDRVteno4sA2/DghAUOhaoX0Fqy4yPXz3pdDwGDUEsljxnTu4YTXMXn+O2kEavYQ3PoDwfkT8RrXXA4ajhCqwYzPN4sEnhWJaSxOvk6GafeWHMIu4Cel/HqBroMTO5kZ3U7d15WYyhXaG5AAL42Wy9wzfE2R++IzEaEV5chaWIGsYTAZgfcy2D0OVQmbGbfhAdaeQFJE6bl6v+Le0Bkp0ZRU0Wklz7XztuETTYcwNvTiVR9sScT3Bnmc648HwppV4tojiaM4x1l7BNoRYEBHWhGUOtTytW3rwthFLKEiJFtWv4e7RL9H2273zJ16YdQD8BmIGVjxsFGudPS1I71VjXwYEpYl+bQUy+yJdeCAh8TpLeTqUXBZRw9Ox4OhoZR+POpy+ReKY+Xc2vZ+DA/U8Q7LJfSt2D6MCSZ1D/nwH0tjiFs7lALVbg6dsJ65zrK8FUucTzQHtpCX8XzwZNpcwugilyXruMsur4bB9t44NV8DeGL9fmiEEvdoYBNlRlxWbm9tw1JOE04NE4ebw1NSFI7i0raJb+JYjn5vGZ/Q5GSCnQpJmC4BOdhY1I9vYvkX6xXIxeBT2s/l/M/13KbJd7I/zK3gO2jsOs1Yk0W0C37UcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52116002)(316002)(6512007)(6666004)(6506007)(186003)(5660300002)(86362001)(8936002)(44832011)(26005)(7416002)(4744005)(1076003)(2616005)(2906002)(8676002)(66476007)(66556008)(83380400001)(66946007)(38350700002)(38100700002)(4326008)(6486002)(508600001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vec/eKXrOt3ZOMSxASoYDDuYOKqGM62LNlk6U1cJKCa8VPphljUxhd/eNYxn?=
 =?us-ascii?Q?Rky47AsD/lz6lvBC2AT3sna9SJ9KR1SADBE8bUa8GETLMcoLXVXzuemEoeTZ?=
 =?us-ascii?Q?2dUqcLechyxIsUq/yqBZ8FhTp5/qNwkHCkdnc/OFqfUdpyaOtdpXV/nEflfm?=
 =?us-ascii?Q?FZ9uyhvSihdil2uEEC7nYmOoKOs1p+9bjq+993xBn8w6/KJN10vDTsHLaJk0?=
 =?us-ascii?Q?EtMQx/ce+OKUKL9+8vASUL/kc1YZ5yLMHOhGQ8m5eKAzh5FCNvx64TNo/wlc?=
 =?us-ascii?Q?jrm6WnSjIfpReilLISIpRZ6YJmV7j+sRzgDvbQLTZ7tvlaxEHk6r+e+w6Kt2?=
 =?us-ascii?Q?9ecF1k+dZXOV6LUkz0YXnjqbiZciohvlR1mEZyCCcoM+2UT/mAcbOLUprdK0?=
 =?us-ascii?Q?ftEshc/KvptTPFl09W94rfOyK+sM0TKX6gQHqZoTlfcDh/tVNr5Amu7osIT3?=
 =?us-ascii?Q?AelNXaoAJ5lF5vbeFeaaVYQTccYhqoS/TDWtcqhZwqmDAQ5yxUAGJPWbdWJO?=
 =?us-ascii?Q?fXUMtNEg/p1y/cMt0PxVwuJz0tpUkKssi6hFpFBi3+FPdkqo9EQ2gQxkebww?=
 =?us-ascii?Q?3mLgllfpIIk8GAKlVr8CJjmq+CmodKLwu1tO0O5kyMmzaZyEGSYPHj/Ms4mf?=
 =?us-ascii?Q?Ugt2mkCZJ2JcvoFa1kXle1KeKfJZKL9vzFkRzWmwWHzW96PK4GKHhbMT7Eet?=
 =?us-ascii?Q?Qp/6ebtYzy+fWqvbrNbrjl8Edbq4eKPQRyeFJHYlcVzk44FvZM7qVwgTSH4p?=
 =?us-ascii?Q?t8Qwe2nRD1Shjdt8oJtMIpdHw39vMchSjBMGdlq7OcNNt8aTCx+oMTOv0gXE?=
 =?us-ascii?Q?nxXsnmiS0gNqlkEYFEQgvtFwYEHbNLcne3iYoxG2/FIevA+uBZCOhuQFNhKo?=
 =?us-ascii?Q?/2FnwAysR67IrdKkaeoth1A13CBWBVEisSJaZkD/P2+rJZUTANy5cQPNrJls?=
 =?us-ascii?Q?pOor5r2PvqFWmbiPczHfiPn944jyZoF7hyGra1l/+k2idYhrHTJs8UUjz9ut?=
 =?us-ascii?Q?fJN9N2b78x3B8Dr+yLSiPTK2nCiB0NhOAvUucaFGXyQkW8AMdmchVG+W0zBU?=
 =?us-ascii?Q?/B2J3fY8Z3k/D/sAEhz79BEFGwyX2tmKsARwH4WkNqd5tQZd3uMRLWAqg8aC?=
 =?us-ascii?Q?Pcyz0ZLNAtZHa3P1ji+ChKjHG9skX7VB149cAa3hAdr4cNT/bMgxXpPDwkcD?=
 =?us-ascii?Q?K+73jPDm7q7tV/rMdMTligWcxM0EIoBNAqeep1+JR1LT+3nWRq3jm0/CItB6?=
 =?us-ascii?Q?a69FrpJ44Nw1artODEM/DRLHlhxQpcoEphogXqCAeWOgN/frYzPH/MlWLy/N?=
 =?us-ascii?Q?oZ8hw4XdF/HAhCtKeAytYWj0OEblH6q7VMM4GQria0k7VAmsq4HybkTAjt3c?=
 =?us-ascii?Q?QV7QFlbbqt7V+86ZVSIPs/34PevH8HfJgpwJWVe8G1D0kbCpK1wfL3/MyI29?=
 =?us-ascii?Q?SrxoQ+FUu3J4uHnHt83a+jQ4DElBtGt3N/OQ0j5Ylh5zfTCXNklLnOXaeqvs?=
 =?us-ascii?Q?IHaBTJMl+bIdiEYd8cYdudw0nHdNlWJ1g2Lg9aYqFoUG8gYZ0clw162q+HJO?=
 =?us-ascii?Q?Ing63NO3WaK5cTaUUDi5VPYCrq7Z9GoEwqVCkM4rH8r0H2T8MZgq+iAUGLvu?=
 =?us-ascii?Q?pnc2Ju71TwE3QnxXHd8qVtM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a79b842a-38d8-4f7f-0034-08d9f904f5ff
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2022 08:49:55.3825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5csJDBsqmOjHo/5nmZQAPK2yebFI8Nh7LjpPKs+cQqmV2kCyUxiFx4iCEjd48l52xdsKUn2th0a+BtJbzpTC8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1768
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10269 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202260060
X-Proofpoint-GUID: wuXO2kE-YC48DFrPHzJHcW-SrSLipK2Y
X-Proofpoint-ORIG-GUID: wuXO2kE-YC48DFrPHzJHcW-SrSLipK2Y
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
index fed85447701a..aa27268edc5f 100644
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

