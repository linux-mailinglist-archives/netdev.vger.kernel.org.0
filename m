Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4812B3810
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 19:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgKOSws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 13:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgKOSwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 13:52:45 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75547C0613D2;
        Sun, 15 Nov 2020 10:52:45 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id o9so21335416ejg.1;
        Sun, 15 Nov 2020 10:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PRS8GQW7oFuDCzXfRsoeq3MgyVfqDxglzJm0FE7yRX0=;
        b=f587MDHdn7XtFw7QnkvRKTUkPbw+llLKwDIbrFERtxe484uRd/l27TdG3G6uBPv2sQ
         oe3ztZVMs/+xreCw6LiWtw/VnOM67joIc+S1ng+Gfz9qLbmkAPxXYPQ2m61eAkF9tOW4
         CLtCU18t99U78UWd9h9Lwwqp+Vu4hQswFwJQq5Xi9ZjnsOdTsfhO1CPg119xhPQ98ziE
         u+2YHT6i/C9OUQA+LOAdpftr4mHUuzbCb70q9nR2oO3T3u6CIuZZZMNTezzMb2SNCrq7
         S9r5afOkT/s0YpIgt6oCkQ02F71M2sP1tBkVX5IFWCWaWFLseWYRaZVHLdjf7vSkYaX+
         LnoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PRS8GQW7oFuDCzXfRsoeq3MgyVfqDxglzJm0FE7yRX0=;
        b=FyhVs15sXqFJBIpTwO3ZKq5oy9loavn7EgDXDDd5KDrLohkHYOV8/29fyv5nF3JSuD
         tGtx2X0onzajsm4e0pftCjaf8JJj7OdWH1eV5TIK04aBeuxFvNfv6w7z2GFVFttbbDtd
         NsnDxq876blDzxrvJR+74DPbkLhnlwPu42JcHSK1pAl6A9DPqm+dE2bhqJZvKghHgeNX
         E6UFgbabHMDRzm4R5r7umldSX6nxCRp2e2tp9uSUbzYybaFGgaBEH1vSPv1wHn6f+7jV
         HYJoC4ofEcPBzOCEEW20mc1Q4BLBsjyls+2jat28L26CV0f03xsBsKFgDD0ycgQIAfT5
         Bhdg==
X-Gm-Message-State: AOAM530ojEsPmJn3fwMApwTRMyS4f26GK7SLDIQE55Ehdl4S7SwNoc5v
        BhUCPb7JatrI7NT+QnquE0G+i+1uHpkhyA==
X-Google-Smtp-Source: ABdhPJxtZ9gYOz1qZtZ2rnw8Jpwnq+Ma1c4Bn4rMhkOiBvWsBsEMVZ7OK911BkbmC7F7XIqmkRPS2Q==
X-Received: by 2002:a17:906:cc4f:: with SMTP id mm15mr11356813ejb.267.1605466364252;
        Sun, 15 Nov 2020 10:52:44 -0800 (PST)
Received: from localhost.localdomain (p4fc3ea77.dip0.t-ipconnect.de. [79.195.234.119])
        by smtp.googlemail.com with ESMTPSA id i13sm9233520ejv.84.2020.11.15.10.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 10:52:43 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org
Cc:     jianxin.pan@amlogic.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, khilman@baylibre.com,
        narmstrong@baylibre.com, jbrunet@baylibre.com, andrew@lunn.ch,
        f.fainelli@gmail.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v2 2/5] net: stmmac: dwmac-meson8b: fix enabling the timing-adjustment clock
Date:   Sun, 15 Nov 2020 19:52:07 +0100
Message-Id: <20201115185210.573739-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201115185210.573739-1-martin.blumenstingl@googlemail.com>
References: <20201115185210.573739-1-martin.blumenstingl@googlemail.com>
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
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index dc0b8b6d180d..e27e2e7a53fd 100644
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

