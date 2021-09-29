Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B50D41CDC9
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 23:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346482AbhI2VIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 17:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345622AbhI2VIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 17:08:44 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354EFC06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 14:07:02 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id x27so16328799lfu.5
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 14:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3KZeQ1UL+Qr6VrGAkVMnUDxIrRV+iTWbafHkEPoCs9g=;
        b=M58hkh9SpiSFF7g28cyy/3kzGz+I4WM2ImAvKHGPlvAQpoXgjzo5WLGWVFb2XS+DjO
         aGc3YjZu4CVVsc+LGQFH5P3tMSUwNuYH5Gt2Y19W330VfK1P3wVoEiCeCqy1U4FGiksp
         kZLs/GfxDAICvCJToEk9tOHXIlCwuhhqk8ypq/CnIuuYxCJEPSKV8BZutt4hop+Jylrc
         MpjwotUmbKWHWGCRS5nNPCzcyCkL5GL6ZdQRzn4frd7le3ceCt0x1/f0djx/2nZ15JOY
         jdKWAvJdW/yvUoZq7h8w1svZxIIA6KiLyB/MSPLYlasCwC8ztIL0eMPCqFykGw6rzp3M
         8xVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3KZeQ1UL+Qr6VrGAkVMnUDxIrRV+iTWbafHkEPoCs9g=;
        b=6j50UzYQHskyFTNJ8zSjfaKVXFX52bLfHrgC3NDHEslxRtM6bR16os3MzB/dPYMrwd
         k0LhQrlAvo982zUDuMfcHLZbUl7gpvjRdWZSIggAJNsyS3xMTnpkAFooSLw3yhNTCWzl
         zNcts6FuU0LhPqCXbbooAUb9sVD1Mm8JvfUKamtUuTadALDDBZjYQj1Zmlk83GxDOsQW
         RYmUYIBejDASJkpaXtUTye7+6kXKQoo+Kpm6RPbvS+9VscM5RkGnric2nfVaytXoUZFL
         cbSrqiqANOBM1HAaK3jWwL/fIUUCPJHP5dbn9xR6jAHPys5WLshgvOQTeHNRxHCewbkw
         YJGw==
X-Gm-Message-State: AOAM531vvBF4NpnVFu7ifgceTUCwMY49IjJ70GvupeB0yz32nLSNG27H
        5wUQ1LcI6JrWqlAEN/43YT18Gw==
X-Google-Smtp-Source: ABdhPJwvl5A/2dSRawajr/n/5JVATrjSjztaVBgZZW52qf0v90ip0K2/9Jpmls0s6yKraYlg4xw1gg==
X-Received: by 2002:ac2:5e24:: with SMTP id o4mr1731035lfg.522.1632949620530;
        Wed, 29 Sep 2021 14:07:00 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id s9sm112613lfp.291.2021.09.29.14.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 14:07:00 -0700 (PDT)
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
Subject: [PATCH net-next 4/4 v4] net: dsa: rtl8366rb: Support setting STP state
Date:   Wed, 29 Sep 2021 23:03:49 +0200
Message-Id: <20210929210349.130099-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929210349.130099-1-linus.walleij@linaro.org>
References: <20210929210349.130099-1-linus.walleij@linaro.org>
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
ChangeLog v1->v4:
- New patch after discovering that we can do really nice
  bridge offloading with these bits.
---
 drivers/net/dsa/rtl8366rb.c | 47 +++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index 748f22ab9130..c143fdab4802 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -110,6 +110,14 @@
 
 #define RTL8366RB_POWER_SAVING_REG	0x0021
 
+/* Spanning tree status (STP) control, two bits per port per FID */
+#define RTL8368S_SPT_STATE_BASE		0x0050 /* 0x0050..0x0057 */
+#define RTL8368S_SPT_STATE_MSK		0x3
+#define RTL8368S_SPT_STATE_DISABLED	0x0
+#define RTL8368S_SPT_STATE_BLOCKING	0x1
+#define RTL8368S_SPT_STATE_LEARNING	0x2
+#define RTL8368S_SPT_STATE_FORWARDING	0x3
+
 /* CPU port control reg */
 #define RTL8368RB_CPU_CTRL_REG		0x0061
 #define RTL8368RB_CPU_PORTS_MSK		0x00FF
@@ -254,6 +262,7 @@
 #define RTL8366RB_NUM_LEDGROUPS		4
 #define RTL8366RB_NUM_VIDS		4096
 #define RTL8366RB_PRIORITYMAX		7
+#define RTL8366RB_NUM_FIDS		8
 #define RTL8366RB_FIDMAX		7
 
 #define RTL8366RB_PORT_1		BIT(0) /* In userspace port 0 */
@@ -1359,6 +1368,43 @@ rtl8366rb_port_bridge_flags(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static void
+rtl8366rb_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
+{
+	struct realtek_smi *smi = ds->priv;
+	u16 mask;
+	u32 val;
+	int i;
+
+	switch (state) {
+	case BR_STATE_DISABLED:
+		val = RTL8368S_SPT_STATE_DISABLED;
+		break;
+	case BR_STATE_BLOCKING:
+	case BR_STATE_LISTENING:
+		val = RTL8368S_SPT_STATE_BLOCKING;
+		break;
+	case BR_STATE_LEARNING:
+		val = RTL8368S_SPT_STATE_LEARNING;
+		break;
+	case BR_STATE_FORWARDING:
+		val = RTL8368S_SPT_STATE_FORWARDING;
+		break;
+	default:
+		dev_err(smi->dev, "unknown bridge state requested\n");
+		return;
+	};
+
+	mask = (RTL8368S_SPT_STATE_MSK << (port * 2));
+	val <<= (port * 2);
+
+	/* Set the same status for the port on all the FIDs */
+	for (i = 0; i < RTL8366RB_NUM_FIDS; i++) {
+		regmap_update_bits(smi->map, RTL8368S_SPT_STATE_BASE + i,
+				   mask, val);
+	}
+}
+
 static void
 rtl8366rb_port_fast_age(struct dsa_switch *ds, int port)
 {
@@ -1784,6 +1830,7 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
 	.port_disable = rtl8366rb_port_disable,
 	.port_pre_bridge_flags = rtl8366rb_port_pre_bridge_flags,
 	.port_bridge_flags = rtl8366rb_port_bridge_flags,
+	.port_stp_state_set = rtl8366rb_port_stp_state_set,
 	.port_fast_age = rtl8366rb_port_fast_age,
 	.port_change_mtu = rtl8366rb_change_mtu,
 	.port_max_mtu = rtl8366rb_max_mtu,
-- 
2.31.1

