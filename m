Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C045D2F0715
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 13:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbhAJMQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 07:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbhAJMQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 07:16:20 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111CAC0617A3;
        Sun, 10 Jan 2021 04:15:40 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id g15so10754642pgu.9;
        Sun, 10 Jan 2021 04:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iVUpnewCYxAmE3x0Y0aBU2Pf48lHqJK5gRlrTNmnLnw=;
        b=X03ytBtG1fgBmWRr0i9Y7/VHATIX3ymIHcmtUaQd+ObNkGfvlFja8/7VbQJbyTilQY
         QtKur3yHjvsIbQHGF4nhkjnihBRAJ4GhqF97E0Sgmu9II61ESzk7qeWByz6V3t93wDrx
         zkFvZdJ7vT23Kd1cPu+8Jo9BRI6waHtEAasImMPbChLey44H44LLYJVc3Y/NNPOvSANm
         eo15lPld4J1WmAJ9n9XADAGgYMM2ixtpy4lZ0GOOMBy7EuIP+sGZ86uUZ0QAEeDwfTok
         Llz9YXHEmfYmyE5Ai/7v9ZnkfMXEUtMh26AzZWK4Bj55XGUzaKObqfQ3Xls3RZhzZlKJ
         7skA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iVUpnewCYxAmE3x0Y0aBU2Pf48lHqJK5gRlrTNmnLnw=;
        b=cQB2y4K77V9saRdPPgMWKHi8LvIRvWyAsukvaZbmLo2gInylGmzfRyPHiXFKffCYqe
         rFzy+0KnV+qjFksvQdAO3u5A0HD52QiL83KxnskoebFPA2sAurAQ7ok9yi2qU8wTlfud
         c8acDVnjRo266rLMyjOPAqMC/8Je+LxEUb/Ix7QaL7xv/FekNWAtUx2ODzDgBZ7CbMdg
         EYGz+uJQ4kLc8OlTbB9uMy3j7IgNMSS6ywz++l35Y7EXju33L+xMHL/splcV8W0NUNky
         hyEHW7ORgPUuIgldrFl2RMOJIpW4QSnci/rB0JSFxnjdOzQOQyDGCw85wtuO2EIzRzPK
         h/vQ==
X-Gm-Message-State: AOAM533HZ9ZIFJEaNt4n3j+eNDPg8UsH0b7PSu7H+oVbqmFQYhphoBcJ
        fqDL4wPTz9HQtC9H9Q+wg4bSqM8k9A9+7l3q
X-Google-Smtp-Source: ABdhPJxUnAbYJooToG2g8hLQx/QHqJiwASfde63P/54nWB7MoIg3hAAwGqKEtMAUKUpHuxpNED4zCQ==
X-Received: by 2002:a63:545f:: with SMTP id e31mr15536593pgm.327.1610280939279;
        Sun, 10 Jan 2021 04:15:39 -0800 (PST)
Received: from localhost.localdomain ([2405:201:600d:a089:381d:ba42:3c3c:81ce])
        by smtp.googlemail.com with ESMTPSA id y5sm10959791pjt.42.2021.01.10.04.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 04:15:38 -0800 (PST)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        lukas.bulwahn@gmail.com, yashsri421@gmail.com
Subject: [PATCH 1/5] rtlwifi: rtl_pci: fix bool comparison in expressions
Date:   Sun, 10 Jan 2021 17:45:21 +0530
Message-Id: <20210110121525.2407-2-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210110121525.2407-1-yashsri421@gmail.com>
References: <3c121981-1468-fc9d-7813-483246066cc4@lwfinger.net>
 <20210110121525.2407-1-yashsri421@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are certain conditional expressions in rtl_pci, where a boolean
variable is compared with true/false, in forms such as (foo == true) or
(false != bar), which does not comply with checkpatch.pl (CHECK:
BOOL_COMPARISON), according to which boolean variables should be
themselves used in the condition, rather than comparing with true/false

E.g., in drivers/net/wireless/realtek/rtlwifi/ps.c,
"if (find_p2p_ie == true)" can be replaced with "if (find_p2p_ie)"

Replace all such expressions with the bool variables appropriately

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/ps.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
index f99882255d48..629c03271bde 100644
--- a/drivers/net/wireless/realtek/rtlwifi/ps.c
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
@@ -798,9 +798,9 @@ static void rtl_p2p_noa_ie(struct ieee80211_hw *hw, void *data,
 		ie += 3 + noa_len;
 	}
 
-	if (find_p2p_ie == true) {
+	if (find_p2p_ie) {
 		if ((p2pinfo->p2p_ps_mode > P2P_PS_NONE) &&
-		    (find_p2p_ps_ie == false))
+		    (!find_p2p_ps_ie))
 			rtl_p2p_ps_cmd(hw, P2P_PS_DISABLE);
 	}
 }
-- 
2.17.1

