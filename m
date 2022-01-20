Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D072494D49
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 12:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbiATLnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 06:43:07 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:43578 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231919AbiATLnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 06:43:04 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20K95NJN010655;
        Thu, 20 Jan 2022 11:42:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=LruUyHGx4otHaBQ7FNiHJ1DCkL7YZ+thL2LVuvJpG7s=;
 b=dTWljpykGMu/pfrYbvQq5SN6czAygJfbX0EJWFrqVHpXdNPCPHtYX4/VGlbZpcw1MAWI
 0sgj7rZLfMNA7NoiX9hei7Wy+SoquPnRJxX2evqcRlRHQ278W9ntPDmzR2+3VzpXuGwc
 xkgAZq6/XImzXCw++O/rOUA/SzZ4hfZMSzvtXbWlbdYy2Qjj+oalHjMMKPTmk+t7dNVr
 E957D1Whb3p7dIWuOgGobpLk6McqM6mhPxyh9hKWxw701ZaDljcwUAxZsHpBVNjtPGf1
 zqTog3Biv1YqnZBKDnMd9np9fbjaDU4mjZaJVBKXdK9dRtWdfDn5TfUat83ghOhynHhc uQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc5302fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 11:42:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20KBaB33151224;
        Thu, 20 Jan 2022 11:42:47 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3020.oracle.com with ESMTP id 3dkqqs9385-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 11:42:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YdLqwY/ltqxF52tES8y83XRglIMrj7BTPpfswqxLhWuDPHg+IVw2WCAjQcp+GDRaxtQ3wMEs2W7fwDcIv9M6v+WZYmmkJOmmYmqR23q812+EVL39USDuSwXOfW1QMTOgYbgDjF0YMv/YbbSKGkosLTnOkdV3NOjsftXyTOuDS15T1QK4SSFwwVHvmSVrg6jz5IzfkUHhAOmEA3AFT12M3GDtgxa4LTpE9y7D1dWWPYpuu6MPK6EB+PVQl9bL/HDD+3Xcm5MBqZzyEG0Mr4e/IEbidXLa0zA+PyMCVvxtV9JDudW2hYE0/IfBOOnHD3axRcyMNuIvoFV/HzfjtaRQwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LruUyHGx4otHaBQ7FNiHJ1DCkL7YZ+thL2LVuvJpG7s=;
 b=H/LJxMZm4fDpnEooCHbalZClQk+N4x/tlWoP7B3zotOkRp6hFbWzhyHMkixW52GrorF94LEIaJ2ZBMHU/+oX22yHJxHSyHtGkISF0zv6P64EpZ7D/Us0btLRQT4S3GbB+wKcX50Hx/D7yIdsWeth81IcDlzuwyylWAWjHKdyEBo1sISfOD6Dg5rdNLtD5epa49Vs7vCueoEdZk3EnLAatyXQRcmJoVeByTckVZEhlGvOCGLJ4YcqGxSP3CW7bKnpeAMj5avJboZEXT5INoNxLd70GG7YqTmQQJyy25vMyZe83o+Zuyz0DzFvRU0O2yCL3GGSiypEOytI7XBjfFBcog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LruUyHGx4otHaBQ7FNiHJ1DCkL7YZ+thL2LVuvJpG7s=;
 b=f/J1EwtFEWBlbp7uFEjguBHNgEstplh6syovjzggOw9J3Ua7aNbLoLljvLlN3ySITCbsUWrMOliXMNjT08Dd/RqpzqAK6WF8ktQvWwnjV942+Ln14qkAvEEumra+AY60zgpNXZ+i/orcnWvYAv3vs/e+cc6sL3zXUj9pfPYLkX8=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by DM6PR10MB2923.namprd10.prod.outlook.com (2603:10b6:5:70::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Thu, 20 Jan
 2022 11:42:44 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6%4]) with mapi id 15.20.4909.010; Thu, 20 Jan 2022
 11:42:44 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC bpf-next 2/3] libbpf: add auto-attach for uprobes based on section name
