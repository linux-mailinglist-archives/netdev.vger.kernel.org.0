Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C50D4576AB
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 19:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbhKSSup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 13:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbhKSSup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 13:50:45 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B83EC061574;
        Fri, 19 Nov 2021 10:47:43 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id x7so8629039pjn.0;
        Fri, 19 Nov 2021 10:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fCBSzU46G4SS0iEFmAqgHj4QLejQ8PNHbA3f1NrvDA0=;
        b=GQ57N/3DijEsK5fCwI4i1tyrM726LEfvBBnbeDmzMJ9bD0WCZCKX5RWUhV9xXEOXMo
         +lX2el/D8m36zDQ/1KhxMdIm1ksh+bfc9c6Q8MV9t/vKWsPjaNc+eV8ePKz9cmQovR6N
         VsF3KuWdE9J8jq5j8wrCkEKmVf4fiFfNjnu84Yb7g5JXswCWyev3ERQ8zoqvUwdoVzJP
         215mVCE2d7RByhxMmdQsw1QoWIMYxjAXoTgZjtfVYP623paq+GZChLVbNguxPf4GfD2x
         QY1gLYuUk2nVr7QYkaBT7IX/J8lOScHUvef5kwoWxYgEcvI2BF6Xeu4q6J/c7oSOX8fh
         76CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fCBSzU46G4SS0iEFmAqgHj4QLejQ8PNHbA3f1NrvDA0=;
        b=lElitO0inznyY0t4kLzZgCGVSGtOOYyaX/9IS9nHXD2NEVntts9Bhpczwd4TBNNsC3
         287dFfr3WBSVxWi1OrnovpHc+2tfZPq0O6lQj7eRrz0ZPFVWh4T8Nw94Y07Xbd1V1gNQ
         WxJmfHe0D5MhXAsfsFqrlfU3BAS9tSRDpDYDo28a7LvcKipNdCdRJ82pENeunVuGp5C3
         upMlTa2CR7bH4FHrQmvZZ9yJ8EpBV6E7y7S2ZNBVAAFQe6DUk3sGbOLQchhefHfONlUh
         NLkawtPP/OVzRIBdO7AjfQf/LSUwIzf/ODN1Tj7wkBQWfX+X8H/nvUGEQhRIexlQgPde
         GBPg==
X-Gm-Message-State: AOAM531Cnfl36e9EO2XgDX/C86ipkNP+NfFL8k75Aj7w81WbTCQpTnRc
        S+x6LCFYcRv2sFolbjtps/LihxtgjLoWjf1E
X-Google-Smtp-Source: ABdhPJy3D6EzBlZCmfxm7POLFPCwwy6Y4TCVha2tfPlgiuEXFZwBiYZ9cHuPwEYQL/qVIOxa6MowGw==
X-Received: by 2002:a17:90a:134f:: with SMTP id y15mr2194193pjf.158.1637347662840;
        Fri, 19 Nov 2021 10:47:42 -0800 (PST)
Received: from localhost.localdomain ([115.27.208.93])
        by smtp.gmail.com with ESMTPSA id q18sm383860pfj.46.2021.11.19.10.47.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Nov 2021 10:47:42 -0800 (PST)
From:   Yeqi Fu <fufuyqqqqqq@gmail.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yeqi Fu <fufuyqqqqqq@gmail.com>
Subject: [PATCH] r8169: Apply configurations to the L0s/L1 entry delay of RTL8105e and RTL8401
Date:   Sat, 20 Nov 2021 02:47:09 +0800
Message-Id: <20211119184709.19209-1-fufuyqqqqqq@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We properly configure the L0s/L1 entry delay in the startup functions of
RTL8105e and RTL8401 through rtl_set_def_aspm_entry_latency(), which will
avoid local denial of service.

Signed-off-by: Yeqi Fu <fufuyqqqqqq@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index bbe21db20417..4f533007a456 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3420,6 +3420,7 @@ static void rtl_hw_start_8401(struct rtl8169_private *tp)
 		{ 0x07,	0xffff, 0x8e68 },
 	};
 
+	rtl_set_def_aspm_entry_latency(tp);
 	rtl_ephy_init(tp, e_info_8401);
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Beacon_en);
 }
@@ -3437,6 +3438,7 @@ static void rtl_hw_start_8105e_1(struct rtl8169_private *tp)
 		{ 0x0a,	0, 0x0020 }
 	};
 
+	rtl_set_def_aspm_entry_latency(tp);
 	/* Force LAN exit from ASPM if Rx/Tx are not idle */
 	RTL_W32(tp, FuncEvent, RTL_R32(tp, FuncEvent) | 0x002800);
 
-- 
2.30.1 (Apple Git-130)

