Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435AA418519
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 01:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhIYXDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 19:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhIYXDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 19:03:35 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B69C06176A
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 16:01:59 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id u8so56651041lff.9
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 16:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6VfYsnn3GVcEaA6EHi8p6QPzT7sjqJpMMo1EYwRS950=;
        b=awT1mbnsCgJ6bB5yjKJgluu4r6q60V3FyC0vDLcXG6atpwJylnvWFnqIwWnC11k/JC
         E4b6+v5mC2wDaFROYCO6ou/NUT4HVeHcgD4dIMxJY9Y0lNSUgXwmU7oHdcN20Q08Q3z8
         gXVECa38nydF5oVExrwliDRPCem0dEJhi0rQO2kplwEQi5s8S+bg/WsHtqPBJb1QqSoe
         VdZ0S8fk+fsPOyK83ClPCfbP2nZPQZLUM2OEMO1MgoBo5D4S3h/oBnfq0Umul4GIsRKO
         MLAd+gn61diHU7IWykhI6WP0Iw891Bc7E5RvbjfNHGjxy/HLwXvYiUHDGYnK0W96Luk2
         h9TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6VfYsnn3GVcEaA6EHi8p6QPzT7sjqJpMMo1EYwRS950=;
        b=f6cCR7uwu8M7ShEHpkoUiyoQaYtL9F7A2Dr4QpDv7DEu4A89boSWWDVxhVKEcEpFR9
         HmiU2i/JkRE0pTBT+IMd+nZt9/ImSCgfoqcJVdFjofRBq7pNVoWj1NhCgojOmMVn3PCf
         pq7THtkqL5O1BA/50v+4lfZH0U7QEbyUyjNrvmueIdqtYoVlYVsb3WeB6F9r+YWzmQBL
         h8hmlPxf/Z+m2ytnETKOLsAaOg7JylGQ7VUXgZRuINiy21feL8EBzr8GfO4/c3GNB5M8
         gW2KjyyuSMYIwd6UF+dOvUgV4ckGfO2rHRtbwpU/Gnh7PJZlR3HudFFclOomJUZas/xH
         9XCQ==
X-Gm-Message-State: AOAM530uFAAV1X6Qz9vTPzVkCFCOxc7VQMSJ0+Yub8HwGkkL9GCtQzxk
        e/3sIYvZWf5RD9J794FKF2HhSg==
X-Google-Smtp-Source: ABdhPJw+mO3m4HfC1XuJ4ON843Jg0ewWVhVzb7vRD85NA7eVnrUE38VyAjrwGGmvD5LvjCmDe6mHaw==
X-Received: by 2002:ac2:4d48:: with SMTP id 8mr16221343lfp.394.1632610917748;
        Sat, 25 Sep 2021 16:01:57 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id d27sm1448111ljo.119.2021.09.25.16.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 16:01:57 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 6/6 v7] net: dsa: rtl8366: Drop and depromote pointless prints
Date:   Sun, 26 Sep 2021 00:59:29 +0200
Message-Id: <20210925225929.2082046-7-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210925225929.2082046-1-linus.walleij@linaro.org>
References: <20210925225929.2082046-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't need a message for every VLAN association, dbg
is fine. The message about adding the DSA or CPU
port to a VLAN is directly misleading, this is perfectly
fine.

Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v6->v7:
- Fix a small whitespace error in one of the debug messages.
- Collect Alvin's review tag.
ChangeLog v5->v6:
- No changes just resending with the rest of the
  patches.
ChangeLog v4->v5:
- Collect Florians review tag.
ChangeLog v1->v4:
- New patch to deal with confusing messages and too talkative
  DSA bridge.
---
 drivers/net/dsa/rtl8366.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index f815cd16ad48..bdb8d8d34880 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -318,12 +318,9 @@ int rtl8366_vlan_add(struct dsa_switch *ds, int port,
 		return ret;
 	}
 
-	dev_info(smi->dev, "add VLAN %d on port %d, %s, %s\n",
-		 vlan->vid, port, untagged ? "untagged" : "tagged",
-		 pvid ? " PVID" : "no PVID");
-
-	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
-		dev_err(smi->dev, "port is DSA or CPU port\n");
+	dev_dbg(smi->dev, "add VLAN %d on port %d, %s, %s\n",
+		vlan->vid, port, untagged ? "untagged" : "tagged",
+		pvid ? "PVID" : "no PVID");
 
 	member |= BIT(port);
 
@@ -356,7 +353,7 @@ int rtl8366_vlan_del(struct dsa_switch *ds, int port,
 	struct realtek_smi *smi = ds->priv;
 	int ret, i;
 
-	dev_info(smi->dev, "del VLAN %04x on port %d\n", vlan->vid, port);
+	dev_dbg(smi->dev, "del VLAN %d on port %d\n", vlan->vid, port);
 
 	for (i = 0; i < smi->num_vlan_mc; i++) {
 		struct rtl8366_vlan_mc vlanmc;
-- 
2.31.1

