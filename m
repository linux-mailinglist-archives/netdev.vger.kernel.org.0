Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2C02119138
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 20:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfLJT5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 14:57:17 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:59543 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfLJT5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 14:57:17 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1Ma1wY-1iHYLx10lQ-00VvBX; Tue, 10 Dec 2019 20:56:53 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Richard Cochran <richardcochran@gmail.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Yangbo Lu <yangbo.lu@nxp.com>,
        Antonio Borneo <antonio.borneo@st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        YueHaibing <yuehaibing@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ptp: clockmatrix: add I2C dependency
Date:   Tue, 10 Dec 2019 20:56:34 +0100
Message-Id: <20191210195648.811120-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:F4zdzK4avnZouVz7gJ/tCWTYGHWNnMwIjsDbazN3EHBrippnh5/
 lUJz/ddp+CP2nzgpMvIPRfYeRRE+wJmlgzTDuS/Jj/Tq9VHJALETTEsCNKK3V8DV1v27k9S
 /vc3Ux0rpKBUWTGD47QU72pkLQRXNRP1ULCcpzDFF4wDp+UYS47T6ZyEU4RHVMnhh26AFSP
 xNhKgI9liz6uMd8sSKbyA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:2+YG34Ahkjo=:6P3HL8aGD4qANpM1IX7CfY
 tU566mWrm6GxrPVqN1d7MK/2ZTp7O2DhGLAqPOYIRAYJxddTp4SuO7zXyG6IwPEzohpcgSfV7
 mR7/q6UXM8VDJQ3Lc5NdvtjevuQo3v90ygbYLG0SXWW7QnxSgSSGENmzkub6aOTRQLK9Wmw/Z
 npE9FzH27WPaHU93/xUf41wVdGOGccyBW36AyRtDtuu1KBE8dpGLEFCP+3ZzviUhYghngVjOG
 wEM2z11OMMxhvcUYKuqFy0BeyAgTJTNriVV4NznnQ4FTXjR5M6qmD96e5hog+NRwHaNB3acLc
 9oGN+l2nucRIC7G+Rr/E2AAd8UMQs+CiDvrN1bDgRPkLEUqzQSB+BJIXOWX53PmWAJTja8mB1
 wsP7VxZjjHOfS9XsNSk/o9VysWM5Who/seVXht+fovEB0en2USpo2n2R/T8D5c2gWaw4f4MWe
 TrsTS6qP9s134jbu0GLLTf9a7z87PfpstRvijkEeS647urGjN3a3gfLMQ1ESfP4FNpnR1/79A
 Oz/5dqNUfLbGdtEsYP2aIGeF9FNVl93ZpNGx6ERhemhBm2N7xApqiP3tYNKUiVZ3sDOIKYEJ2
 iMmc5gfUC5tJv+f0loVibAdyoo9c7cq+i3E9RD9b/6SJ5dYGKhivKgdXXEPDW1dV93QLhdFSL
 PZGXTFr+0g6K3T8g93DDsQF0HJgA2IZFdrqnWQ2jKoCzAqyRtfAuwcwq/8XJ95f8Zt2sa1q5j
 i5QbSsQ5EVA626l5M30P5LL74plbSy3gJRedbR+RbE9+qGJYMRnyscuXEwN2UXzxRaPNLactn
 LA1PR1bgPTXwH7IfAuK6UlEzlKM90faLz4ZBqZU8mwGNRq3juy04A/EguRAQlxpHrIWT6Ldvt
 d29lej7o1dU5YkgnKqNQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without I2C, we get a link failure:

drivers/ptp/ptp_clockmatrix.o: In function `idtcm_xfer.isra.3':
ptp_clockmatrix.c:(.text+0xcc): undefined reference to `i2c_transfer'
drivers/ptp/ptp_clockmatrix.o: In function `idtcm_driver_init':
ptp_clockmatrix.c:(.init.text+0x14): undefined reference to `i2c_register_driver'
drivers/ptp/ptp_clockmatrix.o: In function `idtcm_driver_exit':
ptp_clockmatrix.c:(.exit.text+0x10): undefined reference to `i2c_del_driver'

Fixes: 3a6ba7dc7799 ("ptp: Add a ptp clock driver for IDT ClockMatrix.")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/ptp/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index dc3d8ecb4231..e37797c0a85c 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -107,7 +107,7 @@ config PTP_1588_CLOCK_KVM
 
 config PTP_1588_CLOCK_IDTCM
 	tristate "IDT CLOCKMATRIX as PTP clock"
-	depends on PTP_1588_CLOCK
+	depends on PTP_1588_CLOCK && I2C
 	default n
 	help
 	  This driver adds support for using IDT CLOCKMATRIX(TM) as a PTP
-- 
2.20.0

