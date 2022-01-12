Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57A248C824
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 17:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355089AbiALQUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 11:20:16 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:5710 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355112AbiALQTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 11:19:22 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20CGGNpJ032143;
        Wed, 12 Jan 2022 16:19:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=kgwAE1HzLg25tBBXKQOdkt3l1uzTwkz8y2i+uqH/jao=;
 b=x63DPobPzn94FHzbFacq2OtKZ+764zaenrfYYfSEiYHd2LrHJ/6uzdSB2VZGbPEwJG7X
 ysJi8MOgwSru6rpYKVC7eaUhiiFKSlyP4zXYEfxAITP1y+CzSGFh3axL3ViCv0FGR6n/
 eLnVVbMeTAy2dO4LjhY+A4MEigW7KWAMSURlrQHzT5Ns9L5OPWZnEVhpC7WLlmCJw91J
 OdCkyW3CQAw2a8YtojR8PTCi3F1BsLYHpv8lPz7T46lxCaPqabHEF3ADxZ6BB/qLkDeM
 wDPSB6l4dU8WNeUnI5G8PkRi58yvGuiOpRH4zeY8A2+Ejh6WjSMZaMOFlHozrbyGohf3 ZQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgmk9esu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jan 2022 16:19:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20CG8EKC073597;
        Wed, 12 Jan 2022 16:19:01 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by userp3030.oracle.com with ESMTP id 3deyr051cd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jan 2022 16:19:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gpzqA/nTPXlF+9tlS72TaGRwT8m81wP5l/3ic3XuH5IutWnSJiZHfN6Exe/FnQ8J98pfKdG9gTMjmcEgGjtEM9tHFX0rUjF9T0hZDyUjwrXIjDzI07TJQKUiO3Q2kmTqUcV7x8iVrDZNc8PkQnnETXAIwgJcKcTRYJOhlFpUOCyBP6rh61E4PN821sqebQOh5Tktkw5R/Lbhp3APQ1Au6dCN//TX5T8/Jn7lFSkTaQfJVAHZYijjAHO9F617VP+sLQrSqyuwBk9bvgZ2Qnz0sM931koY/qESguhfpEM1H1zMq+2vgw9TAnZ0jz49wX5qUrE+QNHMdND0AFDULo7kCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kgwAE1HzLg25tBBXKQOdkt3l1uzTwkz8y2i+uqH/jao=;
 b=D4F/VNRTZooccZCUh/CcysD441+Q/HxiZWyMfHYp+8VQ1iXVWe6i7FH21i3unNSphCjr+ZgtQrgmBRPpV8EKCsXdMeyOG6CP55tYboj7Wh9wA19xsKANVOwe3rl+OHgdd9ws3jxG6IIFOs+Z/WuJRXJcVUGAqgpwz4uNZVTiS9xYhCXecRCThlXKPYSdxyHL4ZE+nDxJIYHQEycmU278oJeiMpSCUVHDewajlClhdaB9zx7uj8yDavYh6g84OgWUISkQLntpKX4YqozCLOw+9BkIank7YQMRMI2Eaos5xsKsZk74YpT9bPXQdjB5C+rnucxo2tQmTuEE2pWgyzPPNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kgwAE1HzLg25tBBXKQOdkt3l1uzTwkz8y2i+uqH/jao=;
 b=QpCKxnxbiXdVuW+7LajfH1MOY7VUviciJItNmd5Y/JBubP2sGWk/ErWcagUiDlyBY4XGbXRy9iKMzxgPfsTqLtye53mZWZEfQ56OoH0tEh/a24wOhOx3OgIJUTZU+/iLZ33KWQkN9ZZraoOiaYVt19usJkZAmEUsEkZ/Lyiv9oc=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3600.namprd10.prod.outlook.com (2603:10b6:208:114::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Wed, 12 Jan
 2022 16:18:59 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::31c1:e20b:33a1:ba8c]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::31c1:e20b:33a1:ba8c%5]) with mapi id 15.20.4888.009; Wed, 12 Jan 2022
 16:18:59 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC bpf-next 2/4] libbpf: support usdt provider/probe name-based attach for uprobes
