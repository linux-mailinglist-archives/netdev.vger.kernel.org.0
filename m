Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D666E4E4713
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 20:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbiCVT5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 15:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbiCVT5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 15:57:23 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16664DF52;
        Tue, 22 Mar 2022 12:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647978955; x=1679514955;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MVoKun0f6EUeOWvz5e2xJ3Ag+ZUi3FPzc4l1bOHwOSA=;
  b=vGmPnEhATWY6tTIN8jAhZmJQ+2Vmejbrg/rJqG7tCILgA0qXqwHJQW1j
   P1thzG+6w3WUTxYmseJWGblSgL/czRovbP1huw2zQx3Do4UhIuhUHud2s
   /0gIQ5GV1PtFqt4TgtWAVZl//7sqj02lh70KoSZEe3TQ9QWx6y5DwSgMo
   y8hc7qtmet4GwgJbifWicyfG7G0HeMyl14DX9I7jmqZ5kQ/622fO6hQnf
   0tJQ2CTR/7dxKqgBiBaikvGf8Syp/kLeO9I4RKOthiSAYQ5y0ex+wffPf
   PUfFOVeWLsRKjEW3EWFqZmrkjsMv4DCoyPptX12Q11NRE9QOalPey0p39
   A==;
X-IronPort-AV: E=Sophos;i="5.90,202,1643698800"; 
   d="scan'208";a="89775148"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Mar 2022 12:55:54 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 22 Mar 2022 12:55:54 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 22 Mar 2022 12:55:49 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <woojung.huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>,
        <pabeni@redhat.com>
Subject: [PATCH v10 net-next 08/10] net: dsa: microchip: add support for port mirror operations
Date:   Wed, 23 Mar 2022 01:24:53 +0530
Message-ID: <20220322195455.703921-9-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220322195455.703921-1-prasanna.vengateshan@microchip.com>
References: <20220322195455.703921-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added support for port_mirror_add() and port_mirror_del operations

Sniffing is limited to one port & alert the user if any new
sniffing port is selected

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 83 ++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 51640234dda6..504b9a4edea2 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -98,6 +98,87 @@ static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
 	ksz_update_port_member(dev, port);
 }
 
+static int lan937x_port_mirror_add(struct dsa_switch *ds, int port,
+				   struct dsa_mall_mirror_tc_entry *mirror,
+				   bool ingress, struct netlink_ext_ack *extack)
+{
+	struct ksz_device *dev = ds->priv;
+	int ret, p;
+	u8 data;
+
+	/* Limit to one sniffer port
+	 * Check if any of the port is already set for sniffing
+	 * If yes, instruct the user to remove the previous entry & exit
+	 */
+	for (p = 0; p < dev->port_cnt; p++) {
+		/* Skip the current sniffing port */
+		if (p == mirror->to_local_port)
+			continue;
+
+		ret = lan937x_pread8(dev, p, P_MIRROR_CTRL, &data);
+		if (ret < 0)
+			return ret;
+
+		if (data & PORT_MIRROR_SNIFFER) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Sniffer port is already configured, delete existing rules & retry");
+			return -EBUSY;
+		}
+	}
+
+	/* Configure ingress/egress mirroring */
+	if (ingress)
+		ret = lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX,
+				       true);
+	else
+		ret = lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX,
+				       true);
+	if (ret < 0)
+		return ret;
+
+	/* Configure sniffer port as other ports do not have
+	 * PORT_MIRROR_SNIFFER is set
+	 */
+	ret = lan937x_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
+			       PORT_MIRROR_SNIFFER, true);
+	if (ret < 0)
+		return ret;
+
+	return lan937x_cfg(dev, S_MIRROR_CTRL, SW_MIRROR_RX_TX, false);
+}
+
+static void lan937x_port_mirror_del(struct dsa_switch *ds, int port,
+				    struct dsa_mall_mirror_tc_entry *mirror)
+{
+	struct ksz_device *dev = ds->priv;
+	bool in_use = false;
+	u8 data;
+	int p;
+
+	/* clear ingress/egress mirroring port */
+	if (mirror->ingress)
+		lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX,
+				 false);
+	else
+		lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX,
+				 false);
+
+	/* Check if any of the port is still referring to sniffer port */
+	for (p = 0; p < dev->port_cnt; p++) {
+		lan937x_pread8(dev, p, P_MIRROR_CTRL, &data);
+
+		if ((data & (PORT_MIRROR_RX | PORT_MIRROR_TX))) {
+			in_use = true;
+			break;
+		}
+	}
+
+	/* delete sniffing if there are no other mirroring rule exist */
+	if (!in_use)
+		lan937x_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
+				 PORT_MIRROR_SNIFFER, false);
+}
+
 static void lan937x_config_cpu_port(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
@@ -485,6 +566,8 @@ const struct dsa_switch_ops lan937x_switch_ops = {
 	.port_bridge_leave = ksz_port_bridge_leave,
 	.port_stp_state_set = lan937x_port_stp_state_set,
 	.port_fast_age = ksz_port_fast_age,
+	.port_mirror_add = lan937x_port_mirror_add,
+	.port_mirror_del = lan937x_port_mirror_del,
 	.port_max_mtu = lan937x_get_max_mtu,
 	.port_change_mtu = lan937x_change_mtu,
 	.phylink_get_caps = lan937x_phylink_get_caps,
-- 
2.30.2

