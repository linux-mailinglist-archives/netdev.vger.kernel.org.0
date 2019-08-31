Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C43AA461F
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 22:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbfHaUTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 16:19:06 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38664 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728585AbfHaUTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 16:19:04 -0400
Received: by mail-qk1-f195.google.com with SMTP id u190so9257125qkh.5
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 13:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z1GPxUf88Sk/QhEmCMpdbhbV2q9RctC7UKfjfhLXAmA=;
        b=RdBkProxpW+XAkoBeIajuApHVrbpYNi4ZmZZOGyrGTseHo3Kz7vwNby6/RV9TDsenQ
         6FzHT8Ip34Tx7dbwrgv9aG6Epe3dwJjA7WWmHHj9oWAufwVGx/WSR1jiKaW7FZf+As6O
         RjmbJfKZvbS5q1y5jFH4BCWeGqQKNDSnwraxKLrJ9TgG+FzO4GY841UjRu0G8W2pLc7I
         /lFLPUB1zjLy41j7d/uvXnqIphnJFtMgFctHLT/LOkmd110DPXh8rJ7/bqsl8gOp/XSi
         KjUpxrmp0/kHyo7MgKEA6WmHjJ1ya+dRqooKxjVcTYf0SqBP4aPKScJ+p463CgroRP/R
         6E/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z1GPxUf88Sk/QhEmCMpdbhbV2q9RctC7UKfjfhLXAmA=;
        b=iL7jcdq0LufaxzypQtbCD8bqQcsTyod99v96tWzy9h6juESNSji5UXljqekMtMZ8wF
         pkrBdfuE6i3xFxarfoOxJs/gUOwpLn0KiU+nuY9jbz61GPgYuVruY4s/NHasMkLpSEAI
         4iCRaZeI1T3ILrWGDjMXL6usdKyPxLciS6fw7pFALDlZWf6nGsi5qNqZ+etq2i4t9ZQB
         EXKFVpCtYfUyTF+iAkd7Fix2G+kzJPR7D+/KUzuTyOyUouBCU3cf5cp8jEXO4pC/KP1L
         2ejMNlnfP9NPwSA9S3GQTan6QvwYDkS988IbIAgDhA985EyQOz3ePdpOn0QuE5wmfeEV
         8mdA==
X-Gm-Message-State: APjAAAVQDnJv7fKof4gIA5b0X49iHlEyxZpJYi8iQhEXrxjOSqAmrKdu
        JUkuCLbhdSGGQpOGlYe4T0bitv62
X-Google-Smtp-Source: APXvYqxVsbrBYHIgVqjNBuK7etw82kpyp3TRx+AtqtOIBJmFOihxxgwoSeRJQ8NDlrbaF69Ejs9WqQ==
X-Received: by 2002:a37:47cb:: with SMTP id u194mr21382744qka.342.1567282743633;
        Sat, 31 Aug 2019 13:19:03 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id a23sm4289933qtj.5.2019.08.31.13.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 13:19:02 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 06/10] net: dsa: mv88e6xxx: merge mv88e6352_serdes_power_set
Date:   Sat, 31 Aug 2019 16:18:32 -0400
Message-Id: <20190831201836.19957-7-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190831201836.19957-1-vivien.didelot@gmail.com>
References: <20190831201836.19957-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mv88e6352_serdes_power_set helper is only used at one place, in
mv88e6352_serdes_power. Keep it simple and merge the two functions
together.

Use mv88e6xxx_serdes_get_lane instead of mv88e6352_port_has_serdes
to avoid moving code. No functional changes.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 9fb2773a3eb5..e8ad66987be9 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -49,11 +49,14 @@ static int mv88e6390_serdes_write(struct mv88e6xxx_chip *chip,
 	return mv88e6xxx_phy_write(chip, lane, reg_c45, val);
 }
 
-static int mv88e6352_serdes_power_set(struct mv88e6xxx_chip *chip, bool on)
+int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on)
 {
 	u16 val, new_val;
 	int err;
 
+	if (!mv88e6xxx_serdes_get_lane(chip, port))
+		return 0;
+
 	err = mv88e6352_serdes_read(chip, MII_BMCR, &val);
 	if (err)
 		return err;
@@ -90,19 +93,6 @@ static bool mv88e6352_port_has_serdes(struct mv88e6xxx_chip *chip, int port)
 	return false;
 }
 
-int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on)
-{
-	int err;
-
-	if (mv88e6352_port_has_serdes(chip, port)) {
-		err = mv88e6352_serdes_power_set(chip, on);
-		if (err < 0)
-			return err;
-	}
-
-	return 0;
-}
-
 struct mv88e6352_serdes_hw_stat {
 	char string[ETH_GSTRING_LEN];
 	int sizeof_stat;
-- 
2.23.0

