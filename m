Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7CA4EC840
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 17:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348193AbiC3P3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 11:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348210AbiC3P3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 11:29:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7211B9FDD;
        Wed, 30 Mar 2022 08:27:20 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UFL08Q007033;
        Wed, 30 Mar 2022 15:26:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/Gnsr9cLYV1x8NEYFEeoK+9Qiw9F/I5N6q4Z8+erXu4=;
 b=rTsdKIrRsAgca83wSIR2VXuEA6ggEdeHduNdlzVddxkNfD0SjMlVZTjaMO4MSwd6YREs
 CIDnXk5/r11M9ycIge1Z5rIPd6QIZVUQqQWY4G1Wg6Fqp47+B6w98gzt4kQ5JLrkOhL2
 ZdZKYBiHEaMjaRiDx+Py6p6k/NHrnUg4JvjNih74Ht4Z2kv5mTSPGg0TBsb2XYu1tQzB
 CXAuIXqxAqfIlO+ioAXQF60UnZGm+uBGcTwaUcs2nU3tOWKZrqNsgvc6c3pVBRSazUJB
 Cu4XOjQBx77k8QQlsCDvayvn0jgGn4YqGMv//N4jzb/2bbeZltIvDXSldXGgN7cp5a8Z zA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1tes1t1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 15:26:55 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 22UFBKS4014788;
        Wed, 30 Mar 2022 15:26:55 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f1s947qbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 15:26:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gcbfey/hiQ+/a6i7wy8ybX02tuYGxwPCjEPPUgDsExAQZTh9ND5yJdaS8M15VmRM3l3GVuMmeBSTLY8/vyaFtjB5MRcaakRwyC6H0CAfBBUHhuMvFswYNY2ASMg6WOoCuUUclphC0+oE38In+yYuwBaOF3aDTAQ4+Vz/bZPk2QQZikvn0kwf+EwLVy3YDKDhqIoh6gXOIOGipDatnWUz4/vv0H1+ieOnok+Y0UuGnmeAkvnn6ynkbXiobesrVaxalpVEhARTvg+h56cMbgpg3/W/v+PDoQa3GMO/BDofxG6Mazs5OI5Jw8DgPd7LTGvycQeMi6LxHFTxHnkZeUl+ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Gnsr9cLYV1x8NEYFEeoK+9Qiw9F/I5N6q4Z8+erXu4=;
 b=axi4B3bsrXAIy1QeAd6ol2M+BuYuNVTSRh1djQY8Vy9AiJrd9WiXq8BYFqPavsDFjKazOyc0EvzcFzstuZGYVBEN5k13AB62yZKBg22skRMTRIoVCZE/FnUF4HqANCsTO0R9o9FdSZjbQJQH5SYxD21nmzEwuN1QXrO5Sp/YaIjDoI2kTtujPyYyJWkTTGR9rLzDHDWFYwzwvabssFtOsvPWsNtT03tP7aZd+S19Hr2BkTcA6b8oJQqmKKPXxpwyr6tlMz3+0KBlzi8hcIEUdMSvGsebLX1QhNvX3Y1TPiIP3a4fn2xRH74h+tYnOxusvPdURuBGTUjHlu6rbYDgaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Gnsr9cLYV1x8NEYFEeoK+9Qiw9F/I5N6q4Z8+erXu4=;
 b=YOn0FCDYf5jhOWtYhu99O7egIQW9EXxqog1TvX8eZzqrGOdLX57TMCHPmSWEtk6RGuIDBDbpBaw8DyQ5twdxd9XlOuSwU0HlohOvjFIwBOFwcTNq1poWbfp5eIHA86FNIhvxB6vwUxOpz8gb6eWae66kSQKu8Dw5Zj3HnobMPqg=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BN8PR10MB3251.namprd10.prod.outlook.com (2603:10b6:408:c9::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.22; Wed, 30 Mar
 2022 15:26:52 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::1483:5b00:1247:2386]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::1483:5b00:1247:2386%4]) with mapi id 15.20.5123.020; Wed, 30 Mar 2022
 15:26:52 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, toke@redhat.com,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v5 bpf-next 3/5] libbpf: add auto-attach for uprobes based on section name
