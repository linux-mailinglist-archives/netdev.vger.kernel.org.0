Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5DE4A4B8A
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 17:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379648AbiAaQNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 11:13:13 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:43924 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349651AbiAaQNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 11:13:08 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VFx21n031412;
        Mon, 31 Jan 2022 16:12:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=XT6/J332vzrfsQjZeYLEA0jnrN1qvH4FqmwmPAJHpBM=;
 b=IZYT0Z5HiDcrQgTjb9W3J9D/x3pV71xOIUKkQ86YOSBpLUtbzLhmJPpgPXzC7CQz6IF7
 kNEavJ9gbVZ40rOEeTvKOpugYzgA/UHtwFRE7w+1lv4ioWr+9I6RoAb8fxi0d6OPCctj
 +JmHd+VU7MTwBfzkxeuIh+g7SPNtH5/nxzrMOkzX97X9q8rtRjwoNHm1yyUpr+RhZQQh
 8F89KE5Q8lO758RkiDOLh/wpRa9sW9bb6pvpLUwC6j3wRkR5Oos9kGZCrSkFI8pAIFoF
 tKfGKkTGXUTCdZG4hJaoUsCY5PIJSAtTstL7moz6vTIR15nc0UAlW6T4YAsmJ4avaAVj 6w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxj9v86dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 16:12:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20VGB6DG195237;
        Mon, 31 Jan 2022 16:12:45 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by aserp3020.oracle.com with ESMTP id 3dvwd4j528-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 16:12:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZdQ5vMOLUJNAszCgYzk+av+iGthYmMLLesmIcoRYo4ITenAvrG/LAR6sRXy2bNILh20yYN3hgJyhsa77BRSyIl+w+4qpS4Q8aNWQIwoWagG+y0uz3+raZtcj5+CpJKlT91Ci5SkKvqc7ntgrWUTGkeRxaVicdWGYVBRkPTbc382yYghCP10ZI3Dyrp2RDBgBnDUaYPnCHZ+n/Fg1QX1QCGjtgxwVcssPHFueLXeeYjiBvMbe5equacZ9sk3UeKp+HOCWT5pzL37VFUzVEAUUE/oRQGa1tMH462wdEMrYiIZl+1KqcPxuSNluqL9mpt3RexfRJrFjXZEa/aQn6TCrAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XT6/J332vzrfsQjZeYLEA0jnrN1qvH4FqmwmPAJHpBM=;
 b=BSXgkZSr0nHIrxLxX/pDvN+OOs7vSgP3FJ6qwdApRip8pbAcrL0IRaqnF/x5GH2/p1gmcXxKIp8fxyr02DkNbRmLSscGzxF14txXXsqMIy/n3Z5gNFvHXGuvZfsi+SWNXFR/FR8Pc3jl9+HQTb1a9E1shBGk7QiJ/P15V4qIi077YvDmfTMuNqWM9Weh0VsH2pCau9VG4FyTvMjHoLExkWSYyqUqj+F3kQ3oNxg2yeyKCL3trtoPFFyUQ7LC0cIsS9Y+4V8AIirIrhKnuaIKseH/chPkhqRROKA0JFP5c24wSPTi5M3J6y2ranPZkincvKp+oxVhFWMkOl6u32tywA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XT6/J332vzrfsQjZeYLEA0jnrN1qvH4FqmwmPAJHpBM=;
 b=oXl7FfhKenXlOOOz8t4KdCDVGjUqZEcTjQZcVYRNLIUSI6pf4ENTSiKpnpmiRyncYZ0E7ZEJ+mtX0QQamkldukSlnyci3wfJw1aESyPOlEFym7E63OiwaOIhlbQYzKVxog7gFb5ARdKeTDYHdavyN4QtQA40ADXEB2KSPcFVAd4=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BN7PR10MB2516.namprd10.prod.outlook.com (2603:10b6:406:c1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
 2022 16:12:42 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6%6]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 16:12:42 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v3 bpf-next 1/4] libbpf: support function name-based attach uprobes
