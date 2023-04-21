Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCEF6EA3C7
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 08:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjDUGWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 02:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDUGWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 02:22:41 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EF5E4B;
        Thu, 20 Apr 2023 23:22:39 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-2f67111b2d0so170718f8f.0;
        Thu, 20 Apr 2023 23:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682058158; x=1684650158;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tMge9gBnwOLzBw9MQyGbZzP0hFS5mgBUV5md73joDng=;
        b=fB2brlXfc+B8KY5x7hIcmd02imbSDK/lkj5CGbp+xT9XswzBbaGE5Utlq+m8JyrVwg
         7WldyhLFt95xKavZ2EbSDSthEgauDPmFGKEHawBuXITYIFPQ7iTVkJMsmWRKHucqDkzM
         nn9NFpDQMyB7cotPHAhSugXvG4VHsFORjf1G5a4KuO0r1BfHASauLfC8K0VxF3yN5oU0
         SbsiaqiajPh1w6/6/+CKj42rl079O/5KNlQtSehJno/lFNItCguxwLiD5VtxhyTPEgPc
         d/Z6YMfqMOTWjywvnoa6wVHiGBHvpp+rNyO0RxuzWABnSaNRfMcsI5MndGi2QfQupUbI
         cBhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682058158; x=1684650158;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tMge9gBnwOLzBw9MQyGbZzP0hFS5mgBUV5md73joDng=;
        b=a5cC/3gDL18/lSbh9jfawDDpIDtbSoszXZjrulFWzjVewGA+JS6bPY/Y2jVrwm4oDU
         rKyYTDz0IJKN3NpX+2VfsXbFjJeeVs0Avhz7mwI5wL9AL66o+fUYHMhod1wwrnXRYMFc
         xAUEcieA2f7OcRQE65p85wjWnW8Yr5MkLjY8LuWSoxfoQ4IjgI0bYkMQeBQ8tKg6C8R3
         2lCjwI1Ft38LsAzYxBOnHey3NmVFUD3ibtmRRx4YdFwzj8Z91ugg+mTDiaaAp5Suhxdr
         cMWe4D7GLoAMAqQizB85xb1Qij6tSpSpPtda4G9g+guIi5U5NETp9ZjLfSxGumcInYDA
         pUAw==
X-Gm-Message-State: AAQBX9ehcnpH+o/V89F316r6AWpRGSm+WgqrzciYkbjtb4pU8MkI9Hks
        HCrJEp3Xf3uNd2H6MAs4qnE=
X-Google-Smtp-Source: AKy350anU6wKwVdopXg0Klb7/2EqtE1JUqZSMY1hKs6uG1YLRuzjt/qmmo04/VpiyXPQeAwBU+c7VQ==
X-Received: by 2002:a5d:4fcd:0:b0:2f7:ee2:c2a3 with SMTP id h13-20020a5d4fcd000000b002f70ee2c2a3mr2479402wrw.3.1682058158203;
        Thu, 20 Apr 2023 23:22:38 -0700 (PDT)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id z16-20020a5d4410000000b002fb0c5a0458sm3621114wrq.91.2023.04.20.23.22.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Apr 2023 23:22:37 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, tirthendu.sarkar@intel.com,
        kal.conley@dectris.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf-next] selftests/xsk: put MAP_HUGE_2MB in correct argument
Date:   Fri, 21 Apr 2023 08:22:08 +0200
Message-Id: <20230421062208.3772-1-magnus.karlsson@gmail.com>
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

Put the flag MAP_HUGE_2MB in the correct flags argument instead of the
wrong offset argument.

Fixes: 2ddade322925 ("selftests/xsk: Fix munmap for hugepage allocated umem")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index a59d04118842..f144d0604ddf 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1287,19 +1287,16 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	u64 umem_sz = ifobject->umem->num_frames * ifobject->umem->frame_size;
 	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
 	LIBBPF_OPTS(bpf_xdp_query_opts, opts);
-	off_t mmap_offset = 0;
 	void *bufs;
 	int ret;
 
-	if (ifobject->umem->unaligned_mode) {
-		mmap_flags |= MAP_HUGETLB;
-		mmap_offset = MAP_HUGE_2MB;
-	}
+	if (ifobject->umem->unaligned_mode)
+		mmap_flags |= MAP_HUGETLB | MAP_HUGE_2MB;
 
 	if (ifobject->shared_umem)
 		umem_sz *= 2;
 
-	bufs = mmap(NULL, umem_sz, PROT_READ | PROT_WRITE, mmap_flags, -1, mmap_offset);
+	bufs = mmap(NULL, umem_sz, PROT_READ | PROT_WRITE, mmap_flags, -1, 0);
 	if (bufs == MAP_FAILED)
 		exit_with_error(errno);
 
@@ -1633,7 +1630,7 @@ static bool hugepages_present(struct ifobject *ifobject)
 	void *bufs;
 
 	bufs = mmap(NULL, mmap_sz, PROT_READ | PROT_WRITE,
-		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, MAP_HUGE_2MB);
+		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_HUGE_2MB, -1, 0);
 	if (bufs == MAP_FAILED)
 		return false;
 

base-commit: 267a6e4e7870beb8896c192da175800e47c82407
-- 
2.34.1

