Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A057660E205
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbiJZNWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbiJZNWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:22:35 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DD225C66
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:22:24 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1666790543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Xc9erme20QyOav/3shmqYjYHip7g/OsC0Md5ZfTRPQ=;
        b=h+4SZM9wOtz7EpbtSDrgwWQqMftbI2k/GurPeHGUrbj4MrujEwjmUwmeMFiKcFVu4oICxq
        IV4rEJBdZnWTx5chg1H0igX6IBds3HN1V5O4i2z1ZqXNDo3btCApkOFMFDX+3W1RIKJS4Y
        VRlDggnlCuaFxny+xIb1iLFDKhNr8vaxqPFC5U90s40BEnBFLvzgt+2enA8syh1Dz8ZURp
        a581vDLrAsGsFSfbQJoUUon+HHx3tp4MDdYyPTY8YjmplNBojq4EYfpQpdbzfrdSeUOV41
        pzBheXqU23oXonQoUWaNd4KlEUu5Njp45ij8RIwaMyyOukPCovMAhULgtKuPBA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1666790543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Xc9erme20QyOav/3shmqYjYHip7g/OsC0Md5ZfTRPQ=;
        b=rr36dYPoA/buGnctpLHMygiIkbTcJ33UyV79h7FMgB02+tCO5NzvCtsYoapyOJBbxExAH5
        rbc1e44FKE0PcxDw==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH net-next 1/2] net: Remove the obsolte u64_stats_fetch_*_irq() users (drivers).
Date:   Wed, 26 Oct 2022 15:22:14 +0200
Message-Id: <20221026132215.696950-2-bigeasy@linutronix.de>
In-Reply-To: <20221026132215.696950-1-bigeasy@linutronix.de>
References: <20221026132215.696950-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Now that the 32bit UP oddity is gone and 32bit uses always a sequence
count, there is no need for the fetch_irq() variants anymore.

Convert to the regular interface.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 drivers/net/ethernet/alacritech/slic.h        | 12 +++----
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  4 +--
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 12 +++----
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |  8 ++---
 drivers/net/ethernet/asix/ax88796c_main.c     |  4 +--
 drivers/net/ethernet/broadcom/b44.c           |  8 ++---
 drivers/net/ethernet/broadcom/bcmsysport.c    | 12 +++----
 drivers/net/ethernet/cortina/gemini.c         | 24 +++++++-------
 .../net/ethernet/emulex/benet/be_ethtool.c    | 12 +++----
 drivers/net/ethernet/emulex/benet/be_main.c   | 16 +++++-----
 .../ethernet/fungible/funeth/funeth_txrx.h    |  4 +--
 drivers/net/ethernet/google/gve/gve_ethtool.c | 16 +++++-----
 drivers/net/ethernet/google/gve/gve_main.c    | 12 +++----
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  4 +--
 drivers/net/ethernet/huawei/hinic/hinic_rx.c  |  4 +--
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  |  4 +--
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  8 ++---
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  8 ++---
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 20 ++++++------
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |  8 ++---
 drivers/net/ethernet/intel/ice/ice_main.c     |  4 +--
 drivers/net/ethernet/intel/igb/igb_ethtool.c  | 12 +++----
 drivers/net/ethernet/intel/igb/igb_main.c     |  8 ++---
 drivers/net/ethernet/intel/igc/igc_ethtool.c  | 12 +++----
 drivers/net/ethernet/intel/igc/igc_main.c     |  8 ++---
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |  8 ++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  8 ++---
 drivers/net/ethernet/intel/ixgbevf/ethtool.c  | 12 +++----
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  8 ++---
 drivers/net/ethernet/marvell/mvneta.c         |  8 ++---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  8 ++---
 drivers/net/ethernet/marvell/sky2.c           |  8 ++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  8 ++---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  4 +--
 drivers/net/ethernet/microsoft/mana/mana_en.c |  8 ++---
 .../ethernet/microsoft/mana/mana_ethtool.c    |  8 ++---
 .../ethernet/netronome/nfp/nfp_net_common.c   |  8 ++---
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  |  8 ++---
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  4 +--
 drivers/net/ethernet/nvidia/forcedeth.c       |  8 ++---
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |  4 +--
 drivers/net/ethernet/realtek/8139too.c        |  8 ++---
 drivers/net/ethernet/socionext/sni_ave.c      |  8 ++---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  4 +--
 drivers/net/ethernet/ti/netcp_core.c          |  8 ++---
 drivers/net/ethernet/via/via-rhine.c          |  8 ++---
 .../net/ethernet/xilinx/xilinx_axienet_main.c |  8 ++---
 drivers/net/hyperv/netvsc_drv.c               | 32 +++++++++----------
 drivers/net/ifb.c                             | 12 +++----
 drivers/net/ipvlan/ipvlan_main.c              |  4 +--
 drivers/net/loopback.c                        |  4 +--
 drivers/net/macsec.c                          | 12 +++----
 drivers/net/macvlan.c                         |  4 +--
 drivers/net/mhi_net.c                         |  8 ++---
 drivers/net/netdevsim/netdev.c                |  4 +--
 drivers/net/team/team.c                       |  4 +--
 drivers/net/team/team_mode_loadbalance.c      |  4 +--
 drivers/net/veth.c                            | 12 +++----
 drivers/net/virtio_net.c                      | 16 +++++-----
 drivers/net/vrf.c                             |  4 +--
 drivers/net/vxlan/vxlan_vnifilter.c           |  4 +--
 drivers/net/wwan/mhi_wwan_mbim.c              |  8 ++---
 drivers/net/xen-netfront.c                    |  8 ++---
 63 files changed, 274 insertions(+), 274 deletions(-)

diff --git a/drivers/net/ethernet/alacritech/slic.h b/drivers/net/ethernet/=
alacritech/slic.h
index 4eecbdfff3ff1..82071d0e5f7fc 100644
--- a/drivers/net/ethernet/alacritech/slic.h
+++ b/drivers/net/ethernet/alacritech/slic.h
@@ -288,13 +288,13 @@ do {						\
 	u64_stats_update_end(&(st)->syncp);	\
 } while (0)
=20
-#define SLIC_GET_STATS_COUNTER(newst, st, counter)			\
-{									\
-	unsigned int start;						\
+#define SLIC_GET_STATS_COUNTER(newst, st, counter)		\
+{								\
+	unsigned int start;					\
 	do {							\
-		start =3D u64_stats_fetch_begin_irq(&(st)->syncp);	\
-		newst =3D (st)->counter;					\
-	} while (u64_stats_fetch_retry_irq(&(st)->syncp, start));	\
+		start =3D u64_stats_fetch_begin(&(st)->syncp);	\
+		newst =3D (st)->counter;				\
+	} while (u64_stats_fetch_retry(&(st)->syncp, start));	\
 }
=20
 struct slic_upr {
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/et=
hernet/amazon/ena/ena_ethtool.c
index 98d6386b7f398..48ae6d810f8f9 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -118,9 +118,9 @@ static void ena_safe_update_stat(u64 *src, u64 *dst,
 	unsigned int start;
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(syncp);
+		start =3D u64_stats_fetch_begin(syncp);
 		*(dst) =3D *src;
-	} while (u64_stats_fetch_retry_irq(syncp, start));
+	} while (u64_stats_fetch_retry(syncp, start));
 }
=20
 static void ena_queue_stats(struct ena_adapter *adapter, u64 **data)
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/eth=
ernet/amazon/ena/ena_netdev.c
index d350eeec8bad4..df83f04b0980e 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3268,10 +3268,10 @@ static void ena_get_stats64(struct net_device *netd=
ev,
 		tx_ring =3D &adapter->tx_ring[i];
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&tx_ring->syncp);
+			start =3D u64_stats_fetch_begin(&tx_ring->syncp);
 			packets =3D tx_ring->tx_stats.cnt;
 			bytes =3D tx_ring->tx_stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&tx_ring->syncp, start));
+		} while (u64_stats_fetch_retry(&tx_ring->syncp, start));
=20
 		stats->tx_packets +=3D packets;
 		stats->tx_bytes +=3D bytes;
@@ -3279,20 +3279,20 @@ static void ena_get_stats64(struct net_device *netd=
ev,
 		rx_ring =3D &adapter->rx_ring[i];
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&rx_ring->syncp);
+			start =3D u64_stats_fetch_begin(&rx_ring->syncp);
 			packets =3D rx_ring->rx_stats.cnt;
 			bytes =3D rx_ring->rx_stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&rx_ring->syncp, start));
+		} while (u64_stats_fetch_retry(&rx_ring->syncp, start));
=20
 		stats->rx_packets +=3D packets;
 		stats->rx_bytes +=3D bytes;
 	}
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&adapter->syncp);
+		start =3D u64_stats_fetch_begin(&adapter->syncp);
 		rx_drops =3D adapter->dev_stats.rx_drops;
 		tx_drops =3D adapter->dev_stats.tx_drops;
-	} while (u64_stats_fetch_retry_irq(&adapter->syncp, start));
+	} while (u64_stats_fetch_retry(&adapter->syncp, start));
=20
 	stats->rx_dropped =3D rx_drops;
 	stats->tx_dropped =3D tx_drops;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net=
/ethernet/aquantia/atlantic/aq_ring.c
index 25129e723b575..1e8d902e1c8ea 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -934,7 +934,7 @@ unsigned int aq_ring_fill_stats_data(struct aq_ring_s *=
self, u64 *data)
 		/* This data should mimic aq_ethtool_queue_rx_stat_names structure */
 		do {
 			count =3D 0;
-			start =3D u64_stats_fetch_begin_irq(&self->stats.rx.syncp);
+			start =3D u64_stats_fetch_begin(&self->stats.rx.syncp);
 			data[count] =3D self->stats.rx.packets;
 			data[++count] =3D self->stats.rx.jumbo_packets;
 			data[++count] =3D self->stats.rx.lro_packets;
@@ -951,15 +951,15 @@ unsigned int aq_ring_fill_stats_data(struct aq_ring_s=
 *self, u64 *data)
 			data[++count] =3D self->stats.rx.xdp_tx;
 			data[++count] =3D self->stats.rx.xdp_invalid;
 			data[++count] =3D self->stats.rx.xdp_redirect;
-		} while (u64_stats_fetch_retry_irq(&self->stats.rx.syncp, start));
+		} while (u64_stats_fetch_retry(&self->stats.rx.syncp, start));
 	} else {
 		/* This data should mimic aq_ethtool_queue_tx_stat_names structure */
 		do {
 			count =3D 0;
-			start =3D u64_stats_fetch_begin_irq(&self->stats.tx.syncp);
+			start =3D u64_stats_fetch_begin(&self->stats.tx.syncp);
 			data[count] =3D self->stats.tx.packets;
 			data[++count] =3D self->stats.tx.queue_restarts;
-		} while (u64_stats_fetch_retry_irq(&self->stats.tx.syncp, start));
+		} while (u64_stats_fetch_retry(&self->stats.tx.syncp, start));
 	}
=20
 	return ++count;
diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethern=
et/asix/ax88796c_main.c
index 8b7cdf015a16e..21376c79f6711 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -662,12 +662,12 @@ static void ax88796c_get_stats64(struct net_device *n=
dev,
 		s =3D per_cpu_ptr(ax_local->stats, cpu);
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&s->syncp);
+			start =3D u64_stats_fetch_begin(&s->syncp);
 			rx_packets =3D u64_stats_read(&s->rx_packets);
 			rx_bytes   =3D u64_stats_read(&s->rx_bytes);
 			tx_packets =3D u64_stats_read(&s->tx_packets);
 			tx_bytes   =3D u64_stats_read(&s->tx_bytes);
-		} while (u64_stats_fetch_retry_irq(&s->syncp, start));
+		} while (u64_stats_fetch_retry(&s->syncp, start));
=20
 		stats->rx_packets +=3D rx_packets;
 		stats->rx_bytes   +=3D rx_bytes;
diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/bro=
adcom/b44.c
index 7f876721596c1..b751dc8486dcd 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -1680,7 +1680,7 @@ static void b44_get_stats64(struct net_device *dev,
 	unsigned int start;
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&hwstat->syncp);
+		start =3D u64_stats_fetch_begin(&hwstat->syncp);
=20
 		/* Convert HW stats into rtnl_link_stats64 stats. */
 		nstat->rx_packets =3D hwstat->rx_pkts;
@@ -1714,7 +1714,7 @@ static void b44_get_stats64(struct net_device *dev,
 		/* Carrier lost counter seems to be broken for some devices */
 		nstat->tx_carrier_errors =3D hwstat->tx_carrier_lost;
 #endif
-	} while (u64_stats_fetch_retry_irq(&hwstat->syncp, start));
+	} while (u64_stats_fetch_retry(&hwstat->syncp, start));
=20
 }
