Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0EB43539A
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 21:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhJTTRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 15:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbhJTTRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 15:17:44 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72A4C06161C;
        Wed, 20 Oct 2021 12:15:29 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y7so3777202pfg.8;
        Wed, 20 Oct 2021 12:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eMCE5XA8Z6J+gUaP+mf/hwHTwCzyOLUABs3DRsOl2TA=;
        b=Akg5As9+b22vT9op5p94Hg8lZE6P8T4V88CDYBq9TQkXKePrWxiwSp1f5kuBrDtH4w
         Voe6efFMiEAdrKYBMHYIZfLuEuAFmHpsnbBPWyHjvlgAT5E81jroJByED0CNwDM8ZeRh
         NbbjunPebQB0KHMmlwTeuw8ulhEjbUt7+OJSJdXQQvW9TtbIMR44zwH6o51Fx/CtbQDy
         vrzxWj2n9jOlq6ipLMlrt7yVM5A3X1GaX9ZjdSCVGn6eaogOtxMQK4CfoQmjdgn1eTyS
         j99NuvITwAuKMAVALznCDAOezwCcA2jWL+06mveFG1RxREyCPADURFBFXI+/gZ4L1pre
         b4Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eMCE5XA8Z6J+gUaP+mf/hwHTwCzyOLUABs3DRsOl2TA=;
        b=KmSvoyUfTbB1h5qOni6Baf/8hjBHzLHnWzd3QJqDJ5hCWnCBf8BDS0fD6+06goQ+ws
         V0eVp5ZJPYXdYZV/z+Ph5z5h2hOHdD7cspry6m3QCodeZirJjAD6d/TrB8WxXsLDPDDB
         B1Eqa5xd50E6niGZT67AogGr8ZdzKdnCe+1B4vKSwPxx8u8Zf7x+wrj4KgORJurO+phf
         eyS/TzNfvDcSxWrhvKvVlBGnNC/hluIWj1NP6ilGlTAxW+YS9Jz4eW+Q1ZvonoJVqYE6
         fzCS+h8BdXaK6tjY8pEGXnBWWmabkSNoNDV3PElT8GxY6FIBVo83BASu0MyaZuPBUIFb
         +Xew==
X-Gm-Message-State: AOAM5304Mi3qNh99pA2+zKFmqKvsMYk2LrCycKzN41BfuBqrtI4i0fVb
        UUl/j2a0RmOsJF6j6n/ZeVpb33J/17M4iQ==
X-Google-Smtp-Source: ABdhPJwPC4ziC+OV1J+lhYOxOL2Fo/akVTw5yilkAOF104QPXdcCujsitC4QTnQsIuJieBYBK+/OnA==
X-Received: by 2002:a05:6a00:179f:b0:44d:d603:dfc8 with SMTP id s31-20020a056a00179f00b0044dd603dfc8mr627330pfg.49.1634757329120;
        Wed, 20 Oct 2021 12:15:29 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id lb9sm739148pjb.25.2021.10.20.12.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 12:15:28 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 0/8] Typeless/weak ksym for gen_loader + misc fixups
Date:   Thu, 21 Oct 2021 00:45:18 +0530
Message-Id: <20211020191526.2306852-1-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3552; h=from:subject; bh=UYtmfKW3bbRRm6lVAwBJsPN1vCqhrEdnDQY/coAYX7w=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhcGoec+r5QPsraCQM27E3OMQBZyoY2r4qzfNMI+TX ruj3cGCJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYXBqHgAKCRBM4MiGSL8RygqBD/ 4nz8nHbacu78Q1/znX6c7NO3cOfVmxyeKqhFsQTvZUlyAXMO4Hmt8lmfNaN2AYhC/X4g5MJNm1ISUd bNGhZ1YP57JtWP13NMc9ZrtFl8WIvA6a09FNE+xSE5LKb6pB/8eST+M/JXBUQouXXgu5ca3x/q7qWI iRQwLkqxkcNqmGHkAeHVOLQec6FUNquSY+H4p4pzuX/ASzF6DyWoa6W/7KFLVthAQuu5WU45vV6ug3 6HZn4VxMMyRIjaDS6h/5fG78BIvpHl9KZuxo6rVc0uiANxWX+TfYV5/Di/a/iFpfoonDFLPTxxJqXX NFjVMFI5ORzwzyZP7/60hQ9sY6TFIEYUan4NPxrSktaKp/24ZNFREZn9lynQ9n+IT0NFuwAmV4nyZR a6GtAswWndNmtcbUuqTJGdngcXLt2L/NkOd5xwUzK2kDXeMM5NBi3XouSRppot9FpgHLBtvAZGtH9A ySOidA4Rc6Q3YnyT+nQm8bXWBB5i0z4Zlju/ATogtGrtyrV8IHYsaRFwIm1SoK0QSvC8VTnCQk6Qu5 3ZlPv600mMLs2b0jzcLfkGchYUcyX5GbTcZl9pP0mJ2o+GyuhKtXEURAPiAYsQnZs5KLGQEV5pb1i2 IlrbAr8SC8OWv8Ibu+9hUZSpJkWUpzsARK/dRLDqnZYcHyrbJDhWUaqOCfBA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patches (1,2,3,6) add typeless and weak ksym support to gen_loader. It is follow
up for the recent kfunc from modules series.

