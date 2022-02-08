Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2394ACFF1
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 04:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346592AbiBHD43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 22:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbiBHD41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 22:56:27 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA658C0401E5;
        Mon,  7 Feb 2022 19:56:26 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2182U85F004455;
        Tue, 8 Feb 2022 03:55:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=sOfjXblzFp7GLQhp4rqCFekXG0kpRhpFLA7YbMZgQiA=;
 b=KT0zTufdWA86z3zSNbO3f94R3lxrhiSDxxPhp99S8kfutNxRPv4/gvqEsKD8JdorwmnA
 AAVEnOsb/3x0F2A4yfaq8g0VU8uEApYTp7yvJANWF+hZNAo1xNrk6VxC2erUliG0tjMz
 GiJrp6BnPXaos+fNo1HJajcGc8SGKeD2K+VUZD+NBFRwUQIDHTFXYC+yB+uPh4fZH091
 e1OQTvdEwBpyVjwddzuR4qwR1puzcvmL0L1ik82UpCfUageT9HLGb4kmpDUA52edTjAh
 VncJo5FAdTjnHnOvqquU80ukCmRBZKeQxcJh6ZWMV2g7AQkCrlE/A5hZo6jRiyab6VEy pQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e1g13r7w3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 03:55:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2183tWpq009521;
        Tue, 8 Feb 2022 03:55:35 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by aserp3020.oracle.com with ESMTP id 3e1h25ckv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 03:55:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F9NMgfQ4kwnlKpTl8R9frkRhsHSBdN7g9Xnawu7KqOOdy78hdwcI4fKXZkiCfYhRnSdzOxvJyHXwnRADcnt9JX8gQM1GLBmQ/WSS2rg1IpXwCsDqusXkl93rA8vgp1H+uFbNtsRh6wt6GUIAKyB4cWrjg4WsL1eVTve3GPlshHKmcxE2KvpgzSh+AIi6WVWvIm6p1cX2XrNlc5aB65JJGwuIsq4jWkZp1Fe5tdVMfhkEmyZFV0dhLdZttTl0LWlSj1bY5pAO9hT9MYjY+O/8wWHYe0UPjYyHul7GJX+kO9O3Z0MaCmw7ZxBjM4mjw0RlpOJpCCJYLbOebS7WlZbb6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sOfjXblzFp7GLQhp4rqCFekXG0kpRhpFLA7YbMZgQiA=;
 b=EMseqyhYQ0UMb4v939sTADjX6T4Tb6hdIta0V4+UznuCdd19zwu2C0s38ardMxb35Cpgoxapq2MW0z8teNRypJ12GuELx8YT/y/udkSUoQmBmh1tLCOowEDAURAkJMvKdF4/6sJD6/+nF1bu12xP1p3GJ3dTKTOmknQA0ZAw3P17esfY38JSGMiv9F490R3s6AL9Vubz7mUaaJWFBnGdjutdDrvddudC2I5OQQaUv+9kNkHccHYglglaxPuy76N7GeFtZIiqjEV1Ntu0PNx8OCLZohXeIMkBRJ4aP3lsDmPbF5Gg0feA2VgUjolx2SPhWO/hojXbIvGoqyC6BIbmoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sOfjXblzFp7GLQhp4rqCFekXG0kpRhpFLA7YbMZgQiA=;
 b=SgAi6mKBjlvi6nnCj+1BApY/dGGODO1/iBFzjTOXgA2UBydpL+DVJ/paGTodKVubSS075fIDod1R2OIPyep0rb6ynlbBT6jQvf7JYgN/CkRJNtj6zQVArLXPyUKaB/RUtRsOXBSV0lo6Qsmc2a7Uc407JkQI7bwrQw/9DLa0rGo=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CY4PR10MB1352.namprd10.prod.outlook.com (2603:10b6:903:28::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.16; Tue, 8 Feb
 2022 03:55:32 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 03:55:32 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH 0/2] tun/tap: use kfree_skb_reason() to trace dropped skb
