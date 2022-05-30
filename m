Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BED3A537852
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234702AbiE3JNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 05:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234695AbiE3JNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 05:13:54 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D0778EFF
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 02:13:53 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id q18so9785514pln.12
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 02:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JNP+R0ohcLUjNtDJRZoqQVoepX4pDHJ5Tzsqw/Ip/us=;
        b=1zsRDNM7+bOnSAXrGT8GTnB+LPiaiWeULGvPDxnh8ygbaIBhoXtWi5qIMtlR+0jVC3
         mCvGt4XP1HvP05Ke+93gP1wyUTIWPC8TqTkPUCoiPi8wDLv8QUjVuAY9G0wfAwfbjglm
         NoKvGVb3RhJ+KbFn1b/3H6xRut1xSH5jjCVxn04Hu4IuhaomW+hHiu/5rI8BZ8F3q5pX
         eBlK0Kq1pBmWUk7cwGnPfxh4Z4PAB1MyZytQjrashWTXpKvEnWe8/jjjhSVvNtkcdGZ2
         VnvSXj+wY3xyfzW3dI1WBCB648rq6dK65QaH+KQdProsmF9O+QYp5Geg7zOqauaANpg9
         6iUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JNP+R0ohcLUjNtDJRZoqQVoepX4pDHJ5Tzsqw/Ip/us=;
        b=VLdhhiUCmr7AFADqmAfGfMLk7qDoot6wl2lF6KGtNhW4b2Tr3awTHKA+Mg69VBS2qq
         Xt0Kaw+CM+u7csQ09+F7FY/CRvWliKIHYhCJjfjL9QODzM/LpQr4r6oPyzsBVcY3QBwa
         Dlqg4Sj0lC99jG04g2zQgc74fRqNRC7EH1VosJnCOvzQ6gx2rV2G4AZojTDnaUoBdyLD
         eXVw96q+86nL5Jvyc0uaVLSmgX61l5hM7xyjmPCfRbILrcc3wEjTE/HJfuyyVDSdtAUc
         O+dtYsRqu+AYpIeaOarzmYaUZW6yUI01Z/zMjqS0zbIYwEUFUtRZPKIR8sMRkps3/oYT
         fyig==
X-Gm-Message-State: AOAM530WcX8yoFEB+++Lp2QKqlKeyizufTUbTwx0LLnJizlR2Py15cVC
        lg5Gg6z+fGxVL9kfwSnkFvKO7Q==
X-Google-Smtp-Source: ABdhPJy6/T1nAe2l6F6QTn/YqY4r78bM0hS6jGpWftKdzqrtiEzTF325nNWOg/9YtvKgUD7qLfn7Yw==
X-Received: by 2002:a17:903:22cc:b0:162:4d8b:e2eb with SMTP id y12-20020a17090322cc00b001624d8be2ebmr29890361plg.22.1653902032530;
        Mon, 30 May 2022 02:13:52 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id p2-20020a170902ebc200b0015e8d4eb20dsm8640644plg.87.2022.05.30.02.13.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 May 2022 02:13:52 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, wangdongdong.6@bytedance.com,
        cong.wang@bytedance.com, zhouchengming@bytedance.com,
        zhoufeng.zf@bytedance.com
Subject: [PATCH v3 0/2] Optimize performance of update hash-map when free is zero
Date:   Mon, 30 May 2022 17:13:38 +0800
Message-Id: <20220530091340.53443-1-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Zhou <zhoufeng.zf@bytedance.com>

We encountered bad case on big system with 96 CPUs that
alloc_htab_elem() would last for 1ms. The reason is that after the
prealloc hashtab has no free elems, when trying to update, it will still
grab spin_locks of all cpus. If there are multiple update users, the
competition is very serious.

0001: Add is_empty to check whether the free list is empty or not before taking
the lock.
0002: Add benchmark to reproduce this worst case.

Changelog:
v2->v3: Addressed comments from Alexei Starovoitov, Andrii Nakryiko.
- Adjust the way the benchmark is tested.
- Adjust the code format.
some details in here:
https://lore.kernel.org/all/20220524075306.32306-1-zhoufeng.zf@bytedance.com/T/

v1->v2: Addressed comments from Alexei Starovoitov.
- add a benchmark to reproduce the issue.
- Adjust the code format that avoid adding indent.
some details in here:
https://lore.kernel.org/all/877ac441-045b-1844-6938-fcaee5eee7f2@bytedance.com/T/

Feng Zhou (2):
  bpf: avoid grabbing spin_locks of all cpus when no free elems
  selftest/bpf/benchs: Add bpf_map benchmark

 kernel/bpf/percpu_freelist.c                  | 28 +++++-
 kernel/bpf/percpu_freelist.h                  |  1 +
 tools/testing/selftests/bpf/Makefile          |  4 +-
 tools/testing/selftests/bpf/bench.c           |  2 +
 .../benchs/bench_bpf_hashmap_full_update.c    | 96 +++++++++++++++++++
 .../run_bench_bpf_hashmap_full_update.sh      | 11 +++
 .../bpf/progs/bpf_hashmap_full_update_bench.c | 40 ++++++++
 7 files changed, 178 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_bpf_hashmap_full_update.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_bpf_hashmap_full_update.sh
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_hashmap_full_update_bench.c

-- 
2.20.1