Date:   Wed, 12 Jan 2022 16:18:47 +0000
Message-Id: <1642004329-23514-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1642004329-23514-1-git-send-email-alan.maguire@oracle.com>
References: <1642004329-23514-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0080.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::13) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58505e61-abc5-470f-23ec-08d9d5e73d0b
X-MS-TrafficTypeDiagnostic: MN2PR10MB3600:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3600AE28056FEFE17AA0AFB6EF529@MN2PR10MB3600.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:792;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P3YXobPPftARA+lGH7pJ3jjz7I4BbpdiQbJoi8bwfi8KPY3gk0MAhYgdpVmiIaEZt80SD1vjZ01Kff1HKh43q8bOGrymkUDQxEs21DcAevHpRqXhblkGjNEhsxL5ep7AHOTEtbht/kvjsFbrP7RgYiJDVT3skAYKiXdb95dTyhPeuI1zwHfIx9Txl1yQKah++rlSvp+XGstParGf10WOBKpEWoMJeO3F9x1xblcAUhci1b43OKkqQ4HRwEutjp585RBbr8mZP+x4KJnYjH2n+z5cRBJUMNIfRlfivfNIvyPhY/ImB4fbk5dIq0AAWy2oi+BfKi0/abu+sXRmaJlb3oSrtMQVHFob0Vocmn+OWywuus6D6bo5Zw8b6vpcl/ZztxZQ1oCkzztdRl6UkI9z/9dK5Va9flI3crWut540oMBoxad+vUXa9drIo3XG3JkfVVgxLaSpnu87SElPLQNFGml0aQ4bzvYL+doU2cG9bBYYidDRNz+3g3V3jp25vzHspgA/xEfcyfG0ZskX754o0BrFlJkpN3aR+8BR/6SKBhkEla6tsUu145kO3PebgoKvaMVvfQjEKjLIHY9y+/Dpkpd4DqS65wyTgePOUOkxf2DGtnu/o1Z7Vg6mjzM+XgLCyiE6F9My+S2JPktiMJQqoi7bq8YX03Hj27U+aHaQi9D5CQjcVDbrPXesQyulPq0NqqqUnU7vg6E1rDMjgQeUbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(8676002)(66476007)(8936002)(6486002)(36756003)(66946007)(2616005)(5660300002)(44832011)(107886003)(6512007)(66556008)(316002)(86362001)(7416002)(83380400001)(2906002)(4326008)(52116002)(26005)(38100700002)(6506007)(6666004)(186003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZZS2mtFs6w9wFKgXyqrZedjMikA0xwjOgUXjf0sKLmCNojuUh/xUVfR3rDnd?=
 =?us-ascii?Q?uUAACGicgpjj0R/G+HElKCG2YEX/EtsSkSkYkdB66VWh9YFtVgVqDHna+EDp?=
 =?us-ascii?Q?3WxT4gk46ioZZHHGtZSwKfOX+1hpXtXyhxcteGccNFXrHGl8vUROw2m2/dec?=
 =?us-ascii?Q?8CNpFAein0ScPPOi04yhiF4uWZLzBs/eRjLRNRpuGK+/LrxT1njiCayhX+q1?=
 =?us-ascii?Q?PdBL9JgBYQdLxAcOl5CB1HYCp5ymsIZ4wHc7ECcHFzYJUF2QGbOZTBzWDOw+?=
 =?us-ascii?Q?kBLWq9kW6+/scCEfvc4u27+i1PIhNN8bsvgrjYdzSmdhGBf91ZY+fYbRPkOZ?=
 =?us-ascii?Q?E5dIg/6NcRwuaSnbpmZhlt+VSMuuahm0gaHKdW9DHgqxd6fv5Sxo3Zlkq9iV?=
 =?us-ascii?Q?PXeqeJnMs6CYNK3c3cX7jl/oE0II10qIrZNFOGXyMTEX3WoXlkEH22LSYRHu?=
 =?us-ascii?Q?D337EtgB2Q7woYIsiwqoftD4Yw/AAZH8FGEcgznVFLvd/tEXjxKKHrrSfbhu?=
 =?us-ascii?Q?D4uRqaY3J08eNoBf0VsiggOQoD8aadT6VxWVKxv3ICd+8Tvq1r1G33biyfRo?=
 =?us-ascii?Q?GBXPSmtZ7kZ9W/inZbHkzWDhIQKD5cm/f/qeQWs+EPSRP2LMgHKqPMkMSotN?=
 =?us-ascii?Q?huLv4iUOCTHafHksEUw7rG47AQZJG7wQMftb6au0w6zUvW8k2E4wiSaX6mA0?=
 =?us-ascii?Q?Y1febxBoTErXvF037YXciUsDoTDVc5KoVLEXI7VABRjsUMtB7UAcfplOP/Kg?=
 =?us-ascii?Q?Ji9FS8kq9PrYVeUYs7Hp+0VQMXV17mdU4S5eEedLs7fxoP+05rH3p4x3mVHE?=
 =?us-ascii?Q?Gbe/lyFw0gjXpOy/ZMbAfrVolBv8xijcQrh5ws2lfVE9o80BTocOT8jIo9eU?=
 =?us-ascii?Q?cLoB8GjN5VXk+/zNZ9+gKkKF5t4SifU5dzeDv5S0klhw45Rhrw3jM3wLvNAu?=
 =?us-ascii?Q?bjl0XI/sWpn9W2yYOrzr/BI8qb6Dejv7or3s+mpjjOFdR1MnstGNRZuOkgC0?=
 =?us-ascii?Q?DUxjoDQJyVXop5Gsbw5rXnexVB2ouLsJn1lG3+x3pKsH0XGU11wdpDUIy2oI?=
 =?us-ascii?Q?20eIwqh7Ixhhwag0zYyqVUi2w/DifxTYdlKiUkGns3lfxL5fp5quVi+Xm8wf?=
 =?us-ascii?Q?MYGKHOXV+0BcusJ/ma8HfFl9nfuY/2L62Uu2FGKdLcVlsgPLo1TvnV+NFbbS?=
 =?us-ascii?Q?S9eBjr+ZYRoBp4RS1E2FHGfPNwl+vobaj+RsNj1rgaFl3vQBBy57t7KxeSqI?=
 =?us-ascii?Q?ZWhODrVvtdBZ7kbaHj42JgQAWdPFoF1mN1fIh5eDZfGIKBPVimivnXCGvgm8?=
 =?us-ascii?Q?xQCkiLCknoKrIvrRApg63jI+P0Bdb4zXK8T95aWYuw6FiHrZou//TgOy/eBT?=
 =?us-ascii?Q?vsPbFXk+kPddY1LdF4TA3fEoqLzSDfKifERLmXWFSMP1L8Bv7YP+ZDlK3a+h?=
 =?us-ascii?Q?hTxEUpSXyi/rxJnGlKTyEIPRMw+RFaLHn5kg/9HvIT8PAs/mrluuM3kgFF5B?=
 =?us-ascii?Q?82H9Sa6W8mwjKmCAVVQAVSqlqs3p8RSNAIj6byucZfRe8BlH+sqjC3bhzXwe?=
 =?us-ascii?Q?rGkQx19fpTTzQeuf6yq0S92gzUO1bPFMciY0SJ2jwySUSqEdnODz00r+bUx9?=
 =?us-ascii?Q?oawYW5WiZLWaHvzsGR6Utd4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58505e61-abc5-470f-23ec-08d9d5e73d0b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 16:18:59.0281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eu4has1jT0YL5s2lPlqfB7JH0PgJNI8you+nrxm3r8+H1Hl9J6vGU2zZLBZim4lOc/IsWGUkudSnnTQbZ70M/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3600
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10225 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201120103
X-Proofpoint-GUID: uRRvYqjRGXq7jxJQBmIdtAEv63Uy5YTy
X-Proofpoint-ORIG-GUID: uRRvYqjRGXq7jxJQBmIdtAEv63Uy5YTy
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for name-based attach to Userland Static-Defined Tracing
(USDT) probes via lookup of ELF notes associated with probe definition.
ELF notes are consulted for probe offset, and - if "is-enabled" style
of probing is in use - semaphore offset.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/libbpf.c | 84 ++++++++++++++++++++++++++++++++++++++++++++++----
 tools/lib/bpf/libbpf.h |  9 +++++-
 2 files changed, 86 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index bccc26a..cdcd799 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10275,6 +10275,52 @@ static ssize_t find_elf_func_offset(Elf *elf, const char *name)
 	return ret;
 }
 
