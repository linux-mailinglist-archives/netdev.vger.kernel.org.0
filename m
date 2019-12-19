Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B142D126E1D
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 20:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfLSTlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 14:41:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44130 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727218AbfLSTlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 14:41:24 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJJcb30181182;
        Thu, 19 Dec 2019 14:41:20 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2x0efrjh32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 14:41:20 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xBJJdBKU182869;
        Thu, 19 Dec 2019 14:41:19 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2x0efrjh27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 14:41:19 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xBJJeXpJ012785;
        Thu, 19 Dec 2019 19:41:18 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01dal.us.ibm.com with ESMTP id 2wvqc7ddc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 19:41:18 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBJJfGik35520940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 19:41:16 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DC57BE051;
        Thu, 19 Dec 2019 19:41:16 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B9BFBE04F;
        Thu, 19 Dec 2019 19:41:15 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.160.22.203])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 19 Dec 2019 19:41:14 +0000 (GMT)
From:   Cris Forno <cforno12@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     mst@redhat.com, jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com,
        Cris Forno <cforno12@linux.vnet.ibm.com>
Subject: [PATCH, net-next, v3, 2/2] With get/set link settings functions in core/ethtool.c, ibmveth, netvsc, and virtio now use the core's helper function.
Date:   Thu, 19 Dec 2019 13:40:57 -0600
Message-Id: <20191219194057.4208-3-cforno12@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219194057.4208-1-cforno12@linux.vnet.ibm.com>
References: <20191219194057.4208-1-cforno12@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-19_06:2019-12-17,2019-12-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 suspectscore=1 mlxlogscore=999 priorityscore=1501
 clxscore=1015 spamscore=0 phishscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912190145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Cris Forno <cforno12@linux.vnet.ibm.com>
---
 drivers/net/ethernet/ibm/ibmveth.c | 60 +++++++++++++++++++++-----------------
 drivers/net/ethernet/ibm/ibmveth.h |  3 ++
 drivers/net/hyperv/netvsc_drv.c    | 21 ++++---------
 drivers/net/virtio_net.c           | 45 ++++------------------------
 4 files changed, 46 insertions(+), 83 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index c5be4eb..6f9350ca5 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -712,31 +712,34 @@ static int ibmveth_close(struct net_device *netdev)
 	return 0;
 }
 
-static int netdev_get_link_ksettings(struct net_device *dev,
-				     struct ethtool_link_ksettings *cmd)
+static int ibmveth_set_link_ksettings(struct net_device *dev,
+				      const struct ethtool_link_ksettings *cmd)
 {
-	u32 supported, advertising;
-
-	supported = (SUPPORTED_1000baseT_Full | SUPPORTED_Autoneg |
-				SUPPORTED_FIBRE);
-	advertising = (ADVERTISED_1000baseT_Full | ADVERTISED_Autoneg |
-				ADVERTISED_FIBRE);
-	cmd->base.speed = SPEED_1000;
-	cmd->base.duplex = DUPLEX_FULL;
-	cmd->base.port = PORT_FIBRE;
-	cmd->base.phy_address = 0;
-	cmd->base.autoneg = AUTONEG_ENABLE;
-
-	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported,
-						supported);
-	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.advertising,
-						advertising);
+	struct ibmveth_adapter *adapter = netdev_priv(dev);
 
-	return 0;
+	return ethtool_virtdev_set_ksettings(dev, cmd,
+					     &adapter->speed, &adapter->duplex);
+}
+
+static int ibmveth_get_link_ksettings(struct net_device *dev,
+				      struct ethtool_link_ksettings *cmd)
+{
+	struct ibmveth_adapter *adapter = netdev_priv(dev);
+
+	return ethtool_virtdev_get_ksettings(dev, cmd,
+					     &adapter->speed, &adapter->duplex);
+}
+
+static void ibmveth_init_link_settings(struct net_device *dev)
+{
+	struct ibmveth_adapter *adapter = netdev_priv(dev);
+
+	adapter->speed = SPEED_1000;
+	adapter->duplex = DUPLEX_FULL;
 }
 
