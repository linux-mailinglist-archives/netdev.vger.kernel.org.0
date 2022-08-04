Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD68589FFD
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 19:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbiHDRnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 13:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbiHDRnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 13:43:14 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0BE6A4B1
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 10:43:12 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 12so529973pga.1
        for <netdev@vger.kernel.org>; Thu, 04 Aug 2022 10:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=kq6ZanC12g8/NRe/ooi9uFDvzhQ3jWt5tnWx+eLXK8o=;
        b=pawgCxpE4ZGnwEPvC6xS4vIM6q20LmXZ6ZT0Lg7B+fQW/ir2armmHx/dvhJHpWeSBa
         Z3j3W/kXawATsyO8NjZozMByO0vjFFAHD580o7HnieropNsd7GdaaSOjGk82ptanpegS
         Oh3yKSrhLjN7NYUAsI1cLmOoBIHLXKyM8rBCAadO2IEeYn68E4y7UmjKuYGEUN8COJvp
         RKLQV9m42AQ6D73r6HkNGp5gInRuhlaafvcWbhlJgR6UIl1DSqEL73lQGRVBCCWSArS3
         AAjaPL9lMdNsth8yPRjQU14BR6/Unxa5opouyA+8gQFTZv3IuA+PZMTJA4iPt22Vv0d2
         GwWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=kq6ZanC12g8/NRe/ooi9uFDvzhQ3jWt5tnWx+eLXK8o=;
        b=HomzENTGod+cOThepFm8ATUsCMeeAzjdXGVHV6JHfNYktV8cXLeZq3OIlY/pY83itA
         suAKHdxg6oJF9BOnT5nGE7UADprdSPj3jzOQTvRndo8UaVi42GPS2Dg1TLN8w8Qsa3ny
         30ecgjk3htn4EXlUbDH/oUrJrNuWHSGjtK+AkBK0Ekh0xy/T9STFs8in5Wq8JjnMHMLU
         EKO1DAnIijFPrNJoDxlkoDQEPEjBMHKCaKkRXNExqMrbNgGEtOt/YR56DAPS01kjneUJ
         2GNrEt8aeFV4zhkQ+6taeCDQ07/3y8H739NFqgUK/l6Lq3kVdxPkkKf8cQmL4WCo/8I2
         UHTA==
X-Gm-Message-State: ACgBeo34U+fOfFbOd0pj2141nVySKxm9fJsCtB75enTq5P8rku8IdfmQ
        aheBCpKNhgawdJtdsCq6Ip15ghzGMUU=
X-Google-Smtp-Source: AA6agR6SWLuyivkwta8E5DQj7gJY6vbrNEu9syLKE5ldXbKRNH+a6lyUzRxjO+A4wDFGRsrn6vVT+g==
X-Received: by 2002:a05:6a00:841:b0:52e:1e7:ceb5 with SMTP id q1-20020a056a00084100b0052e01e7ceb5mr2691974pfk.75.1659634991544;
        Thu, 04 Aug 2022 10:43:11 -0700 (PDT)
Received: from jprestwo-xps.none ([50.45.187.22])
        by smtp.gmail.com with ESMTPSA id v3-20020a654603000000b0041a6c2436c7sm142603pgq.82.2022.08.04.10.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 10:43:11 -0700 (PDT)
From:   James Prestwood <prestwoj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     James Prestwood <prestwoj@gmail.com>
Subject: [RFC 1/1] net: move IFF_LIVE_ADDR_CHANGE to public flag
Date:   Thu,  4 Aug 2022 10:43:07 -0700
Message-Id: <20220804174307.448527-2-prestwoj@gmail.com>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220804174307.448527-1-prestwoj@gmail.com>
References: <20220804174307.448527-1-prestwoj@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Devices which do not support this flag need to be brought down prior
to changing their address. Internally the kernel can access the private
flags to check whether or not a power down is required, but from
userspace there is no such flag. Without some way of knowing the
device capability userspace cannot efficiently change the address. The
safest route is to always power down.

The motivation for this change is aimed at the wireless subsystem due
to the consequences of a firmware reboot. When the firmware reboots it
clears all wireless regulatory information (for self-managed devices)
and upon startup again the regulatory domain is set to OO/XX. This
disables frequencies which were once available, and will not be allowed
to use until the regulatory domain is set again. Doing this is out of
userspace control, and actually requires a time-intensive scan to
collect enough wireless beacons to determine the country.

