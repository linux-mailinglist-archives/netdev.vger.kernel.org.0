Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78C1112B3E9
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 11:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfL0Kb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 05:31:27 -0500
Received: from mail.loongson.cn ([114.242.206.163]:43760 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726270AbfL0Kb1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 05:31:27 -0500
Received: from linux.localdomain (unknown [123.138.236.242])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9AxObhy3QVeYssBAA--.2105S2;
        Fri, 27 Dec 2019 18:31:15 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: Fix compile warning about of_mdiobus_child_is_phy
Date:   Fri, 27 Dec 2019 18:30:59 +0800
Message-Id: <1577442659-12134-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9AxObhy3QVeYssBAA--.2105S2
X-Coremail-Antispam: 1UD129KBjvdXoW7XF1DZr1kWw1xJr4rZw4Utwb_yoWDCrbEk3
        W3GrW5Gr4rGFyfCw43Ga1IqF90yrWxWr4kXFZag3yvqw1DXw42v3y8AFn2qr4DGanrCFW5
        Zw18Z3409w1UCjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbskYjsxI4VWkKwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4
        A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
        w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r4j6F4UMc
        vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xK
        xwCY02Avz4vE14v_Gw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2
        IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v2
        6r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2
        IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E
        87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73Uj
        IFyTuYvjxUg8hLDUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following compile warning when CONFIG_OF_MDIO is not set:

  CC      drivers/net/phy/mdio_bus.o
In file included from drivers/net/phy/mdio_bus.c:23:0:
./include/linux/of_mdio.h:58:13: warning: ‘of_mdiobus_child_is_phy’ defined but not used [-Wunused-function]
 static bool of_mdiobus_child_is_phy(struct device_node *child)
             ^

Fixes: 0aa4d016c043 ("of: mdio: export of_mdiobus_child_is_phy")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 include/linux/of_mdio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index 79bc82e..491a2b7 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -55,7 +55,7 @@ static inline int of_mdio_parse_addr(struct device *dev,
 }
 
 #else /* CONFIG_OF_MDIO */
-static bool of_mdiobus_child_is_phy(struct device_node *child)
+static inline bool of_mdiobus_child_is_phy(struct device_node *child)
 {
 	return false;
 }
-- 
2.1.0

