Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80AFF4A4B89
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 17:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376476AbiAaQNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 11:13:11 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:42804 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244114AbiAaQNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 11:13:07 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VFwpWR006233;
        Mon, 31 Jan 2022 16:12:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=W3rPGqEUBOFPO/4b2CVaML0yj8othIL08IFUlfNKW78=;
 b=Qrl0BNK83qbB1KecFg5WUj0HaKpIlAVA8kp4Z96xC1BppXei7SxQMEl+HX4TwLSkwZ93
 2KaingN6QtmJcB3NwYxZhDmRyrL0IUnQ9hNix4DJM7SMyNe2dQHi6SkRstk4i0/E+y97
 w6g66WHeo3DkrbNiIhYqv/hjJnEAJuKpSQu6o1W24g8JK2p1k+G/v80pzBSYNUVaG2LQ
 MYH7e4lozqg6+NiTSbJeD+dgi6b1DOIpCokoutUGn+Ylu05G4mN45OM/UCgamU25Aul0
 fHGNtdKe+iTCYSI5P2Lu09UAhKNOMo8lIkkWNTlCAQDDGBxYOU8Ukq0AN4f0VYDZf5DP 2g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxj9w861c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 16:12:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20VGB6DH195237;
        Mon, 31 Jan 2022 16:12:46 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by aserp3020.oracle.com with ESMTP id 3dvwd4j528-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 16:12:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3TB+1hHALQ5vpFfwHeW7oQ+JDUmv0Dh4T63FNGOmvT+1vJGvAapC0Mwykf711W5gLwj1Gyynj6T5OjcIweTeL+FM2fwxK2OA8IDlO0GW8ZbtCI59bmGgvJOguOi0a3syDbXal5feUKSuSUXMJlKkAtVEBP+KAYIfIZu3hZB13UXzOnzxHJHrlKw9WLsUBEXMKNY0U8BfufYweD92eX1ouljDXRTY14GUZvNjviNYtlo60dleLrUaBj76jhFUVx91/1kXiuSUxaXVgzIevf4br6UDS4ABH/SMmWODrqACyrhNoqiiuOQM3Q2iUWI/FZj85oZ5JfJY/4Zwf/CWP2Ylw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W3rPGqEUBOFPO/4b2CVaML0yj8othIL08IFUlfNKW78=;
 b=Hl8wjtXcddO/FEhYwoc9ao1AZWVKCF+8oYF3yf4x/TLWEYLT7ISDflj1ULQvUN2aJ2+C6Cd5hwWgb4XL08Yq3w6W3Iit7w6yB9wJ+WaKCCRfzlas3ZUOpO0SfKe7eckoh/YNWFbwEfDKKLjW+klyJtlxlgRTpv66qzvkngOZ8JfnZ4cVC7LqX7OcF/XtNm0V0jN2z91mbl5o2p292sM7z9DS1rJODkCn6FclpcQGg+/TuJnXlIXkXhgoeC7OZgEDLZ3vMcKJnkQ0GJpty2n3G89w3KpHtqjiTr+dBYS1JMk+7TUN1IOiZb91SYFFFu5u7Pc28vAqCijBl+4ssK1idg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3rPGqEUBOFPO/4b2CVaML0yj8othIL08IFUlfNKW78=;
 b=XvVXfXHn1PEhAxvPj6zxmfz4TjuXd3i1kRg9eJU66aq5S1cd56e77JL4LIgojnFAvTAl5f8y73UaCrsx95WlYNjZWQEzOyVv9bLyaJmCIKvZ0U5F3GTWtZep89jCER2rTmhp4xea+o60q8pd5XdPJ5fBYuWMyYyZLWX93b1UQ2I=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BN7PR10MB2516.namprd10.prod.outlook.com (2603:10b6:406:c1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
 2022 16:12:43 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6%6]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 16:12:43 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v3 bpf-next 2/4] libbpf: add auto-attach for uprobes based on section name
