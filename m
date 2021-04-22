Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24FB5367DFB
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 11:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235804AbhDVJoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 05:44:14 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:23815 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235798AbhDVJoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 05:44:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1619084610; x=1650620610;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CnJ1HIV8FBOcUxKWmvG7eDS8Xj/2iPvIjrNmlTjPZnI=;
  b=xX+8GAyP2+7jkznOgoYOIM3WJcG1goDLij+LNlc8rKnCcpYbAen/HJZS
   ZiC6ruMm3no3R5Dw1VKKSwRw1DzEoR3XGo8ksJyLIKcZeotJlFf4zN2RC
   km7KLZUF+I+vN3kd/MlFtd3jWC8s/q9od57UFSbKELRMcsYi7uaQU2oxo
   XYjTn/fbKeqMlqhDAPNsyqUS3HL3JK3Sn2qm8r+gwb9Pbq4z8DEhBYUnx
   IyvRFu2DB7kQIpor1i/NJK2EGyoRBxFpECrpOZ6zlnre6Ml8tp+UOVKVE
   Fcrhow/rNaIAtk+Dh6wS2GPFbCZATCI6oCe6m7rHrYZbEh8S6sr9Zimj3
   w==;
IronPort-SDR: yH7+rjBX4k8Ro3fWb1riu30zuJ8VMsVaKHvoJG6MAJBAt6UdatJaN57BHFRT8ihXm803pgU2Tf
 e7an389QzQMO/OmffWrZD6KBriq4+Ig+KwXs3/A13OtRJRyiQYYJIvkR1HzVyrJQtDFkN4DdBw
 y28f4oDvqGrYigDI8XfHZ0MPY6FkJw73qfACiRm3YIWfLiOFLIKpi9SY95BDZ2t4AwqdpJ5SCS
 YAiw5ZHLwJmPl9Vy/Gdl7nPyk1r/ek9CXUDPTEbMCyhIa9w0fLUZnxxiBQU9Gmm23CoqeWDyyo
 j/8=
X-IronPort-AV: E=Sophos;i="5.82,242,1613458800"; 
   d="scan'208";a="111784867"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Apr 2021 02:43:27 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 02:43:27 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Thu, 22 Apr 2021 02:43:20 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v2 net-next 3/9] net: dsa: tag_ksz: add tag handling for Microchip LAN937x
Date:   Thu, 22 Apr 2021 15:12:51 +0530
Message-ID: <20210422094257.1641396-4-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Microchip LAN937X switches have a tagging protocol which is
very similar to KSZ tagging. So that the implementation is added to
tag_ksz.c and reused common APIs

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 include/net/dsa.h |  2 ++
 net/dsa/Kconfig   |  4 ++--
 net/dsa/tag_ksz.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 507082959aa4..98c1ab6dc4dc 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -50,6 +50,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_OCELOT_8021Q_VALUE	20
 #define DSA_TAG_PROTO_SEVILLE_VALUE		21
 #define DSA_TAG_PROTO_BRCM_LEGACY_VALUE		22
+#define DSA_TAG_PROTO_LAN937X_VALUE		23
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -75,6 +76,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_XRS700X		= DSA_TAG_PROTO_XRS700X_VALUE,
 	DSA_TAG_PROTO_OCELOT_8021Q	= DSA_TAG_PROTO_OCELOT_8021Q_VALUE,
 	DSA_TAG_PROTO_SEVILLE		= DSA_TAG_PROTO_SEVILLE_VALUE,
+	DSA_TAG_PROTO_LAN937X		= DSA_TAG_PROTO_LAN937X_VALUE,
 };
 
 struct packet_type;
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index cbc2bd643ab2..888eb79a85f2 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -97,10 +97,10 @@ config NET_DSA_TAG_MTK
 	  Mediatek switches.
 
 config NET_DSA_TAG_KSZ
-	tristate "Tag driver for Microchip 8795/9477/9893 families of switches"
+	tristate "Tag driver for Microchip 8795/937x/9477/9893 families of switches"
 	help
 	  Say Y if you want to enable support for tagging frames for the
-	  Microchip 8795/9477/9893 families of switches.
+	  Microchip 8795/937x/9477/9893 families of switches.
 
 config NET_DSA_TAG_RTL4_A
 	tristate "Tag driver for Realtek 4 byte protocol A tags"
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 4820dbcedfa2..a67f21bdab8f 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -190,10 +190,68 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
 DSA_TAG_DRIVER(ksz9893_netdev_ops);
 MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893);
 
+/* For xmit, 2 bytes are added before FCS.
+ * ---------------------------------------------------------------------------
+ * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|tag1(1byte)|FCS(4bytes)
+ * ---------------------------------------------------------------------------
+ * tag0 : represents tag override, lookup and valid
+ * tag1 : each bit represents port (eg, 0x01=port1, 0x02=port2, 0x80=port8)
+ *
+ * For rcv, 1 byte is added before FCS.
+ * ---------------------------------------------------------------------------
+ * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|FCS(4bytes)
+ * ---------------------------------------------------------------------------
+ * tag0 : zero-based value represents port
+ *	  (eg, 0x00=port1, 0x02=port3, 0x07=port8)
+ */
+#define LAN937X_INGRESS_TAG_LEN		2
+
+#define LAN937X_TAIL_TAG_OVERRIDE	BIT(11)
+#define LAN937X_TAIL_TAG_LOOKUP		BIT(12)
+#define LAN937X_TAIL_TAG_VALID		BIT(13)
+#define LAN937X_TAIL_TAG_PORT_MASK	7
+
+static struct sk_buff *lan937x_xmit(struct sk_buff *skb,
+				    struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	__be16 *tag;
+	u8 *addr;
+	u16 val;
+
+	tag = skb_put(skb, LAN937X_INGRESS_TAG_LEN);
+	addr = skb_mac_header(skb);
+
+	val = BIT(dp->index);
+
+	if (is_link_local_ether_addr(addr))
+		val |= LAN937X_TAIL_TAG_OVERRIDE;
+
+	/* Tail tag valid bit - This bit should always be set by the CPU*/
+	val |= LAN937X_TAIL_TAG_VALID;
+
+	*tag = cpu_to_be16(val);
+
+	return skb;
+}
+
+static const struct dsa_device_ops lan937x_netdev_ops = {
+	.name	= "lan937x",
+	.proto	= DSA_TAG_PROTO_LAN937X,
+	.xmit	= lan937x_xmit,
+	.rcv	= ksz9477_rcv,
+	.overhead = LAN937X_INGRESS_TAG_LEN,
+	.tail_tag = true,
+};
+
+DSA_TAG_DRIVER(lan937x_netdev_ops);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_LAN937X);
+
 static struct dsa_tag_driver *dsa_tag_driver_array[] = {
 	&DSA_TAG_DRIVER_NAME(ksz8795_netdev_ops),
 	&DSA_TAG_DRIVER_NAME(ksz9477_netdev_ops),
 	&DSA_TAG_DRIVER_NAME(ksz9893_netdev_ops),
+	&DSA_TAG_DRIVER_NAME(lan937x_netdev_ops),
 };
 
 module_dsa_tag_drivers(dsa_tag_driver_array);
-- 
2.27.0

