Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7C014E81A
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 06:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbgAaFCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 00:02:36 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47796 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgAaFCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 00:02:35 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00V4w2Fb163740;
        Fri, 31 Jan 2020 05:00:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=ZQU5pjagovfzj67UlXMMtovHXCYgxqsUWqAbT7eBLpo=;
 b=LAWtH3+sIYNNX5aUn+3YLF3Vytzinb38A2xKWulszer98DKCjNnT9D6TTmdDpKHSE04A
 FBbzPoHSFl7M89txI4ENIeFSYuRC0lomDTMlveHW0Bu8MTaNEjj7wKSoMfBlyer+h1FD
 4FUlPl1zgsBC4BKpeTp09vPRei3WygTzwpud4fYEvMYEwflEwFFH/SbsujMuCKeTdLUT
 ND6vOJu/+XS8713VXKtt6Y4pcu+utaP9SX2637HhZFtEOuloy102yzr46+s8FcPiBO3l
 rpTxVJdCpucKn03lddjZHlKTl/HzEG5todFZ24mGEXygKLcn9ujGYXUWkj3O4MiWV907 +A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xrdmr0651-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 05:00:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00V4w1Y3123010;
        Fri, 31 Jan 2020 05:00:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xv9bvtw95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 05:00:15 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00V50508006695;
        Fri, 31 Jan 2020 05:00:06 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jan 2020 21:00:05 -0800
Date:   Fri, 31 Jan 2020 07:59:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ajay Gupta <ajayg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] device property: change device_get_phy_mode() to prevent
 signedess bugs
Message-ID: <20200131045953.wbj66jkvijnmf5s2@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001310043
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001310043
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device_get_phy_mode() was returning negative error codes on
failure and positive phy_interface_t values on success.  The problem is
that the phy_interface_t type is an enum which GCC treats as unsigned.
This lead to recurring signedness bugs where we check "if (phy_mode < 0)"
and "phy_mode" is unsigned.

