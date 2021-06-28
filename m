Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88113B5D55
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 13:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbhF1LwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 07:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhF1LwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 07:52:07 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10020C061574;
        Mon, 28 Jun 2021 04:49:41 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id u14so8791529pga.11;
        Mon, 28 Jun 2021 04:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aSCulj/vN5Z4ufOLL++1l0GWa2ZFyqzFvZuAM9jsmUs=;
        b=egfnO4N9LJwp/I4/l2CHEK0SLwC/1DVlv6Z4KRCNM8gKXMgVY9lnijIT8Y3rGFGy1t
         RdEe/3GuDpSOGgvT4zjVphS4W+Lg0JS9UrQOw3OfDlu5EAglTU1FyQEkHDFhQVIf6Xmv
         ElVPffUNmHU1hftcbOMbxSa3czjHz4H4bcB/23emUOXHQt2BkB3pV170Pm9cslqheAm1
         9Ia40mAC4VGOu8B8oc4y3BSeCvlz+wIP6PSoCoI8Lv7HapdyH+E+AYeyJxyfn9004wln
         1nt6tQmLPdRcoJv0w72azDYEH+zTyANky7cw86Z922A1y6UcW878RtF0QeDsSAu7J55t
         SQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aSCulj/vN5Z4ufOLL++1l0GWa2ZFyqzFvZuAM9jsmUs=;
        b=eFgD93xhcbu/GzxvOhf+M4yTsdYVrSsnYDVXemSR2JS70eWwnuTlvoH4kP1IOXtjf+
         jju02Jr1K8XC/lvl66P/Xp9I4L7MltSlL/XfKnhMc6kSYHhtV144uit+aJDqpZm0iFYI
         sacPBhnpbK+QuLPFNGNZwLlVI4S4+ePr1PfFRfbB51c26RaFGX5vY15tT8PVUbnnb+1x
         D75FYeUJ94rAgHGKoqd75N27psJxlXXWKELOFRy2Yf0w+R70DROWGch+yf6aLhKwVozQ
         zc3MuRITl5cVkgdDlD//jVUcP62w54gMVL7BVo5xE1BQHJRqtObWSIBb/GIterlQ2+0k
         nG5g==
X-Gm-Message-State: AOAM533haHxGQH2RTSfXdFfBzhLio3SfoEfP4elIhnu8vQ4wIiqswt5p
        12MBSVJ6BVKc/Kecsx/gxeVlWQ9XucA=
X-Google-Smtp-Source: ABdhPJwObQIA62Y6tHTBUrE5bhcTlqYgmvZagdXqIjf9vdiom9bd0NFb1PCReGXMrdOt8Dtu2IwXuA==
X-Received: by 2002:a63:921e:: with SMTP id o30mr23167261pgd.346.1624880980349;
        Mon, 28 Jun 2021 04:49:40 -0700 (PDT)
Received: from localhost ([2402:3a80:11da:c590:f80e:952e:84ac:ba3d])
        by smtp.gmail.com with ESMTPSA id q8sm14192958pfc.51.2021.06.28.04.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 04:49:39 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v4 0/5] Generic XDP improvements
Date:   Mon, 28 Jun 2021 17:17:41 +0530
Message-Id: <20210628114746.129669-1-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series makes some improvements to generic XDP mode and brings it
closer to native XDP. Patch 1 splits out generic XDP processing into reusable
parts, patch 2 adds pointer friendly wrappers for bitops (not have to cast back
and forth the address of local pointer to unsigned long *), patch 3 implements
generic cpumap support (details in commit) and patch 4 allows devmap bpf prog
execution before generic_xdp_tx is called.

Patch 5 just updates a couple of selftests to adapt to changes in behavior (in
that specifying devmap/cpumap prog fd in generic mode is now allowed).

Changelog:
----------
v3 -> v4
v3: https://lore.kernel.org/bpf/20210622202835.1151230-1-memxor@gmail.com
 * Add detach now that attach of XDP program succeeds (Toke)
 * Clean up the test to use new ASSERT macros

v2 -> v3
v2: https://lore.kernel.org/bpf/20210622195527.1110497-1-memxor@gmail.com
 * list_for_each_entry -> list_for_each_entry_safe (due to deletion of skb)

v1 -> v2
v1: https://lore.kernel.org/bpf/20210620233200.855534-1-memxor@gmail.com
 * Move __ptr_{set,clear,test}_bit to bitops.h (Toke)
   Also changed argument order to match the bit op they wrap.
 * Remove map value size checking functions for cpumap/devmap (Toke)
 * Rework prog run for skb in cpu_map_kthread_run (Toke)
 * Set skb->dev to dst->dev after devmap prog has run
 * Don't set xdp rxq that will be overwritten in cpumap prog run

Kumar Kartikeya Dwivedi (5):
  net: core: split out code to run generic XDP prog
  bitops: add non-atomic bitops for pointers
  bpf: cpumap: implement generic cpumap
  bpf: devmap: implement devmap prog execution for generic XDP
  bpf: tidy xdp attach selftests

 include/linux/bitops.h                        |  19 +++
 include/linux/bpf.h                           |  10 +-
 include/linux/netdevice.h                     |   2 +
 include/linux/skbuff.h                        |  10 +-
 include/linux/typecheck.h                     |  10 ++
 kernel/bpf/cpumap.c                           | 115 +++++++++++++++---
 kernel/bpf/devmap.c                           |  49 ++++++--
 net/core/dev.c                                | 103 ++++++++--------
 net/core/filter.c                             |   6 +-
 .../bpf/prog_tests/xdp_cpumap_attach.c        |  43 +++----
 .../bpf/prog_tests/xdp_devmap_attach.c        |  39 +++---
 11 files changed, 269 insertions(+), 137 deletions(-)

-- 
2.31.1

