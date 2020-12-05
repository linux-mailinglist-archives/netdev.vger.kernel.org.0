Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A4B2CFF3F
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 22:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgLEVdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 16:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgLEVdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 16:33:09 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02C9C0613CF;
        Sat,  5 Dec 2020 13:32:28 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id qw4so13867022ejb.12;
        Sat, 05 Dec 2020 13:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=768hUwf7RIx859JFI/Ccnti1I5MLKPZtvOJEmoM469s=;
        b=aSFvGdOuicYAbmart/NUe+EXb25VcEXMR3LQh1MsDktoFQE+ArJnGaXSak7srOkMUD
         UP3SjEawoork/pRLFqUQYSFhGcxK9YZn3ns27EulCQWxoFZ0ej/YHM9d2WF5U4KeiVKI
         F5xXEHEJtyCboF3BvqFRogeqyt2OkhpFNVXqFNzhUH/tYj5Vw2bo9S/97zSCDegY2B9J
         3odTLUsX9wHzmGeE4Yy2ZkcMZ7rU6H6+1dXbExTFctx/MyBmw4EBYbbqS715AcgmQpMF
         QnOOmvcnUrb9X4fgHW05BrLQOzXqb3Qdi+l57fJqK03mnoRA0xINGbuXQBgaXWqVIr2X
         QFHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=768hUwf7RIx859JFI/Ccnti1I5MLKPZtvOJEmoM469s=;
        b=LupMbtq6nc5NHgTBThhTJbgdBmxr2/4sf8qQT1s0G4vpRZhop5lrcDH5OjuDlrZ0Qs
         z+d8dCdT+5+PHerOye1bM/KcoFnuDD4NzblfXWPLAMKN3jvJDdMx5oXw1cJLARwwxZ6H
         HNV4h9Iuef39nGPfbXkXV3at3MWrQ7CdZLh4jvQIOo17Hvt8cwUtDwRBCZohIYo24zSb
         Mq5MkCLEnI5knOqjjlRHrM0eDcAGtWfp+jjfM6ca5ryMmxf9jbP0HkmG5r1tkF2pHXzA
         zNJ4jlt6Cyc0vtWEkY5K7LGmhsoOb3I5t0P7auZfY3IAAVpFHa4ySnWjTjX7fLw982j7
         fGOA==
X-Gm-Message-State: AOAM530JpDcTCwZxKTz0ZaHkstg8/CwSv4RS6IagikYReP6SIvO/1piu
        9hhHEgxzMYa/08p9ow7VNgo=
X-Google-Smtp-Source: ABdhPJxsHoEh0SvQhHnb0vF6LgkmxnQALnCbO52raQQhcCfrUMmFXSeapOZ/UNbY2Vvq7HWJk8eEJw==
X-Received: by 2002:a17:906:1955:: with SMTP id b21mr12849375eje.236.1607203947393;
        Sat, 05 Dec 2020 13:32:27 -0800 (PST)
Received: from localhost.localdomain (p200300f13728d200428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:3728:d200:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id m7sm6390133eds.73.2020.12.05.13.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Dec 2020 13:32:26 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH] net: stmmac: dwmac-meson8b: fix mask definition of the m250_sel mux
Date:   Sat,  5 Dec 2020 22:32:07 +0100
Message-Id: <20201205213207.519341-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The m250_sel mux clock uses bit 4 in the PRG_ETH0 register. Fix this by
shifting the PRG_ETH0_CLK_M250_SEL_MASK accordingly as the "mask" in
struct clk_mux expects the mask relative to the "shift" field in the
same struct.

While here, get rid of the PRG_ETH0_CLK_M250_SEL_SHIFT macro and use
__ffs() to determine it from the existing PRG_ETH0_CLK_M250_SEL_MASK
macro.

Fixes: 566e8251625304 ("net: stmmac: add a glue driver for the Amlogic Meson 8b / GXBB DWMAC")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index dc0b8b6d180d..459ae715b33d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -30,7 +30,6 @@
 #define PRG_ETH0_EXT_RMII_MODE		4
 
 /* mux to choose between fclk_div2 (bit unset) and mpll2 (bit set) */
-#define PRG_ETH0_CLK_M250_SEL_SHIFT	4
 #define PRG_ETH0_CLK_M250_SEL_MASK	GENMASK(4, 4)
 
 /* TX clock delay in ns = "8ns / 4 * tx_dly_val" (where 8ns are exactly one
@@ -155,8 +154,9 @@ static int meson8b_init_rgmii_tx_clk(struct meson8b_dwmac *dwmac)
 		return -ENOMEM;
 
 	clk_configs->m250_mux.reg = dwmac->regs + PRG_ETH0;
-	clk_configs->m250_mux.shift = PRG_ETH0_CLK_M250_SEL_SHIFT;
-	clk_configs->m250_mux.mask = PRG_ETH0_CLK_M250_SEL_MASK;
+	clk_configs->m250_mux.shift = __ffs(PRG_ETH0_CLK_M250_SEL_MASK);
+	clk_configs->m250_mux.mask = PRG_ETH0_CLK_M250_SEL_MASK >>
+				     clk_configs->m250_mux.shift;
 	clk = meson8b_dwmac_register_clk(dwmac, "m250_sel", mux_parents,
 					 ARRAY_SIZE(mux_parents), &clk_mux_ops,
 					 &clk_configs->m250_mux.hw);
-- 
2.29.2

