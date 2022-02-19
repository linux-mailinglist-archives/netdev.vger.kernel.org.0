Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD794BCA74
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 20:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243128AbiBSTOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 14:14:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243126AbiBSTOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 14:14:47 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047C41D0E0;
        Sat, 19 Feb 2022 11:14:27 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21J9h32S024603;
        Sat, 19 Feb 2022 19:13:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=F54GROskXjLTTOa/kX4VzAeTyVfJJWVixzTgjiZwsGA=;
 b=LAHXQXBfFBSh+oUH8jAJV/B6tqXQ3pgHVPVZYG4JiTpw8QxPvDM/2Irs8fGY7/1q3A5l
 /tkP5gvzMAdlqjUwfMi8l6wW5IKCw/qCrRMDgvILYUSaIxqZmxdM0nFpZGefWhpZVcMi
 ArNKVovrUVq9ZruokeGS2XOQ4feybk14rJW7smV7EucdrsFcKIwVsVaM3GXfZ0op7K6E
 tLgnBy16+Xd2mRQTxyZlWtVesE/K5Ug69s8kp0pk4NgKFlyLTHQWLER87ePh1VO+rs04
 EtVcoLKuWuP47h4AF9ewG5mHZKt6ESixxwVb/H1TRft123nYtfTDpNA1As9ZpvqE+dTu Yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eaqb390hu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 19:13:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21JJCMxP025236;
        Sat, 19 Feb 2022 19:13:07 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by aserp3020.oracle.com with ESMTP id 3eb47x39ku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 19:13:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJM8NBDDGxmjaxBy4gzZd136OTgAlAEoYVNp0oj5NsC6CfiFf5NWK1tesoaWXhkxh9pSjZPJBDxHdmAXS2//naUxCFuCGufGadX6VVR64CZQMvNsJczhmpkzOXyfLjuyNPRzbKxEyKr3Wdg8WMEMs5EZF0PiKd/IYkKmJiawTQQmRI4U0/+Nf8Ym6/nNdsnNAnFQSl3aMQ+NUPSH0T5xC29epP/RMhlhbny3F5aBkTRScrpTmQwERiiTZTyAxQSD6HSbtD+r7I2o6K9S43vR5rsi3pVWiTIhz23OcorkezUbTE0k4rG5Qew53RCtrxC+g/PQM2iTc5uYk8/0IxleFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F54GROskXjLTTOa/kX4VzAeTyVfJJWVixzTgjiZwsGA=;
 b=l866xBcReSEH0Hu1TO9uJaqY7mzYRUsI+hocB8fL+Ts6S7HslXP/yPjad0JxzjOVruMKHj6uEyMDSA6J0tYQwh/6wK/2NNMPD7wf46g0D6A5XVt6GYanvsxgmLMgwHX/GBSrnbm8QXgE0+/YEJvTbtIrAVgiowROcV7LIcYB4WHbMzQjM3/sJvbgB6LRTfCQw2CHedz9vgHx3jBT8XlThEVTOZqXvsq2Mgp7WFtUeipv5UCC6g0h1p2w7N89j2eWiw27V1BcSkmYvdbOCckgQHHvHhfMpR+kyTX5vUNTC/delNSA5MhpcfXOembObBpO/O0yYrQ9lUdCaPkmJSKU1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F54GROskXjLTTOa/kX4VzAeTyVfJJWVixzTgjiZwsGA=;
 b=MRJW+buFOW0UQ++hDDcITE0MZ4GEbwWtMrqd1d3Lk24VkwQsZdlLZU/p1xXUHd2LycOSPpWUnMqPREF6xXISuiJiVChciWEJt3hnzVfg8U6WSeoH/TIX+qQ95NT1v/U1wus65PQtBjPT3IAnbggOjGxpdFFgSRqwYzrrp9TmRto=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DM6PR10MB2539.namprd10.prod.outlook.com (2603:10b6:5:ba::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Sat, 19 Feb
 2022 19:13:05 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.4995.024; Sat, 19 Feb 2022
 19:13:05 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH v2 0/3] tun/tap: use kfree_skb_reason() to trace dropped skb