+struct sdt_note {
+	uint64_t	pc;
+	uint64_t	base_addr;
+	uint64_t	semaphore;
+	const char	provider_probe[256];
+};
+
+/* Find offset of USDT probe in object specified in ELF notes.
+ * Note may also specify semaphore offset, record value in *semaphore_offp.
+ */
+static ssize_t find_elf_usdt_offset(Elf *elf, const char *provider,
+				    const char *name, ssize_t *semaphore_offp)
+{
+	Elf_Data *data = NULL;
+	Elf_Scn *scn = NULL;
+
+	while ((scn = find_elfscn(elf, SHT_NOTE, scn)) > 0) {
+		while ((data = elf_getdata(scn, data)) != 0) {
+			size_t name_off, desc_off, off;
+			GElf_Nhdr nhdr;
+
+			while ((off = gelf_getnote(data, off, &nhdr,
+						   &name_off, &desc_off)) != 0) {
+				struct sdt_note *sdt_note;
+				const char *probe;
+
+				if (nhdr.n_namesz != 8 ||
+				    memcmp((char *)data->d_buf + name_off, "stapsdt", 8) != 0)
+					continue;
+				sdt_note = (struct sdt_note *)(data->d_buf + desc_off);
+				if (strcmp(provider, sdt_note->provider_probe) != 0)
+					continue;
+				/* probe is after null-terminated provider */
+				probe = sdt_note->provider_probe +
+					strlen(sdt_note->provider_probe) + 1;
+				if (strcmp(probe, name) != 0)
+					continue;
+
+				*semaphore_offp = (ssize_t)sdt_note->semaphore;
+				return (ssize_t)sdt_note->pc;
+			}
+		}
+	}
+	return -ENOENT;
+}
+
 LIBBPF_API struct bpf_link *
 bpf_program__attach_uprobe_opts(const struct bpf_program *prog, pid_t pid,
 				const char *binary_path, size_t func_offset,
@@ -10286,7 +10332,7 @@ static ssize_t find_elf_func_offset(Elf *elf, const char *name)
 	size_t ref_ctr_off;
 	int pfd, err;
 	bool retprobe, legacy;
-	const char *func_name;
+	const char *func_name, *usdt_name, *usdt_provider;
 
 	if (!OPTS_VALID(opts, bpf_uprobe_opts))
 		return libbpf_err_ptr(-EINVAL);
@@ -10296,11 +10342,25 @@ static ssize_t find_elf_func_offset(Elf *elf, const char *name)
 	pe_opts.bpf_cookie = OPTS_GET(opts, bpf_cookie, 0);
 
 	func_name = OPTS_GET(opts, func_name, NULL);
-	if (func_name) {
-		ssize_t sym_off, rel_off;
+	usdt_provider = OPTS_GET(opts, usdt_provider, NULL);
+	usdt_name = OPTS_GET(opts, usdt_name, NULL);
+	if (func_name || usdt_name) {
+		ssize_t sym_off, rel_off, semaphore_off = 0;
 		Elf *elf;
 		int fd;
 
+		if (func_name && usdt_name) {
+			pr_warn("both func_name and usdt_name cannot be specified\n");
+			return libbpf_err_ptr(-EINVAL);
+		}
+		if (usdt_name && (func_offset || ref_ctr_off)) {
+			pr_warn("func_offset argument, ref_ctr_off option should be 0 when usdt_name is used\n");
+			return libbpf_err_ptr(-EINVAL);
+		}
+		if (usdt_name && !usdt_provider) {
+			pr_warn("usdt_provider and usdt_name must be supplied\n");
+			return libbpf_err_ptr(-EINVAL);
+		}
 		if (pid == -1) {
 			/* system-wide probing is not supported; we need
 			 * a running process to determine offsets.
@@ -10330,20 +10390,32 @@ static ssize_t find_elf_func_offset(Elf *elf, const char *name)
 			close(fd);
 			return libbpf_err_ptr(-LIBBPF_ERRNO__FORMAT);
 		}
-		sym_off = find_elf_func_offset(elf, func_name);
+		if (func_name)
+			sym_off = find_elf_func_offset(elf, func_name);
+		else
+			sym_off = find_elf_usdt_offset(elf, usdt_provider, usdt_name,
+						       &semaphore_off);
 		close(fd);
 		elf_end(elf);
 		if (sym_off < 0) {
-			pr_debug("could not find sym offset for %s\n", func_name);
+			pr_debug("could not find sym offset for %s\n", func_name ?: usdt_name);
 			return libbpf_err_ptr(sym_off);
 		}
 		rel_off = get_rel_offset(pid, sym_off);
 		if (rel_off < 0) {
 			pr_debug("could not find relative offset for %s at 0x%lx\n",
-				 func_name, sym_off);
+				 func_name ?: usdt_name, sym_off);
 			return libbpf_err_ptr(rel_off);
 		}
 		func_offset += (size_t)rel_off;
+		if (semaphore_off) {
+			ref_ctr_off = get_rel_offset(pid, semaphore_off);
+			if (ref_ctr_off < 0) {
+				pr_debug("could not find relative offset for semaphore for %s at 0x%lx\n",
+					 usdt_name, semaphore_off);
+				return libbpf_err_ptr(ref_ctr_off);
+			}
+		}
 	}
 
 	legacy = determine_uprobe_perf_type() < 0;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 40cb5ae..fcad6b1 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -439,9 +439,16 @@ struct bpf_uprobe_opts {
 	 * argument to specify argument _within_ the function.
 	 */
 	const char *func_name;
+	/* name of USDT (Userland Static-Defined Tracing) provider/probe.
+	 * Offsets of USDT probe and associated semaphore (if any) are found
+	 * in ELF notes.  Note that if usdt_name is specified, func_offset
+	 * argument and ref_ctr_offset values should be zero.
+	 */
+	const char *usdt_provider;
+	const char *usdt_name;
 	size_t :0;
 };
-#define bpf_uprobe_opts__last_field func_name
+#define bpf_uprobe_opts__last_field usdt_name
 
 /**
  * @brief **bpf_program__attach_uprobe()** attaches a BPF program
-- 
1.8.3.1

