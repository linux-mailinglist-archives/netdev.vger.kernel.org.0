Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417E334D71C
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 20:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbhC2S3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 14:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbhC2S3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 14:29:07 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A0E46C061574;
        Mon, 29 Mar 2021 11:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
        Content-Transfer-Encoding; bh=X3JnzAWB/wP2byqIVYcRzkGaaPhYaCeo9n
        v6lfgBPe0=; b=ciYwCT3No/H9XxjptM0VF/OY2o4gT28I5Kw7VbmnXEjTsDu4mf
        YsC1hh4Hvuul3+7dfes7tXCpnxr5rNaeT3+rm05riOI1g4KMOnote/sxQ5EcgzWR
        OEgbeXuq5a1pXFFi581bdlA3cwdSHNOFbsIHEz4ICpx4YZi1p/j/ZTpXU=
Received: from xhacker (unknown [101.86.19.180])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygCXnkpiHGJg2vRpAA--.2864S2;
        Tue, 30 Mar 2021 02:28:50 +0800 (CST)
Date:   Tue, 30 Mar 2021 02:23:54 +0800
From:   Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        " =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?=" <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 4/9] riscv: Constify sbi_ipi_ops
Message-ID: <20210330022354.385a9a52@xhacker>
In-Reply-To: <20210330022144.150edc6e@xhacker>
References: <20210330022144.150edc6e@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LkAmygCXnkpiHGJg2vRpAA--.2864S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KFyxuF4kuF1rWw17ZFyrJFb_yoW8tw1kpw
        4UCr45CFWrGFn7Ga43tFWku3y3K3ZrWwnIy34Yka45JFnIqrWUAan0qw12vwn8GFyDuFyS
        9r4rCrZ0vF1UAFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkKb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjc
        xK6I8E87Iv6xkF7I0E14v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40E
        FcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr
        0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY
        04v7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        W8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVW8JVW3JwCI42IY6I8E87Iv67AKxVW8JVWx
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU8tKsU
        UUUUU==
X-CM-SenderInfo: xmv2xttqjtqzxdloh3xvwfhvlgxou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

Constify the sbi_ipi_ops so that it will be placed in the .rodata
section. This will cause attempts to modify it to fail when strict
page permissions are in place.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 arch/riscv/include/asm/smp.h | 4 ++--
 arch/riscv/kernel/sbi.c      | 2 +-
 arch/riscv/kernel/smp.c      | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/smp.h b/arch/riscv/include/asm/smp.h
index df1f7c4cd433..a7d2811f3536 100644
--- a/arch/riscv/include/asm/smp.h
+++ b/arch/riscv/include/asm/smp.h
@@ -46,7 +46,7 @@ int riscv_hartid_to_cpuid(int hartid);
 void riscv_cpuid_to_hartid_mask(const struct cpumask *in, struct cpumask *out);
 
 /* Set custom IPI operations */
-void riscv_set_ipi_ops(struct riscv_ipi_ops *ops);
+void riscv_set_ipi_ops(const struct riscv_ipi_ops *ops);
 
 /* Clear IPI for current CPU */
 void riscv_clear_ipi(void);
@@ -92,7 +92,7 @@ static inline void riscv_cpuid_to_hartid_mask(const struct cpumask *in,
 	cpumask_set_cpu(boot_cpu_hartid, out);
 }
 
-static inline void riscv_set_ipi_ops(struct riscv_ipi_ops *ops)
+static inline void riscv_set_ipi_ops(const struct riscv_ipi_ops *ops)
 {
 }
 
diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
index cbd94a72eaa7..cb848e80865e 100644
--- a/arch/riscv/kernel/sbi.c
+++ b/arch/riscv/kernel/sbi.c
@@ -556,7 +556,7 @@ static void sbi_send_cpumask_ipi(const struct cpumask *target)
 	sbi_send_ipi(cpumask_bits(&hartid_mask));
 }
 
-static struct riscv_ipi_ops sbi_ipi_ops = {
+static const struct riscv_ipi_ops sbi_ipi_ops = {
 	.ipi_inject = sbi_send_cpumask_ipi
 };
 
diff --git a/arch/riscv/kernel/smp.c b/arch/riscv/kernel/smp.c
index 504284d49135..e035124f06dc 100644
--- a/arch/riscv/kernel/smp.c
+++ b/arch/riscv/kernel/smp.c
@@ -85,9 +85,9 @@ static void ipi_stop(void)
 		wait_for_interrupt();
 }
 
-static struct riscv_ipi_ops *ipi_ops __ro_after_init;
+static const struct riscv_ipi_ops *ipi_ops __ro_after_init;
 
-void riscv_set_ipi_ops(struct riscv_ipi_ops *ops)
+void riscv_set_ipi_ops(const struct riscv_ipi_ops *ops)
 {
 	ipi_ops = ops;
 }
-- 
2.31.0