Date:   Mon, 31 Jan 2022 16:12:31 +0000
Message-Id: <1643645554-28723-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1643645554-28723-1-git-send-email-alan.maguire@oracle.com>
References: <1643645554-28723-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0124.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::29) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9423111-9fa9-4331-aa51-08d9e4d48220
X-MS-TrafficTypeDiagnostic: BN7PR10MB2516:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB251650888FB86C9300AAFD7CEF259@BN7PR10MB2516.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 59ua2A8zHrUm2HGGU7PPq9dvckK6EsGlRKYKSTDQK21LHRZRa6x3u9SVJSMdDbEQV7OZn27PXoO31X+g8CKCwhWYTd3R/SdvL8zQdNZQ7jdRbIyRz3hZY4OEPJ8SvjhPUbIzUOUduKT85GdHt8lUiFWA48rXR3jCNeLWQnAy4WVeqhcU1CikpHDd6vrlcNI1As716LGoMkwmCGjsBmXyj0penrxkDm2LGVUWb+lHNAKDzhmWDy90ldTc86rHUJZac/h3Uc0dr41gZqne92BRvjN5pP+mIsyj7JUvV9l0ddLbhXmlHN18RD6v/2CB99Lz0rTLMk/rX/4GLlsl1mvGlMtME/SHeM0WLX59stfSzUm4HvYbHFjf6w8piFhHGdaKiaGo7v/nqmb0E+W/WRyHuRZgZBksNNS9JyyzW5asFm+ADyE9cdwgjAMDbpWOKU3v+ZndRLrdynRhOQlkCaBpDp/q63Ym1XPXk84TB0E5iYxM43SIiWwOfyj1oDg678gUnm5aaY4KVKpjxJiDSovjEszENb7hrMQe3hrDMFcHw2BewEnoiPsh/8oZNt4Y6dg6NDYJHKbhFBI5I8C/oYkahPYv6H4sdE6SWhDyMb6YLj6oAYp0dkgWA+PH0hCBMBvnV1ptGubg/OUg7sYfCts8bnPUTwqraY1KM3BpO7aY6JQDv6P2tiRA/8Wj1F9G1aVA3e3uAKKq5g7lVxwiNVG6G7MsE+VCZLtmfS/zgPe/fyorWOFkUYYerZqsA7jxvqKZa6dzSa0OKzVf6s6+tDcmdlMAZArCeBbwVZId7cy9DDk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(186003)(38350700002)(6486002)(38100700002)(966005)(5660300002)(6666004)(107886003)(2616005)(52116002)(86362001)(508600001)(6512007)(6506007)(316002)(83380400001)(44832011)(8936002)(4326008)(8676002)(66946007)(2906002)(66556008)(66476007)(7416002)(36756003)(30864003)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z869li6at8jHNxQtedzwYdlkDVMmrqZWDUkXCP8AvGwLq0HTa2nOGJe+Jwzq?=
 =?us-ascii?Q?awjK0CFCash8YfSBnrfUl1CDIxGWbAMl6pJZTIfp86IxTHUt1zMLZfA4QxNz?=
 =?us-ascii?Q?GMsxkv4ImHt8aeqAjKmHtetqciQXkd+Wp8AuPQiS7AhsuYbe1LtU3dLlemK1?=
 =?us-ascii?Q?048FiYqmms+Ju5Q8XdqD+U5/yC5G4wruiHTBC3SkvPW1rH8WbHc3E0BQugLV?=
 =?us-ascii?Q?9T6S7umUCHNQCoa9DZXiIppgOWyEXVd2jIuNm/6IXohdvCXcfVjUcKAjNNAN?=
 =?us-ascii?Q?banzPW5wbKjYRXuf3AeoZuO3xRlxHnpWQChEB/418qyO0LcdhrEMy2hiSl0k?=
 =?us-ascii?Q?gB0r7Dxun2QHGt6ylEGVNeuvHV49XAyqRrOVoPqOUUhtAmStxnzjiE1Ksgip?=
 =?us-ascii?Q?WcV3DorfelUn0Q18t77uTIxW8IC8kRaG9jaAuPUrrDkJTOazXFFhAHMCGaAc?=
 =?us-ascii?Q?hkO/jg5fXLtiOKx/RhYnytYmdTnzHd/Gqm5vbUJe0eUjpR9n/JFjblfh+UV5?=
 =?us-ascii?Q?ffp+wLVJ92aVffe5/eu2qbyG9Mz8OgmqBQF352eeKdU89csjnH5U1IxGWeN2?=
 =?us-ascii?Q?tCjt1ZLb77CgcBXhznIBXZh9R8CDuHNqtYGGucKJqy0fYYMd8BzpZCqKYu/l?=
 =?us-ascii?Q?SZVPoeX+K92i3qcs0Okx6859O+ra99ei5J95+efi+j8VIc5sVVOSPK0cGYvz?=
 =?us-ascii?Q?YsFolQyNk7C5Q7GWpsSnwuFNfPdzS8vuGNWmtw4JEFWC4liyybSXaJzVWB4u?=
 =?us-ascii?Q?lXMC2pUI19eUqTdz82jSqgmmxRGUTCcKbnLik897ZV4PlqNYW9pJpcy5zu1i?=
 =?us-ascii?Q?cEsLKe87OjDnwDKdo8AD8eStsIppjucpPQEqWetfMb00vMqzqMR1CsnzyCga?=
 =?us-ascii?Q?Lk1/PrEHAxJHOwLYXriiq6awZoAb6dPLFrlMpNrAI9JmhyiJ1jtSneFn3JZs?=
 =?us-ascii?Q?hSMJ4Zt25roLGHqQfwR5Tbb9NZNLKSmr3O4LMYDqUb7zudww0jmq7GxEIZhr?=
 =?us-ascii?Q?TRS1ecmBZ6m1dTAVu5AYgxUBe3poDXkZ27i2g0/E+LUshbqH915JvlmXbL3Q?=
 =?us-ascii?Q?PG0P4cLWsnCEoejeszoeutdGmFXqTu5ma/5jflcaObpChVvDy/4zaJW8Pdzk?=
 =?us-ascii?Q?7ScyOCC5Ttzsz6h3OFriw/yQNuAL3zIXi46WhK8sgdBRhttKyWjCSWrdhpZB?=
 =?us-ascii?Q?GpzJ3LUbqmkUuyOGqF52tlS8l/oUdRqui5brNn/CvprU5MSGZqWz5fo5T9j2?=
 =?us-ascii?Q?5+XaqM9LEwJm14COuo7Yq1GDAeodI3dvItAalYOqQhnCAXDhbierFcfxaM92?=
 =?us-ascii?Q?Pk2RfHg3n5+GkxpKOnfZFehlf17xscH+rg1mdhwYcgIgmT8s7sAr5NhZPSJY?=
 =?us-ascii?Q?TABNnJwErilZzcpuhedy++mmVnhwdYIfTPIAZUYyhoOTLJFcVxqTFWvyOMFm?=
 =?us-ascii?Q?UxS/1G19WYUC7mZrvB+31u6IGbKbExpBhM2xy2G5J2+rChZ2TFBwctI13/6q?=
 =?us-ascii?Q?EZRbwAWFuZSHVTL4BnqGKdFFEwuriRMR1mHMopVotQIRIZkna/kH5aS4xjl0?=
 =?us-ascii?Q?GKSyXoZxkFFsvHQCRxNe/d8AvHHSAF+Y/fsUx57r+YWIKL1U1b+dAIlZQoQK?=
 =?us-ascii?Q?cqGJKoNlAmDUNJjhAjzySMc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9423111-9fa9-4331-aa51-08d9e4d48220
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 16:12:41.8107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SlWWvEAaZYMres5nBrNq8/UykOWqJrYlrFBEoAAvq3ZdM/cxUNExz6kXo7dIP53lLRTaiR843qLh1vG0QjrbqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2516
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10244 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201310106
X-Proofpoint-ORIG-GUID: dqlqxv_dh8EEl0G0VETxlYTuY_Fj5e7W
X-Proofpoint-GUID: dqlqxv_dh8EEl0G0VETxlYTuY_Fj5e7W
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kprobe attach is name-based, using lookups of kallsyms to translate
a function name to an address.  Currently uprobe attach is done
via an offset value as described in [1].  Extend uprobe opts
for attach to include a function name which can then be converted
into a uprobe-friendly offset.  The calcualation is done in
several steps:

