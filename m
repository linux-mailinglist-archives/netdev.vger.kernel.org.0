Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630FA512674
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 01:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239678AbiD0XAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 19:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240483AbiD0W71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:59:27 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16179157E;
        Wed, 27 Apr 2022 15:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bXh7kiTIu/oy8MX/xHxFfh1fd2A2HdpodNy0n7WfBok=; b=jgBsYcG7VatVMQNKfpmMmj+KDF
        XkWdsJfK09vZ2R11ym0rJsLvtM7L6jFVra/wKw7Ru20Q3tXdmM07YvLIKve3XUICHAOg3XVnWAPnC
        QEU9pWc8Syz13kCBbzgQspePXfSisAbL6GFs+m41GGaRoAAhFREDnjG2ZxSQpo/Uwz68hg3pu2x/D
        E6IkumXzatKpQWO5lYMxPl1yMWzmsX3DQC96acG0StwdG2kMOMr4xmOgeGsgOcdwakQdld1rcVf3a
        toHhgvuQnGWFi2MNPNWRfSUHfV6qkAGZNsEtUXlHsz/Hx27noavbMwYx8Z2d6rixzJUQIGNVx4tvy
        GymC5HQQ==;
Received: from [179.113.53.197] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1njqYq-0002L8-2E; Thu, 28 Apr 2022 00:55:04 +0200
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, coresight@lists.linaro.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        rcu@vger.kernel.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        kernel-dev@igalia.com, gpiccoli@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Hari Bathini <hbathini@linux.ibm.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mike Leach <mike.leach@linaro.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 20/30] panic: Add the panic informational notifier list
Date:   Wed, 27 Apr 2022 19:49:14 -0300
Message-Id: <20220427224924.592546-21-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220427224924.592546-1-gpiccoli@igalia.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The goal of this new panic notifier is to allow its users to
register callbacks to run earlier in the panic path than they
currently do. This aims at informational mechanisms, like dumping
kernel offsets and showing device error data (in case it's simple
registers reading, for example) as well as mechanisms to disable
log flooding (like hung_task detector / RCU warnings) and the
tracing dump_on_oops (when enabled).

Any (non-invasive) information that should be provided before
kmsg_dump() as well as log flooding preventing code should fit
here, as long it offers relatively low risk for kdump.

For now, the patch is almost a no-op, although it changes a bit
the ordering in which some panic notifiers are executed - specially
affected by this are the notifiers responsible for disabling the
hung_task detector / RCU warnings, which now run first. In a
subsequent patch, the panic path will be refactored, then the
panic informational notifiers will effectively run earlier,
before ksmg_dump() (and usually before kdump as well).

