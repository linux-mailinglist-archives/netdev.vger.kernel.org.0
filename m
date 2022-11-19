Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2380D6311BB
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbiKSXGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235116AbiKSXG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:06:27 -0500
Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB321A07B;
        Sat, 19 Nov 2022 15:06:25 -0800 (PST)
Date:   Sat, 19 Nov 2022 23:06:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail3; t=1668899184; x=1669158384;
        bh=aAU7Nf2uHGDsr5PzJ0A6nAFZICy8pn9hVi79vE0ftbI=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=b6avCPJr+q/icECeZWKkziIPgEI2mvFKP4d8mR7bPYlphqYYONYBUxnWKpHcTX+ON
         v7O/4bjbo6hISfOzqY9xstmLWjblx3TWlh2tguanWBNcu5wjzGaXJlLl5A9+uvM1OC
         IUUwa6yWf4SEiYPxlQLWEcRof6N4AoZNAlu+dPSgj40ioeLIM2GFm1Uo7J5p0oii7m
         aPNSRGweRg3o+SBTTPf7w28WX8jqcW08QAZqYQD6Fr5BMN4z/djBnYlPUCPMDrVWcO
         40FVIf3lylmBnVDl2Vj3EkqDAlhpDqiK+do0ypeXcjsvDlo1R5O1bs0EArXQ6EnzPx
         M5Uq8fjD5WHAQ==
To:     linux-kbuild@vger.kernel.org
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/18] mfd: rsmu: turn rsmu-{core,i2c,spi} into single-object modules
Message-ID: <20221119225650.1044591-7-alobakin@pm.me>
In-Reply-To: <20221119225650.1044591-1-alobakin@pm.me>
References: <20221119225650.1044591-1-alobakin@pm.me>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

With the previous fix, these modules are built from a single C file.

Rename the source files so they match the module names.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-and-tested-by: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/mfd/Makefile                     | 3 ---
 drivers/mfd/{rsmu_core.c =3D> rsmu-core.c} | 0
 drivers/mfd/{rsmu_i2c.c =3D> rsmu-i2c.c}   | 0
 drivers/mfd/{rsmu_spi.c =3D> rsmu-spi.c}   | 0
 4 files changed, 3 deletions(-)
 rename drivers/mfd/{rsmu_core.c =3D> rsmu-core.c} (100%)
 rename drivers/mfd/{rsmu_i2c.c =3D> rsmu-i2c.c} (100%)
 rename drivers/mfd/{rsmu_spi.c =3D> rsmu-spi.c} (100%)

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index d40d6619bacd..cd436c50c5c0 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -276,9 +276,6 @@ obj-$(CONFIG_MFD_INTEL_M10_BMC)   +=3D intel-m10-bmc.o
 obj-$(CONFIG_MFD_ATC260X)=09+=3D atc260x-core.o
 obj-$(CONFIG_MFD_ATC260X_I2C)=09+=3D atc260x-i2c.o

-rsmu-core-objs=09=09=09:=3D rsmu_core.o
-rsmu-i2c-objs=09=09=09:=3D rsmu_i2c.o
-rsmu-spi-objs=09=09=09:=3D rsmu_spi.o
 obj-$(CONFIG_MFD_RSMU_CORE)=09+=3D rsmu-core.o
 obj-$(CONFIG_MFD_RSMU_I2C)=09+=3D rsmu-i2c.o
 obj-$(CONFIG_MFD_RSMU_SPI)=09+=3D rsmu-spi.o
diff --git a/drivers/mfd/rsmu_core.c b/drivers/mfd/rsmu-core.c
similarity index 100%
rename from drivers/mfd/rsmu_core.c
rename to drivers/mfd/rsmu-core.c
diff --git a/drivers/mfd/rsmu_i2c.c b/drivers/mfd/rsmu-i2c.c
similarity index 100%
rename from drivers/mfd/rsmu_i2c.c
rename to drivers/mfd/rsmu-i2c.c
diff --git a/drivers/mfd/rsmu_spi.c b/drivers/mfd/rsmu-spi.c
similarity index 100%
rename from drivers/mfd/rsmu_spi.c
rename to drivers/mfd/rsmu-spi.c
--
2.38.1


