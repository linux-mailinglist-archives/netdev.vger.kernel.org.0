Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6039D3D3ECA
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbhGWQve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:51:34 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:12001 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbhGWQv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 12:51:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1627061521; x=1658597521;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2Cl8/+oQ/Kq2Y04tKUTiuVCML1p6Cl0L0bXrmXaUHrg=;
  b=FOXTCIf6Rnr/ELiI2uznI1MQVYdu94L0IKvPQI179RHsgszq8HWiLS+p
   nyhvuuFEYbUZACQPOU/ikD24N7A8JMp06lW+S0V7zUR2k2XdBxkWDhjnE
   QSEaPU6qPGqibxUDy2ZHt4PqK9nDSngLhQMmZPjNJAbWC/9EX7KhqJR38
   itrWceMxrWI/EuCmz81UfImWwMI+tnJgiOKOPId1BMOJIaz/H3i6Fgvzh
   aU4H2aeRz1lsxOYcq+t9C4yY0EQ9AAuELqQV9WshYAJIXOcyLMxGs6OO2
   Qg7odNAQs5rHCIyaIULihFax0pke09gQd6V3hCDt2eFne1TGhFQ+uvuUR
   g==;
IronPort-SDR: CMxkL7mfhyGPy9ZqxrlWOsqdOAbphUFN2QJzvJPWEs9HS/xRwfpFepHclbCduMhhksNhEHZ63q
 z6thLZeI9fp0dX7CyXHieO/aF7gYzYjCmQPpL1DWqD/Yr5y5YNhXQPayyAx4x+g3BPi6XHaq8r
 2u0D9o15hNXj93TQC7w+4SdWTG8WIW4ZD+Nunk35YMib7Gdj7zP7uJd0ncWKyZv1/6G59/smkK
 Jbk4i+XJWRKxkKh9Lpmclbj+Cfjv8j4XSEHiKQSba08+u5Qv87bs1tMsG30n3TvVCONVOqjKql
 LaJPn7diu2GqB1G+t6bJwQ4I
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="137292028"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jul 2021 10:32:00 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Jul 2021 10:31:55 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 23 Jul 2021 10:31:50 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v3 net-next 07/10] net: dsa: microchip: add support for ethtool port counters
Date:   Fri, 23 Jul 2021 23:01:05 +0530
Message-ID: <20210723173108.459770-8-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reused the KSZ common APIs for get_ethtool_stats() & get_sset_count()
along with relevant lan937x hooks for KSZ common layer and added
support for get_strings()

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 74b6c9563dc1..3380a4617725 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -43,6 +43,21 @@ static int lan937x_phy_write16(struct dsa_switch *ds, int addr, int reg,
 	return lan937x_internal_phy_write(dev, addr, reg, val);
 }
 
+static void lan937x_get_strings(struct dsa_switch *ds, int port, u32 stringset,
+				uint8_t *buf)
+{
+	struct ksz_device *dev = ds->priv;
+	int i;
+
+	if (stringset != ETH_SS_STATS)
+		return;
+
+	for (i = 0; i < dev->mib_cnt; i++) {
+		memcpy(buf + i * ETH_GSTRING_LEN, lan937x_mib_names[i].string,
+		       ETH_GSTRING_LEN);
+	}
+}
+
 static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
 				       u8 state)
 {
@@ -384,6 +399,9 @@ const struct dsa_switch_ops lan937x_switch_ops = {
 	.phy_read = lan937x_phy_read16,
 	.phy_write = lan937x_phy_write16,
 	.port_enable = ksz_enable_port,
+	.get_strings = lan937x_get_strings,
+	.get_ethtool_stats = ksz_get_ethtool_stats,
+	.get_sset_count = ksz_sset_count,
 	.port_bridge_join = ksz_port_bridge_join,
 	.port_bridge_leave = ksz_port_bridge_leave,
 	.port_stp_state_set = lan937x_port_stp_state_set,
-- 
2.27.0