Date:   Thu, 20 Jan 2022 11:42:29 +0000
Message-Id: <1642678950-19584-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1642678950-19584-1-git-send-email-alan.maguire@oracle.com>
References: <1642678950-19584-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0358.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::21) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9715f633-35cc-4332-4fff-08d9dc09f639
X-MS-TrafficTypeDiagnostic: DM6PR10MB2923:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB29233057232E70EF1BC412CDEF5A9@DM6PR10MB2923.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QUN799/+GcgTbdrhF2VtQMVx1/iDsu9b42g65hbPIREu/TTS8uiAhw64pp5eH4o4oOHC/nEQkgVFoSfIe8Qp6CebsjCAcBd9driBo2GN27LSKmYm4vkoNC/IaWhzJwMS5kZvH3t0BNIKQhB9d+URNrLyQqqZ0PwqmuJk9Jno7lQfx9JTnCUzwJbfK+UQyV0zzMx2WI0esVUEhrpPRs2O8TXlh8sdoicZ3wWeSUgrZH2yUKJg55V4dVT3Ks3uQkCUw3KG07nK23Z+rUWwQLjgFhtoPnpx2HPUcV9yUwGFR2p+RImeZR4CFkY4PUB/O4HijMTPkkPdlpV7vzpE/yyJuhGizIlDVwaknW2iQpXYdQlKCnB9VyHc8xYAU7xa76akLOxTxoesDOQA+lYS8OjgoqRfTCf0WSN6kqNiRQqRzy4aJGTRhawOiakZOkgYZOklVR3A2WxaQ3E22FFyFu1q5jyPC8kKaiO3KEjAmLPntCFfmty/3DlLkIC/gPoCaJ5yQLJge9rqBPmGv/ftrVUuxREKou1jONCe1ccHnSQQA5hUEXCSPD7awHhkTOUmG7bHJIkv9ztSKVHByOozIGq4p3AVL9JgfbSWarGxxTAZJCxR/CySTy050GX/4azbWc2Ocryr2bVOIx+3Bm7waaf02nIhIOlUri2SaRkrv+3zeKU3D54drQTCGMPMUKutY4pkbRNk7cTKmaoubJX5ostIDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(2616005)(8936002)(186003)(86362001)(6666004)(6506007)(2906002)(44832011)(8676002)(26005)(107886003)(508600001)(36756003)(83380400001)(66476007)(66556008)(66946007)(52116002)(38350700002)(38100700002)(4326008)(6486002)(6512007)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gs7+mLseZMCaLbRgKPe++ttKmCjOO6FrQHxNhpe0IqCO6hQnoqqvo74Wgc/Q?=
 =?us-ascii?Q?WZFBgLdR3QcmjUIWhMk8JHLyy02IWizsHQHypbrgXKkTs6Te6nlEX2PPo/q2?=
 =?us-ascii?Q?z6N/BwCtVLaJwvjST5G5dx7/t8UmMzwqP7cF2EMLyAmcc6BMicfntVPWkRP4?=
 =?us-ascii?Q?xYAUxOLZU0dnqjz1+R+vMfwuHFy9nYxXVp48YDyaAeR5m7sC1s9+ZiMGlWbx?=
 =?us-ascii?Q?Tltx2jO3cQKI3m+bhTGj9dH3Z2Xa25pzKzskWvtsFKKvf25HY1xE9mggmT19?=
 =?us-ascii?Q?M2UbqkY0pAfekYPRly7drN+l4pMSPTtnzO7OgnWMqkL6V1OFv4udkWCjRJed?=
 =?us-ascii?Q?fhcQMWFs3Pbfrvea5F5Kkxx5CiXHp3NZCTCidhpYWMGekVYMPZFf9canKMH1?=
 =?us-ascii?Q?p3A3AN++8RQ40SJkrj1v4oj2oxElboens1Ohc9R5NX0NHYsn5vy8N77ABt+6?=
 =?us-ascii?Q?PV4bYJEfPz7EfIuFPIkK/LDGeiYq5ZHwPVworsszZaows/xdexoC9Y633tRF?=
 =?us-ascii?Q?1FIo8jWBXjtt8F1HE3lm1hQW+HKbYXZucwZ3ucuQ+I5+j7pkXnAnxm9BJnTp?=
 =?us-ascii?Q?p0ZQWBa36Cd15YuBNHFYN6GR+MGc9HlK7kjBZY6MbcYcpsya/HqQw/j5EqgY?=
 =?us-ascii?Q?vcME2zTqWoELxNRw/CRFikV57FRSyuDoHpcLnoc1BaoK1yWuryLzYq7zKSrb?=
 =?us-ascii?Q?TFT/LtFn/0zydhikXZz1IRy+BfYPBTcPQxFHIZmpoWs+BBqrPDZHEX3G45fC?=
 =?us-ascii?Q?P58L/Eho009Rm/Ey7+5CxGHE5ZL7tbxfUp+aTLyZVyMVdDu2UD0Dy/OzgW30?=
 =?us-ascii?Q?UkGNMmXYiJ1HPpPMspeGUdciDuVx2Q2e31c6HFbqwmngsK9OzQFDA9t7K5xB?=
 =?us-ascii?Q?cnx+e36z2ys2pGehFEBC2MowNvz6QJqTUe27ETamGoQsp94qK7tsi7meeoUy?=
 =?us-ascii?Q?MtF+CsgrK93c13ZdFAcuSsr8prK6xBaCxTBqu5DQsqQJOlh1t6myUcgESudA?=
 =?us-ascii?Q?BGA571R1US0oyEBZlwdBYzKq1vYAeMHiaIOk5kUG6tB1DGwXfzEf4tnR/+4y?=
 =?us-ascii?Q?1kwKtqTOctvWgw02oIhk+wkB03rHb1CPdShdJ9Pa9gVp+Dvk9Xb47jtAtXtr?=
 =?us-ascii?Q?6bqcIivA6OHztEXMQfgLmgIyVXOwLLIxbK0c1sxhShxWNdQyvfPwj8gcygAd?=
 =?us-ascii?Q?1GpeACF/nLG3hCm9ORbb3IieO9yrVNsiYvJJKPpivA1uiUdiwum86u06JRrw?=
 =?us-ascii?Q?jF0wumzbj2c4McaXy7kXDU/nTXOP/bGxqqKi7KMKHdwTOo7ayUm27GWyng+5?=
 =?us-ascii?Q?ey26BzephihgpO5bYGw5QA9InANufJRKhyBdBVG1UAtecLEyQkyLk3tHHRbt?=
 =?us-ascii?Q?x89yEO2sI/MIFC8p61JIoADNY3R3mSC8SgpHAa6xbf2B332ckceC98sPVHUY?=
 =?us-ascii?Q?hzWIy7UplloiGwVVEctjY4CTMitJw5IaaFMiSC/+8WC1qtiej3fMs6W179n8?=
 =?us-ascii?Q?2lW6tmy/zLMLTMGha4kbtIxtpVyG7ocrvzFKFwmAE4fi62QNivWWxh8Qoy0J?=
 =?us-ascii?Q?AuCt0OxshcuFPI9hkkswk052RNvcBn50SGAhq+V1FDziQRucJ3yaKVBZf2os?=
 =?us-ascii?Q?H23w8YjzsG+/mGyzvhI0WKQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9715f633-35cc-4332-4fff-08d9dc09f639
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 11:42:39.5278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fq8Il5OARnPdte+wuKJu9ce5H8yLslU9zsuLQlLdImTr2tNdSS3avJyoXMnmqM+ENd55w/8NxJ2gOO5L/Mz8IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2923
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10232 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200059
X-Proofpoint-GUID: xdanE6X9M2Ctc0oFpnqojpnO-e-sYHPn
X-Proofpoint-ORIG-GUID: xdanE6X9M2Ctc0oFpnqojpnO-e-sYHPn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that u[ret]probes can use name-based specification, it makes
sense to add support for auto-attach based on SEC() definition.
The format proposed is

	SEC("u[ret]probe[/]/path/to/prog/function[+offset]")

