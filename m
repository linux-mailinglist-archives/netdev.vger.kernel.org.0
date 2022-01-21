Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCF54965E4
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 20:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbiAUTts convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 Jan 2022 14:49:48 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12930 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232249AbiAUTto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 14:49:44 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20LGSdCE019512
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 11:49:44 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dqhyvwghn-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 11:49:44 -0800
Received: from twshared18912.14.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 21 Jan 2022 11:49:39 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 437FD284A5F10; Fri, 21 Jan 2022 11:49:32 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <peterz@infradead.org>, <x86@kernel.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v6 bpf-next 1/7] x86/Kconfig: select HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
Date:   Fri, 21 Jan 2022 11:49:20 -0800
Message-ID: <20220121194926.1970172-2-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121194926.1970172-1-song@kernel.org>
References: <20220121194926.1970172-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: wxKkM3yxSck7Jz-x_d87J2TotxbZ93q7
X-Proofpoint-GUID: wxKkM3yxSck7Jz-x_d87J2TotxbZ93q7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_09,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 spamscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 malwarescore=0 mlxlogscore=914 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201210128
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

This enables module_alloc() to allocate huge page for 2MB+ requests.
To check the difference of this change, we need enable config
CONFIG_PTDUMP_DEBUGFS, and call module_alloc(2MB). Before the change,
/sys/kernel/debug/page_tables/kernel shows pte for this map. With the
change, /sys/kernel/debug/page_tables/ show pmd for thie map.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8910b09b5601..b5d1582ea848 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -158,6 +158,7 @@ config X86
 	select HAVE_ALIGNED_STRUCT_PAGE		if SLUB
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_HUGE_VMAP		if X86_64 || X86_PAE
+	select HAVE_ARCH_HUGE_VMALLOC		if HAVE_ARCH_HUGE_VMAP
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_JUMP_LABEL_RELATIVE
 	select HAVE_ARCH_KASAN			if X86_64
-- 
2.30.2

