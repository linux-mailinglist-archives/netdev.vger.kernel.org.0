Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627684BD578
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 06:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344594AbiBUFi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 00:38:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343958AbiBUFiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 00:38:23 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4996940A1E;
        Sun, 20 Feb 2022 21:38:01 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21L5OiH2016401;
        Mon, 21 Feb 2022 05:35:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=Y68ZqUohIQc0hRxJ93YHFLU+KGjFgAMBNJbG6MgMcXs=;
 b=zPA1UF93AcKCXmeTWvMYES8mJryunGbpk6tbOyA8/LAmmynh3wwdrGvxvDRPne3ABUHj
 rOgXYhpXYEj2oRM5bD1kZt+J4dDtRNS52oxGNw4dRvLR9E8nbkamfodSFGOj9r1doJ4R
 x3C0J8ob05WYG82ke6sMS5AGXTHE7sFp8y2NdvnkTI7Ow+XTEPqOB38dFUJBsEP0y+JG
 y++DLwHhe4i19YoOwzJp4onYQstRZCanXWShX/IxCTNiYf6TjmTYaxNwNeCvRwQeI0bX
 YvY3Wk1NXJ56kvqtrDWuRCH/+JsZx8SlyGANEQ+KLniASyH8S1Hn/KTRYqFxkAv5wty/ Zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eapye33hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 05:35:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21L5WNA2077278;
        Mon, 21 Feb 2022 05:35:14 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by aserp3020.oracle.com with ESMTP id 3eb47y8ntk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 05:35:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEYjBWlsOWv87a9eL23wyZTRPveYVBnnaQSVHmp9bpZkX2MiAULKcis577s7B0xH4xs2b6C26OhOxMRV/ezaJpu3v+8AUMfo/kRQwGpaQRZ6uw93Rp/a/2hRluahLIMqtHebGrT5BwnGD3DIpbHfYYY7AwfRYF7So3luqzLAwYp1+iRFILBvS4i4xrdkcvdcEjubrKlDn0t9oMaF8h60dQNDe7pcr8TISD7GFOs61aP9OtlX3G3tcMR+GGyozDU3JaYXal/AgZpCIVLobFGlMHia9AELBioIFbQHj8CsQHPsKaMCYDyL0rI8Dn/Jnaawt7ZlGtphDdhtC6zLYrGkNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y68ZqUohIQc0hRxJ93YHFLU+KGjFgAMBNJbG6MgMcXs=;
 b=PV2Xqj37gAkgf+XJJUt1fpi+CNIZijolB0Io7uEfRTWjdoqYIuZO63+cUNstIPRQ/kj2Et23havnujlsU/AuLTzO3H/hcARE4dZ97Pty9M11ThaRAGFezP1rw18h1mSnQb0ZhohUnUsmfj9mpSIFnJ/O7m9sdHHio2VcIAzyHKZ9jUjiOZyRiiLUpig7pP3A8WEGN6mZsTJlKw0WWubiMNzxW1+bYYhSS3NoZRIdTWbSLJwIKsnLo2IbApW3sIpsecKYDmTKMJuSBQ/2c32UyTKT1egwgLheaG2/qeAwARgyp/xSDbd6kscc/ja45eU0sMOHrnjawLp0OOf9dvKl7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y68ZqUohIQc0hRxJ93YHFLU+KGjFgAMBNJbG6MgMcXs=;
 b=i8E4i+EoZocvkON6LZawHB1NzZKTIxeB91t9nDVX1S72MfR91kuR8wNFocoSaFbFAAnIt9p5j4F5RYjYN05gjNfQ/UAKtwZXltaeHOkyBvmt4vmMDYHMyWP8MXOpdiBvP6OOKkQqOYI04gmzJFni76/rAokhc3+TTZkTZ/1nvF4=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by MWHPR10MB1533.namprd10.prod.outlook.com (2603:10b6:300:26::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Mon, 21 Feb
 2022 05:35:11 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 05:35:11 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH net-next v3 0/3] tun/tap: use kfree_skb_reason() to trace dropped skb
