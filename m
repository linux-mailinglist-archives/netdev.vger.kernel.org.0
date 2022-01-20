Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234A8494D48
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 12:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbiATLnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 06:43:05 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:43186 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231917AbiATLnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 06:43:03 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20K9n4Tg014084;
        Thu, 20 Jan 2022 11:42:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Xu6tZXLtUyH5CpypomziSHMovOGpMO5K+/+yjHShI3g=;
 b=EAZuYgyWsJCYz9Gs0RpyFCa/H9r7tLSzYNv6RlmS4FbXA9VOmh3hDurUEMqyJbc/iyTD
 UATGDHfNHC/vEO55fStFx9NiH0NdvVZnleeIS6KV1B0tizMAsMdyUoR/p8xHh0m5DIaB
 KKr67wBMWLAtB/zxMgLY8YcSA/ZmxSZGAbLzGHuXYvnOQvYiuwf8d6rcJR2gDfWi5/wf
 q+1D7p6/p53ATzyMZxLL6Ui1ZB6VP0e/HRz161Wwhi4Kd95tmnSxUNrmo5uBIJtGEvbI
 xRl+eD4hfvYBWWOeT8gfAuaUdCkDvfWRn84LOpRlESSMiwoNiVdpRuP9l+CBCkK9C4AF hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc51fr25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 11:42:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20KBaB31151224;
        Thu, 20 Jan 2022 11:42:47 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3020.oracle.com with ESMTP id 3dkqqs9385-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 11:42:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E8Hjbt5RfGpAR2HQ1rtXVUGOJsZSuIo13gG5s7dg1EU8fRvfa4h2RVtBQoKZAoBToJQaSAcgZpOpD/kfWfF/z1LTV6zu3DbeC/VFMTsnafTb7dBqMcqcV8h3NEomN5hxcPbzHpXo8SvKwKPE2JrRYRTeXdd3toDZvQU4zzpN0lYLaVW/AMT4E1buHs2P19XAwhm4DbPAXnRn8vG0MF6bgsCmSi4jXka3ahsvlNrSirQC4QU45Bw0inqqFx9NwM3WsMZ67hrixMslpuyVchTLR+Mu49ReHvELYEOJxAqWmSzfxGoCkLlgRcf29XpR83DXpH0XxlKmmfd43iPZo+KL7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xu6tZXLtUyH5CpypomziSHMovOGpMO5K+/+yjHShI3g=;
 b=bGf9qCxdCWoPJGK5D4OcWDaly08TVzoBt9rBgpQ6hrfnmoddNgHFxaWpGNJRKPiHTJHBmX3DBC24RfCInOvZyYOYSGw8RlqbVB8ZTYXwA92KTs5CLFChBCkSMIzYOJoq3W8FmP1MTSN0dIPX9zqZTC+mkOp4u9ZNqZDQcd7nrkDIStezDAhZALzI9TELKawxlTJhi7UkytM8wxSZDRiSQWxHsjDgq1s+Kk3/f+4Ud8RNHcc3AHmShf+kh8cy5AXxMQsdyunj5W1JAF2NYLNU0ZpNIdUAKbkY6N2V5KHQGDsYbEV42rD7wgPtZO8Hn9KCfX3/yFGis3+e4CwPKCLnQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xu6tZXLtUyH5CpypomziSHMovOGpMO5K+/+yjHShI3g=;
 b=WLAU1R/4Hpsj7uMMxTcI5OL99mF12PRQwb81/AHffs0rOU476hoAji70CCejagQmmgWcQ2M5iokNhlPL+CMCEO1uzufnTWJmI6w/8BpmBzUD86zoYYwkvf9l7liarnR16F6axYWGyyAwLOLYoRYnRgdSXR4kj5IyayZIQ7BTcWc=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by DM6PR10MB2923.namprd10.prod.outlook.com (2603:10b6:5:70::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Thu, 20 Jan
 2022 11:42:43 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6%4]) with mapi id 15.20.4909.010; Thu, 20 Jan 2022
 11:42:43 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC bpf-next 1/3] libbpf: support function name-based attach for uprobes
