Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2080C17696E
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 01:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgCCAum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 19:50:42 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40399 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgCCAul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 19:50:41 -0500
Received: by mail-pg1-f194.google.com with SMTP id t24so666320pgj.7
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 16:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3D53AC+mvbtFOvWhCdqdKfZxPLHDl2gFgUFn+w2hIMI=;
        b=PpAHUPt4FCpGWNJvv2H+zWoZ/LA1u2BGY9BD6oYuRZ082FfiQItrhfnvk6zxQw5bV0
         S1SqJIvNF4X08qwdo9WXxJfSPlA+HpuXz9dDX83mfanb7Cea9/VK1Osaqx3OT2+cBMrb
         DKheoeY/V9en1FOiSSqFrlw3IyYNvxiMbJMyc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3D53AC+mvbtFOvWhCdqdKfZxPLHDl2gFgUFn+w2hIMI=;
        b=Xyh5P+J1vvcKZb5mzQVFXvmtuZRrNg0rSMTc062Jmd+pIsEr9z/0pjBUfpD2TX9cT3
         F1G1PSNnfTaQmTOpzWsT26AI80aUIzt5yaGA4p6iRLCrbNeWPbxjn40UY6G3GebrGsZ7
         Vv/UfPurWXgX98D9X85K/qXQFmjKTVU2tvY1YN1egnNiZTAyibZMyjgR6TEVDH9/6d3s
         b1oIvWbhmOBBA3KcYRiaE/rEDGNw9cSTX5StTWQa8fyfJsxERKG2I+A7e0ngWHOH1B5h
         530ayyYyJ6mQjPrxcCs2euNQTpa0WaOIeaLwzgKebsqzTtdIFuyQ5dIazASTHJfiAdxJ
         niBQ==
X-Gm-Message-State: ANhLgQ3ZOPvPld7nVVZ2ykW7XdRi0l5GyqI/gHWhuT2AD8HrmnJ4vl9t
        BFxeZWHaJVOzlZqvPOF+Y8Ww9w==
X-Google-Smtp-Source: ADFU+vu5i1xpepiSeDF6CXGaG9tUWLD/lfAtDAgCi5AnBUm0RKEt53xDaBdP3NJys5zaFri5Xz/k4g==
X-Received: by 2002:a63:131f:: with SMTP id i31mr1588034pgl.101.1583196639743;
        Mon, 02 Mar 2020 16:50:39 -0800 (PST)
Received: from ryzen.cs.washington.edu ([2607:4000:200:11:b5cd:49c6:f4f6:8295])
        by smtp.gmail.com with ESMTPSA id c15sm357529pja.30.2020.03.02.16.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 16:50:38 -0800 (PST)
From:   Luke Nelson <lukenels@cs.washington.edu>
X-Google-Original-From: Luke Nelson <luke.r.nels@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: [PATCH bpf-next v4 0/4] eBPF JIT for RV32G
Date:   Mon,  2 Mar 2020 16:50:31 -0800
Message-Id: <20200303005035.13814-1-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds an eBPF JIT for 32-bit RISC-V (RV32G) to the kernel,
adapted from the RV64 JIT and the 32-bit ARM JIT.

There are two main changes required for this to work compared to
the RV64 JIT.

First, eBPF registers are 64-bit, while RV32G registers are 32-bit.
BPF registers either map directly to 2 RISC-V registers, or reside
in stack scratch space and are saved and restored when used.

Second, many 64-bit ALU operations do not trivially map to 32-bit
operations. Operations that move bits between high and low words,
such as ADD, LSH, MUL, and others must emulate the 64-bit behavior
in terms of 32-bit instructions.

Supported features:

The RV32 JIT supports the same features and instructions as the
RV64 JIT, with the following exceptions:

- ALU64 DIV/MOD: Requires loops to implement on 32-bit hardware.

- BPF_XADD | BPF_DW: There's no 8-byte atomic instruction in RV32.

These features are also unsupported on other BPF JITs for 32-bit
architectures.

Testing:

- lib/test_bpf.c
test_bpf: Summary: 378 PASSED, 0 FAILED, [349/366 JIT'ed]
test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED

- tools/testing/selftests/bpf/test_verifier.c
Summary: 1415 PASSED, 122 SKIPPED, 43 FAILED

Tested both with and without BPF JIT hardening.

This is the same set of tests that pass using the BPF interpreter
with the JIT disabled.

Running the BPF kernel tests / selftests on riscv32 is non-trivial,
to help others reproduce the test results I made a guide here:
https://github.com/lukenels/meta-linux-utils/tree/master/rv32-linux

Verification and synthesis:

We developed the RV32 JIT using our automated verification tool,
Serval. We have used Serval in the past to verify patches to the
RV64 JIT. We also used Serval to superoptimize the resulting code
through program synthesis.

You can find the tool and a guide to the approach and results here:
https://github.com/uw-unsat/serval-bpf/tree/rv32-jit-v4

Thanks again for all the comments!

Changelog:

v3 -> v4:
  * Added more comments and cleaned up style nits (Björn Töpel).
  * Factored common code in RV64 and RV32 JITs into a separate header
    (Song Liu, Björn Töpel).
  * Added an optimization in the BPF_ALU64 BPF_ADD BPF_X case.
  * Updated MAINTAINERS and kernel documentation (Björn Töpel).

v2 -> v3:
  * Added support for far jumps / branches similar to RV64 JIT.
  * Added support for tail calls.
  * Cleaned up code with more optimizations and comments.
  * Removed special zero-extension instruction from BPF_ALU64
    case (Jiong Wang).

v1 -> v2:
  * Added support for far conditional branches.
  * Added the zero-extension optimization (Jiong Wang).
  * Added more optimizations for operations with an immediate operand.

Luke Nelson (4):
  riscv, bpf: move common riscv JIT code to header
  riscv, bpf: add RV32G eBPF JIT
  bpf, doc: add BPF JIT for RV32G to BPF documentation
  MAINTAINERS: Add entry for RV32G BPF JIT

 Documentation/admin-guide/sysctl/net.rst |    3 +-
 Documentation/networking/filter.txt      |    2 +-
 MAINTAINERS                              |   13 +-
 arch/riscv/Kconfig                       |    2 +-
 arch/riscv/net/Makefile                  |    7 +-
 arch/riscv/net/bpf_jit.h                 |  504 ++++++++
 arch/riscv/net/bpf_jit_comp.c            |  443 +------
 arch/riscv/net/bpf_jit_comp32.c          | 1466 ++++++++++++++++++++++
 8 files changed, 1992 insertions(+), 448 deletions(-)
 create mode 100644 arch/riscv/net/bpf_jit.h
 create mode 100644 arch/riscv/net/bpf_jit_comp32.c

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: "Björn Töpel" <bjorn.topel@gmail.com>
Cc: Luke Nelson <luke.r.nels@gmail.com>
Cc: Xi Wang <xi.wang@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: linux-riscv@lists.infradead.org

-- 
2.20.1

