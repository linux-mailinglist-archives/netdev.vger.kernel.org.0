Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DCD379C75
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhEKCIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbhEKCIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:08:31 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B144BC061574;
        Mon, 10 May 2021 19:07:25 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id l24-20020a7bc4580000b029014ac3b80020so329601wmi.1;
        Mon, 10 May 2021 19:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sK60gaKU0JJ3ab7RUURP4mNP0+dSnJ2h4FVnp3sZLXc=;
        b=p4rPFapoWg620Y6cEa0sE2q4uLN+zrhvd5wOXdW4YfSLLrJtY8NTKWGZ+H1LOgYlqC
         x4fM8j+M73miR7HTZkHR6JAwXmIkfMa9TJaxa8uU867bdoG1Tvrk7+2ynlvHBDpSM12U
         iquaO/ZZgdirY2qbArFnwbT4grVwufbKN8JkCrjn/fuOrR4drTadl9+DvHZehZCEBsi5
         5VggSXZgF+mSdF17ZtgiIV6xS4KZ3F+BNcqjCuLCelqe3v+nd1/GWnGoBXmtQMPP+Vl1
         4YcfbmFhBTejUZos63YIMGP9HgTAxYgVNPJOlK4Bm4BbcfFuBaMhkpNwiM25qiaeWLBt
         LmUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sK60gaKU0JJ3ab7RUURP4mNP0+dSnJ2h4FVnp3sZLXc=;
        b=ERvdWocaEoFbyOdEpOL2G3qX3H3gDVawtMBRqPCZh79TFZJEbf0rh2OxAVLJ86LvA7
         98kOL2Kr0zPk7rzDx0F618QMlLXVmycv3CsZyDKDjZ9j7WGiP2i6rvBWZT/v3+4xWXRA
         Hj2xBAR4cRWbkcXZSkcGoRXjc6pqEfok31NuHOvOGpzddewoJko5tnIAsPJa7wy+gLJg
         8ZJUjsRMFHQfy95fDxcu2ucLHWX0yxJ2NjCCHcE4q5eQwpzFVnc8Ep5/KNHcaqmo3hF7
         vCxOKiHok1u+o5wLMunz3YnQ8xPNZbG5djXeEkQR0g84Q4BIHbidBpHNVo3BB7nLYXop
         qDbQ==
X-Gm-Message-State: AOAM530iVDl70OBW+3/v09Ag2fqaajTn30YfqKeYfx9bPLvg6BXdPyLn
        usu6D4XEgsTLg+N3gm2MAzQ=
X-Google-Smtp-Source: ABdhPJyniuqTMVzlq/HXbbQ3A0xXBCAmWPwRB1AFtBDIbYPyCacI1+BYoPjs5h2FBJItDjOIX2O5IQ==
X-Received: by 2002:a1c:f70b:: with SMTP id v11mr11944550wmh.186.1620698844311;
        Mon, 10 May 2021 19:07:24 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:24 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next v5 02/25] net: dsa: qca8k: use iopoll macro for qca8k_busy_wait
Date:   Tue, 11 May 2021 04:04:37 +0200
Message-Id: <20210511020500.17269-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use iopoll macro instead of while loop.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca8k.c | 23 +++++++++++------------
 drivers/net/dsa/qca8k.h |  2 ++
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 0b295da6c356..25fa7084e820 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -262,21 +262,20 @@ static struct regmap_config qca8k_regmap_config = {
 static int
 qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 {
-	unsigned long timeout;
-
-	timeout = jiffies + msecs_to_jiffies(20);
+	u32 val;
+	int ret;
 
-	/* loop until the busy flag has cleared */
-	do {
-		u32 val = qca8k_read(priv, reg);
-		int busy = val & mask;
+	ret = read_poll_timeout(qca8k_read, val, !(val & mask),
+				0, QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
+				priv, reg);
 
-		if (!busy)
-			break;
-		cond_resched();
-	} while (!time_after_eq(jiffies, timeout));
+	/* Check if qca8k_read has failed for a different reason
+	 * before returning -ETIMEDOUT
+	 */
+	if (ret < 0 && val < 0)
+		return val;
 
-	return time_after_eq(jiffies, timeout);
+	return ret;
 }
 
 static void
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 7ca4b93e0bb5..86c585b7ec4a 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -18,6 +18,8 @@
 #define PHY_ID_QCA8337					0x004dd036
 #define QCA8K_ID_QCA8337				0x13
 
+#define QCA8K_BUSY_WAIT_TIMEOUT				20
+
 #define QCA8K_NUM_FDB_RECORDS				2048
 
 #define QCA8K_CPU_PORT					0
-- 
2.30.2

