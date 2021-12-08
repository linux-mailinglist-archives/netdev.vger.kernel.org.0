Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF12446CCA7
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 05:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235223AbhLHErG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 23:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244269AbhLHErE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 23:47:04 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22952C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 20:43:33 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so1132194pjb.5
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 20:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=esZdvZ1lG4icPms3sYFTZWvT0KVztGqPQXvHysWfHsY=;
        b=Ijm7pv4uxRTOO23oqskNvug9EiH2GIp3/u8j+F/P8hr2RL9o3YBStajpnYGMx2N2Ui
         8UZdzZzEIFU3QvsNrOq53S0T3Ua6+wkXsQ94z+DzJJCTiblLMfF9ePoKUCkD+2mmxKXq
         imvSZZO72qmLqdslYvxcGUeMZlCTfHERRBXcZZPud/e6ctfVYFaj6i1jH2SQK9pfts6Q
         oCc9lB5ZePOnR7NHmhaMHiaqcxXm5Z7pvLWdzhP0RtUccFd4A0rfqvLluH6ELbnj7VuM
         0XpFwNV/Kft1MjzcmN9TIRXLiuAsRnmzWOAw709wTM/vVIdtvtEG3qPefEhNGZfZ8J/D
         9LIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=esZdvZ1lG4icPms3sYFTZWvT0KVztGqPQXvHysWfHsY=;
        b=6IV6fGBfofXKLLgWfIo0iidGOJb/nnqJSFxIQK5SNuqIUt4vZN99Mx7KT+IpN5oqRk
         ZxY3PteH1+5MJITbLR8Ev4Y3aeIfo/kt07DRn/GbzCRU933zubA7qmBGISX0qRX9Dtk5
         fks9MCjx7ZTvKzVyn5IicwRKuLuBsnrPZ3IHGabPX9QXT9WNO5e7cQXR7xH25Fjmh2UX
         Aq74AUNQI0RrHWP7AGXLLhbnSOnwBlhy8Lfs+gb5+agPQA1MvFYwueHptC5n1LhAr+Hz
         JxV7bi+L8UFsAq2KFSs/HFUdFCYDzdB42CMExAB7aDLWWMPq64XTcL3lCdFOZpblYS/+
         baBg==
X-Gm-Message-State: AOAM533mcIxWRqbQWD7409sHr2sYhoVFHMffub/PQbeu7HyNBGFf7Uns
        wEPcY/xFhfGtmgqxz2FVWZ3lXMmXgUQ=
X-Google-Smtp-Source: ABdhPJz6giSiVCH4jA1B5rZc4DkYIP7pYcIgIo8vNL1Hni6Gxwil1e9kbRXFVnZ0u2SV/k51D8uYrQ==
X-Received: by 2002:a17:90b:1892:: with SMTP id mn18mr4325687pjb.178.1638938611947;
        Tue, 07 Dec 2021 20:43:31 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u12sm1491631pfk.71.2021.12.07.20.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 20:43:31 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next 1/2] net_tstamp: add new flag HWTSTAMP_FLAGS_UNSTABLE_PHC
