Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0C81E5077
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387616AbgE0V0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387412AbgE0V0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 17:26:16 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F60CC05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:26:16 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z64so7921528pfb.1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HWEGO/iE0XxNGyN+z1BODXRHBWSEu9H1jpC3AeUzrKE=;
        b=Fa6hhPCjOuTZ+HSLigGAcgAQjY6tz1HY6FDAZ+aRsa2/tvTDA/cIGDvHdDUlVW5k10
         QEwxDlksIALB01UxEX7HjgY6uOPkHpl6Mxsw6PMJW1HxbJpcbxxxJ0AhkMHYTB6LEmIq
         3rKGU5yFrMU7IQa9v/2pt2WI175yKewcgsbq0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HWEGO/iE0XxNGyN+z1BODXRHBWSEu9H1jpC3AeUzrKE=;
        b=LhTX0moqw8gZUPtv8QNlDxFS0t2mRnzdzDgATz+8/c9Ip7K6+wxPIADzXIHNcojkQx
         8vaUWck9o2kz+W/LOf7XyshWLH6kQxMPGyVBVFtwXGtJ/zPKQXm3PZ11WNsYu/xanRYT
         5Y7VSqgrATm2ldbTrtM0nTgNmySxdskRw6LJPgPOLR3dTe29oTVaRjjHGzBU0J7D8pLt
         QS89j5wR1W+fg4XvW18onWLkJY7b6Dl6vKhdgCamy78mhJyh3ntXrMBNB19j8ODJ4pKa
         z4OM5siuO6GQlp4Ku2Ep7EvrrbSWNci9t+xJlX/dDg190nwZEqHqajCNesCK8bAE4t8q
         xRPQ==
X-Gm-Message-State: AOAM532tCWi0ZxakWDQ+eYOMHK0TGAnS8CRbTZ+lo7iO4ukqFyZNc6rY
        UwxuxOsTZNYxSIhEdyB6Spki8j4k51TNAj/Gm3tn2MBTiO4Cxc7KK16xemGBh+xgfPGppyPLexa
        6eAgI0mn66UHbp09Dmyz3AfYWPYuiUNQgIZ0DTqERAu0HUvJNxq2Wf6qn463KgAwqDIKW2eUG
X-Google-Smtp-Source: ABdhPJzv6Wgs3C1CuH+vYbbPvcIWxn4HMZYllnavytyIYs7XCm6ET8vQKXqSto+LFcAuje9ZVMIk/A==
X-Received: by 2002:a63:f74b:: with SMTP id f11mr5793647pgk.368.1590614775074;
        Wed, 27 May 2020 14:26:15 -0700 (PDT)
Received: from localhost.localdomain ([2600:8802:202:f600::ddf])
        by smtp.gmail.com with ESMTPSA id c4sm2770344pfb.130.2020.05.27.14.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 14:26:14 -0700 (PDT)
From:   Edwin Peer <edwin.peer@broadcom.com>
To:     netdev@vger.kernel.org
Cc:     Edwin Peer <edwin.peer@broadcom.com>, edumazet@google.com,
        linville@tuxdriver.com, shemminger@vyatta.com,
        mirq-linux@rere.qmqm.pl, jesse.brandeburg@intel.com,
        jchapman@katalix.com, david@weave.works, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, sridhar.samudrala@intel.com,
        jiri@mellanox.com, geoff@infradead.org, mokuno@sm.sony.co.jp,
        msink@permonline.ru, mporter@kernel.crashing.org,
        inaky.perez-gonzalez@intel.com, jwi@linux.ibm.com,
        kgraul@linux.ibm.com, ubraun@linux.ibm.com,
        grant.likely@secretlab.ca, hadi@cyberus.ca, dsahern@kernel.org,
        shrijeet@gmail.com, jon.mason@intel.com, dave.jiang@intel.com,
        saeedm@mellanox.com, hadarh@mellanox.com, ogerlitz@mellanox.com,
        allenbh@gmail.com, michael.chan@broadcom.com
Subject: [RFC PATCH net-next 11/11] net: leverage IFF_NO_VLAN_ROOM to limit NETIF_F_VLAN_CHALLENGED
Date:   Wed, 27 May 2020 14:25:12 -0700
Message-Id: <20200527212512.17901-12-edwin.peer@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527212512.17901-1-edwin.peer@broadcom.com>
References: <20200527212512.17901-1-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This addresses an old FIXME in netdev-features.txt. The new
IFF_NO_VLAN_ROOM infrastructure makes supporting VLANs on most of these
limited devices trivial. VLANs are now supported on these devices if
either:

