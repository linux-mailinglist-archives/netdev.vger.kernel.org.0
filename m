Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDDD48C81F
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 17:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355073AbiALQUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 11:20:11 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:8116 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355108AbiALQTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 11:19:22 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20CG8KaX001321;
        Wed, 12 Jan 2022 16:19:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ZexGXTclLJjvBdSCrhjcVcDCZ+XNVIEJ82Fb3JEoMHQ=;
 b=X2I23Wf/vys6Oy/GzrwIP0jh+8HjiFxEPNvgNcTVuBgw2Ne+aOonUvVFJafD2OeBdycW
 HvDpB2FGnZb/pNBS3kjp6h7o8Zad7qjhqT0k5R9jg6DEW/yG6kVAIq1qgnTHq/dwRGEY
 30lG8ff6mU9zjI2IGJMsEfAu9oRzBcIXZLJnfovrrfzg8Pc9HqqqYmNaAFYz+NkTTsyW
 ew1JcVzPN+Snx4lmfKr3jrPibKxQ+fv6WyCuJIwFAJQdL1HgI5/uCAnVu/S3JU5AMUHz
 Blz3JjsrS0z6rzmE8GLE1cDklmzkVLjAkXe0nB0qN7Mnv7fIYTxJgN/Ik6WKL/ZThuY+ +w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgp7npq41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jan 2022 16:19:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20CG8DFs073509;
        Wed, 12 Jan 2022 16:18:59 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by userp3030.oracle.com with ESMTP id 3deyr051ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jan 2022 16:18:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n7aG4Nm6xR6MjhZFVj07nsM6AokatU7mtnJ6gPGlob0w64vqF5Irc/QWlULsheO10hfAtJvEc5mC6z3j8mmOwFHk5OfzaIkW7W+iKxH6HVZ4qWXtZXU2KFFXmpG88ckmkzyGehgv2xgdTj0v+zwwdwNSsX/eOzFYUtm3BRq2h1Z7UtH+IUFVzxqjAtifRkLkRpqlaA0mnd6UfKCtAlWzZ6aH30zuquECzdCOfrfLc1DuaclfzLVu7S0Czfl+Nyz/prDRtcJrOMTBo5cCueS7zqif93KVBJcz0A+6uP/crdaBrLsbassPBKXWYYWY4lZZNFI+40r2QNp9mDLxWkMy6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZexGXTclLJjvBdSCrhjcVcDCZ+XNVIEJ82Fb3JEoMHQ=;
 b=Avz31YCHBLtrsTeYCFo8L8PBSs6nOoM0Bo6PN4DzaqULactVVmEo4JRizvAPg8YiRzOvCQn15ccpPY2Tbx2xhoDvM0TG/WIJJIx5A1ID2AHxRa96r07O0jFPRU1WjysLV6/PYrKlQbIoSdUG5Irr7fL6Jp1+Oitzc+ArIB/FyWpHbHvV2X+bXofWxh7ykbs5t+Jlf/uiHMqikqYHVpMGzAh1w4GJBMgszje1tK4EXSnk8E1tsNT/kMDeYaAX67qivEHnE2tcRKsHgV3J7JViS79CnD/QbLqaqMlyzz7slk6aiRwUZ/7vSwTWUu1a/Hy0YvZfWXNzlOGXixOqfAk+Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZexGXTclLJjvBdSCrhjcVcDCZ+XNVIEJ82Fb3JEoMHQ=;
 b=XStBpRrIkjl1UUcz44DlsSg0pBOrL3Krk8ymUhf+Y5Rqg6yewiFvq7BF+4uAYQPSL1MC7yWSyAOOGC5dd66dFtjJtIMYQ03RKMwOdI21kMqq8f7uzE2E4ndPPO7AFkxcBcRtgdYyLVbc1IdhaiU8kPdARjELx9F+9CNsewP4Y44=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3600.namprd10.prod.outlook.com (2603:10b6:208:114::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Wed, 12 Jan
 2022 16:18:57 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::31c1:e20b:33a1:ba8c]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::31c1:e20b:33a1:ba8c%5]) with mapi id 15.20.4888.009; Wed, 12 Jan 2022
 16:18:57 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC bpf-next 1/4] libbpf: support function name-based attach for uprobes