Date:   Wed, 30 Mar 2022 16:26:38 +0100
Message-Id: <1648654000-21758-4-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com>
References: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0362.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::7) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81d80b1c-2a44-439f-343a-08da1261b751
X-MS-TrafficTypeDiagnostic: BN8PR10MB3251:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3251D7EBA0E617C753AA489AEF1F9@BN8PR10MB3251.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x+DJPCjBTDVE1d43dp4lF56zup1XP9/YZUddRwQJDNkaKrAfGvKJW1CQbR6dDPmrT+k9HDZArn0RB8A4NC+DnjyMxZM3TZC+MSwiKiNQ2/nX9tWDuy8jZosBHlcO5ZU9rMeapKc2e1krkK0BsmbK3KiLYMBAcZG3g0N8/4Kf823j9OTEHQ2QI/+uTtk8jCSu3dk3JL1xTiayvblO8DpOSjh33IiX0MppEkw5d5CEojOuEcVk+sjoJHETKl4sP7PpXFcnf49m4OK5smz97gPSCsVfOGslezgvW518kUmKf804h5beS1w2r7c0lTKczdtubDB6uAv5Y6EeOXFyokAQOfmIz5foqnugnuXb8rJ8o6zRwS1A+xlcTd+YrdtrMH+MH06CX05C5A+cYeve+TNgioz2tm7PuCbSNNhmSbzqZOp7bMcidAmmIpaOtqlDoBj7nn/U9/vED2F9410ibvfUYNBMCqgY6BFEQSxLuLHHHefv6YTc9FEZ6/nC8KS5bB+/kdxQoi9SDM8WKFNdjR7pVtrUAmjysduKOVUrD25nTzKhjLL3VacimwcZkFYiSSvStWpEnVxH9OOYw0l+euKJTELGI7i/7l71ehtq51wf86LtcdHTfXAeTQSzcUEMOZXibrxgxr5l2Qrlgo8w7zE+cpg6veWcIVhjeIkL46L4wqkvxp7ixfnDiSX+pjzHZTg2Pcbj2PS5J/D2na9bzlWmtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66556008)(66946007)(8676002)(316002)(38100700002)(38350700002)(36756003)(4326008)(86362001)(6486002)(5660300002)(8936002)(2616005)(6506007)(7416002)(52116002)(44832011)(186003)(26005)(6512007)(6666004)(83380400001)(107886003)(508600001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vPDhs4Sluw+FPUO+l7OEl/L0w6fd2rO04jisQ6KHx+KXDQc1924IAEyuwhAu?=
 =?us-ascii?Q?BOaYQUDvyS125anOK4Iq8pgxXEXklZdvMbL02zCVe8Ii6Vkic9YoUEUdn23Q?=
 =?us-ascii?Q?bxMiw1ay4WR/kYk1R1ie4tHCzzgdqVNL7DE7QtwdhZPdMbN506r3HMyS+HXS?=
 =?us-ascii?Q?DfjD7l8ffl0GWl34W4T1B6SJYL5wv2jOTG3qV3A4OzEhio4c2eSimFry6ugw?=
 =?us-ascii?Q?L6AfHTk9I21xqsybWeeVOXlvXEhHdG+GqJu7lVGrLXqg/Ll5g5HhqMp9g7OX?=
 =?us-ascii?Q?yh+Ev+Tf2E4V1N71OYGIU01df8cjwG/4HMw/xnuSGBgLeFIk9aPy/+PiqmRO?=
 =?us-ascii?Q?UJ3ju9WHvIZo7Q9/8Z+kIKN87tXqlX4ygxaMxNkVskSuqghk45Mex4cBQb2h?=
 =?us-ascii?Q?Y/tlvPsj+wBm7TmZbpVK1pkEvr+t1J7k9pQGbSLJXaQtnGQKlOz/P2ntgYNz?=
 =?us-ascii?Q?TOAxx1QoCBQRVaG2jizuu88el/kO3GJYqpzkw4+xopc4WHrjGeINiYlnaTxD?=
 =?us-ascii?Q?cBhIWFdZi6iiNlSmJmG4HPF7WbQ2Vg9oG7403T7nNk6RVpGMiCUBHoxAa9VS?=
 =?us-ascii?Q?q3bytQUC2eZPNMyxyr5KQdIOyoUUheqowTSuPiQGehbh8hgRlpWwSl8aF7Yt?=
 =?us-ascii?Q?FnTIj1dk9VtGKGtkn8O7Z7/u3au3YEeE4zRfBr42IO/pCFTigYSO+jVvIoKA?=
 =?us-ascii?Q?cBI6cWr73/9gGpjnpRIw73zVShhQmnNzH1GDG76CpU//nAmM4GkfSYvY0Rth?=
 =?us-ascii?Q?+Q/YcAC0kwt44Zs+fjyuEJN0pv1Lr3qA47aPogaBouBvOGkeQwb4aLDzwL/i?=
 =?us-ascii?Q?KX3wiTp28QLgTtHqRz66P+8fave3zv+8/NqI29mvBR/AsUjN8ujA8EzLE4in?=
 =?us-ascii?Q?HtCBorRzcWjhgNMzNWBjWqZBluVT2sJr/8FRwLaphLu+0FW8Alr4R+E0x8xZ?=
 =?us-ascii?Q?pZkzIWv57zBZfoE78bixWOURFebFBDIOGqCN5qPc0hyyz78ieSa86DY7vrUB?=
 =?us-ascii?Q?qoMiA+IhjVvWDusDBbr3RpEFWLki81yJM8gMo5mQdTcFVkUpBXm4nFufLp2L?=
 =?us-ascii?Q?qUxpQtb7N8gYjSSUsPlP6dev4KYC0IGDc/bvX/vhhmvH1n7Zfdx3hMo8oTE1?=
 =?us-ascii?Q?39f4qnaU0f/CcZt1gmb4sMxjg2mIyeToS/VOJJWYZ88aAz4O8u9PqeyCUvct?=
 =?us-ascii?Q?6Epiddi3y/VRFm+ouUnt1TUTAtB+WFpA0fIs9clKdCDQNFndj5wYERsl0DLf?=
 =?us-ascii?Q?XcA+fnqR7luhrU/AgTNmcZJz78rSXefFVXARQAdsfeYf4DEHMPnBFqsowDLz?=
 =?us-ascii?Q?KdQdTQ1fYrnYkEUZDKcAPz3rzFJbr1Qlo55vBArya9lO4EEVSHC/58XONd0+?=
 =?us-ascii?Q?2A7vLZhLXfKbZzIyY9Gycre2ejtsmkANvWRn7JImsPzjmdNspadvc4Btwj6J?=
 =?us-ascii?Q?WYa7NEoe5n43moufgPurL/DbdqqjaJU2ElF3bR7vSyzifyGcb4Llc5WSCgjP?=
 =?us-ascii?Q?NuKeQQOKgejVTspnHzdUsHysHuG9VbaNrImQWr3LfP+8i27HlcHkhHG1uM5V?=
 =?us-ascii?Q?HQS2VBEEKncO8MMIDo15ReQRoif0VRkHFeCWpiL6QDtt8qjgUkSmd47ghimF?=
 =?us-ascii?Q?3wOfeBdcElHLuKdG4LpKH/LPdbo8R9JcvLiHYdsEgNnsApuw5KT80smqMimW?=
 =?us-ascii?Q?MlI69tRBwCc46WCqmRC81jnbiZdY7jIftV1NHBrLhendhEzajY7jwalu8PKy?=
 =?us-ascii?Q?Ro9lFn0vbTDtqXRsAPLVymd+Ca4jxnk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81d80b1c-2a44-439f-343a-08da1261b751
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 15:26:52.4901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KCfGI5SraAf6QMDMqErhU8vsMV8avwIq27LPI6teRBSK65bzfRpGLn4NrRP4cJAw3FYjUJXR3dW7tWtYhrEoJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3251
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-03-30_04:2022-03-29,2022-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=1 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203300074
X-Proofpoint-GUID: _5X0uZkx3FO68orGRYDzt88oXl9pPMla
X-Proofpoint-ORIG-GUID: _5X0uZkx3FO68orGRYDzt88oXl9pPMla
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that u[ret]probes can use name-based specification, it makes
sense to add support for auto-attach based on SEC() definition.
The format proposed is

        SEC("u[ret]probe/binary:[raw_offset|[function_name[+offset]]")

For example, to trace malloc() in libc:

        SEC("uprobe/libc.so.6:malloc")

...or to trace function foo2 in /usr/bin/foo:

        SEC("uprobe//usr/bin/foo:foo2")

Auto-attach is done for all tasks (pid -1).  prog can be an absolute
path or simply a program/library name; in the latter case, we use
PATH/LD_LIBRARY_PATH to resolve the full path, falling back to
standard locations (/usr/bin:/usr/sbin or /usr/lib64:/usr/lib) if
the file is not found via environment-variable specified locations.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/libbpf.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 72 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index eda724c..38b1c91 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8630,6 +8630,7 @@ int bpf_program__set_log_buf(struct bpf_program *prog, char *log_buf, size_t log
 }
 
 static int attach_kprobe(const struct bpf_program *prog, long cookie, struct bpf_link **link);
+static int attach_uprobe(const struct bpf_program *prog, long cookie, struct bpf_link **link);
 static int attach_tp(const struct bpf_program *prog, long cookie, struct bpf_link **link);
 static int attach_raw_tp(const struct bpf_program *prog, long cookie, struct bpf_link **link);
 static int attach_trace(const struct bpf_program *prog, long cookie, struct bpf_link **link);
@@ -8642,9 +8643,9 @@ int bpf_program__set_log_buf(struct bpf_program *prog, char *log_buf, size_t log
 	SEC_DEF("sk_reuseport/migrate",	SK_REUSEPORT, BPF_SK_REUSEPORT_SELECT_OR_MIGRATE, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
 	SEC_DEF("sk_reuseport",		SK_REUSEPORT, BPF_SK_REUSEPORT_SELECT, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
 	SEC_DEF("kprobe/",		KPROBE,	0, SEC_NONE, attach_kprobe),
-	SEC_DEF("uprobe/",		KPROBE,	0, SEC_NONE),
+	SEC_DEF("uprobe+",		KPROBE,	0, SEC_NONE, attach_uprobe),
 	SEC_DEF("kretprobe/",		KPROBE, 0, SEC_NONE, attach_kprobe),
-	SEC_DEF("uretprobe/",		KPROBE, 0, SEC_NONE),
+	SEC_DEF("uretprobe+",		KPROBE, 0, SEC_NONE, attach_uprobe),
 	SEC_DEF("kprobe.multi/",	KPROBE,	BPF_TRACE_KPROBE_MULTI, SEC_NONE, attach_kprobe_multi),
 	SEC_DEF("kretprobe.multi/",	KPROBE,	BPF_TRACE_KPROBE_MULTI, SEC_NONE, attach_kprobe_multi),
 	SEC_DEF("tc",			SCHED_CLS, 0, SEC_NONE),
@@ -10843,6 +10844,75 @@ static int resolve_full_path(const char *file, char *result, size_t result_sz)
 
 }
 
+/* Format of u[ret]probe section definition supporting auto-attach:
+ * u[ret]probe/binary:function[+offset]
+ *
+ * binary can be an absolute/relative path or a filename; the latter is resolved to a
+ * full binary path via bpf_program__attach_uprobe_opts.
+ *
+ * Specifying uprobe+ ensures we carry out strict matching; either "uprobe" must be
+ * specified (and auto-attach is not possible) or the above format is specified for
+ * auto-attach.
+ */
+static int attach_uprobe(const struct bpf_program *prog, long cookie, struct bpf_link **link)
+{
+	DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, opts);
+	char *func, *probe_name, *func_end;
+	char *func_name, binary_path[512];
+	unsigned long long raw_offset;
+	size_t offset = 0;
+	int n;
+
+	*link = NULL;
+
+	opts.retprobe = str_has_pfx(prog->sec_name, "uretprobe/");
+	if (opts.retprobe)
+		probe_name = prog->sec_name + sizeof("uretprobe/") - 1;
+	else
+		probe_name = prog->sec_name + sizeof("uprobe/") - 1;
+
+	/* handle SEC("u[ret]probe") - format is valid, but auto-attach is impossible. */
+	if (strlen(probe_name) == 0) {
+		pr_debug("section '%s' is old-style u[ret]probe/function, cannot auto-attach\n",
+			 prog->sec_name);
+		return 0;
+	}
+	snprintf(binary_path, sizeof(binary_path), "%s", probe_name);
+	/* ':' should be prior to function+offset */
+	func_name = strrchr(binary_path, ':');
+	if (!func_name) {
+		pr_warn("section '%s' missing ':function[+offset]' specification\n",
+			prog->sec_name);
+		return -EINVAL;
+	}
+	func_name[0] = '\0';
+	func_name++;
+	n = sscanf(func_name, "%m[a-zA-Z0-9_.]+%li", &func, &offset);
+	if (n < 1) {
+		pr_warn("uprobe name '%s' is invalid\n", func_name);
+		return -EINVAL;
+	}
+	if (opts.retprobe && offset != 0) {
+		free(func);
+		pr_warn("uretprobes do not support offset specification\n");
+		return -EINVAL;
+	}
+
+	/* Is func a raw address? */
+	errno = 0;
+	raw_offset = strtoull(func, &func_end, 0);
+	if (!errno && !*func_end) {
+		free(func);
+		func = NULL;
+		offset = (size_t)raw_offset;
+	}
+	opts.func_name = func;
+
+	*link = bpf_program__attach_uprobe_opts(prog, -1, binary_path, offset, &opts);
+	free(func);
+	return 0;
+}
+
 struct bpf_link *bpf_program__attach_uprobe(const struct bpf_program *prog,
 					    bool retprobe, pid_t pid,
 					    const char *binary_path,
-- 
1.8.3.1

