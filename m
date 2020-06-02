Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336191EC411
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 22:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgFBUz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 16:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbgFBUzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 16:55:25 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F8DC08C5C0
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 13:55:25 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id w15so7007018lfe.11
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 13:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mSZdHFH4Bx0kIRim8XPkE3hmIfXGRjFDDYswlMmM/WE=;
        b=CYlPDe5zKmPnSuADU51Lo9aFvDegDXUS635rDXYbsA3DCd+cbpDubEUrcfwL22O1w2
         xC2ng04rB7MZ6O34hCBDQGN4OtNxqKI1jsRtMyQPOZJFhsHt4nBLfs4tAaRy1DUgW40P
         //3z/GX5op6ky0gMf4OA24WAINxli6zOQMmw4c/fWFBZ6Gsv1x172AMqTwdnWoIk1peM
         9Lm158ZFMkFy1TAyXsft3N9sryllo4GzPBHJzHxSm8hB6jlxlVebdb6lfDZw3Srjez3m
         zq3lIEYRlgGS8994k59X8QhBouaEn/rbFNeYxqLR+Cudv+Fl0xtnsLULz6Fh0i6pjvPh
         gvhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mSZdHFH4Bx0kIRim8XPkE3hmIfXGRjFDDYswlMmM/WE=;
        b=SexbMWH07x5FdvH0AyImd4TbpQ9C2utCgqrtaDS0rE48o+RERzr3TX9sn1D4g1Oq/W
         N+hmUkyPSpWms6vqE1by2TZ6FIrRn1dl9xRQHDgiqCU/czYYHkQP+KRKu/wN7rvqYl3P
         6XxyhfvroZg2BodHarWdDRFjkxUjMHg1JMyAP4Ef+nli/zGDs7mxIS2+UrWyCrFwNv7s
         2KntPaE1mSBed5fc+eHB/cCKejxjQ0mLiKPpBqB95H1s2AKnotNOuGS2P8ZMapev4LBY
         /gkJpcJ4gszZ/cXb16j2OJXol1ndhoxVtbtAccRMyM4mGNiIFdYDPDGFJp0n2FI52oEz
         KGvQ==
X-Gm-Message-State: AOAM531jWkCuD4mkKtPEBdqCUtASiEIfwNKEH+Ht58qd/3kNGBj4WyPr
        UrJXYxQcrJTOVUaoLUt6JpD21Q==
X-Google-Smtp-Source: ABdhPJzgg4vDjuyM1nULWi0wN5qNgf8AWay5c19LIbOMWBOLIltlvAqQ40lH7hz6pMIcCf0ZTCqeLg==
X-Received: by 2002:ac2:4a75:: with SMTP id q21mr607210lfp.190.1591131323574;
        Tue, 02 Jun 2020 13:55:23 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-8cdb225c.014-348-6c756e10.bbcust.telenor.se. [92.34.219.140])
        by smtp.gmail.com with ESMTPSA id t5sm41962lff.39.2020.06.02.13.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 13:55:22 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [net-next PATCH 2/5] net: dsa: rtl8366rb: Support the CPU DSA tag
Date:   Tue,  2 Jun 2020 22:54:53 +0200
Message-Id: <20200602205456.2392024-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200602205456.2392024-1-linus.walleij@linaro.org>
References: <20200602205456.2392024-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This activates the support to use the CPU tag to properly
direct ingress traffic to the right port.

After this e.g. ping works out-of-the-box with the
RTL8366RB.

Cc: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/Kconfig     |  1 +
 drivers/net/dsa/rtl8366rb.c | 31 ++++++++-----------------------
 2 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 2d38dbc9dd8c..3a4485651f1d 100644
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

