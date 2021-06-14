Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2733A6667
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbhFNMW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:22:26 -0400
Received: from mail-ej1-f46.google.com ([209.85.218.46]:45682 "EHLO
        mail-ej1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232940AbhFNMWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 08:22:23 -0400
Received: by mail-ej1-f46.google.com with SMTP id k7so16322162ejv.12
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 05:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=frdHID8Rty2bQ7PaJLSuzRIfAA1EKrALObYnLRkK9yQ=;
        b=lcwun7Zze+N0p9Pg4as9tyv2sauVXbOQT/X9+u0i5p9Q6d0lti0d1LKibs6+7Ts1hV
         aODoER5eVD7SPPXymCvPhcE/jUKsZKKaNDeassU14SOZJzld7YjMiOgjnvH8gR9KNvta
         nm9jDam1v7QsKKfIlz8UZ7t+UVjePnayFbut3CLQznUQXcesEQPXSrO9fRheypsr+q0D
         o2xkuZ9MfQtNnmD78sMXs2XAf6MXwm+J92rbgRXd5FMHfJSAzDkVjbQ83g5X5RwWn36x
         YhEzEtdwm3JlNJ31OZajeVoUTv5TALCgQvZ4RdSp8Gfx0/0QkqNZX3U0H56Y6DA0R/D/
         hDMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=frdHID8Rty2bQ7PaJLSuzRIfAA1EKrALObYnLRkK9yQ=;
        b=C2kuOLM12wQijJQM+bp5aw9XBuOH/TFB/l1DFTDYC6yrTBypI0V+mD8rww+aqmjsfX
         wATKjfLDvz5ocJss7T+psGi5YT8MP19PS5q7S0fLVVyQJFoN7JCOQ7GuiIcXvvyOapzW
         pbelbpUe7p8SaWMgEgWBA0s55cIYK+YIlXkoLztQVMzHuEl9/2hBC/qPd0ehAflV4XPm
         O2o89gIMYa901kbJY+ds6+miKkB/lQafNI35MbPj4J1kSOA/Yd5O/Gvwg+jAQvqQgIHG
         tKoQ1CzMLDntdiui6/fCjE8GDQL4EJu1bpMsQfjdPB/EozXox8iSPyF+E/QyXhGRX9BM
         VoSA==
X-Gm-Message-State: AOAM531k7FxVxJmOAaaeR7VNSaD19VrI7DNH3ydW2Zd1IPcfJU2Viub1
        LqtSnh0GNizfr67ZDV8BJLdi/6YhAGk=
X-Google-Smtp-Source: ABdhPJwshMhHNpIvOP3a9fL/X/+ajhs7haeP0a847bEYyZhFWP0TVOQopWSt8/LD21pZ+oX6f3SJhg==
X-Received: by 2002:a17:906:8345:: with SMTP id b5mr14759844ejy.14.1623673148169;
        Mon, 14 Jun 2021 05:19:08 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id c18sm8722495edt.97.2021.06.14.05.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 05:19:07 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 1/3] net: phy: nxp-c45-tja11xx: demote the "no PTP support" message to debug
Date:   Mon, 14 Jun 2021 15:18:47 +0300
Message-Id: <20210614121849.437119-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210614121849.437119-1-olteanv@gmail.com>
References: <20210614121849.437119-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The SJA1110 switch integrates these PHYs, and they do not have support
for timestamping. This message becomes quite overwhelming:

[   10.056596] NXP C45 TJA1103 spi1.0-base-t1:01: the phy does not support PTP
[   10.112625] NXP C45 TJA1103 spi1.0-base-t1:02: the phy does not support PTP
[   10.167461] NXP C45 TJA1103 spi1.0-base-t1:03: the phy does not support PTP
[   10.223510] NXP C45 TJA1103 spi1.0-base-t1:04: the phy does not support PTP
[   10.278239] NXP C45 TJA1103 spi1.0-base-t1:05: the phy does not support PTP
[   10.332663] NXP C45 TJA1103 spi1.0-base-t1:06: the phy does not support PTP
[   15.390828] NXP C45 TJA1103 spi1.2-base-t1:01: the phy does not support PTP
[   15.445224] NXP C45 TJA1103 spi1.2-base-t1:02: the phy does not support PTP
[   15.499673] NXP C45 TJA1103 spi1.2-base-t1:03: the phy does not support PTP
[   15.554074] NXP C45 TJA1103 spi1.2-base-t1:04: the phy does not support PTP
[   15.608516] NXP C45 TJA1103 spi1.2-base-t1:05: the phy does not support PTP
[   15.662996] NXP C45 TJA1103 spi1.2-base-t1:06: the phy does not support PTP

So reduce its log level to debug.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 512e4cb5d2c2..902fe1aa7782 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -1090,7 +1090,7 @@ static int nxp_c45_probe(struct phy_device *phydev)
 				   VEND1_PORT_ABILITIES);
 	ptp_ability = !!(ptp_ability & PTP_ABILITY);
 	if (!ptp_ability) {
-		phydev_info(phydev, "the phy does not support PTP");
+		phydev_dbg(phydev, "the phy does not support PTP");
 		goto no_ptp_support;
 	}
 
-- 
2.25.1

