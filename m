Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3736406DD4
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 16:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbhIJPAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 11:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbhIJPAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 11:00:07 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88796C061574;
        Fri, 10 Sep 2021 07:58:56 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id n27so4831638eja.5;
        Fri, 10 Sep 2021 07:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z1CND2OXjCM9w4Bbe0hpLv3pAGa/ruusstAiL0Ducb0=;
        b=SwIcUEZ7uroXfuQhtKj6ZrAJNG7oBiNWdgE43NPHPb+E1JUEwhEPB9JVQ8evrPGQMQ
         /ew1F6wU/ihEXOyIpckK88GTY0h9F9acUriFqGm65s8vqkX32cZCa6vJOpIUV76tAkMd
         mK/tDDl2pIeo0w8rBUIEhm72xWca4uzFDh0zFijYrb1sE8wY+5XtpuELEIc79CERsZM/
         6RLpVaR/zK36v0NFzPPkmgiTCji6ZbvGbuhmN7hPvNYItRreSiuCOm74bWM3tYyaGsQO
         2gdhoIZyojxlyLqas9CWF/1ifwSuI5dhu/ynd02F8Q22TtCKbxmvDTcqTgfBo4IsYd1S
         Dytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z1CND2OXjCM9w4Bbe0hpLv3pAGa/ruusstAiL0Ducb0=;
        b=VxPg9YuPCRdWDZUb9PHVm43UCDyohxCnJ7QRZ3xtUcsHlpPAJMWMAHOyUra2Gy1A2s
         UmEKA7gxQ0Zc95gdnqp5beoepsREnacVSDs1w1EI1/lHiwmTG8WcyGuEcTLiWmiLLAci
         2RGyBsD7mL2ultPo9rsQjXz+kmfDfaxS8xXZlhuFs2OZtcWoRlmnVRkH70l9HUI448ZL
         1rNmkiZdKJK8Muou0uBAlRBBueCC1hOlGG9tBEv9KppWsBL0AfizyMgpilXC0JNBMkRE
         Pvx8iO6U5J46rUlEaDrP80fw+e2mlK7WTYn0wkZizk1s/P1MRi1LwJoKwmeumi86G4hq
         Xh9g==
X-Gm-Message-State: AOAM533XZVPCs7Tt6dWl79enoDuoUG4VRSAXyoqzmLqKPl7z265ZUvF9
        wTgtuIJCU14M9uwcpVUrSj8uWWOqMXqlQg==
X-Google-Smtp-Source: ABdhPJxkXuUgRssi4VbUTfVE4sbbV/cX9TjK7HEGXrzWQMfR6kJnU6cVuFW8s/SnmXo5jNBUDQKqGw==
X-Received: by 2002:a17:906:6547:: with SMTP id u7mr9602869ejn.544.1631285935068;
        Fri, 10 Sep 2021 07:58:55 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id e19sm2507575eja.48.2021.09.10.07.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 07:58:54 -0700 (PDT)
Date:   Fri, 10 Sep 2021 17:58:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, p.rosenberger@kunbus.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Message-ID: <20210910145852.4te2zjkchnajb3qw@skbuf>
References: <20210909114248.aijujvl7xypkh7qe@skbuf>
 <20210909125606.giiqvil56jse4bjk@skbuf>
 <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
 <20210909154734.ujfnzu6omcjuch2a@skbuf>
 <8498b0ce-99bb-aef9-05e1-d359f1cad6cf@gmx.de>
 <2b316d9f-1249-9008-2901-4ab3128eed81@gmail.com>
 <5b899bb3-ed37-19ae-8856-3dabce534cc6@gmx.de>
 <20210909225457.figd5e5o3yw76mcs@skbuf>
 <35466c02-16da-0305-6d53-1c3bbf326418@gmail.com>
 <YTtG3NbYjUbu4jJE@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3n3ubyh3w3apufpu"
Content-Disposition: inline
In-Reply-To: <YTtG3NbYjUbu4jJE@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3n3ubyh3w3apufpu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 10, 2021 at 01:51:56PM +0200, Andrew Lunn wrote:
> > It does not really scale but we also don't have that many DSA masters to
> > support, I believe I can name them all: bcmgenet, stmmac, bcmsysport, enetc,
> > mv643xx_eth, cpsw, macb.
> 
> fec, mvneta, mvpp2, i210/igb.

I can probably double that list only with Freescale/NXP Ethernet
drivers, some of which are not even submitted to mainline. To name some
mainline drivers: gianfar, dpaa-eth, dpaa2-eth, dpaa2-switch, ucc_geth.
Also consider that DSA/switchdev drivers can also be DSA masters of
their own, we have boards doing that too.

Anyway, I've decided to at least try and accept the fact that DSA
masters will unregister their net_device on shutdown, and attempt to do
something sane for all DSA switches in that case.

Attached are two patches (they are fairly big so I won't paste them
inline, and I would like initial feedback before posting them to the
list).

As mentioned in those patches, the shutdown ordering guarantee is still
very important, I still have no clue what goes on there, what we need to
do, etc.

--3n3ubyh3w3apufpu
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-net-mdio-introduce-a-shutdown-method-to-mdio-device-.patch"

From 6cf2bf18535cd11da5168fa574061b2064a7b40a Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Fri, 10 Sep 2021 03:13:39 +0300
Subject: [RFC PATCH net 1/2] net: mdio: introduce a shutdown method to mdio
 device drivers

MDIO devices might have interrupts and other things that might need
quiesced when we kexec into a new kernel. Things are even more creepy
when those interrupt lines are shared, and in that case it is absolutely
mandatory to disable all interrupt sources.

Moreover, MDIO devices might be DSA switches, and DSA needs its own
shutdown method to unlink from the DSA master.

So introduce a ->shutdown method in the MDIO device driver structure.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/mdio_device.c | 11 +++++++++++
 include/linux/mdio.h          |  3 +++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index c94cb5382dc9..250742ffdfd9 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -179,6 +179,16 @@ static int mdio_remove(struct device *dev)
 	return 0;
 }
 
+static void mdio_shutdown(struct device *dev)
+{
+	struct mdio_device *mdiodev = to_mdio_device(dev);
+	struct device_driver *drv = mdiodev->dev.driver;
+	struct mdio_driver *mdiodrv = to_mdio_driver(drv);
+
+	if (mdiodrv->shutdown)
+		mdiodrv->shutdown(mdiodev);
+}
+
 /**
  * mdio_driver_register - register an mdio_driver with the MDIO layer
  * @drv: new mdio_driver to register
@@ -193,6 +203,7 @@ int mdio_driver_register(struct mdio_driver *drv)
 	mdiodrv->driver.bus = &mdio_bus_type;
 	mdiodrv->driver.probe = mdio_probe;
 	mdiodrv->driver.remove = mdio_remove;
+	mdiodrv->driver.shutdown = mdio_shutdown;
 
 	retval = driver_register(&mdiodrv->driver);
 	if (retval) {
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index ffb787d5ebde..5e6dc38f418e 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -80,6 +80,9 @@ struct mdio_driver {
 
 	/* Clears up any memory if needed */
 	void (*remove)(struct mdio_device *mdiodev);
+
+	/* Quiesces the device on system shutdown, turns off interrupts etc */
+	void (*shutdown)(struct mdio_device *mdiodev);
 };
 
 static inline struct mdio_driver *
-- 
2.25.1