Date:   Mon, 31 Jan 2022 16:12:32 +0000
Message-Id: <1643645554-28723-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1643645554-28723-1-git-send-email-alan.maguire@oracle.com>
References: <1643645554-28723-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0124.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::29) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f7bd759-6379-421f-87a4-08d9e4d48343
X-MS-TrafficTypeDiagnostic: BN7PR10MB2516:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB25169BC2639C38DD54340D5BEF259@BN7PR10MB2516.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lh6INAFHuhPoqYK4uDdZ47Jk3yRzqZSHGYL59I185F7ME3Hec7jUxJGvxfrQhkq/WbKmylJZd5TFAMoYT4cNf+yDFQSZdNodZJxADIl6Jn749Bb0VXgtZzTfA4lHIAx8WFRhaN7OXz3ISKRj7tr4ayi0QRZ74vjAK7IvWvSvWNwYn/hC0EjVvOKl2+ibzM1pShPETtZ/p8/YrOS257ImImtNiIRNC9ebYQBE+wynaEeSdmJG33yyEf17BmD3aPI1IFKNYD4iQTPFX8Lb7Devq9ZsXvxlh42s3ohEmSMCSZtYSKJYlGXGUSpF6SbWP97YLH+Qn1u61Yas0jWNn0u8CU1mQpbW4AJ/dGZEFaiRpnMKgzWs6Ys/pXhRFu0cMSVh4e/gTDnlmeD7EVorzoTdPbgRX5bPn45yrZ5rjpWKfqICthkLibcrO6xdyhdupAMtmSJc0i3EbeNlFnlTOOfGvRp6nRDrTpJjU8g8qIrpXbW8oxSXXk2FfMinIb7TR8jTuDQiE72fVNTcIsevqOJUzXxVmuNy7wmsseDRYnuTIDovlwCa7qgpCMwQq6c+YtxQ5KAvxYWexy1XmucVOKV1ThgurlBA1ic/XZaIUUjwyQawfM2VdHTXD+eTlJfynryzytoOxOGKVU75i+EnEQV9RwFznlgJoE2VnGoxhcA/AJcbVwYeZ2vElGmAnrQctdbXn7gqQE8xA++8H9sg6uC+YQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(186003)(38350700002)(6486002)(38100700002)(5660300002)(6666004)(107886003)(2616005)(52116002)(86362001)(508600001)(6512007)(6506007)(316002)(83380400001)(44832011)(8936002)(4326008)(8676002)(66946007)(2906002)(66556008)(66476007)(7416002)(36756003)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?juahTHQV+ICSLy1GqlhxFtlCktqfKEr6kh1gFjy+3O2zeiDuB8aAe8//Vqya?=
 =?us-ascii?Q?fW2sjQjVEDEXMbYolG35GNS29kAQLLUSmQZW+bOVVN45kZs3mRKs7WDlRhfq?=
 =?us-ascii?Q?taFyofMt9Q7Dyxkr48tb/hGvzcNcNRghgOxm8gx+civ4XjdvZ3GdMvL84qRR?=
 =?us-ascii?Q?bpsY5queF8FZiDiQxreqyXXQ4Q/spHJctfJo//1dHqjQxUv6EnR+/TV+l+U7?=
 =?us-ascii?Q?IfefnwZM6eAJ3RcbGXfFSki/CCdFPzI39taaa8s4wv9s8fNjrRVAEg0jKveO?=
 =?us-ascii?Q?Lg702WoDFZ7W0i47zxhI5z+9aLRDjFyp6kP6rYpL3goKXv1JSr6SmIJRuuU/?=
 =?us-ascii?Q?jClS+i0DGB5hjD6SdmXf8Wwq5sYG1AD/RH3HdBH3s6FU+ojKUudnqDlC7fTW?=
 =?us-ascii?Q?AjJhcr+PTtu/kw+tZCcvxIEmKc7t7MyiZUHUmA7iJ+WfoLSPIoIkXYFfZXqO?=
 =?us-ascii?Q?+dZ68INe9Yhr+hgVWmgnuuU7L/MVRHultuluZov/wW1KBz/UTlT4uZsU9dBx?=
 =?us-ascii?Q?jEkEQ33lKV1ZRo3jjjjIriMnO/uxSQdJes+IrUSeFHc+1z3ilr7Y81ReyxvX?=
 =?us-ascii?Q?t7TXa1zG2TZxho0SduVokcvv2G2anz7rAUk/a/VbDJ4OpZNWiZRRRYsDWm7x?=
 =?us-ascii?Q?Po62+VQiPIcaq1oS5MOc9npmEp1WVBkhU0hPLBCf9t+XiZsBXictmCFS8hEL?=
 =?us-ascii?Q?O13Uxe4RKFVXF8VwkA9ytcLnyIoQHvRcgs/F5Ba1Ez4fhiucuaH+Cexcs0Cu?=
 =?us-ascii?Q?RHnBL5CnT4T6iuGtMauIiQofCqzTX8lBpcC20UeQWAU+u4mWFyLv+G0gc7uD?=
 =?us-ascii?Q?d8HMxgyQjwLrEIXBzKVlo+MKZvGsk6U1K+3gIR/AP35kGLNj8QfxtvKddFuc?=
 =?us-ascii?Q?TOnZYVRmEof2QNh0JVROLDEAwIFQjRjZcsawf4zl9LOOa7d2P9MpYKxa6qFQ?=
 =?us-ascii?Q?Eb/6RZcO6QItd1i5dtcm9VElpVaqYY/2Ed3dCBm3QlrtqXbd18V16TMwfg4+?=
 =?us-ascii?Q?k6KDU8mEKcYZC+lk12KjtsXm8EYjrL+Dl82HIvwZ7LKF8huH8EGzw4hGeFyn?=
 =?us-ascii?Q?4Rg4u/7mpkyoJVQeaWfWo1sQRtolRdgXSE6KpfrqrhACPI2QhKEX3zWXbDvp?=
 =?us-ascii?Q?zBoKa11Tg0Rq0U4Pi5aGw6xfkrLtBb95nhCNEN0yzljRPLMNuCP5PsduNduz?=
 =?us-ascii?Q?oywuwFR2+0dQEgmaSMYuNbcAbNJzi03+GeE0v6/liHufBEDb4cJKVC/ViW8V?=
 =?us-ascii?Q?EGr5SZImb8xeCBOaCbBxRdwQLodmKU5Ese0/47dbEY1qSZnKvBmevCWqhLPB?=
 =?us-ascii?Q?g0vBt+e6E2hrdhafOxbvhuq9FruhTDq23y/U/KKG2fUsedXiyJdTIo/M1e++?=
 =?us-ascii?Q?erw+m8kVMrjlI0jyd9W1DDvAEhOEw3taq+5jOzntqKop7GCHdMPJdC9sV+De?=
 =?us-ascii?Q?w4FizGi+pJZtaCM1cFAU2Ssv7Jid65Y2xwNq7Mh2s9Qmtw1fd5FcI4t9BVcy?=
 =?us-ascii?Q?kJ1v4LZzzKFWT/ReZbNRlhfXt/brZS0m+0yvcdI9Ftd9KD0sdQNETUw2/RVQ?=
 =?us-ascii?Q?yvm7QhvtN4u+u1lyPdaPhTHyFDK5hwO5WiZRn1h0/aJKuPY6Znw/NH2CaZ7t?=
 =?us-ascii?Q?H8wjQyZSpDXtJ4H3OepK4+g=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f7bd759-6379-421f-87a4-08d9e4d48343
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 16:12:43.8419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1NcQ87m2usxRBP5e+cRxIH11Ni+MK0VEGZLbE9OYSLil3LvfXz9npRGqUbV55ZuJa6xg1Zf4hNJTR5YvnqWNUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2516
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10244 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201310106
X-Proofpoint-ORIG-GUID: 9M76vjGPumXI1VWhQ2smERGdLYjWdo9l
X-Proofpoint-GUID: 9M76vjGPumXI1VWhQ2smERGdLYjWdo9l
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that u[ret]probes can use name-based specification, it makes
sense to add support for auto-attach based on SEC() definition.
The format proposed is

	SEC("u[ret]probe//path/to/prog:[raw_offset|[function_name[+offset]]")

