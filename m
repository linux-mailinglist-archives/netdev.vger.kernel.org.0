Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE9058525A
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbiG2PXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236263AbiG2PXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:23:22 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473DE22BC2;
        Fri, 29 Jul 2022 08:23:21 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id b9so4891862pfp.10;
        Fri, 29 Jul 2022 08:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bq/Y/ngKZ+WX2+8wytQYbP21OmkIVmhSvPy4lSP3hZY=;
        b=olY0hAfoJpgfXtFDjC9LKVjlh7X0ScP5IIrPw+NncqM7V89hhO9EE8ZHkHvRe10QF/
         8aInHlu3F/f6E99DQyOg0tDiiHHs6OVl7j5HOK/QWowTxLdhkPaE2eNVhFpCI+JRpmd/
         yzbx1D+8I/A5wBQh6M/RvTGpOH+6E5Kk/Nu4J84yKWhA4fX/04NGdmzOqrwFdoQyUMnL
         GZUoFWCN1cszlIhxMfnaziwSPvpCDeMqKPBAUpFV+eK+LiENRFfZ6cL2xjGoTZQmnzB6
         nHI7zLQ1WA94QvE3g9nkniKHdmvL6nIZ51QFaxQ0KvVGMPeATH98L9Fj17cQnom+MPFw
         DPww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bq/Y/ngKZ+WX2+8wytQYbP21OmkIVmhSvPy4lSP3hZY=;
        b=7HjYOWVqkrX/qIuP1Ccufsw0tx0lPccVUZH7dwUeZtNC9vIoS/46bvKHOsruRI9cEL
         AYcGxaFUzM3+NJ0loBsrfx3BhkW63ulEaizQ3iaLh1W2ntqBYIwC1O1nLMGnBlTpjNx+
         V/usqThxFgp7SEivVu/qm1L+gxVryAZpfpYJf2+kZQbwPO+7NuXJR55jWVPoiCZ7dKJV
         +SMh2jt0MS0pnwmP5n61sg2gePLJr06EPKUwQEWNE2stUOA/a5F+E5Dk1esIE0W81C7r
         wdx/xOpIyNxgNXfpQh7a5V1OXksS8BO4uKvMASnaAwL3XbNPILC/GtS4ulwslU6Ke/RP
         ZhKw==
X-Gm-Message-State: ACgBeo2cuJFsPj8e9sI8DSaCuJYCLQRm33GxH+5lnaFf5eBcvlHgx7ct
        BdbC/8O4xp5lWFUr6CxnRCQ=
X-Google-Smtp-Source: AA6agR4/Io2UalncnScFwRru9D8cID85apn3SkZcPYYPPO0xxfepqrQ+WR8upxYqQxmTbRRcvzbImQ==
X-Received: by 2002:a63:3143:0:b0:41b:b5dc:e6b6 with SMTP id x64-20020a633143000000b0041bb5dce6b6mr145342pgx.422.1659108200726;
        Fri, 29 Jul 2022 08:23:20 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:2912:5400:4ff:fe16:4344])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b0016d3a354cffsm3714219plm.89.2022.07.29.08.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 08:23:19 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 00/15] bpf: Introduce selectable memcg for bpf map 
Date:   Fri, 29 Jul 2022 15:23:01 +0000
Message-Id: <20220729152316.58205-1-laoar.shao@gmail.com>
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

    Shared resources             Private resources 
                                    
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

Yafang Shao (15):
  bpf: Remove unneeded memset in queue_stack_map creation
  bpf: Use bpf_map_area_free instread of kvfree
  bpf: Make __GFP_NOWARN consistent in bpf map creation
  bpf: Use bpf_map_area_alloc consistently on bpf map creation
  bpf: Introduce helpers for container of struct bpf_map
  bpf: Use bpf_map_container_alloc helpers in various bpf maps
  bpf: Define bpf_map_get_memcg for !CONFIG_MEMCG_KMEM
  bpf: Use scope-based charge for bpf_map_area_alloc
  bpf: Use bpf_map_kzalloc in arraymap
  bpf: Use bpf_map_pages_alloc in ringbuf
  bpf: Use bpf_map_kvcalloc in bpf_local_storage
  mm, memcg: Add new helper get_obj_cgroup_from_cgroup
  bpf: Add new parameter into bpf_map_container_alloc
  bpf: Add new map flag BPF_F_SELECTABLE_MEMCG
  bpf: Introduce selectable memcg for bpf map

 include/linux/bpf.h            |  19 +++-
 include/linux/memcontrol.h     |  11 ++
 include/uapi/linux/bpf.h       |   5 +
 kernel/bpf/arraymap.c          |  46 ++++----
 kernel/bpf/bloom_filter.c      |  13 ++-
 kernel/bpf/bpf_local_storage.c |  17 +--
 kernel/bpf/bpf_struct_ops.c    |  17 +--
 kernel/bpf/cpumap.c            |  12 +-
 kernel/bpf/devmap.c            |  26 +++--
 kernel/bpf/hashtab.c           |  17 +--
 kernel/bpf/local_storage.c     |  11 +-
 kernel/bpf/lpm_trie.c          |   8 +-
 kernel/bpf/offload.c           |   6 +-
 kernel/bpf/queue_stack_maps.c  |  12 +-
 kernel/bpf/reuseport_array.c   |   9 +-
 kernel/bpf/ringbuf.c           |  57 +++++-----
 kernel/bpf/stackmap.c          |  15 +--
 kernel/bpf/syscall.c           | 197 ++++++++++++++++++++++++++++-----
 mm/memcontrol.c                |  41 +++++++
 net/core/sock_map.c            |  31 +++---
 net/xdp/xskmap.c               |   8 +-
 tools/include/uapi/linux/bpf.h |   5 +
 tools/lib/bpf/bpf.c            |   1 +
 tools/lib/bpf/bpf.h            |   3 +-
 tools/lib/bpf/libbpf.c         |   2 +
 25 files changed, 411 insertions(+), 178 deletions(-)

-- 
2.17.1

