Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2106654685D
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 16:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349528AbiFJObb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 10:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348955AbiFJOax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 10:30:53 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA3C19C38;
        Fri, 10 Jun 2022 07:30:51 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id gc3-20020a17090b310300b001e33092c737so2233581pjb.3;
        Fri, 10 Jun 2022 07:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iYVmmQqAsnpwPZPwlBIXSEQyMSUnOxA1Ec7AdjDsOF4=;
        b=BXynBzGBdA9hjMpwOg9O/wpfCYtepvlZzAXCstgro/D3UrqhcVMVlRAgTMDbI7R7BB
         9uH8PJT9DZJgXNDeHF+i01o4G6INEZYFcrE2Wo3NaCvU16xzbvzHuNz7lifq3hwDZ+v8
         hd3w5zy5xAk2Su7rZFgQ0h/HbOzzwvrfxCEhurz128iNByW9kXBVm8qbGaFD6cKNw5nW
         SBxGBXPy4uPjnBSZDGVg3gmE06S3CkKiU8BVnQOLJ7g3x900ZeGu4k0BW5jSirctq+U2
         gFibpSsWx/RP2wqplMs/Kf3h9nUz134lHWU/4fc3pJaDb12tDPsVq4pgQ13we847N7DH
         B3bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=iYVmmQqAsnpwPZPwlBIXSEQyMSUnOxA1Ec7AdjDsOF4=;
        b=suNgaTM+rY7EPWud1ql731MjfVYw1+wS2TDDgw32Xze/deGR8lGEBybxCFpgWhQ9qk
         vzS8lk4eVWV18VDXxgUf791zrx04OSm/UdsFO+Yq4q0nx5c8gP+e0E2z3em/h+F8u78a
         nP5jrdZXHE39VnGluVztF03WHhlvJWRPtanf8LyM9W6dwr0YXOA3WCHVAKIbrwUgOV1I
         j0ZnKKj2Cu61iRPhc9MpVGyHpjKqFkAR3DpSS4K5h+k4fJRC8KOTt1JxIFZtIvw5zYLj
         EWx6V4BzvrxJyiMn+l4qQJyhrfKsnIXHJ6hG/KCn1XDrhpEG+6x1sZgZcfBZaamt+UFo
         RAkQ==
X-Gm-Message-State: AOAM531kR0Z91SyY2fq1vNNYh8y7/jrDxlCvNAmM4QN3A4JsGE50hd/Z
        CKREgHG8bx7txvZ+Qzeaw98=
X-Google-Smtp-Source: ABdhPJyUr8+mDhQKsMirGOvq4oyBiQu7TpPx6iM48QSY1iY0C4yKcehR5nvN3t/ebD/OZnTUCzwkDg==
X-Received: by 2002:a17:903:248:b0:155:e660:b774 with SMTP id j8-20020a170903024800b00155e660b774mr45886023plh.174.1654871451177;
        Fri, 10 Jun 2022 07:30:51 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id s6-20020a170902ea0600b0016232dbd01fsm18851339plg.292.2022.06.10.07.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 07:30:50 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v6 5/7] net: Kconfig: move the CAN device menu to the "Device Drivers" section
Date:   Fri, 10 Jun 2022 23:30:07 +0900
Message-Id: <20220610143009.323579-6-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220610143009.323579-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220610143009.323579-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
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
index 5335f3afc0a5..806f15146f69 100644
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

