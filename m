Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4631C409D
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 18:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729669AbgEDQ5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 12:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729553AbgEDQ5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 12:57:38 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1F4C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 09:57:38 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id a4so88087pgc.0
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 09:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daemons-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z3NYsHy1jFVKuIx89+E5z9qZ8TEJd1dMXiM1ctxfJr8=;
        b=SrGhxhrpClXsV4bk9050WnnTCzBEH7KG4lJPbuHhjHiDUaYWSZOx0lbW+gfJA4agDq
         Co6Pbdn5mafwPdBMo3V69+Eaj0oXv+mCAhhGmNa5Dojnwrt54nUeIenVdxdTeqI1fsNI
         cm5/15mFX2Xb8UUmViasjD0FTycx5vKgUiI7CLP5IvROEWIWB0jARW0psYcvdT1DIauF
         8Qzczj+p7TzWUaYl7Z23XM5LuHJnurAXnfAyAoHjPOgg6oZv6AFMes2hzT8wTZzv6bTL
         LuIzKuQgBIO22z19qdM6Z7q8+qUpvTohN7ELvCcO3VKplo4yIB331LXCvJ/Zp/HXZjnL
         ZAUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z3NYsHy1jFVKuIx89+E5z9qZ8TEJd1dMXiM1ctxfJr8=;
        b=kHIyTPlEFkmfxBlwoDr2V15dp1RQs5/7oWQ4PXa5kNv6OWBXhdRCKAu8LKB8EifA6Y
         Q+YKstt/boz42KDUuSwtkXhZW888qb159TIUiPMa7xsofQAJD55cbu6WPbA+6qyknSpo
         F6xfq58Zc+z+wU8izlfrCiFLIUQimG6vCHf7mz8f9XHhFLipo0Zpm2Dt+6u8UigeK4pe
         75AaNYHf1qgLjApHrRmfCgIrPdi515TL8G1SzLGE0iJftY+wHgc7ahaGswtfPEdWoneH
         vjMjQLKIA3lKX1Q+NJtklBjP0fGl1pVe5NXhlLde7jflpOM6hAKMJVYSBCue/SdbyQX2
         XACw==
X-Gm-Message-State: AGi0Pua4xhfJbX4YOWruXFzHCaZxoP9EtCrHk97aW9ijZA7GYUB2iBAb
        QwIjo1pFpE3OqSkH8PnUWn6X
X-Google-Smtp-Source: APiQypJcRwf080OF3IvaiRv8wJ6azWOpiCEl8NhtMhRtaJITJnJ3hbJv/bs+i33Zm6IW8Lszw/H0Sw==
X-Received: by 2002:a63:220a:: with SMTP id i10mr18699976pgi.364.1588611457784;
        Mon, 04 May 2020 09:57:37 -0700 (PDT)
Received: from localhost.localdomain ([47.156.151.166])
        by smtp.googlemail.com with ESMTPSA id fh18sm332462pjb.0.2020.05.04.09.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 09:57:36 -0700 (PDT)
From:   Clay McClure <clay@daemons.net>
Cc:     Clay McClure <clay@daemons.net>, Arnd Bergmann <arnd@arndb.de>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        kbuild test robot <lkp@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wingman Kwok <w-kwok2@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2] net: ethernet: ti: Remove TI_CPTS_MOD workaround
Date:   Mon,  4 May 2020 09:57:05 -0700
Message-Id: <20200504165711.5621-1-clay@daemons.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <CAK8P3a1m-zmiTx0_KJb-9PTW0iK+Zkh10gKsaBzge0OJALBFmQ@mail.gmail.com>
References: <CAK8P3a1m-zmiTx0_KJb-9PTW0iK+Zkh10gKsaBzge0OJALBFmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My recent commit b6d49cab44b5 ("net: Make PTP-specific drivers depend on PTP_1588_CLOCK")
exposes a missing dependency in defconfigs that select TI_CPTS without
selecting PTP_1588_CLOCK, leading to linker errors of the form:

drivers/net/ethernet/ti/cpsw.o: in function `cpsw_ndo_stop':
cpsw.c:(.text+0x680): undefined reference to `cpts_unregister'
drivers/net/ethernet/ti/cpsw.o: in function `cpsw_remove':
cpsw.c:(.text+0x81c): undefined reference to `cpts_release'
drivers/net/ethernet/ti/cpsw.o: in function `cpsw_rx_handler':
cpsw.c:(.text+0x1324): undefined reference to `cpts_rx_timestamp'
drivers/net/ethernet/ti/cpsw.o: in function `cpsw_ndo_open':
cpsw.c:(.text+0x15ec): undefined reference to `cpts_register'
drivers/net/ethernet/ti/cpsw.o: in function `cpsw_probe':
cpsw.c:(.text+0x2468): undefined reference to `cpts_release'

That's because TI_CPTS_MOD (which is the symbol gating the _compilation_
of cpts.c) now depends on PTP_1588_CLOCK, and so is not enabled in these
configurations, but TI_CPTS (which is the symbol gating _calls_ to the
cpts functions) _is_ enabled. So we end up compiling calls to functions
that don't exist, resulting in the linker errors.

