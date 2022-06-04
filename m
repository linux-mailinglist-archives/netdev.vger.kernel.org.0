Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3961F53D7D3
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 18:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238600AbiFDQdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 12:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238446AbiFDQc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 12:32:56 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79EE737AAB;
        Sat,  4 Jun 2022 09:32:50 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id q12-20020a17090a304c00b001e2d4fb0eb4so14407933pjl.4;
        Sat, 04 Jun 2022 09:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ixvx9ZCs0ZusH96SsbzvyM52UNoz2acA96dUGJ3sGy4=;
        b=TVTiRNsIgUJ4yU28ozvG3CFARR5WifYH6ixolq/Lfw7oWBhf87759ldLEPDAGIOXq7
         H/VaIiZJyum1Abe3bqcZNRy6gLXAG0TxOS3SVp8qNGfKxEK0QAE0gofQ8AeMXHxGX6+1
         xDGSbqmDHqWUkd787ctWBDArCSpU56Dl9I5OjUMwAKRclMTRI63USuYA1jlFHgb9dKxr
         Tf/c7HJpPdJl1O10hP///ekYV/jlM8lLkeuUAC40zVTd9gjxuWgjH2Vc+tCvCJL2dB9h
         UPsyyd9cF/bljxlhfQecvDahLNHICgJ4tsc2aXIgRUMB/AhXQa4domif/cYiZBu4XlQD
         g5xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=ixvx9ZCs0ZusH96SsbzvyM52UNoz2acA96dUGJ3sGy4=;
        b=KjYV1XIJFapfRj3Wdeh4obCoWypWjcpx490Z3nrcNfZjRtjCIwn+0guGK1sW/mhVLw
         xhiSx0/YBrURRg3VtMPhLc4LDJYcrl463v4UZIotMN4eCqT2OdLBklK5/C7msJWLB1pj
         NDWaWgLzBOpVR+/9Kle+v6ospQil2LnHjh32t1ew1+uH70Adnfi8v1E4n3po/LQB96c7
         R51aC0VvzUFbHt849kigCpnVft5RPDa4TtSRScCYjOLBtcX3dvRn8Z/gjxJnY3OZ9/wj
         oR5ss22ir4kO3fYJTcO54y1oP3PmOWcBfX+BxRhZARKVuNK/VpyA9J/AxhZcu8g0ezFu
         T4vw==
X-Gm-Message-State: AOAM530Q0lyo2jyz3rwnyR4TZA7b86+3+pYFSd9l62Jiiq6sOvN9Z6QB
        6mNFKBQ2PSX72pTGbPGC9TY=
X-Google-Smtp-Source: ABdhPJxhb8MGVtj3pEcfJ55o9ojo/zwQbjnthgudxvCcmUyaugQyCcQkqbnFtnudpx4M9W6RNDR/LQ==
X-Received: by 2002:a17:902:c945:b0:163:c3c3:aff8 with SMTP id i5-20020a170902c94500b00163c3c3aff8mr15594129pla.56.1654360369949;
        Sat, 04 Jun 2022 09:32:49 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id t8-20020a17090a3b4800b001e34b5ed5a7sm8424874pjf.35.2022.06.04.09.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 09:32:49 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v5 4/7] can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
Date:   Sun,  5 Jun 2022 01:29:57 +0900
Message-Id: <20220604163000.211077-5-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only a few drivers rely on the CAN rx offload framework (as of the
writing of this patch, only four: flexcan, m_can, mcp251xfd and
ti_hecc). Give the option to the user to deselect this features during
compilation.

The drivers relying on CAN rx offload are in different sub
folders. All of these drivers get tagged with "select CAN_RX_OFFLOAD"
so that the option is automatically enabled whenever one of those
driver is chosen.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/Kconfig               | 16 ++++++++++++++++
 drivers/net/can/dev/Makefile          |  2 +-
 drivers/net/can/m_can/Kconfig         |  1 +
 drivers/net/can/spi/mcp251xfd/Kconfig |  1 +
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index 87470feae6b1..91e4af727d1f 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -102,6 +102,20 @@ config CAN_CALC_BITTIMING
 
 	  If unsure, say Y.
 
+config CAN_RX_OFFLOAD
+	bool "CAN RX offload"
+	default y
+	help
+	  Framework to offload the controller's RX FIFO during one
+	  interrupt. The CAN frames of the FIFO are read and put into a skb
+	  queue during that interrupt and transmitted afterwards in a NAPI
+	  context.
+
+	  The additional features selected by this option will be added to the
+	  can-dev module.
+
+	  If unsure, say Y.
+
 config CAN_AT91
 	tristate "Atmel AT91 onchip CAN controller"
 	depends on (ARCH_AT91 || COMPILE_TEST) && HAS_IOMEM
@@ -113,6 +127,7 @@ config CAN_FLEXCAN
 	tristate "Support for Freescale FLEXCAN based chips"
 	depends on OF || COLDFIRE || COMPILE_TEST
 	depends on HAS_IOMEM
+	select CAN_RX_OFFLOAD
 	help
 	  Say Y here if you want to support for Freescale FlexCAN.
 
@@ -162,6 +177,7 @@ config CAN_SUN4I
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