This poses a major problem if the device needs to randomize its MAC
address for a connection. If that connection is on a frequency which
is not allowed in the world domain (6GHz is 100% disallowed, and many
other 5/2.4GHz frequencies are also disabled in world roaming) you
essentially cannot randomize you're address since a firmware reboot
would disallow the connection once it came back up.

By exposing IFF_LIVE_ADDR_CHANGE to userspace it at least gives an
indication that we can successfully randomize the address and
connect. In the worst case address randomization can be avoided
ahead of time. A secondary win is also time, since userspace can
avoid a power down unless its required which saves some time.

Signed-off-by: James Prestwood <prestwoj@gmail.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |  2 +-
 .../infiniband/ulp/opa_vnic/opa_vnic_netdev.c |  2 +-
 drivers/net/dummy.c                           |  4 +--
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  2 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  2 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  3 +-
 drivers/net/ethernet/freescale/gianfar.c      |  2 +-
 drivers/net/ethernet/marvell/mvneta.c         |  2 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   |  2 +-
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  2 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  5 +--
 drivers/net/ethernet/realtek/r8169_main.c     |  2 +-
 drivers/net/geneve.c                          |  3 +-
 drivers/net/loopback.c                        |  4 +--
 drivers/net/netdevsim/netdev.c                |  5 ++-
 drivers/net/ntb_netdev.c                      |  2 +-
 drivers/net/team/team.c                       |  3 +-
 drivers/net/tun.c                             |  2 +-
 drivers/net/veth.c                            |  2 +-
 drivers/net/virtio_net.c                      |  4 +--
 drivers/net/vrf.c                             |  2 +-
 drivers/net/vxlan/vxlan_core.c                |  2 +-
 include/linux/netdevice.h                     | 36 +++++++++----------
 include/uapi/linux/if.h                       |  7 +++-
 net/ethernet/eth.c                            |  2 +-
 net/ipv4/ip_gre.c                             |  8 ++---
 net/ipv6/ip6_gre.c                            |  8 ++---
 net/ncsi/ncsi-rsp.c                           |  6 ++--
 net/openvswitch/vport-internal_dev.c          |  4 +--
 29 files changed, 67 insertions(+), 63 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 9934b8bd7f56..5de29c2f8261 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2367,7 +2367,7 @@ static int ipoib_set_mac(struct net_device *dev, void *addr)
 	struct sockaddr_storage *ss = addr;
 	int ret;
 
