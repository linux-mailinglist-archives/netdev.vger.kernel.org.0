Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D71430E30
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 05:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhJRDgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 23:36:09 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:54157 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhJRDgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 23:36:08 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634528038; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=jPRKr7121874X44dRjoBIc4g8bZNHwRqzzzIcG/aR78=; b=sKVSolGLljckIcDP8jVEYeQ3GPvi8ibi15pOT3p/Y/5SA11ASFpfq0I0tEoPEkDUPn1gTzF9
 r9RDoNteDk68CKAC+0pibgC1OjX+DRQ5lQpU9FS40HBFpZ+6CZ5gJEwV9vBQCBMOGrv4NqxR
 yt7yJ392X6ON+2O0wFF443VxgwA=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 616ceb21ea41a97c240fb222 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 18 Oct 2021 03:33:53
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 644A4C4338F; Mon, 18 Oct 2021 03:33:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F2531C4360D;
        Mon, 18 Oct 2021 03:33:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org F2531C4360D
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v3 01/13] net: phy: at803x: replace AT803X_DEVICE_ADDR with MDIO_MMD_PCS
Date:   Mon, 18 Oct 2021 11:33:21 +0800
Message-Id: <20211018033333.17677-2-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211018033333.17677-1-luoj@codeaurora.org>
References: <20211018033333.17677-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace AT803X_DEVICE_ADDR with MDIO_MMD_PCS defined in mdio.h.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/phy/at803x.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index bdac087058b2..5843b5b742f8 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -70,7 +70,6 @@
 #define AT803X_CDT_STATUS_DELTA_TIME_MASK	GENMASK(7, 0)
 #define AT803X_LED_CONTROL			0x18
 
-#define AT803X_DEVICE_ADDR			0x03
 #define AT803X_LOC_MAC_ADDR_0_15_OFFSET		0x804C
 #define AT803X_LOC_MAC_ADDR_16_31_OFFSET	0x804B
 #define AT803X_LOC_MAC_ADDR_32_47_OFFSET	0x804A
@@ -329,7 +328,8 @@ static int at803x_set_wol(struct phy_device *phydev,
 	const u8 *mac;
 	int ret;
 	u32 value;
-	unsigned int i, offsets[] = {
+	unsigned int i;
+	const unsigned int offsets[] = {
 		AT803X_LOC_MAC_ADDR_32_47_OFFSET,
 		AT803X_LOC_MAC_ADDR_16_31_OFFSET,
 		AT803X_LOC_MAC_ADDR_0_15_OFFSET,
@@ -345,7 +345,7 @@ static int at803x_set_wol(struct phy_device *phydev,
 			return -EINVAL;
 
 		for (i = 0; i < 3; i++)
-			phy_write_mmd(phydev, AT803X_DEVICE_ADDR, offsets[i],
+			phy_write_mmd(phydev, MDIO_MMD_PCS, offsets[i],
 				      mac[(i * 2) + 1] | (mac[(i * 2)] << 8));
 
 		value = phy_read(phydev, AT803X_INTR_ENABLE);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