-static void netdev_get_drvinfo(struct net_device *dev,
-			       struct ethtool_drvinfo *info)
+static void ibmveth_get_drvinfo(struct net_device *dev,
+				struct ethtool_drvinfo *info)
 {
 	strlcpy(info->driver, ibmveth_driver_name, sizeof(info->driver));
 	strlcpy(info->version, ibmveth_driver_version, sizeof(info->version));
@@ -965,12 +968,14 @@ static void ibmveth_get_ethtool_stats(struct net_device *dev,
 }
 
 static const struct ethtool_ops netdev_ethtool_ops = {
-	.get_drvinfo		= netdev_get_drvinfo,
-	.get_link		= ethtool_op_get_link,
-	.get_strings		= ibmveth_get_strings,
-	.get_sset_count		= ibmveth_get_sset_count,
-	.get_ethtool_stats	= ibmveth_get_ethtool_stats,
-	.get_link_ksettings	= netdev_get_link_ksettings,
+	.get_drvinfo		         = ibmveth_get_drvinfo,
+	.get_link		         = ethtool_op_get_link,
+	.get_strings		         = ibmveth_get_strings,
+	.get_sset_count		         = ibmveth_get_sset_count,
+	.get_ethtool_stats	         = ibmveth_get_ethtool_stats,
+	.get_link_ksettings	         = ibmveth_get_link_ksettings,
+	.set_link_ksettings              = ibmveth_set_link_ksettings,
+	.virtdev_validate_link_ksettings = ethtool_virtdev_validate_cmd,
 };
 
 static int ibmveth_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
@@ -1648,6 +1653,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	adapter->netdev = netdev;
 	adapter->mcastFilterSize = be32_to_cpu(*mcastFilterSize_p);
 	adapter->pool_config = 0;
+	ibmveth_init_link_settings(netdev);
 
 	netif_napi_add(netdev, &adapter->napi, ibmveth_poll, 16);
 
diff --git a/drivers/net/ethernet/ibm/ibmveth.h b/drivers/net/ethernet/ibm/ibmveth.h
index 4e9bf34..27dfff2 100644
--- a/drivers/net/ethernet/ibm/ibmveth.h
+++ b/drivers/net/ethernet/ibm/ibmveth.h
@@ -162,6 +162,9 @@ struct ibmveth_adapter {
     u64 tx_send_failed;
     u64 tx_large_packets;
     u64 rx_large_packets;
+    /* Ethtool settings */
+	u8 duplex;
+	u32 speed;
 };
 
 /*
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 5fa5c49..d0dfa8e 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1084,29 +1084,17 @@ static int netvsc_get_link_ksettings(struct net_device *dev,
 {
 	struct net_device_context *ndc = netdev_priv(dev);
 
-	cmd->base.speed = ndc->speed;
-	cmd->base.duplex = ndc->duplex;
-	cmd->base.port = PORT_OTHER;
-
-	return 0;
+	return ethtool_virtdev_get_link_ksettings(dev, cmd,
+						  &ndc->speed, &ndc->duplex);
 }
 
 static int netvsc_set_link_ksettings(struct net_device *dev,
 				     const struct ethtool_link_ksettings *cmd)
 {
 	struct net_device_context *ndc = netdev_priv(dev);
-	u32 speed;
-
-	speed = cmd->base.speed;
-	if (!ethtool_validate_speed(speed) ||
-	    !ethtool_validate_duplex(cmd->base.duplex) ||
-	    !netvsc_validate_ethtool_ss_cmd(cmd))
-		return -EINVAL;
-
-	ndc->speed = speed;
-	ndc->duplex = cmd->base.duplex;
 
-	return 0;
+	return ethtool_virtdev_set_link_ksettings(dev, cmd,
+						  &ndc->speed, &ndc->duplex);
 }
 
 static int netvsc_change_mtu(struct net_device *ndev, int mtu)
@@ -1867,6 +1855,7 @@ static void netvsc_set_msglevel(struct net_device *ndev, u32 val)
 	.set_link_ksettings = netvsc_set_link_ksettings,
 	.get_ringparam	= netvsc_get_ringparam,
 	.set_ringparam	= netvsc_set_ringparam,
+	.virtdev_validate_link_ksettings = netvsc_validate_ethtool_ss_cmd,
 };
 
 static const struct net_device_ops device_ops = {
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 5a635f0..5cbcb16 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2166,48 +2166,15 @@ static void virtnet_get_channels(struct net_device *dev,
 	channels->other_count = 0;
 }
 
-/* Check if the user is trying to change anything besides speed/duplex */
-static bool
-virtnet_validate_ethtool_cmd(const struct ethtool_link_ksettings *cmd)
-{
-	struct ethtool_link_ksettings diff1 = *cmd;
-	struct ethtool_link_ksettings diff2 = {};
-
-	/* cmd is always set so we need to clear it, validate the port type
-	 * and also without autonegotiation we can ignore advertising
-	 */
-	diff1.base.speed = 0;
-	diff2.base.port = PORT_OTHER;
-	ethtool_link_ksettings_zero_link_mode(&diff1, advertising);
-	diff1.base.duplex = 0;
-	diff1.base.cmd = 0;
-	diff1.base.link_mode_masks_nwords = 0;
-
-	return !memcmp(&diff1.base, &diff2.base, sizeof(diff1.base)) &&
-		bitmap_empty(diff1.link_modes.supported,
-			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&
-		bitmap_empty(diff1.link_modes.advertising,
-			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&
-		bitmap_empty(diff1.link_modes.lp_advertising,
-			     __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
 
 static int virtnet_set_link_ksettings(struct net_device *dev,
 				      const struct ethtool_link_ksettings *cmd)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
-	u32 speed;
 
-	speed = cmd->base.speed;
-	/* don't allow custom speed and duplex */
-	if (!ethtool_validate_speed(speed) ||
-	    !ethtool_validate_duplex(cmd->base.duplex) ||
-	    !virtnet_validate_ethtool_cmd(cmd))
-		return -EINVAL;
-	vi->speed = speed;
-	vi->duplex = cmd->base.duplex;
-
-	return 0;
+	return ethtool_virtdev_set_link_ksettings(dev, cmd,
+						  &vi->speed, &vi->duplex);
 }
 
 static int virtnet_get_link_ksettings(struct net_device *dev,
@@ -2215,11 +2182,8 @@ static int virtnet_get_link_ksettings(struct net_device *dev,
 {
 	struct virtnet_info *vi = netdev_priv(dev);
 
-	cmd->base.speed = vi->speed;
-	cmd->base.duplex = vi->duplex;
-	cmd->base.port = PORT_OTHER;
-
-	return 0;
+	return ethtool_virtdev_get_link_ksettings(dev, cmd,
+						  vi->speed, vi->duplex);
 }
 
 static int virtnet_set_coalesce(struct net_device *dev,
@@ -2309,6 +2273,7 @@ static void virtnet_update_settings(struct virtnet_info *vi)
 	.set_link_ksettings = virtnet_set_link_ksettings,
 	.set_coalesce = virtnet_set_coalesce,
 	.get_coalesce = virtnet_get_coalesce,
+	.virtdev_validate_link_ksettings = ethtool_virtdev_validate_cmd,
 };
 
 static void virtnet_freeze_down(struct virtio_device *vdev)
-- 
1.8.3.1

