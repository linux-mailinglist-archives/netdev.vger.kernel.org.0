Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2DC1BE843
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgD2URX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbgD2URU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:17:20 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F8FC03C1AE;
        Wed, 29 Apr 2020 13:17:20 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u16so3468680wmc.5;
        Wed, 29 Apr 2020 13:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GrVPUcTD2l9oJ0HPXx8l+PhUQ6rIzd+t7iX8qFgDDUE=;
        b=ipE94I2oDHFBOK1wvyXv2dDCEJ+N4Iszv0sQleLMdWCyHveYpujY5johVU8kihYH9g
         Q7Mvf7UdOXUqBLc+R2xZks9rvgRzyn3pL4zurFd2YBqz9lByXmau8QYKuhkD+14Fn8tp
         Y/WJAgqkwxSN3441r2bv9I99b/EBoORAg9bRHbxaE4zOx9OifBcXW3OEx+0aIMVDnTnv
         bN0KuMUidxZT4TORBaoScSFlGk40WcxUfYWruGgESQ3T+72m6rtw64WqNT6vDhx6ZWCv
         rwIWOTKtw4QElEb19488qaxyVRxaKsCI08m+4+qpQcuztJdItKanL0/Ll2+F/12ze6so
         EmjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GrVPUcTD2l9oJ0HPXx8l+PhUQ6rIzd+t7iX8qFgDDUE=;
        b=GtFuEpnwiA5Rqgqumt6kVi5Nic+A76H5mnVT2ljSquDahHY/pqiTx8qrQgCorEVPud
         hUhYUqGI3a1OWf6DYwNhMFw5Mi3v8pche5yziy4EWrGzITTluOVLgXvTtDHBzdYLKOyy
         cnz2BCZ4MOaJjoLx0YwNB20Oe8bqIDb+ZySBStXQirvTr5okIlIMG2V4s9E//b4Uo+lu
         zmwsEpCsgQil2NzhBoo8pNOz5rI8wAkOXI740jT7cPKqLDztx4IiO6W0hhU/vK+zh9AX
         C4StOenayZ12DGsulXAds/sPS4LJxKYIxs6kD65T5bHocqLd872IsdRXvuPdzGVvzN8X
         WIIA==
X-Gm-Message-State: AGi0Pub3wYIPq13FV3LbqQtuigy+ornUiC1cznf9YXJ01K0hzJ0kYqj3
        hbS7LXoGxPwf/Gzcp+MHjok=
X-Google-Smtp-Source: APiQypL4s/mUZ/ZYL0kEimx4vhbQ6WN12EIfKnlQOaoJRiTogeSbY1XH1KXmgf2OGXzZCm2fknw27w==
X-Received: by 2002:a1c:6402:: with SMTP id y2mr5205603wmb.116.1588191438299;
        Wed, 29 Apr 2020 13:17:18 -0700 (PDT)
Received: from localhost.localdomain (p200300F137142E00428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:3714:2e00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id q143sm9923623wme.31.2020.04.29.13.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 13:17:17 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org
Cc:     jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v2 05/11] net: stmmac: dwmac-meson8b: Add the PRG_ETH0_ADJ_* bits
Date:   Wed, 29 Apr 2020 22:16:38 +0200
Message-Id: <20200429201644.1144546-6-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
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

