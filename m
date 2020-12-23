Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C377A2E22BB
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 00:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgLWXbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 18:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727901AbgLWXbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 18:31:21 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253E6C0617A6;
        Wed, 23 Dec 2020 15:30:41 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id y23so275647wmi.1;
        Wed, 23 Dec 2020 15:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/IDOsxj1FkZFtUZQ+5yS2bWitABPuLIIASx9mGd33kI=;
        b=VuJreDFTBk+1siGVQ+QRRhstiDMGPyx1JVqRSg0H3GSmQsrV9VVhi41vxE8YzrGwDT
         CKyuVPRVdBireX++b4ixYWp6/9NpnExbP4PeXoz5WCBA94ymcUZ9AeIxrgGDwyyJ1Sm6
         hPrTKx+BubGOz8LCXhq2Exl0/76wi0E57oA4UtxnVpdqltQUi68njhqLkKO26zKeHKkA
         Q5bifJzR9uzX/IruDbyBTbo26rg+wkRP9VnzDtYjyZpC/8hkbBKFbVaBt4Cg9B+Ajzsj
         cL7dYuIn/BBiXCUipudEkc9c9iWcngVBVAt0U2AEBSyj5Cg394BuXpxZ7AgHciaMCdoe
         EhSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/IDOsxj1FkZFtUZQ+5yS2bWitABPuLIIASx9mGd33kI=;
        b=fV7fKXYnTNhyHFtMucWqJWZqwnPFhjGJlzKcpMK2NE8UwnfZEJ0CDzq/lPrw6X15Iq
         x08kRhTG8R/mXda99wtmnN4W9IByo2oOW3xC00tZ/dBVCiZjEvVA7nepeUbRZj5+DAo5
         qDUoBK4bPrAwGOT2z12HB4Sgwj5qYi0rhozjapqdFpE9c8H0fjuMdLDyJI8D/IkV2NTh
         C/w7EM0cpqcqouHIOgUdmx4WQmNfbupErjZzpdviWPq2MXNHwS5HpJGZZ6VHzoZp3vnB
         v4Df74mqeX8wwoyfZ8RKfnGyfMVftjTdhIKt/tEBgjru5bO++C/kxnlHfYVO6R6OlMb3
         n+tw==
X-Gm-Message-State: AOAM532WQ8TQsQLg35RMglKoi0JUQpOOcsRNm7TW+7mEjeBVZZdi0X5V
        QU15kVKuypXWd5PS+VNdaD4=
X-Google-Smtp-Source: ABdhPJxfDnawgge8i9/tFQIhr6IWYLXwiiT4tq6T8h5vUGsTJI+w9PHPHpL4xlT+G3MUACp0RmJbhw==
X-Received: by 2002:a1c:df57:: with SMTP id w84mr1717943wmg.37.1608766239904;
        Wed, 23 Dec 2020 15:30:39 -0800 (PST)
Received: from localhost.localdomain (p200300f1371a0900428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:371a:900:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id l16sm37926657wrx.5.2020.12.23.15.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 15:30:39 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, jianxin.pan@amlogic.com,
        narmstrong@baylibre.com, khilman@baylibre.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jbrunet@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 2/5] net: stmmac: dwmac-meson8b: fix enabling the timing-adjustment clock
Date:   Thu, 24 Dec 2020 00:29:02 +0100
Message-Id: <20201223232905.2958651-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223232905.2958651-1-martin.blumenstingl@googlemail.com>
References: <20201223232905.2958651-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The timing-adjustment clock only has to be enabled when a) there is a
2ns RX delay configured using device-tree and b) the phy-mode indicates
that the RX delay should be enabled.

Only enable the RX delay if both are true, instead of (by accident) also
enabling it when there's the 2ns RX delay configured but the phy-mode
incicates that the RX delay is not used.

Fixes: 9308c47640d515 ("net: stmmac: dwmac-meson8b: add support for the RX delay configuration")
Reported-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index f184b00f5116..5f500141567d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -301,7 +301,7 @@ static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
 		return -EINVAL;
 	}
 
-	if (rx_dly_config & PRG_ETH0_ADJ_ENABLE) {
+	if (delay_config & PRG_ETH0_ADJ_ENABLE) {
 		if (!dwmac->timing_adj_clk) {
 			dev_err(dwmac->dev,
 				"The timing-adjustment clock is mandatory for the RX delay re-timing\n");
-- 
2.29.2

