Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273421CD862
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 13:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbgEKL3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 07:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729570AbgEKL3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 07:29:08 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3291C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 04:29:07 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id e16so10483465wra.7
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 04:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NS2S/utFr7Mk20kNWj2b9KCvUQNhSA2fmP/4S25xVm0=;
        b=Kf/ko6dUlwm2FNCev3yIB/umEwXAnbg3Y4vlpm2tlMtcK9xmTYTw1zpzDGjXMRO3ho
         5bttcXQ3Cb5AA1DLBB9oWPe28659wA5v1mJoXeZFStcA3oRQNZ8bysKM2tecQQkcwscl
         YhUzdWkzgUyh/5iweBKL1z7ehhGns3lX1HApOMehrAnTtj/98kgYnUhE3m54FEDxSZT1
         hhVqU7UYcYGytB9ysKdqUHUyzUKbzEwYzu/42bVsLV8LZzVHEnSwbuxrzM45PvR1BCfa
         vZdjVe7NTjbCoR+uPs0zMxsykhwQoe3GR9CJeFg1HIZtKO4yJ/F455v63FHqkZ0dd86a
         mV6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NS2S/utFr7Mk20kNWj2b9KCvUQNhSA2fmP/4S25xVm0=;
        b=IPLQqisSOsTHEgym7b8E3AlXF9FzUxU7LwgsVgjUFNJ5NYdn2YjzuNbJFc4lt2vdh7
         IsTYu3j0g1sxBqVSj71Omf3UpOcWCfP+9TtQaiKk4q/s+p4s9/6BVXmhVWtTW6KglO5e
         cce7yIPTbRIMLo+cGk+nik+6+WJwaZkR6hBkTud8yG3EsdVX+nT5b/xBfDAofZFTBh/o
         Qt0Ym28y+WMSI6BLUGlnvd8/CvXnvjeLdnAhYsSzoMEjcBntwCNT2BcGjnEXIhiqySCq
         DK6mwPto5qsZ9c/FPbQwP2+wXVodHGJSyvvKBXblfXL//pGuC/i6Mh9dTHvYq+Fam8rm
         sbtg==
X-Gm-Message-State: AGi0PuZ/VjDknF/Lk5AVWVxDTCVHep8sAoKnZr8mM12ONiRptMyaNQYy
        d27I6/qxipHqciMoI47scxXjNQ==
X-Google-Smtp-Source: APiQypKMyVuiu0uNRjVgRhq8RQC0050IGsRU1RAydlET9eOYV/9zJwA6qAdiSFT1XoGqcwTErr9fgw==
X-Received: by 2002:adf:edc6:: with SMTP id v6mr18132057wro.8.1589196546558;
        Mon, 11 May 2020 04:29:06 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id u24sm18829365wmm.47.2020.05.11.04.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 04:29:05 -0700 (PDT)
Date:   Mon, 11 May 2020 13:29:05 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Subject: Re: [RFC next-next v2 1/5] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200511112905.GH2245@nanopsycho>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-2-vadym.kochan@plvision.eu>
 <20200511103222.GF2245@nanopsycho>
 <20200511111134.GD25096@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511111134.GD25096@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, May 11, 2020 at 01:11:34PM CEST, vadym.kochan@plvision.eu wrote:
>Hi Jiri,
>
>On Mon, May 11, 2020 at 12:32:22PM +0200, Jiri Pirko wrote:
>> Fri, May 01, 2020 at 01:20:48AM CEST, vadym.kochan@plvision.eu wrote:
>> >Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
>> >ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
>> >wireless SMB deployment.
>> >
>> >The current implementation supports only boards designed for the Marvell
>> >Switchdev solution and requires special firmware.
>> >
>> >The core Prestera switching logic is implemented in prestera.c, there is
>> >an intermediate hw layer between core logic and firmware. It is
>> >implemented in prestera_hw.c, the purpose of it is to encapsulate hw
>> >related logic, in future there is a plan to support more devices with
>> >different HW related configurations.
>> >
>> >This patch contains only basic switch initialization and RX/TX support
>> >over SDMA mechanism.
>> >
>> >Currently supported devices have DMA access range <= 32bit and require
>> >ZONE_DMA to be enabled, for such cases SDMA driver checks if the skb
>> >allocated in proper range supported by the Prestera device.
>> >
>> >Also meanwhile there is no TX interrupt support in current firmware
>> >version so recycling work is sheduled on each xmit.
>> >
>> >It is required to specify 'base_mac' module parameter which is used for
>> 
>> No module parameter please.
>> 
>I understand this is not good, but currently this is simple solution to
>handle base MAC configuration for different boards which has this PP,
>otherwise it needs to by supported by platform drivers. Is there some
>generic way to handle this ?

