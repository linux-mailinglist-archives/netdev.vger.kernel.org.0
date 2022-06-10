Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFD0545A1D
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 04:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345968AbiFJCdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 22:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345461AbiFJCdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 22:33:22 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739F12DA9C
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 19:33:19 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id c18so15196820pgh.11
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 19:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CbbZx2zk8AYEZVW7p2BT5m2zFh5Pea8yTg+uQSbw+ZM=;
        b=6NnaToAenAf+1qTbIO8zMXZDwLs6CWBr6sCZKb9/F0o+JhBfLDqqpgoqUOYSBqTJaj
         x0ynwxQfKHhGu/udqoOK3RIeIiU1k789L4oWGS09xStR4TasotWxwyepaAwm+VdDlsI+
         FSUPa5OgAP+YhMXO4d3jLQZecJzdJVgiR45HPPP35dvaVN+O9MWOXawywsD7ZvruDkb+
         9WX2Btc2oNDTSwAOsrfYOORjCV0O4/cWiMP/sVIgEVyc2Bf3qF81Af4lVf+ReemhYhpg
         Mg8MusUoBJqfquaQHpLwwvSAvwOIXtZLjDUMoD9L6xdvx8/BR4QJBPcyEeDLPdTiXepU
         4PZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CbbZx2zk8AYEZVW7p2BT5m2zFh5Pea8yTg+uQSbw+ZM=;
        b=eWLXhHlOpo9QtT3NYyKWay18YPwNvVrxjOqQS3zzXfk/lKWAaPM4q/LVN/JRqoxVKm
         zlRvyJbJ/hOESfBTlb8fNXoHfAFiFBP2BX9U/oLBsxanK4uO2OQoKtpDer6uuyiKVUcg
         uNdmcGE3FxSODpiparG/wnuy+VAXrtDivnKSS7ApUmrJQtVdUuLg/qO7KfDrVThRawWC
         L6YMdSH94AybNINaj9sHS8LQ9DFBIiFZfV89y7CHLV3nWDnisboPhYPHSddoDlf5FBLS
         6rsUvjZz1QgTVWPc+ythtkVvgSKhtGmtHge19GsJ7GJ/m/CY52ReQuG9lGwmg3FCqdA5
         KYaQ==
X-Gm-Message-State: AOAM532mq2ooejZVZNXKpF5SCRB3fbwuzNtL8hgfktLkCyag6ixJybNA
        CmyyJMRcKDVQvY3JjyqYd6oQig==
X-Google-Smtp-Source: ABdhPJzVM6pjqOZnA+9cgMO+iSFC75/9wKzJNgQBPVUrKEjdQv6By7SzmplxtEqU1WI1H1mgdM+Viw==
X-Received: by 2002:a63:1a1d:0:b0:3f5:eb02:b6b4 with SMTP id a29-20020a631a1d000000b003f5eb02b6b4mr37655988pga.343.1654828398929;
        Thu, 09 Jun 2022 19:33:18 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id o19-20020a170903009300b001620db30cd6sm17432481pld.201.2022.06.09.19.33.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jun 2022 19:33:18 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, wangdongdong.6@bytedance.com,
        cong.wang@bytedance.com, zhouchengming@bytedance.com,
        zhoufeng.zf@bytedance.com
Subject: [PATCH v6 0/2] Optimize performance of update hash-map when free is zero
Date:   Fri, 10 Jun 2022 10:33:06 +0800
Message-Id: <20220610023308.93798-1-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

0001: Use head->first to check whether the free list is empty or not before taking
the lock.
0002: Add benchmark to reproduce this worst case.

Changelog:
v5->v6: Addressed comments from Alexei Starovoitov.
- Adjust the commit log.
some details in here:
https://lore.kernel.org/all/20220608021050.47279-1-zhoufeng.zf@bytedance.com/

v4->v5: Addressed comments from Alexei Starovoitov.
- Use head->first.
- Use cpu+max_entries.
some details in here:
https://lore.kernel.org/bpf/20220601084149.13097-1-zhoufeng.zf@bytedance.com/

v3->v4: Addressed comments from Daniel Borkmann.
- Use READ_ONCE/WRITE_ONCE.
some details in here:
https://lore.kernel.org/all/20220530091340.53443-1-zhoufeng.zf@bytedance.com/

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

 kernel/bpf/percpu_freelist.c                  | 20 ++--
 tools/testing/selftests/bpf/Makefile          |  4 +-
 tools/testing/selftests/bpf/bench.c           |  2 +
 .../benchs/bench_bpf_hashmap_full_update.c    | 96 +++++++++++++++++++
 .../run_bench_bpf_hashmap_full_update.sh      | 11 +++
 .../bpf/progs/bpf_hashmap_full_update_bench.c | 40 ++++++++
 6 files changed, 166 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_bpf_hashmap_full_update.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_bpf_hashmap_full_update.sh
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_hashmap_full_update_bench.c

-- 
2.20.1

