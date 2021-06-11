Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B503A4089
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhFKK5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 06:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbhFKK5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 06:57:14 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3FCC0617AF;
        Fri, 11 Jun 2021 03:55:03 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id h24so3942621ejy.2;
        Fri, 11 Jun 2021 03:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bSqtR/P0vVOyJ7D0Li8Lv7yXqTREWzkdBqljW0NiiXY=;
        b=Q2e3aDafRoQ9XZ3elT85Z4BxChaJBYDl0IFPGVRbFpM9ArcAlU8amH+rIqP+XeOIgy
         qfK58jWrFQu054Ywmser1hInK7u9bcHc96PbWLuhcSrTX3DL/sejIzmyWoof/7AuVzFh
         fDMQaFa3ktbekKD6zeQjzKJ6HpY930kMMHl7JbTj8XMywAq9+vrVZ1ToOG3ZXn29U0zu
         fakD9ckPqdWy3oT6NeIE8jX1sx035LCK1Rf/CgDcP9t1VcIrTwuJGDQEavgtsHwcXj8t
         4W6zms/quJJ4zUPwt5IewQ251JInQnqeEkicj1vfDFJ8uT/46AkdiowXzG7uHDT7DVjq
         gQQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bSqtR/P0vVOyJ7D0Li8Lv7yXqTREWzkdBqljW0NiiXY=;
        b=Znp0AUaXEYvwkQ5On10KoZeX7K4vaMsnLzRdkTNpthJKHUQnKzA4Wnh46dcz+3sGpx
         zg5/MaA+yWeyCkDAeFwAIooSLlim/ifAWqkjuznG++Z/Sw6PPD8pri7puQYNjfz8Y3u0
         w0dxKcVXUWCxBTRGcGjMhilFefhv9vJHPh6QzGHK4WOWUQ9A8r4CWwqp6nHy/tgPwRPg
         Eq7Dt1z+iswUyVKo5J4XUjHXhZoWaDnoV4LPhLTBURTuhhPJon5tZ4DuKf4EHyjOFVDY
         tBT2BAKEkcX589SpmWgcn01zOsnBV0o8PhvMH5sKjwe3njr8B8H+1mKYs7v/1YRQ91jJ
         5JBg==
X-Gm-Message-State: AOAM530fazu8ENgjfMvsti7vfHWSOq97/HFyhvWoAAmBQqFeg6oYmny8
        n0eCGjZMXu+pkS0bbaNwJLw=
X-Google-Smtp-Source: ABdhPJz9d9cKCWOe929TC+xXbcZo7taJ2L4OxHZf1z9GEwr2OeVJL7NG82Oy/gbznCswooCVClbrVA==
X-Received: by 2002:a17:906:b2d1:: with SMTP id cf17mr3152732ejb.225.1623408901654;
        Fri, 11 Jun 2021 03:55:01 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id r19sm2492051eds.75.2021.06.11.03.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 03:55:01 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        calvin.johnson@oss.nxp.com
Cc:     Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v9 07/15] net: mii_timestamper: check NULL in unregister_mii_timestamper()
Date:   Fri, 11 Jun 2021 13:53:53 +0300
Message-Id: <20210611105401.270673-8-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611105401.270673-1-ciorneiioana@gmail.com>
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Callers of unregister_mii_timestamper() currently check for NULL
value of mii_ts before calling it.

Place the NULL check inside unregister_mii_timestamper() and update
the callers accordingly.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Acked-by: Grant Likely <grant.likely@arm.com>
---

Changes in v9: None
Changes in v8: None
Changes in v7:
- check NULL in unregister_mii_timestamper()

Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None


 drivers/net/mdio/of_mdio.c        | 6 ++----
 drivers/net/phy/mii_timestamper.c | 3 +++
 drivers/net/phy/phy_device.c      | 3 +--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 29f121cba314..d73c0570f19c 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -115,15 +115,13 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 	else
 		phy = get_phy_device(mdio, addr, is_c45);
 	if (IS_ERR(phy)) {
-		if (mii_ts)
-			unregister_mii_timestamper(mii_ts);
+		unregister_mii_timestamper(mii_ts);
 		return PTR_ERR(phy);
 	}
 
 	rc = of_mdiobus_phy_device_register(mdio, phy, child, addr);
 	if (rc) {
-		if (mii_ts)
-			unregister_mii_timestamper(mii_ts);
+		unregister_mii_timestamper(mii_ts);
 		phy_device_free(phy);
 		return rc;
 	}
diff --git a/drivers/net/phy/mii_timestamper.c b/drivers/net/phy/mii_timestamper.c
index b71b7456462d..51ae0593a04f 100644
--- a/drivers/net/phy/mii_timestamper.c
+++ b/drivers/net/phy/mii_timestamper.c
@@ -111,6 +111,9 @@ void unregister_mii_timestamper(struct mii_timestamper *mii_ts)
 	struct mii_timestamping_desc *desc;
 	struct list_head *this;
 
+	if (!mii_ts)
+		return;
+
 	/* mii_timestamper statically registered by the PHY driver won't use the
 	 * register_mii_timestamper() and thus don't have ->device set. Don't
 	 * try to unregister these.
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index f7472a0cf771..85734309b580 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -957,8 +957,7 @@ EXPORT_SYMBOL(phy_device_register);
  */
 void phy_device_remove(struct phy_device *phydev)
 {
-	if (phydev->mii_ts)
-		unregister_mii_timestamper(phydev->mii_ts);
+	unregister_mii_timestamper(phydev->mii_ts);
 
 	device_del(&phydev->mdio.dev);
 
-- 
2.31.1

