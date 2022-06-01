Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8740539FB9
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 10:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237030AbiFAImI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 04:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236203AbiFAImE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 04:42:04 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6F95D1AD
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 01:42:02 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d22so1134633plr.9
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 01:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=17jbuB5ApQ2iSURu9wqbSRYsL+H5kiM4U+n5E3wCBBM=;
        b=YYZpXVz73I9bIFut7IGyzJAak1gGAmGFP83a1uzg+MbXHP4zJnmYRW9bqGEDjGyR2I
         HJXNd8uEjusQFPFgN6CF3/Or0xXd9WObAbppzV4d8Kjakf1n5Bqq541sZNKKbrak0Rf1
         hrDXWpV3hBS7wdFZwABFJY2YTT0OEV3UliHm8En96ewOikvWUC24a3lWC5aEIyjl1Rq3
         Pa6mrpOFzFDUQXjNa0LWgt2GDywWPnSzh6tHJvyuW2v+Jyn5xhWaNAl/abKtz2/oxhuw
         DEZnaVlwaujCN2IiKgLcW9S1QrinBOu344RdmTHD3dq3DqOWnxjSb1oExOmkyerAVMQ+
         kWNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=17jbuB5ApQ2iSURu9wqbSRYsL+H5kiM4U+n5E3wCBBM=;
        b=XMOjn4neoSxdibsrBmg9GRtzGfwiwGcSiK8/xO8nFQ4/t3u6/tvvZ5Cb/oUPGwbEs7
         KYO1FdAVM5YA4010FCiO/8FwxxyVcMeGnRBpTLTduKrfD5Gd7m0p30nhytb2Ddf7N1jE
         pAPxwS2jZPElQywqA9PQ6lpGBDQTKJKfYZENeTq21PB97P3OJaQ8K9GaAb9RQO6fNAqd
         GWv/I7pFFA7rkB5qJdP+FWcplBi4guRABYz2ZquUgE3qbNI1e+BpXvo1cVSxBQP2AxP8
         NOvztFuoDBrjrSaYKkFHDcoop9Fs09thdJkhFNa+WXQ1r10tj6zve9mwriCojKpr1G7h
         JRAw==
X-Gm-Message-State: AOAM530oAnWUDatA0Gzk7gD2YaWGRW/55AVNSi/Sk26OdeJeqeIV5vWS
        r2F2n/sV/3z88Ip+m0H7zqLNVQ==
X-Google-Smtp-Source: ABdhPJwRgSG1EOyJ20GwRk9Y2BJbzzZUUJFfjUP4QN+PP1rE56lDFxd9N311EPujHZyQhJ1llk8qXQ==
X-Received: by 2002:a17:902:8c90:b0:163:b989:3cd6 with SMTP id t16-20020a1709028c9000b00163b9893cd6mr17865260plo.170.1654072922062;
        Wed, 01 Jun 2022 01:42:02 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id u11-20020a63d34b000000b003c14af505f6sm827952pgi.14.2022.06.01.01.41.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Jun 2022 01:42:01 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, wangdongdong.6@bytedance.com,
        cong.wang@bytedance.com, zhouchengming@bytedance.com,
        zhoufeng.zf@bytedance.com
Subject: [PATCH v4 0/2] Optimize performance of update hash-map when free is zero
Date:   Wed,  1 Jun 2022 16:41:47 +0800
Message-Id: <20220601084149.13097-1-zhoufeng.zf@bytedance.com>
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