We also defer documenting it all properly in the subsequent
refactor patch. Finally, while at it, we removed some useless
header inclusions too.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Jonathan Hunter <jonathanh@nvidia.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Mikko Perttunen <mperttunen@nvidia.com>
Cc: Neeraj Upadhyay <quic_neeraju@quicinc.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---
 arch/arm64/kernel/setup.c                         | 2 +-
 arch/mips/kernel/relocate.c                       | 2 +-
 arch/powerpc/kernel/setup-common.c                | 2 +-
 arch/x86/kernel/setup.c                           | 2 +-
 drivers/bus/brcmstb_gisb.c                        | 2 +-
 drivers/hwtracing/coresight/coresight-cpu-debug.c | 4 ++--
 drivers/soc/tegra/ari-tegra186.c                  | 3 ++-
 include/linux/panic_notifier.h                    | 1 +
 kernel/hung_task.c                                | 3 ++-
 kernel/panic.c                                    | 4 ++++
 kernel/rcu/tree.c                                 | 1 -
 kernel/rcu/tree_stall.h                           | 3 ++-
 kernel/trace/trace.c                              | 2 +-
 13 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 3505789cf4bd..ac2c7e8c9c6a 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -444,7 +444,7 @@ static struct notifier_block arm64_panic_block = {
 
 static int __init register_arm64_panic_block(void)
 {
-	atomic_notifier_chain_register(&panic_notifier_list,
+	atomic_notifier_chain_register(&panic_info_list,
 				       &arm64_panic_block);
 	return 0;
 }
diff --git a/arch/mips/kernel/relocate.c b/arch/mips/kernel/relocate.c
index 56b51de2dc51..650811f2436a 100644
--- a/arch/mips/kernel/relocate.c
+++ b/arch/mips/kernel/relocate.c
@@ -459,7 +459,7 @@ static struct notifier_block kernel_location_notifier = {
 
 static int __init register_kernel_offset_dumper(void)
 {
-	atomic_notifier_chain_register(&panic_notifier_list,
+	atomic_notifier_chain_register(&panic_info_list,
 				       &kernel_location_notifier);
 	return 0;
 }
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 1468c3937bf4..d04b8bf8dbc7 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -757,7 +757,7 @@ void __init setup_panic(void)
 				       &ppc_fadump_block);
 
 	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && kaslr_offset() > 0)
-		atomic_notifier_chain_register(&panic_notifier_list,
+		atomic_notifier_chain_register(&panic_info_list,
 					       &kernel_offset_notifier);
 
 	/* Low-level platform-specific routines that should run on panic */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c95b9ac5a457..599b25346964 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1266,7 +1266,7 @@ static struct notifier_block kernel_offset_notifier = {
 
 static int __init register_kernel_offset_dumper(void)
 {
-	atomic_notifier_chain_register(&panic_notifier_list,
+	atomic_notifier_chain_register(&panic_info_list,
 					&kernel_offset_notifier);
 	return 0;
 }
diff --git a/drivers/bus/brcmstb_gisb.c b/drivers/bus/brcmstb_gisb.c
index 1ea7b015e225..c64e087fba7a 100644
--- a/drivers/bus/brcmstb_gisb.c
+++ b/drivers/bus/brcmstb_gisb.c
@@ -486,7 +486,7 @@ static int __init brcmstb_gisb_arb_probe(struct platform_device *pdev)
 
 	if (list_is_singular(&brcmstb_gisb_arb_device_list)) {
 		register_die_notifier(&gisb_die_notifier);
-		atomic_notifier_chain_register(&panic_notifier_list,
+		atomic_notifier_chain_register(&panic_info_list,
 					       &gisb_panic_notifier);
 	}
 
diff --git a/drivers/hwtracing/coresight/coresight-cpu-debug.c b/drivers/hwtracing/coresight/coresight-cpu-debug.c
index 1874df7c6a73..7b1012454525 100644
--- a/drivers/hwtracing/coresight/coresight-cpu-debug.c
+++ b/drivers/hwtracing/coresight/coresight-cpu-debug.c
@@ -535,7 +535,7 @@ static int debug_func_init(void)
 			    &debug_func_knob_fops);
 
 	/* Register function to be called for panic */
-	ret = atomic_notifier_chain_register(&panic_notifier_list,
+	ret = atomic_notifier_chain_register(&panic_info_list,
 					     &debug_notifier);
 	if (ret) {
 		pr_err("%s: unable to register notifier: %d\n",
@@ -552,7 +552,7 @@ static int debug_func_init(void)
 
 static void debug_func_exit(void)
 {
-	atomic_notifier_chain_unregister(&panic_notifier_list,
+	atomic_notifier_chain_unregister(&panic_info_list,
 					 &debug_notifier);
 	debugfs_remove_recursive(debug_debugfs_dir);
 }
diff --git a/drivers/soc/tegra/ari-tegra186.c b/drivers/soc/tegra/ari-tegra186.c
index 02577853ec49..4ef05ebed739 100644
--- a/drivers/soc/tegra/ari-tegra186.c
+++ b/drivers/soc/tegra/ari-tegra186.c
@@ -73,7 +73,8 @@ static struct notifier_block tegra186_ari_panic_nb = {
 static int __init tegra186_ari_init(void)
 {
 	if (of_machine_is_compatible("nvidia,tegra186"))
-		atomic_notifier_chain_register(&panic_notifier_list, &tegra186_ari_panic_nb);
+		atomic_notifier_chain_register(&panic_info_list,
+					       &tegra186_ari_panic_nb);
 
 	return 0;
 }
diff --git a/include/linux/panic_notifier.h b/include/linux/panic_notifier.h
index 0bb9dc0dea04..7364a346bcb0 100644
--- a/include/linux/panic_notifier.h
+++ b/include/linux/panic_notifier.h
@@ -7,6 +7,7 @@
 
 extern struct atomic_notifier_head panic_notifier_list;
 extern struct atomic_notifier_head panic_hypervisor_list;
+extern struct atomic_notifier_head panic_info_list;
 
 extern bool crash_kexec_post_notifiers;
 
diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 52501e5f7655..1b2d7111d5ac 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -85,6 +85,7 @@ hung_task_panic(struct notifier_block *this, unsigned long event, void *ptr)
 
 static struct notifier_block panic_block = {
 	.notifier_call = hung_task_panic,
+	.priority = INT_MAX, /* run early to prevent potential log flood */
 };
 
 static void check_hung_task(struct task_struct *t, unsigned long timeout)
@@ -378,7 +379,7 @@ static int watchdog(void *dummy)
 
 static int __init hung_task_init(void)
 {
-	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
+	atomic_notifier_chain_register(&panic_info_list, &panic_block);
 
 	/* Disable hung task detector on suspend */
 	pm_notifier(hungtask_pm_notify, 0);
diff --git a/kernel/panic.c b/kernel/panic.c
index ef76f3f9c44d..73ca1bc44e30 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -76,6 +76,9 @@ EXPORT_SYMBOL(panic_notifier_list);
 ATOMIC_NOTIFIER_HEAD(panic_hypervisor_list);
 EXPORT_SYMBOL(panic_hypervisor_list);
 
+ATOMIC_NOTIFIER_HEAD(panic_info_list);
+EXPORT_SYMBOL(panic_info_list);
+
 static long no_blink(int state)
 {
 	return 0;
@@ -291,6 +294,7 @@ void panic(const char *fmt, ...)
 	 * add information to the kmsg dump output.
 	 */
 	atomic_notifier_call_chain(&panic_hypervisor_list, PANIC_NOTIFIER, buf);
+	atomic_notifier_call_chain(&panic_info_list, PANIC_NOTIFIER, buf);
 	atomic_notifier_call_chain(&panic_notifier_list, PANIC_NOTIFIER, buf);
 
 	panic_print_sys_info(false);
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index a4b8189455d5..d5a2674ae81c 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -35,7 +35,6 @@
 #include <linux/panic.h>
 #include <linux/panic_notifier.h>
 #include <linux/percpu.h>
-#include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/time.h>
diff --git a/kernel/rcu/tree_stall.h b/kernel/rcu/tree_stall.h
index 0c5d8516516a..d8a5840aad5d 100644
--- a/kernel/rcu/tree_stall.h
+++ b/kernel/rcu/tree_stall.h
@@ -97,11 +97,12 @@ static int rcu_panic(struct notifier_block *this, unsigned long ev, void *ptr)
 
 static struct notifier_block rcu_panic_block = {
 	.notifier_call = rcu_panic,
+	.priority = INT_MAX, /* run early to prevent potential log flood */
 };
 
 static int __init check_cpu_stall_init(void)
 {
-	atomic_notifier_chain_register(&panic_notifier_list, &rcu_panic_block);
+	atomic_notifier_chain_register(&panic_info_list, &rcu_panic_block);
 	return 0;
 }
 early_initcall(check_cpu_stall_init);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c1d8a3622ccc..7d02f7a66bb1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -10138,7 +10138,7 @@ __init static int tracer_alloc_buffers(void)
 	/* All seems OK, enable tracing */
 	tracing_disabled = 0;
 
-	atomic_notifier_chain_register(&panic_notifier_list,
+	atomic_notifier_chain_register(&panic_info_list,
 				       &trace_panic_notifier);
 
 	register_die_notifier(&trace_die_notifier);
-- 
2.36.0

