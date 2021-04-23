Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05C6368ADE
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240195AbhDWCBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 22:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbhDWCBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 22:01:25 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7D5C061574;
        Thu, 22 Apr 2021 19:00:49 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id u14-20020a17090a1f0eb029014e38011b09so408566pja.5;
        Thu, 22 Apr 2021 19:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mtGrsoLRm6yuKMc9pFMMMRzrTKFrebBHy6EvapVbSQ0=;
        b=LwiqbKC66g2VP8M/+KGTAFLmrUjq0ba0ZAILayQXQoLSRoTSaFsB6dfjPivDouLWzO
         Do5BmEtNV1VzlXTvrXkwd8kTJ+4KDMFGVRiigZLUHBd7aFpxTLZ5N4kHbTHbiZYg7huc
         /w24ziwSp8A0QGriYcdVpEUKQnyh0S5AtEW7dQhlXaSzCt1yoJmLM134ntOge9TH7Z4M
         IJPIxDbAQ+XNY3Oqxo0aHjsLpLk0rUkAxND1hqIOOP7anFkpvBeUdJbpCGvuZHvelyfm
         mGp7FHz5gZbJM9vfHkquP++/ky6ADdzJyLD+p2ng+PwBqX6pxeBWaw6V53QO8FaEaLof
         u/2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mtGrsoLRm6yuKMc9pFMMMRzrTKFrebBHy6EvapVbSQ0=;
        b=WfgVdjx3E5PiNyZqQQ6of/YqAthUGVIUbZXjAlGmx+Oj7IQYcgINx0Uqu2icAEUnOt
         WTcgw4dTjO24idfby6YfVvSxi7mWrUJHU0F1jk0I3xJa5rnla5sBtZ8T/SeFdr+2BhF0
         KSdllynW7bQNHDGrLexm4gcK0jDSizIf7OuPpuyn4WYbTKIx86hYd2Zz2LFuzu7K+OfB
         uhms2gtSdHWkK2TDe00g+vKVoJS5Vm6Eld+C/L0lf2RnlSuI2nF0dc74VKuKzRT/GK05
         g0FR72eHlL8+xAUDZ4fEj5kzFzgOEqVeQ3q7CYmp+b0kP05LK7Xtv1eN7bhV1rr8HL5c
         Gacw==
X-Gm-Message-State: AOAM531qAC0+YZCPiyRVBu0ZJZbtXdRav60g6HFec+yQQm855DIyqG6T
        JPbxDNG8heTnwgLRazMIwmWhQ6avFXH1+Q==
X-Google-Smtp-Source: ABdhPJzKj/oDpBn6/iXOqBRR/WggCf6HtawoiH7eo8OyetvT8k3shKx2w+29v1SY/X6sdXatvsbwCg==
X-Received: by 2002:a17:90b:238d:: with SMTP id mr13mr1810864pjb.23.1619143249178;
        Thu, 22 Apr 2021 19:00:49 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z5sm3079244pff.191.2021.04.22.19.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 19:00:48 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv10 bpf-next 0/4] xdp: extend xdp_redirect_map with broadcast support
Date:   Fri, 23 Apr 2021 10:00:15 +0800
Message-Id: <20210423020019.2333192-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset is a new implementation for XDP multicast support based
on my previous 2 maps implementation[1]. The reason is that Daniel thinks
the exclude map implementation is missing proper bond support in XDP
context. And there is a plan to add native XDP bonding support. Adding a
exclude map in the helper also increases the complexity of verifier and has
drawback of performance.

The new implementation just add two new flags BPF_F_BROADCAST and
BPF_F_EXCLUDE_INGRESS to extend xdp_redirect_map for broadcast support.

With BPF_F_BROADCAST the packet will be broadcasted to all the interfaces
in the map. with BPF_F_EXCLUDE_INGRESS the ingress interface will be
excluded when do broadcasting.

The patchv9 link is here[2].

[1] https://lore.kernel.org/bpf/20210223125809.1376577-1-liuhangbin@gmail.com
[2] https://lore.kernel.org/bpf/20210422071454.2023282-1-liuhangbin@gmail.com

v10: use READ/WRITE_ONCE when read/write map instead of xchg()
v9: Update patch 01 commit description
v8: use hlist_for_each_entry_rcu() when looping the devmap hash ojbs
v7: No need to free xdpf in dev_map_enqueue_clone() if xdpf_clone failed.
v6: Fix a skb leak in the error path for generic XDP
v5: Just walk the map directly to get interfaces as get_next_key() of devmap
    hash may restart looping from the first key if the device get removed.
    After update the performace has improved 10% compired with v4.
v4: Fix flags never cleared issue in patch 02. Update selftest to cover this.
v3: Rebase the code based on latest bpf-next
v2: fix flag renaming issue in patch 02

Hangbin Liu (3):
  xdp: extend xdp_redirect_map with broadcast support
  sample/bpf: add xdp_redirect_map_multi for redirect_map broadcast test
  selftests/bpf: add xdp_redirect_multi test

Jesper Dangaard Brouer (1):
  bpf: run devmap xdp_prog on flush instead of bulk enqueue

 include/linux/bpf.h                           |  20 ++
 include/linux/filter.h                        |  18 +-
 include/net/xdp.h                             |   1 +
 include/uapi/linux/bpf.h                      |  17 +-
 kernel/bpf/cpumap.c                           |   3 +-
 kernel/bpf/devmap.c                           | 304 +++++++++++++++---
 net/core/filter.c                             |  37 ++-
 net/core/xdp.c                                |  29 ++
 net/xdp/xskmap.c                              |   3 +-
 samples/bpf/Makefile                          |   3 +
 samples/bpf/xdp_redirect_map_multi_kern.c     |  87 +++++
 samples/bpf/xdp_redirect_map_multi_user.c     | 302 +++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  17 +-
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../bpf/progs/xdp_redirect_multi_kern.c       |  99 ++++++
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 205 ++++++++++++
 .../selftests/bpf/xdp_redirect_multi.c        | 236 ++++++++++++++
 17 files changed, 1320 insertions(+), 64 deletions(-)
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c

-- 
2.26.3

