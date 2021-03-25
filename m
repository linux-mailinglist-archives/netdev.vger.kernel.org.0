Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC05348CC8
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 10:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbhCYJ16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 05:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbhCYJ1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 05:27:50 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75149C06174A;
        Thu, 25 Mar 2021 02:27:49 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y5so1451485pfn.1;
        Thu, 25 Mar 2021 02:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HMFgMxemOZZOfQbhGNvWbb0gWfY1QU42QTvVENbHyek=;
        b=OJmPREIYpsJmum/bY8S+JA1et2Lpq/H87iGMP5rWjlHSDw6CTd5l1x7Shd23Nrg+N1
         ryo5VgDM6AEkoMRraLoel9ATzUMfBkap6lhFMneIZr2dnguSfe6Hpvp1N9BXDFIz10s1
         akXSsT/vSzZHqN3oiSqfbeV/ph5ullJVmACc86aIIT47r/1HHvbuhJhdJXQJgEdbH/iK
         PxKF9N75Q5rrZKDmrcRcWdauhNa1L84UHdswvPwAKImxgr9jnOHvCUsJkbRcQp8ELagG
         VnpsMYPICxmWPMIN30tTW9n80vghdTVFy5+Y5dbJLWwxYxgc0KpWhgks+7kf0wrAsiV8
         y1nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HMFgMxemOZZOfQbhGNvWbb0gWfY1QU42QTvVENbHyek=;
        b=TJYxi27N/l5bkHPUEeQCfus2HTiPR2791jLkp9pLnVB1e5nwHvV8ZOcS9lSgcnFfnv
         rUEA0n04Y+Crbza8uTa4pED9EyiJD07UT4TsZtpWaUZpfm/z0Bi25tZCREBMX54tkuW1
         fczmGgLY1xCPWVp/RLoZfzoisqmV7Xdo2ymgAIiExMNni23fzHDvyZx8q13XihYHLAr8
         rOapZSsUe17c5Q/jA1IMUcUQk/VcjJvH8ufMaX5wBaW4SJrjwwKFB0hutXWb3FADIruN
         krs/9IUULnbzlmHG1oiROSwXa/5SQt9aFTaLrFicTqhDixT9iZLCXoirMarX/1WWsCKk
         ZMTg==
X-Gm-Message-State: AOAM532oEwefC8aSlJqt/4SVXrkeyzg/od2nqjCJlf67tp5kwx1WkD5L
        rn451E3J1KcNtnG2sUAdPovePaUbLkM=
X-Google-Smtp-Source: ABdhPJwSvO/xCl8ry5lhgVYFF6NIZpJNlIGkuhCA7hc7BW/eVxbZeoSGoPOD5qAeM+ZH7N4IQB8oAg==
X-Received: by 2002:a17:903:188:b029:e6:52f4:1b2d with SMTP id z8-20020a1709030188b02900e652f41b2dmr8937964plg.58.1616664468811;
        Thu, 25 Mar 2021 02:27:48 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e65sm5191037pfe.9.2021.03.25.02.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 02:27:48 -0700 (PDT)
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
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 bpf-next 0/4] xdp: extend xdp_redirect_map with broadcast support
Date:   Thu, 25 Mar 2021 17:27:29 +0800
Message-Id: <20210325092733.3058653-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset is a new implementation for XDP multicast support based
on my previous patches[1]. The reason is that Daniel think the exclude map
implementation is missing proper bond support in XDP context. And there
is a plan to add native XDP bonding support. Adding a exclude map in the
helper also increase the complex of verifier and has draw back of performace.

So I was suggested to just extend xdp_redirect_map with broadcast support,
which should be more easier and clear. Sorry to make you take a long time
on previous patches review and need to help review this one again.

[1] https://lore.kernel.org/bpf/20210223125809.1376577-1-liuhangbin@gmail.com

v3: Rebase the code based on latest bpf-next
v2: fix flag renaming issue in patch 02

Hangbin Liu (3):
  xdp: extend xdp_redirect_map with broadcast support
  sample/bpf: add xdp_redirect_map_multi for redirect_map broadcast test
  selftests/bpf: add xdp_redirect_multi test

Jesper Dangaard Brouer (1):
  bpf: run devmap xdp_prog on flush instead of bulk enqueue

 include/linux/bpf.h                           |  22 ++
 include/linux/filter.h                        |  14 +-
 include/net/xdp.h                             |   1 +
 include/uapi/linux/bpf.h                      |  17 +-
 kernel/bpf/devmap.c                           | 242 +++++++++++---
 net/core/filter.c                             |  92 +++++-
 net/core/xdp.c                                |  29 ++
 samples/bpf/Makefile                          |   3 +
 samples/bpf/xdp_redirect_map_multi_kern.c     |  87 +++++
 samples/bpf/xdp_redirect_map_multi_user.c     | 302 ++++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  17 +-
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../bpf/progs/xdp_redirect_multi_kern.c       |  96 ++++++
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 187 +++++++++++
 .../selftests/bpf/xdp_redirect_multi.c        | 236 ++++++++++++++
 15 files changed, 1293 insertions(+), 55 deletions(-)
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c

-- 
2.26.2

