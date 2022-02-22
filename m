Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372424C04DE
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 23:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236147AbiBVWtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 17:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbiBVWtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 17:49:10 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F2F132979
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 14:48:44 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id 189-20020a4a03c6000000b003179d7b30d8so19798917ooi.2
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 14:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RqUc8fD+HHtM8kdUtKtgqezvjPTrevAz75LlGqQji4k=;
        b=NUdKMLcJxKZoThV/K06TcFaI6faQqL1Td9lwyB6dsgeC6TqSmZSFG11ZsEQc/gNBe0
         6dPT+iGnUseTHNbYjSR0RS8o/zX4MhHj2Z7fjeoUP7t2RxQHXG1dWOmfoaZCSJFkW4i3
         HvLXK/emyy3tc56gt0hoEQe7HSad2pUMbqrX31tlaaTfCTZxo5/jEZVQLMzS+4feUPYT
         yJpPBadYXysAir1RjoQU1FgNp1LLZ5/y7alQDKJaROSq8FMAaiZkDeOjZvNcSjFxekBh
         2wH52+y67L7F8Yvx1/7vG2Wde8IA650qMhIKnsMJHTf69rWf8jUQHnOdvgOReoKghyRD
         0QVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RqUc8fD+HHtM8kdUtKtgqezvjPTrevAz75LlGqQji4k=;
        b=WqeV7X9xerNoWNsVSsNZNLahpyRjVJNO4OM1rJLgqZs+Hq1fddvnxbiLeZuccq8nR+
         VQjOHYxafPrpFCxhBqQLPz1tmWlTNmAQUaVX44KrG1M0HHTB0xmKXalN2t2XG96wKnGi
         mFnOdsdULzcsJzUgy2+jben2MlH7oRsCmDcyAPRBECpc2hCA2cI/Mq35LGn6nqf/zI9z
         uSQzbiJFmYWAOhRuq+h91WyEingIf56yKZFzo+OBUUXfsSFGHB2oC5m08Nr9ycrB5hpz
         1HqyLjXAox2zByCleUOuU+ezOHIqsWcfS8UhFoLKGjH+Q2ng5OjECd0GIGLUMPi8qla6
         tC6g==
X-Gm-Message-State: AOAM5300GWE0aR48E6e9lXGmLgPwISbGpAzcdBc2V0LQS11jlvFpX/UR
        fMAS46AX3hXJC/bkugY/dN84DtnqdlTGoA==
X-Google-Smtp-Source: ABdhPJzAgecbJ6jyy1YtAaT6fWKx7FL7bCdcjaQmbS1O3Tfy6Js/z1K8JyMvXRM5VfI/u1DeB931Pw==
X-Received: by 2002:a05:6870:ed89:b0:c6:3f95:8f53 with SMTP id fz9-20020a056870ed8900b000c63f958f53mr2699727oab.269.1645570123393;
        Tue, 22 Feb 2022 14:48:43 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id c9sm7033380otd.26.2022.02.22.14.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 14:48:42 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v3 1/2] net: dsa: tag_rtl8_4: add rtl8_4t trailing variant
Date:   Tue, 22 Feb 2022 19:47:57 -0300
Message-Id: <20220222224758.11324-2-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220222224758.11324-1-luizluca@gmail.com>
References: <20220222224758.11324-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Realtek switches supports the same tag both before ethertype or between
payload and the CRC.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 include/net/dsa.h    |   2 +
 net/dsa/tag_rtl8_4.c | 154 +++++++++++++++++++++++++++++++++----------
 2 files changed, 121 insertions(+), 35 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index fd1f62a6e0a8..b688ced04b0e 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -52,6 +52,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_BRCM_LEGACY_VALUE		22
 #define DSA_TAG_PROTO_SJA1110_VALUE		23
 #define DSA_TAG_PROTO_RTL8_4_VALUE		24
+#define DSA_TAG_PROTO_RTL8_4T_VALUE		25
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -79,6 +80,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_SEVILLE		= DSA_TAG_PROTO_SEVILLE_VALUE,
 	DSA_TAG_PROTO_SJA1110		= DSA_TAG_PROTO_SJA1110_VALUE,
 	DSA_TAG_PROTO_RTL8_4		= DSA_TAG_PROTO_RTL8_4_VALUE,
+	DSA_TAG_PROTO_RTL8_4T		= DSA_TAG_PROTO_RTL8_4T_VALUE,
 };
 
 struct dsa_switch;
diff --git a/net/dsa/tag_rtl8_4.c b/net/dsa/tag_rtl8_4.c
index 02686ad4045d..2e81ab49d928 100644
--- a/net/dsa/tag_rtl8_4.c
+++ b/net/dsa/tag_rtl8_4.c
@@ -9,11 +9,6 @@
  *
  * This tag header has the following format:
  *
