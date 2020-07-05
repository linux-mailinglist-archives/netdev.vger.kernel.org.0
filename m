Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60BA215052
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 01:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgGEXQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 19:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727970AbgGEXQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 19:16:03 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47BFFC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 16:16:03 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id 9so43188676ljv.5
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 16:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AXKexd4MzK1hVboNLLmQky0SOZO0lAu7FfFVMrF6AKM=;
        b=Am3Up0oxkIJbITdJ9g1vtgh2GaUCy7ythe+9wquj/EFKRoONwtolQZeI1R9Z1gceGU
         7BEH4DS1HrfHZqZVznJxhy12k5udfxBtsPxZU6bboOD9sEKp0gzuA4YyJg4AAmVW1Q1g
         pOaIUZu+Qj2NpHcAxZVp4+ew8kwab/jTSSEFyeipMb89vn4935l4ZpBVgwf84gttqszw
         UxsZxikg228VBnaIoJapgJBYIvZ7Dg+hOTQ0Y2AGzzU8+wHHRs8p22kUFz7H/03HZOa1
         9A9csEXJ+RIS0sFdtPEFj9TqA1qQ+IQXIyGe/9VmeH5OgOt0bk+idWbkQQEbZgU37B23
         GH/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AXKexd4MzK1hVboNLLmQky0SOZO0lAu7FfFVMrF6AKM=;
        b=iUTeDvU2Yh9pq79w6wJhCKuGzNBTlelaOE/JTzYU8Y62qwiqxBxypEqU49DtmOujqT
         AdgEHVbUZ7aXxYzig6PiQH+mUHQTTtkN9vHrpifoVOF8+Oe/Hf/pfKDl4EUxozGhjyOs
         ax8T2f6sABHw2Vyn7+9EkchgbClnq3vCfICaSvCYqP9L7ZfoFnSMlYnp3DhTEgmz42nU
         OEPysD6PzKA79ur/L0baq266Jafm/MYhm7UM9ZOv47RW4XxwpTzatx9iMPuCDbRLdMLJ
         ubCrJe7rbVITU8EpUUlqpCYeDkMJ4st3NjLoIoHFaEClQb/CPsGHyDdI9vwmzstE/Eda
         fOFg==
X-Gm-Message-State: AOAM530pdoeLkq+eyVDCGyh+mwK53wOlt63ec8kM19zSnYFVsq5K4lwU
        fbHu01GKLsb2WfmEL+PvF9sJog==
X-Google-Smtp-Source: ABdhPJxi5I4nK/awJa4eTzTEhQ++7szfw+dg2OAAuF5SWJ+/kHiw8Z4shxLxp9MZjwdTYe7+wVyg4w==
X-Received: by 2002:a2e:8804:: with SMTP id x4mr25809262ljh.56.1593990961363;
        Sun, 05 Jul 2020 16:16:01 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id f14sm8439410lfa.35.2020.07.05.16.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 16:16:00 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [net-next PATCH 3/5 v3] net: dsa: rtl8366: Split out default VLAN config
Date:   Mon,  6 Jul 2020 01:15:48 +0200
Message-Id: <20200705231550.77946-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200705231550.77946-1-linus.walleij@linaro.org>
References: <20200705231550.77946-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We loop over the ports to initialize the default VLAN
and PVID for each port. As we need to reuse the
code to reinitialize a single port, break out the
function rtl8366_set_default_vlan_and_pvid().

Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Rebased on Andrew's patch for the (int) compile warning
  on GENMASK(). change is carried over.
- Collect Andrew's review tag.
ChangeLog v1->v2:
- Rebased on v5.8-rc1 and other changes.
---
 drivers/net/dsa/rtl8366.c | 70 ++++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 27 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 993cf3ac59d9..b907c0ed9697 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -253,6 +253,48 @@ int rtl8366_reset_vlan(struct realtek_smi *smi)
 }
 EXPORT_SYMBOL_GPL(rtl8366_reset_vlan);
 
+static int rtl8366_set_default_vlan_and_pvid(struct realtek_smi *smi,
+					     int port)
+{
+	u32 mask;
+	u16 vid;
+	int ret;
+
+	/* This is the reserved default VLAN for this port */
+	vid = port + 1;
+
+	if (port == smi->cpu_port)
+		/* For the CPU port, make all ports members of this
+		 * VLAN.
+		 */
+		mask = GENMASK((int)smi->num_ports - 1, 0);
+	else
+		/* For all other ports, enable itself plus the
+		 * CPU port.
+		 */
+		mask = BIT(port) | BIT(smi->cpu_port);
+
+	/* For each port, set the port as member of VLAN (port+1)
+	 * and untagged, except for the CPU port: the CPU port (5) is
+	 * member of VLAN 6 and so are ALL the other ports as well.
+	 * Use filter 0 (no filter).
+	 */
+	dev_info(smi->dev, "Set VLAN %04x portmask to %08x (port %d %s)\n",
+		 vid, mask, port, (port == smi->cpu_port) ?
+		 "CPU PORT and all other ports" : "and CPU port");
+	ret = rtl8366_set_vlan(smi, vid, mask, mask, 0);
+	if (ret)
+		return ret;
+
+	dev_info(smi->dev, "Set PVID %04x on port %d\n",
+		 vid, port);
+	ret = rtl8366_set_pvid(smi, port, vid);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 int rtl8366_init_vlan(struct realtek_smi *smi)
 {
 	int port;
@@ -266,33 +308,7 @@ int rtl8366_init_vlan(struct realtek_smi *smi)
 	 * it with the VLAN (port+1)
 	 */
 	for (port = 0; port < smi->num_ports; port++) {
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
+		ret = rtl8366_set_default_vlan_and_pvid(smi, port);
 		if (ret)
 			return ret;
 	}
-- 
2.26.2

