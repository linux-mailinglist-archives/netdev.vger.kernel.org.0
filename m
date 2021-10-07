Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5176B42565E
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 17:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242299AbhJGPOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 11:14:40 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:28924 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242433AbhJGPOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 11:14:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1633619562; x=1665155562;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H1UIbJWoNOil2Qjrexlefz6DZHEDJ3q3dYgW3iEel/k=;
  b=KhUfO37XRvOkXo2tkPjQFmWpXV8195D2oFhxWxPhVgzzbIjQqRs6T5F/
   jzTgu2z4x9Rldt40f2ZFHm+pOZmhx71j6Vrx9Gw3OqCAeK6+dueJZviFV
   WutUuqQHooLEigephJ989MuT6x6ApmBRf3wlsVFZutPl92Ov1UOkJoKzk
   Rqe5x7fBbyMEaBjsBk3K5wbQcHGza3b6J/idibgCPM+Hk476CM/w+1vu+
   a4wQ6ed+jPM6D815mWmvcWKu4z7hRak/neNdnv99YEck0kULM2FbWKHbY
   3wjOUcvnc19afjGCUBwIpuGi4RhWfKXnjszZAT16UIAAi/HNEY+WYShXU
   w==;
IronPort-SDR: c7nemmXUnBVYGC+7LtMNrNYlknsdIE17u/C9Ef5Q1Jx9+oceqEnhWOQC/jiUmOKZyQnxEjLixl
 bUYBheXCreLdr35vOwP3Dsw9FTnd3uxZWelCkZviGWO1AZ83daAOiwS/oVwHo+ARVwCQlxMfEq
 CUPVf7E4C8piBc5WN8CroyJdYoeY3gpnavsR4PmbwmtQT50aqMctVIB4iNQfGKtxQlYjx+gar7
 iAT2t/jqB1Mjwng3vel0dYVw69qrnWujNxGBuV95j3pdNWgTCf0l1+zOUqPE6cytJGWyC8hipB
 rPX2sB4NxCVSf81ZDw3mJbKC
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="138836816"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Oct 2021 08:12:41 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 7 Oct 2021 08:12:40 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 7 Oct 2021 08:12:33 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v4 net-next 04/10] net: dsa: tag_ksz: add tag handling for Microchip LAN937x
Date:   Thu, 7 Oct 2021 20:41:54 +0530
Message-ID: <20211007151200.748944-5-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
References: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
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
 net/dsa/tag_ksz.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index d784e76113b8..0b5eda0021e7 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -51,6 +51,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_SEVILLE_VALUE		21
 #define DSA_TAG_PROTO_BRCM_LEGACY_VALUE		22
 #define DSA_TAG_PROTO_SJA1110_VALUE		23
+#define DSA_TAG_PROTO_LAN937X_VALUE		24
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -77,6 +78,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_OCELOT_8021Q	= DSA_TAG_PROTO_OCELOT_8021Q_VALUE,
 	DSA_TAG_PROTO_SEVILLE		= DSA_TAG_PROTO_SEVILLE_VALUE,
 	DSA_TAG_PROTO_SJA1110		= DSA_TAG_PROTO_SJA1110_VALUE,
+	DSA_TAG_PROTO_LAN937X		= DSA_TAG_PROTO_LAN937X_VALUE,
 };
 
 struct dsa_switch;
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index bca1b5d66df2..f728e60e0bd3 100644
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
 
 config NET_DSA_TAG_RTL4_A
 	tristate "Tag driver for Realtek 4 byte protocol A tags"
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