For example, to trace malloc() in libc:

        SEC("uprobe//usr/lib64/libc.so.6:malloc")

Auto-attach is done for all tasks (pid -1).

Note that there is a backwards-compatibility issue here.  Consider a BPF
object consisting of a set of BPF programs, including a uprobe program.
Because uprobes did not previously support auto-attach, it's possible that
because the uprobe section name is not in auto-attachable form, overall
BPF skeleton attach would now fail due to the failure of the uprobe program
to auto-attach.  So we need to handle the case of auto-attach failure where
the form of the section name is not suitable for auto-attach without
a complete attach failure.  On surveying the code, bpf_program__attach()
already returns -ESRCH in cases where no auto-attach function is
supplied, so for consistency with that - and because that return value
is less likely to collide with actual attach failures than -EOPNOTSUPP -
it is used as the attach function return value signalling auto-attach
is not possible.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/libbpf.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index eb95629..e2b4415 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8581,6 +8581,7 @@ int bpf_program__set_log_buf(struct bpf_program *prog, char *log_buf, size_t log
 }
 
 static struct bpf_link *attach_kprobe(const struct bpf_program *prog, long cookie);
+static struct bpf_link *attach_uprobe(const struct bpf_program *prog, long cookie);
 static struct bpf_link *attach_tp(const struct bpf_program *prog, long cookie);
 static struct bpf_link *attach_raw_tp(const struct bpf_program *prog, long cookie);
 static struct bpf_link *attach_trace(const struct bpf_program *prog, long cookie);
