Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68010215051
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 01:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgGEXQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 19:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727970AbgGEXQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 19:16:01 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DC2C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 16:16:00 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id h19so43255884ljg.13
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 16:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9urUuGoORWbCOM0jkz2zh+XTET/vU9d85Qc/lpKrzv0=;
        b=bVj34Ewr3hMMHRFBbN1An0NJ2uYuqwrTIJWdUYGx/iXXprxElZ6eCdGEYO3jCbVDwN
         yD3+7m7HdRXjed/v/ix59mxt7xP8YDTM6gPtT7yMJA3pR4RH/jeazq8iGAVOpt3+YcAC
         gziMSIQM21vdQ/CuItW3U+xhJVQ9WqsjmmI9T0o3fRJhbMZeno9il8iOMcd35Tcm8vEc
         wvaCzsAr4obbWYu9MHE//xm4Y5QLPTM5apnamzE7KO/y9db7utOMrLQIeZbqSINju3xY
         9TUqCSSJGLO1CPz6m3QhR9WXd8VgunoChW0ZFnwNq5uvoQFjD9Zgjl93P9uT5N044kEy
         PY9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9urUuGoORWbCOM0jkz2zh+XTET/vU9d85Qc/lpKrzv0=;
        b=MgEr5hn7ZLzdLGEpeXm9y6aMHIPSIR+9W+hRcqfps2r8HCVlrwQTn/0f42C5nF0fbq
         +7sYD4lfomQDFPe7aoSboBKyEiUG+17B+BjDVKyXNHdkXYKxznMrol2TJlGGaeXVIvlY
         1Kq1kpM0SPNpo2xruIm/hPLI1AHaa4y+AHyTJgrwpmu1gOCIU9h1q9oNb7WyNXg5Xm3M
         j6MyGMo55GBjplNLe5pBWBl0RSGTPHorx8QIXL9m/CcMkhcA/LtFkZiDzWLG6ayKIMjb
         67G0RQw4YHWraXKjAKU+pTyB6MzD8AIlCKdNX3RVKtgb0UAN/cUMXWlyGKNisI0uKeFs
         rA9Q==
X-Gm-Message-State: AOAM531/ymH03nqvbi5AY3XTiaSJSfsVMDQ+eeKP+V7YswkHcPN6zySV
        aWYCrnOTEnt1ysiiySrI7Gsatg==
X-Google-Smtp-Source: ABdhPJye0Z7TZt0odpv4XNaqI/Tvil32sdbndYRksj0ytE7bG5QJs3oJPrte9Yk2wm26uGUD2HGfUA==
X-Received: by 2002:a2e:8597:: with SMTP id b23mr9796197lji.338.1593990959162;
        Sun, 05 Jul 2020 16:15:59 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id f14sm8439410lfa.35.2020.07.05.16.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 16:15:58 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [net-next PATCH 2/5 v3] net: dsa: rtl8366rb: Support the CPU DSA tag
Date:   Mon,  6 Jul 2020 01:15:47 +0200
Message-Id: <20200705231550.77946-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200705231550.77946-1-linus.walleij@linaro.org>
References: <20200705231550.77946-1-linus.walleij@linaro.org>
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
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
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

