Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3672B4AF43C
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 15:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235106AbiBIOj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 09:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbiBIOj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 09:39:57 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39D0C06157B;
        Wed,  9 Feb 2022 06:40:00 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id z35so4659895pfw.2;
        Wed, 09 Feb 2022 06:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aO4fss2Kmx8HXgCQ0bzR08QPyCBZELu4B0EYTyczINo=;
        b=aU3YQVKJbd9ljuFhYwuOMQbok4ZtDOreJ3/sOBsE90UxWU5YUc0CpZ1WSGJJJufXV/
         p7lpfI89HdfTCYcIBHc6uGz21TBljfzRi53l652TC1wr6EyMN3g1MF3FgOW+yGG8EsHg
         Mf7Wd8nGYsg6puc19z+YLJBXfd7O/UipITmWcKHW0lddc3oTeLHvj7dlt1SvP2TlrlTt
         m6CbZAQVDgDarm57zOxVILgV4zECCSVwiZo4yFHD8OGT2gI15VbTqN9Qs551pUj68S1f
         RXPhqzeiPUHBRL0O1kp3DrCKDE7JDxRqGhSchIKn41vaNrLc9aGWKY4brJX68QNPNhbc
         hW9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aO4fss2Kmx8HXgCQ0bzR08QPyCBZELu4B0EYTyczINo=;
        b=B3BNQFPzk4m9ftjiE6lKn7Y+xvOQBYKNKJatNFOJpdKU+X7lX+ZcGcxzbicFK+VfkO
         1rl7SfcuY88ZOfXWbshlA38sJsnAT/tbUKuDhMNTEGloJoTsAqRl/q5zXfmWxGcX/8LU
         B3YtnkdVIgRTOqbHcTZ2jgJ3AXS/3ef6yqnmaTcpksoNxmUvQcX0D3bT/NzxRcBHLzhD
         VldV2C19rOQU9LaLpW6vPmcq3pe3VuhnIpchtVU0RB37I3RsXqdv168ECeEMNE8SY4i/
         pdJV6CowkqdFpE10nDdvPgOielAqO5lH97v+gn3COu11WUA3R7Lv0ck/fXZsFiaTpNkG
         gr4g==
X-Gm-Message-State: AOAM532Ryymfn1pQqxTgtbwWiGpgSt6uwn1566REcTJ2SjZM3zIyAlGJ
        aSl/J1ZEW+WE2kSB7oEXYiAln3vcDUY2gQ==
X-Google-Smtp-Source: ABdhPJxrjvgHhaZfZsKO5GvaCN6MHn5ZXO3ESedIlFsIiE8VU0hgKpTCaWJs6TA5Td/4tfHRJNRyAA==
X-Received: by 2002:a63:74e:: with SMTP id 75mr2136067pgh.452.1644417600017;
        Wed, 09 Feb 2022 06:40:00 -0800 (PST)
Received: from localhost.localdomain ([114.91.20.102])
        by smtp.gmail.com with ESMTPSA id o8sm20511586pfu.52.2022.02.09.06.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 06:39:59 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH net] net: phy: mediatek: remove PHY mode check on MT7531
Date:   Wed,  9 Feb 2022 22:39:47 +0800
Message-Id: <20220209143948.445823-1-dqfext@gmail.com>
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

The function mt7531_phy_mode_supported in the DSA driver set supported
mode to PHY_INTERFACE_MODE_GMII instead of PHY_INTERFACE_MODE_INTERNAL
for the internal PHY, so this check breaks the PHY initialization:

mt7530 mdio-bus:00 wan (uninitialized): failed to connect to PHY: -EINVAL

Remove the check to make it work again.

Reported-by: Hauke Mehrtens <hauke@hauke-m.de>
Fixes: e40d2cca0189 ("net: phy: add MediaTek Gigabit Ethernet PHY driver")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/phy/mediatek-ge.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/phy/mediatek-ge.c b/drivers/net/phy/mediatek-ge.c
index b7a5ae20edd5..68ee434f9dea 100644
--- a/drivers/net/phy/mediatek-ge.c
+++ b/drivers/net/phy/mediatek-ge.c
@@ -55,9 +55,6 @@ static int mt7530_phy_config_init(struct phy_device *phydev)
 
 static int mt7531_phy_config_init(struct phy_device *phydev)
 {
-	if (phydev->interface != PHY_INTERFACE_MODE_INTERNAL)
-		return -EINVAL;
-
 	mtk_gephy_config_init(phydev);
 
 	/* PHY link down power saving enable */
-- 
2.25.1

