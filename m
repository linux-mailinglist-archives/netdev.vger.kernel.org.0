Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3773512644
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238414AbiD0XAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 19:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240061AbiD0W7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:59:09 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D119B368D;
        Wed, 27 Apr 2022 15:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UhhPFJqW26A1a6soa6rznnjXRjwvDkXyweuhXfNQOVY=; b=MKBh56UTZ7JCBvBjxeK61V4jDM
        v7kwzQJKazlMRxSRc2ZqArefnMuAMvJRSN0Dm/n3rUqjfn87xJdCwCNZgYYInNcW7KLaZieSBQ8O6
        XsgLVHkw+gGyoqVfpHoR7HGpc4dRel8YFV0PNkyLnVjOtFb6zpg44r32e+Cy7IowfRZ1AwUGXIuJK
        ogEnepSyse/P/gSxYI2obKAoqpGM2oj0KXhOmKybDbZdIj++zZDEM0H4AKnIRoCEV72z/ad5u+yfX
        mziNZTi1DoyU2ltDkam4BhJMX4t8MGH4SNKViSUOE5Td2/P7EGuXXRrbm7W62coqKt68Zw2u7NGpT
        +e52kJVw==;
Received: from [179.113.53.197] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1njqYb-0002JS-Nh; Thu, 28 Apr 2022 00:54:50 +0200
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
        will@kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        David Gow <davidgow@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Doug Berger <opendmb@gmail.com>,
        Evan Green <evgreen@chromium.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hari Bathini <hbathini@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Julius Werner <jwerner@chromium.org>,
        Justin Chen <justinpopo6@gmail.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Lee Jones <lee.jones@linaro.org>,
        Markus Mayer <mmayer@broadcom.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
        Scott Branden <scott.branden@broadcom.com>,
        Sebastian Reichel <sre@kernel.org>,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Wei Liu <wei.liu@kernel.org>,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH 19/30] panic: Add the panic hypervisor notifier list
Date:   Wed, 27 Apr 2022 19:49:13 -0300
Message-Id: <20220427224924.592546-20-gpiccoli@igalia.com>
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

The goal of this new panic notifier is to allow its users to register
callbacks to run very early in the panic path. This aims hypervisor/FW
notification mechanisms as well as simple LED functions, and any other
simple and safe mechanism that should run early in the panic path; more
dangerous callbacks should execute later.

For now, the patch is almost a no-op (although it changes a bit the
ordering in which some panic notifiers are executed). In a subsequent
patch, the panic path will be refactored, then the panic hypervisor
notifiers will effectively run very early in the panic path.

We also defer documenting it all properly in the subsequent refactor
patch. While at it, we removed some useless header inclusions and
fixed some notifiers return too (by using the standard NOTIFY_DONE).

Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brian Norris <computersforpeace@gmail.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: David Gow <davidgow@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Evan Green <evgreen@chromium.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Julius Werner <jwerner@chromium.org>
Cc: Justin Chen <justinpopo6@gmail.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Markus Mayer <mmayer@broadcom.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michael Kelley <mikelley@microsoft.com>
Cc: Mihai Carabas <mihai.carabas@oracle.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Scott Branden <scott.branden@broadcom.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Shile Zhang <shile.zhang@linux.alibaba.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Tianyu Lan <Tianyu.Lan@microsoft.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Wang ShaoBo <bobo.shaobowang@huawei.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: zhenwei pi <pizhenwei@bytedance.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---
 arch/mips/sgi-ip22/ip22-reset.c          | 2 +-
 arch/mips/sgi-ip32/ip32-reset.c          | 3 +--
 arch/powerpc/kernel/setup-common.c       | 2 +-
 arch/sparc/kernel/sstate.c               | 3 +--
 drivers/firmware/google/gsmi.c           | 4 ++--
 drivers/hv/vmbus_drv.c                   | 4 ++--
 drivers/leds/trigger/ledtrig-activity.c  | 4 ++--
 drivers/leds/trigger/ledtrig-heartbeat.c | 4 ++--
 drivers/misc/bcm-vk/bcm_vk_dev.c         | 6 +++---
 drivers/misc/pvpanic/pvpanic.c           | 4 ++--
 drivers/power/reset/ltc2952-poweroff.c   | 4 ++--
 drivers/s390/char/zcore.c                | 5 +++--
 drivers/soc/bcm/brcmstb/pm/pm-arm.c      | 2 +-
 include/linux/panic_notifier.h           | 1 +
 kernel/panic.c                           | 4 ++++
 15 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/arch/mips/sgi-ip22/ip22-reset.c b/arch/mips/sgi-ip22/ip22-reset.c
