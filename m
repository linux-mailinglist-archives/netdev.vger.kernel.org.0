Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D214E5D14
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 03:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243573AbiCXCKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 22:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239878AbiCXCKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 22:10:20 -0400
Received: from mail.meizu.com (edge07.meizu.com [112.91.151.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DF6634F;
        Wed, 23 Mar 2022 19:08:48 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail11.meizu.com
 (172.16.1.15) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 24 Mar
 2022 10:08:47 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Thu, 24 Mar
 2022 10:08:46 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     <shuah@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>
CC:     <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Haowen Bai <baihaowen@meizu.com>
Subject: [PATCH] selftests/bpf: Fix warning comparing pointer to 0
Date:   Thu, 24 Mar 2022 10:08:45 +0800
Message-ID: <1648087725-29435-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-125.meizu.com (172.16.1.125) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid pointer type value compared with 0 to make code clear.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
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