a) the underlying device's MTU is configured VLAN_HLEN smaller than the
maximum supported MTU, or

b) by the upper VLAN automatically configuring a reduced MTU if the
configured device MTU is too large.

The Mellanox switch driver required a little more refactoring than most
to access the maximum supported MTU from ndo_change_mtu.

The Intel WiMAX 2400M is natively a raw IP device, but the driver
emulates Ethernet headers to present a fake Ethernet device. All these
contortions are probably entirely unnecessary, but absent hardware to
test, changing this aspect seems risky.

The ps3_gelic_net device is also interesting. An outer VLAN is
sometimes used internally to distinguish the output device, but there
doesn't appear to be any reason nested VLAN tags cannot be supported.
Furthermore, with an advertised maximum MTU of 1518, there should be
sufficient room for an additional tag too.

The remaining VLAN challenged holdouts are:
	net/hsr/hsr_device.c
	drivers/net/ipvlan/ipvlan_main.c
	drivers/net/ethernet/mellanox/mlx5/core/en_rep.c

The HSR device could in theory support VLANs, but this would appear to
be a nontrivial exercise. It's not clear why mlx5 representors don't
handle VLANs, but other VF representors do appear to, so perhaps this
could be revised too. That would leave only ipvlan, which unfortantely
does not lend itself to removing NET_F_VLAN_CHALLENGED entirely, since
it has a mode exposing an L2 Ethernet device for which VLANs do not
have any sensible meaning.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
---
 Documentation/networking/netdev-features.rst  |  4 +-
 drivers/net/ethernet/intel/e100.c             | 15 +++++-
 .../net/ethernet/mellanox/mlxsw/switchx2.c    | 52 ++++++++++++++-----
 drivers/net/ethernet/toshiba/ps3_gelic_net.c  | 12 +----
 drivers/net/ethernet/wiznet/w5100.c           |  6 ++-
 drivers/net/ethernet/wiznet/w5300.c           |  6 ++-
 drivers/net/rionet.c                          |  3 ++
 drivers/net/wimax/i2400m/netdev.c             |  5 +-
 drivers/s390/net/qeth_l2_main.c               | 12 ++++-
 9 files changed, 80 insertions(+), 35 deletions(-)

diff --git a/Documentation/networking/netdev-features.rst b/Documentation/networking/netdev-features.rst
index a2d7d7160e39..ca4632839f59 100644
--- a/Documentation/networking/netdev-features.rst
+++ b/Documentation/networking/netdev-features.rst
@@ -157,9 +157,7 @@ Don't use it in drivers.
  * VLAN challenged
 
 NETIF_F_VLAN_CHALLENGED should be set for devices which can't cope with VLAN
-headers. Some drivers set this because the cards can't handle the bigger MTU.
-[FIXME: Those cases could be fixed in VLAN code by allowing only reduced-MTU
-VLANs. This may be not useful, though.]
+headers.
 
 *  rx-fcs
 
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 1b8d015ebfb0..caea569a76c5 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2753,6 +2753,18 @@ static int e100_do_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 	return generic_mii_ioctl(&nic->mii, if_mii(ifr), cmd, NULL);
 }
 
