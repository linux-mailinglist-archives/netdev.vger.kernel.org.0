Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D2F3BF18A
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 23:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbhGGVum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 17:50:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26844 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229717AbhGGVum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 17:50:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625694481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aS1dgZe1Y+a0DEt2IGEpVJBZTvoEoYf9KumylbJq+vo=;
        b=LHvASfknSGvyJlxzENEhlEPCgyTtrOHbTnWKAZCb+FSS/il3QZP6egex/EfJ58O6b7t/Lu
        coJH3aaMpu+iIY1Q+UFqmvA54jgHqtGhtfzYNm3rMm3wedKy4Gt+RV42CVNsUenBZ1xaSe
        dpzZLjNAWpEFvGdxO9qP/+llc734J6k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-pTko5kVvP16ZVkWexEwZOQ-1; Wed, 07 Jul 2021 17:47:59 -0400
X-MC-Unique: pTko5kVvP16ZVkWexEwZOQ-1
Received: by mail-wm1-f69.google.com with SMTP id n5-20020a05600c3b85b02902152e9caa1dso1374156wms.3
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 14:47:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aS1dgZe1Y+a0DEt2IGEpVJBZTvoEoYf9KumylbJq+vo=;
        b=afCe9iUEMV3Vv1Ny3fJeIsgIjUsfofBSKmROszNSf/4Eqi1VlMfOJk1DeRFequ8hp2
         L9Rlu1kyJTkn+NDOIgPaDh94EYVXDjG3WYNPTQxNwKBv19v3QRbn3hFIfZzxWZ1M7ddE
         DlLfKNX7l8yND+kZaIBz7R/DU/nI9NCrZALGWCSyX1bGYNEiY8nONYeCqMTLAfv+t+Q/
         /s9ZEKNQSMZvJqdjH3WHdeTeWdPAAfZp01zrtO7ClBAbR0xMM7vLpAdSV3xrBomehFyB
         a09Mx2wLY7noVLarBs1Db/gZ6b8l6kszZftoIdnD5aeHyPB2ZybOqa2DxeXGjLawGt8E
         hHtQ==
X-Gm-Message-State: AOAM533eV7+89AcqN+4ar8+jkEPyCN2GxBHo890RlPii/ilu1yee2Jo3
        nnTCEMlaKUpsTvktxUpSxU81pBIVSZHholXsrHw1IAKnuWFKSeSK/vFZplAhKgiQ9nq73VnzFGB
        691QCs3PO9FMrtqTf
X-Received: by 2002:a05:600c:26d1:: with SMTP id 17mr29243353wmv.1.1625694478780;
        Wed, 07 Jul 2021 14:47:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHPk6iYAbt1Q8J4/o3Q4ktkuU6/y4jq8VFumBVfJBJ6xesYnLDsn6jLfhOkQ+a4dYB0rODlQ==
X-Received: by 2002:a05:600c:26d1:: with SMTP id 17mr29243333wmv.1.1625694478600;
        Wed, 07 Jul 2021 14:47:58 -0700 (PDT)
Received: from krava.redhat.com ([185.153.78.55])
        by smtp.gmail.com with ESMTPSA id p9sm132426wmm.17.2021.07.07.14.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 14:47:58 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCHv3 bpf-next 0/7] bpf, x86: Add bpf_get_func_ip helper
Date:   Wed,  7 Jul 2021 23:47:44 +0200
Message-Id: <20210707214751.159713-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
adding bpf_get_func_ip helper that returns IP address of the
caller function for trampoline and krobe programs.

There're 2 specific implementation of the bpf_get_func_ip
helper, one for trampoline progs and one for kprobe/kretprobe
progs.

The trampoline helper call is replaced/inlined by verifier
with simple move instruction. The kprobe/kretprobe is actual
helper call that returns prepared caller address.

Also available at:
  https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  bpf/get_func_ip

v3 changes:
  - resend with Masami in cc and v3 in each patch subject

v2 changes:
  - use kprobe_running to get kprobe instead of cpu var [Masami]
  - added support to add kprobe on function+offset
    and test for that [Alan]

thanks,
jirka


---
Alan Maguire (1):
      libbpf: allow specification of "kprobe/function+offset"

Jiri Olsa (6):
      bpf, x86: Store caller's ip in trampoline stack
      bpf: Enable BPF_TRAMP_F_IP_ARG for trampolines with call_get_func_ip
      bpf: Add bpf_get_func_ip helper for tracing programs
      bpf: Add bpf_get_func_ip helper for kprobe programs
      selftests/bpf: Add test for bpf_get_func_ip helper
      selftests/bpf: Add test for bpf_get_func_ip in kprobe+offset probe

 arch/x86/net/bpf_jit_comp.c                               | 19 +++++++++++++++++++
 include/linux/bpf.h                                       |  5 +++++
 include/linux/filter.h                                    |  3 ++-
 include/uapi/linux/bpf.h                                  |  7 +++++++
 kernel/bpf/trampoline.c                                   | 12 +++++++++---
 kernel/bpf/verifier.c                                     | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/bpf_trace.c                                  | 32 ++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h                            |  7 +++++++
 tools/lib/bpf/libbpf.c                                    | 20 +++++++++++++++++---
 tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/get_func_ip_test.c      | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 270 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/get_func_ip_test.c

