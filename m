Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E049A4CCDDC
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 07:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238438AbiCDGfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 01:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiCDGfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 01:35:14 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD06C17FD27;
        Thu,  3 Mar 2022 22:34:27 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2240gE8O013345;
        Fri, 4 Mar 2022 06:33:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=gdtOAluPbIQHUWOVCIMoVLm35gM6LdP1RCDPPTEXnVc=;
 b=TZaxe+P6Bx9EF4MToxHkUGvB/e+9D3Y7QyDqTZK+zS7RKFcTi0NrZZSeHixEXdggr8BF
 bbazqzLTXLouKNUf2eBJs0NOJUO7usBEa8NYTHTnrHJJU86vScsQoFtNN9NTcAJA7ZyD
 j9V5MfDIKnWzMCR8DAygXOw0Thc89MYvVIICJn8//QiwVg8kEO37rKxiBp/MbOjHurx7
 Z10RqEyrpVIAlPP9odjV2LhG+PLZb76iJQiiwVYBrHrvn3qCG8duT1p4TA2OB/0cjzS1
 pmQG4a3ILN63clHM+SzJNVKHp196rHG7PqvQ1lCoH6d179MBZYeYBmlP1ffu2BmVQVzh aQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hv0wrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 06:33:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2246V0Rj010236;
        Fri, 4 Mar 2022 06:33:20 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3020.oracle.com with ESMTP id 3ek4j8drqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 06:33:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nn04DFqxt2bwBaQjBI3gniaIuaDyParsG0kT7wS9hNPMDgP8uG+6dZBHRwboUvNphhJHUMnHAN6l/MkClFqYYtn6wEEDmN9kgLbWQfdh7OHfC1mhvHcD9jH4m1ivt2R76XnB4IEdXYjTxiTkImRcvAmb+iN1iACP2UF/6FLt5mCP8nj3fjydxEmpL0rieWTjtihBl6qFwVxTZ506Woq4LbGt/BlTMQT0IR5cNpr1JHQIiTyWG2SpMAnk1to1OZqw1odOZ8vgm07gKQAGtCR6Dr6AeXopj2ntx0ktvSlajQXrktoVlnRgswj32h7RE4gxwBEYaR8QkYDYiWqIcHebQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gdtOAluPbIQHUWOVCIMoVLm35gM6LdP1RCDPPTEXnVc=;
 b=JlNi9pvfpJ7m46FU7sVuT/EsCyJWjBO01BcQhoD2xOgOSOA7027rzJ+NrZjUschu8A9wuawq6F2nfL/SWGo7VpIguAhOwq6G1xKYV1Qk7qfT/SpEcWubJ0ILqrKXzmt7/YUUXQQUCjKb/JJ0sEWgTtV6C/RZZvZXJWI/HL4f04o8X0VaU+dYqmj2j17f13yS9nthTQ6wBo7FcsTMgVYVjizIz7KnhuKKmVSpDcQrvdGCt8+fZDOXQHmSXLAEWZvZuFaFAnAR1Y8LQVsRDzy8YWvQIfO/AKdxIT4KFLNes9Lsb5lK0q8oTdEpLDxfE3jYOLhyadK4a3WHJYqJ4Mu60A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gdtOAluPbIQHUWOVCIMoVLm35gM6LdP1RCDPPTEXnVc=;
 b=co6bsm87s4GQ9ZtOM4h6QP9H2Nh/3fAHZdwNQixAcKAdEXg9M5m9CnXCGSflQFtznVz/rcu/7pOAhbAz7cM4uUhRvX3q6B/Mc/6y1oKjb3f785lzB4QhqEnkrLBxgUJEEt7LBkgAFLRcvW8sIcBUQvnzsV7n9eWE8EEgxTLhjHI=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SA2PR10MB4603.namprd10.prod.outlook.com (2603:10b6:806:119::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Fri, 4 Mar
 2022 06:33:18 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 06:33:18 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH net-next v5 0/4] tun/tap: use kfree_skb_reason() to trace dropped skb
