Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDBFE2793D1
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 23:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgIYV4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 17:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgIYV4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 17:56:45 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D982BC0613CE;
        Fri, 25 Sep 2020 14:56:44 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id j11so680478ejk.0;
        Fri, 25 Sep 2020 14:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Uylx3fTiHwj2S0tEs2f1wEToSjCcCbEFHt+iv9BVjpA=;
        b=BMzkdWIwR4HBFB+pSPFXtjIxIvI8PcdzQQ+S/1EETWFoxIulTyS0Vnw+C5p0T3REE7
         ziLTSiGSYTtaS8XcNDzqoWZu6fvGLeiJAZHDx/swLAWokw7H8VZyufoT6/+zCcQdJbrZ
         V7iLhIZwPTM7ux4mzuENdDlXW1ixSjgF7XVYPRgdckmxun8Fd+DnThl7YkFmEKyEfIrR
         okZT0QoPbYn6hSduf8CUQMRg8iqicEios0sQK/MS+5q9DnpQO3SJWzNpm8LMkakWCY+M
         vrtxKDDO0MN4JRak83afS9ftG9teebZGXgONR6mHFFF3QZyzLcmePr1FWgK9gTYjBJC8
         9lUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Uylx3fTiHwj2S0tEs2f1wEToSjCcCbEFHt+iv9BVjpA=;
        b=QhhAzW0lGVJrm9igSsRzPQFjw4oXIcMtSrTlvaXtTrJuEJSmu/EvU/IDHKmKoR7zjK
         dtMABaYwwhO9wl6atNP/STE1XpcJiDhh0tLuwA3Wi1oN/8VFFtVW8LMucl99ZtynVNFn
         wHt9vfkWseox0hLEM0HcGOKKrX2HA92s6L/zSy/QtgWY7Vz0Tq7/HI2MI5TtV2cEiEQf
         E7Ebd2VlVQvh03JbBRqQaUIWgpeULnQjGV6naUBdsRKEHujoUmMVMtQEfmT+2VdKRS0k
         21suy0en7FM466hZ3Iomp9FR0L0lWXzZFfUBj+EIY9z7OKnHjSUeZw5TvwXriPbtOLI5
         +FUQ==
X-Gm-Message-State: AOAM533wnW5lw6seZLBS/VUN0hO+eLNU+sS/3Ma6Ho25pK6SMgCeRofV
        yIFsf6oaJPoyF71aLEE8++8=
X-Google-Smtp-Source: ABdhPJz01tYZsi1CiKNBkRckUolw1dikYY0VFjNKStNMvKWHD3YPAMYdgX2FG81UQexE3WtC4o3wbA==
X-Received: by 2002:a17:906:e24d:: with SMTP id gq13mr4652709ejb.152.1601071003509;
        Fri, 25 Sep 2020 14:56:43 -0700 (PDT)
Received: from localhost.localdomain (p4fd5dca7.dip0.t-ipconnect.de. [79.213.220.167])
        by smtp.googlemail.com with ESMTPSA id g10sm2683062ejp.34.2020.09.25.14.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 14:56:42 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH] net: stmmac: dwmac-meson8b: add calibration registers
Date:   Fri, 25 Sep 2020 23:56:29 +0200
Message-Id: <20200925215629.545233-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Amlogic dwmac Ethernet IP glue has two registers:
- PRG_ETH0 with various configuration bits
- PRG_ETH1 with various calibration and information related bits

Add the register definitions with comments from different drivers in
Amlogic's vendor u-boot and Linux.

The most important part is PRG_ETH1_AUTO_CALI_IDX_VAL which is needed on
G12A (and later: G12B, SM1) with RGMII PHYs. Ethernet is only working up
to 100Mbit/s speeds if u-boot does not initialize these bits correctly.
On 1Gbit/s links no traffic is flowing (similar to when the RGMII delays
are set incorrectly). The logic to write this register will be added
later.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../ethernet/stmicro/stmmac/dwmac-meson8b.c   | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 5afcf05bbf9c..9a898d2a1e08 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -69,6 +69,34 @@
  */
 #define PRG_ETH0_ADJ_SKEW		GENMASK(24, 20)
 
+#define PRG_ETH0_START_CALIBRATION	BIT(25)
+
+/* 0: falling edge, 1: rising edge */
+#define PRG_ETH0_TEST_EDGE		BIT(26)
+
+/* Select one signal from {RXDV, RXD[3:0]} to calibrate */
+#define PRG_ETH0_SIGNAL_TO_CALIBRATE	GENMASK(29, 27)
+
+#define PRG_ETH1			0x4
+
+/* Signal switch position in 1ns resolution */
+#define PRG_ETH1_SIGNAL_SWITCH_POSITION	GENMASK(4, 0)
+
+/* RXC (RX clock) length in 1ns resolution */
+#define PRG_ETH1_RX_CLK_LENGTH		GENMASK(9, 5)
+
+#define PRG_ETH1_CALI_WAITING_FOR_EVENT	BIT(10)
+
+#define PRG_ETH1_SIGNAL_UNDER_TEST	GENMASK(13, 11)
+
+/* 0: falling edge, 1: rising edge */
+#define PRG_ETH1_RESULT_EDGE		BIT(14)
+
+#define PRG_ETH1_RESULT_IS_VALID	BIT(15)
+
+/* undocumented - only valid on G12A and later */
+#define PRG_ETH1_AUTO_CALI_IDX_VAL	GENMASK(19, 16)
+
 struct meson8b_dwmac;
 
 struct meson8b_dwmac_data {
-- 
2.28.0

