Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA557A51E
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 11:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731017AbfG3Jr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 05:47:29 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36590 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730150AbfG3Jr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 05:47:28 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so65099295wrs.3;
        Tue, 30 Jul 2019 02:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bCbdxxLbqxrpV82n9Yp3CBGNk09BtzYShH1n+PyQxZw=;
        b=sDifU7u9jNRAq5kNlqnu/1rkZANl6J1APsRXOe4d7bIEp377J8Y7y2w5LrFDcQJSbH
         lXX4OW5VlRxigCaqjpcukYysnA+fjS1u+Q/fG0wKdvMUulYcSnQxOZc1J/I8nfOePfZu
         bWXI8CEyUfvCdtKDOMVT+79sIFILkj3WI+0aBnz3mcLoW35/zDQ93x/YKiRL0qXHVxbZ
         m3qV3PP2fwReCTaK8OGWO3OJPbldUT21fo1e7y5QyOPC3bSPvS+2J/rOVKp6v8g7sLqf
         3Gb+Ho+m/xFjU+Xx/pCODD5T+A8uDxISAOWxuej/+XwooJ2yDNYfwOXn/GBI/h02mLy5
         mTWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bCbdxxLbqxrpV82n9Yp3CBGNk09BtzYShH1n+PyQxZw=;
        b=boRfELNp8gOxYZSMGXl89U2rgBToqg0hnpyimB9YYU8sWcbdd8m+b1SBxtu8UG6Jsb
         MNglM76fTMjzt/MQRaHAdp4xvfmQ5r50WkKcq54qvD2ko4ckeWXIUWDBGe13WxvgIiE7
         CdFw8ztvSE0eZlnpcZpA77u9gIMUt/klmpP1mMlllT1n2NzJ3jBAL7CG+v5KjE+30OVg
         pAJ6k2ALMv/sAiKLHEk+iSSC8LLMDw6RyMm7p1TVpaLBzh5uVLLcttaedfzXyuFZ0a1r
         jTXpd4ZowPlFF1gwD+4p65Yqvci4o6JKzPsHx9M3fEhJlf0NB0dpPphsX9/NO9yVuqfv
         3I0g==
X-Gm-Message-State: APjAAAV4VClpGwqxgOZHe9rGeaiQe/38psPPnNepwLhSBn2GvkKIUfmh
        IG1SJipdi0pgxuzxdACJYrVMA9NU
X-Google-Smtp-Source: APXvYqxpuM1LWAHpIrorVL3CbA/q0uiJjOiAgTMu5yGGCSK7GRpI1zv6AkjqptzH0aucfiwlL9Jgdw==
X-Received: by 2002:a5d:5452:: with SMTP id w18mr86200966wrv.327.1564480046500;
        Tue, 30 Jul 2019 02:47:26 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id r12sm77235777wrt.95.2019.07.30.02.47.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 02:47:25 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] net: phy: fixed_phy: print gpio error only if gpio node is present
Date:   Tue, 30 Jul 2019 11:46:23 +0200
Message-Id: <20190730094623.31640-1-h.feurstein@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is perfectly ok to not have an gpio attached to the fixed-link node. So
the driver should not throw an error message when the gpio is missing.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 drivers/net/phy/fixed_phy.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index 3ffe46df249e..7c5265fd2b94 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -216,8 +216,10 @@ static struct gpio_desc *fixed_phy_get_gpiod(struct device_node *np)
 	if (IS_ERR(gpiod)) {
 		if (PTR_ERR(gpiod) == -EPROBE_DEFER)
 			return gpiod;
-		pr_err("error getting GPIO for fixed link %pOF, proceed without\n",
-		       fixed_link_node);
+
+		if (PTR_ERR(gpiod) != -ENOENT)
+			pr_err("error getting GPIO for fixed link %pOF, proceed without\n",
+			       fixed_link_node);
 		gpiod = NULL;
 	}
 
-- 
2.22.0