=20
@@ -2082,12 +2082,12 @@ static void b44_get_ethtool_stats(struct net_device=
 *dev,
 	do {
 		data_src =3D &hwstat->tx_good_octets;
 		data_dst =3D data;
-		start =3D u64_stats_fetch_begin_irq(&hwstat->syncp);
+		start =3D u64_stats_fetch_begin(&hwstat->syncp);
=20
 		for (i =3D 0; i < ARRAY_SIZE(b44_gstrings); i++)
 			*data_dst++ =3D *data_src++;
=20
-	} while (u64_stats_fetch_retry_irq(&hwstat->syncp, start));
+	} while (u64_stats_fetch_retry(&hwstat->syncp, start));
 }
=20
 static void b44_get_wol(struct net_device *dev, struct ethtool_wolinfo *wo=
l)
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ether=
net/broadcom/bcmsysport.c
index 867f14c30e09f..075d34e81a404 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -457,10 +457,10 @@ static void bcm_sysport_update_tx_stats(struct bcm_sy=
sport_priv *priv,
 	for (q =3D 0; q < priv->netdev->num_tx_queues; q++) {
 		ring =3D &priv->tx_rings[q];
 		do {
-			start =3D u64_stats_fetch_begin_irq(&priv->syncp);
+			start =3D u64_stats_fetch_begin(&priv->syncp);
 			bytes =3D ring->bytes;
 			packets =3D ring->packets;
-		} while (u64_stats_fetch_retry_irq(&priv->syncp, start));
+		} while (u64_stats_fetch_retry(&priv->syncp, start));
=20
 		*tx_bytes +=3D bytes;
 		*tx_packets +=3D packets;
@@ -504,9 +504,9 @@ static void bcm_sysport_get_stats(struct net_device *de=
v,
 		if (s->stat_sizeof =3D=3D sizeof(u64) &&
 		    s->type =3D=3D BCM_SYSPORT_STAT_NETDEV64) {
 			do {
-				start =3D u64_stats_fetch_begin_irq(syncp);
+				start =3D u64_stats_fetch_begin(syncp);
 				data[i] =3D *(u64 *)p;
-			} while (u64_stats_fetch_retry_irq(syncp, start));
+			} while (u64_stats_fetch_retry(syncp, start));
 		} else
 			data[i] =3D *(u32 *)p;
 		j++;
@@ -1878,10 +1878,10 @@ static void bcm_sysport_get_stats64(struct net_devi=
ce *dev,
 				    &stats->tx_packets);
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&priv->syncp);
+		start =3D u64_stats_fetch_begin(&priv->syncp);
 		stats->rx_packets =3D stats64->rx_packets;
 		stats->rx_bytes =3D stats64->rx_bytes;
-	} while (u64_stats_fetch_retry_irq(&priv->syncp, start));
+	} while (u64_stats_fetch_retry(&priv->syncp, start));
 }
=20
 static void bcm_sysport_netif_start(struct net_device *dev)
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/c=
ortina/gemini.c
index fdf10318758b4..5715b9ab2712e 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1919,7 +1919,7 @@ static void gmac_get_stats64(struct net_device *netde=
v,
=20
 	/* Racing with RX NAPI */
 	do {
-		start =3D u64_stats_fetch_begin_irq(&port->rx_stats_syncp);
+		start =3D u64_stats_fetch_begin(&port->rx_stats_syncp);
=20
 		stats->rx_packets =3D port->stats.rx_packets;
 		stats->rx_bytes =3D port->stats.rx_bytes;
@@ -1931,11 +1931,11 @@ static void gmac_get_stats64(struct net_device *net=
dev,
 		stats->rx_crc_errors =3D port->stats.rx_crc_errors;
 		stats->rx_frame_errors =3D port->stats.rx_frame_errors;
=20
-	} while (u64_stats_fetch_retry_irq(&port->rx_stats_syncp, start));
+	} while (u64_stats_fetch_retry(&port->rx_stats_syncp, start));
=20
 	/* Racing with MIB and TX completion interrupts */
 	do {
-		start =3D u64_stats_fetch_begin_irq(&port->ir_stats_syncp);
+		start =3D u64_stats_fetch_begin(&port->ir_stats_syncp);
=20
 		stats->tx_errors =3D port->stats.tx_errors;
 		stats->tx_packets =3D port->stats.tx_packets;
@@ -1945,15 +1945,15 @@ static void gmac_get_stats64(struct net_device *net=
dev,
 		stats->rx_missed_errors =3D port->stats.rx_missed_errors;
 		stats->rx_fifo_errors =3D port->stats.rx_fifo_errors;
=20
-	} while (u64_stats_fetch_retry_irq(&port->ir_stats_syncp, start));
+	} while (u64_stats_fetch_retry(&port->ir_stats_syncp, start));
=20
 	/* Racing with hard_start_xmit */
 	do {
-		start =3D u64_stats_fetch_begin_irq(&port->tx_stats_syncp);
+		start =3D u64_stats_fetch_begin(&port->tx_stats_syncp);
=20
 		stats->tx_dropped =3D port->stats.tx_dropped;
=20
-	} while (u64_stats_fetch_retry_irq(&port->tx_stats_syncp, start));
+	} while (u64_stats_fetch_retry(&port->tx_stats_syncp, start));
=20
 	stats->rx_dropped +=3D stats->rx_missed_errors;
 }
@@ -2031,18 +2031,18 @@ static void gmac_get_ethtool_stats(struct net_devic=
e *netdev,
 	/* Racing with MIB interrupt */
 	do {
 		p =3D values;
-		start =3D u64_stats_fetch_begin_irq(&port->ir_stats_syncp);
+		start =3D u64_stats_fetch_begin(&port->ir_stats_syncp);
=20
 		for (i =3D 0; i < RX_STATS_NUM; i++)
 			*p++ =3D port->hw_stats[i];
=20
-	} while (u64_stats_fetch_retry_irq(&port->ir_stats_syncp, start));
+	} while (u64_stats_fetch_retry(&port->ir_stats_syncp, start));
 	values =3D p;
=20
 	/* Racing with RX NAPI */
 	do {
 		p =3D values;
-		start =3D u64_stats_fetch_begin_irq(&port->rx_stats_syncp);
+		start =3D u64_stats_fetch_begin(&port->rx_stats_syncp);
=20
 		for (i =3D 0; i < RX_STATUS_NUM; i++)
 			*p++ =3D port->rx_stats[i];
@@ -2050,13 +2050,13 @@ static void gmac_get_ethtool_stats(struct net_devic=
e *netdev,
 			*p++ =3D port->rx_csum_stats[i];
 		*p++ =3D port->rx_napi_exits;
=20
-	} while (u64_stats_fetch_retry_irq(&port->rx_stats_syncp, start));
+	} while (u64_stats_fetch_retry(&port->rx_stats_syncp, start));
 	values =3D p;
=20
 	/* Racing with TX start_xmit */
 	do {
 		p =3D values;
-		start =3D u64_stats_fetch_begin_irq(&port->tx_stats_syncp);
+		start =3D u64_stats_fetch_begin(&port->tx_stats_syncp);
=20
 		for (i =3D 0; i < TX_MAX_FRAGS; i++) {
 			*values++ =3D port->tx_frag_stats[i];
@@ -2065,7 +2065,7 @@ static void gmac_get_ethtool_stats(struct net_device =
*netdev,
 		*values++ =3D port->tx_frags_linearized;
 		*values++ =3D port->tx_hw_csummed;
=20
-	} while (u64_stats_fetch_retry_irq(&port->tx_stats_syncp, start));
+	} while (u64_stats_fetch_retry(&port->tx_stats_syncp, start));
 }
=20
 static int gmac_get_ksettings(struct net_device *netdev,
diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/e=
thernet/emulex/benet/be_ethtool.c
index 77edc3d9b5057..a29de29bdf231 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -389,10 +389,10 @@ static void be_get_ethtool_stats(struct net_device *n=
etdev,
 		struct be_rx_stats *stats =3D rx_stats(rxo);
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&stats->sync);
+			start =3D u64_stats_fetch_begin(&stats->sync);
 			data[base] =3D stats->rx_bytes;
 			data[base + 1] =3D stats->rx_pkts;
-		} while (u64_stats_fetch_retry_irq(&stats->sync, start));
+		} while (u64_stats_fetch_retry(&stats->sync, start));
=20
 		for (i =3D 2; i < ETHTOOL_RXSTATS_NUM; i++) {
 			p =3D (u8 *)stats + et_rx_stats[i].offset;
@@ -405,19 +405,19 @@ static void be_get_ethtool_stats(struct net_device *n=
etdev,
 		struct be_tx_stats *stats =3D tx_stats(txo);
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&stats->sync_compl);
+			start =3D u64_stats_fetch_begin(&stats->sync_compl);
 			data[base] =3D stats->tx_compl;
-		} while (u64_stats_fetch_retry_irq(&stats->sync_compl, start));
+		} while (u64_stats_fetch_retry(&stats->sync_compl, start));
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&stats->sync);
+			start =3D u64_stats_fetch_begin(&stats->sync);
 			for (i =3D 1; i < ETHTOOL_TXSTATS_NUM; i++) {
 				p =3D (u8 *)stats + et_tx_stats[i].offset;
 				data[base + i] =3D
 					(et_tx_stats[i].size =3D=3D sizeof(u64)) ?
 						*(u64 *)p : *(u32 *)p;
 			}
-		} while (u64_stats_fetch_retry_irq(&stats->sync, start));
+		} while (u64_stats_fetch_retry(&stats->sync, start));
 		base +=3D ETHTOOL_TXSTATS_NUM;
 	}
 }
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethe=
rnet/emulex/benet/be_main.c
index a92a747615466..46fe3d74e2e98 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -665,10 +665,10 @@ static void be_get_stats64(struct net_device *netdev,
 		const struct be_rx_stats *rx_stats =3D rx_stats(rxo);
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&rx_stats->sync);
+			start =3D u64_stats_fetch_begin(&rx_stats->sync);
 			pkts =3D rx_stats(rxo)->rx_pkts;
 			bytes =3D rx_stats(rxo)->rx_bytes;
-		} while (u64_stats_fetch_retry_irq(&rx_stats->sync, start));
+		} while (u64_stats_fetch_retry(&rx_stats->sync, start));
 		stats->rx_packets +=3D pkts;
 		stats->rx_bytes +=3D bytes;
 		stats->multicast +=3D rx_stats(rxo)->rx_mcast_pkts;
@@ -680,10 +680,10 @@ static void be_get_stats64(struct net_device *netdev,
 		const struct be_tx_stats *tx_stats =3D tx_stats(txo);
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&tx_stats->sync);
+			start =3D u64_stats_fetch_begin(&tx_stats->sync);
 			pkts =3D tx_stats(txo)->tx_pkts;
 			bytes =3D tx_stats(txo)->tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&tx_stats->sync, start));
+		} while (u64_stats_fetch_retry(&tx_stats->sync, start));
 		stats->tx_packets +=3D pkts;
 		stats->tx_bytes +=3D bytes;
 	}
@@ -2155,16 +2155,16 @@ static int be_get_new_eqd(struct be_eq_obj *eqo)
=20
 	for_all_rx_queues_on_eq(adapter, eqo, rxo, i) {
 		do {
-			start =3D u64_stats_fetch_begin_irq(&rxo->stats.sync);
+			start =3D u64_stats_fetch_begin(&rxo->stats.sync);
 			rx_pkts +=3D rxo->stats.rx_pkts;
-		} while (u64_stats_fetch_retry_irq(&rxo->stats.sync, start));
+		} while (u64_stats_fetch_retry(&rxo->stats.sync, start));
 	}
=20
 	for_all_tx_queues_on_eq(adapter, eqo, txo, i) {
 		do {
-			start =3D u64_stats_fetch_begin_irq(&txo->stats.sync);
+			start =3D u64_stats_fetch_begin(&txo->stats.sync);
 			tx_pkts +=3D txo->stats.tx_reqs;
-		} while (u64_stats_fetch_retry_irq(&txo->stats.sync, start));
+		} while (u64_stats_fetch_retry(&txo->stats.sync, start));
 	}
=20
 	/* Skip, if wrapped around or first calculation */
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_txrx.h b/drivers/n=
et/ethernet/fungible/funeth/funeth_txrx.h
index 671f51135c269..53b7e95213a85 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
+++ b/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
@@ -206,9 +206,9 @@ struct funeth_rxq {
=20
 #define FUN_QSTAT_READ(q, seq, stats_copy) \
 	do { \
-		seq =3D u64_stats_fetch_begin_irq(&(q)->syncp); \
+		seq =3D u64_stats_fetch_begin(&(q)->syncp); \
 		stats_copy =3D (q)->stats; \
-	} while (u64_stats_fetch_retry_irq(&(q)->syncp, (seq)))
+	} while (u64_stats_fetch_retry(&(q)->syncp, (seq)))
=20
 #define FUN_INT_NAME_LEN (IFNAMSIZ + 16)
