Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7A45AA5C4
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 04:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbiIBCaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 22:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233598AbiIBCaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 22:30:13 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFD0255BB;
        Thu,  1 Sep 2022 19:30:11 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id r69so780797pgr.2;
        Thu, 01 Sep 2022 19:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=D3AdsrAzP/OCg/edNuQ9xj8+/J7mGnaQDmfeSstZF4o=;
        b=etmvLgpdksRnkUosjQdyioujA+kIpML12lmkCnfGCOavvO1XxHfO4TqJcxHP5b7B0j
         F6Hou4guyntbnb0VTPiO0OXyp3wWgBno+i1vUs3kKc8cOzVSOv+zYcDaEs4oKmHXusOz
         Kz6jIDt7pq15ZFqP1aEp9h76JKe7c+t64qfglAp/t9l2JZ8nYeayTjCfPeo23qdGQh5h
         8GsZIoLf2yVn6ZwKBmzMrnmH9eT5JvGfY4uf6vWy9nin6pXUsSFwHRjZqy43r0vXcIpr
         G09X2nMO6OY9ApWWYGQTLHPGglne0PCdMjUHak9SF5TTvTgMCYjwMJ2wHDqAPTBWae+d
         ZlwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=D3AdsrAzP/OCg/edNuQ9xj8+/J7mGnaQDmfeSstZF4o=;
        b=ZwVfA708rnx7ZJhIcKfxtBEig5r4UoQ+jnBFCJObR8PqrxgiHpbmr8mVQY43yR7ePR
         4GYosW9GQVhe1QqCoRLoXzPU0HhCV5HYKZO9P9oY078h/fg+9NcSuH3BYlH50gf328q0
         9DlTHEUwRhrwBj0W1kDcX2+nkYnvnG9xmYR9NHSVg1/mQXgYw8ZnVDPvgpRbGPdjZPDh
         2sUnDE75rHqA9lfGY8toGw3LDEuG50WdJsmTRQvueMx+kCYi2rGyn3GHuB5YQdVJ+8K/
         DPyJd/9iLJw0V67nHG6yFv0JbzJ4DsfJuv9e4igPanpKEGtH1VTKzbbzzTaINJwpwaWm
         r0dw==
X-Gm-Message-State: ACgBeo2S0dmlSZLPcyfNHiG1c8OMt5rAKMOfoDWlmHups1RwGH9VfCWP
        Nur3pKnl7DvwAi1SRfAMa44=
X-Google-Smtp-Source: AA6agR5LBNj3Vby8h2IWgEeZoZ1h88MDc9Z9Qb16Il+pXzlE4DEluuQDO2cTAVQ70i6qAIb5Z+guYw==
X-Received: by 2002:aa7:9242:0:b0:536:f215:4f4f with SMTP id 2-20020aa79242000000b00536f2154f4fmr34192084pfp.45.1662085810846;
        Thu, 01 Sep 2022 19:30:10 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:50ea:5400:4ff:fe1f:fbe2])
        by smtp.gmail.com with ESMTPSA id j4-20020a170902da8400b0017297a6b39dsm269719plx.265.2022.09.01.19.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 19:30:09 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for bpf map 
Date:   Fri,  2 Sep 2022 02:29:50 +0000
Message-Id: <20220902023003.47124-1-laoar.shao@gmail.com>
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

Besides, there's another issue that the bpf-map's memcg is breaking the
memcg hierarchy, because bpf-map has its own memcg. A bpf map can be
wrote by tasks running in other memcgs, once a writer in other memcg
writes a shared bpf map, the memory allocated in this writing won't be
charged to the writer's memcg but it will be charge to bpf-map's own
memcg instead. IOW, the bpf-map is improperly treated as a task, while
actually it is a shared resource. This patchset doesn't resolve this
issue. I will post another RFC once I find a workable solution to
address it.

This patchset tries to resolve the above two issues by introducing a
selectable memcg to limit the bpf memory. Currently we only allow to
select its ancestor to avoid breaking the memcg hierarchy further. 
Possible use cases of the selectable memcg as follows,
- Select the root memcg as bpf-map's memcg
  Then bpf-map's memory won't be throttled by current memcg limit.
- Put current memcg under a fixed memcg dir and select the fixed memcg
  as bpf-map's memcg
  The hierarchy as follows,

      Parent-memcg (A fixed dir, i.e. /sys/fs/cgroup/memory/bpf)
         \
        Current-memcg (Container dir, i.e. /sys/fs/cgroup/memory/bpf/foo)

  At the map creation time, the bpf-map's memory will be charged
  into the parent directly without charging into current memcg, and thus
  current memcg's usage will be consistent among different generations.
  To limit bpf-map's memory usage, we can set the limit in the parent
  memcg.