The reason we have two symbols (TI_CPTS and TI_CPTS_MOD) for the same
driver is due to commit be9ca0d33c85 ("cpsw/netcp: work around reverse
cpts dependency"), which introduced TI_CPTS_MOD because (quoting the
commit message):

> The dependency is reversed: cpsw and netcp call into cpts,
> but cpts depends on the other two in Kconfig. This can lead
> to cpts being a loadable module and its callers built-in:
>
> drivers/net/ethernet/ti/cpsw.o: In function `cpsw_remove':
> cpsw.c:(.text.cpsw_remove+0xd0): undefined reference to `cpts_release'
> drivers/net/ethernet/ti/cpsw.o: In function `cpsw_rx_handler':
> cpsw.c:(.text.cpsw_rx_handler+0x2dc): undefined reference to `cpts_rx_timestamp'
> drivers/net/ethernet/ti/cpsw.o: In function `cpsw_tx_handler':
> cpsw.c:(.text.cpsw_tx_handler+0x7c): undefined reference to `cpts_tx_timestamp'
> drivers/net/ethernet/ti/cpsw.o: In function `cpsw_ndo_stop':

Both forms of linker error -- those caused by defconfigs that select
TI_CPTS without PTP_1588_CLOCK and those caused by configuring TI_CPSW
as a built-in and TI_CPTS as a module -- can be avoided by using the
IS_REACHABLE() macro to gate calls to cpts functions, and using the
TI_CPTS symbol to gate compilation of cpts.c. cpts.h already provides
the no-op stub implementations of the cpts functions required to make
this work, we just need to change the existing IS_ENABLED(TI_CPTS)
guards to IS_REACHABLE(TI_CPTS).

With this change there is no longer any need for the TI_CPTS_MOD symbol,
so we can remove it.

To preserve the existing behavior of defconfigs that select TI_CPTS, we
must also select PTP_1588_CLOCK so that the dependency is satisfied.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Fixes: b6d49cab44b5 ("net: Make PTP-specific drivers depend on PTP_1588_CLOCK")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Clay McClure <clay@daemons.net>
---
Changes in v2:

- Don't regenerate the defconfigs, just add PTP_1588_CLOCK.

 arch/arm/configs/keystone_defconfig    |  1 +
 arch/arm/configs/omap2plus_defconfig   |  1 +
 drivers/net/ethernet/ti/Kconfig        | 13 ++++---------
 drivers/net/ethernet/ti/Makefile       |  2 +-
 drivers/net/ethernet/ti/cpsw_ethtool.c |  2 +-
 drivers/net/ethernet/ti/cpts.h         |  3 +--
 drivers/net/ethernet/ti/netcp_ethss.c  | 10 +++++-----
 7 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/arch/arm/configs/keystone_defconfig b/arch/arm/configs/keystone_defconfig
index 11e2211f9007..84a3b055f253 100644
--- a/arch/arm/configs/keystone_defconfig
+++ b/arch/arm/configs/keystone_defconfig
@@ -147,6 +147,7 @@ CONFIG_I2C_DAVINCI=y
 CONFIG_SPI=y
 CONFIG_SPI_DAVINCI=y
 CONFIG_SPI_SPIDEV=y
+CONFIG_PTP_1588_CLOCK=y
 CONFIG_PINCTRL_SINGLE=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index 3cc3ca5fa027..8b83d4a5d309 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -274,6 +274,7 @@ CONFIG_SPI_TI_QSPI=m
 CONFIG_HSI=m
 CONFIG_OMAP_SSI=m
 CONFIG_SSI_PROTOCOL=m
+CONFIG_PTP_1588_CLOCK=y
 CONFIG_PINCTRL_SINGLE=y
 CONFIG_DEBUG_GPIO=y
 CONFIG_GPIO_SYSFS=y
diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index 8e348780efb6..f3f8bb724294 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -77,23 +77,18 @@ config TI_CPSW_SWITCHDEV
 	  will be called cpsw_new.
 
 config TI_CPTS
-	bool "TI Common Platform Time Sync (CPTS) Support"
+	tristate "TI Common Platform Time Sync (CPTS) Support"
 	depends on TI_CPSW || TI_KEYSTONE_NETCP || TI_CPSW_SWITCHDEV || COMPILE_TEST
 	depends on COMMON_CLK
-	depends on POSIX_TIMERS
+	depends on PTP_1588_CLOCK
+	default y if TI_CPSW=y || TI_KEYSTONE_NETCP=y || TI_CPSW_SWITCHDEV=y
+	default m
 	---help---
 	  This driver supports the Common Platform Time Sync unit of
 	  the CPSW Ethernet Switch and Keystone 2 1g/10g Switch Subsystem.
 	  The unit can time stamp PTP UDP/IPv4 and Layer 2 packets, and the
 	  driver offers a PTP Hardware Clock.
 
-config TI_CPTS_MOD
-	tristate
-	depends on TI_CPTS
-	depends on PTP_1588_CLOCK
-	default y if TI_CPSW=y || TI_KEYSTONE_NETCP=y || TI_CPSW_SWITCHDEV=y
-	default m
-
 config TI_K3_AM65_CPSW_NUSS
 	tristate "TI K3 AM654x/J721E CPSW Ethernet driver"
 	depends on ARCH_K3 && OF && TI_K3_UDMA_GLUE_LAYER
diff --git a/drivers/net/ethernet/ti/Makefile b/drivers/net/ethernet/ti/Makefile
index 53792190e9c2..cb26a9d21869 100644
--- a/drivers/net/ethernet/ti/Makefile
+++ b/drivers/net/ethernet/ti/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_TI_DAVINCI_EMAC) += ti_davinci_emac.o
 ti_davinci_emac-y := davinci_emac.o davinci_cpdma.o
 obj-$(CONFIG_TI_DAVINCI_MDIO) += davinci_mdio.o
 obj-$(CONFIG_TI_CPSW_PHY_SEL) += cpsw-phy-sel.o
-obj-$(CONFIG_TI_CPTS_MOD) += cpts.o
+obj-$(CONFIG_TI_CPTS) += cpts.o
 obj-$(CONFIG_TI_CPSW) += ti_cpsw.o
 ti_cpsw-y := cpsw.o davinci_cpdma.o cpsw_ale.o cpsw_priv.o cpsw_sl.o cpsw_ethtool.o
 obj-$(CONFIG_TI_CPSW_SWITCHDEV) += ti_cpsw_new.o
diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index fa54efe3be63..19a7370a4188 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -709,7 +709,7 @@ int cpsw_set_ringparam(struct net_device *ndev,
 	return ret;
 }
 
-#if IS_ENABLED(CONFIG_TI_CPTS)
+#if IS_REACHABLE(CONFIG_TI_CPTS)
 int cpsw_get_ts_info(struct net_device *ndev, struct ethtool_ts_info *info)
 {
 	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
diff --git a/drivers/net/ethernet/ti/cpts.h b/drivers/net/ethernet/ti/cpts.h
index bb997c11ee15..782e24c78e7a 100644
--- a/drivers/net/ethernet/ti/cpts.h
+++ b/drivers/net/ethernet/ti/cpts.h
@@ -8,7 +8,7 @@
 #ifndef _TI_CPTS_H_
 #define _TI_CPTS_H_
 
-#if IS_ENABLED(CONFIG_TI_CPTS)
+#if IS_REACHABLE(CONFIG_TI_CPTS)
 
 #include <linux/clk.h>
 #include <linux/clkdev.h>
@@ -171,5 +171,4 @@ static inline bool cpts_can_timestamp(struct cpts *cpts, struct sk_buff *skb)
 }
 #endif
 
-
 #endif
diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/ti/netcp_ethss.c
index fb36115e9c51..3de1d25128b7 100644
--- a/drivers/net/ethernet/ti/netcp_ethss.c
+++ b/drivers/net/ethernet/ti/netcp_ethss.c
@@ -181,7 +181,7 @@
 
 #define HOST_TX_PRI_MAP_DEFAULT			0x00000000
 
-#if IS_ENABLED(CONFIG_TI_CPTS)
+#if IS_REACHABLE(CONFIG_TI_CPTS)
 /* Px_TS_CTL register fields */
 #define TS_RX_ANX_F_EN				BIT(0)
 #define TS_RX_VLAN_LT1_EN			BIT(1)
@@ -2000,7 +2000,7 @@ static int keystone_set_link_ksettings(struct net_device *ndev,
 	return phy_ethtool_ksettings_set(phy, cmd);
 }
 
-#if IS_ENABLED(CONFIG_TI_CPTS)
+#if IS_REACHABLE(CONFIG_TI_CPTS)
 static int keystone_get_ts_info(struct net_device *ndev,
 				struct ethtool_ts_info *info)
 {
@@ -2532,7 +2532,7 @@ static int gbe_del_vid(void *intf_priv, int vid)
 	return 0;
 }
 
-#if IS_ENABLED(CONFIG_TI_CPTS)
+#if IS_REACHABLE(CONFIG_TI_CPTS)
 
 static void gbe_txtstamp(void *context, struct sk_buff *skb)
 {
@@ -2977,7 +2977,7 @@ static int gbe_close(void *intf_priv, struct net_device *ndev)
 	return 0;
 }
 
-#if IS_ENABLED(CONFIG_TI_CPTS)
+#if IS_REACHABLE(CONFIG_TI_CPTS)
 static void init_slave_ts_ctl(struct gbe_slave *slave)
 {
 	slave->ts_ctl.uni = 1;
@@ -3718,7 +3718,7 @@ static int gbe_probe(struct netcp_device *netcp_device, struct device *dev,
 
 	gbe_dev->cpts = cpts_create(gbe_dev->dev, gbe_dev->cpts_reg, cpts_node);
 	of_node_put(cpts_node);
-	if (IS_ENABLED(CONFIG_TI_CPTS) && IS_ERR(gbe_dev->cpts)) {
+	if (IS_REACHABLE(CONFIG_TI_CPTS) && IS_ERR(gbe_dev->cpts)) {
 		ret = PTR_ERR(gbe_dev->cpts);
 		goto free_sec_ports;
 	}
-- 
2.20.1