Date:   Thu,  3 Mar 2022 22:33:03 -0800
Message-Id: <20220304063307.1388-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: DM6PR01CA0018.prod.exchangelabs.com (2603:10b6:5:296::23)
 To BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26ff2c9c-f23e-498b-bc76-08d9fda8ded7
X-MS-TrafficTypeDiagnostic: SA2PR10MB4603:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4603A0C0C1F2C600EA58A468F0059@SA2PR10MB4603.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tTDs59zV1RYb8s2Li1RMXk/cH1Xrnvc2euElX1TVkeCjovvFMzhq01Kt6lkVLKeppZlv4/c2mFrZeDCr4QdJ7rVSrcSPbC321t+1uMdceu5U2T87OjH8g594T3UYeXZfbuvDHRlNvEEeGAtKYHu3cQRleC0nmBdeNrPCk/tyoru+4Ilgltw/EZxN95IbudY0T7euCXLD6bm8xDnW7ZnSs8gtlTXmAnPVYYDxq9TUo+YW4co2ew2Ze41q92De5wj5tJrwuLG1o7WHWB5Ml0SbFv/m7g0xR5wUVdCXiWQ8A3ouzijioYLl3HYQUQ1SKZaY9sdGJNmXjjOdXnD/CqUdHkxwdGLBVcj0KiMjMjOZ+svhlkG3xuTiUpVKgut2rMAt2g2ZMTqtMwwEjqgMLBUBZlO5+sSxFSuSrF/851bSTIo5v379iuriLJ99551I7twH5fIXVaygellD7MvtaOkN3LnUO36m4aFxsrXg7GGef7s1x7gY/746g9H5Z4sb9I1OSYWpnvHwGubgovL6CET0Ft4R7+KGBW9gxQPO2YaG4Rx+XEjwbGWc7BnL2ZfwWGyvdG2Vog6zpSovaJ8Z4qKcWEgRRmK+hzQeDkw0tySOM+ytujD8vrbhjrjTAfcGqkP2bvIyZFV5BAzkra4Lk2oVlQcMlpe+CZ9+lTYP9t57It7tpWnAFCg9bjdBvyaOFlS3iUYqezMvWwoXZvIjBw/oUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(8676002)(66946007)(66476007)(66556008)(1076003)(5660300002)(8936002)(7416002)(52116002)(6506007)(6512007)(508600001)(83380400001)(6486002)(86362001)(6666004)(2906002)(38350700002)(38100700002)(26005)(186003)(36756003)(2616005)(44832011)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jLzyKBgFqrywfqnCeg00oDSqAezRG6TUR/yl+pEY1pQMUFP11oCLKcNq1PWh?=
 =?us-ascii?Q?OTJXHdhSD6O4BE6oUDVeNtS68FqA/x891JnQ+vWYqClZkHaQE2ujzwwsDU6R?=
 =?us-ascii?Q?VvZ9bamQc9X8ad0Z7anh+C8LRxTcWI5f4XfgxZ7dHeq+ZutyUzS41KM2wfdN?=
 =?us-ascii?Q?m98n1QztjQwwV25P6D2sjyvHHfVGMpjvqqYnlhIO1g8I0MylJP5XDonChC0D?=
 =?us-ascii?Q?luWmx3jS8YHzBGYozdyUMvI1kQoWUqo/yGCUX06EREA9hq6wbNJYhDYhZQEp?=
 =?us-ascii?Q?OebUFVhnBPducq1AXXfa5ITq5AAlwmpkN5IdY/aljzsYi812X0WCrE/fjpYv?=
 =?us-ascii?Q?q3dSwcoIqOIZAPYkdJBCGMt51nx/zwCzZ2oEAEdDEGmpvrtWxcSdfcVqYP4f?=
 =?us-ascii?Q?+8WnIPfV/I3j/5kSHcX1Goql85+FqY2n/ayW/Ma/7A424xPttyWORNFuPRTr?=
 =?us-ascii?Q?Qeuvhcwf7bHxcXvvr40gB+Uj/VmwpV9SxhfWY50Mt5ETTsJwCCfqr9CuqYK/?=
 =?us-ascii?Q?A4VMEHL8f/MZL0O7RB5GazJA1YM5eqXUN+M2HQb6KFvM+R8Or9pyiWfkjCPs?=
 =?us-ascii?Q?/r/5I20goUu8sXqbru/K5pSDcfaFWxJqUpwcwBkibuuZ0tirWGmoQt+9ttjT?=
 =?us-ascii?Q?ZDJxK5Y/Iprx6qNQkG7pXP5b1iJQbD9mYRObGw4k6+8Y02IiWIAKimMzcUDZ?=
 =?us-ascii?Q?IH4NJT9/2tPUDIBO7lz/W/34gT3+ZdbHugehfWJFbj4xBCxXw/fFwJ/yL/6X?=
 =?us-ascii?Q?mkwwmb3FUusdUcq56WThHMR/31Vei2mTZa9MLL1J3NPArCe4aGCChU6SoIBX?=
 =?us-ascii?Q?Q2JYGseeJk/5E8ncoTUA1Y9U62g5ZU+f//FaxqAWH9gaSb8JmuPSK84kEMIT?=
 =?us-ascii?Q?9Eh5aeaFaVzTDU+gLa9qPE8y2vpC3jDbOiv0i6RjYV3GE4vNArJhWZjRps1x?=
 =?us-ascii?Q?aNRZkJbEA+iTTAL2BuEAqdsfO27/FYd4AysRQucxlPjOpogaJQdDW+3brxFV?=
 =?us-ascii?Q?r2MjWnZorr7cr3M/HDi0nYw4gep+V38yMzQXMOb+tBjoluqFAuDWurnX7W+z?=
 =?us-ascii?Q?mzDmuTfh8q539H/cqWtT2jPN+hHBUpXj5jKKHYCkZvx7bK4dRPzmm2KgvyNP?=
 =?us-ascii?Q?7wvH4kyAMvvGg51WJlmse7DFFYoheifyT7CuRzVY9/aoWzRLgDEVxKZ6ylf2?=
 =?us-ascii?Q?I8PaHZ+ejlriet+JAaAJDZsU+UTSP7lW4pP8BeR1joEOHFDM/VPPTOLV0G5X?=
 =?us-ascii?Q?GV1S/PiPLdyiPwmY1fwT4s9M27vxmbsCwM/GQGSzcSUXfkZC39+VW2ZUvu7s?=
 =?us-ascii?Q?Kza/QJUkuXAV4MTwxf17A2Vl/Nyz9XU54FVj/PXivgDnijmHZoj4/aqNIUbh?=
 =?us-ascii?Q?Vt04cRunYx2UWZfNrEC+irt6cHF7ByiFcxzDjLLSuX6XQdO2DT4fM7zbac3c?=
 =?us-ascii?Q?WG2+6T6UwfiKTBUPO4VPk4fWRaCzFZsOCFCoZ7cmCT6+pLLGWlJA3+ohwBYH?=
 =?us-ascii?Q?RceN15ILFgI2aJOAwsmP7ByGMNAW5A21Pn/6tysgwFYjy+ghZv9nPz4/GuRU?=
 =?us-ascii?Q?IP2KaHZZhmwdNF3DOzBjiXkzuqbszHuc7RYinRajIzC6OlxOwVg84gEv1Yqa?=
 =?us-ascii?Q?FyAnN5Wy3ycr/BKLMtIEINA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26ff2c9c-f23e-498b-bc76-08d9fda8ded7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 06:33:18.6055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LrFqqulQ4M31ELZ8jJwx+uuxqAFujWlCQqqumoeMqvwaHS/deH4gN/tiQCASTL/sgaO3fkgZnWE+GGDtM0Dccg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4603
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10275 signatures=686983
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203040031
X-Proofpoint-GUID: QkblvfiVWbO1g8esSYWU5rlNJqe0Q69R
X-Proofpoint-ORIG-GUID: QkblvfiVWbO1g8esSYWU5rlNJqe0Q69R
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()") has
introduced the kfree_skb_reason() to help track the reason.

