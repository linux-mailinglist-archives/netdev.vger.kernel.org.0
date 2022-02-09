Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303944AFF0C
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbiBIVOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:14:19 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbiBIVOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:14:16 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB0FC001914
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:14:13 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id p190-20020a4a2fc7000000b0031820de484aso3955210oop.9
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 13:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2W0R4oXSwvk7S+2bhP/ex0N55F3trb01+bE8DCCjb84=;
        b=dTZHc9aB1xAzNbmZc/S4YVW+VYLDWgchWydCiXNV9r1yBR4cPm8izM1hsTa3DKZdkv
         uNCUyiQVz/+nbTHbw5Ka0yKVULMZ/Iy7SPvycIPLnu6YCc0GKHLGIp8BP/jSe9+0JIAg
         GMk2DIITg5C37vfnUCBFQnqvHcy3f8sWKH/dsBDonTMV/PiVcP1tAN3UMXKN3xetZQ9g
         X3ncoaGx+eM2DDPBy6KDH3fyh8LzHUxOh63iukijlY51RLG3El7Re+0/qp6pigmDo1RF
         53qqPvQWUTCEQkP97Flu+5Gx7zNA0zCrEHmX7oVudcZGHKu5LJt448fYHpD12o/ek7YZ
         rkSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2W0R4oXSwvk7S+2bhP/ex0N55F3trb01+bE8DCCjb84=;
        b=8MfsxvDScrHuOjIfxM0tl/uXdNmepSQOE8eQEHxoJqCl9Pk2mjN70rmUIVEE0OUaEH
         hiMLrAsvoGggnImWfDu1d+NUK5GBb205KgzaHlxElsNkxux6OrpvUnr/431WxMhAYjl+
         sHVeW5kcTCJRw/HmQm3hODY2GmVpA+O1RjoV1WtjVJR0ky6RvioL475IGlj14hLsTaod
         kHJgb6BWb2vURHHk/WNYyb5zsrrESC7VgkiR45/34A0h6LHb6E6aO0t87SHYyr8VmGk7
         aJAO395pIajqtkHlIooO4KM0Bu4CtIx8FSr276qlI07J0m/hUJO6z9EuNJZT6+2jpIq+
         JQkQ==
X-Gm-Message-State: AOAM530gWy6/Nwbn6LMMfGBvsA47ayDGl1ZeVYlx5rsukfqpzk1szp3z
        cTZ0XJIcNIqMx5kvGwnh4Er0PF+HbxuqPQ==
X-Google-Smtp-Source: ABdhPJywzK8nnFkARToRwWSa0So/OtanEIou+ZESrPyPdjT3MG1FvRXaE9vWacC4viYzUYLcAUn80Q==
X-Received: by 2002:a05:6870:6296:: with SMTP id s22mr1591374oan.231.1644441251146;
        Wed, 09 Feb 2022 13:14:11 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id n9sm6899945otf.9.2022.02.09.13.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 13:14:10 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next 1/2] net: dsa: tag_rtl8_4: add rtl8_4t tailing variant
Date:   Wed,  9 Feb 2022 18:13:11 -0300
Message-Id: <20220209211312.7242-2-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220209211312.7242-1-luizluca@gmail.com>
References: <20220209211312.7242-1-luizluca@gmail.com>
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
 net/dsa/tag_rtl8_4.c | 119 ++++++++++++++++++++++++++++++++-----------
 2 files changed, 90 insertions(+), 31 deletions(-)

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
index 02686ad4045d..a9883b0c1d51 100644
--- a/net/dsa/tag_rtl8_4.c
+++ b/net/dsa/tag_rtl8_4.c
@@ -84,87 +84,123 @@
 #define RTL8_4_TX			GENMASK(3, 0)
 #define RTL8_4_RX			GENMASK(10, 0)
 
-static struct sk_buff *rtl8_4_tag_xmit(struct sk_buff *skb,
-				       struct net_device *dev)
+static inline void rtl8_4_write_tag(struct sk_buff *skb, struct net_device *dev,
+				    char *tag)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	__be16 *tag;
-
-	skb_push(skb, RTL8_4_TAG_LEN);
-
-	dsa_alloc_etype_header(skb, RTL8_4_TAG_LEN);
-	tag = dsa_etype_header_pos_tx(skb);
+	__be16 *tag16 = (__be16 *)tag;
 
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
+	rtl8_4_write_tag(skb, dev, skb_put(skb, RTL8_4_TAG_LEN));
+
+	return skb;
+}
+
+static int rtl8_4_read_tag(struct sk_buff *skb, struct net_device *dev,
+			   char *tag)
 {
-	__be16 *tag;
 	u16 etype;
 	u8 reason;
 	u8 proto;
 	u8 port;
-
-	if (unlikely(!pskb_may_pull(skb, RTL8_4_TAG_LEN)))
-		return NULL;
-
-	tag = dsa_etype_header_pos_rx(skb);
+	__be16 *tag16 = (__be16 *)tag;
 
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
@@ -172,7 +208,28 @@ static const struct dsa_device_ops rtl8_4_netdev_ops = {
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

