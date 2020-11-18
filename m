Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991F32B76BC
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 08:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgKRHQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 02:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgKRHQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 02:16:52 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46C9C0613D4;
        Tue, 17 Nov 2020 23:16:52 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id 18so484735pli.13;
        Tue, 17 Nov 2020 23:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U3seY/lcs8TEEmISiXOkYLuxnoviwJk63EPoYZmFSHk=;
        b=RiXtx3DPHlRFlDgTOXZ8m4RbvrX4ymel4W9RkaXoFDy5tBZ9haArB5r/JN37Htyn4G
         t46IT85L51o98zqItmbV0u5B9c18/6TzF/HNHa3XD3ROGLGf9QikkIgkZtDK/PBSILnJ
         Onb7rpNF9qFt9NW/eOTdYmUZj7KgRksG98Zhf3yuG4PL1puWCFHrHld7OR1giSS6luEJ
         4uW6r7Hfb3+9SxTinlkxryMx7NlLviZPg2V2vt58Hvbhqwn7F/3A6rywtTqdXOVLqiS9
         17KJX6vwbxa18SiXyOjIM4/dM3adwo3EdtT1cUWeQSgtaeIAJeSh8CjHC3VK+KOW33rc
         3jKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U3seY/lcs8TEEmISiXOkYLuxnoviwJk63EPoYZmFSHk=;
        b=CjwYRsOiTt9iKkbers9wLpMCcgp2V0trV0c08N9I63XlX63+yuW5KfyvRGPNSc3y+a
         EYR8LMTLTC57TJzO+eWK25IdM9I4dvODO/ErI0nJygayRED5xbLBwKP4DyqHHt2ihgEr
         eXgQYp9te6/F1L6WRPsThzKLU6EjZmT7dV+ssSyq5gjlFHq6e8EtabZDUwIK0WyKWqBH
         z7bGMMF/7eq8ABpnwjcsRC5Uke7E/ALhd9//0peqfKccgebN0yQKiQg71JoMnactKn5w
         gtgUngl491VMZ1xinlPEOaTI8iY5FHMqIS0a1q8D/64MJ4tfZ5HAZy+i56MIDZGmWqk5
         FVyg==
X-Gm-Message-State: AOAM533sk1uAWkjEtvrnctGrV1dpY7tuC5ItfiQej+VG6uVc/+4LWVBh
        9TLb1DpqHJoO5yOESNLLiYE=
X-Google-Smtp-Source: ABdhPJzkewEWXj9x0t+Tj1EprABPBAe23jRnGAw5xRlVzku4s8j820vquFyHFWQh/VAannLu+8JKSw==
X-Received: by 2002:a17:90a:b303:: with SMTP id d3mr2813534pjr.207.1605683812051;
        Tue, 17 Nov 2020 23:16:52 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id e128sm23019382pfe.154.2020.11.17.23.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 23:16:50 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        xi.wang@gmail.com, luke.r.nels@gmail.com,
        linux-riscv@lists.infradead.org, andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next v2 0/3] RISC-V selftest/bpf fixes
Date:   Wed, 18 Nov 2020 08:16:37 +0100
Message-Id: <20201118071640.83773-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contain some fixes for selftests/bpf when building/running
on a RISC-V host. Details can be found in each individual commit.


Cheers,
Björn

v2:
  Makefile cosmetics. (Andrii)
  Simplified unpriv check and added comment. (Andrii)

Björn Töpel (3):
  selftests/bpf: Fix broken riscv build
  selftests/bpf: Avoid running unprivileged tests with alignment
    requirements
  selftests/bpf: Mark tests that require unaligned memory access

 tools/testing/selftests/bpf/Makefile          |  3 +-
 tools/testing/selftests/bpf/test_verifier.c   | 13 ++++++
 .../selftests/bpf/verifier/ctx_sk_lookup.c    |  7 +++
 .../bpf/verifier/direct_value_access.c        |  3 ++
 .../testing/selftests/bpf/verifier/map_ptr.c  |  1 +
 .../selftests/bpf/verifier/raw_tp_writable.c  |  1 +
 .../selftests/bpf/verifier/ref_tracking.c     |  4 ++
 .../testing/selftests/bpf/verifier/regalloc.c |  8 ++++
 .../selftests/bpf/verifier/wide_access.c      | 46 +++++++++++--------
 9 files changed, 67 insertions(+), 19 deletions(-)


base-commit: ea87ae85c9b31303a2e9d4c769d9f3ee8a3a60d1
-- 
2.27.0

