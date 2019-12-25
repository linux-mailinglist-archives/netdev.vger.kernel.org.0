Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A247C12A5F9
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 06:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfLYFWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 00:22:52 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:52927 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfLYFWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 00:22:52 -0500
Received: by mail-wm1-f45.google.com with SMTP id p9so3663634wmc.2
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 21:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qMTBrOIT6QljA26o7CngIXpUowbXiYo2yACLBwyAbCI=;
        b=ozInkqUYw1Kqoft2NGxBrmmVKrzez0ibPnP4Zt+XboGoIQK8sM3cM63+Yp1Ho8Pe3a
         BZT9i06stwBv8LUlvGBploPoPcOnu2y/88iiZ7aOPREfnUT3e7fmpHN8JQM3CkDoIeEb
         YMrBbGnyGVIRTe9n5SId2UoZuVWlfHskGpIigNcbKQ18P6mnwAqLdCfvdkwYCr2iTh8D
         u51Vy2QL2Sa6cmaMLt3z5AAzPxEhxsbnYerHJqWw/+nBcGiDE5H9g81nu1KCRYhotsED
         mxIL9FTjYTZw82zmD0ASo5K503NK1xWMAfNX1YGHdOiRbTAVk8GsUrFcj2Kpu980bJon
         2YhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qMTBrOIT6QljA26o7CngIXpUowbXiYo2yACLBwyAbCI=;
        b=nutP9dgDKhZk+C/x4149SpU+5ZtscL+43QE3XPfE2ORroiK6ZaHoc/lF3vv8glGbfB
         vmBQ/BdQZph1t3LgpQRmnVVKx6TC7v4/ZypY3EEPoW/qN1J/DpBZnqty6Og04M3RasH3
         2Aw7poapjxVdlD9euBeqKbWycyJJQ8fC5X4pb2OMFrZK3/sIP4MM226OzwdWXMyRPmqa
         7aUhHdCk72uB6izkQxZF8kuU62QYSoz3s0NfAK6mBa49Yf0Z6GKjv68H7TmLwqw6rX7S
         f4+peCwv4uIqfcIv2+VAfD8QQ44sHHPSmanzl1TZo1AVB6ipzhnDegNnRcYt+0US0e0D
         mu0Q==
X-Gm-Message-State: APjAAAWaDXXDFkjdbsKysA1nRqwD6qqG03yM4O+vZ1cs0KEvK5CRgEHN
        lxtLNJCNbGIOjhSyIICyErtNog==
X-Google-Smtp-Source: APXvYqzc/V6XRdPpMfp67C5BqhJAi7qCXNhWtCdv9V988HZMNdA4oBVTi0zALCXR804KowE8pqShrA==
X-Received: by 2002:a05:600c:230d:: with SMTP id 13mr7249445wmo.12.1577251369298;
        Tue, 24 Dec 2019 21:22:49 -0800 (PST)
Received: from cobook.home (nikaet.starlink.ru. [94.141.168.29])
        by smtp.gmail.com with ESMTPSA id u16sm4682935wmj.41.2019.12.24.21.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2019 21:22:48 -0800 (PST)
From:   Nikita Yushchenko <nikita.yoush@cogentembedded.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Subject: [PATCH v2] mv88e6xxx: Add serdes Rx statistics
Date:   Wed, 25 Dec 2019 08:22:38 +0300
Message-Id: <20191225052238.23334-1-nikita.yoush@cogentembedded.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If packet checker is enabled in the serdes, then Rx counter registers
start working, and no side effects have been detected.

This patch enables packet checker automatically when powering serdes on,
and exposes Rx counter registers via ethtool statistics interface.

Code partially basded by older attempt by Andrew Lunn.

Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
---
Changes from v1:
- added missing break statement (thanks kbuild test robot <lkp@intel.com>)
- renamed variable ret -> err to follow the rest of the file

 drivers/net/dsa/mv88e6xxx/chip.c   |   3 +
 drivers/net/dsa/mv88e6xxx/serdes.c | 100 ++++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/serdes.h |   9 +++
 3 files changed, 109 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 3bd988529178..5eeeb6566196 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4424,6 +4424,9 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
+	.serdes_get_strings = mv88e6390_serdes_get_strings,
+	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.phylink_validate = mv88e6390_phylink_validate,
 };
 
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 902feb398746..8d8b3b74aee1 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -405,22 +405,116 @@ static int mv88e6390_serdes_power_sgmii(struct mv88e6xxx_chip *chip, u8 lane,
 	return err;
 }
 
