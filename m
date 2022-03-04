Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9803D4CCDE1
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 07:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238444AbiCDGfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 01:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbiCDGfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 01:35:14 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104C1182BEC;
        Thu,  3 Mar 2022 22:34:28 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2240VeIJ017370;
        Fri, 4 Mar 2022 06:33:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=dQYmymtcbQDv4rr4vMNkQ0DaSEZx37fpH01/Rb0H9zs=;
 b=XjRhTTseATKOXgk7TcGolbFODHCsW8g9uVstS5Hc5bFg4PGvIv5CvN0cmprKP184dve8
 YVnr2WOPt/o+uA81zuYlB2tOqM6I5GHK6mmo2xOP+hb/2H5fi3cMhlj417QZ1im/rCzs
 nqF7QqJlW/Wm7pue6DE8kYioyAdAKiO+FCsv7tT2m+yEuVdW+t8HEm9xu3jTpAaR0iQy
 a1iwVO28G/oQEzn6vxEzBLfUBwxnao17cLWXHS5c8NI8rwPAkUaHDeSWP2hH7cLXUEer
 H17TYVMUWib2L5FtbY5jqelAqzkP0yvDvMxaTstGnQwwEXbL+appaKwiB8P3mOB3dvSu kA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hvgxaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 06:33:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2246VUfO172737;
        Fri, 4 Mar 2022 06:33:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by userp3020.oracle.com with ESMTP id 3ek4jgbr3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 06:33:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AIKnMFceVPDLI0IqsI37njyPKLBQmOqYv2jGHtYvZfXo7GGMxleJl2qAKtwqEBi0ZVkK9jLUGUDdpMhNYsuXwQwcP4VtbJTCrtAtzjYPo5pq9f47zM4XHpgfDlfEuRlT9SMQqia5vxFVqk9VS6oQBTxfKJ1IU9CM1yPwVcFANZ4sYaVWEh6jA/3rgCOkYI7XzvQ8Y/HEymby1ybbngmJVpS4ZaN691xsvyTtlejyDtnnbTmG9gBbU6quYKZrVRXRQGIHI0EqyvQU76eCrjHbr2W4FjyztBEQOtyaFPUpexE+8iMP6T8rTbwCELVdJ5sUu7KlJdP3VzzWUN2/4oB8LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dQYmymtcbQDv4rr4vMNkQ0DaSEZx37fpH01/Rb0H9zs=;
 b=IOjDLHmccjY4fDhc3MihfI0tkaL5iJVyrf4Glbd/K9R33+74sWFpvrukAe04ZsBWXp1sYb4Lz/SNhbMKAmK1jHj3GyIQ6wXGa10eLWgvdehDXQ1cqrmaK4DZIxv/arxvINnWDHj7XKAy61PwQox2SlN2nc9+Z1RA56bY0IlilmkSSHtzdq8P8HUm72tk29/zKQW8A9BOX3oer4aHsX5Kb9cjo4By9lf2ncixeLcjX6JtNd7PuvJGRll8g8cC46EPYMS7jJDSzUvG5In1Izr9HZvyMmHWTsT4OZCxroHH7O/zndSjGQmsK3RTThLbWuyf7HmHk2VEwbpwR4J8q9CjHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dQYmymtcbQDv4rr4vMNkQ0DaSEZx37fpH01/Rb0H9zs=;
 b=KZe4UI1Vr2lEuZdqgZ9rD/dVAXf8lMbNkzQpAKda+1TlakYRG6uXxWb4PYw0LfVk2Wayh03w0n67h6UhayzBNDM37eN6JDXY8JWvO3is4oJvl8pMCX3pCbfd33pEU7euagx1kriDQ3C5HI6JClWKLqI124GymkAl5I211lw6pKA=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SA2PR10MB4603.namprd10.prod.outlook.com (2603:10b6:806:119::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Fri, 4 Mar
 2022 06:33:24 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 06:33:24 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH net-next v5 3/4] net: tun: split run_ebpf_filter() and pskb_trim() into different "if statement"
