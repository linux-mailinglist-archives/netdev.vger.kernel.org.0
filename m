Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC79C4EC83E
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 17:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348187AbiC3P3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 11:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348180AbiC3P25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 11:28:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F03E1B2572;
        Wed, 30 Mar 2022 08:27:11 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UFLXYu027896;
        Wed, 30 Mar 2022 15:26:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=7qt5dTYWWtkAnvdPUFRF8OqyJe+9yc6gf8l+FAT1KXQ=;
 b=cYB+ffVhnAFQHspwkC8xwMfHZUZQ1ij5laTYmt2UY4pw8+/Jbi+lRx1tbrKPas5SKb9q
 yMCMW+N+zfegffDlIWymog6RehC6bZMqH9eFUFXEby0LC67RUpDH/tkdRl9/iM1DM0jk
 J5TqsvoHkxvQq7/RB/DrGA6+/GgbD3SvMvaWoklsrqQ8MAecxV3R88GEm31C5An8kmDo
 nqddGX1oEpxgn11BhUKZRKBITJg1MjbKpGwCafoeDKlpCXhFG9s0IvWlieG+Lt579JIs
 HXbrHzmGiRqBQqV05fHVq/y/RV3C/zYPz+yyyTWNXyZGH+E0P9vQOEuH8/X9kcXa+mcj KQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1sm2hv6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 15:26:54 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 22UFC4tn009540;
        Wed, 30 Mar 2022 15:26:53 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f1tg6x80e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 15:26:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQMk+XJ7iQnYZYlHdLNLBoefWOwvpWH0tcjp/r67HDY7lfQZ2Jh/WlmDTge2cmbB7FuwZf5rXo/t6hQYPOTH1Uw53RaTWbu8k3NoIA3dPP6SkKpWP5yB46b0730KE5Yn0VqLNHpYGcwVb1U1wP5BD1WLJ8W2e9Gvo1q5aqO9uNEoaCoDRMfYTOdHxHUauHeUiqtobbfK0FPIys4Rcj5PkNRzWO+zEk7uh0ZzwdweOmLjFonrKfij09xkE9PD2wmIJwo7XYKlU/WcC/OZyho6Ui8ZMYIjvqSF2ESHhnPty6HxChPocCUA1TR6gZw4gqMbM+4ikRrP+kR1LIJKBYklww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7qt5dTYWWtkAnvdPUFRF8OqyJe+9yc6gf8l+FAT1KXQ=;
 b=GqNjQXgZIwcJ+nnku4wIH+RT+GUac7TIdQBHj8Z3e1rnLpMu++IVSn9w3lYJfLHAKlWyJPF8czTRApic52U3rogaVT803K9Vmt875GVns0osxMNTfzXQMvo+fnOFerZF97wj0tavvsjye39VIc2EezEjLvL448Ax92ep++QiJTJCBdITivnUHFVzhhYoHhgiAgDg5lRua3p5nmDnRqbEZke1r8FMFvjEL82g4d+eqHLMphZBl4J8GO14c/2HzUW/7Ua8DebMrPFgq95IBkIi5bE71D6OsKCOOBucEGyds5Cw8nJf7hiy9rCxb+mBFt+VkXcrRNI1J1ZVsx4ghTd2qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qt5dTYWWtkAnvdPUFRF8OqyJe+9yc6gf8l+FAT1KXQ=;
 b=N9cLKYSzPPnh6HYhtNCKhOLbKSiWUd7B4q0XOyXT8/XZFVMFFqUgrw3RoOWv1s5ISuhLVdyMLBQxUydjV35bZBpLU+MzPyCHGwq8zD68K5au2v4FaaTAzyPaTGmSvynYiNvHkI3X6RT6VIyKzEkfm4luxAYAWKGWcsa6daojkXY=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BN8PR10MB3251.namprd10.prod.outlook.com (2603:10b6:408:c9::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.22; Wed, 30 Mar
 2022 15:26:50 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::1483:5b00:1247:2386]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::1483:5b00:1247:2386%4]) with mapi id 15.20.5123.020; Wed, 30 Mar 2022
 15:26:50 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, toke@redhat.com,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v5 bpf-next 2/5] libbpf: support function name-based attach uprobes
