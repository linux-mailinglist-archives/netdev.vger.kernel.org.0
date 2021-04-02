Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B19352A99
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 14:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbhDBMUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 08:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhDBMUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 08:20:16 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F58DC0613E6;
        Fri,  2 Apr 2021 05:20:14 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id x26so3546703pfn.0;
        Fri, 02 Apr 2021 05:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XCTWa3Gp1spo4Hz5JXhkqT+JI4GrPzq4h70sBfrL6H8=;
        b=GuygRtwSx2saTBrTt8B3fbQCI89PzdmSd+okRREg22DB8Kg8Tbnai5uRGbAB9p4L82
         EU1SNGUONd92RS7ti1yBBH8afx/uE2a6cKSo0Rc9bWWgBYQVKzhur0B+7/9qWVHJdjL7
         Ql81ooeP55E/xzxwHXMiRsF3fU4WmMQGKZ3YIUmCIcDorEF6uxiCtnd32wLSsonzIlf4
         ew7N4252I5QEvpgolvelPQmIMkZDEYSXTUvUiyxuaeLIJo63GYm3a3Er026voUtQKfOI
         U9Loljnv1d6reBFLMbAX4cUKMFTKEeSKBRXFQ05ZFFlVd49RAllTlSWDnOUOmDm4QxYW
         Po9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XCTWa3Gp1spo4Hz5JXhkqT+JI4GrPzq4h70sBfrL6H8=;
        b=hg39qWNpdTko5Bnp9blARDvVQAJ3rTl1nkR7VKp025PtHAPPuv/f4Y3QlzfbF8uOAj
         TzffpslQ2pH0GYU92YLtR/o0+ji8UJ1uPdsItB+YBIWGbAvbH2OmolsIfX88xdE8/gpL
         kmd8sDPEzKbN54BKVGzcbTDDroVj7+xkHIehekByclEyZtrM3yXNWrFHMktlAfTwZ9dr
         IT+hwQZpGL5VUFkK06t+mD+YYJ2kEIfq13GfR4SV9AUzADmOG8d0QTvYv5RnEHX9YoPS
         c0GVvqEpyR4ioGgJA3hsjjWx5Wupj5kxuObMX+n+CQ4Jv3e+xXTeW1C2ENzdDez4/kY5
         YzQA==
X-Gm-Message-State: AOAM5313MoJfFgQI/jrQ3XX9jJn2nIHEW10/t/UAIoWNbU+5BNuKlnAD
        Isn3KmUpXM8XKU0e9vRSVfSXOep/adw+Yg==
X-Google-Smtp-Source: ABdhPJyY2Xx0ID2sS4YCd6T6EYWd+0HOZJJnlhjDvBSOODLPQlsYEcn3voZsqBI5vldQVcdOPCdqvw==
X-Received: by 2002:aa7:9a95:0:b029:1f3:4169:ccf2 with SMTP id w21-20020aa79a950000b02901f34169ccf2mr11740356pfi.14.1617366013762;
        Fri, 02 Apr 2021 05:20:13 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g15sm8760913pfk.36.2021.04.02.05.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 05:20:13 -0700 (PDT)
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
Subject: [PATCHv4 bpf-next 0/4] xdp: extend xdp_redirect_map with broadcast support
Date:   Fri,  2 Apr 2021 20:19:50 +0800
Message-Id: <20210402121954.3568992-1-liuhangbin@gmail.com>
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
the exclude map implementation is missing proper bond support in XDP context.
And there is a plan to add native XDP bonding support. Adding a exclude map
in the helper also increase the complex of verifier and has draw back of
performace.

So I was suggested to just extend xdp_redirect_map with broadcast support,
which should be more easier and clear. Sorry to make you take a long time
on previous patches review and need to help review this one again. The last
version is here[2].

[1] https://lore.kernel.org/bpf/20210223125809.1376577-1-liuhangbin@gmail.com
[2] https://lore.kernel.org/bpf/20210325092733.3058653-1-liuhangbin@gmail.com

v4: Fix flags never cleared issue in patch 02. Update selftest to cover this.
v3: Rebase the code based on latest bpf-next
v2: fix flag renaming issue in patch 02

Hangbin Liu (3):
  xdp: extend xdp_redirect_map with broadcast support
  sample/bpf: add xdp_redirect_map_multi for redirect_map broadcast test
  selftests/bpf: add xdp_redirect_multi test

Jesper Dangaard Brouer (1):
  bpf: run devmap xdp_prog on flush instead of bulk enqueue

 include/linux/bpf.h                           |  22 ++
 include/linux/filter.h                        |  18 +-
 include/net/xdp.h                             |   1 +
 include/uapi/linux/bpf.h                      |  17 +-
 kernel/bpf/cpumap.c                           |   3 +-
 kernel/bpf/devmap.c                           | 248 +++++++++++---
 net/core/filter.c                             |  97 +++++-
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
 17 files changed, 1330 insertions(+), 60 deletions(-)
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c

-- 
2.26.3

