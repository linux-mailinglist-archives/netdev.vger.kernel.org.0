Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739A31FFD1F
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 23:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgFRVHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 17:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgFRVGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 17:06:51 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D7FC06174E;
        Thu, 18 Jun 2020 14:06:50 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id dr13so7917197ejc.3;
        Thu, 18 Jun 2020 14:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=290CdVmBl+kSIfuVWYU0L6Rz1EDZG8KPdqb7eOxaF6g=;
        b=IL3vGZ5GF2XkmZ09yjTI9qQVpz34JO8uQljmjfH/4QbtHF/oMAdGs0vLXaGEOAzLxK
         e2Jr8WYr0yUTSlWvc1B+8ERAVx4UtEOzz2mxPIAIJEN93pihaN2x5ep60PsrlLd5kngK
         roeiMmJkg+rndtK2VJBl47NGTtJZ3umKyhI9yDvEI/Vhk/SRqycbriwSlXa+36b5vlcU
         +EW098i4sylJZRD4QtWrp1Hn4WmRtKvt68CG3EXurdyBk8bDdli+5VQ4HL8LQoWKa0/w
         iphyEecjYHxRsmfPbF7uuy96SkqsXYUZVDo7vMBrRwZq6guobc9TDKD5VpEpf5gBfn9l
         4ngA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=290CdVmBl+kSIfuVWYU0L6Rz1EDZG8KPdqb7eOxaF6g=;
        b=jnRCfE6Tprl1DcxnBmW0jz9TdWx465twoLRmVhFDe8KXtOTAqPU0NAN20Lyw4NUWhD
         Q2IRdL5UxexGyw0Cs5T1HCwo/uxwP4BE/+yX1FUJFXYzaihf8WSt3nX/4KZ+RhOceOy2
         PbefDxmTSSZP33l5yZNziWQ+QNpVURB9gSbBfh0SrlCLuGWTU19w0AFIbbWV4JIfabbe
         xktQA1oBi/kdhnzuCBKl+le4OXfL4xhW4mnXn4qF+jw7kL1EE3Kgugx0xqu0jDOiLq6B
         wQk2qZ5ST3pchVYaCKrtBCWS4+0IUdKrORrLXqfLFvK3YivlQ9IZ4qQt8Ucc2PrniZgg
         MlDw==
X-Gm-Message-State: AOAM532NH0U2UwGFMbKScNAIym4ecU9ciFikn6mQ1nDxBhex8YolHa1x
        RC6fCIG9ddWC5LEJCwTiO9tyFaI=
X-Google-Smtp-Source: ABdhPJydXWqt/WOhfIfWLFwg8Wkf7q37dRTgNWLm+WYOzpbuUITGb+GE5on7wuSx6+q/EGNf7J67vA==
X-Received: by 2002:a17:906:af76:: with SMTP id os22mr548917ejb.191.1592514408273;
        Thu, 18 Jun 2020 14:06:48 -0700 (PDT)
Received: from localhost.localdomain ([46.53.250.254])
        by smtp.gmail.com with ESMTPSA id o90sm2942262edb.60.2020.06.18.14.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 14:06:47 -0700 (PDT)
Date:   Fri, 19 Jun 2020 00:06:45 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH] linux++, this: rename "struct notifier_block *this"
Message-ID: <20200618210645.GB2212102@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename
	struct notifier_block *this
to
	struct notifier_block *nb

"nb" is arguably a better name for notifier block.

Someone used "this" back in the days and everyone else copied.
In nearly 100% of cases it is unused with notable exception of
net/x25/af_ax25.c

Both gcc and g++ accept new name. It would make my adventure of carrying
linux++ patchset slightly less miserable.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/alpha/kernel/setup.c                            |    2 +-
 arch/mips/kernel/pm-cps.c                            |    2 +-
 arch/mips/sgi-ip22/ip22-reset.c                      |    2 +-
 arch/mips/sgi-ip32/ip32-reset.c                      |    2 +-
 arch/mips/txx9/generic/setup_tx4939.c                |    2 +-
 arch/parisc/kernel/pdc_chassis.c                     |    4 ++--
 arch/powerpc/kernel/setup-common.c                   |    2 +-
 arch/powerpc/platforms/85xx/mpc85xx_cds.c            |    2 +-
 arch/powerpc/sysdev/fsl_soc.c                        |    2 +-
 arch/um/drivers/net_kern.c                           |    2 +-
 arch/um/drivers/vector_kern.c                        |    2 +-
 arch/x86/xen/enlighten.c                             |    2 +-
 arch/xtensa/platforms/iss/setup.c                    |    2 +-
 crypto/algboss.c                                     |    2 +-
 drivers/acpi/apei/ghes.c                             |    2 +-
 drivers/acpi/sleep.c                                 |    2 +-
 drivers/auxdisplay/charlcd.c                         |    2 +-
 drivers/char/ipmi/ipmi_msghandler.c                  |    2 +-
 drivers/char/ipmi/ipmi_watchdog.c                    |    2 +-
 drivers/clk/clk-nomadik.c                            |    2 +-
 drivers/clk/rockchip/clk.c                           |    2 +-
 drivers/clk/samsung/clk-s3c2412.c                    |    2 +-
 drivers/clk/samsung/clk-s3c2443.c                    |    2 +-
 drivers/cpufreq/s3c2416-cpufreq.c                    |    2 +-
 drivers/cpufreq/s5pv210-cpufreq.c                    |    2 +-
 drivers/crypto/chelsio/chtls/chtls_main.c            |    2 +-
 drivers/edac/altera_edac.c                           |    4 ++--
 drivers/edac/octeon_edac-pc.c                        |    4 ++--
 drivers/edac/sifive_edac.c                           |    4 ++--
 drivers/gpu/drm/i915/display/intel_dp.c              |    4 ++--
 drivers/hwmon/w83793.c                               |    2 +-
 drivers/infiniband/core/roce_gid_mgmt.c              |   12 ++++++------
 drivers/infiniband/hw/mlx4/main.c                    |    4 ++--
 drivers/infiniband/hw/mlx5/main.c                    |    4 ++--
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c       |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c            |    2 +-
 drivers/macintosh/adbhid.c                           |    2 +-
 drivers/md/md.c                                      |    2 +-
 drivers/mfd/rn5t618.c                                |    2 +-
 drivers/misc/mic/cosm_client/cosm_scif_client.c      |    2 +-
 drivers/mmc/core/pwrseq_emmc.c                       |    4 ++--
 drivers/net/bonding/bond_main.c                      |    2 +-
 drivers/net/ethernet/broadcom/cnic.c                 |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c      |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c       |    4 ++--
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h         |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c      |    4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/lag.c        |    4 ++--
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c |    4 ++--
 drivers/net/ethernet/qlogic/qede/qede_main.c         |    2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c     |    4 ++--
 drivers/net/ethernet/sfc/efx.c                       |    2 +-
 drivers/net/ethernet/sfc/falcon/efx.c                |    2 +-
 drivers/net/hamradio/bpqether.c                      |    2 +-
 drivers/net/hyperv/netvsc_drv.c                      |    2 +-
 drivers/net/macsec.c                                 |    2 +-
 drivers/net/netconsole.c                             |    2 +-
 drivers/net/ppp/pppoe.c                              |    2 +-
 drivers/net/wan/hdlc.c                               |    2 +-
 drivers/net/wan/lapbether.c                          |    2 +-
 drivers/net/wireless/virt_wifi.c                     |    2 +-
 drivers/parisc/power.c                               |    2 +-
 drivers/platform/x86/intel_telemetry_debugfs.c       |    2 +-
 drivers/power/reset/arm-versatile-reboot.c           |    2 +-
 drivers/power/reset/at91-reset.c                     |    4 ++--
 drivers/power/reset/axxia-reset.c                    |    2 +-
 drivers/power/reset/brcm-kona-reset.c                |    2 +-
 drivers/power/reset/brcmstb-reboot.c                 |    2 +-
 drivers/power/reset/gpio-restart.c                   |    4 ++--
 drivers/power/reset/hisi-reboot.c                    |    2 +-
 drivers/power/reset/keystone-reset.c                 |    2 +-
 drivers/power/reset/ocelot-reset.c                   |    4 ++--
 drivers/power/reset/oxnas-restart.c                  |    4 ++--
 drivers/power/reset/reboot-mode.c                    |    4 ++--
 drivers/power/reset/rmobile-reset.c                  |    2 +-
 drivers/power/reset/st-poweroff.c                    |    2 +-
 drivers/power/reset/syscon-reboot.c                  |    4 ++--
 drivers/power/reset/vexpress-poweroff.c              |    2 +-
 drivers/power/reset/xgene-reboot.c                   |    4 ++--
 drivers/power/reset/zx-reboot.c                      |    2 +-
 drivers/rtc/rtc-ds1374.c                             |    2 +-
 drivers/rtc/rtc-m41t80.c                             |    4 ++--
 drivers/s390/char/sclp.c                             |    2 +-
 drivers/s390/cio/css.c                               |    4 ++--
 drivers/s390/net/qeth_l3_main.c                      |    4 ++--
 drivers/soc/tegra/pmc.c                              |    2 +-
 drivers/spi/spi-sprd-adi.c                           |    4 ++--
 drivers/watchdog/alim1535_wdt.c                      |    2 +-
 drivers/watchdog/alim7101_wdt.c                      |    4 ++--
 drivers/watchdog/at91rm9200_wdt.c                    |    2 +-
 drivers/watchdog/diag288_wdt.c                       |    2 +-
 drivers/watchdog/eurotechwdt.c                       |    4 ++--
 drivers/watchdog/f71808e_wdt.c                       |    2 +-
 drivers/watchdog/indydog.c                           |    2 +-
 drivers/watchdog/intel_scu_watchdog.c                |    2 +-
 drivers/watchdog/it8712f_wdt.c                       |    2 +-
 drivers/watchdog/machzwd.c                           |    2 +-
 drivers/watchdog/pc87413_wdt.c                       |    4 ++--
 drivers/watchdog/pcwd_pci.c                          |    2 +-
 drivers/watchdog/pcwd_usb.c                          |    2 +-
 drivers/watchdog/pnx833x_wdt.c                       |    2 +-
 drivers/watchdog/sb_wdog.c                           |    2 +-
 drivers/watchdog/sbc60xxwdt.c                        |    2 +-
 drivers/watchdog/sbc7240_wdt.c                       |    2 +-
 drivers/watchdog/sbc8360.c                           |    2 +-
 drivers/watchdog/sbc_epx_c3.c                        |    2 +-
 drivers/watchdog/sc1200wdt.c                         |    2 +-
 drivers/watchdog/sc520_wdt.c                         |    2 +-
 drivers/watchdog/scx200_wdt.c                        |    2 +-
 drivers/watchdog/smsc37b787_wdt.c                    |    2 +-
 drivers/watchdog/w83877f_wdt.c                       |    2 +-
 drivers/watchdog/w83977f_wdt.c                       |    2 +-
 drivers/watchdog/wafer5823wdt.c                      |    2 +-
 drivers/watchdog/wdrtas.c                            |    2 +-
 drivers/watchdog/wdt.c                               |    4 ++--
 drivers/watchdog/wdt977.c                            |    2 +-
 drivers/watchdog/wdt_pci.c                           |    4 ++--
 fs/lockd/svc.c                                       |    4 ++--
 fs/nfsd/nfssvc.c                                     |    4 ++--
 kernel/debug/debug_core.c                            |    2 +-
 kernel/hung_task.c                                   |    2 +-
 kernel/rcu/tree_stall.h                              |    2 +-
 kernel/trace/trace.c                                 |    2 +-
 net/appletalk/aarp.c                                 |    2 +-
 net/appletalk/ddp.c                                  |    2 +-
 net/atm/br2684.c                                     |    2 +-
 net/atm/clip.c                                       |    6 +++---
 net/ax25/af_ax25.c                                   |    2 +-
 net/batman-adv/hard-interface.c                      |    2 +-
 net/core/failover.c                                  |    2 +-
 net/core/fib_rules.c                                 |    2 +-
 net/core/rtnetlink.c                                 |    2 +-
 net/decnet/af_decnet.c                               |    2 +-
 net/decnet/dn_fib.c                                  |    2 +-
 net/ethtool/netlink.c                                |    2 +-
 net/ipv4/arp.c                                       |    2 +-
 net/ipv4/devinet.c                                   |    2 +-
 net/ipv4/fib_frontend.c                              |    4 ++--
 net/ipv4/igmp.c                                      |    2 +-
 net/ipv4/ipmr.c                                      |    2 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c                   |    2 +-
 net/ipv4/nexthop.c                                   |    2 +-
 net/ipv6/addrconf.c                                  |    2 +-
 net/ipv6/ip6mr.c                                     |    2 +-
 net/ipv6/mcast.c                                     |    2 +-
 net/ipv6/ndisc.c                                     |    2 +-
 net/ipv6/route.c                                     |    2 +-
 net/iucv/af_iucv.c                                   |    2 +-
 net/iucv/iucv.c                                      |    2 +-
 net/mpls/af_mpls.c                                   |    2 +-
 net/netfilter/ipvs/ip_vs_ctl.c                       |    2 +-
 net/netfilter/nf_nat_masquerade.c                    |    6 +++---
 net/netfilter/nf_tables_api.c                        |    2 +-
 net/netfilter/nf_tables_offload.c                    |    2 +-
 net/netfilter/nfnetlink_log.c                        |    2 +-
 net/netfilter/nfnetlink_queue.c                      |    4 ++--
 net/netfilter/nft_chain_filter.c                     |    2 +-
 net/netfilter/nft_flow_offload.c                     |    2 +-
 net/netfilter/xt_TEE.c                               |    2 +-
 net/netlabel/netlabel_unlabeled.c                    |    4 ++--
 net/netrom/af_netrom.c                               |    2 +-
 net/nfc/netlink.c                                    |    2 +-
 net/packet/af_packet.c                               |    2 +-
 net/rose/af_rose.c                                   |    2 +-
 net/sctp/ipv6.c                                      |    2 +-
 net/sctp/protocol.c                                  |    2 +-
 net/smc/smc_core.c                                   |    2 +-
 net/smc/smc_pnet.c                                   |    2 +-
 net/tls/tls_device.c                                 |    2 +-
 net/x25/af_x25.c                                     |   12 ++++++------
 net/xdp/xsk.c                                        |    2 +-
 net/xfrm/xfrm_device.c                               |    2 +-
 security/selinux/netif.c                             |    2 +-
 173 files changed, 221 insertions(+), 221 deletions(-)

