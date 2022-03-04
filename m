Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E12D4CD6E3
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 15:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbiCDO5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 09:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239995AbiCDO5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 09:57:15 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F0D1BD9BA;
        Fri,  4 Mar 2022 06:56:28 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 224EFL74009042;
        Fri, 4 Mar 2022 14:55:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=yqhgfNu7kYY+KC1jknWr8PvtEQ0TGxC2vqd33nJDObE=;
 b=Vkz+Ozt5f9U4ObkazlEq2O4wWaqsjsQj4ZpyZxEjyvDvkppLfZjbqst51azDi6FP6F8S
 4I8fk6wx4RFypzxx8SpCZzs0a3HFodakUi5i/2bDJS2bz+EtN/rBFJSRmHrRbPQa13/W
 MZWE3PJ7p5NG1nc5QSvUyLenY8wdb0T84mfOgPjRkTWWg+/mDG90++CUl7NaLWellbSm
 MYjxKfHUXcyhMsbsxl+yiZFgFoxL4KxnwVjqiJzkQt/Lzy4J7LmBFgDPca7quyi3n7NS
 7jIigVKpMKxFFIb1S1CHo+oofDpUbIgim4LkftlqRkVAwPEECCS6PY/avfcr0EbXg/Tx Ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hv1wrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 14:55:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 224EZUGC130215;
        Fri, 4 Mar 2022 14:55:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by userp3020.oracle.com with ESMTP id 3ek4jh0831-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 14:55:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hsEgoikiC18AhiYQE3WOcHiuiGIKOx650SBDbngqPdTzOEdSvt4Wn4iU9+WofxanZvEOMFWFFyfoNza1B78yGYIpgyNQPDBOUD4+2dxSmZGp5J4cPuuw+88flIB793anin8ppo6u5ElTM435k3R61fjAX/FoIuL7rMYoG+CPT+fZ5wGBVYNKFRGnhOABFa4jPPEPy2fp5zVT4mjvO3qkpLhgX7s/oeo6YpDjNZg1d5/alw/fIyRSs33ELwJfUJiJDGL5f3UoI3h4rcgR0hT6IolTXmoF/UhVzdvloJ+zdvdp9xG8Z1CfRYW0L2zQoYW1N4Z2b6BBWYiHX3DEJ72xrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yqhgfNu7kYY+KC1jknWr8PvtEQ0TGxC2vqd33nJDObE=;
 b=OBEjI18WZoWHEXUo6+czvTi0mUpjXB/zInUB/Ni1jgJlyYEkbZ9OVVxcd10KcsU0pB6h+yz8sfWZvdRlpK1sGBMCEpQxvBgmC+FpyhRMCUoQf2fJr0g+bgVjOWN8FH2cIIXI6eBslJ4BTxMvYwau6LWSHL7ydMEKNRFtqi5uR3OhDPolNMjxmjm3aNqcLd+jkhz37JJnG8uZ2nNemSODa5lyKFAV5bIub44aOMJLG7v/08uacXl3sBtZA5aJcWsbcjPqiyyklZ2DCGu/nlsizKFaxFDPFtJTwHU6dkLd0k90KfECvmK4RN/eTyWjZ/AKlBTBJMucukAJDkiwwvNHMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqhgfNu7kYY+KC1jknWr8PvtEQ0TGxC2vqd33nJDObE=;
 b=gzgNSB2kETtXy3BpRPANcLRtGg+jcJBXFMa3pp0lfrQGwqwxpuZm4HMTtvBj5znXPYxDDLwjO8TSngACM3PGoXrgODH4lxhAclDEoJy99srxZ8u/suiT2AR8XOg3oWoHJAD6PBJeS5hlpnLaxGac/BAIM8JkumTUEiZjC04ZIWM=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DM6PR10MB3977.namprd10.prod.outlook.com (2603:10b6:5:1d0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 4 Mar
 2022 14:55:16 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 14:55:16 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH net-next v6 0/3] tun/tap: use kfree_skb_reason() to trace dropped skb
