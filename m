Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF5442847D
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbhJKBVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:21:23 -0400
Received: from mail.loongson.cn ([114.242.206.163]:34096 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230218AbhJKBVW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 21:21:22 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxP2oPkWNh8sYXAA--.22187S3;
        Mon, 11 Oct 2021 09:19:12 +0800 (CST)
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
Subject: [PATCH bpf-next v2 1/2] bpf, mips: Clean up config options about JIT
Date:   Mon, 11 Oct 2021 09:19:09 +0800
Message-Id: <1633915150-13220-2-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1633915150-13220-1-git-send-email-yangtiezhu@loongson.cn>
References: <1633915150-13220-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9DxP2oPkWNh8sYXAA--.22187S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KF45XF1xCr4xCry7Jw4Utwb_yoW8WF4xpw
        4SyFs7GrykWFy5GFW8AFW7WrWYqr1vq3y2vFWq9ryUXasavF17Ar1Svw1jyFWUWrZrJ3W0
        gFWrWFnrA3s5CwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
        x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
        A2z4x0Y4vEx4A2jsIE14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr1j6F4U
        JwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
        IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbVWUJVW8
        JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
        ka0xkIwI1lc2xSY4AK67AK6w4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
        Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17
        CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0
        I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I
        8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73
        UjIFyTuYvjfUemiiDUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The config options MIPS_CBPF_JIT and MIPS_EBPF_JIT are useless, remove
them in arch/mips/Kconfig, and then modify arch/mips/net/Makefile.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Acked-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
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

