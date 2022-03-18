Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDB94DD6AA
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 09:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234076AbiCRI6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 04:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234190AbiCRI6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 04:58:05 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1627E1F518A;
        Fri, 18 Mar 2022 01:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647593805; x=1679129805;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yrbmAA5eOr2bDr3xh5A19ZPD0LkImm8zRnLwdZx5yiE=;
  b=AJVRx18BhdI2VjcyojbLlsnRBHB0PHv3u7ZMywxqfc2iCeuqcQkVSsXP
   xYhXjrCcckQnXFySGHIpUtzbLVxzYhS83awC5oFdXtBtv8xeC0Uiw2/VO
   oL6vET9kZm6wolPZMcEwBCcMDZwX/zb+xA1qI865qwgFSeO3hAxPGPDa/
   zE18CUPzfJ5mm91ohssppQIa4Zx2LqxO/kYVFEH0i/5Hji8TPmynWTrSd
   q5DwM55Bh5XNh2mEUgT+yhLs1UJrRuWxrhY7K0B9rkNyrA4sK5iWBnc6a
   V+NHWnPiUPoG37sS+R+vmcDVO43q0ErWXWOizYVJng0xTatpcIGWu2NXc
   g==;
X-IronPort-AV: E=Sophos;i="5.90,191,1643698800"; 
   d="scan'208";a="166275150"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Mar 2022 01:56:40 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 18 Mar 2022 01:56:39 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 18 Mar 2022 01:56:34 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <woojung.huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v9 net-next 09/11] net: dsa: microchip: add support for port mirror operations
Date:   Fri, 18 Mar 2022 14:25:38 +0530
Message-ID: <20220318085540.281721-10-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220318085540.281721-1-prasanna.vengateshan@microchip.com>
References: <20220318085540.281721-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/dsa/microchip/lan937x_main.c | 84 ++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index c54aba6a05b5..5a57a2ce8992 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -98,6 +98,88 @@ static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
 	ksz_update_port_member(dev, port);
 }
 
+static int lan937x_port_mirror_add(struct dsa_switch *ds, int port,
+				   struct dsa_mall_mirror_tc_entry *mirror,
+				   bool ingress)
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
+			dev_err(dev->dev,
+				"Delete existing rules towards %s & try\n",
+				dsa_to_port(ds, p)->name);
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
@@ -508,6 +590,8 @@ const struct dsa_switch_ops lan937x_switch_ops = {
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