index 8f0861c58080..3023848acbf1 100644
--- a/arch/mips/sgi-ip22/ip22-reset.c
+++ b/arch/mips/sgi-ip22/ip22-reset.c
@@ -195,7 +195,7 @@ static int __init reboot_setup(void)
 	}
 
 	timer_setup(&blink_timer, blink_timeout, 0);
-	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
+	atomic_notifier_chain_register(&panic_hypervisor_list, &panic_block);
 
 	return 0;
 }
diff --git a/arch/mips/sgi-ip32/ip32-reset.c b/arch/mips/sgi-ip32/ip32-reset.c
index 18d1c115cd53..9ee1302c9d13 100644
--- a/arch/mips/sgi-ip32/ip32-reset.c
+++ b/arch/mips/sgi-ip32/ip32-reset.c
@@ -15,7 +15,6 @@
 #include <linux/panic_notifier.h>
 #include <linux/sched.h>
 #include <linux/sched/signal.h>
-#include <linux/notifier.h>
 #include <linux/delay.h>
 #include <linux/rtc/ds1685.h>
 #include <linux/interrupt.h>
@@ -145,7 +144,7 @@ static __init int ip32_reboot_setup(void)
 	pm_power_off = ip32_machine_halt;
 
 	timer_setup(&blink_timer, blink_timeout, 0);
