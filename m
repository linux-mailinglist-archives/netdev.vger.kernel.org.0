Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3A94EB814
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 04:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241814AbiC3CBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 22:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241785AbiC3CBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 22:01:44 -0400
Received: from mail.meizu.com (edge05.meizu.com [157.122.146.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC7D6D19B;
        Tue, 29 Mar 2022 18:59:58 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail12.meizu.com
 (172.16.1.108) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 30 Mar
 2022 09:59:58 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Wed, 30 Mar
 2022 09:59:56 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     Haowen Bai <baihaowen@meizu.com>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V2] selftests/bpf: Fix warning comparing pointer to 0
Date:   Wed, 30 Mar 2022 09:59:48 +0800
Message-ID: <1648605588-19269-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <29503ac1-69ab-a0b7-53bc-5a7522baa289@linuxfoundation.org>
References: <29503ac1-69ab-a0b7-53bc-5a7522baa289@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-125.meizu.com (172.16.1.125) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid pointer type value compared with 0 to make code clear.

reported by coccicheck:
tools/testing/selftests/bpf/progs/map_ptr_kern.c:370:21-22:
WARNING comparing pointer to 0
tools/testing/selftests/bpf/progs/map_ptr_kern.c:397:21-22:
WARNING comparing pointer to 0

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
V1->V2: include the error/warn message.

 tools/testing/selftests/bpf/progs/map_ptr_kern.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/map_ptr_kern.c b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
index b64df94..db388f5 100644
--- a/tools/testing/selftests/bpf/progs/map_ptr_kern.c
+++ b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
@@ -367,7 +367,7 @@ static inline int check_array_of_maps(void)
 
 	VERIFY(check_default(&array_of_maps->map, map));
 	inner_map = bpf_map_lookup_elem(array_of_maps, &key);
-	VERIFY(inner_map != 0);
+	VERIFY(inner_map != NULL);
 	VERIFY(inner_map->map.max_entries == INNER_MAX_ENTRIES);
 
 	return 1;
@@ -394,7 +394,7 @@ static inline int check_hash_of_maps(void)
 
 	VERIFY(check_default(&hash_of_maps->map, map));
 	inner_map = bpf_map_lookup_elem(hash_of_maps, &key);
-	VERIFY(inner_map != 0);
+	VERIFY(inner_map != NULL);
 	VERIFY(inner_map->map.max_entries == INNER_MAX_ENTRIES);
 
 	return 1;
-- 
2.7.4