1. First, determine the symbol address using libelf; this gives us
   the offset as reported by objdump; then, in the case of local
   functions
2. If the function is a shared library function - and the binary
   provided is a shared library - no further work is required;
   the address found is the required address
3. If the function is a shared library function in a program
   (as opposed to a shared library), the Procedure Linking Table
   (PLT) table address is found (it is indexed via the dynamic
   symbol table index).  This allows us to instrument a call
   to a shared library function locally in the calling binary,
   reducing overhead versus having a breakpoint in global lib.
4. Finally, if the function is local, subtract the base address
   associated with the object, retrieved from ELF program headers.

The resultant value is then added to the func_offset value passed
in to specify the uprobe attach address.  So specifying a func_offset
of 0 along with a function name "printf" will attach to printf entry.

The modes of operation supported are then

1. to attach to a local function in a binary; function "foo1" in
   "/usr/bin/foo"
2. to attach to a shared library function in a binary;
   function "malloc" in "/usr/bin/foo"
3. to attach to a shared library function in a shared library -
   function "malloc" in libc.

[1] https://www.kernel.org/doc/html/latest/trace/uprobetracer.html

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/libbpf.c | 250 +++++++++++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h |  10 +-
 2 files changed, 259 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 4ce94f4..eb95629 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10203,6 +10203,241 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 	return pfd;
 }
 
