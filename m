Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B6A43F698
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 07:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhJ2F0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 01:26:46 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:26406 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbhJ2F0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 01:26:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635485053; x=1667021053;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=64s30kDz1ZBo74A+RcUlPbw6No5OGcdT/hbtUXfasKg=;
  b=e+VUn4sonxMwYnhgwcB20O36QQLl1im+BhAHPWXSr3OqDjSHsB3nsKVY
   eOHPxq4e1lHZy94F00wwSts0cWLFwv1AR2HXIMizLIL3EfKV/McWCzni2
   D0GzE6STX+zah5dfE/vnnVQl3P3ijLECRkAOosw19u2fqHyK+fiY4u1n+
   B8vCk8B5Gxq/zYm2IpA+Z5JY30Y1fgr7S6Ic55ch2ivz8y8zqDE+bviFC
   ZKNyiGSFNw/Prr+tbqKV6U+GuQVVVhU4i1X2egxIfpzOSljKjcNkHRjM5
   w7N3dQOozzSLDyHG1Ru5l1FZXRZpKQ8iU1MvWWCcEtUJKTYgTe1mEYyEc
   g==;
IronPort-SDR: ABxm3HMzh5FQLHJCszFyhb/WNupkPBbJD8T2+wqIMB+AsdGrPJbdIFllYGoHSPrQdO7XdDEAzd
 rLBjnwCyZ1fozJ77wJidgWxG9XjrNa2MAYSCsFMFLD1qoQGs1OayxFio2Z6uJRuJ2dIDLmn6Ma
 Hq7CPSBYubRspVERnfGuWvblo6TqjON8UU3xErVHkhdBMFtVoc0ZUGVFuCOYkcsbHpdfl2Y7N1
 oaBDMBBTmoG4uRtOWBCsovHluu77+H1kTG3FOaMtKFB6+8+ft4VnVWKdA653SD0p5+PHb45Jts
 mC40DLKuW+7Dy1XKPDOZfsJq
X-IronPort-AV: E=Sophos;i="5.87,191,1631602800"; 
   d="scan'208";a="74669112"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Oct 2021 22:24:12 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 28 Oct 2021 22:24:12 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 28 Oct 2021 22:24:05 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v6 net-next 07/10] net: dsa: microchip: add support for ethtool port counters
Date:   Fri, 29 Oct 2021 10:52:53 +0530
Message-ID: <20211029052256.144739-8-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211029052256.144739-1-prasanna.vengateshan@microchip.com>
References: <20211029052256.144739-1-prasanna.vengateshan@microchip.com>
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
index 5dfd60fbc322..0976a95851c0 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -45,6 +45,21 @@ static int lan937x_phy_write16(struct dsa_switch *ds, int addr, int reg,
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
@@ -426,6 +441,9 @@ const struct dsa_switch_ops lan937x_switch_ops = {
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