The later patches (7,8) are misc fixes for selftests, and patch 4 for libbpf
where we try to be careful to not end up with fds == 0, as libbpf assumes in
various places that they are greater than 0. Patch 5 fixes up missing O_CLOEXEC
in libbpf.

Please look at patch 4 and 5 closely and whether I missed any other places that
need a change.

Changelog:
----------
v3 -> v4
v3: https://lore.kernel.org/bpf/20211014205644.1837280-1-memxor@gmail.com

 * Remove gpl_only = true from bpf_kallsyms_lookup_name (Alexei)
 * Add bpf_dump_raw_ok check to ensure kptr_restrict isn't bypassed (Alexei)

v2 -> v3
v2: https://lore.kernel.org/bpf/20211013073348.1611155-1-memxor@gmail.com

 * Address feedback from Song
   * Move ksym logging to separate helper to avoid code duplication
   * Move src_reg mask stuff to separate helper
   * Fix various other nits, add acks
     * __builtin_expect is used instead of likely to as skel_internal.h is
       included in isolation.

v1 -> v2
v1: https://lore.kernel.org/bpf/20211006002853.308945-1-memxor@gmail.com

 * Remove redundant OOM checks in emit_bpf_kallsyms_lookup_name
 * Use designated initializer for sk_lookup fd array (Jakub)
 * Do fd check for all fd returning low level APIs (Andrii, Alexei)
 * Make Fixes: tag quote commit message, use selftests/bpf prefix (Song, Andrii)
 * Split typeless and weak ksym support into separate patches, expand commit
   message (Song)
 * Fix duplication in selftests stemming from use of LSKELS_EXTRA (Song)

Kumar Kartikeya Dwivedi (8):
  bpf: Add bpf_kallsyms_lookup_name helper
  libbpf: Add typeless ksym support to gen_loader
  libbpf: Add weak ksym support to gen_loader
  libbpf: Ensure that BPF syscall fds are never 0, 1, or 2
  libbpf: Use O_CLOEXEC uniformly when opening fds
  selftests/bpf: Add weak/typeless ksym test for light skeleton
  selftests/bpf: Fix fd cleanup in sk_lookup test
  selftests/bpf: Fix memory leak in test_ima

 include/linux/bpf.h                           |   1 +
 include/uapi/linux/bpf.h                      |  16 +++
 kernel/bpf/syscall.c                          |  27 ++++
 tools/include/uapi/linux/bpf.h                |  16 +++
 tools/lib/bpf/bpf.c                           |  28 ++--
 tools/lib/bpf/bpf_gen_internal.h              |  12 +-
 tools/lib/bpf/btf.c                           |   2 +-
 tools/lib/bpf/gen_loader.c                    | 132 ++++++++++++++++--
 tools/lib/bpf/libbpf.c                        |  53 ++++---
 tools/lib/bpf/libbpf_internal.h               |  23 +++
 tools/lib/bpf/libbpf_probes.c                 |   2 +-
 tools/lib/bpf/linker.c                        |   4 +-
 tools/lib/bpf/ringbuf.c                       |   2 +-
 tools/lib/bpf/skel_internal.h                 |  35 ++++-
 tools/lib/bpf/xsk.c                           |   6 +-
 tools/testing/selftests/bpf/Makefile          |   7 +-
 .../selftests/bpf/prog_tests/ksyms_btf.c      |  35 ++++-
 .../selftests/bpf/prog_tests/ksyms_module.c   |  40 +++++-
 .../bpf/prog_tests/ksyms_module_libbpf.c      |  28 ----
 .../selftests/bpf/prog_tests/sk_lookup.c      |  14 +-
 .../selftests/bpf/prog_tests/test_ima.c       |   3 +-
 .../selftests/bpf/progs/test_ksyms_weak.c     |   3 +-
 22 files changed, 374 insertions(+), 115 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c

-- 
2.33.1

