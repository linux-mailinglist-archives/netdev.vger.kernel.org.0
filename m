Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6566843E5CC
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 18:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhJ1QNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 12:13:32 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:44996 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhJ1QNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 12:13:32 -0400
Received: by mail-lf1-f41.google.com with SMTP id y26so14604043lfa.11;
        Thu, 28 Oct 2021 09:11:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FvbhACnEYV1022Gk5eA/3v6HqT63c7KWu84vs0/IVbY=;
        b=DVP9AFK6t2RLd+8zPyBtWwyYgoK3wO8SIrVrML7U45WHT5AtUQk+iiK6XXOOqUUeeJ
         9Z53RCCmgbpVmjHztiNQ/eTtgoAHRR52/btT7vkvj+a/KC3inW9iisnlspjTdqDSqNGo
         Z/ZnmmD4rkOKqX1Zh6g7qpNED2zpQdrsg9yY5r3IaKoteshtVy0sckxdLrzOkmf1ErDx
         oGpzNHg7ZCyfFT/KSMnOMe0IZe3zcyYQdEZaiC7GWZ+rOe55Nlt/rH80P8tYnL8GSIIZ
         P0JbBNKqfkFnDNG66yIp9uq3tyHyGI2Z3xk8jZVYN8rpTW15TdqZBNjzgN67hx1w5nRB
         e+jQ==
X-Gm-Message-State: AOAM5317LPIk+0fVr405r1jR/jIqBLCcb7cI5oVryO8vqMlBxR/6Nx0h
        3o7ZUoWCf8BrWGbcRZF+e40=
X-Google-Smtp-Source: ABdhPJxzQ6+RW6xoki+y/0taUmPzC2/z2+vGdooU8FzF9JjLc2mfl3w6n/6unuLu8TcuuwjRX6K05w==
X-Received: by 2002:ac2:4e15:: with SMTP id e21mr5274403lfr.655.1635437464097;
        Thu, 28 Oct 2021 09:11:04 -0700 (PDT)
Received: from kladdkakan.. ([193.138.218.162])
        by smtp.gmail.com with ESMTPSA id o17sm49680lfo.176.2021.10.28.09.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 09:11:03 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        luke.r.nels@gmail.com, xi.wang@gmail.com,
        linux-riscv@lists.infradead.org
Subject: [PATCH bpf-next v2 0/4] Various RISC-V BPF improvements
Date:   Thu, 28 Oct 2021 18:10:53 +0200
Message-Id: <20211028161057.520552-1-bjorn@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unfortunately selftest/bpf does not build for RV64. This series fixes
that.

* JIT requires more iterations to converge
* Some Makefile issues
* bpf_tracing.h was missing RISC-V macros for PT_REGS

More details are in each commit.

There are still many failing tests, but this is a start.


Cheers,
Björn

v1->v2: A newline sneaked into the Makefile for patch 4, which broke the build. Removed.

Björn Töpel (4):
  riscv, bpf: Increase the maximum number of iterations
  tools build: Add RISC-V to HOSTARCH parsing
  riscv, libbpf: Add RISC-V (RV64) support to bpf_tracing.h
  selftests/bpf: Fix broken riscv build

 arch/riscv/net/bpf_jit_core.c        |  2 +-
 tools/lib/bpf/bpf_tracing.h          | 32 ++++++++++++++++++++++++++++
 tools/scripts/Makefile.arch          |  3 ++-
 tools/testing/selftests/bpf/Makefile |  2 +-
 4 files changed, 36 insertions(+), 3 deletions(-)


base-commit: b066abba3ef16a4a085d237e95da0de3f0b87713
-- 
2.32.0