In the commit 0c65b2b90d13 ("net: of_get_phy_mode: Change API to solve
int/unit warnings") we updated of_get_phy_mode() take a pointer to
phy_mode and only return zero on success and negatives on failure.  This
patch does the same thing for device_get_phy_mode().  Plus it's just
nice for the API to be the same in both places.

Fixes: b9f0b2f634c0 ("net: stmmac: platform: fix probe for ACPI devices")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This is a change to drivers/base/ but all the users are ethernet drivers
so probably it makes sense for Dave to take this?

Also this fixes a bug in stmmac.  If you wanted I could make a one
liner fix for that and then write this change on top of that.  The bug
is only in v5.6 so it doesn't affect old kernels.

 drivers/base/property.c                               | 13 +++++++++++--
 drivers/net/ethernet/apm/xgene-v2/main.c              |  9 ++++-----
 drivers/net/ethernet/apm/xgene-v2/main.h              |  2 +-
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c      |  6 +++---
 drivers/net/ethernet/apm/xgene/xgene_enet_main.h      |  2 +-
 drivers/net/ethernet/smsc/smsc911x.c                  |  8 +++-----
 drivers/net/ethernet/socionext/netsec.c               |  5 ++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c |  6 +++---
 include/linux/property.h                              |  3 ++-
 9 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 511f6d7acdfe..8854cfbd213b 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -863,9 +863,18 @@ EXPORT_SYMBOL_GPL(fwnode_get_phy_mode);
  * 'phy-connection-type', and return its index in phy_modes table, or errno in
  * error case.
  */
-int device_get_phy_mode(struct device *dev)
+int device_get_phy_mode(struct device *dev, phy_interface_t *interface)
 {
-	return fwnode_get_phy_mode(dev_fwnode(dev));
+	int mode;
+
+	*interface = PHY_INTERFACE_MODE_NA;
+
+	mode = fwnode_get_phy_mode(dev_fwnode(dev));
+	if (mode < 0)
+		return mode;
+
+	*interface = mode;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(device_get_phy_mode);
 
diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
index c48f60996761..706602918dd1 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -15,7 +15,7 @@ static int xge_get_resources(struct xge_pdata *pdata)
 {
 	struct platform_device *pdev;
 	struct net_device *ndev;
-	int phy_mode, ret = 0;
+	int ret = 0;
 	struct resource *res;
 	struct device *dev;
 
@@ -41,12 +41,11 @@ static int xge_get_resources(struct xge_pdata *pdata)
 
 	memcpy(ndev->perm_addr, ndev->dev_addr, ndev->addr_len);
 
-	phy_mode = device_get_phy_mode(dev);
-	if (phy_mode < 0) {
+	ret = device_get_phy_mode(dev, &pdata->resources.phy_mode);
+	if (ret) {
 		dev_err(dev, "Unable to get phy-connection-type\n");
-		return phy_mode;
+		return ret;
 	}
-	pdata->resources.phy_mode = phy_mode;
 
 	if (pdata->resources.phy_mode != PHY_INTERFACE_MODE_RGMII) {
 		dev_err(dev, "Incorrect phy-connection-type specified\n");
diff --git a/drivers/net/ethernet/apm/xgene-v2/main.h b/drivers/net/ethernet/apm/xgene-v2/main.h
index d41439d2709d..d687f0185908 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.h
+++ b/drivers/net/ethernet/apm/xgene-v2/main.h
@@ -35,7 +35,7 @@
 
 struct xge_resource {
 	void __iomem *base_addr;
-	int phy_mode;
+	phy_interface_t phy_mode;
 	u32 irq;
 };
 
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 6aee2f0fc0db..da35e70ccceb 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -1736,10 +1736,10 @@ static int xgene_enet_get_resources(struct xgene_enet_pdata *pdata)
 
 	memcpy(ndev->perm_addr, ndev->dev_addr, ndev->addr_len);
 
-	pdata->phy_mode = device_get_phy_mode(dev);
-	if (pdata->phy_mode < 0) {
+	ret = device_get_phy_mode(dev, &pdata->phy_mode);
+	if (ret) {
 		dev_err(dev, "Unable to get phy-connection-type\n");
-		return pdata->phy_mode;
+		return ret;
 	}
 	if (!phy_interface_mode_is_rgmii(pdata->phy_mode) &&
 	    pdata->phy_mode != PHY_INTERFACE_MODE_SGMII &&
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.h b/drivers/net/ethernet/apm/xgene/xgene_enet_main.h
index 18f4923b1723..600cddf1942d 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.h
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.h
@@ -209,7 +209,7 @@ struct xgene_enet_pdata {
 	void __iomem *pcs_addr;
 	void __iomem *ring_csr_addr;
 	void __iomem *ring_cmd_addr;
-	int phy_mode;
+	phy_interface_t phy_mode;
 	enum xgene_enet_rm rm;
 	struct xgene_enet_cle cle;
 	u64 *extd_stats;
diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 49a6a9167af4..2d773e5e67f8 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -2361,14 +2361,12 @@ static const struct smsc911x_ops shifted_smsc911x_ops = {
 static int smsc911x_probe_config(struct smsc911x_platform_config *config,
 				 struct device *dev)
 {
-	int phy_interface;
 	u32 width = 0;
 	int err;
 
-	phy_interface = device_get_phy_mode(dev);
-	if (phy_interface < 0)
-		phy_interface = PHY_INTERFACE_MODE_NA;
-	config->phy_interface = phy_interface;
+	err = device_get_phy_mode(dev, &config->phy_interface);
+	if (err)
+		config->phy_interface = PHY_INTERFACE_MODE_NA;
 
 	device_get_mac_address(dev, config->mac, ETH_ALEN);
 
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index e8224b543dfc..95ff91230523 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1994,10 +1994,9 @@ static int netsec_probe(struct platform_device *pdev)
 	priv->msg_enable = NETIF_MSG_TX_ERR | NETIF_MSG_HW | NETIF_MSG_DRV |
 			   NETIF_MSG_LINK | NETIF_MSG_PROBE;
 
-	priv->phy_interface = device_get_phy_mode(&pdev->dev);
-	if ((int)priv->phy_interface < 0) {
+	ret = device_get_phy_mode(&pdev->dev, &priv->phy_interface);
+	if (ret) {
 		dev_err(&pdev->dev, "missing required property 'phy-mode'\n");
-		ret = -ENODEV;
 		goto free_ndev;
 	}
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index d10ac54bf385..aa77c332ea1d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -412,9 +412,9 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 		*mac = NULL;
 	}
 
-	plat->phy_interface = device_get_phy_mode(&pdev->dev);
-	if (plat->phy_interface < 0)
-		return ERR_PTR(plat->phy_interface);
+	rc = device_get_phy_mode(&pdev->dev, &plat->phy_interface);
+	if (rc)
+		return ERR_PTR(rc);
 
 	plat->interface = stmmac_of_get_mac_mode(np);
 	if (plat->interface < 0)
diff --git a/include/linux/property.h b/include/linux/property.h
index d86de017c689..2ffe9842c997 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -12,6 +12,7 @@
 
 #include <linux/bits.h>
 #include <linux/fwnode.h>
+#include <linux/phy.h>
 #include <linux/types.h>
 
 struct device;
@@ -368,7 +369,7 @@ enum dev_dma_attr device_get_dma_attr(struct device *dev);
 
 const void *device_get_match_data(struct device *dev);
 
-int device_get_phy_mode(struct device *dev);
+int device_get_phy_mode(struct device *dev, phy_interface_t *interface);
 
 void *device_get_mac_address(struct device *dev, char *addr, int alen);
 
-- 
2.11.0

