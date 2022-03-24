Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF224E6A6B
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 22:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346308AbiCXV4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 17:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiCXV4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 17:56:32 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5668B7C4E;
        Thu, 24 Mar 2022 14:54:59 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mp6-20020a17090b190600b001c6841b8a52so10608277pjb.5;
        Thu, 24 Mar 2022 14:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CCavVVAtkRp6WPcm2Jz+S7uZ05dcaTIlvaxgnR52TTU=;
        b=dRs1UktqGL6uMHIp4JBM4J1Z1VoFH7Ssj0y/WJuqcUOnEt/FUIGNyQtun2vCNkfPMa
         PyGey80DsZ2g8nJXlRkt3YM9wc1SOItvi3vzoz3LsIKFksh/UzBv8RlNitXd2gphuoPH
         aU3KVMF3xTDxr89BLGDuBkorYUqBxlIh5ljjn1BYJY16VYKdPEicb9e4FS8zDEhtEGNh
         tD+83m8o9Hon3cJPs/Nlbz6PPkeHOiXoIZ0Vp43OTogaVrwuFEpkXI9ZogPXqMhy38ex
         p1t7MWFpiuy5hCKnzTyjdpMYOo5g2X+LC9nTkawR86oNZawWfWJZQAOI0pIB6ly5dRWb
         dKoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CCavVVAtkRp6WPcm2Jz+S7uZ05dcaTIlvaxgnR52TTU=;
        b=dzTV5jEztAARNl6fWOYDyaKZeo3c9SzRDtpZ7MJzft2tiDHR/1wvwwxRcWcWX3qd4r
         B+EudbjIMp8r6E72U7Ho9kXOGMnGwgHpa3gBe8yI8OHCYGkOUPKc0FlzIj6CuR0FfQ/k
         1GH/NxlV4nYHJwmpP6toB549RdMjITZ6t42S08GaCMv5Y+QDncKGwqm3LCq0IFfd0RLz
         V9Q/ayeTUoadR+1rfwo6PB7je92ziYEri8nDjW/bFHiwyErtLDinBFiwxVkChEPdbnHp
         oeVNEku+Szg/O6gB6JA2wEmDjHjdNcuYrJY0NEeLQ/TOVJQLmvkFImyrqW8CGm4H6ibK
         stkQ==
X-Gm-Message-State: AOAM532JY/HSeXG2C5fPIfuWRk6n8ygDTkijzHY6L9MZPkueRUkfciCc
        AxG8PQ9kG0n1EoWMJ0nCV66ieZakUe4=
X-Google-Smtp-Source: ABdhPJz9tgSUW18kXODJ7YtoqsSnljHs7BdODuZYaAmaN8QqKBRjRC/SmXopRBdqh5bRVZrWIc05zA==
X-Received: by 2002:a17:90a:8595:b0:1bf:4592:a819 with SMTP id m21-20020a17090a859500b001bf4592a819mr8679992pjn.183.1648158898387;
        Thu, 24 Mar 2022 14:54:58 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gt14-20020a17090af2ce00b001c701e0a129sm10389424pjb.38.2022.03.24.14.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 14:54:57 -0700 (PDT)
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
        Matt Carlson <mcarlson@broadcom.com>,
        Benjamin Li <benli@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: phy: broadcom: Fix brcm_fet_config_init()
Date:   Thu, 24 Mar 2022 14:54:51 -0700
Message-Id: <20220324215451.1151297-1-f.fainelli@gmail.com>
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

If we have a genuine read failure, the next read of the interrupt
status register would pick it up anyway.

Fixes: d7a2ed9248a3 ("broadcom: Add AC131 phy support")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 3c683e0e40e9..ae6abe146236 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -602,6 +602,26 @@ static int brcm_fet_config_init(struct phy_device *phydev)
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

