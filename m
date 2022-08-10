Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C585458EF0F
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbiHJPN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbiHJPNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:13:37 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197C37647D;
        Wed, 10 Aug 2022 08:13:35 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id p8so14469273plq.13;
        Wed, 10 Aug 2022 08:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=k27+VFhA3Xa3WrsnpWdG3xMdVqwolNbtk1/PnG0LJps=;
        b=BXF0sb1k58vqsOYCYl9HNeijdOqaB8BoBNuyGB/vovs6RJcWxIJUSP7irYdMFya/oi
         6FOdF/rgh+JeYpAljeqpcdm9gFhgcPZShA//p4RrWmWriIRVDrEKOKqDZn4+G0JBbXAB
         spRgyhVs/fy82eSJj+mEUDxG0X0FNE3rUor9+KmWjYzP/HLtDoQK6+78CrVEDjHVs7F3
         4Is2dVIT232rXDXE/S3XS1Uwj1bftIwBhVdVem3F1SZgn6tfMberi+J86RYQQQthWOMw
         YdckiUS0/GijPI+8KBEtJZfXw/+kIlID9ePZH5+jCdqQ8ti1wnmKeaYz+vvF0o5Xwh6I
         yBfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=k27+VFhA3Xa3WrsnpWdG3xMdVqwolNbtk1/PnG0LJps=;
        b=tWLI2jjRumL2bcRW2jl3xtS/ZCST6U/yWW7h7vWW3ibr4Bm9GNZt+dOqzS+Pp+XfaC
         i6Tcyg7VsKxGb+x8SiVULpspjLUEmgPxAEoVR7RmTFQZ7KKjU8eqe3wGOnKXGTaxkrtu
         pL0I54ZVs0UVwBzc48RXIeZky/XbCRoeGOTgywd5d4PottSkjLcMZudRME2dzsjrDFsj
         RkLmxmdQGGXbGmp4xMYu9G+m5oF1VtAYI0xdKLRLqX1S9GM88lrdUH3GVVcrDeHuPVNk
         880lh2jfpfKbmM4wZze3IfNaa4Q1TD8k80UQJk3JFdg5YAUI05Ad34pSf/MIUxi6YKHJ
         uSnQ==
X-Gm-Message-State: ACgBeo3pIHSrN6wyxVtbVZOYLvRUHNDdeBzED6/StGZ4Y79azEYX6O9h
        DaDyBMa6rh/GpwfNJY8Ie0o=
X-Google-Smtp-Source: AA6agR57VZqZfG+LBcbd9lC5p1/7tYyHuqMmQAT1v6iD8rHm1JIs99lY8yw6tjcCrK2w5sorWPVX6g==
X-Received: by 2002:a17:902:db0f:b0:16f:24e4:15ff with SMTP id m15-20020a170902db0f00b0016f24e415ffmr28467809plx.10.1660144415199;
        Wed, 10 Aug 2022 08:13:35 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5c3e:5400:4ff:fe19:c3bc])
        by smtp.gmail.com with ESMTPSA id n129-20020a622787000000b0052dcbd87ae8sm2118339pfn.25.2022.08.10.08.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:13:34 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 00/15] bpf: Introduce selectable memcg for bpf map 
Date:   Wed, 10 Aug 2022 15:13:07 +0000
Message-Id: <20220810151322.16163-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
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

On our production environment, we may load, run and pin bpf programs and
maps in containers. For example, some of our networking bpf programs and
maps are loaded and pinned by a process running in a container on our
k8s environment. In this container, there're also running some other
user applications which watch the networking configurations from remote
servers and update them on this local host, log the error events, monitor
the traffic, and do some other stuffs. Sometimes we may need to update 
these user applications to a new release, and in this update process we
will destroy the old container and then start a new genration. In order not
to interrupt the bpf programs in the update process, we will pin the bpf
programs and maps in bpffs. That is the background and use case on our
production environment. 

After switching to memcg-based bpf memory accounting to limit the bpf
memory, some unexpected issues jumped out at us.
1. The memory usage is not consistent between the first generation and
new generations.
2. After the first generation is destroyed, the bpf memory can't be
limited if the bpf maps are not preallocated, because they will be
reparented.

This patchset tries to resolve these issues by introducing an
independent memcg to limit the bpf memory.

In the bpf map creation, we can assign a specific memcg instead of using
the current memcg.  That makes it flexible in containized environment.
For example, if we want to limit the pinned bpf maps, we can use below
hierarchy,

    Shared resources              Private resources 
                                    
     bpf-memcg                      k8s-memcg
     /        \                     /             
