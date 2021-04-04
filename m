Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B682D35399B
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 22:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhDDUEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 16:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhDDUEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 16:04:12 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD2EC061756;
        Sun,  4 Apr 2021 13:04:07 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id j17so4671091qvo.13;
        Sun, 04 Apr 2021 13:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9CGn1Zx6vig6iDgOvfLviFqMqMh8pEFz8A4kgE+xhP4=;
        b=QV4zj/7OUWVYZf1MiDXhBjnJW/+DvTgdVoNxCP4Lk7hOMYciw9dD9mKYmSShIxuIag
         CHNx78trjgtb+hlsZFAmQzt3cZoduZU+ZeJLCo0TjH4snbFOGEJqtauE0GHAkLhkoKZV
         nTC1L1T28km1LG/qqpcSIaCZwQOnI5kmuRQzQ89zgJkUw7lhcMBg5+jBNrJ/+hL3OXpF
         BnRgqt0fGdZ+uqB1kk9OTMYhIDw00NuEI6lA9js7/tlI/H2tJJpiDALaDnNGSVQgfxXM
         GhXOU4vxDHMT/KcoiQng1WUPKyUl0t/BFo2/OMmdPOkQ51UqobXogZwnd59IeLniUjjA
         XVAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9CGn1Zx6vig6iDgOvfLviFqMqMh8pEFz8A4kgE+xhP4=;
        b=ATwnhDrtRE6rCCQWbTDzZOqM0YqAnxTw6gJtM/qwNecMxn32LoDTWgI9JoPw0qAzmP
         KGJKFHZ7W6wbbaqkExmMAJ3sw+X6AKr8jUoHRY+dmiESdtjeQzBFEMDKle3iuXvWwdqb
         myqO6gHEZzczEw6R3gWxMmRg7udvNZrQ7iTD1Iq8UwD6Snti/Bn9w4+2M+zqjQ54UHsK
         xEIyINLu7AC8mUqW04L2/Egu3IOEOsGd067dvbIjoJ7ZLwJ/CmHz+uJSZKkLB00DkGw5
         DcSrRfjIXyh9MnKOUJ3QAXDwKgmpjo1TaPYqY+Q9uCErlOKGP0mkgE0SY94gsCBY1/Gf
         xT8w==
X-Gm-Message-State: AOAM533YZqZAIVZc6YQDseKeUjkgfu64eNUoZWxbijhVD2zWo2U8BfAk
        /5qQ8K6BdK6VN05bbfw350Y=
X-Google-Smtp-Source: ABdhPJy6nEXFXpghYGgWZfWjrc1BDdUoZWz4GZRMeGY2HY3ANenPOKOZiIVtnGObSlJeBhH11CYYsA==
X-Received: by 2002:a0c:aa55:: with SMTP id e21mr1704803qvb.28.1617566640798;
        Sun, 04 Apr 2021 13:04:00 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id d24sm12163480qkl.49.2021.04.04.13.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 13:04:00 -0700 (PDT)
From:   Pedro Tammela <pctammela@gmail.com>
X-Google-Original-From: Pedro Tammela <pctammela@mojatatu.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>,
        David Verbeiren <david.verbeiren@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        bpf@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        linux-kernel@vger.kernel.org (open list),
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH bpf-next 0/3] add batched ops support for percpu array
Date:   Sun,  4 Apr 2021 17:02:45 -0300
Message-Id: <20210404200256.300532-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces batched operations for the per-cpu variant of
the array map.

It also introduces a standard way to define per-cpu values via the
'BPF_PERCPU_TYPE()' macro, which handles the alignment transparently.
This was already implemented in the selftests and was merely refactored
out to libbpf, with some simplifications for reuse.

The tests were updated to reflect all the new changes.

Pedro Tammela (3):
  bpf: add batched ops support for percpu array
  libbpf: selftests: refactor 'BPF_PERCPU_TYPE()' and 'bpf_percpu()'
    macros
  bpf: selftests: update array map tests for per-cpu batched ops

 kernel/bpf/arraymap.c                         |   2 +
 tools/lib/bpf/bpf.h                           |  10 ++
 tools/testing/selftests/bpf/bpf_util.h        |   7 --
 .../bpf/map_tests/array_map_batch_ops.c       | 114 +++++++++++++-----
 .../bpf/map_tests/htab_map_batch_ops.c        |  48 ++++----
 .../selftests/bpf/prog_tests/map_init.c       |   5 +-
 tools/testing/selftests/bpf/test_maps.c       |  16 +--
 7 files changed, 133 insertions(+), 69 deletions(-)

-- 
2.25.1