The tun and tap are commonly used as virtio-net/vhost-net backend. This is to
use kfree_skb_reason() to trace the dropped skb for those two drivers. 

Changed since v1:
- I have renamed many of the reasons since v1. I make them as generic as
  possible so that they can be re-used by core networking and drivers.

Changed since v2:
- declare drop_reason as type "enum skb_drop_reason"
- handle the drop in skb_list_walk_safe() case for tap driver, and
  kfree_skb_list_reason() is introduced

Changed since v3 (only for PATCH 4/4):
- rename to TAP_FILTER and TAP_TXFILTER
- honor reverse xmas tree style declaration for 'drop_reason' in
  tun_net_xmit()

Changed since v4:
- make kfree_skb_list() static inline
- add 'computation' to SKB_CSUM comment
- change COPY_DATA to UCOPY_FAULT
- add 'metadata' to DEV_HDR comment
- expand comment on DEV_READY
- change SKB_TRIM to NOMEM
- chnage SKB_PULL to HDR_TRUNC


The following reasons are introduced.

- SKB_DROP_REASON_SKB_CSUM
- SKB_DROP_REASON_SKB_GSO_SEG
- SKB_DROP_REASON_SKB_UCOPY_FAULT
- SKB_DROP_REASON_DEV_HDR
- SKB_DROP_REASON_FULL_RING
- SKB_DROP_REASON_DEV_READY
- SKB_DROP_REASON_NOMEM
- SKB_DROP_REASON_HDR_TRUNC
- SKB_DROP_REASON_TAP_FILTER
- SKB_DROP_REASON_TAP_TXFILTER


