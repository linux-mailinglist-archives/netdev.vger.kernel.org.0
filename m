Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084992C767F
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732325AbgK1WzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 17:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgK1WzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 17:55:22 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2E0C0617A7;
        Sat, 28 Nov 2020 14:54:41 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id e7so9790792wrv.6;
        Sat, 28 Nov 2020 14:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IRkMx7ynKm/yM0ch5pBsS12yNk9GRJdtum4GLiNHEJc=;
        b=qm5mslSvMdUBojxedLrGXh1DWlvwNDRbalZDfnEgF6qgnev418PVBXJmKFVDXFPxqx
         IPv3ddQ7g7/QV8tLpBVgV7O0f0IQlSWOcG9upCOk+PiOGM9L5azm6oMozbEgvwwdHk5F
         WHE22H9/61e/g9JxY6dfUMpQkt3Yvi722RhMJtNwMTxe8m/zAVj/Z75gkeGIK7oUgsUu
         UxmhdBkBRC9CFrivux/3tc3V8jy7FFwQaRjUmUbOuYYBeeWVYLK56PAhCPnFsGvLPvCL
         T3I4FTaCt7OAp/UcS5qhqnPhgZpzVTyMy6pKSLvP332u3ms8jxJbR/C3q8zdQgLYv7rt
         Cx8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IRkMx7ynKm/yM0ch5pBsS12yNk9GRJdtum4GLiNHEJc=;
        b=DIWE7lEPPWx3cxr2oaXT4GwEdPQuRAuNRbdLwxxO1Xxw+yS0Pvi8odGuBmsARjj2YE
         gqv4FUCSjDwai9mzuV2N/urp1mYWlSaC1UibQ7kb7mVDbAgSXHAeAIEXwO9oznQGBFts
         mr3vPjmzmjoxlzuymAfv/9J4qPLByu2wgt2RBzq5F86D8v2G+JAcDbYryLXexs/QdaUH
         fH3K1jaQkNXGJRoBM5zkauj13/L2uiCTgVoFqCliQLtNivrX3hrS+1as/UoiWd2Z0qU9
         bSzJsSJLPdMb5Ef7LimcLdBm8gDmcLdh0+C0eM3AY1EuZoyKFLTozbNNJbloNXE6h7oj
         SYlA==
X-Gm-Message-State: AOAM5319QqZwX+j3JGHisiM24JO/HSxVbPAS/Rn4AalRpCJsgQQ6Bl0U
        fe9/G9DpKB0T0O4czjXSMnk=
X-Google-Smtp-Source: ABdhPJw/PY5xI6P8Zh3sO6jtAXPj7BSsmSNtXjs694JDjXR4kYu9nvTS8Z9JkGtgax+0rK4NWt8pjg==
X-Received: by 2002:adf:b64f:: with SMTP id i15mr20021633wre.125.1606604080437;
        Sat, 28 Nov 2020 14:54:40 -0800 (PST)
Received: from adgra-XPS-15-9570.home (lfbn-idf1-1-1007-144.w86-238.abo.wanadoo.fr. [86.238.83.144])
        by smtp.gmail.com with ESMTPSA id d13sm24231506wrb.39.2020.11.28.14.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 14:54:40 -0800 (PST)
From:   Adrien Grassein <adrien.grassein@gmail.com>
Cc:     fugang.duan@nxp.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrien Grassein <adrien.grassein@gmail.com>
Subject: [PATCH 3/3] net: fsl: fec: add imx8mq support.
Date:   Sat, 28 Nov 2020 23:54:25 +0100
Message-Id: <20201128225425.19300-3-adrien.grassein@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201128225425.19300-1-adrien.grassein@gmail.com>
References: <20201128225425.19300-1-adrien.grassein@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the imx8mq support to the
fsl fec driver.
Quirks are extracted from the NXP driver (5.4).

Signed-off-by: Adrien Grassein <adrien.grassein@gmail.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index e5c0a5da9965..92ad5b86d31c 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -131,6 +131,14 @@ static const struct fec_devinfo fec_imx6ul_info = {
 		  FEC_QUIRK_HAS_COALESCE | FEC_QUIRK_CLEAR_SETUP_MII,
 };
 
+static const struct fec_devinfo fec_imx8mq_info = {
+	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
+		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
+		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
+		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
+		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE
+};
+
 static struct platform_device_id fec_devtype[] = {
 	{
 		/* keep it for coldfire */
@@ -158,6 +166,11 @@ static struct platform_device_id fec_devtype[] = {
 		.name = "imx6ul-fec",
 		.driver_data = (kernel_ulong_t)&fec_imx6ul_info,
 	}, {
+		.name = "imx8mq-fec",
+		.driver_data = (kernel_ulong_t)&fec_imx8mq_info,
+	},
+
+	{
 		/* sentinel */
 	}
 };
@@ -171,6 +184,7 @@ enum imx_fec_type {
 	MVF600_FEC,
 	IMX6SX_FEC,
 	IMX6UL_FEC,
+	IMX8MQ_FEC,
 };
 
 static const struct of_device_id fec_dt_ids[] = {
@@ -181,6 +195,8 @@ static const struct of_device_id fec_dt_ids[] = {
 	{ .compatible = "fsl,mvf600-fec", .data = &fec_devtype[MVF600_FEC], },
 	{ .compatible = "fsl,imx6sx-fec", .data = &fec_devtype[IMX6SX_FEC], },
 	{ .compatible = "fsl,imx6ul-fec", .data = &fec_devtype[IMX6UL_FEC], },
+	{ .compatible = "fsl,imx8mq-fec", .data = &fec_devtype[IMX8MQ_FEC], },
+
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, fec_dt_ids);
-- 
2.20.1

