Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A25403F65
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 21:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350490AbhIHTHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 15:07:32 -0400
Received: from home.keithp.com ([63.227.221.253]:35678 "EHLO elaine.keithp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350414AbhIHTH3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 15:07:29 -0400
Received: from localhost (localhost [127.0.0.1])
        by elaine.keithp.com (Postfix) with ESMTP id C1B3A3F3088B;
        Wed,  8 Sep 2021 12:05:51 -0700 (PDT)
X-Virus-Scanned: Debian amavisd-new at keithp.com
Received: from elaine.keithp.com ([127.0.0.1])
        by localhost (elaine.keithp.com [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id hA43RMvmbiP7; Wed,  8 Sep 2021 12:05:51 -0700 (PDT)
Received: from keithp.com (168-103-156-98.tukw.qwest.net [168.103.156.98])
        by elaine.keithp.com (Postfix) with ESMTPSA id 2D6443F30884;
        Wed,  8 Sep 2021 12:05:49 -0700 (PDT)
Received: by keithp.com (Postfix, from userid 1000)
        id 61B2C1E6013B; Wed,  8 Sep 2021 12:06:09 -0700 (PDT)
From:   Keith Packard <keithpac@amazon.com>
To:     linux-kernel@vger.kernel.org
Cc:     Abbott Liu <liuwenliang@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Ben Segall <bsegall@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        bpf@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Dennis Zhou <dennis@kernel.org>, devicetree@vger.kernel.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Joe Perches <joe@perches.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Keith Packard <keithpac@amazon.com>,
        KP Singh <kpsingh@kernel.org>, kvm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, Manivannan Sadhasivam <mani@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Mel Gorman <mgorman@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mike Rapoport <rppt@kernel.org>, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nick Desaulniers <ndesaulniers@gooogle.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Song Liu <songliubraving@fb.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        virtualization@lists.linux-foundation.org,
        "Wolfram Sang (Renesas)" <wsa+renesas@sang-engineering.com>,
        YiFei Zhu <yifeifz2@illinois.edu>, Yonghong Song <yhs@fb.com>
Subject: [PATCH v4 5/7] ARM: Stop using TPIDRPRW to hold per_cpu_offset
Date:   Wed,  8 Sep 2021 12:06:03 -0700
Message-Id: <20210908190605.419064-6-keithpac@amazon.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210908190605.419064-1-keithpac@amazon.com>
References: <id:20210907220038.91021-1-keithpac@amazon.com>
 <20210908190605.419064-1-keithpac@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're going to store TPIDRPRW here instead

Signed-off-by: Keith Packard <keithpac@amazon.com>
---
 arch/arm/include/asm/percpu.h | 31 -------------------------------
 arch/arm/kernel/setup.c       |  7 -------
 arch/arm/kernel/smp.c         |  3 ---
 3 files changed, 41 deletions(-)

diff --git a/arch/arm/include/asm/percpu.h b/arch/arm/include/asm/percpu.h
index e2fcb3cfd3de..eeafcd6a3e01 100644
--- a/arch/arm/include/asm/percpu.h
+++ b/arch/arm/include/asm/percpu.h
@@ -7,37 +7,6 @@
 
 register unsigned long current_stack_pointer asm ("sp");
 
-/*
- * Same as asm-generic/percpu.h, except that we store the per cpu offset
- * in the TPIDRPRW. TPIDRPRW only exists on V6K and V7
- */
-#if defined(CONFIG_SMP) && !defined(CONFIG_CPU_V6)
-static inline void set_my_cpu_offset(unsigned long off)
-{
-	/* Set TPIDRPRW */
-	asm volatile("mcr p15, 0, %0, c13, c0, 4" : : "r" (off) : "memory");
-}
-
-static inline unsigned long __my_cpu_offset(void)
-{
-	unsigned long off;
-
-	/*
-	 * Read TPIDRPRW.
-	 * We want to allow caching the value, so avoid using volatile and
-	 * instead use a fake stack read to hazard against barrier().
-	 */
-	asm("mrc p15, 0, %0, c13, c0, 4" : "=r" (off)
-		: "Q" (*(const unsigned long *)current_stack_pointer));
-
-	return off;
-}
-#define __my_cpu_offset __my_cpu_offset()
-#else
-#define set_my_cpu_offset(x)	do {} while(0)
-
-#endif /* CONFIG_SMP */
-
 #include <asm-generic/percpu.h>
 
 #endif /* _ASM_ARM_PERCPU_H_ */
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index ca0201635fac..d0dc60afe54f 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -590,13 +590,6 @@ void __init smp_setup_processor_id(void)
 	for (i = 1; i < nr_cpu_ids; ++i)
 		cpu_logical_map(i) = i == cpu ? 0 : i;
 
-	/*
-	 * clear __my_cpu_offset on boot CPU to avoid hang caused by
-	 * using percpu variable early, for example, lockdep will
-	 * access percpu variable inside lock_release
-	 */
-	set_my_cpu_offset(0);
-
 	pr_info("Booting Linux on physical CPU 0x%x\n", mpidr);
 }
 
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 5e999f1f1aea..8ccf10b34f08 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -410,8 +410,6 @@ asmlinkage void secondary_start_kernel(unsigned int cpu, struct task_struct *tas
 {
 	struct mm_struct *mm = &init_mm;
 
-	set_my_cpu_offset(per_cpu_offset(cpu));
-
 	secondary_biglittle_init();
 
 	/*
@@ -495,7 +493,6 @@ void __init smp_cpus_done(unsigned int max_cpus)
 
 void __init smp_prepare_boot_cpu(void)
 {
-	set_my_cpu_offset(per_cpu_offset(smp_processor_id()));
 }
 
 void __init smp_prepare_cpus(unsigned int max_cpus)
-- 
2.33.0

