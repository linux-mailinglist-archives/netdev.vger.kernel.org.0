Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E6B37A10A
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 09:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhEKHmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 03:42:42 -0400
Received: from mga03.intel.com ([134.134.136.65]:44944 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhEKHme (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 03:42:34 -0400
IronPort-SDR: CMWDW/vZyZoTRBRvRvOIbyDwFqlYnM42IYaL3LDFB9VJI1yKcuATTjTe4HgHmPbI03wqmSjMLA
 0Xz/hy0SzOHA==
X-IronPort-AV: E=McAfee;i="6200,9189,9980"; a="199432466"
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="199432466"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2021 00:41:24 -0700
IronPort-SDR: bxjow9D22Jmf3/jJnjYJHVbTuY6PMcBV5ZtEV8Uo8/+4s+KdxC8KTPgRnAns8QsutU3/VaQRZV
 fX6Ws9zRuFvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="621714255"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 11 May 2021 00:41:19 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 2D1AE12A; Tue, 11 May 2021 10:41:40 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Alexander Lobakin <alobakin@pm.me>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Joerg Roedel <jroedel@suse.de>, Wei Liu <wei.liu@kernel.org>,
        Mike Rapoport <rppt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Corey Minyard <cminyard@mvista.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Scott Branden <scott.branden@broadcom.com>,
        Olof Johansson <olof@lixom.net>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Marek Czerski <ma.czerski@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Rishabh Bhatnagar <rishabhb@codeaurora.org>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-um@lists.infradead.org, linux-hyperv@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-xtensa@linux-xtensa.org,
        openipmi-developer@lists.sourceforge.net,
        linux-clk@vger.kernel.org, linux-edac@vger.kernel.org,
        coresight@lists.linaro.org, linux-leds@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-staging@lists.linux.dev, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, linux-arch@vger.kernel.org,
        kexec@lists.infradead.org, rcu@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Corey Minyard <minyard@acm.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>, Arnd Bergmann <arnd@arndb.de>,
        Alex Elder <elder@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Jens Frederich <jfrederich@gmail.com>,
        Daniel Drake <dsd@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v3 1/1] kernel.h: Split out panic and oops helpers
Date:   Tue, 11 May 2021 10:41:37 +0300
Message-Id: <20210511074137.33666-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel.h is being used as a dump for all kinds of stuff for a long time.
Here is the attempt to start cleaning it up by splitting out panic and
oops helpers.

There are several purposes of doing this:
- dropping dependency in bug.h
- dropping a loop by moving out panic_notifier.h
- unload kernel.h from something which has its own domain

At the same time convert users tree-wide to use new headers, although
for the time being include new header back to kernel.h to avoid twisted
indirected includes for existing users.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Corey Minyard <cminyard@mvista.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Wei Liu <wei.liu@kernel.org>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Co-developed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Sebastian Reichel <sre@kernel.org>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Acked-by: Helge Deller <deller@gmx.de> # parisc
---
v3: rebased on top of v5.13-rc1, collected a few more tags

Note WRT Andrew's SoB tag above: I have added it since part of the cases
I took from him. Andrew, feel free to amend or tell me how you want me
to do.

 arch/alpha/kernel/setup.c                     |  2 +-
 arch/arm64/kernel/setup.c                     |  1 +
 arch/mips/kernel/relocate.c                   |  1 +
 arch/mips/sgi-ip22/ip22-reset.c               |  1 +
 arch/mips/sgi-ip32/ip32-reset.c               |  1 +
 arch/parisc/kernel/pdc_chassis.c              |  1 +
 arch/powerpc/kernel/setup-common.c            |  1 +
 arch/s390/kernel/ipl.c                        |  1 +
 arch/sparc/kernel/sstate.c                    |  1 +
 arch/um/drivers/mconsole_kern.c               |  1 +
 arch/um/kernel/um_arch.c                      |  1 +
 arch/x86/include/asm/desc.h                   |  1 +
 arch/x86/kernel/cpu/mshyperv.c                |  1 +
 arch/x86/kernel/setup.c                       |  1 +
 arch/x86/purgatory/purgatory.c                |  2 +
 arch/x86/xen/enlighten.c                      |  1 +
 arch/xtensa/platforms/iss/setup.c             |  1 +
 drivers/bus/brcmstb_gisb.c                    |  1 +
 drivers/char/ipmi/ipmi_msghandler.c           |  1 +
 drivers/clk/analogbits/wrpll-cln28hpc.c       |  4 +
 drivers/edac/altera_edac.c                    |  1 +
 drivers/firmware/google/gsmi.c                |  1 +
 drivers/hv/vmbus_drv.c                        |  1 +
 .../hwtracing/coresight/coresight-cpu-debug.c |  1 +
 drivers/leds/trigger/ledtrig-activity.c       |  1 +
 drivers/leds/trigger/ledtrig-heartbeat.c      |  1 +
 drivers/leds/trigger/ledtrig-panic.c          |  1 +
 drivers/misc/bcm-vk/bcm_vk_dev.c              |  1 +
 drivers/misc/ibmasm/heartbeat.c               |  1 +
 drivers/misc/pvpanic/pvpanic.c                |  1 +
 drivers/net/ipa/ipa_smp2p.c                   |  1 +
 drivers/parisc/power.c                        |  1 +
 drivers/power/reset/ltc2952-poweroff.c        |  1 +
 drivers/remoteproc/remoteproc_core.c          |  1 +
 drivers/s390/char/con3215.c                   |  1 +
 drivers/s390/char/con3270.c                   |  1 +
 drivers/s390/char/sclp.c                      |  1 +
 drivers/s390/char/sclp_con.c                  |  1 +
 drivers/s390/char/sclp_vt220.c                |  1 +
 drivers/s390/char/zcore.c                     |  1 +
 drivers/soc/bcm/brcmstb/pm/pm-arm.c           |  1 +
 drivers/staging/olpc_dcon/olpc_dcon.c         |  1 +
 drivers/video/fbdev/hyperv_fb.c               |  1 +
 include/asm-generic/bug.h                     |  3 +-
 include/linux/kernel.h                        | 84 +---------------
 include/linux/panic.h                         | 98 +++++++++++++++++++
 include/linux/panic_notifier.h                | 12 +++
 kernel/hung_task.c                            |  1 +
 kernel/kexec_core.c                           |  1 +
 kernel/panic.c                                |  1 +
 kernel/rcu/tree.c                             |  2 +
 kernel/sysctl.c                               |  1 +
 kernel/trace/trace.c                          |  1 +
 53 files changed, 167 insertions(+), 85 deletions(-)
 create mode 100644 include/linux/panic.h
 create mode 100644 include/linux/panic_notifier.h

diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
index 03dda3beb3bd..5d1296534682 100644
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -28,6 +28,7 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
+#include <linux/panic_notifier.h>
 #include <linux/platform_device.h>
 #include <linux/memblock.h>
 #include <linux/pci.h>
@@ -46,7 +47,6 @@
 #include <linux/log2.h>
 #include <linux/export.h>
 
-extern struct atomic_notifier_head panic_notifier_list;
 static int alpha_panic_event(struct notifier_block *, unsigned long, void *);
 static struct notifier_block alpha_panic_block = {
 	alpha_panic_event,
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 61845c0821d9..787bc0f601b3 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/smp.h>
 #include <linux/fs.h>
+#include <linux/panic_notifier.h>
 #include <linux/proc_fs.h>
 #include <linux/memblock.h>
 #include <linux/of_fdt.h>
diff --git a/arch/mips/kernel/relocate.c b/arch/mips/kernel/relocate.c
index 499a5357c09f..56b51de2dc51 100644
--- a/arch/mips/kernel/relocate.c
+++ b/arch/mips/kernel/relocate.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/libfdt.h>
 #include <linux/of_fdt.h>
+#include <linux/panic_notifier.h>
 #include <linux/sched/task.h>
 #include <linux/start_kernel.h>
 #include <linux/string.h>
diff --git a/arch/mips/sgi-ip22/ip22-reset.c b/arch/mips/sgi-ip22/ip22-reset.c
index c374f3ceec38..9028dbbb45dd 100644
--- a/arch/mips/sgi-ip22/ip22-reset.c
+++ b/arch/mips/sgi-ip22/ip22-reset.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/sched/signal.h>
 #include <linux/notifier.h>
+#include <linux/panic_notifier.h>
 #include <linux/pm.h>
 #include <linux/timer.h>
 
diff --git a/arch/mips/sgi-ip32/ip32-reset.c b/arch/mips/sgi-ip32/ip32-reset.c
index 20d8637340be..18d1c115cd53 100644
--- a/arch/mips/sgi-ip32/ip32-reset.c
+++ b/arch/mips/sgi-ip32/ip32-reset.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/panic_notifier.h>
 #include <linux/sched.h>
 #include <linux/sched/signal.h>
 #include <linux/notifier.h>
diff --git a/arch/parisc/kernel/pdc_chassis.c b/arch/parisc/kernel/pdc_chassis.c
index 75ae88d13909..da154406d368 100644
--- a/arch/parisc/kernel/pdc_chassis.c
+++ b/arch/parisc/kernel/pdc_chassis.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/panic_notifier.h>
 #include <linux/reboot.h>
 #include <linux/notifier.h>
 #include <linux/cache.h>
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 74a98fff2c2f..046fe21b5c3b 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -9,6 +9,7 @@
 #undef DEBUG
 
 #include <linux/export.h>
+#include <linux/panic_notifier.h>
 #include <linux/string.h>
 #include <linux/sched.h>
 #include <linux/init.h>
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index dba04fbc37a2..36f870dc944f 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/delay.h>
+#include <linux/panic_notifier.h>
 #include <linux/reboot.h>
 #include <linux/ctype.h>
 #include <linux/fs.h>
diff --git a/arch/sparc/kernel/sstate.c b/arch/sparc/kernel/sstate.c
index ac8677c3841e..3bcc4ddc6911 100644
--- a/arch/sparc/kernel/sstate.c
+++ b/arch/sparc/kernel/sstate.c
@@ -6,6 +6,7 @@
 
 #include <linux/kernel.h>
 #include <linux/notifier.h>
+#include <linux/panic_notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
 
diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index 6d00af25ec6b..328b16f99b30 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/notifier.h>
+#include <linux/panic_notifier.h>
 #include <linux/reboot.h>
 #include <linux/sched/debug.h>
 #include <linux/proc_fs.h>
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 74e07e748a9b..9512253947d5 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -7,6 +7,7 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/panic_notifier.h>
 #include <linux/seq_file.h>
 #include <linux/string.h>
 #include <linux/utsname.h>
diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 476082a83d1c..ceb12683b6d1 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -9,6 +9,7 @@
 #include <asm/irq_vectors.h>
 #include <asm/cpu_entry_area.h>
 
+#include <linux/debug_locks.h>
 #include <linux/smp.h>
 #include <linux/percpu.h>
 
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 22f13343b5da..9e5c6f2b044d 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -17,6 +17,7 @@
 #include <linux/irq.h>
 #include <linux/kexec.h>
 #include <linux/i8253.h>
+#include <linux/panic_notifier.h>
 #include <linux/random.h>
 #include <asm/processor.h>
 #include <asm/hypervisor.h>
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 72920af0b3c0..bdcdd29efea6 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -14,6 +14,7 @@
 #include <linux/initrd.h>
 #include <linux/iscsi_ibft.h>
 #include <linux/memblock.h>
+#include <linux/panic_notifier.h>
 #include <linux/pci.h>
 #include <linux/root_dev.h>
 #include <linux/hugetlb.h>
diff --git a/arch/x86/purgatory/purgatory.c b/arch/x86/purgatory/purgatory.c
index f03b64d9cb51..7558139920f8 100644
--- a/arch/x86/purgatory/purgatory.c
+++ b/arch/x86/purgatory/purgatory.c
@@ -9,6 +9,8 @@
  */
 
 #include <linux/bug.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
 #include <crypto/sha2.h>
 #include <asm/purgatory.h>
 
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index aa9f50fccc5d..c79bd0af2e8c 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -6,6 +6,7 @@
 #include <linux/cpu.h>
 #include <linux/kexec.h>
 #include <linux/slab.h>
+#include <linux/panic_notifier.h>
 
 #include <xen/xen.h>
 #include <xen/features.h>
diff --git a/arch/xtensa/platforms/iss/setup.c b/arch/xtensa/platforms/iss/setup.c
index ed519aee0ec8..d3433e1bb94e 100644
--- a/arch/xtensa/platforms/iss/setup.c
+++ b/arch/xtensa/platforms/iss/setup.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/notifier.h>
+#include <linux/panic_notifier.h>
 #include <linux/printk.h>
 #include <linux/string.h>
 
diff --git a/drivers/bus/brcmstb_gisb.c b/drivers/bus/brcmstb_gisb.c
index 7355fa2cb439..6551286a60cc 100644
--- a/drivers/bus/brcmstb_gisb.c
+++ b/drivers/bus/brcmstb_gisb.c
@@ -6,6 +6,7 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/module.h>
+#include <linux/panic_notifier.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/sysfs.h>
diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 8a0e97b33cae..e96cb5c4f97a 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -16,6 +16,7 @@
 
 #include <linux/module.h>
 #include <linux/errno.h>
+#include <linux/panic_notifier.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
diff --git a/drivers/clk/analogbits/wrpll-cln28hpc.c b/drivers/clk/analogbits/wrpll-cln28hpc.c
index 776ead319ae9..7c64ea52a8d5 100644
--- a/drivers/clk/analogbits/wrpll-cln28hpc.c
+++ b/drivers/clk/analogbits/wrpll-cln28hpc.c
@@ -23,8 +23,12 @@
 
 #include <linux/bug.h>
 #include <linux/err.h>
+#include <linux/limits.h>
 #include <linux/log2.h>
 #include <linux/math64.h>
+#include <linux/math.h>
+#include <linux/minmax.h>
+
 #include <linux/clk/analogbits-wrpll-cln28hpc.h>
 
 /* MIN_INPUT_FREQ: minimum input clock frequency, in Hz (Fref_min) */
diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
index 5f7fd79ec82f..61c21bd880a4 100644
--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -20,6 +20,7 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/panic_notifier.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/types.h>
diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index bb6e77ee3898..adaa492c3d2d 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -19,6 +19,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/panic_notifier.h>
 #include <linux/ioctl.h>
 #include <linux/acpi.h>
 #include <linux/io.h>
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 92cb3f7d21d9..57bbbaa4e8f7 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -25,6 +25,7 @@
 
 #include <linux/delay.h>
 #include <linux/notifier.h>
+#include <linux/panic_notifier.h>
 #include <linux/ptrace.h>
 #include <linux/screen_info.h>
 #include <linux/kdebug.h>
diff --git a/drivers/hwtracing/coresight/coresight-cpu-debug.c b/drivers/hwtracing/coresight/coresight-cpu-debug.c
index 2dcf13de751f..9731d3a96073 100644
--- a/drivers/hwtracing/coresight/coresight-cpu-debug.c
+++ b/drivers/hwtracing/coresight/coresight-cpu-debug.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/panic_notifier.h>
 #include <linux/pm_qos.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
diff --git a/drivers/leds/trigger/ledtrig-activity.c b/drivers/leds/trigger/ledtrig-activity.c
index 14ba7faaed9e..30bc9df03636 100644
--- a/drivers/leds/trigger/ledtrig-activity.c
+++ b/drivers/leds/trigger/ledtrig-activity.c
@@ -11,6 +11,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/leds.h>
 #include <linux/module.h>
+#include <linux/panic_notifier.h>
 #include <linux/reboot.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
diff --git a/drivers/leds/trigger/ledtrig-heartbeat.c b/drivers/leds/trigger/ledtrig-heartbeat.c
index 36b6709afe9f..7fe0a05574d2 100644
--- a/drivers/leds/trigger/ledtrig-heartbeat.c
+++ b/drivers/leds/trigger/ledtrig-heartbeat.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/panic_notifier.h>
 #include <linux/slab.h>
 #include <linux/timer.h>
 #include <linux/sched.h>
diff --git a/drivers/leds/trigger/ledtrig-panic.c b/drivers/leds/trigger/ledtrig-panic.c
index 5751cd032f9d..64abf2e91608 100644
--- a/drivers/leds/trigger/ledtrig-panic.c
+++ b/drivers/leds/trigger/ledtrig-panic.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/notifier.h>
+#include <linux/panic_notifier.h>
 #include <linux/leds.h>
 #include "../leds.h"
 
diff --git a/drivers/misc/bcm-vk/bcm_vk_dev.c b/drivers/misc/bcm-vk/bcm_vk_dev.c
index 6bfea3210389..ad639ee85b2a 100644
--- a/drivers/misc/bcm-vk/bcm_vk_dev.c
+++ b/drivers/misc/bcm-vk/bcm_vk_dev.c
@@ -9,6 +9,7 @@
 #include <linux/fs.h>
 #include <linux/idr.h>
 #include <linux/interrupt.h>
+#include <linux/panic_notifier.h>
 #include <linux/kref.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
diff --git a/drivers/misc/ibmasm/heartbeat.c b/drivers/misc/ibmasm/heartbeat.c
index 4f5f3bdc814d..59c9a0d95659 100644
--- a/drivers/misc/ibmasm/heartbeat.c
+++ b/drivers/misc/ibmasm/heartbeat.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/notifier.h>
+#include <linux/panic_notifier.h>
 #include "ibmasm.h"
 #include "dot_command.h"
 #include "lowlevel.h"
diff --git a/drivers/misc/pvpanic/pvpanic.c b/drivers/misc/pvpanic/pvpanic.c
index 65f70a4da8c0..793ea0c01193 100644
--- a/drivers/misc/pvpanic/pvpanic.c
+++ b/drivers/misc/pvpanic/pvpanic.c
@@ -13,6 +13,7 @@
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/panic_notifier.h>
 #include <linux/types.h>
 #include <linux/cdev.h>
 #include <linux/list.h>
diff --git a/drivers/net/ipa/ipa_smp2p.c b/drivers/net/ipa/ipa_smp2p.c
index a5f7a79a1923..34b68dc43886 100644
--- a/drivers/net/ipa/ipa_smp2p.c
+++ b/drivers/net/ipa/ipa_smp2p.c
@@ -8,6 +8,7 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/notifier.h>
+#include <linux/panic_notifier.h>
 #include <linux/soc/qcom/smem.h>
 #include <linux/soc/qcom/smem_state.h>
 
diff --git a/drivers/parisc/power.c b/drivers/parisc/power.c
index ebaf6867b457..456776bd8ee6 100644
--- a/drivers/parisc/power.c
+++ b/drivers/parisc/power.c
@@ -38,6 +38,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/notifier.h>
+#include <linux/panic_notifier.h>
 #include <linux/reboot.h>
 #include <linux/sched/signal.h>
 #include <linux/kthread.h>
diff --git a/drivers/power/reset/ltc2952-poweroff.c b/drivers/power/reset/ltc2952-poweroff.c
index d1495af30081..8688c8ba8894 100644
--- a/drivers/power/reset/ltc2952-poweroff.c
+++ b/drivers/power/reset/ltc2952-poweroff.c
@@ -52,6 +52,7 @@
 #include <linux/slab.h>
 #include <linux/kmod.h>
 #include <linux/module.h>
+#include <linux/panic_notifier.h>
 #include <linux/mod_devicetable.h>
 #include <linux/gpio/consumer.h>
 #include <linux/reboot.h>
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 626a6b90fba2..76dd8e2b1e7e 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/panic_notifier.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/dma-map-ops.h>
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 1fd5bca9fa20..02523f4e29f4 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -19,6 +19,7 @@
 #include <linux/console.h>
 #include <linux/interrupt.h>
 #include <linux/err.h>
+#include <linux/panic_notifier.h>
 #include <linux/reboot.h>
 #include <linux/serial.h> /* ASYNC_* flags */
 #include <linux/slab.h>
diff --git a/drivers/s390/char/con3270.c b/drivers/s390/char/con3270.c
index e21962c0fd94..87cdbace1453 100644
--- a/drivers/s390/char/con3270.c
+++ b/drivers/s390/char/con3270.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
+#include <linux/panic_notifier.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/err.h>
diff --git a/drivers/s390/char/sclp.c b/drivers/s390/char/sclp.c
index 986bbbc23d0a..6627820a5eb9 100644
--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -11,6 +11,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/module.h>
 #include <linux/err.h>
+#include <linux/panic_notifier.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/timer.h>
diff --git a/drivers/s390/char/sclp_con.c b/drivers/s390/char/sclp_con.c
index 9b852a47ccc1..cc01a7b8595d 100644
--- a/drivers/s390/char/sclp_con.c
+++ b/drivers/s390/char/sclp_con.c
@@ -10,6 +10,7 @@
 #include <linux/kmod.h>
 #include <linux/console.h>
 #include <linux/init.h>
+#include <linux/panic_notifier.h>
 #include <linux/timer.h>
 #include <linux/jiffies.h>
 #include <linux/termios.h>
diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index 7f4445b0f819..5b8a7b090a97 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -9,6 +9,7 @@
 
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/panic_notifier.h>
 #include <linux/list.h>
 #include <linux/wait.h>
 #include <linux/timer.h>
diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index bd3c724bf695..b5b0848da93b 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/debugfs.h>
+#include <linux/panic_notifier.h>
 #include <linux/reboot.h>
 
 #include <asm/asm-offsets.h>
diff --git a/drivers/soc/bcm/brcmstb/pm/pm-arm.c b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
index a673fdffe216..3cbb165d6e30 100644
--- a/drivers/soc/bcm/brcmstb/pm/pm-arm.c
+++ b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
@@ -28,6 +28,7 @@
 #include <linux/notifier.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/panic_notifier.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/printk.h>
diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 6d8e9a481786..7284cb4ac395 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -22,6 +22,7 @@
 #include <linux/device.h>
 #include <linux/uaccess.h>
 #include <linux/ctype.h>
+#include <linux/panic_notifier.h>
 #include <linux/reboot.h>
 #include <linux/olpc-ec.h>
 #include <asm/tsc.h>
diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index a7e6eea2c4a1..23999df52739 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -52,6 +52,7 @@
 #include <linux/completion.h>
 #include <linux/fb.h>
 #include <linux/pci.h>
+#include <linux/panic_notifier.h>
 #include <linux/efi.h>
 #include <linux/console.h>
 
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index b402494883b6..f152b9bb916f 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -17,7 +17,8 @@
 #endif
 
 #ifndef __ASSEMBLY__
-#include <linux/kernel.h>
+#include <linux/panic.h>
+#include <linux/printk.h>
 
 #ifdef CONFIG_BUG
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 15d8bad3d2f2..50f4a57cf50c 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -14,6 +14,7 @@
 #include <linux/math.h>
 #include <linux/minmax.h>
 #include <linux/typecheck.h>
+#include <linux/panic.h>
 #include <linux/printk.h>
 #include <linux/build_bug.h>
 #include <linux/static_call_types.h>
@@ -72,7 +73,6 @@
 #define lower_32_bits(n) ((u32)((n) & 0xffffffff))
 
 struct completion;
-struct pt_regs;
 struct user;
 
 #ifdef CONFIG_PREEMPT_VOLUNTARY
@@ -177,14 +177,6 @@ void __might_fault(const char *file, int line);
 static inline void might_fault(void) { }
 #endif
 
-extern struct atomic_notifier_head panic_notifier_list;
-extern long (*panic_blink)(int state);
-__printf(1, 2)
-void panic(const char *fmt, ...) __noreturn __cold;
-void nmi_panic(struct pt_regs *regs, const char *msg);
-extern void oops_enter(void);
-extern void oops_exit(void);
-extern bool oops_may_print(void);
 void do_exit(long error_code) __noreturn;
 void complete_and_exit(struct completion *, long) __noreturn;
 
@@ -370,52 +362,8 @@ extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
 extern int func_ptr_is_kernel_text(void *ptr);
 
-#ifdef CONFIG_SMP
-extern unsigned int sysctl_oops_all_cpu_backtrace;
-#else
-#define sysctl_oops_all_cpu_backtrace 0
-#endif /* CONFIG_SMP */
-
 extern void bust_spinlocks(int yes);
-extern int panic_timeout;
-extern unsigned long panic_print;
-extern int panic_on_oops;
-extern int panic_on_unrecovered_nmi;
-extern int panic_on_io_nmi;
-extern int panic_on_warn;
-extern unsigned long panic_on_taint;
-extern bool panic_on_taint_nousertaint;
-extern int sysctl_panic_on_rcu_stall;
-extern int sysctl_max_rcu_stall_to_panic;
-extern int sysctl_panic_on_stackoverflow;
-
-extern bool crash_kexec_post_notifiers;
 
-/*
- * panic_cpu is used for synchronizing panic() and crash_kexec() execution. It
- * holds a CPU number which is executing panic() currently. A value of
- * PANIC_CPU_INVALID means no CPU has entered panic() or crash_kexec().
- */
-extern atomic_t panic_cpu;
-#define PANIC_CPU_INVALID	-1
-
-/*
- * Only to be used by arch init code. If the user over-wrote the default
- * CONFIG_PANIC_TIMEOUT, honor it.
- */
-static inline void set_arch_panic_timeout(int timeout, int arch_default_timeout)
-{
-	if (panic_timeout == arch_default_timeout)
-		panic_timeout = timeout;
-}
-extern const char *print_tainted(void);
-enum lockdep_ok {
-	LOCKDEP_STILL_OK,
-	LOCKDEP_NOW_UNRELIABLE
-};
-extern void add_taint(unsigned flag, enum lockdep_ok);
-extern int test_taint(unsigned flag);
-extern unsigned long get_taint(void);
 extern int root_mountflags;
 
 extern bool early_boot_irqs_disabled;
@@ -434,36 +382,6 @@ extern enum system_states {
 	SYSTEM_SUSPEND,
 } system_state;
 
-/* This cannot be an enum because some may be used in assembly source. */
-#define TAINT_PROPRIETARY_MODULE	0
-#define TAINT_FORCED_MODULE		1
-#define TAINT_CPU_OUT_OF_SPEC		2
-#define TAINT_FORCED_RMMOD		3
-#define TAINT_MACHINE_CHECK		4
-#define TAINT_BAD_PAGE			5
-#define TAINT_USER			6
-#define TAINT_DIE			7
-#define TAINT_OVERRIDDEN_ACPI_TABLE	8
-#define TAINT_WARN			9
-#define TAINT_CRAP			10
-#define TAINT_FIRMWARE_WORKAROUND	11
-#define TAINT_OOT_MODULE		12
-#define TAINT_UNSIGNED_MODULE		13
-#define TAINT_SOFTLOCKUP		14
-#define TAINT_LIVEPATCH			15
-#define TAINT_AUX			16
-#define TAINT_RANDSTRUCT		17
-#define TAINT_FLAGS_COUNT		18
-#define TAINT_FLAGS_MAX			((1UL << TAINT_FLAGS_COUNT) - 1)
-
-struct taint_flag {
-	char c_true;	/* character printed when tainted */
-	char c_false;	/* character printed when not tainted */
-	bool module;	/* also show as a per-module taint flag */
-};
-
-extern const struct taint_flag taint_flags[TAINT_FLAGS_COUNT];
-
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
 #define hex_asc_hi(x)	hex_asc[((x) & 0xf0) >> 4]
diff --git a/include/linux/panic.h b/include/linux/panic.h
new file mode 100644
index 000000000000..f5844908a089
--- /dev/null
+++ b/include/linux/panic.h
@@ -0,0 +1,98 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PANIC_H
+#define _LINUX_PANIC_H
+
+#include <linux/compiler_attributes.h>
+#include <linux/types.h>
+
+struct pt_regs;
+
+extern long (*panic_blink)(int state);
+__printf(1, 2)
+void panic(const char *fmt, ...) __noreturn __cold;
+void nmi_panic(struct pt_regs *regs, const char *msg);
+extern void oops_enter(void);
+extern void oops_exit(void);
+extern bool oops_may_print(void);
+
+#ifdef CONFIG_SMP
+extern unsigned int sysctl_oops_all_cpu_backtrace;
+#else
+#define sysctl_oops_all_cpu_backtrace 0
+#endif /* CONFIG_SMP */
+
+extern int panic_timeout;
+extern unsigned long panic_print;
+extern int panic_on_oops;
+extern int panic_on_unrecovered_nmi;
+extern int panic_on_io_nmi;
+extern int panic_on_warn;
+
+extern unsigned long panic_on_taint;
+extern bool panic_on_taint_nousertaint;
+
+extern int sysctl_panic_on_rcu_stall;
+extern int sysctl_max_rcu_stall_to_panic;
+extern int sysctl_panic_on_stackoverflow;
+
+extern bool crash_kexec_post_notifiers;
+
+/*
+ * panic_cpu is used for synchronizing panic() and crash_kexec() execution. It
+ * holds a CPU number which is executing panic() currently. A value of
+ * PANIC_CPU_INVALID means no CPU has entered panic() or crash_kexec().
+ */
+extern atomic_t panic_cpu;
+#define PANIC_CPU_INVALID	-1
+
+/*
+ * Only to be used by arch init code. If the user over-wrote the default
+ * CONFIG_PANIC_TIMEOUT, honor it.
+ */
+static inline void set_arch_panic_timeout(int timeout, int arch_default_timeout)
+{
+	if (panic_timeout == arch_default_timeout)
+		panic_timeout = timeout;
+}
+
+/* This cannot be an enum because some may be used in assembly source. */
+#define TAINT_PROPRIETARY_MODULE	0
+#define TAINT_FORCED_MODULE		1
+#define TAINT_CPU_OUT_OF_SPEC		2
+#define TAINT_FORCED_RMMOD		3
+#define TAINT_MACHINE_CHECK		4
+#define TAINT_BAD_PAGE			5
+#define TAINT_USER			6
+#define TAINT_DIE			7
+#define TAINT_OVERRIDDEN_ACPI_TABLE	8
+#define TAINT_WARN			9
+#define TAINT_CRAP			10
+#define TAINT_FIRMWARE_WORKAROUND	11
+#define TAINT_OOT_MODULE		12
+#define TAINT_UNSIGNED_MODULE		13
+#define TAINT_SOFTLOCKUP		14
+#define TAINT_LIVEPATCH			15
+#define TAINT_AUX			16
+#define TAINT_RANDSTRUCT		17
+#define TAINT_FLAGS_COUNT		18
+#define TAINT_FLAGS_MAX			((1UL << TAINT_FLAGS_COUNT) - 1)
+
+struct taint_flag {
+	char c_true;	/* character printed when tainted */
+	char c_false;	/* character printed when not tainted */
+	bool module;	/* also show as a per-module taint flag */
+};
+
+extern const struct taint_flag taint_flags[TAINT_FLAGS_COUNT];
+
+enum lockdep_ok {
+	LOCKDEP_STILL_OK,
+	LOCKDEP_NOW_UNRELIABLE,
+};
+
+extern const char *print_tainted(void);
+extern void add_taint(unsigned flag, enum lockdep_ok);
+extern int test_taint(unsigned flag);
+extern unsigned long get_taint(void);
+
+#endif	/* _LINUX_PANIC_H */
diff --git a/include/linux/panic_notifier.h b/include/linux/panic_notifier.h
new file mode 100644
index 000000000000..41e32483d7a7
--- /dev/null
+++ b/include/linux/panic_notifier.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PANIC_NOTIFIERS_H
+#define _LINUX_PANIC_NOTIFIERS_H
+
+#include <linux/notifier.h>
+#include <linux/types.h>
+
+extern struct atomic_notifier_head panic_notifier_list;
+
+extern bool crash_kexec_post_notifiers;
+
+#endif	/* _LINUX_PANIC_NOTIFIERS_H */
diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index bb2e3e15c84c..2871076e4d29 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -15,6 +15,7 @@
 #include <linux/kthread.h>
 #include <linux/lockdep.h>
 #include <linux/export.h>
+#include <linux/panic_notifier.h>
 #include <linux/sysctl.h>
 #include <linux/suspend.h>
 #include <linux/utsname.h>
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index f099baee3578..4b34a9aa32bc 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -26,6 +26,7 @@
 #include <linux/suspend.h>
 #include <linux/device.h>
 #include <linux/freezer.h>
+#include <linux/panic_notifier.h>
 #include <linux/pm.h>
 #include <linux/cpu.h>
 #include <linux/uaccess.h>
diff --git a/kernel/panic.c b/kernel/panic.c
index 332736a72a58..edad89660a2b 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -23,6 +23,7 @@
 #include <linux/reboot.h>
 #include <linux/delay.h>
 #include <linux/kexec.h>
+#include <linux/panic_notifier.h>
 #include <linux/sched.h>
 #include <linux/sysrq.h>
 #include <linux/init.h>
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 3a5fef9fc934..faa847ce28cd 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -32,6 +32,8 @@
 #include <linux/export.h>
 #include <linux/completion.h>
 #include <linux/moduleparam.h>
+#include <linux/panic.h>
+#include <linux/panic_notifier.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 6e0b77f1117c..304be14fa09b 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -27,6 +27,7 @@
 #include <linux/sysctl.h>
 #include <linux/bitmap.h>
 #include <linux/signal.h>
+#include <linux/panic.h>
 #include <linux/printk.h>
 #include <linux/proc_fs.h>
 #include <linux/security.h>
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 560e4c8d3825..1c4e702133e8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -39,6 +39,7 @@
 #include <linux/slab.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
+#include <linux/panic_notifier.h>
 #include <linux/poll.h>
 #include <linux/nmi.h>
 #include <linux/fs.h>
-- 
2.30.2

