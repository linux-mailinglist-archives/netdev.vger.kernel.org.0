Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4179F39479D
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 22:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhE1UCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 16:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhE1UCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 16:02:15 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87C2C061574;
        Fri, 28 May 2021 13:00:39 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id y202so4051285pfc.6;
        Fri, 28 May 2021 13:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SdzXsQ7+7ZyegFWJcQBEMAwg4Q2c8icvsvtvhKxXf8k=;
        b=dhBxc0DPNL30VGL5XO9IMeeiMps9c2ikvgRWZq5Si33uSA25cGRdFwCe0UKR4pNT+F
         Q2YyIHT9+Dfvb0qWFglj2369qL/gyC1xYTeI7EJLdCqJ0VvFxwPGV9x+yS4Dbr1E3Pfj
         toNxC1T7ZLuKw5WZ+TWU0X547JhOQk9+LaLfT7k/12hV2XZA5GsAUQnR4flhosP7ZzKe
         uRotuao+dUh647pRrRGzioHOfGWYdaOHcD6jPrDLc27tlsOS5lyDsgt6Og9FyGe8BHlb
         Phasw9LKD+jQ5yATzLuaCXQJSthy36QRhTJVKERnYVND8raJfqQtOckQt+IWI+T5PbYK
         66Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SdzXsQ7+7ZyegFWJcQBEMAwg4Q2c8icvsvtvhKxXf8k=;
        b=j3tGWBzrT+8Bd0M9pIf+SblmM0rcUuojKwyunbrgRL8CryoSC/eXPivRQzhQtVFLXI
         jI5dA6uexQ953/M0h6Rx6ctkmTVLD3ST5ehz3cZjBIlSr/FqL2HGW79nGPcL5IU4QDPF
         gL8s9jk1WkIxnJIyQl7LnQuEYxvI6Qwxy+Gqqh+77BQJyU+E8fD6pmtoO2eGIXOdS6uW
         yPjVx+LMWDjQb7HxRalC4yznb2dFeDcNmzjPmYagKlN1tfygEScFAV2sK688Zhprm5Fa
         s93+wZTWXcsez6l5VD5DhP3nwHOwcaQajp/gsRfB8NS/dN9TsT1dznHywYCG5Id/X+LR
         iG5g==
X-Gm-Message-State: AOAM532RbMzQuh2HxLzjSDAdONRhcoKdxvPV8D4B52z5H5TGleUQW1pF
        nG/c+sEk2nhi1d0Ek/Ko6cZbfRkfktc=
X-Google-Smtp-Source: ABdhPJx7H+mVAdclSbbpRuLpmlKNDZtjzLTGLOs1ZtYDBNvXT8qajPBXGyUQP4tDFYCxR8lqP64NXw==
X-Received: by 2002:a63:338c:: with SMTP id z134mr10681953pgz.167.1622232038894;
        Fri, 28 May 2021 13:00:38 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id x23sm5012258pje.52.2021.05.28.13.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 13:00:38 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
Date:   Sat, 29 May 2021 01:29:39 +0530
Message-Id: <20210528195946.2375109-1-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the first RFC version.

This adds a bpf_link path to create TC filters tied to cls_bpf classifier, and
introduces fd based ownership for such TC filters. Netlink cannot delete or
replace such filters, but the bpf_link is severed on indirect destruction of the
filter (backing qdisc being deleted, or chain being flushed, etc.). To ensure
that filters remain attached beyond process lifetime, the usual bpf_link fd
pinning approach can be used.

The individual patches contain more details and comments, but the overall kernel
API and libbpf helper mirrors the semantics of the netlink based TC-BPF API
merged recently. This means that we start by always setting direct action mode,
protocol to ETH_P_ALL, chain_index as 0, etc. If there is a need for more
options in the future, they can be easily exposed through the bpf_link API in
the future.

Patch 1 refactors cls_bpf change function to extract two helpers that will be
reused in bpf_link creation.

Patch 2 exports some bpf_link management functions to modules. This is needed
because our bpf_link object is tied to the cls_bpf_prog object. Tying it to
tcf_proto would be weird, because the update path has to replace offloaded bpf
prog, which happens using internal cls_bpf helpers, and would in general be more
code to abstract over an operation that is unlikely to be implemented for other
filter types.