- *  -------------------------------------------
- *  | MAC DA | MAC SA | 8 byte tag | Type | ...
- *  -------------------------------------------
- *     _______________/            \______________________________________
- *    /                                                                   \
  *  0                                  7|8                                 15
  *  |-----------------------------------+-----------------------------------|---
  *  |                               (16-bit)                                | ^
@@ -58,6 +53,28 @@
  *    TX/RX      | TX (switch->CPU): port number the packet was received on
  *               | RX (CPU->switch): forwarding port mask (if ALLOW=0)
  *               |                   allowance port mask (if ALLOW=1)
+ *
+ * The tag can be positioned before Ethertype, using tag "rtl8_4":
+ *
+ *  +--------+--------+------------+------+-----
+ *  | MAC DA | MAC SA | 8 byte tag | Type | ...
+ *  +--------+--------+------------+------+-----
+ *
+ * If checksum offload is enabled for CPU port device, it might break if the
+ * driver does not use csum_start/csum_offset.
+ *
+ * The tag can also appear between the end of the payload and before the CRC,
+ * using tag "rtl8_4t":
+ *
+ * +--------+--------+------+-----+---------+------------+-----+
+ * | MAC DA | MAC SA | TYPE | ... | payload | 8-byte tag | CRC |
+ * +--------+--------+------+-----+---------+------------+-----+
+ *
+ * The added bytes after the payload will break most checksums, either in
+ * software or hardware. To avoid this issue, if the checksum is still pending,
+ * this tagger checksum the packet before adding the tag, rendering any
+ * checksum offload useless.
+ *
  */
 
 #include <linux/bitfield.h>
@@ -84,87 +101,133 @@
 #define RTL8_4_TX			GENMASK(3, 0)
 #define RTL8_4_RX			GENMASK(10, 0)
 
-static struct sk_buff *rtl8_4_tag_xmit(struct sk_buff *skb,
-				       struct net_device *dev)
+static void rtl8_4_write_tag(struct sk_buff *skb, struct net_device *dev,
+			     void *tag)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	__be16 *tag;
-
-	skb_push(skb, RTL8_4_TAG_LEN);
-
-	dsa_alloc_etype_header(skb, RTL8_4_TAG_LEN);
-	tag = dsa_etype_header_pos_tx(skb);
+	__be16 tag16[RTL8_4_TAG_LEN / 2];
 
 	/* Set Realtek EtherType */
-	tag[0] = htons(ETH_P_REALTEK);
+	tag16[0] = htons(ETH_P_REALTEK);
 
 	/* Set Protocol; zero REASON */
-	tag[1] = htons(FIELD_PREP(RTL8_4_PROTOCOL, RTL8_4_PROTOCOL_RTL8365MB));
+	tag16[1] = htons(FIELD_PREP(RTL8_4_PROTOCOL, RTL8_4_PROTOCOL_RTL8365MB));
 
 	/* Zero FID_EN, FID, PRI_EN, PRI, KEEP; set LEARN_DIS */
-	tag[2] = htons(FIELD_PREP(RTL8_4_LEARN_DIS, 1));
+	tag16[2] = htons(FIELD_PREP(RTL8_4_LEARN_DIS, 1));
 
 	/* Zero ALLOW; set RX (CPU->switch) forwarding port mask */
-	tag[3] = htons(FIELD_PREP(RTL8_4_RX, BIT(dp->index)));
+	tag16[3] = htons(FIELD_PREP(RTL8_4_RX, BIT(dp->index)));
+
+	memcpy(tag, tag16, RTL8_4_TAG_LEN);
+}
+
+static struct sk_buff *rtl8_4_tag_xmit(struct sk_buff *skb,
+				       struct net_device *dev)
+{
+	skb_push(skb, RTL8_4_TAG_LEN);
+
+	dsa_alloc_etype_header(skb, RTL8_4_TAG_LEN);
+
+	rtl8_4_write_tag(skb, dev, dsa_etype_header_pos_tx(skb));
 
 	return skb;
 }
 
