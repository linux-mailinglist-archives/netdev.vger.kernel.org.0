Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21F44C54B8
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 09:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbiBZIvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 03:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbiBZIvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 03:51:40 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA258888FB;
        Sat, 26 Feb 2022 00:51:06 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21Q4nCuo008247;
        Sat, 26 Feb 2022 08:49:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=KDez+LS+FXYOys1cXqkw1KUN43jbTJnNSUFvuamaZ34=;
 b=JisdGANzCz580XAg4Q0fv502j6Oepxo+i7DmsxQew6NnOwUM9OBa4H68BAGZNGgxwShQ
 i2lerdPq+2P4lWL3qifwYkICF1tfW2fyGPygjFSdixpwhcbIwZnedeNHj2eZsOHA+OxC
 0mg7UkoQSo3QpJeeD86EH7iPTZJKlOCcZcPcsTCvv9aHXAYlq62U5//41B+/cTKoUFbj
 IMn5a5elTi2kebcWTIccoTX/jSP5AEKTjjiyGI/qVD8UyL2Uu2JbSsOX4UJXT7fD3kf9
 0stfxBeO0V9KENdBmq+jEXe+v0y6HJTgtlGmgbyF56KH6n/XFITnfJxktbGREsABqR0h aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efb02gdty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 08:49:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21Q8kO7q005020;
        Sat, 26 Feb 2022 08:49:58 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3030.oracle.com with ESMTP id 3ef9askqdw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 08:49:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U0pQZrxRdCF/76wcsOBnA2VYMF8PhQ/E2n//F0X5zhPjQ7t6IAOtKQclcoj3tNvsaJlMwnbXHsDvPV5hQctuWVJwBEciQSHiljWisyZz4W/D3ZnkVM8dTEZy2FtNe5JnKsMhOZ6Ux7lpaWKkSeccyuXkZvEvHZobPuM7MHKvBm5HOjyyF1YDOi7EZxFzgQhYzG21o9APraQc/Tz0+wvcUA7+otYZJz00YtAr6v3nqsMxYkUaQ1lXbe4chBANG34bR46oSphlGL+ZYTxIRslUafvXrKsQM6POHV+JxOQKL5yOYfodQfSfyYNlslOjH0IsL4FiKVIXu11/Adj0ldTlSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KDez+LS+FXYOys1cXqkw1KUN43jbTJnNSUFvuamaZ34=;
 b=etiZyTkQEk4nMuZ4GmNz51/HD/YsFc+vfzlfZ8bXKrORHZg42hu/c4yvwIRXlx4J+7fBxB09xq9barLALinybeXo6bg1FxlfbKtAvowLV+SvKYAmdgkrEjNE2mPcDm/pjttfymxFnLVaMzbt4QaFfQ8q9c7h0RvbvXK9D84jQl/tktq54cWJtUrI2maBh9foYzapZRda51mUx4EdtulIin0TC5/TgF/0OzMq1rba9D+w1tPFObOUe7GNJvI0/8pQLV12gBlTaYiAPV1Q8jAi8bHu5KTBTfqbBhvcQbs8/79OCd4Sfh10WIHP2hNDBY28Q3y3e1kuN1xOMqaHB2co4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KDez+LS+FXYOys1cXqkw1KUN43jbTJnNSUFvuamaZ34=;
 b=egWW+HVSBncn+99LiYoLekwijqpa5Pj9knqTsSni4vowfGLAR13gOZGKVIx+TVR0XT2WvIM77wEa6nzsXrpscM6Nb6m1psCQnPuSuC7NPK5DV96A0Tc7giSVWzg1hqmQ7dla7j5Vuob1IiS+mN4zOaiJzBTWBExSQFZy1tQ1OSs=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CY4PR10MB1768.namprd10.prod.outlook.com (2603:10b6:910:c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Sat, 26 Feb
 2022 08:49:54 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5017.025; Sat, 26 Feb 2022
 08:49:54 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH net-next v4 0/4] tun/tap: use kfree_skb_reason() to trace dropped skb
