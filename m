Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B7D46837A
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 10:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354953AbhLDJRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 04:17:21 -0500
Received: from mail.loongson.cn ([114.242.206.163]:38786 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236591AbhLDJRV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 04:17:21 -0500
Received: from localhost.localdomain.localdomain (unknown [10.2.5.46])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Ax6shAMathLt0CAA--.6211S2;
        Sat, 04 Dec 2021 17:13:44 +0800 (CST)
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
Subject: [PATCH v4 1/2] modpost: file2alias: make mdio alias configure match mdio uevent
Date:   Sat,  4 Dec 2021 17:13:27 +0800
Message-Id: <1638609208-10339-1-git-send-email-zhuyinbo@loongson.cn>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: AQAAf9Ax6shAMathLt0CAA--.6211S2
X-Coremail-Antispam: 1UD129KBjvJXoW3GFWDJF1DXw1xZFyxWr4rXwb_yoW7uryUpF
        Wa9a4jgrWkWF43W3s5u348Ar1Uu397Aws5GF1j939Y9r98X3yktrZ3KF4Yy3y5CF45X3W0
        g345uFy8Cr1UX3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
        4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
        Yx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbV
        WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7Cj
        xVA2Y2ka0xkIwI1lc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
        1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
        b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
        vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Zr0_Wr1UMIIF
        0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
        VjvjDU0xZFpf9x0JUdHUDUUUUU=
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
Change in v4:
		Add following explain information.

Hi Russell King ,


I had given you  feedback lots of times, but it may be mail list server issue, you don't accept my mail,

and I don't get your mail, then I add that what i want explain in v1 patch for your v1 patch comment, 

you can check. then for v3 patch that is for rework commit inforation accorting , just , I notice you

have a comment in v2, but i dont' accept your mail. and I give you explain as follows:


> No. I think we've been over the reasons already. It _will_ break
> existing module loading.

> If I look at the PHY IDs on my Clearfog board:

> /sys/bus/mdio_bus/devices/f1072004.mdio-mii:00/phy_id:0x01410dd1
> /sys/bus/mdio_bus/devices/mv88e6xxx-0:00/phy_id:0x01410eb1
> /sys/bus/mdio_bus/devices/mv88e6xxx-0:01/phy_id:0x01410eb1
> /sys/bus/mdio_bus/devices/mv88e6xxx-0:02/phy_id:0x01410eb1
> /sys/bus/mdio_bus/devices/mv88e6xxx-0:03/phy_id:0x01410eb1
> /sys/bus/mdio_bus/devices/mv88e6xxx-0:04/phy_id:0x01410eb1
> /sys/bus/mdio_bus/devices/mv88e6xxx-0:0f/phy_id:0x01410ea1

> and then look at the PHY IDs that the kernel uses in the drivers, and
> thus will be used in the module's alias tables.

> #define MARVELL_PHY_ID_88E1510          0x01410dd0
> #define MARVELL_PHY_ID_88E1540          0x01410eb0
> #define MARVELL_PHY_ID_88E1545          0x01410ea0

> These numbers are different. This is not just one board. The last nibble
> of the PHY ID is generally the PHY revision, but that is not universal.
> See Atheros PHYs, where we match the entire ID except bit 4.

> You can not "simplify" the "ugly" matching like this. It's the way it is
> for good reason. Using the whole ID will _not_ cause a match, and your
> change will cause a regression.

On my platform, I can find following, stmmac-xx that is is mac name, it represent this platform has two mac 
controller, it isn't phy, but it's sub dir has phy id it is phy silicon id, and devices name is set by mdio bus,
then, you said that "where we match the entire ID except bit 4." I think marvell it is special, and you can have 
look other phy,e.g. motorcomm phy, that phy mask is 0x00000fff or 0x0000ffff or ther, for different phy silicon, 
that phy maskit is not same, and that phy mask it isn't device property, you dont't get it from register, and mdio
 bus for phy register a device then mdiobus_scan will get phy id that phy id it is include all value, and don't has 
mask operation. then phy uevent must use phy_id that from phy register and that uevent doesn't include phy mask, if
uevent add phy mask, then you need  define a phy mask. if you have mature consideration, you will find that definition
phy mask it isn't appropriate, if you define it in mac driver, because  mac can select different phy, if you define it
 in dts, then phy driver is "of" type, mdio_uevent will doesn't be called. if you ask phy_id & phy_mask as a phy uevent,
 I think it is no make sense, e.g. 88e1512 and 88e1510 that has different "phy revision" so that phy silicon has difference, 
and uevent should be unique. If you have no other opinion on the above view, Back to this patch, that phy id of uevent
need match phy alias configure, so alis configure must use phy id all value.

In addition, Even if you hadn't  consided what I said above, you need to know one thing, uevent match alias that must be full
 matching. not Partial matching. I said it a long time ago.  why you think Binary digit and "?" can match dev uevent,   
according my code analysis and test analysis that  any platform and any mdio phy device is all fail that be matched if that
 phy driver module and phy dev was use uevent-alias mechanism

[root@localhost ~]# cat /sys/bus/mdio/devices/stmmac-19\:00/phy_id 
0x01410dd1
[root@localhost ~]# 
[root@localhost ~]# cat /sys/bus/mdio/devices/stmmac-18\:00/phy_id 
0x01410dd1
[root@localhost ~]# 

Thanks,
BRs,
Yinbo Zhu.


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