Date:   Thu,  3 Mar 2022 22:33:06 -0800
Message-Id: <20220304063307.1388-4-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220304063307.1388-1-dongli.zhang@oracle.com>
References: <20220304063307.1388-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: DM6PR01CA0018.prod.exchangelabs.com (2603:10b6:5:296::23)
 To BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8848afcb-7c76-43e4-0ff7-08d9fda8e226
X-MS-TrafficTypeDiagnostic: SA2PR10MB4603:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB46038C903A921AABEE37D83EF0059@SA2PR10MB4603.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tGHY2FGIwBKPt0mZwussoFh+QQAY/awZ6O9K2BksrSD+RD701mQu91lvIh0i4nNrpTzSTfqMYU/q+bAb5KUv+mTEaMUkv9xIe0sNPIB7TBpFVwBR5diV6AJ4qkKd264gWyty1C+TWwpmtUW4rPCTwjFzPqbi3zEWjTJ3Le4dfqTyA6P79L/UQgbiVSW0oV6bSD29tuU//PZod9DCbocEQ+SOZ7P5M2fInEauFPZsJHgiXF0CMLOAOCDM4vwEBqj2axIridmiBiCpIy03lVDviI+eEzcKMwqZFJXlQePMVo8L3f0gXMB63n+ea1Wh784aB8KVd6RHo6lJ3hztp84TEQaeNjvw+mulc08LeQwbs0AowzPLBBl0B7BoljwuO7rO4A1+BgTCvfKQLq/BdolLQIvBpYOmVf5d6hJg08B+p6/u2a6dPIWjQOX5QShH2wXup2HUxkTmQANVpUTUaNcjdki7lrLJNA/PTa0ZWUi12GfARqllldDbgtsoFl24z8APUWx+GrQpwzw/7hCjpy9ui0ONbmboqe556peSSK0hPklYmYDS6KKyGWO/2MDGIcVG51xw70hQ5KVjI8cQuZTeDsKAxX9A/UQvOTpO739uFAKuNMdUXWxmFV04kmgg9CUM6yFmHCyV36DC4UmbdHQzfgNB4PahQtrc1pM7tuujrJDAdBI6q2NTS628ypnOaRMFx/tvCqM+/dFR4ZMcVf9RjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(8676002)(66946007)(66476007)(66556008)(1076003)(5660300002)(8936002)(7416002)(52116002)(6506007)(6512007)(508600001)(83380400001)(6486002)(86362001)(6666004)(2906002)(38350700002)(38100700002)(26005)(186003)(36756003)(4744005)(2616005)(44832011)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lnccs5Le+KPfAlSQXSun1NQufsOBcp3hrDWzSzGT3J45JTSpu0LbTu0OpuLl?=
 =?us-ascii?Q?0BLSVE1MAkMOsvl/0Ua3r3MMFO/yWco7EnbdTgwxI6KZX+iwEfOv7KN/1Jcw?=
 =?us-ascii?Q?kFm0TxhbEFasqg30wE7gBN8LkpXEYYEPSCfdSp8wwkt1pbEzfiTtj70p58Zu?=
 =?us-ascii?Q?3BOpeNaDV7LZJSx1v1AmT/6hl5g900AOBd9fHkUYRbK2qNfEa7wLn0U08PlR?=
 =?us-ascii?Q?L4SapoyM80AIiKBFXMqaajpM0Qmf3lNNP2xwvY8mqNJH91rmYZ32D7YmBhJR?=
 =?us-ascii?Q?N2zOXb+O34LK7LPiYDLJT+0P1K7c1jxC/eB/PFZlksJO/3oDo86lE4kyryte?=
 =?us-ascii?Q?qnmTDMcrMiG534IeMwGFfQGmR1WNt5ouivoNxZh/OENnU1AAo9ZwpFihTa/u?=
 =?us-ascii?Q?Q7hOoSQS4aePLp/5tGq0MmypnvV43jQR6Oip0EtZ0aeLVsmXK0WklS0k4cwg?=
 =?us-ascii?Q?1WjCvIYfue9whnlKTgvg384TLqln34332L6pLlpv2ybX2Bl5/xHXCrXFE7pk?=
 =?us-ascii?Q?no6UyqHXrQVB7E8US9OEkX4mQH7n+aHRvLBI6IkrEz4ib56nCMFtJnaNZm2V?=
 =?us-ascii?Q?YGScZZL4Z6rKkp1UcMEw/ItzU/JbhtfsAx9elT5usaC5ZjOfm9lJMfqf0lwH?=
 =?us-ascii?Q?V8OQCzEQoC5cLhbgCxy+RL7vsHwMqVjyEAm6jqU7Vm/J7FWqZEntwLqOXx+C?=
 =?us-ascii?Q?OII7bA+e6a7AAHkUMB19mLN0Jw0YtGkHE1cP0PeyDJ2Asoo/EIdvFIa6693s?=
 =?us-ascii?Q?fFzuNtWS4WNsd9jIcCL9873IkAlgPVpeaO2k85NVma1P0uq9gqKN4N8g7BDi?=
 =?us-ascii?Q?kkmSyf1EjseYabpWifIezO1JIDaBVD84zU/YIT9mzw6QmX1rjZhOiZBUdHLC?=
 =?us-ascii?Q?UOUSmBCxxA10kMRPhl6VyqzrejOJvXjHcQ256DTRW0qwEcbS/dfRdTfuFQ0+?=
 =?us-ascii?Q?mW1okJInwf9+Y3YMP/Uly1iHYpVtSKIGgr9DaJNmHxE41LO1ichFPXTLOaal?=
 =?us-ascii?Q?Jwd5k/NEjTD5VafyBAw44jJBiJFMwh5dOnSVWYGteeKvzv+f+XHhVVW/kNG/?=
 =?us-ascii?Q?/3s548HNt+r+1TEHPV2kBbHif57Z+Ah9t5M4p9v+rf2bh6/NHtHTVEVjWuW6?=
 =?us-ascii?Q?cfa/nvrQM0BSuIZNGUMqPib3GNJYVL6W0rdzaWQxZLa2+qy6QQL6xyEpMU7G?=
 =?us-ascii?Q?79x3tf5eii8HY6XqpSRc49Uor7fcGzMCLihi9Yx1tC92b9sAe4KHpRTaZbgX?=
 =?us-ascii?Q?2wQ1r0hGQ2gAk26CoFuV7899/jIbtKBkKOyqJjPpgL68UVMu+0VhFsZrVoRa?=
 =?us-ascii?Q?htlwOxxvAjxPpnrsz8Lj35t5eI24ejQHIXoxaRQMZNOumusJrwd3gJ9kJ8xq?=
 =?us-ascii?Q?ZRyAIg5VDoIav9c3ytA+Am3IBE6BOI18rmSeKRSHJ0v4iGTOTvrukVjp2+3l?=
 =?us-ascii?Q?CWaRseYBba0QvY4fUDDJJoR97RsT+TmSQLAIjl6QMNA95X2eUxBtaBH0nypm?=
 =?us-ascii?Q?8M30kmq8ZNMCbPMFVlycMoYbgrd5mmn98lb6cqZBfVM0yO7vUdX0bzP/DxQ5?=
 =?us-ascii?Q?sxGmIaxSnb6dtHEGDUK/uqyH6D9kDrxs4CQyforTj/kflS8Y3/zh0QUrF9/D?=
 =?us-ascii?Q?ttY7XGFa6ry2AjCPpGgkjvo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8848afcb-7c76-43e4-0ff7-08d9fda8e226
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 06:33:24.1676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XmFSJoy4TcwcXC17qIuzGhxPyeadjE7nbSz0y7a2aDeF4fgsn0yKzyKho00LStI91u8nzK5J2kQfC4mTxfDSbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4603
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10275 signatures=686983
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040031
X-Proofpoint-ORIG-GUID: QbMb5efpAHGzbiaOyn8E2S7zRXjs4EUE
X-Proofpoint-GUID: QbMb5efpAHGzbiaOyn8E2S7zRXjs4EUE
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

