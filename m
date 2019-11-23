Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A15A107EC3
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 15:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfKWOTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 09:19:43 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38374 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfKWOTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 09:19:43 -0500
Received: by mail-pg1-f194.google.com with SMTP id t3so4434360pgl.5;
        Sat, 23 Nov 2019 06:19:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l9I4KqFGS6ff8/IYdfHFE2ABoOk3S9eLWIs9fo62ASc=;
        b=W4LyYeKtMUMQo5EEoQI6QKHteSm2OGuC2/43baA3jUpoANrMzlBhI6HbFOGl2zR9Xs
         INH2OSkN7XARs04dGPMpRUs9im8Zh0X7AVbnd/r7kEX26BFFo9z6lVswFybzXqYRJRFg
         FudSy19r0zx0MBvALSJanDGtD5Q94vYOlPByOOkdyRL30lpYieFlMlbXANiSXnx6hRe7
         gjCUXF1kyvh7EfEYKQnoJD99NLRpUOA79yVuqlZbdO4Q13rmgIuhCOT88Goxv+BgUfGn
         YDOdgWElhG/vNXt0e0dmCm8s1yzfyJcLmYQj8mAaiJFWv8QxHT/Mq4GSgZB5Zq/Uf/om
         bujQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l9I4KqFGS6ff8/IYdfHFE2ABoOk3S9eLWIs9fo62ASc=;
        b=EN1UEFJ7NUVx0gvnAhjACymjj+6mhCo6lS+io/biqkdIfasdNe7d8VTPuw7L02wTem
         Mw2ia9p9r5hlpiA8yhCX0oN8Hyal7UQgOKx5BMu3v4Rwt7W/8XZC/3LV2ahn3iWvylEM
         vvKvRuoVKA8W/4Z0fy7/eTm3JE0hxPk4dzlIoKg5cu24b6QePfkw0S8IgK1OXeWSgiGm
         72VMjPxiPD3780yvtRJawDaVwZzRm3rRnqXMhkNDRmwaKpKxXGFKNQACeDIj5o4pk0H/
         9a42i8wdr8OgNGESnxwnJUIpI5PjD1oM9xNu4Wo+JYcfgNKfUbXKMZeMnOnT7q99vy9B
         VmYg==
X-Gm-Message-State: APjAAAU7bINwwWlwWtiA9oydpfzRfOyo13ihlqrZ2SgWlhlOirHjc7o0
        T7/xLfcb96p4UqUe0gxJysE=
X-Google-Smtp-Source: APXvYqzQqAJJxpRwZ2VWlAvLN7OUti2D6yEkc7VDBUERoJW1Tq9GFB1SpZMSgzTi1s8A+JhPrBlx+w==
X-Received: by 2002:a63:6b87:: with SMTP id g129mr13033657pgc.438.1574518782307;
        Sat, 23 Nov 2019 06:19:42 -0800 (PST)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id y17sm1836441pfl.92.2019.11.23.06.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 06:19:41 -0800 (PST)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net v3] net: macb: add missed tasklet_kill
Date:   Sat, 23 Nov 2019 22:19:18 +0800
Message-Id: <20191123141918.16239-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver forgets to kill tasklet in remove.
Add the call to fix it.

Fixes: 032dc41ba6e2 ("net: macb: Handle HRESP error")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
Changes in v3:
  - Add fixes tag and target 'net'.

 drivers/net/ethernet/cadence/macb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 1e1b774e1953..2ec416098fa3 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4383,6 +4383,7 @@ static int macb_remove(struct platform_device *pdev)
 
 	if (dev) {
 		bp = netdev_priv(dev);
+		tasklet_kill(&bp->hresp_err_tasklet);
 		if (dev->phydev)
 			phy_disconnect(dev->phydev);
 		mdiobus_unregister(bp->mii_bus);
-- 
2.24.0

