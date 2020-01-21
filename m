Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 200C314463A
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 22:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgAUVFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 16:05:44 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46178 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728748AbgAUVFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 16:05:43 -0500
Received: by mail-wr1-f67.google.com with SMTP id z7so4877413wrl.13
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 13:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=1a7whNnLjAyW18taQMHtOBMrMabH2Uq8ppBihrFjtGg=;
        b=nuNKSjZF9qfsYAeW0QeuE6bLv+BsaLi19xD+QfEZf3NYDUoeAlr6Vb1VXE+7yqHP5e
         MMfAYo44j/IwEa/atg7oImPfDJ6Z0coN/e+TnDX+A2OMba3ZiUKLLSVe/GGkBlsSAE5V
         ne2B5aXGlZ1je7lX8Cp/XwEKqAbch1qXoOJ2VaifJ7p1SOr/NhUcdnT25foDzW2fuHP/
         wCG1UJJiDHPNmlDYLAJ/FLwb9zROLAGg7sXSXVs8IJVDcLBrzIrD/JF4w9d1DHFtbxE9
         5W6Fe4CUcTY7acz+U316jRdSbU19gQOR/lpHBqACFXEPcDVmRsKukYUD6wo4DiOS7t34
         MXEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=1a7whNnLjAyW18taQMHtOBMrMabH2Uq8ppBihrFjtGg=;
        b=M0qR+YV+p2w1+lW2Tdvz703OpAWXzz8njC9dx7vKiAuprEs1twb+ZkYaL5zxZF6we3
         OTh7iJtnNJ3edOuG2XgcYwQWCmYhjrGupEkXaOI8BKmMmwXQ+EjPnfYbnMQ6n0M/e+QF
         JulYSge805qOhNWKaVzoo9o5M5J9Xtfl4V99ISGdAnfhAdeaYmKaxUeV27lfGCvkBXVz
         LARTa1VeHHNYjz8AlW6WVAh0WcBqNlWDMCTX7Rl49Clc70A8M4YtEQqsiOIFdiMJMJIU
         PRmMCkmhs5P9zbqb1a21kyVDCaRB2WZDY/AMuZvHV6PuWG0BR6wWN4GjVyQbJZCeUmkD
         uCYw==
X-Gm-Message-State: APjAAAVeSwlN78UvzvJ1pZy+SID6dyyEY8UN7k2kL0B2qdUWRXb2egIc
        SMUGZvhJ4n8iCygUZyn/sLVXmNkN
X-Google-Smtp-Source: APXvYqwGw783urdTm8ISQA2nK66ptg0o91EavYm7/IJ1fNB02M0sJ8njAM+Zit2m9GVVhbbjTUYJSw==
X-Received: by 2002:adf:ff84:: with SMTP id j4mr7177275wrr.27.1579640740355;
        Tue, 21 Jan 2020 13:05:40 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id u7sm861301wmj.3.2020.01.21.13.05.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 13:05:39 -0800 (PST)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Byungho An <bh74.an@samsung.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: convert additional drivers to use phy_do_ioctl
Message-ID: <cc7396fa-81c6-6a13-0e94-9ac2ca2cab08@gmail.com>
Date:   Tue, 21 Jan 2020 22:05:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first batch of driver conversions missed a few cases where we can
use phy_do_ioctl too.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/aurora/nb8800.c             |  7 +------
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c |  4 +---
 drivers/net/ethernet/lantiq_etop.c               |  9 +--------
 drivers/net/ethernet/marvell/pxa168_eth.c        | 11 +----------
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c  |  4 +---
 drivers/net/ethernet/socionext/netsec.c          |  8 +-------
 6 files changed, 6 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/aurora/nb8800.c b/drivers/net/ethernet/aurora/nb8800.c
index 30b455013..bc273e0db 100644
--- a/drivers/net/ethernet/aurora/nb8800.c
+++ b/drivers/net/ethernet/aurora/nb8800.c
@@ -1005,18 +1005,13 @@ static int nb8800_stop(struct net_device *dev)
 	return 0;
 }
 