Patch 3 adds the main bpf_link API. A function in cls_api takes care of
obtaining block reference, creating the filter object, and then calls the
bpf_link_change tcf_proto op (only supported by cls_bpf) that returns a fd after
setting up the internal structures. An optimization is made to not keep around
resources for extended actions, which is explained in a code comment as it wasn't
immediately obvious.

Patch 4 adds an update path for bpf_link. Since bpf_link_update only supports
replacing the bpf_prog, we can skip tc filter's change path by reusing the
filter object but swapping its bpf_prog. This takes care of replacing the
offloaded prog as well (if that fails, update is aborted). So far however,
tcf_classify could do normal load (possibly torn) as the cls_bpf_prog->filter
would never be modified concurrently. This is no longer true, and to not
penalize the classify hot path, we also cannot impose serialization around
its load. Hence the load is changed to READ_ONCE, so that the pointer value is
always consistent. Due to invocation in a RCU critical section, the lifetime of
the prog is guaranteed for the duration of the call.

Patch 5, 6 take care of updating the userspace bits and add a bpf_link returning
function to libbpf.

Patch 7 adds a selftest that exercises all possible problematic interactions
that I could think of.

Design:

This is where in the object hierarchy our bpf_link object is attached.

                                                                            ┌─────┐
                                                                            │     │
                                                                            │ BPF │
                                                                            program
                                                                            │     │
                                                                            └──▲──┘
                                                      ┌───────┐                │
                                                      │       │         ┌──────┴───────┐
                                                      │  mod  ├─────────► cls_bpf_prog │
┌────────────────┐                                    │cls_bpf│         └────┬───▲─────┘
│    tcf_block   │                                    │       │              │   │
└────────┬───────┘                                    └───▲───┘              │   │
         │          ┌─────────────┐                       │                ┌─▼───┴──┐
         └──────────►  tcf_chain  │                       │                │bpf_link│
                    └───────┬─────┘                       │                └────────┘
                            │          ┌─────────────┐    │
                            └──────────►  tcf_proto  ├────┘
                                       └─────────────┘

The bpf_link is detached on destruction of the cls_bpf_prog.  Doing it this way
allows us to implement update in a lightweight manner without having to recreate
a new filter, where we can just replace the BPF prog attached to cls_bpf_prog.

The other way to do it would be to link the bpf_link to tcf_proto, there are
numerous downsides to this:

1. All filters have to embed the pointer even though they won't be using it when
cls_bpf is compiled in.
2. This probably won't make sense to be extended to other filter types anyway.
3. We aren't able to optimize the update case without adding another bpf_link
specific update operation to tcf_proto ops.

The downside with tying this to the module is having to export bpf_link
management functions and introducing a tcf_proto op. Hopefully the cost of
another operation func pointer is not big enough (as there is only one ops
struct per module).

This first version is to collect feedback on the approach and get ideas if there
is a better way to do this.

Kumar Kartikeya Dwivedi (7):
  net: sched: refactor cls_bpf creation code
  bpf: export bpf_link functions for modules
  net: sched: add bpf_link API for bpf classifier
  net: sched: add lightweight update path for cls_bpf
  tools: bpf.h: sync with kernel sources
  libbpf: add bpf_link based TC-BPF management API
  libbpf: add selftest for bpf_link based TC-BPF management API

 include/linux/bpf_types.h                     |   3 +
 include/net/pkt_cls.h                         |  13 +
 include/net/sch_generic.h                     |   6 +-
 include/uapi/linux/bpf.h                      |  15 +
 kernel/bpf/syscall.c                          |  14 +-
 net/sched/cls_api.c                           | 138 ++++++-
 net/sched/cls_bpf.c                           | 386 ++++++++++++++++--
 tools/include/uapi/linux/bpf.h                |  15 +
 tools/lib/bpf/bpf.c                           |   5 +
 tools/lib/bpf/bpf.h                           |   8 +-
 tools/lib/bpf/libbpf.c                        |  59 ++-
 tools/lib/bpf/libbpf.h                        |  17 +
 tools/lib/bpf/libbpf.map                      |   1 +
 tools/lib/bpf/netlink.c                       |   5 +-
 tools/lib/bpf/netlink.h                       |   8 +
 .../selftests/bpf/prog_tests/tc_bpf_link.c    | 285 +++++++++++++
 16 files changed, 934 insertions(+), 44 deletions(-)
 create mode 100644 tools/lib/bpf/netlink.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf_link.c

-- 
2.31.1

