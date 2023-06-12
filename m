Return-Path: <netdev+bounces-10193-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA32372CC54
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 19:23:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13DB51C20B54
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:23:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF9091E536;
	Mon, 12 Jun 2023 17:23:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E122F1C768
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 17:23:10 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92AA5DB
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:23:09 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b3b3c69969so18457925ad.0
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686590589; x=1689182589;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Qsu3cuq2IPrUKP784jm3315aYb2wdAs7nUpO6qqSXIY=;
        b=pJTZJIR5hwlrb4l5zjtVD9l2AsadG6lnBL9B0PBqA22CVjILWqG0PmGJhfahZIu4E3
         p9n/SwWjFjxoBoCAfj+GXZ9gKZoG0j4iZt0tFCnl7nNdjwsBZQfpcWmnpYinAcD54zkZ
         jSjUE+2Z2Y5TIpR6WYo9cZnkEa1Tulvm9ObTEg+H4Cww2ESI9r0NnLxGhrIR6xJGFiTc
         9F+XSWXO0REK+O6HACJ0jlnzD4K3Umpw4jKpdGRBWeS1h1csHKdRB3NnNOtRoEPPbiN6
         2xQ+gsX+9lrh9YFVbJhKt+aC2aIYl4kTW+IVmUVslSeJd/Sb4XU4Y7ku4FZp04WRlDBm
         cKQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686590589; x=1689182589;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qsu3cuq2IPrUKP784jm3315aYb2wdAs7nUpO6qqSXIY=;
        b=h3yFa9f2Jx+72ucRG3f8E5GIYkufMytPOP/BRhCRp7eaCP4p0Mf7c0SanrukPpf1Wv
         R9qdTwFpZgAddFIvxu9MmSxbHrmtmLmEkEjXFrJ7+Hoj5lejwxgHG4sAq5KHO/uWmy7E
         uiPnuGotttBrHIKjP7VR3lharkxKir3r5V3YQM0ZchTiEadlBXPsy8mpD4OG9MSt0KV7
         JM43i6zpfT0LjxJWafIWleKQUI7ebTNCPQ69wdxa29Ai2F89afBnR743ZjIqQIByrZtY
         N5jKy9ZxRTNAUiMfpA6Rrzz0xGWHSVgZEmTUwipg7Xb6XgVx9L8DoI7Gq1Wz6nDKjkWf
         31Nw==
X-Gm-Message-State: AC+VfDx/ot4LrgIzrahzMxP7ZQ5rPEQoEPg38d+LpEWDG7g4/zODdbI9
	PGQHuhJVrndQPQy0p8VHMA5+RE4=
X-Google-Smtp-Source: ACHHUZ5tauUa8X45Oy6Hq91hlMyhPKNqvCsUmXwv7OmgnvjifZjlTF+xvldBlq/sIhbW+OJ4kr6VGq0=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:f811:b0:1b3:b84b:900e with SMTP id
 ix17-20020a170902f81100b001b3b84b900emr1108755plb.2.1686590589065; Mon, 12
 Jun 2023 10:23:09 -0700 (PDT)
Date: Mon, 12 Jun 2023 10:23:00 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230612172307.3923165-1-sdf@google.com>
Subject: [RFC bpf-next 0/7] bpf: netdev TX metadata
From: Stanislav Fomichev <sdf@google.com>
To: bpf@vger.kernel.org
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	martin.lau@linux.dev, song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, 
	kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, 
	willemb@google.com, dsahern@kernel.org, magnus.karlsson@intel.com, 
	bjorn@kernel.org, maciej.fijalkowski@intel.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--- Use cases ---

The goal of this series is to add two new standard-ish places
in the transmit path:

1. Right before the packet is transmitted (with access to TX
   descriptors)
2. Right after the packet is actually transmitted and we've received the
   completion (again, with access to TX completion descriptors)

Accessing TX descriptors unlocks the following use-cases:

- Setting device hints at TX: XDP/AF_XDP might use these new hooks to
use device offloads. The existing case implements TX timestamp.
- Observability: global per-netdev hooks can be used for tracing
the packets and exploring completion descriptors for all sorts of
device errors.

Accessing TX descriptors also means that the hooks have to be called
from the drivers.

The hooks are a light-weight alternative to XDP at egress and currently
don't provide any packet modification abilities. However, eventually,
can expose new kfuncs to operate on the packet (or, rather, the actual
descriptors; for performance sake).

--- UAPI ---

The hooks are implemented in a HID-BPF style. Meaning they don't
expose any UAPI and are implemented as tracing programs that call
a bunch of kfuncs. The attach/detach operation happen via BPF syscall
programs. The series expands device-bound infrastructure to tracing
programs.

--- skb vs xdp ---

The hooks operate on a new light-weight devtx_frame which contains:
- data
- len
- sinfo

This should allow us to have a unified (from BPF POW) place at TX
and not be super-taxing (we need to copy 2 pointers + len to the stack
for each invocation).

--- Multiprog attachment ---

Currently, attach/detach don't expose links and don't support multiple
programs. I'm planning to use Daniel's bpf_mprog once it lands.

--- TODO ---

Things that I'm planning to do for the non-RFC series:
- have some real device support to verify xdp_hw_metadata works
- freplace
- Documentation/networking/xdp-rx-metadata.rst - like documentation

--- CC ---

CC'ing people only on the cover letter. Hopefully can find the rest via
lore.

Cc: willemb@google.com
Cc: dsahern@kernel.org
Cc: john.fastabend@gmail.com
Cc: magnus.karlsson@intel.com
Cc: bjorn@kernel.org
Cc: maciej.fijalkowski@intel.com
Cc: netdev@vger.kernel.org

Stanislav Fomichev (7):
  bpf: rename some xdp-metadata functions into dev-bound
  bpf: resolve single typedef when walking structs
  bpf: implement devtx hook points
  bpf: implement devtx timestamp kfunc
  net: veth: implement devtx timestamp kfuncs
  selftests/bpf: extend xdp_metadata with devtx kfuncs
  selftests/bpf: extend xdp_hw_metadata with devtx kfuncs

 MAINTAINERS                                   |   2 +
 drivers/net/veth.c                            |  94 ++++++-
 include/linux/netdevice.h                     |   6 +
 include/net/devtx.h                           |  76 +++++
 include/net/offload.h                         |  38 +++
 include/net/xdp.h                             |  18 +-
 kernel/bpf/btf.c                              |   2 +
 kernel/bpf/offload.c                          |  40 ++-
 kernel/bpf/verifier.c                         |   4 +-
 net/core/Makefile                             |   1 +
 net/core/dev.c                                |   2 +
 net/core/devtx.c                              | 266 ++++++++++++++++++
 net/core/xdp.c                                |  20 +-
 .../selftests/bpf/prog_tests/xdp_metadata.c   |  82 +++++-
 .../selftests/bpf/progs/xdp_hw_metadata.c     |  59 ++++
 .../selftests/bpf/progs/xdp_metadata.c        | 101 +++++++
 tools/testing/selftests/bpf/xdp_hw_metadata.c | 160 ++++++++++-
 tools/testing/selftests/bpf/xdp_metadata.h    |  13 +
 18 files changed, 934 insertions(+), 50 deletions(-)
 create mode 100644 include/net/devtx.h
 create mode 100644 include/net/offload.h
 create mode 100644 net/core/devtx.c

-- 
2.41.0.162.gfafddb0af9-goog


