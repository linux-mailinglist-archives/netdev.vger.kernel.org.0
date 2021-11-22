Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2CA458E12
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 13:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239485AbhKVMSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 07:18:30 -0500
Received: from mail.loongson.cn ([114.242.206.163]:55790 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239434AbhKVMS3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 07:18:29 -0500
Received: from localhost.localdomain.localdomain (unknown [10.2.5.46])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dx79PDiZthKyUAAA--.851S2;
        Mon, 22 Nov 2021 20:15:04 +0800 (CST)
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
Subject: [PATCH v1 1/2] modpost: file2alias: fixup mdio alias garbled code in modules.alias
Date:   Mon, 22 Nov 2021 20:14:57 +0800
Message-Id: <1637583298-20321-1-git-send-email-zhuyinbo@loongson.cn>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: AQAAf9Dx79PDiZthKyUAAA--.851S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tF1UAry5Ww47XF18Xr1xuFg_yoW8Jw17pF
        W3K34a9FZ7GF47Wa1ru34DWr15G3ykJ3yrW3WjgF40qFZ8A3y0yF4SkF1rK34UAFykZa4Y
        gw13uF98Ar1DWrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCY02Avz4vE-syl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvE
        x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
        DU0xZFpf9x0JUdHUDUUUUU=
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
 scripts/mod/file2alias.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 49aba86..5ba1039 100644
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
+	ADD(alias, "p", phy_id != 0, phy_id);
 	return 1;
 }
 
-- 
1.8.3.1