Date:   Fri,  4 Mar 2022 06:55:04 -0800
Message-Id: <20220304145507.1883-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0034.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::47) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53e370b8-c653-4297-996e-08d9fdeefe3b
X-MS-TrafficTypeDiagnostic: DM6PR10MB3977:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB397725F635F42B4FB9400995F0059@DM6PR10MB3977.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wLZlZCIsoTGkOGhTXj4vPVZN0DqtogGxYKWJImAnzPORSkc2IDKSOZdvdOe0Njt+wDH8WEZRdh1wGfyRcAcyLx9Q8eIQK5lThTO+ZECymyrpPaBrjOxV/C5brQ0WAPpPxL0aJ6QbeQ99IvY3KkDzicbBMjmE9XPD12bNw2hHxnH3+lkTeSzuwPAB/6L7eZufZCTqMO46mUEQbC05Yew2h/X6D8Kh8Zq6kHJrB2SClsJy2kWy3eqs1N2TpQ5xKGJabLGDHd/DU9Y4qUOQKjwp4GxMRP9QlRaMDpcsjuOMP09YZ+rfHVrBqYh6recrco3+2eLUkQ0h61Wwf2MBSiAmYSJSVDfc7AyHJ8AxK73qbG/jGutUs3oNy/ZjWeTgs1opyaM+YBpWrN8FWXxHpDDdadVp+yidYMQC60+p0nKSGDr66llndbEn9qSJeZ/LHNsX6fwW4XXle0lwK3oFlo37SqDL1Ha1QTt4Pmtn3Nk0vJolK5RCHPdSJaRpmUjU5SmwyWBFffFgcO1HtObgYZTC31U0BFr8qmynEe+Au3JZdj+dQApNNHUtTuhBfumWE/UNhBmujZg76YuYiH/kbTbNVSlo7MQHQ5HsGHyLCPEX1tth5u6HIofcHQ/vU4UNwQdU/iRNEoOaUW6JFx6B5Ob2fjSRXx24wpOkUfY0EM6/3Ak06z86Q9qpqfnB/Eoc9Dp6VkY6aNM/zLLTIKFXcGbRLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6486002)(316002)(86362001)(38100700002)(52116002)(1076003)(2616005)(6666004)(38350700002)(6512007)(6506007)(83380400001)(66556008)(66476007)(44832011)(66946007)(7416002)(4326008)(2906002)(36756003)(8936002)(5660300002)(8676002)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?588pVN8sZJ/G+e6OT+qZyY9cpOGXzrF3mlJQDj7409aefta8U085bkmAmBH9?=
 =?us-ascii?Q?cwR/7Zo2RzsrjWk7TWnErJlsTypfWHPqs+SSNkMHkbpI9WCS3vQMGGpnnmF7?=
 =?us-ascii?Q?JOLJyqGwM7z5+arXPM2lCTur0WmAFGK9NeaABjdvV2B7pYYS11i7mbiXR4r9?=
 =?us-ascii?Q?/Kr8ZesHgJLim/AI3g7D6pn2GTAo/tsQJcI3KYL7UjRBQY4G++In/ysUxA4z?=
 =?us-ascii?Q?4swLQOxPU49sR8dO9zOnPL7MtsKCpjy4G/OfN5ahDjlELHhZAgI0mDuZDsPD?=
 =?us-ascii?Q?oRl73BhhLZixhmI1T1Ar4QkZ9qdIfTmK00JXrahxV7Xbre7PctkYMF+04PAf?=
 =?us-ascii?Q?98Vy4dZbVf0r1PUCOTuabjh/2YonYCxdpqA43Pf012hDIiYz98udOYXsBj9C?=
 =?us-ascii?Q?R4qU+JoGnDqsl6hZ0fx/1pYD1vM1AZsEpThDAJP3Ng5DRbADSqZEWj72FDpR?=
 =?us-ascii?Q?9Eeu/i54JcOE33Txiwo++3i/UoXAmuNPxPceUk/p2rLxBkOoqZ93OrZpbLN5?=
 =?us-ascii?Q?fVZivRDHBoabfJYzBSmgJJuajisiJeX6bsAv0qtWZdCPCo/mUodyppQl9wfV?=
 =?us-ascii?Q?plk7WzlhQuaGTC0IvLbrBDpD7XCFhorjomTEUW4zm891/zvCDnuW+WwKVHwR?=
 =?us-ascii?Q?62KWm0yySLxDVgM/h4kFb6mP1Ky5lk9lG1kmeZqTaEXgNJHal44XJNLhoXqi?=
 =?us-ascii?Q?Nd6fMRewLy+34Wd53c/kfjjdNeJ2vuPq3tLowYRAx+npU1qqDxSOeWYKIbiZ?=
 =?us-ascii?Q?x1wtAtjjr1kn7z7tz1ZRImCvyItnW5RFrni5dG70fAhukRq1VLbqCINXs0PO?=
 =?us-ascii?Q?vdV+0IRo8/ucLCV0KhNRETQWGAwfkC035dtSeyunLRF9tLF2hj3lMfKqJ8S4?=
 =?us-ascii?Q?XPGauEfxL9piH5W/3wcp5XStsBSlzx3EVOMWDUuShApKZQblJYsmkLuOwoyH?=
 =?us-ascii?Q?/F9o2/xSlKQDiNMUUofJHWO9wb5wXhei3KARtZadL6ISe95tpPWlDnBuyiZy?=
 =?us-ascii?Q?4+Yo26b5bkV3cS+gRa5uQ84NMPH4fJU0VfDri+WU4RGzr8oi8Ifj5r4aBY+r?=
 =?us-ascii?Q?AAFvZB2MILE7N512QmFZr2JUCJV+3O9nDeZ2cKbvhJgoXck9y5Jb4pkTbypC?=
 =?us-ascii?Q?2yaHPFWnPH1Q5Mbh9JlNdOscnio9g2YX1TS3pk4hD+qrvtAoNBx6xHWhNaXo?=
 =?us-ascii?Q?yzl+KtohVtsBqg2U6a6LIUaK0Y8S+IH0kOo1W21kE8VkyPEfpBPUlptwFhUg?=
 =?us-ascii?Q?4Dd3UfysvCklAXwScTAlo6bCzUc7LZOOE4uuYD7yvuj2pbMOFxzYMeihYsgx?=
 =?us-ascii?Q?TuswN9vBWEyiBDv4Y2V+1+z4nLosCuaijrowNTu7odEjSKh9J01rUAly7I07?=
 =?us-ascii?Q?WxtSjDx1yzS3exsDqSPXlgkJMLMSoAtWHkgVS/gWJMpcHKUir/GX05TaBaZ8?=
 =?us-ascii?Q?xYoDtr8Kdb5Uzz5vhIu3zKWR5EqQkv1HGPWZV0wNOLDcDFW61h4yykCtXgOr?=
 =?us-ascii?Q?OsDcEvI+gE2ji5Ad5Q1oOANsZAJ+t5pUUWAqA+MhdEqsTquxxq8T/ykjOFTW?=
 =?us-ascii?Q?DLSh/rqV/tIjz52bJuLdBtGLIfaLiKqFk7wcimx+lvWXwyVfpCWiTZivBcpj?=
 =?us-ascii?Q?35F3uLkvc32rmiL8hHPYusk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53e370b8-c653-4297-996e-08d9fdeefe3b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 14:55:16.0248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ymZJbSy3Nm1SHsiAL48s4owgotlqzPTfsw6oAQJxJgJ3PC/K0N1AzypvF2gdw4XCXYTQV+TeeS+TgRJZ5MvIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3977
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10276 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040080
X-Proofpoint-GUID: h4Qg3swPdRhoeedqbALBvWFviNZV_ABF
X-Proofpoint-ORIG-GUID: h4Qg3swPdRhoeedqbALBvWFviNZV_ABF
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
Changed since v5:
- rebase to net-next


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
 include/linux/skbuff.h     | 31 +++++++++++++++++++++++++++++++
 include/trace/events/skb.h | 10 ++++++++++
 4 files changed, 96 insertions(+), 18 deletions(-)


Thank you very much!

Dongli Zhang