-static struct sk_buff *rtl8_4_tag_rcv(struct sk_buff *skb,
-				      struct net_device *dev)
+static struct sk_buff *rtl8_4t_tag_xmit(struct sk_buff *skb,
+					struct net_device *dev)
 {
-	__be16 *tag;
+	/* Calculate the checksum here if not done yet as trailing tags will
+	 * break either software and hardware based checksum
+	 */
+	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
+		return NULL;
+
+	rtl8_4_write_tag(skb, dev, skb_put(skb, RTL8_4_TAG_LEN));
+
+	return skb;
+}
+
+static int rtl8_4_read_tag(struct sk_buff *skb, struct net_device *dev,
+			   void *tag)
+{
+	__be16 tag16[RTL8_4_TAG_LEN / 2];
 	u16 etype;
 	u8 reason;
 	u8 proto;
 	u8 port;
 
-	if (unlikely(!pskb_may_pull(skb, RTL8_4_TAG_LEN)))
-		return NULL;
-
-	tag = dsa_etype_header_pos_rx(skb);
+	memcpy(tag16, tag, RTL8_4_TAG_LEN);
 
 	/* Parse Realtek EtherType */
-	etype = ntohs(tag[0]);
+	etype = ntohs(tag16[0]);
 	if (unlikely(etype != ETH_P_REALTEK)) {
 		dev_warn_ratelimited(&dev->dev,
 				     "non-realtek ethertype 0x%04x\n", etype);
-		return NULL;
+		return -EPROTO;
 	}
 
 	/* Parse Protocol */
-	proto = FIELD_GET(RTL8_4_PROTOCOL, ntohs(tag[1]));
+	proto = FIELD_GET(RTL8_4_PROTOCOL, ntohs(tag16[1]));
 	if (unlikely(proto != RTL8_4_PROTOCOL_RTL8365MB)) {
 		dev_warn_ratelimited(&dev->dev,
 				     "unknown realtek protocol 0x%02x\n",
 				     proto);
-		return NULL;
+		return -EPROTO;
 	}
 
 	/* Parse REASON */
-	reason = FIELD_GET(RTL8_4_REASON, ntohs(tag[1]));
+	reason = FIELD_GET(RTL8_4_REASON, ntohs(tag16[1]));
 
 	/* Parse TX (switch->CPU) */
-	port = FIELD_GET(RTL8_4_TX, ntohs(tag[3]));
+	port = FIELD_GET(RTL8_4_TX, ntohs(tag16[3]));
 	skb->dev = dsa_master_find_slave(dev, 0, port);
 	if (!skb->dev) {
 		dev_warn_ratelimited(&dev->dev,
 				     "could not find slave for port %d\n",
 				     port);
-		return NULL;
+		return -ENOENT;
 	}
 
+	if (reason != RTL8_4_REASON_TRAP)
+		dsa_default_offload_fwd_mark(skb);
+
+	return 0;
+}
+
+static struct sk_buff *rtl8_4_tag_rcv(struct sk_buff *skb,
+				      struct net_device *dev)
+{
+	if (unlikely(!pskb_may_pull(skb, RTL8_4_TAG_LEN)))
+		return NULL;
+
+	if (unlikely(rtl8_4_read_tag(skb, dev, dsa_etype_header_pos_rx(skb))))
+		return NULL;
+
 	/* Remove tag and recalculate checksum */
 	skb_pull_rcsum(skb, RTL8_4_TAG_LEN);
 
 	dsa_strip_etype_header(skb, RTL8_4_TAG_LEN);
 
-	if (reason != RTL8_4_REASON_TRAP)
-		dsa_default_offload_fwd_mark(skb);
+	return skb;
+}
+
+static struct sk_buff *rtl8_4t_tag_rcv(struct sk_buff *skb,
+				       struct net_device *dev)
+{
+	if (skb_linearize(skb))
+		return NULL;
+
+	if (unlikely(rtl8_4_read_tag(skb, dev, skb_tail_pointer(skb) - RTL8_4_TAG_LEN)))
+		return NULL;
+
+	if (pskb_trim_rcsum(skb, skb->len - RTL8_4_TAG_LEN))
+		return NULL;
 
 	return skb;
 }
 
+/* Ethertype version */
 static const struct dsa_device_ops rtl8_4_netdev_ops = {
 	.name = "rtl8_4",
 	.proto = DSA_TAG_PROTO_RTL8_4,
@@ -172,7 +235,28 @@ static const struct dsa_device_ops rtl8_4_netdev_ops = {
 	.rcv = rtl8_4_tag_rcv,
 	.needed_headroom = RTL8_4_TAG_LEN,
 };
-module_dsa_tag_driver(rtl8_4_netdev_ops);
 
-MODULE_LICENSE("GPL");
+DSA_TAG_DRIVER(rtl8_4_netdev_ops);
+
 MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4);
+
+/* Tail version */
+static const struct dsa_device_ops rtl8_4t_netdev_ops = {
+	.name = "rtl8_4t",
+	.proto = DSA_TAG_PROTO_RTL8_4T,
+	.xmit = rtl8_4t_tag_xmit,
+	.rcv = rtl8_4t_tag_rcv,
+	.needed_tailroom = RTL8_4_TAG_LEN,
+};
+
+DSA_TAG_DRIVER(rtl8_4t_netdev_ops);
+
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4L);
+
+static struct dsa_tag_driver *dsa_tag_drivers[] = {
+	&DSA_TAG_DRIVER_NAME(rtl8_4_netdev_ops),
+	&DSA_TAG_DRIVER_NAME(rtl8_4t_netdev_ops),
+};
+module_dsa_tag_drivers(dsa_tag_drivers);
+
+MODULE_LICENSE("GPL");
-- 
2.35.1

