Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE00142794B
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 12:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244697AbhJILAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 07:00:14 -0400
Received: from mail.loongson.cn ([114.242.206.163]:36344 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232161AbhJILAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 07:00:08 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxv2q0dWFhcgkXAA--.21276S3;
        Sat, 09 Oct 2021 18:58:00 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Paul Burton <paulburton@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [PATCH bpf-next 1/2] bpf, mips: Clean up config options about JIT
Date:   Sat,  9 Oct 2021 18:57:55 +0800
Message-Id: <1633777076-17256-2-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1633777076-17256-1-git-send-email-yangtiezhu@loongson.cn>
References: <1633777076-17256-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9Dxv2q0dWFhcgkXAA--.21276S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KF45XF1xCry7Ar1fGw4rZrb_yoW8Xw4kpw
        4Syan7GrykWFyrGrW8AFW7WFWYqr1vq3y2vFWq9ryUXasavF47Arnavw1jyFW7WrZrJ3W0
        gFWrWFnrA3sYkwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPG14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
        x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
        8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
        xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
        vE14v26r1Y6r17McIj6I8E87Iv67AKxVWxJVW8Jr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
        Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
        xKxwCY02Avz4vE14v_Gw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l
        x2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14
        v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IY
        x2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87
        Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIF
        yTuYvjfU5eOJUUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The config options MIPS_CBPF_JIT and MIPS_EBPF_JIT are useless, remove
them in arch/mips/Kconfig, and then modify arch/mips/net/Makefile.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 arch/mips/Kconfig      | 9 ---------
 arch/mips/net/Makefile | 6 +++---
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 38468f4..9b03c78 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1214,15 +1214,6 @@ config SYS_SUPPORTS_RELOCATABLE
 	  The platform must provide plat_get_fdt() if it selects CONFIG_USE_OF
 	  to allow access to command line and entropy sources.
 
-config MIPS_CBPF_JIT
-	def_bool y
-	depends on BPF_JIT && HAVE_CBPF_JIT
-
-config MIPS_EBPF_JIT
-	def_bool y
-	depends on BPF_JIT && HAVE_EBPF_JIT
-
-
 #
 # Endianness selection.  Sufficiently obscure so many users don't know what to
 # answer,so we try hard to limit the available choices.  Also the use of a
diff --git a/arch/mips/net/Makefile b/arch/mips/net/Makefile
index 95e8267..e3e6ae6 100644
--- a/arch/mips/net/Makefile
+++ b/arch/mips/net/Makefile
@@ -1,10 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
 # MIPS networking code
 
-obj-$(CONFIG_MIPS_EBPF_JIT) += bpf_jit_comp.o
+obj-$(CONFIG_BPF_JIT) += bpf_jit_comp.o
 
 ifeq ($(CONFIG_32BIT),y)
-        obj-$(CONFIG_MIPS_EBPF_JIT) += bpf_jit_comp32.o
+        obj-$(CONFIG_BPF_JIT) += bpf_jit_comp32.o
 else
-        obj-$(CONFIG_MIPS_EBPF_JIT) += bpf_jit_comp64.o
+        obj-$(CONFIG_BPF_JIT) += bpf_jit_comp64.o
 endif
-- 
2.1.0

