Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4470F6BFCCA
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 21:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCRUgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 16:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjCRUgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 16:36:23 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD6E2DE7E
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 13:36:21 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id r11so32928662edd.5
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 13:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679171780;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1EXyUx3O/mJauX2CeNQtRk4By/x4ywiu2x2jMlmuXS0=;
        b=RqPIRC9fZpFehakpAa+nJTdDpTUyUE04J2HP9PqDFs3UtpJUlN+8NEoggjLf4MyG3u
         uBsorCPdoAX8Rhw+wXwgLGrDJFk3ck3qcWaEu62/dpJaYsyhZhlD463PQva2orptBIsj
         HhjWHV1myqn8rcn4z9kVr5X8gjx3GES7+HOUoIw/MOXs8CPE509jWGDw36M0U1wBsML2
         rwMZsF58i5jcN+ISerFYdHm97+h/y98qlY/Foc4rotmbBPQSYjVOfviK956z5LF9SEMV
         jbqlv3AI0I78IHRHx+EgZCk9srrWUjONIwjqMehmyQmjjVyU6xCbk2tjA7qoTJ6odCxI
         VNcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679171780;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1EXyUx3O/mJauX2CeNQtRk4By/x4ywiu2x2jMlmuXS0=;
        b=I/A2XWfwLJpQgtpwHWdbJiRK2omO2IhUwgtw03xv2YaqqDZeFVeyZLZ8aXbcogCgt5
         sXhjkRBSyXSMUmFAo/db9SR852eEOTcteQhYCKmOtPt/ZRMFslVs6YEkbxElTQSaNART
         f5WgTS3oLwXEwdhNR8rvMYOHM1xPRRrrNj5INDFvoTQFcy0bkEUoMfL+LIdfBWMa9fjv
         mJ9/vHH+qOWDwW/14ZWzuJh7cxH2rAGx1FeMJXbYh039MbYH9rF7kxwEOrmekp6ZyNhY
         rGL93OmliUfq1Um1sE2Xk2a33sN8oyAjTApk1atB0kj50Tr/KYpEuZ9gsdzEsXTdzC1y
         bOgw==
X-Gm-Message-State: AO0yUKVrGaRBgYJ/eUCLuml8/AcXcbZLqUOTn2D7NYRJ3mikgj0P4XJb
        45ChlGzYS8aC9wmAhEAsUK4=
X-Google-Smtp-Source: AK7set/wc1fF6WT1/yz3GlCUPi7tnp0KUmP/cCIpzaDUrc8wqDUh20cnWWEuIEw7DBmiI0q6Do3gew==
X-Received: by 2002:a17:906:24c8:b0:861:7a02:1046 with SMTP id f8-20020a17090624c800b008617a021046mr3467116ejb.37.1679171779836;
        Sat, 18 Mar 2023 13:36:19 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c073:a00:b51a:ddab:12c0:b88a? (dynamic-2a01-0c23-c073-0a00-b51a-ddab-12c0-b88a.c23.pool.telefonica.de. [2a01:c23:c073:a00:b51a:ddab:12c0:b88a])
        by smtp.googlemail.com with ESMTPSA id j10-20020a170906094a00b008cafeec917dsm2517411ejd.101.2023.03.18.13.36.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Mar 2023 13:36:19 -0700 (PDT)
Message-ID: <f5261d9d-773b-63a1-e81a-988769d901ee@gmail.com>
Date:   Sat, 18 Mar 2023 21:36:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: [PATCH net-next 2/2] net: phy: meson-gxl: reuse functionality of the
 SMSC PHY driver
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Chris Healy <cphealy@gmail.com>
References: <683422c6-c1e1-90b9-59ed-75d0f264f354@gmail.com>
In-Reply-To: <683422c6-c1e1-90b9-59ed-75d0f264f354@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Amlogic Meson internal PHY's have the same register layout as
certain SMSC PHY's (also for non-c22-standard registers). This seems
to be more than just coincidence. Apparently they also need the same
workaround for EDPD mode (energy detect power down). Therefore let's
reuse SMSC PHY driver functionality in the meson-gxl PHY driver.

Tested with a G12A internal PHY. I don't have GXL test hw,
therefore I replace only the callbacks that are identical in
the SMSC PHY driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/Kconfig     |  1 +
 drivers/net/phy/meson-gxl.c | 77 ++++---------------------------------
 2 files changed, 9 insertions(+), 69 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 54874555c..6b9525def 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -70,6 +70,7 @@ config AMD_PHY
 config MESON_GXL_PHY
 	tristate "Amlogic Meson GXL Internal PHY"
 	depends on ARCH_MESON || COMPILE_TEST
