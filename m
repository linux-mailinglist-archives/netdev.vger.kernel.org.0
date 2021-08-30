Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461A73FBB05
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 19:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238214AbhH3Rf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 13:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbhH3RfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 13:35:25 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994DFC061575;
        Mon, 30 Aug 2021 10:34:31 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so14385231pjr.1;
        Mon, 30 Aug 2021 10:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CyOQ7v1k83UeAxnfGLUghIwT0Z2JNPMZHajFoOQYtNM=;
        b=qpCwUREaztkvtdgpaq1mKQUA7UxXoulIk2SJJFD4IacPINKBjIonkNTXbpWGQaQ17a
         1msbOlzbHv1ItJlnSkywA/fY5KPqCgio00F2WJNNk9OlqVXj8YX+7SkVp4nv2UNL/MXq
         j7+dN5nIjdSGfxDvVlyQgbytwfBXZedN27FzLEUAanNDdqKbLpq0biuAg6n8z+HrVBbh
         u0/EuWEP/jUzhsmW/ZNAQNydU3AURZa8wcsGPvg4Cb41PKavkJhz23L6sryYFYAe8tqz
         9DeRlPkk0Ojb3QS+4NggTUrOZyo+dMnj/9AFNMWxhg0jD2l5MVHkZfUqsGXMgTSr6mZU
         /Dug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CyOQ7v1k83UeAxnfGLUghIwT0Z2JNPMZHajFoOQYtNM=;
        b=VKEliovq7kSs0Q0ZeabkY0mdCsDC+l6Q5xA93C/hmRWAYySuBNOYXqrTHzZIbzdK0q
         WzEBSBQeDXHn1r6qAhk1VRDipOwc1Mt2v19eAuJLgGhGWv84YJExjGC+6EKPShcc/6m2
         uaQ+FNkagjiz1nwuNoDpvg9dY4anjnlnAmcvZs8fYU9nj+tc7AwbjE/S6UZn/UrW1EnI
         YoPtkFeaAOOfAbMXrnXYPFGkTO+5jzu4fo4h26ImlB4B0YEImRb7t70bfe86xPU1ykWN
         Fd83xy3uChW0IURtUxZiw7Hix9WGyo6tGDUqx3AkOQz/IrWhx9tQJLEYtWqbObItK6Vf
         7YQw==
X-Gm-Message-State: AOAM530EpAIdYXJkhjXMdGbqj/n+/KWTfbLRoHl6Y4XViKuQ5sIkwa3N
        F69baj9cH32ShqQb1p8XCZRuIid8z43Eow==
X-Google-Smtp-Source: ABdhPJwPxvpTguE8UV0MKzvoa9xJqTJZmKnY8bfmtNFdnCmzD1+XjanYmpPKZohwDu5RzMWg7Qpkkw==
X-Received: by 2002:a17:90a:f285:: with SMTP id fs5mr211109pjb.148.1630344870881;
        Mon, 30 Aug 2021 10:34:30 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id d20sm14776076pfu.36.2021.08.30.10.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 10:34:30 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next RFC v1 0/8] Support kernel module function calls from eBPF
Date:   Mon, 30 Aug 2021 23:04:16 +0530
Message-Id: <20210830173424.1385796-1-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2603; h=from:subject; bh=c2kGo/sigrmHyjOR/An+f/GPRWdYGrv14zTON1Yr4pE=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhLRX8wbdN7XRR71nQ6cXdP7rSs2SdbTSRYlDPLgtf KTn27gOJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYS0V/AAKCRBM4MiGSL8RyuqcEA CPdzyqUsDI0TouE2k0m1f5BptZ++2iFDADY61yXRJk7jmpSRHcZXHn5PoU1Xgl88oldSXHRfEDh65c qSi0qa5l+rqOGD+rXQKfx++FQrUZSPaBMY4qEgxHPgVPty4JxpgVR3+ZKqzuxssPbltmjqIef15KLH 2Z10i9RSPh0OdEtTwpYf5qy+BGG5No2v4R3azphNsxR2TTr751L3NxOaAK7C8eD7nRe5hhJrIPfcX6 fhujrFhtuiHs12EV7B2g8GTRTrDGU15e2tDEN/ZZabKW6bHmFRsQyTTdMFiZmGdjuY3dPZJOrdZaeD UMBd2gbwyRF1TfrPK7Qc5lE06deLsfHh5/Y+zSRJc9s7jJQHnLoI+/Lou+BBss+qIMNc8XGDFySkMY CVgm7xhLV5Ac1fTMxiI2G+5hunQPO+O8nSENcig+Rr6I3eie7C4rn5zqQup+yXagN+avYcfJZhbTF0 tQIYV585QVuhNhHt92Jja/a61sYqHvlWLyDNdoljlaISlVT7qAITWl0aPnfq/yLsdrakNDUdlHelyX ZKYifIyrJ455J0ewgQo7AzwcTLFPlItM3w5W6tdcxPmprCD9atG+I0Mgrl3s3HH20cgU8qvFD/1iAs 1fbUfh03t8S9DZeO/5HvBMtfCeN8njNTKr+DGp8cUOjT2hrDjFcUBWw6cTAA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set enables kernel module function calls, and also modifies verifier logic
to permit invalid kernel function calls as long as they are pruned as part of
dead code elimination. This is done to provide better runtime portability for
BPF objects, which can conditionally disable parts of code that are pruned later
by the verifier (e.g. const volatile vars, kconfig options). libbpf
modifications are made along with kernel changes to support module function
calls.

It also converts TCP congestion control objects to use the module kfunc support
instead of relying on IS_BUILTIN ifdef.

Kumar Kartikeya Dwivedi (8):
  bpf: Introduce BPF support for kernel module function calls
  bpf: Be conservative during verification for invalid kfunc calls
  libbpf: Support kernel module function calls
  libbpf: Resolve invalid kfunc calls with imm = 0, off = 0
  tools: Allow specifying base BTF file in resolve_btfids
  bpf: btf: Introduce helpers for dynamic BTF set registration
  bpf: enable TCP congestion control kfunc from modules
  bpf, selftests: Add basic test for module kfunc call

 include/linux/bpf.h                           |   1 +
 include/linux/bpfptr.h                        |   1 +
 include/linux/btf.h                           |  18 +++
 include/linux/filter.h                        |   9 ++
 include/uapi/linux/bpf.h                      |   3 +-
 kernel/bpf/btf.c                              |  37 +++++++
 kernel/bpf/core.c                             |  14 +++
 kernel/bpf/syscall.c                          |  55 +++++++++-
 kernel/bpf/verifier.c                         | 103 ++++++++++++++----
 kernel/trace/bpf_trace.c                      |   1 +
 net/ipv4/bpf_tcp_ca.c                         |  34 +-----
 net/ipv4/tcp_bbr.c                            |  28 ++++-
 net/ipv4/tcp_cubic.c                          |  26 ++++-
 net/ipv4/tcp_dctcp.c                          |  26 ++++-
 scripts/Makefile.modfinal                     |   1 +
 tools/bpf/resolve_btfids/main.c               |  19 +++-
 tools/include/uapi/linux/bpf.h                |   3 +-
 tools/lib/bpf/bpf.c                           |   3 +
 tools/lib/bpf/libbpf.c                        |  91 ++++++++++++++--
 tools/lib/bpf/libbpf_internal.h               |   2 +
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  23 +++-
 .../selftests/bpf/prog_tests/ksyms_module.c   |  10 +-
 .../selftests/bpf/progs/test_ksyms_module.c   |   9 ++
 24 files changed, 446 insertions(+), 74 deletions(-)

-- 
2.33.0

