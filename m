Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58772EA8A4
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 11:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbhAEK21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 05:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728070AbhAEK20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 05:28:26 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D9EC061794;
        Tue,  5 Jan 2021 02:27:46 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id q1so28137193ilt.6;
        Tue, 05 Jan 2021 02:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=06leFnGIwZWTXa+9aYwJRfo3DhaEXdzqEroBMYOjBd0=;
        b=aV6Ifn8nUdMOFZVbPeCtaLLo1n3NMKzV13YxYcALQ9yNnh63ZGBcz0yrsuMVbqdGN+
         ESDInYfpGrzjGvaWjmLXxWJicgeb84Etua5GAKGnx6U23u2fhmzOrXO9PpX13dRUD+tV
         An8sFeiUG4LWRRZR1UkXtFPmKb6oc9G+eq5/aRzhuqJNDzDt3FoZfQgPmkebU5dadCk2
         X9pCDLP5oYX06OZeTG0uaBjSG/iPaFyxTOAPlbDZZmhja+AM5t4nAxhl0Z/lwqqFOYzG
         KaUFG/KoUpVZdVcyU+jw2+RrS3MQkwJtsba0VfDrfYoAypeuQufhG9r4Ar/W01gjEO62
         HHkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=06leFnGIwZWTXa+9aYwJRfo3DhaEXdzqEroBMYOjBd0=;
        b=aIx6vGNJoHj/5wK0i8dwbDhlzRb0ebNPuEnGvfd1FX9d1RsM2OgLjl3koI7rnTV7FA
         vOmLGgZSXKy5rvRi6xsK6K9zVJy85FBi0oSNdWdYHWLFOB5UpSx549ZpoVLxm1xaid1A
         UuNn19A0omytNvAzlMBdWgRKsm87WG0eWx6Kk3U0BB5OkCwEnpFArZnjIfDBg+fh74Pa
         ede9RuoeyStisNxLgktNzDFNRh2WMuA5MEDLdJPjOOHPGFtVOhbLc4/qjyc67YGuj+J2
         Skr8/BBg4mM24nhyCP9TPiu69h6bZv5CTp5NvstdpSUZ+jOdBVS3NHe9qlNlJYMOQwA1
         xTkg==
X-Gm-Message-State: AOAM531igK8Mu1b+VnYJm1cQvT+2pU/9ya9NV/dtpFSYhecBUH821ojK
        BrW1sp4IacsYB40z7hTE70E=
X-Google-Smtp-Source: ABdhPJwR+m757T7Pq5kNO9i+0WLiQmzubbeAflBMnJdCJtnXAFx/wxlIZe27CtSZ/Vq0JjUvouFIEQ==
X-Received: by 2002:a92:d44e:: with SMTP id r14mr74244168ilm.83.1609842465881;
        Tue, 05 Jan 2021 02:27:45 -0800 (PST)
Received: from localhost.localdomain ([156.146.37.136])
        by smtp.gmail.com with ESMTPSA id p18sm43514830ile.27.2021.01.05.02.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 02:27:45 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, christophe.jaillet@wanadoo.fr,
        Larry.Finger@lwfinger.net, baijiaju1990@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] drivers: wireless: rtlwifi: rtl8192ce: Fix construction of word rtl8192ce/trx.c
Date:   Tue,  5 Jan 2021 15:57:51 +0530
Message-Id: <20210105102751.21237-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/defautly/de-faulty/p

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
index 4165175cf5c0..d53397e7eb2e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
@@ -671,7 +671,7 @@ bool rtl92ce_is_tx_desc_closed(struct ieee80211_hw *hw,
 	u8 own = (u8)rtl92ce_get_desc(hw, entry, true, HW_DESC_OWN);

 	/*beacon packet will only use the first
-	 *descriptor defautly,and the own may not
+	 *descriptor de-faulty,and the own may not
 	 *be cleared by the hardware
 	 */
 	if (own)
--
2.26.2

