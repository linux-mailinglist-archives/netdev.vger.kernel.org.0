Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142E354684C
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 16:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348486AbiFJOa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 10:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348048AbiFJOax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 10:30:53 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D1313FBCD;
        Fri, 10 Jun 2022 07:30:49 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j7so24159301pjn.4;
        Fri, 10 Jun 2022 07:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zHNXk/AgfFNmsI+UqDPsm2MXpI0i6kU7CMuDASj79/U=;
        b=nl04t7gokzMU7UUQfYRfxhtSFJFKqdVyWc9KiocJWk8qg68IOFxin4gKzdOuUIpXWl
         g8IafnhsqvmI/MlEvV3SsE5sVILnTOT0Gz7YCUlpXWkhFg5xDSQw96knLCp6WQZe5xw/
         vWvmNNpLima3oihrsa5HQYsWSXYs1Xt/iCVT1+HdHrzb7WgCZgvuBAzDb+INAP9N6bhn
         b3m5GSSNQDexRR+CyhEHdsktMiE0K6IqSBUhmc3a+WA7jX2SCkhDQ2B9wcSkT4DcS6Ns
         b+hFfSJeUyqXo/kQ6/rXGNwfIrX1wXVNrF5KzmFCerdbhGEUnk4QMTLCugWPyORr0kqj
         6ThA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=zHNXk/AgfFNmsI+UqDPsm2MXpI0i6kU7CMuDASj79/U=;
        b=HcNIu2YOyN/ISA8LpyI0ZRaV9pJjdfxGJzdbtTxs+QAmbfr49rYHRyP8oYhkx6LyGT
         CLFbT2WC/QfsH+B1aPY6DrWQLfBq4wFtLovaMtteqxJPshESMdihISpXOTbYgsdcGD+T
         LOWjFAuGIa/JmwYtO5wBcCyfuDCK/3dJMhmgDL3nXTpH0mBLLUbaLzUwlMfODyaBqSzq
         P6zxvYMOkuCdFY1M1ncmfBWvLyCcUMZg6+df8wXa92YkyZgWosJ90aQrzkCIfheqpa2J
         P49GZlh8qxCZAFKSm0W59TbBcG98sDd2hGsbdOiN+d0YDn7wDn4PC47R3sucnJlactMO
         88kw==
X-Gm-Message-State: AOAM5322Q+F17H1uAIYYFQWXvj97XUcwqAB8oIuyk274bWrXZj6BdEos
        iIT7hXOhaMm9gDH0p5ayiKM=
X-Google-Smtp-Source: ABdhPJyJrbUTsIZRSz08469GFWX/pT0YdkxUMnkZBnQ/wqbZ8VLU7cS9cDO2fMogrQUNYsQJEu3iOw==
X-Received: by 2002:a17:90b:4acd:b0:1e3:4dab:a14c with SMTP id mh13-20020a17090b4acd00b001e34daba14cmr50130pjb.5.1654871448775;
        Fri, 10 Jun 2022 07:30:48 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id s6-20020a170902ea0600b0016232dbd01fsm18851339plg.292.2022.06.10.07.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 07:30:48 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v6 4/7] can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
Date:   Fri, 10 Jun 2022 23:30:06 +0900
Message-Id: <20220610143009.323579-5-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220610143009.323579-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220610143009.323579-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only a few drivers rely on the CAN rx offload framework (as of the
writing of this patch, only four: flexcan, m_can, mcp251xfd and
ti_hecc). Split it out of can-dev and add a new config symbol:
CAN_RX_OFFLOAD.

The drivers relying on CAN rx offload are in different sub
folders. Make CAN_RX_OFFLOAD an hidden option and tag all the drivers
depending on that feature with "select CAN_RX_OFFLOAD" so that the
option gets automatically enabled if and only if one of those drivers
is chosen.

Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/Kconfig               | 5 +++++
 drivers/net/can/dev/Makefile          | 2 +-
 drivers/net/can/m_can/Kconfig         | 1 +
 drivers/net/can/spi/mcp251xfd/Kconfig | 1 +
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index 87470feae6b1..5335f3afc0a5 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -102,6 +102,9 @@ config CAN_CALC_BITTIMING
 
 	  If unsure, say Y.
 
+config CAN_RX_OFFLOAD
+	bool
+
 config CAN_AT91
 	tristate "Atmel AT91 onchip CAN controller"
 	depends on (ARCH_AT91 || COMPILE_TEST) && HAS_IOMEM
@@ -113,6 +116,7 @@ config CAN_FLEXCAN
 	tristate "Support for Freescale FLEXCAN based chips"
 	depends on OF || COLDFIRE || COMPILE_TEST
 	depends on HAS_IOMEM
+	select CAN_RX_OFFLOAD
 	help
 	  Say Y here if you want to support for Freescale FlexCAN.
 
@@ -162,6 +166,7 @@ config CAN_SUN4I
 config CAN_TI_HECC
 	depends on ARM
 	tristate "TI High End CAN Controller"
+	select CAN_RX_OFFLOAD
 	help
 	  Driver for TI HECC (High End CAN Controller) module found on many
 	  TI devices. The device specifications are available from www.ti.com
diff --git a/drivers/net/can/dev/Makefile b/drivers/net/can/dev/Makefile
index 791e6b297ea3..633687d6b6c0 100644
--- a/drivers/net/can/dev/Makefile
+++ b/drivers/net/can/dev/Makefile
@@ -9,4 +9,4 @@ can-dev-$(CONFIG_CAN_NETLINK) += bittiming.o
 can-dev-$(CONFIG_CAN_NETLINK) += dev.o
 can-dev-$(CONFIG_CAN_NETLINK) += length.o
 can-dev-$(CONFIG_CAN_NETLINK) += netlink.o
-can-dev-$(CONFIG_CAN_NETLINK) += rx-offload.o
+can-dev-$(CONFIG_CAN_RX_OFFLOAD) += rx-offload.o
diff --git a/drivers/net/can/m_can/Kconfig b/drivers/net/can/m_can/Kconfig
index 45ad1b3f0cd0..fc2afab36279 100644
--- a/drivers/net/can/m_can/Kconfig
+++ b/drivers/net/can/m_can/Kconfig
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 menuconfig CAN_M_CAN
 	tristate "Bosch M_CAN support"
+	select CAN_RX_OFFLOAD
 	help
 	  Say Y here if you want support for Bosch M_CAN controller framework.
 	  This is common support for devices that embed the Bosch M_CAN IP.
diff --git a/drivers/net/can/spi/mcp251xfd/Kconfig b/drivers/net/can/spi/mcp251xfd/Kconfig
index dd0fc0a54be1..877e4356010d 100644
--- a/drivers/net/can/spi/mcp251xfd/Kconfig
+++ b/drivers/net/can/spi/mcp251xfd/Kconfig
@@ -2,6 +2,7 @@
 
 config CAN_MCP251XFD
 	tristate "Microchip MCP251xFD SPI CAN controllers"
+	select CAN_RX_OFFLOAD
 	select REGMAP
 	select WANT_DEV_COREDUMP
 	help
-- 
2.35.1

