Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48642EBF0F
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbhAFNp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbhAFNox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 08:44:53 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F07C061358;
        Wed,  6 Jan 2021 05:44:13 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id k10so2486336wmi.3;
        Wed, 06 Jan 2021 05:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bxZLTc7rIJqLiJdfqS1xtEvX/QdxfbBjIy6J1+OLQNE=;
        b=IM3iZ4sPhKgYRgmLXkyxqO3lbGRcEzCB35idFQMDqIGzIkLMgyMe34WRg0uz6B0D0X
         RfDlRfrHmm5RSt/EfDpfapTTxq8qiqxmBbtT+kMGRk+2BIo2kMU6NxoEQ2znALmQRaCj
         ZnU+6Az6+diszOdSiS0SkWxBAiHPPMB5dlcKR2qlkRmhCsfhcvQa/tIhpWWOIMAF7bij
         KerJJ1KM1FUWtRyGa/W60M1CrZ48lMzhNkXOcIhLFkbFDqXlNkqIlWClykAECCtZ3hS4
         lau4tY66z5RXP8LIZ3WQ3Z3e0CpK0JivxJt5bpQbr3fJl5EYS6Rm4DnZ6pN6HBRP6Qrc
         AW0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bxZLTc7rIJqLiJdfqS1xtEvX/QdxfbBjIy6J1+OLQNE=;
        b=kBKLj5jl/WKjIzKx22cg9HagPZDfdP2IaZPVMi7k3HrlAqdcxpvnmaG43Ea+GqNWtx
         ArkLiBSAZYQJbI6MukJngsdhiig4WBFVH3otNZ2feAFpWpwy6JEG9SVKySSrHb6dAqJM
         45htRFu7HNDNcpVMqtnn9qFLEy1FhBu9VzV7+ZaRpB3o06deWC3vhSwWfi9hA9LQo23z
         waOrujcz9eHxFnaDSqyc0W/b69pAT8AWoXWt/6uF/KSeHHrqw4jl9PVmgWq2eCY+7FsR
         QTKTnrB4KByZ2O9En/vmWLOu8Jmen1325CHKaklMOeLLB+vAxM0sieh/poOxygFEPlur
         LH7Q==
X-Gm-Message-State: AOAM530jqCEZCw7DPFkqfhAckNSmJxqThurEaKa/SsEyB7YonN9maOBp
        qzr2H0+Of16mURZ++Izz4QI=
X-Google-Smtp-Source: ABdhPJwfCUpDM2zedZ6Ij/scp6mHXprurYB1xW+w1ei+iiMBq/uFUOVnbjd+JJvVnjYc+FsdkE12eQ==
X-Received: by 2002:a7b:c2e8:: with SMTP id e8mr3714963wmk.103.1609940651943;
        Wed, 06 Jan 2021 05:44:11 -0800 (PST)
Received: from localhost.localdomain (p200300f13711ec00428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:3711:ec00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id f14sm3085351wme.14.2021.01.06.05.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 05:44:11 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, jianxin.pan@amlogic.com,
        narmstrong@baylibre.com, khilman@baylibre.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jbrunet@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v4 2/5] net: stmmac: dwmac-meson8b: fix enabling the timing-adjustment clock
Date:   Wed,  6 Jan 2021 14:42:48 +0100
Message-Id: <20210106134251.45264-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210106134251.45264-1-martin.blumenstingl@googlemail.com>
References: <20210106134251.45264-1-martin.blumenstingl@googlemail.com>
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
2.30.0