-	if (!(dev->priv_flags & IFF_LIVE_ADDR_CHANGE) && netif_running(dev))
+	if (!(dev->flags & IFF_LIVE_ADDR_CHANGE) && netif_running(dev))
 		return -EBUSY;
 
 	ret = ipoib_check_lladdr(dev, ss);
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
index 071f35711468..87c7d1042fc5 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
@@ -353,7 +353,7 @@ struct opa_vnic_adapter *opa_vnic_add_netdev(struct ib_device *ibdev,
 	adapter->rn_ops = netdev->netdev_ops;
 
 	netdev->netdev_ops = &opa_netdev_ops;
-	netdev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	netdev->flags |= IFF_LIVE_ADDR_CHANGE;
 	netdev->hard_header_len += OPA_VNIC_SKB_HEADROOM;
 	mutex_init(&adapter->lock);
 	mutex_init(&adapter->mactbl_lock);
diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index f82ad7419508..f02bc360ce7d 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -120,9 +120,9 @@ static void dummy_setup(struct net_device *dev)
 	dev->needs_free_netdev = true;
 
 	/* Fill in device structure with ethernet-generic values. */
-	dev->flags |= IFF_NOARP;
+	dev->flags |= IFF_NOARP | IFF_LIVE_ADDR_CHANGE;
 	dev->flags &= ~IFF_MULTICAST;
-	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE | IFF_NO_QUEUE;
+	dev->priv_flags |= IFF_NO_QUEUE;
 	dev->features	|= NETIF_F_SG | NETIF_F_FRAGLIST;
 	dev->features	|= NETIF_F_GSO_SOFTWARE;
 	dev->features	|= NETIF_F_HW_CSUM | NETIF_F_HIGHDMA | NETIF_F_LLTX;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 24d715c28a35..46b8135f67ea 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -380,7 +380,7 @@ void aq_nic_ndev_init(struct aq_nic_s *self)
 				     NETIF_F_LRO | NETIF_F_TSO | NETIF_F_TSO6;
 	self->ndev->gso_partial_features = NETIF_F_GSO_UDP_L4;
 	self->ndev->priv_flags = aq_hw_caps->hw_priv_flags;
-	self->ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	self->ndev->flags |= IFF_LIVE_ADDR_CHANGE;
 
 	self->msg_enable = NETIF_MSG_DRV | NETIF_MSG_LINK;
 	self->ndev->mtu = aq_nic_cfg->mtu - ETH_HLEN;
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index c78883c3a2c8..bd278f14f814 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -259,7 +259,7 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	net_dev->features |= NETIF_F_GSO;
 	net_dev->features |= NETIF_F_RXCSUM;
 
-	net_dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	net_dev->flags |= IFF_LIVE_ADDR_CHANGE;
 	/* we do not want shared skbs on TX */
 	net_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 4b047255d928..7b5f6730008f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4375,8 +4375,6 @@ static int dpaa2_eth_netdev_init(struct net_device *net_dev)
 	dpaa2_eth_detect_features(priv);
 
 	/* Capabilities listing */
-	supported |= IFF_LIVE_ADDR_CHANGE;
-
 	if (options & DPNI_OPT_NO_MAC_FILTER)
 		not_supported |= IFF_UNICAST_FLT;
 	else
@@ -4384,6 +4382,7 @@ static int dpaa2_eth_netdev_init(struct net_device *net_dev)
 
 	net_dev->priv_flags |= supported;
 	net_dev->priv_flags &= ~not_supported;
+	net_dev->flags |= IFF_LIVE_ADDR_CHANGE;
 
 	/* Features */
 	net_dev->features = NETIF_F_RXCSUM |
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 206b7a35eaf5..01f644853fda 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -3250,7 +3250,7 @@ static int gfar_probe(struct platform_device *ofdev)
 		dev->features |= NETIF_F_HW_VLAN_CTAG_RX;
 	}
 
-	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	dev->flags |= IFF_LIVE_ADDR_CHANGE;
 
 	gfar_init_addr_hash_table(priv);
 
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 934f6dd90992..c1b4374ffe76 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5598,7 +5598,7 @@ static int mvneta_probe(struct platform_device *pdev)
 			NETIF_F_TSO | NETIF_F_RXCSUM;
 	dev->hw_features |= dev->features;
 	dev->vlan_features |= dev->features;
-	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	dev->flags |= IFF_LIVE_ADDR_CHANGE;
 	netif_set_gso_max_segs(dev, MVNETA_MAX_TSO_SEGS);
 
 	/* MTU range: 68 - 9676 */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index b412670d89b2..a79d2d1ca0ca 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2235,7 +2235,7 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	 * supported.  By default we enable most features.
 	 */
 	if (nn->cap & NFP_NET_CFG_CTRL_LIVE_ADDR)
