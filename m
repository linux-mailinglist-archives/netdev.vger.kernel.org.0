Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CED535DB73
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhDMJmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbhDMJmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 05:42:09 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD192C061574;
        Tue, 13 Apr 2021 02:41:49 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 10so2196029pfl.1;
        Tue, 13 Apr 2021 02:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4fcp0MOnKHkpfVzm+x/2nhnEFr4e99nL/A87nL/uEuU=;
        b=dOIhLEi6WBX24SmPaN3t6pcGXC1C5YEv4D2F75s3Lcj+8J8WkakvkGhQailuKttlQU
         vXCamojg0+0yYQP4vFWQyd8VAbULaQBTqnu6UljZuIVuMk6Mkc4DScklVnTpYcQPzqin
         9eG9HwXFP12lzqZ6QAKZc5vRKZdue0G/qx8XjCsYkWtrQHCOJdbF1qiPN9ZCZu//Ckpc
         36ZMvrg8G+NdWGrG6wnN+fBtvlHd7lidy4BiwGk9m7yVNJPLheB70yjhUyQD1Q66pjH+
         h6Vl8p9JFb7aAhYV4CDcZz5iqmfG2niAgoZGKv2TCxtuuGd+durQiopRvYxmRwfQ4s/O
         e96A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4fcp0MOnKHkpfVzm+x/2nhnEFr4e99nL/A87nL/uEuU=;
        b=JPhkFJWS7CouYin7WxQcM+D0XJERw78/p/uaUK+NhBAZs59m2rLqkyU8cWTNO/hWGB
         unRNGqkGYh5G2H6EN3P9TBkTxziEAgLhvKJclk2ElQeYHk6UbAJqYSpsq9fu3yrwolPW
         aQyMptWS7Az2E8HyZEz0mePhIDlap4BOTBxPhizv1dyDSxmeRz59uUXvYr0e+lcTRCL1
         3szBY1bYhud550z9Q7ziN7+nqhDbLb7XljW07AbXcNP6AUH7f5aXUa1d88Wjjf9W3ZAf
         28WHMrcMnJ1HYZrq3rPLMuuVNevcCXV5aESC9Z1v8n2zch/qQgWVB3Gf1wYVCM4Ry1Nz
         7i8g==
X-Gm-Message-State: AOAM531mOdBuufoKf7XFHhOt03HpTRafVeo777lFkfI0QGKQ5mSkkmxO
        X1Gk5+0bMugnaK/eGhHSySiCGpRUIL3oFg==
X-Google-Smtp-Source: ABdhPJxImwwJpcJSl3Sj7YVe3w3Vba6Dk66MsTJByp6R+n/tXvxF7l52vjVgB4URIJaJAsbt+1Ydtw==
X-Received: by 2002:a63:5857:: with SMTP id i23mr31435160pgm.152.1618306909063;
        Tue, 13 Apr 2021 02:41:49 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y193sm12442732pfc.72.2021.04.13.02.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 02:41:48 -0700 (PDT)
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
Subject: [PATCHv5 bpf-next 0/4] xdp: extend xdp_redirect_map with broadcast support
Date:   Tue, 13 Apr 2021 17:41:29 +0800
Message-Id: <20210413094133.3966678-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset is a new implementation for XDP multicast support based
on my previous 2 maps implementation[1]. The reason is that Daniel think
the exclude map implementation is missing proper bond support in XDP
context. And there is a plan to add native XDP bonding support. Adding a
exclude map in the helper also increase the complex of verifier and has
draw back of performace.

The new implementation just add two new flags BPF_F_BROADCAST and
BPF_F_EXCLUDE_INGRESS to extend xdp_redirect_map for broadcast support.

With BPF_F_BROADCAST the packet will be broadcasted to all the interfaces
in the map. with BPF_F_EXCLUDE_INGRESS the ingress interface will be excluded
when do broadcasting.

The patchv4 link is here[2].

[1] https://lore.kernel.org/bpf/20210223125809.1376577-1-liuhangbin@gmail.com
[2] https://lore.kernel.org/bpf/20210402121954.3568992-1-liuhangbin@gmail.com

v5: Just walk the map directly to get interfaces as get_next_key() of devmap
    hash may restart looping from the first key if the device get removed
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
 kernel/bpf/devmap.c                           | 295 ++++++++++++++---
 net/core/filter.c                             |  33 +-
 net/core/xdp.c                                |  29 ++
 net/xdp/xskmap.c                              |   3 +-
 samples/bpf/Makefile                          |   3 +
 samples/bpf/xdp_redirect_map_multi_kern.c     |  87 +++++
 samples/bpf/xdp_redirect_map_multi_user.c     | 302 ++++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  17 +-
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../bpf/progs/xdp_redirect_multi_kern.c       |  99 ++++++
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 205 ++++++++++++
 .../selftests/bpf/xdp_redirect_multi.c        | 236 ++++++++++++++
 17 files changed, 1307 insertions(+), 64 deletions(-)
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c

-- 
2.26.3

