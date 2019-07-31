Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8917CD5E
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 21:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbfGaT7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 15:59:00 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:45277 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfGaT67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 15:58:59 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1N1u2b-1iL0Pk2PAf-012FfM; Wed, 31 Jul 2019 21:58:21 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     soc@kernel.org, linux-arm-kernel@lists.infradead.org,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/14] usb: udc: lpc32xx: allow compile-testing
Date:   Wed, 31 Jul 2019 21:56:44 +0200
Message-Id: <20190731195713.3150463-3-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190731195713.3150463-1-arnd@arndb.de>
References: <20190731195713.3150463-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:owqhEQqZQOrw+U7JIsdudcOU30aZRR/RpfOBJiDYVq8lo61ITu6
 OTJHhNMtclaN1XkeL+A2wFbBwyqNYCidX1WsSXk3+KA/6veguARtCTAz1ZYlhjxOmuApKns
 AuZqlZnGwsNqxk5F3v4MWhYGZB7bO18wtIZMCv99c9HjUdYOkCKOZGk9CoJxCPqMFHPItHh
 renz7Xxq+4kx8oJTEj0rA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Eh8z57l/pNI=:mdadUktRLMFk1jL652Ne7P
 zFXuP4XrT3hRm8cGQ1BHQgD8pF33SdZrY2CeyvfCTaJL3XiMrWJlhYVR9/OPlDkIHqDaLQf05
 YSL6GiZFkj/XCDvN06vXcqVRCng/jk83sJH3teo1qmVc0vrX9/pUnEIvkcXPERea0ha3RFktU
 UXb17rrjEwJs6NR9YDO3zMVFN6WZUE6Yo5UbLZ3qBCvu1yCt5hhjyPSDahn8s4TtOGm9KlGwG
 wlrAaenzh59sLnunl4zylxv8iV/B0MiIbQ5dj01i02AIT16MbNf1YsMQkhry0/AlaIiNQUxZA
 EehYeeC7x2JEIwuvzAB3KSbmKSnraGIelW2iIXDvqU+yObF3KJa0xH/z6CXbo8SN10kL31zZ7
 WUMoKPzLtgIpVrPtErO5npwMdgV1FM8rHxmFbF7Qa/v2h8l/gwi6hGSQXzgnTEt/GQ0yMyycC
 /odZo/ga1mREGA/9yc8PcSanC4lE8ERC/kepk7fFsc0kOpzh9v5NBE0Qcw1u51XNGbNomOUAl
 pjdXdQFD2yHEFm83pb9MAfq1ms9NrQouZnUVDXhB/oCpuktZrQwAzH2OoaKx5btmN8OSqmpV+
 XALoHKf2pQ8OLObelggBk1g7puywQFXIHlO+yPoYaPI1KdqIy+1g1kDW2Uan5E/Lf5Z9dKB+h
 m+Y1f8dt6M2err8NjDHsx6rDyCKDMCN3Sz4QOl3JV9qVnrkQNdmjE1szvgBdAD/rFtX2m4p3o
 3tNgu7MGtzFonhmt/Qe34m648mNxk6UJQabXqA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only thing that prevents building this driver on other
platforms is the mach/hardware.h include, which is not actually
used here at all, so remove the line and allow CONFIG_COMPILE_TEST.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/usb/gadget/udc/Kconfig       | 3 ++-
 drivers/usb/gadget/udc/lpc32xx_udc.c | 2 --
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/udc/Kconfig b/drivers/usb/gadget/udc/Kconfig
index ef0259a950ba..d354036ff6c8 100644
--- a/drivers/usb/gadget/udc/Kconfig
+++ b/drivers/usb/gadget/udc/Kconfig
@@ -45,7 +45,8 @@ config USB_AT91
 
 config USB_LPC32XX
 	tristate "LPC32XX USB Peripheral Controller"
-	depends on ARCH_LPC32XX && I2C
+	depends on ARCH_LPC32XX || COMPILE_TEST
+	depends on I2C
 	select USB_ISP1301
 	help
 	   This option selects the USB device controller in the LPC32xx SoC.
diff --git a/drivers/usb/gadget/udc/lpc32xx_udc.c b/drivers/usb/gadget/udc/lpc32xx_udc.c
index 5f1b14f3e5a0..4d8847988a50 100644
--- a/drivers/usb/gadget/udc/lpc32xx_udc.c
+++ b/drivers/usb/gadget/udc/lpc32xx_udc.c
@@ -35,8 +35,6 @@
 #include <linux/seq_file.h>
 #endif
 
-#include <mach/hardware.h>
-
 /*
  * USB device configuration structure
  */
-- 
2.20.0