Date:   Thu, 20 Jan 2022 11:42:28 +0000
Message-Id: <1642678950-19584-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1642678950-19584-1-git-send-email-alan.maguire@oracle.com>
References: <1642678950-19584-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0358.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::21) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 666e68f4-4ee8-47be-62ee-08d9dc09f52e
X-MS-TrafficTypeDiagnostic: DM6PR10MB2923:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB292338FF59666A2412D36DECEF5A9@DM6PR10MB2923.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lIHSJlE/MlHJ3ULugKfnb43wX/9XS6o4sf3/Viyt8Db0H0bBa7akbePEP3juY37wjrWZjjdSndfj1iFPb3m4/rG1mzkooj1IFE1KLc52lRNguEykazLBNduKet62Q/7EpL1P3vLuHIvS4fGSTXYZ7xLBfSjMssBkFAl/UBcbEPWfY2Qw6YHbWfqYqzARYpPAN5k49F7qpm2UtIgcwzHv4yn3hkDd+z8BusCpS6QRpSAOprmywxTOvp83eNYegWOWXDbp6KM+OJLtmltJRvVPn9HzHXMjma25pAA2SDkVTWOP6kkHdpgHBeT0gW1U3RTwmNPOeHq/lP4BURmYEGXA7VIXgcWZ4DmZCV7cYtsA0n5X39nJ0Phe+pMujFaFExJ4bwESzFo4Pa6CkCrUES+bJDFsZlU4STp0tJ1hl7Ql0HC9xw7jTHhMBz3vR/FuIdi3kl6q3AzDZFVVzkvlxq+W/GnsDYwZ++Sfke3XFi7lAwJDF8G+iq3eRTSAPnZ4UEEv73tkYt1NKBxKt+yZ6lnVwk1T1eI8z9YHYWfuAdrmAcCWD3Qjt+buRACJeZE0vA6dKulxWtzFBvqCwEcgCTaJEyZggnRnsZEccu2Ddp+XLSCNpSFb4+P5+ufkGkoxk5hrK9h0SfJJPb8P4av+5D7l9tGmUhPtUDhQ/D6Hd5DnekrRdvoQh2l1ctHoQo9aFNAULjmm4MiMJQkqWP4rhJtbrp0Ie7KxYhIu4hZuBuQ9gMHM9a990a7SzY8EENVFo74OnH8Kxcv3M2gCWQPrO5mPLGN/Lo6BJi/wD+6O42o1oW4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(2616005)(8936002)(186003)(86362001)(6666004)(6506007)(2906002)(44832011)(8676002)(26005)(107886003)(508600001)(36756003)(83380400001)(66476007)(66556008)(966005)(66946007)(52116002)(38350700002)(38100700002)(4326008)(6486002)(6512007)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2fqdB+wAIHDQerepgwJLNTJAVu0KanOpEJcza8no3NA2Dak4awVSWQpsXAJ4?=
 =?us-ascii?Q?cVKumBKzh1vMP9zjEXDkscCJoFPSNo9jwdRTvT4HkdJoBwKHSrsznwQL76HE?=
 =?us-ascii?Q?FHPoeLmiTutHmdL9MJWpnywGDWugZB9M9IENtkARff9kNu//r6h+1GM3EqsG?=
 =?us-ascii?Q?LHZ6afZcpH/yKjyue/PWl7NYBeZBcsLKeVTuTuMjjvn+lo4SvwPQrhzPiFOa?=
 =?us-ascii?Q?N68ZxdKgyOs+Y6gkxTXjQMLL6TrEBNMouRnIwq+KLHU6516+/R/nTYeAPPKb?=
 =?us-ascii?Q?pNsFk2DxApJVsYJymNwSah11qEP0aXwozDf/wNusTkUeIlTll6E6fwpRzMAQ?=
 =?us-ascii?Q?SwDsWfgeydHZfd6ru8UDMC7mcTzlwjOhLYm52PeAfj55P3WvlSfe4498uG8O?=
 =?us-ascii?Q?rRrIkxwaGxc8CpKe05N0cDNSPO8ALBrhQQq78ullxtty1/H7wIeclsCRV6qs?=
 =?us-ascii?Q?dx4AB7Cbn+7Au8YfgKTGj36P7NXhTiTJLQGYt+vsNZqTKNHjNa2qXe3g8J4z?=
 =?us-ascii?Q?i/N9EcTO1wfzgyN7Jal7pBiW435pI9sLIqvylKhgdLIP6gZ6MFKnYRDICYlD?=
 =?us-ascii?Q?G0xaqlg727Zu/ugcd6+mM7rPyyAek437ClQ9g6MA5PmangohydJcUqSQ31TZ?=
 =?us-ascii?Q?TJeE9o4saC6U3kFeBtqi354fCE1Cp258HA5StvpkvWvEu1TUnXJWvqtA6Yky?=
 =?us-ascii?Q?xpfNsY4NTrlBgIsu0nFK9svI/eW1aIqiZmtfO3g6zU63EHkMlv3gnyNCANtG?=
 =?us-ascii?Q?J757mcCQ+5Oe7JFVs3XrCK+37g9Cf8DRLhU+DPQ7tV31D0IkDikScymK5yeP?=
 =?us-ascii?Q?/R5KsCZGlIVm8lEQ1JiTO1XApYJjGqatJ83BIEnJaUSchcw2TraBVScuXiTA?=
 =?us-ascii?Q?iMJspkpvDdyS9g6lFF7F4khSb7PNKWrkbMy8imCV/b9eCrrOv6+mvw0GLZd1?=
 =?us-ascii?Q?K0vwb7FpZ5YmGsrzBqlQ0rzkDFOxkolkL7f30XMWbqPSZUgUNZ/v674X0Qhb?=
 =?us-ascii?Q?jtV+BSV476w1hFuG/TCpvkI3ABxZ5tDxUdTaDB71r715f2FZ0G4FDE7czu3G?=
 =?us-ascii?Q?C4LNJQosuGM0VRKjtPCFTp9XfzCYSDLPncmncYV2d5yvm6drNygUvqqClRSv?=
 =?us-ascii?Q?BoPL29v1tqI/z2FjnqTrf4kmWuv6zpiosJuKH8SPSOcjQHFPOZNewnkpH9cw?=
 =?us-ascii?Q?j0sMwFAsQi/rD/u7+231L/abDpawn4oIY4hU03v8gdWnyoj1NrSmwHObozKJ?=
 =?us-ascii?Q?qHJLhsmaj+AwNnRGF7UP/BZgj4rFDWFsbQIm42DIOmzlY0Z3X/M82/Z0Zm7j?=
 =?us-ascii?Q?Y0QXoo5/ybWLnJmzkoZSeBWmL2m9ef9ryqTPq/2E0NbdmoddngSsLJoCU2UZ?=
 =?us-ascii?Q?sE0SaooDx/hOWikgg5vUSwXvWnS+gjc9te1ntiUvH2RrIcnQrIHLNA+wRJfD?=
 =?us-ascii?Q?AvLJ/VFTPPz3ZZ7BA7Pe7S+EJWWIMz81Pc7Mrau4j93mYIqjE1d6PKnNpy9+?=
 =?us-ascii?Q?1aRCApK9upoFCtkAYZ/u5Bl/A0w1jGhNccXKPNpurYT8OdEu14cBn+tG0Ksd?=
 =?us-ascii?Q?M9ZQK+dhd751YumS9Bs1YanmQreianIOBv9P1HHBrBHJ/6azl1YCbTx1NTQm?=
 =?us-ascii?Q?szzacTff/t5+zZK4eLGox7Y=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 666e68f4-4ee8-47be-62ee-08d9dc09f52e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 11:42:37.7784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OpRf6VL6e1VyRookyldnTkHEsVfznmxzs7kmAx4hywQGNGCiSJDk0rLTxPrbyDVZ3zv+yyzVKCvdDH47GGoMeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2923
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10232 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200059
X-Proofpoint-GUID: NeEPMH9r_1XETNfZ82ypNQRVDqjga7Rr
X-Proofpoint-ORIG-GUID: NeEPMH9r_1XETNfZ82ypNQRVDqjga7Rr
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
  the offset as reported by objdump; then, in the case of local
  functions
