Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A7C58EF21
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbiHJPSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiHJPSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:18:45 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AB57822A;
        Wed, 10 Aug 2022 08:18:44 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id bh13so14629057pgb.4;
        Wed, 10 Aug 2022 08:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=k27+VFhA3Xa3WrsnpWdG3xMdVqwolNbtk1/PnG0LJps=;
        b=mlzgUYKDTQCvzf7zbnJ75efNAjgdxvzTw7EtTwGfnunCOetJZnrNMRMkDjyQj06s3u
         nItKZH/PmPeCM8PR2K5TnrUo0ekjaQZ3MPiWkzfww7PmmJ16QXZLCjHT2B4UbIfoC/2T
         bMx00D7OPcQMVyAjtoUXGoo8rYe3+nmdslnNnOhxXoHXt19jR8VfKGChEi92WfqYSPS0
         vboIVxdB3UH1moj/Ck2pJo+/oD0FR+g7/2ghjXi0lUKMG9UiP/2Nd6fOY1EQ073ashAv
         NA96RJeZww6PbmEcprACk0hBkt7RmnsaLjBJNqj/UH8WDmylTAzbajdw/PUTUKC6gUrZ
         0I0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=k27+VFhA3Xa3WrsnpWdG3xMdVqwolNbtk1/PnG0LJps=;
        b=aiobmtsaFYiVGo1I8hf4fsqpYrcLdx8u4kURT4c9l9Liij6Y0+gDBuEapufyG5ma7o
         BN5quIYW+8r9G6IHp5WfmFZICIgc1F5CS/sIlkdkc27LYUXnykljYiQaNIoeFNulxENp
         CoA7nLuRUKS+Qv8hF2XEwrLm1paP3+MZ/GrjdypdhVE6EooBVzzLt3ocr++ObAsvZsNW
         szhwS4+toabJxMuk82/Bz19NRDksW+6hgvm1G4snsjaHLFhq2TnvAVXM0ydS/pRvPDhL
         g97Ra25eFj8/cYuKP0rDZCMHRNyaWpPxdx3P+0qAltL1VSSAIAbyfAwkpTNmG+tQNp0Q
         w4eg==
X-Gm-Message-State: ACgBeo3bLVVg3UAu05l10awNoW4Kj4b8GdzloMdDkpHW64356Aqneyvs
        g0IVKJEdPPxIwPxeL1pxDZ0=
X-Google-Smtp-Source: AA6agR7Co4Nx557udUCrg+JajlYsAOCrKxkva6J6NUzj3ITXm8QLKhQ6LoqkgEveE5nbPcz50ss0vg==
X-Received: by 2002:aa7:94b3:0:b0:530:2957:2a43 with SMTP id a19-20020aa794b3000000b0053029572a43mr647652pfl.44.1660144723775;
        Wed, 10 Aug 2022 08:18:43 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5c3e:5400:4ff:fe19:c3bc])
        by smtp.gmail.com with ESMTPSA id 85-20020a621558000000b0052b6ed5ca40sm2071935pfv.192.2022.08.10.08.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:18:42 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 00/15] bpf: Introduce selectable memcg for bpf map 
Date:   Wed, 10 Aug 2022 15:18:25 +0000
Message-Id: <20220810151840.16394-1-laoar.shao@gmail.com>
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

