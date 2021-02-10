Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A4931619C
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 09:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhBJI5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 03:57:50 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:51205 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhBJIyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 03:54:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612947264; x=1644483264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wWrcWzYHT/+HXPulQO8+35r8GPSI1mInaaUPzsCjy7I=;
  b=g9XqqFceGHNmmhs7KlLi4i0kILYe7I6t1ts4VJoyko9hyz0j+d/ym3VE
   9t4peFLE0nJK/u6SZUleLApClaXdgC2Q0frA+9/kLMthntwZYuTghqjFn
   vBUwoLxjRyUVfl+zh+UG+0943dDXJgsK3PZ3rJTqmCTfEdYAwnrLmD3wt
   BImPDYaEdOVEdZ+mx+VpzYpLZqazwhTQ3DE2xNo9RAi/9I3FSUxK5nCgP
   o1h2bWxyT+GXVcU2MJGTB2MMHhDJ2OJBRedFdXOilrxv9gjejJ9EV5kCP
   vY+4p/yvxckVdHNso4H1ROsXutVQnjfjTGBYA/B0kDjDqgKHSnCyUo3Rq
   g==;
IronPort-SDR: JSBLNSD4g+ogyghFy5uARjdwUViMZSZ4gbZwwoP7xi4kVLXWak+adDqaSanal6OEgRp+YEWnl/
 Cqj004BI/fwpZ/vf+i8+8+zHawUC3aE3RpDIH6/l5czEK57UMMRh37TYIDNsYxIyQDAiNg0us4
 rcgws40jFpFPLEXDtLuhclNqjRTBKREh5Lnz1z696wM1yf27d9+kUfvsbeTvNyYfANnDa1dKG2
 nX9clMFxtDqPcVY+++vJSzH66ON4KzJLUC0tDxKg7oo1OAVTB3HxY5hQgc3mxdBXazF6yiu94c
 aYQ=
X-IronPort-AV: E=Sophos;i="5.81,167,1610434800"; 
   d="scan'208";a="106091807"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Feb 2021 01:53:07 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 10 Feb 2021 01:53:07 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 10 Feb 2021 01:53:05 -0700
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
Subject: [PATCH v14 2/4] phy: Add media type and speed serdes configuration interfaces
Date:   Wed, 10 Feb 2021 09:52:53 +0100
Message-ID: <20210210085255.2006824-3-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210210085255.2006824-1-steen.hegelund@microchip.com>
References: <20210210085255.2006824-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide new phy configuration interfaces for media type and speed that
allows allows e.g. PHYs used for ethernet to be configured with this
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
index e435bdb0bab3..e4fd69a1faa7 100644
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
+	return -ENOSYS;
+}
+
+static inline int phy_set_speed(struct phy *phy, int speed)
+{
+	if (!phy)
+		return 0;
+	return -ENOSYS;
+}
+
 static inline enum phy_mode phy_get_mode(struct phy *phy)
 {
 	return PHY_MODE_INVALID;
-- 
2.30.0