Date:   Wed, 30 Mar 2022 16:26:37 +0100
Message-Id: <1648654000-21758-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com>
References: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0362.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::7) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e9ce5ee-61be-40f9-5a9b-08da1261b616
X-MS-TrafficTypeDiagnostic: BN8PR10MB3251:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB32511C70D2FAC37CB1895CD4EF1F9@BN8PR10MB3251.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8bUzC2L6Y9aWXr7VqxSeYvSqkAs4d23LlsnOx/ViAxlE97eoljnAjhVlggnWTNTVM78pvUWfjY4GObC9l6iYqcT37ecf6/EpT8D+r/v/uOboY9//Ebtl0wa2qZhFw0dYLSLssXelr9iuAkrYsDg+RZggQeFBrRYd6nXk0WC6TvMp0dkpuQpqrhggE1xg1BFgD8e0C0/4/0JCGXwRR1QzLnXdgGpS3mkkzsrqhs1OzHs2LiqzuxHAcXSm01C8nyxAlcddHeOTkBI6ILMV9rQYSUb5Q1VWyU1yTc3gmtryKIROkc52K7xelgkYDY8ldlqVXreYoqT1S2CRVqcnmz3Rj2Nn2TcrrySugZmCNdD9dxjH2G5UgyYgMGzVh7mKuqBeIAc1+xIf+pLkGGyYK/lTTtrfFBJ/N4hAwYgbul1/oClxF0r2Y8EvPoeCqoYRUlHGdrr8w7tM/6DNWat9f1AuNGrjbDZXc0vTlgC2Hej6TPL39NgoeLG1FezGyq4+cKc9zrWNHOgCsZVK9hDh0ng3yIuNDomJ8/RxafU2WNd0ODrA6CJSA8moM6FwqnbfhVeB1wDHvQzLaIpHKosyy++FDYE7d0AIxWIpwwR6kq4TlVazM6l4awte14XqIDi6uj0ysD8iFmcEKKmdJ0wDQLFVNAy1WCYWE7clLv4veScERJTABlBoV7eaa1/P6OQ9UCWgMe+UsfvUXQQfyThPfzB4I2B3CysUqVsJZUDGlAksiiyAqYsYzKcW7KDKC6GG+SFqxOQMEtGmFoCWyR/+v+gwUFrkYcs0YdSOI1hThtokhIk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66556008)(66946007)(8676002)(316002)(38100700002)(38350700002)(36756003)(4326008)(86362001)(6486002)(966005)(5660300002)(8936002)(2616005)(6506007)(7416002)(52116002)(44832011)(186003)(26005)(6512007)(6666004)(83380400001)(107886003)(508600001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sZ76oLUuaZNLptdMG+zEkdZl95fwtsoLa4iVoPhcGvQbsvyIRyt5c/d2jnAd?=
 =?us-ascii?Q?+TiBAR1ab3nEbMgzk1SVZ88FDUeIs/iv2CWjQahFX3FN2/EONXeyeMfP42Qe?=
 =?us-ascii?Q?7jzs0GojraQMROPx8LMgAsAOWULkAvB9ZjSF+pHTLgLNdpx9olE/EQ0ZYYU4?=
 =?us-ascii?Q?/Lboa7GgWtEFODViJn78Kia6TAqWgxd4EOiqpCsB/8+og5kzPE1YnTmschgB?=
 =?us-ascii?Q?IGFYxJkxKJhytKPZ1NKTCJ56gPj2sWuwmMYSTrySGUlDqYYZ1XXcfQ5qtMzN?=
 =?us-ascii?Q?l9i6eZf8QdoA6f1hmHRpot1A+HWqItDKs/+oWdz7x7cVrvycAxboKE2b9j8o?=
 =?us-ascii?Q?XHI8KE0YGPDvrsdnqIniqTN3In56R/wFYYXbjl3Qgc3rNbThgjBEaIEm8D3/?=
 =?us-ascii?Q?4t6Mz3lCPJQ9TAmIuCxLkoWqmrSrMyip0rEgFZ6E7r0rVKcYCu4ILuTX1xHp?=
 =?us-ascii?Q?d0fQpKp4g/MHWCqHx6PAaDJ/AYVQ1WW8SL9287OT5nm15IfBrlB3dl3Siq6E?=
 =?us-ascii?Q?mkHh1BzneTMDaRklRN3qs7/RZm0eQB0T8ZNjISOlDsJEN2XBK5cZhI/X9Umm?=
 =?us-ascii?Q?e0ciNnHEkcDDZHby5y4xjR0eLHqSOvtxljqAYHlkoKwzHsIo/SEK96TqeL6Q?=
 =?us-ascii?Q?7JY98WTqYwBOmi4sBjsDSSWTLbc1p8O2nArrwpBxg7RgS4YH3oMqPblQhc48?=
 =?us-ascii?Q?Nj4AdK++y/2hsv+i105kwOdA64kOM/6OIFeMVy+zWa7bF6y2oflvq4FBV30U?=
 =?us-ascii?Q?zMJY/kmx4oQvlPd09ehIP3Aq4pqyG5mWahfi0xOdBlnJdlBKcT6grur74ERy?=
 =?us-ascii?Q?T7RTR5fEpJTS/oRtjmSTul+CRb3LR6y32Lu0I27pqogJ/zUhI+ZcDb10XRJW?=
 =?us-ascii?Q?BnsrXVltZf8YF13uFOn84WP/Jc7MM8oLnhSyJoV6QHAY7lYTyBLu9LKrXTCm?=
 =?us-ascii?Q?Wk05J5LWQlfPZgG/1G/hcph9wpvbSPnsal4HkDZf2mkRZ2iNqf7SFATvaaCV?=
 =?us-ascii?Q?s0c+l2XGFxFOsFbO8+FQE1+c/tlclZHEAC2LqYpCJqiOKjPj6X0qyjp/2Bl3?=
 =?us-ascii?Q?oopTCyaj00xNfHtuf7OIi9hkmoXOFVCCWWsScmhVrBDe8bJSKdAM2V/Vr64n?=
 =?us-ascii?Q?Glub/dHg1/Oir4+P3z6XBT45zuMFoOJyy/rLLhibU87FgzB26iuyXHCLOIx0?=
 =?us-ascii?Q?x8q+jhs5dDCIt7RuKSWH6zwdrBxViWkZrOzCF056doZEzLDFxL4hF658owID?=
 =?us-ascii?Q?a2L+50RJAQGhQ4vG6O5UDU3aq4P2/60in/GnY/D2SjoKF6PMFFr/rTZOvHy8?=
 =?us-ascii?Q?gDH1Jov8WPqzEM/I44JAlxU3gzXXevd9zVYQoa05hehk1bzS/bXZ1LUi4pJI?=
 =?us-ascii?Q?u8nGSaLtnZECUa3tkGCAEe9+EA0DHO7fRGZd8+C7MPNw4HEHAyl1zUUoRKMi?=
 =?us-ascii?Q?+pKO/JNokgBFKLuEPZg8XPEsmul2jSHdv8Atl4N6QIII4JrwErnHlHS8NRRH?=
 =?us-ascii?Q?bDAU2Ubqfu0Ht67kNFkTAQL87Qz4tXu8TIBrjZ7TNaug7dSELgSBWO+EjhZA?=
 =?us-ascii?Q?YTb3JoCbcDM0IyH1irs+XMSsAE83srFgs+7m2dq4bakpcj2I+ETzTuJZvche?=
 =?us-ascii?Q?ob0/6VtgGg0RG226wqnOnKDe4KTIPN/HKhQ32VH1rq0GfrrTGWts2W1hLV3L?=
 =?us-ascii?Q?IOxASTOyvI/i2q9FJfv0G/EGbVLLY65PdYOgDBhjyoT1FtmiM2xqxauA3J7P?=
 =?us-ascii?Q?zrXjnFzdR2gWdRtsGnsGWnMwuXSm97E=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e9ce5ee-61be-40f9-5a9b-08da1261b616
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 15:26:50.6298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N/0WsFCemV9YjGy5eze1MzABUN1MH+76lsgolXnsO6D9DKeEreqsIHRiTFtVutZiRdSwsfExeOHKl37NBAn0LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3251
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-03-30_04:2022-03-29,2022-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203300074
X-Proofpoint-ORIG-GUID: 7__wi3Fw_EBcmgV_eEPiamWqyL4VR53A
X-Proofpoint-GUID: 7__wi3Fw_EBcmgV_eEPiamWqyL4VR53A
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
   the offset as reported by objdump
