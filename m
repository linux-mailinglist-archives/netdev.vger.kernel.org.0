Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D075642611C
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242569AbhJHAZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241878AbhJHAY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 20:24:59 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03FCC061762;
        Thu,  7 Oct 2021 17:23:04 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id t16so7773900eds.9;
        Thu, 07 Oct 2021 17:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=nMGz1jaxSRjc4ldn7/fMoncfQgr+j4K4wAw0fNIBVyA=;
        b=doDreLe3sti7rYXEgBkFB9Hl4AH/nV/T+e5nUironqbabsKzvl8zi1XQCuPRoVE/Oq
         Mn5CIKgzZESS+k8U9orCa6rMZAZy4dgCoD7xta4CRajb/mHqKKJ1xqrzddg26kKxN1Tz
         /tfEfr3Epw2DmuRKCaZHRfX/ZCHlMkKMf7pOhTYKoIvdjhVyEZu4fsFLMvPPtGCX6+0l
         6zAr8uvnqVRmSb8g0SIlUn8y96oPFBP9NSmLJDkJgbdlOairHj820aqDSBsNl/oY8/8P
         Z/2kht5zzvVTz77wQsIq+IfZU7zYT7i+f2gHQaHoT8QYGT1bJWyeXIbUDESVoMLwSNcn
         jLzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nMGz1jaxSRjc4ldn7/fMoncfQgr+j4K4wAw0fNIBVyA=;
        b=FDT5Cw+zpBSwaMMMpPP04xVrQAF6L8hOpdYCyToUWQNnSA/Vb8Obs9aRorad7utXGt
         +3DXEY6XR8FKfcTHSjnRLdVA8PrdTQxOeo1fMsnxa3NcFr3F1lXTVfMZSdxT/Y2UV5xk
         /F4cNrNZOREPdBjT4fk2Sj3mNg/HFKB0d105ynlS9kpdFFbdFGI8ZWr4pAnpHeR7rQz0
         zT2txEN10uMKVbLLCqDvZoJkBf3zltP0gsPv7w9apyxbEP3PJ/VJ/zctkgLkKDmQSkJm
         U70+W6umJhEVuJTgNnKFh6s0wg+ET3zp1bnaS/kpWCv/anrP5OJM8aduLITKJ2wVeJ1o
         cXuw==
X-Gm-Message-State: AOAM532hX1v+bn0ReXUcpghP8EWcR/PBH+z54H8IUjGmh+8WPkMDuE1m
        bCudlsgzq5BMhLUYfa1mZ8E=
X-Google-Smtp-Source: ABdhPJwCxGafRMPdf/GNa7eQc/uzqvQ85EjYyES6jg+NiaXglVm9blhh866xHP5vwUDJ+cGuB3HZGQ==
X-Received: by 2002:a17:906:2c09:: with SMTP id e9mr147079ejh.410.1633652583159;
        Thu, 07 Oct 2021 17:23:03 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id ke12sm308592ejc.32.2021.10.07.17.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 17:23:02 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [net-next PATCH v2 03/15] drivers: net: phy: at803x: enable prefer master for 83xx internal phy
Date:   Fri,  8 Oct 2021 02:22:13 +0200
Message-Id: <20211008002225.2426-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211008002225.2426-1-ansuelsmth@gmail.com>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From original QCA source code the port was set to prefer master as port
type in 1000BASE-T mode. Apply the same settings also here.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/at803x.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 5208ea8fdd69..402b2096f209 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -1325,6 +1325,9 @@ static int qca83xx_config_init(struct phy_device *phydev)
 		at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0,
 				      QCA8327_DEBUG_MANU_CTRL_EN, 0);
 
+	/* Following original QCA sourcecode set port to prefer master */
+	phy_set_bits(phydev, MII_CTRL1000, CTL1000_PREFER_MASTER);
+
 	return 0;
 }
 
-- 
2.32.0

