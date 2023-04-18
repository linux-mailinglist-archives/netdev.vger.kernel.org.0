Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC49D6E6744
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 16:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjDROgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 10:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjDROgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 10:36:37 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D974C13;
        Tue, 18 Apr 2023 07:36:35 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f16f792384so5854855e9.0;
        Tue, 18 Apr 2023 07:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681828593; x=1684420593;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qQnGtAgdwH+ZHrmgRXxkZJS69+KRcBp67+T8pcKjP0Y=;
        b=IY2L5qV7CMVyX8FM7dD8Ka9FtO6dUkMt5vHMjF3bdv8dVi89c2jT18UPNJL0rvLMoz
         mn128Tg9pDJCD4Xkd4btdZzUjahDD7NGhhv5Eqz9TzNmdPfMsdwa++skh/rCBJkIzV6f
         Qe6UecuMl60V3lUr7E5WDWJRbQ7yOOKvrSHFS0ZynQ3/FLkNETy79EmjdrwsORivpcI2
         eM4P1uZCZ+Tp3XXAloF3GmPvKby/mssU9se5GxbEViTjHb3YYYsYJMllm+JQQe6Wk/Qs
         v0rZSmLEbYALGKnWXKzHC3xYhegetAsOJoaJlwRxlIh0x1pyOxSkZGBLsOAjoNzAMV7g
         UplA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681828593; x=1684420593;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qQnGtAgdwH+ZHrmgRXxkZJS69+KRcBp67+T8pcKjP0Y=;
        b=DPBG3svrw2wNbHpQMwwO4hFME5YPssFBtQ9sgDvZxHYWNfIWLZkvGwXKEdguK7ObFJ
         xzW+/sh/QtSGDaYIOD+pupngP68D6+FBXAo+PxULZhvk8wgmNCcbW5S2Hlnd01jlv77U
         iqWKeHgOw1u8fw/Csc2cxFxl/SBsw97FRoSZFG365+PJPTcRj96JZUtsrb1r+cbz4/CA
         7p6Q1Ne2FREBLCfB4WPYE2A3/y+3QRydMWlXChQNzPCvSoqrYNpNU6fPsqyXzh1SUJTT
         2V6KTqxzvDFtNpiA6v/beEoCdPF9PklLUyiMKNHPRjkqr3fe1GIQ6aeb7ss5FXP3Csjz
         2PkA==
X-Gm-Message-State: AAQBX9fyaMko0/8HwnNsQcpcGTDMyy66H5Ny3eKNXsoGmZlwNuoWoR2F
        d3WqHB5zWDii+Rc6qHOMBSA=
X-Google-Smtp-Source: AKy350bWjhag9MBm/KfKnzd6DVCplauqq4DZGrYBg8inD8vubbhub9gh/nNE26bNlydh1ho3LSywTA==
X-Received: by 2002:a05:600c:1f0e:b0:3f1:7518:e37f with SMTP id bd14-20020a05600c1f0e00b003f17518e37fmr4589349wmb.1.1681828593512;
        Tue, 18 Apr 2023 07:36:33 -0700 (PDT)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c470a00b003ef36ef3833sm19147307wmo.8.2023.04.18.07.36.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Apr 2023 07:36:33 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, tirthendu.sarkar@intel.com,
        kal.conley@dectris.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf-next] selftests/xsk: fix munmap for hugepage allocated umem
Date:   Tue, 18 Apr 2023 16:36:17 +0200
Message-Id: <20230418143617.27762-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix the unmapping of hugepage allocated umems so that they are
properly unmapped. The new test referred to in the fixes label,
introduced a test that allocated a umem that is not a multiple of a 2M
hugepage size. This is fine for mmap() that rounds the size up the
nearest multiple of 2M. But munmap() requires the size to be a
multiple of the hugepage size in order for it to unmap the region. The
current behaviour of not properly unmapping the umem, was discovered
when further additions of tests that require hugepages (unaligned mode
tests only) started failing as the system was running out of
hugepages.

