Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4471EC413
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 22:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgFBUza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 16:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbgFBUz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 16:55:29 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00247C08C5C0
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 13:55:27 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id n24so3779720lji.10
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 13:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YD7hNiI0BkgOn2LYxPlMALflk0oZVF+W4LlCRqaBQAk=;
        b=CDJajuO0aYEL4USSj+tqMIFQwVgT8t+p/UV9hjvEB/pWxx+744kzngnZEtbrnIZOUN
         YD0bmzWkHywR2MyIJ5yGgeyj65g6+A0AGUUFYvsb3or+izKQxvbmclLiNa6FiHOOYfAu
         XgPPTF/l6Rr7iW/nbsK0gKXdzBSyMJolqhxqlLGKp2jMRHDj7soePUwhG7YwnTHD1EN9
         5CV3mogUfjQfPCrxPzwy0vRwmtaQCjnnEye87CbST96O8OL3GeOmCHFV3xCFLRAKVHJx
         2s7uAYKxBvhRpPiPwyJwY7CmKW7yRbnbD9bJcm/Hs7DNfu6N4dpTvguXWVhGq/EYK+fr
         2Z1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YD7hNiI0BkgOn2LYxPlMALflk0oZVF+W4LlCRqaBQAk=;
        b=SLkmjSdYZAC0nT8nXD3CPHOGqrk9tzuiD/V3JeI1Gw/IjRKqAGk4feCte6qLtPizUL
         ERw5Rcinr+mMeVF3aAHQikbhu1cK5LiJXfFl9BhxodAZgey285K+VpSrvsvLs3/P4ixM
         D+4UMKoQVzEVUcZ63YmXPve2z3a4YtT3Am8EAMfXRnWJmfqPw/cBcFtIzVGTep3spubm
         L1g3aOxCm3ytOitRKlwCtPjUHnW1IN66bHtr3qZrz5Vh7SjbbM8N7vALVgPunwHzWPjb
         hAVrOTizpxQsotfmXs/R8iM4jZnqYPKjul3ywtTMiiGNrJuZtl4gEHQDTYW4Lq0zdujr
         QaEw==
X-Gm-Message-State: AOAM530KOcN/kY2/yVEQ3BIOuQ3WsuP5awXtawNYA1EFYofscQtAWVqt
        YhH14mpjjJ4yWMLJLc802OI94Q==
X-Google-Smtp-Source: ABdhPJyTmlgliUfj4x0srWtRjzrLG7HimqPkUUQuYnM199j9Cl9TXU9LPj76cJ42zTRpu/nZc77uwQ==
X-Received: by 2002:a2e:87da:: with SMTP id v26mr446078ljj.14.1591131326379;
        Tue, 02 Jun 2020 13:55:26 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-8cdb225c.014-348-6c756e10.bbcust.telenor.se. [92.34.219.140])
        by smtp.gmail.com with ESMTPSA id t5sm41962lff.39.2020.06.02.13.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 13:55:25 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [net-next PATCH 3/5] net: dsa: rtl8366: Split out default VLAN config
Date:   Tue,  2 Jun 2020 22:54:54 +0200
Message-Id: <20200602205456.2392024-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200602205456.2392024-1-linus.walleij@linaro.org>
References: <20200602205456.2392024-1-linus.walleij@linaro.org>
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
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/rtl8366.c | 70 ++++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 27 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index ac88caca5ad4..66bd1241204c 100644
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
+		mask = GENMASK(smi->num_ports - 1, 0);
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
-			mask = GENMASK(smi->num_ports - 1, 0);
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

