Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FB83605D3
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 11:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbhDOJeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 05:34:05 -0400
Received: from foss.arm.com ([217.140.110.172]:41266 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231960AbhDOJeD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 05:34:03 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 58113106F;
        Thu, 15 Apr 2021 02:33:40 -0700 (PDT)
Received: from net-arm-thunderx2-02.shanghai.arm.com (net-arm-thunderx2-02.shanghai.arm.com [10.169.208.215])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 225E33F694;
        Thu, 15 Apr 2021 02:33:22 -0700 (PDT)
From:   Jianlin Lv <Jianlin.Lv@arm.com>
To:     bpf@vger.kernel.org
Cc:     corbet@lwn.net, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org, illusionist.neo@gmail.com, linux@armlinux.org.uk,
        zlim.lnx@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        paulburton@kernel.org, tsbogend@alpha.franken.de,
        naveen.n.rao@linux.ibm.com, sandipan@linux.ibm.com,
        mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        luke.r.nels@gmail.com, xi.wang@gmail.com, bjorn@kernel.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, iii@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, udknight@gmail.com,
        mchehab+huawei@kernel.org, dvyukov@google.com, maheshb@google.com,
        horms@verge.net.au, nicolas.dichtel@6wind.com,
        viro@zeniv.linux.org.uk, masahiroy@kernel.org,
        keescook@chromium.org, quentin@isovalent.com, tklauser@distanz.ch,
        grantseltzer@gmail.com, irogers@google.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, Jianlin.Lv@arm.com, iecedge@gmail.com
Subject: [PATCH bpf-next 2/2] docs: bpf: bpf_jit_enable mode changed
Date:   Thu, 15 Apr 2021 17:32:50 +0800
Message-Id: <20210415093250.3391257-2-Jianlin.Lv@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210415093250.3391257-1-Jianlin.Lv@arm.com>
References: <20210415093250.3391257-1-Jianlin.Lv@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove information about bpf_jit_enable=2 mode and added description for
how to use the bpf_jit_disasm tool after get rid of =2 mode.

Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
---
 Documentation/admin-guide/sysctl/net.rst |  1 -
 Documentation/networking/filter.rst      | 25 ++++++------------------
 2 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index c941b214e0b7..a39f99deac38 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -86,7 +86,6 @@ Values:
 
 	- 0 - disable the JIT (default value)
 	- 1 - enable the JIT
-	- 2 - enable the JIT and ask the compiler to emit traces on kernel log.
 
 bpf_jit_harden
 --------------
diff --git a/Documentation/networking/filter.rst b/Documentation/networking/filter.rst
index 251c6bd73d15..86954f922168 100644
--- a/Documentation/networking/filter.rst
+++ b/Documentation/networking/filter.rst
@@ -504,25 +504,12 @@ been previously enabled by root::
 
   echo 1 > /proc/sys/net/core/bpf_jit_enable
 
-For JIT developers, doing audits etc, each compile run can output the generated
-opcode image into the kernel log via::
-
-  echo 2 > /proc/sys/net/core/bpf_jit_enable
-
-Example output from dmesg::
-
-    [ 3389.935842] flen=6 proglen=70 pass=3 image=ffffffffa0069c8f
-    [ 3389.935847] JIT code: 00000000: 55 48 89 e5 48 83 ec 60 48 89 5d f8 44 8b 4f 68
-    [ 3389.935849] JIT code: 00000010: 44 2b 4f 6c 4c 8b 87 d8 00 00 00 be 0c 00 00 00
-    [ 3389.935850] JIT code: 00000020: e8 1d 94 ff e0 3d 00 08 00 00 75 16 be 17 00 00
-    [ 3389.935851] JIT code: 00000030: 00 e8 28 94 ff e0 83 f8 01 75 07 b8 ff ff 00 00
-    [ 3389.935852] JIT code: 00000040: eb 02 31 c0 c9 c3
-
-When CONFIG_BPF_JIT_ALWAYS_ON is enabled, bpf_jit_enable is permanently set to 1 and
-setting any other value than that will return in failure. This is even the case for
-setting bpf_jit_enable to 2, since dumping the final JIT image into the kernel log
-is discouraged and introspection through bpftool (under tools/bpf/bpftool/) is the
-generally recommended approach instead.
+When CONFIG_BPF_JIT_ALWAYS_ON is enabled, bpf_jit_enable is permanently set
+to 1 and setting any other value than that will return in failure.
+For debugging JITs, the introspection through bpftool (tools/bpf/bpftool/)
+is the generally recommended approach instead. For JIT developers, doing
+audits etc, you can insert bpf_jit_dump() and recompile the kernel to
+output the generated opcode image into the kernel log.
 
 In the kernel source tree under tools/bpf/, there's bpf_jit_disasm for
 generating disassembly out of the kernel log's hexdump::
-- 
2.25.1

