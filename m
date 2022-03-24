Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576674E6B32
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 00:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355752AbiCXX0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 19:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235505AbiCXX0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 19:26:15 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81089A0BFB;
        Thu, 24 Mar 2022 16:24:43 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mp11-20020a17090b190b00b001c79aa8fac4so3197806pjb.0;
        Thu, 24 Mar 2022 16:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IrAe0P3QA00oC+fcV4Zr1lgJy+9TX66SlaGuE8vWZVM=;
        b=Yy8eVIdPq05y+roqwuHtXC+tzEvYiQs7NTlJyC7efQCxIIgFj34+19J2D7yQpgaFnQ
         xv5S/yCKEMb/P9uFzqPB3IsB4/EyZl4ayM9WUhdRJn7Ob9drdGudk00c3PIMpyzgACN8
         FblIW5ImAnhV1qb3hNwDzn7Q5jY8BMtikaszIwSs2LOa0HRVHQ/FtSOOIcC6NIrYeadr
         jEpFiQqv+kJ44y5OWAdUAr0vkHrNyFU2edUiM7N69+aOW7C3dNOd/joEgl50/i9G0/sG
         gZFKp/pif6LeJZwJuXw+J+HxWWdtMSuXTr0Ay+hR3suI2ITysRZPvHbzaqJfWFDVSh4E
         3fhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IrAe0P3QA00oC+fcV4Zr1lgJy+9TX66SlaGuE8vWZVM=;
        b=QsCOOiqfv3KGNSuev8GrSFZFzNae99Wai+q9E1En/5SeRDI/E8nrK7BpUncsF+D5ND
         5Q6gxU0Ri8V6XBixAIK5SGeSXexdFuZzDwodLghUuB03dl+yYV1R5aTk9mknpjSoE48U
         ExdQL4YaVsjvHNyHwZLpnnKsMk6Yv6SHtDf9oSNA5UxeQWSb057BNNs76pJ+lKoZKtLl
         Grt+NyymUtPL32RI6IDAGXDMQQ4ze9RBIQW53KbZ9i3PCnsm/trqpIhnz15LhFd/qLD/
         hQ8nyVFEs2pVySRHxYVdbKwm47F4D9QyoNwRsXHKIMQ4sF8VFlOC2AZenKZqB9V6Dhog
         v+Zw==
X-Gm-Message-State: AOAM532J9f2AaaW5APBxqlfNVQzuaOlqCVTCLaDwavwfuHTe+aLv5erD
        YYpsPlQh97jPs9uEQdlibMo01K7wJ+M=
X-Google-Smtp-Source: ABdhPJwKio8EGT/llkIMVngWClqmDG3NLPLz6pdEP+J4j+EC0hQdS3pIOKetW019j2E2Z3wYXzQU3w==
X-Received: by 2002:a17:902:a3c1:b0:14f:dc65:ff6c with SMTP id q1-20020a170902a3c100b0014fdc65ff6cmr8327410plb.13.1648164282634;
        Thu, 24 Mar 2022 16:24:42 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j9-20020a056a00130900b004f73df40914sm4483813pfu.82.2022.03.24.16.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 16:24:42 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     opendmb@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <mchan@broadcom.com>,
        Benjamin Li <benli@broadcom.com>,
        Matt Carlson <mcarlson@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net v2] net: phy: broadcom: Fix brcm_fet_config_init()
Date:   Thu, 24 Mar 2022 16:24:38 -0700
Message-Id: <20220324232438.1156812-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A Broadcom AC201 PHY (same entry as 5241) would be flagged by the
Broadcom UniMAC MDIO controller as not completing the turn around
properly since the PHY expects 65 MDC clock cycles to complete a write
cycle, and the MDIO controller was only sending 64 MDC clock cycles as
determined by looking at a scope shot.

This would make the subsequent read fail with the UniMAC MDIO controller
command field having MDIO_READ_FAIL set and we would abort the
brcm_fet_config_init() function and thus not probe the PHY at all.

After issuing a software reset, wait for at least 1ms which is well
above the 1us reset delay advertised by the datasheet and issue a dummy
read to let the PHY turn around the line properly. This read
specifically ignores -EIO which would be returned by MDIO controllers
checking for the line being turned around.

If we have a genuine reaad failure, the next read of the interrupt
status register would pick it up anyway.

Fixes: d7a2ed9248a3 ("broadcom: Add AC131 phy support")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:

- explicitly include delay.h for usleep_range

 drivers/net/phy/broadcom.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 3c683e0e40e9..e36809aa6d30 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -11,6 +11,7 @@
  */
 
 #include "bcm-phy-lib.h"
+#include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/phy.h>
 #include <linux/brcmphy.h>
@@ -602,6 +603,26 @@ static int brcm_fet_config_init(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
+	/* The datasheet indicates the PHY needs up to 1us to complete a reset,
+	 * build some slack here.
+	 */
+	usleep_range(1000, 2000);
+
+	/* The PHY requires 65 MDC clock cycles to complete a write operation
+	 * and turnaround the line properly.
+	 *
+	 * We ignore -EIO here as the MDIO controller (e.g.: mdio-bcm-unimac)
+	 * may flag the lack of turn-around as a read failure. This is
+	 * particularly true with this combination since the MDIO controller
+	 * only used 64 MDC cycles. This is not a critical failure in this
+	 * specific case and it has no functional impact otherwise, so we let
+	 * that one go through. If there is a genuine bus error, the next read
+	 * of MII_BRCM_FET_INTREG will error out.
+	 */
+	err = phy_read(phydev, MII_BMCR);
+	if (err < 0 && err != -EIO)
+		return err;
+
 	reg = phy_read(phydev, MII_BRCM_FET_INTREG);
 	if (reg < 0)
 		return reg;
-- 
2.25.1

