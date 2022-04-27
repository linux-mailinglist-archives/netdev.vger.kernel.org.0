Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E73351264F
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240012AbiD0XBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 19:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240832AbiD0W7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:59:39 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14413B3DF1;
        Wed, 27 Apr 2022 15:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UUXOjzoPDzZBxDSM8+K/LI8aYgpN2c+7zHoVbuhOqsQ=; b=GGfx5lsx2iN56x4Z6fieodmwsm
        q5qfqcY1rIx/L0anA1ZhdBtfQ+C+QCp0EQXWthQC9bhiRHlIzjMM6Fai8Z+t+xthEq/n/fGHRhca/
        t9Tdct8qfeyGi9778oHb6Zp3iyEA8AXWsWrvXe98bM5ZSZw4rYAVPyzYJKBGFZSDrdbdRw4ILVA7u
        KrQ45Y/jrJev8kEITG8FJSs6FiCCu2Z5s5Ob31DxZ15wgRyUmwlyCjKzYxUnHRGrORvmLbjL/1wFO
        iOOLnSiYgX9k/pD9XDR6G4JrDmutJFroQFiYtMUVMnYe6vm1fC5e6345ak3oNfUcNqnNarGdGEYIA
        SoanUEvg==;
Received: from [179.113.53.197] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1njqZ3-0002M7-VZ; Thu, 28 Apr 2022 00:55:19 +0200
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
        will@kernel.org, Alex Elder <elder@kernel.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Chris Zankel <chris@zankel.net>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Corey Minyard <minyard@acm.org>,
        Dexuan Cui <decui@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Helge Deller <deller@gmx.de>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        James Morse <james.morse@arm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Matt Turner <mattst88@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
        Richard Henderson <rth@twiddle.net>,
        Richard Weinberger <richard@nod.at>,
        Robert Richter <rric@kernel.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Vasily Gorbik <gor@linux.ibm.com>, Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 21/30] panic: Introduce the panic pre-reboot notifier list
Date:   Wed, 27 Apr 2022 19:49:15 -0300
Message-Id: <20220427224924.592546-22-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220427224924.592546-1-gpiccoli@igalia.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch renames the panic_notifier_list to panic_pre_reboot_list;
the idea is that a subsequent patch will refactor the panic path
in order to better split the notifiers, running some of them very
early, some of them not so early [but still before kmsg_dump()] and
finally, the rest should execute late, after kdump. The latter ones
are now in the panic pre-reboot list - the name comes from the idea
that these notifiers execute before panic() attempts rebooting the
machine (if that option is set).

We also took the opportunity to clean-up useless header inclusions,
improve some notifier block declarations (e.g. in ibmasm/heartbeat.c)
and more important, change some priorities - we hereby set 2 notifiers
to run late in the list [iss_panic_event() and the IPMI panic_event()]
due to the risks they offer (may not return, for example).
Proper documentation is going to be provided in a subsequent patch,
that effectively refactors the panic path.

Cc: Alex Elder <elder@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Corey Minyard <minyard@acm.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: James Morse <james.morse@arm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Juergen Gross <jgross@suse.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Richard Weinberger <richard@nod.at>
Cc: Robert Richter <rric@kernel.org>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---

Notice that, with this name change, out-of-tree code that relies in the global
exported "panic_notifier_list" will fail to build. We could easily keep the
retro-compatibility by making the old symbol to still exist and point to the
pre_reboot list (or even, keep the old naming).

