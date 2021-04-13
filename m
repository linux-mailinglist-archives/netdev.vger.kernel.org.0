Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3FA35D96C
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 09:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237309AbhDMH4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 03:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236920AbhDMH4n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 03:56:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 036A9613C0;
        Tue, 13 Apr 2021 07:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618300584;
        bh=AwDdzkVBb4/+xSJ8nEvoOEcIgT6LDFbcCuOBHfusSlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k9fdsu9oWsmauJHDetJdInepp2iM3zSBLeiDt9RfcHCugGv0Np8FOFuOEJXzS1Aty
         cQU2M8LZxqGKyiQW+Ke+Sb2qq+QSsgfhHjrRVVvLuGbZzwabde2EW5fTtS3GwcrjzS
         WppAaU6MM4cCcRl1MiyzscM9iXafKFvcIhwZUKmZxjg5IMTk3UnKA0/8Y+EAr+mumy
         vyWEAVRLfN6ds7H/6ttDO20JuVf/M0cC2vQBEjixsQ7sl4wWESGGfzmZ3Ig0n3+19K
         YksyZ3vgC9uvgOTkuADlHZLAftD03O5unAh2iaVroeI9XzNyYOvPVu/1kNi7g9nnBQ
         OCE3zBMEWY/HA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 3/5] net: phy: marvell: use assignment by bitwise AND operator
Date:   Tue, 13 Apr 2021 09:55:36 +0200
Message-Id: <20210413075538.30175-4-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210413075538.30175-1-kabel@kernel.org>
References: <20210413075538.30175-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the &= operator instead of
  ret = ret & ...

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index bae2a225b550..9eb65898da83 100644
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

