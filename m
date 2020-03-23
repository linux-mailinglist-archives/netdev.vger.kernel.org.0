Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6C7E18F285
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 11:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgCWKOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 06:14:36 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37729 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbgCWKOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 06:14:34 -0400
Received: by mail-lj1-f196.google.com with SMTP id r24so13907084ljd.4
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 03:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=AwucaSojyVDcW1oL0/BLNJyhObj7yjHZoejZLugLWjY=;
        b=Z7HLWCF8TAU4EvnFhxKEG6TgJZR3urUi6EBeJAfg3x7tA3Or94oS6nnb7dRX7fdDiN
         qjlNwsaS5EYhfW3z/1bC3iUh+FyAwA8mT94fVJqGdRsxK5XgQ5egqpzp1bUC9uEV9Noi
         23ykMCUAl4LF2suG319GQ6VqW515/ycMHZ6helgEx1fDcoFEb5rxGHy4+O8Vb9I2aWv1
         +i0yhzofQs/r/1LpzY4mLq33x/1QMMUuYlhQNdwj8zAH6m7Tjmyhg8Rvk19EsEMWPVAr
         HNkAmy2KHcgCc8R+5inxCdhm78VfPTbuwx9Dvzo81yKAaDvKlFFdYXQhrpMSfvSN78sh
         l4FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=AwucaSojyVDcW1oL0/BLNJyhObj7yjHZoejZLugLWjY=;
        b=NxkJTMYw+l0/zy9H16ZNpUNPLtXG7THWrW/cQrigPRN24/x/I23RdyJeIO3yJyF/hA
         8amLNRV2bkkzGVkwStQOIQj0BKIKwaYQCVjo+49v0/g/0qUP9ZnaEUP/38rq06kB77aT
         DkKKpe95gR+y7jqMRNrt9exbol/3vLty+DkimlTppXtu/EG6d2S4hDUYZLF/iL4fZ/ln
         3gWvTzIQXy2xZal09F6n1NMshKOVwlnu+dxhFIkmfWjBM9knwbDC+PUpy6GDtn+B58zF
         lKc7iILAZUq4AI7GPjuUZ5mVxYmNPV8Oda09i3VAwmS2Ju1nvOxw64iC5cUcp+3izk4t
         rs5w==
X-Gm-Message-State: ANhLgQ0fMYWAkAEMwLxgSGbxnPr3vrU4NpLXR8f8iNnYUoWIENTaZNzc
        dfDgQ7SqQ2zgDMl1W0t/zLH3+Q==
X-Google-Smtp-Source: ADFU+vvhc8pGZbnPR2BORoTOMMM9hRe2ps9MnXy7Zz2kwD6QI1puwcWzjLfh8mwZsTQSFsNA/jeFiA==
X-Received: by 2002:a2e:b804:: with SMTP id u4mr3899029ljo.159.1584958471937;
        Mon, 23 Mar 2020 03:14:31 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 28sm367434lfp.8.2020.03.23.03.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 03:14:31 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: [PATCH net-next v4 2/2] net: phy: add marvell usb to mdio controller
Date:   Mon, 23 Mar 2020 11:14:14 +0100
Message-Id: <20200323101414.11505-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200323101414.11505-1-tobias@waldekranz.com>
References: <20200323101414.11505-1-tobias@waldekranz.com>
Organization: Westermo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An MDIO controller present on development boards for Marvell switches
from the Link Street (88E6xxx) family.

Using this module, you can use the following setup as a development
platform for switchdev and DSA related work.

   .-------.      .-----------------.
   |      USB----USB                |
   |  SoC  |      |  88E6390X-DB  ETH1-10
   |      ETH----ETH0               |
   '-------'      '-----------------'

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 MAINTAINERS                  |   1 +
 drivers/net/phy/Kconfig      |   7 ++
 drivers/net/phy/Makefile     |   1 +
 drivers/net/phy/mdio-mvusb.c | 120 +++++++++++++++++++++++++++++++++++
 4 files changed, 129 insertions(+)
 create mode 100644 drivers/net/phy/mdio-mvusb.c

diff --git a/MAINTAINERS b/MAINTAINERS
index ff35669f8712..f36023d4ee44 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10105,6 +10105,7 @@ MARVELL USB MDIO CONTROLLER DRIVER
 M:	Tobias Waldekranz <tobias@waldekranz.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/phy/mdio-mvusb.c
 F:	Documentation/devicetree/bindings/net/marvell,mvusb.yaml
 
 MARVELL XENON MMC/SD/SDIO HOST CONTROLLER DRIVER
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index cc7f1df855da..3fa33d27eeba 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -179,6 +179,13 @@ config MDIO_MSCC_MIIM
 	  This driver supports the MIIM (MDIO) interface found in the network
 	  switches of the Microsemi SoCs
 
+config MDIO_MVUSB
+	tristate "Marvell USB to MDIO Adapter"
+	depends on USB
+	help
+	  A USB to MDIO converter present on development boards for
+	  Marvell's Link Street family of Ethernet switches.
+
 config MDIO_OCTEON
 	tristate "Octeon and some ThunderX SOCs MDIO buses"
 	depends on (64BIT && OF_MDIO) || COMPILE_TEST
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 70774ab474e6..2f5c7093a65b 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_MDIO_I2C)		+= mdio-i2c.o
 obj-$(CONFIG_MDIO_IPQ8064)	+= mdio-ipq8064.o
 obj-$(CONFIG_MDIO_MOXART)	+= mdio-moxart.o
 obj-$(CONFIG_MDIO_MSCC_MIIM)	+= mdio-mscc-miim.o
