Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6058843E653
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 18:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhJ1QoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 12:44:21 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:46013 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbhJ1QoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 12:44:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635439310; x=1666975310;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fseRCMYSJpd94MUCe42y/rzPsoc2Eyw6aQWeVlDNT2o=;
  b=szVAcakZdR4ce3LAgL0itoKVrHlUoP322hMqnEJa8feeJ4OvP++NVhgD
   sjomfzTAdvihIh/PvUOQ4bqfJm7/T90Q7O+HIPIGu3FOA5IKzs0TzWaRQ
   SdWGfc34l+khMUbgSntxaz+bjv3oy2e4Le4ZYxGwFZcA3HXdo6sp6vq03
   lgOfkRQ64UMeKAzrV21uF70j1/SoH4ntMGmddHXVwDWT0CXjjAyIEMkSQ
   vPKvR59SHlvc5Q1pyKvdWONvkc4JgK3YiURo1DLihdE8d/3LXFl+CjDc0
   tPeVBtmqoFFuakZVNZiKSDQN2gLOrJRplH8eoYWU+gq012r4Iirv5taiy
   w==;
IronPort-SDR: 82YCPGaVjcQVr7QvZ8dtHf5WFnmI3TypojT4HHO6Zple3Vl38+rdSRnAu4kaOBJu38p67K9vUs
 vkqG3sjIYgKPdIPfcrh0z2X2gJagXt8HOgXew2Ot5tsfISd8VUDQdEUkqWPSmyeGkcQJjHXJVb
 0Th2V9l3NbtI5tLFrKy9sOXoUHOPXff3db2cK8s/pdSNTpmGj2B3N2V8dyRU3O8sC7TFkFy2VY
 f1jXKW/Pn2RuvyeRV6Aw1p59wr7myPBpUcjiyzzF583xpNFWE1a+JwaeyQBxqz3OWKcwM2uDyO
 2MzQX7pqsxH09ZUvTqSbi8CI
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="134681714"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Oct 2021 09:41:49 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 28 Oct 2021 09:41:48 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 28 Oct 2021 09:41:42 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v5 net-next 04/10] net: dsa: tag_ksz: add tag handling for Microchip LAN937x
Date:   Thu, 28 Oct 2021 22:11:05 +0530
Message-ID: <20211028164111.521039-5-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211028164111.521039-1-prasanna.vengateshan@microchip.com>
References: <20211028164111.521039-1-prasanna.vengateshan@microchip.com>
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
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 include/net/dsa.h |  2 ++
 net/dsa/Kconfig   |  4 ++--
 net/dsa/tag_ksz.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index badd214f7470..5e192138ac18 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -52,6 +52,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_BRCM_LEGACY_VALUE		22
 #define DSA_TAG_PROTO_SJA1110_VALUE		23
 #define DSA_TAG_PROTO_RTL8_4_VALUE		24
+#define DSA_TAG_PROTO_LAN937X_VALUE		25
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -79,6 +80,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_SEVILLE		= DSA_TAG_PROTO_SEVILLE_VALUE,
 	DSA_TAG_PROTO_SJA1110		= DSA_TAG_PROTO_SJA1110_VALUE,
 	DSA_TAG_PROTO_RTL8_4		= DSA_TAG_PROTO_RTL8_4_VALUE,
+	DSA_TAG_PROTO_LAN937X		= DSA_TAG_PROTO_LAN937X_VALUE,
 };
 
 struct dsa_switch;
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 8cb87b5067ee..6d0414c9f7f4 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -87,10 +87,10 @@ config NET_DSA_TAG_MTK
 	  Mediatek switches.
 
 config NET_DSA_TAG_KSZ
-	tristate "Tag driver for Microchip 8795/9477/9893 families of switches"
+	tristate "Tag driver for Microchip 8795/937x/9477/9893 families of switches"
 	help
 	  Say Y if you want to enable support for tagging frames for the
-	  Microchip 8795/9477/9893 families of switches.
+	  Microchip 8795/937x/9477/9893 families of switches.
 
 config NET_DSA_TAG_OCELOT
 	tristate "Tag driver for Ocelot family of switches, using NPI port"
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 3509fc967ca9..38fa19c1e2d5 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -193,10 +193,69 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
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
+#define LAN937X_EGRESS_TAG_LEN		2
+
+#define LAN937X_TAIL_TAG_BLOCKING_OVERRIDE	BIT(11)
+#define LAN937X_TAIL_TAG_LOOKUP			BIT(12)
+#define LAN937X_TAIL_TAG_VALID			BIT(13)
+#define LAN937X_TAIL_TAG_PORT_MASK		7
+
+static struct sk_buff *lan937x_xmit(struct sk_buff *skb,
+				    struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	const struct ethhdr *hdr = eth_hdr(skb);
+	__be16 *tag;
+	u16 val;
+
+	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
+		return NULL;
+
+	tag = skb_put(skb, LAN937X_EGRESS_TAG_LEN);
+
+	val = BIT(dp->index);
+
+	if (is_link_local_ether_addr(hdr->h_dest))
+		val |= LAN937X_TAIL_TAG_BLOCKING_OVERRIDE;
+
+	/* Tail tag valid bit - This bit should always be set by the CPU */
+	val |= LAN937X_TAIL_TAG_VALID;
+
+	put_unaligned_be16(val, tag);
+
+	return skb;
+}
+
+static const struct dsa_device_ops lan937x_netdev_ops = {
+	.name	= "lan937x",
+	.proto	= DSA_TAG_PROTO_LAN937X,
+	.xmit	= lan937x_xmit,
+	.rcv	= ksz9477_rcv,
+	.needed_tailroom = LAN937X_EGRESS_TAG_LEN,
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

