Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A2F4BCA73
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 20:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243111AbiBSTOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 14:14:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243099AbiBSTOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 14:14:40 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF3DB21;
        Sat, 19 Feb 2022 11:14:19 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21J9hcDk007169;
        Sat, 19 Feb 2022 19:13:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=t1ZVWrUzSiDnsjR/gi8APfLBNWcGZy+/MwDX+ODbbr4=;
 b=T6N0BGEaBM+Fon9kmHMS7XJci/t5gbVpihXxU4xpxbsTY1D6ekNextEApst9AP/O3v/m
 Q3AamttF287vK05f4089SVtonxJxLSRqtUjggow3qtK3/SskGh894W0r8v9ivDnVwt9M
 RB9Onjo9/svfxGxM/WhiTmS3CwXiKs5BVHHPBHDA1w7KTDy0OqMQx6lYco88pM4SSbho
 xWmpMvlgSTlciaI5yp3hlZll4LCjTjJbcTRbz4+tUyU3nVJcCrDSan49ptMAecibKnGo
 wsiQCNRKz04GgW2Qmvy2RHBrqlem2kTm1xshHh3LS4l1s+hLVjTe0suAabShvCqt/a0h gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eaq52909x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 19:13:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21JJCIxd025071;
        Sat, 19 Feb 2022 19:13:10 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2042.outbound.protection.outlook.com [104.47.73.42])
        by aserp3020.oracle.com with ESMTP id 3eb47x39mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 19:13:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C5ute89JvAl5n0d1i3S0tUZ9mSH3RWOxR198RD6UtJCju1w3jhwNQri8xwRIvfAgRnJVpCdp2/2zVy3TMA3+N55aE4ZT+VoGB9W862nk/B+uaF9pU77e/pRKkag+nxMFNDy/fA6hlQlbPv2fMhINVFkwcS1Dt633Y6RL7FtFdssL0Zlmwl/KgpXkZcJtU5oDFR2EWftZkaGNFZfD/+4JZOHhqUxXMmVE2UiMj0xS7oXKifrcQrtT4/hvB36PW+90Ip/XaN4Sgv5HVPUSnXTjv4+5b+o5+xL/KCNe3pOw4kKPw1HyaDGkGk3u9wH3eSGWuVQ0swkL7HepZNuimSwIaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t1ZVWrUzSiDnsjR/gi8APfLBNWcGZy+/MwDX+ODbbr4=;
 b=KWQur9uYYPPFIDbg/dmjs5/gBCIRMXF0a0Erwj9CHiJcpd5mQdUGAIk0Piy2GgRDj5fY7URiwoBPe7/KskPejZKTWCzs2ioSt+Jc8/mn7ZxmDNwvRZub13grIEYxI9x0qpBOnD3hq0kQEL6p3aTRyW3FH1AcIOz49MGD7Q8gm5T9FpfhAAmNJXmWGLdgfsTRXM6S6ha/uaRBM5AxcACJb4JWqZI+dNiPGZr6iXzVNuCPlXFo1na//CUagNPBuZYcMfv39cnN7LDjaQlhw85W6MZQXb2KtBYki6REg42I7yvgDREEYlyIReeGjgOVnt1w9pZkhN3OKpgawcWLmb/s+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1ZVWrUzSiDnsjR/gi8APfLBNWcGZy+/MwDX+ODbbr4=;
 b=gG5s+SxZtJRnQmmkglXkJjittm9akRwAS2Z6hDD+dstsTfDP44bmtu09LM600IM6LHgtthIfn7lYaCqC0QDf5cIG02jS2IxU2k18lCtTZSW8C4oCHQr2YeB3Eg/ZTQ4h8FucPFGY3toogZICNlS7jWqBXF6CjTWNze2m66/kWvs=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SN6PR10MB2928.namprd10.prod.outlook.com (2603:10b6:805:d2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.22; Sat, 19 Feb
 2022 19:13:08 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.4995.024; Sat, 19 Feb 2022
 19:13:08 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH v2 2/3] net: tun: split run_ebpf_filter() and pskb_trim() into different "if statement"