This is the output for TUN device.

# cat /sys/kernel/debug/tracing/trace_pipe
          <idle>-0       [029] ..s1.   450.727651: kfree_skb: skbaddr=0000000023d235cc protocol=0 location=00000000a6748854 reason: NOT_SPECIFIED
          <idle>-0       [000] b.s3.   451.165671: kfree_skb: skbaddr=000000006b5de7cc protocol=4 location=000000007c2b9eae reason: FULL_RING
          <idle>-0       [000] b.s3.   453.149650: kfree_skb: skbaddr=000000006b5de7cc protocol=4 location=000000007c2b9eae reason: FULL_RING
          <idle>-0       [000] b.s3.   455.133576: kfree_skb: skbaddr=000000006b5de7cc protocol=4 location=000000007c2b9eae reason: FULL_RING
          <idle>-0       [000] b.s3.   457.117566: kfree_skb: skbaddr=000000006b5de7cc protocol=4 location=000000007c2b9eae reason: FULL_RING


This is the output for TAP device.

# cat /sys/kernel/debug/tracing/trace_pipe
          arping-7053    [006] ..s1.  1000.047753: kfree_skb: skbaddr=000000008618a587 protocol=2054 location=00000000743ad4a7 reason: FULL_RING
          <idle>-0       [022] ..s1.  1000.778514: kfree_skb: skbaddr=000000002c1e706c protocol=0 location=00000000a6748854 reason: NOT_SPECIFIED
          arping-7053    [006] ..s1.  1001.047830: kfree_skb: skbaddr=000000008618a587 protocol=2054 location=00000000743ad4a7 reason: FULL_RING
          arping-7053    [006] ..s1.  1002.047918: kfree_skb: skbaddr=000000008618a587 protocol=2054 location=00000000743ad4a7 reason: FULL_RING
          arping-7053    [006] ..s1.  1003.048017: kfree_skb: skbaddr=000000008618a587 protocol=2054 location=00000000743ad4a7 reason: FULL_RING



 drivers/net/tap.c          | 35 +++++++++++++++++++++++++----------
 drivers/net/tun.c          | 38 ++++++++++++++++++++++++++++++--------
 include/linux/skbuff.h     | 39 ++++++++++++++++++++++++++++++++++++++-
 include/trace/events/skb.h | 10 ++++++++++
 net/core/skbuff.c          |  7 ++++---
 5 files changed, 107 insertions(+), 22 deletions(-)


Thank you very much!

Dongli Zhang


