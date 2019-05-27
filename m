Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 048A22AE6F
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 08:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbfE0GQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 02:16:21 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40668 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfE0GQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 02:16:18 -0400
Received: by mail-lf1-f68.google.com with SMTP id h13so11148684lfc.7
        for <netdev@vger.kernel.org>; Sun, 26 May 2019 23:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VDcEZRJFcKGuQU7pkx/gy+nyHr/ZPMViuPvFSSJGZJ0=;
        b=eXmw2xbY2D1jNxyAuv5e6iIFNXdRcLE5kotDKXS8XlL2dja8khDQFmfPl/54CcA+Wu
         BKEtRl9cZ8M2ObqmstK7zFAj2bspVDze6JDj/5+LhkkLHefaXG58NP6tA5mQE0hPLTnB
         V7FDAZJ6AhGyqUUKnzZGxfYFEG3914GqkkSa5wt7oP0qMORhEedIIg+ZDWqkFEY8FXXj
         4If2hBElr9+Np4vSPuhgVQ1KZKeQOwLQuoA2REDPHcsAD3ykpTxiywsaqn5Y2DFOQJpp
         wmHqLMLB3ysEbHWyeNACuhpm87p/0q265LLtgRJBCBMkkA3bs6VKzapoFaposlY5D/BM
         F30A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VDcEZRJFcKGuQU7pkx/gy+nyHr/ZPMViuPvFSSJGZJ0=;
        b=qIF7E+rDjhmmLs8ReHcE1t4lb+4lYSta7ueMzJucmuKIc+f40rbWqDk9YM5/RU11Yd
         oXOLYPeDZwSu8VTdtRCf9HPo7y6B0gFCKlp9UpZEn+pXSxTW+6gdvIf8XUNS2zZ/lalJ
         KqAMSgDd+LNk2cWgpapVOZeOF3F1hgDlugYKwlyZkltHtmpOPVsahaKwPhN+KUrrHWiM
         NMFzOfgFNWtlM49dnjTUSY16NoMwsZMWMKYG71W6CM9tg6HBftrUBzrBCuWOXInPcE0N
         fSAuvJEYQTjkXeeZd+KSBtgYsgyPcW3xWA7VEGG0c+4uyyp0eUilMrtBIuzuNbpb4RBs
         nnRQ==
X-Gm-Message-State: APjAAAWfp3mtfLTNFcj+GLNdrx5nk8BaHCHSIQIov4uxyb8lbFxphZgJ
        kAMIOQT7YEjxYjItGJYtuR5+2BwB0VJAqg==
X-Google-Smtp-Source: APXvYqzpdmDqD9srTbxdcwzWS3UaPDJ0Urv1HnA8IHyisNb5OUvEOdVqaEeFHNamzbfMgMWH4wZyew==
X-Received: by 2002:a19:ca02:: with SMTP id a2mr13897521lfg.88.1558937776658;
        Sun, 26 May 2019 23:16:16 -0700 (PDT)
Received: from maxim-H61M-D2-B3.d-systems.local ([185.75.190.112])
        by smtp.gmail.com with ESMTPSA id a25sm2045454lfc.28.2019.05.26.23.16.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 23:16:16 -0700 (PDT)
From:   Max Uvarov <muvarov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, Max Uvarov <muvarov@gmail.com>
Subject: [PATCH v2 2/4] net: phy: dp83867: increase SGMII autoneg timer duration
Date:   Mon, 27 May 2019 09:16:05 +0300
Message-Id: <20190527061607.30030-3-muvarov@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190527061607.30030-1-muvarov@gmail.com>
References: <20190527061607.30030-1-muvarov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After reset SGMII Autoneg timer is set to 2us (bits 6 and 5 are 01).
That us not enough to finalize autonegatiation on some devices.
Increase this timer duration to maximum supported 16ms.

Signed-off-by: Max Uvarov <muvarov@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/dp83867.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 75861b8f3b4d..5fafcc091525 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -295,6 +295,16 @@ static int dp83867_config_init(struct phy_device *phydev)
 				    DP83867_10M_SGMII_CFG, val);
 		if (ret)
 			return ret;
+
+		/* After reset SGMII Autoneg timer is set to 2us (bits 6 and 5
+		 * are 01). That us not enough to finalize autoneg on some
+		 * devices. Increase this timer duration to maximum 16ms.
+		 */
+		val = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4);
+		val &= ~(BIT(5) | BIT(6));
+		ret = phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4, val);
+		if (ret)
+			return ret;
 	}
 
 	/* Enable Interrupt output INT_OE in CFG3 register */
-- 
2.17.1

