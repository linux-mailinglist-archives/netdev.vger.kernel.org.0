Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1304A4BB1D3
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 07:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbiBRGLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 01:11:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbiBRGLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 01:11:12 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF2C193E8
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 22:10:56 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id s8so2010388oij.13
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 22:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EqCtZuqC6c5dM19mL2gTsra8fI657Qf2ZpsMBOgNsrQ=;
        b=aDtCDKBnQmM4XhOQ7ghvaMXT9Xm1vmuTKxXhF+J7GWDyBKI6ZIX++VzDGbjvja/Xuq
         7lyKgeTiqndqAlR5FPXrQEPrGY4IvyXxyfk6dolhQtA/DLaYDXhoieIcS+VZqdPk4pgU
         mcB4NrPXnxof9D1LpmsSCbJhPz/2tsxNk6YOzHQSI2nJVKiZvlmsUgZpvlL1brBS094h
         Fz1Kk2s2SlBQ8NMN3/h6dZrmddlzmTaCn/xpGNgdWOm31HPrdpA7LjbibbXjbkCZpPTU
         0yVPrjRs1yEeQiyjaiWBDy/JLbCPyhO9ykplYpP7CrTQJKklR/Y7MHK8LwoVK+8UGRFC
         XWZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EqCtZuqC6c5dM19mL2gTsra8fI657Qf2ZpsMBOgNsrQ=;
        b=xHakgmVPCtI0bA/JHZiEGZCKRiV4ubAROSR0v59zheBri2bfXM0MzArTselFcomZRP
         +YaSG3mxt6FpSP5Okt3FbnAsOIjSeVnqZ2bdl4r/SxEsCdaw/mcAofGQuEezKu8VpX54
         DyixuYudftFzSXkeixaGfXONY+DVRP8JKydCzjiEMjgpJ3m6/LgZkXwjI5xedDpbrzUQ
         hsK3dXTodJrPtgSDwyo7oZgiAN38LnBSgQEjJq2kSo29ETOgoHAmzabxTwIA72PJsXqf
         S9Ht27dPnxjZfScr/SqOPut35UdcSHDFrrCGOR3IXGJU6ou8X1MykfARPHFYiWAVp9Z0
         SUhQ==
X-Gm-Message-State: AOAM532fC7u2kXj7/XH3v6JzYF5yXcAGUVA+prGMiyghUxGNgRXcxCgI
        n6ZmTEjBySKtYLYm9LFjo2nJiXpeXvIpSw==
X-Google-Smtp-Source: ABdhPJxw8pbXuSRXRg/+26VH1Nd+cu/NaBVS6H7n6xStTP7uPHb9YDa6ChhyqgoV0T0I+C1N//LFmQ==
X-Received: by 2002:a05:6808:1b24:b0:2d4:5f02:1469 with SMTP id bx36-20020a0568081b2400b002d45f021469mr2665187oib.50.1645164655070;
        Thu, 17 Feb 2022 22:10:55 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id 9sm3125214oas.27.2022.02.17.22.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 22:10:54 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v2 1/2] net: dsa: tag_rtl8_4: add rtl8_4t trailing variant
Date:   Fri, 18 Feb 2022 03:09:58 -0300
Message-Id: <20220218060959.6631-2-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218060959.6631-1-luizluca@gmail.com>
References: <20220218060959.6631-1-luizluca@gmail.com>
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

The switch supports the same tag both before ethertype or before CRC.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 include/net/dsa.h    |   2 +
 net/dsa/tag_rtl8_4.c | 127 +++++++++++++++++++++++++++++++++----------
 2 files changed, 99 insertions(+), 30 deletions(-)

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
index 02686ad4045d..d80357cb74b0 100644
--- a/net/dsa/tag_rtl8_4.c
+++ b/net/dsa/tag_rtl8_4.c
@@ -84,87 +84,133 @@
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
+{
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
 {
-	__be16 *tag;
 	u16 etype;
 	u8 reason;
 	u8 proto;
 	u8 port;
+	__be16 tag16[RTL8_4_TAG_LEN / 2];
 
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
@@ -172,7 +218,28 @@ static const struct dsa_device_ops rtl8_4_netdev_ops = {
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