=20
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/et=
hernet/google/gve/gve_ethtool.c
index 7b9a2d9d96243..50b384910c839 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -177,14 +177,14 @@ gve_get_ethtool_stats(struct net_device *netdev,
 				struct gve_rx_ring *rx =3D &priv->rx[ring];
=20
 				start =3D
-				  u64_stats_fetch_begin_irq(&priv->rx[ring].statss);
+				  u64_stats_fetch_begin(&priv->rx[ring].statss);
 				tmp_rx_pkts =3D rx->rpackets;
 				tmp_rx_bytes =3D rx->rbytes;
 				tmp_rx_skb_alloc_fail =3D rx->rx_skb_alloc_fail;
 				tmp_rx_buf_alloc_fail =3D rx->rx_buf_alloc_fail;
 				tmp_rx_desc_err_dropped_pkt =3D
 					rx->rx_desc_err_dropped_pkt;
-			} while (u64_stats_fetch_retry_irq(&priv->rx[ring].statss,
+			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
 						       start));
 			rx_pkts +=3D tmp_rx_pkts;
 			rx_bytes +=3D tmp_rx_bytes;
@@ -198,10 +198,10 @@ gve_get_ethtool_stats(struct net_device *netdev,
 		if (priv->tx) {
 			do {
 				start =3D
-				  u64_stats_fetch_begin_irq(&priv->tx[ring].statss);
+				  u64_stats_fetch_begin(&priv->tx[ring].statss);
 				tmp_tx_pkts =3D priv->tx[ring].pkt_done;
 				tmp_tx_bytes =3D priv->tx[ring].bytes_done;
-			} while (u64_stats_fetch_retry_irq(&priv->tx[ring].statss,
+			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
 						       start));
 			tx_pkts +=3D tmp_tx_pkts;
 			tx_bytes +=3D tmp_tx_bytes;
@@ -259,13 +259,13 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			data[i++] =3D rx->fill_cnt - rx->cnt;
 			do {
 				start =3D
-				  u64_stats_fetch_begin_irq(&priv->rx[ring].statss);
+				  u64_stats_fetch_begin(&priv->rx[ring].statss);
 				tmp_rx_bytes =3D rx->rbytes;
 				tmp_rx_skb_alloc_fail =3D rx->rx_skb_alloc_fail;
 				tmp_rx_buf_alloc_fail =3D rx->rx_buf_alloc_fail;
 				tmp_rx_desc_err_dropped_pkt =3D
 					rx->rx_desc_err_dropped_pkt;
-			} while (u64_stats_fetch_retry_irq(&priv->rx[ring].statss,
+			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
 						       start));
 			data[i++] =3D tmp_rx_bytes;
 			data[i++] =3D rx->rx_cont_packet_cnt;
@@ -331,9 +331,9 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			}
 			do {
 				start =3D
-				  u64_stats_fetch_begin_irq(&priv->tx[ring].statss);
+				  u64_stats_fetch_begin(&priv->tx[ring].statss);
 				tmp_tx_bytes =3D tx->bytes_done;
-			} while (u64_stats_fetch_retry_irq(&priv->tx[ring].statss,
+			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
 						       start));
 			data[i++] =3D tmp_tx_bytes;
 			data[i++] =3D tx->wake_queue;
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ether=
net/google/gve/gve_main.c
index d3e3ac242bfc3..5a229a01f49d0 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -51,10 +51,10 @@ static void gve_get_stats(struct net_device *dev, struc=
t rtnl_link_stats64 *s)
 		for (ring =3D 0; ring < priv->rx_cfg.num_queues; ring++) {
 			do {
 				start =3D
-				  u64_stats_fetch_begin_irq(&priv->rx[ring].statss);
+				  u64_stats_fetch_begin(&priv->rx[ring].statss);
 				packets =3D priv->rx[ring].rpackets;
 				bytes =3D priv->rx[ring].rbytes;
-			} while (u64_stats_fetch_retry_irq(&priv->rx[ring].statss,
+			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
 						       start));
 			s->rx_packets +=3D packets;
 			s->rx_bytes +=3D bytes;
@@ -64,10 +64,10 @@ static void gve_get_stats(struct net_device *dev, struc=
t rtnl_link_stats64 *s)
 		for (ring =3D 0; ring < priv->tx_cfg.num_queues; ring++) {
 			do {
 				start =3D
-				  u64_stats_fetch_begin_irq(&priv->tx[ring].statss);
+				  u64_stats_fetch_begin(&priv->tx[ring].statss);
 				packets =3D priv->tx[ring].pkt_done;
 				bytes =3D priv->tx[ring].bytes_done;
-			} while (u64_stats_fetch_retry_irq(&priv->tx[ring].statss,
+			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
 						       start));
 			s->tx_packets +=3D packets;
 			s->tx_bytes +=3D bytes;
@@ -1273,9 +1273,9 @@ void gve_handle_report_stats(struct gve_priv *priv)
 			}
=20
 			do {
-				start =3D u64_stats_fetch_begin_irq(&priv->tx[idx].statss);
+				start =3D u64_stats_fetch_begin(&priv->tx[idx].statss);
 				tx_bytes =3D priv->tx[idx].bytes_done;
-			} while (u64_stats_fetch_retry_irq(&priv->tx[idx].statss, start));
+			} while (u64_stats_fetch_retry(&priv->tx[idx].statss, start));
 			stats[stats_idx++] =3D (struct stats) {
 				.stat_name =3D cpu_to_be32(TX_WAKE_CNT),
 				.value =3D cpu_to_be64(priv->tx[idx].wake_queue),
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/=
ethernet/hisilicon/hns3/hns3_enet.c
index 4cb2421e71a75..813d5b3d7b58c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2486,7 +2486,7 @@ static void hns3_fetch_stats(struct rtnl_link_stats64=
 *stats,
 	unsigned int start;
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&ring->syncp);
+		start =3D u64_stats_fetch_begin(&ring->syncp);
 		if (is_tx) {
 			stats->tx_bytes +=3D ring->stats.tx_bytes;
 			stats->tx_packets +=3D ring->stats.tx_pkts;
@@ -2520,7 +2520,7 @@ static void hns3_fetch_stats(struct rtnl_link_stats64=
 *stats,
 			stats->multicast +=3D ring->stats.rx_multicast;
 			stats->rx_length_errors +=3D ring->stats.err_pkt_len;
 		}
-	} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+	} while (u64_stats_fetch_retry(&ring->syncp, start));
 }
=20
 static void hns3_nic_get_stats64(struct net_device *netdev,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/eth=
ernet/huawei/hinic/hinic_rx.c
index d649c6e323c87..ceec8be2a73b4 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -74,14 +74,14 @@ void hinic_rxq_get_stats(struct hinic_rxq *rxq, struct =
hinic_rxq_stats *stats)
 	unsigned int start;
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&rxq_stats->syncp);
+		start =3D u64_stats_fetch_begin(&rxq_stats->syncp);
 		stats->pkts =3D rxq_stats->pkts;
 		stats->bytes =3D rxq_stats->bytes;
 		stats->errors =3D rxq_stats->csum_errors +
 				rxq_stats->other_errors;
 		stats->csum_errors =3D rxq_stats->csum_errors;
 		stats->other_errors =3D rxq_stats->other_errors;
-	} while (u64_stats_fetch_retry_irq(&rxq_stats->syncp, start));
+	} while (u64_stats_fetch_retry(&rxq_stats->syncp, start));
 }
=20
 /**
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/eth=
ernet/huawei/hinic/hinic_tx.c
index e91476c8ff8b0..ad47ac51a139c 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -99,14 +99,14 @@ void hinic_txq_get_stats(struct hinic_txq *txq, struct =
hinic_txq_stats *stats)
 	unsigned int start;
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&txq_stats->syncp);
+		start =3D u64_stats_fetch_begin(&txq_stats->syncp);
 		stats->pkts    =3D txq_stats->pkts;
 		stats->bytes   =3D txq_stats->bytes;
 		stats->tx_busy =3D txq_stats->tx_busy;
 		stats->tx_wake =3D txq_stats->tx_wake;
 		stats->tx_dropped =3D txq_stats->tx_dropped;
 		stats->big_frags_pkts =3D txq_stats->big_frags_pkts;
-	} while (u64_stats_fetch_retry_irq(&txq_stats->syncp, start));
+	} while (u64_stats_fetch_retry(&txq_stats->syncp, start));
 }
=20
 /**
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/=
ethernet/intel/fm10k/fm10k_netdev.c
index 2cca9e84e31e1..34ab5ff9823b7 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1229,10 +1229,10 @@ static void fm10k_get_stats64(struct net_device *ne=
tdev,
 			continue;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&ring->syncp);
+			start =3D u64_stats_fetch_begin(&ring->syncp);
 			packets =3D ring->stats.packets;
 			bytes   =3D ring->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
=20
 		stats->rx_packets +=3D packets;
 		stats->rx_bytes   +=3D bytes;
@@ -1245,10 +1245,10 @@ static void fm10k_get_stats64(struct net_device *ne=
tdev,
 			continue;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&ring->syncp);
+			start =3D u64_stats_fetch_begin(&ring->syncp);
 			packets =3D ring->stats.packets;
 			bytes   =3D ring->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
=20
 		stats->tx_packets +=3D packets;
 		stats->tx_bytes   +=3D bytes;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/e=
thernet/intel/i40e/i40e_ethtool.c
index 87f36d1ce8008..69a6a6d146460 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -154,7 +154,7 @@ __i40e_add_ethtool_stats(u64 **data, void *pointer,
  * @ring: the ring to copy
  *
  * Queue statistics must be copied while protected by
- * u64_stats_fetch_begin_irq, so we can't directly use i40e_add_ethtool_st=
ats.
+ * u64_stats_fetch_begin, so we can't directly use i40e_add_ethtool_stats.
  * Assumes that queue stats are defined in i40e_gstrings_queue_stats. If t=
he
  * ring pointer is null, zero out the queue stat values and update the data
  * pointer. Otherwise safely copy the stats from the ring into the supplied
@@ -172,16 +172,16 @@ i40e_add_queue_stats(u64 **data, struct i40e_ring *ri=
ng)
=20
 	/* To avoid invalid statistics values, ensure that we keep retrying
 	 * the copy until we get a consistent value according to
-	 * u64_stats_fetch_retry_irq. But first, make sure our ring is
+	 * u64_stats_fetch_retry. But first, make sure our ring is
 	 * non-null before attempting to access its syncp.
 	 */
 	do {
-		start =3D !ring ? 0 : u64_stats_fetch_begin_irq(&ring->syncp);
+		start =3D !ring ? 0 : u64_stats_fetch_begin(&ring->syncp);
 		for (i =3D 0; i < size; i++) {
 			i40e_add_one_ethtool_stat(&(*data)[i], ring,
 						  &stats[i]);
 		}
-	} while (ring && u64_stats_fetch_retry_irq(&ring->syncp, start));
+	} while (ring && u64_stats_fetch_retry(&ring->syncp, start));
=20
 	/* Once we successfully copy the stats in, update the data pointer */
 	*data +=3D size;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethe=
rnet/intel/i40e/i40e_main.c
index b5dcd15ced364..1a1fab94205df 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -419,10 +419,10 @@ static void i40e_get_netdev_stats_struct_tx(struct i4=
0e_ring *ring,
 	unsigned int start;
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&ring->syncp);
+		start =3D u64_stats_fetch_begin(&ring->syncp);
 		packets =3D ring->stats.packets;
 		bytes   =3D ring->stats.bytes;
-	} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+	} while (u64_stats_fetch_retry(&ring->syncp, start));
=20
 	stats->tx_packets +=3D packets;
 	stats->tx_bytes   +=3D bytes;
@@ -472,10 +472,10 @@ static void i40e_get_netdev_stats_struct(struct net_d=
evice *netdev,
 		if (!ring)
 			continue;
 		do {
-			start   =3D u64_stats_fetch_begin_irq(&ring->syncp);
+			start   =3D u64_stats_fetch_begin(&ring->syncp);
 			packets =3D ring->stats.packets;
 			bytes   =3D ring->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
=20
 		stats->rx_packets +=3D packets;
 		stats->rx_bytes   +=3D bytes;
@@ -897,10 +897,10 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vs=
i)
 			continue;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&p->syncp);
+			start =3D u64_stats_fetch_begin(&p->syncp);
 			packets =3D p->stats.packets;
 			bytes =3D p->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&p->syncp, start));
+		} while (u64_stats_fetch_retry(&p->syncp, start));
 		tx_b +=3D bytes;
 		tx_p +=3D packets;
 		tx_restart +=3D p->tx_stats.restart_queue;
@@ -915,10 +915,10 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vs=
i)
 			continue;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&p->syncp);
+			start =3D u64_stats_fetch_begin(&p->syncp);
 			packets =3D p->stats.packets;
 			bytes =3D p->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&p->syncp, start));
+		} while (u64_stats_fetch_retry(&p->syncp, start));
 		rx_b +=3D bytes;
 		rx_p +=3D packets;
 		rx_buf +=3D p->rx_stats.alloc_buff_failed;
@@ -935,10 +935,10 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vs=
i)
 				continue;
