Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1232AC3704
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 16:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389035AbfJAOWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 10:22:11 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:39489 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389016AbfJAOWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 10:22:07 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1N6c0W-1i4vN93b6E-0182Dk; Tue, 01 Oct 2019 16:21:54 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ionic: select CONFIG_NET_DEVLINK
Date:   Tue,  1 Oct 2019 16:21:40 +0200
Message-Id: <20191001142151.1206987-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:u7qraBxsgoB/VaqNMmE0UtXHW3uhM1WX/o1uIcS2nAeZfUDgChQ
 BtCKPfi1Jo3WIfOuE4U3nFRcAC6Rgni/92SmJ7YBr6HCd+sfqaIXu/sCIPCpWAdmYjzOBfQ
 VCwRY4xh9QCc3PaBFt/LgHxbpzHnd19BeuAHVj9EYLC7gC5b1rWzDVw/2dlQ7W06mGIPnYI
 BfbaJfuBD1+qiV1HwIRsg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:dkPAEz+sepA=:Pg+Dbyy+hzRh0CS1RVlh79
 L1hXS14AIrY/G/OHNUCQLb0ZeGJ7dmdcv+KKsJgRiI09HzwXmm02jusaIK72wYZeH3eW8IuFQ
 7hEGZo1mxG+8KNO9yPvTD/GTZqrtWXkwTgdib8IHR5FkeHWqQggWAFVpu7qHIFKEnqAu5jw6S
 +7I2ot9C0kEm4VWeIBPl+OrVSWTPiVelxLBGMbppcobCEBcsIIbP5G3165iIG6vck5+NQYKXC
 m6Mz79afCW4pftyaCd6oOfjg+keZbqGJbAFRqxyuJ5pgRzIkG/atkxG4/mIX0Imo+USOGTWcO
 bx5rNJeYfx2cp6gNlJ/eiAZXjD/NPPU3tGp1clC5LB+zd9e4VjTXHy5qm9iOoutEqhaN+ti9M
 bt0wCku7ZT4S1s5VokQJfwFPnPdy/WfA9kLkgRILtq8ElZnRmLYDTiTFbNzqJ8/YhdxkEvzvt
 aert8QgW8TOkVWrYgs0QKSS61YslZpGWziGLTEoMYJ2nlDUxsImkc17hZbvYwyBZicbhaKLSe
 blDLTZCsJMzlwjh/To12vRSmBoeDdYbAI+GQ5HlZCAO3NfVvtwX043zvjKhmGsFFyFyJNsFGA
 swZkGPZn+5GaVvhbKjgGR3BDXmT5+d4UEhZ5jf8qgnJoIbYd+60xjIGU05UrB5/jgJsPrYTcY
 bKvSRJu/ohLVWs/DOs/joa67MCegMxy5LUR1tWh1B3RtTJUn9EsWfPI3jAkCs4krZQ8p3rWdk
 DL0/9fr72XcgAbK75bVf3Fw4LaSta2tmmTHWuNknlq0eMLIsaE4MkyLXi8mIBMm/COZZ8f38v
 mrNtqFYZYeryLGnHc0gxkhtwhu5EAG/HVUcYZjbYKY/u4b8wdrbHvDH9y8jn5/yqBQsI1uCml
 1gYQhpOD05qEjFY6s5LA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When no other driver selects the devlink library code, ionic
produces a link failure:

drivers/net/ethernet/pensando/ionic/ionic_devlink.o: In function `ionic_devlink_alloc':
ionic_devlink.c:(.text+0xd): undefined reference to `devlink_alloc'
drivers/net/ethernet/pensando/ionic/ionic_devlink.o: In function `ionic_devlink_register':
ionic_devlink.c:(.text+0x71): undefined reference to `devlink_register'

Add the same 'select' statement that the other drivers use here.

Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/pensando/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/Kconfig b/drivers/net/ethernet/pensando/Kconfig
index bd0583e409df..d25b88f53de4 100644
--- a/drivers/net/ethernet/pensando/Kconfig
+++ b/drivers/net/ethernet/pensando/Kconfig
@@ -20,6 +20,7 @@ if NET_VENDOR_PENSANDO
 config IONIC
 	tristate "Pensando Ethernet IONIC Support"
 	depends on 64BIT && PCI
+	select NET_DEVLINK
 	help
 	  This enables the support for the Pensando family of Ethernet
 	  adapters.  More specific information on this driver can be
-- 
2.20.0