+	select SMSC_PHY
 	help
 	  Currently has a driver for the Amlogic Meson GXL Internal PHY
 
diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index a6015cd03..3dea7c752 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -13,6 +13,7 @@
 #include <linux/phy.h>
 #include <linux/netdevice.h>
 #include <linux/bitfield.h>
+#include <linux/smscphy.h>
 
 #define TSTCNTL		20
 #define  TSTCNTL_READ		BIT(15)
@@ -23,18 +24,6 @@
 #define  TSTCNTL_WRITE_ADDRESS	GENMASK(4, 0)
 #define TSTREAD1	21
 #define TSTWRITE	23
-#define INTSRC_FLAG	29
-#define  INTSRC_ANEG_PR		BIT(1)
-#define  INTSRC_PARALLEL_FAULT	BIT(2)
-#define  INTSRC_ANEG_LP_ACK	BIT(3)
-#define  INTSRC_LINK_DOWN	BIT(4)
-#define  INTSRC_REMOTE_FAULT	BIT(5)
-#define  INTSRC_ANEG_COMPLETE	BIT(6)
-#define  INTSRC_ENERGY_DETECT	BIT(7)
-#define INTSRC_MASK	30
-
-#define INT_SOURCES (INTSRC_LINK_DOWN | INTSRC_ANEG_COMPLETE | \
-		     INTSRC_ENERGY_DETECT)
 
 #define BANK_ANALOG_DSP		0
 #define BANK_WOL		1
@@ -195,59 +184,6 @@ static int meson_gxl_read_status(struct phy_device *phydev)
 	return genphy_read_status(phydev);
 }
 
-static int meson_gxl_ack_interrupt(struct phy_device *phydev)
-{
-	int ret = phy_read(phydev, INTSRC_FLAG);
-
-	return ret < 0 ? ret : 0;
-}
-
-static int meson_gxl_config_intr(struct phy_device *phydev)
-{
-	int ret;
-
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
-		/* Ack any pending IRQ */
-		ret = meson_gxl_ack_interrupt(phydev);
-		if (ret)
-			return ret;
-
-		ret = phy_write(phydev, INTSRC_MASK, INT_SOURCES);
-	} else {
-		ret = phy_write(phydev, INTSRC_MASK, 0);
-
-		/* Ack any pending IRQ */
-		ret = meson_gxl_ack_interrupt(phydev);
-	}
-
-	return ret;
-}
-
-static irqreturn_t meson_gxl_handle_interrupt(struct phy_device *phydev)
-{
-	int irq_status;
-
-	irq_status = phy_read(phydev, INTSRC_FLAG);
-	if (irq_status < 0) {
-		phy_error(phydev);
-		return IRQ_NONE;
-	}
-
-	irq_status &= INT_SOURCES;
-
-	if (irq_status == 0)
-		return IRQ_NONE;
-
-	/* Aneg-complete interrupt is used for link-up detection */
-	if (phydev->autoneg == AUTONEG_ENABLE &&
-	    irq_status == INTSRC_ENERGY_DETECT)
-		return IRQ_HANDLED;
-
-	phy_trigger_machine(phydev);
-
-	return IRQ_HANDLED;
-}
-
 static struct phy_driver meson_gxl_phy[] = {
 	{
 		PHY_ID_MATCH_EXACT(0x01814400),
@@ -257,8 +193,8 @@ static struct phy_driver meson_gxl_phy[] = {
 		.soft_reset     = genphy_soft_reset,
 		.config_init	= meson_gxl_config_init,
 		.read_status	= meson_gxl_read_status,
-		.config_intr	= meson_gxl_config_intr,
-		.handle_interrupt = meson_gxl_handle_interrupt,
+		.config_intr	= smsc_phy_config_intr,
+		.handle_interrupt = smsc_phy_handle_interrupt,
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
 		.read_mmd	= genphy_read_mmd_unsupported,
@@ -268,9 +204,12 @@ static struct phy_driver meson_gxl_phy[] = {
 		.name		= "Meson G12A Internal PHY",
 		/* PHY_BASIC_FEATURES */
 		.flags		= PHY_IS_INTERNAL,
+		.probe		= smsc_phy_probe,
+		.config_init	= smsc_phy_config_init,
 		.soft_reset     = genphy_soft_reset,
-		.config_intr	= meson_gxl_config_intr,
-		.handle_interrupt = meson_gxl_handle_interrupt,
+		.read_status	= lan87xx_read_status,
+		.config_intr	= smsc_phy_config_intr,
+		.handle_interrupt = smsc_phy_handle_interrupt,
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
 		.read_mmd	= genphy_read_mmd_unsupported,
-- 
2.39.2


