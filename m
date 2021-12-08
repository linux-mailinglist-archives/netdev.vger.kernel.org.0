Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53FA46D4FE
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbhLHOHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234586AbhLHOHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 09:07:53 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50156C061746;
        Wed,  8 Dec 2021 06:04:21 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id i5so4292113wrb.2;
        Wed, 08 Dec 2021 06:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X401kasTb6VMtJyNy7oiEKvBwtdJJLLJKiE0jpdRtfQ=;
        b=CAIB/pGzC2fZpQGKOIU1mHnokYsRef9f31jdFZNfqbg+O3p0oLfxmqz1AXLI0BroWC
         xS6/Q9+HE004+EMRo6uPpzPFfzBFsEX43OaS90N4tTurqnOl2y/tt1fIyN2Mcxv4nS7b
         Lad13gDmwJ2eYJRo7H6FGDJRkF8TpXvseEpJLRNLOIt4Sqeuyd7+ZyTmFPxi1LSO+rG8
         MSBPyI2UAGUDOQqDKJ+xh2frfmqX09JpYX6dYw/mgavZA52Aq/KFGJ+7WgeYAOuq1kWr
         KJVvr5ljaUn/qF9xInQAmsmA1L+1x2TkVx1shLiKQIY7BzMH1q2qkV1Sz/2H8GXhPd39
         smCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X401kasTb6VMtJyNy7oiEKvBwtdJJLLJKiE0jpdRtfQ=;
        b=RG4hH1MuZau38aC3pdji8OX1gubb7L6goleUtoh2m0jbTKcbSwQsuefU2LxD5KXbjL
         mxm9EjXvyjVUfgQxBY5x4QQ3GlFLaFXKaK0XnAsMWnkXa+McNE2kn5/Dt5F6DkrsBmw3
         OnorxexW7ZFD1xZXA/pn7lgS4JJlcOhABSQNDlDw5rhdhA801GVy1KyPwwUZWB4sEQEY
         GYT5mhJ9ZAQ7Xr3/fB0Da+ruJu75/9iw2r4h8TzgP7yBzWIlv+g//Ykcyi5WriyD0Dam
         NCo1ZrhUiiTT2sXy2DB7dec39OLVPcb+mAFJDEB7d09kKAEmZR0qz5Z0jk8aa/F/fgrt
         g8nA==
X-Gm-Message-State: AOAM532TfM2StGHBudNVKcbRwBSKC5Zgll1d2NUy5rwqwuMlXhtVq2SE
        IE5TBx6afMqvPLOhbfkUU0zLrW1ohQ5Z/va+
X-Google-Smtp-Source: ABdhPJyeeLAQhv3ZV7tGd7lU8VyDL2XSLtQ8vVCXx7iVsrMHo0Js7PDq2aQorMGYCFld0TkZzbYjXA==
X-Received: by 2002:a05:6000:248:: with SMTP id m8mr61973793wrz.404.1638972259852;
        Wed, 08 Dec 2021 06:04:19 -0800 (PST)
Received: from localhost.localdomain ([39.48.199.136])
        by smtp.gmail.com with ESMTPSA id r83sm5994726wma.22.2021.12.08.06.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 06:04:19 -0800 (PST)
From:   Ameer Hamza <amhamza.mgc@gmail.com>
To:     kabel@kernel.org, kuba@kernel.org, andrew@lunn.ch
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, amhamza.mgc@gmail.com
Subject: [PATCH v2] net: dsa: mv88e6xxx: error handling for serdes_power functions
Date:   Wed,  8 Dec 2021 19:04:13 +0500
Message-Id: <20211208140413.96856-1-amhamza.mgc@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207140647.6926a3e7@thinkpad>
References: <20211207140647.6926a3e7@thinkpad>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mv88e6390_serdes_power() and mv88e6393x_serdes_power() should return
with EINVAL error if cmode is undefined.

Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 33727439724a..f3dc1865f291 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -830,7 +830,7 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			   bool up)
 {
 	u8 cmode = chip->ports[port].cmode;
-	int err = 0;
+	int err;
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
@@ -842,6 +842,8 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 	case MV88E6XXX_PORT_STS_CMODE_RXAUI:
 		err = mv88e6390_serdes_power_10g(chip, lane, up);
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	if (!err && up)
@@ -1507,7 +1509,7 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			    bool on)
 {
 	u8 cmode = chip->ports[port].cmode;
-	int err = 0;
+	int err;
 
 	if (port != 0 && port != 9 && port != 10)
 		return -EOPNOTSUPP;
@@ -1541,6 +1543,8 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 	case MV88E6393X_PORT_STS_CMODE_10GBASER:
 		err = mv88e6390_serdes_power_10g(chip, lane, on);
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	if (err)
-- 
2.25.1

