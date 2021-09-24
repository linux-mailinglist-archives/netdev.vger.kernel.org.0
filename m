Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63032417E5A
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 01:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345264AbhIXXki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 19:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345192AbhIXXkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 19:40:31 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D10C061762
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 16:38:57 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id z24so47583990lfu.13
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 16:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6oyOVt1g+lnmeELtwPigIKUcCfyMaHiZkeh2y7CVFYY=;
        b=xOCL6IKYthmKz1XSjk8ogEaoN8jLKXYKWm2NjgeyV9Q+YGO+RgSAeDqd0v9YChtErz
         ukWDpMTpFBb3XNsSP9428IV5Z3yaNWGSlhWm3wtw5QodWxNS3aI4Pu9C3y1Icf6DHeIV
         j2PtlQpn1G3BYGrCGDg0eDBqh3cDjXqAIrEo0QMFcjdFJP2+tMvOaSMKwhLobwNCgzi3
         FYnHFnYvHL8WmZwmonletxU3jWq1pql5cMoMfF+bTg1F9Ok0P2jR973MnvsuF67x11Nz
         7DrVvKjFGSeQCq4Tu5IbpdDjeCeYAXg5jGnl1OuGV3YHSPDAgfBBKsvbPvPRYGezqMbR
         yLsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6oyOVt1g+lnmeELtwPigIKUcCfyMaHiZkeh2y7CVFYY=;
        b=WMjsKF2U+KnoMD9p2XuKBaH5+0dJq2IBXyV3OdmsN+gqoG2XpEr9u74hcG3SsbS7X/
         sQ/9SEMnfhQBz1/QdQcLOZAdzVcHgNUopWhtdj/1ibbswNdvmJw2YgxvergG+J2Dk2yq
         LK04zEz98lUZ+kGe5QZ0btTF8guLNZhtx64Qpz/R5fN+XJutnmOqHtkYsUOGbnA9KOrs
         9/dJ4EgoKJ4GrQZdKb0AAshTbn91GSimzgOxJwb/TPsRCIho2kQcDk9rheLce9DoY6ai
         yHF3r0V1jHoh2ZXzpWHg6tSmd+OUVMk8UwERVrODoNwd99Afowj2TR3AaRwv68RGZuE6
         JVoA==
X-Gm-Message-State: AOAM532KdmrDsPPK8xmNiTNnA1KfESUcToglD7/NgBuRc0hgWLh6uEKg
        17hzCRC3VlFKHjn5amVvEKjHIA==
X-Google-Smtp-Source: ABdhPJztc42RLfWp0+gSplfh9/FHdGCnp8XZBhR4crJsf+v8Ig4Xi9KwwAK6KX8cCnJu18XbmKkArg==
X-Received: by 2002:a2e:750d:: with SMTP id q13mr14266925ljc.420.1632526735512;
        Fri, 24 Sep 2021 16:38:55 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id k21sm1176652lji.81.2021.09.24.16.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 16:38:55 -0700 (PDT)
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
Subject: [PATCH net-next 5/6 v5] net: dsa: rtl8366: Fix a bug in deleting VLANs
Date:   Sat, 25 Sep 2021 01:36:27 +0200
Message-Id: <20210924233628.2016227-6-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924233628.2016227-1-linus.walleij@linaro.org>
References: <20210924233628.2016227-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We were checking that the MC (member config) was != 0
for some reason, all we need to check is that the config
has no ports, i.e. no members. Then it can be recycled.
This must be some misunderstanding.

Fixes: 4ddcaf1ebb5e ("net: dsa: rtl8366: Properly clear member config")
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v4->v5:
- Collect Florians review tag
- Add Fixes tag
ChangeLog v1->v4:
- New patch for a bug found while fixing the other issues.
---
 drivers/net/dsa/rtl8366.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 0672dd56c698..f815cd16ad48 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -374,7 +374,7 @@ int rtl8366_vlan_del(struct dsa_switch *ds, int port,
 			 * anymore then clear the whole member
 			 * config so it can be reused.
 			 */
-			if (!vlanmc.member && vlanmc.untag) {
+			if (!vlanmc.member) {
 				vlanmc.vid = 0;
 				vlanmc.priority = 0;
 				vlanmc.fid = 0;
-- 
2.31.1

