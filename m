Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFA441F700
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 23:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355633AbhJAVef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 17:34:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355607AbhJAVeU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 17:34:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 519AC61AF8;
        Fri,  1 Oct 2021 21:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633123955;
        bh=S2hyKflUWqdmwMCKvovoVzHMek8EdoehB6bzEVDssKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UplWYbrPVPVzQBaQgRkj93Ttwp2c2ydjn+RbJoMihgINvckv8R14/g9/WPoEYMSx+
         MtHQleNpSrLaBo7yadoro4wy0nYnwsV+54SD+EcXY2+p4XVfWcn8kxvzF3w0WoNttF
         YKYK0VWBPhsVl8thMX9EMYz/Y/8ySEW7gjQXByIZUw8s3hr1Gu7UuLKrtejOe3Wvv2
         xlUe3qnALZCalXcTQW7yeQT3ho/CqNHeFkaIbjjAVmG/uIyNtK0/9j3hOoiSMmB1tw
         6dUD5AX+afSy4I/ZI74Fu4pQOQgPCQzTDBWh9XEXcjdVOGiBmfZgj5OUrCiQgC7E4N
         oZccSKAVVoEtw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 06/11] ethernet: use eth_hw_addr_set() instead of ether_addr_copy()
Date:   Fri,  1 Oct 2021 14:32:23 -0700
Message-Id: <20211001213228.1735079-7-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001213228.1735079-1-kuba@kernel.org>
References: <20211001213228.1735079-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert Ethernet from ether_addr_copy() to eth_hw_addr_set():

  @@
  expression dev, np;
  @@
  - ether_addr_copy(dev->dev_addr, np)
  + eth_hw_addr_set(dev, np)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/agere/et131x.c                        | 4 ++--
 drivers/net/ethernet/alacritech/slicoss.c                  | 2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c               | 2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c            | 2 +-
 drivers/net/ethernet/broadcom/bgmac-bcma.c                 | 2 +-
 drivers/net/ethernet/broadcom/bgmac.c                      | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c              | 2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c             | 4 ++--
 drivers/net/ethernet/brocade/bna/bnad.c                    | 4 ++--
 drivers/net/ethernet/cavium/liquidio/lio_core.c            | 2 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c            | 2 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c         | 2 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c           | 3 +--
 drivers/net/ethernet/emulex/benet/be_main.c                | 2 +-
 drivers/net/ethernet/ethoc.c                               | 2 +-
 drivers/net/ethernet/ezchip/nps_enet.c                     | 2 +-
 drivers/net/ethernet/faraday/ftgmac100.c                   | 4 ++--
 drivers/net/ethernet/google/gve/gve_adminq.c               | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c            | 4 ++--
 drivers/net/ethernet/ibm/ibmveth.c                         | 2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                         | 5 ++---
 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c            | 2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c               | 4 ++--
 drivers/net/ethernet/intel/i40e/i40e_main.c                | 4 ++--
 drivers/net/ethernet/intel/iavf/iavf_main.c                | 2 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c            | 4 ++--
 drivers/net/ethernet/intel/ice/ice_main.c                  | 4 ++--
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c          | 6 +++---
 drivers/net/ethernet/korina.c                              | 2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c            | 4 ++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c             | 2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c   | 2 +-
 drivers/net/ethernet/marvell/prestera/prestera_main.c      | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c          | 2 +-
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c | 2 +-
 drivers/net/ethernet/microchip/enc28j60.c                  | 4 ++--
 drivers/net/ethernet/microchip/lan743x_main.c              | 4 ++--
 drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c      | 2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c              | 2 +-
 drivers/net/ethernet/mscc/ocelot_net.c                     | 2 +-
 drivers/net/ethernet/netronome/nfp/abm/main.c              | 2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_main.c          | 2 +-
 drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c        | 2 +-
 drivers/net/ethernet/ni/nixge.c                            | 2 +-
 drivers/net/ethernet/qlogic/qede/qede_filter.c             | 4 ++--
 drivers/net/ethernet/qlogic/qede/qede_main.c               | 2 +-
 drivers/net/ethernet/qualcomm/emac/emac.c                  | 2 +-
 drivers/net/ethernet/sfc/ef10_sriov.c                      | 2 +-
 drivers/net/ethernet/sfc/efx.c                             | 2 +-
 drivers/net/ethernet/sfc/efx_common.c                      | 4 ++--
 drivers/net/ethernet/sfc/falcon/efx.c                      | 6 +++---
 drivers/net/ethernet/socionext/netsec.c                    | 2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                   | 2 +-
 drivers/net/ethernet/ti/cpsw_new.c                         | 4 ++--
 drivers/net/ethernet/ti/davinci_emac.c                     | 2 +-
 drivers/net/ethernet/ti/netcp_core.c                       | 2 +-
 include/linux/etherdevice.h                                | 2 +-
 57 files changed, 77 insertions(+), 79 deletions(-)

diff --git a/drivers/net/ethernet/agere/et131x.c b/drivers/net/ethernet/agere/et131x.c
index 920633161174..f4edc616388c 100644
--- a/drivers/net/ethernet/agere/et131x.c
+++ b/drivers/net/ethernet/agere/et131x.c
@@ -3863,7 +3863,7 @@ static int et131x_change_mtu(struct net_device *netdev, int new_mtu)
 
 	et131x_init_send(adapter);
 	et131x_hwaddr_init(adapter);
