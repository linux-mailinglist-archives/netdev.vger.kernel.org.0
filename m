Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063E146853B
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 15:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385146AbhLDOKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 09:10:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31917 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1385137AbhLDOKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 09:10:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638626824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cOdYTEZmaIlv5IppN0FZFDrUkHw6ggGqnaTF4PDq7Qg=;
        b=IuzbuEdxlu74r4SLiOYknxYUjEg3f7jZuXSPutFiIJRHr3eEO0yzePoZktJQjsxv1/Kymi
        XTJK0I5ky4gKwu2kXUoSx62+ZUX/vlCSArr3GsVNiRFdPVmKNla9q9IBtabYv1WU1TWEEk
        BKPGsZlkTk63HIu7Tb67W1Vb7SwuMKU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-9w2Tz3ByOeqyhCLte21oDg-1; Sat, 04 Dec 2021 09:07:03 -0500
X-MC-Unique: 9w2Tz3ByOeqyhCLte21oDg-1
Received: by mail-wm1-f69.google.com with SMTP id g81-20020a1c9d54000000b003330e488323so2416379wme.0
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 06:07:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cOdYTEZmaIlv5IppN0FZFDrUkHw6ggGqnaTF4PDq7Qg=;
        b=Kk+1YF/F6oQl429o701ApbZY70KZ4dfg+PHCh4rFuDUhUJRGFcMhIdvftNSXZjljLX
         Xi364NR2Jj4+lDsdwvRe6FU1iTvIaiJSfeiloRWOwnLOGelonFAEHtmTB2poJsiK68vh
         MDaJj5zmi1YVvXj5vR27BjMDK8x+g5IiI2wPDppQRHOzAqWwTiCLhwsNse+wDmdoDyyp
         J9CwOWIDDoAj4/NiDW6IgZZ1ISm5pvg1SUpkiAw7xoa4G0y5qn2K5NDeF0dKMo0RLCxZ
         E7xjaqTYraN30ZNXuiLKP32I8VlU4ycCFRMFt0HsIhLP/sSZ9m9OKeu8LGGRxIZcHOLV
         rBbQ==
X-Gm-Message-State: AOAM530H4fUoQfp64n39VfznTgbiPBGb3+xQGmAR+GfCRechKKQa7j7L
        I72cx1Ql5fN+P9QO8SMCz2N0LptqRjvG1GhvHi+mQ+zkq5E1oOcz/FwZ4OI5ozu6Fl4DLw40WCD
        FFhqj9ADvwxiqB6IW
X-Received: by 2002:a5d:4989:: with SMTP id r9mr28514330wrq.14.1638626822106;
        Sat, 04 Dec 2021 06:07:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzNKAK0HUtMITjRd+ZyXSm1XTXxwpkjejiQgvuHlN7hMdvUounBStqVDU/jkHmmtEsT4FnjJQ==
X-Received: by 2002:a5d:4989:: with SMTP id r9mr28514305wrq.14.1638626821958;
        Sat, 04 Dec 2021 06:07:01 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id i17sm6359714wmq.48.2021.12.04.06.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 06:07:01 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next 0/3] bpf: Add helpers to access traced function arguments
Date:   Sat,  4 Dec 2021 15:06:57 +0100
Message-Id: <20211204140700.396138-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
adding new helpers to access traced function arguments that
came out of the trampoline batch changes [1].

  Get n-th argument of the traced function:
    long bpf_get_func_arg(void *ctx, u32 n, u64 *value)
  
  Get return value of the traced function:
    long bpf_get_func_ret(void *ctx, u64 *value)
  
  Get arguments count of the traced funtion:
    long bpf_get_func_arg_cnt(void *ctx)

changes from original post [1]:
  - change helpers names to get_func_*
  - change helpers to return error values instead of
    direct values
  - replaced stack_size usage with specific offset
    variables in arch_prepare_bpf_trampoline
  - add comment on stack layout
  - add more tests
  - allow bpf_get_func_ret in FENTRY programs
  - use BPF_LSH instead of BPF_MUL

thanks,
jirka


[1] https://lore.kernel.org/bpf/20211118112455.475349-1-jolsa@kernel.org/
---
Jiri Olsa (3):
      bpf, x64: Replace some stack_size usage with offset variables
      bpf: Add get_func_[arg|ret|arg_cnt] helpers
      selftests/bpf: Add tests for get_func_[arg|ret|arg_cnt] helpers

 arch/x86/net/bpf_jit_comp.c                                 |  55 +++++++++++++++++++++++++++++++++------------
 include/uapi/linux/bpf.h                                    |  28 +++++++++++++++++++++++
 kernel/bpf/verifier.c                                       |  73 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/trace/bpf_trace.c                                    |  58 ++++++++++++++++++++++++++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h                              |  28 +++++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/get_func_args_test.c |  38 +++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/get_func_args_test.c      | 112 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 375 insertions(+), 17 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_func_args_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/get_func_args_test.c

