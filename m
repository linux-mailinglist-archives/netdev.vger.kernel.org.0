Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2E62717DB
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 22:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgITUiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 16:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgITUiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 16:38:00 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2A8C061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 13:37:59 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id v23so9422983ljd.1
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 13:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bDeFnL3dJQZAMkdqi8DvD+AKAGLNDf4MsO3jyDuyMS0=;
        b=IAtscVTB493Qm5D03V/fW/5gDSNB1dti0ZffEJMcZxCiaeQc5DRh5M/ZvdJjo0sDKF
         oEjWNm3SOpESfyMakoWpNJ3XN/qbM7ODbrTD3a8fKMBTgVMdaldLBd5KvY3BAkbwIoeS
         AwnwD9dC5SGqMQN21zZAN6tMadqmqH6RGgHDcSH99VPzxV4a5aeICyAJBKNgHqr7VGEb
         mpy19ARPWu7WmVskUvvMuIRUUj9ACGVTbS3fkyHnrZVR8nBHFK/6WJ7AIuRC4QBExVZG
         Afs3SWDrMT0TkM3JCOlk/ab2bC5uE3lzC2Z0DjzNb10FKnwiVjuf1omi9IwekaZ7MLTP
         dnDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bDeFnL3dJQZAMkdqi8DvD+AKAGLNDf4MsO3jyDuyMS0=;
        b=h1L+WcmRyKls3wPM0wZ9D4Zoy5S7IVzBsnsr+BcyoMQdcXFhaR8GUTzQZIsu4JjOnQ
         pX2rDd8Wr0WhNXWAxuh7QN9p01aWrmN7cNG4/ziLxftNo7EDd3J1+CY9FoJSJGQ5jvgu
         MhAzhVqHIiaJBNmeO/1kiga+D2Q7iCgttTee+rRSB9Y7GjTrJp2UZkbW08Nf0PYuc4j9
         YH/4ElluMYcWxgeDOJ72j0swwwgxoUF6dhPOEotqAxom1tVqmcgyObOity1llVu29F4g
         oxNeaqMTMwVrhiVRCm9phl1oVdBH9t8sLhDHO+2frBHpgEUW/+S+W8qj5KLKF2AIdgSA
         MxiQ==
X-Gm-Message-State: AOAM530ncaflOedYYdcyWVuFAFB3yKXbR96xLQkhYk7QRAr/no2bT3++
        ZQomLKNxo2GEVUEVD9E0DEtikw==
X-Google-Smtp-Source: ABdhPJwFmxQxeW9VM74MLJIRtullr1mGbSkOKN1eWIMFPOiKMLi4NUHJgtUSoMTGn5b3a/aGKeb23w==
X-Received: by 2002:a2e:964e:: with SMTP id z14mr12415225ljh.86.1600634278185;
        Sun, 20 Sep 2020 13:37:58 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id y10sm1995327lfj.271.2020.09.20.13.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2020 13:37:57 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [net-next PATCH] net: dsa: rtl8366rb: Support all 4096 VLANs
Date:   Sun, 20 Sep 2020 22:37:33 +0200
Message-Id: <20200920203733.409687-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is an off-by-one error in rtl8366rb_is_vlan_valid()
making VLANs 0..4094 valid while it should be 1..4095.
Fix it.

Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/rtl8366rb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index 1e79349922f4..1a49ea822b2e 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1345,7 +1345,7 @@ static bool rtl8366rb_is_vlan_valid(struct realtek_smi *smi, unsigned int vlan)
 	if (smi->vlan4k_enabled)
 		max = RTL8366RB_NUM_VIDS - 1;
 
-	if (vlan == 0 || vlan >= max)
+	if (vlan == 0 || vlan > max)
 		return false;
 
 	return true;
-- 
2.26.2

