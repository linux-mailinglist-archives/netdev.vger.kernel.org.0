Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC591484258
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 14:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbiADNZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 08:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbiADNZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 08:25:18 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD529C061761;
        Tue,  4 Jan 2022 05:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dlRlk2wYEk2DcEqB0eWfT2wU9WqSJ+uo3N+tcXCm11Y=; b=KGMx4rfBbqbGNXr4D1mA4fjhfh
        prgjQ8LufvAghOqFX3n7LpJZa7dIK0XyL5tKpCKnLpP2ahG/Or7tGusW2PkO0g6WumQpB0g9vGIjn
        +kpHW3+GQjc+BdCxh0MANNaPiX6OEEvLO26mAWYKEqNBh6VzONfdOz1wY1jNyMVU7NWLQhmYkwTyx
        kX5Xw0Myy6K75K0ZwFm9T0nklXDQvwnaSvUx0vt9HQ625UXKFJmK+gI8LrwH1WlHsc9SvibNtbuBO
        zFxooRd09L1LIZi7fjB6KbA7fksTeo0wPKnBtMm9KSVitb/+EY33LyDRYRjDVMAW2Mh27sPtXdRe6
        jFLWHteg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56562)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n4joK-00071l-2M; Tue, 04 Jan 2022 13:25:08 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n4joF-0007Gq-MK; Tue, 04 Jan 2022 13:25:03 +0000
Date:   Tue, 4 Jan 2022 13:25:03 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     zhuyinbo <zhuyinbo@loongson.cn>
Cc:     Andrew Lunn <andrew@lunn.ch>, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, masahiroy@kernel.org,
        michal.lkml@markovi.net, ndesaulniers@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v2 1/2] modpost: file2alias: fixup mdio alias garbled
 code in modules.alias
Message-ID: <YdRKr4rxUj9EnDh3@shell.armlinux.org.uk>
References: <1637919957-21635-1-git-send-email-zhuyinbo@loongson.cn>
 <c6d37ae0-9ccb-a527-4f55-e96972813a53@gmail.com>
 <YaYPMOJ/+OXIWcnj@shell.armlinux.org.uk>
 <YabEHd+Z5SPAhAT5@lunn.ch>
 <f91f4fff-8bdf-663b-68f5-b8ccbd0c187a@loongson.cn>
 <257a0fbf-941e-2d9e-50b4-6e34d7061405@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <257a0fbf-941e-2d9e-50b4-6e34d7061405@loongson.cn>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 09:11:56PM +0800, zhuyinbo wrote:
> From the present point of view, no matter what the situation, my supplement
> can cover udev or request_module for auto load module.
> 
> if that phy driver isn't platform driver my patch cover it I think there is
> no doubt, if phy driver is platform driver and platform driver udev will
> cover it. My only requestion is the request_module not work well.
> 
> about xgmiitorgmii_of_match that it belongs to platform driver load, please
> you note. and about your doubt usepace whether disable module load that
> module load function is okay becuase other device driver auto load is okay.

xgmiitorgmii is *not* a platform driver.

> > Please report back what the following command produces on your
> > problem system:
> >
> > /sbin/modprobe -vn mdio:00000001010000010000110111010001
> >
> > Thanks.
> 
> [root@localhost ~]# lsmod | grep marvell
> [root@localhost ~]# ls
> /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
> /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
> [root@localhost ~]# /sbin/modprobe -vn mdio:00000001010000010000110111010001
> insmod /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
> insmod /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
> [root@localhost ~]#
> [root@localhost ~]# cat /proc/sys/kernel/modprobe
> /sbin/modprobe

Great, so the current scheme using "mdio:<binary digits>" works
perfectly for you. What is missing is having that modalias in the
uevent file.

So, my patch on the 4th December should cause the marvell module to
be loaded at boot time. Please test that patch ASAP, which I have
already asked you to do. I'll include it again in this email so you
don't have to hunt for it.

8<===
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH] net: phy: generate PHY mdio modalias

The modalias string provided in the uevent sysfs file does not conform
to the format used in PHY driver modules. One of the reasons is that
udev loading of PHY driver modules has not been an expected use case.

This patch changes the MODALIAS entry for only PHY devices from:
        MODALIAS=of:Nethernet-phyT(null)
to:
        MODALIAS=mdio:00000000001000100001010100010011

Other MDIO devices (such as DSA) remain as before.

However, having udev automatically load the module has the advantage
of making use of existing functionality to have the module loaded
before the device is bound to the driver, thus taking advantage of
multithreaded boot systems, potentially decreasing the boot time.

However, this patch will not solve any issues with the driver module
not being loaded prior to the network device needing to use the PHY.
This is something that is completely out of control of any patch to
change the uevent mechanism.

Reported-by: Yinbo Zhu <zhuyinbo@loongson.cn>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/mdio_bus.c   |  8 ++++++++
 drivers/net/phy/phy_device.c | 14 ++++++++++++++
 include/linux/mdio.h         |  2 ++
 3 files changed, 24 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 4638d7375943..663bd98760fb 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -1010,8 +1010,16 @@ static int mdio_bus_match(struct device *dev, struct device_driver *drv)
 
 static int mdio_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
+	struct mdio_device *mdio = to_mdio_device(dev);
 	int rc;
 
+	/* Use the device-specific uevent if specified */
+	if (mdio->bus_uevent) {
+		rc = mdio->bus_uevent(mdio, env);
+		if (rc != -ENODEV)
+			return rc;
+	}
+
 	/* Some devices have extra OF data and an OF-style MODALIAS */
 	rc = of_device_uevent_modalias(dev, env);
 	if (rc != -ENODEV)
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 23667658b9c6..f4c2057f0202 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -563,6 +563,19 @@ static int phy_request_driver_module(struct phy_device *dev, u32 phy_id)
 	return 0;
 }
 
+static int phy_bus_uevent(struct mdio_device *mdiodev,
+			  struct kobj_uevent_env *env)
+{
+	struct phy_device *phydev;
+
+	phydev = container_of(mdiodev, struct phy_device, mdio);
+
+	add_uevent_var(env, "MODALIAS=" MDIO_MODULE_PREFIX MDIO_ID_FMT,
+		       MDIO_ID_ARGS(phydev->phy_id));
+
+	return 0;
+}
+
 struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids)
@@ -582,6 +595,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 	mdiodev->dev.type = &mdio_bus_phy_type;
 	mdiodev->bus = bus;
 	mdiodev->bus_match = phy_bus_match;
+	mdiodev->bus_uevent = phy_bus_uevent;
 	mdiodev->addr = addr;
 	mdiodev->flags = MDIO_DEVICE_FLAG_PHY;
 	mdiodev->device_free = phy_mdio_device_free;
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index df9c96e56907..5c6676d3de23 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -38,6 +38,8 @@ struct mdio_device {
 	char modalias[MDIO_NAME_SIZE];
 
 	int (*bus_match)(struct device *dev, struct device_driver *drv);
+	int (*bus_uevent)(struct mdio_device *mdiodev,
+			  struct kobj_uevent_env *env);
 	void (*device_free)(struct mdio_device *mdiodev);
 	void (*device_remove)(struct mdio_device *mdiodev);
 
-- 
2.30.2


-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
