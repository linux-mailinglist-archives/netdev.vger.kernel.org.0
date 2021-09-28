Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CEF41B251
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 16:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241416AbhI1Oqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 10:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241398AbhI1Oqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 10:46:36 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1088AC06161C
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 07:44:57 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id x27so93923253lfu.5
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 07:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=62y0ANGEUm3ySLIVamKt9x6B4cOMDWlyE3Xypm+3cmw=;
        b=Kmea0YCMrSIDBm9cAWPXW2eLpoDtU99SaCnLhyXiotUFbVN6vk3+9NodecFOZqg0Xl
         Ahh6gDFdhu/KbuzeyWkcyN9EOjrqUAZXztHv4mtaUawfMQTFyoNTPSL4Q+g3bQf+S8vz
         V8NFr7dpirKWrdTHGMmd63r/l3UKQHOMqLB7+Ra3cup2tC2nqb7srh+h3Vz0mjE/E8pE
         rSPkvLvMvd4ZhDXMYIPSXbKux/Wcruw6ZsPpia2ZZddJmug+7E/bp7OlSd8M2fTZH6Ts
         VUwESTollrjDJqxqh1WdnlwLvu1r4sbyVlxxclELBVqeBFZkmKvy/bAk24PjHpixogjW
         T3dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=62y0ANGEUm3ySLIVamKt9x6B4cOMDWlyE3Xypm+3cmw=;
        b=psvWjdlOCfvAtNE6PJtmSrIvTwuCDo1ic5MuxII7V3OIdqBSTyqzomS5/GVIA/7LPT
         X1PSnMSMEg8hp0fbLLcOaCoS94ovrohRcbYn5uQbB4N0+9aSMgGBE3ddAkMgvfLzqQZA
         FfNi+QOhnnDR/2r9bRckREK6WLcwf8arPiQiEVmMvFglCDSqYE7jrrh32YNOsSnEIh78
         Qxs+Fs+WErCLAuhD+UUxZZeLjOqv0Kp5EFZ8N6K7P+hnyDGDzv454WGVPlIPx87af14v
         jNoq1LUN6T/Ac1ho92zQWVGKoPfy0vAtqzrPyocyfxJJDp9pcIE4Ur7bZOkE0HL7odBa
         lSDg==
X-Gm-Message-State: AOAM531m6DxdJoz8C9CI4QrOGwYWnJBCDB6Vij0ljKQKO7iAccTCN7VO
        CNL/d9eEJ0O6N/41pXbGRhsCIA==
X-Google-Smtp-Source: ABdhPJz99AIJcxRi02OuZUTbnPmeGEHUZGQNzK6Lk8PfEfs5UocDHuhE9uL9LRCMGkZKhC2nhbspwQ==
X-Received: by 2002:a2e:58c:: with SMTP id 134mr374947ljf.100.1632840295361;
        Tue, 28 Sep 2021 07:44:55 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id x23sm1933462lfd.136.2021.09.28.07.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 07:44:54 -0700 (PDT)
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
Subject: [PATCH net-next 6/6 v8] net: dsa: rtl8366: Drop and depromote pointless prints
Date:   Tue, 28 Sep 2021 16:41:49 +0200
Message-Id: <20210928144149.84612-7-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928144149.84612-1-linus.walleij@linaro.org>
References: <20210928144149.84612-1-linus.walleij@linaro.org>
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
ChangeLog v7->v8:
- No changes just resending with the rest of the
  patches.
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

