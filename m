Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9FF525CDB4
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 00:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgICWeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 18:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728288AbgICWdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 18:33:36 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3B7C061247
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 15:33:36 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id y187so2468655qka.10
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 15:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=fTZ15syT0j93m0JsqPQnX1nkgQUuupGOrvog1ui3uCg=;
        b=jg0PYIL8/uxMLhBlBcANr9ZodHPKPSPhUdh/T7gtdwPYtHZdEBIqw++C06tS8hxt7K
         FQyODpWmDbyei1fD7rLkUD5zFFclZ0s8B9BFtTRjSVxAaF6DQovV4Tjag5YScRBg3rkr
         pz/qPj2xm0HVcn8B8Iug60bEEaZkRnD6g3sQRlc+Vo+zmID1DkdotqvR8FtOUdizKqvc
         3AZBfgYuZCtK8DfaBtPFmUcNC8RoC5gAUxZe6ZBg+vFjnvwS/sFbWMb0dJQr1LxwBeMy
         bMDihACraTfSF8FFU0JmiMN/uuQRlyc1F25wtC9BTlvZuCn4DvWUsLnVZIYwezb9zoHh
         BGbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=fTZ15syT0j93m0JsqPQnX1nkgQUuupGOrvog1ui3uCg=;
        b=tgOWTDZCACG/J3qEC00CrY/Fz9YBtF5HH999NgzMXj//kJ0I21Pj3jFXzaUywqZxIm
         bJlh9WiO91XdHvVa9svLI/auzMcvFrUSUe0vzbxpcFVwRm7/mi8QX9ZMubDpbkmOYjC0
         lWbRh4ZFmJXRePCm1evwG80OBKSkTeWiZ8t/sgCvYDBrgjtIjsjL7M5KSmJoiPy55s8o
         KWu/RwmEfPBevJvXgpEtck2fGOr+B68rIlxm3c2kWUMZqBEsk1h5C7zT+QFiwJuWn2CH
         smWLI2i0JoMNsIMA6hvF2pPSdtQKdZ/kfep9CaWw4cXz0FA84bwbKNwvlZBo8ArACD9q
         qh3w==
X-Gm-Message-State: AOAM5301n1WGjlh+0Uf360i/RRsGW/CY0ppdxfvYHknR0kitmomcQh7O
        WMe09dr/M683taUbK3Q7xTti2o7SMi432ov4LSUZMlFLTnkZ0ciHIwo5Zid/0FTlGWj02+txxez
        lS6IlaxpgGFTP8cHlt4JT5r4n/ElRqYIE29RoyiISk0vdjDTPlub888N88eWbsg==
X-Google-Smtp-Source: ABdhPJwfdmRl7fQrs6iAGmzxMo4s6aY3ueBPiwa8QHmB+91ldNEpNzmWD5pOtS17ypkemV/n1Ula7lNNngU=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:a0c:f48e:: with SMTP id i14mr4176950qvm.9.1599172415472;
 Thu, 03 Sep 2020 15:33:35 -0700 (PDT)
Date:   Thu,  3 Sep 2020 15:33:26 -0700
Message-Id: <20200903223332.881541-1-haoluo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH bpf-next v2 0/6] bpf: BTF support for ksyms
From:   Hao Luo <haoluo@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Hao Luo <haoluo@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1 -> v2:
 - Move check_pseudo_btf_id from check_ld_imm() to
   replace_map_fd_with_map_ptr() and rename the latter.
 - Add bpf_this_cpu_ptr().
 - Use bpf_core_types_are_compat() in libbpf.c for checking type
   compatibility.
 - Rewrite typed ksym extern type in BTF with int to save space.
 - Minor revision of bpf_per_cpu_ptr()'s comments.
 - Avoid using long in tests that use skeleton.
 - Refactored test_ksyms.c by moving kallsyms_find() to trace_helpers.c
 - Fold the patches that sync include/linux/uapi and
   tools/include/linux/uapi.

rfc -> v1:
 - Encode VAR's btf_id for PSEUDO_BTF_ID.
 - More checks in verifier. Checking the btf_id passed as
   PSEUDO_BTF_ID is valid VAR, its name and type.
 - Checks in libbpf on type compatibility of ksyms.
 - Add bpf_per_cpu_ptr() to access kernel percpu vars. Introduced
   new ARG and RET types for this helper.

This patch series extends the previously added __ksym externs with
btf support.

Right now the __ksym externs are treated as pure 64-bit scalar value.
Libbpf replaces ld_imm64 insn of __ksym by its kernel address at load
time. This patch series extend those externs with their btf info. Note
that btf support for __ksym must come with the kernel btf that has
VARs encoded to work properly. The corresponding chagnes in pahole
is available at [1] (with a fix at [2] for gcc 4.9+).

The first 3 patches in this series add support for general kernel
global variables, which include verifier checking (01/06), libpf
support (02/06) and selftests for getting typed ksym extern's kernel
address (03/06).

The next 3 patches extends that capability further by introducing
helpers bpf_per_cpu_ptr() and bpf_this_cpu_ptr(), which allows accessing
kernel percpu variables correctly (04/06 and 05/06).

The tests of this feature were performed against pahole that is extended
with [1] and [2]. For kernel BTF that does not have VARs encoded, the
selftests will be skipped.

[1] https://git.kernel.org/pub/scm/devel/pahole/pahole.git/commit/?id=f3d9054ba8ff1df0fc44e507e3a01c0964cabd42
[2] https://www.spinics.net/lists/dwarves/msg00451.html

Hao Luo (6):
  bpf: Introduce pseudo_btf_id
  bpf/libbpf: BTF support for typed ksyms
  bpf/selftests: ksyms_btf to test typed ksyms
  bpf: Introduce bpf_per_cpu_ptr()
  bpf: Introduce bpf_this_cpu_ptr()
  bpf/selftests: Test for bpf_per_cpu_ptr() and bpf_this_cpu_ptr()

 include/linux/bpf.h                           |   4 +
 include/linux/bpf_verifier.h                  |   4 +
 include/linux/btf.h                           |  26 +++
 include/uapi/linux/bpf.h                      |  69 ++++++-
 kernel/bpf/btf.c                              |  25 ---
 kernel/bpf/verifier.c                         | 176 +++++++++++++++++-
 kernel/trace/bpf_trace.c                      |  32 ++++
 tools/include/uapi/linux/bpf.h                |  69 ++++++-
 tools/lib/bpf/libbpf.c                        | 116 ++++++++++--
 .../testing/selftests/bpf/prog_tests/ksyms.c  |  31 +--
 .../selftests/bpf/prog_tests/ksyms_btf.c      |  73 ++++++++
 .../selftests/bpf/progs/test_ksyms_btf.c      |  49 +++++
 tools/testing/selftests/bpf/trace_helpers.c   |  26 +++
 tools/testing/selftests/bpf/trace_helpers.h   |   4 +
 14 files changed, 615 insertions(+), 89 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf.c

-- 
2.28.0.526.ge36021eeef-goog