--3n3ubyh3w3apufpu
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-net-dsa-implement-a-shutdown-procedure-and-call-it-f.patch"

From 5458da3f6a3db71d0bb77dec5cac6e53ca9a14c6 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Fri, 10 Sep 2021 03:13:18 +0300
Subject: [RFC PATCH net 2/2] net: dsa: implement a shutdown procedure and call
 it from all drivers

Lino reports that on his system with bcmgenet as DSA master and KSZ9897
as a switch, rebooting or shutting down never works properly.

This message can be seen in a loop, and it hangs the reboot process there:

unregister_netdevice: waiting for eth0 to become free. Usage count = 3

So why 3?

A usage count of 1 is normal for a registered network interface, and any
virtual interface which links itself as an upper of that will increment
it via dev_hold. In the case of DSA, this is the call path:

dsa_slave_create
-> netdev_upper_dev_link
   -> __netdev_upper_dev_link
      -> __netdev_adjacent_dev_insert
         -> dev_hold

So a DSA switch with 3 interfaces will result in a usage count elevated
by two, and netdev_wait_allrefs will wait until they have gone away.

Other stacked interfaces, like VLAN, watch NETDEV_UNREGISTER events and
delete themselves, but DSA cannot just vanish and go poof, at most it
can unbind itself from the switch devices, but that must happen strictly
earlier compared to when the DSA master unregisters its net_device.

It seems that it is a pretty established pattern to have a driver's
->shutdown hook redirect to its ->remove hook, so the same code is
executed regardless of whether the driver is unbound from the device, or
the system is just shutting down. As Florian puts it, it is quite a big
hammer for bcmgenet to unregister its net_device during shutdown, but
having a common code path with the driver unbind helps ensure it is well
tested.

So DSA, for better or for worse, has to live with that and engage in an
arms race of implementing the ->shutdown hook too, from all individual
drivers, and do something sane when paired with masters that unregister
their net_device there. The only sane thing to do, of course, is to
unlink from the master.

However, complications arise really quickly.

The pattern of redirecting ->shutdown to ->remove is not unique to
bcmgenet or even to net_device drivers. In fact, SPI controllers do it
too (see dspi_shutdown -> dspi_remove), and presumably, I2C controllers
and MDIO controllers do it too. Since DSA switches might be SPI devices,
I2C devices, MDIO devices, the insane implication is that for the exact
same DSA switch device, we might have both ->shutdown and ->remove
getting called.

So we need to do something with that insane environment. The pattern
I've come up with is "if this, then not that", so if either ->shutdown
or ->remove gets called, we set the device's drvdata to NULL, and in the
other hook, we check whether the drvdata is NULL and just do nothing.
This is probably not necessary for platform devices, just for devices on
buses, but I would really insist for consistency among drivers, because
when code is copy-pasted, it is not always copy-pasted from the best
sources.

So depending on whether the DSA switch's ->remove or ->shutdown will get
called first, we cannot really guarantee even for the same driver if
rebooting will result in the same code path on all platforms. But
nonetheless, we need to do something minimally reasonable on ->shutdown
too to fix the bug. Of course, the ->remove will do more (a full
teardown of the tree, with all data structures freed, and this is why
the bug was not caught for so long). The new ->shutdown method is kept
separate from dsa_unregister_switch not because we couldn't have
unregistered the switch, but simply in the interest of doing something
quick and to the point.