Date:   Mon,  7 Feb 2022 19:55:08 -0800
Message-Id: <20220208035510.1200-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SA0PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:806:130::15) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11944b5b-2a94-43bd-7c91-08d9eab6da38
X-MS-TrafficTypeDiagnostic: CY4PR10MB1352:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB135282EA10954B16325005DDF02D9@CY4PR10MB1352.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D0ZfG6T86g/d6HI6reBYRvN0q5MjKdBFuidaDu5X+pduCHnWbrf5RN2HMwUKUnKkmZQwX/D7Yiyly/74LXyC4liKuaRYLfwbqEFHaHbTpQkNPscyPELejLlDeS8iFxct8fOAMaJLQKnN4vyF5eMTG915avrExKNnlKzevIHFgCCfxXbK1GPNoriDxPCsMo3kHHn7VMm+ZC1rWPNPcz6HUFabkAykCQtx83j/u0hUdS7PCZpdgyYqah0kElLUh2epEvXxwV7RoU7CVRVxfhiyOjuHZzALvAHSpg9PqY9TXQZ7pE5Lo5PgdMdr60jPDN5iwaMHQs/57u4C5d72f/PrSrCdzktw6WOMW8PWY0fP1AfuF1DMaZbyaO7NSdB8yUyJUYZJ/IimOvL+eOaIRpq2Jk32ldJ4+KskaMECFuGkjsVoTPHiuUs05O9utiUpH27W34MgYl/cr328GUe9kMr9iywChEWrOeYeNg2G5j607a2uqBed3MNKYcmKzpKgaGyhHXMQISuzPMs2jCINm7CokSiwilnJIi6wIfe0k7ww+DFr4DP3GmNFyy90dhiSlvkX0EPfNPhYmCPmkqgbdzYyocqsd3vobRG9CNKmqBEXRfzIrZRLDCIY7iBd3dbTQJwUWD10MDWm7q6KhocuERzANng5PqT9B16U5N5yYw/Ykq1l9cBVMAq/Drt6NoSQHGiuzo7pGO2d7lJYwRc4LA4auA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(4326008)(1076003)(38350700002)(38100700002)(83380400001)(6512007)(26005)(186003)(8936002)(2616005)(52116002)(6666004)(6506007)(8676002)(7416002)(66476007)(2906002)(86362001)(36756003)(44832011)(508600001)(66556008)(66946007)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CrATAlU313yu1XGGPHAHdLLGv+5e9m4o2ScnKE0X956CuMPSYpiNtC2GmRTC?=
 =?us-ascii?Q?MGss4ulGQvDViUe4QCmAIOryYn1eyOj/LkTbtmynGOD93HsyQ8E4DwFQhegw?=
 =?us-ascii?Q?x8jnWj0FtnvofZ3a/h7tDAvBvfRy6uXQ6kP+fgDvx/jNlVdp22z1O0bUO+jI?=
 =?us-ascii?Q?2hchs7FDGQxhkqbOuZwSyGFJmg9e3Sbe+1kYSfkWhVMFp/mi4oT2e2FGeMOf?=
 =?us-ascii?Q?lgMbmtac55dpoYcPad+hZOgfuImRlWEA+CyyraGiA+Djha2+hzkQuBWsQwcn?=
 =?us-ascii?Q?D9Or/BjhN0zQqcJYRBJZ1vn7gPLG8FSSNUI78GgKPcjmlecG+EtTOtfSXNOD?=
 =?us-ascii?Q?qOJHouBTuliJbmTlzo+Rvyn6Ynn5J/wA1GflDZISB2tYOsfkiqMxPqtIHc6W?=
 =?us-ascii?Q?sRGtnjRTOh7CBDdhoK+2fYSP6uksYCHwNCCgYqIhte+F+OH/STJMSZ+ZJ1UM?=
 =?us-ascii?Q?TZGMV0E2eUwMKgNw4soUlcfdtEbft1GsoIdKWvwXVEgAk0GzDenj3OouMOnq?=
 =?us-ascii?Q?TWLzQ3VJK2MCZZwC0zwAxzdtgEg9qDhKg6oeuVtsSTfnPfDKdQNXPIrVwLJk?=
 =?us-ascii?Q?6+2Z64RXEFuqPmE5NBxh1AVyYijEHwTwCADQa0HYeiP4DKNBlbUgWTcrE7zf?=
 =?us-ascii?Q?GpiCE1mvLWxs6jSukPSxOMedOeCoy3ACEXoxNneUyddNY+t1SMVzKA2QhpsG?=
 =?us-ascii?Q?364d65cQZGVljVLMoiqR1yFfM6LGAP8K1qw21prsJublQKSzoTVvQhyxtQE0?=
 =?us-ascii?Q?8YhMd7sxYMbacDu4UTkoQLz+GBkRcxNO+dYwJ6CmjFTBMpJI4ngw16+zsswJ?=
 =?us-ascii?Q?u09pN6Q0pv89oE0t5UxEhurCQjmf44jrS/lK9DrMWnzmqFAJiWSS76rLfMao?=
 =?us-ascii?Q?7Kl+hC9QxC/3/q0zt9BlUDpyL9F+2HzJ0m7Efex4WAU0biZEY/s4m/O8w+qe?=
 =?us-ascii?Q?9Rihlr5umGzzao65lcAKP9N/douOfB3U0rAlXRL0pSyQGZ4gabV/XEDrok9h?=
 =?us-ascii?Q?JeoiB6Ja4/r15h6KoF16oa5VtGkgimw3VK0eBDKEEJh4ZvFKdiA9ELC35PLR?=
 =?us-ascii?Q?E/oGhbC6GC4TF9HJzzEvbvCId2zek61uMSQYXiUYdWv3HJvBM0hQfavnvK1s?=
 =?us-ascii?Q?2KyuCbr/SUeCsLsrdL+LG24jef45qJ5qeco6eA012N1nrOwRGr4Jz9n445cw?=
 =?us-ascii?Q?w9XpO6/u4WE7JufRsJXyWtQKBSym5Bv2jWHURYDvij5itgHTtou/giuKwQVD?=
 =?us-ascii?Q?gxbRJD3v4qbe911tXk319mdtgHVnIqWy/NXD4OATbZZj2TYmuIsSvafG920z?=
 =?us-ascii?Q?fzJdsrx/Qp+0rbkY5SMyP4WQlBvLxECpvQ2PwbgXHv56nEp9Bw8/GMhaAxll?=
 =?us-ascii?Q?nfwpD9GA/Q9B2dpkgngpAqbysqUXfyz0voJ3SwNcYVF5BO2XOEhTljf8D6TW?=
 =?us-ascii?Q?AvbtmnnBxTbW4VXm6IMVQXjxoBKS2glVGDtBpEAILakWJ3DReCWj2rEa1eMD?=
 =?us-ascii?Q?i6YcOx65uAbqxRhHKYq3DKd5Vza/x9mAwF/MyjkavRHtytmxKpH8/JX1Oqyd?=
 =?us-ascii?Q?PiZD5YpaF71D/UVVBjvqDg+ruIKypwSg5WYoba5HHB6ANv04AHvI3ixnOC5/?=
 =?us-ascii?Q?IjRj7wFlsQdkKc4+1pVAdOY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11944b5b-2a94-43bd-7c91-08d9eab6da38
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 03:55:31.9311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HrcpFZzBCz8107GLntvV+2eaxxwvtNsQ6bfBqyXFqjhHjVTohK6MgEivDKVj1l8txggaU4FDJ2rG+8dGucw7xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1352
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10251 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=664 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080019
X-Proofpoint-GUID: Ch6jJJFZ_nSz68cEeM9oc8WZTTEDkRLX
X-Proofpoint-ORIG-GUID: Ch6jJJFZ_nSz68cEeM9oc8WZTTEDkRLX
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
introduced the kfree_skb_reason() to help track the reason. This is to
use kfree_skb_reason() to trace the dropped skb for those two drivers. The
tun and tap are commonly used as virtio-net/vhost-net backend.