-	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
+	atomic_notifier_chain_register(&panic_hypervisor_list, &panic_block);
 
 	return 0;
 }
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 52f96b209a96..1468c3937bf4 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -753,7 +753,7 @@ static struct notifier_block ppc_panic_block = {
 void __init setup_panic(void)
 {
 	/* Hard-disables IRQs + deal with FW-assisted dump (fadump) */
-	atomic_notifier_chain_register(&panic_notifier_list,
+	atomic_notifier_chain_register(&panic_hypervisor_list,
 				       &ppc_fadump_block);
 
 	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && kaslr_offset() > 0)
diff --git a/arch/sparc/kernel/sstate.c b/arch/sparc/kernel/sstate.c
index 3bcc4ddc6911..82b7b68e0bdc 100644
--- a/arch/sparc/kernel/sstate.c
+++ b/arch/sparc/kernel/sstate.c
@@ -5,7 +5,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/notifier.h>
 #include <linux/panic_notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
@@ -106,7 +105,7 @@ static int __init sstate_init(void)
 
 	do_set_sstate(HV_SOFT_STATE_TRANSITION, booting_msg);
 
-	atomic_notifier_chain_register(&panic_notifier_list,
+	atomic_notifier_chain_register(&panic_hypervisor_list,
 				       &sstate_panic_block);
 	register_reboot_notifier(&sstate_reboot_notifier);
 
diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index b01ed02e4a87..ff0bebe2f444 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -1034,7 +1034,7 @@ static __init int gsmi_init(void)
 
 	register_reboot_notifier(&gsmi_reboot_notifier);
 	register_die_notifier(&gsmi_die_notifier);
-	atomic_notifier_chain_register(&panic_notifier_list,
+	atomic_notifier_chain_register(&panic_hypervisor_list,
 				       &gsmi_panic_notifier);
 
 	printk(KERN_INFO "gsmi version " DRIVER_VERSION " loaded\n");
@@ -1061,7 +1061,7 @@ static void __exit gsmi_exit(void)
 {
 	unregister_reboot_notifier(&gsmi_reboot_notifier);
 	unregister_die_notifier(&gsmi_die_notifier);
-	atomic_notifier_chain_unregister(&panic_notifier_list,
+	atomic_notifier_chain_unregister(&panic_hypervisor_list,
 					 &gsmi_panic_notifier);
 #ifdef CONFIG_EFI
 	efivars_unregister(&efivars);
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index f37f12d48001..901b97034308 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1614,7 +1614,7 @@ static int vmbus_bus_init(void)
 			hv_kmsg_dump_register();
 
 		register_die_notifier(&hyperv_die_report_block);
-		atomic_notifier_chain_register(&panic_notifier_list,
+		atomic_notifier_chain_register(&panic_hypervisor_list,
 						&hyperv_panic_report_block);
 	}
 
@@ -2843,7 +2843,7 @@ static void __exit vmbus_exit(void)
 	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE) {
 		kmsg_dump_unregister(&hv_kmsg_dumper);
 		unregister_die_notifier(&hyperv_die_report_block);
-		atomic_notifier_chain_unregister(&panic_notifier_list,
+		atomic_notifier_chain_unregister(&panic_hypervisor_list,
 						&hyperv_panic_report_block);
 	}
 
diff --git a/drivers/leds/trigger/ledtrig-activity.c b/drivers/leds/trigger/ledtrig-activity.c
index 30bc9df03636..bbbcf3bc17e3 100644
--- a/drivers/leds/trigger/ledtrig-activity.c
+++ b/drivers/leds/trigger/ledtrig-activity.c
@@ -247,7 +247,7 @@ static int __init activity_init(void)
 	int rc = led_trigger_register(&activity_led_trigger);
 
 	if (!rc) {
-		atomic_notifier_chain_register(&panic_notifier_list,
+		atomic_notifier_chain_register(&panic_hypervisor_list,
 					       &activity_panic_nb);
 		register_reboot_notifier(&activity_reboot_nb);
 	}
@@ -257,7 +257,7 @@ static int __init activity_init(void)
 static void __exit activity_exit(void)
 {
 	unregister_reboot_notifier(&activity_reboot_nb);
-	atomic_notifier_chain_unregister(&panic_notifier_list,
+	atomic_notifier_chain_unregister(&panic_hypervisor_list,
 					 &activity_panic_nb);
 	led_trigger_unregister(&activity_led_trigger);
 }
diff --git a/drivers/leds/trigger/ledtrig-heartbeat.c b/drivers/leds/trigger/ledtrig-heartbeat.c
index 7fe0a05574d2..a1ed25e83c8f 100644
--- a/drivers/leds/trigger/ledtrig-heartbeat.c
+++ b/drivers/leds/trigger/ledtrig-heartbeat.c
@@ -190,7 +190,7 @@ static int __init heartbeat_trig_init(void)
 	int rc = led_trigger_register(&heartbeat_led_trigger);
 
 	if (!rc) {
-		atomic_notifier_chain_register(&panic_notifier_list,
+		atomic_notifier_chain_register(&panic_hypervisor_list,
 					       &heartbeat_panic_nb);
 		register_reboot_notifier(&heartbeat_reboot_nb);
 	}
@@ -200,7 +200,7 @@ static int __init heartbeat_trig_init(void)
 static void __exit heartbeat_trig_exit(void)
 {
 	unregister_reboot_notifier(&heartbeat_reboot_nb);
-	atomic_notifier_chain_unregister(&panic_notifier_list,
+	atomic_notifier_chain_unregister(&panic_hypervisor_list,
 					 &heartbeat_panic_nb);
 	led_trigger_unregister(&heartbeat_led_trigger);
 }
diff --git a/drivers/misc/bcm-vk/bcm_vk_dev.c b/drivers/misc/bcm-vk/bcm_vk_dev.c
index a16b99bdaa13..d9d5199cdb2b 100644
--- a/drivers/misc/bcm-vk/bcm_vk_dev.c
+++ b/drivers/misc/bcm-vk/bcm_vk_dev.c
@@ -1446,7 +1446,7 @@ static int bcm_vk_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* register for panic notifier */
 	vk->panic_nb.notifier_call = bcm_vk_on_panic;
-	err = atomic_notifier_chain_register(&panic_notifier_list,
+	err = atomic_notifier_chain_register(&panic_hypervisor_list,
 					     &vk->panic_nb);
 	if (err) {
 		dev_err(dev, "Fail to register panic notifier\n");
@@ -1486,7 +1486,7 @@ static int bcm_vk_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	bcm_vk_tty_exit(vk);
 
 err_unregister_panic_notifier:
-	atomic_notifier_chain_unregister(&panic_notifier_list,
+	atomic_notifier_chain_unregister(&panic_hypervisor_list,
 					 &vk->panic_nb);
 
 err_destroy_workqueue:
@@ -1559,7 +1559,7 @@ static void bcm_vk_remove(struct pci_dev *pdev)
 	usleep_range(BCM_VK_UCODE_BOOT_US, BCM_VK_UCODE_BOOT_MAX_US);
 
 	/* unregister panic notifier */
-	atomic_notifier_chain_unregister(&panic_notifier_list,
+	atomic_notifier_chain_unregister(&panic_hypervisor_list,
 					 &vk->panic_nb);
 
 	bcm_vk_msg_remove(vk);
diff --git a/drivers/misc/pvpanic/pvpanic.c b/drivers/misc/pvpanic/pvpanic.c
index 049a12006348..233a71d89477 100644
--- a/drivers/misc/pvpanic/pvpanic.c
+++ b/drivers/misc/pvpanic/pvpanic.c
@@ -101,7 +101,7 @@ static int pvpanic_init(void)
 	INIT_LIST_HEAD(&pvpanic_list);
 	spin_lock_init(&pvpanic_lock);
 
-	atomic_notifier_chain_register(&panic_notifier_list, &pvpanic_panic_nb);
+	atomic_notifier_chain_register(&panic_hypervisor_list, &pvpanic_panic_nb);
 
 	return 0;
 }
@@ -109,7 +109,7 @@ module_init(pvpanic_init);
 
 static void pvpanic_exit(void)
 {
-	atomic_notifier_chain_unregister(&panic_notifier_list, &pvpanic_panic_nb);
+	atomic_notifier_chain_unregister(&panic_hypervisor_list, &pvpanic_panic_nb);
 
 }
 module_exit(pvpanic_exit);
diff --git a/drivers/power/reset/ltc2952-poweroff.c b/drivers/power/reset/ltc2952-poweroff.c
index 65d9528cc989..fb5078ba3a69 100644
--- a/drivers/power/reset/ltc2952-poweroff.c
+++ b/drivers/power/reset/ltc2952-poweroff.c
@@ -279,7 +279,7 @@ static int ltc2952_poweroff_probe(struct platform_device *pdev)
 	pm_power_off = ltc2952_poweroff_kill;
 
 	data->panic_notifier.notifier_call = ltc2952_poweroff_notify_panic;
-	atomic_notifier_chain_register(&panic_notifier_list,
+	atomic_notifier_chain_register(&panic_hypervisor_list,
 				       &data->panic_notifier);
 	dev_info(&pdev->dev, "probe successful\n");
 
@@ -293,7 +293,7 @@ static int ltc2952_poweroff_remove(struct platform_device *pdev)
 	pm_power_off = NULL;
 	hrtimer_cancel(&data->timer_trigger);
 	hrtimer_cancel(&data->timer_wde);
-	atomic_notifier_chain_unregister(&panic_notifier_list,
+	atomic_notifier_chain_unregister(&panic_hypervisor_list,
 					 &data->panic_notifier);
 	return 0;
 }
diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index 516783ba950f..768a8a3a9046 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -246,7 +246,7 @@ static int zcore_reboot_and_on_panic_handler(struct notifier_block *self,
 	if (hsa_available)
 		release_hsa();
 
-	return NOTIFY_OK;
+	return NOTIFY_DONE;
 }
 
 static struct notifier_block zcore_reboot_notifier = {
@@ -322,7 +322,8 @@ static int __init zcore_init(void)
 					     NULL, &zcore_hsa_fops);
 
 	register_reboot_notifier(&zcore_reboot_notifier);
-	atomic_notifier_chain_register(&panic_notifier_list, &zcore_on_panic_notifier);
+	atomic_notifier_chain_register(&panic_hypervisor_list,
+				       &zcore_on_panic_notifier);
 
 	return 0;
 fail:
diff --git a/drivers/soc/bcm/brcmstb/pm/pm-arm.c b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
index 870686ae042b..babca66c7862 100644
--- a/drivers/soc/bcm/brcmstb/pm/pm-arm.c
+++ b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
@@ -814,7 +814,7 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	atomic_notifier_chain_register(&panic_notifier_list,
+	atomic_notifier_chain_register(&panic_hypervisor_list,
 				       &brcmstb_pm_panic_nb);
 
 	pm_power_off = brcmstb_pm_poweroff;
diff --git a/include/linux/panic_notifier.h b/include/linux/panic_notifier.h
index 07dced83a783..0bb9dc0dea04 100644
--- a/include/linux/panic_notifier.h
+++ b/include/linux/panic_notifier.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 
 extern struct atomic_notifier_head panic_notifier_list;
+extern struct atomic_notifier_head panic_hypervisor_list;
 
 extern bool crash_kexec_post_notifiers;
 
diff --git a/kernel/panic.c b/kernel/panic.c
index 523bc9ccd0e9..ef76f3f9c44d 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -73,6 +73,9 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
 
 EXPORT_SYMBOL(panic_notifier_list);
 
+ATOMIC_NOTIFIER_HEAD(panic_hypervisor_list);
+EXPORT_SYMBOL(panic_hypervisor_list);
+
 static long no_blink(int state)
 {
 	return 0;
@@ -287,6 +290,7 @@ void panic(const char *fmt, ...)
 	 * Run any panic handlers, including those that might need to
 	 * add information to the kmsg dump output.
 	 */
+	atomic_notifier_call_chain(&panic_hypervisor_list, PANIC_NOTIFIER, buf);
 	atomic_notifier_call_chain(&panic_notifier_list, PANIC_NOTIFIER, buf);
 
 	panic_print_sys_info(false);
-- 
2.36.0

