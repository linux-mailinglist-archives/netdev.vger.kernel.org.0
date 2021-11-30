Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7E0462E71
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 09:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239315AbhK3IZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 03:25:56 -0500
Received: from mail.loongson.cn ([114.242.206.163]:39896 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234234AbhK3IZx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 03:25:53 -0500
Received: from localhost.localdomain.localdomain (unknown [10.2.5.46])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxz8on36Vhh7UBAA--.4073S2;
        Tue, 30 Nov 2021 16:22:06 +0800 (CST)
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
Subject: [PATCH v3 1/2] modpost: file2alias: make mdio alias configure match mdio uevent
Date:   Tue, 30 Nov 2021 16:21:56 +0800
Message-Id: <1638260517-13634-1-git-send-email-zhuyinbo@loongson.cn>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: AQAAf9Dxz8on36Vhh7UBAA--.4073S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJr1DXF4rJw4xJFWUAFW8Zwb_yoW8Cw4UpF
        ZxGa42grWkWF47Wa15ua4DJr1UXw4kC3s5WayY9a10gFWqyrZYqr4SkFsIyr15CFWkXa40
        gw13uFy8uw4UXrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26r
        xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
        8cxan2IY04v7MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
        W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
        1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
        IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
        nxnUUI43ZEXa7VU1a9aPUUUUU==
X-CM-SenderInfo: 52kx5xhqerqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The do_mdio_entry was responsible for generating a phy alias configure
that according to the phy driver's mdio_device_id, before apply this
patch, which alias configure is like "alias mdio:000000010100000100001
1011101????", it doesn't match the phy_id of mdio_uevent, because of
the phy_id was a hexadecimal digit and the mido uevent is consisit of
phy_id with the char 'p', the uevent string is different from alias.
Add this patch that mdio alias configure will can match mdio uevent.

Signed-off-by: Yinbo Zhu <zhuyinbo@loongson.cn>
---
Change in v3:
		Rework the patch commit log information.

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

