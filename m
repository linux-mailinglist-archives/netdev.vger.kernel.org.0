Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41DC2D8869
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 08:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388477AbfJPGBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 02:01:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17972 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388369AbfJPGBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 02:01:19 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9G5wmft015212
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 23:01:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=IL1yW/YbbL8JvFC7hGyFJimUqs7jB+YTU6tF4L1TnVo=;
 b=ObrIz+T2BZH6vCWsGS0t2t6R5rpWBREN7OFuj2tZ9pmdB9ceos4mjuuEMVuUKvTMxsjn
 bN40vxDFuBr9vvJh1wZVxNefGxl1jlmjYag2vAg8dezkozzI5lYEOndZm3flJrBEiT8S
 1/WtikHKBFftx71DxjTsS8hQWhMrVEDye24= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2vnccackrj-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 23:01:18 -0700
Received: from 2401:db00:30:6012:face:0:17:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 15 Oct 2019 23:01:17 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 181C686195B; Tue, 15 Oct 2019 23:01:14 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v4 bpf-next 6/7] selftests/bpf: move test_queue_stack_map.h into progs/ where it belongs
Date:   Tue, 15 Oct 2019 23:00:50 -0700
Message-ID: <20191016060051.2024182-7-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016060051.2024182-1-andriin@fb.com>
References: <20191016060051.2024182-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_02:2019-10-15,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 mlxlogscore=898
 adultscore=0 malwarescore=0 suspectscore=8 phishscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160056
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

test_queue_stack_map.h is used only from BPF programs. Thus it should be
part of progs/ subdir. An added benefit of moving it there is that new
TEST_RUNNER_DEFINE_RULES macro-rule will properly capture dependency on
this header for all BPF objects and trigger re-build, if it changes.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile                           | 3 ---
 tools/testing/selftests/bpf/{ => progs}/test_queue_stack_map.h | 0
 2 files changed, 3 deletions(-)
 rename tools/testing/selftests/bpf/{ => progs}/test_queue_stack_map.h (100%)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index c9f43d49eac9..16056e5d399d 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -153,9 +153,6 @@ CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
 $(OUTPUT)/test_l4lb_noinline.o: BPF_CFLAGS += -fno-inline
 $(OUTPUT)/test_xdp_noinline.o: BPF_CFLAGS += -fno-inline
 
-$(OUTPUT)/test_queue_map.o: test_queue_stack_map.h
-$(OUTPUT)/test_stack_map.o: test_queue_stack_map.h
-
 $(OUTPUT)/flow_dissector_load.o: flow_dissector_load.h
 
 # Build BPF object using Clang
diff --git a/tools/testing/selftests/bpf/test_queue_stack_map.h b/tools/testing/selftests/bpf/progs/test_queue_stack_map.h
similarity index 100%
rename from tools/testing/selftests/bpf/test_queue_stack_map.h
rename to tools/testing/selftests/bpf/progs/test_queue_stack_map.h
-- 
2.17.1

