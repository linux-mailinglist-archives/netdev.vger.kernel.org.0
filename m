Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD0A1BB99B
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 11:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgD1JN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 05:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726462AbgD1JN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 05:13:58 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28159C03C1AB
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 02:13:58 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t16so8113565plo.7
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 02:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daemons-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xUhBUrl9Kc4rstZhnUAfruOOJTFBX99jmJUUZfVXyT8=;
        b=rwFbMZSM6Syhnc+1CcRzNtF7U0iyDH0CNNHXC3G36/pyUqb8WDFG0/PPqeEU4fAFPC
         6L+siEA1kb+C5CXi61p5JoGpWp9/GHAjLIlKDmhMs0HwuEr3ktJUnst1YAzcYTT5l2Pv
         qAEVjK5pL9efJW8kc2I4gpiB8r2hr8k2+t7sS59ETfG36Ovx8FNtmbB3Wab+sOh1NpRI
         aT0Nxzf0B8xpYVY2p5sUvm6gdu4dDk8zumi0abTIzv3Nw7TTBot3/8ks+BrVqNm2pSXm
         3pGYDOLVlxufA18qd0MPx96Tnq2H3+Jtj2T4Yu5EFodxfTu02a/EhAE6Rx3WxEyLg8Qs
         +WUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xUhBUrl9Kc4rstZhnUAfruOOJTFBX99jmJUUZfVXyT8=;
        b=nfe13FsCe+7SiJGbg2yy/lT7cgM0i2uXBwjENq0Jgk7DHbjuzNWBibdoPKf0B7J9/8
         zYIrmEbFiJgpJkSua2Y7LTq+D39L4YKLnNU1X1bpinsWuz9Ul0C0QIDbXKj2B5J8lQyd
         NuO04UBh7oniSKLot5M67YJdKVfdhL4KRqtqc5mPOxql58BYo//Eepeamy3xLb1+ZAte
         datk4PR88d5WHUca/8T3vzWvVQkA0tNqibn5xVevoHAJpeeuU6FW30Q4bDg96oh6Fk+P
         TD5GO99lRQ74H/5gemd92Wo7R6fIP7C6LZUUVE0j3BsLPi1jGzy0oYFN/xg+zDzLdNSA
         cxgA==
X-Gm-Message-State: AGi0PuaoVbib4q3Dj8m4KVS+enzG5YGd7YFgpZ7AHOClrMzmzoPE2MWr
        iyikmIQc5i9XmNXtn+aoXLQH
X-Google-Smtp-Source: APiQypK432KZI5avbvytPqeej2cdwTFN1mYbR/vnZB1jogWWvBSxHuDu1/TXaLEzwgxyaC3nF2FabA==
X-Received: by 2002:a17:90a:290f:: with SMTP id g15mr3903364pjd.93.1588065237310;
        Tue, 28 Apr 2020 02:13:57 -0700 (PDT)
Received: from localhost.localdomain ([47.156.151.166])
        by smtp.googlemail.com with ESMTPSA id f74sm1803376pje.3.2020.04.28.02.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 02:13:56 -0700 (PDT)
From:   Clay McClure <clay@daemons.net>
Cc:     Clay McClure <clay@daemons.net>, Arnd Bergmann <arnd@arndb.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Mao Wenan <maowenan@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Edward Cree <ecree@solarflare.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Josh Triplett <josh@joshtriplett.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: Select PTP_1588_CLOCK in PTP-specific drivers
Date:   Tue, 28 Apr 2020 02:07:47 -0700
Message-Id: <20200428090749.31983-1-clay@daemons.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d1cbfd771ce8 ("ptp_clock: Allow for it to be optional") changed
all PTP-capable Ethernet drivers from `select PTP_1588_CLOCK` to `imply
PTP_1588_CLOCK`, "in order to break the hard dependency between the PTP
clock subsystem and ethernet drivers capable of being clock providers."
As a result it is possible to build PTP-capable Ethernet drivers without
the PTP subsystem by deselecting PTP_1588_CLOCK. Drivers are required to
handle the missing dependency gracefully.

Some PTP-capable Ethernet drivers (e.g., TI_CPSW) factor their PTP code
out into separate drivers (e.g., TI_CPTS_MOD). The above commit also
changed these PTP-specific drivers to `imply PTP_1588_CLOCK`, making it
possible to build them without the PTP subsystem. But as Grygorii
Strashko noted in [1]:

On Wed, Apr 22, 2020 at 02:16:11PM +0300, Grygorii Strashko wrote:

> Another question is that CPTS completely nonfunctional in this case and
> it was never expected that somebody will even try to use/run such
> configuration (except for random build purposes).

In my view, enabling a PTP-specific driver without the PTP subsystem is
a configuration error made possible by the above commit. Kconfig should
not allow users to create a configuration with missing dependencies that
results in "completely nonfunctional" drivers.

I audited all network drivers that call ptp_clock_register() and found
six that look like PTP-specific drivers that are likely nonfunctional
without PTP_1588_CLOCK:

    NET_DSA_MV88E6XXX_PTP
    NET_DSA_SJA1105_PTP
    MACB_USE_HWSTAMP
    CAVIUM_PTP
    TI_CPTS_MOD
    PTP_1588_CLOCK_IXP46X