One thing I still don't know is whether the device core guarantees that
DSA's {->remove, ->shutdown} methods will be called before the master's.
We have a device_link between them, but experimentally that seems to
help only with the unbind path, not even clear if it does something on
shutdown (documentation says it does, but I don't see what).

If the device core doesn't guarantee that, then:
- the master net_device reference hasn't gone away, remember we have a
  dev_hold on it, but
- the WARN_ON in unregister_netdevice will still trigger, saying that
  unregister is attempted for an interface with uppers.

My limited testing has shown this to not happen, but obviously I
wouldn't rely on experimentation alone.

Fixes: 2f1e8ea726e9 ("net: dsa: link interfaces with the DSA master to get rid of lockdep warnings")
Link: https://lore.kernel.org/netdev/20210909095324.12978-1-LinoSanfilippo@gmx.de/
Reported-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/b53/b53_mdio.c             | 21 +++++++++-
 drivers/net/dsa/b53/b53_mmap.c             | 13 ++++++
 drivers/net/dsa/b53/b53_priv.h             |  5 +++
 drivers/net/dsa/b53/b53_spi.c              | 13 ++++++
 drivers/net/dsa/b53/b53_srab.c             | 21 +++++++++-
 drivers/net/dsa/bcm_sf2.c                  | 12 ++++++
 drivers/net/dsa/dsa_loop.c                 | 22 ++++++++++-
 drivers/net/dsa/hirschmann/hellcreek.c     | 16 ++++++++
 drivers/net/dsa/lan9303-core.c             |  6 +++
 drivers/net/dsa/lan9303.h                  |  1 +
 drivers/net/dsa/lan9303_i2c.c              | 24 +++++++++--
 drivers/net/dsa/lan9303_mdio.c             | 15 +++++++
 drivers/net/dsa/lantiq_gswip.c             | 18 +++++++++
 drivers/net/dsa/microchip/ksz8795_spi.c    | 11 +++++-
 drivers/net/dsa/microchip/ksz8863_smi.c    | 13 ++++++
 drivers/net/dsa/microchip/ksz9477_i2c.c    | 14 ++++++-
 drivers/net/dsa/microchip/ksz9477_spi.c    |  8 +++-
 drivers/net/dsa/mt7530.c                   | 18 +++++++++
 drivers/net/dsa/mv88e6060.c                | 18 +++++++++
 drivers/net/dsa/mv88e6xxx/chip.c           | 22 ++++++++++-
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 20 +++++++++-
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 20 +++++++++-
 drivers/net/dsa/qca/ar9331.c               | 18 +++++++++
 drivers/net/dsa/qca8k.c                    | 18 +++++++++
 drivers/net/dsa/realtek-smi-core.c         | 20 +++++++++-
 drivers/net/dsa/sja1105/sja1105_main.c     | 21 +++++++++-
 drivers/net/dsa/vitesse-vsc73xx-core.c     |  6 +++
 drivers/net/dsa/vitesse-vsc73xx-platform.c | 22 ++++++++++-
 drivers/net/dsa/vitesse-vsc73xx-spi.c      | 22 ++++++++++-
 drivers/net/dsa/vitesse-vsc73xx.h          |  1 +
 drivers/net/dsa/xrs700x/xrs700x.c          |  6 +++
 drivers/net/dsa/xrs700x/xrs700x.h          |  1 +
 drivers/net/dsa/xrs700x/xrs700x_i2c.c      | 18 +++++++++
 drivers/net/dsa/xrs700x/xrs700x_mdio.c     | 18 +++++++++
 include/net/dsa.h                          |  1 +
 net/dsa/dsa2.c                             | 46 ++++++++++++++++++++++
 36 files changed, 525 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_mdio.c b/drivers/net/dsa/b53/b53_mdio.c
index a533a90e3904..a7aeb3c132c9 100644
--- a/drivers/net/dsa/b53/b53_mdio.c
+++ b/drivers/net/dsa/b53/b53_mdio.c
@@ -351,9 +351,25 @@ static int b53_mdio_probe(struct mdio_device *mdiodev)
 static void b53_mdio_remove(struct mdio_device *mdiodev)
 {
 	struct b53_device *dev = dev_get_drvdata(&mdiodev->dev);
-	struct dsa_switch *ds = dev->ds;
 
-	dsa_unregister_switch(ds);
+	if (!dev)
+		return;
+
+	b53_switch_remove(dev);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
+}
+
+static void b53_mdio_shutdown(struct mdio_device *mdiodev)
+{
+	struct b53_device *dev = dev_get_drvdata(&mdiodev->dev);
+
+	if (!dev)
+		return;
+
+	b53_switch_shutdown(dev);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
 }
 
 static const struct of_device_id b53_of_match[] = {
@@ -373,6 +389,7 @@ MODULE_DEVICE_TABLE(of, b53_of_match);
 static struct mdio_driver b53_mdio_driver = {
 	.probe	= b53_mdio_probe,
 	.remove	= b53_mdio_remove,
+	.shutdown = b53_mdio_shutdown,
 	.mdiodrv.driver = {
 		.name = "bcm53xx",
 		.of_match_table = b53_of_match,
diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
index 82680e083cc2..62ea45f492f3 100644
--- a/drivers/net/dsa/b53/b53_mmap.c
+++ b/drivers/net/dsa/b53/b53_mmap.c
@@ -316,9 +316,21 @@ static int b53_mmap_remove(struct platform_device *pdev)
 	if (dev)
 		b53_switch_remove(dev);
 
+	platform_set_drvdata(pdev, NULL);
+
 	return 0;
 }
 
+static int b53_mmap_shutdown(struct platform_device *pdev)
+{
+	struct b53_device *dev = platform_get_drvdata(pdev);
+
+	if (dev)
+		b53_switch_shutdown(dev);
+
+	platform_set_drvdata(pdev, NULL);
+}
+
 static const struct of_device_id b53_mmap_of_table[] = {
 	{ .compatible = "brcm,bcm3384-switch" },
 	{ .compatible = "brcm,bcm6328-switch" },
@@ -331,6 +343,7 @@ MODULE_DEVICE_TABLE(of, b53_mmap_of_table);
 static struct platform_driver b53_mmap_driver = {
 	.probe = b53_mmap_probe,
 	.remove = b53_mmap_remove,
+	.shutdown = b53_mmap_shutdown,
 	.driver = {
 		.name = "b53-switch",
 		.of_match_table = b53_mmap_of_table,
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 5d068acf7cf8..959a52d41f0a 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -228,6 +228,11 @@ static inline void b53_switch_remove(struct b53_device *dev)
 	dsa_unregister_switch(dev->ds);
 }
 
+static inline void b53_switch_shutdown(struct b53_device *dev)
+{
+	dsa_switch_shutdown(dev->ds);
+}
+
 #define b53_build_op(type_op_size, val_type)				\
 static inline int b53_##type_op_size(struct b53_device *dev, u8 page,	\
 				     u8 reg, val_type val)		\
diff --git a/drivers/net/dsa/b53/b53_spi.c b/drivers/net/dsa/b53/b53_spi.c
index ecb9f7f6b335..01e37b75471e 100644
--- a/drivers/net/dsa/b53/b53_spi.c
+++ b/drivers/net/dsa/b53/b53_spi.c
@@ -321,9 +321,21 @@ static int b53_spi_remove(struct spi_device *spi)
 	if (dev)
 		b53_switch_remove(dev);
 
+	spi_set_drvdata(spi, NULL);
+
 	return 0;
 }
 
+static void b53_spi_shutdown(struct spi_device *spi)
+{
+	struct b53_device *dev = spi_get_drvdata(spi);
+
+	if (dev)
+		b53_switch_shutdown(dev);
+
+	spi_set_drvdata(spi, NULL);
+}
+
 static const struct of_device_id b53_spi_of_match[] = {
 	{ .compatible = "brcm,bcm5325" },
 	{ .compatible = "brcm,bcm5365" },
@@ -344,6 +356,7 @@ static struct spi_driver b53_spi_driver = {
 	},
 	.probe	= b53_spi_probe,
 	.remove	= b53_spi_remove,
+	.shutdown = b53_spi_shutdown,
 };
 
 module_spi_driver(b53_spi_driver);
diff --git a/drivers/net/dsa/b53/b53_srab.c b/drivers/net/dsa/b53/b53_srab.c
index 3f4249de70c5..4591bb1c05d2 100644
--- a/drivers/net/dsa/b53/b53_srab.c
+++ b/drivers/net/dsa/b53/b53_srab.c
@@ -629,17 +629,34 @@ static int b53_srab_probe(struct platform_device *pdev)
 static int b53_srab_remove(struct platform_device *pdev)
 {
 	struct b53_device *dev = platform_get_drvdata(pdev);
-	struct b53_srab_priv *priv = dev->priv;
 
-	b53_srab_intr_set(priv, false);
+	if (!dev)
+		return 0;
+
+	b53_srab_intr_set(dev->priv, false);
 	b53_switch_remove(dev);
 
+	platform_set_drvdata(pdev, NULL);
+
 	return 0;
 }
 
+static void b53_srab_shutdown(struct platform_device *pdev)
+{
+	struct b53_device *dev = platform_get_drvdata(pdev);
+
+	if (!dev)
+		return;
+
+	b53_switch_shutdown(dev);
+
+	platform_set_drvdata(pdev, NULL);
+}
+
 static struct platform_driver b53_srab_driver = {
 	.probe = b53_srab_probe,
 	.remove = b53_srab_remove,
+	.shutdown = b53_srab_shutdown,
 	.driver = {
 		.name = "b53-srab-switch",
 		.of_match_table = b53_srab_of_match,
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 6ce9ec1283e0..520fbb56c202 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1512,6 +1512,9 @@ static int bcm_sf2_sw_remove(struct platform_device *pdev)
 {
 	struct bcm_sf2_priv *priv = platform_get_drvdata(pdev);
 
+	if (!priv)
+		return 0;
+
 	priv->wol_ports_mask = 0;
 	/* Disable interrupts */
 	bcm_sf2_intr_disable(priv);
@@ -1523,6 +1526,8 @@ static int bcm_sf2_sw_remove(struct platform_device *pdev)
 	if (priv->type == BCM7278_DEVICE_ID)
 		reset_control_assert(priv->rcdev);
 
+	platform_set_drvdata(pdev, NULL);
+
 	return 0;
 }
 
@@ -1530,6 +1535,9 @@ static void bcm_sf2_sw_shutdown(struct platform_device *pdev)
 {
 	struct bcm_sf2_priv *priv = platform_get_drvdata(pdev);
 
+	if (!priv)
+		return;
+
 	/* For a kernel about to be kexec'd we want to keep the GPHY on for a
 	 * successful MDIO bus scan to occur. If we did turn off the GPHY
 	 * before (e.g: port_disable), this will also power it back on.
@@ -1538,6 +1546,10 @@ static void bcm_sf2_sw_shutdown(struct platform_device *pdev)
 	 */
 	if (priv->hw_params.num_gphy == 1)
 		bcm_sf2_gphy_enable_set(priv->dev->ds, true);
+
+	dsa_switch_shutdown(priv->dev->ds);
+
+	platform_set_drvdata(pdev, NULL);
 }
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index bfdf3324aac3..e638e3eea911 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -340,10 +340,29 @@ static int dsa_loop_drv_probe(struct mdio_device *mdiodev)
 static void dsa_loop_drv_remove(struct mdio_device *mdiodev)
 {
 	struct dsa_switch *ds = dev_get_drvdata(&mdiodev->dev);
-	struct dsa_loop_priv *ps = ds->priv;
+	struct dsa_loop_priv *ps;
+
+	if (!ds)
+		return;
+
+	ps = ds->priv;
 
 	dsa_unregister_switch(ds);
 	dev_put(ps->netdev);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
+}
+
+static void dsa_loop_drv_shutdown(struct mdio_device *mdiodev)
+{
+	struct dsa_switch *ds = dev_get_drvdata(&mdiodev->dev);
+
+	if (!ds)
+		return;
+
+	dsa_switch_shutdown(ds);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
 }
 
 static struct mdio_driver dsa_loop_drv = {
@@ -352,6 +371,7 @@ static struct mdio_driver dsa_loop_drv = {
 	},
 	.probe	= dsa_loop_drv_probe,
 	.remove	= dsa_loop_drv_remove,
+	.shutdown = dsa_loop_drv_shutdown,
 };
 
 #define NUM_FIXED_PHYS	(DSA_LOOP_NUM_PORTS - 2)
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 542cfc4ccb08..354655f9ed00 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1916,6 +1916,9 @@ static int hellcreek_remove(struct platform_device *pdev)
 {
 	struct hellcreek *hellcreek = platform_get_drvdata(pdev);
 
+	if (!hellcreek)
+		return 0;
+
 	hellcreek_hwtstamp_free(hellcreek);
 	hellcreek_ptp_free(hellcreek);
 	dsa_unregister_switch(hellcreek->ds);
@@ -1924,6 +1927,18 @@ static int hellcreek_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void hellcreek_shutdown(struct platform_device *pdev)
+{
+	struct hellcreek *hellcreek = platform_get_drvdata(pdev);
+
+	if (!hellcreek)
+		return;
+
+	dsa_switch_shutdown(hellcreek->ds);
+
+	platform_set_drvdata(pdev, NULL);
+}
+
 static const struct hellcreek_platform_data de1soc_r1_pdata = {
 	.name		 = "r4c30",
 	.num_ports	 = 4,
@@ -1946,6 +1961,7 @@ MODULE_DEVICE_TABLE(of, hellcreek_of_match);
 static struct platform_driver hellcreek_driver = {
 	.probe	= hellcreek_probe,
 	.remove = hellcreek_remove,
+	.shutdown = hellcreek_shutdown,
 	.driver = {
 		.name = "hellcreek",
 		.of_match_table = hellcreek_of_match,
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index d7ce281570b5..89f920289ae2 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1379,6 +1379,12 @@ int lan9303_remove(struct lan9303 *chip)
 }
 EXPORT_SYMBOL(lan9303_remove);
 
+void lan9303_shutdown(struct lan9303 *chip)
+{
+	dsa_switch_shutdown(chip->ds);
+}
+EXPORT_SYMBOL(lan9303_shutdown);
+
 MODULE_AUTHOR("Juergen Borleis <kernel@pengutronix.de>");
 MODULE_DESCRIPTION("Core driver for SMSC/Microchip LAN9303 three port ethernet switch");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/dsa/lan9303.h b/drivers/net/dsa/lan9303.h
index 11f590b64701..c7f73efa50f0 100644
--- a/drivers/net/dsa/lan9303.h
+++ b/drivers/net/dsa/lan9303.h
@@ -10,3 +10,4 @@ extern const struct lan9303_phy_ops lan9303_indirect_phy_ops;
 
 int lan9303_probe(struct lan9303 *chip, struct device_node *np);
 int lan9303_remove(struct lan9303 *chip);
+void lan9303_shutdown(struct lan9303 *chip);
diff --git a/drivers/net/dsa/lan9303_i2c.c b/drivers/net/dsa/lan9303_i2c.c
index 9bffaef65a04..8ca4713310fa 100644
--- a/drivers/net/dsa/lan9303_i2c.c
+++ b/drivers/net/dsa/lan9303_i2c.c
@@ -67,13 +67,28 @@ static int lan9303_i2c_probe(struct i2c_client *client,
 
 static int lan9303_i2c_remove(struct i2c_client *client)
 {
-	struct lan9303_i2c *sw_dev;
+	struct lan9303_i2c *sw_dev = i2c_get_clientdata(client);
 
-	sw_dev = i2c_get_clientdata(client);
 	if (!sw_dev)
-		return -ENODEV;
+		return 0;
+
+	lan9303_remove(&sw_dev->chip);
+
+	i2c_set_clientdata(client, NULL);
+
+	return 0;
+}
+
+static void lan9303_i2c_shutdown(struct i2c_client *client)
+{
+	struct lan9303_i2c *sw_dev = i2c_get_clientdata(client);
+
+	if (!sw_dev)
+		return;
+
+	lan9303_shutdown(&sw_dev->chip);
 
-	return lan9303_remove(&sw_dev->chip);
+	i2c_set_clientdata(client, NULL);
 }
 
 /*-------------------------------------------------------------------------*/
@@ -97,6 +112,7 @@ static struct i2c_driver lan9303_i2c_driver = {
 	},
 	.probe = lan9303_i2c_probe,
 	.remove = lan9303_i2c_remove,
+	.shutdown = lan9303_i2c_shutdown,
 	.id_table = lan9303_i2c_id,
 };
 module_i2c_driver(lan9303_i2c_driver);
diff --git a/drivers/net/dsa/lan9303_mdio.c b/drivers/net/dsa/lan9303_mdio.c
index 9cbe80460b53..bbb7032409ba 100644
--- a/drivers/net/dsa/lan9303_mdio.c
+++ b/drivers/net/dsa/lan9303_mdio.c
@@ -138,6 +138,20 @@ static void lan9303_mdio_remove(struct mdio_device *mdiodev)
 		return;
 
 	lan9303_remove(&sw_dev->chip);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
+}
+
+static void lan9303_mdio_shutdown(struct mdio_device *mdiodev)
+{
+	struct lan9303_mdio *sw_dev = dev_get_drvdata(&mdiodev->dev);
+
+	if (!sw_dev)
+		return;
+
+	lan9303_shutdown(&sw_dev->chip);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
 }
 
 /*-------------------------------------------------------------------------*/
@@ -155,6 +169,7 @@ static struct mdio_driver lan9303_mdio_driver = {
 	},
 	.probe  = lan9303_mdio_probe,
 	.remove = lan9303_mdio_remove,
+	.shutdown = lan9303_mdio_shutdown,
 };
 mdio_module_driver(lan9303_mdio_driver);
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 64d6dfa83122..6d8ca3613a42 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -2178,6 +2178,9 @@ static int gswip_remove(struct platform_device *pdev)
 	struct gswip_priv *priv = platform_get_drvdata(pdev);
 	int i;
 
+	if (!priv)
+		return 0;
+
 	/* disable the switch */
 	gswip_mdio_mask(priv, GSWIP_MDIO_GLOB_ENABLE, 0, GSWIP_MDIO_GLOB);
 
@@ -2191,9 +2194,23 @@ static int gswip_remove(struct platform_device *pdev)
 	for (i = 0; i < priv->num_gphy_fw; i++)
 		gswip_gphy_fw_remove(priv, &priv->gphy_fw[i]);
 
+	platform_set_drvdata(pdev, NULL);
+
 	return 0;
 }
 
+static void gswip_shutdown(struct platform_device *pdev)
+{
+	struct gswip_priv *priv = platform_get_drvdata(pdev);
+
+	if (!priv)
+		return;
+
+	dsa_switch_shutdown(priv->ds);
+
+	platform_set_drvdata(pdev, NULL);
+}
+
 static const struct gswip_hw_info gswip_xrx200 = {
 	.max_ports = 7,
 	.cpu_port = 6,
@@ -2217,6 +2234,7 @@ MODULE_DEVICE_TABLE(of, gswip_of_match);
 static struct platform_driver gswip_driver = {
 	.probe = gswip_probe,
 	.remove = gswip_remove,
+	.shutdown = gswip_shutdown,
 	.driver = {
 		.name = "gswip",
 		.of_match_table = gswip_of_match,
diff --git a/drivers/net/dsa/microchip/ksz8795_spi.c b/drivers/net/dsa/microchip/ksz8795_spi.c
index ea7550d1b634..866767b70d65 100644
--- a/drivers/net/dsa/microchip/ksz8795_spi.c
+++ b/drivers/net/dsa/microchip/ksz8795_spi.c
@@ -94,6 +94,8 @@ static int ksz8795_spi_remove(struct spi_device *spi)
 	if (dev)
 		ksz_switch_remove(dev);
 
+	spi_set_drvdata(spi, NULL);
+
 	return 0;
 }
 
@@ -101,8 +103,15 @@ static void ksz8795_spi_shutdown(struct spi_device *spi)
 {
 	struct ksz_device *dev = spi_get_drvdata(spi);
 
-	if (dev && dev->dev_ops->shutdown)
+	if (!dev)
+		return;
+
+	if (dev->dev_ops->shutdown)
 		dev->dev_ops->shutdown(dev);
+
+	dsa_switch_shutdown(dev->ds);
+
+	spi_set_drvdata(spi, NULL);
 }
 
 static const struct of_device_id ksz8795_dt_ids[] = {
diff --git a/drivers/net/dsa/microchip/ksz8863_smi.c b/drivers/net/dsa/microchip/ksz8863_smi.c
index 11293485138c..5883fa7edda2 100644
--- a/drivers/net/dsa/microchip/ksz8863_smi.c
+++ b/drivers/net/dsa/microchip/ksz8863_smi.c
@@ -191,6 +191,18 @@ static void ksz8863_smi_remove(struct mdio_device *mdiodev)
 
 	if (dev)
 		ksz_switch_remove(dev);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
+}
+
+static void ksz8863_smi_shutdown(struct mdio_device *mdiodev)
+{
+	struct ksz_device *dev = dev_get_drvdata(&mdiodev->dev);
+
+	if (dev)
+		dsa_switch_shutdown(dev->ds);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
 }
 
 static const struct of_device_id ksz8863_dt_ids[] = {
@@ -203,6 +215,7 @@ MODULE_DEVICE_TABLE(of, ksz8863_dt_ids);
 static struct mdio_driver ksz8863_driver = {
 	.probe	= ksz8863_smi_probe,
 	.remove	= ksz8863_smi_remove,
+	.shutdown = ksz8863_smi_shutdown,
 	.mdiodrv.driver = {
 		.name	= "ksz8863-switch",
 		.of_match_table = ksz8863_dt_ids,
diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index 4e053a25d077..f3afb8b8c4cc 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -56,7 +56,10 @@ static int ksz9477_i2c_remove(struct i2c_client *i2c)
 {
 	struct ksz_device *dev = i2c_get_clientdata(i2c);
 
-	ksz_switch_remove(dev);
+	if (dev)
+		ksz_switch_remove(dev);
+
+	i2c_set_clientdata(i2c, NULL);
 
 	return 0;
 }
@@ -65,8 +68,15 @@ static void ksz9477_i2c_shutdown(struct i2c_client *i2c)
 {
 	struct ksz_device *dev = i2c_get_clientdata(i2c);
 
-	if (dev && dev->dev_ops->shutdown)
+	if (!dev)
+		return;
+
+	if (dev->dev_ops->shutdown)
 		dev->dev_ops->shutdown(dev);
+
+	dsa_switch_shutdown(dev->ds);
+
+	i2c_set_clientdata(i2c, NULL);
 }
 
 static const struct i2c_device_id ksz9477_i2c_id[] = {
diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index 15bc11b3cda4..e3cb0e6c9f6f 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -72,6 +72,8 @@ static int ksz9477_spi_remove(struct spi_device *spi)
 	if (dev)
 		ksz_switch_remove(dev);
 
+	spi_set_drvdata(spi, NULL);
+
 	return 0;
 }
 
@@ -79,8 +81,10 @@ static void ksz9477_spi_shutdown(struct spi_device *spi)
 {
 	struct ksz_device *dev = spi_get_drvdata(spi);
 
-	if (dev && dev->dev_ops->shutdown)
-		dev->dev_ops->shutdown(dev);
+	if (dev)
+		dsa_switch_shutdown(dev->ds);
+
+	spi_set_drvdata(spi, NULL);
 }
 
 static const struct of_device_id ksz9477_dt_ids[] = {
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index d0cba2d1cd68..094737e5084a 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -3286,6 +3286,9 @@ mt7530_remove(struct mdio_device *mdiodev)
 	struct mt7530_priv *priv = dev_get_drvdata(&mdiodev->dev);
 	int ret = 0;
 
+	if (!priv)
+		return;
+
 	ret = regulator_disable(priv->core_pwr);
 	if (ret < 0)
 		dev_err(priv->dev,
@@ -3301,11 +3304,26 @@ mt7530_remove(struct mdio_device *mdiodev)
 
 	dsa_unregister_switch(priv->ds);
 	mutex_destroy(&priv->reg_mutex);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
+}
+
+static void mt7530_shutdown(struct mdio_device *mdiodev)
+{
+	struct mt7530_priv *priv = dev_get_drvdata(&mdiodev->dev);
+
+	if (!priv)
+		return;
+
+	dsa_switch_shutdown(priv->ds);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
 }
 
 static struct mdio_driver mt7530_mdio_driver = {
 	.probe  = mt7530_probe,
 	.remove = mt7530_remove,
+	.shutdown = mt7530_shutdown,
 	.mdiodrv.driver = {
 		.name = "mt7530",
 		.of_match_table = mt7530_of_match,
diff --git a/drivers/net/dsa/mv88e6060.c b/drivers/net/dsa/mv88e6060.c
index 24b8219fd607..a4c6eb9a52d0 100644
--- a/drivers/net/dsa/mv88e6060.c
+++ b/drivers/net/dsa/mv88e6060.c
@@ -290,7 +290,24 @@ static void mv88e6060_remove(struct mdio_device *mdiodev)
 {
 	struct dsa_switch *ds = dev_get_drvdata(&mdiodev->dev);
 
+	if (!ds)
+		return;
+
 	dsa_unregister_switch(ds);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
+}
+
+static void mv88e6060_shutdown(struct mdio_device *mdiodev)
+{
+	struct dsa_switch *ds = dev_get_drvdata(&mdiodev->dev);
+
+	if (!ds)
+		return;
+
+	dsa_switch_shutdown(ds);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
 }
 
 static const struct of_device_id mv88e6060_of_match[] = {
@@ -303,6 +320,7 @@ static const struct of_device_id mv88e6060_of_match[] = {
 static struct mdio_driver mv88e6060_driver = {
 	.probe	= mv88e6060_probe,
 	.remove = mv88e6060_remove,
+	.shutdown = mv88e6060_shutdown,
 	.mdiodrv.driver = {
 		.name = "mv88e6060",
 		.of_match_table = mv88e6060_of_match,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c45ca2473743..fb10422d2c33 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6389,7 +6389,12 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 static void mv88e6xxx_remove(struct mdio_device *mdiodev)
 {
 	struct dsa_switch *ds = dev_get_drvdata(&mdiodev->dev);
-	struct mv88e6xxx_chip *chip = ds->priv;
+	struct mv88e6xxx_chip *chip;
+
+	if (!ds)
+		return;
+
+	chip = ds->priv;
 
 	if (chip->info->ptp_support) {
 		mv88e6xxx_hwtstamp_free(chip);
@@ -6410,6 +6415,20 @@ static void mv88e6xxx_remove(struct mdio_device *mdiodev)
 		mv88e6xxx_g1_irq_free(chip);
 	else
 		mv88e6xxx_irq_poll_free(chip);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
+}
+
+static void mv88e6xxx_shutdown(struct mdio_device *mdiodev)
+{
+	struct dsa_switch *ds = dev_get_drvdata(&mdiodev->dev);
+
+	if (!ds)
+		return;
+
+	dsa_switch_shutdown(ds);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
 }
 
 static const struct of_device_id mv88e6xxx_of_match[] = {
@@ -6433,6 +6452,7 @@ MODULE_DEVICE_TABLE(of, mv88e6xxx_of_match);
 static struct mdio_driver mv88e6xxx_driver = {
 	.probe	= mv88e6xxx_probe,
 	.remove = mv88e6xxx_remove,
+	.shutdown = mv88e6xxx_shutdown,
 	.mdiodrv.driver = {
 		.name = "mv88e6085",
 		.of_match_table = mv88e6xxx_of_match,
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index f966a253d1c7..75823c6323ad 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1472,9 +1472,10 @@ static int felix_pci_probe(struct pci_dev *pdev,
 
 static void felix_pci_remove(struct pci_dev *pdev)
 {
-	struct felix *felix;
+	struct felix *felix = pci_get_drvdata(pdev);
 
-	felix = pci_get_drvdata(pdev);
+	if (!felix)
+		return;
 
 	dsa_unregister_switch(felix->ds);
 
@@ -1482,6 +1483,20 @@ static void felix_pci_remove(struct pci_dev *pdev)
 	kfree(felix);
 
 	pci_disable_device(pdev);
+
+	pci_set_drvdata(pdev, NULL);
+}
+
+static void felix_pci_shutdown(struct pci_dev *pdev)
+{
+	struct felix *felix = pci_get_drvdata(pdev);
+
+	if (!felix)
+		return;
+
+	dsa_switch_shutdown(felix->ds);
+
+	pci_set_drvdata(pdev, NULL);
 }
 
 static struct pci_device_id felix_ids[] = {
@@ -1498,6 +1513,7 @@ static struct pci_driver felix_vsc9959_pci_driver = {
 	.id_table	= felix_ids,
 	.probe		= felix_pci_probe,
 	.remove		= felix_pci_remove,
+	.shutdown	= felix_pci_shutdown,
 };
 module_pci_driver(felix_vsc9959_pci_driver);
 
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index deae923c8b7a..de1d34a1f1e4 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1245,18 +1245,33 @@ static int seville_probe(struct platform_device *pdev)
 
 static int seville_remove(struct platform_device *pdev)
 {
-	struct felix *felix;
+	struct felix *felix = platform_get_drvdata(pdev);
 
-	felix = platform_get_drvdata(pdev);
+	if (!felix)
+		return 0;
 
 	dsa_unregister_switch(felix->ds);
 
 	kfree(felix->ds);
 	kfree(felix);
 
+	platform_set_drvdata(pdev, NULL);
+
 	return 0;
 }
 
+static void seville_shutdown(struct platform_device *pdev)
+{
+	struct felix *felix = platform_get_drvdata(pdev);
+
+	if (!felix)
+		return;
+
+	dsa_switch_shutdown(felix->ds);
+
+	platform_set_drvdata(pdev, NULL);
+}
+
 static const struct of_device_id seville_of_match[] = {
 	{ .compatible = "mscc,vsc9953-switch" },
 	{ },
@@ -1266,6 +1281,7 @@ MODULE_DEVICE_TABLE(of, seville_of_match);
 static struct platform_driver seville_vsc9953_driver = {
 	.probe		= seville_probe,
 	.remove		= seville_remove,
+	.shutdown	= seville_shutdown,
 	.driver = {
 		.name		= "mscc_seville",
 		.of_match_table	= of_match_ptr(seville_of_match),
diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index 563d8a279030..a6bfb6abc51a 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -1083,6 +1083,9 @@ static void ar9331_sw_remove(struct mdio_device *mdiodev)
 	struct ar9331_sw_priv *priv = dev_get_drvdata(&mdiodev->dev);
 	unsigned int i;
 
+	if (!priv)
+		return;
+
 	for (i = 0; i < ARRAY_SIZE(priv->port); i++) {
 		struct ar9331_sw_port *port = &priv->port[i];
 
@@ -1094,6 +1097,20 @@ static void ar9331_sw_remove(struct mdio_device *mdiodev)
 	dsa_unregister_switch(&priv->ds);
 
 	reset_control_assert(priv->sw_reset);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
+}
+
+static void ar9331_sw_shutdown(struct mdio_device *mdiodev)
+{
+	struct ar9331_sw_priv *priv = dev_get_drvdata(&mdiodev->dev);
+
+	if (!priv)
+		return;
+
+	dsa_switch_shutdown(&priv->ds);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
 }
 
 static const struct of_device_id ar9331_sw_of_match[] = {
@@ -1104,6 +1121,7 @@ static const struct of_device_id ar9331_sw_of_match[] = {
 static struct mdio_driver ar9331_sw_mdio_driver = {
 	.probe = ar9331_sw_probe,
 	.remove = ar9331_sw_remove,
+	.shutdown = ar9331_sw_shutdown,
 	.mdiodrv.driver = {
 		.name = AR9331_SW_NAME,
 		.of_match_table = ar9331_sw_of_match,
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 1f63f50f73f1..a7ae9d0ae29b 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1866,10 +1866,27 @@ qca8k_sw_remove(struct mdio_device *mdiodev)
 	struct qca8k_priv *priv = dev_get_drvdata(&mdiodev->dev);
 	int i;
 
+	if (!priv)
+		return;
+
 	for (i = 0; i < QCA8K_NUM_PORTS; i++)
 		qca8k_port_set_status(priv, i, 0);
 
 	dsa_unregister_switch(priv->ds);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
+}
+
+static void qca8k_sw_shutdown(struct mdio_device *mdiodev)
+{
+	struct qca8k_priv *priv = dev_get_drvdata(&mdiodev->dev);
+
+	if (!priv)
+		return;
+
+	dsa_switch_shutdown(priv->ds);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -1926,6 +1943,7 @@ static const struct of_device_id qca8k_of_match[] = {
 static struct mdio_driver qca8kmdio_driver = {
 	.probe  = qca8k_sw_probe,
 	.remove = qca8k_sw_remove,
+	.shutdown = qca8k_sw_shutdown,
 	.mdiodrv.driver = {
 		.name = "qca8k",
 		.of_match_table = qca8k_of_match,
diff --git a/drivers/net/dsa/realtek-smi-core.c b/drivers/net/dsa/realtek-smi-core.c
index 8e49d4f85d48..dd2f0d6208b3 100644
--- a/drivers/net/dsa/realtek-smi-core.c
+++ b/drivers/net/dsa/realtek-smi-core.c
@@ -464,16 +464,33 @@ static int realtek_smi_probe(struct platform_device *pdev)
 
 static int realtek_smi_remove(struct platform_device *pdev)
 {
-	struct realtek_smi *smi = dev_get_drvdata(&pdev->dev);
+	struct realtek_smi *smi = platform_get_drvdata(pdev);
+
+	if (!smi)
+		return 0;
 
 	dsa_unregister_switch(smi->ds);
 	if (smi->slave_mii_bus)
 		of_node_put(smi->slave_mii_bus->dev.of_node);
 	gpiod_set_value(smi->reset, 1);
 
+	platform_set_drvdata(pdev, NULL);
+
 	return 0;
 }
 
+static void realtek_smi_shutdown(struct platform_device *pdev)
+{
+	struct realtek_smi *smi = platform_get_drvdata(pdev);
+
+	if (!smi)
+		return;
+
+	dsa_switch_shutdown(smi->ds);
+
+	platform_set_drvdata(pdev, NULL);
+}
+
 static const struct of_device_id realtek_smi_of_match[] = {
 	{
 		.compatible = "realtek,rtl8366rb",
@@ -495,6 +512,7 @@ static struct platform_driver realtek_smi_driver = {
 	},
 	.probe  = realtek_smi_probe,
 	.remove = realtek_smi_remove,
+	.shutdown = realtek_smi_shutdown,
 };
 module_platform_driver(realtek_smi_driver);
 
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 2f8cc6686c38..7c0db80eff00 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3335,13 +3335,29 @@ static int sja1105_probe(struct spi_device *spi)
 static int sja1105_remove(struct spi_device *spi)
 {
 	struct sja1105_private *priv = spi_get_drvdata(spi);
-	struct dsa_switch *ds = priv->ds;
 
-	dsa_unregister_switch(ds);
+	if (!priv)
+		return 0;
+
+	dsa_unregister_switch(priv->ds);
+
+	spi_set_drvdata(spi, NULL);
 
 	return 0;
 }
 
+static void sja1105_shutdown(struct spi_device *spi)
+{
+	struct sja1105_private *priv = spi_get_drvdata(spi);
+
+	if (!priv)
+		return;
+
+	dsa_switch_shutdown(priv->ds);
+
+	spi_set_drvdata(spi, NULL);
+}
+
 static const struct of_device_id sja1105_dt_ids[] = {
 	{ .compatible = "nxp,sja1105e", .data = &sja1105e_info },
 	{ .compatible = "nxp,sja1105t", .data = &sja1105t_info },
@@ -3365,6 +3381,7 @@ static struct spi_driver sja1105_driver = {
 	},
 	.probe  = sja1105_probe,
 	.remove = sja1105_remove,
+	.shutdown = sja1105_shutdown,
 };
 
 module_spi_driver(sja1105_driver);
diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index 19ce4aa0973b..a4b1447ff055 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -1225,6 +1225,12 @@ int vsc73xx_remove(struct vsc73xx *vsc)
 }
 EXPORT_SYMBOL(vsc73xx_remove);
 
+void vsc73xx_shutdown(struct vsc73xx *vsc)
+{
+	dsa_switch_shutdown(vsc->ds);
+}
+EXPORT_SYMBOL(vsc73xx_shutdown);
+
 MODULE_AUTHOR("Linus Walleij <linus.walleij@linaro.org>");
 MODULE_DESCRIPTION("Vitesse VSC7385/7388/7395/7398 driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/dsa/vitesse-vsc73xx-platform.c b/drivers/net/dsa/vitesse-vsc73xx-platform.c
index 2a57f337b2a2..fe4b154a0a57 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-platform.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-platform.c
@@ -116,7 +116,26 @@ static int vsc73xx_platform_remove(struct platform_device *pdev)
 {
 	struct vsc73xx_platform *vsc_platform = platform_get_drvdata(pdev);
 
-	return vsc73xx_remove(&vsc_platform->vsc);
+	if (!vsc_platform)
+		return 0;
+
+	vsc73xx_remove(&vsc_platform->vsc);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static void vsc73xx_platform_shutdown(struct platform_device *pdev)
+{
+	struct vsc73xx_platform *vsc_platform = platform_get_drvdata(pdev);
+
+	if (!vsc_platform)
+		return;
+
+	vsc73xx_shutdown(&vsc_platform->vsc);
+
+	platform_set_drvdata(pdev, NULL);
 }
 
 static const struct vsc73xx_ops vsc73xx_platform_ops = {
@@ -144,6 +163,7 @@ MODULE_DEVICE_TABLE(of, vsc73xx_of_match);
 static struct platform_driver vsc73xx_platform_driver = {
 	.probe = vsc73xx_platform_probe,
 	.remove = vsc73xx_platform_remove,
+	.shutdown = vsc73xx_platform_shutdown,
 	.driver = {
 		.name = "vsc73xx-platform",
 		.of_match_table = vsc73xx_of_match,
diff --git a/drivers/net/dsa/vitesse-vsc73xx-spi.c b/drivers/net/dsa/vitesse-vsc73xx-spi.c
index 81eca4a5781d..645398901e05 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-spi.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-spi.c
@@ -163,7 +163,26 @@ static int vsc73xx_spi_remove(struct spi_device *spi)
 {
 	struct vsc73xx_spi *vsc_spi = spi_get_drvdata(spi);
 
-	return vsc73xx_remove(&vsc_spi->vsc);
+	if (!vsc_spi)
+		return 0;
+
+	vsc73xx_remove(&vsc_spi->vsc);
+
+	spi_set_drvdata(spi, NULL);
+
+	return 0;
+}
+
+static void vsc73xx_spi_shutdown(struct spi_device *spi)
+{
+	struct vsc73xx_spi *vsc_spi = spi_get_drvdata(spi);
+
+	if (!vsc_spi)
+		return;
+
+	vsc73xx_shutdown(&vsc_spi->vsc);
+
+	spi_set_drvdata(spi, NULL);
 }
 
 static const struct vsc73xx_ops vsc73xx_spi_ops = {
@@ -191,6 +210,7 @@ MODULE_DEVICE_TABLE(of, vsc73xx_of_match);
 static struct spi_driver vsc73xx_spi_driver = {
 	.probe = vsc73xx_spi_probe,
 	.remove = vsc73xx_spi_remove,
+	.shutdown = vsc73xx_spi_shutdown,
 	.driver = {
 		.name = "vsc73xx-spi",
 		.of_match_table = vsc73xx_of_match,
diff --git a/drivers/net/dsa/vitesse-vsc73xx.h b/drivers/net/dsa/vitesse-vsc73xx.h
index 7478f8d4e0a9..30b951504e65 100644
--- a/drivers/net/dsa/vitesse-vsc73xx.h
+++ b/drivers/net/dsa/vitesse-vsc73xx.h
@@ -27,3 +27,4 @@ struct vsc73xx_ops {
 int vsc73xx_is_addr_valid(u8 block, u8 subblock);
 int vsc73xx_probe(struct vsc73xx *vsc);
 int vsc73xx_remove(struct vsc73xx *vsc);
+void vsc73xx_shutdown(struct vsc73xx *vsc);
diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index 130abb0f1438..469420941054 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -822,6 +822,12 @@ void xrs700x_switch_remove(struct xrs700x *priv)
 }
 EXPORT_SYMBOL(xrs700x_switch_remove);
 
+void xrs700x_switch_shutdown(struct xrs700x *priv)
+{
+	dsa_switch_shutdown(priv->ds);
+}
+EXPORT_SYMBOL(xrs700x_switch_shutdown);
+
 MODULE_AUTHOR("George McCollister <george.mccollister@gmail.com>");
 MODULE_DESCRIPTION("Arrow SpeedChips XRS700x DSA driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/dsa/xrs700x/xrs700x.h b/drivers/net/dsa/xrs700x/xrs700x.h
index ff62cf61b091..4d58257471d2 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.h
+++ b/drivers/net/dsa/xrs700x/xrs700x.h
@@ -40,3 +40,4 @@ struct xrs700x {
 struct xrs700x *xrs700x_switch_alloc(struct device *base, void *devpriv);
 int xrs700x_switch_register(struct xrs700x *priv);
 void xrs700x_switch_remove(struct xrs700x *priv);
+void xrs700x_switch_shutdown(struct xrs700x *priv);
diff --git a/drivers/net/dsa/xrs700x/xrs700x_i2c.c b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
index 489d9385b4f0..6deae388a0d6 100644
--- a/drivers/net/dsa/xrs700x/xrs700x_i2c.c
+++ b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
@@ -109,11 +109,28 @@ static int xrs700x_i2c_remove(struct i2c_client *i2c)
 {
 	struct xrs700x *priv = i2c_get_clientdata(i2c);
 
+	if (!priv)
+		return 0;
+
 	xrs700x_switch_remove(priv);
 
+	i2c_set_clientdata(i2c, NULL);
+
 	return 0;
 }
 
+static void xrs700x_i2c_shutdown(struct i2c_client *i2c)
+{
+	struct xrs700x *priv = i2c_get_clientdata(i2c);
+
+	if (!priv)
+		return;
+
+	xrs700x_switch_shutdown(priv);
+
+	i2c_set_clientdata(i2c, NULL);
+}
+
 static const struct i2c_device_id xrs700x_i2c_id[] = {
 	{ "xrs700x-switch", 0 },
 	{},
@@ -137,6 +154,7 @@ static struct i2c_driver xrs700x_i2c_driver = {
 	},
 	.probe	= xrs700x_i2c_probe,
 	.remove	= xrs700x_i2c_remove,
+	.shutdown = xrs700x_i2c_shutdown,
 	.id_table = xrs700x_i2c_id,
 };
 
diff --git a/drivers/net/dsa/xrs700x/xrs700x_mdio.c b/drivers/net/dsa/xrs700x/xrs700x_mdio.c
index 44f58bee04a4..d01cf1073d49 100644
--- a/drivers/net/dsa/xrs700x/xrs700x_mdio.c
+++ b/drivers/net/dsa/xrs700x/xrs700x_mdio.c
@@ -136,7 +136,24 @@ static void xrs700x_mdio_remove(struct mdio_device *mdiodev)
 {
 	struct xrs700x *priv = dev_get_drvdata(&mdiodev->dev);
 
+	if (!priv)
+		return;
+
 	xrs700x_switch_remove(priv);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
+}
+
+static void xrs700x_mdio_shutdown(struct mdio_device *mdiodev)
+{
+	struct xrs700x *priv = dev_get_drvdata(&mdiodev->dev);
+
+	if (!priv)
+		return;
+
+	xrs700x_switch_shutdown(priv);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
 }
 
 static const struct of_device_id __maybe_unused xrs700x_mdio_dt_ids[] = {
@@ -155,6 +172,7 @@ static struct mdio_driver xrs700x_mdio_driver = {
 	},
 	.probe	= xrs700x_mdio_probe,
 	.remove	= xrs700x_mdio_remove,
+	.shutdown = xrs700x_mdio_shutdown,
 };
 
 mdio_module_driver(xrs700x_mdio_driver);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index f9a17145255a..2c39dbac63bd 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1041,6 +1041,7 @@ static inline int dsa_ndo_eth_ioctl(struct net_device *dev, struct ifreq *ifr,
 
 void dsa_unregister_switch(struct dsa_switch *ds);
 int dsa_register_switch(struct dsa_switch *ds);
+void dsa_switch_shutdown(struct dsa_switch *ds);
 struct dsa_switch *dsa_switch_find(int tree_index, int sw_index);
 #ifdef CONFIG_PM_SLEEP
 int dsa_switch_suspend(struct dsa_switch *ds);
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 1b2b25d7bd02..b94d7bd62277 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1546,3 +1546,49 @@ void dsa_unregister_switch(struct dsa_switch *ds)
 	mutex_unlock(&dsa2_mutex);
 }
 EXPORT_SYMBOL_GPL(dsa_unregister_switch);
+
+/* If the DSA master chooses to unregister its net_device on .shutdown, DSA is
+ * blocking that operation from completion, due to the dev_hold taken inside
+ * netdev_upper_dev_link. Unlink the DSA slave interfaces from being uppers of
+ * the DSA master, so that the system can reboot successfully.
+ */
+void dsa_switch_shutdown(struct dsa_switch *ds)
+{
+	struct net_device *master, *slave_dev;
+	struct dsa_port *dp;
+
+	mutex_lock(&dsa2_mutex);
+	rtnl_lock();
+	list_for_each_entry(dp, &ds->dst->ports, list) {
+		if (dp->ds != ds)
+			continue;
+
+		if (!dsa_is_user_port(ds, dp->index))
+			continue;
+
+		master = dp->cpu_dp->master;
+		slave_dev = dp->slave;
+
+		netdev_upper_dev_unlink(master, slave_dev);
+		/* Just unlinking ourselves as uppers of the master is not
+		 * sufficient. When the master net device unregisters, that will
+		 * also call dev_close, which we will catch as NETDEV_GOING_DOWN
+		 * and trigger a dev_close on our own devices (dsa_slave_close).
+		 * In turn, that will call dev_mc_unsync on the master's net
+		 * device. If the master is also a DSA switch port, this will
+		 * trigger dsa_slave_set_rx_mode which will call dev_mc_sync on
+		 * its own master. Lockdep will complain about the fact that
+		 * all cascaded masters have the same dsa_master_addr_list_lock_key,
+		 * which it normally would not do if the cascaded masters would
+		 * be in a proper upper/lower relationship, which we've just
+		 * destroyed.
+		 * To suppress the lockdep warnings, let's actually unregister
+		 * the DSA slave interfaces too, to avoid the nonsensical
+		 * multicast address list synchronization on shutdown.
+		 */
+		unregister_netdevice(slave_dev);
+	}
+	rtnl_unlock();
+	mutex_unlock(&dsa2_mutex);
+}
+EXPORT_SYMBOL_GPL(dsa_switch_shutdown);
-- 
2.25.1


--3n3ubyh3w3apufpu--