Date:   Sat, 26 Feb 2022 00:49:25 -0800
Message-Id: <20220226084929.6417-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0196.namprd05.prod.outlook.com
 (2603:10b6:a03:330::21) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92bab966-b215-4886-209d-08d9f904f539
X-MS-TrafficTypeDiagnostic: CY4PR10MB1768:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB17685C7B67AE00EB3970F53BF03F9@CY4PR10MB1768.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R81V1CwcfUQNFIfigP2R1cvoO4lSQWlBOlPPrbU1bfmgUU5LrLfzYMtXBKcQkFZTVMoE5QfGCrQ4RZ738UleqoRLbwBl7Jw8s6xaHDBd5gpCRaVwhcUBH63nlqb4anN0My5LOSy+S9D50c4E8yHQxhd7+nGmRk10QQRQY1PI3A5+TUNA8WnLuOUl6EknfcxQDHhpNtioP6Kc+CO3lTosvR3uPqzyQgoZQWzQ5VbUBobL28+1qbOSKJlzV+5zZJnUeOvJhOGvuTFZNaT7sXsnqzDsCuMZBaXtkVN6pq9IpiesLebvxBEiJ6mtP5nU4ludZ4MLa/SYv8oruzS+RLMgwcdfcFR03TprxksS2zzi0Q1ubONa0k0pPTyA4mK1wTp8+iYGzBUj1KNE17Pa7hzgQGnEDsAhMZCbNaBcLKAlzQTyk335nTwrc3tz0AmrjHzlB9wC0ccjtMgmAuGOKo9ERE3VwX90V6Yt5/Vsg1j/hc9sc9zqMF4w68KmJjlVk7Wwu/HnpbejQZg9smyKSv6fCoh7m9rhCKhrvcQU8HtFTtxc+5et9FXwkzWdI3C46Ap75PNBHnVg6E+y6xtOMe8SjK2N9eEW2YhZNBf2ueyVwRB1GvyUH+1u0ubNwbxubTOZBhn3Un0pkNMzJcM36hg/wl8t5JkXkHtK3oG9HnPJOeNXEkOn7XrzWbt23p108NTVscCwsyPX1UjKVueeycFw2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52116002)(316002)(6512007)(6666004)(6506007)(186003)(5660300002)(86362001)(8936002)(44832011)(26005)(7416002)(1076003)(2616005)(2906002)(8676002)(66476007)(66556008)(83380400001)(66946007)(38350700002)(38100700002)(4326008)(6486002)(508600001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hvd9hEdoxI9Oz22ZkfZjwm1BLPzj3/3VMuU9Y1ByJnVlfItQfIW9QhX66MFT?=
 =?us-ascii?Q?4nKRSpU8uxYciUOlSDnL0fMiKovN13DIl06QqfImcJACzJ06jZwKE188vzv7?=
 =?us-ascii?Q?Jm2QvXjDOwFg8Ifm2HgG0XDK5buOD4j1RvpUrbak1FiOQduNT//qcuuBQiY8?=
 =?us-ascii?Q?Y+DtWGZJED24FpvtaARs6CkABAKhoEsvy6ESzTxLpEjxi+0Y3aep/bpg3grN?=
 =?us-ascii?Q?wzTJ9pTf73ZOPi3YuU3D0K2DKjAQdRVdXDEYh3cMVH19MBo5o2T8Ys/W00Yp?=
 =?us-ascii?Q?Z/C60CstKzBK6p8fJM4yaFrvrbEhLavetLT5t2bErf0hedggWcAz8c6WatOr?=
 =?us-ascii?Q?RxlCSEPJLPGLhQnSy0taHzuZ5hK0Wy42GkGAp+fbB/N9IfBjDvKyzUkivhzF?=
 =?us-ascii?Q?O+kCYI6pIxAcYHM9Jbzjd6rZLTIeaRNtq1BkJ/CZLNiNrEr6A2qjqUBsE0JW?=
 =?us-ascii?Q?cGqL0gv1a3qvEnr1234atAp8C7p8gEY2J+Pz7gEIsPJiwNZ51BnFlKhengX5?=
 =?us-ascii?Q?TSuqdB9y2SowFDB3e6fHbpGjFQxR9OMBHq304Zvzlcs9bh3iXoviBBQJXuEc?=
 =?us-ascii?Q?iagYHymAGUckEu+/sMhJvNrdsLkduwMgTdYidAF7pLOMukI3MEuFi2AIFwLf?=
 =?us-ascii?Q?7uTCbWzQZ3y/QI4tb5X6yYM8pQak6NDrMehQshwIaaQ0Q6/CjkmeznOpDGKu?=
 =?us-ascii?Q?7d8Qz+NIXBQvufa/DAQ1EqFd4TTXjdB/Sn2VKuZOngwB7PQzT92AZNSttOWs?=
 =?us-ascii?Q?RxQ0X2DJa9lL1Z664Vffll8XccipwocezZnma+qxLxkOGHq/uMSZo3ATipRq?=
 =?us-ascii?Q?wkbFDPopHquxpTSw7VeE2Pl9VINwx8kIWtt3X21jOnhCHCXTG8OS4eZvx1aY?=
 =?us-ascii?Q?6Odv1hzotxJ/46YRDIZ8RcLij+D0PGGCvMZ6lfS7apxMxiH10vWsBOt4/21C?=
 =?us-ascii?Q?FCo04dwxQpV6vOfyBwbD2G9hA9nN2QKRj+vzcccv3gPEgvYO6kZ014lJDHJ2?=
 =?us-ascii?Q?jvrGJfCLMt5gkjcNA+ImrS6VbQEbonjSPHIPgQS/yX5nodWT6iG4JZ1Q9XXC?=
 =?us-ascii?Q?e+fPqB/eEdlVP5QdPQzVRl/zBuvodzBP00JF/JF26L3+/aXSmpZI5BIUAs63?=
 =?us-ascii?Q?adXenX3hYqbUpGQjMW+1SGpoUcqxIbB56OIOTESZLB/jluuuS0Hm9bgenwUR?=
 =?us-ascii?Q?d1nzJfloef8Rl39Y44FYRcnFuzwbNEURym1mvYWBx8avFgXa24DnOx400ees?=
 =?us-ascii?Q?3ei3iPQ7Cjhnod/8jkwtmN/iBE5HiDRGGyWznqOKMLqGzMmV6eA5+7ubiByw?=
 =?us-ascii?Q?XR+AxoPStN3EiZIIv7yaW8adVXTtkeH9d6LPtCfyEAuwayQuxOt3nl95+TvE?=
 =?us-ascii?Q?wfrxeT/uHsd2b5Mr6UDWDxeCcd4h1IaWO07teZI0s5DwkhYCbXjyDKZYN6Yd?=
 =?us-ascii?Q?Z9MCR4xincR79bFuCaQOQe0NpG7YXkeVl0DD9Jo2hKeWEK0nMF1BQWg3Sl1k?=
 =?us-ascii?Q?yjoWAdwzEBNjM8u3O9i6XPEtt2dN9WZ0qrOY7xUDlaEaz1c8a6sDhC2fH7wY?=
 =?us-ascii?Q?75eb6QYGpnF+aDhhnXrPBnXOh3ezyRzNXh1sAAZwA/r9Jwe4nJ01LnTynWvg?=
 =?us-ascii?Q?hDALlmXfgqFVXUynUFfMcMM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92bab966-b215-4886-209d-08d9f904f539
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2022 08:49:54.1482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tePG+n4GY7u/iFqJt1PlTZNqkrzY5k3wkpbRt6uS4WAoq8BXgpYhMPVNX3x8/quOxRbkAvbFxAfn8wdK2CgzBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1768
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10269 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=949
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202260060
X-Proofpoint-GUID: nsy016fOyxj1xGCbQSyfRt-pz8ylFOQ5
X-Proofpoint-ORIG-GUID: nsy016fOyxj1xGCbQSyfRt-pz8ylFOQ5
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


The following reasons are introduced.

- SKB_DROP_REASON_SKB_CSUM

This is used whenever there is checksum error with sk_buff.

- SKB_DROP_REASON_SKB_COPY_DATA

The kernel may (zero) copy the data to or from sk_buff, e.g.,
zerocopy_sg_from_iter(), skb_copy_datagram_from_iter() and
skb_orphan_frags_rx(). This reason is for the copy related error.

- SKB_DROP_REASON_SKB_GSO_SEG

Any error reported when GSO processing the sk_buff. It is frequent to process
sk_buff gso data and we introduce a new reason to handle that.
	
- SKB_DROP_REASON_SKB_PULL
- SKB_DROP_REASON_SKB_TRIM

It is frequent to pull to sk_buff data or trim the sk_buff data.

- SKB_DROP_REASON_DEV_HDR

Any driver may report error if there is any error in the metadata on the DMA
ring buffer.

- SKB_DROP_REASON_DEV_READY

The device is not ready/online or initialized to receive data.

- SKB_DROP_REASON_FULL_RING

Suggested by Eric Dumazet.

- SKB_DROP_REASON_TAP_FILTER

Suggested by Menglong Dong. For sk_buff dropped by (ebpf) filter directly
attached to tun/tap, e.g., via TUNSETFILTEREBPF.

- SKB_DROP_REASON_TAP_TXFILTER

Suggested by Menglong Dong. For sk_buff dropped by tx filter implemented at
tun/tap, e.g., check_filter()


This is the output for TUN device.

# cat /sys/kernel/debug/tracing/trace_pipe
          <idle>-0       [014] b.s3.   893.074829: kfree_skb: skbaddr=0000000013eea285 protocol=4 location=00000000036fe12c reason: FULL_RING
      vhost-4456-4469    [024] b..1.   893.230235: kfree_skb: skbaddr=0000000011eab049 protocol=2054 location=00000000036fe12c reason: FULL_RING
          arping-6811    [002] b..1.   893.235606: kfree_skb: skbaddr=000000000121f124 protocol=2054 location=00000000036fe12c reason: FULL_RING
          arping-6811    [002] b..1.   894.235682: kfree_skb: skbaddr=000000000121f124 protocol=2054 location=00000000036fe12c reason: FULL_RING
      vhost-4456-4469    [024] b..1.   894.291240: kfree_skb: skbaddr=00000000d093f0cd protocol=2054 location=00000000036fe12c reason: FULL_RING


This is the output for TAP device.

# cat /sys/kernel/debug/tracing/trace_pipe
          <idle>-0       [004] ..s1.  1584.564287: kfree_skb: skbaddr=00000000e0987862 protocol=0 location=00000000177d2c83 reason: NOT_SPECIFIED
          arping-9338    [018] ..s1.  1584.642082: kfree_skb: skbaddr=00000000856cd27d protocol=2054 location=00000000615812ac reason: FULL_RING
          arping-9338    [018] ..s1.  1585.642190: kfree_skb: skbaddr=00000000856cd27d protocol=2054 location=00000000615812ac reason: FULL_RING
          arping-9338    [018] ..s1.  1586.642271: kfree_skb: skbaddr=00000000856cd27d protocol=2054 location=00000000615812ac reason: FULL_RING
          arping-9338    [018] ..s1.  1587.642368: kfree_skb: skbaddr=00000000856cd27d protocol=2054 location=00000000615812ac reason: FULL_RING


 drivers/net/tap.c          | 35 +++++++++++++++++++++++++----------
 drivers/net/tun.c          | 38 ++++++++++++++++++++++++++++++--------
 include/linux/skbuff.h     | 21 +++++++++++++++++++++
 include/trace/events/skb.h | 10 ++++++++++
 net/core/skbuff.c          | 11 +++++++++--
 5 files changed, 95 insertions(+), 20 deletions(-)


Thank you very much!

Dongli Zhang


