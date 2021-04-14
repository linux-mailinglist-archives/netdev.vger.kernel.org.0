Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF3035EA63
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 03:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345070AbhDNBak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 21:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241079AbhDNBaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 21:30:39 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF9CC061574;
        Tue, 13 Apr 2021 18:30:19 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id y32so13234135pga.11;
        Tue, 13 Apr 2021 18:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5J2UYvQLrJOPeb0ZUIXCE2EyLjUQYjQTf2stXwCCBNY=;
        b=MKBgnfoBZieO+xuA/+kawPDFWvRuYxFw4/Ln4eWbHXK2vvzak+DC5TbU8alKiqcHdQ
         opmnirvwqudw+p14qShTAb5uovJn+a7tuW6ySaXMCX6ly5avY89EF28eHsaEpbE8BYLi
         ju+Vws8cz4V4n3INiJZG0dRBHtpIJBEibJpIzvmmN4AfL2Z7vjX76Z122lCpwzvI9tzZ
         5gp/xWRyszjhMUq7jwA5n7nCw99Rtivl9vhgzQLWlRMaeUcEyJleBtvsHkaDfP4qqdMl
         OwXNTBb998dsC1DOveN7FksjBIyb9lqLqYG9xFudJ5Re8wySfgobz0t3XkUoedFKfkT0
         bDGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5J2UYvQLrJOPeb0ZUIXCE2EyLjUQYjQTf2stXwCCBNY=;
        b=EqZu81R31qrUB6LiM5+5GfVzbtk/mlb+c12Ga4pXpLSThOUrrnSFKe1WVqltCc1BNC
         7u67q1J6fR4fsieVj/O5O9VcD1IpCB0ab5i8fqY6Ax5IAmD0oQv64YXxedpWo+kW32f9
         zlgG4XSa6n7mdZ3HmkQIgZr8iv5g8SSosNuzdq8mfJ9XeklU/AXEct6aM0zEEnZqKtFB
         iO6K9uCutXDYR22l6G4Ws8vLF/Qp2QxNZqOtzz/nFAbdaF5NiQviujhfJt7jzJXrC/2W
         eXv77DMIiGT5hkmOytZXMwO8wwPqsJp6Fb9MRQjeSz+168LocIeHwiWBoa9neiiWDpTi
         dz/w==
X-Gm-Message-State: AOAM530xzvnJNbGoewf+vI3novXnTE1+xpDZWPhuHntfJ3Cfhrhq206S
        xf0fcNHEMMeyU2ZpRi2SYxIKgH1Cxvg=
X-Google-Smtp-Source: ABdhPJzt6NyUSgtvvrzz52hgjiajxASDAm6JKvLDQ2NLhQTpAHdtsyJJajxj1VFCCgVX6O+xAFy7pA==
X-Received: by 2002:a63:fa57:: with SMTP id g23mr34171883pgk.243.1618363818777;
        Tue, 13 Apr 2021 18:30:18 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w191sm14858767pfd.25.2021.04.13.18.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 18:30:18 -0700 (PDT)
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
Subject: [PATCHv6 bpf-next 0/4] xdp: extend xdp_redirect_map with broadcast support
Date:   Wed, 14 Apr 2021 09:23:37 +0800
Message-Id: <20210414012341.3992365-1-liuhangbin@gmail.com>
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
in the map. with BPF_F_EXCLUDE_INGRESS the ingress interface will be
excluded when do broadcasting.

The patchv5 link is here[2].

[1] https://lore.kernel.org/bpf/20210223125809.1376577-1-liuhangbin@gmail.com
[2] https://lore.kernel.org/bpf/20210413094133.3966678-1-liuhangbin@gmail.com

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
 kernel/bpf/devmap.c                           | 306 +++++++++++++++---
 net/core/filter.c                             |  33 +-
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
 17 files changed, 1318 insertions(+), 64 deletions(-)
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c

-- 
2.26.3

