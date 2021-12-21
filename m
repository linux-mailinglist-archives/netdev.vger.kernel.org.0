Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF50D47BD50
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 10:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236680AbhLUJsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 04:48:01 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:20076 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236654AbhLUJr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 04:47:59 -0500
X-IronPort-AV: E=Sophos;i="5.88,223,1635174000"; 
   d="scan'208";a="104225017"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 21 Dec 2021 18:47:57 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 5D6924006199;
        Tue, 21 Dec 2021 18:47:53 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        dmaengine@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-serial@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH 04/16] soc: renesas: Identify RZ/V2L SoC
Date:   Tue, 21 Dec 2021 09:47:05 +0000
Message-Id: <20211221094717.16187-5-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

Add support for identifying the RZ/V2L (R9A07G054) SoC.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/soc/renesas/Kconfig       |  5 +++++
 drivers/soc/renesas/renesas-soc.c | 13 +++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/soc/renesas/Kconfig b/drivers/soc/renesas/Kconfig
index 2cbd03db2cc7..90f4f98be29c 100644
--- a/drivers/soc/renesas/Kconfig
+++ b/drivers/soc/renesas/Kconfig
@@ -296,6 +296,11 @@ config ARCH_R9A07G044
 	help
 	  This enables support for the Renesas RZ/G2L SoC variants.
 
+config ARCH_R9A07G054
+	bool "ARM64 Platform support for RZ/V2L"
+	help
+	  This enables support for the Renesas RZ/V2L SoC variants.
+
 endif # ARM64
 
 config RST_RCAR
diff --git a/drivers/soc/renesas/renesas-soc.c b/drivers/soc/renesas/renesas-soc.c
index 9608fa728c23..6084325bf98f 100644
--- a/drivers/soc/renesas/renesas-soc.c
+++ b/drivers/soc/renesas/renesas-soc.c
@@ -64,6 +64,10 @@ static const struct renesas_family fam_rzg2l __initconst __maybe_unused = {
 	.name	= "RZ/G2L",
 };
 
+static const struct renesas_family fam_rzv2l __initconst __maybe_unused = {
+	.name	= "RZ/V2L",
+};
+
 static const struct renesas_family fam_shmobile __initconst __maybe_unused = {
 	.name	= "SH-Mobile",
 	.reg	= 0xe600101c,		/* CCCR (Common Chip Code Register) */
@@ -144,6 +148,11 @@ static const struct renesas_soc soc_rz_g2l __initconst __maybe_unused = {
 	.id     = 0x841c447,
 };
 
+static const struct renesas_soc soc_rz_v2l __initconst __maybe_unused = {
+	.family = &fam_rzv2l,
+	.id     = 0x8447447,
+};
+
 static const struct renesas_soc soc_rcar_m1a __initconst __maybe_unused = {
 	.family	= &fam_rcar_gen1,
 };
@@ -334,6 +343,9 @@ static const struct of_device_id renesas_socs[] __initconst = {
 #if defined(CONFIG_ARCH_R9A07G044)
 	{ .compatible = "renesas,r9a07g044",	.data = &soc_rz_g2l },
 #endif
+#if defined(CONFIG_ARCH_R9A07G054)
+	{ .compatible = "renesas,r9a07g054",	.data = &soc_rz_v2l },
+#endif
 #ifdef CONFIG_ARCH_SH73A0
 	{ .compatible = "renesas,sh73a0",	.data = &soc_shmobile_ag5 },
 #endif
@@ -367,6 +379,7 @@ static const struct renesas_id id_prr __initconst = {
 static const struct of_device_id renesas_ids[] __initconst = {
 	{ .compatible = "renesas,bsid",			.data = &id_bsid },
 	{ .compatible = "renesas,r9a07g044-sysc",	.data = &id_rzg2l },
+	{ .compatible = "renesas,r9a07g054-sysc",	.data = &id_rzg2l },
 	{ .compatible = "renesas,prr",			.data = &id_prr },
 	{ /* sentinel */ }
 };
-- 
2.17.1