- subtract the base address associated with the object, retrieved
  from ELF program headers.

The resultant value is then added to the func_offset value passed
in to specify the uprobe attach address.  So specifying a func_offset
of 0 along with a function name "printf" will attach to printf entry.

The modes of operation supported are to attach to a local function
in a binary - function "foo1" in /usr/bin/foo - or to attach to
a library function in a shared object - function "malloc" in
/usr/lib64/libc.so.6.  Because the symbol table values of shared
object functions in a binary will be 0, we cannot attach to a
shared object function in a binary ("malloc" in /usr/bin/foo).

[1] https://www.kernel.org/doc/html/latest/trace/uprobetracer.html

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/libbpf.c | 199 +++++++++++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h |  10 ++-
 2 files changed, 208 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index fdb3536..6479aae 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10183,6 +10183,191 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 	return pfd;
 }
 
+/* uprobes deal in relative offsets; subtract the base address associated with
+ * the mapped binary.  See Documentation/trace/uprobetracer.rst for more
+ * details.
+ */
+static ssize_t find_elf_relative_offset(Elf *elf,  ssize_t addr)
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
+		if (phdr.p_type != PT_LOAD ||  !(phdr.p_flags & PF_X))
+			continue;
+
+		seg_start = phdr.p_vaddr;
+		seg_end = seg_start + phdr.p_memsz;
+		seg_offset = phdr.p_offset;
+		if (addr >= seg_start && addr < seg_end)
+			return (ssize_t)addr -  seg_start + seg_offset;
+	}
+	pr_warn("elf: failed to find prog header containing 0x%lx\n", addr);
+	return -ENOENT;
+}
+
+/* Return next ELF section of sh_type after scn, or first of that type
+ * if scn is NULL.
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
+static ssize_t find_elf_func_offset(const char *binary_path, const char *name)
+{
+	size_t si, strtabidx, nr_syms;
+	bool dynamic, is_shared_lib;
+	char errmsg[STRERR_BUFSIZE];
+	Elf_Data *symbols = NULL;
+	int lastbind = -1, fd;
+	ssize_t ret = -ENOENT;
+	Elf_Scn *scn = NULL;
+	const char *sname;
+	Elf64_Shdr *sh;
+	GElf_Ehdr ehdr;
+	Elf *elf;
+
+	if (!binary_path) {
+		pr_warn("name-based attach requires binary_path\n");
+		return -EINVAL;
+	}
+	if (elf_version(EV_CURRENT) == EV_NONE) {
+		pr_warn("elf: failed to init libelf for %s\n", binary_path);
+		return -LIBBPF_ERRNO__LIBELF;
+	}
+	fd = open(binary_path, O_RDONLY | O_CLOEXEC);
+	if (fd < 0) {
+		ret = -errno;
+		pr_warn("failed to open %s: %s\n", binary_path,
+			libbpf_strerror_r(ret, errmsg, sizeof(errmsg)));
+		return ret;
+	}
+	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
+	if (!elf) {
+		pr_warn("elf: could not read elf from %s: %s\n",
+			binary_path, elf_errmsg(-1));
+		close(fd);
+		return -LIBBPF_ERRNO__FORMAT;
+	}
+	if (!gelf_getehdr(elf, &ehdr)) {
+		pr_warn("elf: failed to get ehdr from %s: %s\n",
+			binary_path, elf_errmsg(-1));
+		ret = -LIBBPF_ERRNO__FORMAT;
+		goto out;
+	}
+	is_shared_lib = ehdr.e_type == ET_DYN;
+	dynamic = is_shared_lib;
+retry:
+	scn = find_elfscn(elf, dynamic ? SHT_DYNSYM : SHT_SYMTAB, NULL);
+	if (!scn) {
+		pr_warn("elf: failed to find symbol table ELF section in %s\n",
+			binary_path);
+		ret = -ENOENT;
+		goto out;
+	}
+
+	sh = elf64_getshdr(scn);
+	strtabidx = sh->sh_link;
+	symbols = elf_getdata(scn, 0);
+	if (!symbols) {
+		pr_warn("elf: failed to get symtab section in %s: %s\n",
+			binary_path, elf_errmsg(-1));
+		ret = -LIBBPF_ERRNO__FORMAT;
+		goto out;
+	}
+
+	lastbind = -1;
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
+			pr_warn("elf: failed to get sym name string in %s\n",
+				binary_path);
+			ret = -EIO;
+			goto out;
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
+			if (ret >= 0 && lastbind != -1) {
+				/* handle multiple matches */
+				if (lastbind != STB_WEAK && currbind != STB_WEAK) {
+					/* Only accept one non-weak bind. */
+					pr_warn("elf: additional match for '%s': %s\n",
+						sname, name);
+					ret = -LIBBPF_ERRNO__FORMAT;
+					goto out;
+				} else if (currbind == STB_WEAK) {
+					/* already have a non-weak bind, and
+					 * this is a weak bind, so ignore.
+					 */
+					continue;
+				}
+			}
+			ret = sym->st_value;
+			lastbind = currbind;
+		}
+	}
+	if (ret == 0) {
+		if (!dynamic) {
+			dynamic = true;
+			goto retry;
+		}
+		pr_warn("elf: '%s' is 0 in symbol table; try using shared library path instead of '%s'\n",
+			 name, binary_path);
+		ret = -ENOENT;
+	}
+	if (ret > 0) {
+		pr_debug("elf: symbol table match for '%s': 0x%lx\n",
+			 name, ret);
+		if (!is_shared_lib)
+			ret = find_elf_relative_offset(elf, ret);
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
@@ -10194,6 +10379,7 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 	size_t ref_ctr_off;
 	int pfd, err;
 	bool retprobe, legacy;
+	const char *func_name;
 
 	if (!OPTS_VALID(opts, bpf_uprobe_opts))
 		return libbpf_err_ptr(-EINVAL);
@@ -10202,6 +10388,19 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 	ref_ctr_off = OPTS_GET(opts, ref_ctr_offset, 0);
 	pe_opts.bpf_cookie = OPTS_GET(opts, bpf_cookie, 0);
 
+	func_name = OPTS_GET(opts, func_name, NULL);
+	if (func_name) {
+		ssize_t sym_off;
+
+		sym_off = find_elf_func_offset(binary_path, func_name);
+		if (sym_off < 0) {
+			pr_debug("could not find sym offset for %s in %s\n",
+				 func_name, binary_path);
+			return libbpf_err_ptr(sym_off);
+		}
+		func_offset += (size_t)sym_off;
+	}
+
 	legacy = determine_uprobe_perf_type() < 0;
 	if (!legacy) {
 		pfd = perf_event_open_probe(true /* uprobe */, retprobe, binary_path,
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 9728551..4675586 100644
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

