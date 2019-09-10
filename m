Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE2BAAF183
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 21:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfIJTFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 15:05:03 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54010 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfIJTEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 15:04:50 -0400
Received: by mail-wm1-f66.google.com with SMTP id q18so739541wmq.3;
        Tue, 10 Sep 2019 12:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W7KZxJZQlQBh9qnOabi1zRfPdYNbJhcPoRClNUhd8jY=;
        b=FJVHb2NZueail+Sas4/1tsvyii4MpaEovCO5yMLNJDxV0oy/DSda1+elsLz8VTRXOd
         +VpT+7IVXI99PWwQ1mBMY+IDhGhWTF6ffQPRb08yq1tejZhZs35Pp7fKgzYB9u2BhMLL
         q5Y1D6AylWIiupK0UB3jl9FAOSilaYKCfTxMCCkme40uf3J6QYcngfyOZkkePNIkg5vb
         mnl61ktMsCCSQS0mf91vyXAzN2UNbreJXxYxOHwjbdQWQ0fsdoIZZT8dHnZFoeo/jWV2
         4wy5dodQ+AOIZiBdh/Q34Ezi31rZs3dcb+Ox717z9Wke8uffBknEmkl17crM6+BUB9nj
         nF4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W7KZxJZQlQBh9qnOabi1zRfPdYNbJhcPoRClNUhd8jY=;
        b=hLICGXfOQ44vGk5+cKqW6o7+19e6vIvxaOG19cVKC6mbqvsn+Da4OG2wfptgzNIoqV
         y4m3BSPR9U1Vx/HgILrl7dCzyRCDPdoKD19/4zdiDIMXlMS/m6kfm1Uo2B2fdoovWsY6
         6CJcWCL+plPcFrSUyVO0LRuPH7y9307IcEKi3SbmVy5q0X0zzeIKXDiYdaQ6iR3LHsKU
         I9aKbVCm3/FjmijYxxeSPBVNN4rLrJJ3e5G8xCry9cPxyPrbq8IgoFY8arNRXkiO39ew
         wGfuq8/q9iJOOmlSKegE6G49+g35oUfHU/EMDeu6QhVs5Sg3lz+RX+d6U0j/6qMcBXaY
         z+cA==
X-Gm-Message-State: APjAAAVPLrzCKOpJx/xJIwHzPss3eN9vCG4fiZijorhhXmxnfuOCyVWS
        Pf7SjCzJCNXX9nf2m3jMlQYXUD5B
X-Google-Smtp-Source: APXvYqyeENK4P7Ci6k2N7GMiNOei3vR442TkIvBoab5dWf/sjrnbLuCJvCDTag9VJV9NaH1UbPZdfw==
X-Received: by 2002:a7b:c34e:: with SMTP id l14mr781443wmj.105.1568142288517;
        Tue, 10 Sep 2019 12:04:48 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8108:96bf:e0ab:2b68:5d76:a12a:e6ba])
        by smtp.gmail.com with ESMTPSA id w15sm14222967wru.53.2019.09.10.12.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 12:04:48 -0700 (PDT)
From:   Michael Straube <straube.linux@gmail.com>
To:     kvalo@codeaurora.org
Cc:     pkshih@realtek.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Straube <straube.linux@gmail.com>
Subject: [PATCH 2/3] rtlwifi: rtl8192cu: replace _rtl92c_evm_db_to_percentage with generic version
Date:   Tue, 10 Sep 2019 21:04:21 +0200
Message-Id: <20190910190422.63378-3-straube.linux@gmail.com>
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
 .../wireless/realtek/rtlwifi/rtl8192cu/mac.c   | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
index c8daad1e749f..cec19b32c7e2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
@@ -577,22 +577,6 @@ static u8 _rtl92c_query_rxpwrpercentage(s8 antpower)
 		return 100 + antpower;
 }
 
-static u8 _rtl92c_evm_db_to_percentage(s8 value)
-{
-	s8 ret_val;
-
-	ret_val = value;
-	if (ret_val >= 0)
-		ret_val = 0;
-	if (ret_val <= -33)
-		ret_val = -33;
-	ret_val = 0 - ret_val;
-	ret_val *= 3;
-	if (ret_val == 99)
-		ret_val = 100;
-	return ret_val;
-}
-
 static long _rtl92c_signal_scale_mapping(struct ieee80211_hw *hw,
 		long currsig)
 {
@@ -743,7 +727,7 @@ static void _rtl92c_query_rxphystatus(struct ieee80211_hw *hw,
 		else
 			max_spatial_stream = 1;
 		for (i = 0; i < max_spatial_stream; i++) {
-			evm = _rtl92c_evm_db_to_percentage(p_drvinfo->rxevm[i]);
+			evm = rtl_evm_db_to_percentage(p_drvinfo->rxevm[i]);
 			if (packet_match_bssid) {
 				if (i == 0)
 					pstats->signalquality =
-- 
2.23.0