+/* uprobes deal in relative offsets; subtract the base address associated with
+ * the mapped binary.  See Documentation/trace/uprobetracer.rst for more
+ * details.
+ */
+static long elf_find_relative_offset(Elf *elf,  long addr)
+{
+	size_t n;
+	int i;
+
+	if (elf_getphdrnum(elf, &n)) {
+		pr_warn("elf: failed to find program headers: %s\n",
+			elf_errmsg(-1));
+		return -ENOENT;
+	}
+
+	for (i = 0; i < n; i++) {
+		int seg_start, seg_end, seg_offset;
+		GElf_Phdr phdr;
+
+		if (!gelf_getphdr(elf, i, &phdr)) {
+			pr_warn("elf: failed to get program header %d: %s\n",
+				i, elf_errmsg(-1));
+			return -ENOENT;
+		}
+		if (phdr.p_type != PT_LOAD || !(phdr.p_flags & PF_X))
+			continue;
+
+		seg_start = phdr.p_vaddr;
+		seg_end = seg_start + phdr.p_memsz;
+		seg_offset = phdr.p_offset;
+		if (addr >= seg_start && addr < seg_end)
+			return addr -  seg_start + seg_offset;
+	}
+	pr_warn("elf: failed to find prog header containing 0x%lx\n", addr);
+	return -ENOENT;
+}
+
+/* Return next ELF section of sh_type after scn, or first of that type
+ * if scn is NULL.
+ */
+static Elf_Scn *elf_find_next_scn_by_type(Elf *elf, int sh_type, Elf_Scn *scn)
+{
+	while ((scn = elf_nextscn(elf, scn)) != NULL) {
+		GElf_Shdr sh;
+
+		if (!gelf_getshdr(scn, &sh))
+			continue;
+		if (sh.sh_type == sh_type)
+			break;
+	}
+	return scn;
+}
+
+/* For Position-Independent Code-based libraries, a table of trampolines
+ * (Procedure Linking Table) is used to support resolution of symbol
+ * names at linking time.  The goal here is to find the offset associated
+ * with the jump to the actual library function.  If we can instrument that
+ * locally in the specific binary (rather than instrumenting glibc say),
+ * overheads are greatly reduced.
+ *
+ * The method used is to find the .plt section and determine the offset
+ * of the relevant entry (given by the base address plus the index
+ * of the function multiplied by the size of a .plt entry).
+ */
+static ssize_t elf_find_plt_offset(Elf *elf, size_t ndx)
+{
+	Elf_Scn *scn = NULL;
+	size_t shstrndx;
+
+	if (elf_getshdrstrndx(elf, &shstrndx)) {
+		pr_debug("elf: failed to get section names section index: %s\n",
+			 elf_errmsg(-1));
+		return -LIBBPF_ERRNO__FORMAT;
+	}
+	while ((scn = elf_find_next_scn_by_type(elf, SHT_PROGBITS, scn))) {
+		long plt_entry_sz, plt_base;
+		const char *name;
+		GElf_Shdr sh;
+
+		if (!gelf_getshdr(scn, &sh))
+			continue;
+		name = elf_strptr(elf, shstrndx, sh.sh_name);
+		if (!name || strcmp(name, ".plt") != 0)
+			continue;
+		plt_base = sh.sh_addr;
+		plt_entry_sz = sh.sh_entsize;
+		return plt_base + (ndx * plt_entry_sz);
+	}
+	pr_debug("elf: no .plt section found\n");
+	return -LIBBPF_ERRNO__FORMAT;
+}
+
+/* Find offset of function name in object specified by path.  "name" matches
+ * symbol name or name@@LIB for library functions.
+ */
+static long elf_find_func_offset(const char *binary_path, const char *name)
+{
+	int fd, i, sh_types[2] = { SHT_DYNSYM, SHT_SYMTAB };
+	bool is_shared_lib, is_name_qualified;
+	size_t name_len, sym_ndx = -1;
+	char errmsg[STRERR_BUFSIZE];
+	long ret = -ENOENT;
+	GElf_Ehdr ehdr;
+	Elf *elf;
+
+	fd = open(binary_path, O_RDONLY | O_CLOEXEC);
+	if (fd < 0) {
+		ret = -errno;
+		pr_warn("failed to open %s: %s\n", binary_path,
+			libbpf_strerror_r(ret, errmsg, sizeof(errmsg)));
+		return ret;
+	}
+	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
+	if (!elf) {
+		pr_warn("elf: could not read elf from %s: %s\n", binary_path, elf_errmsg(-1));
+		close(fd);
+		return -LIBBPF_ERRNO__FORMAT;
+	}
+	if (!gelf_getehdr(elf, &ehdr)) {
+		pr_warn("elf: failed to get ehdr from %s: %s\n", binary_path, elf_errmsg(-1));
+		ret = -LIBBPF_ERRNO__FORMAT;
+		goto out;
+	}
+	/* for shared lib case, we do not need to calculate relative offset */
+	is_shared_lib = ehdr.e_type == ET_DYN;
+
+	name_len = strlen(name);
+	/* Does name specify "@@LIB"? */
+	is_name_qualified = strstr(name, "@@") != NULL;
+
+	/* Search SHT_DYNSYM, SHT_SYMTAB for symbol.  This search order is used because if
+	 * the symbol is found in SHY_DYNSYM, the index in that table tells us which index
+	 * to use in the Procedure Linking Table to instrument calls to the shared library
+	 * function, but locally in the binary rather than in the shared library ifself.
+	 * If a binary is stripped, it may also only have SHT_DYNSYM, and a fully-statically
+	 * linked binary may not have SHT_DYMSYM, so absence of a section should not be
+	 * reported as a warning/error.
+	 */
+	for (i = 0; i < ARRAY_SIZE(sh_types); i++) {
+		size_t strtabidx, ndx, nr_syms;
+		Elf_Data *symbols = NULL;
+		Elf_Scn *scn = NULL;
+		int last_bind = -1;
+		const char *sname;
+		GElf_Shdr sh;
+
+		scn = elf_find_next_scn_by_type(elf, sh_types[i], NULL);
+		if (!scn) {
+			pr_debug("elf: failed to find symbol table ELF sections in %s\n",
+				 binary_path);
+			continue;
+		}
+		if (!gelf_getshdr(scn, &sh))
+			continue;
+		strtabidx = sh.sh_link;
+		symbols = elf_getdata(scn, 0);
+		if (!symbols) {
+			pr_warn("elf: failed to get symbols for symtab section in %s: %s\n",
+				binary_path, elf_errmsg(-1));
+			ret = -LIBBPF_ERRNO__FORMAT;
+			goto out;
+		}
+		nr_syms = symbols->d_size / sh.sh_entsize;
+
+		for (ndx = 0; ndx < nr_syms; ndx++) {
+			int curr_bind;
+			GElf_Sym sym;
+
+			if (!gelf_getsym(symbols, ndx, &sym))
+				continue;
+			if (GELF_ST_TYPE(sym.st_info) != STT_FUNC)
+				continue;
+
+			sname = elf_strptr(elf, strtabidx, sym.st_name);
+			if (!sname)
+				continue;
+			curr_bind = GELF_ST_BIND(sym.st_info);
+
+			/* User can specify func, func@@LIB or func@@LIB_VERSION. */
+			if (strncmp(sname, name, name_len) != 0)
+				continue;
+			/* ...but we don't want a search for "foo" to match 'foo2" also, so any
+			 * additional characters in sname should be of the form "@@LIB".
+			 */
+			if (!is_name_qualified && strlen(sname) > name_len &&
+			    sname[name_len] != '@')
+				continue;
+
+			if (ret >= 0 && last_bind != -1) {
+				/* handle multiple matches */
+				if (last_bind != STB_WEAK && curr_bind != STB_WEAK) {
+					/* Only accept one non-weak bind. */
+					pr_warn("elf: ambiguous match for '%s': %s\n",
+						sname, name);
+					ret = -LIBBPF_ERRNO__FORMAT;
+					goto out;
+				} else if (curr_bind == STB_WEAK) {
+					/* already have a non-weak bind, and
+					 * this is a weak bind, so ignore.
+					 */
+					continue;
+				}
+			}
+			ret = sym.st_value;
+			last_bind = curr_bind;
+			sym_ndx = ndx;
+		}
+		/* The index of the entry in SHT_DYNSYM gives us the index into the PLT */
+		if (ret == 0 && sh_types[i] == SHT_DYNSYM)
+			ret = elf_find_plt_offset(elf, sym_ndx);
+		/* For binaries that are not shared libraries, we need relative offset */
+		if (ret > 0 && !is_shared_lib)
+			ret = elf_find_relative_offset(elf, ret);
+		if (ret > 0)
+			break;
+	}
+
+	if (ret > 0) {
+		pr_debug("elf: symbol address match for '%s': 0x%lx\n", name, ret);
+	} else {
+		if (ret == 0) {
+			pr_warn("elf: '%s' is 0 in symtab for '%s': %s\n", name, binary_path,
+				is_shared_lib ? "should not be 0 in a shared library" :
+						"try using shared library path instead");
+			ret = -ENOENT;
+		} else {
+			pr_warn("elf: failed to find symbol '%s' in '%s'\n", name, binary_path);
+		}
+	}
+out:
+	elf_end(elf);
+	close(fd);
+	return ret;
+}
+
 LIBBPF_API struct bpf_link *
 bpf_program__attach_uprobe_opts(const struct bpf_program *prog, pid_t pid,
 				const char *binary_path, size_t func_offset,
@@ -10214,6 +10449,7 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 	size_t ref_ctr_off;
 	int pfd, err;
 	bool retprobe, legacy;
+	const char *func_name;
 
 	if (!OPTS_VALID(opts, bpf_uprobe_opts))
 		return libbpf_err_ptr(-EINVAL);
@@ -10222,6 +10458,20 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 	ref_ctr_off = OPTS_GET(opts, ref_ctr_offset, 0);
 	pe_opts.bpf_cookie = OPTS_GET(opts, bpf_cookie, 0);
 
+	func_name = OPTS_GET(opts, func_name, NULL);
+	if (func_name) {
+		long sym_off;
+
+		if (!binary_path) {
+			pr_warn("name-based attach requires binary_path\n");
+			return libbpf_err_ptr(-EINVAL);
+		}
+		sym_off = elf_find_func_offset(binary_path, func_name);
+		if (sym_off < 0)
+			return libbpf_err_ptr(sym_off);
+		func_offset += (size_t)sym_off;
+	}
+
 	legacy = determine_uprobe_perf_type() < 0;
 	if (!legacy) {
 		pfd = perf_event_open_probe(true /* uprobe */, retprobe, binary_path,
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 5762b57..1de3eeb 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -433,9 +433,17 @@ struct bpf_uprobe_opts {
 	__u64 bpf_cookie;
 	/* uprobe is return probe, invoked at function return time */
 	bool retprobe;
+	/* name of function name or function@@LIBRARY.  Partial matches
+	 * work for library functions, such as printf, printf@@GLIBC.
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

