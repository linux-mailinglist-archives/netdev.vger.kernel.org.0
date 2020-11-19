Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B5A2B95B6
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 16:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgKSPGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 10:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgKSPGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 10:06:31 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD106C0613CF;
        Thu, 19 Nov 2020 07:06:30 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id g7so4767690pfc.2;
        Thu, 19 Nov 2020 07:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b1iMvdFarHnzQg6C8XPNfQu8ZLCVHwVNqqrW/LV5ijc=;
        b=nTfaqu75TMgOVldXLUhLAYkhDG8c7PcyDGf7tPGDDzPQRgrmtsSqIM/YNOm0xxo3Ph
         uMN1cJNIFFC3I8RVCBqWrraDk+BFd83zrqBwL8xlhpbR9t5v0zc/A+TS+SffgqcOEM/H
         /WrfeBDpINfco5W5CGy2QnzycMRZ7Rsf9O/MtTd9noTXpzfWvR6MvMRbs+hSCwJ8TGYr
         HDWx+xI2kWHr61Jpnz5C4Zic1ds2Q59iUHqYLh1/sPDxFkEitAnwYhK5lAhNwl2893E4
         5S2GR/pbLdSAVQ6iLTkGUdB+TZbpe7yPaiSGPHYQVwIe1BRLzV1EsKtXmHOr92vZdn+S
         KWwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b1iMvdFarHnzQg6C8XPNfQu8ZLCVHwVNqqrW/LV5ijc=;
        b=W1wZK6juzAZ4j+wikWFHMHwGDVsdR87L7A4kwvN19bkEtB0enOIf7WlvSnHmMSdjLi
         YTLP8vA/dSE1CXpudV8sZkWHzvr91xzUWqlX1Dr6TWxs8re2gC6Pq9OkVsLPQOY5WoqI
         cVXGiK/YYSnpVqDg1y48zEVsc0TuHlUBDCiLnTWPTvd+UHnlCfzmIdowTVtMKjhWr79v
         HvcyKLfAT1D3a77OwBhwOeVxbvUH6+VZNijz1LTAL2QMnLmCBAE3ynTAXSFxZs7TDhUr
         hhNcZFL+EBPv3+jLkmgztpuXM/23lEp0rFXyOdkP8lqi3YSIyvc3LOexSlVGgwgqLojX
         Mr5w==
X-Gm-Message-State: AOAM533BpnM72OXS6QwfTdeI9dFn9Sfv91xASUfN97Tm3PZW+AIWJ8mM
        tnVpYhzA15wqj3kvCIaWBw==
X-Google-Smtp-Source: ABdhPJwhZL03zRCitPKU3FrV0B2he21J+9gTJ8LKcmFzCdo2d9z1JIW+gtVfrMeQs7UJvcOYmOMaMA==
X-Received: by 2002:a17:90b:100f:: with SMTP id gm15mr4597598pjb.63.1605798390266;
        Thu, 19 Nov 2020 07:06:30 -0800 (PST)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id b80sm77783pfb.40.2020.11.19.07.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 07:06:29 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: [PATCH bpf-next v2 0/7] bpf: remove bpf_load loader completely
Date:   Thu, 19 Nov 2020 15:06:10 +0000
Message-Id: <20201119150617.92010-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Numerous refactoring that rewrites BPF programs written with bpf_load
to use the libbpf loader was finally completed, resulting in BPF
programs using bpf_load within the kernel being completely no longer
present.

This patchset refactors remaining bpf programs with libbpf and
completely removes bpf_load, an outdated bpf loader that is difficult
to keep up with the latest kernel BPF and causes confusion.

Changes in v2:
 - drop 'move tracing helpers to trace_helper' patch
 - add link pinning to prevent cleaning up on process exit
 - add static at global variable and remove unused variable
 - change to destroy link even after link__pin()
 - fix return error code on exit
 - merge commit with changing Makefile

Daniel T. Lee (7):
  samples: bpf: refactor hbm program with libbpf
  samples: bpf: refactor test_cgrp2_sock2 program with libbpf
  samples: bpf: refactor task_fd_query program with libbpf
  samples: bpf: refactor ibumad program with libbpf
  samples: bpf: refactor test_overhead program with libbpf
  samples: bpf: fix lwt_len_hist reusing previous BPF map
  samples: bpf: remove bpf_load loader completely

 samples/bpf/.gitignore           |   3 +
 samples/bpf/Makefile             |  20 +-
 samples/bpf/bpf_load.c           | 667 -------------------------------
 samples/bpf/bpf_load.h           |  57 ---
 samples/bpf/do_hbm_test.sh       |  32 +-
 samples/bpf/hbm.c                | 106 ++---
 samples/bpf/hbm_kern.h           |   2 +-
 samples/bpf/ibumad_kern.c        |  26 +-
 samples/bpf/ibumad_user.c        |  71 +++-
 samples/bpf/lwt_len_hist.sh      |   2 +
 samples/bpf/task_fd_query_user.c | 101 +++--
 samples/bpf/test_cgrp2_sock2.c   |  61 ++-
 samples/bpf/test_cgrp2_sock2.sh  |  21 +-
 samples/bpf/test_lwt_bpf.sh      |   0
 samples/bpf/test_overhead_user.c |  82 ++--
 samples/bpf/xdp2skb_meta_kern.c  |   2 +-
 16 files changed, 345 insertions(+), 908 deletions(-)
 delete mode 100644 samples/bpf/bpf_load.c
 delete mode 100644 samples/bpf/bpf_load.h
 mode change 100644 => 100755 samples/bpf/lwt_len_hist.sh
 mode change 100644 => 100755 samples/bpf/test_lwt_bpf.sh

-- 
2.25.1

