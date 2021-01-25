Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3297330218F
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 06:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbhAYFGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 00:06:44 -0500
Received: from mail.loongson.cn ([114.242.206.163]:36364 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725272AbhAYFGn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 00:06:43 -0500
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxSL6qUQ5gvboLAA--.17884S2;
        Mon, 25 Jan 2021 13:05:47 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>
Subject: [PATCH bpf-next v2] samples/bpf: Set flag __SANE_USERSPACE_TYPES__ for MIPS to fix build warnings
Date:   Mon, 25 Jan 2021 13:05:46 +0800
Message-Id: <1611551146-14052-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9DxSL6qUQ5gvboLAA--.17884S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZFyDZr1ktrW8ArW5Xw13urg_yoW5KF17pa
        n29rW7Cr4jvrW3GrW7Cr4I9w1fW398WFyDXFW8WryYv3W2gasYqr4DK3yaqrs5Wrs2va1S
        vry3KrW5Ja4rXw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1lc2xSY4AK67AK6r4rMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
        1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
        b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
        vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI
        42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
        evJa73UjIFyTuYvjfUeF4iUUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There exists many build warnings when make M=samples/bpf on the Loongson
platform, this issue is MIPS related, x86 compiles just fine.

Here are some warnings:

  CC  samples/bpf/ibumad_user.o
samples/bpf/ibumad_user.c: In function ‘dump_counts’:
samples/bpf/ibumad_user.c:46:24: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
    printf("0x%02x : %llu\n", key, value);
                     ~~~^          ~~~~~
                     %lu
  CC  samples/bpf/offwaketime_user.o
samples/bpf/offwaketime_user.c: In function ‘print_ksym’:
samples/bpf/offwaketime_user.c:34:17: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
   printf("%s/%llx;", sym->name, addr);
              ~~~^               ~~~~
              %lx
samples/bpf/offwaketime_user.c: In function ‘print_stack’:
samples/bpf/offwaketime_user.c:68:17: warning: format ‘%lld’ expects argument of type ‘long long int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
  printf(";%s %lld\n", key->waker, count);
              ~~~^                 ~~~~~
              %ld

MIPS needs __SANE_USERSPACE_TYPES__ before <linux/types.h> to select
'int-ll64.h' in arch/mips/include/uapi/asm/types.h, then it can avoid
build warnings when printing __u64 with %llu, %llx or %lld.

The header tools/include/linux/types.h defines __SANE_USERSPACE_TYPES__,
it seems that we can include <linux/types.h> in the source files which
have build warnings, but it has no effect due to actually it includes
usr/include/linux/types.h instead of tools/include/linux/types.h, the
problem is that "usr/include" is preferred first than "tools/include"
in samples/bpf/Makefile, that sounds like a ugly hack to -Itools/include
before -Iusr/include.

So define __SANE_USERSPACE_TYPES__ for MIPS in samples/bpf/Makefile
is proper, if add "TPROGS_CFLAGS += -D__SANE_USERSPACE_TYPES__" in
samples/bpf/Makefile, it appears the following error:

Auto-detecting system features:
...                        libelf: [ on  ]
...                          zlib: [ on  ]
...                           bpf: [ OFF ]

BPF API too old
make[3]: *** [Makefile:293: bpfdep] Error 1
make[2]: *** [Makefile:156: all] Error 2

With #ifndef __SANE_USERSPACE_TYPES__  in tools/include/linux/types.h,
the above error has gone and this ifndef change does not hurt other
compilations.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---

v2: Update the commit message

 samples/bpf/Makefile        | 4 ++++
 tools/include/linux/types.h | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 26fc96c..27de306 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -183,6 +183,10 @@ BPF_EXTRA_CFLAGS := $(ARM_ARCH_SELECTOR)
 TPROGS_CFLAGS += $(ARM_ARCH_SELECTOR)
 endif
 
+ifeq ($(ARCH), mips)
+TPROGS_CFLAGS += -D__SANE_USERSPACE_TYPES__
+endif
+
 TPROGS_CFLAGS += -Wall -O2
 TPROGS_CFLAGS += -Wmissing-prototypes
 TPROGS_CFLAGS += -Wstrict-prototypes
diff --git a/tools/include/linux/types.h b/tools/include/linux/types.h
index 154eb4e..e9c5a21 100644
--- a/tools/include/linux/types.h
+++ b/tools/include/linux/types.h
@@ -6,7 +6,10 @@
 #include <stddef.h>
 #include <stdint.h>
 
+#ifndef __SANE_USERSPACE_TYPES__
 #define __SANE_USERSPACE_TYPES__	/* For PPC64, to get LL64 types */
+#endif
+
 #include <asm/types.h>
 #include <asm/posix_types.h>
 
-- 
2.1.0

