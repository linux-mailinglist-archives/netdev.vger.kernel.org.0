Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657344A7240
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 14:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238147AbiBBNxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 08:53:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35167 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229529AbiBBNxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 08:53:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643810017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=eoBEdHsWn1QD68AtpyuWojbCmpscK/IojyHyc83t4H4=;
        b=Kyg41tsyHLBnmnxineNG5CpHXa6hSr+hnUy8sC6uvTVhvLMsbVYiAruj36N1uX5ivhW51P
        84VMPHNGbLV3XVHfF9zVJOWcLeNWQb/FX3s4S3y1mxPXDmUpNR4MKfEJItdHGj8/IhSeYC
        0GyDzcDPEG8nE54WPTRFJCEg/Cmcsu8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-gu83IQUaN2qx7ef3pzVPRA-1; Wed, 02 Feb 2022 08:53:36 -0500
X-MC-Unique: gu83IQUaN2qx7ef3pzVPRA-1
Received: by mail-ed1-f69.google.com with SMTP id en7-20020a056402528700b00404aba0a6ffso10436457edb.5
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 05:53:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eoBEdHsWn1QD68AtpyuWojbCmpscK/IojyHyc83t4H4=;
        b=e7E2RFaRrQ4cx7DdazhwtH63sXY0SMdO+Kt2PevATRqvfnzctx4B7YqLAKcRB+KbPp
         s0Jdc2bjvQoLtNHOlml9I4zrqaKSUdfJIGHfol9eXR9yjRALiTCyaogei3Jtufe2XyCz
         qq53I2Te9b7Gbyc07vaxEnTvB7qHnGQ3ZLE45cR4wv4ghZZHrd/FsFzrEROYMNdGxo46
         Wi/Ugds85SAGer8hpsixQrdVjkDwitlLBQU+Q2+9mnpuXuzJFvWipCVcsE1J0YhDNij4
         BNNXPumU45pifwiEGxa+IP+j89LQW8SSoyVC1yMyfM1LbqZAjcbmONzctrBHA8Pf/RfQ
         1lMw==
X-Gm-Message-State: AOAM533XtiY5I5zz2mEWHt37h0xbH6XW0HpPCDHs/x+9dYTJxOXqm/nq
        J4QBHvWc3PSvCeBxYyxM1qzIsL3ZjIXFuTDi5pv8pZKIrk4O7ij6ibL4DVaatbtKpbp7NC+xKje
        IuCxhorq7nC6x5Jox
X-Received: by 2002:a17:907:d04:: with SMTP id gn4mr20014764ejc.86.1643810014727;
        Wed, 02 Feb 2022 05:53:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx0ihpwMn3oeTT6GSsLeNjEcThx+Ms7gLQ06aOCGXUesXTCBrEMC4UM29cpjBQ86+98ggGceg==
X-Received: by 2002:a17:907:d04:: with SMTP id gn4mr20014745ejc.86.1643810014525;
        Wed, 02 Feb 2022 05:53:34 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id fn3sm15672986ejc.47.2022.02.02.05.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 05:53:34 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>
Subject: [PATCH 0/8] bpf: Add fprobe link
Date:   Wed,  2 Feb 2022 14:53:25 +0100
Message-Id: <20220202135333.190761-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
this patchset adds new link type BPF_LINK_TYPE_FPROBE that attaches kprobe
program through fprobe API [1] instroduced by Masami.

The fprobe API allows to attach probe on multiple functions at once very
fast, because it works on top of ftrace. On the other hand this limits
the probe point to the function entry or return.

With bpftrace support I see following attach speed:

  # perf stat --null -r 5 ./src/bpftrace -e 'kprobe:x* { } i:ms:1 { exit(); } '
  Attaching 2 probes...
  Attaching 3342 functions
  ...

  1.4960 +- 0.0285 seconds time elapsed  ( +-  1.91% )

Also available at:
  https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  bpf/fprobe_link

thanks,
jirka


[1] https://lore.kernel.org/bpf/20220202162925.bd74e7970fc35cb4236eef48@kernel.org/T/#t
---
Jiri Olsa (8):
      bpf: Add support to attach kprobe program with fprobe
      bpf: Add bpf_get_func_ip kprobe helper for fprobe link
      bpf: Add bpf_cookie support to fprobe
      libbpf: Add libbpf__kallsyms_parse function
      libbpf: Add bpf_link_create support for multi kprobes
      libbpf: Add bpf_program__attach_kprobe_opts for multi kprobes
      selftest/bpf: Add fprobe attach test
      selftest/bpf: Add fprobe test for bpf_cookie values

 include/linux/bpf.h                                   |   2 +
 include/linux/bpf_types.h                             |   1 +
 include/uapi/linux/bpf.h                              |  14 +++++
 kernel/bpf/syscall.c                                  | 327 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/bpf/verifier.c                                 |  19 +++++-
 kernel/trace/bpf_trace.c                              |  32 +++++++++-
 tools/include/uapi/linux/bpf.h                        |  14 +++++
 tools/lib/bpf/bpf.c                                   |   7 +++
 tools/lib/bpf/bpf.h                                   |   9 ++-
 tools/lib/bpf/libbpf.c                                | 198 +++++++++++++++++++++++++++++++++++++++++++++++++++--------
 tools/lib/bpf/libbpf_internal.h                       |   5 ++
 tools/testing/selftests/bpf/prog_tests/bpf_cookie.c   |  73 ++++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/fprobe_test.c  | 117 +++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/fprobe.c            |  58 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/fprobe_bpf_cookie.c |  62 +++++++++++++++++++
 15 files changed, 902 insertions(+), 36 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fprobe_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/fprobe.c
 create mode 100644 tools/testing/selftests/bpf/progs/fprobe_bpf_cookie.c

