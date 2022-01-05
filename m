Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA6F484CA0
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 04:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236052AbiAEDDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 22:03:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233243AbiAEDDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 22:03:52 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C76C061784;
        Tue,  4 Jan 2022 19:03:52 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 8so33918874pfo.4;
        Tue, 04 Jan 2022 19:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tB3BOrXRYEduh6b6cfsOzhTDYHRhS4PARArLudGPIAU=;
        b=RzWtAvGliW2u2+/tZwjYUWs+AdCdoKH3D2qlmrZXtpMHKT8+wDY+Yau0B6961d+Z7I
         xg7pgpSH90+qS36h70xDHkrWP+yoLa0ldsRrVmKuNPAc7gco/0tl7iQRD7sddjFxSMrQ
         hYl9AtXNT1+kv3nze3GIj13MBu0mpKwQrsS0g4cY9icmK9KU7fr/7mCiphQkbMeWdJqe
         cozYKnFv5yLpQBxKTjN975VIdNHkUSmXFHG+2TTPVv0hwWIBb2ZIMqbUOA74tNfP6QI7
         Hz+Z2hJRJ9vvCth39iN8qamLh3U5j1A7yGzZJy5gKa4tJD0+640+hK3wYcK+VF/hGgTT
         kr2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tB3BOrXRYEduh6b6cfsOzhTDYHRhS4PARArLudGPIAU=;
        b=ZHPD/PXmjY6GdMDAIOYAs25AxPhGot8573wF8thzOU+B2pjTbU3Bafloz0XYb1w9Hk
         93FxTOBlDWeIzlFe+rGwpseMxEP5/WGaf+NVDunD2UNd4PAZZZKOJe/NiMMbn145fNDI
         zmBKv/qt0vh/jpOaRN1ZRXF8em+qaJvrU5DrinFXTfFLDSlE7gmh1dDjLle3gJBRexAM
         JyKDGtwYVz6fGbOyr4hDe/5v3ByIHdGpN6BZLpgUXxkQO88itvMJqdE6Acrw3fMAypJZ
         aCX9nfLx8o5ATi713V1utzr78DPJrH6U5O/UQac7Pa+ceVj4dh9ukFCgqENaoCXv9eWK
         iUCg==
X-Gm-Message-State: AOAM531tjJOytId1qjhV2Rfc71ZotyWc4+hsEX94ySx4hgJbJULetJxM
        HNpPEouEM+UeyZNya/YcSA==
X-Google-Smtp-Source: ABdhPJxa9RifkMnktZwyX0yFwXxX7WTYZdpqJqja4tPDPS+5n4LR+Qs5/0VSqrIHt7vOP5AMdfuH8A==
X-Received: by 2002:a63:7c1b:: with SMTP id x27mr47000804pgc.176.1641351831623;
        Tue, 04 Jan 2022 19:03:51 -0800 (PST)
Received: from jevburton2.c.googlers.com.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i9sm34280818pgc.27.2022.01.04.19.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 19:03:51 -0800 (PST)
From:   Joe Burton <jevburton.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, ppenkov@google.com,
        sdf@google.com, haoluo@google.com
Cc:     Joe Burton <jevburton@google.com>
Subject: [PATCH bpf-next v4 0/3] Introduce BPF map tracing capability
Date:   Wed,  5 Jan 2022 03:03:42 +0000
Message-Id: <20220105030345.3255846-1-jevburton.kernel@gmail.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Burton <jevburton@google.com>

This is the fourth version of a patch series implementing map tracing.

Map tracing enables executing BPF programs upon BPF map updates. This
might be useful to perform upgrades of stateful programs; e.g., tracing
programs can propagate changes to maps that occur during an upgrade
operation.

This version uses trampoline hooks to provide the capability.
fentry/fexit/fmod_ret programs can attach to two new functions:
        int bpf_map_trace_update_elem(struct bpf_map* map, void* key,
                void* val, u32 flags);
        int bpf_map_trace_delete_elem(struct bpf_map* map, void* key);

These hooks work as intended for the following map types:
        BPF_MAP_TYPE_ARRAY
        BPF_MAP_TYPE_PERCPU_ARRAY
        BPF_MAP_TYPE_HASH
        BPF_MAP_TYPE_PERCPU_HASH
        BPF_MAP_TYPE_LRU_HASH
        BPF_MAP_TYPE_LRU_PERCPU_HASH

The only guarantee about the semantics of these hooks is that they execute
after the operation takes place. We cannot call them with locks held
because the hooked program might try to acquire the same locks.

Changes from v3 -> v4:
* Hooks execute *after* the associated operation, not before.
* Replaced `#pragma once' with traditional `#ifdef' guards.
* Explicitly constrained selftests to x86, since trampolines are only
  implemented there.
* Use /dev/null instead of /tmp/map_trace_test_file in selftests.

Changes from v2 -> v3:
* Reimplemented using trampoline hooks, simplifying greatly.

Changes from v1 -> v2:
* None. Resent series to a broader audience.

Joe Burton (3):
  bpf: Add map tracing functions and call sites
  bpf: Add selftests
  bpf: Add real world example for map tracing

 kernel/bpf/Makefile                           |   2 +-
 kernel/bpf/arraymap.c                         |   4 +-
 kernel/bpf/hashtab.c                          |  20 +-
 kernel/bpf/map_trace.c                        |  17 +
 kernel/bpf/map_trace.h                        |  19 +
 .../selftests/bpf/prog_tests/map_trace.c      | 427 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_map_trace.c       |  95 ++++
 .../bpf/progs/bpf_map_trace_common.h          |  12 +
 .../progs/bpf_map_trace_real_world_common.h   | 125 +++++
 .../bpf_map_trace_real_world_migration.c      | 102 +++++
 .../bpf/progs/bpf_map_trace_real_world_new.c  |   4 +
 .../bpf/progs/bpf_map_trace_real_world_old.c  |   5 +
 12 files changed, 829 insertions(+), 3 deletions(-)
 create mode 100644 kernel/bpf/map_trace.c
 create mode 100644 kernel/bpf/map_trace.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/map_trace.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_common.h
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_common.h
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_migration.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_new.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_old.c

-- 
2.34.1.448.ga2b2bfdf31-goog

