Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D6D4A87C7
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351900AbiBCPil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:38:41 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:28606 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349835AbiBCPil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:38:41 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 213FBpQU003835;
        Thu, 3 Feb 2022 15:37:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=EfL+2WZZgFWiYDeRWzmoFOrCK1RdirtOhCRLdhUIXV4=;
 b=BFzKxN4CelJ2IFwIRXlbdTM49R9QrDoZkV0yN1QYbITnnGW3tmKCiyliHhUgUe2C6AEp
 W1wCqvsrTaneAGP3DushTJjP0Fugn14gSTglTMKbQGA9yQx1fP4n1FhiKvKeI93G8yeG
 FjPs3dju8mVhIcWnbPxmSPFPjZJt0Fsd0+qJXASvmQgVrmi3jbLl16Xmcs38Kz/knLUg
 8VmlgW1RCqDc859Cv9d0TrRm6qnxRG1BCHiBnRqz2CtYgILuJSEB/oULrBvIFTXUZRLu
 5M9BeB6zRsJOy/00mE/tcKNFNlu3CUfYm3AEJZF+ZvzMW6Y84iaHvrFzr8vHMBjr103N JA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e0hfw82ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Feb 2022 15:37:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 213FVILw184560;
        Thu, 3 Feb 2022 15:37:44 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by aserp3020.oracle.com with ESMTP id 3dvwdaj9de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Feb 2022 15:37:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLs46aDuu3dFMcYPWLJkOQs1vOgNyp2sD6M9/2sD2QCac97zR9GbdfrlATJd8ZqzGKjFS2lwOYi4bTfqK153VYmejMUxvJYyYxm+tiT/GAtQUrtUYxrHa7Uy9ogqS3DqXJICMpxYDkqHHlW7kAWBCK+TwwCcsIOUuwPm9qc8wqhcnewTrm8VN46vxhpEjDQVcR00Zvl8L8hfMdf3Yphw3C7dg/kwZXN9IoXdVt9cPoaomK4lqDsR58UAexP9nz+hXcxfaz+CgWijI7PBWYjRi1E4TQK0XZhl5749HWXw8PLfM/Nz6Auh8D1CDRGeQF/8gRV6Tu4m00bvA7lL9rYx8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EfL+2WZZgFWiYDeRWzmoFOrCK1RdirtOhCRLdhUIXV4=;
 b=Sgx6dOIa4mxpaRg4eysQPSN2KH3OGh+uq6+a4nZNleLX867rHgNcD0j8sdiYQiTa/Jd7vJQzSrSj/4sp/a5Q/r5lwLO8tujHjnJR3o/w6LY+/5YOhf/rWn6x38EHFkSSIB8Cp0QHBn17EyJHbMSirlf6queEAaJmRpoE5Ggv8wis3pj2ElEAVO+Ipa2ImLMoXvNoyxHhS3YjNiUJRmdgM/SC1xZyQ6URRmZdfIv4OK25xPPvqvDlfuheDFy9N5MO/ScUY7fWM8W8ih5GMD6nK8lNiEHxdCj3mbcmFbw8auRcVd+yhQvOimKejSLK70Xi+QHUe8OCR2JcKAdF8Itorw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EfL+2WZZgFWiYDeRWzmoFOrCK1RdirtOhCRLdhUIXV4=;
 b=zRlbqGbnXFDaFvcH4aDm7DddKmK85RqzwliQqDH1f4LYyz4TS4zqy5XbIVW6c5jwGMa2cJPXmAzlQSB19kMLY5k2C15pGQB2SzHVGt6pm2t0D2ggBGOlZWR67bbbp00WwFzTPwP+zkeqO4lkcj8Ocp8LZwTrzyTSxQZf0UmBVQ8=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BN7PR10MB2436.namprd10.prod.outlook.com (2603:10b6:406:c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Thu, 3 Feb
 2022 15:37:42 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::60be:11d2:239:dcef]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::60be:11d2:239:dcef%7]) with mapi id 15.20.4930.021; Thu, 3 Feb 2022
 15:37:42 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        imagedong@tencent.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com
