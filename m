Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 652384AFF0F
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiBIVOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:14:20 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbiBIVOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:14:17 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B7DC10369C
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:14:17 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id x193so3947922oix.0
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 13:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0r5PuTUOAuiFN7mjQ/nuYeWmmj9tWlQyEc4lQV3nS90=;
        b=I7JncBASS3XwpAwlFfRkifkBay3t/kX27Bpek8i/qI1dqBHeHC8j0EKq3tMrUPeQoi
         GvWHEYjMemajJJvu+/8/O5XukhWlsTiRERkjqzSXcU5IN8pZFGmypncDFgwYFdUwROt4
         qr7cmujW5rMoeNnwLO+kqFO7zrrCpZgy3644jceoO7YCOB782Hk68RsPN2lOw3x8CZGy
         w8lVRs/5tRtXYtMD5fwlyrP5Fa6fb9osfKvzaAk1h/IzTnIZE/iRPsE4nwyYx2V6RSVW
         qXpS6DAyI0nUwjxhqfkSrTGzo9/pGNYRW8O5tpzNptGb1VppSH472HkyJu4o6ECgZHsJ
         KO6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0r5PuTUOAuiFN7mjQ/nuYeWmmj9tWlQyEc4lQV3nS90=;
        b=IA68Zk1oyp6ByGviPdUOQfT5Pd0zfruxPkb1EslLDC0geVF4uvrneSMevrWQeCtqtP
         V9OeJabKQicApSh7B4VuWalbusAfM7OK//N4cEReDmxvwfw0iMZ/sQusUKGGl+mR9LH4
         VGCIs5uFQX+wXG0mZU+SLX3/E+eu5Pc+XjC75gyvjC4jTBAlu/ckbYfwlRAmDnzsSMMq
         YWf2QXfYhlCqIO8KXaQCV+kapURvaELf2jc/c1KaE2Kp1IYX1HwPD+fMrYsnWxn8gWpA
         ICuFelZuJgfxQL6ZGrLrnHqbLXctN2xfUkC/KdVODSoXzN8QZj9zqAJcFAVfo0cjFEcG
         PrVQ==
X-Gm-Message-State: AOAM533Wps3HrNPuWRdT1RiuU3nFvhQQtJWabEOBczQPWY2pmPbQIXaf
        rpxiXd6eTTRdeYaF/mzZ8PsMYjTtKVDw6Q==
X-Google-Smtp-Source: ABdhPJxQK1S+v3EpzHm+B5WBl5G4pULPNz0dPJJgyqL0ZhKOofCzCgaCLVwEokXaYamKUqZmQECIpQ==
X-Received: by 2002:a05:6808:2386:: with SMTP id bp6mr2241245oib.152.1644441256540;
        Wed, 09 Feb 2022 13:14:16 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id n9sm6899945otf.9.2022.02.09.13.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 13:14:15 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next 2/2] net: dsa: realtek: rtl8365mb: add support for rtl8_4t
Date:   Wed,  9 Feb 2022 18:13:12 -0300
Message-Id: <20220209211312.7242-3-luizluca@gmail.com>
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

The tailing tag is also supported by this family. The default is still
rtl8_4 but now the switch supports changing the tag to rtl8_4t.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 63 +++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index e0c7f64bc56f..02d1521887ae 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -853,9 +853,70 @@ static enum dsa_tag_protocol
 rtl8365mb_get_tag_protocol(struct dsa_switch *ds, int port,
 			   enum dsa_tag_protocol mp)
 {
+	struct realtek_priv *priv = ds->priv;
+	u32 val;
+
+	/* No way to return error */
+	regmap_read(priv->map, RTL8365MB_CPU_CTRL_REG, &val);
+
+	switch (FIELD_GET(RTL8365MB_CPU_CTRL_TAG_FORMAT_MASK, val)) {
+	case RTL8365MB_CPU_FORMAT_4BYTES:
+		/* Similar to DSA_TAG_PROTO_RTL4_A but with 1-byte version
+		 * To CPU: [0x88 0x99 0x04 portnum]. Not supported yet.
+		 */
+		break;
+	case RTL8365MB_CPU_FORMAT_8BYTES:
+		switch (FIELD_GET(RTL8365MB_CPU_CTRL_TAG_POSITION_MASK, val)) {
+		case RTL8365MB_CPU_POS_BEFORE_CRC:
+			return DSA_TAG_PROTO_RTL8_4T;
+		case RTL8365MB_CPU_POS_AFTER_SA:
+		default:
+			return DSA_TAG_PROTO_RTL8_4;
+		}
+		break;
+	}
+
 	return DSA_TAG_PROTO_RTL8_4;
 }
 
+static int rtl8365mb_change_tag_protocol(struct dsa_switch *ds, int cpu,
+					 enum dsa_tag_protocol proto)
+{
+	struct realtek_priv *priv = ds->priv;
+	int tag_position;
+	int tag_format;
+	int ret;
+
+	switch (proto) {
+	case DSA_TAG_PROTO_RTL8_4:
+		tag_format = RTL8365MB_CPU_FORMAT_8BYTES;
+		tag_position = RTL8365MB_CPU_POS_AFTER_SA;
+		break;
+	case DSA_TAG_PROTO_RTL8_4T:
+		tag_format = RTL8365MB_CPU_FORMAT_8BYTES;
+		tag_position = RTL8365MB_CPU_POS_BEFORE_CRC;
+		break;
+	/* The switch also supports a 4-byte format, similar to rtl4a but with
+	 * the same 0x04 8-bit version and probably 8-bit port source/dest.
+	 * There is no public doc about it. Not supported yet.
+	 */
+	default:
+		return -EPROTONOSUPPORT;
+	}
+
+	ret = regmap_update_bits(priv->map, RTL8365MB_CPU_CTRL_REG,
+				 RTL8365MB_CPU_CTRL_TAG_POSITION_MASK |
+				 RTL8365MB_CPU_CTRL_TAG_FORMAT_MASK,
+				 FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_POSITION_MASK,
+					    tag_position) |
+				 FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_FORMAT_MASK,
+					    tag_format));
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
 				      phy_interface_t interface)
 {
@@ -2079,6 +2140,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 
 static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
 	.get_tag_protocol = rtl8365mb_get_tag_protocol,
+	.change_tag_protocol = rtl8365mb_change_tag_protocol,
 	.setup = rtl8365mb_setup,
 	.teardown = rtl8365mb_teardown,
 	.phylink_get_caps = rtl8365mb_phylink_get_caps,
@@ -2097,6 +2159,7 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
 
 static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
 	.get_tag_protocol = rtl8365mb_get_tag_protocol,
+	.change_tag_protocol = rtl8365mb_change_tag_protocol,
 	.setup = rtl8365mb_setup,
 	.teardown = rtl8365mb_teardown,
 	.phylink_get_caps = rtl8365mb_phylink_get_caps,
-- 
2.35.1