For example, to trace malloc() in libc:

	SEC("uprobe/usr/lib64/libc.so.6/malloc")

Auto-attach is done for all tasks (pid -1).

Future work will look at generalizing section specification to
substitute ':' for '/'.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/libbpf.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6479aae..1c8c8f0 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8565,6 +8565,7 @@ int bpf_program__set_log_buf(struct bpf_program *prog, char *log_buf, size_t log
 }
 
 static struct bpf_link *attach_kprobe(const struct bpf_program *prog, long cookie);
+static struct bpf_link *attach_uprobe(const struct bpf_program *prog, long cookie);
 static struct bpf_link *attach_tp(const struct bpf_program *prog, long cookie);
 static struct bpf_link *attach_raw_tp(const struct bpf_program *prog, long cookie);
 static struct bpf_link *attach_trace(const struct bpf_program *prog, long cookie);
@@ -8576,9 +8577,9 @@ int bpf_program__set_log_buf(struct bpf_program *prog, char *log_buf, size_t log
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
@@ -10454,6 +10455,61 @@ static ssize_t find_elf_func_offset(const char *binary_path, const char *name)
 
 }
 
+/* Format of u[ret]probe section definition supporting auto-attach:
+ * u[ret]probe[/]/path/to/prog/function[+offset]
+ *
+ * Many uprobe programs do not avail of auto-attach, so we need to handle the
+ * case where the format is uprobe/myfunc by returning NULL rather than an
+ * error.
+ */
+static struct bpf_link *attach_uprobe(const struct bpf_program *prog, long cookie)
+{
+	DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, opts);
+	char *func_name, binary_path[512];
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
+	/* First char in binary_path is a '/'; this allows us to support
+	 * uprobe/path/2/prog and uprobe//path/2/prog, while also
+	 * distinguishing between old-style uprobe/something definitions.
+	 */
+	snprintf(binary_path, sizeof(binary_path) - 1, "/%s", probe_name);
+	/* last '/' should be prior to function+offset */
+	func_name = strrchr(binary_path + 1, '/');
+	if (!func_name) {
+		pr_debug("section '%s' is old-style u[ret]probe/function, cannot auto-attach\n",
+			 prog->sec_name);
+		return NULL;
+	}
+	func_name[0] = '\0';
+	func_name++;
+	n = sscanf(func_name, "%m[a-zA-Z0-9_.]+%li", &func, &offset);
+	if (n < 1) {
+		err = -EINVAL;
+		pr_warn("uprobe name is invalid: %s\n", func_name);
+		return libbpf_err_ptr(err);
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
-- 
1.8.3.1