Subject: [PATCH RFC 0/4] net: skb: to use (function, line) pair as reason for kfree_skb_reason()
Date:   Thu,  3 Feb 2022 07:37:27 -0800
Message-Id: <20220203153731.8992-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::27) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8967ec71-3b33-497f-20aa-08d9e72b1e0a
X-MS-TrafficTypeDiagnostic: BN7PR10MB2436:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB24367FFB39FDD36B86D0B90BF0289@BN7PR10MB2436.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N8JgqlZ/2KSYnYJwEHMTuehk1eTy1ioyJbEFnL5AEP1nByVjTaxEuw+pwrBQ6Ws69bXGtxPGY362gPWzE/xhxFEz/rJX8GKKHaxTM8qtRYOTJ6qFCC6XUMtUzK79ygmYRfU1B94HZ0YlE9vZZ0w/DE4ELsustRS52TuKTCa1BhhzytrgahzughcZi0Kb9WL1BHUQtypUtm9+677EGTTFx6z7r57v696Rfi+9ex1w/+kKolLF5T8BPMhOu1iwOVTxSwqu4S1fX0FhWZfOOqvjxtRgL2cTrkGRWZjoykubOixo1V/E9p7vqiVXtDjhdCJgPujrzt15VboPH7hFA4hYw8hPS3xMfI9j/UF0jKxrhu8lfhN27n1EpawLbhC3UyGcrqEKBWvE4gHTA4Vj/hV0rocbFUW33GFGG/uWV5rNvklrGVBZvx9GsMM4qDoLa6cp4CAvMZ+QP2Dq1AOAcBjJecx4Q+U+hAqpD3WfzRkIMeWrdpbLEPN0NJN+5YvH6rhzEuSRr6XVihxFzewhJ64pJczD7gpjPb57Lgmx/kntWjxpjlfzQ2CAJM307uOvcE8cQ4HKWY3M5pWrO4CDrmFbQ0iPQopW4eKxdxVPOf9flAX929VC0wD70mX/dYI0AzU9qgWNsp1fyDnqEB9hx3ijP07keHzsBuKYEg3HO0a3CUwKMay4GRBKzzb1khIgSX7Y6dErgB8sbnEj86hePffq6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(66476007)(52116002)(6512007)(107886003)(7416002)(2906002)(8936002)(66946007)(6506007)(2616005)(66556008)(4326008)(86362001)(6666004)(508600001)(5660300002)(8676002)(186003)(26005)(6486002)(83380400001)(38100700002)(38350700002)(36756003)(316002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5JzXii5TVa6GEDNFrOdiokvck+QXjCGzvnzcDJ13mo4yVs+qEHJGnYlnH08+?=
 =?us-ascii?Q?nMfTSyfuAXhnlfnG2s/bwWzKjKyHznuQraEChmrJL/Wtd5ITcyMY+uakNiiG?=
 =?us-ascii?Q?4hLSj5GaKnAKiLIVepgwHu4rzBTxFEtOqCMpc8a/TJYGcMfAJqH4dfcb/uyD?=
 =?us-ascii?Q?nz1v8dtTJlzzxbFuPftCQZohN9xCYmiueP2hL1ffOwSMzdw3TlKfZN/IoN/d?=
 =?us-ascii?Q?xZpqP9UCzbYJnwQ3SbR0qiUR63KIM63pP3GQOs54sJuIrGDOhkBFMdjyNpjx?=
 =?us-ascii?Q?JXjEd3hRf59p3EDTd2BFEN4puDOfAwkk/JImPyVOQOJqCqyMPaHEr7PmQyWC?=
 =?us-ascii?Q?fQY2QdL5ec8KbJAfxKvAsWI1cwB6oy2kTxiPk0VQtwSRK+jeRbSe2G72CER2?=
 =?us-ascii?Q?WjJ+1tEVtYP91EA8WVECeLoMRbzSzgE9fiO7TuQD0I3TeMX9zUJqo2o79yMV?=
 =?us-ascii?Q?7iji1AQz4zoZB0rBavhXpIoGJYXDRhlAF9ra6ETspm+1c/A3fNka33m2Fxuq?=
 =?us-ascii?Q?83mszC2Uq3VDjfZkldyIkW8Jf2ZjmM4fbxnoLgkyftkKnhT7RYDGkFhw2xKC?=
 =?us-ascii?Q?wDxR7jxcsDYLfD3vfWDLwpknbkdJvQBLXf2BoCJtk5jZ/Rx3xVnbOjX9IFr2?=
 =?us-ascii?Q?azzyTCdUrWj9+k5NqHQkrMrnYZPONoOgUwT+wjOGWUU40Hox2fwuNXyVavh+?=
 =?us-ascii?Q?Ev+nBYoz4FuWyitkyRzBPZD0onzqzihiSIMrU0Ez85KVYba5WYOsYxcZoZ5S?=
 =?us-ascii?Q?a7ArCluRXki25cniAqDkDiK2pVj5R6lVPlp51Dt1AKSV9cTWzazCGzPr7lsO?=
 =?us-ascii?Q?nMnlOxCTxjM9gu2ovOYpdJGd1rJgbEnJCmpBsH+qzyQGSke86CNFvo0nOESk?=
 =?us-ascii?Q?dzxaSafXJJKCx+JcO8pEGmgd2IsfFlq595ZgbxVK0XRMRkbBoLzd+YbsKCtp?=
 =?us-ascii?Q?TXaDU+0YK2302z8wpua+GP1CbJhcwBBF1JBrQ2l+udMfo8QqJX69E4LpeFbQ?=
 =?us-ascii?Q?syo/Y8/c2aOitVHtVRyAQlstla7UbPBOJVFW/CMaR/X5JVsbPHP/Rfu6oBDx?=
 =?us-ascii?Q?5odmBOJ9zZYPy8KS5XbsBlIZpA0TmCcBSIPLlW743PJ8hdc1f8EJvy+hSPqC?=
 =?us-ascii?Q?QTb0ZErmQ27GXaIi/Us+GRoDhYe8UjoUR5VAmB7oivXUMhnVi7a9UuwX6J+7?=
 =?us-ascii?Q?74+wa5rCWk0JW2AzOr90iHtT5MyMGs3iancn7Af5NzQFn11STkl5QOmqHZJi?=
 =?us-ascii?Q?wdIZrQmZ1bUC3EMd5x1TIgePcuIx/KE2IW0w4XD+yopywQbkjZBNfgLCvi3V?=
 =?us-ascii?Q?k0wDz9f2b9EHfDzs7/wMlRfP39AHN2ghoPdVaxh/Kg3iJWaGdXuXWYSZjrBB?=
 =?us-ascii?Q?uJztNmQTgYzgxaqxUN8pBd5qqtMZQvkl13nWxT61rBOmnVBmjfq8+rby+iHJ?=
 =?us-ascii?Q?J1AGG9rWmm8ccU30CGWuGuEI1zz6X35QMrZGELs6gvdp0FwIlqHTH/uiOGHV?=
 =?us-ascii?Q?C+FMeD5rtqEk62d2o/wuypvBpTXcXgk35MzH1N9JF4xlyfJkcnnED4UH3t/6?=
 =?us-ascii?Q?URc4X7Xi7oFi9N7gJlyIClG9ire6xPQjl/idP2Sdx+4JC6zfSxIGToHphIoO?=
 =?us-ascii?Q?MnfPPGhq31muur7ZOdL9kzE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8967ec71-3b33-497f-20aa-08d9e72b1e0a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 15:37:42.5569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RCTCSfNJDovHyGgCDLpYqTGvhssyHuPwR/A4htIx3G7Wx0F3RFPyFqcpyws6XYnOnFjpP6IRWnDwILujqmnb2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2436
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10247 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030096
X-Proofpoint-ORIG-GUID: N3jgOHqe_ERUEuwVTOYi7IrfoHrX4pBz
X-Proofpoint-GUID: N3jgOHqe_ERUEuwVTOYi7IrfoHrX4pBz
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This RFC is to seek for suggestion to track the reason that the sk_buff is
dropped.

Sometimes the kernel may not directly call kfree_skb() to drop the sk_buff.
Instead, it "goto drop" and call kfree_skb() at 'drop'. This makes it
difficult to track the reason that the sk_buff is dropped.

The commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()") has
introduced the kfree_skb_reason() to help track the reason. However, we may
need to define many reasons for each driver/subsystem.

I am going to trace the "goto drop" in TUN and TAP drivers. However, I will
need to introduce many new reasons if I re-use kfree_skb_reason().


There are some other options.

1. The 1st option is to introduce a new tracepoint, e.g., trace_drop_skb()
as below to track the function and line number. We would call
trace_drop_skb() before "goto drop".

TP_PROTO(struct sk_buff *skb, struct net_device *dev,
         const char *function, unsigned int line),


2. The 2nd option is to directly call trace_kfree_skb() before "goto drop".
And we may replace kfree_skb() with below kfree_skb_notrace() as suggested
by Joao Martins.

/**
 * kfree_skb_notrace - free an sk_buff without tracing
 * @skb: buffer to free
 *
 * Drop a reference to the buffer and free it if the usage count has
 * hit zero.
 */
void kfree_skb_notrace(struct sk_buff *skb)
{
    if (!skb_unref(skb))
        return;

    __kfree_skb(skb);
}


3. The last option is this RFC. To avoid introducing so many new reasons,
we use (__func__, __LINE__) to uniquely identify the location of
each "goto drop". The 'reason' introduced by the
commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()") is replaced
by the (function, line) pair.

The below is the sample output from trace_pipe by this RFC, when the
sk_buff is dropped by TUN driver.


          <idle>-0       [016] ..s1.   432.701987: kfree_skb: skbaddr=00000000a65c0a72 protocol=0 location=000000008a49d80c function=none line=0
          <idle>-0       [003] b.s2.   432.704397: kfree_skb: skbaddr=00000000665e5ccd protocol=2048 location=00000000ec3b7129 function=tun_net_xmit line=1116
          <idle>-0       [003] ..s1.   432.704400: kfree_skb: skbaddr=00000000e4c806f8 protocol=2048 location=000000002929642d function=none line=0
          <idle>-0       [002] b.s2.   432.734617: kfree_skb: skbaddr=00000000079749b3 protocol=2048 location=00000000ec3b7129 function=tun_net_xmit line=1116
          <idle>-0       [015] b.s2.   432.880571: kfree_skb: skbaddr=00000000e1542f1e protocol=34525 location=00000000ec3b7129 function=tun_net_xmit line=1116
          <idle>-0       [015] ..s1.   432.880577: kfree_skb: skbaddr=000000004f3022b6 protocol=34525 location=00000000547c5c25 function=none line=0
          <idle>-0       [002] b.s2.   432.886247: kfree_skb: skbaddr=0000000062990a71 protocol=2054 location=00000000ec3b7129 function=tun_net_xmit line=1116


 drivers/net/tap.c          | 30 ++++++++++++++++++++++--------
 drivers/net/tun.c          | 33 +++++++++++++++++++++++++--------
 include/linux/skbuff.h     | 24 +++++++-----------------
 include/trace/events/skb.h | 37 ++++++++-----------------------------
 net/core/dev.c             |  3 ++-
 net/core/skbuff.c          | 10 ++++++----
 net/ipv4/tcp_ipv4.c        | 14 +++++++-------
 net/ipv4/udp.c             | 14 +++++++-------
 8 files changed, 84 insertions(+), 81 deletions(-)


Would you please share your suggestion and feedback?

Thank you very much!

Dongli Zhang


