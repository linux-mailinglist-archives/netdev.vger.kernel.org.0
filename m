Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0607C1BD6BC
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 10:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgD2IAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 04:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726457AbgD2IAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 04:00:34 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AA6C03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 01:00:33 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id f7so712585pfa.9
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 01:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daemons-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ws5RoUs9BriDfSRkNG63+mR2vT5tvodj3Q9+M/gLZPE=;
        b=qSVAH55OAgDQsOQRCHZPWMz7fCVAjTpWBjYMm7LXCQTnMOyZ7Elx+iKUddqvqYhE1P
         5lSnX2vvXhjb5t1uKWKpuLCXLC0Kq7hM7gQMlurrUmJpYJWK9vRicI8sgsa5LpB1ZnYc
         w9ExbnqozKqsAhWbrZrBPQ3Lq613RtugMgi7PsciMGvEbqK7COPy6cJr88Gba9HyS8Ro
         ot89vTYW0jh2ceXk9VYqTOomvnVgZXATVX0ijnXrEraTaQBjgBb7nFpuSXSDnV30ripJ
         DJBLmAjW3CScH64lkaTG+zDfx8rZxhqf+86t1sbOrCj2EmF6gKk0llrPrB2W6cQ2t+5/
         ncWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ws5RoUs9BriDfSRkNG63+mR2vT5tvodj3Q9+M/gLZPE=;
        b=Z6oNUMMgOajn/mumoIPhs7hkdPo3sDu0W6rBYZ4QCZ7CTHfcNg9syQlgsQjXKv6KzM
         xEO0HHHHxJxbEwUhVKITjMi5jqvHFj8p6MVUTqYHjMZImWb/tJiZICY+7l7eAtPpRoSy
         FHD0fbcsNUD5+NG5wDmVRBWhNiO+ZMYlO/re38tvelzC0a4xxHUxctpkvghVX4UJFFAX
         iKs4pyfBLEo8ymg4h/TZkDiEhW/leX9V2bfmI7yPD68fbg+C/M++Ap6JSv3v4k2Tkuow
         Wl9A7KVgtyaf4mpVFLVfbdM8I1kDQ47oT6APX5O9VzLtgFgtARmkAr1y9Airq0KXVVyD
         HRGA==
X-Gm-Message-State: AGi0PuadZE3uha5hjIZZQX3cJrjqOUSc3rKselq8jL03KcP8zKw5RDZF
        ikvAz/1T/D2pAKHNz5gQp+Kb
X-Google-Smtp-Source: APiQypLJqpMAR4GU8Qdqt8+I9LRgFDuTqS0ubKbugPWxkmIZhA0qw3JVE9AjraFvZWusHh33uaY4+A==
X-Received: by 2002:a62:ed14:: with SMTP id u20mr34503722pfh.69.1588147232557;
        Wed, 29 Apr 2020 01:00:32 -0700 (PDT)
Received: from localhost.localdomain ([47.156.151.166])
        by smtp.googlemail.com with ESMTPSA id b3sm429253pga.48.2020.04.29.01.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 01:00:31 -0700 (PDT)
From:   Clay McClure <clay@daemons.net>
Cc:     Clay McClure <clay@daemons.net>, Arnd Bergmann <arnd@arndb.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
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
        Kishon Vijay Abraham I <kishon@ti.com>,
        Mao Wenan <maowenan@huawei.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Edward Cree <ecree@solarflare.com>,
        Josh Triplett <josh@joshtriplett.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: Make PTP-specific drivers depend on PTP_1588_CLOCK
Date:   Wed, 29 Apr 2020 00:59:00 -0700
Message-Id: <20200429075903.19788-1-clay@daemons.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200429072959.GA10194@arctic-shiba-lx>
References: <20200429072959.GA10194@arctic-shiba-lx>
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

I audited all network drivers that call ptp_clock_register() but merely
`imply PTP_1588_CLOCK` and found five PTP-specific drivers that are
likely nonfunctional without PTP_1588_CLOCK:

    NET_DSA_MV88E6XXX_PTP
    NET_DSA_SJA1105_PTP
    MACB_USE_HWSTAMP
    CAVIUM_PTP
    TI_CPTS_MOD

Note how these symbols all reference PTP or timestamping in their name;
this is a clue that they depend on PTP_1588_CLOCK.

Change them from `imply PTP_1588_CLOCK` [2] to `depends on PTP_1588_CLOCK`.
I'm not using `select PTP_1588_CLOCK` here because PTP_1588_CLOCK has
its own dependencies, which `select` would not transitively apply.