Date:   Wed, 12 Jan 2022 16:18:46 +0000
Message-Id: <1642004329-23514-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1642004329-23514-1-git-send-email-alan.maguire@oracle.com>
References: <1642004329-23514-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0080.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::13) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef39e37d-92ba-44ce-cdee-08d9d5e73bd9
X-MS-TrafficTypeDiagnostic: MN2PR10MB3600:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB36006564DAC43610B2B113F4EF529@MN2PR10MB3600.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /87Cuklmt5B+vSdg304Zj6Wr1kW/Ex5cRyBCvK/1qRzJw1IPX9H+lKL82gjm2esuK9BEVwOP0lRMWXyqZjT6fHHZKjuwX0WgqHghe87H9jLYOeDvLrR1bhtUeIBAPf5Z1CfUR7QXth7zRvVCRjEayovQk0yGRyCIocpVP7XEYKoMxP4zwfZsGy4pSvtQb6Yui5btUXA3XTemt183LBklaUz9PHCklvhLNQ2s1jfIQbcuxtfD9gRw4SMmlUpNR4dXhPXB/AGmgqYfzOekzf/K3eHjsXeQajYhnxBReT64tV7N9vn6L9iKjgtmUkb+Xc3KoQ0Nw/cWS0XvD42+OTxomsuyIep/V0mNxE+i/cOL5kXZujYe5rY4GZkmQ/XMHCXtDbs826NmdWNrtpz/NXXhq7pRCrTD3MkaKBk249S+rB9kwPwlgsHLzVZXLIvfjnP7N5bAL0Y6pGIhv4jHS9PnXktJangUzBDmUaHdn7/PoKU01q2YxAotMgQKDOitgjL0Cs3tbTykexVoqbNYO0grAU7lfPXS5S0GF8oAqtiiMrefn6CbPYU64N9QYS0MCo6lCLhqb8C99gd6vLX9WM+jlbjKolMEri+q30JvitWeWeRVW4hyAOUSseF4I4RdhdDGOiYp2QNzE0JgEA55BSOne5nu+8PFTMrGsZvLCyKV6LvIVSGjMdHfP6tB88AQOldYp99kKb3EQFtANXj19YcrbsRGGUAY9dFLXjLSxcWVyO5KFKrKEvYzLR2BwbT3tvwykgFPg975t7302xpOMLdfje1yRvKRTZpdzNXmrBKON+Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(8676002)(66476007)(8936002)(6486002)(36756003)(66946007)(2616005)(5660300002)(44832011)(107886003)(6512007)(66556008)(316002)(86362001)(7416002)(966005)(83380400001)(2906002)(4326008)(52116002)(26005)(38100700002)(6506007)(6666004)(186003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+xSxiD2dGg10R2Jga0cRSmmuIb5fsjaNGfTfuYkoocHpw+17ygPYxo6wqAHO?=
 =?us-ascii?Q?DgcU0LFK9kzMopuiwNs6/Vv0tuFiIz5Zonr3rn7tN8ucls9IIK7DW+PkZ+3U?=
 =?us-ascii?Q?oHAU1y9ikQjmR3x3swE0cTva1sQPvbYvrOJGMsV+DDjvkbFdCd3DsOalzNlB?=
 =?us-ascii?Q?1Js924t7G2o0NYYnhQI/RHKRaoz1zSy1WdQaxdC13jjTD7mn+CfiCFPDpGY+?=
 =?us-ascii?Q?MUEBDyDIrsgvn03DiuHXj+R1t60t+uHFc8UfIHF2khYJbkZ3A24ypjSqAD0f?=
 =?us-ascii?Q?kSnsK/01oXUGD1/pUrhRkP7Mji8aQFvO95kMjQLu9sa3M7a7c+LvpiY90HKx?=
 =?us-ascii?Q?Qpxmcp8PBP/d6s2gHBKINrBdKYOHk+F5zi42fAXtjWUk0gGL086oisH99IO0?=
 =?us-ascii?Q?72uQgFXnKO8yZmAIFYXXhG0mv4NndzWpGdCOS0eL61uzFEO+YUVG5S5WHXlP?=
 =?us-ascii?Q?G0xJ6roF2anS2Dvggk1MMt+loMy3dVq0MEeoygC49ngRo8zjkjzRfq7GUAcw?=
 =?us-ascii?Q?T70c/uDfmtAhVCw3zGVd65LuTQvwMLULGB0aBRzhBpM0p+X42hUytIdhRBIW?=
 =?us-ascii?Q?4WSm/ejyYOer7l3PuoCtee6wrXB5FeQjjdlYGpAhPLa7SJPlXfO8ofLvQ9o1?=
 =?us-ascii?Q?l4hzfR1WLmT1SS1Bm/65I6pyswYfR4b/z/QJU33Bw6akyzLY5rIMUW1SeXGq?=
 =?us-ascii?Q?5RUFyWYuys1+7GEcIKYMhyTrdlyhsgRt+Bgw8JRjKumaKgmwrHAn0kioA09f?=
 =?us-ascii?Q?qn5YsDpQMCePRMyIajw+D3XW9U9WvEyhBKaQqpQWXSBL41KHNW9S4Q43fVPk?=
 =?us-ascii?Q?bY2UATxDdaQOXfZ6LS2GAP3MF80RD8OM7a5BMvtnyWG6k6EGxL2PnjTpvGUg?=
 =?us-ascii?Q?PqIdAf8M/oFqoPuLZte+/sLPJL3lEgCsX/sddnoreF2bI/DZXemGdQWwsrGy?=
 =?us-ascii?Q?M7QChzjL7eE70Tkr3pH4R8ztvWcWaHSz3L2mD7nWQugUVZkasKsZvWUFv3lE?=
 =?us-ascii?Q?gFGyIJ6DVhHO2yVdx1ve9WeTIjxmk76KRoBcDbJ7IRnHqAMMygvmkcUM3bFJ?=
 =?us-ascii?Q?V9IYY70wx1IHbya8xQshY/A/t0um+aTMG+gbsKgWN10zmHna5IzEhUrSTj/H?=
 =?us-ascii?Q?Hwak2HHfqYUkPOTKo01GuP6QH2w1yAWxsWcLVlM09vM/GvPpvzZKOWGtqfFl?=
 =?us-ascii?Q?n+3YKNjfqOob53j+N3WAFmmvhyg/mNYlfMX6Slv9CBTpx8K2+biNZM/8L8b6?=
 =?us-ascii?Q?nEFhpvU4I+PBKkZkmKQzeAR4Yaoi0xMVrbOSiInE4CIv+NzbPI983T0HOYHn?=
 =?us-ascii?Q?fweEobmxdxq8jf7k9bZN1/51s2gqwNhba8tHC6r4jhyUQI3x4fWAHlUJTI2/?=
 =?us-ascii?Q?jt3iJ6sqpyZT26bbVdtN2UhOT23fWWSOlNiIgs33xmTCqHwdyItIriFlmO4E?=
 =?us-ascii?Q?6Pz3vSkJBaEOaoV0Q7X+Bzmzhi6k3/teQN6Uh07RwTvL/JK429HJbE9fhBiQ?=
 =?us-ascii?Q?6zakZDj5u1jmYWiVVsr3fDheebRTXmM/v326muyohfmWc0yaH04e1VkNR9Ut?=
 =?us-ascii?Q?WsF0gW6EFfI69V6ct/DDiCKnDVHZVu3in677pv5Bqjm4n69wYUQedv9AENqa?=
 =?us-ascii?Q?zDBvYV5kYTW51Cqpc9VCTsI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef39e37d-92ba-44ce-cdee-08d9d5e73bd9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 16:18:57.0582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BZSNPCrTF77Fu1w6v7N3bbS0s3NnU5ys+CoW1cziTCSr39GHvvo6aOAkMOobVBlK00sI88qxAE2h4Hm/i225iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3600
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10225 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201120103
X-Proofpoint-GUID: 9LHRPjdL9k7Rbezm8819AMN1l51zmorA
X-Proofpoint-ORIG-GUID: 9LHRPjdL9k7Rbezm8819AMN1l51zmorA
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kprobe attach is name-based, using lookups of kallsyms to translate
a function name to an address.  Currently uprobe attach is done
via an offset value as described in [1].  Extend uprobe opts
for attach to include a function name which can then be converted
into a uprobe-friendly offset.  The calcualation is done in two
steps:

- first, determine the symbol address using libelf; this gives us
  the offset as reported by objdump; then
- subtract the base address associated with the object.

The resultant value is then added to the func_offset value passed
in to specify the uprobe attach address.  So specifying a func_offset
of 0 along with a function name "printf" will attach to printf entry.

[1] https://www.kernel.org/doc/html/latest/trace/uprobetracer.html

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/libbpf.c | 172 +++++++++++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h |  10 ++-
 2 files changed, 181 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index cf862a1..bccc26a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10155,6 +10155,126 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 	return pfd;
 }
 
