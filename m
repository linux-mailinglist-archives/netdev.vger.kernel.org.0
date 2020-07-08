Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7DA21873A
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 14:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbgGHM0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 08:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729168AbgGHM0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 08:26:12 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58EDC08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 05:26:11 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id r19so2949759ljn.12
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 05:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yRcWB5FaQnDZXbiUdscmBjCjWbXuxtFWTfNfhgIFsjs=;
        b=Wea/Bhm7slzAFfmDzBfttlqHklvdySwqLunJ1buN9L0iiuluMs0eFxjNqKqaZfgd/P
         QEG+Ded9Y9/6DQwZq1gVo98DEeOTJE51Lq/WM+IP0gs42wOc0Uaj0L3bkv49CW4z6MRK
         ZSSxrAOsULC2X1ORws6MgSygztNLVJsWnDKdX4i5TYAVoNGKlhubqBqFFGQxmcEvmBGx
         QkzoTqcWalMbepaL/IaDe2u08nD/8A9FuPsN8n1XbyPc2p7TJ1Ru3FZRnAReyByHRHX5
         YYBIeAr27C/F/P97FARrViaL6BA+N4Tjf2dAosPvSoi09IicoZ7zN8O1qeHvQcoKsFHZ
         1z/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yRcWB5FaQnDZXbiUdscmBjCjWbXuxtFWTfNfhgIFsjs=;
        b=O2S+WINo6m8VD/SqJMkeSqlLF/ZF++4hwX8wPH3qFV4JudSatbKGfN1YrQxFmDp94s
         xsMhNFtgWDZm656/9Ozqx98HWKHETnzTrkWLQD+6LJXOZ0J12t/GTkXW9Ijuh/4baf67
         mW4RqjSx/RPYkzCelLcjC/of8aJ7HDR65PeQ21W/oUYBmOxEPgzntfr/OeXKpnXKPnu7
         5KZPECGpkFoQOPZoHOv8yzdBe+625Ay+9HHZn1Tb/QgVsa4EywtymuwOXR5kzIwOnEJn
         22og3E9XBpjaujpq+GahmL88NAIDNUj5mrLJnb0o26221Rm93f/Dk5QIW7bNXlws0FnU
         H64g==
X-Gm-Message-State: AOAM531ot9HA96Gzv4TGJ1x2NX1IlP/mQdzS+xE7r4QQJCpy5GXFLxZg
        fdOff1m5nP7ITzOSt1hxED25hA==
X-Google-Smtp-Source: ABdhPJwRBZw6SbUYNi74bT6H2VWOOUSdh0RqE7RNI/6lKKThMPE1Ge4u4/zoA4d/Q20xpsds6UzIOw==
X-Received: by 2002:a05:651c:106f:: with SMTP id y15mr35184667ljm.32.1594211169922;
        Wed, 08 Jul 2020 05:26:09 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id q128sm874934ljb.140.2020.07.08.05.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:26:09 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [net-next PATCH 2/2 v6] net: dsa: rtl8366rb: Support the CPU DSA tag
Date:   Wed,  8 Jul 2020 14:25:37 +0200
Message-Id: <20200708122537.1341307-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200708122537.1341307-1-linus.walleij@linaro.org>
References: <20200708122537.1341307-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This activates the support to use the CPU tag to properly
direct ingress traffic to the right port.

Bit 15 in register RTL8368RB_CPU_CTRL_REG can be set to
1 to disable the insertion of the CPU tag which is what
the code currently does. The bit 15 define calls this
setting RTL8368RB_CPU_INSTAG which is confusing since the
inverse meaning is implied: programmers may think that
setting this bit to 1 will *enable* inserting the tag
rather than disabling it, so rename this setting in
bit 15 to RTL8368RB_CPU_NO_TAG which is more to the
point.

