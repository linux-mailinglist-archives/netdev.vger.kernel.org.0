Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4701D57BB
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgEORZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726244AbgEORZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:25:27 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9793C061A0C;
        Fri, 15 May 2020 10:25:26 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id k7so1173921pjs.5;
        Fri, 15 May 2020 10:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5BAaBU5ifC58XNGZbuP0G4dXisapjBIo5HxzFI37890=;
        b=d6tfvIUOSPS6rTzMoqxcRhO3DHFM0yPeswT6Eq7iGmqfTVFq8qJqMNmwnbI3YcrRNj
         lEvJfNJf84fm4girX5Uj70aWaIVXxarw1p13WV8c6eI1+MxtKAqa4YnQtI5heTYQUWR+
         xIsEDY86QxzLiEr5YTCBIOXIMcoLuR1KpScT3BKG5lHrf1zq/GgPdNIXQltecVc43Zjb
         Iw7eS8EicTa49mX+ESredRg78oi/iw66Q81zs0SyxLtn3Gil/KX2WNAOkorbZVQGBXub
         0ce2kebNA0z1THSVjp6i4tl+7xsDo5oCggg56NTcV4o4eFEvwPXVtoYaTHvdjQ4a6O2Z
         FuJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5BAaBU5ifC58XNGZbuP0G4dXisapjBIo5HxzFI37890=;
        b=fsjNvN+D2kdCLr4XNLAesv178aJoV/mIxgOAKFGWhXoM2v3RnM7vYdwbsxoODO7Tog
         91QPzQJf34k1ICIvz5+H/xGxNK4I10meUEc6wRnIA43Hfcoj3YbRs2pO5f6lX5rSd0Wz
         yOwnQIXSY+yNVoOV+zLTshQ5gwPaCTfJ0CBtYDCX0YVLCXUmgaSFLAxM9aO+jFOeDyY/
         EEcb5v/OCmCkwRsws2ziKzyNHNvtEB/UMPJBK+pWBf6S6Mog7R+CK51YXAvyWZEoxyZn
         8P2YckS0zguMwN0OiRIw/ybuVHh2FjNcrsOvXywoQNT+0RimBzrCDYRaT3w8lcV+yYXi
         PFIA==
X-Gm-Message-State: AOAM532BqLhBKDNMxuPow3PXKFOk9DBJOfKgluH0+yJ63b5A/KlaYH7g
        5pCz+xrPWO3ooo7grvsoUmM=
X-Google-Smtp-Source: ABdhPJyTHR9uM3WifwYDjny5M+gs0lXsuGUUGSYa3CuRMSNXGIijnWzpj7+oD1h/dY0xU3NlAR2IoA==
X-Received: by 2002:a17:902:8202:: with SMTP id x2mr4579527pln.287.1589563526420;
        Fri, 15 May 2020 10:25:26 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id gb6sm1957880pjb.56.2020.05.15.10.25.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 May 2020 10:25:25 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: pull-request: bpf 2020-05-15
Date:   Fri, 15 May 2020 10:25:23 -0700
Message-Id: <20200515172523.44348-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 9 non-merge commits during the last 2 day(s) which contain
a total of 14 files changed, 137 insertions(+), 43 deletions(-).

The main changes are:

1) Fix secid_to_secctx LSM hook default value, from Anders.

2) Fix bug in mmap of bpf array, from Andrii.

3) Restrict bpf_probe_read to archs where they work, from Daniel.

4) Enforce returning 0 for fentry/fexit progs, from Yonghong.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Christoph Hellwig, James Morris, John Fastabend, Julian 
Wiedmann, Linus Torvalds, Masami Hiramatsu, Yonghong Song

----------------------------------------------------------------

The following changes since commit 9de5d235b60a7cdfcdd5461e70c5663e713fde87:

  net: phy: fix aneg restart in phy_ethtool_set_eee (2020-05-13 15:21:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 59df9f1fb4977b40cfad8d07b0d5baeb3a07e22c:

  Merge branch 'restrict-bpf_probe_read' (2020-05-15 08:15:07 -0700)

----------------------------------------------------------------
Alexei Starovoitov (1):
      Merge branch 'restrict-bpf_probe_read'

Anders Roxell (1):
      security: Fix the default value of secid_to_secctx hook

Andrii Nakryiko (1):
      bpf: Fix bug in mmap() implementation for BPF array map

Daniel Borkmann (3):
      bpf: Restrict bpf_probe_read{, str}() only to archs where they work
      bpf: Add bpf_probe_read_{user, kernel}_str() to do_refine_retval_range
      bpf: Restrict bpf_trace_printk()'s %s usage and add %pks, %pus specifier

Matteo Croce (1):
      samples: bpf: Fix build error

Sumanth Korikkar (1):
      libbpf: Fix register naming in PT_REGS s390 macros

Yonghong Song (2):
      bpf: Enforce returning 0 for fentry/fexit progs
      selftests/bpf: Enforce returning 0 for fentry/fexit programs

 Documentation/core-api/printk-formats.rst         |  14 +++
 arch/arm/Kconfig                                  |   1 +
 arch/arm64/Kconfig                                |   1 +
 arch/x86/Kconfig                                  |   1 +
 include/linux/lsm_hook_defs.h                     |   2 +-
 init/Kconfig                                      |   3 +
 kernel/bpf/arraymap.c                             |   7 +-
 kernel/bpf/verifier.c                             |  21 ++++-
 kernel/trace/bpf_trace.c                          | 100 ++++++++++++++--------
 lib/vsprintf.c                                    |  12 +++
 samples/bpf/lwt_len_hist_user.c                   |   2 -
 tools/lib/bpf/bpf_tracing.h                       |   4 +-
 tools/testing/selftests/bpf/prog_tests/mmap.c     |   8 ++
 tools/testing/selftests/bpf/progs/test_overhead.c |   4 +-
 14 files changed, 137 insertions(+), 43 deletions(-)
