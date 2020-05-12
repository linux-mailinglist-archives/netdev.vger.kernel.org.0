Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874A21D0060
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 23:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731463AbgELVL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 17:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731331AbgELVLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 17:11:23 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29553C061A0C;
        Tue, 12 May 2020 14:11:23 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id h17so8813625wrc.8;
        Tue, 12 May 2020 14:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pjlQaP6Pg6Yvwq7DW912bqutMrQVbTNiK7xq5gHpuE0=;
        b=roj0ycigj6tQpVmbhT3jMy7/bvzkqodh/XKde1bJcDq8Su5gcZDcm7zLr8gdt1bPAk
         g6x90DldhUlWdT1PBS48kD5RXetpXcNc/eHbsfufeiGHipzX0E9wjr+TphFWQnr7SDpb
         Xm7K9cF+fp2IDhkP9lNym+BixHnCNStlxvFAqVJFvw6emDyQ8VT5GEScIX+vwtIQCtX6
         JNfzeR6qGKqrY4zUi2lMyQnWve+b2zgGtJkscILNbP+VxR1I2hFQO24nrHSt/G7eIapF
         ApuothyXDI9r84McHgKdSCJGozqmmGcc+BRDGBYXZuFrvrWvu48XpMTyalcsBo2dctp2
         Dytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pjlQaP6Pg6Yvwq7DW912bqutMrQVbTNiK7xq5gHpuE0=;
        b=iIlZXY9EQvEKXyp9jPGiG28qVY+i15Iw7i3iZzSThwilNgM4bCzOX8JPp1ovUHouUx
         IT88udKsezI/jcAQAvB0MMotVy5lP9WiJNW+SVertYR/UvD34NEaql3gPhXg0j3VSNsH
         pUTHRy0sGxsm/xNkhDdbdV0PtU4I5xwmmYwWm3YJI2EcdiX0r+lDVFAcZ97ErlDjnO4y
         31f8PaAreOkwFjhFIUfqSt7O3WdktwAGMWaY/vZsckBEO2EJjLKXt5b7EwCiP7MaUHrN
         qPt0swicPizoWIMIU9Q1koNE5VDFSVspbLiURsQ8T/Yl5tdmTtKsfoRGMZoni9o0qzV7
         BiXw==
X-Gm-Message-State: AOAM530YbQ66vWSzuQJg++f5+7Sv/ttk7rsLiOCI+f+pW/7maFsVlnaG
        AwIUvAiuEc28MgnpclGXr3I=
X-Google-Smtp-Source: ABdhPJy8IBNIga3u76iZvWIyKVklYTAzmaNyRda+NSuJrgm3ui7QhnMf2uVqDc69Bo88OkngKLdAvg==
X-Received: by 2002:a5d:4d81:: with SMTP id b1mr5282727wru.55.1589317881655;
        Tue, 12 May 2020 14:11:21 -0700 (PDT)
Received: from localhost.localdomain (p200300F137132E00428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:3713:2e00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id r3sm9724228wmh.48.2020.05.12.14.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 14:11:21 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org
Cc:     jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 5/8] net: stmmac: dwmac-meson8b: Add the PRG_ETH0_ADJ_* bits
Date:   Tue, 12 May 2020 23:11:00 +0200
Message-Id: <20200512211103.530674-6-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512211103.530674-1-martin.blumenstingl@googlemail.com>
References: <20200512211103.530674-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PRG_ETH0_ADJ_* are used for applying the RGMII RX delay. The public
datasheets only have very limited description for these registers, but
Jianxin Pan provided more detailed documentation from an (unnamed)
Amlogic engineer. Add the PRG_ETH0_ADJ_* bits along with the improved
description.

Suggested-by: Jianxin Pan <jianxin.pan@amlogic.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../ethernet/stmicro/stmmac/dwmac-meson8b.c   | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 1d7526ee09dd..70075628c58e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -48,6 +48,27 @@
 #define PRG_ETH0_INVERTED_RMII_CLK	BIT(11)
 #define PRG_ETH0_TX_AND_PHY_REF_CLK	BIT(12)
 
+/* Bypass (= 0, the signal from the GPIO input directly connects to the
+ * internal sampling) or enable (= 1) the internal logic for RXEN and RXD[3:0]
+ * timing tuning.
+ */
+#define PRG_ETH0_ADJ_ENABLE		BIT(13)
+/* Controls whether the RXEN and RXD[3:0] signals should be aligned with the
+ * input RX rising/falling edge and sent to the Ethernet internals. This sets
+ * the automatically delay and skew automatically (internally).
+ */
+#define PRG_ETH0_ADJ_SETUP		BIT(14)
+/* An internal counter based on the "timing-adjustment" clock. The counter is
+ * cleared on both, the falling and rising edge of the RX_CLK. This selects the
+ * delay (= the counter value) when to start sampling RXEN and RXD[3:0].
+ */
+#define PRG_ETH0_ADJ_DELAY		GENMASK(19, 15)
+/* Adjusts the skew between each bit of RXEN and RXD[3:0]. If a signal has a
+ * large input delay, the bit for that signal (RXEN = bit 0, RXD[3] = bit 1,
+ * ...) can be configured to be 1 to compensate for a delay of about 1ns.
+ */
+#define PRG_ETH0_ADJ_SKEW		GENMASK(24, 20)
+
 #define MUX_CLK_NUM_PARENTS		2
 
 struct meson8b_dwmac;
-- 
2.26.2

