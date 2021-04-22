Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21372367E03
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 11:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbhDVJob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 05:44:31 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:52771 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235855AbhDVJoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 05:44:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1619084629; x=1650620629;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jwRbholel2gyBVZTpWGBcfAzi4y/NKDbsLEQ9KN/sLk=;
  b=neNcNVeyD4VNXjmUKIobP5B6Y0vk/UGgF8tADcKACJwCE+/ISvuKi+Y9
   TZ81/Bsv89YAGckQz0xgYpYKZSZ0qfP6GWUjbA2F60wN2I2l1XApb6gGK
   SQ8EeP/iydhHJh9fOBENMkNymVkX9ZsbSqJe2QQO+Ezqm+I+r9YnIUrxM
   POxBOztj+TdVkU6pR8zL6o7MepSD0Id4Lsow2s9zKD8KoMYfiKPEWabV9
   ctrRke3lCLkLPiaYC/uDkX8ZXf3K8jSONnbVKHeL37rExdcP4T99HurY/
   BVWlQPlBwIXKTgHKbeBEZlT/iw1mqUAo8syw3p2kB/u8BPDZOCFANjyNn
   Q==;
IronPort-SDR: C8NOg0FAK0lMGw7DLqlNXRRUdFEIqB9e0nDCEWKQszvGIGqeaLD9BAN6z+0csu4xzZ7pxFIXoP
 jufoG+VBplCfYVci39wZTkt4I6u0fQQu8q8KTfyiv6ZQgTAw7agoCWOzwW5ckNiM6K1bup+EBI
 I4SND/HO2P4LxgSiU0Iv5/iDejiwH/5TsjB8S2gOqLnGCam/5+lkuixOfTrVIoG/8OTyE+TfQE
 5YIjMqcNkrKfFxkjaHyFsHg0yU84Byh3pgNJkxnAZXcWicm5WDgUgD/rlEPaCn4sS5Rx11gnt0
 p2g=
X-IronPort-AV: E=Sophos;i="5.82,242,1613458800"; 
   d="scan'208";a="114490573"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Apr 2021 02:43:48 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 02:43:47 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Thu, 22 Apr 2021 02:43:41 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v2 net-next 6/9] net: dsa: microchip: add support for ethtool port counters
Date:   Thu, 22 Apr 2021 15:12:54 +0530
Message-ID: <20210422094257.1641396-7-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
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
index 93c392081423..573d2dd906f5 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -43,6 +43,21 @@ static int lan937x_phy_write16(struct dsa_switch *ds, int addr, int reg,
 	return lan937x_internal_phy_write(dev, addr, reg, val);
 }
 
+static void lan937x_get_strings(struct dsa_switch *ds, int port,
+				u32 stringset, uint8_t *buf)
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
@@ -372,6 +387,9 @@ const struct dsa_switch_ops lan937x_switch_ops = {
 	.phy_read		= lan937x_phy_read16,
 	.phy_write		= lan937x_phy_write16,
 	.port_enable		= ksz_enable_port,
+	.get_strings		= lan937x_get_strings,
+	.get_ethtool_stats	= ksz_get_ethtool_stats,
+	.get_sset_count		= ksz_sset_count,
 	.port_bridge_join	= ksz_port_bridge_join,
 	.port_bridge_leave	= ksz_port_bridge_leave,
 	.port_pre_bridge_flags	= lan937x_port_pre_bridge_flags,
-- 
2.27.0

