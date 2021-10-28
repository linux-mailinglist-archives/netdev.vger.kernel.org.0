Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F3A43DB37
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 08:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhJ1Ghb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 02:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhJ1Ghb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 02:37:31 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B14C061570;
        Wed, 27 Oct 2021 23:35:04 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id oa4so3925059pjb.2;
        Wed, 27 Oct 2021 23:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d57ZRnUdiuRIz10splAfyVu/kTSoQlQTF/6uxmPMj2Q=;
        b=MkvEICPKCEn3DWx8yyY6tyv8armsmkJV28e91TJ65UTlN2PI0v1NqimoQ8QBqGBr1y
         PDRFKSqqaVl/naQjOZC1l1uvr5Xs099QnEi6wdjSn5hldeLiZxsglZBNgZILGO4xw9ab
         8vs4NmO+KkK6r1cwcEgf+lzmcUx5HMptKPDNcVaVpbr0SCGdoUx+WT18wAuyP918VTuM
         a3f8kLu7jeONmRloEJnRYQSn4sVpENml86A180Sy1QeJlZN4vXOqMeJUWoOeqt4O1N4X
         /iZn+CeITtodwNTB5owLmXCx2S+bzWxqPNGyQ17iajRzDxg62XpuisISiVu+uneqVALm
         USqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d57ZRnUdiuRIz10splAfyVu/kTSoQlQTF/6uxmPMj2Q=;
        b=EXQ18A1/8vbOtkzALZ//g6H1zw+mIB7s4qysHwt3CH/0E4x3oDO1SkNUj5jtVHNUM3
         a92EShYfEoTSy7pSG0cCkQXcTLRyMWeSWt5ta+y49+KlHt3IIa4Lf3g4FUFG/i7yLgxg
         GkSi3oZV/9UxMrbtNa8PlvHgBFetWgRS4KHCgV2Gj4AETCgtrh5uZdeTtJpwT7EnWL5H
         0m2fdM3qzXd2r0eiCM5Gl02zxdRSUOgrYLB9QpBwj40e8HJa/PN2IXGbBORXqfUBtKIJ
         LWEqfbbaXrnL0EddLAfjksD6cAyIhz9rj+pI7o2U3CgQjxA+Gfq0wZcjwppS5HhUsfyX
         lGoA==
X-Gm-Message-State: AOAM53382ATkHNT4iZRa+IAqD7GiGS7uSZzBldeeObkX63WwbaE3wUT3
        kMnaNxjSr08EoAvDQc1+YtjbMB/Nl0Urmw==
X-Google-Smtp-Source: ABdhPJwdXTh89cxZh8y4DurB3fIG4wXbtNNR3Vfkg/9hDvFH598gdD7NO84WhM8Mvqv5q2KG582jDg==
X-Received: by 2002:a17:902:e54f:b0:141:490d:4e62 with SMTP id n15-20020a170902e54f00b00141490d4e62mr2060704plf.5.1635402904216;
        Wed, 27 Oct 2021 23:35:04 -0700 (PDT)
