Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBDB417E5B
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 01:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhIXXkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 19:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345149AbhIXXka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 19:40:30 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14F5C061760
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 16:38:55 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id u18so45415653lfd.12
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 16:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WMsTxrWHhRC1xT+2K/5RB0/0syWqfSvMlujp2wqvh6k=;
        b=XDeHQPoN24Et/JFoyMK1/35+aWdPmmX80Maar1VdfEj3YmfR1x35uwbzhYJEfj/Z6Z
         f8xzBoKnYjmvXsiBEW+67wnpviqPOuGm/qfzKlT/akhgNgCi/AjBxY27BP4GoCTP0q+N
         xiD7TEA5urE99Fpd/cKdXIIXLf2rRxmRS6BuWgqcjBPXdBB7NxVlHMm/YjEpO0o6XPpq
         RT4vVnlabWE3iADKcdeOnGxWyGNTfMVmB8fkujRz+BeoZwbvb+q1ec5RKD4whr0SSPf0
         kOzIaon6dF46mmKnuwnK1rTWKSLlcmAx06107CjBB2PDC/UF85EOWj6Irp3BjQZGlpEq
         AwpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WMsTxrWHhRC1xT+2K/5RB0/0syWqfSvMlujp2wqvh6k=;
        b=Sy4KS50gpoWQtwL5QHJdgbps7G9JhSm6jbG+S1PfT5A61zcwFrHvrTWyiN/rJOF4Sl
         qKWVxWM/0pjKFXudoFJerTUbCe9WkSLRkVVqN2u8zfbuazrMHvrU8tJDXpGAMAnzooje
         lOPgYGGJRPxlj5e2yFPTTGtran2s6B748Krzjt7NGUHHR/cD8zSqnrb2i7S3RtZ6q3QI
         Q6wVRq70DAkGzvt9HlDLqe8BkX9FLbRt37rPUseyUYj4Wyp+2NPt72kazh4bzFhb9lm5
         n3Mp0GD/YKheXnyMNP3tC7w2DmP/OiDtvXvKNB072cu5yx2vx3/byp+HONViDzTg07PG
         cVHQ==
X-Gm-Message-State: AOAM5306MGoSLRRk+7uMHLnUXS8Imq3w78P+CvPc4GxsAh0BFJfqPse+
        W+QrEIYb9l5cAqFfYaNdYEP8OQ==
X-Google-Smtp-Source: ABdhPJwCGO4nxtzORznxJOgAliQS3tOmGWL03ubqwSiGNTDc6ky5Z5LRkSeGoVZSvcgSLIeoEBh5oQ==
X-Received: by 2002:a2e:5803:: with SMTP id m3mr13948055ljb.137.1632526734130;
        Fri, 24 Sep 2021 16:38:54 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id k21sm1176652lji.81.2021.09.24.16.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 16:38:53 -0700 (PDT)
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
Subject: [PATCH net-next 4/6 v5] net: dsa: rtl8366rb: Fix off-by-one bug
Date:   Sat, 25 Sep 2021 01:36:26 +0200
Message-Id: <20210924233628.2016227-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924233628.2016227-1-linus.walleij@linaro.org>
References: <20210924233628.2016227-1-linus.walleij@linaro.org>
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
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v4->v5:
- Add some more text describing that this is not a critical bug.
- Add Fixes tag
ChangeLog v1->v4:
- New patch for a bug discovered when fixing the other issues.
---
 drivers/net/dsa/rtl8366rb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index 1f228a7a5685..7e57442ab0ca 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1451,7 +1451,7 @@ static int rtl8366rb_set_mc_index(struct realtek_smi *smi, int port, int index)
 
 static bool rtl8366rb_is_vlan_valid(struct realtek_smi *smi, unsigned int vlan)
 {
-	unsigned int max = RTL8366RB_NUM_VLANS;
+	unsigned int max = RTL8366RB_NUM_VLANS - 1;
 
 	if (smi->vlan4k_enabled)
 		max = RTL8366RB_NUM_VIDS - 1;
-- 
2.31.1

