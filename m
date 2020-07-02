Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7F2212BA6
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 19:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgGBRx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 13:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgGBRx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 13:53:57 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64710C08C5C1;
        Thu,  2 Jul 2020 10:53:57 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id 80so26466416qko.7;
        Thu, 02 Jul 2020 10:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0/GQxXxfGsYnBic5/RL6CAFNUaN6B/gl7pdQ8fVaHoY=;
        b=bb1PyoLTqgnmqpoyjiIqzjmgwRxbIg8/iGsNGwpirVNTcqI/GQWWEP9KFFNsCcQ10Y
         Ni/imIv6X56JStRHswX9whmutnIkp9Jwpyw17nRT4ye+1zS2B8WHUkvehHf6HtkRirUr
         zzJuHZC5HZrpJA0wVOqSeUSYAsh3oBtm0I5eOe8bKLXC8dpfaODBFsJFDB2Vn8gFNR/v
         WdX5Squi+dYMgYQR2SYNp5wy2DwPLQaCVC2RpOSHbFUfVtMI/q97tPM2I/aAwfNXWWpB
         imEUZFoBTZD10dU53SjxXkOV4t3X3K2X7Uq9ooGbmCV9xzi9qS/uULtffIR1Y/+AZ3qS
         Mmew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0/GQxXxfGsYnBic5/RL6CAFNUaN6B/gl7pdQ8fVaHoY=;
        b=hv+9ayLtqIwGTYryFqBE4lxzVoWWLIzgE9AP3yBBZzHSnOdKtpklipRJkv52lecWH9
         42yNcil/GdDyeWf+Zv2s4PSFcH/TdqbaIs2jSEefks77fe0nb2Td67/ktKv/pon9X0a2
         alaRwnYGrs5k8PA8EaeN7if0Saawvra4CO5JBXHiSxYznKLwwJcjr6s3+ALNnLZ60I7w
         uyBZC7J0NYZa7+eyIHNiuW6TjaD93iqmITGK2vPvhgT0hH+1CuZR+uY30XF3gWoUc7Ta
         PsD0PFgIX8RFBxNIJvxh/8qgZ4zj54SpIKkJtGLGpe85/qDqDEhppBMbQpd8PGBEAwyf
         aS5g==
X-Gm-Message-State: AOAM532zxJ+PysimTj9ZOoXIaRIjcUw84LwmPH1RCoFfU7n/T3bbhnfN
        QU4gzV/HfY8P3HWkrM6QFok=
X-Google-Smtp-Source: ABdhPJyHl0z1SgQYig6I2fdY7EXsTetGozQfTeorJpNp1pG+z4UU5fykSc183B/FAVq+lx8x9BbPzQ==
X-Received: by 2002:a37:689:: with SMTP id 131mr22871561qkg.468.1593712436222;
        Thu, 02 Jul 2020 10:53:56 -0700 (PDT)
Received: from localhost.localdomain ([72.53.229.195])
        by smtp.gmail.com with ESMTPSA id w204sm9149937qka.41.2020.07.02.10.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 10:53:55 -0700 (PDT)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     shawnguo@kernel.org, fugang.duan@nxp.com, robh+dt@kernel.org
Cc:     Fabio Estevam <festevam@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/3] ARM: imx: mach-imx6q: Search for fsl,imx6q-iomuxc-gpr earlier
Date:   Thu,  2 Jul 2020 13:53:50 -0400
Message-Id: <20200702175352.19223-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

Check the presence of fsl,imx6q-iomuxc-gpr earlier and exit in case
of failure.

This is done in preparation for adding support for configuring the
GPR5 register for i.MX6QP a bit easier.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
---

Tree: v5.8-rc3

Patch history: see [PATCH v5 3/3]

To: Shawn Guo <shawnguo@kernel.org>
To: Andy Duan <fugang.duan@nxp.com>
To: Rob Herring <robh+dt@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org

 arch/arm/mach-imx/mach-imx6q.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index 85c084a716ab..ae89ad93ca83 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -169,6 +169,12 @@ static void __init imx6q_1588_init(void)
 	struct regmap *gpr;
 	u32 clksel;
 
+	gpr = syscon_regmap_lookup_by_compatible("fsl,imx6q-iomuxc-gpr");
+	if (IS_ERR(gpr)) {
+		pr_err("failed to find fsl,imx6q-iomuxc-gpr regmap\n");
+		return;
+	}
+
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx6q-fec");
 	if (!np) {
 		pr_warn("%s: failed to find fec node\n", __func__);
@@ -195,13 +201,8 @@ static void __init imx6q_1588_init(void)
 	clksel = clk_is_match(ptp_clk, enet_ref) ?
 				IMX6Q_GPR1_ENET_CLK_SEL_ANATOP :
 				IMX6Q_GPR1_ENET_CLK_SEL_PAD;
-	gpr = syscon_regmap_lookup_by_compatible("fsl,imx6q-iomuxc-gpr");
-	if (!IS_ERR(gpr))
-		regmap_update_bits(gpr, IOMUXC_GPR1,
-				IMX6Q_GPR1_ENET_CLK_SEL_MASK,
-				clksel);
-	else
-		pr_err("failed to find fsl,imx6q-iomuxc-gpr regmap\n");
+	regmap_update_bits(gpr, IOMUXC_GPR1, IMX6Q_GPR1_ENET_CLK_SEL_MASK,
+			   clksel);
 
 	clk_put(enet_ref);
 put_ptp_clk:
-- 
2.17.1

