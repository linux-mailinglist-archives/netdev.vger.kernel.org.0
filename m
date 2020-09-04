Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232AF25E361
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 23:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgIDVhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 17:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728027AbgIDVhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 17:37:36 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3C7C061244;
        Fri,  4 Sep 2020 14:37:35 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id e33so4988037pgm.0;
        Fri, 04 Sep 2020 14:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wkAVJoVoRBCJEyWInzS/e4imL5cccpTcbk0DieW+gr4=;
        b=t4lf6q4ciCDroGEJn4jGg0VxZuwB//H3Rn2QwoBvhYFJDDpFlNU1b8W1OVWs7Eqf8L
         3M+PvEKT0pLbCOHE94GXjVn601RXNKS4q1wxOq7ITiSXd6UKZJgN926jeR4XrapZu6V0
         +WiSbDEk/MxWq90c5xgEzT1ZFy/tclxX6C0JmqiVpoxvqklrQonCCPSFq55z3v5Y2kax
         mYibgyXCkqggE8ZTpLsZv9ROmeZzRRuBqBc39qHey4+d8NkzCogTn+aGMrKWzOOLCNMg
         D3KYH9UewRGLYmf558AdqCV8aBEVZO2t3gUy46i4NNoFjigBd1JAJa01wauLaaqTsbj2
         cUKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wkAVJoVoRBCJEyWInzS/e4imL5cccpTcbk0DieW+gr4=;
        b=AInNe3DSTwCxmOWPlb145c6oT+x0VqFNGeO8yFNCIc94lorZurH0Kw2RMpC4bhD3pn
         LLVQU6XjtLo065nm4tsNJJWA1rfKREkv4mROyo4Yi71xi2QL/9QV1qW+r4Cus4e8VhUw
         nUklXOmszBNLYxyY8HztIrjMGWtltk9uGY74V+pBtzZZGOWO2rAQH6HBNS6HsNo8zjSe
         tisRO/WQmjDhFS1QRAG5d0LgWXxuKY26oouI6/Mhg7/nUB0t3fSHLVjm0qWq0bSlHpok
         p+dhGhoGm2GWCiu7A82ZkTF0zpMLsCx/lc3IVhwtb/TYpyDn3SmwuNkr3STnl4nUgo9v
         glmg==
X-Gm-Message-State: AOAM530qhcDDmuY1l54xcfxlWcHIYUvLvv+SW4pTPp24UnvZm4UUayT8
        8SKmeyvkf21ZNGdfuQcgcXU/pmE0Th0=
X-Google-Smtp-Source: ABdhPJxKQh51JIWSeHtUcULy+XoA4scpq790dbR9PxNvODbVORgxPJ0cfSgA2k/2XGe7kKro62tj1Q==
X-Received: by 2002:a62:4e8a:0:b029:13c:1611:653b with SMTP id c132-20020a624e8a0000b029013c1611653bmr8271577pfb.13.1599255455104;
        Fri, 04 Sep 2020 14:37:35 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d17sm1255093pgn.56.2020.09.04.14.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 14:37:34 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE)
Subject: [PATCH net-next v2 1/2] of: Export of_remove_property() to modules
Date:   Fri,  4 Sep 2020 14:37:29 -0700
Message-Id: <20200904213730.3467899-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200904213730.3467899-1-f.fainelli@gmail.com>
References: <20200904213730.3467899-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will need to remove some OF properties in drivers/net/dsa/bcm_sf2.c
with a subsequent commit. Export of_remove_property() to modules so we
can keep bcm_sf2 modular and provide an empty stub for when CONFIG_OF is
disabled to maintain the ability to compile test.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/of/base.c  | 1 +
 include/linux/of.h | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index ea44fea99813..161a23631472 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1869,6 +1869,7 @@ int of_remove_property(struct device_node *np, struct property *prop)
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(of_remove_property);
 
 int __of_update_property(struct device_node *np, struct property *newprop,
 		struct property **oldpropp)
diff --git a/include/linux/of.h b/include/linux/of.h
index 5cf7ae0465d1..481ec0467285 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -929,6 +929,11 @@ static inline int of_machine_is_compatible(const char *compat)
 	return 0;
 }
 
+static inline int of_remove_property(struct device_node *np, struct property *prop)
+{
+	return 0;
+}
+
 static inline bool of_console_check(const struct device_node *dn, const char *name, int index)
 {
 	return false;
-- 
2.25.1

