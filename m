Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B9145D278
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 02:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347757AbhKYBlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 20:41:24 -0500
Received: from mail.loongson.cn ([114.242.206.163]:50660 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234909AbhKYBjX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 20:39:23 -0500
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dx+NGI6J5hPTQBAA--.2223S2;
        Thu, 25 Nov 2021 09:36:08 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Xuefeng Li <lixuefeng@loongson.cn>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2] bpf, mips: Fix build errors about __NR_bpf undeclared
Date:   Thu, 25 Nov 2021 09:36:07 +0800
Message-Id: <1637804167-8323-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9Dx+NGI6J5hPTQBAA--.2223S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWryruFWxWryrXrW8Jw48Xrb_yoWrWrWxpr
        42kFy8tw1UGay7K34fZFWFqw43Jwn2yrWjqFWUu3ykCa1Fqa1fJr429rZ5CF1aqr4vva47
        ur13W345ury8Aw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
        4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
        Yx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbV
        WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK
        6w4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VU1ItC7UUUU
        U==
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the __NR_bpf definitions to fix the following build errors for mips.

 $ cd tools/bpf/bpftool
 $ make
 [...]
 bpf.c:54:4: error: #error __NR_bpf not defined. libbpf does not support your arch.
  #  error __NR_bpf not defined. libbpf does not support your arch.
     ^~~~~
 bpf.c: In function ‘sys_bpf’:
 bpf.c:66:17: error: ‘__NR_bpf’ undeclared (first use in this function); did you mean ‘__NR_brk’?
   return syscall(__NR_bpf, cmd, attr, size);
                  ^~~~~~~~
                  __NR_brk
 [...]
 In file included from gen_loader.c:15:0:
 skel_internal.h: In function ‘skel_sys_bpf’:
 skel_internal.h:53:17: error: ‘__NR_bpf’ undeclared (first use in this function); did you mean ‘__NR_brk’?
   return syscall(__NR_bpf, cmd, attr, size);
                  ^~~~~~~~
                  __NR_brk

We can see the following generated definitions:

 $ grep -r "#define __NR_bpf" arch/mips
 arch/mips/include/generated/uapi/asm/unistd_o32.h:#define __NR_bpf (__NR_Linux + 355)
 arch/mips/include/generated/uapi/asm/unistd_n64.h:#define __NR_bpf (__NR_Linux + 315)
 arch/mips/include/generated/uapi/asm/unistd_n32.h:#define __NR_bpf (__NR_Linux + 319)

The __NR_Linux is defined in arch/mips/include/uapi/asm/unistd.h:

 $ grep -r "#define __NR_Linux" arch/mips
 arch/mips/include/uapi/asm/unistd.h:#define __NR_Linux	4000
 arch/mips/include/uapi/asm/unistd.h:#define __NR_Linux	5000
 arch/mips/include/uapi/asm/unistd.h:#define __NR_Linux	6000

That is to say, __NR_bpf is
4000 + 355 = 4355 for mips o32,
6000 + 319 = 6319 for mips n32,
5000 + 315 = 5315 for mips n64.

So use the GCC pre-defined macro _ABIO32, _ABIN32 and _ABI64 [1] to define
the corresponding __NR_bpf.

This patch is similar with commit bad1926dd2f6 ("bpf, s390: fix build for
libbpf and selftest suite").

[1] https://gcc.gnu.org/git/?p=gcc.git;a=blob;f=gcc/config/mips/mips.h#l549

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---

v2: use a final number without __NR_Linux to define __NR_bpf
    suggested by Andrii Nakryiko, thank you.

 tools/build/feature/test-bpf.c |  6 ++++++
 tools/lib/bpf/bpf.c            |  6 ++++++
 tools/lib/bpf/skel_internal.h  | 10 ++++++++++
 3 files changed, 22 insertions(+)

diff --git a/tools/build/feature/test-bpf.c b/tools/build/feature/test-bpf.c
index 82070ea..727d22e 100644
--- a/tools/build/feature/test-bpf.c
+++ b/tools/build/feature/test-bpf.c
@@ -14,6 +14,12 @@
 #  define __NR_bpf 349
 # elif defined(__s390__)
 #  define __NR_bpf 351
+# elif defined(__mips__) && defined(_ABIO32)
+#  define __NR_bpf 4355
+# elif defined(__mips__) && defined(_ABIN32)
+#  define __NR_bpf 6319
+# elif defined(__mips__) && defined(_ABI64)
+#  define __NR_bpf 5315
 # else
 #  error __NR_bpf not defined. libbpf does not support your arch.
 # endif
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 94560ba..17f9fe2 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -50,6 +50,12 @@
 #  define __NR_bpf 351
 # elif defined(__arc__)
 #  define __NR_bpf 280
+# elif defined(__mips__) && defined(_ABIO32)
+#  define __NR_bpf 4355
+# elif defined(__mips__) && defined(_ABIN32)
+#  define __NR_bpf 6319
+# elif defined(__mips__) && defined(_ABI64)
+#  define __NR_bpf 5315
 # else
 #  error __NR_bpf not defined. libbpf does not support your arch.
 # endif
diff --git a/tools/lib/bpf/skel_internal.h b/tools/lib/bpf/skel_internal.h
index 9cf6670..064da66 100644
--- a/tools/lib/bpf/skel_internal.h
+++ b/tools/lib/bpf/skel_internal.h
@@ -7,6 +7,16 @@
 #include <sys/syscall.h>
 #include <sys/mman.h>
 
+#ifndef __NR_bpf
+# if defined(__mips__) && defined(_ABIO32)
+#  define __NR_bpf 4355
+# elif defined(__mips__) && defined(_ABIN32)
+#  define __NR_bpf 6319
+# elif defined(__mips__) && defined(_ABI64)
+#  define __NR_bpf 5315
+# endif
+#endif
+
 /* This file is a base header for auto-generated *.lskel.h files.
  * Its contents will change and may become part of auto-generation in the future.
  *
-- 
2.1.0

