Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB02176DF3
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 05:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgCCEYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 23:24:25 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40330 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbgCCEYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 23:24:24 -0500
Received: by mail-pl1-f195.google.com with SMTP id y1so713965plp.7;
        Mon, 02 Mar 2020 20:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f86LiJQbCNA1Ft9AZXlHC0BYAiDHBjeq0L9Elqc5kKw=;
        b=sv9W2C2ZtdII3V+CIq3dBeUkeRd4xv2o+enc7NIN1sLmSgtslLGlSV28SxLVZPXIqu
         GQ8x7nUrtfMmEf/EH5W+ESSMD1TfqTtLJLl44f8Qx6HKHBnHlXDpLXSdrM1mrmCM+91T
         rmVpIIhuGKQT7ddcoWpt063FRXewLLdsJ1cNfnZ0zCe3q0nymgAjfEYZPiAtn7rnIm8Z
         CqmZSCzr4egana552G/4WPExDD/jTe93e6ninK2FiJitnT34VHsxdDp6gjUiiNJKYETm
         1zJXEAFPsqFfXj45XXVigeIsSizwWIkQMhvtpstdlwFXVX59P7UcOubnt8Q+G8mCOjP2
         8Thw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=f86LiJQbCNA1Ft9AZXlHC0BYAiDHBjeq0L9Elqc5kKw=;
        b=rumEsFnzt9UUqgH4oUdvpI1X+G5pPG6cQ0SFjGaFAOaVCf5kU+Y+Tv4QVEM5UjiaMr
         3C8OD/iylXOb4NmQSPH49SEN6RoWMmhKBSgHn4JpSzTsO3jNW5OIvstxD6UWsALzL+Xg
         ldqgtArH1wfmJHYTiGUQjdCN45bh6aBsy8vn60YdVEODN9uxNhkyNsWGsRrgBNRXqv6F
         hMfSfZOzTjwXeMwQqwGjXSZmkrKWeTjuCJ8a1xMriP25Ak59Q5CQUwyIo1RxBNTWpPNG
         R1WLH1UcVuP1NYGS+Wk7ucdnZBMGTUt/nvKGR37GAws0R0qlNs5FkG1ePNCXxodvHhsD
         UQJQ==
X-Gm-Message-State: ANhLgQ1jL6A60ONQvYVFoJbQOwf2NHf4dJc9mLjlzXG1UCKos80oJYqC
        rSzBlZhlgEX2kuExZvbiJpE=
X-Google-Smtp-Source: ADFU+vtD7otol1zz+BzNveCSSkBR1wMResXpkLKpWSCWLYAO/nroKGGBxUZp+R3+fvRR83WQDRr8RQ==
X-Received: by 2002:a17:902:8498:: with SMTP id c24mr2392112plo.233.1583209463685;
        Mon, 02 Mar 2020 20:24:23 -0800 (PST)
Received: from localhost.localdomain (c-98-210-123-170.hsd1.ca.comcast.net. [98.210.123.170])
        by smtp.googlemail.com with ESMTPSA id a5sm679900pjh.7.2020.03.02.20.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 20:24:22 -0800 (PST)
From:   Dajun Jin <adajunjin@gmail.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        robh+dt@kernel.org, frowand.list@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] drivers/of/of_mdio.c:fix of_mdiobus_register()
Date:   Mon,  2 Mar 2020 20:24:21 -0800
Message-Id: <20200303042421.23050-1-adajunjin@gmail.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200302175759.GD24912@lunn.ch>
References: <20200302175759.GD24912@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When registers a phy_device successful, should terminate the loop
or the phy_device would be registered in other addr. If there are
multiple PHYs without reg properties, it will go wrong.

Signed-off-by: Dajun Jin <adajunjin@gmail.com>
---
Hi Andrew, Thanks for your review.

 drivers/of/of_mdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index 8270bbf505fb..9f982c0627a0 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -306,6 +306,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 				rc = of_mdiobus_register_phy(mdio, child, addr);
 				if (rc && rc != -ENODEV)
 					goto unregister;
+				break;
 			}
 		}
 	}
-- 
2.17.1