+obj-$(CONFIG_MDIO_MVUSB)	+= mdio-mvusb.o
 obj-$(CONFIG_MDIO_OCTEON)	+= mdio-octeon.o
 obj-$(CONFIG_MDIO_SUN4I)	+= mdio-sun4i.o
 obj-$(CONFIG_MDIO_THUNDER)	+= mdio-thunder.o
diff --git a/drivers/net/phy/mdio-mvusb.c b/drivers/net/phy/mdio-mvusb.c
new file mode 100644
index 000000000000..d5eabddfdf51
--- /dev/null
+++ b/drivers/net/phy/mdio-mvusb.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_mdio.h>
+#include <linux/phy.h>
+#include <linux/usb.h>
+
+#define USB_MARVELL_VID	0x1286
+
+static const struct usb_device_id mvusb_mdio_table[] = {
+	{ USB_DEVICE(USB_MARVELL_VID, 0x1fa4) },
+
+	{}
+};
+MODULE_DEVICE_TABLE(usb, mvusb_mdio_table);
+
+enum {
+	MVUSB_CMD_PREAMBLE0,
+	MVUSB_CMD_PREAMBLE1,
+	MVUSB_CMD_ADDR,
+	MVUSB_CMD_VAL,
+};
+
+struct mvusb_mdio {
+	struct usb_device *udev;
+	struct mii_bus *mdio;
+
+	__le16 buf[4];
+};
+
+static int mvusb_mdio_read(struct mii_bus *mdio, int dev, int reg)
+{
+	struct mvusb_mdio *mvusb = mdio->priv;
+	int err, alen;
+
+	if (dev & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	mvusb->buf[MVUSB_CMD_ADDR] = cpu_to_le16(0xa400 | (dev << 5) | reg);
+
+	err = usb_bulk_msg(mvusb->udev, usb_sndbulkpipe(mvusb->udev, 2),
+			   mvusb->buf, 6, &alen, 100);
+	if (err)
+		return err;
+
+	err = usb_bulk_msg(mvusb->udev, usb_rcvbulkpipe(mvusb->udev, 6),
+			   &mvusb->buf[MVUSB_CMD_VAL], 2, &alen, 100);
+	if (err)
+		return err;
+
+	return le16_to_cpu(mvusb->buf[MVUSB_CMD_VAL]);
+}
+
+static int mvusb_mdio_write(struct mii_bus *mdio, int dev, int reg, u16 val)
+{
+	struct mvusb_mdio *mvusb = mdio->priv;
+	int alen;
+
+	if (dev & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	mvusb->buf[MVUSB_CMD_ADDR] = cpu_to_le16(0x8000 | (dev << 5) | reg);
+	mvusb->buf[MVUSB_CMD_VAL]  = cpu_to_le16(val);
+
+	return usb_bulk_msg(mvusb->udev, usb_sndbulkpipe(mvusb->udev, 2),
+			    mvusb->buf, 8, &alen, 100);
+}
+
+static int mvusb_mdio_probe(struct usb_interface *interface,
+			    const struct usb_device_id *id)
+{
+	struct device *dev = &interface->dev;
+	struct mvusb_mdio *mvusb;
+	struct mii_bus *mdio;
+
+	mdio = devm_mdiobus_alloc_size(dev, sizeof(*mvusb));
+	if (!mdio)
+		return -ENOMEM;
+
+	mvusb = mdio->priv;
+	mvusb->mdio = mdio;
+	mvusb->udev = usb_get_dev(interface_to_usbdev(interface));
+
+	/* Reversed from USB PCAPs, no idea what these mean. */
+	mvusb->buf[MVUSB_CMD_PREAMBLE0] = cpu_to_le16(0xe800);
+	mvusb->buf[MVUSB_CMD_PREAMBLE1] = cpu_to_le16(0x0001);
+
+	snprintf(mdio->id, MII_BUS_ID_SIZE, "mvusb-%s", dev_name(dev));
+	mdio->name = mdio->id;
+	mdio->parent = dev;
+	mdio->read = mvusb_mdio_read;
+	mdio->write = mvusb_mdio_write;
+
+	usb_set_intfdata(interface, mvusb);
+	return of_mdiobus_register(mdio, dev->of_node);
+}
+
+static void mvusb_mdio_disconnect(struct usb_interface *interface)
+{
+	struct mvusb_mdio *mvusb = usb_get_intfdata(interface);
+	struct usb_device *udev = mvusb->udev;
+
+	mdiobus_unregister(mvusb->mdio);
+	usb_set_intfdata(interface, NULL);
+	usb_put_dev(udev);
+}
+
+static struct usb_driver mvusb_mdio_driver = {
+	.name       = "mvusb_mdio",
+	.id_table   = mvusb_mdio_table,
+	.probe      = mvusb_mdio_probe,
+	.disconnect = mvusb_mdio_disconnect,
+};
+
+module_usb_driver(mvusb_mdio_driver);
+
+MODULE_AUTHOR("Tobias Waldekranz <tobias@waldekranz.com>");
+MODULE_DESCRIPTION("Marvell USB MDIO Adapter");
+MODULE_LICENSE("GPL");
-- 
2.17.1