Received: from localhost ([2405:201:6014:d916:31fc:9e49:a605:b093])
        by smtp.gmail.com with ESMTPSA id b8sm1973352pfi.103.2021.10.27.23.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 23:35:04 -0700 (PDT)
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
Subject: [PATCH bpf-next v5 0/8] Typeless/weak ksym for gen_loader + misc fixups
Date:   Thu, 28 Oct 2021 12:04:53 +0530
Message-Id: <20211028063501.2239335-1-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4259; h=from:subject; bh=3r6gvW4nslX/S5EpuJ9nHTKlEyz66eXOsbP9Tn04FpU=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhekR+iyyWwevJCTnYeHl1wu4vrJlUkFNTPX2l5gMa InBYKKmJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYXpEfgAKCRBM4MiGSL8RyuTeD/ 9eXFSWPxmiXAQxQFfxTrSmVfLbGlm49t0hJSf+KS8BUXIpUUxClqbytIPxwEWq17cVkVaaXgc1tW5j +1uRZLcNVW9XuwSnY3b6kSTWsT2OB8XUnrrQ+vQ7m8IcAmuVIOVFVe3hvzcd0VlyrPg7/kYZF/CY1n Z6qn7YFem1PwW95r/amps6ja4per3OJw7a5trfmqtefG6qZlHJ3Ij2/iDzXB6H7Wr3tNDJcnyJMk1M In2FcsU+YwjrI0P35iLh2LlHtu0XuYRLiSmUG4Nrv2CKdBj3TObc4pmEGXKgoxIrGOqedZuqZvsKqI gkJIWK/Cm/32XXXt163ms9FFXiI3/zWB8VeFhAOt9tFWdacvG0459UrZaD/27TxXF+bMFy93p+pGiu 3g+Xj+NKBmyYjXCwsFMN9Gl/pKfPrQUziv3hK1smM3EBe3NcgCLY28srYw5aI92GoybnSD86Sb/XzK 1ZP+PxRd33nj0WSBWUhmkGpR+dRRyGcDqGGG8xrSDDcVoIxB0UXaw6IKAxDqt44+ZtPRi5zmZrqqJn PhttVzZLdEw42/6RvH9BzK8D9WCA2GuJo2+lFMlC+BjTBa0Xvv/GfKNUsfNYP9fzvvQrMgyoNXYnGY fR3Uas6+jHRR/Z5WgP/ee8Q81Afjdf9c9qKFNay6P9n7Iw3hTJnSNO/HUxUQ==
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

Changelog:
----------
v4 -> v5
v4: https://lore.kernel.org/bpf/20211020191526.2306852-1-memxor@gmail.com

 * Address feedback from Andrii
   * Drop use of ensure_good_fd in unneeded call sites
   * Add sys_bpf_fd
   * Add _lskel suffix to all light skeletons and change all current selftests
   * Drop early break in close loop for sk_lookup
   * Fix other nits

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
 tools/lib/bpf/bpf.c                           |  35 +++--
 tools/lib/bpf/bpf_gen_internal.h              |  12 +-
 tools/lib/bpf/btf.c                           |   2 +-
 tools/lib/bpf/gen_loader.c                    | 132 ++++++++++++++++--
 tools/lib/bpf/libbpf.c                        |  19 ++-
 tools/lib/bpf/libbpf_internal.h               |  24 ++++
 tools/lib/bpf/libbpf_probes.c                 |   2 +-
 tools/lib/bpf/linker.c                        |   4 +-
 tools/lib/bpf/xsk.c                           |   6 +-
 tools/testing/selftests/bpf/Makefile          |   4 +-
 .../selftests/bpf/prog_tests/atomics.c        |  34 ++---
 .../selftests/bpf/prog_tests/fentry_fexit.c   |  16 +--
 .../selftests/bpf/prog_tests/fentry_test.c    |  14 +-
 .../selftests/bpf/prog_tests/fexit_sleep.c    |  12 +-
 .../selftests/bpf/prog_tests/fexit_test.c     |  14 +-
 .../selftests/bpf/prog_tests/kfunc_call.c     |   6 +-
 .../selftests/bpf/prog_tests/ksyms_btf.c      |  35 ++++-
 .../selftests/bpf/prog_tests/ksyms_module.c   |  40 +++++-
 .../bpf/prog_tests/ksyms_module_libbpf.c      |  28 ----
 .../selftests/bpf/prog_tests/ringbuf.c        |  12 +-
 .../selftests/bpf/prog_tests/sk_lookup.c      |   4 +-
 .../selftests/bpf/prog_tests/test_ima.c       |   3 +-
 .../selftests/bpf/prog_tests/trace_printk.c   |  14 +-
 .../selftests/bpf/prog_tests/trace_vprintk.c  |  12 +-
 .../selftests/bpf/prog_tests/verif_stats.c    |   6 +-
 .../selftests/bpf/progs/test_ksyms_weak.c     |   2 +-
 30 files changed, 393 insertions(+), 159 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c

-- 
2.33.1