Date:   Sat, 19 Feb 2022 11:12:45 -0800
Message-Id: <20220219191246.4749-3-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220219191246.4749-1-dongli.zhang@oracle.com>
References: <20220219191246.4749-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0017.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::15) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9661b79e-467b-4a83-0475-08d9f3dbdd14
X-MS-TrafficTypeDiagnostic: SN6PR10MB2928:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB29289D62283DEBE95C1BE06BF0389@SN6PR10MB2928.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: msMkrrsu8jpIx6+U2zXabB3zOAhGWeVMfAAAoL7xBtZBh7htwW+40QiBmN8CGn3O2P5ZPSZGdhfiNQ61c0V29TYWQxheuAhVavP4+jEghjClWtVuwT3cWmfyI2yfOdWdsJ0e1gBsLZwLFXt31Mlxlk/fD4O+gcBqGZAmxRPSWh3AYfO+p8HG3mwOz4YIaV0AiXZjz9uHq9hNaP8HFqaThfURj5U/UvWpQj1XSbEbf3ldinW3nQjGamVDiYkU+REfGrM0FvWei8n+F7Czwjcutx5yx32YCHr2YKuRgYvFq96PNZt8M+2S3jM5KSxRM9d5zyxyHMuJEuqaaQGZFH32XHogthJ/Lb/ODs3BDd3jQs2pi8xlOcfvU9iupGLNHl7cT1BWE+wIstQYR7ezehvgqeLfnLFpoRVaKfq65cGhIwkoDebTAEXubgimlNJ8Ryw1JDPS6iElMFkmFxEfAQB6llPfjGlvwz6zeAGhtvTmHazCu7ZGpWJEQFCeb+nrOdbMq/yEypJnjwQdxUBzL9dboVWujxc/3LNfpQRbxccMQXCtlRXtEOVtH3vapL/hURdSWA07IkZ5PBvhq8dwUOYCR2Qcl4hcTYHvpvaum86rOami1M4BS4nlkRVkFI5QJ+C1K6VhGd8Fl70qCw6187APv9C3hWWCWqtOf98ybKng6MxQf3Iat55X+4wkpzr31MAmW+eX7Satxg5hE1akMJn4rw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(5660300002)(8936002)(86362001)(316002)(508600001)(8676002)(4326008)(66946007)(6506007)(66476007)(66556008)(52116002)(6666004)(4744005)(44832011)(38350700002)(186003)(26005)(38100700002)(2616005)(1076003)(36756003)(83380400001)(6486002)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Idc0q7Cq4hd2ZYeHU63GRlKOl47c/KK3M9KLE2zjUQ/8e9oSMUZ1zBt74gdI?=
 =?us-ascii?Q?x6Mr+i/JogmiBXCp/R1DgMkrVmB4N+tP5ROjCS9bwcSDX2504U4s5so5F7JG?=
 =?us-ascii?Q?JqCPwVcR1Mm1Y5/hDpTzgPFolHx8w+S/djPWa34W2gHAhEmjlBKAK7qBczYx?=
 =?us-ascii?Q?vjyDsna+nz4oqFL0VmjSbeYJl2wTItHvOakPW/tKQUKxBneNhJYvWDmXNJj2?=
 =?us-ascii?Q?B15GDAoYiMMP96oEn4d48Fx8q7+IlTWj7nrEtSyG7OGlTTGYZ90JQI/ZTtoo?=
 =?us-ascii?Q?6oVqaZRunQR8d0XgOUUhPQlso1Sc6RqgVGwgOrI9FM08PPDC2jxZlLy8XGWR?=
 =?us-ascii?Q?SFZ2wK/GH+dzTs9Uue3Bg2E9Ysdcgcb7DQdRAONNyV8Le0nPokm9kgFHaPl+?=
 =?us-ascii?Q?hOwTo3KZLgmY3sbnOT7Ed273ZUoKhRKb942K+DgNK0nkykRC2BGB5sARHdrJ?=
 =?us-ascii?Q?TqWs0QuriEBgDRvi2Zai86BTgloT7Pj9ROome35NnSSuDi5bgxWftKF6cku8?=
 =?us-ascii?Q?bzZ3Ysl3P6CbOK74JkyS1XhYXGLYhP95iogBFAU7x3gdzCdlsM4EyLpsJxOp?=
 =?us-ascii?Q?Xd2hxwAnk0NN38wMUOL5iUMuM5DIy3YsFygfsIIToQik7ZOVEhbAraQUOJba?=
 =?us-ascii?Q?9zPGrSl2vNpzlU+kbiHFFc+wkZ4E56DW5dXuVKsFZP8CCvc7S0BtumUAjGII?=
 =?us-ascii?Q?YZAVRp2qAkW1w9yANz+AomOG2g6l0VhJbs7dc2RoFQuURP4VGIG4gcSkUCuq?=
 =?us-ascii?Q?w+nXvmE3jGOLJjBYOT7zmC+TBACQeDA/n8DoQAVAiofQRsrolc2w7aLCepu5?=
 =?us-ascii?Q?Jlx76pB5bilp923xm4VwUnf95wYeizVoGq8UPcSHYidGa7aUwCzzsO7+9SVF?=
 =?us-ascii?Q?7XLZ2w32wt3hE/5zRHx9xdsjgaAm01+5MFnz2BcpFSUVB0o1H5hZYTkzMggU?=
 =?us-ascii?Q?9OfIkUSk29y0aUIPcruIHV6qHlv7oSWYIQOyXQkU4AfLBsYQfgm4bYCE1IJj?=
 =?us-ascii?Q?aAATFLzhMsT7mWrcKco1glnqUUfN5Y9lgzECAqvPabsxZFGH5czzBbZmwjxL?=
 =?us-ascii?Q?huy2sZ85RFjELMFjDqUtgyB0xpyQnAuLRhbyg0X3q0rZnq1nl1kcEtwR7z+b?=
 =?us-ascii?Q?2IWqr0DE0pY9F5yJEb6Q3BfrWXsnvnAbnxZPpyfjeACUw9sqorZReKkAu+I8?=
 =?us-ascii?Q?nm17FAhfTZ2xAi4DT9R2pZQ2q12NBIYRk5Y9Jr8kKoMU1qZXFT3rDzdrNXsC?=
 =?us-ascii?Q?SQLv8r2iCb9dKP0Nk/zhDz4iVIF2b0hG+07mC8PZ1hq8hJHCZDm4/zyPpCrn?=
 =?us-ascii?Q?3gRyBqQ6q/H5GdDwHQia/xW1uUilR+76OfYApwMwLMW+AADP6SimM2sZW9Rn?=
 =?us-ascii?Q?hLMY0fKD9l/nz2tSxcQnCDOzhNniqLPiVKu4IqB3vgN9om5Bf11bbEYKEPUK?=
 =?us-ascii?Q?/keyAFph/hdgXiF8uNpeTlgmYNwoHrHVvp0W2SYkKdSooq1A8zDR43/aK2CL?=
 =?us-ascii?Q?rhE8oRXWAs74q90FVbndGXt9f1oLn95F71aECzzemP31Ru9qcGdqGSCCHL9Q?=
 =?us-ascii?Q?H/xBIN7F9MQSIUVtgA5OuF0VHdnJtiBChMSQxT7ECzEf48XQ541p56fBa6Lz?=
 =?us-ascii?Q?4kcmmOJoBpn8LjQ0mv/WeY0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9661b79e-467b-4a83-0475-08d9f3dbdd14
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2022 19:13:08.3818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hmhOWF71in6RztrjqSXf5eIDxoNqzaRkhxTAYgVTF6t/feuKUBr37wg/akmwM3YyodPOB/ZLMSPG24Y+XC37kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2928
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10263 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202190125
X-Proofpoint-GUID: cKNk6eqkg2LVANTK3ybO_pOZmeZedsZZ
X-Proofpoint-ORIG-GUID: cKNk6eqkg2LVANTK3ybO_pOZmeZedsZZ
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

