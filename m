Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091154D614E
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 13:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345664AbiCKMMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 07:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345125AbiCKMMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 07:12:40 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CF914EF68;
        Fri, 11 Mar 2022 04:11:31 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BAsIEZ005961;
        Fri, 11 Mar 2022 12:11:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=6D7nt7OzBOEA4QTwKj2un6TQjCBXMl3jObir2mlHN8U=;
 b=dy21cfRvQM9DxQoEGZulA64M4h900YOr+8T0cdT1l2jpgpu7PBTAnnujH6dz25YiRscZ
 0722yCmplwBTxs+1XR3CB3GQQuVXyFWvVGNMu42pM+rdId+EEraCUrVXH3CnpXtb6nZQ
 jLvb1jwDRivtYEIww40ngYTPVrm7Df31Yat2rVgfGgoeUvaNf14ieavjVgZH0quH6S6u
 1yWmUbiHNRUMsg2Tc8qh5Sapmyc2XQaMnSCw9upZ7tZu2iL6DsXc/N/UAPYEKEvUDgsR
 xT7wbhkG31DmDbE/h51YXFg+TMFOWsIk9B365ng8DDiK8a3ZB4GHQ1CStK1Xrez3ZpVe Ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyrayw5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 12:11:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22BC1obu034517;
        Fri, 11 Mar 2022 12:11:11 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by aserp3030.oracle.com with ESMTP id 3ekwwe2s0h-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 12:11:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T93UCjfPYxk00G9X+3yf5DYCcjRgmH/tDPT63ME6olxkj5Ux+/pSbKCy8fV0KRS3EL1FLASN62mNHJfnVcHHMfRFZHaoFMtW6UjkBsLzLDetss6+qkdFElnjqDW/TmML0C+OF/bZex2DCdj797EmEvYWWIvWLThe08TVOzYv7jZKH8otl3ZEtb0HpXV6qM9b2sGRuWTp7a9qqJgU0dCP5oRVrnld69+LXkV7UlIuAcOKipEvHAl6GkVjnn1ojgeYEpg4EaQ1HSji9xgjDW5R0uYI1frAtbRjN0QQLvkl7dFVcn1wvRuD6OFb6zY/p8K+jBBhBWtMMi3QxixSKaiiig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6D7nt7OzBOEA4QTwKj2un6TQjCBXMl3jObir2mlHN8U=;
 b=VWlwrQq6aK7e9wR46KayWNA/ERW2Dg+7LlGfYVyIS2vw7TkY+mcrZ9CM4bHuUCV4yNdjacpr5VUqtqtPkOLJtZDam6L8+uSVxsBISork6xANu6jj0gFlqTsjp7s3bolb1TcK/8+rMe9FJf99MjM39GQ1QDP0qxaMnbGozpBbMww1iZ5FC/9Z1V0yWfrML3muzbTtditXxAOOR+ByzVRSRc2N7drItx9kw3hdIbEOe/6U+m70OnPAB4DBT68ZgcKEqzp9VhhnRVajQw/dqVE8IhsrbqcjGN9dR+6VBHQuvf8R9nz2aL81593Tc7+2q6niBSWNB72f7HW1MuPh45v3nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6D7nt7OzBOEA4QTwKj2un6TQjCBXMl3jObir2mlHN8U=;
 b=ztRm29S4S6iRmP3VAoAHsIlu54SgewGR47zzIQ0cegiOONV4Ut7HxRVlbLiQRB+wlM8rA1em8wb2Op4HAg7Em+49rP9axVMfQgOjLEQY57Aldyq9IBI7MLGXEwIxCHtW7xNMjcKGOs8emX7MPlphSkwIcpaVLD5PX7ke4Z799m8=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by SJ0PR10MB4784.namprd10.prod.outlook.com (2603:10b6:a03:2d4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 11 Mar
 2022 12:11:09 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::517b:68:908d:b931]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::517b:68:908d:b931%3]) with mapi id 15.20.5061.024; Fri, 11 Mar 2022
 12:11:09 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, toke@redhat.com,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v4 bpf-next 3/5] libbpf: add auto-attach for uprobes based on section name