But our design choice was to allow the breakage, making users rethink their
notifiers, adding them in the list that fits best. If that wasn't a good
decision, we're open to change it, of course.
Thanks in advance for the review!

 arch/alpha/kernel/setup.c             |  4 ++--
 arch/parisc/kernel/pdc_chassis.c      |  3 +--
 arch/powerpc/kernel/setup-common.c    |  2 +-
 arch/s390/kernel/ipl.c                |  4 ++--
 arch/um/drivers/mconsole_kern.c       |  2 +-
 arch/um/kernel/um_arch.c              |  2 +-
 arch/x86/xen/enlighten.c              |  2 +-
 arch/xtensa/platforms/iss/setup.c     |  4 ++--
 drivers/char/ipmi/ipmi_msghandler.c   | 12 +++++++-----
 drivers/edac/altera_edac.c            |  3 +--
 drivers/hv/vmbus_drv.c                |  4 ++--
 drivers/leds/trigger/ledtrig-panic.c  |  3 +--
 drivers/misc/ibmasm/heartbeat.c       | 16 +++++++++-------
 drivers/net/ipa/ipa_smp2p.c           |  5 ++---
 drivers/parisc/power.c                |  4 ++--
 drivers/remoteproc/remoteproc_core.c  |  6 ++++--
 drivers/s390/char/con3215.c           |  2 +-
 drivers/s390/char/con3270.c           |  2 +-
 drivers/s390/char/sclp_con.c          |  2 +-
 drivers/s390/char/sclp_vt220.c        |  2 +-
 drivers/staging/olpc_dcon/olpc_dcon.c |  6 ++++--
 drivers/video/fbdev/hyperv_fb.c       |  4 ++--
 include/linux/panic_notifier.h        |  2 +-
 kernel/panic.c                        |  9 ++++-----
 24 files changed, 54 insertions(+), 51 deletions(-)

diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
index d88bdf852753..8ace0d7113b6 100644
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -472,8 +472,8 @@ setup_arch(char **cmdline_p)
 	}
 
 	/* Register a call for panic conditions. */
-	atomic_notifier_chain_register(&panic_notifier_list,
-			&alpha_panic_block);
+	atomic_notifier_chain_register(&panic_pre_reboot_list,
+					&alpha_panic_block);
 
 #ifndef alpha_using_srm
 	/* Assume that we've booted from SRM if we haven't booted from MILO.
diff --git a/arch/parisc/kernel/pdc_chassis.c b/arch/parisc/kernel/pdc_chassis.c
index da154406d368..0fd8d87fb4f9 100644
--- a/arch/parisc/kernel/pdc_chassis.c
+++ b/arch/parisc/kernel/pdc_chassis.c
@@ -22,7 +22,6 @@
 #include <linux/kernel.h>
 #include <linux/panic_notifier.h>
 #include <linux/reboot.h>
-#include <linux/notifier.h>
 #include <linux/cache.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
@@ -135,7 +134,7 @@ void __init parisc_pdc_chassis_init(void)
 				PDC_CHASSIS_VER);
 
 		/* initialize panic notifier chain */
-		atomic_notifier_chain_register(&panic_notifier_list,
+		atomic_notifier_chain_register(&panic_pre_reboot_list,
 				&pdc_chassis_panic_block);
 
 		/* initialize reboot notifier chain */
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index d04b8bf8dbc7..3518bebc10ad 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -762,7 +762,7 @@ void __init setup_panic(void)
 
 	/* Low-level platform-specific routines that should run on panic */
 	if (ppc_md.panic)
-		atomic_notifier_chain_register(&panic_notifier_list,
+		atomic_notifier_chain_register(&panic_pre_reboot_list,
 					       &ppc_panic_block);
 }
 
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 1cc85b8ff42e..4a88c5bb6e15 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -2034,7 +2034,7 @@ static int on_panic_notify(struct notifier_block *self,
 			   unsigned long event, void *data)
 {
 	do_panic();
-	return NOTIFY_OK;
+	return NOTIFY_DONE;
 }
 
 static struct notifier_block on_panic_nb = {
@@ -2069,7 +2069,7 @@ void __init setup_ipl(void)
 		/* We have no info to copy */
 		break;
 	}
-	atomic_notifier_chain_register(&panic_notifier_list, &on_panic_nb);
+	atomic_notifier_chain_register(&panic_pre_reboot_list, &on_panic_nb);
 }
 
 void s390_reset_system(void)
diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index 2ea0421bcc3f..21c13b4e24a3 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -855,7 +855,7 @@ static struct notifier_block panic_exit_notifier = {
 
 static int add_notifier(void)
 {
-	atomic_notifier_chain_register(&panic_notifier_list,
+	atomic_notifier_chain_register(&panic_pre_reboot_list,
 			&panic_exit_notifier);
 	return 0;
 }
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 4485b1a7c8e4..fc6e443299da 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -257,7 +257,7 @@ static struct notifier_block panic_exit_notifier = {
 
 void uml_finishsetup(void)
 {
-	atomic_notifier_chain_register(&panic_notifier_list,
+	atomic_notifier_chain_register(&panic_pre_reboot_list,
 				       &panic_exit_notifier);
 
 	uml_postsetup();
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 30c6e986a6cd..d4f4de239a21 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -290,7 +290,7 @@ static struct notifier_block xen_panic_block = {
 
 int xen_panic_handler_init(void)
 {
-	atomic_notifier_chain_register(&panic_notifier_list, &xen_panic_block);
+	atomic_notifier_chain_register(&panic_pre_reboot_list, &xen_panic_block);
 	return 0;
 }
 
diff --git a/arch/xtensa/platforms/iss/setup.c b/arch/xtensa/platforms/iss/setup.c
index d3433e1bb94e..eeeeb6cff6bd 100644
--- a/arch/xtensa/platforms/iss/setup.c
+++ b/arch/xtensa/platforms/iss/setup.c
@@ -13,7 +13,6 @@
  */
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/notifier.h>
 #include <linux/panic_notifier.h>
 #include <linux/printk.h>
 #include <linux/string.h>
@@ -53,6 +52,7 @@ iss_panic_event(struct notifier_block *this, unsigned long event, void *ptr)
 
 static struct notifier_block iss_panic_block = {
 	.notifier_call = iss_panic_event,
+	.priority = INT_MIN, /* run as late as possible, may not return */
 };
 
 void __init platform_setup(char **p_cmdline)
@@ -81,5 +81,5 @@ void __init platform_setup(char **p_cmdline)
 		}
 	}
 
-	atomic_notifier_chain_register(&panic_notifier_list, &iss_panic_block);
+	atomic_notifier_chain_register(&panic_pre_reboot_list, &iss_panic_block);
 }
diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index c59265146e9c..6c4770949c01 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -25,7 +25,6 @@
 #include <linux/slab.h>
 #include <linux/ipmi.h>
 #include <linux/ipmi_smi.h>
-#include <linux/notifier.h>
 #include <linux/init.h>
 #include <linux/proc_fs.h>
 #include <linux/rcupdate.h>
@@ -5375,10 +5374,13 @@ static int ipmi_register_driver(void)
 	return rv;
 }
 
+/*
+ * we should execute this panic callback late, since it involves
+ * a complex call-chain and panic() runs in atomic context.
+ */
 static struct notifier_block panic_block = {
 	.notifier_call	= panic_event,
-	.next		= NULL,
-	.priority	= 200	/* priority: INT_MAX >= x >= 0 */
+	.priority	= INT_MIN + 1,
 };
 
 static int ipmi_init_msghandler(void)
@@ -5406,7 +5408,7 @@ static int ipmi_init_msghandler(void)
 	timer_setup(&ipmi_timer, ipmi_timeout, 0);
 	mod_timer(&ipmi_timer, jiffies + IPMI_TIMEOUT_JIFFIES);
 
-	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
+	atomic_notifier_chain_register(&panic_pre_reboot_list, &panic_block);
 
 	initialized = true;
 
@@ -5438,7 +5440,7 @@ static void __exit cleanup_ipmi(void)
 	if (initialized) {
 		destroy_workqueue(remove_work_wq);
 
-		atomic_notifier_chain_unregister(&panic_notifier_list,
+		atomic_notifier_chain_unregister(&panic_pre_reboot_list,
 						 &panic_block);
 
 		/*
diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
index e7e8e624a436..4890e9cba6fb 100644
--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/mfd/altera-sysmgr.h>
 #include <linux/mfd/syscon.h>
-#include <linux/notifier.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
@@ -2163,7 +2162,7 @@ static int altr_edac_a10_probe(struct platform_device *pdev)
 		int dberror, err_addr;
 
 		edac->panic_notifier.notifier_call = s10_edac_dberr_handler;
-		atomic_notifier_chain_register(&panic_notifier_list,
+		atomic_notifier_chain_register(&panic_pre_reboot_list,
 					       &edac->panic_notifier);
 
 		/* Printout a message if uncorrectable error previously. */
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 901b97034308..3717c323aa36 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1622,7 +1622,7 @@ static int vmbus_bus_init(void)
 	 * Always register the vmbus unload panic notifier because we
 	 * need to shut the VMbus channel connection on panic.
 	 */
-	atomic_notifier_chain_register(&panic_notifier_list,
+	atomic_notifier_chain_register(&panic_pre_reboot_list,
 			       &hyperv_panic_vmbus_unload_block);
 
 	vmbus_request_offers();
@@ -2851,7 +2851,7 @@ static void __exit vmbus_exit(void)
 	 * The vmbus panic notifier is always registered, hence we should
 	 * also unconditionally unregister it here as well.
 	 */
-	atomic_notifier_chain_unregister(&panic_notifier_list,
+	atomic_notifier_chain_unregister(&panic_pre_reboot_list,
 					&hyperv_panic_vmbus_unload_block);
 
 	free_page((unsigned long)hv_panic_page);
diff --git a/drivers/leds/trigger/ledtrig-panic.c b/drivers/leds/trigger/ledtrig-panic.c
index 64abf2e91608..34fd5170723f 100644
--- a/drivers/leds/trigger/ledtrig-panic.c
+++ b/drivers/leds/trigger/ledtrig-panic.c
@@ -7,7 +7,6 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/notifier.h>
 #include <linux/panic_notifier.h>
 #include <linux/leds.h>
 #include "../leds.h"
@@ -64,7 +63,7 @@ static long led_panic_blink(int state)
 
 static int __init ledtrig_panic_init(void)
 {
-	atomic_notifier_chain_register(&panic_notifier_list,
+	atomic_notifier_chain_register(&panic_pre_reboot_list,
 				       &led_trigger_panic_nb);
 
 	led_trigger_register_simple("panic", &trigger);
diff --git a/drivers/misc/ibmasm/heartbeat.c b/drivers/misc/ibmasm/heartbeat.c
index 59c9a0d95659..d6acae88b722 100644
--- a/drivers/misc/ibmasm/heartbeat.c
+++ b/drivers/misc/ibmasm/heartbeat.c
@@ -8,7 +8,6 @@
  * Author: Max Asböck <amax@us.ibm.com>
  */
 
-#include <linux/notifier.h>
 #include <linux/panic_notifier.h>
 #include "ibmasm.h"
 #include "dot_command.h"
@@ -24,7 +23,7 @@ static int suspend_heartbeats = 0;
  * In the case of a panic the interrupt handler continues to work and thus
  * continues to respond to heartbeats, making the service processor believe
  * the OS is still running and thus preventing a reboot.
- * To prevent this from happening a callback is added the panic_notifier_list.
+ * To prevent this from happening a callback is added in a panic notifier list.
  * Before responding to a heartbeat the driver checks if a panic has happened,
  * if yes it suspends heartbeat, causing the service processor to reboot as
  * expected.
@@ -32,20 +31,23 @@ static int suspend_heartbeats = 0;
 static int panic_happened(struct notifier_block *n, unsigned long val, void *v)
 {
 	suspend_heartbeats = 1;
-	return 0;
+	return NOTIFY_DONE;
 }
 
-static struct notifier_block panic_notifier = { panic_happened, NULL, 1 };
+static struct notifier_block panic_notifier = {
+	.notifier_call = panic_happened,
+};
 
 void ibmasm_register_panic_notifier(void)
 {
-	atomic_notifier_chain_register(&panic_notifier_list, &panic_notifier);
+	atomic_notifier_chain_register(&panic_pre_reboot_list,
+					&panic_notifier);
 }
 
 void ibmasm_unregister_panic_notifier(void)
 {
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-			&panic_notifier);
+	atomic_notifier_chain_unregister(&panic_pre_reboot_list,
+					&panic_notifier);
 }
 
 
diff --git a/drivers/net/ipa/ipa_smp2p.c b/drivers/net/ipa/ipa_smp2p.c
index 211233612039..92cdf6e0637c 100644
--- a/drivers/net/ipa/ipa_smp2p.c
+++ b/drivers/net/ipa/ipa_smp2p.c
@@ -7,7 +7,6 @@
 #include <linux/types.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
-#include <linux/notifier.h>
 #include <linux/panic_notifier.h>
 #include <linux/pm_runtime.h>
 #include <linux/soc/qcom/smem.h>
@@ -138,13 +137,13 @@ static int ipa_smp2p_panic_notifier_register(struct ipa_smp2p *smp2p)
 	smp2p->panic_notifier.notifier_call = ipa_smp2p_panic_notifier;
 	smp2p->panic_notifier.priority = INT_MAX;	/* Do it early */
 
-	return atomic_notifier_chain_register(&panic_notifier_list,
+	return atomic_notifier_chain_register(&panic_pre_reboot_list,
 					      &smp2p->panic_notifier);
 }
 
 static void ipa_smp2p_panic_notifier_unregister(struct ipa_smp2p *smp2p)
 {
-	atomic_notifier_chain_unregister(&panic_notifier_list,
+	atomic_notifier_chain_unregister(&panic_pre_reboot_list,
 					 &smp2p->panic_notifier);
 }
 
diff --git a/drivers/parisc/power.c b/drivers/parisc/power.c
index 8512884de2cf..5bb0868f5f08 100644
--- a/drivers/parisc/power.c
+++ b/drivers/parisc/power.c
@@ -233,7 +233,7 @@ static int __init power_init(void)
 	}
 
 	/* Register a call for panic conditions. */
-	atomic_notifier_chain_register(&panic_notifier_list,
+	atomic_notifier_chain_register(&panic_pre_reboot_list,
 			&parisc_panic_block);
 
 	return 0;
@@ -243,7 +243,7 @@ static void __exit power_exit(void)
 {
 	kthread_stop(power_task);
 
-	atomic_notifier_chain_unregister(&panic_notifier_list,
+	atomic_notifier_chain_unregister(&panic_pre_reboot_list,
 			&parisc_panic_block);
 
 	pdc_soft_power_button(0);
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index c510125769b9..24799ff239e6 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -2795,12 +2795,14 @@ static int rproc_panic_handler(struct notifier_block *nb, unsigned long event,
 static void __init rproc_init_panic(void)
 {
 	rproc_panic_nb.notifier_call = rproc_panic_handler;
-	atomic_notifier_chain_register(&panic_notifier_list, &rproc_panic_nb);
+	atomic_notifier_chain_register(&panic_pre_reboot_list,
+				       &rproc_panic_nb);
 }
 
 static void __exit rproc_exit_panic(void)
 {
-	atomic_notifier_chain_unregister(&panic_notifier_list, &rproc_panic_nb);
+	atomic_notifier_chain_unregister(&panic_pre_reboot_list,
+					 &rproc_panic_nb);
 }
 
 static int __init remoteproc_init(void)
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 192198bd3dc4..07379dd3f1f3 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -867,7 +867,7 @@ static int __init con3215_init(void)
 		raw3215[0] = NULL;
 		return -ENODEV;
 	}
-	atomic_notifier_chain_register(&panic_notifier_list, &on_panic_nb);
+	atomic_notifier_chain_register(&panic_pre_reboot_list, &on_panic_nb);
 	register_reboot_notifier(&on_reboot_nb);
 	register_console(&con3215);
 	return 0;
diff --git a/drivers/s390/char/con3270.c b/drivers/s390/char/con3270.c
index 476202f3d8a0..e79bf3e7bde3 100644
--- a/drivers/s390/char/con3270.c
+++ b/drivers/s390/char/con3270.c
@@ -645,7 +645,7 @@ con3270_init(void)
 	condev->cline->len = 0;
 	con3270_create_status(condev);
 	condev->input = alloc_string(&condev->freemem, 80);
-	atomic_notifier_chain_register(&panic_notifier_list, &on_panic_nb);
+	atomic_notifier_chain_register(&panic_pre_reboot_list, &on_panic_nb);
 	register_reboot_notifier(&on_reboot_nb);
 	register_console(&con3270);
 	return 0;
diff --git a/drivers/s390/char/sclp_con.c b/drivers/s390/char/sclp_con.c
index e5d947c763ea..7ca9d4c45d60 100644
--- a/drivers/s390/char/sclp_con.c
+++ b/drivers/s390/char/sclp_con.c
@@ -288,7 +288,7 @@ sclp_console_init(void)
 	timer_setup(&sclp_con_timer, sclp_console_timeout, 0);
 
 	/* enable printk-access to this driver */
-	atomic_notifier_chain_register(&panic_notifier_list, &on_panic_nb);
+	atomic_notifier_chain_register(&panic_pre_reboot_list, &on_panic_nb);
 	register_reboot_notifier(&on_reboot_nb);
 	register_console(&sclp_console);
 	return 0;
diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index a32f34a1c6d2..97cf9e290c28 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -838,7 +838,7 @@ sclp_vt220_con_init(void)
 	if (rc)
 		return rc;
 	/* Attach linux console */
-	atomic_notifier_chain_register(&panic_notifier_list, &on_panic_nb);
+	atomic_notifier_chain_register(&panic_pre_reboot_list, &on_panic_nb);
 	register_reboot_notifier(&on_reboot_nb);
 	register_console(&sclp_vt220_console);
 	return 0;
diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 7284cb4ac395..cb50471f2246 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -653,7 +653,8 @@ static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 
 	register_reboot_notifier(&dcon->reboot_nb);
-	atomic_notifier_chain_register(&panic_notifier_list, &dcon_panic_nb);
+	atomic_notifier_chain_register(&panic_pre_reboot_list,
+				       &dcon_panic_nb);
 
 	return 0;
 
@@ -676,7 +677,8 @@ static int dcon_remove(struct i2c_client *client)
 	struct dcon_priv *dcon = i2c_get_clientdata(client);
 
 	unregister_reboot_notifier(&dcon->reboot_nb);
-	atomic_notifier_chain_unregister(&panic_notifier_list, &dcon_panic_nb);
+	atomic_notifier_chain_unregister(&panic_pre_reboot_list,
+					 &dcon_panic_nb);
 
 	free_irq(DCON_IRQ, dcon);
 
diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index f3494b868a64..ec21e63592be 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -1253,7 +1253,7 @@ static int hvfb_probe(struct hv_device *hdev,
 	 */
 	par->hvfb_panic_nb.notifier_call = hvfb_on_panic;
 	par->hvfb_panic_nb.priority = INT_MIN + 10,
-	atomic_notifier_chain_register(&panic_notifier_list,
+	atomic_notifier_chain_register(&panic_pre_reboot_list,
 				       &par->hvfb_panic_nb);
 
 	return 0;
@@ -1276,7 +1276,7 @@ static int hvfb_remove(struct hv_device *hdev)
 	struct fb_info *info = hv_get_drvdata(hdev);
 	struct hvfb_par *par = info->par;
 
-	atomic_notifier_chain_unregister(&panic_notifier_list,
+	atomic_notifier_chain_unregister(&panic_pre_reboot_list,
 					 &par->hvfb_panic_nb);
 
 	par->update = false;
diff --git a/include/linux/panic_notifier.h b/include/linux/panic_notifier.h
index 7364a346bcb0..7912aacbc0e5 100644
--- a/include/linux/panic_notifier.h
+++ b/include/linux/panic_notifier.h
@@ -5,9 +5,9 @@
 #include <linux/notifier.h>
 #include <linux/types.h>
 
-extern struct atomic_notifier_head panic_notifier_list;
 extern struct atomic_notifier_head panic_hypervisor_list;
 extern struct atomic_notifier_head panic_info_list;
+extern struct atomic_notifier_head panic_pre_reboot_list;
 
 extern bool crash_kexec_post_notifiers;
 
diff --git a/kernel/panic.c b/kernel/panic.c
index 73ca1bc44e30..a9d43b98b05b 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -69,16 +69,15 @@ EXPORT_SYMBOL_GPL(panic_timeout);
 #define PANIC_PRINT_ALL_CPU_BT		0x00000040
 unsigned long panic_print;
 
-ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
-
-EXPORT_SYMBOL(panic_notifier_list);
-
 ATOMIC_NOTIFIER_HEAD(panic_hypervisor_list);
 EXPORT_SYMBOL(panic_hypervisor_list);
 
 ATOMIC_NOTIFIER_HEAD(panic_info_list);
 EXPORT_SYMBOL(panic_info_list);
 
+ATOMIC_NOTIFIER_HEAD(panic_pre_reboot_list);
+EXPORT_SYMBOL(panic_pre_reboot_list);
+
 static long no_blink(int state)
 {
 	return 0;
@@ -295,7 +294,7 @@ void panic(const char *fmt, ...)
 	 */
 	atomic_notifier_call_chain(&panic_hypervisor_list, PANIC_NOTIFIER, buf);
 	atomic_notifier_call_chain(&panic_info_list, PANIC_NOTIFIER, buf);
-	atomic_notifier_call_chain(&panic_notifier_list, PANIC_NOTIFIER, buf);
+	atomic_notifier_call_chain(&panic_pre_reboot_list, PANIC_NOTIFIER, buf);
 
 	panic_print_sys_info(false);
 
-- 
2.36.0

