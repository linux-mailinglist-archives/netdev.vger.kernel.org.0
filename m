Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25C553D7D2
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 18:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239017AbiFDQd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 12:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238681AbiFDQdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 12:33:08 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4893A39694;
        Sat,  4 Jun 2022 09:32:55 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id w21so9484215pfc.0;
        Sat, 04 Jun 2022 09:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=agCu5duaP2yRZbB8x8TElHRh/rx3kgk6Ng8uUqbAkb0=;
        b=blhMq/g6bIz0SW4AGzZN+kavtWYqy1zINCdLwEHLRFIGrkaeQXpoi8qzkkoGO7YRvA
         dty8YCz2Ttnlxu4AiDXKzoO4JLs9IqGijSZkSSi47doPgKBn9PkVMonf1qJqLQmkXGwt
         ge/VWBJ9u8rcOZ6GShfQwFeKffS1SolhbqDO/l2+Sn9DXYLH6R+2JNsRnmslZc89EWkl
         f0MUOAAiTF6sw/7g67uMdVgv4d6Q6++92DU3LqRilRutrwuVL89zQhT9AiEe2s/erVZt
         8PjVbP95AUx1BMLfJOlZU6qj63XQJOQA4orNRfQFkhgOh/l24cuvho7WSgZpHiL5ggBE
         Gn1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=agCu5duaP2yRZbB8x8TElHRh/rx3kgk6Ng8uUqbAkb0=;
        b=64ZDY9SSE5sGD4asheRBjs87L8Swp276fxFejOpVafNQNOLxeqHjAIIjoEwPsLtDLe
         34gXe/e2CxImSaQzChEOTsXDeRMVXCxtGDzLSMfgYEes9tp8MHSiAfNFJDajwBgqwG0m
         qSqmIWjoJ16g0qYN/GS5pF3dgqEid62m13djrGzt4b7HCpEbjylNFvO71EYXnFYnNLXI
         RmushnF9ZSFDyObmFJ5izmTAVZ49IwrjTAi8ahXX1AwmI6Nz10fx01tZw1cnTq7GlwYZ
         17jQGOH+Ermi+icdYH5bLXiH9cQFSZlgdfbe7cWpnIjQnDdqFWlMfGRGdA3MLBZgiRmt
         x8Sg==
X-Gm-Message-State: AOAM530eRfFewJ+ttaTaMBsbpTFvs0uoGpvzm5EN0GxSGa2MINnjPWQ2
        UQPQfrdO+nFneVgXMmE+kWQ=
X-Google-Smtp-Source: ABdhPJz3E287L4EMAW/1XV7S3KBFudykJkNlQhVU+E+Z/iO4uQw46tfFFonxP36HU96LEVy5+v2tqw==
X-Received: by 2002:a63:90c9:0:b0:3fc:f0c9:d0f with SMTP id a192-20020a6390c9000000b003fcf0c90d0fmr10780089pge.608.1654360374573;
        Sat, 04 Jun 2022 09:32:54 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id t8-20020a17090a3b4800b001e34b5ed5a7sm8424874pjf.35.2022.06.04.09.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 09:32:54 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v5 5/7] net: Kconfig: move the CAN device menu to the "Device Drivers" section
Date:   Sun,  5 Jun 2022 01:29:58 +0900
Message-Id: <20220604163000.211077-6-mailhol.vincent@wanadoo.fr>
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

The devices are meant to be under the "Device Drivers" category of the
menuconfig. The CAN subsystem is currently one of the rare exception
with all of its devices under the "Networking support" category.

The CAN_DEV menuentry gets moved to fix this discrepancy. The CAN menu
is added just before MCTP in order to be consistent with the current
order under the "Networking support" menu.

A dependency on CAN is added to CAN_DEV so that the CAN devices only
show up if the CAN subsystem is enabled.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/Kconfig     | 2 ++
 drivers/net/can/Kconfig | 1 +
 net/can/Kconfig         | 5 ++---
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index b2a4f998c180..5de243899de8 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -499,6 +499,8 @@ config NET_SB1000
 
 source "drivers/net/phy/Kconfig"
 
+source "drivers/net/can/Kconfig"
+
 source "drivers/net/mctp/Kconfig"
 
 source "drivers/net/mdio/Kconfig"
diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index 91e4af727d1f..17656beb6bda 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -3,6 +3,7 @@
 menuconfig CAN_DEV
 	tristate "CAN Device Drivers"
 	default y
+	depends on CAN
 	help
 	  Controller Area Network (CAN) is serial communications protocol up to
 	  1Mbit/s for its original release (now known as Classical CAN) and up
diff --git a/net/can/Kconfig b/net/can/Kconfig
index a9ac5ffab286..cb56be8e3862 100644
--- a/net/can/Kconfig
+++ b/net/can/Kconfig
@@ -15,7 +15,8 @@ menuconfig CAN
 	  PF_CAN is contained in <Documentation/networking/can.rst>.
 
 	  If you want CAN support you should say Y here and also to the
-	  specific driver for your controller(s) below.
+	  specific driver for your controller(s) under the Network device
+	  support section.
 
 if CAN
 
@@ -69,6 +70,4 @@ config CAN_ISOTP
 	  If you want to perform automotive vehicle diagnostic services (UDS),
 	  say 'y'.
 
-source "drivers/net/can/Kconfig"
-
 endif
-- 
2.35.1

