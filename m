Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B499041B253
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 16:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241422AbhI1Oqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 10:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241427AbhI1Oql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 10:46:41 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD339C061749
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 07:45:01 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id u18so91950015lfd.12
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 07:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PIgf3DsDMzPlEkL+3qloth/cat7utuH+OdIdrgmjoIs=;
        b=JLcmRMCcF7wdaVnVYrobu2efL0u0TCbuxotlva05T572L0moE+PORETze3VzZxLooH
         TrruhDuQ4+N/1YePqgvvhukM4t4/Db01LPiFYT23PQ7u9x7OSqysXRNk31sohcXslyGR
         Ib+ssGQVeev/zAYuEhr4GUEFM7h60kA86A+6+ttpB28Pj+PreFbwjw2NHMw/xa0y568Q
         skN6zgYU9RXn1wy5oGW6zEqaKN3VGY+vPPvzedyP9wMQq9MNAVxLxJWUMFkD6afHrEeR
         ELVpdZN+eqSeCDourf2YiW8KCvvANDxp7cUHHcpgif8ZDRr52XcFYuWEuh4Yq0PzU2hR
         I4KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PIgf3DsDMzPlEkL+3qloth/cat7utuH+OdIdrgmjoIs=;
        b=2PwEwn9HGSEmZZMTl/abET2G3uM3jSLsbPotk0fYq+olt/fmTZyny7Xspq+mt/B0uT
         d77TSWplPmMuoM0Y/PBL3BgksSy9gY+yfhEGZvrF6+eaQm4b7Am1SIdNj2Ds6QpbFffQ
         bOx3K4Tt7b1CP1y7TE+5QpRyvKmos01ZIFnOUYhoPpRrc/sw5Cgnd6RtCdKzL1XYzN7p
         xuPLWM+Jc6xoLY6iaUY4sJ/m1PFIjNkhGXT3rnCFcNWCx+lJ+1c1FVdV8CXiB+1tuhKl
         i6ktGS/yoz0LIKHZwiB1Nakan1NQF/+c8VPlBMnd9e/2zmJZXpewQnlrTLSFlR2FpTJR
         JMng==
X-Gm-Message-State: AOAM5309Gx3SJxBXEHImFl3e3T9k9TC7/MhObwZmtCJFf846lA/1x3IC
        5EYLZznRj3PHE0j++UktCoXy2Q==
X-Google-Smtp-Source: ABdhPJznXyUDeS0Z/DhQhBouIFuMuam0TvcIHmo7WZLP8dRgPdQ7NsIONirVvli07OVOXOGBRLjv0Q==
X-Received: by 2002:ac2:5387:: with SMTP id g7mr6011190lfh.541.1632840291460;
        Tue, 28 Sep 2021 07:44:51 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id x23sm1933462lfd.136.2021.09.28.07.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 07:44:50 -0700 (PDT)
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
Subject: [PATCH net-next 4/6 v8] net: dsa: rtl8366rb: Fix off-by-one bug
Date:   Tue, 28 Sep 2021 16:41:47 +0200
Message-Id: <20210928144149.84612-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928144149.84612-1-linus.walleij@linaro.org>
References: <20210928144149.84612-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The max VLAN number with non-4K VLAN activated is 15, and the
range is 0..15. Not 16.

The impact should be low since we by default have 4K VLAN and
thus have 4095 VLANs to play with in this switch. There will
not be a problem unless the code is rewritten to only use
16 VLANs.

Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v7->v8:
- Collect Florian's review tag.
ChangeLog v6->v7:
- Collect Alvin's and Vladimir's review tags.
ChangeLog v5->v6:
- No changes just resending with the rest of the
  patches.
ChangeLog v4->v5:
- Add some more text describing that this is not a critical bug.
- Add Fixes tag
ChangeLog v1->v4:
- New patch for a bug discovered when fixing the other issues.
---
 drivers/net/dsa/rtl8366rb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index b565074b0462..bb9d017c2f9f 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1515,7 +1515,7 @@ static int rtl8366rb_set_mc_index(struct realtek_smi *smi, int port, int index)
 
 static bool rtl8366rb_is_vlan_valid(struct realtek_smi *smi, unsigned int vlan)
 {
-	unsigned int max = RTL8366RB_NUM_VLANS;
+	unsigned int max = RTL8366RB_NUM_VLANS - 1;
 
 	if (smi->vlan4k_enabled)
 		max = RTL8366RB_NUM_VIDS - 1;
-- 
2.31.1

