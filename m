Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDDF306DD3
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 07:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhA1Gp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 01:45:59 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:10106 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbhA1Gpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 01:45:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611816345; x=1643352345;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9tSKzomBMjhAvNcMzz+sOAdh/RdjsnA65i6SeUfXtFQ=;
  b=tByXCDfQtpO3O+z/2SAhO+flQrK+U+pdBbR9494Dh+63ZpQM2T1vzPSd
   XqdqivP7ZVqMSVBqEtmAuv1qDJHMh96nkt/hCM6cG9S85yVWRyeo2Sv8l
   aToB1MpDVvUpOEsPdTZpkjlskoR0N0ESZ1lvcTWRTSgvbhOIyr8glcjik
   Vz24qJPwhkBTtzLoaM8WLh2JYUoJLSsFna3GZCfTCKY5+0BP6ztPnk0iC
   iowHSRhY0kaAzerzHyzmGEH8npuf1zMYFtPvVRGGRSiVnU0dj86gyPCyU
   pN8zBpYQYVYvOs/vWKudX99lRMTEcmpvaKUiI9NXswhfeLh3b/30xAFI5
   Q==;
IronPort-SDR: 9RhBQJjcEkVCgDPRlSHzWUUUUXtTHAxnUq2faRy9r0/FVsPvOWyKaFD1XPm+tMy1Mnodx/G/UX
 Tz+v9BnpWptSptj7RIdKi7ycmvIUaXVzmk4gn2++V6MEts3J+3Bn7s6QymbofIqzm15gvvaFl7
 CeDJVIz1PHnlf7+RL9oJ/khGuTj904z+fxcN5mVLH33yznE4N7dtzfkn4a1IrnlR2qY3SH+ZIr
 r91OfCjnQrrtldnR2Dmfxb6/Q3ugUpNLhip3g7Y4NmuFUVEievKgfL40IDCQOSqJRW5kyuh5/C
 U4g=
X-IronPort-AV: E=Sophos;i="5.79,381,1602572400"; 
   d="scan'208";a="107076550"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2021 23:44:20 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 23:44:18 -0700
Received: from CHE-LT-I21427U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 27 Jan 2021 23:44:13 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <olteanv@gmail.com>, <netdev@vger.kernel.org>,
        <robh+dt@kernel.org>
CC:     <kuba@kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH net-next 2/8] net: dsa: tag_ksz: add tag handling for Microchip LAN937x
Date:   Thu, 28 Jan 2021 12:11:06 +0530
Message-ID: <20210128064112.372883-3-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
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
 net/dsa/Kconfig   |  4 +--
 net/dsa/tag_ksz.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 2f5435d3d1db..b9bc7a9a8c15 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -47,6 +47,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_RTL4_A_VALUE		17
 #define DSA_TAG_PROTO_HELLCREEK_VALUE		18
 #define DSA_TAG_PROTO_XRS700X_VALUE		19
+#define DSA_TAG_PROTO_LAN937X_VALUE		20
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -69,6 +70,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_RTL4_A		= DSA_TAG_PROTO_RTL4_A_VALUE,
 	DSA_TAG_PROTO_HELLCREEK		= DSA_TAG_PROTO_HELLCREEK_VALUE,
 	DSA_TAG_PROTO_XRS700X		= DSA_TAG_PROTO_XRS700X_VALUE,
+	DSA_TAG_PROTO_LAN937X		= DSA_TAG_PROTO_LAN937X_VALUE,
 };
 
 struct packet_type;
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 2d226a5c085f..217fa0f8d13e 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -92,10 +92,10 @@ config NET_DSA_TAG_MTK
 	  Mediatek switches.
 
 config NET_DSA_TAG_KSZ
-	tristate "Tag driver for Microchip 8795/9477/9893 families of switches"
+	tristate "Tag driver for Microchip 8795/9477/9893/937x families of switches"
 	help
 	  Say Y if you want to enable support for tagging frames for the
-	  Microchip 8795/9477/9893 families of switches.
+	  Microchip 8795/9477/9893/937x families of switches.
 
 config NET_DSA_TAG_RTL4_A
 	tristate "Tag driver for Realtek 4 byte protocol A tags"
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 4820dbcedfa2..6fac39c2b7d5 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -190,10 +190,84 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
 DSA_TAG_DRIVER(ksz9893_netdev_ops);
 MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893);
 
+/* For Ingress (Host -> LAN937x), 2 bytes are added before FCS.
+ * ---------------------------------------------------------------------------
+ * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|tag1(1byte)|FCS(4bytes)
+ * ---------------------------------------------------------------------------
+ * tag0 : represents tag override, lookup and valid
+ * tag1 : each bit represents port (eg, 0x01=port1, 0x02=port2, 0x80=port8)
+ *
+ * For Egress (LAN937x -> Host), 1 byte is added before FCS.
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
+	/* Tag encoding */
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
+static struct sk_buff *lan937x_rcv(struct sk_buff *skb, struct net_device *dev,
+				   struct packet_type *pt)
+{
+	/* Tag decoding */
+	u8 *tag = skb_tail_pointer(skb) - KSZ_EGRESS_TAG_LEN;
+	unsigned int port = tag[0] & LAN937X_TAIL_TAG_PORT_MASK;
+	unsigned int len = KSZ_EGRESS_TAG_LEN;
+
+	/* Extra 4-bytes PTP timestamp */
+	if (tag[0] & KSZ9477_PTP_TAG_INDICATION)
+		len += KSZ9477_PTP_TAG_LEN;
+
+	return ksz_common_rcv(skb, dev, port, len);
+}
+
+static const struct dsa_device_ops lan937x_netdev_ops = {
+	.name	= "lan937x",
+	.proto	= DSA_TAG_PROTO_LAN937X,
+	.xmit	= lan937x_xmit,
+	.rcv	= lan937x_rcv,
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
2.25.1

