Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5679D135347
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 07:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgAIGiF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 9 Jan 2020 01:38:05 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20740 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728177AbgAIGiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 01:38:03 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0096a2ZC000348
        for <netdev@vger.kernel.org>; Wed, 8 Jan 2020 22:38:03 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xd3ep7r98-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 22:38:02 -0800
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 8 Jan 2020 22:38:01 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id D0547760FEC; Wed,  8 Jan 2020 22:37:57 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 6/7] selftests/bpf: Modify a test to check global functions
Date:   Wed, 8 Jan 2020 22:37:44 -0800
Message-ID: <20200109063745.3154913-7-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200109063745.3154913-1-ast@kernel.org>
References: <20200109063745.3154913-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-09_01:2020-01-08,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 mlxlogscore=694 phishscore=0 clxscore=1034 impostorscore=0 mlxscore=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001090056
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

