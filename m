Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04714E82E9
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 18:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234362AbiCZRK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 13:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbiCZRKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 13:10:33 -0400
Received: from stuerz.xyz (stuerz.xyz [IPv6:2001:19f0:5:15da:5400:3ff:fecc:7379])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAF634BA0;
        Sat, 26 Mar 2022 10:08:33 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 9D973FBBC6; Sat, 26 Mar 2022 17:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314024; bh=gqt1+kI42FGInscQtbmdIv8LY19kdHpeRO5nUSHeT20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yTXX8Igb67dmxs2rI659X8bFPAsNUwM4FYdfBfqYco2pov/ruj2kzZjHBlDxNkm4O
         YrS0PiktRz+Kr7/aFJY64IZPdRchAc2MJNAASFeANAOToGtmTs60gRB0CWYatC4Yz3
         1ZJDCGLTP8XgRa8IefeCRaT1qjpCVz5BAAoKiFJF7ShxdKbQMTIX0RodhnN2J11VGs
         k+N760Wph8Ptz1J0J5ixbFLngT+HQI2/cTFotHxVMERaU8M2LJcQTJ7SxTbMfx5rcP
         YZNQ2bgzHE4XMRQDQRyA9OuyThOohBO9PlEEpixa0+Wbjl+hLiIIhKEEvfsw9ED24f
         glh+IX8phWjZw==
Received: from benni-fedora.. (unknown [IPv6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8])
        by stuerz.xyz (Postfix) with ESMTPSA id A8729FB7D3;
        Sat, 26 Mar 2022 17:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314020; bh=gqt1+kI42FGInscQtbmdIv8LY19kdHpeRO5nUSHeT20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cAGmc7q/v70fp/d8OErxnqAUtLx7NZZMJRTXOS0xd3wx/9j3/80aOVZpisTnSXgpD
         prCgpdgT77LpFvxgJNlKEBWLSBjZ4kxEnRiiQ8dYJXZz/rVa+mwrDqlAxyVCXFhHlW
         pIK2SHvu+HJwUEPSNGCBAg9W2pTt/tLFKw/zKUqmtezySp/jWWzvO2dxfFwiuWRJ/2
         xpQDsn76lN3Gog+YDVovDRsTD/FUOFZK+XpCqNI1kFh28CwW7J2ObwhgE7g2W94Ieh
         euilI5YMx4HWkP8cW5lsUQrviC9YxhnjqgNxitvFz2aa9gpm6UrKMQ8V/jtHu5kgQn
         iXGM/MCmHVf9Q==
From:   =?UTF-8?q?Benjamin=20St=C3=BCrz?= <benni@stuerz.xyz>
To:     andrew@lunn.ch
Cc:     sebastian.hesselbarth@gmail.com, gregory.clement@bootlin.com,
        linux@armlinux.org.uk, linux@simtec.co.uk, krzk@kernel.org,
        alim.akhtar@samsung.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        robert.moore@intel.com, rafael.j.wysocki@intel.com,
        lenb@kernel.org, 3chas3@gmail.com, laforge@gnumonks.org,
        arnd@arndb.de, gregkh@linuxfoundation.org, mchehab@kernel.org,
        tony.luck@intel.com, james.morse@arm.com, rric@kernel.org,
        linus.walleij@linaro.org, brgl@bgdev.pl,
        mike.marciniszyn@cornelisnetworks.com,
        dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca,
        pali@kernel.org, dmitry.torokhov@gmail.com, isdn@linux-pingi.de,
        benh@kernel.crashing.org, fbarrat@linux.ibm.com, ajd@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        nico@fluxnic.net, loic.poulain@linaro.org, kvalo@kernel.org,
        pkshih@realtek.com, bhelgaas@google.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-input@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-pci@vger.kernel.org,
        =?UTF-8?q?Benjamin=20St=C3=BCrz?= <benni@stuerz.xyz>
Subject: [PATCH 09/22] gpio-winbond: Use C99 initializers
Date:   Sat, 26 Mar 2022 17:58:56 +0100
Message-Id: <20220326165909.506926-9-benni@stuerz.xyz>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220326165909.506926-1-benni@stuerz.xyz>
References: <20220326165909.506926-1-benni@stuerz.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This replaces comments with C99's designated
initializers because the kernel supports them now.

Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
---
 drivers/gpio/gpio-winbond.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-winbond.c b/drivers/gpio/gpio-winbond.c
index 7f8f5b02e31d..0b637fdb407c 100644
--- a/drivers/gpio/gpio-winbond.c
+++ b/drivers/gpio/gpio-winbond.c
@@ -249,7 +249,7 @@ struct winbond_gpio_info {
 };
 
 static const struct winbond_gpio_info winbond_gpio_infos[6] = {
-	{ /* 0 */
+	[0] = {
 		.dev = WB_SIO_DEV_GPIO12,
 		.enablereg = WB_SIO_GPIO12_REG_ENABLE,
 		.enablebit = WB_SIO_GPIO12_ENABLE_1,
@@ -266,7 +266,7 @@ static const struct winbond_gpio_info winbond_gpio_infos[6] = {
 			.warnonly = true
 		}
 	},
-	{ /* 1 */
+	[1] = {
 		.dev = WB_SIO_DEV_GPIO12,
 		.enablereg = WB_SIO_GPIO12_REG_ENABLE,
 		.enablebit = WB_SIO_GPIO12_ENABLE_2,
@@ -277,7 +277,7 @@ static const struct winbond_gpio_info winbond_gpio_infos[6] = {
 		.datareg = WB_SIO_GPIO12_REG_DATA2
 		/* special conflict handling so doesn't use conflict data */
 	},
-	{ /* 2 */
+	[2] = {
 		.dev = WB_SIO_DEV_GPIO34,
 		.enablereg = WB_SIO_GPIO34_REG_ENABLE,
 		.enablebit = WB_SIO_GPIO34_ENABLE_3,
@@ -294,7 +294,7 @@ static const struct winbond_gpio_info winbond_gpio_infos[6] = {
 			.warnonly = true
 		}
 	},
-	{ /* 3 */
+	[3] = {
 		.dev = WB_SIO_DEV_GPIO34,
 		.enablereg = WB_SIO_GPIO34_REG_ENABLE,
 		.enablebit = WB_SIO_GPIO34_ENABLE_4,
@@ -311,7 +311,7 @@ static const struct winbond_gpio_info winbond_gpio_infos[6] = {
 			.warnonly = true
 		}
 	},
-	{ /* 4 */
+	[4] = {
 		.dev = WB_SIO_DEV_WDGPIO56,
 		.enablereg = WB_SIO_WDGPIO56_REG_ENABLE,
 		.enablebit = WB_SIO_WDGPIO56_ENABLE_5,
@@ -328,7 +328,7 @@ static const struct winbond_gpio_info winbond_gpio_infos[6] = {
 			.warnonly = true
 		}
 	},
-	{ /* 5 */
+	[5] = {
 		.dev = WB_SIO_DEV_WDGPIO56,
 		.enablereg = WB_SIO_WDGPIO56_REG_ENABLE,
 		.enablebit = WB_SIO_WDGPIO56_ENABLE_6,
-- 
2.35.1