-	ether_addr_copy(netdev->dev_addr, adapter->addr);
+	eth_hw_addr_set(netdev, adapter->addr);
 
 	/* Init the device with the new settings */
 	et131x_adapter_setup(adapter);
@@ -3966,7 +3966,7 @@ static int et131x_pci_setup(struct pci_dev *pdev,
 
 	netif_napi_add(netdev, &adapter->napi, et131x_poll, 64);
 
-	ether_addr_copy(netdev->dev_addr, adapter->addr);
+	eth_hw_addr_set(netdev, adapter->addr);
 
 	rc = -ENOMEM;
 
diff --git a/drivers/net/ethernet/alacritech/slicoss.c b/drivers/net/ethernet/alacritech/slicoss.c
index 696517eae77f..82f4f2608102 100644
--- a/drivers/net/ethernet/alacritech/slicoss.c
+++ b/drivers/net/ethernet/alacritech/slicoss.c
@@ -1660,7 +1660,7 @@ static int slic_read_eeprom(struct slic_device *sdev)
 		goto free_eeprom;
 	}
 	/* set mac address */
-	ether_addr_copy(sdev->netdev->dev_addr, mac[devfn]);
+	eth_hw_addr_set(sdev->netdev, mac[devfn]);
 free_eeprom:
 	dma_free_coherent(&sdev->pdev->dev, SLIC_EEPROM_SIZE, eeprom, paddr);
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 0e43000614ab..7d5d885d85d5 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4073,7 +4073,7 @@ static void ena_set_conf_feat_params(struct ena_adapter *adapter,
 		ether_addr_copy(adapter->mac_addr, netdev->dev_addr);
 	} else {
 		ether_addr_copy(adapter->mac_addr, feat->dev_attr.mac_addr);
-		ether_addr_copy(netdev->dev_addr, adapter->mac_addr);
+		eth_hw_addr_set(netdev, adapter->mac_addr);
 	}
 
 	/* Set offload features */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 6c049864dac0..694aa70bcafe 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -332,7 +332,7 @@ int aq_nic_ndev_register(struct aq_nic_s *self)
 	{
 		static u8 mac_addr_permanent[] = AQ_CFG_MAC_ADDR_PERMANENT;
 
-		ether_addr_copy(self->ndev->dev_addr, mac_addr_permanent);
+		eth_hw_addr_set(self->ndev, mac_addr_permanent);
 	}
 #endif
 
diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma.c b/drivers/net/ethernet/broadcom/bgmac-bcma.c
index 9513cfb5ba58..28759062d68d 100644
--- a/drivers/net/ethernet/broadcom/bgmac-bcma.c
+++ b/drivers/net/ethernet/broadcom/bgmac-bcma.c
@@ -150,7 +150,7 @@ static int bgmac_probe(struct bcma_device *core)
 			err = -ENOTSUPP;
 			goto err;
 		}
-		ether_addr_copy(bgmac->net_dev->dev_addr, mac);
+		eth_hw_addr_set(bgmac->net_dev, mac);
 	}
 
 	/* On BCM4706 we need common core to access PHY */
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index fe4d99abd548..d2c7834850cc 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1241,7 +1241,7 @@ static int bgmac_set_mac_address(struct net_device *net_dev, void *addr)
 	if (ret < 0)
 		return ret;
 
-	ether_addr_copy(net_dev->dev_addr, sa->sa_data);
+	eth_hw_addr_set(net_dev, sa->sa_data);
 	bgmac_write_mac_address(bgmac, net_dev->dev_addr);
 
 	eth_commit_mac_addr_change(net_dev, addr);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index 9401936b74fa..8eb28e088582 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -475,7 +475,7 @@ static void bnxt_vf_rep_netdev_init(struct bnxt *bp, struct bnxt_vf_rep *vf_rep,
 	dev->features |= pf_dev->features;
 	bnxt_vf_rep_eth_addr_gen(bp->pf.mac_addr, vf_rep->vf_idx,
 				 dev->perm_addr);
-	ether_addr_copy(dev->dev_addr, dev->perm_addr);
+	eth_hw_addr_set(dev, dev->perm_addr);
 	/* Set VF-Rep's max-mtu to the corresponding VF's max-mtu */
 	if (!bnxt_hwrm_vfr_qcfg(bp, vf_rep, &max_mtu))
 		dev->max_mtu = max_mtu;
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 6a8234bc9428..02fe98cbabb0 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3633,7 +3633,7 @@ static int bcmgenet_set_mac_addr(struct net_device *dev, void *p)
 	if (netif_running(dev))
 		return -EBUSY;
 
-	ether_addr_copy(dev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	return 0;
 }
@@ -4082,7 +4082,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 		bcmgenet_power_up(priv, GENET_POWER_PASSIVE);
 
 	if (pd && !IS_ERR_OR_NULL(pd->mac_address))
-		ether_addr_copy(dev->dev_addr, pd->mac_address);
+		eth_hw_addr_set(dev, pd->mac_address);
 	else
 		if (!device_get_mac_address(&pdev->dev, dev->dev_addr, ETH_ALEN))
 			if (has_acpi_companion(&pdev->dev))
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index ba47777d9cff..b1947fd9a07c 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -875,7 +875,7 @@ bnad_set_netdev_perm_addr(struct bnad *bnad)
 
 	ether_addr_copy(netdev->perm_addr, bnad->perm_addr);
 	if (is_zero_ether_addr(netdev->dev_addr))
-		ether_addr_copy(netdev->dev_addr, bnad->perm_addr);
+		eth_hw_addr_set(netdev, bnad->perm_addr);
 }
 
 /* Control Path Handlers */
