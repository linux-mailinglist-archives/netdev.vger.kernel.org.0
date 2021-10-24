Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E37243876C
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 10:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhJXIay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 04:30:54 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:11839 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbhJXIaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 04:30:30 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635064089; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=s7tZ+gorRsxqwepfdAU/5stDHe2zWKCAd0ciKQ70/1Q=; b=F550Tm3jY3QgdFDgDLFro+cJq2M0VqBuITNsZMUGs5JmokXSlSSrYxLgKPdyI0kZ5wmUAsi4
 3gwnMmrLMDbT7Aguvz+3HKAkGDjLngUmOo3ktyiVSPMKMgeCtw+LpRUeeeJTou+lRlxlgiJS
 rXym30v/RHvZEvW+cHIpec9JxIg=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 6175190fb03398c06c722623 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 24 Oct 2021 08:27:59
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0D9C5C43635; Sun, 24 Oct 2021 08:27:58 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 46B29C4360D;
        Sun, 24 Oct 2021 08:27:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 46B29C4360D
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v7 04/14] net: phy: at803x: use GENMASK() for speed status
Date:   Sun, 24 Oct 2021 16:27:28 +0800
Message-Id: <20211024082738.849-5-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211024082738.849-1-luoj@codeaurora.org>
References: <20211024082738.849-1-luoj@codeaurora.org>
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