Date:   Sat, 19 Feb 2022 11:12:43 -0800
Message-Id: <20220219191246.4749-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0017.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::15) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92b2952c-7d67-4026-7657-08d9f3dbdaf4
X-MS-TrafficTypeDiagnostic: DM6PR10MB2539:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB25392C1A17D7827542E8B901F0389@DM6PR10MB2539.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7JnydwNFv63a+EwOPbbK0u8Jjic4kGq2SMYjK7xwiama5nP6zDoIL3WvD+3fKN5xroR+Bz75QbNngz/88Q9q31I5Q1OgKhsF6Wq5WX/bfaXwpZdC4St684wIlZJf+rP/1+76O6cnzD5lYHJMGeqPH/dAEbFs3RyAvNBcdDf2VTYwHirtgy+Hn73M41I5DfzcGKrvWCAE7rQJ3sKFV3tCydDUxGvjFmSLWqJiRxm5yVcku/ykeDbW5f4k/t2Ntim3YPjefffQrg5cRBGVfT8Mdarwujuz03O+tH+5k/UX9u7fYhQAPgylyj87KMvhMkpwLcEXHvOaE4L+stye3120DkD5+8t0ktURfrp/08BXv5E8ojci5YgWiPeV2wW6ZeEuoD+IFG1DwoL03EqvGwqoEzwIBpgo6A+rIO3EdMGJr9J8hernBg199jj2CwIXS3qRFxzOeJfEG4E56OJk8QHh4wyV073Qb1341lXzMlQYdo0AXJ5erfPe1Lky9ZwLGlLqZeoE5/ozAg3OoGgah3sCOfe1Uf2gcgJ7+eSv1yLeh6YuQTvHBOKA16JzSgCgHQyrL+6p4W0E0Hb/1QZISwMrCCQxuwtI4TGz2958HX8F2P03LQD7tK0n/0Zti2xVLPshWO1ARXoi7PcDHPnDETgrJ4L8kuHPip2gxZsSc1uy3UlpfMxmIEXsgq4Nkwk1s0Fqc662v1uPxGz7AgqkT7VR3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(26005)(66946007)(66556008)(38100700002)(1076003)(66476007)(38350700002)(316002)(83380400001)(4326008)(8676002)(36756003)(6512007)(5660300002)(8936002)(508600001)(52116002)(6506007)(7416002)(2616005)(6486002)(86362001)(2906002)(44832011)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DogjQP6fw31j8Kz2U6dlnkXlfMlwkkuTxGZH5dOtiqZf8QZIZcjEHZNpWTw/?=
 =?us-ascii?Q?lrpFKZ9nIZ9UO6Z2QResbBsjpGlT/PNPeXH3VB5tXqWWJ8W22EUJVN5EPQz5?=
 =?us-ascii?Q?DtOPtRoSU3kFdkj4xWGDnHPg+yyAXZcNh5tcKy8lHcMuwSyTnB6SQNKEuI1o?=
 =?us-ascii?Q?TiD9nDCMXcwL+O4ndVJpawwdPGX6ZWbPyKLxzop8GlWNUfuMt6Ytvj+aRXg8?=
 =?us-ascii?Q?EWMz47bTDyZ9kYtsdn9nmwD/iGzfBaYONcI3bivqrB7PoIDzUfaRjlln7vxB?=
 =?us-ascii?Q?b3sx5iQZf6gYsP6LjHBCwpsO+JvlVkD+rf24oLyHBtrN1JtwKIwVi/ZLjRKJ?=
 =?us-ascii?Q?tqBufuQeY/OrhbyE3Cq1qDywUI7Daomn6ayZLsOTs8bVsMBPWUSuCqCEUg1f?=
 =?us-ascii?Q?qUMER6ff/uuYiiDol1pb37xtFo6lEImgvz86pZuLOAAOlae2WuaK2z4XO9I4?=
 =?us-ascii?Q?36y6WhDCq8bCDa9IYYfCk4yNuCAhEXhYPedsuFMnTvDodxZdxC4sbgW8MwsY?=
 =?us-ascii?Q?2NGTTfxJoqXUKM9grm+p1nkBZA00ZAT6YxPpGqCbQXOH2Ba25BOwArcjQ+K4?=
 =?us-ascii?Q?kMyac6ardH3JXMUhFl+dZL2qqiON6OnmkPsjF/D7UlkunmfSxtc3ZotkUuN0?=
 =?us-ascii?Q?22Ih6ahkAo/98Hnj10STL/18rXtQ5ty9gfikq0NtYOIh6V7/xgjK72mv0r62?=
 =?us-ascii?Q?qNCNGkmt412jdSnv0oQCyOCeDbQMAfLt0ZE/lQrmyTzIvvDocVRT/TfjfodG?=
 =?us-ascii?Q?Pg2k0SYNJ6GQCUrAElxEhj1WdCx2uQscxwV4zoppi+oeKxZ2yiAH5WKATavR?=
 =?us-ascii?Q?PNkd3nNkpVzJi6Aubk4zd+UpSHAB5AXCM/ZlG1VVnbvrTo3ASqq22V4f8foy?=
 =?us-ascii?Q?VzehxjeFpMCq77iL8yWqz85vt2i4c1i/0eB08BPlGBe+4VHdP3INrn4VyCbl?=
 =?us-ascii?Q?9rHHv1sFTHVwv9TAt+c2UBrR6FP3vzOim8xyHNcfJY6DoQCCyeFCpKkyjP6g?=
 =?us-ascii?Q?BonNwMARgP71cxaTohr+c86P88tAwcqCzvUesDh1fOj1qdn0jy5XLVd+o7IS?=
 =?us-ascii?Q?zNWdnr+eUxPK/KSUfKKRR+aswNUSCJ1eAQA0ceNxcSv6mcwdeOtkVSMv0Fw9?=
 =?us-ascii?Q?1tQ77jburTlXrGS3Iznn6ww/98UzYdmIUfbQ9I2MSa8uSEj2ZykLEFXBMIGF?=
 =?us-ascii?Q?bjI7i7XrU+dYwYJI1qhozmR7ymnIhjWn9g0iEPdb5/l3Dq9OQQ45W0iQLiRi?=
 =?us-ascii?Q?hDDrf9udplyHCK83JPPphJ4/DuUTaIycSgFfxVc0qO8n2rIcWqkRVzdm3fig?=
 =?us-ascii?Q?U3ZB2bKx8HR7qxD8dO+ot+vv7o7XQxEAoqq1ezbssnh+8wxOzbTRFERevZhB?=
 =?us-ascii?Q?3GK6YlLa4qxWIy3eZvQCVPvgVznjWhkdxDkLXe+ErdVVLa2lBSBEB0P8CkkL?=
 =?us-ascii?Q?ZCJqKPqhu7TzNEvrc9ldFgadWdSDTMW6WX+FQGcSloRRkKJ5PYTqoGNpi0b8?=
 =?us-ascii?Q?wXLc0PMd3e+iy2UL1LA5/oYJJ4qutz8Ow1qeTVNAhiZFMCU0co6X+HlF0fYq?=
 =?us-ascii?Q?iDAvz7TkSpZagF2AY8UBIMltivVoTWmk/6v1N7vP46ZKkyHxRz6TinWa7Loh?=
 =?us-ascii?Q?9GtgW+iGAgS0A1QiOi7ETSU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92b2952c-7d67-4026-7657-08d9f3dbdaf4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2022 19:13:05.0383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UAanYGFy69Ri4fNyZfRxwb2dooji6OT/EcUfaMWn46HaSL82Tmau5PLeLy4951bFvQZR6dpyhBSLpsUHVd9SFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2539
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10263 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=813 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202190125
X-Proofpoint-ORIG-GUID: t2jiQYAWkiO1Ln_6TyWuNjlwEiRiHAKA
X-Proofpoint-GUID: t2jiQYAWkiO1Ln_6TyWuNjlwEiRiHAKA
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