@@ -8592,9 +8593,9 @@ int bpf_program__set_log_buf(struct bpf_program *prog, char *log_buf, size_t log
 	SEC_DEF("sk_reuseport/migrate",	SK_REUSEPORT, BPF_SK_REUSEPORT_SELECT_OR_MIGRATE, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
 	SEC_DEF("sk_reuseport",		SK_REUSEPORT, BPF_SK_REUSEPORT_SELECT, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
 	SEC_DEF("kprobe/",		KPROBE,	0, SEC_NONE, attach_kprobe),
-	SEC_DEF("uprobe/",		KPROBE,	0, SEC_NONE),
+	SEC_DEF("uprobe/",		KPROBE, 0, SEC_NONE, attach_uprobe),
 	SEC_DEF("kretprobe/",		KPROBE, 0, SEC_NONE, attach_kprobe),
-	SEC_DEF("uretprobe/",		KPROBE, 0, SEC_NONE),
+	SEC_DEF("uretprobe/",		KPROBE, 0, SEC_NONE, attach_uprobe),
 	SEC_DEF("tc",			SCHED_CLS, 0, SEC_NONE),
 	SEC_DEF("classifier",		SCHED_CLS, 0, SEC_NONE | SEC_SLOPPY_PFX),
 	SEC_DEF("action",		SCHED_ACT, 0, SEC_NONE | SEC_SLOPPY_PFX),
@@ -10525,6 +10526,64 @@ static long elf_find_func_offset(const char *binary_path, const char *name)
 
 }
 
+/* Format of u[ret]probe section definition supporting auto-attach:
+ * u[ret]probe//path/to/prog:function[+offset]
+ *
+ * Many uprobe programs do not avail of auto-attach, so we need to handle the
+ * case where the format is uprobe/myfunc by returning NULL rather than an
+ * error.
+ */
+static struct bpf_link *attach_uprobe(const struct bpf_program *prog, long cookie)
+{
+	DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, opts);
+	char *func_name, binary_path[512];
+	unsigned int raw_offset;
+	char *func, *probe_name;
+	struct bpf_link *link;
+	size_t offset = 0;
+	int n, err;
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
+		return libbpf_err_ptr(-ESRCH);
+	}
+	func_name[0] = '\0';
+	func_name++;
+	n = sscanf(func_name, "%m[a-zA-Z0-9_.]+%li", &func, &offset);
+	if (n < 1) {
+		err = -EINVAL;
+		pr_warn("uprobe name is invalid: %s\n", func_name);
+		return libbpf_err_ptr(err);
+	}
+	/* Is func a raw address? */
+	if (n == 1 && sscanf(func, "%x", &raw_offset) == 1) {
+		free(func);
+		func = NULL;
+		offset = (size_t)raw_offset;
+	}
+	if (opts.retprobe && offset != 0) {
+		free(func);
+		err = -EINVAL;
+		pr_warn("uretprobes do not support offset specification\n");
+		return libbpf_err_ptr(err);
+	}
+	opts.func_name = func;
+
+	link = bpf_program__attach_uprobe_opts(prog, -1, binary_path, offset, &opts);
+	free(func);
+	return link;
+}
+
 struct bpf_link *bpf_program__attach_uprobe(const struct bpf_program *prog,
 					    bool retprobe, pid_t pid,
 					    const char *binary_path,
@@ -12041,7 +12100,19 @@ int bpf_object__attach_skeleton(struct bpf_object_skeleton *s)
 
 		*link = bpf_program__attach(prog);
 		err = libbpf_get_error(*link);
-		if (err) {
+		switch (err) {
+		case 0:
+			break;
+		case -ESRCH:
+			/* -ESRCH is used as it is less likely to collide with other error
+			 * cases in program attach while being consistent with the value
+			 * returned by bpf_program__attach() where no auto-attach function
+			 * is provided.
+			 */
+			pr_warn("auto-attach not supported for program '%s'\n",
+				bpf_program__name(prog));
+			break;
+		default:
 			pr_warn("failed to auto-attach program '%s': %d\n",
 				bpf_program__name(prog), err);
 			return libbpf_err(err);
-- 
1.8.3.1

