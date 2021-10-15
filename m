Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D8442EA44
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 09:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236189AbhJOHht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 03:37:49 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:62902 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236165AbhJOHhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 03:37:46 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634283340; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=PTQjFbjv6SCyDGSVGPRtRZAVzPncgEt4v64/RYZZ9LU=; b=xmO8vHUcbAGIcCXME/50DM6m3neUT4X8BZRkjJbSFui4CNpJq7PHkvopYwRvMeolKMtYZA20
 Vud16u5ht9mkGfj/Cgat0eL+pjkcpnTumP8HepkYokm/msJri3LJMq0aZEdbbAxfHGOy/EBN
 E0BKNzlURvrwtV40TXzqmzrgZdw=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 61692f43f3e5b80f1f7c5e1f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 15 Oct 2021 07:35:31
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 267C1C4360D; Fri, 15 Oct 2021 07:35:31 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8D36EC43460;
        Fri, 15 Oct 2021 07:35:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 8D36EC43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v2 04/13] net: phy: at803x: use GENMASK() for speed status
Date:   Fri, 15 Oct 2021 15:34:56 +0800
Message-Id: <20211015073505.1893-5-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211015073505.1893-1-luoj@codeaurora.org>
References: <20211015073505.1893-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use GENMASK() for the current speed value.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/phy/at803x.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 2f7d96bd1be8..0b69e77a0510 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -33,10 +33,10 @@
 #define AT803X_SFC_DISABLE_JABBER		BIT(0)
 
 #define AT803X_SPECIFIC_STATUS			0x11
-#define AT803X_SS_SPEED_MASK			(3 << 14)
-#define AT803X_SS_SPEED_1000			(2 << 14)
-#define AT803X_SS_SPEED_100			(1 << 14)
-#define AT803X_SS_SPEED_10			(0 << 14)
+#define AT803X_SS_SPEED_MASK			GENMASK(15, 14)
+#define AT803X_SS_SPEED_1000			2
+#define AT803X_SS_SPEED_100			1
+#define AT803X_SS_SPEED_10			0
 #define AT803X_SS_DUPLEX			BIT(13)
 #define AT803X_SS_SPEED_DUPLEX_RESOLVED		BIT(11)
 #define AT803X_SS_MDIX				BIT(6)
@@ -969,7 +969,7 @@ static int at803x_read_status(struct phy_device *phydev)
 		if (sfc < 0)
 			return sfc;
 
-		switch (ss & AT803X_SS_SPEED_MASK) {
+		switch (FIELD_GET(AT803X_SS_SPEED_MASK, ss)) {
 		case AT803X_SS_SPEED_10:
 			phydev->speed = SPEED_10;
 			break;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

