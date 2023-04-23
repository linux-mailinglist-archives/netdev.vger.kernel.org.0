Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9CFB6EC15F
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 19:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjDWR21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 13:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjDWR20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 13:28:26 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82E3E55;
        Sun, 23 Apr 2023 10:28:24 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f18335a870so22292055e9.0;
        Sun, 23 Apr 2023 10:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682270903; x=1684862903;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rmFnPlf15TJG9qiredh4hyrIMNo2fBNHqd9NUoV+idk=;
        b=Eu6XOWyJ3ZHyolw01znSdBZJ2WU1+fPNFWxkpMCEtdOXHBFPfmBWY7tqEbwJX/xDf0
         7imy0hQcMl7s/Q7c6ZJeiDuZYoyCBG57hXpyb7LWHGYnOKTK3lFGsIqdHPc/yb3FmvIO
         8d8CqD6fNwFIoV39AZ2usOxrZKFgahKKTHs9DRuknu07P2eXA6cky2jjZ3gQjy1fRnPG
         6EC+V8wJUguVsLGA/m3Afauza6rQF/F8RaDEpkTaaRivorFJmyKV0IskvNJO1z3Hwm+o
         kiO92A/Dh8dVOoO2Ki4kxj7Y8ssZaOlxZXWBJIM6qR+7R3C2rJ6zene9f88zykZ4Elcj
         lUpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682270903; x=1684862903;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rmFnPlf15TJG9qiredh4hyrIMNo2fBNHqd9NUoV+idk=;
        b=b1G/4q3XHo3xsPqxtO206ELVCWn6+utAaapYmU8UKdXHmTq2VGMg5oloXbw06jDzm/
         y3Rdqs/Q1puYCoOjQegxRNnZwWadlbFl88/lUJYYNpEL9sHqkkqKHXC4Sdo+W3Wj2MVL
         j7No50ysILULb1EMBbv0LLA24oTNm1HhoVXlNHhG5zYNI65cUZMafnzvFo9g5nPdPdcO
         CZG/uGtCkgKzQSzgSoM8qJRhkj6k5CGi9X1htM3W+24CCtDpQ4k1DkRt+9YUiDdiPsYI
         t9ZJh5EYoKkvADiXv7imcaL7Abh7DLahaEdYNn2GCGB/1fjQYXjlmpVmZyDpnS+VQREc
         S0lg==
X-Gm-Message-State: AAQBX9fl22AKag7iTfZnc59d+jnSSJ1Foxb7Utr7Nguk+NPTPRyNIS1p
        gJ1FEKZMkd9gKrmVWOL2uDs=
X-Google-Smtp-Source: AKy350ZtT9vViOegiwHejx/+hxpNEokE6V0LFdTiMW1+9K2qjHVu2wPjXw4+mTK6lP2uN95ykgWd1A==
X-Received: by 2002:a7b:c4cd:0:b0:3f1:8e33:8c68 with SMTP id g13-20020a7bc4cd000000b003f18e338c68mr6187193wmk.26.1682270902822;
        Sun, 23 Apr 2023 10:28:22 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id n10-20020a1c720a000000b003edef091b17sm10024886wmc.37.2023.04.23.10.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 10:28:22 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>
Subject: [net-next PATCH] net: phy: marvell: Fix inconsistent indenting in led_blink_set
Date:   Sun, 23 Apr 2023 19:28:00 +0200
Message-Id: <20230423172800.3470-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
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

Fix inconsistent indeinting in m88e1318_led_blink_set reported by kernel
test robot, probably done by the presence of an if condition dropped in
later revision of the same code.

Cc: Andrew Lunn <andrew@lunn.ch>
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202304240007.0VEX8QYG-lkp@intel.com/
Fixes: 46969f66e928 ("net: phy: marvell: Implement led_blink_set()")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/phy/marvell.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index cd5d0ed9c5e5..43b6cb725551 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2880,10 +2880,10 @@ static int m88e1318_led_blink_set(struct phy_device *phydev, u8 index,
 	case 1:
 	case 2:
 		reg &= ~(0xf << (4 * index));
-			reg |= MII_88E1318S_PHY_LED_FUNC_BLINK << (4 * index);
-			/* Reset default is 84ms */
-			*delay_on = 84 / 2;
-			*delay_off = 84 / 2;
+		reg |= MII_88E1318S_PHY_LED_FUNC_BLINK << (4 * index);
+		/* Reset default is 84ms */
+		*delay_on = 84 / 2;
+		*delay_off = 84 / 2;
 		break;
 	default:
 		return -EINVAL;
-- 
2.39.2

