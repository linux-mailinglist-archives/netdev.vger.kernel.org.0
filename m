Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFEAE53C8B6
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 12:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243704AbiFCKaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 06:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243662AbiFCK3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 06:29:52 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DEC3BA48;
        Fri,  3 Jun 2022 03:29:50 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id c196so6904246pfb.1;
        Fri, 03 Jun 2022 03:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JfOXhlCk1wDpEvOOv4BaJTA7xSnTCyIJZTqst+9NdFc=;
        b=R//XEZ0n3L62QgxG5CxntfyT6wiYLXj6NeK9h9hGIAVh/wdxVfyB2YKwR6kW1NjYwO
         MD3CAsT4O9BzZBGdzqydxE1WwXNiVa3YVe7/og4oDyoedRkBBqYgaNlXzppzexmasaXo
         XDZMDnWNGyDJE6xXsteOAfr6utyW6lsk7NypnFAAD9ASH7vEeu6u0qRrK9S21vLRZDxX
         YyuVk701mHs8DS1ghEyNatCKEoc215x1DHNdewX/amPpNA7+J34kk+JPOLEUD/SXdzk+
         SoZElLw9UCb94wiIZQZm0PfJaChlsmhWwN+b4BMEaIwkl8ohetawIbwoqP6Awaw/giGC
         9rlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=JfOXhlCk1wDpEvOOv4BaJTA7xSnTCyIJZTqst+9NdFc=;
        b=FQzSuW3U3OjHbSWc4zG5jWECW6oB2BJxE6KAWkoLdF4PH5PXVxcbbQc4nn8UnDBOl0
         egmCP9vB2CQ0Wz4xgboeBqpFAPENpU2y8qpFw7gna4P4cyYIStFLXR+qgKuRDI4+JYoD
         +a7I0jm2UjY2eCKnPhj+ab14PPy8X54++Rh66T+e/MN4E2LJbsFs+uVWUxOIbnze2Z5S
         k3oX43oDnv4FkIvdZ93Rn3kTqtH1J1YOvyz91hlFNJiGJf22tJJz7kBOmDHJIm25NVDY
         tUzy8zMs09pJOWw3uTQco+xo1cTL+9uu0vsn06cy+aLYRHHDH1I0MwsGu5rbFlV4dqz+
         MNVQ==
X-Gm-Message-State: AOAM533TsGRpjKw9+dZHln3cVwX1Gx0U1R1nVqhZxIuaZy8ZMuZSrmT/
        oDrK/EslBTVhhGJ6b1ni/JA=
X-Google-Smtp-Source: ABdhPJw26b1830Lj+1FQek2f5WIhVINc26oWfi+u3qZ/GkdCdBOcY2KY1SxFSjJYjU5jukykHbjx4g==
X-Received: by 2002:a62:be14:0:b0:505:a43b:cf6e with SMTP id l20-20020a62be14000000b00505a43bcf6emr76935857pff.33.1654252190417;
        Fri, 03 Jun 2022 03:29:50 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id b22-20020a056a0002d600b0050dc7628182sm3041676pft.92.2022.06.03.03.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 03:29:50 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v4 4/7] can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
Date:   Fri,  3 Jun 2022 19:28:45 +0900
Message-Id: <20220603102848.17907-5-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220603102848.17907-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr>
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
writing of this patch, only three: flexcan, ti_hecc and
mcp251xfd). Give the option to the user to deselect this features
during compilation.

The drivers relying on CAN rx offload are in different sub
folders. All of these drivers get tagged with "select CAN_RX_OFFLOAD"
so that the option is automatically enabled whenever one of those
driver is chosen.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/Kconfig               | 16 ++++++++++++++++
 drivers/net/can/dev/Makefile          |  2 ++
 drivers/net/can/spi/mcp251xfd/Kconfig |  1 +
 3 files changed, 19 insertions(+)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index 8f3b97aea638..1f1d81da1c8c 100644
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
index b8a55b1d90cd..5081d8a3be57 100644
--- a/drivers/net/can/dev/Makefile
+++ b/drivers/net/can/dev/Makefile
@@ -11,3 +11,5 @@ can-dev-$(CONFIG_CAN_NETLINK) += netlink.o
 can-dev-$(CONFIG_CAN_NETLINK) += rx-offload.o
 
 can-dev-$(CONFIG_CAN_CALC_BITTIMING) += calc_bittiming.o
+
+can-dev-$(CONFIG_CAN_RX_OFFLOAD) += rx-offload.o
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