Date:   Sun, 20 Feb 2022 21:34:36 -0800
Message-Id: <20220221053440.7320-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SA1P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::21) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 236d8261-894b-44f2-ec7a-08d9f4fbed7e
X-MS-TrafficTypeDiagnostic: MWHPR10MB1533:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB15338E7C8F30DFE040842295F03A9@MWHPR10MB1533.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WrrutXBnvvwy54X7PkOoDDwCDd6cTIyL1c0xngPhlbjl0eE4tnc566K8Vx+bDE3P1v6Rxoq/NKrGrG83X+ukWg9smC68JM094it5xXiUoDAhnj0Ub+ThcB23zPGYaZ1V8ONmRsSZ1XOZ4L0mUo3WHYpZEiYlxxxNePuG3fEUZ5GuTdqbmfauRZIomxduQV3+wz0sGRa7mrSaAS3exF3uemmG/cH7z1OkSNxA5RhaolyGw/bh3jbJY5djr/7f8UI4Vj/h0pwMlbHnxh12W3RQOt1WAmoFHrTnT/iUnLtnUABwtBDuNY7/2H5L9HDuJ5jOagIvKVaPRizjzovOKoMMcr+DaSNPBYAEouRPxFtyuQRJjgRrHaRBJUZxVFOcGU4Q8PH+GLtM5ASsAhFKqVIS6qhpv5oWiCmnEuyTi2jpVSj5gb3lLk4ZW2KrWEYAxKX4F5RYWg+Wn5hJsGw4SyQbueWzHy7ib/Gw2WNgQBi0pt5fGa2MJ7o1je7ZY1xMCwSJ5S6v3kTa8T6HlwomGPGoHXOS5G3gose1O5JiEDHdgHW/yRpnS3hptIXf4D76m9GEMYKCU+O9tNFPWnX+RAYnuj6ibUsD0EY607Ju0OxOGf+Z9vAtM/8a6/s0U9TXe89TMHwYUZWLZTOaBOZ+53Sj2kOHYpXihIs2EPl9eqvLhIaLJaaUxkSik34ctbQQJk+4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(38100700002)(38350700002)(83380400001)(36756003)(7416002)(44832011)(5660300002)(2906002)(8936002)(2616005)(8676002)(6486002)(6506007)(26005)(52116002)(186003)(66946007)(66556008)(6512007)(1076003)(66476007)(6666004)(508600001)(316002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qnhY4Suz8IS/0Bbs735tPyS/rrrf3TAQNMKw8841JnbTJR1yerOgeR9iC8lP?=
 =?us-ascii?Q?OK3rmgQeBX0vyKx8wkxKUgKncZznjomzecUa0SX2P1c7t5xDNPBweagH1rXU?=
 =?us-ascii?Q?kGFp0ml9989wjc7l37eRWgC25TEKQ7D6JoG/q1QkYhItId41NYAhPywBFCJ3?=
 =?us-ascii?Q?Vnteqz8lUnLGgMLL13QG0703NYnXn7M/Hn0+zufD7VlVBRqbpfUAjE3A+wJr?=
 =?us-ascii?Q?eCinc6yFk9TKsDkQdXXDW4Z5z8cAWHR5fsyiqJimW0Z5JpVeNsXrHuSLPjQK?=
 =?us-ascii?Q?MszSDZX6i6lwrWi9csGbmQ2xeRT/xO31tQnNVtKrKf9PXQn1Jr4aK3oK8WWS?=
 =?us-ascii?Q?GWAtHupRYzLKauewiFKx5x1Kx7gJTeDu5DXVNT/eDBfAIE/TlVaUJOHxJb3I?=
 =?us-ascii?Q?Ybb6zJ85B/X9ufnkvKOQmWtFs4KdAiqr3TOPcJJU+T938F9B6YreIk+RWGLC?=
 =?us-ascii?Q?OGLNKLTgG7ZGmAdZIEjQCxUbF40P+yclt08P6obbWVypzDfgAuB56ams8fBw?=
 =?us-ascii?Q?uP3QHI1McOCzrqhGmwxSHGTjR9zSvNy0jEBi2KhAgeCYEWm9X6wPQhMS3DIu?=
 =?us-ascii?Q?1pbCP8HczkvnLWHy5XRSD7OK3Iu8Y2OoZHiYEGHaQTBC1m18xva4Y2Wki/g/?=
 =?us-ascii?Q?A4CSxwBxW5TAtQui8WnDrjfeV/gftGOxFSM/oeebHa3SndaRFU+ipnH0+cR2?=
 =?us-ascii?Q?U2rfTNWkDjWNmnB/jpsawl3mf7B6MNdJ9wvgqpop8kTWSqVz7WbxElIvYjDB?=
 =?us-ascii?Q?Bil2gGjkzGRl28G6B3ix8boiNK+3rBFUlTMpm2/qL7qvdYUfZ35o8JAAbIeu?=
 =?us-ascii?Q?XBTkC+NO4U4xNjgc1JEKLtJuYGEpkvjMMYLt76ErjuGFc/4K5rQAxpyiDQST?=
 =?us-ascii?Q?66blHFS9xODM2uGVBgAF3EByYXncqwfDAm3di84r2Ck+3z8gAK0ZOcUE7UlM?=
 =?us-ascii?Q?BhWhx4wB0WfGvDgdT8aTutk3G9QSfyC6NotteYoLbHIzgBAiDNqShwWYR8Yl?=
 =?us-ascii?Q?qSrjb2EUj8/Levwzd1X6VECbOI06fnsXEpsqOZOzKK7SUVZIZ0U1efcMbhBw?=
 =?us-ascii?Q?e94OtKD8sN575qYQXSxq4dWfXlnzoes7IF7X/W+9mlQMCXZLVv8E/skdx4HW?=
 =?us-ascii?Q?aLt53xOx+MohfAOQz7TO9WNnKhA+v7dK8jYnRD/DQaNfBDd2k5BxrANpmH2I?=
 =?us-ascii?Q?n95dPgp1Ho0Ih4XBBvoGLjlV5WbrnWDkR3dv+2124BHH7jsdCejtiSZu2p0Q?=
 =?us-ascii?Q?wvC5cMGqemq7/+2NEWWYqDRNDfx+CjpC4LCMFhnHdbketS0ZD2JuEfdjTj6q?=
 =?us-ascii?Q?qgmXyeNzNHWY9+I8S1U8kcNkV6ecH9DUs57+qfqPS32Z27Fg5qgHAkA5E3B8?=
 =?us-ascii?Q?lymxV795vaQ9pllw9NHhbR7aYaWN1F53rBWMnCuZOfT1PHqA07pgQXM3FnC8?=
 =?us-ascii?Q?L+stMbPdICsUcvXZjGpRibXZJnXak8XUIqPb1ZY2+xJDeH73gSD8iPQUfhuS?=
 =?us-ascii?Q?56UP3YlAFMtN7xsziTgoLZnC4+DmmDpqvac5oyKA4jJs24X+5omcgRkAOlfA?=
 =?us-ascii?Q?59xb+5dJtZ1K69OmFyvLsEYJNxinkZrs/OjyqTAkOImvWxSxZMc2iXvFZgyr?=
 =?us-ascii?Q?j3x5LMh/0xh65oifrMtnHwE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 236d8261-894b-44f2-ec7a-08d9f4fbed7e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 05:35:11.0622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Syu++M5BwvjLzITNQmB3PMSwW+c213WXbIWe2221s5hQqgkzRvbuwY8mnCgDOXHCepIafkCLLfA6zyLBSnobbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1533
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10264 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=955 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202210034
X-Proofpoint-ORIG-GUID: oTosf1OsjzxId_RKwUqqgDEAQZm58-4e
X-Proofpoint-GUID: oTosf1OsjzxId_RKwUqqgDEAQZm58-4e
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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

- SKB_DROP_REASON_DEV_FILTER

David Ahern suggested SKB_DROP_REASON_TAP_FILTER. I changed from 'TAP' to 'DEV'
to make it more generic.

- SKB_DROP_REASON_FULL_RING

Suggested by Eric Dumazet.

- SKB_DROP_REASON_BPF_FILTER

Dropped by ebpf filter


This is the output for TUN device.

# cat /sys/kernel/debug/tracing/trace_pipe
          <idle>-0       [018] ..s1.  1478.130490: kfree_skb: skbaddr=00000000c4f21b8d protocol=0 location=00000000aff342c7 reason: NOT_SPECIFIED
      vhost-9003-9020    [012] b..1.  1478.196264: kfree_skb: skbaddr=00000000b174fb9b protocol=2054 location=000000001cf38db0 reason: FULL_RING
          arping-9639    [018] b..1.  1479.082993: kfree_skb: skbaddr=00000000c4f21b8d protocol=2054 location=000000001cf38db0 reason: FULL_RING
          <idle>-0       [012] b.s3.  1479.110472: kfree_skb: skbaddr=00000000e0c3681f protocol=4 location=000000001cf38db0 reason: FULL_RING
          arping-9639    [018] b..1.  1480.083086: kfree_skb: skbaddr=00000000c4f21b8d protocol=2054 location=000000001cf38db0 reason: FULL_RING


This is the output for TAP device.

# cat /sys/kernel/debug/tracing/trace_pipe
          <idle>-0       [014] ..s1.  1096.418621: kfree_skb: skbaddr=00000000f8f41946 protocol=0 location=00000000aff342c7 reason: NOT_SPECIFIED
          arping-7006    [001] ..s1.  1096.843961: kfree_skb: skbaddr=000000002ec803a8 protocol=2054 location=000000009a57b32f reason: FULL_RING
          arping-7006    [001] ..s1.  1097.844035: kfree_skb: skbaddr=000000002ec803a8 protocol=2054 location=000000009a57b32f reason: FULL_RING
          arping-7006    [001] ..s1.  1098.844102: kfree_skb: skbaddr=00000000295eb0da protocol=2054 location=000000009a57b32f reason: FULL_RING
          arping-7006    [001] ..s1.  1099.844160: kfree_skb: skbaddr=00000000295eb0da protocol=2054 location=000000009a57b32f reason: FULL_RING
          arping-7006    [001] ..s1.  1100.844214: kfree_skb: skbaddr=00000000295eb0da protocol=2054 location=000000009a57b32f reason: FULL_RING
          arping-7006    [001] ..s1.  1101.844230: kfree_skb: skbaddr=00000000295eb0da protocol=2054 location=000000009a57b32f reason: FULL_RING


 drivers/net/tap.c          | 35 +++++++++++++++++++++++++----------
 drivers/net/tun.c          | 38 ++++++++++++++++++++++++++++++--------
 include/linux/skbuff.h     | 18 ++++++++++++++++++
 include/trace/events/skb.h | 10 ++++++++++
 net/core/skbuff.c          | 11 +++++++++--
 5 files changed, 92 insertions(+), 20 deletions(-)

Please let me know if there is any suggestion on the definition of reasons.

Thank you very much!

Dongli Zhang


