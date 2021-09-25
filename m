Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCF8418518
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 01:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhIYXDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 19:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbhIYXDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 19:03:33 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B656C061740
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 16:01:58 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id u8so56650933lff.9
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 16:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aEbVU1x57FyQIizkQNokEr+/kzDXEj5p9oOADNfgO3o=;
        b=zX1p4w34JlmsFP7th4iRnPU5Y4gl28/MSTRDbgahObrRZfeFcQyp6Cun1uLuL7ZRgh
         XbJxbpvTZbZnEIWY2HFP6Zzz9vUzAvofY1tFRt+RfmKRoyKQ0iLkq/Z+8P6QemaaNZ3X
         mWkgtzYUu6QeHzDBEH5rX8foGmgnIB11UFOq9eTIHts7uxVfwnH1X4zuMzPWkFRgGu+H
         aUCobVYvXUp/q2qc2xp7IcfhexaHR+4Zj3RuvMrOOMS1L400UjzM1HnPQr8ZCdJiJ4ks
         6ZMelXBsdiApbiXWc4nQVTuLLbPrC3kDNXv1xSeSQGJfHFrwadRiPGe67br4+YMMQ1up
         VPUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aEbVU1x57FyQIizkQNokEr+/kzDXEj5p9oOADNfgO3o=;
        b=1T+wo85zg/E+3matGmqU8QBLe5jBv1F3csZIN/B5gpUgQdPPyVCgsWS0KNkVbbJvK7
         OQfX+5++RqzCX4C6PXh4c7rwlz0Rmu2poAHtNajl2a6fVGHS2MHiN/RNcA8y5VS8uEFD
         NQtXE38DjGrWxKtDn4sj0cJT8Uvn1+NVbOMMX7qhrBPJwTy7g5wjIP+KP82HOEzLlLQI
         PwNhgynN8TrW8njbrX9ncbKYRDeknjUvB+HNrHpMI28QzKgVToGVpAt0pgrCpleXCjjA
         7jq6hoMqLckHtN6MKU18ubfuBxse7nDoypPYUbwyWG3EgczURUsLLGjKynj93yCwxuD9
         4rTw==
X-Gm-Message-State: AOAM533DWkKwABE0DoOFBmmvw4HATpp+fOv9rdYI2oacSDnDRjpLF4D7
        RYySW17NvdcjCt3OvE1UOMPaQg==
X-Google-Smtp-Source: ABdhPJwDqY/bvnYEB/DKhjlyKyxRgsOqz6eea6upk2iBm0uH2vCWDrMsBQmvwsAjBBBMCYbMUzwV1g==
X-Received: by 2002:ac2:5e23:: with SMTP id o3mr16860180lfg.352.1632610916457;
        Sat, 25 Sep 2021 16:01:56 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id d27sm1448111ljo.119.2021.09.25.16.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 16:01:56 -0700 (PDT)
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
Subject: [PATCH net-next 5/6 v7] net: dsa: rtl8366: Fix a bug in deleting VLANs
Date:   Sun, 26 Sep 2021 00:59:28 +0200
Message-Id: <20210925225929.2082046-6-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210925225929.2082046-1-linus.walleij@linaro.org>
References: <20210925225929.2082046-1-linus.walleij@linaro.org>
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
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v6->v7:
- Collect Alvin's and Vladimir's review tags.
ChangeLog v5->v6:
- No changes just resending with the rest of the
  patches.
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

