Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E60645B70E
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 10:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241004AbhKXJDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 04:03:44 -0500
Received: from mail.loongson.cn ([114.242.206.163]:37608 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240975AbhKXJDl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 04:03:41 -0500
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Axl+gq_51hSfAAAA--.4428S2;
        Wed, 24 Nov 2021 17:00:27 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next] bpf, mips: Fix build errors about __NR_bpf undeclared
Date:   Wed, 24 Nov 2021 17:00:26 +0800
Message-Id: <1637744426-22044-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9Axl+gq_51hSfAAAA--.4428S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWryruFWxWryrXrW8Jw48Xrb_yoW5Kw4Dpr
        42kFy8tw1UGa17K34fZFWFqw43Jwn2yrWjvFWUCws7CFW5Ja1xGr4jvFZ5CF4aqr4vva47
        ur15G345ury8Aw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkIb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4
        vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY02Avz4vE14v_GFWl42xK
        82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGw
        C20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48J
        MIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMI
        IF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
        x4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU5dGYtUUUUU==
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

So use the GCC pre-defined macro _ABIO32, _ABIN32 and _ABI64 [1] to define
the corresponding __NR_bpf.

This patch is similar with commit bad1926dd2f6 ("bpf, s390: fix build for
libbpf and selftest suite").

[1] https://gcc.gnu.org/git/?p=gcc.git;a=blob;f=gcc/config/mips/mips.h#l549

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 tools/build/feature/test-bpf.c |  6 ++++++
 tools/lib/bpf/bpf.c            |  6 ++++++
 tools/lib/bpf/skel_internal.h  | 10 ++++++++++
 3 files changed, 22 insertions(+)

diff --git a/tools/build/feature/test-bpf.c b/tools/build/feature/test-bpf.c
index 82070ea..ebc7a2a 100644
--- a/tools/build/feature/test-bpf.c
+++ b/tools/build/feature/test-bpf.c
@@ -14,6 +14,12 @@
 #  define __NR_bpf 349
 # elif defined(__s390__)
 #  define __NR_bpf 351
+# elif defined(__mips__) && defined(_ABIO32)
+#  define __NR_bpf (__NR_Linux + 355)
+# elif defined(__mips__) && defined(_ABIN32)
+#  define __NR_bpf (__NR_Linux + 319)
+# elif defined(__mips__) && defined(_ABI64)
+#  define __NR_bpf (__NR_Linux + 315)
 # else
 #  error __NR_bpf not defined. libbpf does not support your arch.
 # endif
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 94560ba..60422404 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -50,6 +50,12 @@
 #  define __NR_bpf 351
 # elif defined(__arc__)
 #  define __NR_bpf 280
+# elif defined(__mips__) && defined(_ABIO32)
+#  define __NR_bpf (__NR_Linux + 355)
+# elif defined(__mips__) && defined(_ABIN32)
+#  define __NR_bpf (__NR_Linux + 319)
+# elif defined(__mips__) && defined(_ABI64)
+#  define __NR_bpf (__NR_Linux + 315)
 # else
 #  error __NR_bpf not defined. libbpf does not support your arch.
 # endif
diff --git a/tools/lib/bpf/skel_internal.h b/tools/lib/bpf/skel_internal.h
index 9cf6670..6ff4939 100644
--- a/tools/lib/bpf/skel_internal.h
+++ b/tools/lib/bpf/skel_internal.h
@@ -7,6 +7,16 @@
 #include <sys/syscall.h>
 #include <sys/mman.h>
 
+#ifndef __NR_bpf
+# if defined(__mips__) && defined(_ABIO32)
+#  define __NR_bpf (__NR_Linux + 355)
+# elif defined(__mips__) && defined(_ABIN32)
+#  define __NR_bpf (__NR_Linux + 319)
+# elif defined(__mips__) && defined(_ABI64)
+#  define __NR_bpf (__NR_Linux + 315)
+# endif
+#endif
+
 /* This file is a base header for auto-generated *.lskel.h files.
  * Its contents will change and may become part of auto-generation in the future.
  *
-- 
2.1.0

