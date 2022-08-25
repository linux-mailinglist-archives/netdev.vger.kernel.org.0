Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A603C5A075E
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 04:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbiHYCj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 22:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiHYCjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 22:39:55 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCA113FA4;
        Wed, 24 Aug 2022 19:39:53 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id s206so16688027pgs.3;
        Wed, 24 Aug 2022 19:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=9Lx/rm4RlyCxK21C3i6hruyLuRt3Xgx3pxAClyakVdY=;
        b=LkMU6WeH3JP9JYJb0DzyGpsfNOU5Eyz4SAveLXXKnw147z2+w7+53fzcoyRPGNuX+6
         Pm3Oer8QGRmKubzjagxcuRbUoc/YCdGf5jAr6dZI5FbNxrLLnUTnqGQMbUH4PUn68p0+
         isdl+baBsOghNXYVvdoc9Nn+6SkRHF0euknr+XkcJKE2M/OO3krqZHoG0p0T910co9IY
         VvZz9E3BNm5gnviHPEG/YHIaLzuzMGLoHoE3aBpG7x1zRWuBOc1BcIY7wwrjknQswdAQ
         A+1Wd5YkYWoNKdSBIjmzpw2m7JgjvZsQol5Rnz1Gs5OGuD4bml1Qtp0IWY08NnLcyXWD
         u8+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=9Lx/rm4RlyCxK21C3i6hruyLuRt3Xgx3pxAClyakVdY=;
        b=aI2nDjyyY7kWosCMT8A/xlendYaBWodoWwMfBDKvWmCSMqgaUZklblCC5mNcOYrW5J
         vpBxZ6Qhz4IKJTWeADmwchIb0JGQSQGa5MkMijUO0KzPLHAlNnww33Ll6ZM7oT4hwya5
         t0eATAxKcqbNpCU1sdY84alVNXvfaCtbjajBcxb4YQJjynu+hwTacnlEWp9tdBVlJ8t4
         JYDArN9X6Bvk3hJyRbtNwBFa0ulwza2P8bosubE5yiWmwEuOKsuZ0Rc6DteMpJvRhmSU
         O5ksxPkQNrAbBSl3mQ/r4GXlPD5YWTx1uIfTyqlI2nhg0Mgfiy7YrvPJMv8YHfuH5atY
         rm9g==
X-Gm-Message-State: ACgBeo3nD1qgwANZfQO3M0YVjg53TQX4SxcJ0f0S4lAVcLVvKKqwmbiv
        mUo2mjccQUmTprZKQhZbOwZLEiFCbzY=
X-Google-Smtp-Source: AA6agR4Jp71a2sOn2rMOm71ZLBLU7P6WPj5YR4JwS+XNqWSwWG5X9PBJIaj0sFkGhTgKL+Rz7+15jw==
X-Received: by 2002:a05:6a00:170c:b0:537:27b4:ebfe with SMTP id h12-20020a056a00170c00b0053727b4ebfemr1696339pfc.19.1661395192289;
        Wed, 24 Aug 2022 19:39:52 -0700 (PDT)
Received: from 7YHHR73.igp.broadcom.net (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id c9-20020a170902d48900b0016db43e5212sm13534441plg.175.2022.08.24.19.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 19:39:51 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: smsc911x: Stop and start PHY during suspend and resume
Date:   Wed, 24 Aug 2022 19:39:51 -0700
Message-Id: <20220825023951.3220-1-f.fainelli@gmail.com>
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

Commit 744d23c71af3 ("net: phy: Warn about incorrect
mdio_bus_phy_resume() state") unveiled that the smsc911x driver was not
properly stopping and restarting the PHY during suspend/resume. Correct
that by indicating that the MAC is in charge of PHY PM operations and
ensure that all MDIO bus activity is quiescent during suspend.

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
Fixes: 2aa70f864955 ("net: smsc911x: Quieten netif during suspend")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/smsc/smsc911x.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 3bf20211cceb..3829c2805b16 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1037,6 +1037,8 @@ static int smsc911x_mii_probe(struct net_device *dev)
 		return ret;
 	}
 
+	/* Indicate that the MAC is responsible for managing PHY PM */
+	phydev->mac_managed_pm = true;
 	phy_attached_info(phydev);
 
 	phy_set_max_speed(phydev, SPEED_100);
@@ -2587,6 +2589,8 @@ static int smsc911x_suspend(struct device *dev)
 	if (netif_running(ndev)) {
 		netif_stop_queue(ndev);
 		netif_device_detach(ndev);
+		if (!device_may_wakeup(dev))
+			phy_stop(ndev->phydev);
 	}
 
 	/* enable wake on LAN, energy detection and the external PME
@@ -2628,6 +2632,8 @@ static int smsc911x_resume(struct device *dev)
 	if (netif_running(ndev)) {
 		netif_device_attach(ndev);
 		netif_start_queue(ndev);
+		if (!device_may_wakeup(dev))
+			phy_start(ndev->phydev);
 	}
 
 	return 0;
-- 
2.25.1