If the HW is not capable holding the mac, I think that you can have it
in platform data. The usual way for such HW is to generate random mac.
module parameter is definitelly a no-go.


>
>> 
>> >generation of initial port's mac address, as currently there is no
>> >some generic way to set it because base mac can be stored on different
>> >storage places.
>> >
>> >Signed-off-by: Andrii Savka <andrii.savka@plvision.eu>
>> >Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
>> >Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
>> >Signed-off-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
>> >Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
>> >Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
>> >Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
>> >---
>> > drivers/net/ethernet/marvell/Kconfig          |   1 +
>> > drivers/net/ethernet/marvell/Makefile         |   1 +
>> > drivers/net/ethernet/marvell/prestera/Kconfig |  13 +
>> > .../net/ethernet/marvell/prestera/Makefile    |   4 +
>> > .../net/ethernet/marvell/prestera/prestera.c  | 530 +++++++++++
>> > .../net/ethernet/marvell/prestera/prestera.h  | 172 ++++
>> > .../ethernet/marvell/prestera/prestera_dsa.c  | 134 +++
>> > .../ethernet/marvell/prestera/prestera_dsa.h  |  37 +
>> > .../ethernet/marvell/prestera/prestera_hw.c   | 614 +++++++++++++
>> > .../ethernet/marvell/prestera/prestera_hw.h   |  71 ++
>> > .../ethernet/marvell/prestera/prestera_rxtx.c | 825 ++++++++++++++++++
>> > .../ethernet/marvell/prestera/prestera_rxtx.h |  21 +
>> > 12 files changed, 2423 insertions(+)
>> > create mode 100644 drivers/net/ethernet/marvell/prestera/Kconfig
>> > create mode 100644 drivers/net/ethernet/marvell/prestera/Makefile
>> > create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.c
>> > create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.h
>> > create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.c
>> > create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.h
>> > create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.c
>> > create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.h
>> > create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
>> > create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
>> >
>> >diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
>> >index 3d5caea096fb..74313d9e1fc0 100644
>> >--- a/drivers/net/ethernet/marvell/Kconfig
>> >+++ b/drivers/net/ethernet/marvell/Kconfig
>> >@@ -171,5 +171,6 @@ config SKY2_DEBUG
>> > 
>> > 
>> > source "drivers/net/ethernet/marvell/octeontx2/Kconfig"
>> >+source "drivers/net/ethernet/marvell/prestera/Kconfig"
>> > 
>> > endif # NET_VENDOR_MARVELL
>> >diff --git a/drivers/net/ethernet/marvell/Makefile b/drivers/net/ethernet/marvell/Makefile
>> >index 89dea7284d5b..9f88fe822555 100644
>> >--- a/drivers/net/ethernet/marvell/Makefile
>> >+++ b/drivers/net/ethernet/marvell/Makefile
>> >@@ -12,3 +12,4 @@ obj-$(CONFIG_PXA168_ETH) += pxa168_eth.o
>> > obj-$(CONFIG_SKGE) += skge.o
>> > obj-$(CONFIG_SKY2) += sky2.o
>> > obj-y		+= octeontx2/
>> >+obj-y		+= prestera/
>> >diff --git a/drivers/net/ethernet/marvell/prestera/Kconfig b/drivers/net/ethernet/marvell/prestera/Kconfig
>> >new file mode 100644
>> >index 000000000000..0eddbc2e5901
>> >--- /dev/null
>> >+++ b/drivers/net/ethernet/marvell/prestera/Kconfig
>> >@@ -0,0 +1,13 @@
>> >+# SPDX-License-Identifier: GPL-2.0-only
>> >+#
>> >+# Marvell Prestera drivers configuration
>> >+#
>> >+
>> >+config PRESTERA
>> >+	tristate "Marvell Prestera Switch ASICs support"
>> >+	depends on NET_SWITCHDEV && VLAN_8021Q
>> >+	help
>> >+	  This driver supports Marvell Prestera Switch ASICs family.
>> >+
>> >+	  To compile this driver as a module, choose M here: the
>> >+	  module will be called prestera_sw.
>> >diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
>> >new file mode 100644
>> >index 000000000000..2c35c498339e
>> >--- /dev/null
>> >+++ b/drivers/net/ethernet/marvell/prestera/Makefile
>> >@@ -0,0 +1,4 @@
>> >+# SPDX-License-Identifier: GPL-2.0
>> >+obj-$(CONFIG_PRESTERA)	+= prestera_sw.o
>> >+prestera_sw-objs	:= prestera.o prestera_hw.o prestera_dsa.o \
>> 
>> Everything else is "prestera". Let the module name be "prestera" too.
>> Don't forget to rename this in Kconfig as well.
>> 
>> 
>> >+			   prestera_rxtx.o
>> >diff --git a/drivers/net/ethernet/marvell/prestera/prestera.c b/drivers/net/ethernet/marvell/prestera/prestera.c
>> >new file mode 100644
>> >index 000000000000..e2cccd9db742
>> >--- /dev/null
>> >+++ b/drivers/net/ethernet/marvell/prestera/prestera.c
>> >@@ -0,0 +1,530 @@
>> >+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
>> >+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
>> >+
>> >+#include <linux/kernel.h>
>> >+#include <linux/module.h>
>> >+#include <linux/list.h>
>> >+#include <linux/netdevice.h>
>> >+#include <linux/netdev_features.h>
>> >+#include <linux/etherdevice.h>
>> >+#include <linux/jiffies.h>
>> >+
>> >+#include "prestera.h"
>> >+#include "prestera_hw.h"
>> >+#include "prestera_rxtx.h"
>> >+
>> >+static char base_mac_addr[ETH_ALEN];
>> >+static char *base_mac;
>> >+
>> >+#define PRESTERA_MTU_DEFAULT 1536
>> >+
>> >+#define PRESTERA_STATS_DELAY_MS	(msecs_to_jiffies(1000))
>> 
>> Drop the ()s
>> 
>> 
>> >+
>> >+static struct prestera_switch *registered_switch;
>> 
>> Please remove this global variable.
>> 
>> 
>> >+static struct workqueue_struct *prestera_wq;
>> >+
>> >+struct prestera_port *prestera_port_find_by_hwid(u32 dev_id, u32 hw_id)
>> >+{
>> >+	struct prestera_port *port;
>> >+
>> >+	rcu_read_lock();
>> >+
>> >+	list_for_each_entry_rcu(port, &registered_switch->port_list, list) {
>> >+		if (port->dev_id == dev_id && port->hw_id == hw_id) {
>> >+			rcu_read_unlock();
>> >+			return port;
>> >+		}
>> >+	}
>> >+
>> >+	rcu_read_unlock();
>> >+
>> >+	return NULL;
>> >+}
>> >+
>> >+static struct prestera_port *prestera_find_port(struct prestera_switch *sw,
>> >+						u32 port_id)
>> >+{
>> >+	struct prestera_port *port;
>> >+
>> >+	rcu_read_lock();
>> >+
>> >+	list_for_each_entry_rcu(port, &sw->port_list, list) {
>> >+		if (port->id == port_id) {
>> >+			rcu_read_unlock();
>> 
>> In cases like this is good to have one unlock in the function.
>> 
>> 
>> >+			return port;
>> >+		}
>> >+	}
>> >+
>> >+	rcu_read_unlock();
>> >+
>> >+	return NULL;
>> >+}
>> >+
>> >+static int prestera_port_state_set(struct net_device *dev, bool is_up)
>> >+{
>> >+	struct prestera_port *port = netdev_priv(dev);
>> >+	int err;
>> >+
>> >+	if (!is_up)
>> >+		netif_stop_queue(dev);
>> >+
>> >+	err = prestera_hw_port_state_set(port, is_up);
>> >+
>> >+	if (is_up && !err)
>> >+		netif_start_queue(dev);
>> >+
>> >+	return err;
>> >+}
>> >+
>> >+static int prestera_port_get_port_parent_id(struct net_device *dev,
>> >+					    struct netdev_phys_item_id *ppid)
>> >+{
>> >+	const struct prestera_port *port = netdev_priv(dev);
>> >+
>> >+	ppid->id_len = sizeof(port->sw->id);
>> >+
>> >+	memcpy(&ppid->id, &port->sw->id, ppid->id_len);
>> >+	return 0;
>> >+}
>> >+
>> >+static int prestera_port_get_phys_port_name(struct net_device *dev,
>> >+					    char *buf, size_t len)
>> >+{
>> 
>> Hmm, in my previous patch version review I wrote:
>> "Don't implement this please. Just implement basic devlink and devlink
>>  port support, devlink is going to take care of the netdevice names."
>> 
>> Why did you chose to ignore my comment? :(
>Sorry, I really still keep it in mind) I was mostly focused on things
>originated from the original patch and was a bit stressed with some
>re-implementations and global renamings. Of course I will add support
>for the devlink interface, currently I am not familiar with this
>interface so I need some investigation.

It is simple. Please make sure you have it included in the next version.


>> 
>> 
>> >+	const struct prestera_port *port = netdev_priv(dev);
>> >+
>> >+	snprintf(buf, len, "%u", port->fp_id);
>> >+	return 0;
>> >+}
>> >+
>> >+static int prestera_port_open(struct net_device *dev)
>> >+{
>> >+	return prestera_port_state_set(dev, true);
>> >+}
>> >+
>> >+static int prestera_port_close(struct net_device *dev)
>> >+{
>> >+	return prestera_port_state_set(dev, false);
>> >+}
>> >+
>> >+static netdev_tx_t prestera_port_xmit(struct sk_buff *skb,
>> >+				      struct net_device *dev)
>> >+{
>> >+	return prestera_rxtx_xmit(netdev_priv(dev), skb);
>> >+}
>> >+
>> >+static int prestera_is_valid_mac_addr(struct prestera_port *port, u8 *addr)
>> >+{
>> >+	if (!is_valid_ether_addr(addr))
>> >+		return -EADDRNOTAVAIL;
>> >+
>> >+	if (memcmp(port->sw->base_mac, addr, ETH_ALEN - 1))
>> >+		return -EINVAL;
>> >+
>> >+	return 0;
>> >+}
>> >+
>> >+static int prestera_port_set_mac_address(struct net_device *dev, void *p)
>> >+{
>> >+	struct prestera_port *port = netdev_priv(dev);
>> >+	struct sockaddr *addr = p;
>> >+	int err;
>> >+
>> >+	err = prestera_is_valid_mac_addr(port, addr->sa_data);
>> >+	if (err)
>> >+		return err;
>> >+
>> >+	err = prestera_hw_port_mac_set(port, addr->sa_data);
>> >+	if (err)
>> >+		return err;
>> >+
>> >+	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
>> >+	return 0;
>> >+}
>> >+
>> >+static int prestera_port_change_mtu(struct net_device *dev, int mtu)
>> >+{
>> >+	struct prestera_port *port = netdev_priv(dev);
>> >+	int err;
>> >+
>> >+	err = prestera_hw_port_mtu_set(port, mtu);
>> >+	if (err)
>> >+		return err;
>> >+
>> >+	dev->mtu = mtu;
>> >+	return 0;
>> >+}
>> >+
>> >+static void prestera_port_get_stats64(struct net_device *dev,
>> >+				      struct rtnl_link_stats64 *stats)
>> >+{
>> >+	struct prestera_port *port = netdev_priv(dev);
>> >+	struct prestera_port_stats *port_stats = &port->cached_hw_stats.stats;
>> >+
>> >+	stats->rx_packets = port_stats->broadcast_frames_received +
>> >+				port_stats->multicast_frames_received +
>> >+				port_stats->unicast_frames_received;
>> >+
>> >+	stats->tx_packets = port_stats->broadcast_frames_sent +
>> >+				port_stats->multicast_frames_sent +
>> >+				port_stats->unicast_frames_sent;
>> >+
>> >+	stats->rx_bytes = port_stats->good_octets_received;
>> >+
>> >+	stats->tx_bytes = port_stats->good_octets_sent;
>> >+
>> >+	stats->rx_errors = port_stats->rx_error_frame_received;
>> >+	stats->tx_errors = port_stats->mac_trans_error;
>> >+
>> >+	stats->rx_dropped = port_stats->buffer_overrun;
>> >+	stats->tx_dropped = 0;
>> >+
>> >+	stats->multicast = port_stats->multicast_frames_received;
>> >+	stats->collisions = port_stats->excessive_collision;
>> >+
>> >+	stats->rx_crc_errors = port_stats->bad_crc;
>> >+}
>> >+
>> >+static void prestera_port_get_hw_stats(struct prestera_port *port)
>> >+{
>> >+	prestera_hw_port_stats_get(port, &port->cached_hw_stats.stats);
>> >+}
>> >+
>> >+static void prestera_port_stats_update(struct work_struct *work)
>> >+{
>> >+	struct prestera_port *port =
>> >+		container_of(work, struct prestera_port,
>> >+			     cached_hw_stats.caching_dw.work);
>> >+
>> >+	prestera_port_get_hw_stats(port);
>> >+
>> >+	queue_delayed_work(prestera_wq, &port->cached_hw_stats.caching_dw,
>> >+			   PRESTERA_STATS_DELAY_MS);
>> >+}
>> >+
>> >+static const struct net_device_ops netdev_ops = {
>> >+	.ndo_open = prestera_port_open,
>> >+	.ndo_stop = prestera_port_close,
>> >+	.ndo_start_xmit = prestera_port_xmit,
>> >+	.ndo_change_mtu = prestera_port_change_mtu,
>> >+	.ndo_get_stats64 = prestera_port_get_stats64,
>> >+	.ndo_set_mac_address = prestera_port_set_mac_address,
>> >+	.ndo_get_phys_port_name = prestera_port_get_phys_port_name,
>> >+	.ndo_get_port_parent_id = prestera_port_get_port_parent_id
>> >+};
>> >+
>> >+static int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
>> >+				     u64 link_modes, u8 fec)
>> >+{
>> >+	bool refresh = false;
>> >+	int err = 0;
>> >+
>> >+	if (port->caps.type != PRESTERA_PORT_TYPE_TP)
>> >+		return enable ? -EINVAL : 0;
>> >+
>> >+	if (port->adver_link_modes != link_modes || port->adver_fec != fec) {
>> >+		port->adver_fec = fec ?: BIT(PRESTERA_PORT_FEC_OFF);
>> >+		port->adver_link_modes = link_modes;
>> >+		refresh = true;
>> >+	}
>> >+
>> >+	if (port->autoneg == enable && !(port->autoneg && refresh))
>> >+		return 0;
>> >+
>> >+	err = prestera_hw_port_autoneg_set(port, enable, port->adver_link_modes,
>> >+					   port->adver_fec);
>> >+	if (err)
>> >+		return -EINVAL;
>> >+
>> >+	port->autoneg = enable;
>> >+	return 0;
>> >+}
>> >+
>> >+static int prestera_port_create(struct prestera_switch *sw, u32 id)
>> >+{
>> >+	struct prestera_port *port;
>> >+	struct net_device *dev;
>> >+	int err;
>> >+
>> >+	dev = alloc_etherdev(sizeof(*port));
>> >+	if (!dev)
>> >+		return -ENOMEM;
>> >+
>> >+	port = netdev_priv(dev);
>> >+
>> >+	port->dev = dev;
>> >+	port->id = id;
>> >+	port->sw = sw;
>> >+
>> >+	err = prestera_hw_port_info_get(port, &port->fp_id,
>> >+					&port->hw_id, &port->dev_id);
>> >+	if (err) {
>> >+		dev_err(prestera_dev(sw), "Failed to get port(%u) info\n", id);
>> >+		goto err_port_init;
>> >+	}
>> >+
>> >+	dev->features |= NETIF_F_NETNS_LOCAL;
>> >+	dev->netdev_ops = &netdev_ops;
>> >+
>> >+	netif_carrier_off(dev);
>> >+
>> >+	dev->mtu = min_t(unsigned int, sw->mtu_max, PRESTERA_MTU_DEFAULT);
>> >+	dev->min_mtu = sw->mtu_min;
>> >+	dev->max_mtu = sw->mtu_max;
>> >+
>> >+	err = prestera_hw_port_mtu_set(port, dev->mtu);
>> >+	if (err) {
>> >+		dev_err(prestera_dev(sw), "Failed to set port(%u) mtu(%d)\n",
>> >+			id, dev->mtu);
>> >+		goto err_port_init;
>> >+	}
>> >+
>> >+	/* Only 0xFF mac addrs are supported */
>> >+	if (port->fp_id >= 0xFF)
>> >+		goto err_port_init;
>> >+
>> >+	memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);
>> >+	dev->dev_addr[dev->addr_len - 1] = (char)port->fp_id;
>> >+
>> >+	err = prestera_hw_port_mac_set(port, dev->dev_addr);
>> >+	if (err) {
>> >+		dev_err(prestera_dev(sw), "Failed to set port(%u) mac addr\n", id);
>> >+		goto err_port_init;
>> >+	}
>> >+
>> >+	err = prestera_hw_port_cap_get(port, &port->caps);
>> >+	if (err) {
>> >+		dev_err(prestera_dev(sw), "Failed to get port(%u) caps\n", id);
>> >+		goto err_port_init;
>> >+	}
>> >+
>> >+	port->adver_fec = BIT(PRESTERA_PORT_FEC_OFF);
>> >+	prestera_port_autoneg_set(port, true, port->caps.supp_link_modes,
>> >+				  port->caps.supp_fec);
>> >+
>> >+	err = prestera_hw_port_state_set(port, false);
>> >+	if (err) {
>> >+		dev_err(prestera_dev(sw), "Failed to set port(%u) down\n", id);
>> >+		goto err_port_init;
>> >+	}
>> >+
>> >+	err = prestera_rxtx_port_init(port);
>> >+	if (err)
>> >+		goto err_port_init;
>> >+
>> >+	INIT_DELAYED_WORK(&port->cached_hw_stats.caching_dw,
>> >+			  &prestera_port_stats_update);
>> >+
>> >+	spin_lock(&sw->ports_lock);
>> >+	list_add(&port->list, &sw->port_list);
>> 
>> This is RCU list. Treat it accordingly.
>> 
>> 
>> >+	spin_unlock(&sw->ports_lock);
>> 
>> I don't follow, why do you need to protect the list by spinlock here?
>> More to that, why do you need the port_list reader-writer
>> protected (by rcu)? Is is possible that you add/remove port in the same
>> time packets are flying in?
>> 
>> If yes, you need to ensure the structs are in the memory (free_rcu,
>> synchronize_rcu). But I believe that you should disable that from
>> happening in HW.
>Probably you are right, may be this is too much for the current
>implementation)
>
>> 
>> 
>> >+
>> >+	err = register_netdev(dev);
>> >+	if (err)
>> >+		goto err_register_netdev;
>> >+
>> >+	return 0;
>> >+
>> >+err_register_netdev:
>> >+	spin_lock(&sw->ports_lock);
>> >+	list_del_rcu(&port->list);
>> >+	spin_unlock(&sw->ports_lock);
>> >+err_port_init:
>> >+	free_netdev(dev);
>> >+	return err;
>> >+}
>> >+
>> >+static void prestera_port_destroy(struct prestera_port *port)
>> >+{
>> >+	struct net_device *dev = port->dev;
>> >+
>> >+	cancel_delayed_work_sync(&port->cached_hw_stats.caching_dw);
>> >+	unregister_netdev(dev);
>> >+
>> >+	spin_lock(&port->sw->ports_lock);
>> >+	list_del_rcu(&port->list);
>> >+	spin_unlock(&port->sw->ports_lock);
>> >+
>> >+	free_netdev(dev);
>> >+}
>> >+
>> >+static void prestera_destroy_ports(struct prestera_switch *sw)
>> >+{
>> >+	struct prestera_port *port, *tmp;
>> >+	struct list_head remove_list;
>> >+
>> >+	INIT_LIST_HEAD(&remove_list);
>> >+
>> >+	spin_lock(&sw->ports_lock);
>> >+	list_splice_init(&sw->port_list, &remove_list);
>> >+	spin_unlock(&sw->ports_lock);
>> >+
>> >+	list_for_each_entry_safe(port, tmp, &remove_list, list)
>> >+		prestera_port_destroy(port);
>> >+}
>> >+
>> >+static int prestera_create_ports(struct prestera_switch *sw)
>> >+{
>> >+	u32 port;
>> >+	int err;
>> >+
>> >+	for (port = 0; port < sw->port_count; port++) {
>> >+		err = prestera_port_create(sw, port);
>> >+		if (err)
>> >+			goto err_ports_init;
>> >+	}
>> >+
>> >+	return 0;
>> >+
>> >+err_ports_init:
>> >+	prestera_destroy_ports(sw);
>> >+	return err;
>> >+}
>> >+
>> >+static void prestera_port_handle_event(struct prestera_switch *sw,
>> >+				       struct prestera_event *evt, void *arg)
>> >+{
>> >+	struct delayed_work *caching_dw;
>> >+	struct prestera_port *port;
>> >+
>> >+	port = prestera_find_port(sw, evt->port_evt.port_id);
>> >+	if (!port)
>> >+		return;
>> >+
>> >+	caching_dw = &port->cached_hw_stats.caching_dw;
>> >+
>> >+	if (evt->id == PRESTERA_PORT_EVENT_STATE_CHANGED) {
>> >+		if (evt->port_evt.data.oper_state) {
>> >+			netif_carrier_on(port->dev);
>> >+			if (!delayed_work_pending(caching_dw))
>> >+				queue_delayed_work(prestera_wq, caching_dw, 0);
>> >+		} else {
>> >+			netif_carrier_off(port->dev);
>> >+			if (delayed_work_pending(caching_dw))
>> >+				cancel_delayed_work(caching_dw);
>> >+		}
>> >+	}
>> >+}
>> >+
>> >+static void prestera_event_handlers_unregister(struct prestera_switch *sw)
>> >+{
>> >+	prestera_hw_event_handler_unregister(sw, PRESTERA_EVENT_TYPE_PORT,
>> >+					     prestera_port_handle_event);
>> >+}
>> >+
>> >+static int prestera_event_handlers_register(struct prestera_switch *sw)
>> >+{
>> >+	return prestera_hw_event_handler_register(sw, PRESTERA_EVENT_TYPE_PORT,
>> >+						  prestera_port_handle_event,
>> >+						  NULL);
>> >+}
>> >+
>> >+static int prestera_switch_init(struct prestera_switch *sw)
>> >+{
>> >+	int err;
>> >+
>> >+	err = prestera_hw_switch_init(sw);
>> >+	if (err) {
>> >+		dev_err(prestera_dev(sw), "Failed to init Switch device\n");
>> >+		return err;
>> >+	}
>> >+
>> >+	memcpy(sw->base_mac, base_mac_addr, sizeof(sw->base_mac));
>> >+	spin_lock_init(&sw->ports_lock);
>> >+	INIT_LIST_HEAD(&sw->port_list);
>> >+
>> >+	err = prestera_hw_switch_mac_set(sw, sw->base_mac);
>> >+	if (err)
>> >+		return err;
>> >+
>> >+	err = prestera_rxtx_switch_init(sw);
>> >+	if (err)
>> >+		return err;
>> >+
>> >+	err = prestera_event_handlers_register(sw);
>> >+	if (err)
>> >+		goto err_evt_handlers;
>> >+
>> >+	err = prestera_create_ports(sw);
>> >+	if (err)
>> >+		goto err_ports_create;
>> >+
>> >+	return 0;
>> >+
>> >+err_ports_create:
>> 
>> You are missing prestera_event_handlers_unregister(sw); call here.
>> 
>> 
>> >+err_evt_handlers:
>> >+	prestera_rxtx_switch_fini(sw);
>> >+
>> >+	return err;
>> >+}
>> >+
>> >+static void prestera_switch_fini(struct prestera_switch *sw)
>> >+{
>> >+	prestera_destroy_ports(sw);
>> >+	prestera_event_handlers_unregister(sw);
>> >+	prestera_rxtx_switch_fini(sw);
>> >+}
>> >+
>> >+int prestera_device_register(struct prestera_device *dev)
>> >+{
>> >+	struct prestera_switch *sw;
>> >+	int err;
>> >+
>> >+	sw = kzalloc(sizeof(*sw), GFP_KERNEL);
>> >+	if (!sw)
>> >+		return -ENOMEM;
>> >+
>> >+	dev->priv = sw;
>> >+	sw->dev = dev;
>> >+
>> >+	err = prestera_switch_init(sw);
>> >+	if (err) {
>> >+		kfree(sw);
>> >+		return err;
>> >+	}
>> >+
>> >+	registered_switch = sw;
>> >+	return 0;
>> >+}
>> >+EXPORT_SYMBOL(prestera_device_register);
>> >+
>> >+void prestera_device_unregister(struct prestera_device *dev)
>> >+{
>> >+	struct prestera_switch *sw = dev->priv;
>> >+
>> >+	registered_switch = NULL;
>> >+	prestera_switch_fini(sw);
>> >+	kfree(sw);
>> >+}
>> >+EXPORT_SYMBOL(prestera_device_unregister);
>> >+
>> >+static int __init prestera_module_init(void)
>> >+{
>> >+	if (!base_mac) {
>> >+		pr_err("[base_mac] parameter must be specified\n");
>> >+		return -EINVAL;
>> >+	}
>> >+	if (!mac_pton(base_mac, base_mac_addr)) {
>> >+		pr_err("[base_mac] parameter has invalid format\n");
>> >+		return -EINVAL;
>> >+	}
>> >+
>> >+	prestera_wq = alloc_workqueue("prestera", 0, 0);
>> >+	if (!prestera_wq)
>> >+		return -ENOMEM;
>> >+
>> >+	return 0;
>> >+}
>> >+
>> >+static void __exit prestera_module_exit(void)
>> >+{
>> >+	destroy_workqueue(prestera_wq);
>> >+}
>> >+
>> >+module_init(prestera_module_init);
>> >+module_exit(prestera_module_exit);
>> >+
>> >+MODULE_AUTHOR("Marvell Semi.");
>> >+MODULE_LICENSE("Dual BSD/GPL");
>> >+MODULE_DESCRIPTION("Marvell Prestera switch driver");
>> >+
>> >+module_param(base_mac, charp, 0);
>> 
>> No please.
>> 
>> 
>> [..]
>> 
>
>Thanks for review!
>
>I still keep in todo list some things from Ido (regarding default pvid)
>and Jakub regarding module author and of course the devlink, I will put
>them on next version, I assume it can be as PATCH version ?

Great. Thanks! Just make sure you don't forget anything. It is
frustrating to see the same thing during review you commented the last
time ignored :/


>
>Regards,
>Vadym Kochan