=20
 			do {
-				start =3D u64_stats_fetch_begin_irq(&p->syncp);
+				start =3D u64_stats_fetch_begin(&p->syncp);
 				packets =3D p->stats.packets;
 				bytes =3D p->stats.bytes;
-			} while (u64_stats_fetch_retry_irq(&p->syncp, start));
+			} while (u64_stats_fetch_retry(&p->syncp, start));
 			tx_b +=3D bytes;
 			tx_p +=3D packets;
 			tx_restart +=3D p->tx_stats.restart_queue;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/e=
thernet/intel/iavf/iavf_ethtool.c
index a056e15456153..d79ead5e8d0ca 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -147,7 +147,7 @@ __iavf_add_ethtool_stats(u64 **data, void *pointer,
  * @ring: the ring to copy
  *
  * Queue statistics must be copied while protected by
- * u64_stats_fetch_begin_irq, so we can't directly use iavf_add_ethtool_st=
ats.
+ * u64_stats_fetch_begin, so we can't directly use iavf_add_ethtool_stats.
  * Assumes that queue stats are defined in iavf_gstrings_queue_stats. If t=
he
  * ring pointer is null, zero out the queue stat values and update the data
  * pointer. Otherwise safely copy the stats from the ring into the supplied
@@ -165,14 +165,14 @@ iavf_add_queue_stats(u64 **data, struct iavf_ring *ri=
ng)
=20
 	/* To avoid invalid statistics values, ensure that we keep retrying
 	 * the copy until we get a consistent value according to
-	 * u64_stats_fetch_retry_irq. But first, make sure our ring is
+	 * u64_stats_fetch_retry. But first, make sure our ring is
 	 * non-null before attempting to access its syncp.
 	 */
 	do {
-		start =3D !ring ? 0 : u64_stats_fetch_begin_irq(&ring->syncp);
+		start =3D !ring ? 0 : u64_stats_fetch_begin(&ring->syncp);
 		for (i =3D 0; i < size; i++)
 			iavf_add_one_ethtool_stat(&(*data)[i], ring, &stats[i]);
-	} while (ring && u64_stats_fetch_retry_irq(&ring->syncp, start));
+	} while (ring && u64_stats_fetch_retry(&ring->syncp, start));
=20
 	/* Once we successfully copy the stats in, update the data pointer */
 	*data +=3D size;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethern=
et/intel/ice/ice_main.c
index 0f6718719453d..73e02a8ffa9a3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6370,10 +6370,10 @@ ice_fetch_u64_stats_per_ring(struct u64_stats_sync =
*syncp,
 	unsigned int start;
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(syncp);
+		start =3D u64_stats_fetch_begin(syncp);
 		*pkts =3D stats.pkts;
 		*bytes =3D stats.bytes;
-	} while (u64_stats_fetch_retry_irq(syncp, start));
+	} while (u64_stats_fetch_retry(syncp, start));
 }