--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -1443,7 +1443,7 @@ const struct seq_operations cpuinfo_op = {
 
 
 static int
-alpha_panic_event(struct notifier_block *this, unsigned long event, void *ptr)
+alpha_panic_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 #if 1
 	/* FIXME FIXME FIXME */
--- a/arch/mips/kernel/pm-cps.c
+++ b/arch/mips/kernel/pm-cps.c
@@ -667,7 +667,7 @@ static int cps_pm_online_cpu(unsigned int cpu)
 	return 0;
 }
 
-static int cps_pm_power_notifier(struct notifier_block *this,
+static int cps_pm_power_notifier(struct notifier_block *nb,
 				 unsigned long event, void *ptr)
 {
 	unsigned int stat;
--- a/arch/mips/sgi-ip22/ip22-reset.c
+++ b/arch/mips/sgi-ip22/ip22-reset.c
@@ -163,7 +163,7 @@ static irqreturn_t panel_int(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int panic_event(struct notifier_block *this, unsigned long event,
+static int panic_event(struct notifier_block *nb, unsigned long event,
 		      void *ptr)
 {
 	if (machine_state & MACHINE_PANICED)
--- a/arch/mips/sgi-ip32/ip32-reset.c
+++ b/arch/mips/sgi-ip32/ip32-reset.c
@@ -108,7 +108,7 @@ void ip32_prepare_poweroff(void)
 	add_timer(&power_timer);
 }
 
-static int panic_event(struct notifier_block *this, unsigned long event,
+static int panic_event(struct notifier_block *nb, unsigned long event,
 		       void *ptr)
 {
 	unsigned long led;
--- a/arch/mips/txx9/generic/setup_tx4939.c
+++ b/arch/mips/txx9/generic/setup_tx4939.c
@@ -328,7 +328,7 @@ static u32 tx4939_get_eth_speed(struct net_device *dev)
 	return cmd.base.speed;
 }
 
-static int tx4939_netdev_event(struct notifier_block *this,
+static int tx4939_netdev_event(struct notifier_block *nb,
 			       unsigned long event,
 			       void *ptr)
 {
--- a/arch/parisc/kernel/pdc_chassis.c
+++ b/arch/parisc/kernel/pdc_chassis.c
@@ -83,7 +83,7 @@ static void __init pdc_chassis_checkold(void)
  * As soon as a panic occurs, we should inform the PDC.
  */
 
-static int pdc_chassis_panic_event(struct notifier_block *this,
+static int pdc_chassis_panic_event(struct notifier_block *nb,
 		        unsigned long event, void *ptr)
 {
 	pdc_chassis_send_status(PDC_CHASSIS_DIRECT_PANIC);
@@ -103,7 +103,7 @@ static struct notifier_block pdc_chassis_panic_block = {
  * As soon as a reboot occurs, we should inform the PDC.
  */
 
-static int pdc_chassis_reboot_event(struct notifier_block *this,
+static int pdc_chassis_reboot_event(struct notifier_block *nb,
 		        unsigned long event, void *ptr)
 {
 	pdc_chassis_send_status(PDC_CHASSIS_DIRECT_SHUTDOWN);
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -687,7 +687,7 @@ int check_legacy_ioport(unsigned long base_port)
 }
 EXPORT_SYMBOL(check_legacy_ioport);
 
-static int ppc_panic_event(struct notifier_block *this,
+static int ppc_panic_event(struct notifier_block *nb,
                              unsigned long event, void *ptr)
 {
 	/*
--- a/arch/powerpc/platforms/85xx/mpc85xx_cds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
@@ -79,7 +79,7 @@ static int mpc85xx_exclude_device(struct pci_controller *hose,
 		return PCIBIOS_SUCCESSFUL;
 }
 
-static int mpc85xx_cds_restart(struct notifier_block *this,
+static int mpc85xx_cds_restart(struct notifier_block *nb,
 			       unsigned long mode, void *cmd)
 {
 	struct pci_dev *dev;
--- a/arch/powerpc/sysdev/fsl_soc.c
+++ b/arch/powerpc/sysdev/fsl_soc.c
@@ -155,7 +155,7 @@ EXPORT_SYMBOL(get_baudrate);
 #if defined(CONFIG_FSL_SOC_BOOKE) || defined(CONFIG_PPC_86xx)
 static __be32 __iomem *rstcr;
 
-static int fsl_rstcr_restart(struct notifier_block *this,
+static int fsl_rstcr_restart(struct notifier_block *nb,
 			     unsigned long mode, void *cmd)
 {
 	local_irq_disable();
--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -721,7 +721,7 @@ static struct mc_device net_mc = {
 };
 
 #ifdef CONFIG_INET
-static int uml_inetaddr_event(struct notifier_block *this, unsigned long event,
+static int uml_inetaddr_event(struct notifier_block *nb, unsigned long event,
 			      void *ptr)
 {
 	struct in_ifaddr *ifa = ptr;
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1732,7 +1732,7 @@ static struct mc_device vector_mc = {
 
 #ifdef CONFIG_INET
 static int vector_inetaddr_event(
-	struct notifier_block *this,
+	struct notifier_block *nb,
 	unsigned long event,
 	void *ptr)
 {
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -277,7 +277,7 @@ void xen_emergency_restart(void)
 }
 
 static int
-xen_panic_event(struct notifier_block *this, unsigned long event, void *ptr)
+xen_panic_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	if (!kexec_crash_loaded()) {
 		if (xen_legacy_crash)
--- a/arch/xtensa/platforms/iss/setup.c
+++ b/arch/xtensa/platforms/iss/setup.c
@@ -44,7 +44,7 @@ void platform_restart(void)
 }
 
 static int
-iss_panic_event(struct notifier_block *this, unsigned long event, void *ptr)
+iss_panic_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	simc_exit(1);
 	return NOTIFY_DONE;
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -251,7 +251,7 @@ static int cryptomgr_schedule_test(struct crypto_alg *alg)
 	return NOTIFY_OK;
 }
 
-static int cryptomgr_notify(struct notifier_block *this, unsigned long msg,
+static int cryptomgr_notify(struct notifier_block *nb, unsigned long msg,
 			    void *data)
 {
 	switch (msg) {
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -808,7 +808,7 @@ static irqreturn_t ghes_irq_func(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static int ghes_notify_hed(struct notifier_block *this, unsigned long event,
+static int ghes_notify_hed(struct notifier_block *nb, unsigned long event,
 			   void *data)
 {
 	struct ghes *ghes;
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -45,7 +45,7 @@ static void acpi_sleep_tts_switch(u32 acpi_state)
 	}
 }
 
-static int tts_notify_reboot(struct notifier_block *this,
+static int tts_notify_reboot(struct notifier_block *nb,
 			unsigned long code, void *x)
 {
 	acpi_sleep_tts_switch(ACPI_STATE_S5);
--- a/drivers/auxdisplay/charlcd.c
+++ b/drivers/auxdisplay/charlcd.c
@@ -811,7 +811,7 @@ void charlcd_free(struct charlcd *lcd)
 }
 EXPORT_SYMBOL_GPL(charlcd_free);
 
-static int panel_notify_sys(struct notifier_block *this, unsigned long code,
+static int panel_notify_sys(struct notifier_block *nb, unsigned long code,
 			    void *unused)
 {
 	struct charlcd *lcd = the_charlcd;
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -5050,7 +5050,7 @@ static void send_panic_events(struct ipmi_smi *intf, char *str)
 
 static int has_panicked;
 
-static int panic_event(struct notifier_block *this,
+static int panic_event(struct notifier_block *nb,
 		       unsigned long         event,
 		       void                  *ptr)
 {
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -1134,7 +1134,7 @@ ipmi_nmi(unsigned int val, struct pt_regs *regs)
 }
 #endif
 
-static int wdog_reboot_handler(struct notifier_block *this,
+static int wdog_reboot_handler(struct notifier_block *nb,
 			       unsigned long         code,
 			       void                  *unused)
 {
--- a/drivers/clk/clk-nomadik.c
+++ b/drivers/clk/clk-nomadik.c
@@ -61,7 +61,7 @@ static DEFINE_SPINLOCK(src_lock);
 /* Base address of the SRC */
 static void __iomem *src_base;
 
-static int nomadik_clk_reboot_handler(struct notifier_block *this,
+static int nomadik_clk_reboot_handler(struct notifier_block *nb,
 				unsigned long code,
 				void *unused)
 {
--- a/drivers/clk/rockchip/clk.c
+++ b/drivers/clk/rockchip/clk.c
@@ -606,7 +606,7 @@ void __init rockchip_clk_protect_critical(const char *const clocks[],
 static void __iomem *rst_base;
 static unsigned int reg_restart;
 static void (*cb_restart)(void);
-static int rockchip_restart_notify(struct notifier_block *this,
+static int rockchip_restart_notify(struct notifier_block *nb,
 				   unsigned long mode, void *cmd)
 {
 	if (cb_restart)
--- a/drivers/clk/samsung/clk-s3c2412.c
+++ b/drivers/clk/samsung/clk-s3c2412.c
@@ -155,7 +155,7 @@ static struct samsung_clock_alias s3c2412_aliases[] __initdata = {
 	ALIAS(MSYSCLK, NULL, "fclk"),
 };
 
-static int s3c2412_restart(struct notifier_block *this,
+static int s3c2412_restart(struct notifier_block *nb,
 			   unsigned long mode, void *cmd)
 {
 	/* errata "Watch-dog/Software Reset Problem" specifies that
--- a/drivers/clk/samsung/clk-s3c2443.c
+++ b/drivers/clk/samsung/clk-s3c2443.c
@@ -307,7 +307,7 @@ static struct samsung_clock_alias s3c2450_aliases[] __initdata = {
 	ALIAS(PCLK_I2C1, "s3c2410-i2c.1", "i2c"),
 };
 
-static int s3c2443_restart(struct notifier_block *this,
+static int s3c2443_restart(struct notifier_block *nb,
 			   unsigned long mode, void *cmd)
 {
 	__raw_writel(0x533c2443, reg_base + SWRST);
--- a/drivers/cpufreq/s3c2416-cpufreq.c
+++ b/drivers/cpufreq/s3c2416-cpufreq.c
@@ -299,7 +299,7 @@ static void s3c2416_cpufreq_cfg_regulator(struct s3c2416_data *s3c_freq)
 }
 #endif
 
-static int s3c2416_cpufreq_reboot_notifier_evt(struct notifier_block *this,
+static int s3c2416_cpufreq_reboot_notifier_evt(struct notifier_block *nb,
 					       unsigned long event, void *ptr)
 {
 	struct s3c2416_data *s3c_freq = &s3c2416_cpufreq;
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -551,7 +551,7 @@ static int s5pv210_cpu_init(struct cpufreq_policy *policy)
 	return ret;
 }
 
-static int s5pv210_cpufreq_reboot_notifier_event(struct notifier_block *this,
+static int s5pv210_cpufreq_reboot_notifier_event(struct notifier_block *nb,
 						 unsigned long event, void *ptr)
 {
 	int ret;
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -50,7 +50,7 @@ static void unregister_listen_notifier(struct notifier_block *nb)
 	mutex_unlock(&notify_mutex);
 }
 
-static int listen_notify_handler(struct notifier_block *this,
+static int listen_notify_handler(struct notifier_block *nb,
 				 unsigned long event, void *data)
 {
 	struct chtls_listen *clisten;
--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -2024,10 +2024,10 @@ extern int panic_timeout;
  * The double bit error is handled through SError which is fatal. This is
  * called as a panic notifier to printout ECC error info as part of the panic.
  */
-static int s10_edac_dberr_handler(struct notifier_block *this,
+static int s10_edac_dberr_handler(struct notifier_block *nb,
 				  unsigned long event, void *ptr)
 {
-	struct altr_arria10_edac *edac = to_a10edac(this, panic_notifier);
+	struct altr_arria10_edac *edac = to_a10edac(nb, panic_notifier);
 	int err_addr, dberror;
 
 	regmap_read(edac->ecc_mgr_map, S10_SYSMGR_ECC_INTSTAT_DERR_OFST,
--- a/drivers/edac/octeon_edac-pc.c
+++ b/drivers/edac/octeon_edac-pc.c
@@ -35,10 +35,10 @@ struct co_cache_error {
  *
  * @event: non-zero if unrecoverable.
  */
-static int  co_cache_error_event(struct notifier_block *this,
+static int  co_cache_error_event(struct notifier_block *nb,
 	unsigned long event, void *ptr)
 {
-	struct co_cache_error *p = container_of(this, struct co_cache_error,
+	struct co_cache_error *p = container_of(nb, struct co_cache_error,
 						notifier);
 
 	unsigned int core = cvmx_get_core_num();
--- a/drivers/edac/sifive_edac.c
+++ b/drivers/edac/sifive_edac.c
@@ -25,12 +25,12 @@ struct sifive_edac_priv {
  * @event: non-zero if unrecoverable.
  */
 static
-int ecc_err_event(struct notifier_block *this, unsigned long event, void *ptr)
+int ecc_err_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	const char *msg = (char *)ptr;
 	struct sifive_edac_priv *p;
 
-	p = container_of(this, struct sifive_edac_priv, notifier);
+	p = container_of(nb, struct sifive_edac_priv, notifier);
 
 	if (event == SIFIVE_L2_ERR_TYPE_UE)
 		edac_device_handle_ue(p->dci, 0, 0, msg);
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -1125,10 +1125,10 @@ _pp_stat_reg(struct intel_dp *intel_dp)
 
 /* Reboot notifier handler to shutdown panel power to guarantee T12 timing
    This function only applicable when panel PM state is not to be tracked */
-static int edp_notify_handler(struct notifier_block *this, unsigned long code,
+static int edp_notify_handler(struct notifier_block *nb, unsigned long code,
 			      void *unused)
 {
-	struct intel_dp *intel_dp = container_of(this, typeof(* intel_dp),
+	struct intel_dp *intel_dp = container_of(nb, typeof(* intel_dp),
 						 edp_notifier);
 	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
 	intel_wakeref_t wakeref;
--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -1465,7 +1465,7 @@ static const struct file_operations watchdog_fops = {
  *	Notifier for system down
  */
 
-static int watchdog_notify_sys(struct notifier_block *this, unsigned long code,
+static int watchdog_notify_sys(struct notifier_block *nb, unsigned long code,
 			       void *unused)
 {
 	struct w83793_data *data = NULL;
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -731,7 +731,7 @@ static const struct netdev_event_work_cmd add_default_gid_cmd = {
 	.filter	= is_ndev_for_default_gid_filter,
 };
 
-static int netdevice_event(struct notifier_block *this, unsigned long event,
+static int netdevice_event(struct notifier_block *nb, unsigned long event,
 			   void *ptr)
 {
 	static const struct netdev_event_work_cmd del_cmd = {
@@ -811,7 +811,7 @@ static void update_gid_event_work_handler(struct work_struct *_work)
 	kfree(work);
 }
 
-static int addr_event(struct notifier_block *this, unsigned long event,
+static int addr_event(struct notifier_block *nb, unsigned long event,
 		      struct sockaddr *sa, struct net_device *ndev)
 {
 	struct update_gid_event_work *work;
@@ -851,7 +851,7 @@ static int addr_event(struct notifier_block *this, unsigned long event,
 	return NOTIFY_DONE;
 }
 
-static int inetaddr_event(struct notifier_block *this, unsigned long event,
+static int inetaddr_event(struct notifier_block *nb, unsigned long event,
 			  void *ptr)
 {
 	struct sockaddr_in	in;
@@ -862,10 +862,10 @@ static int inetaddr_event(struct notifier_block *this, unsigned long event,
 	in.sin_addr.s_addr = ifa->ifa_address;
 	ndev = ifa->ifa_dev->dev;
 
-	return addr_event(this, event, (struct sockaddr *)&in, ndev);
+	return addr_event(nb, event, (struct sockaddr *)&in, ndev);
 }
 
-static int inet6addr_event(struct notifier_block *this, unsigned long event,
+static int inet6addr_event(struct notifier_block *nb, unsigned long event,
 			   void *ptr)
 {
 	struct sockaddr_in6	in6;
@@ -876,7 +876,7 @@ static int inet6addr_event(struct notifier_block *this, unsigned long event,
 	in6.sin6_addr = ifa6->addr;
 	ndev = ifa6->idev->dev;
 
-	return addr_event(this, event, (struct sockaddr *)&in6, ndev);
+	return addr_event(nb, event, (struct sockaddr *)&in6, ndev);
 }
 
 static struct notifier_block nb_netdevice = {
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2389,7 +2389,7 @@ static void mlx4_ib_scan_netdevs(struct mlx4_ib_dev *ibdev,
 		mlx4_ib_update_qps(ibdev, dev, update_qps_port);
 }
 
-static int mlx4_ib_netdev_event(struct notifier_block *this,
+static int mlx4_ib_netdev_event(struct notifier_block *nb,
 				unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
@@ -2398,7 +2398,7 @@ static int mlx4_ib_netdev_event(struct notifier_block *this,
 	if (!net_eq(dev_net(dev), &init_net))
 		return NOTIFY_DONE;
 
-	ibdev = container_of(this, struct mlx4_ib_dev, iboe.nb);
+	ibdev = container_of(nb, struct mlx4_ib_dev, iboe.nb);
 	mlx4_ib_scan_netdevs(ibdev, dev, event);
 
 	return NOTIFY_DONE;
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -179,10 +179,10 @@ static struct mlx5_roce *mlx5_get_rep_roce(struct mlx5_ib_dev *dev,
 	return NULL;
 }
 
-static int mlx5_netdev_event(struct notifier_block *this,
+static int mlx5_netdev_event(struct notifier_block *nb,
 			     unsigned long event, void *ptr)
 {
-	struct mlx5_roce *roce = container_of(this, struct mlx5_roce, nb);
+	struct mlx5_roce *roce = container_of(nb, struct mlx5_roce, nb);
 	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
 	u8 port_num = roce->native_port_num;
 	struct mlx5_core_dev *mdev;
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -758,7 +758,7 @@ static void pvrdma_netdevice_event_work(struct work_struct *work)
 	kfree(netdev_work);
 }
 
-static int pvrdma_netdevice_event(struct notifier_block *this,
+static int pvrdma_netdevice_event(struct notifier_block *nb,
 				  unsigned long event, void *ptr)
 {
 	struct net_device *event_netdev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -105,7 +105,7 @@ static struct ib_client ipoib_client = {
 };
 
 #ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
-static int ipoib_netdev_event(struct notifier_block *this,
+static int ipoib_netdev_event(struct notifier_block *nb,
 			      unsigned long event, void *ptr)
 {
 	struct netdev_notifier_info *ni = ptr;
--- a/drivers/macintosh/adbhid.c
+++ b/drivers/macintosh/adbhid.c
@@ -714,7 +714,7 @@ adbhid_kbd_capslock_remember(void)
 }
 
 static int
-adb_message_handler(struct notifier_block *this, unsigned long code, void *x)
+adb_message_handler(struct notifier_block *nb, unsigned long code, void *x)
 {
 	switch (code) {
 	case ADB_MSG_PRE_RESET:
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9433,7 +9433,7 @@ int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 }
 EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
 
-static int md_notify_reboot(struct notifier_block *this,
+static int md_notify_reboot(struct notifier_block *nb,
 			    unsigned long code, void *x)
 {
 	struct list_head *tmp;
--- a/drivers/mfd/rn5t618.c
+++ b/drivers/mfd/rn5t618.c
@@ -124,7 +124,7 @@ static void rn5t618_power_off(void)
 	rn5t618_trigger_poweroff_sequence(false);
 }
 
-static int rn5t618_restart(struct notifier_block *this,
+static int rn5t618_restart(struct notifier_block *nb,
 			    unsigned long mode, void *cmd)
 {
 	rn5t618_trigger_poweroff_sequence(true);
--- a/drivers/misc/mic/cosm_client/cosm_scif_client.c
+++ b/drivers/misc/mic/cosm_client/cosm_scif_client.c
@@ -25,7 +25,7 @@ static struct scif_peer_dev *client_spdev;
  * Reboot notifier: receives shutdown status from the OS and communicates it
  * back to the COSM process on the host
  */
-static int cosm_reboot_event(struct notifier_block *this, unsigned long event,
+static int cosm_reboot_event(struct notifier_block *nb, unsigned long event,
 			     void *ptr)
 {
 	struct cosm_msg msg = { .id = COSM_MSG_SHUTDOWN_STATUS };
--- a/drivers/mmc/core/pwrseq_emmc.c
+++ b/drivers/mmc/core/pwrseq_emmc.c
@@ -39,10 +39,10 @@ static void mmc_pwrseq_emmc_reset(struct mmc_host *host)
 	udelay(200);
 }
 
-static int mmc_pwrseq_emmc_reset_nb(struct notifier_block *this,
+static int mmc_pwrseq_emmc_reset_nb(struct notifier_block *nb,
 				    unsigned long mode, void *cmd)
 {
-	struct mmc_pwrseq_emmc *pwrseq = container_of(this,
+	struct mmc_pwrseq_emmc *pwrseq = container_of(nb,
 					struct mmc_pwrseq_emmc, reset_nb);
 	gpiod_set_value(pwrseq->reset_gpio, 1);
 	udelay(1);
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3254,7 +3254,7 @@ static int bond_slave_netdev_event(unsigned long event,
  * locks for us to safely manipulate the slave devices (RTNL lock,
  * dev_probe_lock).
  */
-static int bond_netdev_event(struct notifier_block *this,
+static int bond_netdev_event(struct notifier_block *nb,
 			     unsigned long event, void *ptr)
 {
 	struct net_device *event_dev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -5678,7 +5678,7 @@ static void cnic_rcv_netevent(struct cnic_local *cp, unsigned long event,
 }
 
 /* netdev event handler */
-static int cnic_netdev_event(struct notifier_block *this, unsigned long event,
+static int cnic_netdev_event(struct notifier_block *nb, unsigned long event,
 							 void *ptr)
 {
 	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -2371,7 +2371,7 @@ static void notify_ulds(struct adapter *adap, enum cxgb4_state new_state)
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-static int cxgb4_inet6addr_handler(struct notifier_block *this,
+static int cxgb4_inet6addr_handler(struct notifier_block *nb,
 				   unsigned long event, void *data)
 {
 	struct inet6_ifaddr *ifa = data;
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3012,7 +3012,7 @@ static int mlx4_en_queue_bond_work(struct mlx4_en_priv *priv, int is_bonded,
 	return 0;
 }
 
-int mlx4_en_netdev_event(struct notifier_block *this,
+int mlx4_en_netdev_event(struct notifier_block *nb,
 			 unsigned long event, void *ptr)
 {
 	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
@@ -3028,7 +3028,7 @@ int mlx4_en_netdev_event(struct notifier_block *this,
 	if (!net_eq(dev_net(ndev), &init_net))
 		return NOTIFY_DONE;
 
-	mdev = container_of(this, struct mlx4_en_dev, nb);
+	mdev = container_of(nb, struct mlx4_en_dev, nb);
 	dev = mdev->dev;
 
 	/* Go into this mode only when two network devices set on two ports
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -794,7 +794,7 @@ void mlx4_en_update_pfc_stats_bitmap(struct mlx4_dev *dev,
 				     struct mlx4_en_stats_bitmap *stats_bitmap,
 				     u8 rx_ppp, u8 rx_pause,
 				     u8 tx_ppp, u8 tx_pause);
-int mlx4_en_netdev_event(struct notifier_block *this,
+int mlx4_en_netdev_event(struct notifier_block *nb,
 			 unsigned long event, void *ptr);
 
 /*
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4979,7 +4979,7 @@ static void mlx5e_tc_hairpin_update_dead_peer(struct mlx5e_priv *priv,
 	}
 }
 
-static int mlx5e_tc_netdev_event(struct notifier_block *this,
+static int mlx5e_tc_netdev_event(struct notifier_block *nb,
 				 unsigned long event, void *ptr)
 {
 	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
@@ -4993,7 +4993,7 @@ static int mlx5e_tc_netdev_event(struct notifier_block *this,
 	    ndev->reg_state == NETREG_REGISTERED)
 		return NOTIFY_DONE;
 
-	tc = container_of(this, struct mlx5e_tc_table, netdevice_nb);
+	tc = container_of(nb, struct mlx5e_tc_table, netdevice_nb);
 	fs = container_of(tc, struct mlx5e_flow_steering, tc);
 	priv = container_of(fs, struct mlx5e_priv, fs);
 	peer_priv = netdev_priv(ndev);
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -433,7 +433,7 @@ static int mlx5_handle_changelowerstate_event(struct mlx5_lag *ldev,
 	return 1;
 }
 
-static int mlx5_lag_netdev_event(struct notifier_block *this,
+static int mlx5_lag_netdev_event(struct notifier_block *nb,
 				 unsigned long event, void *ptr)
 {
 	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
@@ -444,7 +444,7 @@ static int mlx5_lag_netdev_event(struct notifier_block *this,
 	if ((event != NETDEV_CHANGEUPPER) && (event != NETDEV_CHANGELOWERSTATE))
 		return NOTIFY_DONE;
 
-	ldev    = container_of(this, struct mlx5_lag, nb);
+	ldev    = container_of(nb, struct mlx5_lag, nb);
 	tracker = ldev->tracker;
 
 	switch (event) {
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -3344,7 +3344,7 @@ static void netxen_config_master(struct net_device *dev, unsigned long event)
 		netxen_free_ip_list(adapter, true);
 }
 
-static int netxen_netdev_event(struct notifier_block *this,
+static int netxen_netdev_event(struct notifier_block *nb,
 				 unsigned long event, void *ptr)
 {
 	struct netxen_adapter *adapter;
@@ -3387,7 +3387,7 @@ static int netxen_netdev_event(struct notifier_block *this,
 }
 
 static int
-netxen_inetaddr_event(struct notifier_block *this,
+netxen_inetaddr_event(struct notifier_block *nb,
 		unsigned long event, void *ptr)
 {
 	struct netxen_adapter *adapter;
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -240,7 +240,7 @@ static struct qed_eth_cb_ops qede_ll_ops = {
 	.ports_update = qede_udp_ports_update,
 };
 
-static int qede_netdev_event(struct notifier_block *this, unsigned long event,
+static int qede_netdev_event(struct notifier_block *nb, unsigned long event,
 			     void *ptr)
 {
 	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -4162,7 +4162,7 @@ void qlcnic_restore_indev_addr(struct net_device *netdev, unsigned long event)
 	rcu_read_unlock();
 }
 
-static int qlcnic_netdev_event(struct notifier_block *this,
+static int qlcnic_netdev_event(struct notifier_block *nb,
 				 unsigned long event, void *ptr)
 {
 	struct qlcnic_adapter *adapter;
@@ -4194,7 +4194,7 @@ static int qlcnic_netdev_event(struct notifier_block *this,
 }
 
 static int
-qlcnic_inetaddr_event(struct notifier_block *this,
+qlcnic_inetaddr_event(struct notifier_block *nb,
 		unsigned long event, void *ptr)
 {
 	struct qlcnic_adapter *adapter;
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -881,7 +881,7 @@ static void efx_update_name(struct efx_nic *efx)
 	efx_set_channel_names(efx);
 }
 
-static int efx_netdev_event(struct notifier_block *this,
+static int efx_netdev_event(struct notifier_block *nb,
 			    unsigned long event, void *ptr)
 {
 	struct net_device *net_dev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2237,7 +2237,7 @@ static void ef4_update_name(struct ef4_nic *efx)
 	ef4_set_channel_names(efx);
 }
 
-static int ef4_netdev_event(struct notifier_block *this,
+static int ef4_netdev_event(struct notifier_block *nb,
 			    unsigned long event, void *ptr)
 {
 	struct net_device *net_dev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -525,7 +525,7 @@ static void bpq_free_device(struct net_device *ndev)
 /*
  *	Handle device status changes.
  */
-static int bpq_device_event(struct notifier_block *this,
+static int bpq_device_event(struct notifier_block *nb,
 			    unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2622,7 +2622,7 @@ static struct  hv_driver netvsc_drv = {
  * to the guest. When the corresponding VF instance is registered,
  * we will take care of switching the data path.
  */
-static int netvsc_netdev_event(struct notifier_block *this,
+static int netvsc_netdev_event(struct notifier_block *nb,
 			       unsigned long event, void *ptr)
 {
 	struct net_device *event_dev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -4282,7 +4282,7 @@ static bool is_macsec_master(struct net_device *dev)
 	return rcu_access_pointer(dev->rx_handler) == macsec_handle_frame;
 }
 
-static int macsec_notify(struct notifier_block *this, unsigned long event,
+static int macsec_notify(struct notifier_block *nb, unsigned long event,
 			 void *ptr)
 {
 	struct net_device *real_dev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -688,7 +688,7 @@ static struct configfs_subsystem netconsole_subsys = {
 #endif	/* CONFIG_NETCONSOLE_DYNAMIC */
 
 /* Handle network interface device notifications */
-static int netconsole_netdev_event(struct notifier_block *this,
+static int netconsole_netdev_event(struct notifier_block *nb,
 				   unsigned long event, void *ptr)
 {
 	unsigned long flags;
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -327,7 +327,7 @@ static void pppoe_flush_dev(struct net_device *dev)
 	write_unlock_bh(&pn->hash_lock);
 }
 
-static int pppoe_device_event(struct notifier_block *this,
+static int pppoe_device_event(struct notifier_block *nb,
 			      unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -85,7 +85,7 @@ static inline void hdlc_proto_stop(struct net_device *dev)
 
 
 
-static int hdlc_device_event(struct notifier_block *this, unsigned long event,
+static int hdlc_device_event(struct notifier_block *nb, unsigned long event,
 			     void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -359,7 +359,7 @@ static void lapbeth_free_device(struct lapbethdev *lapbeth)
  *
  * Called from notifier with RTNL held.
  */
-static int lapbeth_device_event(struct notifier_block *this,
+static int lapbeth_device_event(struct notifier_block *nb,
 				unsigned long event, void *ptr)
 {
 	struct lapbethdev *lapbeth;
--- a/drivers/net/wireless/virt_wifi.c
+++ b/drivers/net/wireless/virt_wifi.c
@@ -605,7 +605,7 @@ static bool netif_is_virt_wifi_dev(const struct net_device *dev)
 	return rcu_access_pointer(dev->rx_handler) == virt_wifi_rx_handler;
 }
 
-static int virt_wifi_event(struct notifier_block *this, unsigned long event,
+static int virt_wifi_event(struct notifier_block *nb, unsigned long event,
 			   void *ptr)
 {
 	struct net_device *lower_dev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/parisc/power.c
+++ b/drivers/parisc/power.c
@@ -179,7 +179,7 @@ static void powerfail_interrupt(int code, void *x)
  * executed any longer. This function then re-enables the 
  * soft-power switch and allows the user to switch off the system
  */
-static int parisc_panic_event(struct notifier_block *this,
+static int parisc_panic_event(struct notifier_block *nb,
 		unsigned long event, void *ptr)
 {
 	/* re-enable the soft-power switch */
--- a/drivers/platform/x86/intel_telemetry_debugfs.c
+++ b/drivers/platform/x86/intel_telemetry_debugfs.c
@@ -884,7 +884,7 @@ static int pm_suspend_exit_cb(void)
 	return NOTIFY_OK;
 }
 
-static int pm_notification(struct notifier_block *this,
+static int pm_notification(struct notifier_block *nb,
 			   unsigned long event, void *ptr)
 {
 	switch (event) {
--- a/drivers/power/reset/arm-versatile-reboot.c
+++ b/drivers/power/reset/arm-versatile-reboot.c
@@ -69,7 +69,7 @@ static const struct of_device_id versatile_reboot_of_match[] = {
 	{},
 };
 
-static int versatile_reboot(struct notifier_block *this, unsigned long mode,
+static int versatile_reboot(struct notifier_block *nb, unsigned long mode,
 			    void *cmd)
 {
 	/* Unlock the reset register */
--- a/drivers/power/reset/at91-reset.c
+++ b/drivers/power/reset/at91-reset.c
@@ -64,10 +64,10 @@ struct at91_reset {
 * reset register it can be left driving the data bus and
 * killing the chance of a subsequent boot from NAND
 */
-static int at91_reset(struct notifier_block *this, unsigned long mode,
+static int at91_reset(struct notifier_block *nb, unsigned long mode,
 		      void *cmd)
 {
-	struct at91_reset *reset = container_of(this, struct at91_reset, nb);
+	struct at91_reset *reset = container_of(nb, struct at91_reset, nb);
 
 	asm volatile(
 		/* Align to cache lines */
--- a/drivers/power/reset/axxia-reset.c
+++ b/drivers/power/reset/axxia-reset.c
@@ -28,7 +28,7 @@
 
 static struct regmap *syscon;
 
-static int axxia_restart_handler(struct notifier_block *this,
+static int axxia_restart_handler(struct notifier_block *nb,
 				 unsigned long mode, void *cmd)
 {
 	/* Access Key (0xab) */
--- a/drivers/power/reset/brcm-kona-reset.c
+++ b/drivers/power/reset/brcm-kona-reset.c
@@ -25,7 +25,7 @@
 
 static void __iomem *kona_reset_base;
 
-static int kona_reset_handler(struct notifier_block *this,
+static int kona_reset_handler(struct notifier_block *nb,
 				unsigned long mode, void *cmd)
 {
 	/*
--- a/drivers/power/reset/brcmstb-reboot.c
+++ b/drivers/power/reset/brcmstb-reboot.c
@@ -42,7 +42,7 @@ struct reset_reg_mask {
 
 static const struct reset_reg_mask *reset_masks;
 
-static int brcmstb_restart_handler(struct notifier_block *this,
+static int brcmstb_restart_handler(struct notifier_block *nb,
 				   unsigned long mode, void *cmd)
 {
 	int rc;
--- a/drivers/power/reset/gpio-restart.c
+++ b/drivers/power/reset/gpio-restart.c
@@ -23,11 +23,11 @@ struct gpio_restart {
 	u32 wait_delay_ms;
 };
 
-static int gpio_restart_notify(struct notifier_block *this,
+static int gpio_restart_notify(struct notifier_block *nb,
 				unsigned long mode, void *cmd)
 {
 	struct gpio_restart *gpio_restart =
-		container_of(this, struct gpio_restart, restart_handler);
+		container_of(nb, struct gpio_restart, restart_handler);
 
 	/* drive it active, also inactive->active edge */
 	gpiod_direction_output(gpio_restart->reset_gpio, 1);
--- a/drivers/power/reset/hisi-reboot.c
+++ b/drivers/power/reset/hisi-reboot.c
@@ -21,7 +21,7 @@
 static void __iomem *base;
 static u32 reboot_offset;
 
-static int hisi_restart_handler(struct notifier_block *this,
+static int hisi_restart_handler(struct notifier_block *nb,
 				unsigned long mode, void *cmd)
 {
 	writel_relaxed(0xdeadbeef, base + reboot_offset);
--- a/drivers/power/reset/keystone-reset.c
+++ b/drivers/power/reset/keystone-reset.c
@@ -49,7 +49,7 @@ static inline int rsctrl_enable_rspll_write(void)
 				  RSCTRL_KEY_MASK, RSCTRL_KEY);
 }
 
-static int rsctrl_restart_handler(struct notifier_block *this,
+static int rsctrl_restart_handler(struct notifier_block *nb,
 				  unsigned long mode, void *cmd)
 {
 	/* enable write access to RSTCTRL */
--- a/drivers/power/reset/ocelot-reset.c
+++ b/drivers/power/reset/ocelot-reset.c
@@ -33,10 +33,10 @@ struct ocelot_reset_context {
 #define IF_SI_OWNER_SIMC			2
 #define IF_SI_OWNER_OFFSET			4
 
-static int ocelot_restart_handle(struct notifier_block *this,
+static int ocelot_restart_handle(struct notifier_block *nb,
 				 unsigned long mode, void *cmd)
 {
-	struct ocelot_reset_context *ctx = container_of(this, struct
+	struct ocelot_reset_context *ctx = container_of(nb, struct
 							ocelot_reset_context,
 							restart_handler);
 
--- a/drivers/power/reset/oxnas-restart.c
+++ b/drivers/power/reset/oxnas-restart.c
@@ -96,10 +96,10 @@ struct oxnas_restart_context {
 	struct notifier_block restart_handler;
 };
 
-static int ox820_restart_handle(struct notifier_block *this,
+static int ox820_restart_handle(struct notifier_block *nb,
 				 unsigned long mode, void *cmd)
 {
-	struct oxnas_restart_context *ctx = container_of(this, struct
+	struct oxnas_restart_context *ctx = container_of(nb, struct
 							oxnas_restart_context,
 							restart_handler);
 	u32 value;
--- a/drivers/power/reset/reboot-mode.c
+++ b/drivers/power/reset/reboot-mode.c
@@ -39,13 +39,13 @@ static unsigned int get_reboot_mode_magic(struct reboot_mode_driver *reboot,
 	return magic;
 }
 
-static int reboot_mode_notify(struct notifier_block *this,
+static int reboot_mode_notify(struct notifier_block *nb,
 			      unsigned long mode, void *cmd)
 {
 	struct reboot_mode_driver *reboot;
 	unsigned int magic;
 
-	reboot = container_of(this, struct reboot_mode_driver, reboot_notifier);
+	reboot = container_of(nb, struct reboot_mode_driver, reboot_notifier);
 	magic = get_reboot_mode_magic(reboot, cmd);
 	if (magic)
 		reboot->write(reboot, magic);
--- a/drivers/power/reset/rmobile-reset.c
+++ b/drivers/power/reset/rmobile-reset.c
@@ -21,7 +21,7 @@
 
 static void __iomem *sysc_base2;
 
-static int rmobile_reset_handler(struct notifier_block *this,
+static int rmobile_reset_handler(struct notifier_block *nb,
 				 unsigned long mode, void *cmd)
 {
 	pr_debug("%s %lu\n", __func__, mode);
--- a/drivers/power/reset/st-poweroff.c
+++ b/drivers/power/reset/st-poweroff.c
@@ -39,7 +39,7 @@ static struct reset_syscfg stih407_reset = {
 
 static struct reset_syscfg *st_restart_syscfg;
 
-static int st_restart(struct notifier_block *this, unsigned long mode,
+static int st_restart(struct notifier_block *nb, unsigned long mode,
 		      void *cmd)
 {
 	/* reset syscfg updated */
--- a/drivers/power/reset/syscon-reboot.c
+++ b/drivers/power/reset/syscon-reboot.c
@@ -23,11 +23,11 @@ struct syscon_reboot_context {
 	struct notifier_block restart_handler;
 };
 
-static int syscon_restart_handle(struct notifier_block *this,
+static int syscon_restart_handle(struct notifier_block *nb,
 					unsigned long mode, void *cmd)
 {
 	struct syscon_reboot_context *ctx =
-			container_of(this, struct syscon_reboot_context,
+			container_of(nb, struct syscon_reboot_context,
 					restart_handler);
 
 	/* Issue the reboot */
--- a/drivers/power/reset/vexpress-poweroff.c
+++ b/drivers/power/reset/vexpress-poweroff.c
@@ -37,7 +37,7 @@ static void vexpress_power_off(void)
 
 static struct device *vexpress_restart_device;
 
-static int vexpress_restart(struct notifier_block *this, unsigned long mode,
+static int vexpress_restart(struct notifier_block *nb, unsigned long mode,
 			     void *cmd)
 {
 	vexpress_reset_do(vexpress_restart_device, "restart");
--- a/drivers/power/reset/xgene-reboot.c
+++ b/drivers/power/reset/xgene-reboot.c
@@ -27,11 +27,11 @@ struct xgene_reboot_context {
 	struct notifier_block restart_handler;
 };
 
-static int xgene_restart_handler(struct notifier_block *this,
+static int xgene_restart_handler(struct notifier_block *nb,
 				 unsigned long mode, void *cmd)
 {
 	struct xgene_reboot_context *ctx =
-		container_of(this, struct xgene_reboot_context,
+		container_of(nb, struct xgene_reboot_context,
 			     restart_handler);
 
 	/* Issue the reboot */
--- a/drivers/power/reset/zx-reboot.c
+++ b/drivers/power/reset/zx-reboot.c
@@ -18,7 +18,7 @@
 static void __iomem *base;
 static void __iomem *pcu_base;
 
-static int zx_restart_handler(struct notifier_block *this,
+static int zx_restart_handler(struct notifier_block *nb,
 			      unsigned long mode, void *cmd)
 {
 	writel_relaxed(1, base + 0xb0);
--- a/drivers/rtc/rtc-ds1374.c
+++ b/drivers/rtc/rtc-ds1374.c
@@ -571,7 +571,7 @@ static long ds1374_wdt_unlocked_ioctl(struct file *file, unsigned int cmd,
 	return ret;
 }
 
-static int ds1374_wdt_notify_sys(struct notifier_block *this,
+static int ds1374_wdt_notify_sys(struct notifier_block *nb,
 			unsigned long code, void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -814,7 +814,7 @@ static int wdt_release(struct inode *inode, struct file *file)
 
 /**
  *	notify_sys:
- *	@this: our notifier block
+ *	@nb: our notifier block
  *	@code: the event being reported
  *	@unused: unused
  *
@@ -823,7 +823,7 @@ static int wdt_release(struct inode *inode, struct file *file)
  *	test or worse yet during the following fsck. This would suck, in fact
  *	trust me - if it happens it does suck.
  */
-static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
+static int wdt_notify_sys(struct notifier_block *nb, unsigned long code,
 			  void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -1000,7 +1000,7 @@ sclp_check_interface(void)
 /* Reboot event handler. Reset send and receive mask to prevent pending SCLP
  * events from interfering with rebooted system. */
 static int
-sclp_reboot_event(struct notifier_block *this, unsigned long event, void *ptr)
+sclp_reboot_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	sclp_deactivate();
 	return NOTIFY_DONE;
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -1011,7 +1011,7 @@ static int __init setup_css(int nr)
 	return ret;
 }
 
-static int css_reboot_event(struct notifier_block *this,
+static int css_reboot_event(struct notifier_block *nb,
 			    unsigned long event,
 			    void *ptr)
 {
@@ -1040,7 +1040,7 @@ static struct notifier_block css_reboot_notifier = {
  * path measurements via the normal suspend/resume callbacks, but have
  * to use notifiers.
  */
-static int css_power_event(struct notifier_block *this, unsigned long event,
+static int css_power_event(struct notifier_block *nb, unsigned long event,
 			   void *ptr)
 {
 	struct channel_subsystem *css;
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -2179,7 +2179,7 @@ static struct qeth_card *qeth_l3_get_card_from_dev(struct net_device *dev)
 	return NULL;
 }
 
-static int qeth_l3_ip_event(struct notifier_block *this,
+static int qeth_l3_ip_event(struct notifier_block *nb,
 			    unsigned long event, void *ptr)
 {
 
@@ -2205,7 +2205,7 @@ static struct notifier_block qeth_l3_ip_notifier = {
 	NULL,
 };
 
-static int qeth_l3_ip6_event(struct notifier_block *this,
+static int qeth_l3_ip6_event(struct notifier_block *nb,
 			     unsigned long event, void *ptr)
 {
 	struct inet6_ifaddr *ifa = (struct inet6_ifaddr *)ptr;
--- a/drivers/soc/tegra/pmc.c
+++ b/drivers/soc/tegra/pmc.c
@@ -944,7 +944,7 @@ int tegra_pmc_cpu_remove_clamping(unsigned int cpuid)
 	return tegra_powergate_remove_clamping(id);
 }
 
-static int tegra_pmc_restart_notify(struct notifier_block *this,
+static int tegra_pmc_restart_notify(struct notifier_block *nb,
 				    unsigned long action, void *data)
 {
 	const char *cmd = data;
--- a/drivers/spi/spi-sprd-adi.c
+++ b/drivers/spi/spi-sprd-adi.c
@@ -329,10 +329,10 @@ static void sprd_adi_set_wdt_rst_mode(struct sprd_adi *sadi)
 #endif
 }
 
-static int sprd_adi_restart_handler(struct notifier_block *this,
+static int sprd_adi_restart_handler(struct notifier_block *nb,
 				    unsigned long mode, void *cmd)
 {
-	struct sprd_adi *sadi = container_of(this, struct sprd_adi,
+	struct sprd_adi *sadi = container_of(nb, struct sprd_adi,
 					     restart_handler);
 	u32 val, reboot_mode = 0;
 
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -280,7 +280,7 @@ static int ali_release(struct inode *inode, struct file *file)
  */
 
 
-static int ali_notify_sys(struct notifier_block *this,
+static int ali_notify_sys(struct notifier_block *nb,
 					unsigned long code, void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -303,7 +303,7 @@ static struct miscdevice wdt_miscdev = {
 	.fops	=	&wdt_fops,
 };
 
-static int wdt_restart_handle(struct notifier_block *this, unsigned long mode,
+static int wdt_restart_handle(struct notifier_block *nb, unsigned long mode,
 			      void *cmd)
 {
 	/*
@@ -329,7 +329,7 @@ static struct notifier_block wdt_restart_handler = {
  *	Notifier for system down
  */
 
-static int wdt_notify_sys(struct notifier_block *this,
+static int wdt_notify_sys(struct notifier_block *nb,
 					unsigned long code, void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -52,7 +52,7 @@ static unsigned long at91wdt_busy;
 
 /* ......................................................................... */
 
-static int at91rm9200_restart(struct notifier_block *this,
+static int at91rm9200_restart(struct notifier_block *nb,
 					unsigned long mode, void *cmd)
 {
 	/*
--- a/drivers/watchdog/diag288_wdt.c
+++ b/drivers/watchdog/diag288_wdt.c
@@ -247,7 +247,7 @@ static int wdt_resume(void)
 	return NOTIFY_DONE;
 }
 
-static int wdt_power_event(struct notifier_block *this, unsigned long event,
+static int wdt_power_event(struct notifier_block *nb, unsigned long event,
 			   void *ptr)
 {
 	switch (event) {
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -342,7 +342,7 @@ static int eurwdt_release(struct inode *inode, struct file *file)
 
 /**
  * eurwdt_notify_sys:
- * @this: our notifier block
+ * @nb: our notifier block
  * @code: the event being reported
  * @unused: unused
  *
@@ -352,7 +352,7 @@ static int eurwdt_release(struct inode *inode, struct file *file)
  * trust me - if it happens it does suck.
  */
 
-static int eurwdt_notify_sys(struct notifier_block *this, unsigned long code,
+static int eurwdt_notify_sys(struct notifier_block *nb, unsigned long code,
 	void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/watchdog/f71808e_wdt.c
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -654,7 +654,7 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 	}
 }
 
-static int watchdog_notify_sys(struct notifier_block *this, unsigned long code,
+static int watchdog_notify_sys(struct notifier_block *nb, unsigned long code,
 	void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/watchdog/indydog.c
+++ b/drivers/watchdog/indydog.c
@@ -138,7 +138,7 @@ static long indydog_ioctl(struct file *file, unsigned int cmd,
 	}
 }
 
-static int indydog_notify_sys(struct notifier_block *this,
+static int indydog_notify_sys(struct notifier_block *nb,
 					unsigned long code, void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/watchdog/intel_scu_watchdog.c
+++ b/drivers/watchdog/intel_scu_watchdog.c
@@ -394,7 +394,7 @@ static long intel_scu_ioctl(struct file *file,
 /*
  *      Notifier for system down
  */
-static int intel_scu_notify_sys(struct notifier_block *this,
+static int intel_scu_notify_sys(struct notifier_block *nb,
 			       unsigned long code,
 			       void *another_unused)
 {
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -215,7 +215,7 @@ static int it8712f_wdt_disable(void)
 	return 0;
 }
 
-static int it8712f_wdt_notify(struct notifier_block *this,
+static int it8712f_wdt_notify(struct notifier_block *nb,
 		    unsigned long code, void *unused)
 {
 	if (code == SYS_HALT || code == SYS_POWER_OFF)
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -348,7 +348,7 @@ static int zf_close(struct inode *inode, struct file *file)
  * Notifier for system down
  */
 
-static int zf_notify_sys(struct notifier_block *this, unsigned long code,
+static int zf_notify_sys(struct notifier_block *nb, unsigned long code,
 								void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -446,7 +446,7 @@ static long pc87413_ioctl(struct file *file, unsigned int cmd,
 
 /**
  *	notify_sys:
- *	@this: our notifier block
+ *	@nb: our notifier block
  *	@code: the event being reported
  *	@unused: unused
  *
@@ -456,7 +456,7 @@ static long pc87413_ioctl(struct file *file, unsigned int cmd,
  *	trust me - if it happens it does suck.
  */
 
-static int pc87413_notify_sys(struct notifier_block *this,
+static int pc87413_notify_sys(struct notifier_block *nb,
 			      unsigned long code,
 			      void *unused)
 {
--- a/drivers/watchdog/pcwd_pci.c
+++ b/drivers/watchdog/pcwd_pci.c
@@ -628,7 +628,7 @@ static int pcipcwd_temp_release(struct inode *inode, struct file *file)
  *	Notify system
  */
 
-static int pcipcwd_notify_sys(struct notifier_block *this, unsigned long code,
+static int pcipcwd_notify_sys(struct notifier_block *nb, unsigned long code,
 								void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -532,7 +532,7 @@ static int usb_pcwd_temperature_release(struct inode *inode, struct file *file)
  *	Notify system
  */
 
-static int usb_pcwd_notify_sys(struct notifier_block *this, unsigned long code,
+static int usb_pcwd_notify_sys(struct notifier_block *nb, unsigned long code,
 								void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/watchdog/pnx833x_wdt.c
+++ b/drivers/watchdog/pnx833x_wdt.c
@@ -201,7 +201,7 @@ static long pnx833x_wdt_ioctl(struct file *file, unsigned int cmd,
 	}
 }
 
-static int pnx833x_wdt_notify_sys(struct notifier_block *this,
+static int pnx833x_wdt_notify_sys(struct notifier_block *nb,
 					unsigned long code, void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/watchdog/sb_wdog.c
+++ b/drivers/watchdog/sb_wdog.c
@@ -218,7 +218,7 @@ static long sbwdog_ioctl(struct file *file, unsigned int cmd,
 /*
  *	Notifier for system down
  */
-static int sbwdog_notify_sys(struct notifier_block *this, unsigned long code,
+static int sbwdog_notify_sys(struct notifier_block *nb, unsigned long code,
 								void *erf)
 {
 	if (code == SYS_DOWN || code == SYS_HALT) {
--- a/drivers/watchdog/sbc60xxwdt.c
+++ b/drivers/watchdog/sbc60xxwdt.c
@@ -293,7 +293,7 @@ static struct miscdevice wdt_miscdev = {
  *	Notifier for system down
  */
 
-static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
+static int wdt_notify_sys(struct notifier_block *nb, unsigned long code,
 	void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/watchdog/sbc7240_wdt.c
+++ b/drivers/watchdog/sbc7240_wdt.c
@@ -223,7 +223,7 @@ static struct miscdevice wdt_miscdev = {
  *	Notifier for system down
  */
 
-static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
+static int wdt_notify_sys(struct notifier_block *nb, unsigned long code,
 			  void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/watchdog/sbc8360.c
+++ b/drivers/watchdog/sbc8360.c
@@ -286,7 +286,7 @@ static int sbc8360_close(struct inode *inode, struct file *file)
  *	Notifier for system down
  */
 
-static int sbc8360_notify_sys(struct notifier_block *this, unsigned long code,
+static int sbc8360_notify_sys(struct notifier_block *nb, unsigned long code,
 			      void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/watchdog/sbc_epx_c3.c
+++ b/drivers/watchdog/sbc_epx_c3.c
@@ -142,7 +142,7 @@ static long epx_c3_ioctl(struct file *file, unsigned int cmd,
 	}
 }
 
-static int epx_c3_notify_sys(struct notifier_block *this, unsigned long code,
+static int epx_c3_notify_sys(struct notifier_block *nb, unsigned long code,
 				void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/watchdog/sc1200wdt.c
+++ b/drivers/watchdog/sc1200wdt.c
@@ -288,7 +288,7 @@ static ssize_t sc1200wdt_write(struct file *file, const char __user *data,
 }
 
 
-static int sc1200wdt_notify_sys(struct notifier_block *this,
+static int sc1200wdt_notify_sys(struct notifier_block *nb,
 					unsigned long code, void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/watchdog/sc520_wdt.c
+++ b/drivers/watchdog/sc520_wdt.c
@@ -349,7 +349,7 @@ static struct miscdevice wdt_miscdev = {
  *	Notifier for system down
  */
 
-static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
+static int wdt_notify_sys(struct notifier_block *nb, unsigned long code,
 	void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/watchdog/scx200_wdt.c
+++ b/drivers/watchdog/scx200_wdt.c
@@ -114,7 +114,7 @@ static int scx200_wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int scx200_wdt_notify_sys(struct notifier_block *this,
+static int scx200_wdt_notify_sys(struct notifier_block *nb,
 				      unsigned long code, void *unused)
 {
 	if (code == SYS_HALT || code == SYS_POWER_OFF)
--- a/drivers/watchdog/smsc37b787_wdt.c
+++ b/drivers/watchdog/smsc37b787_wdt.c
@@ -487,7 +487,7 @@ static long wb_smsc_wdt_ioctl(struct file *file,
 
 /* -- Notifier funtions -----------------------------------------*/
 
-static int wb_smsc_wdt_notify_sys(struct notifier_block *this,
+static int wb_smsc_wdt_notify_sys(struct notifier_block *nb,
 					unsigned long code, void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT) {
--- a/drivers/watchdog/w83877f_wdt.c
+++ b/drivers/watchdog/w83877f_wdt.c
@@ -317,7 +317,7 @@ static struct miscdevice wdt_miscdev = {
  *	Notifier for system down
  */
 
-static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
+static int wdt_notify_sys(struct notifier_block *nb, unsigned long code,
 	void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/watchdog/w83977f_wdt.c
+++ b/drivers/watchdog/w83977f_wdt.c
@@ -433,7 +433,7 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	}
 }
 
-static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
+static int wdt_notify_sys(struct notifier_block *nb, unsigned long code,
 	void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/watchdog/wafer5823wdt.c
+++ b/drivers/watchdog/wafer5823wdt.c
@@ -213,7 +213,7 @@ static int wafwdt_close(struct inode *inode, struct file *file)
  *	Notifier for system down
  */
 
-static int wafwdt_notify_sys(struct notifier_block *this, unsigned long code,
+static int wafwdt_notify_sys(struct notifier_block *nb, unsigned long code,
 								void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/watchdog/wdrtas.c
+++ b/drivers/watchdog/wdrtas.c
@@ -456,7 +456,7 @@ static int wdrtas_temp_close(struct inode *inode, struct file *file)
  *
  * wdrtas_reboot stops the watchdog in case of a reboot
  */
-static int wdrtas_reboot(struct notifier_block *this,
+static int wdrtas_reboot(struct notifier_block *nb,
 					unsigned long code, void *ptr)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -495,7 +495,7 @@ static int wdt_temp_release(struct inode *inode, struct file *file)
 
 /**
  *	notify_sys:
- *	@this: our notifier block
+ *	@nb: our notifier block
  *	@code: the event being reported
  *	@unused: unused
  *
@@ -505,7 +505,7 @@ static int wdt_temp_release(struct inode *inode, struct file *file)
  *	trust me - if it happens it does suck.
  */
 
-static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
+static int wdt_notify_sys(struct notifier_block *nb, unsigned long code,
 	void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/watchdog/wdt977.c
+++ b/drivers/watchdog/wdt977.c
@@ -409,7 +409,7 @@ static long wdt977_ioctl(struct file *file, unsigned int cmd,
 	}
 }
 
-static int wdt977_notify_sys(struct notifier_block *this, unsigned long code,
+static int wdt977_notify_sys(struct notifier_block *nb, unsigned long code,
 	void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -538,7 +538,7 @@ static int wdtpci_temp_release(struct inode *inode, struct file *file)
 
 /**
  *	notify_sys:
- *	@this: our notifier block
+ *	@nb: our notifier block
  *	@code: the event being reported
  *	@unused: unused
  *
@@ -548,7 +548,7 @@ static int wdtpci_temp_release(struct inode *inode, struct file *file)
  *	trust me - if it happens it does suck.
  */
 
-static int wdtpci_notify_sys(struct notifier_block *this, unsigned long code,
+static int wdtpci_notify_sys(struct notifier_block *nb, unsigned long code,
 							void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -296,7 +296,7 @@ static void lockd_down_net(struct svc_serv *serv, struct net *net)
 	}
 }
 
-static int lockd_inetaddr_event(struct notifier_block *this,
+static int lockd_inetaddr_event(struct notifier_block *nb,
 	unsigned long event, void *ptr)
 {
 	struct in_ifaddr *ifa = (struct in_ifaddr *)ptr;
@@ -326,7 +326,7 @@ static struct notifier_block lockd_inetaddr_notifier = {
 };
 
 #if IS_ENABLED(CONFIG_IPV6)
-static int lockd_inet6addr_event(struct notifier_block *this,
+static int lockd_inet6addr_event(struct notifier_block *nb,
 	unsigned long event, void *ptr)
 {
 	struct inet6_ifaddr *ifa = (struct inet6_ifaddr *)ptr;
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -436,7 +436,7 @@ static void nfsd_shutdown_net(struct net *net)
 	nfsd_shutdown_generic();
 }
 
-static int nfsd_inetaddr_event(struct notifier_block *this, unsigned long event,
+static int nfsd_inetaddr_event(struct notifier_block *nb, unsigned long event,
 	void *ptr)
 {
 	struct in_ifaddr *ifa = (struct in_ifaddr *)ptr;
@@ -467,7 +467,7 @@ static struct notifier_block nfsd_inetaddr_notifier = {
 };
 
 #if IS_ENABLED(CONFIG_IPV6)
-static int nfsd_inet6addr_event(struct notifier_block *this,
+static int nfsd_inet6addr_event(struct notifier_block *nb,
 	unsigned long event, void *ptr)
 {
 	struct inet6_ifaddr *ifa = (struct inet6_ifaddr *)ptr;
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -985,7 +985,7 @@ void __init dbg_late_init(void)
 }
 
 static int
-dbg_notify_reboot(struct notifier_block *this, unsigned long code, void *x)
+dbg_notify_reboot(struct notifier_block *nb, unsigned long code, void *x)
 {
 	/*
 	 * Take the following action on reboot notify depending on value:
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -73,7 +73,7 @@ unsigned int __read_mostly sysctl_hung_task_panic =
 				CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE;
 
 static int
-hung_task_panic(struct notifier_block *this, unsigned long event, void *ptr)
+hung_task_panic(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	did_panic = 1;
 
--- a/kernel/rcu/tree_stall.h
+++ b/kernel/rcu/tree_stall.h
@@ -86,7 +86,7 @@ void rcu_sysrq_end(void)
 }
 
 /* Don't print RCU CPU stall warnings during a kernel panic. */
-static int rcu_panic(struct notifier_block *this, unsigned long ev, void *ptr)
+static int rcu_panic(struct notifier_block *nb, unsigned long ev, void *ptr)
 {
 	rcu_cpu_stall_suppress = 1;
 	return NOTIFY_DONE;
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9095,7 +9095,7 @@ static __init int tracer_init_tracefs(void)
 	return 0;
 }
 
-static int trace_panic_handler(struct notifier_block *this,
+static int trace_panic_handler(struct notifier_block *nb,
 			       unsigned long event, void *unused)
 {
 	if (ftrace_dump_on_oops)
--- a/net/appletalk/aarp.c
+++ b/net/appletalk/aarp.c
@@ -324,7 +324,7 @@ static void aarp_expire_timeout(struct timer_list *unused)
 }
 
 /* Network device notifier chain handler. */
-static int aarp_device_event(struct notifier_block *this, unsigned long event,
+static int aarp_device_event(struct notifier_block *nb, unsigned long event,
 			     void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -636,7 +636,7 @@ static inline void atalk_dev_down(struct net_device *dev)
  * A device event has occurred. Watch for devices going down and
  * delete our use of them (iface and route).
  */
-static int ddp_device_event(struct notifier_block *this, unsigned long event,
+static int ddp_device_event(struct notifier_block *nb, unsigned long event,
 			    void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/atm/br2684.c
+++ b/net/atm/br2684.c
@@ -144,7 +144,7 @@ static struct net_device *br2684_find_dev(const struct br2684_if_spec *s)
 	return NULL;
 }
 
-static int atm_dev_event(struct notifier_block *this, unsigned long event,
+static int atm_dev_event(struct notifier_block *nb, unsigned long event,
 		 void *arg)
 {
 	struct atm_dev *atm_dev = arg;
--- a/net/atm/clip.c
+++ b/net/atm/clip.c
@@ -542,7 +542,7 @@ static int clip_create(int number)
 	return number;
 }
 
-static int clip_device_event(struct notifier_block *this, unsigned long event,
+static int clip_device_event(struct notifier_block *nb, unsigned long event,
 			     void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
@@ -575,7 +575,7 @@ static int clip_device_event(struct notifier_block *this, unsigned long event,
 	return NOTIFY_DONE;
 }
 
-static int clip_inet_event(struct notifier_block *this, unsigned long event,
+static int clip_inet_event(struct notifier_block *nb, unsigned long event,
 			   void *ifa)
 {
 	struct in_device *in_dev;
@@ -589,7 +589,7 @@ static int clip_inet_event(struct notifier_block *this, unsigned long event,
 	if (event != NETDEV_UP)
 		return NOTIFY_DONE;
 	netdev_notifier_info_init(&info, in_dev->dev);
-	return clip_device_event(this, NETDEV_CHANGE, &info);
+	return clip_device_event(nb, NETDEV_CHANGE, &info);
 }
 
 static struct notifier_block clip_dev_notifier = {
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -106,7 +106,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 /*
  *	Handle device status changes.
  */
-static int ax25_device_event(struct notifier_block *this, unsigned long event,
+static int ax25_device_event(struct notifier_block *nb, unsigned long event,
 			     void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -1017,7 +1017,7 @@ static int batadv_hard_if_event_softif(unsigned long event,
 	return NOTIFY_DONE;
 }
 
-static int batadv_hard_if_event(struct notifier_block *this,
+static int batadv_hard_if_event(struct notifier_block *nb,
 				unsigned long event, void *ptr)
 {
 	struct net_device *net_dev = netdev_notifier_info_to_dev(ptr);
--- a/net/core/failover.c
+++ b/net/core/failover.c
@@ -183,7 +183,7 @@ static int failover_slave_name_change(struct net_device *slave_dev)
 }
 
 static int
-failover_event(struct notifier_block *this, unsigned long event, void *ptr)
+failover_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	struct net_device *event_dev = netdev_notifier_info_to_dev(ptr);
 
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -1194,7 +1194,7 @@ static void detach_rules(struct list_head *rules, struct net_device *dev)
 }
 
 
-static int fib_rules_event(struct notifier_block *this, unsigned long event,
+static int fib_rules_event(struct notifier_block *nb, unsigned long event,
 			   void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5490,7 +5490,7 @@ static int rtnetlink_bind(struct net *net, int group)
 	return 0;
 }
 
-static int rtnetlink_event(struct notifier_block *this, unsigned long event, void *ptr)
+static int rtnetlink_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -2076,7 +2076,7 @@ static int dn_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	return err;
 }
 
-static int dn_device_event(struct notifier_block *this, unsigned long event,
+static int dn_device_event(struct notifier_block *nb, unsigned long event,
 			   void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/decnet/dn_fib.c
+++ b/net/decnet/dn_fib.c
@@ -672,7 +672,7 @@ static void dn_fib_disable_addr(struct net_device *dev, int force)
 	neigh_ifdown(&dn_neigh_table, dev);
 }
 
-static int dn_fib_dnaddr_event(struct notifier_block *this, unsigned long event, void *ptr)
+static int dn_fib_dnaddr_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	struct dn_ifaddr *ifa = (struct dn_ifaddr *)ptr;
 
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -666,7 +666,7 @@ static void ethnl_notify_features(struct netdev_notifier_info *info)
 	ethtool_notify(dev, ETHTOOL_MSG_FEATURES_NTF, NULL);
 }
 
-static int ethnl_netdev_event(struct notifier_block *this, unsigned long event,
+static int ethnl_netdev_event(struct notifier_block *nb, unsigned long event,
 			      void *ptr)
 {
 	switch (event) {
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1236,7 +1236,7 @@ int arp_ioctl(struct net *net, unsigned int cmd, void __user *arg)
 	return err;
 }
 
-static int arp_netdev_event(struct notifier_block *this, unsigned long event,
+static int arp_netdev_event(struct notifier_block *nb, unsigned long event,
 			    void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1518,7 +1518,7 @@ static void inetdev_send_gratuitous_arp(struct net_device *dev,
 
 /* Called only under RTNL semaphore */
 
-static int inetdev_event(struct notifier_block *this, unsigned long event,
+static int inetdev_event(struct notifier_block *nb, unsigned long event,
 			 void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1408,7 +1408,7 @@ static void fib_disable_ip(struct net_device *dev, unsigned long event,
 	arp_ifdown(dev);
 }
 
-static int fib_inetaddr_event(struct notifier_block *this, unsigned long event, void *ptr)
+static int fib_inetaddr_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	struct in_ifaddr *ifa = (struct in_ifaddr *)ptr;
 	struct net_device *dev = ifa->ifa_dev->dev;
@@ -1439,7 +1439,7 @@ static int fib_inetaddr_event(struct notifier_block *this, unsigned long event,
 	return NOTIFY_DONE;
 }
 
-static int fib_netdev_event(struct notifier_block *this, unsigned long event, void *ptr)
+static int fib_netdev_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct netdev_notifier_changeupper_info *upper_info = ptr;
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -3034,7 +3034,7 @@ static struct pernet_operations igmp_net_ops = {
 };
 #endif
 
-static int igmp_netdev_event(struct notifier_block *this,
+static int igmp_netdev_event(struct notifier_block *nb,
 			     unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1709,7 +1709,7 @@ int ipmr_compat_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
 }
 #endif
 
-static int ipmr_device_event(struct notifier_block *this, unsigned long event, void *ptr)
+static int ipmr_device_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct net *net = dev_net(dev);
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -185,7 +185,7 @@ clusterip_config_init_nodelist(struct clusterip_config *c,
 }
 
 static int
-clusterip_netdev_event(struct notifier_block *this, unsigned long event,
+clusterip_netdev_event(struct notifier_block *nb, unsigned long event,
 		       void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1891,7 +1891,7 @@ static void nexthop_sync_mtu(struct net_device *dev, u32 orig_mtu)
 }
 
 /* rtnl */
-static int nh_netdev_event(struct notifier_block *this,
+static int nh_netdev_event(struct notifier_block *nb,
 			   unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3445,7 +3445,7 @@ static void addrconf_permanent_addr(struct net *net, struct net_device *dev)
 	write_unlock_bh(&idev->lock);
 }
 
-static int addrconf_notify(struct notifier_block *this, unsigned long event,
+static int addrconf_notify(struct notifier_block *nb, unsigned long event,
 			   void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1230,7 +1230,7 @@ static int ip6mr_mfc_delete(struct mr_table *mrt, struct mf6cctl *mfc,
 	return 0;
 }
 
-static int ip6mr_device_event(struct notifier_block *this,
+static int ip6mr_device_event(struct notifier_block *nb,
 			      unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2637,7 +2637,7 @@ static void ipv6_mc_rejoin_groups(struct inet6_dev *idev)
 		mld_send_report(idev, NULL);
 }
 
-static int ipv6_mc_netdev_event(struct notifier_block *this,
+static int ipv6_mc_netdev_event(struct notifier_block *nb,
 				unsigned long event,
 				void *ptr)
 {
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1772,7 +1772,7 @@ int ndisc_rcv(struct sk_buff *skb)
 	return 0;
 }
 
-static int ndisc_netdev_event(struct notifier_block *this, unsigned long event, void *ptr)
+static int ndisc_netdev_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct netdev_notifier_change_info *change_info;
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6058,7 +6058,7 @@ void fib6_rt_update(struct net *net, struct fib6_info *rt,
 		rtnl_set_sk_err(net, RTNLGRP_IPV6_ROUTE, err);
 }
 
-static int ip6_route_dev_notify(struct notifier_block *this,
+static int ip6_route_dev_notify(struct notifier_block *nb,
 				unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2203,7 +2203,7 @@ static void afiucv_hs_callback_txnotify(struct sk_buff *skb,
 /*
  * afiucv_netdev_event: handle netdev notifier chain events
  */
-static int afiucv_netdev_event(struct notifier_block *this,
+static int afiucv_netdev_event(struct notifier_block *nb,
 			       unsigned long event, void *ptr)
 {
 	struct net_device *event_dev = netdev_notifier_info_to_dev(ptr);
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -776,7 +776,7 @@ void iucv_unregister(struct iucv_handler *handler, int smp)
 }
 EXPORT_SYMBOL(iucv_unregister);
 
-static int iucv_reboot_event(struct notifier_block *this,
+static int iucv_reboot_event(struct notifier_block *nb,
 			     unsigned long event, void *ptr)
 {
 	int i;
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1576,7 +1576,7 @@ static void mpls_ifup(struct net_device *dev, unsigned int flags)
 	}
 }
 
-static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
+static int mpls_dev_notify(struct notifier_block *nb, unsigned long event,
 			   void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1647,7 +1647,7 @@ ip_vs_forget_dev(struct ip_vs_dest *dest, struct net_device *dev)
 /* Netdev event receiver
  * Currently only NETDEV_DOWN is handled to release refs to cached dsts
  */
-static int ip_vs_dst_event(struct notifier_block *this, unsigned long event,
+static int ip_vs_dst_event(struct notifier_block *nb, unsigned long event,
 			   void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -72,7 +72,7 @@ static int device_cmp(struct nf_conn *i, void *ifindex)
 	return nat->masq_index == (int)(long)ifindex;
 }
 
-static int masq_device_event(struct notifier_block *this,
+static int masq_device_event(struct notifier_block *nb,
 			     unsigned long event,
 			     void *ptr)
 {
@@ -106,7 +106,7 @@ static int inet_cmp(struct nf_conn *ct, void *ptr)
 	return ifa->ifa_address == tuple->dst.u3.ip;
 }
 
-static int masq_inet_event(struct notifier_block *this,
+static int masq_inet_event(struct notifier_block *nb,
 			   unsigned long event,
 			   void *ptr)
 {
@@ -228,7 +228,7 @@ static void iterate_cleanup_work(struct work_struct *work)
  * As we can have 'a lot' of inet_events (depending on amount of ipv6
  * addresses being deleted), we also need to limit work item queue.
  */
-static int masq_inet6_event(struct notifier_block *this,
+static int masq_inet6_event(struct notifier_block *nb,
 			    unsigned long event, void *ptr)
 {
 	struct inet6_ifaddr *ifa = ptr;
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6960,7 +6960,7 @@ static void nft_flowtable_event(unsigned long event, struct net_device *dev,
 	}
 }
 
-static int nf_tables_flowtable_event(struct notifier_block *this,
+static int nf_tables_flowtable_event(struct notifier_block *nb,
 				     unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -556,7 +556,7 @@ static struct nft_chain *__nft_offload_get_chain(struct net_device *dev)
 	return NULL;
 }
 
-static int nft_offload_netdev_event(struct notifier_block *this,
+static int nft_offload_netdev_event(struct notifier_block *nb,
 				    unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -815,7 +815,7 @@ nfulnl_log_packet(struct net *net,
 }
 
 static int
-nfulnl_rcv_nl_event(struct notifier_block *this,
+nfulnl_rcv_nl_event(struct notifier_block *nb,
 		   unsigned long event, void *ptr)
 {
 	struct netlink_notify *n = ptr;
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -933,7 +933,7 @@ nfqnl_dev_drop(struct net *net, int ifindex)
 }
 
 static int
-nfqnl_rcv_dev_event(struct notifier_block *this,
+nfqnl_rcv_dev_event(struct notifier_block *nb,
 		    unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
@@ -963,7 +963,7 @@ static void nfqnl_nf_hook_drop(struct net *net)
 }
 
 static int
-nfqnl_rcv_nl_event(struct notifier_block *this,
+nfqnl_rcv_nl_event(struct notifier_block *nb,
 		   unsigned long event, void *ptr)
 {
 	struct netlink_notify *n = ptr;
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -318,7 +318,7 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 	__nft_release_basechain(ctx);
 }
 
-static int nf_tables_netdev_event(struct notifier_block *this,
+static int nf_tables_netdev_event(struct notifier_block *nb,
 				  unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -237,7 +237,7 @@ static struct nft_expr_type nft_flow_offload_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 
-static int flow_offload_netdev_event(struct notifier_block *this,
+static int flow_offload_netdev_event(struct notifier_block *nb,
 				     unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -57,7 +57,7 @@ tee_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 }
 #endif
 
-static int tee_netdev_event(struct notifier_block *this, unsigned long event,
+static int tee_netdev_event(struct notifier_block *nb, unsigned long event,
 			    void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -686,7 +686,7 @@ int netlbl_unlhsh_remove(struct net *net,
 
 /**
  * netlbl_unlhsh_netdev_handler - Network device notification handler
- * @this: notifier block
+ * @nb: notifier block
  * @event: the event
  * @ptr: the netdevice notifier info (cast to void)
  *
@@ -696,7 +696,7 @@ int netlbl_unlhsh_remove(struct net *net,
  * related entries from the unlabeled connection hash table.
  *
  */
-static int netlbl_unlhsh_netdev_handler(struct notifier_block *this,
+static int netlbl_unlhsh_netdev_handler(struct notifier_block *nb,
 					unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -112,7 +112,7 @@ static void nr_kill_by_device(struct net_device *dev)
 /*
  *	Handle device status changes.
  */
-static int nr_device_event(struct notifier_block *this, unsigned long event, void *ptr)
+static int nr_device_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1806,7 +1806,7 @@ static void nfc_urelease_event_work(struct work_struct *work)
 	kfree(w);
 }
 
-static int nfc_genl_rcv_nl_event(struct notifier_block *this,
+static int nfc_genl_rcv_nl_event(struct notifier_block *nb,
 				 unsigned long event, void *ptr)
 {
 	struct netlink_notify *n = ptr;
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4062,7 +4062,7 @@ static int compat_packet_setsockopt(struct socket *sock, int level, int optname,
 }
 #endif
 
-static int packet_notifier(struct notifier_block *this,
+static int packet_notifier(struct notifier_block *nb,
 			   unsigned long msg, void *ptr)
 {
 	struct sock *sk;
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -200,7 +200,7 @@ static void rose_kill_by_device(struct net_device *dev)
 /*
  *	Handle device status changes.
  */
-static int rose_device_event(struct notifier_block *this,
+static int rose_device_event(struct notifier_block *nb,
 			     unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -71,7 +71,7 @@ static int sctp_v6_cmp_addr(const union sctp_addr *addr1,
  * time and thus corrupt the list.
  * The reader side is protected with RCU.
  */
-static int sctp_inet6addr_event(struct notifier_block *this, unsigned long ev,
+static int sctp_inet6addr_event(struct notifier_block *nb, unsigned long ev,
 				void *ptr)
 {
 	struct inet6_ifaddr *ifa = (struct inet6_ifaddr *)ptr;
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -766,7 +766,7 @@ void sctp_addr_wq_mgmt(struct net *net, struct sctp_sockaddr_entry *addr, int cm
  * time and thus corrupt the list.
  * The reader side is protected with RCU.
  */
-static int sctp_inetaddr_event(struct notifier_block *this, unsigned long ev,
+static int sctp_inetaddr_event(struct notifier_block *nb, unsigned long ev,
 			       void *ptr)
 {
 	struct in_ifaddr *ifa = (struct in_ifaddr *)ptr;
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1986,7 +1986,7 @@ static void smc_lgrs_shutdown(void)
 	spin_unlock(&smcd_dev_list.lock);
 }
 
-static int smc_core_reboot_event(struct notifier_block *this,
+static int smc_core_reboot_event(struct notifier_block *nb,
 				 unsigned long event, void *ptr)
 {
 	smc_lgrs_shutdown();
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -707,7 +707,7 @@ static struct genl_family smc_pnet_nl_family __ro_after_init = {
 	.n_ops =  ARRAY_SIZE(smc_pnet_ops)
 };
 
-static int smc_pnet_netdev_event(struct notifier_block *this,
+static int smc_pnet_netdev_event(struct notifier_block *nb,
 				 unsigned long event, void *ptr)
 {
 	struct net_device *event_dev = netdev_notifier_info_to_dev(ptr);
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1245,7 +1245,7 @@ static int tls_device_down(struct net_device *netdev)
 	return NOTIFY_DONE;
 }
 
-static int tls_dev_event(struct notifier_block *this, unsigned long event,
+static int tls_dev_event(struct notifier_block *nb, unsigned long event,
 			 void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -218,11 +218,11 @@ static void x25_kill_by_device(struct net_device *dev)
 /*
  *	Handle device status changes.
  */
-static int x25_device_event(struct notifier_block *this, unsigned long event,
+static int x25_device_event(struct notifier_block *nb, unsigned long event,
 			    void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct x25_neigh *nb;
+	struct x25_neigh *neigh;
 
 	if (!net_eq(dev_net(dev), &init_net))
 		return NOTIFY_DONE;
@@ -237,10 +237,10 @@ static int x25_device_event(struct notifier_block *this, unsigned long event,
 			x25_link_device_up(dev);
 			break;
 		case NETDEV_GOING_DOWN:
-			nb = x25_get_neigh(dev);
-			if (nb) {
-				x25_terminate_link(nb);
-				x25_neigh_put(nb);
+			neigh = x25_get_neigh(dev);
+			if (neigh) {
+				x25_terminate_link(neigh);
+				x25_neigh_put(neigh);
 			}
 			break;
 		case NETDEV_DOWN:
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -972,7 +972,7 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 			       size, vma->vm_page_prot);
 }
 
-static int xsk_notifier(struct notifier_block *this,
+static int xsk_notifier(struct notifier_block *nb,
 			unsigned long msg, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -395,7 +395,7 @@ static int xfrm_dev_down(struct net_device *dev)
 	return NOTIFY_DONE;
 }
 
-static int xfrm_dev_event(struct notifier_block *this, unsigned long event, void *ptr)
+static int xfrm_dev_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
--- a/security/selinux/netif.c
+++ b/security/selinux/netif.c
@@ -247,7 +247,7 @@ void sel_netif_flush(void)
 	spin_unlock_bh(&sel_netif_lock);
 }
 
-static int sel_netif_netdev_notifier_handler(struct notifier_block *this,
+static int sel_netif_netdev_notifier_handler(struct notifier_block *nb,
 					     unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
