Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376FE36539C
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 09:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhDTHzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 03:55:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229981AbhDTHzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 03:55:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBF68613B4;
        Tue, 20 Apr 2021 07:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618905294;
        bh=9+SHHBZIc/0Ed6lwP2UUfNL+XmMEtfetbMXJsD3EnOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qonqMvilBvPiHu4rpY/InGbtW0+WG7cvr1aOW1UffvSjYa66iZfVFXzfU9sGr3v9t
         7ES64MeC79eterRXRNy8Nx2JUW8B70bY9uM37ZbPm1UcCuBDBvzCvvxWAsxgXMYAUl
         Dmb1Pdn7F0JxVKnVQKv7c1h95xu/8LW9Q2PUuSt16ZEpZPzXV/KeRcF4cXwY9jCKWM
         X4fu1Qt3B54YtVzuYag9LiEB8FSLIAc50mvZz/xgX77Kt5eMbKhTqGGinwnVB9QDS+
         2X5YyK2RAFK8v+/EZbYGxqB5H6F9nzuZ3xdzlYTbl98RigIX+dJsS26lalxep1id6r
         nVLfn3sT597iw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 3/5] net: phy: marvell: use assignment by bitwise AND operator
Date:   Tue, 20 Apr 2021 09:54:01 +0200
Message-Id: <20210420075403.5845-4-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210420075403.5845-1-kabel@kernel.org>
References: <20210420075403.5845-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the &= operator instead of
  ret = ret & ...

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/marvell.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 9529aaa3bed3..e505060d0743 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2352,7 +2352,7 @@ static int m88e6390_get_temp(struct phy_device *phydev, long *temp)
 	if (ret < 0)
 		goto error;
 
-	ret = ret & ~MII_88E6390_MISC_TEST_TEMP_SENSOR_MASK;
+	ret &= ~MII_88E6390_MISC_TEST_TEMP_SENSOR_MASK;
 	ret |= MII_88E6390_MISC_TEST_TEMP_SENSOR_ENABLE_SAMPLE_1S;
 
 	ret = __phy_write(phydev, MII_88E6390_MISC_TEST, ret);
-- 
2.26.3