Additionally, remove the `select NET_PTP_CLASSIFY` from CPTS_TI_MOD;
PTP_1588_CLOCK already selects that.

[1]: https://lore.kernel.org/lkml/c04458ed-29ee-1797-3a11-7f3f560553e6@ti.com/

[2]: NET_DSA_SJA1105_PTP had never declared any type of dependency on
PTP_1588_CLOCK (`imply` or otherwise); adding a `depends on PTP_1588_CLOCK`
here seems appropriate.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Fixes: d1cbfd771ce8 ("ptp_clock: Allow for it to be optional")
Signed-off-by: Clay McClure <clay@daemons.net>
---
 drivers/net/dsa/mv88e6xxx/Kconfig    | 2 +-
 drivers/net/dsa/sja1105/Kconfig      | 1 +
 drivers/net/ethernet/cadence/Kconfig | 2 +-
 drivers/net/ethernet/cavium/Kconfig  | 2 +-
 drivers/net/ethernet/ti/Kconfig      | 3 +--
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/Kconfig b/drivers/net/dsa/mv88e6xxx/Kconfig
index 6435020d690d..51185e4d7d15 100644
--- a/drivers/net/dsa/mv88e6xxx/Kconfig
+++ b/drivers/net/dsa/mv88e6xxx/Kconfig
@@ -24,8 +24,8 @@ config NET_DSA_MV88E6XXX_PTP
 	bool "PTP support for Marvell 88E6xxx"
 	default n
 	depends on NET_DSA_MV88E6XXX_GLOBAL2
+	depends on PTP_1588_CLOCK
 	imply NETWORK_PHY_TIMESTAMPING
-	imply PTP_1588_CLOCK
 	help
 	  Say Y to enable PTP hardware timestamping on Marvell 88E6xxx switch
 	  chips that support it.
diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
index 0fe1ae173aa1..68c3086af9af 100644
--- a/drivers/net/dsa/sja1105/Kconfig
+++ b/drivers/net/dsa/sja1105/Kconfig
@@ -20,6 +20,7 @@ tristate "NXP SJA1105 Ethernet switch family support"
 config NET_DSA_SJA1105_PTP
 	bool "Support for the PTP clock on the NXP SJA1105 Ethernet switch"
 	depends on NET_DSA_SJA1105
+	depends on PTP_1588_CLOCK
 	help
 	  This enables support for timestamping and PTP clock manipulations in
 	  the SJA1105 DSA driver.
diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
index 53b50c24d9c9..2c4c12b03502 100644
--- a/drivers/net/ethernet/cadence/Kconfig
+++ b/drivers/net/ethernet/cadence/Kconfig
@@ -35,8 +35,8 @@ config MACB
 config MACB_USE_HWSTAMP
 	bool "Use IEEE 1588 hwstamp"
 	depends on MACB
+	depends on PTP_1588_CLOCK
 	default y
-	imply PTP_1588_CLOCK
 	---help---
 	  Enable IEEE 1588 Precision Time Protocol (PTP) support for MACB.
 
diff --git a/drivers/net/ethernet/cavium/Kconfig b/drivers/net/ethernet/cavium/Kconfig
index 6a700d34019e..4520e7ee00fe 100644
--- a/drivers/net/ethernet/cavium/Kconfig
+++ b/drivers/net/ethernet/cavium/Kconfig
@@ -54,7 +54,7 @@ config	THUNDER_NIC_RGX
 config CAVIUM_PTP
 	tristate "Cavium PTP coprocessor as PTP clock"
 	depends on 64BIT && PCI
-	imply PTP_1588_CLOCK
+	depends on PTP_1588_CLOCK
 	---help---
 	  This driver adds support for the Precision Time Protocol Clocks and
 	  Timestamping coprocessor (PTP) found on Cavium processors.
diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index 89cec778cf2d..8e348780efb6 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -90,9 +90,8 @@ config TI_CPTS
 config TI_CPTS_MOD
 	tristate
 	depends on TI_CPTS
+	depends on PTP_1588_CLOCK
 	default y if TI_CPSW=y || TI_KEYSTONE_NETCP=y || TI_CPSW_SWITCHDEV=y
-	select NET_PTP_CLASSIFY
-	imply PTP_1588_CLOCK
 	default m
 
 config TI_K3_AM65_CPSW_NUSS
-- 
2.20.1

