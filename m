Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2972DEFE8
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 14:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgLSNxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 08:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgLSNxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 08:53:32 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625F9C0617B0;
        Sat, 19 Dec 2020 05:52:52 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id g20so7308452ejb.1;
        Sat, 19 Dec 2020 05:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cScwhsBDy0n9T2wqbVdNhwbfWnu1a8RovKqaENONwz4=;
        b=nszt3lSg8u2a+DKQJGUP6VbGxeBTEE/qgMQ90FcGJpGEpnExbZUvjyvBI0DjcOizjj
         kdu7+9dC8UI4j75AKBHuKcQxXOrbOQc1hJhKKLGibeenNBvLbLiAUC59oKBg/PPTJf4r
         4S3kIsEt95CYHB7h+moqQqUuTUd6Egn4kVALTErqj6kvn+dBz92Ggga0EghHzyuZX7CA
         ObOvYQxIlg/nlwmJhWWinegugQ6JiqPz8HBGYtKM0HP/sOW7wB0OkAaXC6yQZCvyBQHR
         6YN9a0sXtTAeCFgc6WWCc10axj89g/dr/ojAMIwDDwTm7oF/n7q61h/lwS9kEidinCKw
         8L9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cScwhsBDy0n9T2wqbVdNhwbfWnu1a8RovKqaENONwz4=;
        b=RxsnKrKLRhrDu/nrEG53XkKFmV1DK6VYaWFjLv0CJLBSHPdsHrSQfeqIWvtsYVVvBU
         vlgXFF41/Cf4CM2RDB3JVqUumd+kXrOMbeI/P7E1Jrtq4Hf7nt11uisFkmPKT8X8azF/
         /TLhSt7ujxFfHhT0cFK77cCilaUokeVv4U2Gwz9xiPfnWL7GtcLhimoAFcqKOFrzOiRd
         zkLAVubm5Lp3tK4IRqgK0zA5FAhM+pIkEiyj0E1dinjFcFJyN21t0z+cEZHfu64FUATZ
         10Xtbx12N8InSFGCu37qKC84VesNwm+J9HufB/H7TWZk9X5vSil+hIxVYQrECV6yE8ey
         W/SA==
X-Gm-Message-State: AOAM531LMiVFMLDBwkLcGbM0VI3k4RPSqmGSbiFjo1ylwZkAtBE6VkpT
        Cbv1kxWrtvWB3cQlaBwuxJ6NqRTzfJw=
X-Google-Smtp-Source: ABdhPJye4mu3SslUsrOAPhFcctjWk9HUb8WOw+y+woblvSNlNSjhvmvpKNIPWAnCXjeFfHVzukqsJw==
X-Received: by 2002:a17:907:3e23:: with SMTP id hp35mr8522020ejc.254.1608385970812;
        Sat, 19 Dec 2020 05:52:50 -0800 (PST)
Received: from localhost.localdomain (p200300f137299d00428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:3729:9d00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id s5sm6823063eju.98.2020.12.19.05.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 05:52:50 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     khilman@baylibre.com, jbrunet@baylibre.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Thomas Graichen <thomas.graichen@gmail.com>
Subject: [PATCH] net: stmmac: dwmac-meson8b: ignore the second clock input
Date:   Sat, 19 Dec 2020 14:50:36 +0100
Message-Id: <20201219135036.3216017-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dwmac glue registers on Amlogic Meson8b and newer SoCs has two clock
inputs:
- Meson8b and Meson8m2: MPLL2 and MPLL2 (the same parent is wired to
  both inputs)
- GXBB, GXL, GXM, AXG, G12A, G12B, SM1: FCLK_DIV2 and MPLL2

All known vendor kernels and u-boots are using the first input only. We
let the common clock framework automatically choose the "right" parent.
For some boards this causes a problem though, specificially with G12A and
newer SoCs. The clock input is used for generating the 125MHz RGMII TX
clock. For the two input clocks this means on G12A:
- FCLK_DIV2: 999999985Hz / 8 = 124999998.125Hz
- MPLL2: 499999993Hz / 4 = 124999998.25Hz

In theory MPLL2 is the "better" clock input because it's gets us 0.125Hz
closer to the requested frequency than FCLK_DIV2. In reality however
there is a resource conflict because MPLL2 is needed to generate some of
the audio clocks. dwmac-meson8b probes first and sets up the clock tree
with MPLL2. This works fine until the audio driver comes and "steals"
the MPLL2 clocks and configures it with it's own rate (294909637Hz). The
common clock framework happily changes the MPLL2 rate but does not
reconfigure our RGMII TX clock tree, which then ends up at 73727409Hz,
which is more than 40% off the requested 125MHz.

Don't use the second clock input for now to force the common clock
framework to always select the first parent. This mimics the behavior
from the vendor driver and fixes the clock resource conflict with the
audio driver on G12A boards. Once the common clock framework can handle
this situation this change can be reverted again.

Fixes: 566e8251625304 ("net: stmmac: add a glue driver for the Amlogic Meson 8b / GXBB DWMAC")
Reported-by: Thomas Graichen <thomas.graichen@gmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 459ae715b33d..f184b00f5116 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -135,7 +135,7 @@ static int meson8b_init_rgmii_tx_clk(struct meson8b_dwmac *dwmac)
 	struct device *dev = dwmac->dev;
 	static const struct clk_parent_data mux_parents[] = {
 		{ .fw_name = "clkin0", },
-		{ .fw_name = "clkin1", },
+		{ .index = -1, },
 	};
 	static const struct clk_div_table div_table[] = {
 		{ .div = 2, .val = 2, },
-- 
2.29.2