=20
 /**
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/eth=
ernet/intel/igb/igb_ethtool.c
index e5f3e7680dc66..36acec89d3d49 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -2311,15 +2311,15 @@ static void igb_get_ethtool_stats(struct net_device=
 *netdev,
=20
 		ring =3D adapter->tx_ring[j];
 		do {
-			start =3D u64_stats_fetch_begin_irq(&ring->tx_syncp);
+			start =3D u64_stats_fetch_begin(&ring->tx_syncp);
 			data[i]   =3D ring->tx_stats.packets;
 			data[i+1] =3D ring->tx_stats.bytes;
 			data[i+2] =3D ring->tx_stats.restart_queue;
-		} while (u64_stats_fetch_retry_irq(&ring->tx_syncp, start));
+		} while (u64_stats_fetch_retry(&ring->tx_syncp, start));
 		do {
-			start =3D u64_stats_fetch_begin_irq(&ring->tx_syncp2);
+			start =3D u64_stats_fetch_begin(&ring->tx_syncp2);
 			restart2  =3D ring->tx_stats.restart_queue2;
-		} while (u64_stats_fetch_retry_irq(&ring->tx_syncp2, start));
+		} while (u64_stats_fetch_retry(&ring->tx_syncp2, start));
 		data[i+2] +=3D restart2;
=20
 		i +=3D IGB_TX_QUEUE_STATS_LEN;
@@ -2327,13 +2327,13 @@ static void igb_get_ethtool_stats(struct net_device=
 *netdev,
 	for (j =3D 0; j < adapter->num_rx_queues; j++) {
 		ring =3D adapter->rx_ring[j];
 		do {
-			start =3D u64_stats_fetch_begin_irq(&ring->rx_syncp);
+			start =3D u64_stats_fetch_begin(&ring->rx_syncp);
 			data[i]   =3D ring->rx_stats.packets;
 			data[i+1] =3D ring->rx_stats.bytes;
 			data[i+2] =3D ring->rx_stats.drops;
 			data[i+3] =3D ring->rx_stats.csum_err;
 			data[i+4] =3D ring->rx_stats.alloc_failed;
-		} while (u64_stats_fetch_retry_irq(&ring->rx_syncp, start));
+		} while (u64_stats_fetch_retry(&ring->rx_syncp, start));
 		i +=3D IGB_RX_QUEUE_STATS_LEN;
 	}
 	spin_unlock(&adapter->stats64_lock);
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethern=
et/intel/igb/igb_main.c
index f8e32833226c1..d6c1c2e66f261 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6632,10 +6632,10 @@ void igb_update_stats(struct igb_adapter *adapter)
 		}
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&ring->rx_syncp);
+			start =3D u64_stats_fetch_begin(&ring->rx_syncp);
 			_bytes =3D ring->rx_stats.bytes;
 			_packets =3D ring->rx_stats.packets;
-		} while (u64_stats_fetch_retry_irq(&ring->rx_syncp, start));
+		} while (u64_stats_fetch_retry(&ring->rx_syncp, start));
 		bytes +=3D _bytes;
 		packets +=3D _packets;
 	}
@@ -6648,10 +6648,10 @@ void igb_update_stats(struct igb_adapter *adapter)
 	for (i =3D 0; i < adapter->num_tx_queues; i++) {
 		struct igb_ring *ring =3D adapter->tx_ring[i];
 		do {
-			start =3D u64_stats_fetch_begin_irq(&ring->tx_syncp);
+			start =3D u64_stats_fetch_begin(&ring->tx_syncp);
 			_bytes =3D ring->tx_stats.bytes;
 			_packets =3D ring->tx_stats.packets;
-		} while (u64_stats_fetch_retry_irq(&ring->tx_syncp, start));
+		} while (u64_stats_fetch_retry(&ring->tx_syncp, start));
 		bytes +=3D _bytes;
 		packets +=3D _packets;
 	}
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/eth=
ernet/intel/igc/igc_ethtool.c
index 8cc077b712add..5a26a7805ef80 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -839,15 +839,15 @@ static void igc_ethtool_get_stats(struct net_device *=
netdev,
=20
 		ring =3D adapter->tx_ring[j];
 		do {
-			start =3D u64_stats_fetch_begin_irq(&ring->tx_syncp);
+			start =3D u64_stats_fetch_begin(&ring->tx_syncp);
 			data[i]   =3D ring->tx_stats.packets;
 			data[i + 1] =3D ring->tx_stats.bytes;
 			data[i + 2] =3D ring->tx_stats.restart_queue;
-		} while (u64_stats_fetch_retry_irq(&ring->tx_syncp, start));
+		} while (u64_stats_fetch_retry(&ring->tx_syncp, start));
 		do {
-			start =3D u64_stats_fetch_begin_irq(&ring->tx_syncp2);
+			start =3D u64_stats_fetch_begin(&ring->tx_syncp2);
 			restart2  =3D ring->tx_stats.restart_queue2;
-		} while (u64_stats_fetch_retry_irq(&ring->tx_syncp2, start));
+		} while (u64_stats_fetch_retry(&ring->tx_syncp2, start));
 		data[i + 2] +=3D restart2;
=20
 		i +=3D IGC_TX_QUEUE_STATS_LEN;
@@ -855,13 +855,13 @@ static void igc_ethtool_get_stats(struct net_device *=
netdev,
 	for (j =3D 0; j < adapter->num_rx_queues; j++) {
 		ring =3D adapter->rx_ring[j];
 		do {
-			start =3D u64_stats_fetch_begin_irq(&ring->rx_syncp);
+			start =3D u64_stats_fetch_begin(&ring->rx_syncp);
 			data[i]   =3D ring->rx_stats.packets;
 			data[i + 1] =3D ring->rx_stats.bytes;
 			data[i + 2] =3D ring->rx_stats.drops;
 			data[i + 3] =3D ring->rx_stats.csum_err;
 			data[i + 4] =3D ring->rx_stats.alloc_failed;
-		} while (u64_stats_fetch_retry_irq(&ring->rx_syncp, start));
+		} while (u64_stats_fetch_retry(&ring->rx_syncp, start));
 		i +=3D IGC_RX_QUEUE_STATS_LEN;
 	}
 	spin_unlock(&adapter->stats64_lock);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethern=
et/intel/igc/igc_main.c
index 34889be63e788..5d307b6e660ba 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4682,10 +4682,10 @@ void igc_update_stats(struct igc_adapter *adapter)
 		}
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&ring->rx_syncp);
+			start =3D u64_stats_fetch_begin(&ring->rx_syncp);
 			_bytes =3D ring->rx_stats.bytes;
 			_packets =3D ring->rx_stats.packets;
-		} while (u64_stats_fetch_retry_irq(&ring->rx_syncp, start));
+		} while (u64_stats_fetch_retry(&ring->rx_syncp, start));
 		bytes +=3D _bytes;
 		packets +=3D _packets;
 	}
@@ -4699,10 +4699,10 @@ void igc_update_stats(struct igc_adapter *adapter)
 		struct igc_ring *ring =3D adapter->tx_ring[i];
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&ring->tx_syncp);
+			start =3D u64_stats_fetch_begin(&ring->tx_syncp);
 			_bytes =3D ring->tx_stats.bytes;
 			_packets =3D ring->tx_stats.packets;
-		} while (u64_stats_fetch_retry_irq(&ring->tx_syncp, start));
+		} while (u64_stats_fetch_retry(&ring->tx_syncp, start));
 		bytes +=3D _bytes;
 		packets +=3D _packets;
 	}
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net=
/ethernet/intel/ixgbe/ixgbe_ethtool.c
index e88e3dfac8c21..eda7188e8df44 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -1335,10 +1335,10 @@ static void ixgbe_get_ethtool_stats(struct net_devi=
ce *netdev,
 		}
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&ring->syncp);
+			start =3D u64_stats_fetch_begin(&ring->syncp);
 			data[i]   =3D ring->stats.packets;
 			data[i+1] =3D ring->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
 		i +=3D 2;
 	}
 	for (j =3D 0; j < IXGBE_NUM_RX_QUEUES; j++) {
@@ -1351,10 +1351,10 @@ static void ixgbe_get_ethtool_stats(struct net_devi=
ce *netdev,
 		}
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&ring->syncp);
+			start =3D u64_stats_fetch_begin(&ring->syncp);
 			data[i]   =3D ring->stats.packets;
 			data[i+1] =3D ring->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
 		i +=3D 2;
 	}
=20
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/et=
hernet/intel/ixgbe/ixgbe_main.c
index 298cfbfcb7b6f..ab8370c413f3f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9041,10 +9041,10 @@ static void ixgbe_get_ring_stats64(struct rtnl_link=
_stats64 *stats,
=20
 	if (ring) {
 		do {
-			start =3D u64_stats_fetch_begin_irq(&ring->syncp);
+			start =3D u64_stats_fetch_begin(&ring->syncp);
 			packets =3D ring->stats.packets;
 			bytes   =3D ring->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
 		stats->tx_packets +=3D packets;
 		stats->tx_bytes   +=3D bytes;
 	}
@@ -9064,10 +9064,10 @@ static void ixgbe_get_stats64(struct net_device *ne=
tdev,
=20
 		if (ring) {
 			do {
-				start =3D u64_stats_fetch_begin_irq(&ring->syncp);
+				start =3D u64_stats_fetch_begin(&ring->syncp);
 				packets =3D ring->stats.packets;
 				bytes   =3D ring->stats.bytes;
-			} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+			} while (u64_stats_fetch_retry(&ring->syncp, start));
 			stats->rx_packets +=3D packets;
 			stats->rx_bytes   +=3D bytes;
 		}
diff --git a/drivers/net/ethernet/intel/ixgbevf/ethtool.c b/drivers/net/eth=
ernet/intel/ixgbevf/ethtool.c
index ccfa6b91aac63..296915414a7cf 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
@@ -458,10 +458,10 @@ static void ixgbevf_get_ethtool_stats(struct net_devi=
ce *netdev,
 		}
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&ring->syncp);
+			start =3D u64_stats_fetch_begin(&ring->syncp);
 			data[i]   =3D ring->stats.packets;
 			data[i + 1] =3D ring->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
 		i +=3D 2;
 	}
=20
@@ -475,10 +475,10 @@ static void ixgbevf_get_ethtool_stats(struct net_devi=
ce *netdev,
 		}
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&ring->syncp);
+			start =3D u64_stats_fetch_begin(&ring->syncp);
 			data[i] =3D ring->stats.packets;
 			data[i + 1] =3D ring->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
 		i +=3D 2;
 	}
=20
@@ -492,10 +492,10 @@ static void ixgbevf_get_ethtool_stats(struct net_devi=
ce *netdev,
 		}
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&ring->syncp);
+			start =3D u64_stats_fetch_begin(&ring->syncp);
 			data[i]   =3D ring->stats.packets;
 			data[i + 1] =3D ring->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
 		i +=3D 2;
 	}
 }
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/ne=
t/ethernet/intel/ixgbevf/ixgbevf_main.c
index 99933e89717ad..be733677bdc88 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4350,10 +4350,10 @@ static void ixgbevf_get_tx_ring_stats(struct rtnl_l=
ink_stats64 *stats,
=20
 	if (ring) {
 		do {
-			start =3D u64_stats_fetch_begin_irq(&ring->syncp);
+			start =3D u64_stats_fetch_begin(&ring->syncp);
 			bytes =3D ring->stats.bytes;
 			packets =3D ring->stats.packets;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
 		stats->tx_bytes +=3D bytes;
 		stats->tx_packets +=3D packets;
 	}
@@ -4376,10 +4376,10 @@ static void ixgbevf_get_stats(struct net_device *ne=
tdev,
 	for (i =3D 0; i < adapter->num_rx_queues; i++) {
 		ring =3D adapter->rx_ring[i];
 		do {
-			start =3D u64_stats_fetch_begin_irq(&ring->syncp);
+			start =3D u64_stats_fetch_begin(&ring->syncp);
 			bytes =3D ring->stats.bytes;
 			packets =3D ring->stats.packets;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
 		stats->rx_bytes +=3D bytes;
 		stats->rx_packets +=3D packets;
 	}
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/m=
arvell/mvneta.c
index ff3e361e06e78..81dc57a69fd0a 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -813,14 +813,14 @@ mvneta_get_stats64(struct net_device *dev,
=20
 		cpu_stats =3D per_cpu_ptr(pp->stats, cpu);
 		do {
-			start =3D u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start =3D u64_stats_fetch_begin(&cpu_stats->syncp);
 			rx_packets =3D cpu_stats->es.ps.rx_packets;
 			rx_bytes   =3D cpu_stats->es.ps.rx_bytes;
 			rx_dropped =3D cpu_stats->rx_dropped;
 			rx_errors  =3D cpu_stats->rx_errors;
 			tx_packets =3D cpu_stats->es.ps.tx_packets;
 			tx_bytes   =3D cpu_stats->es.ps.tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
=20
 		stats->rx_packets +=3D rx_packets;
 		stats->rx_bytes   +=3D rx_bytes;
@@ -4762,7 +4762,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *=
pp,
=20
 		stats =3D per_cpu_ptr(pp->stats, cpu);
 		do {
-			start =3D u64_stats_fetch_begin_irq(&stats->syncp);
+			start =3D u64_stats_fetch_begin(&stats->syncp);
 			skb_alloc_error =3D stats->es.skb_alloc_error;
 			refill_error =3D stats->es.refill_error;
 			xdp_redirect =3D stats->es.ps.xdp_redirect;
@@ -4772,7 +4772,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *=
pp,
 			xdp_xmit_err =3D stats->es.ps.xdp_xmit_err;
 			xdp_tx =3D stats->es.ps.xdp_tx;
 			xdp_tx_err =3D stats->es.ps.xdp_tx_err;
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
=20
 		es->skb_alloc_error +=3D skb_alloc_error;
 		es->refill_error +=3D refill_error;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/=
ethernet/marvell/mvpp2/mvpp2_main.c
index eb0fb81280968..116e531720728 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2008,7 +2008,7 @@ mvpp2_get_xdp_stats(struct mvpp2_port *port, struct m=
vpp2_pcpu_stats *xdp_stats)
=20
 		cpu_stats =3D per_cpu_ptr(port->stats, cpu);
 		do {
-			start =3D u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start =3D u64_stats_fetch_begin(&cpu_stats->syncp);
 			xdp_redirect =3D cpu_stats->xdp_redirect;
 			xdp_pass   =3D cpu_stats->xdp_pass;
 			xdp_drop =3D cpu_stats->xdp_drop;
@@ -2016,7 +2016,7 @@ mvpp2_get_xdp_stats(struct mvpp2_port *port, struct m=
vpp2_pcpu_stats *xdp_stats)
 			xdp_xmit_err   =3D cpu_stats->xdp_xmit_err;
 			xdp_tx   =3D cpu_stats->xdp_tx;
 			xdp_tx_err   =3D cpu_stats->xdp_tx_err;
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
=20
 		xdp_stats->xdp_redirect +=3D xdp_redirect;
 		xdp_stats->xdp_pass   +=3D xdp_pass;
@@ -5115,12 +5115,12 @@ mvpp2_get_stats64(struct net_device *dev, struct rt=
nl_link_stats64 *stats)
=20
 		cpu_stats =3D per_cpu_ptr(port->stats, cpu);
 		do {
-			start =3D u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start =3D u64_stats_fetch_begin(&cpu_stats->syncp);
 			rx_packets =3D cpu_stats->rx_packets;
 			rx_bytes   =3D cpu_stats->rx_bytes;
 			tx_packets =3D cpu_stats->tx_packets;
 			tx_bytes   =3D cpu_stats->tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
=20
 		stats->rx_packets +=3D rx_packets;
 		stats->rx_bytes   +=3D rx_bytes;
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/mar=
vell/sky2.c
index ab33ba1c3023c..ff97b140886ae 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -3894,19 +3894,19 @@ static void sky2_get_stats(struct net_device *dev,
 	u64 _bytes, _packets;
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&sky2->rx_stats.syncp);
+		start =3D u64_stats_fetch_begin(&sky2->rx_stats.syncp);
 		_bytes =3D sky2->rx_stats.bytes;
 		_packets =3D sky2->rx_stats.packets;
-	} while (u64_stats_fetch_retry_irq(&sky2->rx_stats.syncp, start));
+	} while (u64_stats_fetch_retry(&sky2->rx_stats.syncp, start));
=20
 	stats->rx_packets =3D _packets;
 	stats->rx_bytes =3D _bytes;
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&sky2->tx_stats.syncp);
+		start =3D u64_stats_fetch_begin(&sky2->tx_stats.syncp);
 		_bytes =3D sky2->tx_stats.bytes;
 		_packets =3D sky2->tx_stats.packets;
-	} while (u64_stats_fetch_retry_irq(&sky2->tx_stats.syncp, start));
+	} while (u64_stats_fetch_retry(&sky2->tx_stats.syncp, start));
=20
 	stats->tx_packets =3D _packets;
 	stats->tx_bytes =3D _bytes;
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethe=
rnet/mediatek/mtk_eth_soc.c
index 7cd381530aa4a..789268b15106e 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -865,7 +865,7 @@ static void mtk_get_stats64(struct net_device *dev,
 	}
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&hw_stats->syncp);
+		start =3D u64_stats_fetch_begin(&hw_stats->syncp);
 		storage->rx_packets =3D hw_stats->rx_packets;
 		storage->tx_packets =3D hw_stats->tx_packets;
 		storage->rx_bytes =3D hw_stats->rx_bytes;
@@ -877,7 +877,7 @@ static void mtk_get_stats64(struct net_device *dev,
 		storage->rx_crc_errors =3D hw_stats->rx_fcs_errors;
 		storage->rx_errors =3D hw_stats->rx_checksum_errors;
 		storage->tx_aborted_errors =3D hw_stats->tx_skip;
-	} while (u64_stats_fetch_retry_irq(&hw_stats->syncp, start));
+	} while (u64_stats_fetch_retry(&hw_stats->syncp, start));
=20
 	storage->tx_errors =3D dev->stats.tx_errors;
 	storage->rx_dropped =3D dev->stats.rx_dropped;
@@ -3684,13 +3684,13 @@ static void mtk_get_ethtool_stats(struct net_device=
 *dev,
=20
 	do {
 		data_dst =3D data;
-		start =3D u64_stats_fetch_begin_irq(&hwstats->syncp);
+		start =3D u64_stats_fetch_begin(&hwstats->syncp);
=20
 		for (i =3D 0; i < ARRAY_SIZE(mtk_ethtool_stats); i++)
 			*data_dst++ =3D *(data_src + mtk_ethtool_stats[i].offset);
 		if (mtk_page_pool_enabled(mac->hw))
 			mtk_ethtool_pp_stats(mac->hw, data_dst);
-	} while (u64_stats_fetch_retry_irq(&hwstats->syncp, start));
+	} while (u64_stats_fetch_retry(&hwstats->syncp, start));
 }
=20
 static int mtk_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/e=
thernet/mellanox/mlxsw/spectrum.c
index 5bcf5bceff710..6ed496f6cbfb2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -827,12 +827,12 @@ mlxsw_sp_port_get_sw_stats64(const struct net_device =
*dev,
 	for_each_possible_cpu(i) {
 		p =3D per_cpu_ptr(mlxsw_sp_port->pcpu_stats, i);
 		do {
-			start =3D u64_stats_fetch_begin_irq(&p->syncp);
+			start =3D u64_stats_fetch_begin(&p->syncp);
 			rx_packets	=3D p->rx_packets;
 			rx_bytes	=3D p->rx_bytes;
 			tx_packets	=3D p->tx_packets;
 			tx_bytes	=3D p->tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&p->syncp, start));
+		} while (u64_stats_fetch_retry(&p->syncp, start));
=20
 		stats->rx_packets	+=3D rx_packets;
 		stats->rx_bytes		+=3D rx_bytes;
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/et=
hernet/microsoft/mana/mana_en.c
index 9259a74eca40b..318dbbb482797 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -315,10 +315,10 @@ static void mana_get_stats64(struct net_device *ndev,
 		rx_stats =3D &apc->rxqs[q]->stats;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&rx_stats->syncp);
+			start =3D u64_stats_fetch_begin(&rx_stats->syncp);
 			packets =3D rx_stats->packets;
 			bytes =3D rx_stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&rx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&rx_stats->syncp, start));
=20
 		st->rx_packets +=3D packets;
 		st->rx_bytes +=3D bytes;
@@ -328,10 +328,10 @@ static void mana_get_stats64(struct net_device *ndev,
 		tx_stats =3D &apc->tx_qp[q].txq.stats;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&tx_stats->syncp);
+			start =3D u64_stats_fetch_begin(&tx_stats->syncp);
 			packets =3D tx_stats->packets;
 			bytes =3D tx_stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&tx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&tx_stats->syncp, start));
=20
 		st->tx_packets +=3D packets;
 		st->tx_bytes +=3D bytes;
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/n=
et/ethernet/microsoft/mana/mana_ethtool.c
index c530db76880f0..96d55c91c9698 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -90,13 +90,13 @@ static void mana_get_ethtool_stats(struct net_device *n=
dev,
 		rx_stats =3D &apc->rxqs[q]->stats;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&rx_stats->syncp);
+			start =3D u64_stats_fetch_begin(&rx_stats->syncp);
 			packets =3D rx_stats->packets;
 			bytes =3D rx_stats->bytes;
 			xdp_drop =3D rx_stats->xdp_drop;
 			xdp_tx =3D rx_stats->xdp_tx;
 			xdp_redirect =3D rx_stats->xdp_redirect;
-		} while (u64_stats_fetch_retry_irq(&rx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&rx_stats->syncp, start));
=20
 		data[i++] =3D packets;
 		data[i++] =3D bytes;
@@ -109,11 +109,11 @@ static void mana_get_ethtool_stats(struct net_device =
*ndev,
 		tx_stats =3D &apc->tx_qp[q].txq.stats;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&tx_stats->syncp);
+			start =3D u64_stats_fetch_begin(&tx_stats->syncp);
 			packets =3D tx_stats->packets;
 			bytes =3D tx_stats->bytes;
 			xdp_xmit =3D tx_stats->xdp_xmit;
-		} while (u64_stats_fetch_retry_irq(&tx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&tx_stats->syncp, start));
=20
 		data[i++] =3D packets;
 		data[i++] =3D bytes;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/=
net/ethernet/netronome/nfp/nfp_net_common.c
index 27f4786ace4fb..a5ca5c4a7896f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1631,21 +1631,21 @@ static void nfp_net_stat64(struct net_device *netde=
v,
 		unsigned int start;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&r_vec->rx_sync);
+			start =3D u64_stats_fetch_begin(&r_vec->rx_sync);
 			data[0] =3D r_vec->rx_pkts;
 			data[1] =3D r_vec->rx_bytes;
 			data[2] =3D r_vec->rx_drops;
-		} while (u64_stats_fetch_retry_irq(&r_vec->rx_sync, start));
+		} while (u64_stats_fetch_retry(&r_vec->rx_sync, start));
 		stats->rx_packets +=3D data[0];
 		stats->rx_bytes +=3D data[1];
 		stats->rx_dropped +=3D data[2];
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&r_vec->tx_sync);
+			start =3D u64_stats_fetch_begin(&r_vec->tx_sync);
 			data[0] =3D r_vec->tx_pkts;
 			data[1] =3D r_vec->tx_bytes;
 			data[2] =3D r_vec->tx_errors;
-		} while (u64_stats_fetch_retry_irq(&r_vec->tx_sync, start));
+		} while (u64_stats_fetch_retry(&r_vec->tx_sync, start));
 		stats->tx_packets +=3D data[0];
 		stats->tx_bytes +=3D data[1];
 		stats->tx_errors +=3D data[2];
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers=
/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 22a5d24190840..f6b09eed73dcb 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -686,7 +686,7 @@ static u64 *nfp_vnic_get_sw_stats(struct net_device *ne=
tdev, u64 *data)
 		unsigned int start;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&nn->r_vecs[i].rx_sync);
+			start =3D u64_stats_fetch_begin(&nn->r_vecs[i].rx_sync);
 			data[0] =3D nn->r_vecs[i].rx_pkts;
 			tmp[0] =3D nn->r_vecs[i].hw_csum_rx_ok;
 			tmp[1] =3D nn->r_vecs[i].hw_csum_rx_inner_ok;
@@ -694,10 +694,10 @@ static u64 *nfp_vnic_get_sw_stats(struct net_device *=
netdev, u64 *data)
 			tmp[3] =3D nn->r_vecs[i].hw_csum_rx_error;
 			tmp[4] =3D nn->r_vecs[i].rx_replace_buf_alloc_fail;
 			tmp[5] =3D nn->r_vecs[i].hw_tls_rx;
-		} while (u64_stats_fetch_retry_irq(&nn->r_vecs[i].rx_sync, start));
+		} while (u64_stats_fetch_retry(&nn->r_vecs[i].rx_sync, start));
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&nn->r_vecs[i].tx_sync);
+			start =3D u64_stats_fetch_begin(&nn->r_vecs[i].tx_sync);
 			data[1] =3D nn->r_vecs[i].tx_pkts;
 			data[2] =3D nn->r_vecs[i].tx_busy;
 			tmp[6] =3D nn->r_vecs[i].hw_csum_tx;
@@ -707,7 +707,7 @@ static u64 *nfp_vnic_get_sw_stats(struct net_device *ne=
tdev, u64 *data)
 			tmp[10] =3D nn->r_vecs[i].hw_tls_tx;
 			tmp[11] =3D nn->r_vecs[i].tls_tx_fallback;
 			tmp[12] =3D nn->r_vecs[i].tls_tx_no_fallback;
-		} while (u64_stats_fetch_retry_irq(&nn->r_vecs[i].tx_sync, start));
+		} while (u64_stats_fetch_retry(&nn->r_vecs[i].tx_sync, start));
=20
 		data +=3D NN_RVEC_PER_Q_STATS;
=20
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/ne=
t/ethernet/netronome/nfp/nfp_net_repr.c
index 8b77582bdfa01..a6b6ca1fd55ee 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -134,13 +134,13 @@ nfp_repr_get_host_stats64(const struct net_device *ne=
tdev,
=20
 		repr_stats =3D per_cpu_ptr(repr->stats, i);
 		do {
-			start =3D u64_stats_fetch_begin_irq(&repr_stats->syncp);
+			start =3D u64_stats_fetch_begin(&repr_stats->syncp);
 			tbytes =3D repr_stats->tx_bytes;
 			tpkts =3D repr_stats->tx_packets;
 			tdrops =3D repr_stats->tx_drops;
 			rbytes =3D repr_stats->rx_bytes;
 			rpkts =3D repr_stats->rx_packets;
-		} while (u64_stats_fetch_retry_irq(&repr_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&repr_stats->syncp, start));
=20
 		stats->tx_bytes +=3D tbytes;
 		stats->tx_packets +=3D tpkts;
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet=
/nvidia/forcedeth.c
index daa028729d444..0605d1ee490dd 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -1734,12 +1734,12 @@ static void nv_get_stats(int cpu, struct fe_priv *n=
p,
 	u64 tx_packets, tx_bytes, tx_dropped;
=20
 	do {
-		syncp_start =3D u64_stats_fetch_begin_irq(&np->swstats_rx_syncp);
+		syncp_start =3D u64_stats_fetch_begin(&np->swstats_rx_syncp);
 		rx_packets       =3D src->stat_rx_packets;
 		rx_bytes         =3D src->stat_rx_bytes;
 		rx_dropped       =3D src->stat_rx_dropped;
 		rx_missed_errors =3D src->stat_rx_missed_errors;
-	} while (u64_stats_fetch_retry_irq(&np->swstats_rx_syncp, syncp_start));
+	} while (u64_stats_fetch_retry(&np->swstats_rx_syncp, syncp_start));
=20
 	storage->rx_packets       +=3D rx_packets;
 	storage->rx_bytes         +=3D rx_bytes;
@@ -1747,11 +1747,11 @@ static void nv_get_stats(int cpu, struct fe_priv *n=
p,
 	storage->rx_missed_errors +=3D rx_missed_errors;
=20
 	do {
-		syncp_start =3D u64_stats_fetch_begin_irq(&np->swstats_tx_syncp);
+		syncp_start =3D u64_stats_fetch_begin(&np->swstats_tx_syncp);
 		tx_packets  =3D src->stat_tx_packets;
 		tx_bytes    =3D src->stat_tx_bytes;
 		tx_dropped  =3D src->stat_tx_dropped;
-	} while (u64_stats_fetch_retry_irq(&np->swstats_tx_syncp, syncp_start));
+	} while (u64_stats_fetch_retry(&np->swstats_tx_syncp, syncp_start));
=20
 	storage->tx_packets +=3D tx_packets;
 	storage->tx_bytes   +=3D tx_bytes;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/=
ethernet/qualcomm/rmnet/rmnet_vnd.c
index 1b2119b1d48aa..3f5e6572d20e7 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -135,9 +135,9 @@ static void rmnet_get_stats64(struct net_device *dev,
 		pcpu_ptr =3D per_cpu_ptr(priv->pcpu_stats, cpu);
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&pcpu_ptr->syncp);
+			start =3D u64_stats_fetch_begin(&pcpu_ptr->syncp);
 			snapshot =3D pcpu_ptr->stats;	/* struct assignment */
