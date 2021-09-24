Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CA4417E5C
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 01:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345192AbhIXXkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 19:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343603AbhIXXkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 19:40:32 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3C9C061571
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 16:38:58 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id z24so47584145lfu.13
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 16:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mYZoFK7FS+15PHZW0TzOGr7TcQmdt+hsCtzBIKDLxuQ=;
        b=Y6q64wXQ1G+Q4gu4gMAGZQ0LHwi/3PTMcBtOV88cfQqyzw+97wAtPs1PXipSW+nijs
         wAT/8DW7ygLjGHQKo6+PkpSMWlFqUYsuF2XBltHFRtNb6JVOYZq4jXZtDI0i6ylbKmCD
         oKpXRMsX5VWksn8g+nZjjoKcNuHpQtPV/IZ8WAhQDPOwCxml6quWtnqRQu3IhmN3vqTJ
         WTuhR6ftWjBSqfV3wB6BODqVOrwu8ieQTAI3FuuGWUYgNUp6BwqQCg4ogWjhq1ShedXQ
         2TPNqCtyDhnY4nUYOwD49C67gYpcu70sWLIg6470zusM9e9rh9Q/D+FBujA+OZ5+VTiW
         mdfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mYZoFK7FS+15PHZW0TzOGr7TcQmdt+hsCtzBIKDLxuQ=;
        b=F9UbfGTld02w57Q7nouxrnwsD3Z4ZmNlQpx6oNYI1dezPRWqb+U0x8cDlVKNE0XTuw
         zNJtPGYp48xpEWF2o5nme7B6ymYqLMXOo3z01v3aypqdsgeJOSy/IORQvHW8UbxQQD70
         ONY3+B86M2D/Dj5ib19ziKw5iauAu7PaMPJkKaVGRod6Y6kPja6QpIi1tvAveuOcBHXA
         zNXNHlqufTu+/dbAOagDxQbA+DYmNTSmtiG9jpeZucI0jo+Fp9HZwj5aXXQA8HGFFGSJ
         qMQBlIfsq/Xpna6hVO9rP2cquMG663fJJVf+opZQbbrfmO1JlDIV4Nlo6MOwa+gdVEJx
         zGgQ==
X-Gm-Message-State: AOAM531rLYZWNo6i4o8JXOhzyR83Dhm49E72AkU5/EuL0bMW5dQPaWQZ
        89zFusETDo69R4Z56oclXYZHYA==
X-Google-Smtp-Source: ABdhPJzbhpzCZAyuG2Po5+/a0/HrGYRHYnqGHgQmhTHZTCMPCajP2fRZi2ckRKH+2YRcNwEzKiWjcQ==
X-Received: by 2002:a05:6512:3d8b:: with SMTP id k11mr11720754lfv.633.1632526736845;
        Fri, 24 Sep 2021 16:38:56 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id k21sm1176652lji.81.2021.09.24.16.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 16:38:56 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH net-next 6/6 v5] net: dsa: rtl8366: Drop and depromote pointless prints
Date:   Sat, 25 Sep 2021 01:36:28 +0200
Message-Id: <20210924233628.2016227-7-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924233628.2016227-1-linus.walleij@linaro.org>
References: <20210924233628.2016227-1-linus.walleij@linaro.org>
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
Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
Cc: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v4->v5:
- Collect Florians review tag.
ChangeLog v1->v4:
- New patch to deal with confusing messages and too talkative
  DSA bridge.
---
 drivers/net/dsa/rtl8366.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index f815cd16ad48..bb6189aedcd4 100644
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
+		pvid ? " PVID" : "no PVID");
 
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

