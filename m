Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4995BBD1E
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiIRJuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiIRJt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:49:56 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A33912AAF
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:51 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MVjc6166czmVLX;
        Sun, 18 Sep 2022 17:45:58 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:49 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 16/55] treewide: adjust the handle for netdev features '0'
Date:   Sun, 18 Sep 2022 09:42:57 +0000
Message-ID: <20220918094336.28958-17-shenjian15@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918094336.28958-1-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the prototype of netdev_features_t will be changed from
u64 to structure, so it's unable to assignment with 0 directly.
Replace it with netdev_features_zero helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/hsi/clients/ssi_protocol.c            |  2 +-
 drivers/net/caif/caif_serial.c                |  3 ++-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  4 +++-
 drivers/net/ethernet/broadcom/b44.c           |  2 +-
 drivers/net/ethernet/broadcom/tg3.c           |  4 +++-
 drivers/net/ethernet/dnet.c                   |  2 +-
 drivers/net/ethernet/ec_bhf.c                 |  3 ++-
 drivers/net/ethernet/emulex/benet/be_main.c   |  2 +-
 drivers/net/ethernet/ethoc.c                  |  2 +-
 .../net/ethernet/huawei/hinic/hinic_main.c    |  8 ++++++--
 drivers/net/ethernet/ibm/ibmvnic.c            |  8 +++++---
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 20 ++++++++++++++-----
 drivers/net/ethernet/microsoft/mana/mana_en.c |  2 +-
 drivers/net/ethernet/sfc/ef10.c               |  3 ++-
 drivers/net/tap.c                             |  3 ++-
 drivers/net/tun.c                             |  4 +++-
 drivers/net/usb/cdc-phonet.c                  |  3 ++-
 drivers/net/usb/lan78xx.c                     |  2 +-
 drivers/s390/net/qeth_core_main.c             |  3 ++-
 drivers/usb/gadget/function/f_phonet.c        |  3 ++-
 include/linux/tcp.h                           |  1 +
 net/dccp/ipv4.c                               |  2 +-
 net/dccp/ipv6.c                               |  2 +-
 net/ethtool/ioctl.c                           |  9 +++++++--
 net/ipv4/af_inet.c                            |  2 +-
 net/ipv4/tcp.c                                |  2 +-
 net/ipv4/tcp_ipv4.c                           |  2 +-
 net/ipv6/af_inet6.c                           |  2 +-
 net/ipv6/inet6_connection_sock.c              |  2 +-
 net/ipv6/tcp_ipv6.c                           |  2 +-
 net/openvswitch/datapath.c                    |  4 +++-
 31 files changed, 75 insertions(+), 38 deletions(-)

