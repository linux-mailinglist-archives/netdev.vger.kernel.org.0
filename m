Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A81339B2AA
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 08:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhFDGfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 02:35:09 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45030 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhFDGfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 02:35:08 -0400
Received: by mail-pf1-f196.google.com with SMTP id u18so6714759pfk.11;
        Thu, 03 Jun 2021 23:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j7klZjcVBcs6h9HZr2YYg5JL8UCcJh1ymVzboKFNgMY=;
        b=ub1Ve3CQiSs1uUlbxYzDX5xp3v3WY7ygxztBNK/yIZr8JT6kgkkW+SwIfMLnBrRiI9
         xELIHzmVWgWV1whadZ5PUhiqUVf70ZgQcZSxt69vLn/YdvWDeOXk6LzRi0nS6gawomdM
         JRESVREE2+VILd0dN6Lm5MWNZjHhm9ogSXinx9g5eIT61yRRf6x16srFmXKdBb/gcg23
         SMBhkSXMosp/Biuu4+6g3dHeLpJ3oNxat6N0heINk/q/5lqfPscVHzO9urjZXGc8OS3S
         99ree/L6F1TdtKm/w7IcTpYiFlc8pyUvvJatzIbynVsSyM3XlHG/0mR1YB5sbCralJ1b
         vxUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j7klZjcVBcs6h9HZr2YYg5JL8UCcJh1ymVzboKFNgMY=;
        b=nruTS6cf1BaC/gZQDvZQ9xNNVCPkWVhtL6gMVeyh9Ab5V0h7fo9pWNn79uT6I6x3DT
         Pauy1nEFOFlWEZngwaLtjeqjIdkViv3jyNZJGP+VOXb8oMFyXUL25MV8RIZ8JGrLxNjn
         Trb7Piewsw4cSMZFTR6TOf9KeN3yUqilmfvuA0JKlFRL6NK34WNRA4e23m4ndBnR9kNh
         YDNB12QU9QEEUafntDjm90fDdSDK41+nMp910XgrzkFOj6NAceL5bJIobpT28FpiU26m
         aJGhoSgUenmS/KsU85m/nQNCK7QjDIDlt+1G+66c76lD8VUSDVz/oo1ouyCg/FYLumEG
         jIkA==
X-Gm-Message-State: AOAM532lujxVekfoU26BrJsYSB/JLkbQ58b+T6l9/Xvh5kiuZULZnLOE
        wkSfMfmVgqSdhcoPxcKcTL5cIr7ysO0=
X-Google-Smtp-Source: ABdhPJyDIVpwDzckUlBAmaiaX9oxLwRC6UNctHsr8zaM1cLKWINXboOBEexdZPgEoUpN0SxJm7s0+g==
X-Received: by 2002:a63:7204:: with SMTP id n4mr3485828pgc.78.1622788342402;
        Thu, 03 Jun 2021 23:32:22 -0700 (PDT)
Received: from localhost ([2402:3a80:11cb:b599:c759:2079:3ef5:1764])
        by smtp.gmail.com with ESMTPSA id i8sm3783026pjs.54.2021.06.03.23.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 23:32:21 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 0/7] Add bpf_link based TC-BPF API
Date:   Fri,  4 Jun 2021 12:01:09 +0530
Message-Id: <20210604063116.234316-1-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the second (non-RFC) version.

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

Changelog:
----------
v1 (RFC) -> v2
v1: https://lore.kernel.org/bpf/20210528195946.2375109-1-memxor@gmail.com

 * Avoid overwriting other members of union in bpf_attr (Andrii)
 * Set link to NULL after bpf_link_cleanup to avoid double free (Andrii)
 * Use __be16 to store the result of htons (Kernel Test Robot)
 * Make assignment of tcf_exts::net conditional on CONFIG_NET_CLS_ACT
   (Kernel Test Robot)

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
 net/sched/cls_api.c                           | 139 ++++++-
 net/sched/cls_bpf.c                           | 389 ++++++++++++++++--
 tools/include/uapi/linux/bpf.h                |  15 +
 tools/lib/bpf/bpf.c                           |   8 +-
 tools/lib/bpf/bpf.h                           |   8 +-
 tools/lib/bpf/libbpf.c                        |  59 ++-
 tools/lib/bpf/libbpf.h                        |  17 +
 tools/lib/bpf/libbpf.map                      |   1 +
 tools/lib/bpf/netlink.c                       |   5 +-
 tools/lib/bpf/netlink.h                       |   8 +
 .../selftests/bpf/prog_tests/tc_bpf_link.c    | 285 +++++++++++++
 16 files changed, 940 insertions(+), 45 deletions(-)
 create mode 100644 tools/lib/bpf/netlink.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf_link.c

-- 
2.31.1