-		} while (u64_stats_fetch_retry_irq(&pcpu_ptr->syncp, start));
+		} while (u64_stats_fetch_retry(&pcpu_ptr->syncp, start));
=20
 		total_stats.rx_pkts +=3D snapshot.rx_pkts;
 		total_stats.rx_bytes +=3D snapshot.rx_bytes;
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/=
realtek/8139too.c
index 469e2e229c6e7..9ce0e8a64ba83 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -2532,16 +2532,16 @@ rtl8139_get_stats64(struct net_device *dev, struct =
rtnl_link_stats64 *stats)
 	netdev_stats_to_stats64(stats, &dev->stats);
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&tp->rx_stats.syncp);
+		start =3D u64_stats_fetch_begin(&tp->rx_stats.syncp);
 		stats->rx_packets =3D tp->rx_stats.packets;
 		stats->rx_bytes =3D tp->rx_stats.bytes;
-	} while (u64_stats_fetch_retry_irq(&tp->rx_stats.syncp, start));
+	} while (u64_stats_fetch_retry(&tp->rx_stats.syncp, start));
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&tp->tx_stats.syncp);
+		start =3D u64_stats_fetch_begin(&tp->tx_stats.syncp);
 		stats->tx_packets =3D tp->tx_stats.packets;
 		stats->tx_bytes =3D tp->tx_stats.bytes;
-	} while (u64_stats_fetch_retry_irq(&tp->tx_stats.syncp, start));
+	} while (u64_stats_fetch_retry(&tp->tx_stats.syncp, start));
 }
