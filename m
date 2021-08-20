Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162F83F258B
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 06:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbhHTEHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 00:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhHTEHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 00:07:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8775AC061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 21:06:43 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mGvnh-0006UH-U8; Fri, 20 Aug 2021 06:06:37 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mGvnf-0001WP-PY; Fri, 20 Aug 2021 06:06:35 +0200
Date:   Fri, 20 Aug 2021 06:06:35 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Regression with commit e532a096be0e ("net: usb: asix: ax88772:
 add phylib support")
Message-ID: <20210820040635.GA3573@pengutronix.de>
References: <3904c728-1ea2-9c2b-ec11-296396fd2f7e@linux.intel.com>
 <20210816081314.3b251d2e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210816161822.td7jl4tv7zfbprty@pengutronix.de>
 <e575a7a9-2645-9ebc-fdea-f0421ecaf0e2@linux.intel.com>
 <20210817090920.7wviv7fsfzyhli5t@pengutronix.de>
 <1e54ca43-6631-a76a-2e40-1355fe187538@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <1e54ca43-6631-a76a-2e40-1355fe187538@linux.intel.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:02:09 up 172 days, 13:37, 84 users,  load average: 3.46, 2.80,
 1.94
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Jarkko,

On Tue, Aug 17, 2021 at 02:55:20PM +0300, Jarkko Nikula wrote:
> On 8/17/21 12:09 PM, Oleksij Rempel wrote:
> > OK thx, I'll need to your help to debug it:
> > - please send me complete log, or at least parts related to the asix
> >    (dmesg | grep -i Asix)
> 
> I added following dyndebug options if that helps:
> asix.dyndbg=+p ax88179_178a.dyndbg=+p
> 
> Around ~8 s or so after bootup I run following:
> ifconfig eth0 down; sleep 5; ifconfig eth0 up; sleep 5; ifconfig eth0 down
> 
> Attachments have grepped dmesg from v5.13 and linux-next next-20210816.

thank you! It helps.

> > - do the interface is not able to go up at all? For example, it works on
> >    hot plug, but is not working on reboot.
> > - Can you please test it with other link partners.
> > 
> I'm now testing this remotely but can test these later this week or next
> week at the office.

Can you please test attached patch.
And may be add some prints to the ax88772_hw_reset() and ax88772a_hw_reset().
It would be interesting to know, which variant is actually affected.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--bp/iNruPH9dso1Pn
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-net-usb-asix-ax88772-move-embedded-PHY-detection-as-.patch"

From a96a1bcaba8afa9d716e88b241ac77d97be068f9 Mon Sep 17 00:00:00 2001
From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Thu, 19 Aug 2021 06:58:52 +0200
Subject: [PATCH] net: usb: asix: ax88772: move embedded PHY detection as early
 as possible

Some HW revisions need additional MAC configuration before the embedded PHY
can be enabled. If this is not done, we won't be able to get response
from the PHY.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/usb/asix.h         |  1 +
 drivers/net/usb/asix_devices.c | 41 +++++++++++++++++-----------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
index e1994a246122..2a1e31defe71 100644
--- a/drivers/net/usb/asix.h
+++ b/drivers/net/usb/asix.h
@@ -184,6 +184,7 @@ struct asix_common_private {
 	struct phy_device *phydev;
 	u16 phy_addr;
 	char phy_name[20];
+	bool embd_phy;
 };
 
 extern const struct driver_info ax88172a_info;
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index cb01897c7a5d..a74e67a60436 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -354,24 +354,23 @@ static int ax88772_reset(struct usbnet *dev)
 static int ax88772_hw_reset(struct usbnet *dev, int in_pm)
 {
 	struct asix_data *data = (struct asix_data *)&dev->data;
-	int ret, embd_phy;
+	struct asix_common_private *priv = dev->driver_priv;
 	u16 rx_ctl;
+	int ret;
 
 	ret = asix_write_gpio(dev, AX_GPIO_RSE | AX_GPIO_GPO_2 |
 			      AX_GPIO_GPO2EN, 5, in_pm);
 	if (ret < 0)
 		goto out;
 
-	embd_phy = ((dev->mii.phy_id & 0x1f) == 0x10 ? 1 : 0);
-
-	ret = asix_write_cmd(dev, AX_CMD_SW_PHY_SELECT, embd_phy,
+	ret = asix_write_cmd(dev, AX_CMD_SW_PHY_SELECT, priv->embd_phy,
 			     0, 0, NULL, in_pm);
 	if (ret < 0) {
 		netdev_dbg(dev->net, "Select PHY #1 failed: %d\n", ret);
 		goto out;
 	}
 
-	if (embd_phy) {
+	if (priv->embd_phy) {
 		ret = asix_sw_reset(dev, AX_SWRESET_IPPD, in_pm);
 		if (ret < 0)
 			goto out;
@@ -449,17 +448,16 @@ static int ax88772_hw_reset(struct usbnet *dev, int in_pm)
 static int ax88772a_hw_reset(struct usbnet *dev, int in_pm)
 {
 	struct asix_data *data = (struct asix_data *)&dev->data;
-	int ret, embd_phy;
+	struct asix_common_private *priv = dev->driver_priv;
 	u16 rx_ctl, phy14h, phy15h, phy16h;
 	u8 chipcode = 0;
+	int ret;
 
 	ret = asix_write_gpio(dev, AX_GPIO_RSE, 5, in_pm);
 	if (ret < 0)
 		goto out;
 
-	embd_phy = ((dev->mii.phy_id & 0x1f) == 0x10 ? 1 : 0);
-
-	ret = asix_write_cmd(dev, AX_CMD_SW_PHY_SELECT, embd_phy |
+	ret = asix_write_cmd(dev, AX_CMD_SW_PHY_SELECT, priv->embd_phy |
 			     AX_PHYSEL_SSEN, 0, 0, NULL, in_pm);
 	if (ret < 0) {
 		netdev_dbg(dev->net, "Select PHY #1 failed: %d\n", ret);
@@ -683,12 +681,6 @@ static int ax88772_init_phy(struct usbnet *dev)
 	struct asix_common_private *priv = dev->driver_priv;
 	int ret;
 
-	ret = asix_read_phy_addr(dev, true);
-	if (ret < 0)
-		return ret;
-
-	priv->phy_addr = ret;
-
 	snprintf(priv->phy_name, sizeof(priv->phy_name), PHY_ID_FMT,
 		 priv->mdio->id, priv->phy_addr);
 
@@ -715,6 +707,12 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 	struct asix_common_private *priv;
 	int ret, i;
 
+	priv = devm_kzalloc(&dev->udev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	dev->driver_priv = priv;
+
 	usbnet_get_endpoints(dev, intf);
 
 	/* Maybe the boot loader passed the MAC address via device tree */
@@ -750,6 +748,13 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->net->needed_headroom = 4; /* cf asix_tx_fixup() */
 	dev->net->needed_tailroom = 4; /* cf asix_tx_fixup() */
 
+	ret = asix_read_phy_addr(dev, true);
+	if (ret < 0)
+		return ret;
+
+	priv->phy_addr = ret;
+	priv->embd_phy = ((priv->phy_addr & 0x1f) == 0x10 ? true : false);
+
 	asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG, 0, 0, 1, &chipcode, 0);
 	chipcode &= AX_CHIPCODE_MASK;
 
@@ -768,12 +773,6 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 		dev->rx_urb_size = 2048;
 	}
 
-	priv = devm_kzalloc(&dev->udev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
-	dev->driver_priv = priv;
-
 	priv->presvd_phy_bmcr = 0;
 	priv->presvd_phy_advertise = 0;
 	if (chipcode == AX_AX88772_CHIPCODE) {
-- 
2.30.2


--bp/iNruPH9dso1Pn--
