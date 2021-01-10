Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67C22F0717
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 13:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbhAJMQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 07:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbhAJMQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 07:16:24 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A6EC0617A4;
        Sun, 10 Jan 2021 04:15:43 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id b5so8770063pjl.0;
        Sun, 10 Jan 2021 04:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5LcHk/djoLn7Im0a8MC7BPIVlKvUBpW71T7HTSyZtvM=;
        b=O5lBJIX0RFEgUKCa4t1sN8losvZrAe0svC+/OhDjliPS8GDWh0SK+NxKA1nHNgw7GV
         MkaDqSjl7Nrq3/VXDkvMpj+UR4SPzM/HVpi4frbEsORChfqqe7CcNv08IqCFM2Lqa08b
         Wy/rXmnKrUCHzLFuiMhxQOmTmtQ02wcH0SJ6jY2ODICPUO5VMHs35TFLrAGFinhO52Yz
         hqjnmx1IxQZTzYBmP5qKXEUTqQsnPTzCQrgqrvMRuev0i0d4SONiD2SZOvI+QKRa4WK/
         quIMQxZc7Wyw1aW23CSbjN7SZHSKkMPuNzgpykUV6uDwW3c0l4K8umhppJzO9xJP2u8l
         0dFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5LcHk/djoLn7Im0a8MC7BPIVlKvUBpW71T7HTSyZtvM=;
        b=ObuQNDUYGHh4tLJ/lSNU5WzeFbkMtfhdjuWfkzMXkGSzOM6FzV7S1KQDr8i6w4sdwd
         hhj1HnFvjjyHW3/IegCZvDejZBFnBpi3hOFFSTwR4N0Ny4efStH7gWduUeoR8ngy3Plp
         XT5qoH19neZZeZk16pIRc4c7KBl7NIbtItLYWruIhLrIAJxR3whBISxVV7zmmdqFRhxN
         64x/YXdvep+ZL0xynCR3oLvWxqh6cdRSy1ByfTOKGourZAw3a3lfrqbkLGETRVty2cU1
         LgE56n3yAKzWhGqu7tWeKkBwAv7SkEP2P2wPeACdQSkvK9IWae2pWVHm9NNgDWXVa2gH
         NMpg==
X-Gm-Message-State: AOAM530tu2yNym//wmjDP991I/XdkBz3MNzuKAi8V7tT9OZgNNkAxQOb
        GL/BOeijFuHEYvzc2BjznAczHaHl1nRHkQ==
X-Google-Smtp-Source: ABdhPJwVYC4QdGdeR1/vy2XXXA0K3dfT+pmaaaNTppDHriuZEvmh0dN/3EyUcnvG7B6qLZwxtQwAlg==
X-Received: by 2002:a17:90a:c20b:: with SMTP id e11mr12570465pjt.43.1610280943229;
        Sun, 10 Jan 2021 04:15:43 -0800 (PST)
Received: from localhost.localdomain ([2405:201:600d:a089:381d:ba42:3c3c:81ce])
        by smtp.googlemail.com with ESMTPSA id y5sm10959791pjt.42.2021.01.10.04.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 04:15:42 -0800 (PST)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        lukas.bulwahn@gmail.com, yashsri421@gmail.com
Subject: [PATCH 2/5] rtlwifi: rtl8192c-common: fix bool comparison in expressions
Date:   Sun, 10 Jan 2021 17:45:22 +0530
Message-Id: <20210110121525.2407-3-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210110121525.2407-1-yashsri421@gmail.com>
References: <3c121981-1468-fc9d-7813-483246066cc4@lwfinger.net>
 <20210110121525.2407-1-yashsri421@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are certain conditional expressions in rtl8192c-common, where a
boolean variable is compared with true/false, in forms such as
(foo == true) or (false != bar), which does not comply with checkpatch.pl
(CHECK: BOOL_COMPARISON), according to which boolean variables should be
themselves used in the condition, rather than comparing with true/false

E.g., in drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c,
"else if (initialized == false) {" can be replaced with
"else if (!initialized) {"

Replace all such expressions with the bool variables appropriately

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
index 265a1a336304..0b6a15c2e5cc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
@@ -380,7 +380,7 @@ static void rtl92c_dm_initial_gain_multi_sta(struct ieee80211_hw *hw)
 		initialized = false;
 		dm_digtable->dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
 		return;
-	} else if (initialized == false) {
+	} else if (!initialized) {
 		initialized = true;
 		dm_digtable->dig_ext_port_stage = DIG_EXT_PORT_STAGE_0;
 		dm_digtable->cur_igvalue = 0x20;
@@ -509,7 +509,7 @@ static void rtl92c_dm_dig(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
-	if (rtlpriv->dm.dm_initialgain_enable == false)
+	if (!rtlpriv->dm.dm_initialgain_enable)
 		return;
 	if (!(rtlpriv->dm.dm_flag & DYNAMIC_FUNC_DIG))
 		return;
-- 
2.17.1

