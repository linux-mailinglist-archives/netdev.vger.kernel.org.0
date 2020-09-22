Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49102749BF
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 22:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgIVUEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 16:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbgIVUEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 16:04:07 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25461C061755;
        Tue, 22 Sep 2020 13:04:07 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id y14so2795542pgf.12;
        Tue, 22 Sep 2020 13:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SuV+yJBGSoAtpEbxONX5yGGmxZPrDGQ8MAV9fK25O7U=;
        b=r6sy8YWIHD434X4QCttQdlj3mKj5epCo7+RVNQVPT9+eTXZIS/Y2VBCRwmPSQuUze5
         ru3ClwDDdlAAHqZwoy555VaRpW0RaAcOOBCcjjaYNI3CnGQFzo7fbLsY/6jy4fUXuiGH
         1udnYN4cMoKoJEKDbM08SOr3MUGQo2rccX5nYRvfw9+fGpV3eLJFP1poiatD+1T5N4Lm
         LyJ5eVWey8F9gohSB62ssgyAciyDyiNahYWHYCy+ZYHZhZV4TC8e30WSJuUiNo1Oavya
         jnF9BArCPceHO3Vj6Moddm1QDvxnRO9CJujrIImXOjgmK6RGxXrgoLZ5ruBGWXvs7OhE
         eRAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SuV+yJBGSoAtpEbxONX5yGGmxZPrDGQ8MAV9fK25O7U=;
        b=Jr1E+1A9XQLaXl2MlM8SYgy317CkvJjy+z3h8u+5Q4edRvw9FUQWnLZ8Ddnx0I7a2U
         mZLOmTGly7rnqWZ9+YXUbWe9o8gVnLO6AdocTJqBCwVCKnNRVttONaZSdTNuaH3/ximZ
         1I1iV/EbBiY7RPhWMwVgq3CMJPq2jWy60IDiQT/u47Uud6ldL0MGrWOuBZXSOYj+tzjP
         +5mm6iApvngE5oaLZiSYBIoFzR81qoo9/C3IRdCp+3Qvr6tfBhZt/D9sKPbZv8XPV0oR
         rqYC8Jb2MbKnYTzdp2V41Z6hcu3MYqAIg3K/gEMhZeHQjFOIBe9WChpy0hcxuNyof2Cr
         acyg==
X-Gm-Message-State: AOAM533pxkHVLqFfgMWvdYb4o/EHeI8ShpSci+b8oVibE5AgDb/Z/kQS
        fTNxGwdM7OQ/PoQqmP6JndMemjGaUSLG4A==
X-Google-Smtp-Source: ABdhPJy6pZDfRe0oHFfjxTkT1uXFPWChxskyJdswDvPi/fBxO0Jc9bewMlmRO5R2Ib6Qw/ECFdeZHA==
X-Received: by 2002:a17:902:7089:b029:d1:e5e7:be13 with SMTP id z9-20020a1709027089b02900d1e5e7be13mr272332plk.70.1600805046243;
        Tue, 22 Sep 2020 13:04:06 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q18sm15562700pfg.158.2020.09.22.13.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 13:04:05 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 2/2] net: dsa: bcm_sf2: Include address 0 for MDIO diversion
Date:   Tue, 22 Sep 2020 13:03:56 -0700
Message-Id: <20200922200356.2611257-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200922200356.2611257-1-f.fainelli@gmail.com>
References: <20200922200356.2611257-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to include MDIO address 0, which is how our Device Tree blobs
indicate where to find the external BCM53125 switches.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 2bd52b03de38..0b5b2b33b3b6 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -538,7 +538,7 @@ static int bcm_sf2_mdio_register(struct dsa_switch *ds)
 	 * driver.
 	 */
 	if (of_machine_is_compatible("brcm,bcm7445d0"))
-		priv->indir_phy_mask |= (1 << BRCM_PSEUDO_PHY_ADDR);
+		priv->indir_phy_mask |= (1 << BRCM_PSEUDO_PHY_ADDR) | (1 << 0);
 	else
 		priv->indir_phy_mask = 0;
 
-- 
2.25.1

