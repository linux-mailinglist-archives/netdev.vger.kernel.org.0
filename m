Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 080C511AB65
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 13:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbfLKM50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 07:57:26 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:42119 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728128AbfLKM50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 07:57:26 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MatmF-1i8ibS36ZH-00cOoO; Wed, 11 Dec 2019 13:57:13 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net: ethernet: ti: build cpsw-common for switchdev
Date:   Wed, 11 Dec 2019 13:56:10 +0100
Message-Id: <20191211125643.1987157-2-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191211125643.1987157-1-arnd@arndb.de>
References: <20191211125643.1987157-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:K6rsam58HmBZQzLvo9EBHtFu2MxaOTWeFk96Se6piIUDIb6cI0F
 /dI9Aep+YrNPLwpnbwhuOcewweRyHskJN33FJh+PjMYCurRpkrzac+njNH/TpTNGYKvmMMa
 LaN36M/SepcSpqQCim9xV7od6ph8Vppbjz8BRiCUu3hfCIIuizlXu94JDbVqnLJ+2ofXZeB
 5srA/DbfW66duIwP47qpQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:kqUrXnKg35M=:CaUAdEjNCKSXdpNTo0Eorq
 b6ldRdm5Tauq2CQV3kUOU2OLIInZe3UuZdSgZKEZTzyl5pvTzwVTIvYJToqXS9k+O6lKqSG3j
 OHBMNiQln4vY02omU0+rAhYHK/hqg1Cvex0uofOhbf4xryiRcanTLOOPhqQwJvRJFJtEOCHl9
 E2BfqGeanhJwLlpdZIBIDTamgWWlWPInVJ/i3czwYnWbBZ0xBCdD2+qJ5lM0+8H0yfYYIFzmB
 hWxsJOlX59P0EevL6tR2oMuu50FE1ERBDoALc+xsr4DnnKlViRpsFJbn9fJOxoD2zS/NgStIZ
 GD07xbQZWFtl9wpbCltJ500d00FEdnAb72VY8gt0T+B05wRnYWPDpIhnLUhMoi3/mIGctaqwY
 NKSXsip/AEhMLCsDOXAmpyccgGSkrqjS9qviBjgk1gjp6ic3UInrrFRJuULvNq1+JrWXSwc93
 I8kA7iypL2yrxiXGBrrLFkCwQOk5Qeu4poQuDy0SG0PL6tY2nyIG5h0O8W2cwV2Hz0X86IHNP
 zPChNae4ykswfrd5GbM7sLsBBmMh9EH5jXyoQzHyAgRZeuGwO4N9dhzUmpd+m2fvHVLWjSP7l
 DL/nYhKNWHZo2zFYw9nMfgBrqbGOI/j42hE6mZB4PaTJQKnC8zJA/FBVJlAPzielwWl/vHw8h
 yviFiD3E+OP024kmLaUlMWIQJl/TDQx/TMKtMdncDawnUUrPO1ZrMtSxu5w4r/1el16rZJn6e
 Pw+WZD2vIe/cyMBM15P3NMtLJ52SYhcFvw2RSwTXelh/lLBCPtZl2Unor67znXuOD/MwjJRkl
 yOGf1J2nQyF7e6RR8I1MNt//8hG7d/Cb69Nx4Ie5ceymS61b5IG0PhkATLNh02vxpdNVlhdGo
 H7HiYrXmWcJcZqEyIT9A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without the common part of the driver, the new file fails to link:

drivers/net/ethernet/ti/cpsw_new.o: In function `cpsw_probe':
cpsw_new.c:(.text+0x312c): undefined reference to `ti_cm_get_macid'

Use the same Makefile hack as before, and build cpsw-common.o for
any driver that needs it.

Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/ti/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ti/Makefile b/drivers/net/ethernet/ti/Makefile
index d34df8e5cf94..ecf776ad8689 100644
--- a/drivers/net/ethernet/ti/Makefile
+++ b/drivers/net/ethernet/ti/Makefile
@@ -5,6 +5,7 @@
 
 obj-$(CONFIG_TI_CPSW) += cpsw-common.o
 obj-$(CONFIG_TI_DAVINCI_EMAC) += cpsw-common.o
+obj-$(CONFIG_TI_CPSW_SWITCHDEV) += cpsw-common.o
 
 obj-$(CONFIG_TLAN) += tlan.o
 obj-$(CONFIG_CPMAC) += cpmac.o
-- 
2.20.0