@@ -3249,7 +3249,7 @@ bnad_set_mac_address(struct net_device *netdev, void *addr)
 
 	err = bnad_mac_addr_set_locked(bnad, sa->sa_data);
 	if (!err)
-		ether_addr_copy(netdev->dev_addr, sa->sa_data);
+		eth_hw_addr_set(netdev, sa->sa_data);
 
 	spin_unlock_irqrestore(&bnad->bna_lock, flags);
 
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_core.c b/drivers/net/ethernet/cavium/liquidio/lio_core.c
index 2a0d64e5797c..ec7928b54e4a 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_core.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_core.c
@@ -411,7 +411,7 @@ void octeon_pf_changed_vf_macaddr(struct octeon_device *oct, u8 *mac)
 
 	if (!ether_addr_equal(netdev->dev_addr, mac)) {
 		macaddr_changed = true;
-		ether_addr_copy(netdev->dev_addr, mac);
+		eth_hw_addr_set(netdev, mac);
 		ether_addr_copy(((u8 *)&lio->linfo.hw_addr) + 2, mac);
 		call_netdevice_notifiers(NETDEV_CHANGEADDR, netdev);
 	}
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index dafc79bd34f4..5d865ba7aed4 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -3634,7 +3634,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 
 		/* Copy MAC Address to OS network device structure */
 
-		ether_addr_copy(netdev->dev_addr, mac);
+		eth_hw_addr_set(netdev, mac);
 
 		/* By default all interfaces on a single Octeon uses the same
 		 * tx and rx queues
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index f6396ac64006..8a969a9d4b63 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -2148,7 +2148,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 			mac[j] = *((u8 *)(((u8 *)&lio->linfo.hw_addr) + 2 + j));
 
 		/* Copy MAC Address to OS network device structure */