-		netdev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+		netdev->flags |= IFF_LIVE_ADDR_CHANGE;
 
 	netdev->hw_features = NETIF_F_HIGHDMA;
 	if (nn->cap & NFP_NET_CFG_CTRL_RXCSUM_ANY) {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index ba3fa7eac98d..6b65aa9220c9 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -339,7 +339,7 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 
 	/* Set features the lower device can support with representors */
 	if (repr_cap & NFP_NET_CFG_CTRL_LIVE_ADDR)
-		netdev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+		netdev->flags |= IFF_LIVE_ADDR_CHANGE;
 
 	netdev->hw_features = NETIF_F_HIGHDMA;
 	if (repr_cap & NFP_NET_CFG_CTRL_RXCSUM_ANY)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index f3568901eb91..8a285a1149ab 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1544,8 +1544,9 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
 	netdev->features |= netdev->hw_features;
 	netdev->vlan_features |= netdev->features & ~NETIF_F_VLAN_FEATURES;
 
-	netdev->priv_flags |= IFF_UNICAST_FLT |
-			      IFF_LIVE_ADDR_CHANGE;
+	netdev->priv_flags |= IFF_UNICAST_FLT;
+	netdev->flags |= IFF_LIVE_ADDR_CHANGE;
+
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 33f5c5698ccb..ac26b9e97513 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5420,7 +5420,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
 			   NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
 	dev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO;
-	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	dev->flags |= IFF_LIVE_ADDR_CHANGE;
 
 	/*
 	 * Pretend we are using VLANs; This bypasses a nasty bug where
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 7db6c135ac6c..03ea394f6b85 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1257,7 +1257,8 @@ static void geneve_setup(struct net_device *dev)
 
 	netif_keep_dst(dev);
 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
-	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE | IFF_NO_QUEUE;
+	dev->priv_flags |= IFF_NO_QUEUE;
+	dev->flags |= IFF_LIVE_ADDR_CHANGE;
 	eth_hw_addr_random(dev);
 }
 
diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 720394c0639b..355edd31a4d2 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -172,8 +172,8 @@ static void gen_lo_setup(struct net_device *dev,
 	dev->min_header_len	= ETH_HLEN;	/* 14	*/
 	dev->addr_len		= ETH_ALEN;	/* 6	*/
 	dev->type		= ARPHRD_LOOPBACK;	/* 0x0001*/
-	dev->flags		= IFF_LOOPBACK;
-	dev->priv_flags		|= IFF_LIVE_ADDR_CHANGE | IFF_NO_QUEUE;
+	dev->flags		= IFF_LOOPBACK | IFF_LIVE_ADDR_CHANGE;
+	dev->priv_flags		|= IFF_NO_QUEUE;
 	netif_keep_dst(dev);
 	dev->hw_features	= NETIF_F_GSO_SOFTWARE;
 	dev->features		= NETIF_F_SG | NETIF_F_FRAGLIST
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index e470e3398abc..cdf18078f002 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -284,10 +284,9 @@ static void nsim_setup(struct net_device *dev)
 	eth_hw_addr_random(dev);
 
 	dev->tx_queue_len = 0;
-	dev->flags |= IFF_NOARP;
+	dev->flags |= IFF_NOARP | IFF_LIVE_ADDR_CHANGE;
 	dev->flags &= ~IFF_MULTICAST;
-	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE |
-			   IFF_NO_QUEUE;
+	dev->priv_flags |= IFF_NO_QUEUE;
 	dev->features |= NETIF_F_HIGHDMA |
 			 NETIF_F_SG |
 			 NETIF_F_FRAGLIST |
diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index 80bdc07f2cd3..103bca43fd4d 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -422,7 +422,7 @@ static int ntb_netdev_probe(struct device *client_dev)
 	dev->pdev = pdev;
 	ndev->features = NETIF_F_HIGHDMA;
 
-	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	ndev->flags |= IFF_LIVE_ADDR_CHANGE;
 
 	ndev->hw_features = ndev->features;
 	ndev->watchdog_timeo = msecs_to_jiffies(NTB_TX_TIMEOUT_MS);
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index b07dde6f0abf..1d82f0130831 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2168,7 +2168,8 @@ static void team_setup(struct net_device *dev)
 	 * bring us to promisc mode in case a unicast addr is added.
 	 * Let this up to underlay drivers.
 	 */
-	dev->priv_flags |= IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE;
+	dev->flags |= IFF_LIVE_ADDR_CHANGE;
+	dev->priv_flags |= IFF_UNICAST_FLT;
 
 	dev->features |= NETIF_F_LLTX;
 	dev->features |= NETIF_F_GRO;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index dbe4c0a4be2c..53bd5dac0551 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1385,7 +1385,7 @@ static void tun_net_initialize(struct net_device *dev)
 		/* Ethernet TAP Device */
 		ether_setup(dev);
 		dev->priv_flags &= ~IFF_TX_SKB_SHARING;
-		dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+		dev->flags |= IFF_LIVE_ADDR_CHANGE;
 
 		eth_hw_addr_random(dev);
 
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index eb0121a64d6d..30366c4964bb 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1627,9 +1627,9 @@ static void veth_setup(struct net_device *dev)
 	ether_setup(dev);
 
 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
-	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 	dev->priv_flags |= IFF_NO_QUEUE;
 	dev->priv_flags |= IFF_PHONY_HEADROOM;
+	dev->flags |= IFF_LIVE_ADDR_CHANGE;
 
 	dev->netdev_ops = &veth_netdev_ops;
 	dev->ethtool_ops = &veth_ethtool_ops;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index cbba9d2e8f32..bf836450c468 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3481,8 +3481,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 		return -ENOMEM;
 
 	/* Set up network device as normal. */
-	dev->priv_flags |= IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE |
-			   IFF_TX_SKB_NO_LINEAR;
+	dev->priv_flags |= IFF_UNICAST_FLT | IFF_TX_SKB_NO_LINEAR;
+	dev->flags |= IFF_LIVE_ADDR_CHANGE;
 	dev->netdev_ops = &virtnet_netdev;
 	dev->features = NETIF_F_HIGHDMA;
 
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index cfc30ce4c6e1..0900bacff9b5 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1697,7 +1697,7 @@ static void vrf_setup(struct net_device *dev)
 	/* default to no qdisc; user can add if desired */
 	dev->priv_flags |= IFF_NO_QUEUE;
 	dev->priv_flags |= IFF_NO_RX_HANDLER;
-	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	dev->flags |= IFF_LIVE_ADDR_CHANGE;
 
 	/* VRF devices do not care about MTU, but if the MTU is set
 	 * too low then the ipv4 and ipv6 protocols are disabled
diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 8a5e3a6d32d7..16dda95d9c6e 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -3177,7 +3177,7 @@ static void vxlan_setup(struct net_device *dev)
 static void vxlan_ether_setup(struct net_device *dev)
 {
 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
-	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	dev->flags |= IFF_LIVE_ADDR_CHANGE;
 	dev->netdev_ops = &vxlan_netdev_ether_ops;
 }
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f736c020cde2..6b75d813f4af 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1637,24 +1637,23 @@ enum netdev_priv_flags {
 	IFF_UNICAST_FLT			= 1<<12,
 	IFF_TEAM_PORT			= 1<<13,
 	IFF_SUPP_NOFCS			= 1<<14,
-	IFF_LIVE_ADDR_CHANGE		= 1<<15,
-	IFF_MACVLAN			= 1<<16,
-	IFF_XMIT_DST_RELEASE_PERM	= 1<<17,
-	IFF_L3MDEV_MASTER		= 1<<18,
-	IFF_NO_QUEUE			= 1<<19,
-	IFF_OPENVSWITCH			= 1<<20,
-	IFF_L3MDEV_SLAVE		= 1<<21,
-	IFF_TEAM			= 1<<22,
-	IFF_RXFH_CONFIGURED		= 1<<23,
-	IFF_PHONY_HEADROOM		= 1<<24,
-	IFF_MACSEC			= 1<<25,
-	IFF_NO_RX_HANDLER		= 1<<26,
-	IFF_FAILOVER			= 1<<27,
-	IFF_FAILOVER_SLAVE		= 1<<28,
-	IFF_L3MDEV_RX_HANDLER		= 1<<29,
-	IFF_LIVE_RENAME_OK		= 1<<30,
-	IFF_TX_SKB_NO_LINEAR		= 1<<31,
-	IFF_CHANGE_PROTO_DOWN		= BIT_ULL(32),
+	IFF_MACVLAN			= 1<<15,
+	IFF_XMIT_DST_RELEASE_PERM	= 1<<16,
+	IFF_L3MDEV_MASTER		= 1<<17,
+	IFF_NO_QUEUE			= 1<<18,
+	IFF_OPENVSWITCH			= 1<<19,
+	IFF_L3MDEV_SLAVE		= 1<<20,
+	IFF_TEAM			= 1<<21,
+	IFF_RXFH_CONFIGURED		= 1<<22,
+	IFF_PHONY_HEADROOM		= 1<<23,
+	IFF_MACSEC			= 1<<24,
+	IFF_NO_RX_HANDLER		= 1<<25,
+	IFF_FAILOVER			= 1<<26,
+	IFF_FAILOVER_SLAVE		= 1<<27,
+	IFF_L3MDEV_RX_HANDLER		= 1<<28,
+	IFF_LIVE_RENAME_OK		= 1<<29,
+	IFF_TX_SKB_NO_LINEAR		= 1<<30,
+	IFF_CHANGE_PROTO_DOWN		= BIT_ULL(31),
 };
 
 #define IFF_802_1Q_VLAN			IFF_802_1Q_VLAN
@@ -1672,7 +1671,6 @@ enum netdev_priv_flags {
 #define IFF_UNICAST_FLT			IFF_UNICAST_FLT
 #define IFF_TEAM_PORT			IFF_TEAM_PORT
 #define IFF_SUPP_NOFCS			IFF_SUPP_NOFCS
-#define IFF_LIVE_ADDR_CHANGE		IFF_LIVE_ADDR_CHANGE
 #define IFF_MACVLAN			IFF_MACVLAN
 #define IFF_XMIT_DST_RELEASE_PERM	IFF_XMIT_DST_RELEASE_PERM
 #define IFF_L3MDEV_MASTER		IFF_L3MDEV_MASTER
diff --git a/include/uapi/linux/if.h b/include/uapi/linux/if.h
index 797ba2c1562a..111b077b2d4e 100644
--- a/include/uapi/linux/if.h
+++ b/include/uapi/linux/if.h
@@ -78,6 +78,8 @@
  * @IFF_LOWER_UP: driver signals L1 up. Volatile.
  * @IFF_DORMANT: driver signals dormant. Volatile.
  * @IFF_ECHO: echo sent packets. Volatile.
+ * @IFF_LIVE_ADDR_CHANGE: device supports hardware address
+ *	change when it's running. Volatile
  */
 enum net_device_flags {
 /* for compatibility with glibc net/if.h */
@@ -103,6 +105,7 @@ enum net_device_flags {
 	IFF_LOWER_UP			= 1<<16, /* volatile */
 	IFF_DORMANT			= 1<<17, /* volatile */
 	IFF_ECHO			= 1<<18, /* volatile */
+	IFF_LIVE_ADDR_CHANGE		= 1<<19, /* volatile */
 #endif /* __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO */
 };
 #endif /* __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO != 0 || __UAPI_DEF_IF_NET_DEVICE_FLAGS != 0 */
@@ -131,10 +134,12 @@ enum net_device_flags {
 #define IFF_LOWER_UP			IFF_LOWER_UP
 #define IFF_DORMANT			IFF_DORMANT
 #define IFF_ECHO			IFF_ECHO
+#define IFF_LIVE_ADDR_CHANGE		IFF_LIVE_ADDR_CHANGE
 #endif /* __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO */
 
 #define IFF_VOLATILE	(IFF_LOOPBACK|IFF_POINTOPOINT|IFF_BROADCAST|IFF_ECHO|\
-		IFF_MASTER|IFF_SLAVE|IFF_RUNNING|IFF_LOWER_UP|IFF_DORMANT)
+		IFF_MASTER|IFF_SLAVE|IFF_RUNNING|IFF_LOWER_UP|IFF_DORMANT|\
+		IFF_LIVE_ADDR_CHANGE)
 
 #define IF_GET_IFACE	0x0001		/* for querying only */
 #define IF_GET_PROTO	0x0002
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index ebcc812735a4..b32301b72070 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -288,7 +288,7 @@ int eth_prepare_mac_addr_change(struct net_device *dev, void *p)
 {
 	struct sockaddr *addr = p;
 
-	if (!(dev->priv_flags & IFF_LIVE_ADDR_CHANGE) && netif_running(dev))
+	if (!(dev->flags & IFF_LIVE_ADDR_CHANGE) && netif_running(dev))
 		return -EBUSY;
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index aacee9dd771b..cc0c977b36a9 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1271,7 +1271,7 @@ static bool ipgre_netlink_encap_parms(struct nlattr *data[],
 static int gre_tap_init(struct net_device *dev)
 {
 	__gre_tunnel_init(dev);
-	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	dev->flags |= IFF_LIVE_ADDR_CHANGE;
 	netif_keep_dst(dev);
 
 	return ip_tunnel_init(dev);
@@ -1304,7 +1304,7 @@ static int erspan_tunnel_init(struct net_device *dev)
 
 	dev->features		|= GRE_FEATURES;
 	dev->hw_features	|= GRE_FEATURES;
-	dev->priv_flags		|= IFF_LIVE_ADDR_CHANGE;
+	dev->flags		|= IFF_LIVE_ADDR_CHANGE;
 	netif_keep_dst(dev);
 
 	return ip_tunnel_init(dev);
@@ -1328,7 +1328,7 @@ static void ipgre_tap_setup(struct net_device *dev)
 	dev->max_mtu = 0;
 	dev->netdev_ops	= &gre_tap_netdev_ops;
 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
-	dev->priv_flags	|= IFF_LIVE_ADDR_CHANGE;
+	dev->flags	|= IFF_LIVE_ADDR_CHANGE;
 	ip_tunnel_setup(dev, gre_tap_net_id);
 }
 
@@ -1560,7 +1560,7 @@ static void erspan_setup(struct net_device *dev)
 	dev->max_mtu = 0;
 	dev->netdev_ops = &erspan_netdev_ops;
 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
-	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	dev->flags |= IFF_LIVE_ADDR_CHANGE;
 	ip_tunnel_setup(dev, erspan_net_id);
 	t->erspan_ver = 1;
 }
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 5136959b3dc5..ab81445b1954 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1832,7 +1832,7 @@ static int ip6gre_tap_init(struct net_device *dev)
 	if (ret)
 		return ret;
 
-	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	dev->flags |= IFF_LIVE_ADDR_CHANGE;
 
 	return 0;
 }
@@ -1892,7 +1892,7 @@ static int ip6erspan_tap_init(struct net_device *dev)
 	if (!(tunnel->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
 		dev->mtu -= 8;
 
-	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	dev->flags |= IFF_LIVE_ADDR_CHANGE;
 	ip6erspan_tnl_link_config(tunnel, 1);
 
 	dev_hold_track(dev, &tunnel->dev_tracker, GFP_KERNEL);
@@ -1928,7 +1928,7 @@ static void ip6gre_tap_setup(struct net_device *dev)
 	dev->priv_destructor = ip6gre_dev_free;
 
 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
-	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	dev->flags |= IFF_LIVE_ADDR_CHANGE;
 	netif_keep_dst(dev);
 }
 
@@ -2228,7 +2228,7 @@ static void ip6erspan_tap_setup(struct net_device *dev)
 	dev->priv_destructor = ip6gre_dev_free;
 
 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
-	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	dev->flags |= IFF_LIVE_ADDR_CHANGE;
 	netif_keep_dst(dev);
 }
 
diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index 6447a09932f5..05e93e4e131b 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -625,7 +625,7 @@ static int ncsi_rsp_handler_oem_mlx_gma(struct ncsi_request *nr)
 	rsp = (struct ncsi_rsp_oem_pkt *)skb_network_header(nr->rsp);
 
 	saddr.sa_family = ndev->type;
-	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	ndev->flags |= IFF_LIVE_ADDR_CHANGE;
 	memcpy(saddr.sa_data, &rsp->data[MLX_MAC_ADDR_OFFSET], ETH_ALEN);
 	/* Set the flag for GMA command which should only be called once */
 	ndp->gma_flag = 1;
@@ -667,7 +667,7 @@ static int ncsi_rsp_handler_oem_bcm_gma(struct ncsi_request *nr)
 	rsp = (struct ncsi_rsp_oem_pkt *)skb_network_header(nr->rsp);
 
 	saddr.sa_family = ndev->type;
-	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	ndev->flags |= IFF_LIVE_ADDR_CHANGE;
 	memcpy(saddr.sa_data, &rsp->data[BCM_MAC_ADDR_OFFSET], ETH_ALEN);
 	/* Increase mac address by 1 for BMC's address */
 	eth_addr_inc((u8 *)saddr.sa_data);
@@ -713,7 +713,7 @@ static int ncsi_rsp_handler_oem_intel_gma(struct ncsi_request *nr)
 	rsp = (struct ncsi_rsp_oem_pkt *)skb_network_header(nr->rsp);
 
 	saddr.sa_family = ndev->type;
-	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	ndev->flags |= IFF_LIVE_ADDR_CHANGE;
 	memcpy(saddr.sa_data, &rsp->data[INTEL_MAC_ADDR_OFFSET], ETH_ALEN);
 	/* Increase mac address by 1 for BMC's address */
 	eth_addr_inc((u8 *)saddr.sa_data);
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 5b2ee9c1c00b..dbe39b6ddddb 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -101,8 +101,8 @@ static void do_setup(struct net_device *netdev)
 	netdev->netdev_ops = &internal_dev_netdev_ops;
 
 	netdev->priv_flags &= ~IFF_TX_SKB_SHARING;
-	netdev->priv_flags |= IFF_LIVE_ADDR_CHANGE | IFF_OPENVSWITCH |
-			      IFF_NO_QUEUE;
+	netdev->priv_flags |= IFF_OPENVSWITCH | IFF_NO_QUEUE;
+	netdev->flags |= IFF_LIVE_ADDR_CHANGE;
 	netdev->needs_free_netdev = true;
 	netdev->priv_destructor = NULL;
 	netdev->ethtool_ops = &internal_dev_ethtool_ops;
-- 
2.34.3