+struct mv88e6390_serdes_hw_stat {
+	char string[ETH_GSTRING_LEN];
+	int reg;
+};
+
+static struct mv88e6390_serdes_hw_stat mv88e6390_serdes_hw_stats[] = {
+	{ "serdes_rx_pkts", 0xf021 },
+	{ "serdes_rx_bytes", 0xf024 },
+	{ "serdes_rx_pkts_error", 0xf027 },
+};
+
+int mv88e6390_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port)
+{
+	if (mv88e6390_serdes_get_lane(chip, port) == 0)
+		return 0;
+
+	return ARRAY_SIZE(mv88e6390_serdes_hw_stats);
+}
+
+int mv88e6390_serdes_get_strings(struct mv88e6xxx_chip *chip,
+				 int port, uint8_t *data)
+{
+	struct mv88e6390_serdes_hw_stat *stat;
+	int i;
+
+	if (mv88e6390_serdes_get_lane(chip, port) == 0)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(mv88e6390_serdes_hw_stats); i++) {
+		stat = &mv88e6390_serdes_hw_stats[i];
+		memcpy(data + i * ETH_GSTRING_LEN, stat->string,
+		       ETH_GSTRING_LEN);
+	}
+	return ARRAY_SIZE(mv88e6390_serdes_hw_stats);
+}
+
+static uint64_t mv88e6390_serdes_get_stat(struct mv88e6xxx_chip *chip, int lane,
+					  struct mv88e6390_serdes_hw_stat *stat)
+{
+	u16 reg[3];
+	int err, i;
+
+	for (i = 0; i < 3; i++) {
+		err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+					    stat->reg + i, &reg[i]);
+		if (err) {
+			dev_err(chip->dev, "failed to read statistic\n");
+			return 0;
+		}
+	}
+
+	return reg[0] | ((u64)reg[1] << 16) | ((u64)reg[2] << 32);
+}
+
+int mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
+			       uint64_t *data)
+{
+	struct mv88e6390_serdes_hw_stat *stat;
+	int lane;
+	int i;
+
+	lane = mv88e6390_serdes_get_lane(chip, port);
+	if (lane == 0)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(mv88e6390_serdes_hw_stats); i++) {
+		stat = &mv88e6390_serdes_hw_stats[i];
+		data[i] = mv88e6390_serdes_get_stat(chip, lane, stat);
+	}
+
+	return ARRAY_SIZE(mv88e6390_serdes_hw_stats);
+}
+
+static int mv88e6390_serdes_enable_checker(struct mv88e6xxx_chip *chip, u8 lane)
+{
+	u16 reg;
+	int err;
+
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6390_PG_CONTROL, &reg);
+	if (err)
+		return err;
+
+	reg |= MV88E6390_PG_CONTROL_ENABLE_PC;
+	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
+				      MV88E6390_PG_CONTROL, reg);
+}
+
 int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
 			   bool up)
 {
 	u8 cmode = chip->ports[port].cmode;
+	int err = 0;
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
 	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
-		return mv88e6390_serdes_power_sgmii(chip, lane, up);
+		err = mv88e6390_serdes_power_sgmii(chip, lane, up);
+		break;
 	case MV88E6XXX_PORT_STS_CMODE_XAUI:
 	case MV88E6XXX_PORT_STS_CMODE_RXAUI:
-		return mv88e6390_serdes_power_10g(chip, lane, up);
+		err = mv88e6390_serdes_power_10g(chip, lane, up);
+		break;
 	}
 
-	return 0;
+	if (!err && up)
+		err = mv88e6390_serdes_enable_checker(chip, lane);
+
+	return err;
 }
 
 static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index bd8df36ab537..d16ef4da20b0 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -74,6 +74,10 @@
 #define MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID BIT(11)
 #define MV88E6390_SGMII_PHY_STATUS_LINK		BIT(10)
 
+/* Packet generator pad packet checker */
+#define MV88E6390_PG_CONTROL		0xf010
+#define MV88E6390_PG_CONTROL_ENABLE_PC		BIT(0)
+
 u8 mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 u8 mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 u8 mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
@@ -99,6 +103,11 @@ int mv88e6352_serdes_get_strings(struct mv88e6xxx_chip *chip,
 				 int port, uint8_t *data);
 int mv88e6352_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
 			       uint64_t *data);
+int mv88e6390_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port);
+int mv88e6390_serdes_get_strings(struct mv88e6xxx_chip *chip,
+				 int port, uint8_t *data);
+int mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
+			       uint64_t *data);
 
 /* Return the (first) SERDES lane address a port is using, 0 otherwise. */
 static inline u8 mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
-- 
2.20.1

