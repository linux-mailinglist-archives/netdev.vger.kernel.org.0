Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF3A1ED22F
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 16:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgFCOg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 10:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgFCOg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 10:36:27 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37A3C08C5C1
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 07:36:26 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f185so2337836wmf.3
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 07:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FOpVDH4BiTRLorEpkAgzDg/6WmANN7Aamz0qZgH0p5E=;
        b=O4P8ErICiAV0HMQA6Py2q/B2CtSFxsJLz0N4RfK34q7OWw3/t5HNu8/fUeFNeVLW1b
         IEmhO0mrbg3VMrM55aeVLqlQQSQNzhGPgqhZ6kF3SoB3M8oaUJZa42T3KDpK54goWO/t
         23YKY0X+6XjXc3oiZ1pjaiz8oiug5EEZUW1twNv5uR8MSFB1iHvxiCKRuaocqvBEb6Nt
         QW4GMlWlxNU/FEX7117ZevmsvQgmfyHhSZ+1duIodr5NzQPySpGTlMKp8U7D8dIxksU2
         ZOqCNiO7UEyNmGCgcfKLHMCOGoTuAyXoORMuFjA/TNN0R+nVgzIkobPgD+g6CnUiy7bU
         B0xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FOpVDH4BiTRLorEpkAgzDg/6WmANN7Aamz0qZgH0p5E=;
        b=Bf2j1/t4fn1JjaUwTcPByzNnMAiQaddWyUQnF2pKgRCVUCda5+YArgLhLwSwAp2DNV
         yfb+Lx4zkH3wH/7Li87nRwRqGfXSvNyJlEvpvJoEb5QH9hjwvj6XluOGWiNiNcWCjHo4
         nls/gnnLukx8Tn/A/CNvyEsBlgh+AeYFBYDcnFC832LSKeAQhkqQldDrYD+rFDKYxgDJ
         FCGxDHMtiW9ufbhMukFZCHJoe1/auBseajhg8cNuzH4vA0q358HHfJHP1iUsTNHt2813
         nB1KiXEaBDPx0GxN6frm+kTfbK4QI1qiBOn18+6Bn3xqwxZfIlW1hOsU9mz8E5G2u/WF
         Kezg==
X-Gm-Message-State: AOAM532DqbLiHBVVTavxKNeb7824B64CyyI9OBxzncCozr8TL8DIY6YE
        Dq8iluVwVDMe3/H0pwFAgQh9Qg==
X-Google-Smtp-Source: ABdhPJxmoQDiarJtX2HTTZ3DjoapQbGSg6RMAYrh8/YxCRpMxajr/xqeqM+FfDm4/kTSKtOjXvh9Vw==
X-Received: by 2002:a05:600c:146:: with SMTP id w6mr8677844wmm.97.1591194985386;
        Wed, 03 Jun 2020 07:36:25 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z22sm3303213wmf.9.2020.06.03.07.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 07:36:24 -0700 (PDT)
Date:   Wed, 3 Jun 2020 16:36:23 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next 3/6] net: marvell: prestera: Add basic devlink support
Message-ID: <20200603143623.GB2274@nanopsycho.orion>
References: <20200528151245.7592-1-vadym.kochan@plvision.eu>
 <20200528151245.7592-4-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528151245.7592-4-vadym.kochan@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, May 28, 2020 at 05:12:42PM CEST, vadym.kochan@plvision.eu wrote:
