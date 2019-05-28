Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 021192C3D1
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 12:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfE1KBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 06:01:22 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43664 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfE1KBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 06:01:21 -0400
Received: by mail-lj1-f196.google.com with SMTP id z5so17078232lji.10
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 03:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=om/x3iP5fctWoqvXA+2EZTqv203LFeCCn2e57pz6/x0=;
        b=loj+qWp22ZPFaWOGMzazF9biVHnD/lhmpI01hRkBqH5I3+EUe7PLUnBPj1b7Ls7RcU
         SKuwn2KhUIHh9c07aaZE2J41dwxyRyyWZqGx3+58p92olAfhTiC1/6h4DY5mySNkrYhs
         7OdBGpDkmKUL0JtRr36eOYjStzDu07M9NFxbPFHH91DTk/hr3KK4GmQMXJghGPOYOzl9
         oRu8s4ykG1yJd9TYKrpVqnZdMU0l0BPlBetmOAdzT9busnnLt/bATRcp81Xk8sNiUQfF
         znsIMc5Ctu0+nTgcU4zcsMGp38DVEgRBwEzwsuVIuAgYgPO7tS58EDddRRivBDvMSG2j
         nQ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=om/x3iP5fctWoqvXA+2EZTqv203LFeCCn2e57pz6/x0=;
        b=VuoDi3onn48ZGZobHcSLKUnsaf/599AurePqFhBiaiS6woR5Cc1dEWB5TDbXIZ/EQ9
         xMlJRS/zHNXE0xuCaCpCLYqkX3w4vBwBXQ7wnssnia1/OTGDbJvEADMG2lCf1Z9AVQx9
         o24derJHzrB2uq3QhDx7gWjb7dD5Gl7YRFZ/ETtRc+5hJVyYWjINBDj+163LtVvLfV8T
         NuN0De3phsWikfpwB8PEXmtyzY2JnODhlfYNtaguCqLq7UgLPWY6ezpNNz/jKt2E5BFI
         59gNkZDq0Pq+5CY4EQtQmUzJOosxzSSAN3mD6lxXeeUWoI4Jpvsu+WImr1GFSk5vHbma
         9iBQ==
X-Gm-Message-State: APjAAAVBpID5FOkkzqCrd8U0TRPrD8lxWQBtLx7caev+A1ieIlCVn08+
        nFjsZ9gK+fIb/+QfV+L5SHIiyZ52cV8Gzg==
X-Google-Smtp-Source: APXvYqwjZTQfttmaC61YXcg6sSG3JISIzPzabbD4cN1/XVF+4jY0bDJb3dHdt1yEQ1XRAMpvGsoHdw==
X-Received: by 2002:a2e:818b:: with SMTP id e11mr64260208ljg.82.1559037678861;
        Tue, 28 May 2019 03:01:18 -0700 (PDT)
Received: from maxim-H61M-D2-B3.d-systems.local ([185.75.190.112])
        by smtp.gmail.com with ESMTPSA id x28sm581816lfc.2.2019.05.28.03.01.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 03:01:18 -0700 (PDT)
From:   Max Uvarov <muvarov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, Max Uvarov <muvarov@gmail.com>
Subject: [PATCH v3 3/4] net: phy: dp83867: do not call config_init twice
Date:   Tue, 28 May 2019 13:00:51 +0300
Message-Id: <20190528100052.8023-4-muvarov@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190528100052.8023-1-muvarov@gmail.com>
References: <20190528100052.8023-1-muvarov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Phy state machine calls _config_init just after
reset.

Signed-off-by: Max Uvarov <muvarov@gmail.com>
---
 drivers/net/phy/dp83867.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 14e9e8a94639..1ec48ecf4133 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -342,7 +342,7 @@ static int dp83867_phy_reset(struct phy_device *phydev)
 
 	usleep_range(10, 20);
 
-	return dp83867_config_init(phydev);
+	return 0;
 }
 
 static struct phy_driver dp83867_driver[] = {
-- 
2.17.1