diff --git a/drivers/hsi/clients/ssi_protocol.c b/drivers/hsi/clients/ssi_protocol.c
index 21f11a5b965b..3db5de9db626 100644
--- a/drivers/hsi/clients/ssi_protocol.c
+++ b/drivers/hsi/clients/ssi_protocol.c
@@ -1057,7 +1057,7 @@ static void ssip_pn_setup(struct net_device *dev)
 {
 	static const u8 addr = PN_MEDIA_SOS;
 
-	dev->features		= 0;
+	netdev_active_features_zero(dev);
 	dev->netdev_ops		= &ssip_pn_ops;
 	dev->type		= ARPHRD_PHONET;
 	dev->flags		= IFF_POINTOPOINT | IFF_NOARP;
diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index 688075859ae4..009090b365f1 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -11,6 +11,7 @@
 #include <linux/types.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/rtnetlink.h>
 #include <linux/tty.h>
 #include <linux/file.h>
@@ -398,7 +399,7 @@ static void caifdev_setup(struct net_device *dev)
 {
 	struct ser_device *serdev = netdev_priv(dev);
 
-	dev->features = 0;
+	netdev_active_features_zero(dev);
 	dev->netdev_ops = &netdev_ops;
 	dev->type = ARPHRD_CAIF;
 	dev->flags = IFF_POINTOPOINT | IFF_NOARP;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 571dc950c863..490451fc76a9 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4014,7 +4014,9 @@ static u32 ena_calc_max_io_queue_num(struct pci_dev *pdev,
 static void ena_set_dev_offloads(struct ena_com_dev_get_features_ctx *feat,
 				 struct net_device *netdev)
 {
-	netdev_features_t dev_features = 0;
+	netdev_features_t dev_features;
+
+	netdev_features_zero(dev_features);
 
 	/* Set offload features */
 	if (feat->offload.tx &
diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index 7821084c8fbe..153ff772b4d6 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -2359,7 +2359,7 @@ static int b44_init_one(struct ssb_device *sdev,
 	SET_NETDEV_DEV(dev, sdev->dev);
 
 	/* No interesting netdevice features in this card... */
-	dev->features |= 0;
+	dev->features |= netdev_empty_features;
 
 	bp = netdev_priv(dev);
 	bp->sdev = sdev;
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index c9f784ba26eb..bc4ee4966da8 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17552,13 +17552,13 @@ static void tg3_init_coal(struct tg3 *tp)
 static int tg3_init_one(struct pci_dev *pdev,
 				  const struct pci_device_id *ent)
 {
+	netdev_features_t features;
 	struct net_device *dev;
 	struct tg3 *tp;
 	int i, err;
 	u32 sndmbx, rcvmbx, intmbx;
 	char str[40];
 	u64 dma_mask, persist_dma_mask;
-	netdev_features_t features = 0;
 	u8 addr[ETH_ALEN] __aligned(2);
 
 	err = pci_enable_device(pdev);
@@ -17698,6 +17698,8 @@ static int tg3_init_one(struct pci_dev *pdev,
 	} else
 		persist_dma_mask = dma_mask = DMA_BIT_MASK(64);
 
+	netdev_features_zero(features);
+
 	/* Configure DMA attributes. */
 	if (dma_mask > DMA_BIT_MASK(32)) {
 		err = dma_set_mask(&pdev->dev, dma_mask);
diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index 99e6f76f6cc0..17143e07c875 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -763,7 +763,7 @@ static int dnet_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	/* TODO: Actually, we have some interesting features... */
-	dev->features |= 0;
+	dev->features |= netdev_empty_features;
 
 	bp = netdev_priv(dev);
 	bp->dev = dev;
diff --git a/drivers/net/ethernet/ec_bhf.c b/drivers/net/ethernet/ec_bhf.c
index 46e3a05e9582..cc8dcd86d2ac 100644
--- a/drivers/net/ethernet/ec_bhf.c
+++ b/drivers/net/ethernet/ec_bhf.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/ip.h>
 #include <linux/skbuff.h>
@@ -525,7 +526,7 @@ static int ec_bhf_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	pci_set_drvdata(dev, net_dev);
 	SET_NETDEV_DEV(net_dev, &dev->dev);
 
-	net_dev->features = 0;
+	netdev_active_features_zero(net_dev);
 	net_dev->flags |= IFF_NOARP;
 
 	net_dev->netdev_ops = &ec_bhf_netdev_ops;
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 35b4d335e97c..9f0e58d34d2c 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -4025,7 +4025,7 @@ static int be_vxlan_unset_port(struct net_device *netdev, unsigned int table,
 	adapter->flags &= ~BE_FLAGS_VXLAN_OFFLOADS;
 	adapter->vxlan_port = 0;
 
-	netdev->hw_enc_features = 0;
+	netdev_hw_enc_features_zero(netdev);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index 437c5acfe222..3ced63aaa6cb 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -1220,7 +1220,7 @@ static int ethoc_probe(struct platform_device *pdev)
 	/* setup the net_device structure */
 	netdev->netdev_ops = &ethoc_netdev_ops;
 	netdev->watchdog_timeo = ETHOC_TIMEOUT;
-	netdev->features |= 0;
+	netdev->features |= netdev_empty_features;
 	netdev->ethtool_ops = &ethoc_ethtool_ops;
 
 	/* setup NAPI */
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 09815e4bea8f..c4e25a34cab7 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -1063,10 +1063,11 @@ static int set_features(struct hinic_dev *nic_dev,
 {
 	netdev_features_t changed = force_change ? ~0 : pre_features ^ features;
 	u32 csum_en = HINIC_RX_CSUM_OFFLOAD_EN;
-	netdev_features_t failed_features = 0;
+	netdev_features_t failed_features;
 	int ret = 0;
 	int err = 0;
 
+	netdev_features_zero(failed_features);
 	if (changed & NETIF_F_TSO) {
 		ret = hinic_port_set_tso(nic_dev, (features & NETIF_F_TSO) ?
 					 HINIC_TSO_ENABLE : HINIC_TSO_DISABLE);
@@ -1165,6 +1166,7 @@ static int nic_dev_init(struct pci_dev *pdev)
 	struct net_device *netdev;
 	struct hinic_hwdev *hwdev;
 	struct devlink *devlink;
+	netdev_features_t feats;
 	u8 addr[ETH_ALEN];
 	int err, num_qps;
 
@@ -1284,7 +1286,9 @@ static int nic_dev_init(struct pci_dev *pdev)
 				HINIC_MGMT_MSG_CMD_LINK_ERR_EVENT,
 				nic_dev, link_err_event);
 
-	err = set_features(nic_dev, 0, nic_dev->netdev->features, true);
+	netdev_features_zero(feats);
+	err = set_features(nic_dev, feats,
+			   nic_dev->netdev->features, true);
 	if (err)
 		goto err_set_features;
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 0ea0f2e5c8e0..7fcb8c9506dc 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4836,7 +4836,7 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 	struct ibmvnic_control_ip_offload_buffer *ctrl_buf = &adapter->ip_offload_ctrl;
 	struct ibmvnic_query_ip_offload_buffer *buf = &adapter->ip_offload_buf;
 	struct device *dev = &adapter->vdev->dev;
-	netdev_features_t old_hw_features = 0;
+	netdev_features_t old_hw_features;
 	union ibmvnic_crq crq;
 
 	adapter->ip_offload_ctrl_tok =
@@ -4865,9 +4865,10 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 	ctrl_buf->large_rx_ipv4 = 0;
 	ctrl_buf->large_rx_ipv6 = 0;
 
+	netdev_hw_features_zero(old_hw_features);
 	if (adapter->state != VNIC_PROBING) {
 		old_hw_features = adapter->netdev->hw_features;
-		adapter->netdev->hw_features = 0;
+		netdev_hw_features_zero(adapter->netdev);
 	}
 
 	netdev_hw_features_zero(adapter->netdev);
@@ -4891,8 +4892,9 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 	if (adapter->state == VNIC_PROBING) {
 		adapter->netdev->features |= adapter->netdev->hw_features;
 	} else if (old_hw_features != adapter->netdev->hw_features) {
-		netdev_features_t tmp = 0;
+		netdev_features_t tmp;
 
+		netdev_features_zero(tmp);
 		/* disable features no longer supported */
 		adapter->netdev->features &= adapter->netdev->hw_features;
 		/* turn on features now supported if previously enabled */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 38d7ba76643a..39fbfe6e18e9 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2670,9 +2670,14 @@ static void iavf_init_config_adapter(struct iavf_adapter *adapter)
 	else
 		iavf_init_rss(adapter);
 
-	if (VLAN_V2_ALLOWED(adapter))
+	if (VLAN_V2_ALLOWED(adapter)) {
+		netdev_features_t feats;
+
+		netdev_features_zero(feats);
 		/* request initial VLAN offload settings */
-		iavf_set_vlan_offload_features(adapter, 0, netdev->features);
+		iavf_set_vlan_offload_features(adapter, feats,
+					       netdev->features);
+	}
 
 	return;
 err_mem:
@@ -3232,14 +3237,16 @@ static void iavf_adminq_task(struct work_struct *work)
 		if (adapter->netdev_registered ||
 		    !test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section)) {
 			struct net_device *netdev = adapter->netdev;
+			netdev_features_t feats;
 
 			rtnl_lock();
 			netdev_update_features(netdev);
 			rtnl_unlock();
+			netdev_features_zero(feats);
 			/* Request VLAN offload settings */
 			if (VLAN_V2_ALLOWED(adapter))
 				iavf_set_vlan_offload_features
-					(adapter, 0, netdev->features);
+					(adapter, feats, netdev->features);
 
 			iavf_set_queue_vlan_tag_loc(adapter);
 		}
@@ -4441,7 +4448,9 @@ static netdev_features_t iavf_features_check(struct sk_buff *skb,
 static netdev_features_t
 iavf_get_netdev_vlan_hw_features(struct iavf_adapter *adapter)
 {
-	netdev_features_t hw_features = 0;
+	netdev_features_t hw_features;
+
+	netdev_features_zero(hw_features);
 
 	if (!adapter->vf_res || !adapter->vf_res->vf_cap_flags)
 		return hw_features;
@@ -4502,8 +4511,9 @@ iavf_get_netdev_vlan_hw_features(struct iavf_adapter *adapter)
 static netdev_features_t
 iavf_get_netdev_vlan_features(struct iavf_adapter *adapter)
 {
-	netdev_features_t features = 0;
+	netdev_features_t features;
 
+	netdev_features_zero(features);
 	if (!adapter->vf_res || !adapter->vf_res->vf_cap_flags)
 		return features;
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 68962a6c0bbd..8f8cc9bd5577 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2087,7 +2087,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 				   NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
 				   NETIF_F_RXHASH_BIT);
 	ndev->features = ndev->hw_features;
-	ndev->vlan_features = 0;
+	netdev_vlan_features_zero(ndev);
 
 	err = register_netdev(ndev);
 	if (err) {
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 7f0e59652305..a9f3b1793437 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1304,7 +1304,7 @@ static void efx_ef10_fini_nic(struct efx_nic *efx)
 static int efx_ef10_init_nic(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	netdev_features_t hw_enc_features = 0;
+	netdev_features_t hw_enc_features;
 	int rc;
 
 	if (nic_data->must_check_datapath_caps) {
@@ -1349,6 +1349,7 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 		nic_data->must_restore_piobufs = false;
 	}
 
+	netdev_features_zero(hw_enc_features);
 	/* add encapsulated checksum offload features */
 	if (efx_has_cap(efx, VXLAN_NVGRE) && !efx_ef10_is_vf(efx))
 		hw_enc_features |= netdev_ip_csum_features;
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index ab78a12218bc..abd499a8f289 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -938,13 +938,14 @@ static int tap_ioctl_set_queue(struct file *file, unsigned int flags)
 static int set_offload(struct tap_queue *q, unsigned long arg)
 {
 	struct tap_dev *tap;
+	netdev_features_t feature_mask;
 	netdev_features_t features;
-	netdev_features_t feature_mask = 0;
 
 	tap = rtnl_dereference(q->tap);
 	if (!tap)
 		return -ENOLINK;
 
+	netdev_features_zero(feature_mask);
 	features = tap->dev->features;
 
 	if (arg & TUN_F_CSUM) {
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 1c895384bf03..95de1f551d59 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2858,7 +2858,9 @@ static void tun_get_iff(struct tun_struct *tun, struct ifreq *ifr)
  * privs required. */
 static int set_offload(struct tun_struct *tun, unsigned long arg)
 {
-	netdev_features_t features = 0;
+	netdev_features_t features;
+
+	netdev_features_zero(features);
 
 	if (arg & TUN_F_CSUM) {
 		features |= NETIF_F_HW_CSUM;
diff --git a/drivers/net/usb/cdc-phonet.c b/drivers/net/usb/cdc-phonet.c
index ad5121e9cf5d..d7568af38f96 100644
--- a/drivers/net/usb/cdc-phonet.c
+++ b/drivers/net/usb/cdc-phonet.c
@@ -14,6 +14,7 @@
 #include <linux/usb.h>
 #include <linux/usb/cdc.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/if_arp.h>
 #include <linux/if_phonet.h>
 #include <linux/phonet.h>
@@ -277,7 +278,7 @@ static void usbpn_setup(struct net_device *dev)
 {
 	const u8 addr = PN_MEDIA_USB;
 
-	dev->features		= 0;
+	netdev_active_features_zero(dev);
 	dev->netdev_ops		= &usbpn_ops;
 	dev->header_ops		= &phonet_header_ops;
 	dev->type		= ARPHRD_PHONET;
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 381799e045e1..8f6268a2edd1 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3457,7 +3457,7 @@ static int lan78xx_bind(struct lan78xx_net *dev, struct usb_interface *intf)
 
 	INIT_WORK(&pdata->set_vlan, lan78xx_deferred_vlan_write);
 
-	dev->net->features = 0;
+	netdev_active_features_zero(dev->net);
 
 	if (DEFAULT_TX_CSUM_ENABLE)
 		dev->net->features |= NETIF_F_HW_CSUM;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 8bd9fd51208c..65b9c10c1a08 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6864,8 +6864,9 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 	/* Traffic with local next-hop is not eligible for some offloads: */
 	if (skb->ip_summed == CHECKSUM_PARTIAL &&
 	    READ_ONCE(card->options.isolation) != ISOLATION_MODE_FWD) {
-		netdev_features_t restricted = 0;
+		netdev_features_t restricted;
 
+		netdev_features_zero(restricted);
 		if (skb_is_gso(skb) && !netif_needs_gso(skb, features))
 			restricted |= NETIF_F_ALL_TSO;
 
diff --git a/drivers/usb/gadget/function/f_phonet.c b/drivers/usb/gadget/function/f_phonet.c
index 0bebbdf3f213..b9d6445b3bbf 100644
--- a/drivers/usb/gadget/function/f_phonet.c
+++ b/drivers/usb/gadget/function/f_phonet.c
@@ -14,6 +14,7 @@
 #include <linux/device.h>
 
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/if_ether.h>
 #include <linux/if_phonet.h>
 #include <linux/if_arp.h>
@@ -269,7 +270,7 @@ static void pn_net_setup(struct net_device *dev)
 {
 	const u8 addr = PN_MEDIA_USB;
 
-	dev->features		= 0;
+	netdev_active_features_zero(dev);
 	dev->type		= ARPHRD_PHONET;
 	dev->flags		= IFF_POINTOPOINT | IFF_NOARP;
 	dev->mtu		= PHONET_DEV_MTU;
diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index a9fbe22732c3..800c545f3c74 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -16,6 +16,7 @@
 
 #include <linux/skbuff.h>
 #include <linux/win_minmax.h>
+#include <linux/netdev_feature_helpers.h>
 #include <net/sock.h>
 #include <net/inet_connection_sock.h>
 #include <net/inet_timewait_sock.h>
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 6a6e121dc00c..d9d1c658245a 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -158,7 +158,7 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 */
 	dccp_set_state(sk, DCCP_CLOSED);
 	ip_rt_put(rt);
-	sk->sk_route_caps = 0;
+	netdev_features_zero(sk->sk_route_caps);
 	inet->inet_dport = 0;
 	goto out;
 }
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 9915a6d15886..956985d3d132 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -989,7 +989,7 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	__sk_dst_reset(sk);
 failure:
 	inet->inet_dport = 0;
-	sk->sk_route_caps = 0;
+	netdev_features_zero(sk->sk_route_caps);
 	return err;
 }
 
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 586b4ee4ee85..04d0c37ba763 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -125,7 +125,8 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_sfeatures cmd;
 	struct ethtool_set_features_block features[ETHTOOL_DEV_FEATURE_WORDS];
-	netdev_features_t wanted = 0, valid = 0;
+	netdev_features_t wanted;
+	netdev_features_t valid;
 	netdev_features_t tmp;
 	int i, ret = 0;
 
@@ -139,6 +140,8 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 	if (copy_from_user(features, useraddr, sizeof(features)))
 		return -EFAULT;
 
+	netdev_features_zero(wanted);
+	netdev_features_zero(valid);
 	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; ++i) {
 		valid |= (netdev_features_t)features[i].valid << (32 * i);
 		wanted |= (netdev_features_t)features[i].requested << (32 * i);
@@ -325,13 +328,15 @@ static u32 __ethtool_get_flags(struct net_device *dev)
 
 static int __ethtool_set_flags(struct net_device *dev, u32 data)
 {
-	netdev_features_t features = 0, changed;
 	netdev_features_t eth_all_features;
+	netdev_features_t features;
+	netdev_features_t changed;
 	netdev_features_t tmp;
 
 	if (data & ~ETH_ALL_FLAGS)
 		return -EINVAL;
 
+	netdev_features_zero(features);
 	if (data & ETH_FLAG_LRO)
 		features |= NETIF_F_LRO;
 	if (data & ETH_FLAG_RXVLAN)
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index d3ab1ae32ef5..1607dd056702 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1313,7 +1313,7 @@ int inet_sk_rebuild_header(struct sock *sk)
 		err = PTR_ERR(rt);
 
 		/* Routing failed... */
-		sk->sk_route_caps = 0;
+		netdev_features_zero(sk->sk_route_caps);
 		/*
 		 * Other protocols have to map its equivalent state to TCP_SYN_SENT.
 		 * DCCP maps its DCCP_REQUESTING state to TCP_SYN_SENT. -acme
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8230be00ecca..467a9c6aefb1 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1193,7 +1193,7 @@ static int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg,
 		if (err) {
 			tcp_set_state(sk, TCP_CLOSE);
 			inet->inet_dport = 0;
-			sk->sk_route_caps = 0;
+			netdev_features_zero(sk->sk_route_caps);
 		}
 	}
 	flags = (msg->msg_flags & MSG_DONTWAIT) ? O_NONBLOCK : 0;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 01b31f5c7aba..2f21fc55261d 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -343,7 +343,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 */
 	tcp_set_state(sk, TCP_CLOSE);
 	ip_rt_put(rt);
-	sk->sk_route_caps = 0;
+	netdev_features_zero(sk->sk_route_caps);
 	inet->inet_dport = 0;
 	return err;
 }
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 19732b5dce23..754599d8e1e3 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -846,7 +846,7 @@ int inet6_sk_rebuild_header(struct sock *sk)
 
 		dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 		if (IS_ERR(dst)) {
-			sk->sk_route_caps = 0;
+			netdev_features_zero(sk->sk_route_caps);
 			sk->sk_err_soft = -PTR_ERR(dst);
 			return PTR_ERR(dst);
 		}
diff --git a/net/ipv6/inet6_connection_sock.c b/net/ipv6/inet6_connection_sock.c
index 5a9f4d722f35..24ff7edb9f57 100644
--- a/net/ipv6/inet6_connection_sock.c
+++ b/net/ipv6/inet6_connection_sock.c
@@ -121,7 +121,7 @@ int inet6_csk_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl_unused
 	dst = inet6_csk_route_socket(sk, &fl6);
 	if (IS_ERR(dst)) {
 		sk->sk_err_soft = -PTR_ERR(dst);
-		sk->sk_route_caps = 0;
+		netdev_features_zero(sk->sk_route_caps);
 		kfree_skb(skb);
 		return PTR_ERR(dst);
 	}
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 35013497e407..e93d739425f3 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -359,7 +359,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	tcp_set_state(sk, TCP_CLOSE);
 failure:
 	inet->inet_dport = 0;
-	sk->sk_route_caps = 0;
+	netdev_features_zero(sk->sk_route_caps);
 	return err;
 }
 
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index a7687f1f668f..0f21f1cdb6bc 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -417,6 +417,7 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 	struct ovs_header *upcall;
 	struct sk_buff *nskb = NULL;
 	struct sk_buff *user_skb = NULL; /* to be queued to userspace */
+	netdev_features_t feats;
 	struct nlattr *nla;
 	size_t len;
 	unsigned int hlen;
@@ -444,9 +445,10 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 		goto out;
 	}
 
+	netdev_features_zero(feats);
 	/* Complete checksum if needed */
 	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-	    (err = skb_csum_hwoffload_help(skb, 0)))
+	    (err = skb_csum_hwoffload_help(skb, feats)))
 		goto out;
 
 	/* Older versions of OVS user space enforce alignment of the last
-- 
2.33.0

