Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B2068DC38
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 15:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbjBGOzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 09:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbjBGOzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 09:55:39 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E04FF1F
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 06:55:36 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id x8so10497069ybt.13
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 06:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kpS3HgKPmEogc2Gw9AlFJQlCzGdEEgzV3gaAp0/AV2s=;
        b=waPM8nbRluE35gGhrnOOlYCVoqMbSzXI/bIeppE9bSuFFI+RZAzc6Kl5AasZ9otGI4
         OBcaMb89VmJlQA1BqQM9ko3ab0J+4Uob3evLCOBCdMRAvfPWqBlGowOBUJ6rCj1/Vw5l
         XsdeMKH6QAcOLrAjl8BW/dfg2o5OtyicTpibLycC02L1REZwkd+Y7rbkJkOqOlSQv3La
         cTVllcV5wizPEPJZkmwzpovhOVse1MS8EUFEA5YXboPA/Yu4/bznLdms8azWGLg7n+wf
         jmU54a3NqzhTvcksWe8Tw1hVTpGGhzzkCQdkP6PiJjo5P+u9SwIiWyDKskkWkkK6MrhL
         sNOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kpS3HgKPmEogc2Gw9AlFJQlCzGdEEgzV3gaAp0/AV2s=;
        b=zFhuZ0fvexu842vOpSUUasxhvUIKdkG/6bx5ui3hg0hjLDUpD5zjtC3g4ej1eBTaE+
         GvfQhMiwjkT75BZmgylMyxEcC2+50atKKqbb8BDRaWAFzH4DycHnG1VhXajjSW9bueQD
         KwtINrx93eRWqMHGDqrzOUSc3sgmc/I6jNHlAHjMPUHihJjnB5G2c0XL7OaQXhSy0DYw
         U8gPAfKldbEShw0gIpXEdQRqxKD8FmBETpJBx/1iNxKdKuJLkj7gWMdt50XDJjuhhZEU
         xJ6Vrb1SWOi+Zqt23R2QE9NHuNhMtrfMk+A1DkuWaAFNvKq+ePX+zq3iTD3YFESrJ5c3
         dpJg==
X-Gm-Message-State: AO0yUKXv0bzgQuHAQiJBcOmi3dBHnhlUwxnPtig6iFMUznuIQr7+ykbb
        CpoYN4W+tX5Ge1kicuzLkngouyTkTn2j5ZxBxfEbsA==
X-Google-Smtp-Source: AK7set+FPiZG8Q0bqmAM+3oI4VA9/UkIXmLGvn2kwzKpYMs61nqxRIkPG0TtYZXh9iAdflkTtIBPO8Shde99ziPoa9c=
X-Received: by 2002:a5b:150:0:b0:88f:92ec:4292 with SMTP id
 c16-20020a5b0150000000b0088f92ec4292mr401234ybp.460.1675781735294; Tue, 07
 Feb 2023 06:55:35 -0800 (PST)
MIME-Version: 1.0
References: <20230207142952.51844-1-andriy.shevchenko@linux.intel.com> <20230207142952.51844-7-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20230207142952.51844-7-andriy.shevchenko@linux.intel.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 7 Feb 2023 15:55:23 +0100
Message-ID: <CACRpkdaPgjDijPjCdinWy5_Rd8g3idv-8K=YPTv5iTfJKFuJfw@mail.gmail.com>
Subject: Re: [PATCH v3 06/12] gpiolib: split linux/gpio/driver.h out of linux/gpio.h
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Devarsh Thakkar <devarsht@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-gpio@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, linux-arch@vger.kernel.org,
        devicetree@vger.kernel.org, Bartosz Golaszewski <brgl@bgdev.pl>,
        Jonathan Corbet <corbet@lwn.net>, Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Russell King <linux@armlinux.org.uk>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Keerthy <j-keerthy@ti.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>, Qiang Zhao <qiang.zhao@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 7, 2023 at 3:29 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
>
> Almost all gpio drivers include linux/gpio/driver.h, and other
> files should not rely on includes from this header.
>
> Remove the indirect include from here and include the correct
> headers directly from where they are used.
>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Make sure you push this to the kernel.org build servers (zeroday builds),
I think this patch needs to hit some more files, in my tests with a similar
patch at least these:

diff --git a/drivers/hte/hte-tegra194-test.c b/drivers/hte/hte-tegra194-test.c
index 5d776a185bd6..79eb866558d3 100644
--- a/drivers/hte/hte-tegra194-test.c
+++ b/drivers/hte/hte-tegra194-test.c
@@ -6,10 +6,11 @@
  */

 #include <linux/err.h>
+#include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/interrupt.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/timer.h>
 #include <linux/platform_device.h>
 #include <linux/workqueue.h>


diff --git a/arch/arm/mach-pxa/viper-pcmcia.c b/arch/arm/mach-pxa/viper-pcmcia.c
index 26599dcc49b3..2c7af4ed57d5 100644
--- a/arch/arm/mach-pxa/viper-pcmcia.c
+++ b/arch/arm/mach-pxa/viper-pcmcia.c
@@ -19,6 +19,7 @@
 #include <linux/errno.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/mod_devicetable.h>
 #include <linux/gpio.h>

 #include <pcmcia/ss.h>

Yours,
Linus Walleij
