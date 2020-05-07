Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54FC11C7FA6
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 03:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgEGBFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 21:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728137AbgEGBFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 21:05:11 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A7CC061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 18:05:11 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id e6so1851926pjt.4
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 18:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id;
        bh=fDAxUkCWnLLNYKyqcom5jHpqbxcvX3Nwbyo0Ip8LuRk=;
        b=h3+IYrojdj8XrOT2yXppvSlG8FlwZRoZQROyHHbykmQH5tWOadvP0qK0EZc5qCfLI6
         IqjGPMkJRzQr+j+pWak8kvYgpGx4wUuuXT4NMxnU17wy8R779cxPMzCxmLH2fnU1Y8il
         x/zIrMjy3HjgIAu+PpqzTq5b3BIs9elVKsoUU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fDAxUkCWnLLNYKyqcom5jHpqbxcvX3Nwbyo0Ip8LuRk=;
        b=FWM0FhLnT7oGEV5z07+PFnJpBWwK3hX53kvB/nnXqMIZuwotaM4qjbVcpI0zOloYtM
         bxojbU69G8K0cs1LqR42IZuJKJUlVfM22/kQIRQSgq92C4Fc0NxhX+ov78iLz2eS6xyn
         rDCm14AursN8z+aJBx3R/95Gl/wzi3dnbTANOmir7Wu9vLpjEHeZxoR6TloCtbhwR4W8
         pd26d8LUuakzHkDdqZE/NsCfHsfniTB/Whw4Cojqk6DS0+4GjdHIaSUYcYGssF5q9rv0
         c3Cc2z126lSfq4FbpfZ81i2ueFWkAJ3fqDXZiaTPwaug5PPV3kxjg2jLMSxmWK5SC9x8
         6axw==
X-Gm-Message-State: AGi0PuaxWZDHB6gdH/sHIrkUK+JOAOgJF/22ZCORKY0B5zGSx01nLF9a
        0HIs5fS3ySjc1R8/KEPrp0FDyw==
X-Google-Smtp-Source: APiQypILpdn/n4nXzF+P/+vZkv7wDuleI/+evcTuS8G2sV3tj+B+qfsjlo61Cp/3MJ9nD2qqAg7YWA==
X-Received: by 2002:a17:90a:d153:: with SMTP id t19mr13166154pjw.42.1588813510513;
        Wed, 06 May 2020 18:05:10 -0700 (PDT)
Received: from localhost.localdomain (c-73-53-94-119.hsd1.wa.comcast.net. [73.53.94.119])
        by smtp.gmail.com with ESMTPSA id ev5sm6165250pjb.1.2020.05.06.18.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 18:05:09 -0700 (PDT)
From:   Luke Nelson <lukenels@cs.washington.edu>
X-Google-Original-From: Luke Nelson <luke.r.nels@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [RFC PATCH bpf-next 0/3] arm64 BPF JIT Optimizations
Date:   Wed,  6 May 2020 18:05:00 -0700
Message-Id: <20200507010504.26352-1-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series introduces several optimizations to the arm64 BPF JIT.
The optimizations make use of arm64 immediate instructions to avoid
loading BPF immediates to temporary registers, when possible.

In the process, we discovered two bugs in the logical immediate encoding
function in arch/arm64/kernel/insn.c using Serval. The series also fixes
the two bugs before introducing the optimizations.

Tested on aarch64 QEMU virt machine using test_bpf and test_verifier.

Luke Nelson (3):
  arm64: insn: Fix two bugs in encoding 32-bit logical immediates
  bpf, arm64: Optimize AND,OR,XOR,JSET BPF_K using arm64 logical
    immediates
  bpf, arm64: Optimize ADD,SUB,JMP BPF_K using arm64 add/sub immediates

 arch/arm64/kernel/insn.c      |  6 ++-
 arch/arm64/net/bpf_jit.h      | 22 +++++++++++
 arch/arm64/net/bpf_jit_comp.c | 73 ++++++++++++++++++++++++++++-------
 3 files changed, 85 insertions(+), 16 deletions(-)

Cc: Xi Wang <xi.wang@gmail.com>

-- 
2.17.1