Date:   Wed,  8 Dec 2021 12:42:23 +0800
Message-Id: <20211208044224.1950323-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211208044224.1950323-1-liuhangbin@gmail.com>
References: <20211208044224.1950323-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 94dd016ae538 ("bond: pass get_ts_info and SIOC[SG]HWTSTAMP
ioctl to active device") the user could get bond active interface's
PHC index directly. But when there is a failover, the bond active
interface will change, thus the PHC index is also changed. This may
break the user's program if they did not update the PHC timely.

This patch adds a new hwtstamp_config flag HWTSTAMP_FLAGS_UNSTABLE_PHC.
When the user wants to use get unstable PHC index, like bond active
interface's PHC, they need to add this flag and be aware the PHC index may
be changed.

With the new flag. All flag checks in current drivers need to be removed.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c   |  4 ----
 drivers/net/dsa/mv88e6xxx/hwtstamp.c              |  4 ----
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c          |  3 ---
 drivers/net/ethernet/aquantia/atlantic/aq_main.c  |  3 ---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  5 -----
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c     |  3 ---
 drivers/net/ethernet/broadcom/tg3.c               |  3 ---
 drivers/net/ethernet/cadence/macb_ptp.c           |  4 ----
 drivers/net/ethernet/cavium/liquidio/lio_main.c   |  3 ---
 .../net/ethernet/cavium/liquidio/lio_vf_main.c    |  3 ---
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c  |  3 ---
 drivers/net/ethernet/cavium/thunder/nicvf_main.c  |  4 ----
 drivers/net/ethernet/engleder/tsnep_ptp.c         |  3 ---
 drivers/net/ethernet/freescale/fec_ptp.c          |  4 ----
 drivers/net/ethernet/freescale/gianfar.c          |  4 ----
 drivers/net/ethernet/intel/e1000e/netdev.c        |  4 ----
 drivers/net/ethernet/intel/i40e/i40e_ptp.c        |  4 ----
 drivers/net/ethernet/intel/ice/ice_ptp.c          |  4 ----
 drivers/net/ethernet/intel/igb/igb_ptp.c          |  4 ----
 drivers/net/ethernet/intel/igc/igc_ptp.c          |  4 ----
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c      |  4 ----
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c   |  3 ---
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c  |  4 ----
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c    |  4 ----
 drivers/net/ethernet/microchip/lan743x_ptp.c      |  6 ------
 drivers/net/ethernet/mscc/ocelot.c                |  4 ----
 drivers/net/ethernet/neterion/vxge/vxge-main.c    |  4 ----
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |  3 ---
 drivers/net/ethernet/qlogic/qede/qede_ptp.c       |  5 -----
 drivers/net/ethernet/renesas/ravb_main.c          |  4 ----
 drivers/net/ethernet/sfc/ptp.c                    |  3 ---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  4 ----
 drivers/net/ethernet/ti/cpsw_priv.c               |  4 ----
 drivers/net/ethernet/ti/netcp_ethss.c             |  4 ----
 drivers/net/ethernet/xscale/ixp4xx_eth.c          |  3 ---
 drivers/net/phy/dp83640.c                         |  3 ---
 drivers/net/phy/mscc/mscc_ptp.c                   |  3 ---
 drivers/ptp/ptp_ines.c                            |  4 ----
 include/uapi/linux/net_tstamp.h                   | 15 ++++++++++++++-
 net/core/dev_ioctl.c                              |  3 ---
 40 files changed, 14 insertions(+), 146 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
index 40b41c794dfa..b3bc948d6145 100644
--- a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
+++ b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
@@ -52,10 +52,6 @@ static int hellcreek_set_hwtstamp_config(struct hellcreek *hellcreek, int port,
 	 */
 	clear_bit_unlock(HELLCREEK_HWTSTAMP_ENABLED, &ps->state);
 
-	/* Reserved for future extensions */
-	if (config->flags)
-		return -EINVAL;
-
 	switch (config->tx_type) {
 	case HWTSTAMP_TX_ON:
 		tx_tstamp_enable = true;
diff --git a/drivers/net/dsa/mv88e6xxx/hwtstamp.c b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
index 8f74ffc7a279..389f8a6ec0ab 100644
--- a/drivers/net/dsa/mv88e6xxx/hwtstamp.c
+++ b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
@@ -100,10 +100,6 @@ static int mv88e6xxx_set_hwtstamp_config(struct mv88e6xxx_chip *chip, int port,
 	 */
 	clear_bit_unlock(MV88E6XXX_HWTSTAMP_ENABLED, &ps->state);
 
-	/* reserved for future extensions */
-	if (config->flags)
-		return -EINVAL;
-
 	switch (config->tx_type) {
 	case HWTSTAMP_TX_OFF:
 		tstamp_enable = false;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 30d24d19f40d..492ac383f16d 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1508,9 +1508,6 @@ static int xgbe_set_hwtstamp_settings(struct xgbe_prv_data *pdata,
 	if (copy_from_user(&config, ifreq->ifr_data, sizeof(config)))
 		return -EFAULT;
 
-	if (config.flags)
-		return -EINVAL;
-
 	mac_tscr = 0;
 
 	switch (config.tx_type) {
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index e22935ce9573..e65ce7199dac 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -231,9 +231,6 @@ static void aq_ndev_set_multicast_settings(struct net_device *ndev)
 static int aq_ndev_config_hwtstamp(struct aq_nic_s *aq_nic,
 				   struct hwtstamp_config *config)
 {
-	if (config->flags)
-		return -EINVAL;
-
 	switch (config->tx_type) {
 	case HWTSTAMP_TX_OFF:
 	case HWTSTAMP_TX_ON:
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index aec666e97683..651bc1d7a57a 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -15356,11 +15356,6 @@ static int bnx2x_hwtstamp_ioctl(struct bnx2x *bp, struct ifreq *ifr)
 	DP(BNX2X_MSG_PTP, "Requested tx_type: %d, requested rx_filters = %d\n",
 	   config.tx_type, config.rx_filter);
 
-	if (config.flags) {
-		BNX2X_ERR("config.flags is reserved for future use\n");
-		return -EINVAL;
-	}
-
 	bp->hwtstamp_ioctl_called = true;
 	bp->tx_type = config.tx_type;
 	bp->rx_filter = config.rx_filter;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 8388be119f9a..48520967746f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -417,9 +417,6 @@ int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 	if (copy_from_user(&stmpconf, ifr->ifr_data, sizeof(stmpconf)))
 		return -EFAULT;
 
-	if (stmpconf.flags)
-		return -EINVAL;
-
 	if (stmpconf.tx_type != HWTSTAMP_TX_ON &&
 	    stmpconf.tx_type != HWTSTAMP_TX_OFF)
 		return -ERANGE;
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 283f3c1f1195..c28f8cc00d1c 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -13806,9 +13806,6 @@ static int tg3_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 	if (copy_from_user(&stmpconf, ifr->ifr_data, sizeof(stmpconf)))
 		return -EFAULT;
 
-	if (stmpconf.flags)
-		return -EINVAL;
-
 	if (stmpconf.tx_type != HWTSTAMP_TX_ON &&
 	    stmpconf.tx_type != HWTSTAMP_TX_OFF)
 		return -ERANGE;
diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index 095c5a2144a7..fb6b27f46b15 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -464,10 +464,6 @@ int gem_set_hwtst(struct net_device *dev, struct ifreq *ifr, int cmd)
 			   sizeof(*tstamp_config)))
 		return -EFAULT;
 
-	/* reserved for future extensions */
-	if (tstamp_config->flags)
-		return -EINVAL;
-
 	switch (tstamp_config->tx_type) {
 	case HWTSTAMP_TX_OFF:
 		break;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 12eee2bc7f5c..ba28aa444e5a 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -2114,9 +2114,6 @@ static int hwtstamp_ioctl(struct net_device *netdev, struct ifreq *ifr)
 	if (copy_from_user(&conf, ifr->ifr_data, sizeof(conf)))
 		return -EFAULT;
 
-	if (conf.flags)
-		return -EINVAL;
-
 	switch (conf.tx_type) {
 	case HWTSTAMP_TX_ON:
 	case HWTSTAMP_TX_OFF:
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index c607756b731f..568f211d91cc 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1254,9 +1254,6 @@ static int hwtstamp_ioctl(struct net_device *netdev, struct ifreq *ifr)
 	if (copy_from_user(&conf, ifr->ifr_data, sizeof(conf)))
 		return -EFAULT;
 
-	if (conf.flags)
-		return -EINVAL;
-
 	switch (conf.tx_type) {
 	case HWTSTAMP_TX_ON:
 	case HWTSTAMP_TX_OFF:
diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index 4b4ffdd1044d..103591dcea1c 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -702,9 +702,6 @@ static int octeon_mgmt_ioctl_hwtstamp(struct net_device *netdev,
 	if (copy_from_user(&config, rq->ifr_data, sizeof(config)))
 		return -EFAULT;
 
-	if (config.flags) /* reserved for future extensions */
-		return -EINVAL;
-
 	/* Check the status of hardware for tiemstamps */
 	if (OCTEON_IS_MODEL(OCTEON_CN6XXX)) {
 		/* Get the current state of the PTP clock */
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index bb45d5df2856..63191692f624 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1917,10 +1917,6 @@ static int nicvf_config_hwtstamp(struct net_device *netdev, struct ifreq *ifr)
 	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
 		return -EFAULT;
 
-	/* reserved for future extensions */
-	if (config.flags)
-		return -EINVAL;
-
 	switch (config.tx_type) {
 	case HWTSTAMP_TX_OFF:
 	case HWTSTAMP_TX_ON:
diff --git a/drivers/net/ethernet/engleder/tsnep_ptp.c b/drivers/net/ethernet/engleder/tsnep_ptp.c
index 4bfb4d8508f5..eaad453d487e 100644
--- a/drivers/net/ethernet/engleder/tsnep_ptp.c
+++ b/drivers/net/ethernet/engleder/tsnep_ptp.c
@@ -31,9 +31,6 @@ int tsnep_ptp_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 		if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
 			return -EFAULT;
 
-		if (config.flags)
-			return -EINVAL;
-
 		switch (config.tx_type) {
 		case HWTSTAMP_TX_OFF:
 		case HWTSTAMP_TX_ON:
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index d71eac7e1924..af99017a5453 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -473,10 +473,6 @@ int fec_ptp_set(struct net_device *ndev, struct ifreq *ifr)
 	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
 		return -EFAULT;
 
-	/* reserved for future extensions */
-	if (config.flags)
-		return -EINVAL;
-
 	switch (config.tx_type) {
 	case HWTSTAMP_TX_OFF:
 		fep->hwts_tx_en = 0;
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index acab58fd3db3..206b7a35eaf5 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -2076,10 +2076,6 @@ static int gfar_hwtstamp_set(struct net_device *netdev, struct ifreq *ifr)
 	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
 		return -EFAULT;
 
-	/* reserved for future extensions */
-	if (config.flags)
-		return -EINVAL;
-
 	switch (config.tx_type) {
 	case HWTSTAMP_TX_OFF:
 		priv->hwts_tx_en = 0;
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 44e2dc8328a2..635a95927e93 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -3614,10 +3614,6 @@ static int e1000e_config_hwtstamp(struct e1000_adapter *adapter,
 	if (!(adapter->flags & FLAG_HAS_HW_TIMESTAMP))
 		return -EINVAL;
 
-	/* flags reserved for future extensions - must be zero */
-	if (config->flags)
-		return -EINVAL;
-
 	switch (config->tx_type) {
 	case HWTSTAMP_TX_OFF:
 		tsync_tx_ctl = 0;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
index 09b1d5aed1c9..61e5789d78db 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -1205,10 +1205,6 @@ static int i40e_ptp_set_timestamp_mode(struct i40e_pf *pf,
 
 	INIT_WORK(&pf->ptp_extts0_work, i40e_ptp_extts0_work);
 
-	/* Reserved for future extensions. */
-	if (config->flags)
-		return -EINVAL;
-
 	switch (config->tx_type) {
 	case HWTSTAMP_TX_OFF:
 		pf->ptp_tx = false;
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index bf7247c6f58e..dfc7c830acf6 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1205,10 +1205,6 @@ int ice_ptp_get_ts_config(struct ice_pf *pf, struct ifreq *ifr)
 static int
 ice_ptp_set_timestamp_mode(struct ice_pf *pf, struct hwtstamp_config *config)
 {
-	/* Reserved for future extensions. */
-	if (config->flags)
-		return -EINVAL;
-
 	switch (config->tx_type) {
 	case HWTSTAMP_TX_OFF:
 		ice_set_tx_tstamp(pf, false);
diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 0011b15e678c..0ac4cc5eaa2d 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -1015,10 +1015,6 @@ static int igb_ptp_set_timestamp_mode(struct igb_adapter *adapter,
 	bool is_l2 = false;
 	u32 regval;
 
-	/* reserved for future extensions */
-	if (config->flags)
-		return -EINVAL;
-
 	switch (config->tx_type) {
 	case HWTSTAMP_TX_OFF:
 		tsync_tx_ctl = 0;
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 30568e3544cd..71813fa8f928 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -560,10 +560,6 @@ static void igc_ptp_enable_tx_timestamp(struct igc_adapter *adapter)
 static int igc_ptp_set_timestamp_mode(struct igc_adapter *adapter,
 				      struct hwtstamp_config *config)
 {
-	/* reserved for future extensions */
-	if (config->flags)
-		return -EINVAL;
-
 	switch (config->tx_type) {
 	case HWTSTAMP_TX_OFF:
 		igc_ptp_disable_tx_timestamp(adapter);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
index 23ddfd79fc8b..336426a67ac1 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
@@ -992,10 +992,6 @@ static int ixgbe_ptp_set_timestamp_mode(struct ixgbe_adapter *adapter,
 	bool is_l2 = false;
 	u32 regval;
 
-	/* reserved for future extensions */
-	if (config->flags)
-		return -EINVAL;
-
 	switch (config->tx_type) {
 	case HWTSTAMP_TX_OFF:
 		tsync_tx_ctl = 0;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 252e215a14f1..03f4a1b1f2a4 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5142,9 +5142,6 @@ static int mvpp2_set_ts_config(struct mvpp2_port *port, struct ifreq *ifr)
 	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
 		return -EFAULT;
 
-	if (config.flags)
-		return -EINVAL;
-
 	if (config.tx_type != HWTSTAMP_TX_OFF &&
 	    config.tx_type != HWTSTAMP_TX_ON)
 		return -ERANGE;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 1333edf1c361..6080ebd9bd94 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2002,10 +2002,6 @@ int otx2_config_hwtstamp(struct net_device *netdev, struct ifreq *ifr)
 	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
 		return -EFAULT;
 
-	/* reserved for future extensions */
-	if (config.flags)
-		return -EINVAL;
-
 	switch (config.tx_type) {
 	case HWTSTAMP_TX_OFF:
 		otx2_config_hw_tx_tstamp(pfvf, false);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index f1c10f2bda78..ad1e4caf48bf 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2427,10 +2427,6 @@ static int mlx4_en_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
 		return -EFAULT;
 
-	/* reserved for future extensions */
-	if (config.flags)
-		return -EINVAL;
-
 	/* device doesn't support time stamping */
 	if (!(mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_TS))
 		return -EINVAL;
diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
index 9380e396f648..8b7a8d879083 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -1305,12 +1305,6 @@ int lan743x_ptp_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
 		return -EFAULT;
 
-	if (config.flags) {
-		netif_warn(adapter, drv, adapter->netdev,
-			   "ignoring hwtstamp_config.flags == 0x%08X, expected 0\n",
-			   config.flags);
-	}
-
 	switch (config.tx_type) {
 	case HWTSTAMP_TX_OFF:
 		for (index = 0; index < LAN743X_MAX_TX_CHANNELS;
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b1856d8c944b..0be74c823d5e 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1602,10 +1602,6 @@ int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr)
 	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
 		return -EFAULT;
 
-	/* reserved for future extensions */
-	if (cfg.flags)
-		return -EINVAL;
-
 	/* Tx type sanity check */
 	switch (cfg.tx_type) {
 	case HWTSTAMP_TX_ON:
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 1969009a91e7..2c2e9e56ed4e 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -3159,10 +3159,6 @@ static int vxge_hwtstamp_set(struct vxgedev *vdev, void __user *data)
 	if (copy_from_user(&config, data, sizeof(config)))
 		return -EFAULT;
 
-	/* reserved for future extensions */
-	if (config.flags)
-		return -EINVAL;
-
 	/* Transmit HW Timestamp not supported */
 	switch (config.tx_type) {
 	case HWTSTAMP_TX_OFF:
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 71d234291fc5..1dc40c537281 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -210,9 +210,6 @@ static int hwtstamp_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
 		return -EFAULT;
 
-	if (cfg.flags) /* reserved for future extensions */
-		return -EINVAL;
-
 	/* Get ieee1588's dev information */
 	pdev = adapter->ptp_pdev;
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ptp.c b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
index 8c28fabb0ff6..39176e765767 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ptp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
@@ -304,11 +304,6 @@ int qede_ptp_hw_ts(struct qede_dev *edev, struct ifreq *ifr)
 		   "HWTSTAMP IOCTL: Requested tx_type = %d, requested rx_filters = %d\n",
 		   config.tx_type, config.rx_filter);
 
-	if (config.flags) {
-		DP_ERR(edev, "config.flags is reserved for future use\n");
-		return -EINVAL;
-	}
-
 	ptp->hw_ts_ioctl_called = 1;
 	ptp->tx_type = config.tx_type;
 	ptp->rx_filter = config.rx_filter;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index ce09bd45527e..b215cde68e10 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2221,10 +2221,6 @@ static int ravb_hwtstamp_set(struct net_device *ndev, struct ifreq *req)
 	if (copy_from_user(&config, req->ifr_data, sizeof(config)))
 		return -EFAULT;
 
-	/* Reserved for future extensions */
-	if (config.flags)
-		return -EINVAL;
-
 	switch (config.tx_type) {
 	case HWTSTAMP_TX_OFF:
 		tstamp_tx_ctrl = 0;
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 797e51802ccb..f0ef515e2ade 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1765,9 +1765,6 @@ static int efx_ptp_ts_init(struct efx_nic *efx, struct hwtstamp_config *init)
 {
 	int rc;
 
-	if (init->flags)
-		return -EINVAL;
-
 	if ((init->tx_type != HWTSTAMP_TX_OFF) &&
 	    (init->tx_type != HWTSTAMP_TX_ON))
 		return -ERANGE;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4e05c1d92935..e4d2748592ee 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -636,10 +636,6 @@ static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 	netdev_dbg(priv->dev, "%s config flags:0x%x, tx_type:0x%x, rx_filter:0x%x\n",
 		   __func__, config.flags, config.tx_type, config.rx_filter);
 
-	/* reserved for future extensions */
-	if (config.flags)
-		return -EINVAL;
-
 	if (config.tx_type != HWTSTAMP_TX_OFF &&
 	    config.tx_type != HWTSTAMP_TX_ON)
 		return -ERANGE;
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index c99dd9735087..8624a044776f 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -626,10 +626,6 @@ static int cpsw_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
 		return -EFAULT;
 
-	/* reserved for future extensions */
-	if (cfg.flags)
-		return -EINVAL;
-
 	if (cfg.tx_type != HWTSTAMP_TX_OFF && cfg.tx_type != HWTSTAMP_TX_ON)
 		return -ERANGE;
 
diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/ti/netcp_ethss.c
index 33c1592d5381..751fb0bc65c5 100644
--- a/drivers/net/ethernet/ti/netcp_ethss.c
+++ b/drivers/net/ethernet/ti/netcp_ethss.c
@@ -2654,10 +2654,6 @@ static int gbe_hwtstamp_set(struct gbe_intf *gbe_intf, struct ifreq *ifr)
 	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
 		return -EFAULT;
 
-	/* reserved for future extensions */
-	if (cfg.flags)
-		return -EINVAL;
-
 	switch (cfg.tx_type) {
 	case HWTSTAMP_TX_OFF:
 		gbe_dev->tx_ts_enabled = 0;
diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 65fdad1107fc..df77a22d1b81 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -382,9 +382,6 @@ static int hwtstamp_set(struct net_device *netdev, struct ifreq *ifr)
 	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
 		return -EFAULT;
 
-	if (cfg.flags) /* reserved for future extensions */
-		return -EINVAL;
-
 	ret = ixp46x_ptp_find(&port->timesync_regs, &port->phc_index);
 	if (ret)
 		return ret;
diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 705c16675b80..c2d1a85ec559 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -1235,9 +1235,6 @@ static int dp83640_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
 	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
 		return -EFAULT;
 
-	if (cfg.flags) /* reserved for future extensions */
-		return -EINVAL;
-
 	if (cfg.tx_type < 0 || cfg.tx_type > HWTSTAMP_TX_ONESTEP_SYNC)
 		return -ERANGE;
 
diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_ptp.c
index edb951695b13..34f829845d06 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -1057,9 +1057,6 @@ static int vsc85xx_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
 	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
 		return -EFAULT;
 
-	if (cfg.flags)
-		return -EINVAL;
-
 	switch (cfg.tx_type) {
 	case HWTSTAMP_TX_ONESTEP_SYNC:
 		one_step = true;
diff --git a/drivers/ptp/ptp_ines.c b/drivers/ptp/ptp_ines.c
index 6c7c2843ba0b..61f47fb9d997 100644
--- a/drivers/ptp/ptp_ines.c
+++ b/drivers/ptp/ptp_ines.c
@@ -338,10 +338,6 @@ static int ines_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
 	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
 		return -EFAULT;
 
-	/* reserved for future extensions */
-	if (cfg.flags)
-		return -EINVAL;
-
 	switch (cfg.tx_type) {
 	case HWTSTAMP_TX_OFF:
 		ts_stat_tx = 0;
diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
index fcc61c73a666..d3aaab8396ef 100644
--- a/include/uapi/linux/net_tstamp.h
+++ b/include/uapi/linux/net_tstamp.h
@@ -62,7 +62,7 @@ struct so_timestamping {
 /**
  * struct hwtstamp_config - %SIOCGHWTSTAMP and %SIOCSHWTSTAMP parameter
  *
- * @flags:	no flags defined right now, must be zero for %SIOCSHWTSTAMP
+ * @flags:	one of HWTSTAMP_FLAGS_*
  * @tx_type:	one of HWTSTAMP_TX_*
  * @rx_filter:	one of HWTSTAMP_FILTER_*
  *
@@ -78,6 +78,19 @@ struct hwtstamp_config {
 	int rx_filter;
 };
 
+/* possible values for hwtstamp_config->flags */
+enum hwtstamp_flags {
+	/*
+	 * With this flag the user should aware that the PHC index
+	 * get/set by syscall is not stable. e.g. the phc index of
+	 * bond active interface may changed after failover.
+	 */
+	HWTSTAMP_FLAGS_UNSTABLE_PHC = (1<<0),
+
+	/* add new constants above here */
+	__HWTSTAMP_FLAGS_CNT
+};
+
 /* possible values for hwtstamp_config->tx_type */
 enum hwtstamp_tx_types {
 	/*
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 1d309a666932..a81c98cfc3db 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -192,9 +192,6 @@ static int net_hwtstamp_validate(struct ifreq *ifr)
 	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
 		return -EFAULT;
 
-	if (cfg.flags) /* reserved for future extensions */
-		return -EINVAL;
-
 	tx_type = cfg.tx_type;
 	rx_filter = cfg.rx_filter;
 
-- 
2.31.1

