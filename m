Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7C45C04E6
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 19:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiIURAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 13:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiIURAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 13:00:11 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C1D43E4D;
        Wed, 21 Sep 2022 10:00:09 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id t70so6539430pgc.5;
        Wed, 21 Sep 2022 10:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=nx1Pb9dM/JhxWQDw5gPMNf7lql+4Go4MShpr0kH8cc0=;
        b=CSmmdZMqYw079U3775ip77HfU+VXCgRduxH7nLU4fKoetQbDbOwQj0N5VV1/R8yDTB
         C5GMBqy47IWpmoTOMmzVq61LzA369UyUVSLinzDwi61L1Axo/PtoSDz2JbP4bzVDzaWl
         1yV5Q4v2g2Z3JLxsorCYmgdPG5ImO6aspZeVppBKF97s56qvy400HqJMer+UI3a14YRR
         gSkLqNo0MAdXwSJHLuriZIstp04xsabXLTTzSVuR4NtzxdYn7TiL3vyQmHPZCYD9N5AT
         3qL2QoEN7swf8pRaRkA/ygy+yZTv4hx4oPBNO5o+2cICKWm6vzzgWsev4IqCrVliZOvV
         rnBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=nx1Pb9dM/JhxWQDw5gPMNf7lql+4Go4MShpr0kH8cc0=;
        b=dBnjnRRWZLfjVkWpXouFf0WsijGrOLVek3s1LxR8IM5psMglzSshBmlS0rtXXtG7HN
         CSIvzXDwmifBhFoVMn7m67I1U6qOErEIghYOH7aGJQbGfH9PRUEjrxKzDSDC7+vhucPB
         d5IWp86MUj7wkpJYtbZCxKbDlGLxV2THRmvLXyP/sF/kW/TSdGpYmnY/8YqE1iZwFhzV
         9scwKmUaFDS9vmWaKAff+kY0aiwBBcACUbGf+jolJ2b5Dd8uLR0JYEWG/FTAYiOxQk5L
         FDbBaBp0bLrbVaZZzl222vvvWTq2BFsmu4BM5r9CtnTCBCHoC5ZjfJ3qg2fuNxsoo6F4
         VsVw==
X-Gm-Message-State: ACrzQf1KfWaIg/BS+pns1uqw9pxqD1+6hcBJbwT2fmfuzNhbnmNfoJom
        7WoeHFYPEcVfh3przt63LjU=
X-Google-Smtp-Source: AMsMyM5lFjvc00By5S97lTbkK6aQKp+jRrL0ah3mK3K52ySB+gICbHi4wmo/VDJyZQSp3t7PQblKqg==
X-Received: by 2002:a05:6a00:248b:b0:542:6ae2:24d5 with SMTP id c11-20020a056a00248b00b005426ae224d5mr30838022pfv.65.1663779608600;
        Wed, 21 Sep 2022 10:00:08 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:488e:5400:4ff:fe25:7db8])
        by smtp.gmail.com with ESMTPSA id mp4-20020a17090b190400b002006f8e7688sm2102495pjb.32.2022.09.21.10.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 10:00:07 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org, tj@kernel.org,
        lizefan.x@bytedance.com
Cc:     cgroups@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 00/10] bpf, mm: Add a new item bpf into memory.stat for the observability of bpf memory
Date:   Wed, 21 Sep 2022 16:59:52 +0000
Message-Id: <20220921170002.29557-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds a new item 'bpf' into memory.stat to show the bpf
memory usage in each memcg (except the root memcg because kmem is not
charged into root memcg now). The bpf memory usage is not trivial, so it
deserves a new item.

Patches #1 ~ #8 are from another series[1] which try to fix the pinned bpf
issues, but it seems to be a long way to go. So let's do the observability
first, which has been in my local repo for a long time.

We use the scope-based accouting/unaccouthing to track the bpf memory
usage, which is similar with the way how we charge bpf memory.

We have to annotate both allocations and releases of bpf memory because we
don't want to add something into struct page currently. The allocations
and releases of bpf memory are very clear, so it won't be a trouble.

This patchset only tracks the memory of bpf-map currently.

Future works:
- track the memory of bpf-prog
- observe system-wide bpf memory usage by adding this item into root memcg
- per-map and per-prog bpf memory usage in bpftool or something else
- give user an option to disable memcg-based bpf accouting [2]

Any feedback is welcomed.

[1]. https://lore.kernel.org/bpf/20220902023003.47124-1-laoar.shao@gmail.com/
[2]. https://lore.kernel.org/bpf/CALOAHbAOkUpDWaL2kP8ntBe6sj8S0thLmAwZXhG5kFKBunHt_w@mail.gmail.com/T/#m3597928c7161b206cb9218c80d9e58a42128d31a

Yafang Shao (10):
  bpf: Introduce new helper bpf_map_put_memcg()
  bpf: Define bpf_map_{get,put}_memcg for !CONFIG_MEMCG_KMEM
  bpf: Call bpf_map_init_from_attr() immediately after map creation
  bpf: Save memcg in bpf_map_init_from_attr()
  bpf: Use scoped-based charge in bpf_map_area_alloc
  bpf: Introduce new helpers bpf_ringbuf_pages_{alloc,free}
  bpf: Use bpf_map_kzalloc in arraymap
  bpf: Use bpf_map_kvcalloc in bpf_local_storage
  bpf: Add bpf map free helpers
  bpf, memcg: Add new item bpf into memory.stat

 include/linux/bpf.h            |  70 ++++++++++++++++++-
 include/linux/memcontrol.h     |  11 +++
 include/linux/sched.h          |   1 +
 include/linux/sched/mm.h       |  24 +++++++
 kernel/bpf/arraymap.c          |  30 ++++-----
 kernel/bpf/bloom_filter.c      |   4 +-
 kernel/bpf/bpf_local_storage.c |  20 +++---
 kernel/bpf/bpf_struct_ops.c    |  14 ++--
 kernel/bpf/cpumap.c            |  24 +++----
 kernel/bpf/devmap.c            |  36 +++++-----
 kernel/bpf/hashtab.c           |  24 ++++---
 kernel/bpf/helpers.c           |   2 +-
 kernel/bpf/local_storage.c     |  14 ++--
 kernel/bpf/lpm_trie.c          |   6 +-
 kernel/bpf/memalloc.c          |  10 +++
 kernel/bpf/offload.c           |   6 +-
 kernel/bpf/queue_stack_maps.c  |   4 +-
 kernel/bpf/reuseport_array.c   |   4 +-
 kernel/bpf/ringbuf.c           | 106 ++++++++++++++++++++---------
 kernel/bpf/stackmap.c          |  13 ++--
 kernel/bpf/syscall.c           | 149 ++++++++++++++++++++++++++++++-----------
 kernel/fork.c                  |   1 +
 mm/memcontrol.c                |  20 ++++++
 net/core/sock_map.c            |  22 +++---
 net/xdp/xskmap.c               |   6 +-
 25 files changed, 439 insertions(+), 182 deletions(-)

-- 
1.8.3.1

