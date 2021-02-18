Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734BF31ED83
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbhBRRni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:43:38 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:54728 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbhBRQQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 11:16:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613664987; x=1645200987;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1nnvswdMGV7YOXxPq8283T4a69ySRCQHedAu3sGiWWw=;
  b=DgHVk1Uan47Al9APYoY7JVfxpPIJfsEMtA5hbVZkq48Rz5mmJEEYZ1TT
   vBLhhQp4D/AFkC2rP1NCoSlFe89YLFygz1M6ZhkZ47/ljK5AB5UMixqQQ
   HEqE0OJDO3krl1fo0SolsN/zSK4w3RhrDofOgJqewBYZVvVL8t+nYOfZu
   CeYbgFujtlkp5IQhjtGh/R/8x+r8pdVxyysK6Mhi9JIKu7Ladcnp/mHxg
   clpFtX9jULkB3W0oCZbanidAzhOayjepEB95hlh6W2dUyA6gsLDEkfm8t
   a8/QDmOGi7l+P7TQ1oojWz+jMNA8OkOcl3Iy0X2D8Tqw97VN3lMBt67Bw
   Q==;
IronPort-SDR: 9uOtFRu2J94JgqHfpqnq8NjimsOHE8GJxHDuJ2mZbda1u0BtOcJzfHblgkPp7YjzJ29MEMuHvR
 jNlzT0Ge8z7cKIPLPA99/5A2dTKs5DOWWcMHm8ESAhToAXqCQj5e567CVi1IWfk0zjX7wq22ya
 hKhEctCVjOweQwcb5tRhVLhdC7oozZX2kcYshDpkE+J2qyqlL+NDpM/MaVmt1507F160uHt6fA
 OlUobnlUnmNUfdEq44i2Wb+xphu2rDaY3pMaO1bGGHiLDbTYCLidT4E+BiD1KVuc5UdUPlisgP
 3Ig=
X-IronPort-AV: E=Sophos;i="5.81,187,1610434800"; 
   d="scan'208";a="115692358"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Feb 2021 09:15:04 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Feb 2021 09:15:04 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 18 Feb 2021 09:15:02 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v15 2/4] phy: Add media type and speed serdes configuration interfaces
Date:   Thu, 18 Feb 2021 17:14:49 +0100
Message-ID: <20210218161451.3489955-3-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210218161451.3489955-1-steen.hegelund@microchip.com>
References: <20210218161451.3489955-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide new phy configuration interfaces for media type and speed that
allows e.g. PHYs used for ethernet to be configured with this
information.

Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
 drivers/phy/phy-core.c  | 30 ++++++++++++++++++++++++++++++
 include/linux/phy/phy.h | 26 ++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 71cb10826326..ccb575b13777 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -373,6 +373,36 @@ int phy_set_mode_ext(struct phy *phy, enum phy_mode mode, int submode)
 }
 EXPORT_SYMBOL_GPL(phy_set_mode_ext);
 
+int phy_set_media(struct phy *phy, enum phy_media media)
+{
+	int ret;
+
+	if (!phy || !phy->ops->set_media)
+		return 0;
+
+	mutex_lock(&phy->mutex);
+	ret = phy->ops->set_media(phy, media);
+	mutex_unlock(&phy->mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_set_media);
+
+int phy_set_speed(struct phy *phy, int speed)
+{
+	int ret;
+
+	if (!phy || !phy->ops->set_speed)
+		return 0;
+
+	mutex_lock(&phy->mutex);
+	ret = phy->ops->set_speed(phy, speed);
+	mutex_unlock(&phy->mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_set_speed);
+
 int phy_reset(struct phy *phy)
 {
 	int ret;
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index e435bdb0bab3..0ed434d02196 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -44,6 +44,12 @@ enum phy_mode {
 	PHY_MODE_DP
 };
 
+enum phy_media {
+	PHY_MEDIA_DEFAULT,
+	PHY_MEDIA_SR,
+	PHY_MEDIA_DAC,
+};
+
 /**
  * union phy_configure_opts - Opaque generic phy configuration
  *
@@ -64,6 +70,8 @@ union phy_configure_opts {
  * @power_on: powering on the phy
  * @power_off: powering off the phy
  * @set_mode: set the mode of the phy
+ * @set_media: set the media type of the phy (optional)
+ * @set_speed: set the speed of the phy (optional)
  * @reset: resetting the phy
  * @calibrate: calibrate the phy
  * @release: ops to be performed while the consumer relinquishes the PHY
@@ -75,6 +83,8 @@ struct phy_ops {
 	int	(*power_on)(struct phy *phy);
 	int	(*power_off)(struct phy *phy);
 	int	(*set_mode)(struct phy *phy, enum phy_mode mode, int submode);
+	int	(*set_media)(struct phy *phy, enum phy_media media);
+	int	(*set_speed)(struct phy *phy, int speed);
 
 	/**
 	 * @configure:
@@ -215,6 +225,8 @@ int phy_power_off(struct phy *phy);
 int phy_set_mode_ext(struct phy *phy, enum phy_mode mode, int submode);
 #define phy_set_mode(phy, mode) \
 	phy_set_mode_ext(phy, mode, 0)
+int phy_set_media(struct phy *phy, enum phy_media media);
+int phy_set_speed(struct phy *phy, int speed);
 int phy_configure(struct phy *phy, union phy_configure_opts *opts);
 int phy_validate(struct phy *phy, enum phy_mode mode, int submode,
 		 union phy_configure_opts *opts);
@@ -344,6 +356,20 @@ static inline int phy_set_mode_ext(struct phy *phy, enum phy_mode mode,
 #define phy_set_mode(phy, mode) \
 	phy_set_mode_ext(phy, mode, 0)
 
+static inline int phy_set_media(struct phy *phy, enum phy_media media)
+{
+	if (!phy)
+		return 0;
+	return -ENODEV;
+}
+
+static inline int phy_set_speed(struct phy *phy, int speed)
+{
+	if (!phy)
+		return 0;
+	return -ENODEV;
+}
+
 static inline enum phy_mode phy_get_mode(struct phy *phy)
 {
 	return PHY_MODE_INVALID;
-- 
2.30.0

