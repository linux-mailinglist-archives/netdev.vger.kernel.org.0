Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9F643E1E8
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbhJ1NXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:23:13 -0400
Received: from mail-lj1-f181.google.com ([209.85.208.181]:33746 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhJ1NXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 09:23:13 -0400
Received: by mail-lj1-f181.google.com with SMTP id 17so7520108ljq.0;
        Thu, 28 Oct 2021 06:20:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tV3/PwR5VpxbTSpUyiluLuIWKfFd+0GUhLTj4B2BabA=;
        b=XVno5Xsq181pRPOlL1ZzwLEMPkvEoDkYWngmCxcq2PUf/coFwOE9VIsIUG4siN/Kmt
         3nS/KPISuDvxABs/+JhLHPaK5VI1x0aP9xK+mVrMOYFPDVAZA82wOeU/LHTSNrO23z2h
         SOoaCSy+5Wr9mAWSvhN7m7JPeMi57TqiGcEP/6/l+Aa4osyOGwYIl8LcKRpGCOKb41Eb
         u56IBKd8bTNXF3r12swsOAXkyjEfiH4XgwHO/ofmVWjy0onmZpMMj2ToY3l02Fx311nO
         RfM2mnLZUHiUoS00G28FXJVU79OdK1V6UA7I+L8tbTbsa8Ttxp4/1zKjg5z4fh9cYHnr
         DOTQ==
X-Gm-Message-State: AOAM5313CbIKCcXpQeWPHbYlb6LUmWgg+oNpNkINgk0SiCWw4/xeMd/t
        Xi9osXw3dlMtHPq4qYFluxVmRqOUGvY=
X-Google-Smtp-Source: ABdhPJxYlGkAp5YfgykTL+OJPSVAqgl4GZXQLle35EobOrAUTuaWxVUdSIobaRXPItg1SLgSd2jolA==
X-Received: by 2002:a2e:82d5:: with SMTP id n21mr4673656ljh.6.1635427244950;
        Thu, 28 Oct 2021 06:20:44 -0700 (PDT)
Received: from kladdkakan.. ([185.213.154.234])
        by smtp.gmail.com with ESMTPSA id o9sm309616lfk.292.2021.10.28.06.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 06:20:44 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH bpf-next 0/4] Various RISC-V BPF improvements
Date:   Thu, 28 Oct 2021 15:20:37 +0200
Message-Id: <20211028132041.516820-1-bjorn@kernel.org>
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

Björn Töpel (4):
  riscv, bpf: Increase the maximum number of iterations
  tools build: Add RISC-V to HOSTARCH parsing
  riscv, libbpf: Add RISC-V (RV64) support to bpf_tracing.h
  selftests/bpf: Fix broken riscv build

 arch/riscv/net/bpf_jit_core.c        |  2 +-
 tools/lib/bpf/bpf_tracing.h          | 32 ++++++++++++++++++++++++++++
 tools/scripts/Makefile.arch          |  3 ++-
 tools/testing/selftests/bpf/Makefile |  3 ++-
 4 files changed, 37 insertions(+), 3 deletions(-)


base-commit: b066abba3ef16a4a085d237e95da0de3f0b87713
-- 
2.32.0