Fixes: c0801598e543 ("selftests: xsk: Add test UNALIGNED_INV_DESC_4K1_FRAME_SIZE")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 19 +++++++++++++++----
 tools/testing/selftests/bpf/xskxceiver.h |  1 +
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 5a9691e942de..a59d04118842 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -77,6 +77,7 @@
 #include <linux/if_link.h>
 #include <linux/if_ether.h>
 #include <linux/ip.h>
+#include <linux/mman.h>
 #include <linux/udp.h>
 #include <arpa/inet.h>
 #include <net/if.h>
@@ -1286,16 +1287,19 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	u64 umem_sz = ifobject->umem->num_frames * ifobject->umem->frame_size;
 	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
 	LIBBPF_OPTS(bpf_xdp_query_opts, opts);
+	off_t mmap_offset = 0;
 	void *bufs;
 	int ret;
 
-	if (ifobject->umem->unaligned_mode)
+	if (ifobject->umem->unaligned_mode) {
 		mmap_flags |= MAP_HUGETLB;
+		mmap_offset = MAP_HUGE_2MB;
+	}
 
 	if (ifobject->shared_umem)
 		umem_sz *= 2;
 
-	bufs = mmap(NULL, umem_sz, PROT_READ | PROT_WRITE, mmap_flags, -1, 0);
+	bufs = mmap(NULL, umem_sz, PROT_READ | PROT_WRITE, mmap_flags, -1, mmap_offset);
 	if (bufs == MAP_FAILED)
 		exit_with_error(errno);
 
@@ -1379,6 +1383,11 @@ static void *worker_testapp_validate_rx(void *arg)
 	pthread_exit(NULL);
 }
 
+static u64 ceil_u64(u64 a, u64 b)
+{
+	return (a + b - 1) / b;
+}
+
 static void testapp_clean_xsk_umem(struct ifobject *ifobj)
 {
 	u64 umem_sz = ifobj->umem->num_frames * ifobj->umem->frame_size;
@@ -1386,6 +1395,7 @@ static void testapp_clean_xsk_umem(struct ifobject *ifobj)
 	if (ifobj->shared_umem)
 		umem_sz *= 2;
 
+	umem_sz = ceil_u64(umem_sz, HUGEPAGE_SIZE) * HUGEPAGE_SIZE;
 	xsk_umem__delete(ifobj->umem->umem);
 	munmap(ifobj->umem->buffer, umem_sz);
 }
@@ -1619,14 +1629,15 @@ static void testapp_stats_fill_empty(struct test_spec *test)
 /* Simple test */
 static bool hugepages_present(struct ifobject *ifobject)
 {
-	const size_t mmap_sz = 2 * ifobject->umem->num_frames * ifobject->umem->frame_size;
+	size_t mmap_sz = 2 * ifobject->umem->num_frames * ifobject->umem->frame_size;
 	void *bufs;
 
 	bufs = mmap(NULL, mmap_sz, PROT_READ | PROT_WRITE,
-		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
+		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, MAP_HUGE_2MB);
 	if (bufs == MAP_FAILED)
 		return false;
 
+	mmap_sz = ceil_u64(mmap_sz, HUGEPAGE_SIZE) * HUGEPAGE_SIZE;
 	munmap(bufs, mmap_sz);
 	return true;
 }
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index 919327807a4e..c535aeab2ca3 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -56,6 +56,7 @@
 #define RX_FULL_RXQSIZE 32
 #define UMEM_HEADROOM_TEST_SIZE 128
 #define XSK_UMEM__INVALID_FRAME_SIZE (XSK_UMEM__DEFAULT_FRAME_SIZE + 1)
+#define HUGEPAGE_SIZE (2 * 1024 * 1024)
 
 #define print_verbose(x...) do { if (opt_verbose) ksft_print_msg(x); } while (0)
 

base-commit: 49859de997c3115b85544bce6b6ceab60a7fabc4
-- 
2.34.1

