Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0994230FF
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 21:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235872AbhJETvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 15:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235830AbhJETvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 15:51:09 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B10C061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 12:49:18 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id u18so476552lfd.12
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 12:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pku09rj7/VU7FTxKbOt83SUvrPCcVT0ttGrANV0CkWQ=;
        b=dBimG1esq4CMK92UHmrupXVB8h7YFyYHBsFKUQGK7zt08Wu7fEbNBp/BUyxMTmDKJT
         0nNPWDAcBz+uqekxNevz6Ryr+BYlT5KTlb7osscGCVBL33yR/J8jdO1ARXUlFKY4gi7H
         +RFl21XvOfevpZmPnMij/u+0cwRfAM5DGBQoOxBuuTuiQhD1WyBhLrSmbTTtll9fdk7n
         ZoFiEquSJLMlzUrWxJov7Ht6+rxVD5DiUPQm7+wkEWpCfogIsFgh3wzeKagNJOnr+wT0
         WfD45MLYPLaE1BFLUcJUEvzDBvht4Bf/NaHCDvRnCP42+776ZGxGnkF1hqdC/BwfZ6RU
         ILow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pku09rj7/VU7FTxKbOt83SUvrPCcVT0ttGrANV0CkWQ=;
        b=ZGsgNlbLgGktQlK5z57h/gpA3HP277up+XyyKuk9QgPRPIContT0umKVBCL4AlxVbj
         KREI5nKOtKG9UfxHKyg769AjGIvUPa7SfxudyMv7jD8t+xfym+0kQZvfPbjkgOs3sEAc
         0H4NAaNMfn/0pJfwpMYMRj/0xyl86ypgCnbO5sI6UpIxIjR/d5d1sO/tL+bDOP2F3mUh
         fWFCRy9gJiiwvbCzeICs8EzzIMD4b+BicAL5vh7K/4f9QWzsMsW2ZvRbHf17j77qRtjO
         ZJmLU6SRPcoTyT6cNge68K0wCcXj45Mj1Uq6m1gL4RGAOsROutYr1u1yYTOh3WKuDOjp
         dUvw==
X-Gm-Message-State: AOAM533JQ+ACa4Wk4JqCX81Cy0beLvKbpjPJNOsk5BcQggEm4Bovjlwe
        5XWsq3vdmXEphxydQw0oFYPKGQ==
X-Google-Smtp-Source: ABdhPJzjmya5A89pSlQzt2eG+uYlDqstfzi5q9zl5E69P0RGAQrwuiyXvkQiUo10a/s2cn1nqBpSBg==
X-Received: by 2002:a2e:544a:: with SMTP id y10mr24851671ljd.323.1633463356559;
        Tue, 05 Oct 2021 12:49:16 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id k28sm2083577ljn.57.2021.10.05.12.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 12:49:16 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH net-next 3/3 v5] net: dsa: rtl8366rb: Support setting STP state
Date:   Tue,  5 Oct 2021 21:47:04 +0200
Message-Id: <20211005194704.342329-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005194704.342329-1-linus.walleij@linaro.org>
References: <20211005194704.342329-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for setting the STP state to the RTL8366RB
DSA switch. This rids the following message from the kernel on
e.g. OpenWrt:

DSA: failed to set STP state 3 (-95)

Since the RTL8366RB has one STP state register per FID with
two bit per port in each, we simply loop over all the FIDs
and set the state on all of them.

Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v4->v5:
- Rename register from RTL8368S* to RTL8366RB as all other
  registers. (RTL8368S is some similar ASIC maybe the same.)
- Rename registers from "SPT" to "STP", we assume this is just
  a typo in the vendor tree.
- Create RTL8366RB_STP_STATE_MASK() and RTL8366RB_STP_STATE()
  macros and use these.
ChangeLog v1->v4:
- New patch after discovering that we can do really nice
  bridge offloading with these bits.
---
 drivers/net/dsa/rtl8366rb.c | 48 +++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index c78e4220ddd1..d2370cda4be0 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -110,6 +110,18 @@
 
 #define RTL8366RB_POWER_SAVING_REG	0x0021
 
+/* Spanning tree status (STP) control, two bits per port per FID */
+#define RTL8366RB_STP_STATE_BASE	0x0050 /* 0x0050..0x0057 */
+#define RTL8366RB_STP_STATE_DISABLED	0x0
+#define RTL8366RB_STP_STATE_BLOCKING	0x1
+#define RTL8366RB_STP_STATE_LEARNING	0x2
+#define RTL8366RB_STP_STATE_FORWARDING	0x3
+#define RTL8366RB_STP_MASK		GENMASK(1, 0)
+#define RTL8366RB_STP_STATE(port, state) \
+	((state) << ((port) * 2))
+#define RTL8366RB_STP_STATE_MASK(port) \
+	RTL8366RB_STP_STATE((port), RTL8366RB_STP_MASK)
+
 /* CPU port control reg */
 #define RTL8368RB_CPU_CTRL_REG		0x0061
 #define RTL8368RB_CPU_PORTS_MSK		0x00FF
@@ -234,6 +246,7 @@
 #define RTL8366RB_NUM_LEDGROUPS		4
 #define RTL8366RB_NUM_VIDS		4096
 #define RTL8366RB_PRIORITYMAX		7
+#define RTL8366RB_NUM_FIDS		8
 #define RTL8366RB_FIDMAX		7
 
 #define RTL8366RB_PORT_1		BIT(0) /* In userspace port 0 */
@@ -1308,6 +1321,40 @@ rtl8366rb_port_bridge_flags(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static void
+rtl8366rb_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
+{
+	struct realtek_smi *smi = ds->priv;
+	u32 val;
+	int i;
+
+	switch (state) {
+	case BR_STATE_DISABLED:
+		val = RTL8366RB_STP_STATE_DISABLED;
+		break;
+	case BR_STATE_BLOCKING:
+	case BR_STATE_LISTENING:
+		val = RTL8366RB_STP_STATE_BLOCKING;
+		break;
+	case BR_STATE_LEARNING:
+		val = RTL8366RB_STP_STATE_LEARNING;
+		break;
+	case BR_STATE_FORWARDING:
+		val = RTL8366RB_STP_STATE_FORWARDING;
+		break;
+	default:
+		dev_err(smi->dev, "unknown bridge state requested\n");
+		return;
+	};
+
+	/* Set the same status for the port on all the FIDs */
+	for (i = 0; i < RTL8366RB_NUM_FIDS; i++) {
+		regmap_update_bits(smi->map, RTL8366RB_STP_STATE_BASE + i,
+				   RTL8366RB_STP_STATE_MASK(port),
+				   RTL8366RB_STP_STATE(port, val));
+	}
+}
+
 static void
 rtl8366rb_port_fast_age(struct dsa_switch *ds, int port)
 {
@@ -1733,6 +1780,7 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
 	.port_disable = rtl8366rb_port_disable,
 	.port_pre_bridge_flags = rtl8366rb_port_pre_bridge_flags,
 	.port_bridge_flags = rtl8366rb_port_bridge_flags,
+	.port_stp_state_set = rtl8366rb_port_stp_state_set,
 	.port_fast_age = rtl8366rb_port_fast_age,
 	.port_change_mtu = rtl8366rb_change_mtu,
 	.port_max_mtu = rtl8366rb_max_mtu,
-- 
2.31.1