>Add very basic support for devlink interface:
>
>    - driver name
>    - fw version
>    - devlink ports
>
>Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
>---
> drivers/net/ethernet/marvell/prestera/Kconfig |   1 +
> .../net/ethernet/marvell/prestera/Makefile    |   2 +-
> .../net/ethernet/marvell/prestera/prestera.h  |   4 +
> .../marvell/prestera/prestera_devlink.c       | 111 ++++++++++++++++++
> .../marvell/prestera/prestera_devlink.h       |  25 ++++
> .../ethernet/marvell/prestera/prestera_main.c |  27 ++++-
> 6 files changed, 165 insertions(+), 5 deletions(-)
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.c
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.h
>
>diff --git a/drivers/net/ethernet/marvell/prestera/Kconfig b/drivers/net/ethernet/marvell/prestera/Kconfig
>index 0848edb272a5..dfd5174d0568 100644
>--- a/drivers/net/ethernet/marvell/prestera/Kconfig
>+++ b/drivers/net/ethernet/marvell/prestera/Kconfig
>@@ -6,6 +6,7 @@
> config PRESTERA
> 	tristate "Marvell Prestera Switch ASICs support"
> 	depends on NET_SWITCHDEV && VLAN_8021Q
>+	select NET_DEVLINK
> 	help
> 	  This driver supports Marvell Prestera Switch ASICs family.
> 
>diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
>index 2146714eab21..babd71fba809 100644
>--- a/drivers/net/ethernet/marvell/prestera/Makefile
>+++ b/drivers/net/ethernet/marvell/prestera/Makefile
>@@ -1,6 +1,6 @@
> # SPDX-License-Identifier: GPL-2.0
> obj-$(CONFIG_PRESTERA)	+= prestera.o
> prestera-objs		:= prestera_main.o prestera_hw.o prestera_dsa.o \
>-			   prestera_rxtx.o
>+			   prestera_rxtx.o prestera_devlink.o
> 
> obj-$(CONFIG_PRESTERA_PCI)	+= prestera_pci.o
>diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
>index 5079d872e18a..f8abaaff5f21 100644
>--- a/drivers/net/ethernet/marvell/prestera/prestera.h
>+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
>@@ -11,6 +11,9 @@
> #include <linux/notifier.h>
> #include <uapi/linux/if_ether.h>
> #include <linux/workqueue.h>
>+#include <net/devlink.h>
>+
>+#define PRESTERA_DRV_NAME	"prestera"
> 
> struct prestera_fw_rev {
> 	u16 maj;
>@@ -63,6 +66,7 @@ struct prestera_port_caps {
> struct prestera_port {
> 	struct net_device *dev;
> 	struct prestera_switch *sw;
>+	struct devlink_port dl_port;
> 	u32 id;
> 	u32 hw_id;
> 	u32 dev_id;
>diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
>new file mode 100644
>index 000000000000..58021057981b
>--- /dev/null
>+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
>@@ -0,0 +1,111 @@
>+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
>+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
>+
>+#include <net/devlink.h>
>+
>+#include "prestera.h"
>+#include "prestera_devlink.h"
>+
>+static int prestera_dl_info_get(struct devlink *dl,
>+				struct devlink_info_req *req,
>+				struct netlink_ext_ack *extack)
>+{
>+	struct prestera_switch *sw = devlink_priv(dl);
>+	char buf[16];
>+	int err = 0;
>+
>+	err = devlink_info_driver_name_put(req, PRESTERA_DRV_NAME);
>+	if (err)
>+		return err;
>+
>+	snprintf(buf, sizeof(buf), "%d.%d.%d",
>+		 sw->dev->fw_rev.maj,
>+		 sw->dev->fw_rev.min,
>+		 sw->dev->fw_rev.sub);
>+
>+	err = devlink_info_version_running_put(req,
>+					       DEVLINK_INFO_VERSION_GENERIC_FW,
>+					       buf);
>+	if (err)
>+		return err;
>+
>+	return 0;
>+}
>+
>+static const struct devlink_ops prestera_dl_ops = {
>+	.info_get = prestera_dl_info_get,
>+};
>+
>+struct prestera_switch *prestera_devlink_alloc(void)
>+{
>+	struct devlink *dl;
>+
>+	dl = devlink_alloc(&prestera_dl_ops, sizeof(struct prestera_switch));
>+
>+	return devlink_priv(dl);
>+}
>+
>+void prestera_devlink_free(struct prestera_switch *sw)
>+{
>+	struct devlink *dl = priv_to_devlink(sw);
>+
>+	devlink_free(dl);
>+}
>+
>+int prestera_devlink_register(struct prestera_switch *sw)
>+{
>+	struct devlink *dl = priv_to_devlink(sw);
>+	int err;
>+
>+	err = devlink_register(dl, sw->dev->dev);
>+	if (err) {
>+		dev_warn(sw->dev->dev, "devlink_register failed: %d\n", err);
>+		return err;
>+	}
>+
>+	return 0;
>+}
>+
>+void prestera_devlink_unregister(struct prestera_switch *sw)
>+{
>+	struct devlink *dl = priv_to_devlink(sw);
>+
>+	devlink_unregister(dl);
>+}
>+
>+int prestera_devlink_port_register(struct prestera_port *port)
>+{
>+	struct devlink *dl = priv_to_devlink(port->sw);
>+	struct prestera_switch *sw;
>+	int err;
>+
>+	sw = port->sw;
>+	dl = priv_to_devlink(sw);
>+
>+	devlink_port_attrs_set(&port->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
>+			       port->fp_id, false, 0,
>+			       &port->sw->id, sizeof(port->sw->id));
>+
>+	err = devlink_port_register(dl, &port->dl_port, port->fp_id);
>+	if (err)
>+		dev_err(sw->dev->dev, "devlink_port_register failed: %d\n", err);
>+
>+	return 0;
>+}
>+
>+void prestera_devlink_port_unregister(struct prestera_port *port)
>+{
>+	devlink_port_unregister(&port->dl_port);
>+}
>+
>+void prestera_devlink_port_type_set(struct prestera_port *port)
>+{
>+	devlink_port_type_eth_set(&port->dl_port, port->dev);
>+}
>+
>+struct devlink_port *prestera_devlink_get_port(struct net_device *dev)
>+{
>+	struct prestera_port *port = netdev_priv(dev);
>+
>+	return &port->dl_port;
>+}
>diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.h b/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
>new file mode 100644
>index 000000000000..b46441d1e758
>--- /dev/null
>+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
>@@ -0,0 +1,25 @@
>+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
>+ *
>+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
>+ *
>+ */
>+
>+#ifndef _PRESTERA_DEVLINK_H_
>+#define _PRESTERA_DEVLINK_H_
>+
>+#include "prestera.h"
>+
>+struct prestera_switch *prestera_devlink_alloc(void);
>+void prestera_devlink_free(struct prestera_switch *sw);
>+
>+int prestera_devlink_register(struct prestera_switch *sw);
>+void prestera_devlink_unregister(struct prestera_switch *sw);
>+
>+int prestera_devlink_port_register(struct prestera_port *port);
>+void prestera_devlink_port_unregister(struct prestera_port *port);
>+
>+void prestera_devlink_port_type_set(struct prestera_port *port);
>+
>+struct devlink_port *prestera_devlink_get_port(struct net_device *dev);
>+
>+#endif /* _PRESTERA_DEVLINK_H_ */
>diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
>index b5241e9b784a..ddab9422fe5e 100644
>--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
>+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
>@@ -14,6 +14,7 @@
> #include "prestera.h"
> #include "prestera_hw.h"
> #include "prestera_rxtx.h"
>+#include "prestera_devlink.h"
> 
> #define PRESTERA_MTU_DEFAULT 1536
> 
>@@ -185,6 +186,7 @@ static const struct net_device_ops netdev_ops = {
> 	.ndo_change_mtu = prestera_port_change_mtu,
> 	.ndo_get_stats64 = prestera_port_get_stats64,
> 	.ndo_set_mac_address = prestera_port_set_mac_address,
>+	.ndo_get_devlink_port = prestera_devlink_get_port,
> };
> 
> static int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
>@@ -234,9 +236,13 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
> 					&port->hw_id, &port->dev_id);
> 	if (err) {
> 		dev_err(prestera_dev(sw), "Failed to get port(%u) info\n", id);
>-		goto err_port_init;
>+		goto err_port_info_get;
> 	}
> 
>+	err = prestera_devlink_port_register(port);
>+	if (err)
>+		goto err_dl_port_register;
>+
> 	dev->features |= NETIF_F_NETNS_LOCAL;
> 	dev->netdev_ops = &netdev_ops;
> 
>@@ -295,11 +301,16 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
> 	if (err)
> 		goto err_register_netdev;
> 
>+	prestera_devlink_port_type_set(port);
>+
> 	return 0;
> 
> err_register_netdev:
> 	list_del_rcu(&port->list);
> err_port_init:
>+	prestera_devlink_port_unregister(port);
>+err_dl_port_register:
>+err_port_info_get:
> 	free_netdev(dev);
> 	return err;
> }
>@@ -313,6 +324,7 @@ static void prestera_port_destroy(struct prestera_port *port)
> 

You need to call devlink_port_type_clear() before unregister_netdev()
call.


> 	list_del_rcu(&port->list);
> 
>+	prestera_devlink_port_unregister(port);
> 	free_netdev(dev);
> }
> 
>@@ -435,6 +447,10 @@ static int prestera_switch_init(struct prestera_switch *sw)
> 	if (err)
> 		return err;
> 
>+	err = prestera_devlink_register(sw);
>+	if (err)
>+		goto err_dl_register;
>+
> 	err = prestera_create_ports(sw);
> 	if (err)
> 		goto err_ports_create;
>@@ -442,6 +458,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
> 	return 0;
> 
> err_ports_create:
>+	prestera_devlink_unregister(sw);
>+err_dl_register:
> 	prestera_event_handlers_unregister(sw);
> 
> 	return err;
>@@ -450,6 +468,7 @@ static int prestera_switch_init(struct prestera_switch *sw)
> static void prestera_switch_fini(struct prestera_switch *sw)
> {
> 	prestera_destroy_ports(sw);
>+	prestera_devlink_unregister(sw);
> 	prestera_event_handlers_unregister(sw);
> 	prestera_rxtx_switch_fini(sw);
> }
>@@ -459,7 +478,7 @@ int prestera_device_register(struct prestera_device *dev)
> 	struct prestera_switch *sw;
> 	int err;
> 
>-	sw = kzalloc(sizeof(*sw), GFP_KERNEL);
>+	sw = prestera_devlink_alloc();
> 	if (!sw)
> 		return -ENOMEM;
> 
>@@ -468,7 +487,7 @@ int prestera_device_register(struct prestera_device *dev)
> 
> 	err = prestera_switch_init(sw);
> 	if (err) {
>-		kfree(sw);
>+		prestera_devlink_free(sw);
> 		return err;
> 	}
> 
>@@ -481,7 +500,7 @@ void prestera_device_unregister(struct prestera_device *dev)
> 	struct prestera_switch *sw = dev->priv;
> 
> 	prestera_switch_fini(sw);
>-	kfree(sw);
>+	prestera_devlink_free(sw);
> }
> EXPORT_SYMBOL(prestera_device_unregister);
> 
>-- 
>2.17.1
>
