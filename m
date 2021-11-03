Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539EC443F9E
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 10:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhKCJxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 05:53:20 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:19802 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231614AbhKCJxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 05:53:18 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A38Yh98000561;
        Wed, 3 Nov 2021 09:49:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=vpuA0NXZZF7huJS24oR1AIv2Iv6uC9hMogsdMvqMV/k=;
 b=l2JCTpamiCJ2oFeMnzMMdBHiBK6SroyFu9gK7iaKHhQRiI5td0eAxjS+S1ypdWKwVnG2
 D50/uzNIPoQRz/4fJgLRo/fZltGOt7xjjEJzvjz+u76XwU0sLf6kNT3KicCMWi1+B7F8
 g8HSCaBK6TwmVzAVa3EY13P99kFuXg+N4m5xYMti3s/tb5uysYjkWQIgQz9g/bAXOi22
 BQ2omCfOMsT5K2FQq0Lg7UfNwCfr0FNOblcX7yFkKvgd4+WNG2YDcWl+RMT2oGf2rcwM
 WI/xmLnbn9FvriZ0ABdZKOIr45c2twWoGt8bZzAXfkaVOyuDoPBnbtqU4mnX7vtEIo1F VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3q1n8bwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Nov 2021 09:49:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A39kJJZ187155;
        Wed, 3 Nov 2021 09:49:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3020.oracle.com with ESMTP id 3c1khv93qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Nov 2021 09:49:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1+3udbXD50aDmqOLH31+Prg2Z2q3NLvJqxE+486RYJUtoOTRMZF1DOw23rpT4nbeOgKv0oNz34aUt8rWTS5l0eOJkYO1D79xjKgLiIxQxVRx/960nRZgaWansYfZAy3taFhtEP3OOBOEap4jOwlsirqMSn7Q+Hw9Gq99qMtCAKr0O8tQv0qPN6I543f8zKEZS1w0DC8LtNR06LzE/F53Ivl83lLGjGBreGxvXUmDLajcw9RGU3anoxPd/7lvWQCtNFuSlU8EI8J/c5EJkQzJZdz7gFB37pQIcGSf6CTaCAMTOTz6F9x4Kzo/raA40V4gapExaFZQkUZkEDbqMwp5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vpuA0NXZZF7huJS24oR1AIv2Iv6uC9hMogsdMvqMV/k=;
 b=Ja92uJcyE2zimUoYQ2tqUFPyI9rgpVP860ETuoTa2eiaeCUDGTTKX23uJCdh3DHeHaeUDGiDFuEyuSTtitYSyhE+mvHrt512yBTHX4m4Hycui+10HfM+kW5GfIne6ii0RBXl5zQcDkwS1J0xxkllyO3ONI4Mu/2QTc7eTgyLTvOEavYU17PKzNeM0Zjj1SLhotwKSiXq2Nf0xC7Mq5hNq4jcqufG/E3tPlZCcOerqJFP40rXqxhbY3RAXz2rcpeWLu3z7eJ7+6nab0jrzGSLo5/HePvHphrIFKvc3ZU2Ho4DlZPrvT5UP+zcvEIr9DGC6tzcNzlbV1L7ZxIb9MYKeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vpuA0NXZZF7huJS24oR1AIv2Iv6uC9hMogsdMvqMV/k=;
 b=MkkCDJ5C+TqZrt3fF8QSO5tuqOV5f2s/lph4kLUXWlohOGnoMODerYRDGUtjNvgfl83slO8hZQX40ItTRRL8fLqmH6kJCEH+xBwY47i/9psdNHKHMcDKQA1+seTxyidun4AyVlW5jHn2ZACXZU/LpmE4SCjMIUbdNu4XZ3Qtcj4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DS7PR10MB5278.namprd10.prod.outlook.com (2603:10b6:5:3a5::9) by
 DM6PR10MB2490.namprd10.prod.outlook.com (2603:10b6:5:ae::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.17; Wed, 3 Nov 2021 09:49:44 +0000
Received: from DS7PR10MB5278.namprd10.prod.outlook.com
 ([fe80::6c17:986b:dd58:431d]) by DS7PR10MB5278.namprd10.prod.outlook.com
 ([fe80::6c17:986b:dd58:431d%7]) with mapi id 15.20.4649.018; Wed, 3 Nov 2021
 09:49:44 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ardb@kernel.org, catalin.marinas@arm.com, will@kernel.org,
        daniel@iogearbox.net, ast@kernel.org
Cc:     zlim.lnx@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, andreyknvl@gmail.com,
        vincenzo.frascino@arm.com, mark.rutland@arm.com,
        samitolvanen@google.com, joey.gouly@arm.com, maz@kernel.org,
        daizhiyuan@phytium.com.cn, jthierry@redhat.com,
        tiantao6@hisilicon.com, pcc@google.com, akpm@linux-foundation.org,
        rppt@kernel.org, Jisheng.Zhang@synaptics.com,
        liu.hailong6@zte.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Russell King <russell.king@oracle.com>
Subject: [PATCH bpf-next 1/2] arm64/bpf: remove 128MB limit for BPF JIT programs
Date:   Wed,  3 Nov 2021 09:49:28 +0000
Message-Id: <1635932969-13149-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1635932969-13149-1-git-send-email-alan.maguire@oracle.com>
References: <1635932969-13149-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0089.eurprd07.prod.outlook.com
 (2603:10a6:207:6::23) To DS7PR10MB5278.namprd10.prod.outlook.com
 (2603:10b6:5:3a5::9)
MIME-Version: 1.0
Received: from localhost.uk.oracle.com (138.3.204.46) by AM3PR07CA0089.eurprd07.prod.outlook.com (2603:10a6:207:6::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.4 via Frontend Transport; Wed, 3 Nov 2021 09:49:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83f72bdc-7bb6-443b-abed-08d99eaf4375
X-MS-TrafficTypeDiagnostic: DM6PR10MB2490:
X-Microsoft-Antispam-PRVS: <DM6PR10MB2490E8D6EAA5C42712B794DBEF8C9@DM6PR10MB2490.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c7i9TD6h/YOgNhdOoRXRyISFY4T+D7oUpwlQodTAKsE7OII763JkMerPWdTuF5saDUYKw5hv31Rx2RmIPHTr0C/L8L+lqPhBKEJEXpJlmZ0fomauiuNUppCrLO0ykX0VSCaquxfSa+q9kGxSlKpvTBTOKNcNIJvwV07kd+5o4GgiQqr3dOMhqeD6uBJu4LrEtIhkUnX3bQJRATjGOAr7yM07C8QD3rw3fSRKyHm8lL8DTJuLNRI1LqyUbLqEFFYDLkxJUjnApiMd8BJNRWXZ3WKNq/B8fil9u2WqCL5oHmWa9+wPzU5apdWhWM/FJcAZLf7pEXQH6hbd4V6UxWxuoZS0WchidPrdSu5FzZk+pqD9xRHvAixa6wYHA53P/5ZR0MoR3V9FpgZPJy/AumVEyK6LY+gyYz/WAKQpbQEWP4XmOr+wtDwe4avr8slVYcTuSKvp9KnvwAwJ+2tDez54cVVLbbqJFCDo5iinkBUU8Cm2o39e3lzwhP3hqu64WXaJhDTHUjJtuxRYe/d36MmgSB1Pb6F2hTbFo331QTta17oGuKhoYN2ixFcvGSxfRYRbj1hg7X488J5jSMoQBF4TeVlQMG/8hnGcE3GM2AImDRpLDl1ngZbCwpLMZcJEvFs0p/2WGAL+Srpm06yxNwRYwS/wFfIE6Xm/qDmdNseEb6Qb8txzNbGLpXgs0azdHddLsdDC75gLiOzkehbiq0eiyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5278.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(36756003)(2906002)(66556008)(26005)(86362001)(8676002)(508600001)(83380400001)(6666004)(7416002)(8936002)(7406005)(38350700002)(956004)(2616005)(186003)(44832011)(107886003)(6486002)(38100700002)(66476007)(7696005)(66946007)(4326008)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1mCW4xftSMo/QzJJChuCJFKtIy3Tq69Z+JooY61TSmuNzGVDskKsye8ib4NV?=
 =?us-ascii?Q?o2I3kro0Hj+udvmP8OJvQbGAPGKUZ0n1fltWekW0On/SoaRadDStBuR0f/J3?=
 =?us-ascii?Q?U5pHWreLMAn8r4mHKbx44Z1hxqMu5CeMXyf79gO4Nr74KBfPRMoMZ9HYJE1h?=
 =?us-ascii?Q?SSP5eBW3uZOIsCtHgjOGrqhK5HF9ONGXsXvvRCPFGvZERw/eU+XlfYhmKJP9?=
 =?us-ascii?Q?aMw2H8RV4MJjwKvFzLHnLHDZ340ugVdq+NA6kKFEBGU6LXYAk+iYvsKSOlDd?=
 =?us-ascii?Q?rLzrFZ5AHmN2XldHdkTRonET/q8nQu/5J5DgnnSvbzvyW46wBebxit4JKepc?=
 =?us-ascii?Q?YGwJxcjASeWGTGs+4ErtqM+gpKay1O2IiKUfkXocv31t/85ZZkeHjhwsukOI?=
 =?us-ascii?Q?+xqMKzUKC96tsCLeOOn9fWWzZEJD4qyEqLtlfInicbbGG9Eyif+sXfpOsjdl?=
 =?us-ascii?Q?EehVQ5R0Fyw9z+ay39IrMbFJDKSam5xITNzTXCaJf17vkYXdR1V0zg1Fq+6M?=
 =?us-ascii?Q?1nmdfjQisb29tbEdO3Zd+0YUwZgLX8PddaDtky9p+eDppsYDpd0nbAA0tsDj?=
 =?us-ascii?Q?49vvqDIzCpgukCZpuAFVjrmrrB0KlEps24wpNhEUuY4Keoh9sQOYWnPnmHph?=
 =?us-ascii?Q?p+2LYQ792JKkxMpHXjhyhnPXJ8Ftb3F89R6er/n2ihqGaprXqzxZpCfoysp8?=
 =?us-ascii?Q?GJhzC19sUeAum/MwOWDrxdkGcSCujp5w6KRoNFmCIxltmTP/ZlyLBeWKurSI?=
 =?us-ascii?Q?CgrNyu6RNZ94L0UDnrxULTjb7dzem/fDdCIqeeU+6Whwp4noGRDh4uHFLaUH?=
 =?us-ascii?Q?8Cssp8CUJuMttmbUltpCK7s75EHB2eBwiMmIr8zOy65M80rIPk3JrtsbztrE?=
 =?us-ascii?Q?KNjz0Ccuf/sHLMSzlSavS6OCAl/z9KLegCJPxZP3tDihL3oT2+ZD5ttfjvZx?=
 =?us-ascii?Q?zHqxPStBrene4AO1myDGxTufcqjwnnVUFDcGmFPPpbuONMIX1fXQTMWRocGp?=
 =?us-ascii?Q?caHjBUAc1d9pHkRtghUtbqs0Wv4zGXkJYaf37cxW+i0fMex+4Q1jbUqhFtlc?=
 =?us-ascii?Q?sJu0mS450HhVsdC5xPf4iSIdMbGCeSZI3Mphv5Uy+6qfcYyWNEJbfYwEbfWP?=
 =?us-ascii?Q?qK5X4A8Rfo/OjUg1Yyy3gsam3ovKNfPIRrzbM37LRscGt4TRxEB6jdo7yDCY?=
 =?us-ascii?Q?f/ktGOWWl1WQfmdB949T1Ph8bO3g/FCDe6JoZEPJBKlbgyjkUxlHUjpedWl3?=
 =?us-ascii?Q?IVTML/7LobaNJijAeFyQk65c+39C/lhO+WcRrB64Kss/XcwaFx+DMhk0UzQL?=
 =?us-ascii?Q?//9WoCPauq86jbPzfk2sjJheqGZKeDDO09F6a8G9+977u4caew94eVohH1Jz?=
 =?us-ascii?Q?ZxXAxBX6u0lABEpP4L1nobLlMt1RQpuvyTg9GKI6lyxeNTZ+yU7kiH81XD4w?=
 =?us-ascii?Q?M8F2bpaF1JkMWvkDHysxDwI3bTihplpky6pv66b5GG6jdKhfO2aZLQe1f111?=
 =?us-ascii?Q?NAgYmERL9piBIpyyOD/Q8wVbSafP9i+dk7A/TqSHsAbfE/uvUkSJPRRrMcVm?=
 =?us-ascii?Q?QUKlHzOuMdg1863nuOL8qRJU0b43XSiVdE17OVPO99fJKn1F1qQTORFOjcf8?=
 =?us-ascii?Q?nmLJHNyX/MvktNJpwk7hBgE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83f72bdc-7bb6-443b-abed-08d99eaf4375
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5278.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 09:49:44.0524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RScEQ2eEtUF9VDigVxtdIVQYs1zZY9uq/8Et64bifT4Z4iJ4DRhfjpARkYumeT61u6hV5IPf9D3VajDk5F4LVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2490
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10156 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111030055
X-Proofpoint-ORIG-GUID: W9jSigDcE-Hl3flK4qujncZc3IaqcAD_
X-Proofpoint-GUID: W9jSigDcE-Hl3flK4qujncZc3IaqcAD_
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <russell.king@oracle.com>

commit 91fc957c9b1d ("arm64/bpf: don't allocate BPF JIT programs in module memory")

...restricts BPF JIT program allocation to a 128MB region to ensure
BPF programs are still in branching range of each other.  However
this restriction should not apply to the aarch64 JIT, since
BPF_JMP | BPF_CALL are implemented as a 64-bit move into a register
and then a BLR instruction - which has the effect of being able to call
anything without proximity limitation.  Removing the contiguous JIT
region requires explicitly searching the bpf exception tables first
in fixup_exception(), since they are formatted differently from
the rest of the exception tables.  Previously we used the fact that
the JIT memory was contiguous to identify the fact that the context
for the exception (the program counter) is a BPF program.

The practical reason to relax this restriction on JIT memory is that 128MB
of JIT memory can be quickly exhausted, especially where PAGE_SIZE is 64KB -
one page is needed per program.  In cases where seccomp filters are applied
to multiple VMs on VM launch - such filters are classic BPF but converted to
BPF - this can severely limit the number of VMs that can be launched.  In a
world where we support BPF JIT always on, turning off the JIT isn't always
an option either.

Fixes: 91fc957c9b1d ("arm64/bpf: don't allocate BPF JIT programs in module memory")

Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Russell King <russell.king@oracle.com>
Tested-by: Alan Maguire <alan.maguire@oracle.com>
---
 arch/arm64/include/asm/extable.h |  9 ---------
 arch/arm64/include/asm/memory.h  |  5 +----
 arch/arm64/kernel/traps.c        |  2 +-
 arch/arm64/mm/extable.c          | 13 +++++++++----
 arch/arm64/mm/ptdump.c           |  2 --
 arch/arm64/net/bpf_jit_comp.c    | 10 ++++++----
 6 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/extable.h b/arch/arm64/include/asm/extable.h
index b15eb4a..840a35e 100644
--- a/arch/arm64/include/asm/extable.h
+++ b/arch/arm64/include/asm/extable.h
@@ -22,15 +22,6 @@ struct exception_table_entry
 
 #define ARCH_HAS_RELATIVE_EXTABLE
 
-static inline bool in_bpf_jit(struct pt_regs *regs)
-{
-	if (!IS_ENABLED(CONFIG_BPF_JIT))
-		return false;
-
-	return regs->pc >= BPF_JIT_REGION_START &&
-	       regs->pc < BPF_JIT_REGION_END;
-}
-
 #ifdef CONFIG_BPF_JIT
 int arm64_bpf_fixup_exception(const struct exception_table_entry *ex,
 			      struct pt_regs *regs);
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index f1745a8..0588632 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -44,11 +44,8 @@
 #define _PAGE_OFFSET(va)	(-(UL(1) << (va)))
 #define PAGE_OFFSET		(_PAGE_OFFSET(VA_BITS))
 #define KIMAGE_VADDR		(MODULES_END)
-#define BPF_JIT_REGION_START	(_PAGE_END(VA_BITS_MIN))
-#define BPF_JIT_REGION_SIZE	(SZ_128M)
-#define BPF_JIT_REGION_END	(BPF_JIT_REGION_START + BPF_JIT_REGION_SIZE)
 #define MODULES_END		(MODULES_VADDR + MODULES_VSIZE)
-#define MODULES_VADDR		(BPF_JIT_REGION_END)
+#define MODULES_VADDR		(_PAGE_END(VA_BITS_MIN))
 #define MODULES_VSIZE		(SZ_128M)
 #define VMEMMAP_START		(-(UL(1) << (VA_BITS - VMEMMAP_SHIFT)))
 #define VMEMMAP_END		(VMEMMAP_START + VMEMMAP_SIZE)
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index b03e383..fe0cd05 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -988,7 +988,7 @@ static int bug_handler(struct pt_regs *regs, unsigned int esr)
 static int reserved_fault_handler(struct pt_regs *regs, unsigned int esr)
 {
 	pr_err("%s generated an invalid instruction at %pS!\n",
-		in_bpf_jit(regs) ? "BPF JIT" : "Kernel text patching",
+		"Kernel text patching",
 		(void *)instruction_pointer(regs));
 
 	/* We cannot handle this */
diff --git a/arch/arm64/mm/extable.c b/arch/arm64/mm/extable.c
index aa00601..60a8b6a 100644
--- a/arch/arm64/mm/extable.c
+++ b/arch/arm64/mm/extable.c
@@ -9,14 +9,19 @@
 int fixup_exception(struct pt_regs *regs)
 {
 	const struct exception_table_entry *fixup;
+	unsigned long addr;
 
-	fixup = search_exception_tables(instruction_pointer(regs));
-	if (!fixup)
-		return 0;
+	addr = instruction_pointer(regs);
 
-	if (in_bpf_jit(regs))
+	/* Search the BPF tables first, these are formatted differently */
+	fixup = search_bpf_extables(addr);
+	if (fixup)
 		return arm64_bpf_fixup_exception(fixup, regs);
 
+	fixup = search_exception_tables(addr);
+	if (!fixup)
+		return 0;
+
 	regs->pc = (unsigned long)&fixup->fixup + fixup->fixup;
 	return 1;
 }
diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index 1c40353..9bc4066 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -41,8 +41,6 @@ enum address_markers_idx {
 	{ 0 /* KASAN_SHADOW_START */,	"Kasan shadow start" },
 	{ KASAN_SHADOW_END,		"Kasan shadow end" },
 #endif
-	{ BPF_JIT_REGION_START,		"BPF start" },
-	{ BPF_JIT_REGION_END,		"BPF end" },
 	{ MODULES_VADDR,		"Modules start" },
 	{ MODULES_END,			"Modules end" },
 	{ VMALLOC_START,		"vmalloc() area" },
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 41c23f4..465c44d 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1136,12 +1136,14 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	return prog;
 }
 
+u64 bpf_jit_alloc_exec_limit(void)
+{
+	return VMALLOC_END - VMALLOC_START;
+}
+
 void *bpf_jit_alloc_exec(unsigned long size)
 {
-	return __vmalloc_node_range(size, PAGE_SIZE, BPF_JIT_REGION_START,
-				    BPF_JIT_REGION_END, GFP_KERNEL,
-				    PAGE_KERNEL, 0, NUMA_NO_NODE,
-				    __builtin_return_address(0));
+	return vmalloc(size);
 }
 
 void bpf_jit_free_exec(void *addr)
-- 
1.8.3.1