Currenly it only supports for bpf map, and we can extend it to bpf prog
as well.

The observebility can also be supported in the next step, for example,
showing the bpf map's memcg by 'bpftool map show' or even showing which
maps are charged to a specific memcg by 'bpftool cgroup show'.
Furthermore, we may also show an accurate memory size of a bpf map
instead of an estimated memory size in 'bpftool map show' in the future. 

v2->v3:
- use css_tryget() instead of css_tryget_online() (Shakeel)
- add comment for get_obj_cgroup_from_cgroup() (Shakeel)
- add new memcg helper task_under_memcg_hierarchy()
- add restriction to allow selecting ancestor only to avoid breaking the
  memcg hierarchy further, per discussion with Tejun 

v1->v2:
- cgroup1 is also supported after
  commit f3a2aebdd6fb ("cgroup: enable cgroup_get_from_file() on cgroup1")
  So update the commit log.
- remove incorrect fix to mem_cgroup_put  (Shakeel,Roman,Muchun) 
- use cgroup_put() in bpf_map_save_memcg() (Shakeel)
- add detailed commit log for get_obj_cgroup_from_cgroup (Shakeel) 

RFC->v1:
- get rid of bpf_map container wrapper (Alexei)
- add the new field into the end of struct (Alexei)
- get rid of BPF_F_SELECTABLE_MEMCG (Alexei)
- save memcg in bpf_map_init_from_attr
- introduce bpf_ringbuf_pages_{alloc,free} and keep them inside
  kernel/bpf/ringbuf.c  (Andrii)

Yafang Shao (13):
  cgroup: Update the comment on cgroup_get_from_fd
  bpf: Introduce new helper bpf_map_put_memcg()
  bpf: Define bpf_map_{get,put}_memcg for !CONFIG_MEMCG_KMEM
  bpf: Call bpf_map_init_from_attr() immediately after map creation
  bpf: Save memcg in bpf_map_init_from_attr()
  bpf: Use scoped-based charge in bpf_map_area_alloc
  bpf: Introduce new helpers bpf_ringbuf_pages_{alloc,free}
  bpf: Use bpf_map_kzalloc in arraymap
  bpf: Use bpf_map_kvcalloc in bpf_local_storage
  mm, memcg: Add new helper get_obj_cgroup_from_cgroup
  mm, memcg: Add new helper task_under_memcg_hierarchy
  bpf: Add return value for bpf_map_init_from_attr
  bpf: Introduce selectable memcg for bpf map

 include/linux/bpf.h            |  40 +++++++++++-
 include/linux/memcontrol.h     |  25 ++++++++
 include/uapi/linux/bpf.h       |   1 +
 kernel/bpf/arraymap.c          |  34 +++++-----
 kernel/bpf/bloom_filter.c      |  11 +++-
 kernel/bpf/bpf_local_storage.c |  17 +++--
 kernel/bpf/bpf_struct_ops.c    |  19 +++---
 kernel/bpf/cpumap.c            |  17 +++--
 kernel/bpf/devmap.c            |  30 +++++----
 kernel/bpf/hashtab.c           |  26 +++++---
 kernel/bpf/local_storage.c     |  11 +++-
 kernel/bpf/lpm_trie.c          |  12 +++-
 kernel/bpf/offload.c           |  12 ++--
 kernel/bpf/queue_stack_maps.c  |  11 +++-
 kernel/bpf/reuseport_array.c   |  11 +++-
 kernel/bpf/ringbuf.c           | 104 ++++++++++++++++++++----------
 kernel/bpf/stackmap.c          |  13 ++--
 kernel/bpf/syscall.c           | 140 ++++++++++++++++++++++++++++-------------
 kernel/cgroup/cgroup.c         |   2 +-
 mm/memcontrol.c                |  48 ++++++++++++++
 net/core/sock_map.c            |  30 +++++----
 net/xdp/xskmap.c               |  12 +++-
 tools/include/uapi/linux/bpf.h |   1 +
 tools/lib/bpf/bpf.c            |   3 +-
 tools/lib/bpf/bpf.h            |   3 +-
 tools/lib/bpf/gen_loader.c     |   2 +-
 tools/lib/bpf/libbpf.c         |   2 +
 tools/lib/bpf/skel_internal.h  |   2 +-
 28 files changed, 462 insertions(+), 177 deletions(-)

-- 
1.8.3.1