I have renamed many of the reasons since v1. I make them as generic as possible
so that they can be re-used by core networking and drivers.

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

- SKB_DROP_REASON_DEV_FILTER

David Ahern suggested SKB_DROP_REASON_TAP_FILTER. I changed from 'TAP' to 'DEV'
to make it more generic.

- SKB_DROP_REASON_FULL_RING

Suggested by Eric Dumazet.

- SKB_DROP_REASON_BPF_FILTER

Dropped by ebpf filter


This is the output for TUN device.

# cat /sys/kernel/debug/tracing/trace_pipe
          <idle>-0       [020] b.s3.  2317.035738: kfree_skb: skbaddr=00000000feed21ec protocol=4 location=000000003e0b7d3d reason: FULL_RING
          arping-7078    [028] b..1.  2317.065261: kfree_skb: skbaddr=000000003409d3c3 protocol=2054 location=000000003e0b7d3d reason: FULL_RING
      vhost-5409-5422    [001] b..1.  2317.818647: kfree_skb: skbaddr=0000000004b8c03a protocol=2054 location=000000003e0b7d3d reason: FULL_RING
          arping-7078    [028] b..1.  2318.065336: kfree_skb: skbaddr=000000003409d3c3 protocol=2054 location=000000003e0b7d3d reason: FULL_RING
      vhost-5409-5422    [001] b..1.  2318.845315: kfree_skb: skbaddr=0000000004b8c03a protocol=2054 location=000000003e0b7d3d reason: FULL_RING

This is the output for TAP device.

# cat /sys/kernel/debug/tracing/trace_pipe 
    kworker/19:1-243     [019] ..s1.   922.639393: kfree_skb: skbaddr=0000000045a155b0 protocol=2054 location=00000000f88b4996 reason: FULL_RING
    kworker/19:1-243     [019] ..s1.   923.663398: kfree_skb: skbaddr=00000000ff4e054b protocol=2054 location=00000000f88b4996 reason: FULL_RING
    kworker/19:1-243     [019] ..s1.   924.687351: kfree_skb: skbaddr=00000000ff4e054b protocol=2054 location=00000000f88b4996 reason: FULL_RING
    kworker/19:1-243     [019] ..s1.   925.711294: kfree_skb: skbaddr=00000000fb75a48b protocol=2054 location=00000000f88b4996 reason: FULL_RING



 drivers/net/tap.c          | 30 ++++++++++++++++++++++--------
 drivers/net/tun.c          | 38 ++++++++++++++++++++++++++++++--------
 include/linux/skbuff.h     | 16 ++++++++++++++++
 include/trace/events/skb.h | 10 ++++++++++


Please let me know if there is any suggestion on the definition of reasons.

Thank you very much!

Dongli Zhang