=20
 /* Set or clear the multicast filter for this adaptor.
diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/etherne=
t/socionext/sni_ave.c
index 1fa09b49ba7fa..a22ee1bac5622 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1506,16 +1506,16 @@ static void ave_get_stats64(struct net_device *ndev,
 	unsigned int start;
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&priv->stats_rx.syncp);
+		start =3D u64_stats_fetch_begin(&priv->stats_rx.syncp);
 		stats->rx_packets =3D priv->stats_rx.packets;
 		stats->rx_bytes	  =3D priv->stats_rx.bytes;
-	} while (u64_stats_fetch_retry_irq(&priv->stats_rx.syncp, start));
+	} while (u64_stats_fetch_retry(&priv->stats_rx.syncp, start));
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&priv->stats_tx.syncp);
+		start =3D u64_stats_fetch_begin(&priv->stats_tx.syncp);
 		stats->tx_packets =3D priv->stats_tx.packets;
 		stats->tx_bytes	  =3D priv->stats_tx.bytes;
-	} while (u64_stats_fetch_retry_irq(&priv->stats_tx.syncp, start));
+	} while (u64_stats_fetch_retry(&priv->stats_tx.syncp, start));
=20
 	stats->rx_errors      =3D priv->stats_rx.errors;
 	stats->tx_errors      =3D priv->stats_tx.errors;
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/etherne=
t/ti/am65-cpsw-nuss.c
index 7f86068f3ff63..8800c8a010ff8 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1362,12 +1362,12 @@ static void am65_cpsw_nuss_ndo_get_stats(struct net=
_device *dev,
=20
 		cpu_stats =3D per_cpu_ptr(ndev_priv->stats, cpu);
 		do {
-			start =3D u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start =3D u64_stats_fetch_begin(&cpu_stats->syncp);
 			rx_packets =3D cpu_stats->rx_packets;
 			rx_bytes   =3D cpu_stats->rx_bytes;
 			tx_packets =3D cpu_stats->tx_packets;
 			tx_bytes   =3D cpu_stats->tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
=20
 		stats->rx_packets +=3D rx_packets;
 		stats->rx_bytes   +=3D rx_bytes;
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti=
/netcp_core.c
index aba70bef48945..8b776f9cdb3f3 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1916,16 +1916,16 @@ netcp_get_stats(struct net_device *ndev, struct rtn=
l_link_stats64 *stats)
 	unsigned int start;
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&p->syncp_rx);
+		start =3D u64_stats_fetch_begin(&p->syncp_rx);
 		rxpackets       =3D p->rx_packets;
 		rxbytes         =3D p->rx_bytes;
-	} while (u64_stats_fetch_retry_irq(&p->syncp_rx, start));
+	} while (u64_stats_fetch_retry(&p->syncp_rx, start));
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&p->syncp_tx);
+		start =3D u64_stats_fetch_begin(&p->syncp_tx);
 		txpackets       =3D p->tx_packets;
 		txbytes         =3D p->tx_bytes;
-	} while (u64_stats_fetch_retry_irq(&p->syncp_tx, start));
+	} while (u64_stats_fetch_retry(&p->syncp_tx, start));
=20
 	stats->rx_packets =3D rxpackets;
 	stats->rx_bytes =3D rxbytes;
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/vi=
a/via-rhine.c
index 0fb15a17b5472..d716e6fe26e1c 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -2217,16 +2217,16 @@ rhine_get_stats64(struct net_device *dev, struct rt=
nl_link_stats64 *stats)
 	netdev_stats_to_stats64(stats, &dev->stats);
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&rp->rx_stats.syncp);
+		start =3D u64_stats_fetch_begin(&rp->rx_stats.syncp);
 		stats->rx_packets =3D rp->rx_stats.packets;
 		stats->rx_bytes =3D rp->rx_stats.bytes;
-	} while (u64_stats_fetch_retry_irq(&rp->rx_stats.syncp, start));
+	} while (u64_stats_fetch_retry(&rp->rx_stats.syncp, start));
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&rp->tx_stats.syncp);
+		start =3D u64_stats_fetch_begin(&rp->tx_stats.syncp);
 		stats->tx_packets =3D rp->tx_stats.packets;
 		stats->tx_bytes =3D rp->tx_stats.bytes;
-	} while (u64_stats_fetch_retry_irq(&rp->tx_stats.syncp, start));
+	} while (u64_stats_fetch_retry(&rp->tx_stats.syncp, start));
 }
=20
 static void rhine_set_rx_mode(struct net_device *dev)
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/ne=
t/ethernet/xilinx/xilinx_axienet_main.c
index d1d772580da98..441e1058104fa 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1305,16 +1305,16 @@ axienet_get_stats64(struct net_device *dev, struct =
rtnl_link_stats64 *stats)
 	netdev_stats_to_stats64(stats, &dev->stats);
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&lp->rx_stat_sync);
+		start =3D u64_stats_fetch_begin(&lp->rx_stat_sync);
 		stats->rx_packets =3D u64_stats_read(&lp->rx_packets);
 		stats->rx_bytes =3D u64_stats_read(&lp->rx_bytes);
-	} while (u64_stats_fetch_retry_irq(&lp->rx_stat_sync, start));
+	} while (u64_stats_fetch_retry(&lp->rx_stat_sync, start));
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&lp->tx_stat_sync);
+		start =3D u64_stats_fetch_begin(&lp->tx_stat_sync);
 		stats->tx_packets =3D u64_stats_read(&lp->tx_packets);
 		stats->tx_bytes =3D u64_stats_read(&lp->tx_bytes);
-	} while (u64_stats_fetch_retry_irq(&lp->tx_stat_sync, start));
+	} while (u64_stats_fetch_retry(&lp->tx_stat_sync, start));
 }
=20
 static const struct net_device_ops axienet_netdev_ops =3D {
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_dr=
v.c
index 89eb4f179a3ce..f9b219e6cd58b 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1264,12 +1264,12 @@ static void netvsc_get_vf_stats(struct net_device *=
net,
 		unsigned int start;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&stats->syncp);
+			start =3D u64_stats_fetch_begin(&stats->syncp);
 			rx_packets =3D stats->rx_packets;
 			tx_packets =3D stats->tx_packets;
 			rx_bytes =3D stats->rx_bytes;
 			tx_bytes =3D stats->tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
=20
 		tot->rx_packets +=3D rx_packets;
 		tot->tx_packets +=3D tx_packets;
@@ -1294,12 +1294,12 @@ static void netvsc_get_pcpu_stats(struct net_device=
 *net,
 		unsigned int start;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&stats->syncp);
+			start =3D u64_stats_fetch_begin(&stats->syncp);
 			this_tot->vf_rx_packets =3D stats->rx_packets;
 			this_tot->vf_tx_packets =3D stats->tx_packets;
 			this_tot->vf_rx_bytes =3D stats->rx_bytes;
 			this_tot->vf_tx_bytes =3D stats->tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
 		this_tot->rx_packets =3D this_tot->vf_rx_packets;
 		this_tot->tx_packets =3D this_tot->vf_tx_packets;
 		this_tot->rx_bytes   =3D this_tot->vf_rx_bytes;
@@ -1318,20 +1318,20 @@ static void netvsc_get_pcpu_stats(struct net_device=
 *net,
=20
 		tx_stats =3D &nvchan->tx_stats;
 		do {
-			start =3D u64_stats_fetch_begin_irq(&tx_stats->syncp);
+			start =3D u64_stats_fetch_begin(&tx_stats->syncp);
 			packets =3D tx_stats->packets;
 			bytes =3D tx_stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&tx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&tx_stats->syncp, start));
=20
 		this_tot->tx_bytes	+=3D bytes;
 		this_tot->tx_packets	+=3D packets;
=20
 		rx_stats =3D &nvchan->rx_stats;
 		do {
-			start =3D u64_stats_fetch_begin_irq(&rx_stats->syncp);
+			start =3D u64_stats_fetch_begin(&rx_stats->syncp);
 			packets =3D rx_stats->packets;
 			bytes =3D rx_stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&rx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&rx_stats->syncp, start));
=20
 		this_tot->rx_bytes	+=3D bytes;
 		this_tot->rx_packets	+=3D packets;
@@ -1370,21 +1370,21 @@ static void netvsc_get_stats64(struct net_device *n=
et,
=20
 		tx_stats =3D &nvchan->tx_stats;
 		do {
-			start =3D u64_stats_fetch_begin_irq(&tx_stats->syncp);
+			start =3D u64_stats_fetch_begin(&tx_stats->syncp);
 			packets =3D tx_stats->packets;
 			bytes =3D tx_stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&tx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&tx_stats->syncp, start));
=20
 		t->tx_bytes	+=3D bytes;
 		t->tx_packets	+=3D packets;
=20
 		rx_stats =3D &nvchan->rx_stats;
 		do {
-			start =3D u64_stats_fetch_begin_irq(&rx_stats->syncp);
+			start =3D u64_stats_fetch_begin(&rx_stats->syncp);
 			packets =3D rx_stats->packets;
 			bytes =3D rx_stats->bytes;
 			multicast =3D rx_stats->multicast + rx_stats->broadcast;
-		} while (u64_stats_fetch_retry_irq(&rx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&rx_stats->syncp, start));
=20
 		t->rx_bytes	+=3D bytes;
 		t->rx_packets	+=3D packets;
@@ -1527,24 +1527,24 @@ static void netvsc_get_ethtool_stats(struct net_dev=
ice *dev,
 		tx_stats =3D &nvdev->chan_table[j].tx_stats;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&tx_stats->syncp);
+			start =3D u64_stats_fetch_begin(&tx_stats->syncp);
 			packets =3D tx_stats->packets;
 			bytes =3D tx_stats->bytes;
 			xdp_xmit =3D tx_stats->xdp_xmit;
-		} while (u64_stats_fetch_retry_irq(&tx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&tx_stats->syncp, start));
 		data[i++] =3D packets;
 		data[i++] =3D bytes;
 		data[i++] =3D xdp_xmit;
=20
 		rx_stats =3D &nvdev->chan_table[j].rx_stats;
 		do {
-			start =3D u64_stats_fetch_begin_irq(&rx_stats->syncp);
+			start =3D u64_stats_fetch_begin(&rx_stats->syncp);
 			packets =3D rx_stats->packets;
 			bytes =3D rx_stats->bytes;
 			xdp_drop =3D rx_stats->xdp_drop;
 			xdp_redirect =3D rx_stats->xdp_redirect;
 			xdp_tx =3D rx_stats->xdp_tx;
-		} while (u64_stats_fetch_retry_irq(&rx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&rx_stats->syncp, start));
 		data[i++] =3D packets;
 		data[i++] =3D bytes;
 		data[i++] =3D xdp_drop;
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 1c64d5347b8e0..78253ad57b2ef 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -162,18 +162,18 @@ static void ifb_stats64(struct net_device *dev,
=20
 	for (i =3D 0; i < dev->num_tx_queues; i++,txp++) {
 		do {
-			start =3D u64_stats_fetch_begin_irq(&txp->rx_stats.sync);
+			start =3D u64_stats_fetch_begin(&txp->rx_stats.sync);
 			packets =3D txp->rx_stats.packets;
 			bytes =3D txp->rx_stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&txp->rx_stats.sync, start));
+		} while (u64_stats_fetch_retry(&txp->rx_stats.sync, start));
 		stats->rx_packets +=3D packets;
 		stats->rx_bytes +=3D bytes;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&txp->tx_stats.sync);
+			start =3D u64_stats_fetch_begin(&txp->tx_stats.sync);
 			packets =3D txp->tx_stats.packets;
 			bytes =3D txp->tx_stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&txp->tx_stats.sync, start));
+		} while (u64_stats_fetch_retry(&txp->tx_stats.sync, start));
 		stats->tx_packets +=3D packets;
 		stats->tx_bytes +=3D bytes;
 	}
@@ -245,12 +245,12 @@ static void ifb_fill_stats_data(u64 **data,
 	int j;
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&q_stats->sync);
+		start =3D u64_stats_fetch_begin(&q_stats->sync);
 		for (j =3D 0; j < IFB_Q_STATS_LEN; j++) {
 			offset =3D ifb_q_stats_desc[j].offset;
 			(*data)[j] =3D *(u64 *)(stats_base + offset);
 		}
-	} while (u64_stats_fetch_retry_irq(&q_stats->sync, start));
+	} while (u64_stats_fetch_retry(&q_stats->sync, start));
=20
 	*data +=3D IFB_Q_STATS_LEN;
 }
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_m=
ain.c
index 54c94a69c2bb8..b6bfa9fdca623 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -299,13 +299,13 @@ static void ipvlan_get_stats64(struct net_device *dev,
 		for_each_possible_cpu(idx) {
 			pcptr =3D per_cpu_ptr(ipvlan->pcpu_stats, idx);
 			do {
-				strt=3D u64_stats_fetch_begin_irq(&pcptr->syncp);
+				strt =3D u64_stats_fetch_begin(&pcptr->syncp);
 				rx_pkts =3D u64_stats_read(&pcptr->rx_pkts);
 				rx_bytes =3D u64_stats_read(&pcptr->rx_bytes);
 				rx_mcast =3D u64_stats_read(&pcptr->rx_mcast);
 				tx_pkts =3D u64_stats_read(&pcptr->tx_pkts);
 				tx_bytes =3D u64_stats_read(&pcptr->tx_bytes);
-			} while (u64_stats_fetch_retry_irq(&pcptr->syncp,
+			} while (u64_stats_fetch_retry(&pcptr->syncp,
 							   strt));
=20
 			s->rx_packets +=3D rx_pkts;
diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 14e8d04cb4347..c4ad98d39ea60 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -106,10 +106,10 @@ void dev_lstats_read(struct net_device *dev, u64 *pac=
kets, u64 *bytes)
=20
 		lb_stats =3D per_cpu_ptr(dev->lstats, i);
 		do {
-			start =3D u64_stats_fetch_begin_irq(&lb_stats->syncp);
+			start =3D u64_stats_fetch_begin(&lb_stats->syncp);
 			tpackets =3D u64_stats_read(&lb_stats->packets);
 			tbytes =3D u64_stats_read(&lb_stats->bytes);
-		} while (u64_stats_fetch_retry_irq(&lb_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&lb_stats->syncp, start));
 		*bytes   +=3D tbytes;
 		*packets +=3D tpackets;
 	}
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index c891b60937a7f..ad38fadd0d896 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2795,9 +2795,9 @@ static void get_rx_sc_stats(struct net_device *dev,
=20
 		stats =3D per_cpu_ptr(rx_sc->stats, cpu);
 		do {
-			start =3D u64_stats_fetch_begin_irq(&stats->syncp);
+			start =3D u64_stats_fetch_begin(&stats->syncp);
 			memcpy(&tmp, &stats->stats, sizeof(tmp));
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
=20
 		sum->InOctetsValidated +=3D tmp.InOctetsValidated;
 		sum->InOctetsDecrypted +=3D tmp.InOctetsDecrypted;
@@ -2876,9 +2876,9 @@ static void get_tx_sc_stats(struct net_device *dev,
=20
 		stats =3D per_cpu_ptr(macsec_priv(dev)->secy.tx_sc.stats, cpu);
 		do {
-			start =3D u64_stats_fetch_begin_irq(&stats->syncp);
+			start =3D u64_stats_fetch_begin(&stats->syncp);
 			memcpy(&tmp, &stats->stats, sizeof(tmp));
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
=20
 		sum->OutPktsProtected   +=3D tmp.OutPktsProtected;
 		sum->OutPktsEncrypted   +=3D tmp.OutPktsEncrypted;
@@ -2932,9 +2932,9 @@ static void get_secy_stats(struct net_device *dev, st=
ruct macsec_dev_stats *sum)
=20
 		stats =3D per_cpu_ptr(macsec_priv(dev)->stats, cpu);
 		do {
-			start =3D u64_stats_fetch_begin_irq(&stats->syncp);
+			start =3D u64_stats_fetch_begin(&stats->syncp);
 			memcpy(&tmp, &stats->stats, sizeof(tmp));
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
=20
 		sum->OutPktsUntagged  +=3D tmp.OutPktsUntagged;
 		sum->InPktsUntagged   +=3D tmp.InPktsUntagged;
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index c5cfe85551992..c58fea63be7d7 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -948,13 +948,13 @@ static void macvlan_dev_get_stats64(struct net_device=
 *dev,
 		for_each_possible_cpu(i) {
 			p =3D per_cpu_ptr(vlan->pcpu_stats, i);
 			do {
-				start =3D u64_stats_fetch_begin_irq(&p->syncp);
+				start =3D u64_stats_fetch_begin(&p->syncp);
 				rx_packets	=3D u64_stats_read(&p->rx_packets);
 				rx_bytes	=3D u64_stats_read(&p->rx_bytes);
 				rx_multicast	=3D u64_stats_read(&p->rx_multicast);
 				tx_packets	=3D u64_stats_read(&p->tx_packets);
 				tx_bytes	=3D u64_stats_read(&p->tx_bytes);
-			} while (u64_stats_fetch_retry_irq(&p->syncp, start));
+			} while (u64_stats_fetch_retry(&p->syncp, start));
=20
 			stats->rx_packets	+=3D rx_packets;
 			stats->rx_bytes		+=3D rx_bytes;
diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index 0b1b6f650104b..ff302144029de 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -104,19 +104,19 @@ static void mhi_ndo_get_stats64(struct net_device *nd=
ev,
 	unsigned int start;
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&mhi_netdev->stats.rx_syncp);
+		start =3D u64_stats_fetch_begin(&mhi_netdev->stats.rx_syncp);
 		stats->rx_packets =3D u64_stats_read(&mhi_netdev->stats.rx_packets);
 		stats->rx_bytes =3D u64_stats_read(&mhi_netdev->stats.rx_bytes);
 		stats->rx_errors =3D u64_stats_read(&mhi_netdev->stats.rx_errors);
-	} while (u64_stats_fetch_retry_irq(&mhi_netdev->stats.rx_syncp, start));
+	} while (u64_stats_fetch_retry(&mhi_netdev->stats.rx_syncp, start));
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&mhi_netdev->stats.tx_syncp);
+		start =3D u64_stats_fetch_begin(&mhi_netdev->stats.tx_syncp);
 		stats->tx_packets =3D u64_stats_read(&mhi_netdev->stats.tx_packets);
 		stats->tx_bytes =3D u64_stats_read(&mhi_netdev->stats.tx_bytes);
 		stats->tx_errors =3D u64_stats_read(&mhi_netdev->stats.tx_errors);
 		stats->tx_dropped =3D u64_stats_read(&mhi_netdev->stats.tx_dropped);
-	} while (u64_stats_fetch_retry_irq(&mhi_netdev->stats.tx_syncp, start));
+	} while (u64_stats_fetch_retry(&mhi_netdev->stats.tx_syncp, start));
 }
=20
 static const struct net_device_ops mhi_netdev_ops =3D {
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 9a1a5b2036240..e470e3398abc2 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -67,10 +67,10 @@ nsim_get_stats64(struct net_device *dev, struct rtnl_li=
nk_stats64 *stats)
 	unsigned int start;
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&ns->syncp);
+		start =3D u64_stats_fetch_begin(&ns->syncp);
 		stats->tx_bytes =3D ns->tx_bytes;
 		stats->tx_packets =3D ns->tx_packets;
-	} while (u64_stats_fetch_retry_irq(&ns->syncp, start));
+	} while (u64_stats_fetch_retry(&ns->syncp, start));
 }
=20
 static int
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 62ade69295a94..d10606f257c43 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1865,13 +1865,13 @@ team_get_stats64(struct net_device *dev, struct rtn=
l_link_stats64 *stats)
 	for_each_possible_cpu(i) {
 		p =3D per_cpu_ptr(team->pcpu_stats, i);
 		do {
-			start =3D u64_stats_fetch_begin_irq(&p->syncp);
+			start =3D u64_stats_fetch_begin(&p->syncp);
 			rx_packets	=3D u64_stats_read(&p->rx_packets);
 			rx_bytes	=3D u64_stats_read(&p->rx_bytes);
 			rx_multicast	=3D u64_stats_read(&p->rx_multicast);
 			tx_packets	=3D u64_stats_read(&p->tx_packets);
 			tx_bytes	=3D u64_stats_read(&p->tx_bytes);
-		} while (u64_stats_fetch_retry_irq(&p->syncp, start));
+		} while (u64_stats_fetch_retry(&p->syncp, start));
=20
 		stats->rx_packets	+=3D rx_packets;
 		stats->rx_bytes		+=3D rx_bytes;
diff --git a/drivers/net/team/team_mode_loadbalance.c b/drivers/net/team/te=
am_mode_loadbalance.c
index b095a4b4957bb..18d99fda997cf 100644
--- a/drivers/net/team/team_mode_loadbalance.c
+++ b/drivers/net/team/team_mode_loadbalance.c
@@ -466,9 +466,9 @@ static void __lb_one_cpu_stats_add(struct lb_stats *acc=
_stats,
 	struct lb_stats tmp;
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(syncp);
+		start =3D u64_stats_fetch_begin(syncp);
 		tmp.tx_bytes =3D cpu_stats->tx_bytes;
-	} while (u64_stats_fetch_retry_irq(syncp, start));
+	} while (u64_stats_fetch_retry(syncp, start));
 	acc_stats->tx_bytes +=3D tmp.tx_bytes;
 }
=20
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 09682ea3354e9..740506c44427d 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -182,12 +182,12 @@ static void veth_get_ethtool_stats(struct net_device =
*dev,
 		size_t offset;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&rq_stats->syncp);
+			start =3D u64_stats_fetch_begin(&rq_stats->syncp);
 			for (j =3D 0; j < VETH_RQ_STATS_LEN; j++) {
 				offset =3D veth_rq_stats_desc[j].offset;
 				data[idx + j] =3D *(u64 *)(stats_base + offset);
 			}
-		} while (u64_stats_fetch_retry_irq(&rq_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&rq_stats->syncp, start));
 		idx +=3D VETH_RQ_STATS_LEN;
 	}
=20
@@ -203,12 +203,12 @@ static void veth_get_ethtool_stats(struct net_device =
*dev,
=20
 		tx_idx +=3D (i % dev->real_num_tx_queues) * VETH_TQ_STATS_LEN;
 		do {
-			start =3D u64_stats_fetch_begin_irq(&rq_stats->syncp);
+			start =3D u64_stats_fetch_begin(&rq_stats->syncp);
 			for (j =3D 0; j < VETH_TQ_STATS_LEN; j++) {
 				offset =3D veth_tq_stats_desc[j].offset;
 				data[tx_idx + j] +=3D *(u64 *)(base + offset);
 			}
-		} while (u64_stats_fetch_retry_irq(&rq_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&rq_stats->syncp, start));
 	}
 }
=20
@@ -379,13 +379,13 @@ static void veth_stats_rx(struct veth_stats *result, =
struct net_device *dev)
 		unsigned int start;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&stats->syncp);
+			start =3D u64_stats_fetch_begin(&stats->syncp);
 			peer_tq_xdp_xmit_err =3D stats->vs.peer_tq_xdp_xmit_err;
 			xdp_tx_err =3D stats->vs.xdp_tx_err;
 			packets =3D stats->vs.xdp_packets;
 			bytes =3D stats->vs.xdp_bytes;
 			drops =3D stats->vs.rx_drops;
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
 		result->peer_tq_xdp_xmit_err +=3D peer_tq_xdp_xmit_err;
 		result->xdp_tx_err +=3D xdp_tx_err;
 		result->xdp_packets +=3D packets;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7106932c6f887..56dbd645d7c86 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2069,18 +2069,18 @@ static void virtnet_stats(struct net_device *dev,
 		struct send_queue *sq =3D &vi->sq[i];
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&sq->stats.syncp);
+			start =3D u64_stats_fetch_begin(&sq->stats.syncp);
 			tpackets =3D sq->stats.packets;
 			tbytes   =3D sq->stats.bytes;
 			terrors  =3D sq->stats.tx_timeouts;
-		} while (u64_stats_fetch_retry_irq(&sq->stats.syncp, start));
+		} while (u64_stats_fetch_retry(&sq->stats.syncp, start));
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&rq->stats.syncp);
+			start =3D u64_stats_fetch_begin(&rq->stats.syncp);
 			rpackets =3D rq->stats.packets;
 			rbytes   =3D rq->stats.bytes;
 			rdrops   =3D rq->stats.drops;
-		} while (u64_stats_fetch_retry_irq(&rq->stats.syncp, start));
+		} while (u64_stats_fetch_retry(&rq->stats.syncp, start));
=20
 		tot->rx_packets +=3D rpackets;
 		tot->tx_packets +=3D tpackets;
@@ -2691,12 +2691,12 @@ static void virtnet_get_ethtool_stats(struct net_de=
vice *dev,
=20
 		stats_base =3D (u8 *)&rq->stats;
 		do {
-			start =3D u64_stats_fetch_begin_irq(&rq->stats.syncp);
+			start =3D u64_stats_fetch_begin(&rq->stats.syncp);
 			for (j =3D 0; j < VIRTNET_RQ_STATS_LEN; j++) {
 				offset =3D virtnet_rq_stats_desc[j].offset;
 				data[idx + j] =3D *(u64 *)(stats_base + offset);
 			}
-		} while (u64_stats_fetch_retry_irq(&rq->stats.syncp, start));
+		} while (u64_stats_fetch_retry(&rq->stats.syncp, start));
 		idx +=3D VIRTNET_RQ_STATS_LEN;
 	}
=20
@@ -2705,12 +2705,12 @@ static void virtnet_get_ethtool_stats(struct net_de=
vice *dev,
=20
 		stats_base =3D (u8 *)&sq->stats;
 		do {
-			start =3D u64_stats_fetch_begin_irq(&sq->stats.syncp);
+			start =3D u64_stats_fetch_begin(&sq->stats.syncp);
 			for (j =3D 0; j < VIRTNET_SQ_STATS_LEN; j++) {
 				offset =3D virtnet_sq_stats_desc[j].offset;
 				data[idx + j] =3D *(u64 *)(stats_base + offset);
 			}
-		} while (u64_stats_fetch_retry_irq(&sq->stats.syncp, start));
+		} while (u64_stats_fetch_retry(&sq->stats.syncp, start));
 		idx +=3D VIRTNET_SQ_STATS_LEN;
 	}
 }
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index badf6f09ae51c..6b5a4d036d153 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -159,13 +159,13 @@ static void vrf_get_stats64(struct net_device *dev,
=20
 		dstats =3D per_cpu_ptr(dev->dstats, i);
 		do {
-			start =3D u64_stats_fetch_begin_irq(&dstats->syncp);
+			start =3D u64_stats_fetch_begin(&dstats->syncp);
 			tbytes =3D dstats->tx_bytes;
 			tpkts =3D dstats->tx_pkts;
 			tdrops =3D dstats->tx_drps;
 			rbytes =3D dstats->rx_bytes;
 			rpkts =3D dstats->rx_pkts;
-		} while (u64_stats_fetch_retry_irq(&dstats->syncp, start));
+		} while (u64_stats_fetch_retry(&dstats->syncp, start));
 		stats->tx_bytes +=3D tbytes;
 		stats->tx_packets +=3D tpkts;
 		stats->tx_dropped +=3D tdrops;
diff --git a/drivers/net/vxlan/vxlan_vnifilter.c b/drivers/net/vxlan/vxlan_=
vnifilter.c
index 3e04af4c5daa1..a3de081cda5ee 100644
--- a/drivers/net/vxlan/vxlan_vnifilter.c
+++ b/drivers/net/vxlan/vxlan_vnifilter.c
@@ -129,9 +129,9 @@ static void vxlan_vnifilter_stats_get(const struct vxla=
n_vni_node *vninode,
=20
 		pstats =3D per_cpu_ptr(vninode->stats, i);
 		do {
-			start =3D u64_stats_fetch_begin_irq(&pstats->syncp);
+			start =3D u64_stats_fetch_begin(&pstats->syncp);
 			memcpy(&temp, &pstats->stats, sizeof(temp));
-		} while (u64_stats_fetch_retry_irq(&pstats->syncp, start));
+		} while (u64_stats_fetch_retry(&pstats->syncp, start));
=20
 		dest->rx_packets +=3D temp.rx_packets;
 		dest->rx_bytes +=3D temp.rx_bytes;
diff --git a/drivers/net/wwan/mhi_wwan_mbim.c b/drivers/net/wwan/mhi_wwan_m=
bim.c
index 6872782e8dd89..22b5939a42bb3 100644
--- a/drivers/net/wwan/mhi_wwan_mbim.c
+++ b/drivers/net/wwan/mhi_wwan_mbim.c
@@ -456,19 +456,19 @@ static void mhi_mbim_ndo_get_stats64(struct net_devic=
e *ndev,
 	unsigned int start;
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&link->rx_syncp);
+		start =3D u64_stats_fetch_begin(&link->rx_syncp);
 		stats->rx_packets =3D u64_stats_read(&link->rx_packets);
 		stats->rx_bytes =3D u64_stats_read(&link->rx_bytes);
 		stats->rx_errors =3D u64_stats_read(&link->rx_errors);
-	} while (u64_stats_fetch_retry_irq(&link->rx_syncp, start));
+	} while (u64_stats_fetch_retry(&link->rx_syncp, start));
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&link->tx_syncp);
+		start =3D u64_stats_fetch_begin(&link->tx_syncp);
 		stats->tx_packets =3D u64_stats_read(&link->tx_packets);
 		stats->tx_bytes =3D u64_stats_read(&link->tx_bytes);
 		stats->tx_errors =3D u64_stats_read(&link->tx_errors);
 		stats->tx_dropped =3D u64_stats_read(&link->tx_dropped);
-	} while (u64_stats_fetch_retry_irq(&link->tx_syncp, start));
+	} while (u64_stats_fetch_retry(&link->tx_syncp, start));
 }
=20
 static void mhi_mbim_ul_callback(struct mhi_device *mhi_dev,
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 9af2b027c19c6..ef4e53bf56044 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1392,16 +1392,16 @@ static void xennet_get_stats64(struct net_device *d=
ev,
 		unsigned int start;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&tx_stats->syncp);
+			start =3D u64_stats_fetch_begin(&tx_stats->syncp);
 			tx_packets =3D tx_stats->packets;
 			tx_bytes =3D tx_stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&tx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&tx_stats->syncp, start));
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&rx_stats->syncp);
+			start =3D u64_stats_fetch_begin(&rx_stats->syncp);
 			rx_packets =3D rx_stats->packets;
 			rx_bytes =3D rx_stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&rx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&rx_stats->syncp, start));
=20
 		tot->rx_packets +=3D rx_packets;
 		tot->tx_packets +=3D tx_packets;
--=20
2.37.2

