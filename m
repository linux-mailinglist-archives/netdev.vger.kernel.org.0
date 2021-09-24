Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C86D417E58
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 01:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345157AbhIXXka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 19:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245038AbhIXXk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 19:40:26 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0675C061571
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 16:38:52 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id y26so7383349lfa.11
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 16:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1ndp/1UpmZSSJkO792vxD6IRr0Ne7P+vQpY+t6aGjlY=;
        b=zFJJV5FUwPQ7lYQYifECC+qifOaN6x/GcMhftTPVnJ3sUUsZCLGJNpsCyrv7EREPz9
         YxWaRBxKAP9iM7aouJcQ2dJXsR32/WD8LKMhwmJvFeKkgKwAjeSya6Y4o3FrHiNgjzFY
         VjjAG98CA29Szae8azcTdFbJgdQ6wOUcC2P8cbLho5/3yO7r6C1wM7w9QnDtmkTHqcGo
         sntq2tB55aNGNVycqyeq4cn1Ept4s9wuW9yjGwTPwzG031zVoShVf9GhehJHfcrIrqWM
         fyZo/D7gZamTPMUFsVTH6jOWfhsfwtkzwZ8BHrJD7WhRm2gPp7UmfPw9hPoRFb/t3MLa
         8h+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1ndp/1UpmZSSJkO792vxD6IRr0Ne7P+vQpY+t6aGjlY=;
        b=TdriLmuZB4yBQcDomezsu4xly6lCH7geoQtKvwq2EWVQ7z70Ma5nshNQIFiGojlES2
         /f10G51p/jT3E7vb25kaU8Q+iewjWXFupah5lCyqNCAnaxKodEJLJ091lh4WSkkIucRg
         hTmyvOFxRreUwozSgrR8d0CcQpWcL25hYVHtbsOSVuC6ev9+yr//9lLkDOpx7tTkU7L1
         KsU2xWV76oVHK6gBhGC2Xx+K9lYDwU8BYnTpHc3Kq8wRJ2Jf9JFaKWMJM9djIsI8kcG7
         z+R41CsmKsRSOPQvFKCwlaMzorPi/rI5eHQ9q6vkQmao8eWpTld22Xeup0k52Vlif+NQ
         lYaA==
X-Gm-Message-State: AOAM531JeLBSNp57z9ZXvGFiF6qeIsr0YVjfczIXQ83APKSZekrG+87f
        QAsKhsr8jWo6VjO16llI9l1pvg==
X-Google-Smtp-Source: ABdhPJzrWmZUHPDggQXxj0R984duAabKj4mNBXiHLCHJFZI1KjCfP7goe8M4aQsm5qkdrR7plRvHHw==
X-Received: by 2002:a2e:974b:: with SMTP id f11mr13497805ljj.385.1632526731294;
        Fri, 24 Sep 2021 16:38:51 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id k21sm1176652lji.81.2021.09.24.16.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 16:38:51 -0700 (PDT)
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
Subject: [PATCH net-next 2/6 v5] net: dsa: rtl8366: Drop custom VLAN set-up
Date:   Sat, 25 Sep 2021 01:36:24 +0200
Message-Id: <20210924233628.2016227-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924233628.2016227-1-linus.walleij@linaro.org>
References: <20210924233628.2016227-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This hacky default VLAN setup was done in order to direct
packets to the right ports and provide port isolation, both
which we now support properly using custom tags and proper
bridge port isolation.

We can drop the custom VLAN code and leave all VLAN handling
alone, as users expect things to be. We can also drop
ds->configure_vlan_while_not_filtering = false; and let
the core deal with any VLANs it wants.

Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v4->v5:
- No changes just resending with the rest of the
  patches.
ChangeLog v3->v4:
- No changes
ChangeLog v2->v3:
- Collect a bunch of reviewed-by tags
ChangeLog v1->v2:
- No changes.
---
 drivers/net/dsa/realtek-smi-core.h |  1 -
 drivers/net/dsa/rtl8366.c          | 48 ------------------------------
 drivers/net/dsa/rtl8366rb.c        |  4 +--
 3 files changed, 1 insertion(+), 52 deletions(-)

diff --git a/drivers/net/dsa/realtek-smi-core.h b/drivers/net/dsa/realtek-smi-core.h
index fcf465f7f922..c8fbd7b9fd0b 100644
--- a/drivers/net/dsa/realtek-smi-core.h
+++ b/drivers/net/dsa/realtek-smi-core.h
@@ -129,7 +129,6 @@ int rtl8366_set_pvid(struct realtek_smi *smi, unsigned int port,
 int rtl8366_enable_vlan4k(struct realtek_smi *smi, bool enable);
 int rtl8366_enable_vlan(struct realtek_smi *smi, bool enable);
 int rtl8366_reset_vlan(struct realtek_smi *smi);
-int rtl8366_init_vlan(struct realtek_smi *smi);
 int rtl8366_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
 			   struct netlink_ext_ack *extack);
 int rtl8366_vlan_add(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 75897a369096..59c5bc4f7b71 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -292,54 +292,6 @@ int rtl8366_reset_vlan(struct realtek_smi *smi)
 }
 EXPORT_SYMBOL_GPL(rtl8366_reset_vlan);
 
-int rtl8366_init_vlan(struct realtek_smi *smi)
-{
-	int port;
-	int ret;
-
-	ret = rtl8366_reset_vlan(smi);
-	if (ret)
-		return ret;
-
-	/* Loop over the available ports, for each port, associate
-	 * it with the VLAN (port+1)
-	 */
-	for (port = 0; port < smi->num_ports; port++) {
-		u32 mask;
-
-		if (port == smi->cpu_port)
-			/* For the CPU port, make all ports members of this
-			 * VLAN.
-			 */
-			mask = GENMASK((int)smi->num_ports - 1, 0);
-		else
-			/* For all other ports, enable itself plus the
-			 * CPU port.
-			 */
-			mask = BIT(port) | BIT(smi->cpu_port);
-
-		/* For each port, set the port as member of VLAN (port+1)
-		 * and untagged, except for the CPU port: the CPU port (5) is
-		 * member of VLAN 6 and so are ALL the other ports as well.
-		 * Use filter 0 (no filter).
-		 */
-		dev_info(smi->dev, "VLAN%d port mask for port %d, %08x\n",
-			 (port + 1), port, mask);
-		ret = rtl8366_set_vlan(smi, (port + 1), mask, mask, 0);
-		if (ret)
-			return ret;
-
-		dev_info(smi->dev, "VLAN%d port %d, PVID set to %d\n",
-			 (port + 1), port, (port + 1));
-		ret = rtl8366_set_pvid(smi, port, (port + 1));
-		if (ret)
-			return ret;
-	}
-
-	return rtl8366_enable_vlan(smi, true);
-}
-EXPORT_SYMBOL_GPL(rtl8366_init_vlan);
-
 int rtl8366_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
 			   struct netlink_ext_ack *extack)
 {
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index b930050cfd1b..a5b7d7ff8884 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -985,7 +985,7 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 			return ret;
 	}
 
-	ret = rtl8366_init_vlan(smi);
+	ret = rtl8366_reset_vlan(smi);
 	if (ret)
 		return ret;
 
@@ -999,8 +999,6 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 		return -ENODEV;
 	}
 
-	ds->configure_vlan_while_not_filtering = false;
-
 	return 0;
 }
 
-- 
2.31.1