This is the 'stacktrace' example for tap when the skb is dropped because
the ptr ring between tap and vhost-net is full.

    kworker/13:0-9759    [013] ..s1.  1439.053393: kfree_skb: skbaddr=000000004109db76 protocol=2054 location=00000000db8dd81c reason: PTR_FULL
    kworker/13:0-9759    [013] ..s2.  1439.053431: <stack trace>
 => trace_event_raw_event_kfree_skb
 => kfree_skb_reason.part.0
 => tap_handle_frame
 => __netif_receive_skb_core
 => __netif_receive_skb_one_core
 => process_backlog
 => __napi_poll
 => net_rx_action
 => __do_softirq
 => do_softirq.part.0
 => netif_rx_ni
 => macvlan_broadcast
 => macvlan_process_broadcast
 => process_one_work
 => worker_thread
 => kthread
 => ret_from_fork

 
This is the 'stacktrace' example for tun when the skb is dropped because
the ptr ring between run and vhost-net is full.

           <idle>-0       [000] b.s2.   499.675592: kfree_skb: skbaddr=00000000ff79867d protocol=2054 location=00000000635128db reason: PTR_FULL
          <idle>-0       [000] b.s3.   499.675612: <stack trace>
 => trace_event_raw_event_kfree_skb
 => kfree_skb_reason.part.0
 => tun_net_xmit
 => dev_hard_start_xmit
 => sch_direct_xmit
 => __dev_queue_xmit
 => br_dev_queue_push_xmit
 => br_handle_frame_finish
 => br_handle_frame
 => __netif_receive_skb_core
 => __netif_receive_skb_list_core
 => netif_receive_skb_list_internal
 => napi_complete_done
 => ixgbe_poll
 => __napi_poll
 => net_rx_action
 => __do_softirq
 => __irq_exit_rcu
 => common_interrupt
 => asm_common_interrupt
 => cpuidle_enter_state
 => cpuidle_enter
 => do_idle
 => cpu_startup_entry
 => start_kernel
 => secondary_startup_64_no_verify



 drivers/net/tap.c          | 30 ++++++++++++++++++++++--------
 drivers/net/tun.c          | 33 +++++++++++++++++++++++++--------
 include/linux/skbuff.h     | 11 +++++++++++
 include/trace/events/skb.h | 11 +++++++++++
 4 files changed, 69 insertions(+), 16 deletions(-)


Thank you very much!

Dongli Zhang


