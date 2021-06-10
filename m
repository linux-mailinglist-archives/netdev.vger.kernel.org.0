Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071483A30FD
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbhFJQnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:43:39 -0400
Received: from mail-ej1-f48.google.com ([209.85.218.48]:46895 "EHLO
        mail-ej1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbhFJQn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:43:27 -0400
Received: by mail-ej1-f48.google.com with SMTP id he7so152629ejc.13;
        Thu, 10 Jun 2021 09:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZXMwlWoKAxdjuwt/HiX3am6VGgoRjdgFRZsahRLqNM4=;
        b=rr23b17GamtNW4dIKFfdbl4vB0T6+nWAuLM1qZ7yQw2xnlRe+bajixCjTlcKC+hrXO
         Cwsal0pKmmyPA6kJKecYnw5pIhWxIJaA4AVmPsjJedoNY3jSGz1YnsGHc9AuPuazXFyM
         IwOH1+nVuAmXlDXfh5R0BYbzBOga0u7dN1RGBISYwAAK65FjtzYHZRxoV26dHJ+Hsg+u
         DdPki22Jgq2bjkMLQnsjabA8/miMHqOK8DU865YyB4xSY/ollgX8SVpcvqahy211EiYm
         RsWB0Ft40d/gujKFhntTSmtpqDLfqIIFSGNreZRGBPiGBlclqoExVSN7gLeMs9Qz96DG
         qwAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZXMwlWoKAxdjuwt/HiX3am6VGgoRjdgFRZsahRLqNM4=;
        b=Lwap2AOEHrmEkTLmA4p6ig7bDwFwsP+xweHEJuZpIJB491atyKOkvIeouNj9RcVIV2
         E6n/eKcrXvU3iPbnycdXtq58upi+9s+Yap0RT7nT1BT4xY9OoloyjGTK/DLsC9e9fGFJ
         RZ6qUcFQdzox0uEOr3TGi58p5KpXFZC6pKYziGC6GdTiaSRKE6/9YxxNUWN/nlstrWqG
         kiwNEVMwb4R0b833geTMtdJDbkTI/8M0uIgQoJBJtWJrahANVhXBcuFRGCWqVDpc10Vk
         MO9AZj1YuQ2SJ27r1tLkXCsTxTV3I9I9mGG9SBaOZtB84//ef81i2i6JpUZ5Gqmt5ro5
         X23w==
X-Gm-Message-State: AOAM531+2TNiP73Tcn/hhWbD4pF4H0ZWVcUEsOPLZuZ3yc1rxWoUgQJy
        auEH2rNV9V8YPaqgpVYE7GQ=
X-Google-Smtp-Source: ABdhPJyCX/NBP+v0Apbk+4/3ZqHRp6qWrIaNmofj15uz4394jzlihzFqwQyK2h4+J5iQK3HLJ45kZQ==
X-Received: by 2002:a17:906:490:: with SMTP id f16mr442229eja.541.1623343229891;
        Thu, 10 Jun 2021 09:40:29 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id e22sm1657166edv.57.2021.06.10.09.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 09:40:29 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Grant Likely <grant.likely@arm.com>,
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
        Randy Dunlap <rdunlap@infradead.org>, calvin.johnson@nxp.com
Cc:     Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v8 07/15] net: mii_timestamper: check NULL in unregister_mii_timestamper()
Date:   Thu, 10 Jun 2021 19:39:09 +0300
Message-Id: <20210610163917.4138412-8-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610163917.4138412-1-ciorneiioana@gmail.com>
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
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
---

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
index 0ce5c7274930..e4b935b0b71b 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -945,8 +945,7 @@ EXPORT_SYMBOL(phy_device_register);
  */
 void phy_device_remove(struct phy_device *phydev)
 {
-	if (phydev->mii_ts)
-		unregister_mii_timestamper(phydev->mii_ts);
+	unregister_mii_timestamper(phydev->mii_ts);
 
 	device_del(&phydev->mdio.dev);
 
-- 
2.31.1

