Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E842446750
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 17:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbhKEQyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 12:54:31 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:30704 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231288AbhKEQy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 12:54:29 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A5Ft67X003132;
        Fri, 5 Nov 2021 16:51:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=f4+r/oMKCTcZ9dHu4ictO+LSuAIJVI1YzP5kz9TYqvo=;
 b=fusvqjIEqP3h7TeYqhNOniO4g4L+DYQxyhJFSgg/HHNZKGj8N8F0LgoiHkBUAMmsDJiT
 QYdXkqIkf2btzGIbUuouKTNU8Fqm0a/fHeBf09cj52+xiJrU6QsNoetQdd4mZnwqoWOg
 hgMjt7/VF45HVcFsAxz53hWg+V76Lpa+zbuMk9izUJBLtmn9f3kUxrzGcexQZ1HRHAqn
 WRqHFEwPksS/yUGDK72WN1q6w4pAu9WZ2GMk7sR8hBcb02TcU1x8okaIhgi22lQsuphH
 qP4l5ZZS2wteYeYz8JCcLdQJp+HVsNQnLdYFVQrDryuOI2Hl77j8B91Ayb908gqo19if bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c4t7bug0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 16:51:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A5Ge5aF116448;
        Fri, 5 Nov 2021 16:51:01 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by aserp3020.oracle.com with ESMTP id 3c4t5smde6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 16:51:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gi7KqRLgr/yUxpBv8h19ZClz+W1NFiNe03PZmRp6tnqnYf+B2suzWg2Emfj78tdioEXDPgRVkeYMlm7r2bX5tvlwZeVsbtIwiPUpnceMLPBbYoB1PaqwKW78QQHogIvQZfSh2L3eRc4wAoBfx+yhOOtGPuIpsDdb2sGE4XbHLxWHuhEt8mG3bR/JuQk1awxOEpXvrwcrZ0KHoRosQkeGt+x/Ua+9DK5k1hHWz5ETt6BPEGHvrjTZe8RKh3x+mhFsOUkHnfPf7hdSEfJx9Nl6Cob1b8tqJg1vFbjZGGiq1BhVTLo+M11OQtfNMCgjvBUOnAgbObfvBDEguX/uJpwuHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f4+r/oMKCTcZ9dHu4ictO+LSuAIJVI1YzP5kz9TYqvo=;
 b=BYuYACWM+zZdGBeEZQzgo7BWoaxVoov6xwIivevhfAbEPgq/UW96E3CpQlf5JTqSlh0jUPUkYtD1VYGkyeSJ82/1KM58g/3izL4orZRIl0yn60iXJuj0NUx5bDFHjsOuzaDAYKW62uEm+9WTAmJ+IE1d7x5sNtT8fLoqNTM5tLstSO2bNNde/rHYNkl9N1+xyza7mGzuWxwhnyRKHRPC0TwtYvg88LBuwxvM+efGN1TO6G3WW81a5fUnmWTuH+tQ+794oc4Vp/mcPcOnax+Fa2/QRoRjZ7XiDpPUnbtesc47iXRea7Ok4XXR3cCeY1axNIRTAnHd5S836wTT5KbNhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f4+r/oMKCTcZ9dHu4ictO+LSuAIJVI1YzP5kz9TYqvo=;
 b=urr0aYJm59yNe25JUHQCko57HotvypTyuMpig7DhQ6WM/fkDT9cGPUMkNHtO5FoKR4q6OsBFZXpNjUExqnR4G8ss8TJJ/YUmYNLPKHElCKd8QMGKdHTq3tSCQm3um+whQkqFvdAzD3bzmIHGoOfkg8MEhPLQms+EljQR/6FOiB0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3213.namprd10.prod.outlook.com (2603:10b6:208:131::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Fri, 5 Nov
 2021 16:50:59 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::998f:e9eb:ec26:1334]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::998f:e9eb:ec26:1334%7]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 16:50:59 +0000
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
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Russell King <russell.king@oracle.com>
Subject: [PATCH v2 bpf-next 1/2] arm64/bpf: remove 128MB limit for BPF JIT programs
Date:   Fri,  5 Nov 2021 16:50:45 +0000
Message-Id: <1636131046-5982-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1636131046-5982-1-git-send-email-alan.maguire@oracle.com>
References: <1636131046-5982-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM9P192CA0024.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::29) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
Received: from localhost.uk.oracle.com (138.3.204.60) by AM9P192CA0024.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17 via Frontend Transport; Fri, 5 Nov 2021 16:50:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b20b62be-0f9e-4770-d658-08d9a07c7170
X-MS-TrafficTypeDiagnostic: MN2PR10MB3213:
X-Microsoft-Antispam-PRVS: <MN2PR10MB321317F8A57BBFB892F458F7EF8E9@MN2PR10MB3213.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: etxdappmNFPZDR9ayu9mxEi1glogcWankCHmfmrsnEvbzOYj33c+umtyab3K2wbXVn4ZPNRU7L/g5MfgE6HUOARfxxSHqVr8jVzmto6lQ7vxeAIfly6W9qKQLxbWH2EK/iIIzKtSUz4BQsMdLiOAmZxHJhPavJBmOPpAvoWJBWmu0aVBQLSckqhAX/eHDjiseaZPqMXfYrz44YtIUjRysNZBc3BSxyfxAp6cll+rjoMI4G+/+MdTrUsUaXIzABL4uv+0WUySxqBeL4A9yxRfYIGzIjkzinn2Lnavjjumh/qFlxfemBTXl7Y3z+A3wrwCJRq45Yo/kKxYWqA9Co7FOVkdUX82nFUd2ELGhUewBNppJ59HmYuhuMFDzEOYuOAyR6rIEE2rJQGvt9cnVlLmCZJY4bzclpcPCShtPQ4EeyPFhMEQtz8aKPnXXSLFYcv3j8PPEW+6kniIzJYn+9FlwhuccXCJrtJ//jhnvoxyhKbmXydoO9YYpioMQ+U48BRZWh+7GGQAc+quRURb3pYpGreu6qN4dZUN6pzhGi423cICvoel8a42lDs64e0Z1pWi7BZpj2CC5lnum3lIembJRX1B54e647ZzjeCLZ8/L6yrgxaAR4Sl20pkXpfvLwWbEw/8gFoTxuTx/hT/He8cVQXP7vt7QJYob6FhRro+A2EEz0GNR1v21hC3gqphtg1qLv3KVs3NhuYe13iEBBVJrEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(8676002)(44832011)(36756003)(107886003)(2906002)(956004)(2616005)(66946007)(508600001)(66556008)(66476007)(316002)(4326008)(8936002)(38350700002)(83380400001)(52116002)(7696005)(6666004)(38100700002)(5660300002)(86362001)(7416002)(26005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i9pnrORL1u8t2uLQSFT+esrdpHrA3VOs4UUSNtUXta2fCN8tdM80vSXkIkWN?=
 =?us-ascii?Q?Kqjjw/646rw81xlGCJUMcplcqXzHcumHRHReTDpAFNTN+HJdyOmNSiiDEOvq?=
 =?us-ascii?Q?8pcjVPsBjeIgY7pdqO0+2dy6bOKy9gh/x8D/xbwEyb7mmkvxqpZgNcYQUU1r?=
 =?us-ascii?Q?2hJdOYiBoJ7gbw+WuoaPOJIkcgkg0/4RfLh9zkXTFIUZmiIMZhm/SzRrG3Ll?=
 =?us-ascii?Q?XFS6brvibigvQ/wsexJgYZM2J6s1rH78TZjsYPJIg/3YoNAhxI2arqeil2xg?=
 =?us-ascii?Q?OZqFRbV5/C9Ynws38x+djYd9qUcJkt2mnRBRq7Uvzt+oeuo2w3+/VQ4FWFBW?=
 =?us-ascii?Q?uyDcGVuYEkJ0ds7TpTaaEQbEwEyKmIuw86Sah+Pb/ficeyFyOL9Hahsv/C49?=
 =?us-ascii?Q?fnLWFrcyP69iL7/CTzRP8Z7R7OSlzfO2enFRG4t4dbWYpE//aZZfD3vjSNMV?=
 =?us-ascii?Q?W2fnS3I23/8KZwIlE2mFpKTuf/qT1GhHCkfUNA/PnO69EcQDlzmnA4Xr7Z6h?=
 =?us-ascii?Q?mGaI4Ky+f1a3dAJpOwREka7T3JZL6tTRnjAPHMUS3fdWmrYzcjNnYAUX9fF+?=
 =?us-ascii?Q?3N/4AW4AqR/DDdt22Econ+g8Nfawi8GR2SoDiPFTzrYEUj51uENYQnyvJR5c?=
 =?us-ascii?Q?BLgE36XTY8cjUiFGw9V5eHxh+DkBBOW0l8dFunrCLIUyjq8s/DILIpCe2VSt?=
 =?us-ascii?Q?QYQZtVgFaspEhWABYc7hNAFF51GOrlI2ZWgs1+GYYhoaXYyuSZd4aazqlU9O?=
 =?us-ascii?Q?6yEAe4pCykqcSfS5YF4zW4r9udLu483xm1H3Q8gz/cC7rYvm4bgKai/j8huc?=
 =?us-ascii?Q?AW403Km76y0kdeVITINY2oWTAXADSot42ggs6qqAfIZRRwDn0DgTDEnDcP9R?=
 =?us-ascii?Q?JcGits+nxzSlLw60bNT5nmQhEbOJsQ0EogN/4p8LNXmb1xVA3OlhdbwSVtRT?=
 =?us-ascii?Q?U6j+LYgERn2ztDCxGFNnJb/M7KpVuKWKPiFXFit6TpUQyl+GSeM6zMPwoqm2?=
 =?us-ascii?Q?MlpX0a0hHyGFARozNBjOvbmDCzZaXa80oi1vTkWxLe25rfBBUY/ZEaqcYHHm?=
 =?us-ascii?Q?h2YKIRQY/k11UrRieAXEGFEi4OSfbI0XK1UMEXDQNbhH96uaNjLRSPW6IPT2?=
 =?us-ascii?Q?LW0j0bAPRikttKmPe7ubfNtB3448Dj3u+BV/ONQmQ2FW/q4aOCIB27OqThip?=
 =?us-ascii?Q?lXHbtDjnPxbAisXGxoESoe9pilWUzJqKDM7bQjEU9W4+b6qFRenTuVQPRjp+?=
 =?us-ascii?Q?TJplqVYfXdWW6NvpbhYL5tYLO1QKoLQ+tJdHxig824o8pjwSMunRo6Arn6l7?=
 =?us-ascii?Q?KAMmhn+xP6301J3Al/MsXP7FPWVx7EY6sObR81QzBIZ26WCAkdRbUanbubIw?=
 =?us-ascii?Q?FunR93CaOxLSBFDa4GSjFs33AHu14BOgXB+rfqeNdFaLtH9C7ocNwd7AnZo6?=
 =?us-ascii?Q?QMdAWqBGgfkQtFZTVZhMKdjWmwp0I6f7ddIv1xcLYVfJj8V8FAA6zfs0IGGa?=
 =?us-ascii?Q?1nX/BdqybozSPuYR/LsNkdmdthvB9zOzxSLMxALC0nVRn0kL3N968ZJ6CsCA?=
 =?us-ascii?Q?7RqkiuhvdDJUgkYhjnIaOQSeBd7SeVRG+u2qmV2lEPoZcrafIKJpVkz8gKWo?=
 =?us-ascii?Q?zm+JwZD68JgBGZCuQ7qhmhA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b20b62be-0f9e-4770-d658-08d9a07c7170
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 16:50:59.2132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dlPmLhvkCaQkrlef9BuDOk7hufNr3qoF8Owyp5GoQ8eLF+kE4DrSXihVD7Eq2WNkWpXddFrTXXh8zFxc/HPjzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3213
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10159 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050094
X-Proofpoint-GUID: K7nSrEz0rhJ66NzgQRPlW0ixfhG_BYAA
X-Proofpoint-ORIG-GUID: K7nSrEz0rhJ66NzgQRPlW0ixfhG_BYAA
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
anything without proximity limitation.

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
 arch/arm64/include/asm/extable.h | 9 ---------
 arch/arm64/include/asm/memory.h  | 5 +----
 arch/arm64/kernel/traps.c        | 2 +-
 arch/arm64/mm/ptdump.c           | 2 --
 arch/arm64/net/bpf_jit_comp.c    | 7 ++-----
 5 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/extable.h b/arch/arm64/include/asm/extable.h
index 8b300dd..72b0e71 100644
--- a/arch/arm64/include/asm/extable.h
+++ b/arch/arm64/include/asm/extable.h
@@ -33,15 +33,6 @@ struct exception_table_entry
 	(b)->data = (tmp).data;				\
 } while (0)
 
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
 bool ex_handler_bpf(const struct exception_table_entry *ex,
 		    struct pt_regs *regs);
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 1b9a1e2..0af70d9 100644
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
index 7b21213..e8986e6 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -994,7 +994,7 @@ static int bug_handler(struct pt_regs *regs, unsigned int esr)
 static int reserved_fault_handler(struct pt_regs *regs, unsigned int esr)
 {
 	pr_err("%s generated an invalid instruction at %pS!\n",
-		in_bpf_jit(regs) ? "BPF JIT" : "Kernel text patching",
+		"Kernel text patching",
 		(void *)instruction_pointer(regs));
 
 	/* We cannot handle this */
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
index 3a8a714..86c9dc0 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1141,15 +1141,12 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 
 u64 bpf_jit_alloc_exec_limit(void)
 {
-	return BPF_JIT_REGION_SIZE;
+	return VMALLOC_END - VMALLOC_START;
 }
 
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