2. If the function is a shared library function - and the binary
   provided is a shared library - no further work is required;
   the address found is the required address
3. Finally, if the function is local, subtract the base address
   associated with the object, retrieved from ELF program headers.

The resultant value is then added to the func_offset value passed
in to specify the uprobe attach address.  So specifying a func_offset
of 0 along with a function name "printf" will attach to printf entry.

The modes of operation supported are then

1. to attach to a local function in a binary; function "foo1" in
   "/usr/bin/foo"
2. to attach to a shared library function in a shared library -
   function "malloc" in libc.

[1] https://www.kernel.org/doc/html/latest/trace/uprobetracer.html

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/libbpf.c | 203 +++++++++++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h |  10 ++-
 2 files changed, 212 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a7d5954..eda724c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10517,6 +10517,195 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 	return pfd;
 }
 
+/* uprobes deal in relative offsets; subtract the base address associated with
+ * the mapped binary.  See Documentation/trace/uprobetracer.rst for more
+ * details.
+ */
+static long elf_find_relative_offset(const char *filename, Elf *elf, long addr)
+{
+	size_t n;
+	int i;
+
+	if (elf_getphdrnum(elf, &n)) {
+		pr_warn("elf: failed to find program headers for '%s': %s\n", filename,
+			elf_errmsg(-1));
+		return -ENOENT;
+	}
+
+	for (i = 0; i < n; i++) {
+		int seg_start, seg_end, seg_offset;
+		GElf_Phdr phdr;
+
+		if (!gelf_getphdr(elf, i, &phdr)) {
+			pr_warn("elf: failed to get program header %d from '%s': %s\n", i, filename,
+				elf_errmsg(-1));
+			return -ENOENT;
+		}
+		if (phdr.p_type != PT_LOAD || !(phdr.p_flags & PF_X))
+			continue;
+
+		seg_start = phdr.p_vaddr;
+		seg_end = seg_start + phdr.p_memsz;
+		seg_offset = phdr.p_offset;
+		if (addr >= seg_start && addr < seg_end)
+			return addr - seg_start + seg_offset;
+	}
+	pr_warn("elf: failed to find prog header containing 0x%lx in '%s'\n", addr, filename);
+	return -ENOENT;
+}
+
+/* Return next ELF section of sh_type after scn, or first of that type if scn is NULL. */
+static Elf_Scn *elf_find_next_scn_by_type(Elf *elf, int sh_type, Elf_Scn *scn)
+{
+	while ((scn = elf_nextscn(elf, scn)) != NULL) {
+		GElf_Shdr sh;
+
+		if (!gelf_getshdr(scn, &sh))
+			continue;
+		if (sh.sh_type == sh_type)
+			return scn;
+	}
+	return NULL;
+}
+
+/* Find offset of function name in object specified by path.  "name" matches
+ * symbol name or name@@LIB for library functions.
+ */
+static long elf_find_func_offset(const char *binary_path, const char *name)
+{
+	int fd, i, sh_types[2] = { SHT_DYNSYM, SHT_SYMTAB };
+	bool is_shared_lib, is_name_qualified;
+	char errmsg[STRERR_BUFSIZE];
+	long ret = -ENOENT;
+	size_t name_len;
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
+	 * a binary is stripped, it may only have SHT_DYNSYM, and a fully-statically
+	 * linked binary may not have SHT_DYMSYM, so absence of a section should not be
+	 * reported as a warning/error.
+	 */
+	for (i = 0; i < ARRAY_SIZE(sh_types); i++) {
+		size_t nr_syms, strtabidx, idx;
+		Elf_Data *symbols = NULL;
+		Elf_Scn *scn = NULL;
+		int last_bind = -1;
+		const char *sname;
+		GElf_Shdr sh;
+
+		scn = elf_find_next_scn_by_type(elf, sh_types[i], NULL);
+		if (!scn) {
+			pr_debug("elf: failed to find symbol table ELF sections in '%s'\n",
+				 binary_path);
+			continue;
+		}
+		if (!gelf_getshdr(scn, &sh))
+			continue;
+		strtabidx = sh.sh_link;
+		symbols = elf_getdata(scn, 0);
+		if (!symbols) {
+			pr_warn("elf: failed to get symbols for symtab section in '%s': %s\n",
+				binary_path, elf_errmsg(-1));
+			ret = -LIBBPF_ERRNO__FORMAT;
+			goto out;
+		}
+		nr_syms = symbols->d_size / sh.sh_entsize;
+
+		for (idx = 0; idx < nr_syms; idx++) {
+			int curr_bind;
+			GElf_Sym sym;
+
+			if (!gelf_getsym(symbols, idx, &sym))
+				continue;
+
+			if (GELF_ST_TYPE(sym.st_info) != STT_FUNC)
+				continue;
+
+			sname = elf_strptr(elf, strtabidx, sym.st_name);
+			if (!sname)
+				continue;
+
+			curr_bind = GELF_ST_BIND(sym.st_info);
+
+			/* User can specify func, func@@LIB or func@@LIB_VERSION. */
+			if (strncmp(sname, name, name_len) != 0)
+				continue;
+			/* ...but we don't want a search for "foo" to match 'foo2" also, so any
+			 * additional characters in sname should be of the form "@@LIB".
+			 */
+			if (!is_name_qualified && sname[name_len] != '\0' && sname[name_len] != '@')
+				continue;
+
+			if (ret >= 0) {
+				/* handle multiple matches */
+				if (last_bind != STB_WEAK && curr_bind != STB_WEAK) {
+					/* Only accept one non-weak bind. */
+					pr_warn("elf: ambiguous match for '%s', '%s' in '%s'\n",
+						sname, name, binary_path);
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
+		}
+		/* For binaries that are not shared libraries, we need relative offset */
+		if (ret > 0 && !is_shared_lib)
+			ret = elf_find_relative_offset(binary_path, elf, ret);
+		if (ret > 0)
+			break;
+	}
+
+	if (ret > 0) {
+		pr_debug("elf: symbol address match for '%s' in '%s': 0x%lx\n", name, binary_path,
+			 ret);
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
 /* Get full path to program/shared library. */
 static int resolve_full_path(const char *file, char *result, size_t result_sz)
 {
@@ -10569,6 +10758,7 @@ static int resolve_full_path(const char *file, char *result, size_t result_sz)
 	size_t ref_ctr_off;
 	int pfd, err;
 	bool retprobe, legacy;
+	const char *func_name;
 
 	if (!OPTS_VALID(opts, bpf_uprobe_opts))
 		return libbpf_err_ptr(-EINVAL);
@@ -10586,6 +10776,19 @@ static int resolve_full_path(const char *file, char *result, size_t result_sz)
 		}
 		binary_path = full_binary_path;
 	}
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
+		func_offset += sym_off;
+	}
 
 	legacy = determine_uprobe_perf_type() < 0;
 	if (!legacy) {
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 05dde85..28cd206 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -459,9 +459,17 @@ struct bpf_uprobe_opts {
 	__u64 bpf_cookie;
 	/* uprobe is return probe, invoked at function return time */
 	bool retprobe;
+	/* Function name to attach to.  Could be an unqualified ("abc") or library-qualified
+	 * "abc@LIBXYZ" name.  To specify function entry, func_name should be set while
+	 * func_offset argument to bpf_prog__attach_uprobe_opts() should be 0.  To trace an
+	 * offset within a function, specify func_name and use func_offset argument to specify
+	 * offset within the function.  Shared library functions must specify the shared library
+	 * binary_path.
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