-		ether_addr_copy(netdev->dev_addr, mac);
+		eth_hw_addr_set(netdev, mac);
 
 		if (liquidio_setup_io_queues(octeon_dev, i,
 					     lio->linfo.num_txpciq,
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 2b87565781a0..5ef704c8d839 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -221,8 +221,7 @@ static void  nicvf_handle_mbx_intr(struct nicvf *nic)
 		nic->tns_mode = mbx.nic_cfg.tns_mode & 0x7F;
 		nic->node = mbx.nic_cfg.node_id;
 		if (!nic->set_mac_pending)
-			ether_addr_copy(nic->netdev->dev_addr,
-					mbx.nic_cfg.mac_addr);
+			eth_hw_addr_set(nic->netdev, mbx.nic_cfg.mac_addr);
 		nic->sqs_mode = mbx.nic_cfg.sqs_mode;
 		nic->loopback_supported = mbx.nic_cfg.loopback_supported;
 		nic->link_up = false;
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 0fb36d50c42b..ef60e2da05a4 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -369,7 +369,7 @@ static int be_mac_addr_set(struct net_device *netdev, void *p)
 	/* Remember currently programmed MAC */
 	ether_addr_copy(adapter->dev_mac, addr->sa_data);
 done:
-	ether_addr_copy(netdev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(netdev, addr->sa_data);
 	dev_info(dev, "MAC address changed to %pM\n", addr->sa_data);
 	return 0;
 err:
diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index c5bd27db708a..7eb7d28a489d 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -1144,7 +1144,7 @@ static int ethoc_probe(struct platform_device *pdev)
 
 	/* Allow the platform setup code to pass in a MAC address. */
 	if (pdata) {
-		ether_addr_copy(netdev->dev_addr, pdata->hwaddr);
+		eth_hw_addr_set(netdev, pdata->hwaddr);
 		priv->phy_id = pdata->phy_id;
 	} else {
 		of_get_mac_address(pdev->dev.of_node, netdev->dev_addr);
diff --git a/drivers/net/ethernet/ezchip/nps_enet.c b/drivers/net/ethernet/ezchip/nps_enet.c
index f9a288a6ec8c..f5935eb5a791 100644
--- a/drivers/net/ethernet/ezchip/nps_enet.c
+++ b/drivers/net/ethernet/ezchip/nps_enet.c
@@ -421,7 +421,7 @@ static s32 nps_enet_set_mac_address(struct net_device *ndev, void *p)
 
 	res = eth_mac_addr(ndev, p);
 	if (!res) {
-		ether_addr_copy(ndev->dev_addr, addr->sa_data);
+		eth_hw_addr_set(ndev, addr->sa_data);
 		nps_enet_set_hw_mac_address(ndev);
 	}
 
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index ff76e401a014..ab9267225573 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -186,7 +186,7 @@ static void ftgmac100_initial_mac(struct ftgmac100 *priv)
 
 	addr = device_get_mac_address(priv->dev, mac, ETH_ALEN);
 	if (addr) {
-		ether_addr_copy(priv->netdev->dev_addr, mac);
+		eth_hw_addr_set(priv->netdev, mac);
 		dev_info(priv->dev, "Read MAC address %pM from device tree\n",
 			 mac);
 		return;
@@ -203,7 +203,7 @@ static void ftgmac100_initial_mac(struct ftgmac100 *priv)
 	mac[5] = l & 0xff;
 
 	if (is_valid_ether_addr(mac)) {
-		ether_addr_copy(priv->netdev->dev_addr, mac);
+		eth_hw_addr_set(priv->netdev, mac);
 		dev_info(priv->dev, "Read MAC address %pM from chip\n", mac);
 	} else {
 		eth_hw_addr_random(priv->netdev);
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index f089d33dd48e..af2c1d1535f5 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -733,7 +733,7 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	}
 	priv->dev->max_mtu = mtu;
 	priv->num_event_counters = be16_to_cpu(descriptor->counters);
-	ether_addr_copy(priv->dev->dev_addr, descriptor->mac);
+	eth_hw_addr_set(priv->dev, descriptor->mac);
 	mac = descriptor->mac;
 	dev_info(&priv->pdev->dev, "MAC addr: %pM\n", mac);
 	priv->tx_pages_per_qpl = be16_to_cpu(descriptor->tx_pages_per_qpl);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 468b8f07bf47..fea1be4c02ed 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2287,7 +2287,7 @@ static int hns3_nic_net_set_mac_address(struct net_device *netdev, void *p)
 		return ret;
 	}
 
-	ether_addr_copy(netdev->dev_addr, mac_addr->sa_data);
+	eth_hw_addr_set(netdev, mac_addr->sa_data);
 
 	return 0;
 }
@@ -4933,7 +4933,7 @@ static int hns3_init_mac_addr(struct net_device *netdev)
 		dev_warn(priv->dev, "using random MAC address %pM\n",
 			 netdev->dev_addr);
 	} else if (!ether_addr_equal(netdev->dev_addr, mac_addr_temp)) {
-		ether_addr_copy(netdev->dev_addr, mac_addr_temp);
+		eth_hw_addr_set(netdev, mac_addr_temp);
 		ether_addr_copy(netdev->perm_addr, mac_addr_temp);
 	} else {
 		return 0;
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 42d374cef664..836617fb3f40 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1613,7 +1613,7 @@ static int ibmveth_set_mac_addr(struct net_device *dev, void *p)
 		return rc;
 	}
 
-	ether_addr_copy(dev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 21efd76dd427..9d61167ba767 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4766,8 +4766,7 @@ static int handle_change_mac_rsp(union ibmvnic_crq *crq,
 	/* crq->change_mac_addr.mac_addr is the requested one
 	 * crq->change_mac_addr_rsp.mac_addr is the returned valid one.
 	 */
-	ether_addr_copy(netdev->dev_addr,
-			&crq->change_mac_addr_rsp.mac_addr[0]);
+	eth_hw_addr_set(netdev, &crq->change_mac_addr_rsp.mac_addr[0]);
 	ether_addr_copy(adapter->mac_addr,
 			&crq->change_mac_addr_rsp.mac_addr[0]);
 out:
@@ -5723,7 +5722,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	bitmap_set(adapter->map_ids, 0, 1);
 
 	ether_addr_copy(adapter->mac_addr, mac_addr_p);
-	ether_addr_copy(netdev->dev_addr, adapter->mac_addr);
+	eth_hw_addr_set(netdev, adapter->mac_addr);
 	netdev->irq = dev->irq;
 	netdev->netdev_ops = &ibmvnic_netdev_ops;
 	netdev->ethtool_ops = &ibmvnic_ethtool_ops;
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index 2fb52bd6fc0e..2cca9e84e31e 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -990,7 +990,7 @@ static int fm10k_set_mac(struct net_device *dev, void *p)
 	}
 
 	if (!err) {
-		ether_addr_copy(dev->dev_addr, addr->sa_data);
+		eth_hw_addr_set(dev, addr->sa_data);
 		ether_addr_copy(hw->mac.addr, addr->sa_data);
 		dev->addr_assign_type &= ~NET_ADDR_RANDOM;
 	}
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
index adfa2768f024..b473cb7d7c57 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
@@ -300,7 +300,7 @@ static int fm10k_handle_reset(struct fm10k_intfc *interface)
 		if (is_valid_ether_addr(hw->mac.perm_addr)) {
 			ether_addr_copy(hw->mac.addr, hw->mac.perm_addr);
 			ether_addr_copy(netdev->perm_addr, hw->mac.perm_addr);
-			ether_addr_copy(netdev->dev_addr, hw->mac.perm_addr);
+			eth_hw_addr_set(netdev, hw->mac.perm_addr);
 			netdev->addr_assign_type &= ~NET_ADDR_RANDOM;
 		}
 
@@ -2045,7 +2045,7 @@ static int fm10k_sw_init(struct fm10k_intfc *interface,
 		netdev->addr_assign_type |= NET_ADDR_RANDOM;
 	}
 
-	ether_addr_copy(netdev->dev_addr, hw->mac.addr);
+	eth_hw_addr_set(netdev, hw->mac.addr);
 	ether_addr_copy(netdev->perm_addr, hw->mac.addr);
 
 	if (!is_valid_ether_addr(netdev->perm_addr)) {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 2f20980dd9a5..f3a1d72538fb 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -1587,7 +1587,7 @@ static int i40e_set_mac(struct net_device *netdev, void *p)
 	 */
 	spin_lock_bh(&vsi->mac_filter_hash_lock);
 	i40e_del_mac_filter(vsi, netdev->dev_addr);
-	ether_addr_copy(netdev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(netdev, addr->sa_data);
 	i40e_add_mac_filter(vsi, netdev->dev_addr);
 	spin_unlock_bh(&vsi->mac_filter_hash_lock);
 
@@ -13424,7 +13424,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	i40e_add_mac_filter(vsi, broadcast);
 	spin_unlock_bh(&vsi->mac_filter_hash_lock);
 
-	ether_addr_copy(netdev->dev_addr, mac_addr);
+	eth_hw_addr_set(netdev, mac_addr);
 	ether_addr_copy(netdev->perm_addr, mac_addr);
 
 	/* i40iw_net_event() reads 16 bytes from neigh->primary_key */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 23762a7ef740..7f812abe5abe 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1847,7 +1847,7 @@ static int iavf_init_get_resources(struct iavf_adapter *adapter)
 		eth_hw_addr_random(netdev);
 		ether_addr_copy(adapter->hw.mac.addr, netdev->dev_addr);
 	} else {
-		ether_addr_copy(netdev->dev_addr, adapter->hw.mac.addr);
+		eth_hw_addr_set(netdev, adapter->hw.mac.addr);
 		ether_addr_copy(netdev->perm_addr, adapter->hw.mac.addr);
 	}
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 3c735968e1b8..8eb8d4663a81 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -1685,7 +1685,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		if (!v_retval)
 			iavf_mac_add_ok(adapter);
 		if (!ether_addr_equal(netdev->dev_addr, adapter->hw.mac.addr))
-			ether_addr_copy(netdev->dev_addr, adapter->hw.mac.addr);
+			eth_hw_addr_set(netdev, adapter->hw.mac.addr);
 		break;
 	case VIRTCHNL_OP_GET_STATS: {
 		struct iavf_eth_stats *stats =
@@ -1716,7 +1716,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 			ether_addr_copy(adapter->hw.mac.addr, netdev->dev_addr);
 		} else {
 			/* refresh current mac address if changed */
-			ether_addr_copy(netdev->dev_addr, adapter->hw.mac.addr);
+			eth_hw_addr_set(netdev, adapter->hw.mac.addr);
 			ether_addr_copy(netdev->perm_addr,
 					adapter->hw.mac.addr);
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 909e5cd98054..57e24aeffbc5 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3143,7 +3143,7 @@ static int ice_cfg_netdev(struct ice_vsi *vsi)
 	if (vsi->type == ICE_VSI_PF) {
 		SET_NETDEV_DEV(netdev, ice_pf_to_dev(vsi->back));
 		ether_addr_copy(mac_addr, vsi->port_info->mac.perm_addr);
-		ether_addr_copy(netdev->dev_addr, mac_addr);
+		eth_hw_addr_set(netdev, mac_addr);
 		ether_addr_copy(netdev->perm_addr, mac_addr);
 	}
 
@@ -5172,7 +5172,7 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 		netdev_err(netdev, "can't set MAC %pM. filter update failed\n",
 			   mac);
 		netif_addr_lock_bh(netdev);
-		ether_addr_copy(netdev->dev_addr, old_mac);
+		eth_hw_addr_set(netdev, old_mac);
 		netif_addr_unlock_bh(netdev);
 		return err;
 	}
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index c714e1ecd308..d81811ab4ec4 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -2540,7 +2540,7 @@ void ixgbevf_reset(struct ixgbevf_adapter *adapter)
 	}
 
 	if (is_valid_ether_addr(adapter->hw.mac.addr)) {
-		ether_addr_copy(netdev->dev_addr, adapter->hw.mac.addr);
+		eth_hw_addr_set(netdev, adapter->hw.mac.addr);
 		ether_addr_copy(netdev->perm_addr, adapter->hw.mac.addr);
 	}
 
@@ -3054,7 +3054,7 @@ static int ixgbevf_sw_init(struct ixgbevf_adapter *adapter)
 		else if (is_zero_ether_addr(adapter->hw.mac.addr))
 			dev_info(&pdev->dev,
 				 "MAC address not assigned by administrator.\n");
-		ether_addr_copy(netdev->dev_addr, hw->mac.addr);
+		eth_hw_addr_set(netdev, hw->mac.addr);
 	}
 
 	if (!is_valid_ether_addr(netdev->dev_addr)) {
@@ -4231,7 +4231,7 @@ static int ixgbevf_set_mac(struct net_device *netdev, void *p)
 
 	ether_addr_copy(hw->mac.addr, addr->sa_data);
 	ether_addr_copy(hw->mac.perm_addr, addr->sa_data);
-	ether_addr_copy(netdev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(netdev, addr->sa_data);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 3e9f324f1061..097516af4325 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -1297,7 +1297,7 @@ static int korina_probe(struct platform_device *pdev)
 	lp = netdev_priv(dev);
 
 	if (mac_addr)
-		ether_addr_copy(dev->dev_addr, mac_addr);
+		eth_hw_addr_set(dev, mac_addr);
 	else if (of_get_mac_address(pdev->dev.of_node, dev->dev_addr) < 0)
 		eth_hw_addr_random(dev);
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d5c92e43f89e..94ea6dd91b74 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6083,7 +6083,7 @@ static void mvpp2_port_copy_mac_addr(struct net_device *dev, struct mvpp2 *priv,
 
 	if (fwnode_get_mac_address(fwnode, fw_mac_addr, ETH_ALEN)) {
 		*mac_from = "firmware node";
-		ether_addr_copy(dev->dev_addr, fw_mac_addr);
+		eth_hw_addr_set(dev, fw_mac_addr);
 		return;
 	}
 
@@ -6091,7 +6091,7 @@ static void mvpp2_port_copy_mac_addr(struct net_device *dev, struct mvpp2 *priv,
 		mvpp21_get_mac_address(port, hw_mac_addr);
 		if (is_valid_ether_addr(hw_mac_addr)) {
 			*mac_from = "hardware";
-			ether_addr_copy(dev->dev_addr, hw_mac_addr);
+			eth_hw_addr_set(dev, hw_mac_addr);
 			return;
 		}
 	}
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
index 93575800ca92..75ba57bd1d46 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -2347,7 +2347,7 @@ int mvpp2_prs_update_mac_da(struct net_device *dev, const u8 *da)
 		return err;
 
 	/* Set addr in the device */
-	ether_addr_copy(dev->dev_addr, da);
+	eth_hw_addr_set(dev, da);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 0aa88cea1676..9826a9012737 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -188,7 +188,7 @@ static int otx2_hw_get_mac_addr(struct otx2_nic *pfvf,
 		return PTR_ERR(msghdr);
 	}
 	rsp = (struct nix_get_mac_addr_rsp *)msghdr;
-	ether_addr_copy(netdev->dev_addr, rsp->mac_addr);
+	eth_hw_addr_set(netdev, rsp->mac_addr);
 	mutex_unlock(&pfvf->mbox.lock);
 
 	return 0;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 78a7a00bce22..b667f560b931 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -137,7 +137,7 @@ static int prestera_port_set_mac_address(struct net_device *dev, void *p)
 	if (err)
 		return err;
 
-	ether_addr_copy(dev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0c5197f9cea3..e873d2322ce1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3226,7 +3226,7 @@ static int mlx5e_set_mac(struct net_device *netdev, void *addr)
 		return -EADDRNOTAVAIL;
 
 	netif_addr_lock_bh(netdev);
-	ether_addr_copy(netdev->dev_addr, saddr->sa_data);
+	eth_hw_addr_set(netdev, saddr->sa_data);
 	netif_addr_unlock_bh(netdev);
 
 	mlx5e_nic_set_rx_mode(priv);
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index 6704f5c1aa32..b990782c1eb1 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -75,7 +75,7 @@ static void mlxbf_gige_initial_mac(struct mlxbf_gige *priv)
 	u64_to_ether_addr(local_mac, mac);
 
 	if (is_valid_ether_addr(mac)) {
-		ether_addr_copy(priv->netdev->dev_addr, mac);
+		eth_hw_addr_set(priv->netdev, mac);
 	} else {
 		/* Provide a random MAC if for some reason the device has
 		 * not been configured with a valid MAC address already.
diff --git a/drivers/net/ethernet/microchip/enc28j60.c b/drivers/net/ethernet/microchip/enc28j60.c
index 09cdc2f2e7ff..bf77e8adffbf 100644
--- a/drivers/net/ethernet/microchip/enc28j60.c
+++ b/drivers/net/ethernet/microchip/enc28j60.c
@@ -517,7 +517,7 @@ static int enc28j60_set_mac_address(struct net_device *dev, void *addr)
 	if (!is_valid_ether_addr(address->sa_data))
 		return -EADDRNOTAVAIL;
 
-	ether_addr_copy(dev->dev_addr, address->sa_data);
+	eth_hw_addr_set(dev, address->sa_data);
 	return enc28j60_set_hw_macaddr(dev);
 }
 
@@ -1573,7 +1573,7 @@ static int enc28j60_probe(struct spi_device *spi)
 	}
 
 	if (device_get_mac_address(&spi->dev, macaddr, sizeof(macaddr)))
-		ether_addr_copy(dev->dev_addr, macaddr);
+		eth_hw_addr_set(dev, macaddr);
 	else
 		eth_hw_addr_random(dev);
 	enc28j60_set_hw_macaddr(dev);
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 9e8561cdc32a..03d02403c19e 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -816,7 +816,7 @@ static int lan743x_mac_init(struct lan743x_adapter *adapter)
 			eth_random_addr(adapter->mac_address);
 	}
 	lan743x_mac_set_address(adapter, adapter->mac_address);
-	ether_addr_copy(netdev->dev_addr, adapter->mac_address);
+	eth_hw_addr_set(netdev, adapter->mac_address);
 
 	return 0;
 }
@@ -2645,7 +2645,7 @@ static int lan743x_netdev_set_mac_address(struct net_device *netdev,
 	ret = eth_prepare_mac_addr_change(netdev, sock_addr);
 	if (ret)
 		return ret;
-	ether_addr_copy(netdev->dev_addr, sock_addr->sa_data);
+	eth_hw_addr_set(netdev, sock_addr->sa_data);
 	lan743x_mac_set_address(adapter, sock_addr->sa_data);
 	lan743x_rfe_update_mac_address(adapter);
 	return 0;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index cb68eaaac881..b21ebaa32d7e 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -162,7 +162,7 @@ static int sparx5_set_mac_address(struct net_device *dev, void *p)
 	sparx5_mact_learn(sparx5, PGID_CPU, addr->sa_data, port->pvid);
 
 	/* Record the address */
-	ether_addr_copy(dev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 1b21030308e5..9a871192ca96 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1608,7 +1608,7 @@ static int mana_init_port(struct net_device *ndev)
 	if (apc->num_queues > apc->max_queues)
 		apc->num_queues = apc->max_queues;
 
-	ether_addr_copy(ndev->dev_addr, apc->mac_addr);
+	eth_hw_addr_set(ndev, apc->mac_addr);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 8ef3868d7d68..2f2312715439 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -605,7 +605,7 @@ static int ocelot_port_set_mac_address(struct net_device *dev, void *p)
 	/* Then forget the previous one. */
 	ocelot_mact_forget(ocelot, dev->dev_addr, ocelot_port->pvid_vlan.vid);
 
-	ether_addr_copy(dev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(dev, addr->sa_data);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/netronome/nfp/abm/main.c b/drivers/net/ethernet/netronome/nfp/abm/main.c
index 605a1617b195..5d3df28c648f 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/main.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/main.c
@@ -305,7 +305,7 @@ nfp_abm_vnic_set_mac(struct nfp_pf *pf, struct nfp_abm *abm, struct nfp_net *nn,
 		return;
 	}
 
-	ether_addr_copy(nn->dp.netdev->dev_addr, mac_addr);
+	eth_hw_addr_set(nn->dp.netdev, mac_addr);
 	ether_addr_copy(nn->dp.netdev->perm_addr, mac_addr);
 }
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index 5fbb7c613ff1..751f76cd4f79 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -55,7 +55,7 @@ nfp_net_get_mac_addr(struct nfp_pf *pf, struct net_device *netdev,
 		return;
 	}
 
-	ether_addr_copy(netdev->dev_addr, eth_port->mac_addr);
+	eth_hw_addr_set(netdev, eth_port->mac_addr);
 	ether_addr_copy(netdev->perm_addr, eth_port->mac_addr);
 }
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
index c0e2f4394aef..87f2268b16d6 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
@@ -58,7 +58,7 @@ static void nfp_netvf_get_mac_addr(struct nfp_net *nn)
 		return;
 	}
 
-	ether_addr_copy(nn->dp.netdev->dev_addr, mac_addr);
+	eth_hw_addr_set(nn->dp.netdev, mac_addr);
 	ether_addr_copy(nn->dp.netdev->perm_addr, mac_addr);
 }
 
diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 346145d3180e..cfeb7620ae20 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -1283,7 +1283,7 @@ static int nixge_probe(struct platform_device *pdev)
 
 	mac_addr = nixge_get_nvmem_address(&pdev->dev);
 	if (mac_addr && is_valid_ether_addr(mac_addr)) {
-		ether_addr_copy(ndev->dev_addr, mac_addr);
+		eth_hw_addr_set(ndev, mac_addr);
 		kfree(mac_addr);
 	} else {
 		eth_hw_addr_random(ndev);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index f99b085b56a5..03c51dd37e1f 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -557,7 +557,7 @@ void qede_force_mac(void *dev, u8 *mac, bool forced)
 		return;
 	}
 
-	ether_addr_copy(edev->ndev->dev_addr, mac);
+	eth_hw_addr_set(edev->ndev, mac);
 	__qede_unlock(edev);
 }
 
@@ -1101,7 +1101,7 @@ int qede_set_mac_addr(struct net_device *ndev, void *p)
 			goto out;
 	}
 
-	ether_addr_copy(ndev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(ndev, addr->sa_data);
 	DP_INFO(edev, "Setting device MAC to %pM\n", addr->sa_data);
 
 	if (edev->state != QEDE_STATE_OPEN) {
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index ee4c3bd28a93..75adb71adf18 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -836,7 +836,7 @@ static void qede_init_ndev(struct qede_dev *edev)
 	ndev->max_mtu = QEDE_MAX_JUMBO_PACKET_SIZE;
 
 	/* Set network device HW mac */
-	ether_addr_copy(edev->ndev->dev_addr, edev->dev_info.common.hw_mac);
+	eth_hw_addr_set(edev->ndev, edev->dev_info.common.hw_mac);
 
 	ndev->mtu = edev->dev_info.common.mtu;
 }
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 9015a38eaced..fbfabfc5cc51 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -550,7 +550,7 @@ static int emac_probe_resources(struct platform_device *pdev,
 
 	/* get mac address */
 	if (device_get_mac_address(&pdev->dev, maddr, ETH_ALEN))
-		ether_addr_copy(netdev->dev_addr, maddr);
+		eth_hw_addr_set(netdev, maddr);
 	else
 		eth_hw_addr_random(netdev);
 
diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 752d6406f07e..06d23c708a5f 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -523,7 +523,7 @@ int efx_ef10_sriov_set_vf_mac(struct efx_nic *efx, int vf_i, u8 *mac)
 			goto fail;
 
 		if (vf->efx)
-			ether_addr_copy(vf->efx->net_dev->dev_addr, mac);
+			eth_hw_addr_set(vf->efx->net_dev, mac);
 	}
 
 	ether_addr_copy(vf->mac, mac);
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 43ef4f529028..6960a2fe2b53 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -136,7 +136,7 @@ static int efx_probe_port(struct efx_nic *efx)
 		return rc;
 
 	/* Initialise MAC address to permanent address */
-	ether_addr_copy(efx->net_dev->dev_addr, efx->net_dev->perm_addr);
+	eth_hw_addr_set(efx->net_dev, efx->net_dev->perm_addr);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 896b59253197..f187631b2c5c 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -181,11 +181,11 @@ int efx_set_mac_address(struct net_device *net_dev, void *data)
 
 	/* save old address */
 	ether_addr_copy(old_addr, net_dev->dev_addr);
-	ether_addr_copy(net_dev->dev_addr, new_addr);
+	eth_hw_addr_set(net_dev, new_addr);
 	if (efx->type->set_mac_address) {
 		rc = efx->type->set_mac_address(efx);
 		if (rc) {
-			ether_addr_copy(net_dev->dev_addr, old_addr);
+			eth_hw_addr_set(net_dev, old_addr);
 			return rc;
 		}
 	}
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 423bdf81200f..c68837a951f4 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -1044,7 +1044,7 @@ static int ef4_probe_port(struct ef4_nic *efx)
 		return rc;
 
 	/* Initialise MAC address to permanent address */
-	ether_addr_copy(efx->net_dev->dev_addr, efx->net_dev->perm_addr);
+	eth_hw_addr_set(efx->net_dev, efx->net_dev->perm_addr);
 
 	return 0;
 }
@@ -2162,11 +2162,11 @@ static int ef4_set_mac_address(struct net_device *net_dev, void *data)
 
 	/* save old address */
 	ether_addr_copy(old_addr, net_dev->dev_addr);
-	ether_addr_copy(net_dev->dev_addr, new_addr);
+	eth_hw_addr_set(net_dev, new_addr);
 	if (efx->type->set_mac_address) {
 		rc = efx->type->set_mac_address(efx);
 		if (rc) {
-			ether_addr_copy(net_dev->dev_addr, old_addr);
+			eth_hw_addr_set(net_dev, old_addr);
 			return rc;
 		}
 	}
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index f80a2aef9972..c7e56dc0a494 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -2036,7 +2036,7 @@ static int netsec_probe(struct platform_device *pdev)
 
 	mac = device_get_mac_address(&pdev->dev, macbuf, sizeof(macbuf));
 	if (mac)
-		ether_addr_copy(ndev->dev_addr, mac);
+		eth_hw_addr_set(ndev, mac);
 
 	if (priv->eeprom_base &&
 	    (!mac || !is_valid_ether_addr(ndev->dev_addr))) {
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 0de5f4a4fe08..6904bfaa5777 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1970,7 +1970,7 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 	ndev_priv->msg_enable = AM65_CPSW_DEBUG;
 	SET_NETDEV_DEV(port->ndev, dev);
 
-	ether_addr_copy(port->ndev->dev_addr, port->slave.mac_addr);
+	eth_hw_addr_set(port->ndev, port->slave.mac_addr);
 
 	port->ndev->min_mtu = AM65_CPSW_MIN_PACKET_SIZE;
 	port->ndev->max_mtu = AM65_CPSW_MAX_PACKET_SIZE;
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 1530532748a8..279e261e4720 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1000,7 +1000,7 @@ static int cpsw_ndo_set_mac_address(struct net_device *ndev, void *p)
 			   flags, vid);
 
 	ether_addr_copy(priv->mac_addr, addr->sa_data);
-	ether_addr_copy(ndev->dev_addr, priv->mac_addr);
+	eth_hw_addr_set(ndev, priv->mac_addr);
 	cpsw_set_slave_mac(&cpsw->slaves[slave_no], priv);
 
 	pm_runtime_put(cpsw->dev);
@@ -1401,7 +1401,7 @@ static int cpsw_create_ports(struct cpsw_common *cpsw)
 			dev_info(cpsw->dev, "Random MACID = %pM\n",
 				 priv->mac_addr);
 		}
-		ether_addr_copy(ndev->dev_addr, slave_data->mac_addr);
+		eth_hw_addr_set(ndev, slave_data->mac_addr);
 		ether_addr_copy(priv->mac_addr, slave_data->mac_addr);
 
 		cpsw->slaves[i].ndev = ndev;
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index e8291d848839..e4b4624be2ae 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1899,7 +1899,7 @@ static int davinci_emac_probe(struct platform_device *pdev)
 
 	rc = davinci_emac_try_get_mac(pdev, res_ctrl ? 0 : 1, priv->mac_addr);
 	if (!rc)
-		ether_addr_copy(ndev->dev_addr, priv->mac_addr);
+		eth_hw_addr_set(ndev, priv->mac_addr);
 
 	if (!is_valid_ether_addr(priv->mac_addr)) {
 		/* Use random MAC if still none obtained. */
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index eda2961c0fe2..a4cd44a39e3d 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -2028,7 +2028,7 @@ static int netcp_create_interface(struct netcp_device *netcp_device,
 
 		emac_arch_get_mac_addr(efuse_mac_addr, efuse, efuse_mac);
 		if (is_valid_ether_addr(efuse_mac_addr))
-			ether_addr_copy(ndev->dev_addr, efuse_mac_addr);
+			eth_hw_addr_set(ndev, efuse_mac_addr);
 		else
 			eth_random_addr(ndev->dev_addr);
 
diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 928c411bd509..e7b2e5fd8d24 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -323,7 +323,7 @@ static inline void eth_hw_addr_inherit(struct net_device *dst,
 				       struct net_device *src)
 {
 	dst->addr_assign_type = src->addr_assign_type;
-	ether_addr_copy(dst->dev_addr, src->dev_addr);
+	eth_hw_addr_set(dst, src->dev_addr);
 }
 
 /**
-- 
2.31.1