Note how they all reference PTP or timestamping in their name; this is a
clue that they depend on PTP_1588_CLOCK.

Change these drivers back [2] to `select PTP_1588_CLOCK`. Note that this
requires also selecting POSIX_TIMERS, a transitive dependency of
PTP_1588_CLOCK.

[1]: https://lkml.org/lkml/2020/4/22/1056

[2]: NET_DSA_SJA1105_PTP had never declared any type of dependency on
PTP_1588_CLOCK (`imply` or otherwise); adding it here seems appropriate.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Fixes: d1cbfd771ce8 ("ptp_clock: Allow for it to be optional")
Signed-off-by: Clay McClure <clay@daemons.net>
---
 drivers/net/dsa/mv88e6xxx/Kconfig    | 3 ++-
 drivers/net/dsa/sja1105/Kconfig      | 2 ++
 drivers/net/ethernet/cadence/Kconfig | 3 ++-
 drivers/net/ethernet/cavium/Kconfig  | 3 ++-
 drivers/net/ethernet/ti/Kconfig      | 2 +-
 drivers/net/ethernet/xscale/Kconfig  | 3 ++-
 6 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/Kconfig b/drivers/net/dsa/mv88e6xxx/Kconfig
index 6435020d690d..6e8250599eb1 100644
--- a/drivers/net/dsa/mv88e6xxx/Kconfig
+++ b/drivers/net/dsa/mv88e6xxx/Kconfig
@@ -25,7 +25,8 @@ config NET_DSA_MV88E6XXX_PTP
 	default n
 	depends on NET_DSA_MV88E6XXX_GLOBAL2
 	imply NETWORK_PHY_TIMESTAMPING
-	imply PTP_1588_CLOCK
+	select PTP_1588_CLOCK
+	select POSIX_TIMERS
 	help
 	  Say Y to enable PTP hardware timestamping on Marvell 88E6xxx switch
 	  chips that support it.
diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
index 0fe1ae173aa1..84349b6c8c44 100644
--- a/drivers/net/dsa/sja1105/Kconfig
+++ b/drivers/net/dsa/sja1105/Kconfig
@@ -20,6 +20,8 @@ tristate "NXP SJA1105 Ethernet switch family support"
 config NET_DSA_SJA1105_PTP
 	bool "Support for the PTP clock on the NXP SJA1105 Ethernet switch"
 	depends on NET_DSA_SJA1105
+	select PTP_1588_CLOCK
+	select POSIX_TIMERS
 	help
 	  This enables support for timestamping and PTP clock manipulations in
 	  the SJA1105 DSA driver.
diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
index 53b50c24d9c9..bc792c334903 100644
--- a/drivers/net/ethernet/cadence/Kconfig
+++ b/drivers/net/ethernet/cadence/Kconfig
@@ -36,7 +36,8 @@ config MACB_USE_HWSTAMP
 	bool "Use IEEE 1588 hwstamp"
 	depends on MACB
 	default y
-	imply PTP_1588_CLOCK
+	select PTP_1588_CLOCK
+	select POSIX_TIMERS
 	---help---
 	  Enable IEEE 1588 Precision Time Protocol (PTP) support for MACB.
 
diff --git a/drivers/net/ethernet/cavium/Kconfig b/drivers/net/ethernet/cavium/Kconfig
index 6a700d34019e..bae58c488792 100644
--- a/drivers/net/ethernet/cavium/Kconfig
+++ b/drivers/net/ethernet/cavium/Kconfig
@@ -54,7 +54,8 @@ config	THUNDER_NIC_RGX
 config CAVIUM_PTP
 	tristate "Cavium PTP coprocessor as PTP clock"
 	depends on 64BIT && PCI
-	imply PTP_1588_CLOCK
+	select PTP_1588_CLOCK
+	select POSIX_TIMERS
 	---help---
 	  This driver adds support for the Precision Time Protocol Clocks and
 	  Timestamping coprocessor (PTP) found on Cavium processors.
diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index 89cec778cf2d..1177953790c5 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -92,7 +92,7 @@ config TI_CPTS_MOD
 	depends on TI_CPTS
 	default y if TI_CPSW=y || TI_KEYSTONE_NETCP=y || TI_CPSW_SWITCHDEV=y
 	select NET_PTP_CLASSIFY
-	imply PTP_1588_CLOCK
+	select PTP_1588_CLOCK
 	default m
 
 config TI_K3_AM65_CPSW_NUSS
diff --git a/drivers/net/ethernet/xscale/Kconfig b/drivers/net/ethernet/xscale/Kconfig
index 98aa7b8ddb06..82d4ec3c6398 100644
--- a/drivers/net/ethernet/xscale/Kconfig
+++ b/drivers/net/ethernet/xscale/Kconfig
@@ -30,7 +30,8 @@ config IXP4XX_ETH
 config PTP_1588_CLOCK_IXP46X
 	tristate "Intel IXP46x as PTP clock"
 	depends on IXP4XX_ETH
-	depends on PTP_1588_CLOCK
+	select PTP_1588_CLOCK
+	select POSIX_TIMERS
 	default y
 	help
 	  This driver adds support for using the IXP46X as a PTP
-- 
2.20.1

