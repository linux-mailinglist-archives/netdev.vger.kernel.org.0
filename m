Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7A521609E
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgGFUxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgGFUxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:53:03 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83000C08C5DF
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 13:53:02 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id h22so40053553lji.9
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 13:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IGRiCDosImo09IoK/bbV7wmdxtWQy6UAfjTnx38Q7Bo=;
        b=YbumsW7bQiN1yq7HrBRq3mtBzVIIOdhbZitKA3MVoINuEVSsetVz+FYmvYoqTnAOdm
         /pEYTx+SNIuj13maKN/UsybPzw21/Kb2YVqv+LtbZsT0A3MZYg62MiCCnxsTTQsn+OAj
         MLJGEawGQAhKq8LOBu+mKHULLkWWs3fNPxJQyKUlfQkJ+mnbp6VNvmLCHtcV0OzntVvr
         81xyB5hWJa++60i5ZJJRgfVFbObM4qdaWX/g3T7rnJf2zbOaYI6kshJk94Sxrqxj5ZV0
         uWDyeSSZBBKLUHBGrsF9sU/7Ew58Xamp/wbznbvupslRnLRGMYuPB6o5MjvIH6BujA5E
         TFQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IGRiCDosImo09IoK/bbV7wmdxtWQy6UAfjTnx38Q7Bo=;
        b=kzS1DCbpbSygAh1UOdFlMCaaGebyxQkJ1TFu1NlHnil6Qgr06gVevzNAsP7+LvtYNU
         UmGYZiCmQqkJg5EudQOV+eN5wnBwL2gJ+cMO61CRrSJZH8uD+WuY437D+buMYZbQvpM3
         fEwFfKDu2pJskZB0N6W45H27LilAEyjj/eEEEoHjcwBNns9mE/AHTjNdnwevCuG9HSLF
         oqZEey/RzsqrU2Td+DOQ6HlnQBazNSaEfEk5wqf3rAnFVntDefIxZAh9k3Mm3SAvnqtb
         /osYBBgo3P6UmXk7btI4z2/2gHxbmL9fuGGhpCxKQ/G5+ndCsljKsJtfy8N+qOw9toY7
         mJVA==
X-Gm-Message-State: AOAM532Vq9PcXB3gFgDrcuh9HE12U0MLdCWCzBv8gtCR0BdOWZacNijY
        gwWg5UKu0myajg9WDUjLrAnwrQ==
X-Google-Smtp-Source: ABdhPJw7zToliW2chOPqSxVzP2DAqaDHcRyJg58ry842rVfYpXIt/14ONRgIbA+Y+D224sNLqv7eUA==
X-Received: by 2002:a2e:730c:: with SMTP id o12mr22541989ljc.165.1594068780891;
        Mon, 06 Jul 2020 13:53:00 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id t10sm624714ljg.60.2020.07.06.13.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 13:53:00 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [net-next PATCH 3/5 v4] net: dsa: rtl8366: Split out default VLAN config
Date:   Mon,  6 Jul 2020 22:52:43 +0200
Message-Id: <20200706205245.937091-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200706205245.937091-1-linus.walleij@linaro.org>
References: <20200706205245.937091-1-linus.walleij@linaro.org>
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
ChangeLog v3->v4:
- Resend with the rest
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

