Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B018A4382E9
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 11:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbhJWJ62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 05:58:28 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:63140 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231939AbhJWJ5z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Oct 2021 05:57:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634982936; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=s7tZ+gorRsxqwepfdAU/5stDHe2zWKCAd0ciKQ70/1Q=; b=fxax+uji8XNBymKJn5OqiEuxyKEA1c7+a0A9zQmdnLGpQSu/3gqEeSoTa6o9cU0PcmCWhp0z
 qpNiPXZzZ9EI2C1pBwnp6x2yLkj495Ds2xdIHazmi9tqtfSFW3byLobFdrPfF9it9tLsKARz
 cvhQjFKeWJ3dtaMbg1i3x1V6sOQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 6173dc0ac75c436a30248d30 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 23 Oct 2021 09:55:22
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 75358C4361B; Sat, 23 Oct 2021 09:55:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4D5B6C4361C;
        Sat, 23 Oct 2021 09:55:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 4D5B6C4361C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v6 04/14] net: phy: at803x: use GENMASK() for speed status
Date:   Sat, 23 Oct 2021 17:54:43 +0800
Message-Id: <20211023095453.22615-5-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211023095453.22615-1-luoj@codeaurora.org>
References: <20211023095453.22615-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use GENMASK() for the current speed value.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/at803x.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 1363f12ba659..3465f2bb6356 100644
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
@@ -994,7 +994,7 @@ static int at803x_read_status(struct phy_device *phydev)
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