+static int e100_change_mtu(struct net_device *netdev, int new_mtu)
+{
+	struct nic *nic = netdev_priv(netdev);
+
+	netdev->mtu = new_mtu;
+	/* D100 MAC doesn't allow rx of vlan packets with normal MTU */
+	if (nic->mac < mac_82558_D101_A4)
+		vlan_constrain_mtu(netdev);
+
+	return 0;
+}
+
 static int e100_alloc(struct nic *nic)
 {
 	nic->mem = pci_alloc_consistent(nic->pdev, sizeof(struct mem),
@@ -2808,6 +2820,7 @@ static const struct net_device_ops e100_netdev_ops = {
 	.ndo_set_rx_mode	= e100_set_multicast_list,
 	.ndo_set_mac_address	= e100_set_mac_address,
 	.ndo_do_ioctl		= e100_do_ioctl,
+	.ndo_change_mtu		= e100_change_mtu,
 	.ndo_tx_timeout		= e100_tx_timeout,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= e100_netpoll,
@@ -2883,7 +2896,7 @@ static int e100_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* D100 MAC doesn't allow rx of vlan packets with normal MTU */
 	if (nic->mac < mac_82558_D101_A4)
-		netdev->features |= NETIF_F_VLAN_CHALLENGED;
+		netdev->priv_flags |= IFF_NO_VLAN_ROOM;
 
 	/* locks must be initialized before calling hw_reset */
 	spin_lock_init(&nic->cb_lock);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index b438f5576e18..cc25e4bade16 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -184,38 +184,54 @@ static int mlxsw_sx_port_oper_status_get(struct mlxsw_sx_port *mlxsw_sx_port,
 	return 0;
 }
 
-static int __mlxsw_sx_port_mtu_set(struct mlxsw_sx_port *mlxsw_sx_port,
-				   u16 mtu)
+static int mlxsw_sx_port_mtu_max(struct mlxsw_sx_port *mlxsw_sx_port)
 {
 	struct mlxsw_sx *mlxsw_sx = mlxsw_sx_port->mlxsw_sx;
 	char pmtu_pl[MLXSW_REG_PMTU_LEN];
-	int max_mtu;
 	int err;
 
 	mlxsw_reg_pmtu_pack(pmtu_pl, mlxsw_sx_port->local_port, 0);
 	err = mlxsw_reg_query(mlxsw_sx->core, MLXSW_REG(pmtu), pmtu_pl);
 	if (err)
-		return err;
-	max_mtu = mlxsw_reg_pmtu_max_mtu_get(pmtu_pl);
+		return err; /* all errors are negative */
+	return mlxsw_reg_pmtu_max_mtu_get(pmtu_pl);
+}
 
-	if (mtu > max_mtu)
-		return -EINVAL;
+static int ____mlxsw_sx_port_mtu_eth_set(struct mlxsw_sx_port *mlxsw_sx_port,
+					 u16 mtu)
+{
+	struct mlxsw_sx *mlxsw_sx = mlxsw_sx_port->mlxsw_sx;
+	char pmtu_pl[MLXSW_REG_PMTU_LEN];
 
 	mlxsw_reg_pmtu_pack(pmtu_pl, mlxsw_sx_port->local_port, mtu);
 	return mlxsw_reg_write(mlxsw_sx->core, MLXSW_REG(pmtu), pmtu_pl);
 }
 
+static int __mlxsw_sx_port_mtu_eth_set(struct mlxsw_sx_port *mlxsw_sx_port,
+				       u16 mtu)
+{
+	int max_mtu = mlxsw_sx_port_mtu_max(mlxsw_sx_port);
+
+	if (max_mtu < 0)
+		return max_mtu; /* error code */
+
+	if (mtu > max_mtu)
+		return -EINVAL;
+
+	return ____mlxsw_sx_port_mtu_eth_set(mlxsw_sx_port, mtu);
+}
+
 static int mlxsw_sx_port_mtu_eth_set(struct mlxsw_sx_port *mlxsw_sx_port,
 				     u16 mtu)
 {
 	mtu += MLXSW_TXHDR_LEN + ETH_HLEN;
-	return __mlxsw_sx_port_mtu_set(mlxsw_sx_port, mtu);
+	return __mlxsw_sx_port_mtu_eth_set(mlxsw_sx_port, mtu);
 }
 
 static int mlxsw_sx_port_mtu_ib_set(struct mlxsw_sx_port *mlxsw_sx_port,
 				    u16 mtu)
 {
-	return __mlxsw_sx_port_mtu_set(mlxsw_sx_port, mtu);
+	return __mlxsw_sx_port_mtu_eth_set(mlxsw_sx_port, mtu);
 }
 
 static int mlxsw_sx_port_ib_port_set(struct mlxsw_sx_port *mlxsw_sx_port,
@@ -336,12 +352,23 @@ static netdev_tx_t mlxsw_sx_port_xmit(struct sk_buff *skb,
 static int mlxsw_sx_port_change_mtu(struct net_device *dev, int mtu)
 {
 	struct mlxsw_sx_port *mlxsw_sx_port = netdev_priv(dev);
+	int max_mtu = mlxsw_sx_port_mtu_max(mlxsw_sx_port);
 	int err;
 
-	err = mlxsw_sx_port_mtu_eth_set(mlxsw_sx_port, mtu);
+	if (max_mtu < 0)
+		return max_mtu; /* error code */
+
+	max_mtu -= MLXSW_TXHDR_LEN + ETH_HLEN;
+	if (mtu > max_mtu)
+		return -EINVAL;
+
+	err = ____mlxsw_sx_port_mtu_eth_set(mlxsw_sx_port, mtu);
 	if (err)
 		return err;
+
 	dev->mtu = mtu;
+	__vlan_constrain_mtu(dev, max_mtu);
+
 	return 0;
 }
 
@@ -1013,8 +1040,9 @@ static int __mlxsw_sx_port_eth_create(struct mlxsw_sx *mlxsw_sx, u8 local_port,
 
 	netif_carrier_off(dev);
 
-	dev->features |= NETIF_F_NETNS_LOCAL | NETIF_F_LLTX | NETIF_F_SG |
-			 NETIF_F_VLAN_CHALLENGED;
+	dev->features |= NETIF_F_NETNS_LOCAL | NETIF_F_LLTX | NETIF_F_SG;
+
+	dev->priv_flags |= IFF_NO_VLAN_ROOM;
 
 	dev->min_mtu = 0;
 	dev->max_mtu = ETH_MAX_MTU;
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index 310e6839c6e5..7e008139ad22 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -1479,18 +1479,8 @@ int gelic_net_setup_netdev(struct net_device *netdev, struct gelic_card *card)
 	}
 	memcpy(netdev->dev_addr, &v1, ETH_ALEN);
 
-	if (card->vlan_required) {
+	if (card->vlan_required)
 		netdev->hard_header_len += VLAN_HLEN;
-		/*
-		 * As vlan is internally used,
-		 * we can not receive vlan packets
-		 */
-		netdev->features |= NETIF_F_VLAN_CHALLENGED;
-	}
-
-	/* MTU range: 64 - 1518 */
-	netdev->min_mtu = GELIC_NET_MIN_MTU;
-	netdev->max_mtu = GELIC_NET_MAX_MTU;
 
 	status = register_netdev(netdev);
 	if (status) {
diff --git a/drivers/net/ethernet/wiznet/w5100.c b/drivers/net/ethernet/wiznet/w5100.c
index c0d181a7f83a..a417c0dbce56 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -24,6 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/gpio.h>
+#include <linux/if_vlan.h>
 
 #include "w5100.h"
 
@@ -1038,6 +1039,7 @@ static const struct net_device_ops w5100_netdev_ops = {
 	.ndo_set_rx_mode	= w5100_set_rx_mode,
 	.ndo_set_mac_address	= w5100_set_macaddr,
 	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_change_mtu		= vlan_constrained_change_mtu,
 };
 
 static int w5100_mmio_probe(struct platform_device *pdev)
@@ -1137,9 +1139,9 @@ int w5100_probe(struct device *dev, const struct w5100_ops *ops,
 	netif_napi_add(ndev, &priv->napi, w5100_napi_poll, 16);
 
 	/* This chip doesn't support VLAN packets with normal MTU,
-	 * so disable VLAN for this device.
+	 * so constrain MTU of upper VLAN devices.
 	 */
-	ndev->features |= NETIF_F_VLAN_CHALLENGED;
+	ndev->priv_flags |= IFF_NO_VLAN_ROOM;
 
 	err = register_netdev(ndev);
 	if (err < 0)
diff --git a/drivers/net/ethernet/wiznet/w5300.c b/drivers/net/ethernet/wiznet/w5300.c
index 46aae30c4636..e4d97a6749b3 100644
--- a/drivers/net/ethernet/wiznet/w5300.c
+++ b/drivers/net/ethernet/wiznet/w5300.c
@@ -25,6 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/gpio.h>
+#include <linux/if_vlan.h>
 
 #define DRV_NAME	"w5300"
 #define DRV_VERSION	"2012-04-04"
@@ -520,6 +521,7 @@ static const struct net_device_ops w5300_netdev_ops = {
 	.ndo_set_rx_mode	= w5300_set_rx_mode,
 	.ndo_set_mac_address	= w5300_set_macaddr,
 	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_change_mtu		= vlan_constrained_change_mtu,
 };
 
 static int w5300_hw_probe(struct platform_device *pdev)
@@ -606,9 +608,9 @@ static int w5300_probe(struct platform_device *pdev)
 	netif_napi_add(ndev, &priv->napi, w5300_napi_poll, 16);
 
 	/* This chip doesn't support VLAN packets with normal MTU,
-	 * so disable VLAN for this device.
+	 * so constrain MTU of upper VLAN devices.
 	 */
-	ndev->features |= NETIF_F_VLAN_CHALLENGED;
+	ndev->priv_flags |= IFF_NO_VLAN_ROOM;
 
 	err = register_netdev(ndev);
 	if (err < 0)
diff --git a/drivers/net/rionet.c b/drivers/net/rionet.c
index 2056d6ad04b5..1fd7df17d552 100644
--- a/drivers/net/rionet.c
+++ b/drivers/net/rionet.c
@@ -21,6 +21,7 @@
 #include <linux/crc32.h>
 #include <linux/ethtool.h>
 #include <linux/reboot.h>
+#include <linux/if_vlan.h>
 
 #define DRV_NAME        "rionet"
 #define DRV_VERSION     "0.3"
@@ -476,6 +477,7 @@ static const struct net_device_ops rionet_netdev_ops = {
 	.ndo_start_xmit		= rionet_start_xmit,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
+	.ndo_change_mtu		= vlan_constrained_change_mtu,
 };
 
 static int rionet_setup_netdev(struct rio_mport *mport, struct net_device *ndev)
@@ -514,6 +516,7 @@ static int rionet_setup_netdev(struct rio_mport *mport, struct net_device *ndev)
 	ndev->min_mtu = ETH_MIN_MTU;
 	ndev->max_mtu = RIONET_MAX_MTU;
 	ndev->features = NETIF_F_LLTX;
+	ndev->priv_flags |= IFF_NO_VLAN_ROOM;
 	SET_NETDEV_DEV(ndev, &mport->dev);
 	ndev->ethtool_ops = &rionet_ethtool_ops;
 
diff --git a/drivers/net/wimax/i2400m/netdev.c b/drivers/net/wimax/i2400m/netdev.c
index a7fcbceb6e6b..4097182a21c7 100644
--- a/drivers/net/wimax/i2400m/netdev.c
+++ b/drivers/net/wimax/i2400m/netdev.c
@@ -583,13 +583,12 @@ void i2400m_netdev_setup(struct net_device *net_dev)
 {
 	d_fnstart(3, NULL, "(net_dev %p)\n", net_dev);
 	ether_setup(net_dev);
+	net_dev->type = ARPHRD_RAWIP;
 	net_dev->mtu = I2400M_MAX_MTU;
 	net_dev->min_mtu = 0;
 	net_dev->max_mtu = I2400M_MAX_MTU;
 	net_dev->tx_queue_len = I2400M_TX_QLEN;
-	net_dev->features =
-		  NETIF_F_VLAN_CHALLENGED
-		| NETIF_F_HIGHDMA;
+	net_dev->features = NETIF_F_HIGHDMA;
 	net_dev->flags =
 		IFF_NOARP		/* i2400m is apure IP device */
 		& (~IFF_BROADCAST	/* i2400m is P2P */
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index da47e423e1b1..e9507237f3b7 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -629,6 +629,15 @@ static void qeth_l2_set_rx_mode(struct net_device *dev)
 	schedule_work(&card->rx_mode_work);
 }
 
+static int qeth_l2_change_mtu(struct net_device *dev, int new_mtu)
+{
+	struct qeth_card *card = dev->ml_priv;
+
+	dev->mtu = new_mtu;
+	if (IS_OSM(card))
+		vlan_constrain_mtu(dev);
+}
+
 static const struct net_device_ops qeth_l2_netdev_ops = {
 	.ndo_open		= qeth_open,
 	.ndo_stop		= qeth_stop,
@@ -640,6 +649,7 @@ static const struct net_device_ops qeth_l2_netdev_ops = {
 	.ndo_set_rx_mode	= qeth_l2_set_rx_mode,
 	.ndo_do_ioctl		= qeth_do_ioctl,
 	.ndo_set_mac_address    = qeth_l2_set_mac_address,
+	.ndo_change_mtu		= qeth_l2_change_mtu,
 	.ndo_vlan_rx_add_vid	= qeth_l2_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid   = qeth_l2_vlan_rx_kill_vid,
 	.ndo_tx_timeout	   	= qeth_tx_timeout,
@@ -675,7 +685,7 @@ static int qeth_l2_setup_netdev(struct qeth_card *card)
 	card->dev->priv_flags |= IFF_UNICAST_FLT;
 
 	if (IS_OSM(card)) {
-		card->dev->features |= NETIF_F_VLAN_CHALLENGED;
+		card->dev->priv_flags |= IFF_NO_VLAN_ROOM;
 	} else {
 		if (!IS_VM_NIC(card))
 			card->dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
-- 
2.26.2