-static int nb8800_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
-{
-	return phy_mii_ioctl(dev->phydev, rq, cmd);
-}
-
 static const struct net_device_ops nb8800_netdev_ops = {
 	.ndo_open		= nb8800_open,
 	.ndo_stop		= nb8800_stop,
 	.ndo_start_xmit		= nb8800_xmit,
 	.ndo_set_mac_address	= nb8800_set_mac_address,
 	.ndo_set_rx_mode	= nb8800_set_rx_mode,
-	.ndo_do_ioctl		= nb8800_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index cdd7e5da4..e9575887a 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -790,9 +790,7 @@ static int octeon_mgmt_ioctl(struct net_device *netdev,
 	case SIOCSHWTSTAMP:
 		return octeon_mgmt_ioctl_hwtstamp(netdev, rq, cmd);
 	default:
-		if (netdev->phydev)
-			return phy_mii_ioctl(netdev->phydev, rq, cmd);
-		return -EINVAL;
+		return phy_do_ioctl(netdev, rq, cmd);
 	}
 }
 
diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 1e165ba31..2d0c52f71 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -509,13 +509,6 @@ ltq_etop_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
-static int
-ltq_etop_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
-{
-	/* TODO: mii-toll reports "No MII transceiver present!." ?!*/
-	return phy_mii_ioctl(dev->phydev, rq, cmd);
-}
-
 static int
 ltq_etop_set_mac_address(struct net_device *dev, void *p)
 {
@@ -616,7 +609,7 @@ static const struct net_device_ops ltq_eth_netdev_ops = {
 	.ndo_stop = ltq_etop_stop,
 	.ndo_start_xmit = ltq_etop_tx,
 	.ndo_change_mtu = ltq_etop_change_mtu,
-	.ndo_do_ioctl = ltq_etop_ioctl,
+	.ndo_do_ioctl = phy_do_ioctl,
 	.ndo_set_mac_address = ltq_etop_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
 	.ndo_set_rx_mode = ltq_etop_set_multicast_list,
diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 1a6877902..7a0d785b8 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1344,15 +1344,6 @@ static int pxa168_smi_write(struct mii_bus *bus, int phy_addr, int regnum,
 	return 0;
 }
 
-static int pxa168_eth_do_ioctl(struct net_device *dev, struct ifreq *ifr,
-			       int cmd)
-{
-	if (dev->phydev)
-		return phy_mii_ioctl(dev->phydev, ifr, cmd);
-
-	return -EOPNOTSUPP;
-}
-
 #ifdef CONFIG_NET_POLL_CONTROLLER
 static void pxa168_eth_netpoll(struct net_device *dev)
 {
@@ -1387,7 +1378,7 @@ static const struct net_device_ops pxa168_eth_netdev_ops = {
 	.ndo_set_rx_mode	= pxa168_eth_set_rx_mode,
 	.ndo_set_mac_address	= pxa168_eth_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= pxa168_eth_do_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl,
 	.ndo_change_mtu		= pxa168_eth_change_mtu,
 	.ndo_tx_timeout		= pxa168_eth_tx_timeout,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 7d3a1c0df..c705743d6 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -1939,9 +1939,7 @@ static int sxgbe_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	case SIOCGMIIPHY:
 	case SIOCGMIIREG:
 	case SIOCSMIIREG:
-		if (!dev->phydev)
-			return -EINVAL;
-		ret = phy_mii_ioctl(dev->phydev, rq, cmd);
+		ret = phy_do_ioctl(dev, rq, cmd);
 		break;
 	default:
 		break;
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 6870a6ce7..495f6cfdb 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1740,12 +1740,6 @@ static int netsec_netdev_set_features(struct net_device *ndev,
 	return 0;
 }
 
-static int netsec_netdev_ioctl(struct net_device *ndev, struct ifreq *ifr,
-			       int cmd)
-{
-	return phy_mii_ioctl(ndev->phydev, ifr, cmd);
-}
-
 static int netsec_xdp_xmit(struct net_device *ndev, int n,
 			   struct xdp_frame **frames, u32 flags)
 {
@@ -1830,7 +1824,7 @@ static const struct net_device_ops netsec_netdev_ops = {
 	.ndo_set_features	= netsec_netdev_set_features,
 	.ndo_set_mac_address    = eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= netsec_netdev_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl,
 	.ndo_xdp_xmit		= netsec_xdp_xmit,
 	.ndo_bpf		= netsec_xdp,
 };
-- 
2.25.0

