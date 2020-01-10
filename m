Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFB8013679D
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 07:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731656AbgAJGlp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Jan 2020 01:41:45 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47466 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731644AbgAJGlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 01:41:45 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00A6cLUv029021
        for <netdev@vger.kernel.org>; Thu, 9 Jan 2020 22:41:44 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xe9eeb39w-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 22:41:43 -0800
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 9 Jan 2020 22:41:42 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 5F69B760DBA; Thu,  9 Jan 2020 22:41:34 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 5/6] selftests/bpf: Modify a test to check global functions
Date:   Thu, 9 Jan 2020 22:41:23 -0800
Message-ID: <20200110064124.1760511-6-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200110064124.1760511-1-ast@kernel.org>
References: <20200110064124.1760511-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 impostorscore=0 spamscore=0 bulkscore=0 malwarescore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 mlxlogscore=680 suspectscore=1
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001100055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make two static functions in test_xdp_noinline.c global:
before: processed 2790 insns
after: processed 2598 insns

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
---
 tools/testing/selftests/bpf/progs/test_xdp_noinline.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
index e88d7b9d65ab..f95bc1a17667 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
@@ -86,7 +86,7 @@ u32 jhash(const void *key, u32 length, u32 initval)
 	return c;
 }
 
-static __attribute__ ((noinline))
+__attribute__ ((noinline))
 u32 __jhash_nwords(u32 a, u32 b, u32 c, u32 initval)
 {
 	a += initval;
@@ -96,7 +96,7 @@ u32 __jhash_nwords(u32 a, u32 b, u32 c, u32 initval)
 	return c;
 }
 
-static __attribute__ ((noinline))
+__attribute__ ((noinline))
 u32 jhash_2words(u32 a, u32 b, u32 initval)
 {
 	return __jhash_nwords(a, b, 0, initval + JHASH_INITVAL + (2 << 2));
-- 
2.23.0