bpf-bar-memcg bpf-foo-memcg   srv-foo-memcg        
                  |               /        \
               (charged)     (not charged) (charged)                 
                  |           /              \
                  |          /                \
          bpf-foo-{progs, maps}              srv-foo

srv-foo loads and pins bpf-foo-{progs, maps}, but they are charged to an
independent memcg (bpf-foo-memcg) instead of srv-foo's memcg
(srv-foo-memcg).

Pls. note that there may be no process in bpf-foo-memcg, that means it
can be rmdir-ed by root user currently. Meanwhile we don't forcefully
destroy a memcg if it doesn't have any residents. So this hierarchy is
acceptible. 

In order to make the memcg of bpf maps seletectable, this patchset
introduces some memory allocation wrappers to allocate map related
memory. In these wrappers, it will get the memcg from the map and then
charge the allocated pages or objs.  

Currenly it only supports for bpf map, and we can extend it to bpf prog
as well. It only supports for cgroup2 now, but we can make an additional
change in cgroup_get_from_fd() to support it for cgroup1. 

The observebility can also be supported in the next step, for example,
showing the bpf map's memcg by 'bpftool map show' or even showing which
maps are charged to a specific memcg by 'bpftool cgroup show'.
Furthermore, we may also show an accurate memory size of a bpf map
instead of an estimated memory size in 'bpftool map show' in the future. 

RFC->v1:
- get rid of bpf_map container wrapper (Alexei)
- add the new field into the end of struct (Alexei)
- get rid of BPF_F_SELECTABLE_MEMCG (Alexei)
- save memcg in bpf_map_init_from_attr
- introduce bpf_ringbuf_pages_{alloc,free} and keep them inside
  kernel/bpf/ringbuf.c  (Andrii)

Yafang Shao (15):
  bpf: Remove unneeded memset in queue_stack_map creation
  bpf: Use bpf_map_area_free instread of kvfree
  bpf: Make __GFP_NOWARN consistent in bpf map creation
  bpf: Use bpf_map_area_alloc consistently on bpf map creation
  bpf: Fix incorrect mem_cgroup_put
  bpf: Define bpf_map_{get,put}_memcg for !CONFIG_MEMCG_KMEM
  bpf: Call bpf_map_init_from_attr() immediately after map creation
  bpf: Save memcg in bpf_map_init_from_attr()
  bpf: Use scoped-based charge in bpf_map_area_alloc
  bpf: Introduce new helpers bpf_ringbuf_pages_{alloc,free}
  bpf: Use bpf_map_kzalloc in arraymap
  bpf: Use bpf_map_kvcalloc in bpf_local_storage
  mm, memcg: Add new helper get_obj_cgroup_from_cgroup
  bpf: Add return value for bpf_map_init_from_attr
  bpf: Introduce selectable memcg for bpf map

 include/linux/bpf.h            |  43 ++++++++++++-
 include/linux/memcontrol.h     |  11 ++++
 include/uapi/linux/bpf.h       |   1 +
 kernel/bpf/arraymap.c          |  34 ++++++-----
 kernel/bpf/bloom_filter.c      |  11 +++-
 kernel/bpf/bpf_local_storage.c |  17 ++++--
 kernel/bpf/bpf_struct_ops.c    |  19 +++---
 kernel/bpf/cpumap.c            |  17 ++++--
 kernel/bpf/devmap.c            |  30 ++++++----
 kernel/bpf/hashtab.c           |  26 ++++----
 kernel/bpf/local_storage.c     |  12 ++--
 kernel/bpf/lpm_trie.c          |  12 +++-
 kernel/bpf/offload.c           |  12 ++--
 kernel/bpf/queue_stack_maps.c  |  13 ++--
 kernel/bpf/reuseport_array.c   |  11 +++-
 kernel/bpf/ringbuf.c           | 104 ++++++++++++++++++++++----------
 kernel/bpf/stackmap.c          |  13 ++--
 kernel/bpf/syscall.c           | 133 ++++++++++++++++++++++++++++-------------
 mm/memcontrol.c                |  41 +++++++++++++
 net/core/sock_map.c            |  30 ++++++----
 net/xdp/xskmap.c               |  12 +++-
 tools/include/uapi/linux/bpf.h |   1 +
 tools/lib/bpf/bpf.c            |   3 +-
 tools/lib/bpf/bpf.h            |   3 +-
 tools/lib/bpf/gen_loader.c     |   2 +-
 tools/lib/bpf/libbpf.c         |   2 +
 tools/lib/bpf/skel_internal.h  |   2 +-
 27 files changed, 436 insertions(+), 179 deletions(-)

-- 
1.8.3.1

