Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8B7174E8B
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 17:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgCAQlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 11:41:51 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:51191 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgCAQlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 11:41:51 -0500
Received: by mail-pj1-f67.google.com with SMTP id nm14so622689pjb.0;
        Sun, 01 Mar 2020 08:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=nBNOxHWFas+8MMS2HXjk5to/S9YWzFiNrJt6S9zLpis=;
        b=NltdUatu/ub4DSzhHG4Gn/xibW7gv7MaKnQaH9nruTAl2c8102UoZQTsdo4vTLPVvF
         QNKZSFheeLsYG8JZCj5hqNubFaYrzskg+5dSSdDMPTM9adGXY2Nv9R3M1lKqCnYauHZl
         Yw3fW3b7TdvgbZ1Fttr6ZJG4v6/h01sp+IXQWrmvjCkLPh0RT2K4XtxmdtGbnAZ/F5Yc
         DC6VZVvF5wsq1pUeYu57XorVp6v4m4NeN6fHF3IHdUR3JGUSkkVhjEr4ltoab5/6M9sO
         VSARx4LJlPBv7+rRo37swAC9VDc5Yd2vHvUUqESAWv5JhK6489Sw0h+vGWRyTC4VQhKJ
         9ePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nBNOxHWFas+8MMS2HXjk5to/S9YWzFiNrJt6S9zLpis=;
        b=s15xYwAkTsCuGya3DtROaO+uX0SqD6yAGjtCzbOaoJ7CHPoAOuoHdgpYdlmzC54QsX
         qcGfsIzP0iRFKkKVKxSpVN90cOk1B7wMDQKxF3AJugiDgX/NiWKcAmP5OoylwGOPJ57w
         KYes/MP4Gdim+f6Li1hNPwhEYbTv+qxBzHCrAz2QsyXffr8Y577wGQuPVL8l1YRHGJOI
         jJNsBWpt7SZW6HnjI+ik1MvsQD4gMvWekHH1bhBryuVyVpXuOddBfBz08aun7y6tUSwi
         FHpIaa3at69230dAzO+GJNUfxLGM8YXBGQtZlTiptIhMdoZhqgoHX9dpXYzvLZiJG5Pi
         rOfQ==
X-Gm-Message-State: APjAAAV5J/VC2MrYX8G53OqhbXFR68dAjYmDdxXUOFJM9rJk1xOV44Ka
        l/GJV1sCd+xDee08mVjSaQc=
X-Google-Smtp-Source: APXvYqw7kqWuoD3/nRn6iKkX1dGGBSVD99jXF9EE1d1jsgpdSTJ+8OQNizvg3PsCoo6fgwAXhGkkkA==
X-Received: by 2002:a17:902:ac83:: with SMTP id h3mr13812813plr.86.1583080908907;
        Sun, 01 Mar 2020 08:41:48 -0800 (PST)
Received: from localhost.localdomain ([61.141.64.253])
        by smtp.googlemail.com with ESMTPSA id l13sm9129643pjq.23.2020.03.01.08.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 08:41:48 -0800 (PST)
From:   Dajun Jin <adajunjin@gmail.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        robh+dt@kernel.org, frowand.list@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Dajun Jin <adajunjin@gmail.com>
Subject: [PATCH] drivers/of/of_mdio.c:fix of_mdiobus_register()
Date:   Mon,  2 Mar 2020 00:41:38 +0800
Message-Id: <20200301164138.8542-1-adajunjin@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when registers a phy_device successful, should terminate the loop
or the phy_device would be registered in other addr.

Signed-off-by: Dajun Jin <adajunjin@gmail.com>
---
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

