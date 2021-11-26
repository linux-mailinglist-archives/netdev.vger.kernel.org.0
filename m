Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95A945EAAC
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 10:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376467AbhKZJvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 04:51:31 -0500
Received: from mail.loongson.cn ([114.242.206.163]:33930 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236947AbhKZJta (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 04:49:30 -0500
Received: from localhost.localdomain.localdomain (unknown [10.2.5.46])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9AxWsjWrKBhSyEAAA--.43S2;
        Fri, 26 Nov 2021 17:46:03 +0800 (CST)
From:   Yinbo Zhu <zhuyinbo@loongson.cn>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Cc:     zhuyinbo@loongson.cn
Subject: [PATCH v2 1/2] modpost: file2alias: fixup mdio alias garbled code in modules.alias
Date:   Fri, 26 Nov 2021 17:45:56 +0800
Message-Id: <1637919957-21635-1-git-send-email-zhuyinbo@loongson.cn>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: AQAAf9AxWsjWrKBhSyEAAA--.43S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tF1UAry5Ww47XF18Xr1xuFg_yoW8CF45pF
        ZxGa4SgFWkWF47uan5ua4DAr1UXw4DK3s5Wa1j9F40gF9Iyry0vF4SkFnay3WUAFZ7Xa40
        g343uFyUur47XrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1lc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
        nxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: 52kx5xhqerqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After module compilation, module alias mechanism will generate a ugly
mdio modules alias configure if ethernet phy was selected, this patch
is to fixup mdio alias garbled code.

In addition, that ugly alias configure will cause ethernet phy module
doens't match udev, phy module auto-load is fail, but add this patch
that it is well mdio driver alias configure match phy device uevent.

Signed-off-by: Yinbo Zhu <zhuyinbo@loongson.cn>
---
Change in v2:
		Add a MDIO_ANY_ID for considering some special phy device 
		which phy id doesn't be read from phy register.


 include/linux/mod_devicetable.h |  2 ++
 scripts/mod/file2alias.c        | 17 +----------------
 2 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index ae2e75d..7bd23bf 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -595,6 +595,8 @@ struct platform_device_id {
 	kernel_ulong_t driver_data;
 };
 
+#define MDIO_ANY_ID (~0)
+
 #define MDIO_NAME_SIZE		32
 #define MDIO_MODULE_PREFIX	"mdio:"
 
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 49aba86..63f3149 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1027,24 +1027,9 @@ static int do_platform_entry(const char *filename,
 static int do_mdio_entry(const char *filename,
 			 void *symval, char *alias)
 {
-	int i;
 	DEF_FIELD(symval, mdio_device_id, phy_id);
-	DEF_FIELD(symval, mdio_device_id, phy_id_mask);
-
 	alias += sprintf(alias, MDIO_MODULE_PREFIX);
-
-	for (i = 0; i < 32; i++) {
-		if (!((phy_id_mask >> (31-i)) & 1))
-			*(alias++) = '?';
-		else if ((phy_id >> (31-i)) & 1)
-			*(alias++) = '1';
-		else
-			*(alias++) = '0';
-	}
-
-	/* Terminate the string */
-	*alias = 0;
-
+	ADD(alias, "p", phy_id != MDIO_ANY_ID, phy_id);
 	return 1;
 }
 
-- 
1.8.3.1