After this e.g. ping works out-of-the-box with the
RTL8366RB.

Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v5->v6:
- Collect Florian's review tag.
ChangeLog v4->v5:
- Split tagging support from the VLAN fix-ups.
ChangeLog v3->v4:
- Resend with the rest
ChangeLog v2->v3:
- Fix up the commit message.
- Collect Andrew's review tag.
ChangeLog v1->v2:
- Update the commit message to explain why we are renaming
  bit 15 in RTL8368RB_CPU_CTRL_REG.
---
 drivers/net/dsa/Kconfig     |  1 +
 drivers/net/dsa/rtl8366rb.c | 31 ++++++++-----------------------
 2 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index d0024cb30a7b..468b3c4273c5 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -70,6 +70,7 @@ config NET_DSA_QCA8K
 config NET_DSA_REALTEK_SMI
 	tristate "Realtek SMI Ethernet switch family support"
 	depends on NET_DSA
+	select NET_DSA_TAG_RTL4_A
 	select FIXED_PHY
 	select IRQ_DOMAIN
 	select REALTEK_PHY
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index fd1977590cb4..48f1ff746799 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -109,8 +109,8 @@
 /* CPU port control reg */
 #define RTL8368RB_CPU_CTRL_REG		0x0061
 #define RTL8368RB_CPU_PORTS_MSK		0x00FF
-/* Enables inserting custom tag length/type 0x8899 */
-#define RTL8368RB_CPU_INSTAG		BIT(15)
+/* Disables inserting custom tag length/type 0x8899 */
+#define RTL8368RB_CPU_NO_TAG		BIT(15)
 
 #define RTL8366RB_SMAR0			0x0070 /* bits 0..15 */
 #define RTL8366RB_SMAR1			0x0071 /* bits 16..31 */
@@ -844,16 +844,14 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	/* Enable CPU port and enable inserting CPU tag
+	/* Enable CPU port with custom DSA tag 8899.
 	 *
-	 * Disabling RTL8368RB_CPU_INSTAG here will change the behaviour
-	 * of the switch totally and it will start talking Realtek RRCP
-	 * internally. It is probably possible to experiment with this,
-	 * but then the kernel needs to understand and handle RRCP first.
+	 * If you set RTL8368RB_CPU_NO_TAG (bit 15) in this registers
+	 * the custom tag is turned off.
 	 */
 	ret = regmap_update_bits(smi->map, RTL8368RB_CPU_CTRL_REG,
 				 0xFFFF,
-				 RTL8368RB_CPU_INSTAG | BIT(smi->cpu_port));
+				 BIT(smi->cpu_port));
 	if (ret)
 		return ret;
 
@@ -967,21 +965,8 @@ static enum dsa_tag_protocol rtl8366_get_tag_protocol(struct dsa_switch *ds,
 						      int port,
 						      enum dsa_tag_protocol mp)
 {
-	/* For now, the RTL switches are handled without any custom tags.
-	 *
-	 * It is possible to turn on "custom tags" by removing the
-	 * RTL8368RB_CPU_INSTAG flag when enabling the port but what it
-	 * does is unfamiliar to DSA: ethernet frames of type 8899, the Realtek
-	 * Remote Control Protocol (RRCP) start to appear on the CPU port of
-	 * the device. So this is not the ordinary few extra bytes in the
-	 * frame. Instead it appears that the switch starts to talk Realtek
-	 * RRCP internally which means a pretty complex RRCP implementation
-	 * decoding and responding the RRCP protocol is needed to exploit this.
-	 *
-	 * The OpenRRCP project (dormant since 2009) have reverse-egineered
-	 * parts of the protocol.
-	 */
-	return DSA_TAG_PROTO_NONE;
+	/* This switch uses the 4 byte protocol A Realtek DSA tag */
+	return DSA_TAG_PROTO_RTL4_A;
 }
 
 static void rtl8366rb_adjust_link(struct dsa_switch *ds, int port,
-- 
2.26.2

