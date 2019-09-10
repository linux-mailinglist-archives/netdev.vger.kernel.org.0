Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87EDBAF180
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 21:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfIJTEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 15:04:51 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43035 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfIJTEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 15:04:50 -0400
Received: by mail-wr1-f65.google.com with SMTP id q17so17088541wrx.10;
        Tue, 10 Sep 2019 12:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UT3cZkUDaUMQO15RjZED92gOIdZMcWWa8JAgUM0JUu8=;
        b=u5tU6pfDkSo0ZwR3/fc10W40t5OO+TAKHFgJExBhRMjkiIDvFu1p5n+FIBW5SXWZ7Y
         DuP9s0a3Q4DUxYZkxmWRBk/ywYIbpp71rDfgSx2avGoQE1ivtM2s+pzkti2klQtGnQin
         Yb2Al1ewWW5NvyY3OakJTX9a4wd60i1PKtC2XFQuWxcxIOswoJT6S7rH+r/h3ueQ4/2g
         Al9cUbLZV/pTHZph3LBNvWpy5sw3lQ8XaaVBQPcTNBgrHcHJt1+3BqtZ0X2JMaD1AfWq
         wuExovsAp2GhEmHOH5K+T63x/mLewMikdrIt/Q+gKYluPxU8x8Wz6b1N9vLRnoCp6tzv
         7l6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UT3cZkUDaUMQO15RjZED92gOIdZMcWWa8JAgUM0JUu8=;
        b=hT96GqJTop7fKCjR/NpJIkDJ+gLcpL2rtYG0DgvDUXDtwo+0IElBYoG1MeRBrTTe4j
         acYa37ydenP1u3KaYe/s5cTgX0XGDf4cU7jsFJvFhyCScTi2xHru7lWyuY/DjmOoQZfn
         j1o3+4g5EoO8c/XuXemeqz2xwkFI4IqibTkUO77Qmu+ERXMrs+dvIaH55pN//+5dPTcD
         yIBRO+HPvEhlveHg2r7oy9hrrbykm62lUydAKDvoZN+517OQJFfkQwKlLHsHXZVwgUHt
         Z+1t4/keqqat9Hr7ry244NLTYQWqjdx7WvHgNWNehfhoJ/6YBp2IOaOAo/c0+ifQbU2S
         42aA==
X-Gm-Message-State: APjAAAVg/6MfZWQ7xJk/MLwd/wZpHnVm0FPkqTKygMmMH1/EUGSh9sRM
        0c1ZbAU3uBNCAjEMmudVIlA=
X-Google-Smtp-Source: APXvYqxlviCnO+SbPkCGDeqka+rPMo8komwQkshIeYyhRhVESQhn55xLg4AZb+E1ru13fHmpRyy9Qw==
X-Received: by 2002:a5d:4c92:: with SMTP id z18mr13990913wrs.111.1568142287717;
        Tue, 10 Sep 2019 12:04:47 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8108:96bf:e0ab:2b68:5d76:a12a:e6ba])
        by smtp.gmail.com with ESMTPSA id w15sm14222967wru.53.2019.09.10.12.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 12:04:47 -0700 (PDT)
From:   Michael Straube <straube.linux@gmail.com>
To:     kvalo@codeaurora.org
Cc:     pkshih@realtek.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Straube <straube.linux@gmail.com>
Subject: [PATCH 1/3] rtlwifi: rtl8192ce: replace _rtl92c_evm_db_to_percentage with generic version
Date:   Tue, 10 Sep 2019 21:04:20 +0200
Message-Id: <20190910190422.63378-2-straube.linux@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190910190422.63378-1-straube.linux@gmail.com>
References: <20190910190422.63378-1-straube.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function _rtl92c_evm_db_to_percentage is functionally identical
to the generic version rtl_evm_db_to_percentage, so remove
_rtl92c_evm_db_to_percentage and use the generic version instead.

Signed-off-by: Michael Straube <straube.linux@gmail.com>
---
 .../wireless/realtek/rtlwifi/rtl8192ce/trx.c  | 23 +------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
index 123dbf0903a1..fc9a3aae047f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
@@ -33,27 +33,6 @@ static u8 _rtl92c_query_rxpwrpercentage(s8 antpower)
 		return 100 + antpower;
 }
 
-static u8 _rtl92c_evm_db_to_percentage(s8 value)
-{
-	s8 ret_val;
-
-	ret_val = value;
-
-	if (ret_val >= 0)
-		ret_val = 0;
-
-	if (ret_val <= -33)
-		ret_val = -33;
-
-	ret_val = 0 - ret_val;
-	ret_val *= 3;
-
-	if (ret_val == 99)
-		ret_val = 100;
-
-	return ret_val;
-}
-
 static long _rtl92ce_signal_scale_mapping(struct ieee80211_hw *hw,
 		long currsig)
 {
@@ -243,7 +222,7 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 			max_spatial_stream = 1;
 
 		for (i = 0; i < max_spatial_stream; i++) {
-			evm = _rtl92c_evm_db_to_percentage(p_drvinfo->rxevm[i]);
+			evm = rtl_evm_db_to_percentage(p_drvinfo->rxevm[i]);
 
 			if (packet_match_bssid) {
 				/* Fill value in RFD, Get the first
-- 
2.23.0

