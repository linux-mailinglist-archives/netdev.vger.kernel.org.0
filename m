Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6273D2F071D
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 13:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbhAJMQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 07:16:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbhAJMQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 07:16:43 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CA6C0617A6;
        Sun, 10 Jan 2021 04:15:52 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id n7so10784863pgg.2;
        Sun, 10 Jan 2021 04:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YTc1II9ACj1oYqqot33qA4ayP2h78MhFEqKnLEwd3cg=;
        b=lXlNqKSB1WT/06xJmknbydbtn2KROIF2e+XrhojUPkwwXA95s5qNeAjiMvf6EFlNtU
         doaXT8YzHMJ8VPtoN/VE2eTLvx3nqNfou5cnpvekM/BQlr9Ys6cLi6J5Jokqq3NL9lsd
         uXhygadpsGlzxXbsOg23Rz8ygs5t9F+I9TBOaOxkRzV36M2qukJqtCYr3nF6sQg9x9Qn
         ACVBKxuCoeEOdDkLF7yp4JRSNsr2w+Pc0M3ta2VehMbIcnu2b5duS7on/ReNn+qFmzuC
         UtWX0Klp42c3t45FsFHCTI1yJtJusT5m3M57SIrPizFM2DzadEdnrNKFhPNWU3dBe5p9
         OIzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YTc1II9ACj1oYqqot33qA4ayP2h78MhFEqKnLEwd3cg=;
        b=W+zZGb2whO9gmcvH97aPWk4BYPeohdoslfW98n5dWum1DtZ9DAJoemjYk87MIgFpY9
         cN7L1f/uP4DyEsEZZvimgzgzR3Wg4L/WnIpUtBs75rrXosDlqNo8KS4iExFegLkYPOfm
         uwoZMC64cDiVzTC0kRkQx7MLNm+opgcLBqfXexgOsrsie/QEqJ/yib6RpaaO3DDLBAmb
         newcr2WF+JPK2nIChVmVYl6XjDRxni54BtK8jbBFRjeyr82jyzbORm7YeunlkqYVqahl
         zLJxtQErUBpV86LF9DzsyJYiwUFsXkzjUky38C58L7vuLgyez7H6VWFk3Sjy9goQ99vY
         GK4w==
X-Gm-Message-State: AOAM5328yMj0ckvUcqnuizfWgsvzLxOUx6Q3aZSSYqwoibV6lTJacSXZ
        OdX6rsh4YfgS2t1zCOT74T1E3HJrjfTbsQ==
X-Google-Smtp-Source: ABdhPJyweUMzxtoGdLkP4eQrEr3IkevhAfKwZ7liWN3FD2t4BNbzorjUd4KIR2CEX4FkHGgx4/b3dw==
X-Received: by 2002:aa7:970f:0:b029:19e:758b:dab1 with SMTP id a15-20020aa7970f0000b029019e758bdab1mr15239229pfg.24.1610280951963;
        Sun, 10 Jan 2021 04:15:51 -0800 (PST)
Received: from localhost.localdomain ([2405:201:600d:a089:381d:ba42:3c3c:81ce])
        by smtp.googlemail.com with ESMTPSA id y5sm10959791pjt.42.2021.01.10.04.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 04:15:51 -0800 (PST)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        lukas.bulwahn@gmail.com, yashsri421@gmail.com
Subject: [PATCH 4/5] rtlwifi: rtl8192se: fix bool comparison in expressions
Date:   Sun, 10 Jan 2021 17:45:24 +0530
Message-Id: <20210110121525.2407-5-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210110121525.2407-1-yashsri421@gmail.com>
References: <3c121981-1468-fc9d-7813-483246066cc4@lwfinger.net>
 <20210110121525.2407-1-yashsri421@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are certain conditional expressions in rtl8192se, where a boolean
variable is compared with true/false, in forms such as (foo == true) or
(false != bar), which does not comply with checkpatch.pl (CHECK:
BOOL_COMPARISON), according to which boolean variables should be
themselves used in the condition, rather than comparing with true/false

Replace all such expressions with the bool variables appropriately

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
index 47fabce5c235..73a5d8a068fc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
@@ -458,7 +458,7 @@ static u8 _rtl92se_halset_sysclk(struct ieee80211_hw *hw, u8 data)
 	tmpvalue = rtl_read_byte(rtlpriv, SYS_CLKR + 1);
 	bresult = ((tmpvalue & BIT(7)) == (data & BIT(7)));
 
-	if ((data & (BIT(6) | BIT(7))) == false) {
+	if (!(data & (BIT(6) | BIT(7)))) {
 		waitcount = 100;
 		tmpvalue = 0;
 
@@ -1268,7 +1268,7 @@ static u8 _rtl92s_set_sysclk(struct ieee80211_hw *hw, u8 data)
 	tmp = rtl_read_byte(rtlpriv, SYS_CLKR + 1);
 	result = ((tmp & BIT(7)) == (data & BIT(7)));
 
-	if ((data & (BIT(6) | BIT(7))) == false) {
+	if (!(data & (BIT(6) | BIT(7)))) {
 		waitcnt = 100;
 		tmp = 0;
 
-- 
2.17.1