+/* uprobes deal in relative offsets; subtract the base address associated with
+ * the mapped binary.  See Documentation/trace/uprobetracer.rst for more
+ * details.
+ */
+static ssize_t get_rel_offset(pid_t pid, uintptr_t addr)
+{
+	size_t start, end, offset;
+	char msg[STRERR_BUFSIZE];
+	char maps[64];
+	char buf[256];
+	FILE *f;
+	int err;
+
+	/* pid 0 implies "this process" */
+	snprintf(maps, sizeof(maps), "/proc/%d/maps", pid ? pid : getpid());
+	f = fopen(maps, "r");
+	if (!f) {
+		err = -errno;
+		pr_warn("could not open %s: %s\n",
+			maps, libbpf_strerror_r(err, msg, sizeof(msg)));
+		return err;
+	}
+
+	while (fscanf(f, "%zx-%zx %s %zx %*[^\n]\n", &start, &end, buf, &offset) == 4) {
+		if (addr >= start && addr < end) {
+			fclose(f);
+			return (size_t)addr - start + offset;
+		}
+	}
+	fclose(f);
+	return -ENOENT;
+}
+
+/* find next ELF section of sh_type, returning fd and setting elfp and scnp to
+ * point at Elf and next Elf_Scn.
+ */
+static Elf_Scn *find_elfscn(Elf *elf, int sh_type, Elf_Scn *scn)
+{
+	Elf64_Shdr *sh;
+
+	while ((scn = elf_nextscn(elf, scn)) != NULL) {
+		sh = elf64_getshdr(scn);
+		if (sh && sh->sh_type == sh_type)
+			break;
+	}
+	return scn;
+}
+
+/* Find offset of function name in object specified by path.  "name" matches
+ * symbol name or name@@LIB for library functions.
+ */
+static ssize_t find_elf_func_offset(Elf *elf, const char *name)
+{
+	size_t si, strtabidx, nr_syms;
+	Elf_Data *symbols = NULL;
+	ssize_t ret = -ENOENT;
+	Elf_Scn *scn = NULL;
+	const char *sname;
+	Elf64_Shdr *sh;
+	int bind;
+
+	scn = find_elfscn(elf, SHT_SYMTAB, NULL);
+	if (!scn) {
+		pr_debug("elf: failed to find symbol table ELF section\n");
+		return -ENOENT;
+	}
+
+	sh = elf64_getshdr(scn);
+	strtabidx = sh->sh_link;
+	symbols = elf_getdata(scn, 0);
+	if (!symbols) {
+		pr_debug("elf: failed to get symtab section: %s\n", elf_errmsg(-1));
+		return -LIBBPF_ERRNO__FORMAT;
+	}
+
+	nr_syms = symbols->d_size / sizeof(Elf64_Sym);
+	for (si = 0; si < nr_syms; si++) {
+		Elf64_Sym *sym = (Elf64_Sym *)symbols->d_buf + si;
+		size_t matchlen;
+		int currbind;
+
+		if (ELF64_ST_TYPE(sym->st_info) != STT_FUNC)
+			continue;
+
+		sname = elf_strptr(elf, strtabidx, sym->st_name);
+		if (!sname) {
+			pr_debug("failed to get sym name string for var %s\n", name);
+			return -EIO;
+		}
+		currbind = ELF64_ST_BIND(sym->st_info);
+
+		/* If matching on func@@LIB, match on everything prior to
+		 * the '@@'; otherwise match on full string.
+		 */
+		matchlen = strstr(sname, "@@") ? strstr(sname, "@@") - sname :
+						 strlen(sname);
+
+		if (strlen(name) == matchlen &&
+		    strncmp(sname, name, matchlen) == 0) {
+			if (ret >= 0) {
+				/* handle multiple matches */
+				if (bind != STB_WEAK && currbind != STB_WEAK) {
+					/* Only accept one non-weak bind. */
+					pr_debug("got additional match for symbol %s: %s\n",
+						 sname, name);
+					return -LIBBPF_ERRNO__FORMAT;
+				} else if (currbind == STB_WEAK) {
+					/* already have a non-weak bind, and
+					 * this is a weak bind, so ignore.
+					 */
+					continue;
+				}
+			}
+			ret = sym->st_value;
+			bind = currbind;
+		}
+	}
+	return ret;
+}
+
 LIBBPF_API struct bpf_link *
 bpf_program__attach_uprobe_opts(const struct bpf_program *prog, pid_t pid,
 				const char *binary_path, size_t func_offset,
@@ -10166,6 +10286,7 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 	size_t ref_ctr_off;
 	int pfd, err;
 	bool retprobe, legacy;
+	const char *func_name;
 
 	if (!OPTS_VALID(opts, bpf_uprobe_opts))
 		return libbpf_err_ptr(-EINVAL);
@@ -10174,6 +10295,57 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 	ref_ctr_off = OPTS_GET(opts, ref_ctr_offset, 0);
 	pe_opts.bpf_cookie = OPTS_GET(opts, bpf_cookie, 0);
 
+	func_name = OPTS_GET(opts, func_name, NULL);
+	if (func_name) {
+		ssize_t sym_off, rel_off;
+		Elf *elf;
+		int fd;
+
+		if (pid == -1) {
+			/* system-wide probing is not supported; we need
+			 * a running process to determine offsets.
+			 */
+			pr_warn("name-based attach does not work for pid -1 (all processes)\n");
+			return libbpf_err_ptr(-EINVAL);
+		}
+		if (!binary_path) {
+			pr_warn("name-based attach requires binary_path\n");
+			return libbpf_err_ptr(-EINVAL);
+		}
+		if (elf_version(EV_CURRENT) == EV_NONE) {
+			pr_debug("failed to init libelf for %s\n", binary_path);
+			return libbpf_err_ptr(-LIBBPF_ERRNO__LIBELF);
+		}
+		fd = open(binary_path, O_RDONLY | O_CLOEXEC);
+		if (fd < 0) {
+			err = -errno;
+			pr_debug("failed to open %s: %s\n", binary_path,
+				 libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
+			return libbpf_err_ptr(err);
+		}
+		elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
+		if (!elf) {
+			pr_debug("could not read elf from %s: %s\n",
+				 binary_path, elf_errmsg(-1));
+			close(fd);
+			return libbpf_err_ptr(-LIBBPF_ERRNO__FORMAT);
+		}
+		sym_off = find_elf_func_offset(elf, func_name);
+		close(fd);
+		elf_end(elf);
+		if (sym_off < 0) {
+			pr_debug("could not find sym offset for %s\n", func_name);
+			return libbpf_err_ptr(sym_off);
+		}
+		rel_off = get_rel_offset(pid, sym_off);
+		if (rel_off < 0) {
+			pr_debug("could not find relative offset for %s at 0x%lx\n",
+				 func_name, sym_off);
+			return libbpf_err_ptr(rel_off);
+		}
+		func_offset += (size_t)rel_off;
+	}
+
 	legacy = determine_uprobe_perf_type() < 0;
 	if (!legacy) {
 		pfd = perf_event_open_probe(true /* uprobe */, retprobe, binary_path,
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 85dfef8..40cb5ae 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -431,9 +431,17 @@ struct bpf_uprobe_opts {
 	__u64 bpf_cookie;
 	/* uprobe is return probe, invoked at function return time */
 	bool retprobe;
+	/* name of function name or function@@LIBRARY.  Partial matches
+	 * work for library name, such as printf, printf@@GLIBC.
+	 * To specify function entry, func_offset argument should be 0 and
+	 * func_name should specify function to trace.  To trace an offset
+	 * within the function, specify func_name and use func_offset
+	 * argument to specify argument _within_ the function.
+	 */
+	const char *func_name;
 	size_t :0;
 };
-#define bpf_uprobe_opts__last_field retprobe
+#define bpf_uprobe_opts__last_field func_name
 
 /**
  * @brief **bpf_program__attach_uprobe()** attaches a BPF program
-- 
1.8.3.1