Date:   Fri, 11 Mar 2022 12:10:56 +0000
Message-Id: <1647000658-16149-4-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1647000658-16149-1-git-send-email-alan.maguire@oracle.com>
References: <1647000658-16149-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0335.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::16) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0274200e-88c4-4b73-bc6d-08da03583a3a
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4784:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB47849E6D67E0116B86FDBBEFEF0C9@SJ0PR10MB4784.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /JDBVq7UTHpojywrECJ4IpKk7M1InM1cxKj3PK7kOFjBUP1+l3KFd5rkTsP0YWsfbqRaMzbBJ1rotoX7I50KlnJMNOChmLhGBFNplxXLBnmrx71QJkSWvu9ExSIMswkrgS83kG/BmN4yMGAqExN9lSyG5qSpx8+B+HskuAHcdYU3WexSxGwKzL5s/VraXJUHaArm52Lp8bx5Qu/gaArUNZqIz+G5wR9oHjU3ruI7DM0BM4+51krToULH/p3XB8lORUVexMkpTsf8eiEObxPRVXtwCCvJEpcUv598Wo4g6+TEj5IclJfH6ldCYQ3X11EZ5etaJOFPUtxxSmV096MQhxM0dSNHNZpPLdkhxw88VOJBLydiSHJLc4DZW1U9ALP6mE5FQiE8zVYLqRwe8ZUoHNaPCyBtJDEC9SBERq3Aj0seV38RaAd7NqqdlEbmbjfxK+2unW6rTJwvhnuC2Ia1cm1zGKGcq8HMiWhFUQgDvnN9dfmpUTLL3b4oYte5wm2FEnmJBg0XD8ZT/S6Nn2akAq6y3gCVhApjpqu1KMuuYegNNQI32QOlH29sIP9WosSQFXn9vM2QV1rvqMtu9IkNyoBukNFVBCpIU5QUTheqv/e/RR7s5+L1KyGXJXO0L9YWzKLBHNeZP0j9kuKdA+liRdLe686eRGGLFqsRDNNx8smIaqOHyfSgDhcSRUYEg5YsDXSzFQJg+IIkOPAsRRnXJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(2616005)(66946007)(36756003)(7416002)(83380400001)(316002)(38100700002)(6666004)(86362001)(508600001)(5660300002)(44832011)(6506007)(8936002)(52116002)(26005)(6512007)(186003)(2906002)(107886003)(66476007)(8676002)(4326008)(6486002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pBDJkn44GEcFNyaUyOQ8RcEq1U/aac+ir+90kpqV+1SYpgNLGcExfZl17h/U?=
 =?us-ascii?Q?6W+0jDvH7rpNreEz1aWtfRvXkxMmuID7WdlX1XevmORz5PvPhRnE8W3yVkrs?=
 =?us-ascii?Q?Oqnd5dniiM8G2V0ibcFu14pB0pdDkFBH8n0JMWBaOe61ZWMcuzliiN8xGdUs?=
 =?us-ascii?Q?lIn+2Zy0DOpnU4PgD3vxVBsamV7hKDEhC8Fh/1xhxz1POY2zfqjTmtQWrxAB?=
 =?us-ascii?Q?Cr/JnyPKH+t8UUCu9C7nKBk6rtACVsbiRZLMHsdfmI/ASEn6pdK2SIfyc+Ux?=
 =?us-ascii?Q?8k4p3cJZfTCJmt0MikC9sKcjz9HqFrg8cfQuzy9cvFg/7SEWtsNWe5oHvcgh?=
 =?us-ascii?Q?bdRKwovqnmDuDABrWnRfP4eMHk1SQPb5ee+cZFa+TPF8ZKvr+fTx31kXYjAK?=
 =?us-ascii?Q?NQZS03j0iNGNRdqcQF0y4YK9RNtGqHBINs3gMj7DxaXOuC7TILfQxFc99Ips?=
 =?us-ascii?Q?B9xVq13nUT6gyevB+m6jf5D0ItRM2BDc2p4T1IOpNdM8yG8JQOgyU79yOOaS?=
 =?us-ascii?Q?5o7Mff3PkzY1T8CeB7+TGArZnRoUyNWC4cjE5exifSAxDwU96IcuTflSjzHi?=
 =?us-ascii?Q?Tun3WLG0CP5l8K+IoD0M6sxL+tTCkliEBSMAdDZyJUVXFCjIOyjfOpofaaNY?=
 =?us-ascii?Q?jl1xawZILz38Xp7rEVEBFGe8vIK8Pgtaap9gp28AdeEu4FB5DmQu/eE3+XjK?=
 =?us-ascii?Q?OsAaEMaj47m3F68YBRTEc3XtjjXxbapl39CWR4/xxla52YVxHztrLebByDw1?=
 =?us-ascii?Q?FDneOPM9P4kCuoYuEYl5BUHbu/JmvMxiXtC78UfC2zR43LVCtRzY8yVQQk9Y?=
 =?us-ascii?Q?CQr3LWCp/ihSZIQjspvigkYpzV0QykNbu0VqCoBpMS8Jrd5DlzcsfDErUfm8?=
 =?us-ascii?Q?qPk02ilvceaqTUpOi6V/6FqURGpZjmXzG+J7Vf9Lw0cHs/PTSEVb/EY8baSe?=
 =?us-ascii?Q?5jQxveRE+kTPSuPEA1qS7tXLS/5OoUtOur/tja/m8mxiv6/D8qcsgEy71PMn?=
 =?us-ascii?Q?r+L4Y3tiHPz7c0QlAcQEB/VB/+aLs3ljdew9DeJGyH/7LxECTYkDq0TXTtTR?=
 =?us-ascii?Q?PHehlf6t2W/0ioRYepqDyZuSEsEB/DUuW6YiQZRJM93/dxHJLijuUT/ZLQXB?=
 =?us-ascii?Q?4Lq54D87ZlwUNHqOkVlfmgnWBb2QeBOSoCnrxE+VEiJj5t0Cev/MahTx0UQv?=
 =?us-ascii?Q?1SKl+Ri1GgZqTw7G5d70Z8G/1S0pShb/lIHGBEyilz4AqLGBWvJnsshs3mHR?=
 =?us-ascii?Q?6lFJaD5ZENO70rYftDoq6mIuwSh9js2zb8jLg8bxUcgnMga22iRFthWX8UBC?=
 =?us-ascii?Q?eUVHANc1UemXmCkdyJJRbzVH3kbO7b/ROGfr72UBfPetOoP54NYsNeEusFqD?=
 =?us-ascii?Q?6oL7+bRyoz/m0gWWCJ36kez+iYdCcyD0RHXfQOSqJzZDjiSPuf8MRBtzlidh?=
 =?us-ascii?Q?Ht6Bos8/DMQ8ydk4Ua8sZzObpoMMbUOM1GWET/86uzUkYehwdsAGhLGtaTFI?=
 =?us-ascii?Q?iJiKAac5oaBzk3q6jD2XiYFaOZh99L1NxUg8/1WFClaLZPwADeAWibgR+TPx?=
 =?us-ascii?Q?9NKGA/32PeoN0qEdLmJOk8vFieyGmphPuFkVIJCUBZcF3fXLSzkAlCuqPUdI?=
 =?us-ascii?Q?GeNhWfIcSkPbQ1INpKrLeKI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0274200e-88c4-4b73-bc6d-08da03583a3a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 12:11:09.7153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LCJ7wZoY6NvyJUBjDab2S4J8Z40to1D3pNvszLhyC2j+y8FnBrVecFH/e/gZJ+vFbvwa8g9vBiTzdZmRXCiagg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4784
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10282 signatures=692556
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203110059
X-Proofpoint-GUID: Ck9gYYNjXA635bD0nfwiavPGyigya2eX
X-Proofpoint-ORIG-GUID: Ck9gYYNjXA635bD0nfwiavPGyigya2eX
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

        SEC("u[ret]probe/prog:[raw_offset|[function_name[+offset]]")

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
 tools/lib/bpf/libbpf.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2b50b01..0dcbca8 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8593,6 +8593,7 @@ int bpf_program__set_log_buf(struct bpf_program *prog, char *log_buf, size_t log
 }
 
 static int attach_kprobe(const struct bpf_program *prog, long cookie, struct bpf_link **link);
+static int attach_uprobe(const struct bpf_program *prog, long cookie, struct bpf_link **link);
 static int attach_tp(const struct bpf_program *prog, long cookie, struct bpf_link **link);
 static int attach_raw_tp(const struct bpf_program *prog, long cookie, struct bpf_link **link);
 static int attach_trace(const struct bpf_program *prog, long cookie, struct bpf_link **link);
@@ -8604,9 +8605,9 @@ int bpf_program__set_log_buf(struct bpf_program *prog, char *log_buf, size_t log
 	SEC_DEF("sk_reuseport/migrate",	SK_REUSEPORT, BPF_SK_REUSEPORT_SELECT_OR_MIGRATE, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
 	SEC_DEF("sk_reuseport",		SK_REUSEPORT, BPF_SK_REUSEPORT_SELECT, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
 	SEC_DEF("kprobe/",		KPROBE,	0, SEC_NONE, attach_kprobe),
-	SEC_DEF("uprobe/",		KPROBE,	0, SEC_NONE),
+	SEC_DEF("uprobe/",		KPROBE,	0, SEC_NONE, attach_uprobe),
 	SEC_DEF("kretprobe/",		KPROBE, 0, SEC_NONE, attach_kprobe),
-	SEC_DEF("uretprobe/",		KPROBE, 0, SEC_NONE),
+	SEC_DEF("uretprobe/",		KPROBE, 0, SEC_NONE, attach_uprobe),
 	SEC_DEF("tc",			SCHED_CLS, 0, SEC_NONE),
 	SEC_DEF("classifier",		SCHED_CLS, 0, SEC_NONE | SEC_SLOPPY_PFX | SEC_DEPRECATED),
 	SEC_DEF("action",		SCHED_ACT, 0, SEC_NONE | SEC_SLOPPY_PFX),
@@ -10761,6 +10762,69 @@ struct bpf_link *bpf_program__attach_uprobe(const struct bpf_program *prog,
 	return bpf_program__attach_uprobe_opts(prog, pid, binary_path, func_offset, &opts);
 }
 
+/* Format of u[ret]probe section definition supporting auto-attach:
+ * u[ret]probe/prog:function[+offset]
+ *
+ * prog can be an absolute/relative path or a filename; the latter is resolved to a
+ * full path via bpf_program__attach_uprobe_opts.
+ *
+ * Many uprobe programs do not avail of auto-attach, so we need to handle the
+ * case where the format is uprobe/myfunc by returning 0 with *link set to NULL
+ * to identify the case where auto-attach is not supported.
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
+	snprintf(binary_path, sizeof(binary_path), "%s", probe_name);
+	/* ':' should be prior to function+offset */
+	func_name = strrchr(binary_path, ':');
+	if (!func_name) {
+		pr_debug("section '%s' is old-style u[ret]probe/function, cannot auto-attach\n",
+			 prog->sec_name);
+		return 0;
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
 static int determine_tracepoint_id(const char *tp_category,
 				   const char *tp_name)
 {
-- 
1.8.3.1

